/* Functional single-tone IPC beeper, not an 8049 instruction-level model.
 * Wire layout and half-period convention cross-checked against QLAY qlio.c.
 * Duration units: Sinclair QL User Guide, BEEP (72 microseconds).
 * Integer time units are 1/(48000*1000000) seconds: one sample = 1000000.
 */
#include "beeper.h"
/**
 * ql_beeper_start
 *
 * Decode the 16-nibble IPC sound request and restart the square-wave generator. Zero duration
 * means continuous sound; remaining time uses the fixed-point sample units described above.
 */
void ql_beeper_start(QLBeeper *b, const unsigned *n) {
    unsigned pitch = n[0] * 16 + n[1];
    unsigned duration = (n[10] * 16 + n[11]) * 256 + n[8] * 16 + n[9];
    b->pitch = pitch ? pitch : 256; /* ROM sends BASIC pitch + 1, wrapping at 256. */
    b->duration = duration;
    b->continuous = duration == 0;
    b->remaining = (uint64_t)duration * 72 * QL_AUDIO_RATE;
    b->phase = 0;
    b->active = 1;
    b->starts++;
}
/**
 * ql_beeper_stop
 *
 * Silence the beeper immediately, discard its remaining duration and record a stop for
 * diagnostics.
 */
void ql_beeper_stop(QLBeeper *b) {
    b->active = 0;
    b->remaining = 0;
    b->phase = 0;
    b->stops++;
}
/**
 * ql_beeper_render
 *
 * Fill count mono samples, advancing phase and duration even when the host audio output is
 * muted. Inactive samples are zero; this initializes the buffer before QSound is mixed into it.
 */
void ql_beeper_render(QLBeeper *b, int16_t *out, unsigned count) {
    unsigned i;
    uint64_t half = (uint64_t)b->pitch * 72 * QL_AUDIO_RATE;
    for (i = 0; i < count; i++) {
        out[i] = 0;
        if (!b->active)
            continue;
        out[i] = (int16_t)(b->phase < half ? 3000 : -3000);
        b->phase = (b->phase + 1000000) % (half * 2);
        if (!b->continuous) {
            if (b->remaining <= 1000000) {
                b->remaining = 0;
                b->active = 0;
            } else
                b->remaining -= 1000000;
        }
    }
}
