#ifndef QL_H
#define QL_H
#include <stdint.h>
#include "beeper.h"
#include "qsound.h"
#include "mouse.h"
#define QL_MEM_SIZE 0x100000
#define QL_WIDTH 512
#define QL_HEIGHT 256
/* Single guest instance; all machine state lives outside the presentation layer. */
typedef struct {
    /* Guest address-space backing bytes; all multibyte access is explicitly big-endian. */
    uint8_t mem[QL_MEM_SIZE];
    unsigned keyboard_table, boot_wait, basic_ready;
    /* Timing 0=legacy, 1=68008 bus, 2=bus + ZX8301 RAM contention. */
    unsigned timing, timing_active;
    uint64_t timing_clock, timing_cursor, timing_bus_extra, timing_ram_wait;
    unsigned timing_extra;
    int timing_debt;
    unsigned qsound_rom_size;
    unsigned rom_size, host_request, boot_mode;
    unsigned exit_requested;
    /* CLI launch configuration, active stream interception and completion handshake. */
    unsigned run_enabled, run_active, run_done;
    int32_t run_status;
    char run_name[44], run_args[1024];
    unsigned ram_top, frame, video, irq, clock_base, speed;
    unsigned ipc_command, ipc_nibble, ipc_nbits, ipc_reply, ipc_bits, ipc_reads, ipc_latch;
    unsigned ipc_param, ipc_count, ipc_test;
    /* IPC event ring plus physical held-key state; indices grow and wrap on access. */
    unsigned keys[256], key_in, key_out, held[64], repeat[64], modifiers;
    unsigned ipc_commands[16], key_delivered, irq_acks;
    QLBeeper beeper;
    QLQSound qsound;
    QLMouse mouse;
    unsigned beep_packet[16];
    int16_t audio[QL_AUDIO_FRAME];
    int trace;
} QL;
extern QL ql;
int ql_init(const char *rom, unsigned ram_kb, int trace);
int ql_load_qsound_rom(const char *path);
void ql_set_timing(unsigned mode);
unsigned ql_ram_wait(uint64_t clock);
void ql_frame(void);
void ql_key(unsigned code, unsigned modifiers, int down);
int ql_type(unsigned char c);
int ql_map_char(unsigned char c);
void ql_release_keys(void);
void ql_render(uint32_t *pixels);
int ql_ppm(const char *path);
int ql_dump(const char *path);
void ql_status(void);
#endif
