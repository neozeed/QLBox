/* Stream-only CON/SCR driver for the ROM's CLI launcher.
 * QDOS owns the actual channels and asynchronous retry/scheduling. */
#define _POSIX_C_SOURCE 200809L
#include "terminal.h"
#include "ql.h"
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <signal.h>
#ifdef _WIN32
#include <windows.h>
#include <conio.h>
#include <fcntl.h>
#include <io.h>
#else
#include <unistd.h>
#include <sys/select.h>
#include <errno.h>
#endif
#define TAG 0x80000000u
#define CHANNELS 128
static unsigned char channels[CHANNELS], queue[65536];
static unsigned used;
static int input_eof, pending, after_cr;
/**
 * get32
 *
 * Read a big-endian 32-bit guest value without casting guest bytes to a host integer.
 */
static uint32_t get32(const unsigned char *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
/**
 * put32
 *
 * Store a 32-bit value in big-endian guest byte order.
 */
static void put32(unsigned char *p, uint32_t v) {
    p[0] = (unsigned char)(v >> 24);
    p[1] = (unsigned char)(v >> 16);
    p[2] = (unsigned char)(v >> 8);
    p[3] = (unsigned char)v;
}
/**
 * ram
 *
 * Return whether the entire guest byte range lies inside configured writable RAM. Subtraction
 * avoids an overflowing end address.
 */
static int ram(uint32_t a, uint32_t n) {
    return a >= 0x20000 && a <= ql.ram_top && n <= ql.ram_top - a;
}
/**
 * readable
 *
 * Accept a byte range wholly inside the main ROM or configured RAM; reject I/O and unmapped
 * ranges.
 */
static int readable(uint32_t a, uint32_t n) {
    return (a <= ql.rom_size && n <= ql.rom_size - a) || ram(a, n);
}
/**
 * terminal_init
 *
 * Reset stream channels and input queue; on Windows, select binary stdout for redirected output
 * to preserve guest bytes.
 */
void terminal_init(void) {
    memset(channels, 0, sizeof(channels));
    used = 0;
    input_eof = pending = after_cr = 0;
#ifdef _WIN32
    if (!_isatty(_fileno(stdout)))
        _setmode(_fileno(stdout), _O_BINARY);
#endif
}
/**
 * feed
 *
 * Append a host input byte with CR/CRLF normalized to one guest newline. The caller reserves
 * queue capacity.
 */
static void feed(unsigned c) {
    if (c == '\n' && after_cr) {
        after_cr = 0;
        return;
    }
    after_cr = c == '\r';
    if (after_cr)
        c = '\n';
    queue[used++] = (unsigned char)c;
}
/**
 * terminal_poll
 *
 * Collect available console/pipe input into the queue. A short wait is allowed when a guest read
 * is pending; EOF is retained for subsequent QDOS requests.
 */
void terminal_poll(void) {
    if (input_eof || used == sizeof(queue))
        return;
#ifdef _WIN32
    {
        HANDLE h = GetStdHandle(STD_INPUT_HANDLE);
        DWORD mode, n = 0;
        unsigned char b[1024];
        if (GetConsoleMode(h, &mode)) {
            if (!_kbhit()) {
                if (pending)
                    Sleep(10);
                return;
            }
            while (_kbhit() && used < sizeof(queue)) {
                int c = _getch();
                if (c == 0 || c == 224) {
                    (void)_getch();
                    continue;
                }
                if (c == 3) {
                    raise(SIGINT);
                    return;
                }
                if (c == 26) {
                    input_eof = 1;
                    break;
                }
                if (c == 8) {
                    if (used && queue[used - 1] != '\n') {
                        used--;
                        fputs("\b \b", stdout);
                        fflush(stdout);
                    }
                    continue;
                }
                if (c == '\r')
                    fputc('\n', stdout);
                else
                    fputc(c, stdout);
                fflush(stdout);
                feed((unsigned)c);
            }
        } else {
            DWORD kind = GetFileType(h), avail = 0;
            if (kind == FILE_TYPE_PIPE) {
                if (!PeekNamedPipe(h, NULL, 0, NULL, &avail, NULL)) {
                    input_eof = 1;
                    return;
                }
                if (!avail) {
                    if (pending)
                        Sleep(10);
                    return;
                }
            }
            n = (DWORD)(sizeof(queue) - used);
            if (n > sizeof(b))
                n = sizeof(b);
            if (!ReadFile(h, b, n, &n, NULL) || !n) {
                input_eof = 1;
                return;
            }
            {
                DWORD i;
                for (i = 0; i < n; i++)
                    feed(b[i]);
            }
        }
    }
#else
    {
        fd_set rd;
        struct timeval tv;
        unsigned char b[1024];
        ssize_t n;
        size_t cap = sizeof(queue) - used;
        FD_ZERO(&rd);
        FD_SET(STDIN_FILENO, &rd);
        tv.tv_sec = 0;
        tv.tv_usec = pending ? 10000 : 0;
        if (select(STDIN_FILENO + 1, &rd, NULL, NULL, &tv) <= 0)
            return;
        if (cap > sizeof(b))
            cap = sizeof(b);
        n = read(STDIN_FILENO, b, cap);
        if (n < 0) {
            if (errno != EINTR && errno != EAGAIN)
                input_eof = 1;
            return;
        }
        if (!n) {
            input_eof = 1;
            return;
        }
        {
            ssize_t i;
            for (i = 0; i < n; i++)
                feed(b[i]);
        }
    }
#endif
    pending = 0;
}
/**
 * open_terminal
 *
 * Recognize counted CON/SCR names and allocate a tagged stream handle. Return zero for another
 * driver, one for success or a negative allocation error.
 */
static int open_terminal(uint32_t a, uint32_t *id) {
    unsigned n, i;
    char name[4];
    if (!readable(a, 2))
        return 0;
    n = ((unsigned)ql.mem[a] << 8) | ql.mem[a + 1];
    if (n < 3 || !readable(a + 2, n))
        return 0;
    for (i = 0; i < 3; i++) {
        unsigned c = ql.mem[a + 2 + i];
        name[i] = (char)(c >= 'a' && c <= 'z' ? c - 32 : c);
    }
    name[3] = 0;
    if (strcmp(name, "CON") && strcmp(name, "SCR"))
        return 0;
    if (n > 3 && ql.mem[a + 5] != '_')
        return 0;
    for (i = 0; i < CHANNELS; i++)
        if (!channels[i]) {
            channels[i] = (unsigned char)(name[0] == 'S' ? 2 : 1);
            *id = TAG | (i + 1);
            return 1;
        }
    *id = 0;
    return -3;
}
/**
 * io
 *
 * Execute stream I/O against the shared input queue and stdout. Return not-complete for pending
 * reads so QDOS can retry; SCR rejects input and graphics operations are unsupported.
 */
static int io(uint32_t *r, unsigned slot) {
    unsigned op = r[0], count = r[2] & 65535, n, i;
    int status = 0;
    if (op == 0) {
        if (channels[slot] == 2)
            return -19;
        if (used)
            return 0;
        if (input_eof)
            return -10;
        pending = 1;
        return -1;
    }
    if (op == 5) {
        if (fputc((int)(r[1] & 255), stdout) == EOF || fflush(stdout))
            return -16;
        return 0;
    }
    if (op == 7) {
        if (!readable(r[5], count))
            return -15;
        n = (unsigned)fwrite(ql.mem + r[5], 1, count, stdout);
        r[5] += n;
        r[1] = n;
        return n != count || fflush(stdout) ? -16 : 0;
    }
    if (op == 0x40 || op == 0x41)
        return fflush(stdout) ? -16 : 0;
    if (op != 1 && op != 2 && op != 3)
        return -19; /* no full-screen/graphics contract */
    if (channels[slot] == 2)
        return -19;
    if (op == 1)
        count = 1;
    else
        r[1] = 0;
    if (op != 1 && !ram(r[5], count))
        return -15;
    n = used < count ? used : count;
    if (op == 2)
        for (i = 0; i < n; i++)
            if (queue[i] == '\n') {
                n = i + 1;
                break;
            }
    if (!n && count) {
        if (input_eof)
            return -10;
        pending = 1;
        return -1;
    }
    if (op == 2 && n && queue[n - 1] != '\n') {
        if (n == count)
            status = -5;
        else if (!input_eof) {
            pending = 1;
            return -1;
        } else
            status = -10;
    } else if (op == 3 && n < count) {
        if (!input_eof) {
            pending = 1;
            return -1;
        }
        status = -10;
    }
    if (op == 1)
        r[1] = (r[1] & 0xffffff00u) | queue[0];
    else {
        memcpy(ql.mem + r[5], queue, n);
        r[5] += n;
        r[1] = n;
    }
    used -= n;
    memmove(queue, queue + n, used);
    return status;
}
/**
 * terminal_command
 *
 * Handle a ROM bridge request only when the CLI runner is active and the target is a tagged
 * terminal channel. Return zero to let hostfs try another driver.
 */
int terminal_command(unsigned command, unsigned request) {
    uint32_t r[6], id = 0;
    unsigned i;
    int status;
    if (!ql.run_active || !ram(request, 24))
        return 0;
    for (i = 0; i < 6; i++)
        r[i] = get32(ql.mem + request + i * 4);
    if (command == 1) {
        int found = open_terminal(r[4], &id);
        if (!found)
            return 0;
        status = found < 0 ? found : 0;
        r[1] = id;
    } else {
        if (command == 3)
            id = r[1];
        else if (command == 2 && ram(r[4], 32))
            id = get32(ql.mem + r[4] + 24);
        if (!(id & TAG))
            return 0;
        id &= ~TAG;
        if (!id || id > CHANNELS || !channels[id - 1])
            status = -6;
        else if (command == 3) {
            channels[id - 1] = 0;
            status = 0;
        } else
            status = io(r, id - 1);
    }
    r[0] = (uint32_t)status;
    for (i = 0; i < 6; i++)
        put32(ql.mem + request + i * 4, r[i]);
    return 1;
}
