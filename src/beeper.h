#ifndef QL_BEEPER_H
#define QL_BEEPER_H
#include <stdint.h>
#define QL_AUDIO_RATE 48000
#define QL_AUDIO_FRAME 960
typedef struct {
    unsigned active, continuous, pitch, duration;
    uint64_t remaining, phase;
    unsigned starts, stops;
} QLBeeper;
void ql_beeper_start(QLBeeper *b, const unsigned *nibbles);
void ql_beeper_stop(QLBeeper *b);
void ql_beeper_render(QLBeeper *b, int16_t *out, unsigned count);
#endif
