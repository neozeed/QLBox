#define _POSIX_C_SOURCE 200809L
#include "ql.h"
#include "hostfs.h"
#include "terminal.h"
#include "modem.h"
#include "debugger.h"
#include <signal.h>
#include <ctype.h>
#ifdef _WIN32
#include <windows.h>
#elif defined(__APPLE__)
#include <mach-o/dyld.h>
#else
#include <unistd.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef QLBOX_SDL
#ifndef SDL_MAIN_HANDLED
#define SDL_MAIN_HANDLED
#endif
#include <SDL.h>
#include "sdl_input.h"
#endif
#ifdef QLBOX_SDL
/**
 * speed_title
 *
 * Update the SDL title with CPU speed and current mouse-capture eligibility/state.
 */
static void speed_title(SDL_Window *window) {
    char title[128];
    snprintf(title, sizeof(title),
             "QLBox R21 - %ux CPU | Ctrl+F11 slower, Ctrl+F12 faster, Ctrl+F9 %s mouse", ql.speed,
             ql_sdl_mouse_captured()                ? "release"
             : ql_mouse_active(&ql.mouse, ql.frame) ? "capture"
                                                    : "inactive");
    SDL_SetWindowTitle(window, title);
}
#endif
/* Configuration is expanded before command-line options, so CLI wins.
 * Paths deliberately use the process working directory, like --mount. */
/**
 * config_args
 *
 * Translate configuration settings into command-line arguments placed before explicit options so
 * the latter win. Validate keys, values and mount slots before startup.
 */
static int config_args(int *argc, char ***argv) {
    static char *expanded[512];
    static char values[192][4096];
    const char *file = "qlbox.conf";
    int explicit_file = 0, disabled = 0, i, n = 1, v = 0, line = 0;
    FILE *f;
    for (i = 1; i < *argc; i++) {
        if (!strcmp((*argv)[i], "--"))
            break;
        if (!strcmp((*argv)[i], "--no-config"))
            disabled = 1;
        if (!strcmp((*argv)[i], "--config")) {
            if (++i >= *argc) {
                fprintf(stderr, "--config requires a file\n");
                return 0;
            }
            file = (*argv)[i];
            explicit_file = 1;
        }
    }
    expanded[0] = (*argv)[0];
    f = disabled ? NULL : fopen(file, "r");
    if (!disabled && !f && explicit_file) {
        perror(file);
        return 0;
    }
    if (f) {
        char buf[4096];
        while (fgets(buf, sizeof(buf), f)) {
            char *key = buf, *value, *end;
            const char *option = NULL;
            line++;
            if (!strchr(buf, '\n') && !feof(f))
                goto bad;
            while (isspace((unsigned char)*key))
                key++;
            if (!*key || *key == '#' || *key == ';')
                continue;
            value = strchr(key, '=');
            if (!value)
                goto bad;
            *value++ = 0;
            end = key + strlen(key);
            while (end > key && isspace((unsigned char)end[-1]))
                *--end = 0;
            while (isspace((unsigned char)*value))
                value++;
            end = value + strlen(value);
            while (end > value && isspace((unsigned char)end[-1]))
                *--end = 0;
            if (*value == '"' && end > value + 1 && end[-1] == '"') {
                value++;
                *--end = 0;
            }
            if (!*value)
                goto bad;
            if (!strcmp(key, "ram"))
                option = "--ram";
            else if (!strcmp(key, "speed"))
                option = "--speed";
            else if (!strcmp(key, "modem"))
                option = "--modem";
            else if (!strcmp(key, "modem_mode"))
                option = "--modem-mode";
            else if (!strcmp(key, "timing"))
                option = "--timing";
            else if (!strcmp(key, "mouse_speed"))
                option = "--mouse-speed";
            else if (!strcmp(key, "boot"))
                option = "--boot";
            else if (!strcmp(key, "rom"))
                option = "--rom";
            else if (!strcmp(key, "qsound_rom"))
                option = "--qsound-rom";
            else if (!strcmp(key, "mount") || !strcmp(key, "mount1"))
                option = "--mount";
            else if (strlen(key) == 6 && !strncmp(key, "mount", 5) && key[5] >= '2' &&
                     key[5] <= '8') {
                if (v >= 190)
                    goto bad;
                snprintf(values[v], 4096, "--%s", key);
                option = values[v++];
            } else if (!strcmp(key, "qsound")) {
                if (!strcmp(value, "true") || !strcmp(value, "1"))
                    option = "--qsound";
                else if (!strcmp(value, "false") || !strcmp(value, "0"))
                    option = "--no-qsound";
                else
                    goto bad;
                if (n >= 300)
                    goto bad;
                expanded[n++] = (char *)option;
                continue;
            } else if (!strcmp(key, "mouse")) {
                if (!strcmp(value, "true") || !strcmp(value, "1"))
                    option = "--mouse";
                else if (!strcmp(value, "false") || !strcmp(value, "0"))
                    option = "--no-mouse";
                else
                    goto bad;
                if (n >= 300)
                    goto bad;
                expanded[n++] = (char *)option;
                continue;
            } else if (!strcmp(key, "mute")) {
                if (!strcmp(value, "true") || !strcmp(value, "1"))
                    option = "--mute";
                else if (!strcmp(value, "false") || !strcmp(value, "0"))
                    option = "--sound";
                else
                    goto bad;
                if (n >= 300)
                    goto bad;
                expanded[n++] = (char *)option;
                continue;
            } else
                goto bad;
            if (n >= 300 || v >= 191)
                goto bad;
            strcpy(values[v], value);
            expanded[n++] = (char *)option;
            expanded[n++] = values[v++];
        }
        if (ferror(f))
            goto bad;
        fclose(f);
    }
    for (i = 1; i < *argc; i++) {
        if (!strcmp((*argv)[i], "--")) {
            while (i < *argc) {
                if (n >= 511)
                    return 0;
                expanded[n++] = (*argv)[i++];
            }
            break;
        }
        if (!strcmp((*argv)[i], "--config")) {
            i++;
            continue;
        }
        if (!strcmp((*argv)[i], "--no-config"))
            continue;
        if (n >= 511)
            return 0;
        expanded[n++] = (*argv)[i];
    }
    expanded[n] = NULL;
    *argc = n;
    *argv = expanded;
    return 1;
bad:
    fprintf(stderr, "%s:%d: invalid configuration entry\n", file, line);
    fclose(f);
    return 0;
}
static volatile sig_atomic_t interrupted;
/**
 * interrupt_run
 *
 * Record a host signal in the signal-safe interruption flag; normal loop cleanup handles
 * termination.
 */
static void interrupt_run(int sig) {
    (void)sig;
    interrupted = 1;
}
/**
 * default_rom
 *
 * Probe supported working-directory and executable-relative locations for the bundled ROM,
 * writing candidate paths into the caller buffer.
 */
static const char *default_rom(const char *argv0, char *out, size_t cap) {
    char exe[4096];
    char *p;
    size_t n;
    int depth;
    FILE *f;
#ifdef _WIN32
    DWORD got = GetModuleFileNameA(NULL, exe, sizeof(exe));
    if (!got || got >= sizeof(exe))
        exe[0] = 0;
#elif defined(__APPLE__)
    uint32_t size = sizeof(exe);
    if (_NSGetExecutablePath(exe, &size))
        exe[0] = 0;
#elif defined(__linux__)
    ssize_t got = readlink("/proc/self/exe", exe, sizeof(exe) - 1);
    if (got < 0)
        exe[0] = 0;
    else
        exe[got] = 0;
#else
    exe[0] = 0;
#endif
    if (!exe[0])
        snprintf(exe, sizeof(exe), "%s", argv0);
    p = NULL;
    for (n = 0; exe[n]; n++)
        if (exe[n] == '/' || exe[n] == '\\')
            p = exe + n;
    if (p) {
        *p = 0;
        for (depth = 0; depth < 3; depth++) {
            int len = snprintf(out, cap, "%s/%srom/js-rom.bin", exe,
                               depth == 0   ? ""
                               : depth == 1 ? "../"
                                            : "../../");
            if (len >= 0 && (size_t)len < cap && (f = fopen(out, "rb"))) {
                fclose(f);
                return out;
            }
        }
    }
    return "rom/js-rom.bin";
}
/**
 * usage
 *
 * Print the command-line interface and exit conventions implemented by this build.
 */
static void usage(void) {
    puts("QLBox R21 - Musashi Sinclair QL\n"
         "  --rom FILE       64 KiB QLBox ROM (default rom/js-rom.bin)\n"
         "  --mount PATH     directory or QL image as WIN1_/HOST1_/FLP1_/MDV1_\n"
         "  --ram KIB        RAM size, 128..640 in steps of 64 (default 128)\n"
         "  --timing MODE   fast (default), 68008 bus, or ql bus+RAM contention\n"
         "  --speed N        CPU multiplier 1..64, timer stays 50 Hz (default 1)\n"
         "  SDL hotkeys: Ctrl+F11 slower, Ctrl+F12 faster, Ctrl+F10 reset to 1x\n"
         "  --boot f1|f2     startup layout (default f2/TV)\n"
         "  --run FILE       run one QDOS executable in the host terminal, then exit\n"
         "  --args TEXT      raw QDOS command tail (or append -- followed by arguments)\n"
         "  --headless       no SDL window; runs without real-time pacing\n"
         "  --mount2..8 PATH additional drives (images are read-only)\n"
         "  --config FILE    read key=value settings (default ./qlbox.conf)\n"
         "  --no-config      ignore configuration; CLI overrides config\n"
         "  --gdb PORT      localhost GDB remote debugger\n"
         "  --gdb-wait      pause CPU before first instruction\n"
         "  --debug-log FILE guest diagnostic output (default stderr)\n"
         "  --frames N       stop after N emulated 50 Hz frames\n"
         "  --type FILE      type ASCII text through IPC after boot\n"
         "  --type-at N      start typing at frame N (default 500)\n"
         "  --dump FILE      save final 512x256 screen as PPM\n"
         "  --ram-dump FILE  save complete 1 MiB address-space backing array\n"
         "  --mouse-speed N relative mouse gain 1..8; capture requires guest polling\n"
         "  --no-mouse       disable QIMSI mouse; Ctrl+F9 captures/releases\n"
         "  --modem PORT    Hayes modem on ser1, ser2 (default), or off\n"
         "  --modem-mode MODE  telnet (default) or raw TCP; ATDT host[:port]\n"
         "  --qsound-rom FILE  map QSound firmware at 0xC0000 before boot\n"
         "  --no-qsound      disable the QSound AY interface (enabled by default)\n"
         "  --mute           disable host audio output (guest sound chips still run)\n"
         "  --trace          log initial IPC exchanges\n"
         "Default: TV; --boot f1: monitor. F12: quit. Ctrl+Space: QL break.\n"
         "Text runner: qlbox --run host/HELLO_EXE; pipe stdin/stdout as normal.");
}
/**
 * main
 *
 * Parse startup options, initialize the guest and optional SDL/GDB services, then run the
 * presentation or terminal loop. Finalize dumps, status and resources and return the guest/host
 * result.
 */
int main(int argc, char **argv) {
    const char *mount = "host", *run = NULL, *args = "", *mounts[8] = {0};
    char run_mount[4096], rom_path[4096], run_name[44], joined[1024] = "";
    int qsound_enabled = 1, mouse_enabled = 1;
    unsigned mouse_speed = 2;
    int mount_set = 0, gdb_wait = 0;
    unsigned gdb_port = 0;
    const char *debug_log = NULL;
    const char *qsound_rom = NULL;
    const char *rom = NULL, *dump = NULL, *ramdump = NULL, *type = NULL;
    unsigned timing = 0, modem_port = 2;
    int modem_telnet = 1;
    unsigned speed = 1, frames = 0, ram = 128, boot = 0, type_at = 500, typed = 0, next_type = 0;
    int mute = 0, headless = 0, trace = 0, i, done = 0, result = 0;
    FILE *input = NULL;
#ifdef QLBOX_SDL
    SDL_AudioDeviceID audio_device = 0;
    SDL_Window *window = NULL;
    SDL_Renderer *renderer = NULL;
    SDL_Texture *texture = NULL;
    static uint32_t pixels[512 * 256];
    Uint32 deadline = 0;
#endif
    if (!config_args(&argc, &argv))
        return 2;
    for (i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (a[0] != '-' && !run) {
            run = a;
            continue;
        }
        if (!strcmp(a, "--help") || !strcmp(a, "-h")) {
            usage();
            return 0;
        }
        if (!strcmp(a, "--")) {
            size_t n = 0;
            int j;
            for (j = i + 1; j < argc; j++) {
                size_t len = strlen(argv[j]);
                if (n + len + (j > i + 1) >= sizeof(joined)) {
                    fprintf(stderr, "Command tail too long\n");
                    return 2;
                }
                if (j > i + 1)
                    joined[n++] = ' ';
                memcpy(joined + n, argv[j], len + 1);
                n += len;
            }
            args = joined;
            break;
        }
        if (!strcmp(a, "--gdb-wait")) {
            gdb_wait = 1;
            continue;
        }
        if (!strcmp(a, "--sound")) {
            mute = 0;
            continue;
        }
        if (!strcmp(a, "--mute")) {
            mute = 1;
            continue;
        }
        if (!strcmp(a, "--qsound")) {
            qsound_enabled = 1;
            continue;
        }
        if (!strcmp(a, "--no-qsound")) {
            qsound_enabled = 0;
            continue;
        }
        if (!strcmp(a, "--mouse")) {
            mouse_enabled = 1;
            continue;
        }
        if (!strcmp(a, "--no-mouse")) {
            mouse_enabled = 0;
            continue;
        }
        if (!strcmp(a, "--headless")) {
            headless = 1;
            continue;
        }
        if (!strcmp(a, "--trace")) {
            trace = 1;
            continue;
        }
        if (i + 1 >= argc) {
            usage();
            return 2;
        }
        if (!strcmp(a, "--mouse-speed")) {
            char *end;
            unsigned long n = strtoul(argv[++i], &end, 10);
            if (!*argv[i] || *end || n < 1 || n > 8) {
                fprintf(stderr, "--mouse-speed expects 1..8\n");
                return 2;
            }
            mouse_speed = (unsigned)n;
        } else if (!strcmp(a, "--mount")) {
            mount = argv[++i];
            mount_set = 1;
        } else if (strlen(a) == 8 && !strncmp(a, "--mount", 7) && a[7] >= '2' && a[7] <= '8')
            mounts[a[7] - '1'] = argv[++i];
        else if (!strcmp(a, "--run"))
            run = argv[++i];
        else if (!strcmp(a, "--args"))
            args = argv[++i];
        else if (!strcmp(a, "--gdb")) {
            char *end;
            unsigned long port = strtoul(argv[++i], &end, 10);
            if (!*argv[i] || *end || port < 1 || port > 65535) {
                fprintf(stderr, "--gdb needs a port from 1 to 65535\n");
                return 2;
            }
            gdb_port = (unsigned)port;
        } else if (!strcmp(a, "--debug-log"))
            debug_log = argv[++i];
        else if (!strcmp(a, "--rom"))
            rom = argv[++i];
        else if (!strcmp(a, "--qsound-rom"))
            qsound_rom = argv[++i];
        else if (!strcmp(a, "--dump"))
            dump = argv[++i];
        else if (!strcmp(a, "--ram-dump"))
            ramdump = argv[++i];
        else if (!strcmp(a, "--type"))
            type = argv[++i];
        else if (!strcmp(a, "--modem")) {
            const char *port = argv[++i];
            if (!strcmp(port, "off")) modem_port = 0;
            else if (!strcmp(port, "ser1")) modem_port = 1;
            else if (!strcmp(port, "ser2")) modem_port = 2;
            else { fprintf(stderr, "--modem expects off, ser1, or ser2\n"); return 2; }
        } else if (!strcmp(a, "--modem-mode")) {
            const char *mode = argv[++i];
            if (!strcmp(mode, "raw")) modem_telnet = 0;
            else if (!strcmp(mode, "telnet")) modem_telnet = 1;
            else { fprintf(stderr, "--modem-mode expects raw or telnet\n"); return 2; }
        } else if (!strcmp(a, "--timing")) {
            const char *mode = argv[++i];
            if (!strcmp(mode, "fast"))
                timing = 0;
            else if (!strcmp(mode, "68008"))
                timing = 1;
            else if (!strcmp(mode, "ql"))
                timing = 2;
            else {
                fprintf(stderr, "--timing expects fast, 68008, or ql\n");
                return 2;
            }
        } else if (!strcmp(a, "--speed")) {
            char *end;
            unsigned long v = strtoul(argv[++i], &end, 10);
            if (!*argv[i] || *end || v < 1 || v > 64) {
                fprintf(stderr, "--speed expects an integer from 1 to 64\n");
                return 2;
            }
            speed = (unsigned)v;
        } else if (!strcmp(a, "--ram"))
            ram = (unsigned)strtoul(argv[++i], NULL, 0);
        else if (!strcmp(a, "--frames"))
            frames = (unsigned)strtoul(argv[++i], NULL, 0);
        else if (!strcmp(a, "--type-at"))
            type_at = (unsigned)strtoul(argv[++i], NULL, 0);
        else if (!strcmp(a, "--boot")) {
            a = argv[++i];
            if (!strcmp(a, "f1"))
                boot = 0x39;
            else if (!strcmp(a, "f2"))
                boot = 0x3b;
            else {
                fprintf(stderr, "--boot expects f1 or f2\n");
                return 2;
            }
        } else {
            fprintf(stderr, "Unknown option: %s\n", a);
            return 2;
        }
    }
    (void)mute; /* no audio device in the standalone CLI build */
    if (!rom)
        rom = default_rom(argv[0], rom_path, sizeof(rom_path));
    if (!run && *args) {
        fprintf(stderr, "Command arguments require --run\n");
        return 2;
    }
    if (run) {
        const char *base = run, *p;
        if (type) {
            fprintf(stderr, "--run and --type cannot be combined\n");
            return 2;
        }
        for (p = run; *p; p++)
            if (*p == '/' || *p == '\\')
                base = p + 1;
        if (base != run) {
            size_t n = (size_t)(base - run);
            if (mount_set) {
                fprintf(stderr,
                        "Use a guest filename with --mount, or a host path without --mount\n");
                return 2;
            }
            if (n >= sizeof(run_mount)) {
                fprintf(stderr, "Mount path too long\n");
                return 2;
            }
            memcpy(run_mount, run, n);
            run_mount[n] = 0;
            mount = run_mount;
        }
        if (strlen(base) > 5 &&
            ((tolower((unsigned char)base[0]) == 'w' && tolower((unsigned char)base[1]) == 'i' &&
              tolower((unsigned char)base[2]) == 'n') ||
             (tolower((unsigned char)base[0]) == 'f' && tolower((unsigned char)base[1]) == 'l' &&
              tolower((unsigned char)base[2]) == 'p') ||
             (tolower((unsigned char)base[0]) == 'm' && tolower((unsigned char)base[1]) == 'd' &&
              tolower((unsigned char)base[2]) == 'v')) &&
            base[3] >= '1' && base[3] <= '8' && base[4] == '_' && base == run)
            base += 5;
        else if (strlen(base) > 6 && tolower((unsigned char)base[0]) == 'h' &&
                 tolower((unsigned char)base[1]) == 'o' && tolower((unsigned char)base[2]) == 's' &&
                 tolower((unsigned char)base[3]) == 't' && base[4] >= '1' && base[4] <= '8' &&
                 base[5] == '_' && base == run)
            base += 6;
        if (!*base || strlen(base) > 36 || strlen(args) > 1023) {
            fprintf(stderr, "Filename or command tail too long/empty\n");
            return 2;
        }
        if (base != run && (base - run == 5 || base - run == 6) && !strchr(run, '/') &&
            !strchr(run, '\\'))
            snprintf(run_name, sizeof(run_name), "%s", run);
        else if (base == run && strlen(base) > 5 && tolower((unsigned char)base[0]) == 'r' &&
                 tolower((unsigned char)base[1]) == 'o' && tolower((unsigned char)base[2]) == 'm' &&
                 base[3] >= '1' && base[3] <= '8' && base[4] == '_')
            snprintf(run_name, sizeof(run_name), "%s", base);
        else
            snprintf(run_name, sizeof(run_name), "WIN1_%s", base);
        headless = 1;
    }
#ifndef QLBOX_SDL
    if (!headless) {
        fprintf(stderr, "This build has no SDL2; use --headless --frames N\n");
        return 2;
    }
#endif
    if (headless && !frames && !run && !gdb_port)
        frames = 1000;
    if (type && !(input = fopen(type, "rb"))) {
        perror(type);
        return 1;
    }
    if (!hostfs_init(mount)) {
        if (input)
            fclose(input);
        return 1;
    }
    for (i = 1; i < 8; i++)
        if (mounts[i] && !hostfs_mount((unsigned)i + 1, mounts[i])) {
            fprintf(stderr, "Cannot mount WIN%d_: %s\n", i + 1, mounts[i]);
            return 2;
        }
    if (!ql_init(rom, ram, trace)) {
        if (input)
            fclose(input);
        hostfs_shutdown();
        return 1;
    }
    if (qsound_rom && !ql_load_qsound_rom(qsound_rom)) {
        if (input)
            fclose(input);
        hostfs_shutdown();
        return 1;
    }
    ql_set_timing(timing);
    if (!debugger_init(gdb_port, gdb_wait, debug_log)) {
        fprintf(stderr, "Debugger/log setup failed (--gdb-wait requires --gdb)\n");
        return 2;
    }
    ql.speed = speed;
    ql.mouse.enabled = (unsigned)mouse_enabled;
    ql.qsound.enabled = (unsigned)qsound_enabled;
    (void)mouse_speed;
    if (run && memcmp(ql.mem + 0xfff0, "QLBOX-R4", 8)) {
        fprintf(stderr, "--run requires the QLBox R4 ROM\n");
        hostfs_shutdown();
        return 2;
    }
    terminal_init();
    if (!modem_init(modem_port, modem_telnet)) {
        fprintf(stderr, "Cannot initialize modem networking\n");
        hostfs_shutdown(); debugger_close(); return 2;
    }
    if (run) {
        ql.run_enabled = 1;
        strcpy(ql.run_name, run_name);
        strcpy(ql.run_args, args);
        signal(SIGINT, interrupt_run);
        signal(SIGTERM, interrupt_run);
    }
    ql.boot_mode = boot == 0x39 ? 0xe8 : 0xec;
#ifdef QLBOX_SDL
    if (!headless) {
        SDL_SetMainReady();
        if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0)
            goto sdl_fail;
        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "0");
        SDL_StartTextInput();
        window = SDL_CreateWindow("QLBox R21 - Sinclair QL", SDL_WINDOWPOS_CENTERED,
                                  SDL_WINDOWPOS_CENTERED, 1024, 512,
                                  SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
        if (!window)
            goto sdl_fail;
        ql_sdl_mouse_speed(mouse_speed);
        speed_title(window);
        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
        if (!renderer)
            renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE);
        if (!renderer)
            goto sdl_fail;
        SDL_RenderSetLogicalSize(renderer, 512, 256);
        texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING,
                                    512, 256);
        if (!texture)
            goto sdl_fail;
        if (!mute && SDL_InitSubSystem(SDL_INIT_AUDIO) == 0) {
            SDL_AudioSpec desired, obtained;
            SDL_zero(desired);
            desired.freq = QL_AUDIO_RATE;
            desired.format = AUDIO_S16SYS;
            desired.channels = 1;
            desired.samples = 1024;
            audio_device = SDL_OpenAudioDevice(NULL, 0, &desired, &obtained, 0);
            if (audio_device) {
                int16_t silence[QL_AUDIO_FRAME * 2] = {0};
                SDL_QueueAudio(audio_device, silence, sizeof(silence));
                SDL_PauseAudioDevice(audio_device, 0);
            } else
                fprintf(stderr, "Audio unavailable: %s\n", SDL_GetError());
        } else if (!mute)
            fprintf(stderr, "Audio unavailable: %s\n", SDL_GetError());
        deadline = SDL_GetTicks();
    }
#endif
    next_type = type_at;
    while (!done && !interrupted && (!frames || ql.frame < frames)) {
        if (run)
            terminal_poll();
#ifdef QLBOX_SDL
        if (!headless) {
            SDL_Event e;
            if (ql_sdl_mouse_update())
                speed_title(window);
            while (SDL_PollEvent(&e)) {
                if (ql_sdl_mouse(&e)) {
                    speed_title(window);
                    continue;
                }
                if (e.type == SDL_WINDOWEVENT && e.window.event == SDL_WINDOWEVENT_FOCUS_LOST)
                    speed_title(window);
                if (ql_sdl_speed_control(&e)) {
                    speed_title(window);
                    continue;
                }
                if (e.type == SDL_QUIT)
                    done = 1;
                if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_F12)
                    done = 1;
                ql_sdl_input(&e);
            }
        }
#endif
        /* Layout is read by the ROM; no fake key is queued. */
        if (input && ql.basic_ready && ql.frame >= next_type) {
            int c = fgetc(input);
            if (c == EOF) {
                if (ferror(input))
                    result = 1;
                fclose(input);
                input = NULL;
            } else if (c != '\r') {
                if (!ql_type((unsigned char)c)) {
                    fprintf(stderr, "Unsupported script byte %02x\n", c);
                    result = 1;
                    done = 1;
                }
                typed++;
                next_type = ql.frame + ((c == '\n') ? 40 : 4);
            }
        }
        modem_poll();
        ql_frame();
        if (ql.exit_requested)
            break;
        if (run && ql.run_done)
            done = 1;
#ifdef QLBOX_SDL
        if (!headless) {
            if (audio_device) {
                /* Bound latency if the host falls behind; never grow an unbounded queue. */
                if (SDL_GetQueuedAudioSize(audio_device) > QL_AUDIO_RATE * 2 / 10)
                    SDL_ClearQueuedAudio(audio_device);
                if (SDL_QueueAudio(audio_device, ql.audio, sizeof(ql.audio)) < 0) {
                    fprintf(stderr, "Audio queue: %s\n", SDL_GetError());
                    SDL_CloseAudioDevice(audio_device);
                    audio_device = 0;
                }
            }
            ql_render(pixels);
            SDL_UpdateTexture(texture, NULL, pixels, 512 * 4);
            SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
            SDL_RenderClear(renderer);
            SDL_RenderCopy(renderer, texture, NULL, NULL);
            SDL_RenderPresent(renderer);
            deadline += 20;
            {
                Sint32 delay = (Sint32)(deadline - SDL_GetTicks());
                if (delay > 0)
                    SDL_Delay((Uint32)delay);
                else if (delay < -200)
                    deadline = SDL_GetTicks();
            }
        }
#endif
    }
    debugger_close();
    if (!run || trace)
        ql_status();
    if (run) {
        if (interrupted)
            result = 130;
        else if (ql.exit_requested)
            result = 0;
        else if (!ql.run_done) {
            fprintf(stderr, "QLBox: frame limit reached before job completion\n");
            result = 124;
        } else if (ql.run_status) {
            int64_t code = ql.run_status;
            fprintf(stderr, "QLBox: QDOS status %ld\n", (long)ql.run_status);
            if (code < 0)
                code = -code;
            result = code > 255 ? 255 : (int)code;
        }
    }
    if (input) {
        if (!ql.exit_requested) {
            fprintf(stderr, "Script not fully consumed (%u bytes typed)\n", typed);
            result = 1;
        }
        fclose(input);
    }
    if (dump && !ql_ppm(dump)) {
        perror(dump);
        result = 1;
    }
    if (ramdump && !ql_dump(ramdump)) {
        perror(ramdump);
        result = 1;
    }
#ifdef QLBOX_SDL
    if (audio_device)
        SDL_CloseAudioDevice(audio_device);
    if (texture)
        SDL_DestroyTexture(texture);
    if (renderer)
        SDL_DestroyRenderer(renderer);
    if (window)
        SDL_DestroyWindow(window);
    SDL_Quit();
#endif
    modem_shutdown();
    hostfs_shutdown();
    return result;
#ifdef QLBOX_SDL
sdl_fail:
    fprintf(stderr, "SDL: %s\n", SDL_GetError());
    if (input)
        fclose(input);
    if (audio_device)
        SDL_CloseAudioDevice(audio_device);
    if (texture)
        SDL_DestroyTexture(texture);
    if (renderer)
        SDL_DestroyRenderer(renderer);
    if (window)
        SDL_DestroyWindow(window);
    SDL_Quit();
    modem_shutdown();
    hostfs_shutdown();
    return 1;
#endif
}
