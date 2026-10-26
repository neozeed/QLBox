#ifndef QL_QSOUND_H
#define QL_QSOUND_H
#include <stdint.h>
/* Functional QSound AY-3-8910 + PIA register interface, fixed 750 kHz clock. */
typedef struct {
    unsigned enabled, selected, data, bus, control[2], ddr[2];
    unsigned char reg[16];
    unsigned tone_count[3], tone[3], noise_count, lfsr, env_count;
    unsigned env_step, env_attack, env_hold, env_alternate, env_holding;
    uint32_t clock_fraction;
    int32_t dc_input, dc_output;
    unsigned writes;
} QLQSound;
void ql_qsound_init(QLQSound *s);
void ql_qsound_write(QLQSound *s, unsigned offset, unsigned value);
unsigned ql_qsound_read(const QLQSound *s, unsigned offset);
void ql_qsound_mix(QLQSound *s, int16_t *pcm, unsigned count);
#endif
