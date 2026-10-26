/* QLBox machine layer. IPC protocol and keyboard numbering informed by
 * QLAY, Copyright Jan Venema 1997-1999; see docs/QLAY-LICENSE.txt. */
#include "ql.h"
#include "hostfs.h"
#include "terminal.h"
#include "modem.h"
#include "debugger.h"
#include "rom_symbols.h"
#include "m68k.h"
#include <stdio.h>
#include <string.h>
#include <time.h>
QL ql;
/**
 * irq_update
 *
 * Drive Musashi interrupt level 2 when any emulated pending source is set; otherwise deassert
 * the CPU interrupt input.
 */
static void irq_update(void) {
    m68k_set_irq((ql.irq & 31) ? 2 : 0);
}
/**
 * irq_ack
 *
 * Count a CPU interrupt acknowledgement and request the standard autovector. Guest I/O
 * acknowledges the pending hardware sources separately.
 */
static int irq_ack(int level) {
    (void)level;
    ql.irq_acks++;
    return M68K_INT_ACK_AUTOVECTOR;
}
/**
 * held_keys
 *
 * Report whether a non-modifier key remains held for the IPC repeat/status protocol.
 */
static unsigned held_keys(void) {
    unsigned i;
    for (i = 3; i < 64; i++)
        if (ql.repeat[i])
            return 1;
    return 0;
}
/**
 * reply
 *
 * Latch a serial IPC response and the number of bits remaining to be shifted out.
 */
static void reply(unsigned value, unsigned bits) {
    ql.ipc_reply = value;
    ql.ipc_bits = bits;
}
/**
 * ipc_command
 *
 * Interpret a completed IPC command nibble or its pending parameter. Implements
 * keyboard/status/test exchanges and functional beeper control rather than executing an 8049
 * ROM.
 */
static void ipc_command(unsigned cmd) {
    unsigned i, row, value = 0;
    if (ql.ipc_param) {
        switch (ql.ipc_param) {
        case 9:
            row = (7 - (cmd & 7)) * 8;
            for (i = 0; i < 8; i++)
                if (ql.held[row + i])
                    value |= 1u << i;
            if (row == 0)
                value |= ((ql.modifiers >> 10) & 1) | ((ql.modifiers >> 8) & 2) |
                         ((ql.modifiers >> 6) & 4);
            reply(value, 8);
            ql.ipc_param = 0;
            break;
        case 10:
            ql.beep_packet[ql.ipc_count++] = cmd;
            if (ql.ipc_count == 16) {
                ql.ipc_param = 0;
                ql_beeper_start(&ql.beeper, ql.beep_packet);
            }
            break;
        case 15:
            ql.ipc_test = (ql.ipc_test << 4) | cmd;
            if (++ql.ipc_count == 2) {
                reply(ql.ipc_test, 8);
                ql.ipc_param = 0;
            }
            break;
        default:
            ql.ipc_param = 0;
            break;
        }
        return;
    }
    ql.ipc_commands[cmd]++;
    if (ql.trace && ql.ipc_commands[cmd] < 5)
        fprintf(stderr, "[ipc] cmd=%x pc=%06x\n", cmd, m68k_get_reg(NULL, M68K_REG_PC));
    switch (cmd) {
    case 1:
        reply(((ql.key_in != ql.key_out || held_keys()) ? 1 : 0) | (ql.beeper.active ? 2 : 0), 8);
        break;
    case 11:
        ql_beeper_stop(&ql.beeper);
        break;
    case 6:
    case 7:
        reply(0, 8);
        break;
    case 8:
        if (ql.key_out != ql.key_in) {
            value = ql.keys[ql.key_out++ & 255];
            ql.key_delivered++;
            reply(0x1000 | value, 16);
        } else
            reply(held_keys() ? 8 : 0, 4);
        break;
    case 9:
    case 10:
    case 12:
    case 13:
    case 15:
        ql.ipc_param = cmd;
        ql.ipc_count = 0;
        ql.ipc_test = 0;
        break;
    case 14:
        reply(0xabcd, 16);
        break;
    default:
        break;
    }
}
/**
 * ipc_write
 *
 * Advance the serial IPC handshake: shift a reply bit when one is pending, otherwise collect
 * four incoming bits into a command nibble.
 */
static void ipc_write(unsigned v) {
    if (ql.ipc_bits) {
        /* ROM reads acknowledgement first, then the serial data bit. */
        ql.ipc_latch = ((ql.ipc_reply >> --ql.ipc_bits) & 1) << 7;
        ql.ipc_reads = 2;
    } else if ((v & 12) == 12) {
        ql.ipc_nibble = (ql.ipc_nibble << 1) | ((v == 12) ? 0 : 1);
        if (++ql.ipc_nbits == 4) {
            unsigned cmd = ql.ipc_nibble & 15;
            ql.ipc_nbits = ql.ipc_nibble = 0;
            ipc_command(cmd);
        }
    }
}
/* Hardware-derived bus slots; see docs/TIMING.md for phase limitations. */
/**
 * ql_ram_wait
 *
 * Calculate clocks until a permitted onboard-RAM transfer slot at the supplied horizontal clock
 * phase. This is the experimental contention model, not a raster renderer.
 */
unsigned ql_ram_wait(uint64_t clock) {
    unsigned x = (unsigned)(clock % 480);
    if (x < 384) {
        unsigned phase = x % 12;
        return phase <= 8 ? 8 - phase : (x >= 380 ? 384 - x : 20 - phase);
    }
    /* A four-clock access must finish before the next reserved slot. */
    return x <= 476 ? 0 : 488 - x;
}
/**
 * timing_begin
 *
 * Mark the start of an execution group and reset its bus cursor and additional-cycle
 * accumulator.
 */
static void timing_begin(void) {
    ql.timing_active = 1;
    ql.timing_cursor = ql.timing_clock;
    ql.timing_extra = 0;
}
/**
 * timing_end
 *
 * Finish timing an execution group, padding it if scheduled bus transfers outlast the core-
 * reported cycles, then advance the absolute clock.
 */
static void timing_end(unsigned elapsed) {
    /* Some 68000 handlers hide bus/prefetch details. Do not let a scheduled
  * transfer finish after its instruction in this approximate model. */
    uint64_t bus = ql.timing_cursor - ql.timing_clock;
    if (bus > elapsed) {
        unsigned pad = (unsigned)(bus - elapsed);
        m68k_add_wait_cycles(pad);
        elapsed += pad;
    }
    ql.timing_clock += elapsed;
    ql.timing_active = 0;
}
/**
 * ql_set_timing
 *
 * Select fast, bus-only or contended timing, reset all accounting and install or remove the
 * Musashi cycle callbacks.
 */
void ql_set_timing(unsigned mode) {
    ql.timing = mode;
    ql.timing_active = 0;
    ql.timing_clock = ql.timing_cursor = 0;
    ql.timing_bus_extra = ql.timing_ram_wait = 0;
    ql.timing_extra = 0;
    ql.timing_debt = 0;
    m68k_set_cycle_callbacks(mode ? timing_begin : NULL, mode ? timing_end : NULL);
}
/**
 * timing_access
 *
 * Charge one CPU memory transfer for external byte-bus width and, in ql mode, onboard-RAM
 * contention. Inspection outside an active execution group is not charged.
 */
static void timing_access(unsigned address, unsigned bytes) {
    unsigned i, extra = bytes == 1 ? 0 : bytes * 2;
    if (!ql.timing_active)
        return;
    ql.timing_bus_extra += extra;
    for (i = 0; i < bytes; i++) {
        unsigned a = (address + i) & 0xfffff, wait = 0;
        if (ql.timing == 2 && a >= 0x20000 && a < 0x40000)
            wait = ql_ram_wait(ql.timing_cursor);
        ql.timing_ram_wait += wait;
        extra += wait;
        ql.timing_cursor += 4 + wait;
    }
    ql.timing_extra += extra;
    m68k_add_wait_cycles(extra);
}
/**
 * raw_read8
 *
 * Decode one 20-bit bus address without adding timing. Reads of IPC and mouse registers may
 * consume device state; unmapped addresses return 0xff.
 */
static unsigned raw_read8(unsigned a) {
    a &= 0xfffff;
    if (a >= 0xc2000 && a <= 0xc2003)
        return ql_qsound_read(&ql.qsound, a - 0xc2000);
    if (a >= 0xfedd && a <= 0xfedf && ql.mouse.enabled) {
        ql_mouse_note_read(&ql.mouse, ql.frame);
        return ql_mouse_read(&ql.mouse, a, 1);
    }
    if (a >= 0xc0000 && a < 0xc0000 + ql.qsound_rom_size)
        return ql.mem[a];
    if (a < ql.rom_size || (a >= 0x20000 && a < ql.ram_top))
        return ql.mem[a];
    if (a >= 0x18110 && a < 0x18114)
        return (ql.ram_top >> (8 * (0x18113 - a))) & 255;
    if (a == 0x18114)
        return ql.boot_mode;
    if (a == 0x18115)
        return ql.run_enabled;
    if (a >= 0x18200 && a < 0x18200 + 46) {
        unsigned n = (unsigned)strlen(ql.run_name), off = a - 0x18200;
        return off < 2       ? (n >> (8 * (1 - off))) & 255
               : off - 2 < n ? (unsigned char)ql.run_name[off - 2]
                             : 0;
    }
    if (a >= 0x18300 && a < 0x18702) {
        unsigned n = (unsigned)strlen(ql.run_args), off = a - 0x18300;
        return off < 2       ? (n >> (8 * (1 - off))) & 255
               : off - 2 < n ? (unsigned char)ql.run_args[off - 2]
                             : 0;
    }
    if (a >= 0x18000 && a <= 0x18003) {
        unsigned t = ql.clock_base + ql.frame / 50;
        return (t >> (8 * (3 - (a & 3)))) & 255;
    }
    if (a == 0x18020) {
        if (ql.ipc_reads)
            return (--ql.ipc_reads) ? 0 : ql.ipc_latch;
        return 0; /* no serial receive data / no microdrive media */
    }
    if (a == 0x18021)
        return ql.irq;
    return 0xff;
}
/**
 * m68k_read_memory_8
 *
 * Musashi CPU callback: charge a 8-bit transfer and read guest bytes in big-endian order.
 */
unsigned int m68k_read_memory_8(unsigned a) {
    timing_access(a, 1);
    return raw_read8(a);
}
/**
 * m68k_read_memory_16
 *
 * Musashi CPU callback: charge a 16-bit transfer and read guest bytes in big-endian order.
 */
unsigned int m68k_read_memory_16(unsigned a) {
    timing_access(a, 2);
    return (raw_read8(a) << 8) | raw_read8(a + 1);
}
/**
 * m68k_read_memory_32
 *
 * Musashi CPU callback: charge a 32-bit transfer and read guest bytes in big-endian order.
 */
unsigned int m68k_read_memory_32(unsigned a) {
    timing_access(a, 4);
    return (raw_read8(a) << 24) | (raw_read8(a + 1) << 16) | (raw_read8(a + 2) << 8) |
           raw_read8(a + 3);
}
/**
 * m68k_read_disassembler_8
 *
 * Musashi inspection callback: read 8 bits without CPU timing charges or consuming mouse
 * reports. Other mapped reads retain raw device-read semantics.
 */
unsigned int m68k_read_disassembler_8(unsigned a) {
    a &= 0xfffff;
    if (a >= 0xfedd && a <= 0xfedf && ql.mouse.enabled)
        return ql_mouse_read(&ql.mouse, a, 0);
    return raw_read8(a);
}
/**
 * m68k_read_disassembler_16
 *
 * Musashi inspection callback: read 16 bits without CPU timing charges or consuming mouse
 * reports. Other mapped reads retain raw device-read semantics.
 */
unsigned int m68k_read_disassembler_16(unsigned a) {
    return (m68k_read_disassembler_8(a) << 8) | m68k_read_disassembler_8(a + 1);
}
/**
 * m68k_read_disassembler_32
 *
 * Musashi inspection callback: read 32 bits without CPU timing charges or consuming mouse
 * reports. Other mapped reads retain raw device-read semantics.
 */
unsigned int m68k_read_disassembler_32(unsigned a) {
    return (m68k_read_disassembler_16(a) << 16) | m68k_read_disassembler_16(a + 2);
}
/**
 * raw_write8
 *
 * Decode one byte write to RAM, hardware or the ROM/host bridge. ROM writes are ignored; bridge
 * command writes dispatch the prepared request immediately.
 */
static void raw_write8(unsigned a, unsigned v) {
    a &= 0xfffff;
    v &= 255;
    if (a >= 0xc2000 && a <= 0xc2003) {
        ql_qsound_write(&ql.qsound, a - 0xc2000, v);
        return;
    }
    if (a == 0x18122) {
        if (v == 1) {
            ql.exit_requested = 1;
            m68k_end_timeslice();
        }
        return;
    }
    if (a == 0x18120) {
        debugger_output(v);
        return;
    }
    if (a == 0x18121) {
        debugger_control(v);
        return;
    }
    if (a >= 0x20000 && a < ql.ram_top) {
        ql.mem[a] = (uint8_t)v;
        return;
    }
    if (a >= 0x18104 && a < 0x18108) {
        unsigned shift = 8 * (0x18107 - a);
        ql.host_request = (ql.host_request & ~(255u << shift)) | (v << shift);
        return;
    }
    if (a >= 0x18118 && a < 0x1811c) {
        unsigned shift = 8 * (0x1811b - a);
        ql.run_status = (int32_t)(((uint32_t)ql.run_status & ~(255u << shift)) | (v << shift));
        return;
    }
    switch (a) {
    case 0x18116:
        ql.run_active = v;
        break;
    case 0x1811c:
        ql.run_done = v;
        break;
    case 0x18100:
        if (!modem_command(v, ql.host_request) && !terminal_command(v, ql.host_request))
            hostfs_command(v, ql.host_request);
        break;
    case 0x18003:
        ipc_write(v);
        break;
    case 0x18021:
        ql.irq = (ql.irq & ~(v & 31) & 31) | (v & 224);
        irq_update();
        break;
    case 0x18063:
        ql.video = v;
        break;
    default:
        break;
    }
}
/**
 * m68k_write_memory_8
 *
 * Musashi CPU callback: charge a 8-bit transfer and dispatch its bytes in big-endian order.
 */
void m68k_write_memory_8(unsigned a, unsigned v) {
    timing_access(a, 1);
    raw_write8(a, v);
}
/**
 * m68k_write_memory_16
 *
 * Musashi CPU callback: charge a 16-bit transfer and dispatch its bytes in big-endian order.
 */
void m68k_write_memory_16(unsigned a, unsigned v) {
    timing_access(a, 2);
    raw_write8(a, v >> 8);
    raw_write8(a + 1, v);
}
/**
 * m68k_write_memory_32
 *
 * Musashi CPU callback: charge a 32-bit transfer and dispatch its bytes in big-endian order.
 */
void m68k_write_memory_32(unsigned a, unsigned v) {
    timing_access(a, 4);
    raw_write8(a, v >> 24);
    raw_write8(a + 1, v >> 16);
    raw_write8(a + 2, v >> 8);
    raw_write8(a + 3, v);
}
/**
 * hook
 *
 * Observe known addresses in the bundled ROM for boot readiness and trace messages. It does not
 * replace instruction execution or patch guest registers.
 */
static void hook(unsigned pc) {
    if (pc == QL_PC_BOOT_WAIT)
        ql.boot_wait = 1; /* GETMOD, bundled JS symbol map */
    if (pc == QL_PC_BASIC_READY)
        ql.basic_ready = 1; /* first BASIC command loop */
    if (ql.trace && pc == QL_PC_KEY_DECODED)
        fprintf(stderr, "[key] ASCII=%04x\n", m68k_get_reg(NULL, M68K_REG_D1));
    if (ql.trace && pc == QL_PC_RAM_ERROR)
        fprintf(stderr, "[cpu] exception/ram-error pc=%06x sp=%06x\n", pc,
                m68k_get_reg(NULL, M68K_REG_SP));
}
/**
 * ql_init
 *
 * Reset the machine, validate RAM and the supplied 64 KiB ROM, find its keyboard table and reset
 * the Musashi CPU. Return false on unsupported configuration or ROM input.
 */
int ql_init(const char *rom, unsigned ram_kb, int trace) {
    FILE *f;
    size_t n;
    memset(&ql, 0, sizeof(ql));
    ql_set_timing(0);
    ql_mouse_init(&ql.mouse);
    ql_qsound_init(&ql.qsound);
    if (ram_kb < 128 || ram_kb > 640 || ram_kb % 64) {
        fprintf(stderr, "RAM must be 128..640 KiB in 64 KiB steps\n");
        return 0;
    }
    ql.speed = 1;
    ql.boot_mode = 0xec;
    ql.ram_top = 0x20000 + ram_kb * 1024;
    ql.trace = trace;
    ql.clock_base = (unsigned)time(NULL) + 283996800u; /* QDOS epoch: 1961 */
    f = fopen(rom, "rb");
    if (!f) {
        perror(rom);
        return 0;
    }
    n = fread(ql.mem, 1, 0x10000, f);
    if (n != 0x10000 || fgetc(f) != EOF) {
        fprintf(stderr, "Expected the 65536-byte QLBox ROM\n");
        fclose(f);
        return 0;
    }
    fclose(f);
    ql.rom_size = (unsigned)n;
    {
        static const unsigned char signature[] = {0, 12, 0, 138, 0, 75, 0, 201, 1, 8, 1, 18, 3, 63};
        unsigned a;
        for (a = 0; a < 0xc000 - sizeof(signature); a++)
            if (!memcmp(ql.mem + a, signature, sizeof(signature))) {
                ql.keyboard_table = a;
                break;
            }
        if (!ql.keyboard_table) {
            fprintf(stderr, "Unsupported ROM keyboard table\n");
            return 0;
        }
    }
    m68k_init();
    m68k_set_cpu_type(M68K_CPU_TYPE_68000);
    m68k_set_int_ack_callback(irq_ack);
    m68k_set_instr_hook_callback(hook);
    m68k_pulse_reset();
    return 1;
}
/* Called before the first CPU frame; JS discovers the expansion normally. */
/**
 * ql_load_qsound_rom
 *
 * Validate an 8/16 KiB expansion image and copy it to the read-only mapping at 0xc0000 before
 * boot. JS discovers the ROM through its normal expansion scan.
 */
int ql_load_qsound_rom(const char *path) {
    unsigned char rom[0x4000];
    FILE *f = fopen(path, "rb");
    size_t n;
    int extra, failed;
    if (!f) {
        perror(path);
        return 0;
    }
    n = fread(rom, 1, sizeof(rom), f);
    extra = fgetc(f);
    failed = ferror(f);
    fclose(f);
    if (failed || (n != 0x2000 && n != 0x4000) || extra != EOF ||
        memcmp(rom, "\x4a\xfb\x00\x01", 4)) {
        fprintf(stderr,
                "QSound ROM must be an 8192- or 16384-byte expansion ROM with header 4AFB0001\n");
        return 0;
    }
    memcpy(ql.mem + 0xc0000, rom, n);
    ql.qsound_rom_size = (unsigned)n;
    return 1;
}
/**
 * ql_frame
 *
 * Run one nominal 20 ms frame as fifty CPU/audio slices, assert the frame interrupt and mix
 * sound. Optional timing debt carries instruction overshoot between slices.
 */
void ql_frame(void) {
    /* 50 CPU slices per 20 ms frame; sound time is independent of CPU speed.
  * Commands become audible within one 400 us slice, including very short beeps. */
    unsigned slice, offset = 0;
    ql.irq |= 8;
    irq_update();
    for (slice = 0; slice < 50; slice++) {
        unsigned end = (slice + 1) * QL_AUDIO_FRAME / 50;
        int budget = 3000 * (int)ql.speed;
        uint64_t before = ql.timing_clock;
        if (ql.timing) {
            budget -= ql.timing_debt;
            if (budget <= 0) {
                ql.timing_debt -= 3000 * (int)ql.speed;
                goto audio_slice;
            }
        }
        if (!debugger_execute(budget)) {
            memset(ql.audio, 0, sizeof(ql.audio));
            return;
        }
        if (ql.timing)
            ql.timing_debt += (int)(ql.timing_clock - before) - 3000 * (int)ql.speed;
        if (ql.exit_requested) {
            memset(ql.audio, 0, sizeof(ql.audio));
            return;
        }
    audio_slice:
        ql_beeper_render(&ql.beeper, ql.audio + offset, end - offset);
        ql_qsound_mix(&ql.qsound, ql.audio + offset, end - offset);
        offset = end;
    }
    ql.frame++;
}
/**
 * ql_key
 *
 * Update a physical key and modifier state, queuing only a new key-down transition when the IPC
 * queue has room.
 */
void ql_key(unsigned code, unsigned mods, int down) {
    code &= 63;
    ql.modifiers = mods & 0x700;
    if (down && !ql.held[code] && ql.key_in - ql.key_out < 256)
        ql.keys[ql.key_in++ & 255] = code | (mods & 0x700);
    ql.held[code] = (unsigned)(down != 0);
    ql.repeat[code] = ql.held[code];
}
/**
 * ql_release_keys
 *
 * Clear held/repeat/modifier state on focus loss so the guest does not retain stuck keys.
 */
void ql_release_keys(void) {
    memset(ql.held, 0, sizeof(ql.held));
    memset(ql.repeat, 0, sizeof(ql.repeat));
    ql.modifiers = 0;
}
/**
 * ql_map_char
 *
 * Invert the loaded ROM keyboard tables to find a key/modifier encoding for a character. Return
 * -1 if no mapping exists.
 */
int ql_map_char(unsigned char c) {
    unsigned map, code, base = ql.keyboard_table;
    if (c == '\r')
        c = '\n';
    /* Invert this ROM's translation tables: the supplied JS has a localized
  * layout, so a hardcoded UK scan-code map is incorrect. QDOS still does
  * the conversion, through the real IPC path. Prefer unmodified keys. */
    for (map = 0; map < 4; map++) {
        unsigned mods[4] = {0, 4, 2, 6};
        unsigned off = (ql.mem[base + mods[map]] << 8) | ql.mem[base + mods[map] + 1];
        unsigned t = base + off, lo = ql.mem[t], hi = ql.mem[t + 1];
        for (code = lo; code <= hi; code++)
            if (ql.mem[t + 2 + code - lo] == c) {
                return (int)(code | (mods[map] << 8));
            }
    }
    return -1;
}
/**
 * ql_type
 *
 * Queue a character through the real IPC keyboard path; return false if it is unmappable or the
 * key queue is full.
 */
int ql_type(unsigned char c) {
    int key = ql_map_char(c);
    if (key < 0 || ql.key_in - ql.key_out >= 256)
        return 0;
    ql.keys[ql.key_in++ & 255] = (unsigned)key;
    return 1;
}
/**
 * ql_render
 *
 * Decode the selected screen bank into 512x256 opaque ARGB pixels, including mode-8 doubled
 * pixels, flash and display blanking. Reads final frame state, not raster history.
 */
void ql_render(uint32_t *pixels) {
    unsigned y, x, b, base = (ql.video & 128) ? 0x28000 : 0x20000;
    for (y = 0; y < 256; y++) {
        unsigned flash = 0;
        for (x = 0; x < 512; x += 8) {
            unsigned a = base + y * 128 + x / 4, w = (ql.mem[a] << 8) | ql.mem[a + 1];
            for (b = 0; b < 8;) {
                unsigned r, g, bl, color, repeat = 1;
                if (ql.video & 8) {
                    r = (w >> 7) & 1;
                    g = (w >> 15) & 1;
                    bl = (w >> 6) & 1;
                    if (w & 0x4000)
                        flash ^= 1;
                    if (flash && (ql.frame / 25) & 1) {
                        r ^= 1;
                        g ^= 1;
                        bl ^= 1;
                    }
                    w <<= 2;
                    repeat = 2;
                } else {
                    r = (w >> 7) & 1;
                    g = (w >> 15) & 1;
                    bl = r & g;
                    w <<= 1;
                }
                color = 0xff000000u | (r ? 0xff0000 : 0) | (g ? 0xff00 : 0) | (bl ? 0xff : 0);
                if (ql.video & 2)
                    color = 0xff000000u;
                while (repeat--)
                    pixels[y * 512 + x + b++] = color;
            }
        }
    }
}
/**
 * ql_ppm
 *
 * Render and write a binary PPM screenshot. Return true only if writes and close succeed.
 */
int ql_ppm(const char *path) {
    static uint32_t p[512 * 256];
    unsigned i;
    FILE *f = fopen(path, "wb");
    if (!f)
        return 0;
    ql_render(p);
    fprintf(f, "P6\n512 256\n255\n");
    for (i = 0; i < 512 * 256; i++) {
        fputc(p[i] >> 16, f);
        fputc(p[i] >> 8, f);
        fputc(p[i], f);
    }
    {
        int ok = !ferror(f);
        return fclose(f) == 0 && ok;
    }
}
/**
 * ql_dump
 *
 * Write the complete 1 MiB memory backing array for inspection, including regions outside
 * configured RAM. Return true on successful write and close.
 */
int ql_dump(const char *path) {
    FILE *f = fopen(path, "wb");
    int ok;
    if (!f)
        return 0;
    ok = fwrite(ql.mem, 1, sizeof(ql.mem), f) == sizeof(ql.mem);
    return fclose(f) == 0 && ok;
}
/**
 * ql_status
 *
 * Print machine counters and, when enabled, experimental timing totals for reproducible
 * diagnostics.
 */
void ql_status(void) {
    if (ql.timing)
        fprintf(
            stderr,
            "[timing] mode=%s clocks=%llu bus-extra=%llu ram-wait=%llu debt=%d (experimental)\n",
            ql.timing == 2 ? "ql" : "68008", (unsigned long long)ql.timing_clock,
            (unsigned long long)ql.timing_bus_extra, (unsigned long long)ql.timing_ram_wait,
            ql.timing_debt);
    fprintf(stderr, "[qlbox] frame=%u pc=%06x sr=%04x ramtop=%06x video=%02x keys=%u irq_acks=%u\n",
            ql.frame, m68k_get_reg(NULL, M68K_REG_PC), m68k_get_reg(NULL, M68K_REG_SR), ql.ram_top,
            ql.video, ql.key_delivered, ql.irq_acks);
}
