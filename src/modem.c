/* Hayes command interpreter and nonblocking outgoing TCP transport.
 * This is a QDOS device bridge, not a bit-level ZX8302/8049 serial model.
 * DNS runs on a detached worker; only its result is shared under a lock.
 * TCP connect/read/write and command processing remain on the emulator thread.
 */
#define _POSIX_C_SOURCE 200809L
#include "modem.h"
#include "ql.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
typedef SOCKET Socket;
#define INVALID_SOCK INVALID_SOCKET
#define socket_close closesocket
#else
#include <sys/socket.h>
#include <sys/select.h>
#include <netdb.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
typedef int Socket;
#define INVALID_SOCK (-1)
#define socket_close close
#endif
#define CAP 65536u
#define MODEM_HANDLE 0xc0000001u
#define NC (-1)
#define BP (-15)
#define NI (-19)
typedef struct {
    unsigned char bytes[CAP];
    unsigned head, count;
} Queue;
typedef struct {
    char host[256], service[6];
    struct addrinfo *addresses;
    int done, error;
#ifdef _WIN32
    CRITICAL_SECTION lock;
#else
    pthread_mutex_t lock;
#endif
} Lookup;
static struct {
    unsigned port, opened, echo, verbose, quiet, guard, pluses;
    int telnet, online, connecting, dialing, overflow, cancelled, swallow_lf;
    Socket socket;
    Lookup *lookup;
    struct addrinfo *addresses, *next;
    uint64_t deadline, last_tx, plus_time;
    char line[512];
    unsigned length;
    Queue rx, tx;
    unsigned tel_state, tel_cmd, sublen, rx_cr, tx_cr;
    unsigned char sub[128], local[256], remote[256];
} m = {.socket = INVALID_SOCK};

/* Monotonic host time: network timeout and escape guards do not accelerate
 * with the guest CPU multiplier or an unpaced headless run. */
/** milliseconds: Read the monotonic host clock in milliseconds for dial and escape timing. */
static uint64_t milliseconds(void) {
#ifdef _WIN32
    return GetTickCount64();
#else
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000 + (unsigned)t.tv_nsec / 1000000;
#endif
}
/* Queue helpers preserve binary bytes and never overwrite unread data. */
/** push: Append one byte to a bounded ring; return false when it is full. */
static int push(Queue *q, unsigned c) {
    if (q->count == CAP)
        return 0;
    q->bytes[(q->head + q->count++) % CAP] = (unsigned char)c;
    return 1;
}
/** pop: Remove one byte from a ring, or return -1 when empty. */
static int pop(Queue *q) {
    int c;
    if (!q->count)
        return -1;
    c = q->bytes[q->head];
    q->head = (q->head + 1) % CAP;
    q->count--;
    return c;
}
/** text: Enqueue modem response text into the guest receive queue. */
static void text(const char *s) {
    while (*s)
        push(&m.rx, (unsigned char)*s++);
}
/* Hayes numeric results: OK=0, CONNECT=1, NO CARRIER=3, ERROR=4, BUSY=7. */
/** result: Emit a Hayes result using the current quiet/numeric/text settings. */
static void result(unsigned code) {
    static const char *words[] = {"OK", "CONNECT", "RING", "NO CARRIER", "ERROR", "", "", "BUSY"};
    char number[16];
    if (m.quiet)
        return;
    if (m.verbose) {
        text("\r\n");
        text(words[code]);
        text("\r\n");
    } else {
        snprintf(number, sizeof(number), "%u\r", code);
        text(number);
    }
}
/* The detached resolver owns the task until done is published under its lock.
 * Cancellation never frees a task while getaddrinfo is still using it. */
/** lock_lookup: Acquire the platform lock protecting a resolver task result. */
static void lock_lookup(Lookup *q) {
#ifdef _WIN32
    EnterCriticalSection(&q->lock);
#else
    pthread_mutex_lock(&q->lock);
#endif
}
/** unlock_lookup: Release the resolver task lock. */
static void unlock_lookup(Lookup *q) {
#ifdef _WIN32
    LeaveCriticalSection(&q->lock);
#else
    pthread_mutex_unlock(&q->lock);
#endif
}
/* resolve_host: Resolve the immutable destination on a worker and publish addresses/error under its lock. */
#ifdef _WIN32
static DWORD WINAPI resolve_host(void *arg)
#else
static void *resolve_host(void *arg)
#endif
{
    Lookup *q = arg;
    struct addrinfo hints, *addresses = NULL;
    int error;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    error = getaddrinfo(q->host, q->service, &hints, &addresses);
    lock_lookup(q);
    q->addresses = addresses;
    q->error = error;
    q->done = 1;
    unlock_lookup(q);
    return 0;
}
/** free_lookup: Destroy the lock and free a completed resolver task after the worker has published completion. */
static void free_lookup(Lookup *q) {
#ifdef _WIN32
    DeleteCriticalSection(&q->lock);
#else
    pthread_mutex_destroy(&q->lock);
#endif
    free(q);
}
/* Release TCP state. A pending DNS job is marked cancelled and reaped later. */
/** hangup: Close TCP and release address candidates; cancel, but do not prematurely free, any DNS task. */
static void hangup(void) {
    if (m.socket != INVALID_SOCK)
        socket_close(m.socket);
    m.socket = INVALID_SOCK;
    if (m.addresses)
        freeaddrinfo(m.addresses);
    m.addresses = m.next = NULL;
    m.cancelled = 1;
    m.dialing = m.connecting = m.online = 0;
    m.pluses = 0;
    m.tx.head = m.tx.count = 0;
}
/** would_block: Recognize platform socket errors that mean an operation may be retried later. */
static int would_block(void) {
#ifdef _WIN32
    int e = WSAGetLastError();
    return e == WSAEWOULDBLOCK || e == WSAEINPROGRESS;
#else
    return errno == EAGAIN || errno == EWOULDBLOCK || errno == EINPROGRESS || errno == EINTR;
#endif
}
/* Connected sockets remain nonblocking; no guest request waits on a host send. */
/** connected: Enter online data mode, reset Telnet state and report CONNECT. */
static void connected(void) {
    m.connecting = m.dialing = 0;
    m.online = 1;
    m.last_tx = milliseconds();
    m.tel_state = m.sublen = m.rx_cr = m.tx_cr = 0;
    memset(m.local, 0, sizeof(m.local));
    memset(m.remote, 0, sizeof(m.remote));
    if (m.addresses)
        freeaddrinfo(m.addresses);
    m.addresses = m.next = NULL;
    result(1);
}
/* Try each resolved address without blocking; IPv4 and IPv6 share the path. */
/** next_address: Try resolved addresses with nonblocking sockets, retaining a pending connect or reporting NO CARRIER. */
static void next_address(void) {
    while (m.next) {
        struct addrinfo *a = m.next;
        int rc;
        m.next = a->ai_next;
        if (m.socket != INVALID_SOCK)
            socket_close(m.socket);
        m.socket = socket(a->ai_family, a->ai_socktype, a->ai_protocol);
        if (m.socket == INVALID_SOCK)
            continue;
#ifdef _WIN32
        {
            u_long yes = 1;
            if (ioctlsocket(m.socket, FIONBIO, &yes))
                continue;
        }
#else
        if (fcntl(m.socket, F_SETFL, O_NONBLOCK) < 0)
            continue;
#ifdef SO_NOSIGPIPE
        {
            int yes = 1;
            setsockopt(m.socket, SOL_SOCKET, SO_NOSIGPIPE, &yes, sizeof(yes));
        }
#endif
#endif
        rc = connect(m.socket, a->ai_addr, (int)a->ai_addrlen);
        if (!rc) {
            connected();
            return;
        }
        if (would_block()) {
            m.connecting = 1;
            return;
        }
    }
    hangup();
    result(3);
}
/* Parse host[:port] or [IPv6][:port], with port 23 as the Telnet default. */
/** destination: Validate host[:port] or bracketed IPv6[:port] and default the service to TCP port 23. */
static int destination(const char *s, Lookup *q) {
    const char *end, *port = NULL;
    size_t n;
    unsigned long value;
    char *tail;
    while (*s == ' ')
        s++;
    if (*s == '[') {
        end = strchr(++s, ']');
        if (!end)
            return 0;
        if (end[1]) {
            if (end[1] != ':')
                return 0;
            port = end + 2;
        }
    } else {
        end = strchr(s, ':');
        if (end) {
            if (strchr(end + 1, ':'))
                return 0;
            port = end + 1;
        } else
            end = s + strlen(s);
    }
    n = (size_t)(end - s);
    if (!n || n >= sizeof(q->host))
        return 0;
    memcpy(q->host, s, n);
    q->host[n] = 0;
    for (n = 0; q->host[n]; n++)
        if (isspace((unsigned char)q->host[n]) || q->host[n] == '/' || q->host[n] == ';')
            return 0;
    value = 23;
    if (port) {
        if (!isdigit((unsigned char)*port))
            return 0;
        value = strtoul(port, &tail, 10);
        if (*tail || !value || value > 65535)
            return 0;
    }
    snprintf(q->service, sizeof(q->service), "%lu", value);
    return 1;
}
/* Start asynchronous DNS, retaining at most one outstanding lookup. */
/** dial: Start one asynchronous resolver task and the 30-second outgoing-dial timeout. */
static void dial(const char *address) {
    Lookup *q;
    if (m.socket != INVALID_SOCK || m.lookup) {
        result(7);
        return;
    }
    q = calloc(1, sizeof(*q));
    if (!q) {
        result(4);
        return;
    }
    if (!destination(address, q)) {
        free(q);
        result(4);
        return;
    }
#ifdef _WIN32
    InitializeCriticalSection(&q->lock);
    {
        HANDLE thread = CreateThread(NULL, 0, resolve_host, q, 0, NULL);
        if (!thread) {
            free_lookup(q);
            result(4);
            return;
        }
        CloseHandle(thread);
    }
#else
    {
        pthread_t thread;
        if (pthread_mutex_init(&q->lock, NULL)) {
            free(q);
            result(4);
            return;
        }
        if (pthread_create(&thread, NULL, resolve_host, q)) {
            free_lookup(q);
            result(4);
            return;
        }
        pthread_detach(thread);
    }
#endif
    m.lookup = q;
    m.cancelled = 0;
    m.dialing = 1;
    m.deadline = milliseconds() + 30000;
}
/* Factory defaults only describe this implemented subset, not an imaginary
 * hardware modem: E1 Q0 V1, S12=50 (one-second guard). */
/** defaults: Restore E1/Q0/V1 and the one-second S12 escape guard. */
static void defaults(void) {
    m.echo = m.verbose = 1;
    m.quiet = 0;
    m.guard = 50;
}
/** parameter: Parse an optional decimal command parameter with a bounded accumulator. */
static unsigned parameter(const char **p, unsigned fallback) {
    unsigned n = 0;
    if (!isdigit((unsigned char)**p))
        return fallback;
    while (isdigit((unsigned char)**p)) {
        if (n > 65535)
            return 999999;
        n = n * 10 + (unsigned)(*(*p)++ - '0');
    }
    return n;
}
/* Execute one bounded AT line. Unsupported commands produce ERROR, rather
 * than pretending to implement modem features such as incoming calls. */
/** execute: Interpret a completed AT command line, including settings, dialing and online control. */
static void execute(const char *p) {
    unsigned value;
    int c;
    while (*p == ' ')
        p++;
    if (toupper((unsigned char)p[0]) != 'A' || toupper((unsigned char)p[1]) != 'T') {
        result(4);
        return;
    }
    p += 2;
    while (*p) {
        c = toupper((unsigned char)*p++);
        if (c == ' ')
            continue;
        if (c == 'D') {
            if (toupper((unsigned char)*p) == 'T' || toupper((unsigned char)*p) == 'P')
                p++;
            dial(p);
            return;
        }
        if (c == 'E' || c == 'Q' || c == 'V') {
            value = parameter(&p, 0);
            if (value > 1) {
                result(4);
                return;
            }
            if (c == 'E')
                m.echo = value;
            else if (c == 'Q')
                m.quiet = value;
            else
                m.verbose = value;
        } else if (c == 'H') {
            if (parameter(&p, 0)) {
                result(4);
                return;
            }
            hangup();
        } else if (c == 'Z') {
            if (parameter(&p, 0)) {
                result(4);
                return;
            }
            hangup();
            defaults();
        } else if (c == '&' && toupper((unsigned char)*p) == 'F') {
            p++;
            if (parameter(&p, 0)) {
                result(4);
                return;
            }
            hangup();
            defaults();
        } else if (c == 'O') {
            if (parameter(&p, 0) || *p || m.socket == INVALID_SOCK) {
                result(3);
                return;
            }
            m.online = 1;
            m.last_tx = milliseconds();
            result(1);
            return;
        } else if (c == 'I') {
            if (parameter(&p, 0)) {
                result(4);
                return;
            }
            text("\r\nQLBox TCP modem\r\n");
        } else if (c == 'S') {
            if (parameter(&p, 999) != 12) {
                result(4);
                return;
            }
            if (*p == '?') {
                char out[16];
                p++;
                snprintf(out, sizeof(out), "\r\n%u\r\n", m.guard);
                text(out);
            } else if (*p++ == '=') {
                value = parameter(&p, 999);
                if (value > 255) {
                    result(4);
                    return;
                }
                m.guard = value;
            } else {
                result(4);
                return;
            }
        } else {
            result(4);
            return;
        }
    }
    result(0);
}
/* Escape IAC on a Telnet connection; raw mode preserves all 256 byte values. */
/** data_byte: Queue one network payload byte with Telnet IAC escaping and NVT carriage-return handling as required. */
static int data_byte(unsigned c) {
    if (m.tx.count > CAP - 3)
        return 0;
    if (m.tx_cr) {
        if (c != 10)
            push(&m.tx, 0);
        m.tx_cr = 0;
    }
    push(&m.tx, c);
    if (m.telnet && c == 255)
        push(&m.tx, c);
    if (m.telnet && !m.local[0] && c == 13)
        m.tx_cr = 1;
    return 1;
}
/** modem_put: Accept one guest serial byte, applying command parsing or guarded escape detection in data mode. */
int modem_put(unsigned c) {
    uint64_t now = milliseconds();
    unsigned i;
    c &= 255;
    if (!m.port)
        return 0;
    /* A CRLF command terminator must not abort a pending dial on its LF. */
    if (m.swallow_lf) {
        m.swallow_lf = 0;
        if (c == '\n')
            return 1;
    }
    if (m.dialing) {
        hangup();
        result(3);
        return 1;
    }
    if (m.online) {
        if (m.tx.count > CAP - 10)
            return 0;
        if (m.pluses) {
            if (c == '+' && m.pluses < 3 && now - m.plus_time <= (uint64_t)m.guard * 20) {
                m.pluses++;
                m.plus_time = now;
                return 1;
            }
            for (i = 0; i < m.pluses; i++)
                data_byte('+');
            m.pluses = 0;
        } else if (c == '+' && now - m.last_tx >= (uint64_t)m.guard * 20) {
            m.pluses = 1;
            m.plus_time = now;
            return 1;
        }
        m.last_tx = now;
        return data_byte(c);
    }
    if (m.rx.count > CAP - 2048)
        return 0;
    if (m.echo)
        push(&m.rx, c);
    if (c == '\r' || c == '\n') {
        m.swallow_lf = c == '\r';
        m.line[m.length] = 0;
        if (m.overflow)
            result(4);
        else if (m.length)
            execute(m.line);
        m.length = 0;
        m.overflow = 0;
    } else if (c == 8 || c == 127) {
        if (m.length)
            m.length--;
    } else if (c >= 32 && c < 127) {
        if (m.length < sizeof(m.line) - 1)
            m.line[m.length++] = (char)c;
        else
            m.overflow = 1;
    }
    return 1;
}
/* Minimal Telnet endpoint: binary, remote echo, suppress-go-ahead, ANSI
 * terminal type and 80x24 dimensions. Option states prevent reply loops. */
/** negotiate: Process Telnet WILL/WONT/DO/DONT with per-direction state and fixed 80x24 NAWS support. */
static void negotiate(unsigned command, unsigned option) {
    unsigned response = 0;
    if (command == 251) { /* WILL */
        if (m.remote[option])
            return;
        response = option == 0 || option == 1 || option == 3 ? 253 : 254;
        m.remote[option] = response == 253 ? 1 : 2;
    } else if (command == 253) { /* DO */
        if (m.local[option])
            return;
        response = option == 0 || option == 3 || option == 24 || option == 31 ? 251 : 252;
        m.local[option] = response == 251 ? 1 : 2;
    } else if (command == 252) {
        if (m.remote[option] == 1)
            response = 254;
        m.remote[option] = 0;
    } else if (command == 254) {
        if (m.local[option] == 1)
            response = 252;
        m.local[option] = 0;
    }
    if (response) {
        push(&m.tx, 255);
        push(&m.tx, response);
        push(&m.tx, option);
    }
    if (response == 251 && option == 31) {
        const unsigned char size[] = {255, 250, 31, 0, 80, 0, 24, 255, 240};
        unsigned i;
        for (i = 0; i < sizeof(size); i++)
            push(&m.tx, size[i]);
    }
}
/** received: Parse one Telnet byte, preserving partial commands/subnegotiations between socket reads. */
static void received(unsigned c) {
    switch (m.tel_state) {
    case 0:
        if (c == 255)
            m.tel_state = 1;
        else {
            if (!m.remote[0] && m.rx_cr && c == 0) {
                m.rx_cr = 0;
                break;
            }
            push(&m.rx, c);
            m.rx_cr = c == 13;
        }
        break;
    case 1:
        if (c == 255) {
            push(&m.rx, c);
            m.rx_cr = 0;
            m.tel_state = 0;
        } else if (c >= 251 && c <= 254) {
            m.tel_cmd = c;
            m.tel_state = 2;
        } else if (c == 250) {
            m.sublen = 0;
            m.tel_state = 3;
        } else
            m.tel_state = 0;
        break;
    case 2:
        negotiate(m.tel_cmd, c);
        m.tel_state = 0;
        break;
    case 3:
        if (c == 255)
            m.tel_state = 4;
        else if (m.sublen < sizeof(m.sub))
            m.sub[m.sublen++] = (unsigned char)c;
        break;
    case 4:
        if (c == 240) {
            if (m.sublen == 2 && m.sub[0] == 24 && m.sub[1] == 1 && m.local[24]) {
                const unsigned char type[] = {255, 250, 24, 0, 'A', 'N', 'S', 'I', 255, 240};
                unsigned i;
                for (i = 0; i < sizeof(type); i++)
                    push(&m.tx, type[i]);
            }
            m.tel_state = 0;
        } else {
            if (c == 255 && m.sublen < sizeof(m.sub))
                m.sub[m.sublen++] = 255;
            m.tel_state = 3;
        }
        break;
    }
}
/* Poll host networking without waiting. Queue capacity provides backpressure
 * in both directions; data is not discarded when a guest reads slowly. */
/** modem_poll: Reap DNS, advance nonblocking TCP and escape timing, and transfer bounded queue data without waiting. */
void modem_poll(void) {
    uint64_t now = milliseconds();
    unsigned i;
    if (m.lookup) {
        Lookup *q = m.lookup;
        int done;
        lock_lookup(q);
        done = q->done;
        unlock_lookup(q);
        if (done) {
            m.lookup = NULL;
            if (m.cancelled || !m.dialing) {
                if (q->addresses)
                    freeaddrinfo(q->addresses);
            } else if (q->error) {
                hangup();
                result(3);
            } else {
                m.addresses = m.next = q->addresses;
                next_address();
            }
            free_lookup(q);
        }
    }
    if (!m.port)
        return;
    if (m.dialing && now >= m.deadline) {
        hangup();
        result(3);
    }
    if (m.connecting && m.socket != INVALID_SOCK) {
        fd_set writes, errors;
        struct timeval zero = {0, 0};
        FD_ZERO(&writes);
        FD_ZERO(&errors);
        FD_SET(m.socket, &writes);
        FD_SET(m.socket, &errors);
        if (select((int)m.socket + 1, NULL, &writes, &errors, &zero) > 0) {
            int error = 0;
#ifdef _WIN32
            int length = sizeof(error);
#else
            socklen_t length = sizeof(error);
#endif
            if (getsockopt(m.socket, SOL_SOCKET, SO_ERROR, (void *)&error, &length) || error)
                next_address();
            else
                connected();
        }
    }
    if (m.pluses && now - m.plus_time >= (uint64_t)m.guard * 20) {
        if (m.pluses == 3) {
            m.pluses = 0;
            m.online = 0;
            result(0);
        } else if (m.tx.count <= CAP - 6) {
            for (i = 0; i < m.pluses; i++)
                data_byte('+');
            m.pluses = 0;
            m.last_tx = now;
        }
    }
    if (m.socket == INVALID_SOCK || m.connecting)
        return;
    if (m.tx_cr && m.tx.count < CAP) {
        push(&m.tx, 0);
        m.tx_cr = 0;
    }
    if (m.tx.count) {
        unsigned n = CAP - m.tx.head;
        int sent;
        if (n > m.tx.count)
            n = m.tx.count;
#ifdef MSG_NOSIGNAL
        sent = (int)send(m.socket, (const char *)m.tx.bytes + m.tx.head, (int)n, MSG_NOSIGNAL);
#else
        sent = (int)send(m.socket, (const char *)m.tx.bytes + m.tx.head, (int)n, 0);
#endif
        if (sent > 0) {
            m.tx.head = (m.tx.head + (unsigned)sent) % CAP;
            m.tx.count -= (unsigned)sent;
        } else if (sent < 0 && !would_block()) {
            hangup();
            result(3);
            return;
        }
    }
    /* Keep remote bytes pending at the socket while in online command mode. */
    if (m.online && m.rx.count <= CAP - 4096 && m.tx.count <= CAP - 16384) {
        unsigned char buf[1024];
        int n = (int)recv(m.socket, (char *)buf, sizeof(buf), 0);
        if (n > 0)
            for (i = 0; i < (unsigned)n; i++) {
                if (m.telnet)
                    received(buf[i]);
                else
                    push(&m.rx, buf[i]);
            }
        else if (!n || !would_block()) {
            hangup();
            result(3);
        }
    }
}
/** modem_get: Return one queued guest receive byte, or -1 when none is available. */
int modem_get(void) {
    return pop(&m.rx);
}
/** modem_available: Report the current guest receive byte count. */
unsigned modem_available(void) {
    return m.rx.count;
}
/* Closing the QDOS channel drops carrier; settings survive until ATZ/reset. */
/** modem_shutdown: Cancel any dial, close carrier and disable the bridge without blocking on DNS. */
void modem_shutdown(void) {
    hangup();
    m.opened = 0;
    m.port = 0;
    modem_poll();
}
/** modem_init: Reset modem state and select a serial port/transport, preserving a pending cancelled resolver safely. */
int modem_init(unsigned port, int telnet) {
    Lookup *pending = m.lookup;
    hangup();
    memset(&m, 0, sizeof(m));
    m.lookup = pending;
    m.cancelled = 1;
    m.socket = INVALID_SOCK;
    m.port = port;
    m.telnet = telnet;
    defaults();
#ifdef _WIN32
    {
        static int initialized;
        WSADATA data;
        if (port && !initialized) {
            if (WSAStartup(MAKEWORD(2, 2), &data)) {
                m.port = 0;
                return 0;
            }
            initialized = 1;
        }
    }
#endif
    return 1;
}
/** get32: Decode a big-endian guest register without host-endian or alignment assumptions. */
static uint32_t get32(const unsigned char *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
/** put32: Store a register result in big-endian guest byte order. */
static void put32(unsigned char *p, uint32_t v) {
    p[0] = v >> 24;
    p[1] = v >> 16;
    p[2] = v >> 8;
    p[3] = v;
}
/** ram: Check that a complete byte range lies inside configured guest RAM. */
static int ram(uint32_t a, uint32_t n) {
    return a >= 0x20000 && a <= ql.ram_top && n <= ql.ram_top - a;
}
/** readable: Accept a complete source range in ROM or RAM, excluding unmapped/device regions. */
static int readable(uint32_t a, uint32_t n) {
    return (a < ql.rom_size && n <= ql.rom_size - a) || ram(a, n);
}
/* Recognize only the selected SER device and standard parity/handshake suffixes. */
/** serial_name: Recognize a counted name for the configured port with accepted serial suffix characters. */
static int serial_name(uint32_t a) {
    unsigned n, i;
    const unsigned char *p;
    if (!readable(a, 2))
        return 0;
    n = (unsigned)ql.mem[a] * 256 + ql.mem[a + 1];
    if (n < 4 || n > 12 || !readable(a + 2, n))
        return 0;
    p = ql.mem + a + 2;
    if (toupper(p[0]) != 'S' || toupper(p[1]) != 'E' || toupper(p[2]) != 'R' ||
        p[3] != '0' + m.port)
        return 0;
    for (i = 4; i < n; i++)
        if (!p[i] || !strchr("IEOMHSZ", toupper(p[i])))
            return 0;
    return 1;
}
/* QDOS stream operations preserve partial counts for asynchronous retry.
 * Serial parity, baud and handshake suffixes are accepted but not paced. */
/** io: Dispatch serial QDOS I/O, retaining partial counts and pointers for OS retry semantics. */
static int io(uint32_t *r) {
    unsigned op = r[0], n = r[2] & 65535, i = 0;
    int c;
    if (op == 0)
        return m.rx.count ? 0 : NC;
    if (op == 0x40 || op == 0x41)
        return m.tx.count ? NC : 0;
    if (op == 5)
        return modem_put(r[1] & 255) ? 0 : NC;
    if (op == 7) {
        if (!readable(r[5], n))
            return BP;
        while (i < n && modem_put(ql.mem[r[5] + i]))
            i++;
        r[1] = i;
        r[5] += i;
        return i == n ? 0 : NC;
    }
    if (op != 1 && op != 2 && op != 3)
        return NI;
    if (op == 1) {
        c = modem_get();
        if (c < 0)
            return NC;
        r[1] = (r[1] & 0xffffff00u) | (unsigned)c;
        return 0;
    }
    if (!ram(r[5], n))
        return BP;
    while (i < n && (c = modem_get()) >= 0) {
        ql.mem[r[5] + i++] = (unsigned char)c;
        if (op == 2 && c == 10)
            break;
    }
    r[1] = i;
    r[5] += i;
    if (op == 2)
        return i && ql.mem[r[5] - 1] == 10 ? 0 : i == n ? -5 : NC;
    return i == n ? 0 : NC;
}
/* Claim only our selected port and tagged handle; all other device requests
 * fall through to the terminal/file drivers and ultimately stock QDOS. */
/** modem_command: Claim selected serial opens and tagged-handle operations in the existing six-register ROM bridge. */
int modem_command(unsigned command, unsigned request) {
    uint32_t r[6], id = 0;
    unsigned i;
    int status;
    if (!m.port || !ram(request, 24))
        return 0;
    for (i = 0; i < 6; i++)
        r[i] = get32(ql.mem + request + 4 * i);
    if (command == 1) {
        if (!serial_name(r[4]))
            return 0;
        status = m.opened ? -9 : 0;
        if (!status) {
            m.opened = 1;
            r[1] = MODEM_HANDLE;
        }
    } else {
        if (command == 3)
            id = r[1];
        else if (command == 2 && ram(r[4], 32))
            id = get32(ql.mem + r[4] + 24);
        if (id != MODEM_HANDLE)
            return 0;
        if (!m.opened)
            status = -6;
        else if (command == 3) {
            hangup();
            m.opened = 0;
            m.rx.head = m.rx.count = m.length = 0;
            m.overflow = m.swallow_lf = 0;
            status = 0;
        } else
            status = io(r);
    }
    r[0] = (uint32_t)status;
    for (i = 0; i < 6; i++)
        put32(ql.mem + request + 4 * i, r[i]);
    return 1;
}
