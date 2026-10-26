/* Optional, loopback-only GDB RSP for the whole 68000 machine. */
#include "debugger.h"
#include "ql.h"
#include "m68k.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
typedef SOCKET Sock;
#define BAD INVALID_SOCKET
#define sockclose closesocket
#else
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <unistd.h>
#include <signal.h>
typedef int Sock;
#define BAD (-1)
#define sockclose close
#endif
#define CAP 8192
static Sock listener = BAD, client = BAD;
static int stopped, step, skip_break, notify_stop, noack, rxstate, overflow;
static unsigned rxlen, checksum, received, breaks[64], nbreaks;
static char rx[CAP], last[CAP + 4], xml[2048];
static FILE *logfile;
static char line[1024];
static unsigned line_len;
static const m68k_register_t regs[] = {
    M68K_REG_D0, M68K_REG_D1, M68K_REG_D2, M68K_REG_D3, M68K_REG_D4, M68K_REG_D5,
    M68K_REG_D6, M68K_REG_D7, M68K_REG_A0, M68K_REG_A1, M68K_REG_A2, M68K_REG_A3,
    M68K_REG_A4, M68K_REG_A5, M68K_REG_A6, M68K_REG_A7, M68K_REG_SR, M68K_REG_PC};
/**
 * hex
 *
 * Decode one hexadecimal digit or return -1 for invalid input.
 */
static int hex(int c) {
    if (c >= '0' && c <= '9')
        return c - '0';
    if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    return -1;
}
/**
 * disconnect
 *
 * Close the debug client and clear session-specific stop, packet and breakpoint state while
 * leaving the listening socket available.
 */
static void disconnect(void) {
    if (client != BAD)
        sockclose(client);
    client = BAD;
    stopped = step = notify_stop = noack = rxstate = 0;
    nbreaks = 0;
}
/**
 * sendall
 *
 * Send a complete protocol message, retrying partial writes. Disconnect and return false if the
 * socket cannot accept more data.
 */
static int sendall(const char *s, unsigned n) {
    while (n) {
        int r = (int)send(client, s, (int)n, 0);
        if (r <= 0) {
            disconnect();
            return 0;
        }
        s += r;
        n -= (unsigned)r;
    }
    return 1;
}
/**
 * packet
 *
 * Frame a GDB response with its checksum and retain it for retransmission on a negative
 * acknowledgement.
 */
static void packet(const char *s) {
    unsigned sum = 0, i, n = (unsigned)strlen(s);
    if (client == BAD || n >= CAP)
        return;
    last[0] = '$';
    memcpy(last + 1, s, n);
    for (i = 0; i < n; i++)
        sum += (unsigned char)s[i];
    snprintf(last + n + 1, 4, "#%02x", sum & 255);
    sendall(last, n + 4);
}
/**
 * number
 *
 * Parse one to eight hexadecimal digits into a 32-bit value and advance the input cursor; reject
 * empty or overlong values.
 */
static int number(const char **p, uint32_t *v) {
    unsigned n = 0;
    int h;
    *v = 0;
    while ((h = hex(**p)) >= 0) {
        if (n++ == 8)
            return 0;
        *v = (*v << 4) | (unsigned)h;
        (*p)++;
    }
    return n != 0;
}
/**
 * decode
 *
 * Decode an exactly sized hex byte string, rejecting invalid characters or length.
 */
static int decode(const char *p, unsigned char *out, unsigned n) {
    unsigned i;
    if (strlen(p) != 2 * n)
        return 0;
    for (i = 0; i < n; i++) {
        int a = hex(p[2 * i]), b = hex(p[2 * i + 1]);
        if (a < 0 || b < 0)
            return 0;
        out[i] = (unsigned char)(a * 16 + b);
    }
    return 1;
}
/**
 * mapped
 *
 * Check a debugger memory range against readable ROM or writable RAM. Device registers are
 * excluded from this direct-access interface.
 */
static int mapped(uint32_t a, uint32_t n, int write) {
    if (a > QL_MEM_SIZE || n > QL_MEM_SIZE - a)
        return 0;
    return (!write && a < ql.rom_size && n <= ql.rom_size - a) ||
           (a >= 0x20000 && a <= ql.ram_top && n <= ql.ram_top - a);
}
/**
 * resume
 *
 * Validate an optional new PC and resume continuous or single-step execution, skipping the
 * current breakpoint once.
 */
static void resume(int single, const char *p) {
    uint32_t a;
    if (*p) {
        if (!number(&p, &a) || *p || a & 1 || !mapped(a, 2, 0)) {
            packet("E01");
            return;
        }
        m68k_set_reg(M68K_REG_PC, a);
    }
    stopped = 0;
    step = single;
    skip_break = 1;
}
/**
 * command
 *
 * Dispatch a validated GDB remote-protocol payload: registers, memory, execution control,
 * breakpoints and capability queries. Unsupported packets receive an empty reply.
 */
static void command(const char *s) {
    char out[CAP];
    const char *p = s + 1;
    uint32_t a, n, v;
    unsigned i;
    unsigned char bytes[CAP / 2];
    if (!strcmp(s, "?")) {
        stopped = 1;
        packet("S05");
    } else if (!strncmp(s, "qSupported", 10))
        packet("PacketSize=1fff;qXfer:features:read+;QStartNoAckMode+;swbreak+");
    else if (!strcmp(s, "QStartNoAckMode")) {
        packet("OK");
        noack = 1;
    } else if (!strncmp(s, "qXfer:features:read:target.xml:", 31)) {
        p = s + 31;
        if (!number(&p, &a) || *p++ != ',' || !number(&p, &n) || *p) {
            packet("E01");
            return;
        }
        v = (uint32_t)strlen(xml);
        if (a > v) {
            packet("E01");
            return;
        }
        if (n > CAP - 2)
            n = CAP - 2;
        if (n > v - a)
            n = v - a;
        out[0] = a + n < v ? 'm' : 'l';
        memcpy(out + 1, xml + a, n);
        out[n + 1] = 0;
        packet(out);
    } else if (!strcmp(s, "qAttached"))
        packet("1");
    else if (!strcmp(s, "qC"))
        packet("QC1");
    else if (!strcmp(s, "qfThreadInfo"))
        packet("m1");
    else if (!strcmp(s, "qsThreadInfo"))
        packet("l");
    else if (s[0] == 'H' || !strcmp(s, "T1"))
        packet("OK");
    else if (!strcmp(s, "g")) {
        for (i = 0; i < 18; i++)
            sprintf(out + i * 8, "%08x", m68k_get_reg(NULL, regs[i]));
        packet(out);
    } else if (s[0] == 'p') {
        if (!number(&p, &a) || *p || a >= 18) {
            packet("E01");
            return;
        }
        sprintf(out, "%08x", m68k_get_reg(NULL, regs[a]));
        packet(out);
    } else if (s[0] == 'P') {
        if (!number(&p, &a) || *p++ != '=' || strlen(p) != 8 || !number(&p, &v) || *p || a >= 18) {
            packet("E01");
            return;
        }
        m68k_set_reg(regs[a], v);
        packet("OK");
    } else if (s[0] == 'G') {
        if (!decode(p, bytes, 72)) {
            packet("E01");
            return;
        }
        /* SR first: switching supervisor mode changes active A7. */
        m68k_set_reg(M68K_REG_SR, ((unsigned)bytes[66] << 8) | bytes[67]);
        for (i = 0; i < 18; i++)
            if (i != 16)
                m68k_set_reg(regs[i], ((uint32_t)bytes[i * 4] << 24) |
                                          ((uint32_t)bytes[i * 4 + 1] << 16) |
                                          ((uint32_t)bytes[i * 4 + 2] << 8) | bytes[i * 4 + 3]);
        packet("OK");
    } else if (s[0] == 'm' || s[0] == 'M') {
        if (!number(&p, &a) || *p++ != ',' || !number(&p, &n) || n > (CAP - 1) / 2 ||
            !mapped(a, n, s[0] == 'M')) {
            packet("E01");
            return;
        }
        if (s[0] == 'M') {
            if (*p++ != ':' || !decode(p, bytes, n)) {
                packet("E01");
                return;
            }
            memcpy(ql.mem + a, bytes, n);
            packet("OK");
        } else {
            if (*p) {
                packet("E01");
                return;
            }
            for (i = 0; i < n; i++)
                sprintf(out + 2 * i, "%02x", ql.mem[a + i]);
            out[2 * n] = 0;
            packet(out);
        }
    } else if (s[0] == 'Z' || s[0] == 'z') {
        uint32_t kind;
        if (!number(&p, &v) || *p++ != ',' || !number(&p, &a) || *p++ != ',' ||
            !number(&p, &kind) || *p) {
            packet("E01");
            return;
        }
        if (v > 1) {
            packet("");
            return;
        }
        if (kind != 2 || (a & 1) || !mapped(a, 2, 0)) {
            packet("E01");
            return;
        }
        for (i = 0; i < nbreaks && breaks[i] != a; i++) {
        }
        if (s[0] == 'Z' && i == nbreaks) {
            if (nbreaks == 64) {
                packet("E01");
                return;
            }
            breaks[nbreaks++] = a;
        }
        if (s[0] == 'z' && i < nbreaks)
            breaks[i] = breaks[--nbreaks];
        packet("OK");
    } else if (s[0] == 'c' || s[0] == 's')
        resume(s[0] == 's', p);
    else if (!strcmp(s, "vCont?"))
        packet("vCont;c;s");
    else if (!strcmp(s, "vCont;c") || !strcmp(s, "vCont;c:1"))
        resume(0, "");
    else if (!strcmp(s, "vCont;s") || !strcmp(s, "vCont;s:1"))
        resume(1, "");
    else if (!strcmp(s, "D")) {
        packet("OK");
        disconnect();
    } else if (!strcmp(s, "k")) {
        disconnect();
    } else
        packet("");
}
/**
 * ready
 *
 * Poll a socket for readable data without waiting, keeping debugger checks within the emulator
 * loop.
 */
static int ready(Sock s) {
    fd_set set;
    struct timeval t = {0, 0};
    FD_ZERO(&set);
    FD_SET(s, &set);
    return select((int)s + 1, &set, NULL, NULL, &t) > 0;
}
/**
 * poll_socket
 *
 * Accept a local debugger connection and assemble bounded packets, checking checksums and
 * handling acknowledgements and interrupt requests.
 */
static void poll_socket(void) {
    unsigned count = 0;
    if (client == BAD) {
        if (listener == BAD || !ready(listener))
            return;
        client = accept(listener, NULL, NULL);
        if (client == BAD)
            return;
        noack = rxstate = 0;
        stopped = 1;
        step = 0;
        notify_stop = 0;
        fprintf(stderr, "[gdb] connected, CPU paused\n");
    }
    if (notify_stop) {
        packet("S05");
        notify_stop = 0;
    }
    while (client != BAD && count++ < CAP && ready(client)) {
        unsigned char c;
        int r = (int)recv(client, (char *)&c, 1, 0);
        if (r <= 0) {
            disconnect();
            return;
        }
        if (c == 3) {
            stopped = 1;
            step = 0;
            packet("S02");
            rxstate = 0;
            continue;
        }
        if (!rxstate) {
            if (c == '$') {
                rxstate = 1;
                rxlen = checksum = overflow = 0;
            } else if (c == '-' && !noack && last[0])
                sendall(last, (unsigned)strlen(last));
            continue;
        }
        if (rxstate == 1) {
            if (c == '#') {
                rxstate = 2;
                continue;
            }
            checksum = (checksum + c) & 255;
            if (rxlen < CAP - 1)
                rx[rxlen++] = (char)c;
            else
                overflow = 1;
            continue;
        }
        if (hex(c) < 0) {
            rxstate = 0;
            if (!noack)
                sendall("-", 1);
            continue;
        }
        if (rxstate == 2) {
            received = (unsigned)hex(c) << 4;
            rxstate = 3;
            continue;
        }
        received |= (unsigned)hex(c);
        rxstate = 0;
        rx[rxlen] = 0;
        if (received != checksum || overflow) {
            if (!noack)
                sendall("-", 1);
            continue;
        }
        if (!noack && !sendall("+", 1))
            return;
        command(rx);
    }
}
/**
 * debugger_init
 *
 * Initialize the guest log and optional loopback GDB listener, including the target register
 * description. Return false if initialization fails.
 */
int debugger_init(unsigned port, int wait, const char *path) {
    unsigned i;
    const char *names[] = {"d0", "d1", "d2", "d3", "d4", "d5", "d6", "d7", "a0",
                           "a1", "a2", "a3", "a4", "a5", "fp", "sp", "ps", "pc"};
    logfile = stderr;
    if (path) {
        logfile = fopen(path, "wb");
        if (!logfile) {
            perror(path);
            return 0;
        }
    }
    if (!port)
        return !wait;
#ifndef _WIN32
    signal(SIGPIPE, SIG_IGN);
#endif
#ifdef _WIN32
    {
        WSADATA w;
        if (WSAStartup(MAKEWORD(2, 2), &w))
            return 0;
    }
#endif
    {
        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));
        addr.sin_family = AF_INET;
        addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
        addr.sin_port = htons((unsigned short)port);
        listener = socket(AF_INET, SOCK_STREAM, 0);
        if (listener == BAD || bind(listener, (struct sockaddr *)&addr, sizeof(addr)) ||
            listen(listener, 1)) {
            fprintf(stderr, "Cannot listen for GDB on 127.0.0.1:%u\n", port);
            debugger_close();
            return 0;
        }
    }
    strcpy(xml, "<?xml version=\"1.0\"?><!DOCTYPE target SYSTEM \"gdb-target.dtd\"><target><architecture>m68k</architecture><feature name=\"org.gnu.gdb.m68k.core\">");
    for (i = 0; i < 18; i++) {
        char tag[100];
        snprintf(tag, sizeof(tag), "<reg name=\"%s\" bitsize=\"32\" regnum=\"%u\"/>", names[i], i);
        strcat(xml, tag);
    }
    strcat(xml, "</feature></target>");
    /* Consume Musashi reset latency without executing an instruction. */
    m68k_execute(0);
    stopped = wait;
    fprintf(stderr, "[gdb] listening on 127.0.0.1:%u%s\n", port, wait ? " (waiting)" : "");
    return 1;
}
/**
 * debugger_execute
 *
 * Run the requested CPU budget directly when debugging is off; otherwise interleave execution
 * with stop, single-step, breakpoint and socket handling.
 */
int debugger_execute(int cycles) {
    int used = 0;
    unsigned i, count = 0;
    if (listener == BAD) {
        m68k_execute(cycles);
        return 1;
    }
    poll_socket();
    if (stopped) {
#ifdef _WIN32
        Sleep(10);
#else
        struct timeval delay = {0, 10000};
        select(0, NULL, NULL, NULL, &delay);
#endif
        return 0;
    }

    while (used < cycles) {
        unsigned pc = m68k_get_reg(NULL, M68K_REG_PC);
        if (!skip_break)
            for (i = 0; i < nbreaks; i++)
                if (breaks[i] == pc) {
                    stopped = 1;
                    packet("S05");
                    return 0;
                }
        skip_break = 0;
        used += m68k_execute(1);
        if (stopped) {
            if (notify_stop) {
                packet("S05");
                notify_stop = 0;
            }
            return 0;
        }
        if (step) {
            step = 0;
            stopped = 1;
            packet("S05");
            return 0;
        }
        if (++count % 256 == 0) {
            poll_socket();
            if (stopped)
                return 0;
        }
    }
    return 1;
}
/**
 * debugger_enabled
 *
 * Report whether a GDB listening socket is active.
 */
int debugger_enabled(void) {
    return listener != BAD;
}
/**
 * flush_line
 *
 * Emit a buffered guest diagnostic line to the chosen log or stderr and reset its length.
 */
static void flush_line(void) {
    if (line_len) {
        FILE *f = logfile ? logfile : stderr;
        fprintf(f, "[guest] %.*s\n", (int)line_len, line);
        fflush(f);
        line_len = 0;
    }
}
/**
 * debugger_output
 *
 * Accept one byte from the guest diagnostic port, ignoring CR/NUL and flushing on newline or a
 * full buffer.
 */
void debugger_output(unsigned v) {
    v &= 255;
    if (v == '\n')
        flush_line();
    else if (v != '\r' && v) {
        line[line_len++] = (char)v;
        if (line_len == sizeof(line) - 1)
            flush_line();
    }
}
/**
 * debugger_control
 *
 * Interpret guest control bits to flush diagnostics or request a debugger stop when a listener
 * exists.
 */
void debugger_control(unsigned v) {
    if (v & 1)
        flush_line();
    if ((v & 2) && listener != BAD) {
        stopped = 1;
        notify_stop = 1;
    }
}
/**
 * debugger_close
 *
 * Flush final diagnostics and close the log, client and listener resources.
 */
void debugger_close(void) {
    flush_line();
    if (logfile && logfile != stderr)
        fclose(logfile);
    logfile = NULL;
    disconnect();
    if (listener != BAD)
        sockclose(listener);
    listener = BAD;
}
