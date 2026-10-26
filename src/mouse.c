/* QIMSI receive interface: CODE is latched until a read of UNLOCK.
 * Four-byte IntelliMouse packets; bit 4 of STATUS advertises that format.
 * No QIMSI storage, keyboard, audio, or CPU is advertised/emulated here. */
#include "mouse.h"
#include <string.h>
/**
 * part
 *
 * Clamp one signed movement component to a legal packet-sized step.
 */
static int part(int n, int limit) {
    return n > limit ? limit : n < -limit ? -limit : n;
}
/**
 * packet
 *
 * Append one four-byte mouse report. On overflow retain the report currently being read and
 * replace older queued reports with the newest state.
 */
static void packet(QLMouse *m, int x, int y, int z, unsigned buttons) {
    unsigned tail;
    uint8_t *p;
    if (m->count == QL_MOUSE_PACKETS) {
        /* Keep the in-flight packet intact. Discard old complete reports, then
   * append the newest state so a release cannot leave buttons stuck. */
        m->count = 1;
    }
    tail = (m->head + m->count) % QL_MOUSE_PACKETS;
    p = m->packet[tail];
    p[0] = (uint8_t)(8 | (buttons & 7) | (x < 0 ? 16 : 0) | (y < 0 ? 32 : 0));
    p[1] = (uint8_t)x;
    p[2] = (uint8_t)y;
    p[3] = (uint8_t)z;
    m->count++;
}
/* Require polling on distinct frames; a boot-time probe must not arm capture.
 * A one-second grace period tolerates occasional slow guest frames. */
/**
 * ql_mouse_note_read
 *
 * Record a real guest interface read. Two distinct recent frames are needed to distinguish
 * active polling from a one-frame hardware probe.
 */
void ql_mouse_note_read(QLMouse *m, unsigned frame) {
    if (!m->enabled)
        return;
    if (!m->read_frames || frame - m->last_read_frame >= 50)
        m->read_frames = 1;
    else if (frame != m->last_read_frame)
        m->read_frames = 2;
    m->last_read_frame = frame;
}
/**
 * ql_mouse_active
 *
 * Return whether polling has armed capture and the last read is less than 50 emulated frames
 * old. Unsigned subtraction permits frame-counter wrap.
 */
int ql_mouse_active(const QLMouse *m, unsigned frame) {
    return m->enabled && m->read_frames >= 2 && frame - m->last_read_frame < 50;
}
/**
 * ql_mouse_init
 *
 * Clear packet and polling state, then enable the emulated interface by default.
 */
void ql_mouse_init(QLMouse *m) {
    memset(m, 0, sizeof(*m));
    m->enabled = 1;
}
/**
 * ql_mouse_event
 *
 * Convert host relative motion, wheel movement and three button bits into bounded PS/2 reports.
 * Split large movements instead of silently truncating them.
 */
void ql_mouse_event(QLMouse *m, int dx, int dy, int wheel, unsigned buttons) {
    int x, y, z;
    buttons &= 7;
    if (!m->enabled)
        return;
    if (!dx && !dy && !wheel && buttons == m->buttons)
        return;
    /* Smaller legal PS/2 reports avoid dropping movement in clients which
  * cap per-packet acceleration. Split rather than truncate large deltas. */
    do {
        x = part(dx, 28);
        y = part(dy, 28);
        z = part(wheel, 7);
        packet(m, x, y, z, buttons);
        dx -= x;
        dy -= y;
        wheel -= z;
    } while (dx || dy || wheel);
    m->buttons = buttons;
}
/**
 * ql_mouse_release
 *
 * Discard stale queued motion, preserve any partially consumed packet and enqueue a button-
 * release report.
 */
void ql_mouse_release(QLMouse *m) {
    /* Keep a partially read report aligned; discard stale motion on focus loss. */
    if (m->byte || m->latched)
        m->count = 1;
    else {
        m->count = 0;
        m->head = 0;
    }
    packet(m, 0, 0, 0, 0);
    m->buttons = 0;
}
/**
 * ql_mouse_read
 *
 * Read CODE, UNLOCK or STATUS. A consuming UNLOCK read advances the packet; consume=0 lets
 * inspection observe the interface without advancing it.
 */
unsigned ql_mouse_read(QLMouse *m, unsigned a, int consume) {
    if (!m->enabled)
        return 0xff;
    if (a == 0xfedf)
        return 0x10 | (m->count ? 1 : 0);
    if (a == 0xfedd) {
        if (consume && m->count)
            m->latched = 1;
        return m->count ? m->packet[m->head][m->byte] : 0;
    }
    if (a == 0xfede && consume && m->count) {
        m->latched = 0;
        if (++m->byte == 4) {
            m->byte = 0;
            m->head = (m->head + 1) % QL_MOUSE_PACKETS;
            m->count--;
        }
    }
    return 0;
}
