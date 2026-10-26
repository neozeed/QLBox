/* QSound at $c2000: PIA A=data, B=AY bus control, CRA/CRB select data or DDR.
 * BC1=bit0, BC2=bit1, BDIR=bit2, /RESET=bit3. $f latch, $e write, $a idle.
 * QSound/QPrint manual: AY clock 0.75 MHz. AY counters run in clock/8 ticks:
 * tone toggles each period; noise/envelope step each 2*period (zero => one).
 * Eight sub-samples per output sample reduce aliasing. The output capacitor
 * is approximated by a DC-blocking filter; no CPU-speed-dependent clocking.
 * This is an original functional implementation, not an analogue circuit model.
 */
#include "qsound.h"
#include "beeper.h"
#include <string.h>
static const unsigned char masks[16] = {255, 15, 255, 15,  255, 15, 31,  255,
                                        31,  31, 31,  255, 255, 15, 255, 255};
/* Logarithmic ~3 dB AY levels, scaled to leave room for the IPC beeper. */
static const unsigned levels[16] = {0,   45,  64,   90,   128,  181,  256,  362,
                                    512, 724, 1024, 1448, 2048, 2896, 4096, 5792};
/**
 * chip_reset
 *
 * Reset AY registers, tone/noise counters and envelope state without clearing the surrounding
 * PIA configuration or host mixer state.
 */
static void chip_reset(QLQSound *s) {
    memset(s->reg, 0, sizeof(s->reg));
    memset(s->tone_count, 0, sizeof(s->tone_count));
    memset(s->tone, 0, sizeof(s->tone));
    s->selected = 0;
    s->noise_count = 0;
    s->lfsr = 1;
    s->env_count = 0;
    s->env_step = 15;
    s->env_attack = 0;
    s->env_hold = 1;
    s->env_alternate = 0;
    s->env_holding = 0;
}
/**
 * ql_qsound_init
 *
 * Initialize the complete board model and enable data-register access so direct-register players
 * can run without expansion firmware.
 */
void ql_qsound_init(QLQSound *s) {
    memset(s, 0, sizeof(*s));
    s->enabled = 1;
    chip_reset(s);
    /* Ready for direct hardware players, without requiring an expansion ROM. */
    s->control[0] = s->control[1] = 4;
    s->ddr[0] = s->ddr[1] = 255;
    s->bus = 10;
}
/**
 * reg_write
 *
 * Mask a write to the selected AY register. Writing envelope shape restarts the envelope,
 * including its attack, hold and alternate behavior.
 */
static void reg_write(QLQSound *s, unsigned value) {
    unsigned r = s->selected;
    if (r >= 16)
        return;
    s->reg[r] = (unsigned char)(value & masks[r]);
    s->writes++;
    if (r == 13) {
        unsigned shape = value & 15;
        s->env_attack = (shape & 4) ? 15 : 0;
        s->env_hold = (shape & 8) ? shape & 1 : 1;
        s->env_alternate = (shape & 8) ? !!(shape & 2) : !!s->env_attack;
        s->env_step = 15;
        s->env_count = 0;
        s->env_holding = 0;
    }
}
/**
 * ql_qsound_write
 *
 * Dispatch one PIA register write, interpreting data-direction selection and AY control strobes.
 * Latch/write actions occur only on a control-state transition.
 */
void ql_qsound_write(QLQSound *s, unsigned offset, unsigned value) {
    unsigned port = (offset >> 1) & 1;
    value &= 255;
    if (!s->enabled)
        return;
    if (offset & 1) {
        s->control[port] = value & 63;
        return;
    }
    if (!(s->control[port] & 4)) {
        s->ddr[port] = value;
        return;
    }
    if (!port) {
        s->data = value;
        return;
    }
    if (!(value & 8)) {
        chip_reset(s);
        s->bus = value;
        return;
    }
    /* Act once on the active control strobe. Returning to idle never retriggers. */
    if ((value & 7) != (s->bus & 7)) {
        if ((value & 7) == 7)
            s->selected = s->data;
        else if ((value & 7) == 6)
            reg_write(s, s->data);
    }
    s->bus = value;
}
/**
 * ql_qsound_read
 *
 * Return the selected PIA register or AY read-bus value. Unattached AY input ports read high;
 * disabled hardware reads as 0xff.
 */
unsigned ql_qsound_read(const QLQSound *s, unsigned offset) {
    unsigned port = (offset >> 1) & 1, r = s->selected;
    if (!s->enabled)
        return 255;
    if (offset & 1)
        return s->control[port];
    if (!(s->control[port] & 4))
        return s->ddr[port];
    if (port)
        return s->bus;
    if ((s->bus & 7) == 3) {
        if (r >= 16)
            return 255;
        /* No printer attached to the AY parallel ports; inputs are pulled high. */
        if (r >= 14 && (s->reg[7] & (64u << (r - 14))))
            return 255;
        return s->reg[r];
    }
    return s->data;
}
/**
 * tick
 *
 * Advance one AY clock/8 tick: update three square waves, the noise LFSR and the envelope
 * counters. Zero programmed periods are treated as one.
 */
static void tick(QLQSound *s) {
    unsigned c, p;
    for (c = 0; c < 3; c++) {
        p = s->reg[2 * c] | ((unsigned)s->reg[2 * c + 1] << 8);
        if (!p)
            p = 1;
        if (++s->tone_count[c] >= p) {
            s->tone_count[c] = 0;
            s->tone[c] ^= 1;
        }
    }
    p = s->reg[6];
    if (!p)
        p = 1;
    if (++s->noise_count >= 2 * p) {
        s->noise_count = 0;
        s->lfsr = (s->lfsr >> 1) | (((s->lfsr ^ (s->lfsr >> 3)) & 1) << 16);
    }
    if (!s->env_holding) {
        p = s->reg[11] | ((unsigned)s->reg[12] << 8);
        if (!p)
            p = 1;
        if (++s->env_count >= 2 * p) {
            s->env_count = 0;
            if (s->env_step)
                s->env_step--;
            else if (s->env_hold) {
                if (s->env_alternate)
                    s->env_attack ^= 15;
                s->env_holding = 1;
            } else {
                if (s->env_alternate)
                    s->env_attack ^= 15;
                s->env_step = 15;
            }
        }
    }
}
/**
 * output
 *
 * Compute the instantaneous sum of enabled tone/noise channels using fixed volume or the current
 * envelope level.
 */
static int output(const QLQSound *s) {
    unsigned c, m = s->reg[7];
    int sum = 0;
    for (c = 0; c < 3; c++) {
        unsigned v = s->reg[8 + c];
        if (v & 16)
            v = s->env_step ^ s->env_attack;
        if ((s->tone[c] || (m & (1u << c))) && ((s->lfsr & 1) || (m & (8u << c))))
            sum += (int)levels[v & 15];
    }
    return sum;
}
/**
 * ql_qsound_mix
 *
 * Advance the 750 kHz chip clock through eight sub-samples per PCM sample, remove DC
 * approximately and saturating-add the result to the existing beeper buffer.
 */
void ql_qsound_mix(QLQSound *s, int16_t *pcm, unsigned count) {
    unsigned i, j;
    if (!s->enabled)
        return;
    for (i = 0; i < count; i++) {
        int sum = 0, mix;
        int32_t x, y;
        for (j = 0; j < 8; j++) {
            s->clock_fraction += 750000;
            while (s->clock_fraction >= QL_AUDIO_RATE * 64u) {
                s->clock_fraction -= QL_AUDIO_RATE * 64u;
                tick(s);
            }
            sum += output(s);
        }
        x = (sum / 8) * 256;
        /* Q8 filter state preserves small signals and avoids integer rounding bias. */
        y = x - s->dc_input + s->dc_output - s->dc_output / 256;
        s->dc_input = x;
        s->dc_output = y;
        mix = pcm[i] + y / 256;
        if (mix > 32767)
            mix = 32767;
        else if (mix < -32768)
            mix = -32768;
        pcm[i] = (int16_t)mix;
    }
}
