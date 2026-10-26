#ifndef QL_MOUSE_H
#define QL_MOUSE_H
#include <stdint.h>
#define QL_MOUSE_PACKETS 512
typedef struct {
    uint8_t packet[QL_MOUSE_PACKETS][4];
    unsigned head, count, byte, buttons, enabled, latched;
    unsigned last_read_frame, read_frames;
} QLMouse;
void ql_mouse_note_read(QLMouse *m, unsigned frame);
int ql_mouse_active(const QLMouse *m, unsigned frame);
void ql_mouse_init(QLMouse *m);
void ql_mouse_event(QLMouse *m, int dx, int dy, int wheel, unsigned buttons);
void ql_mouse_release(QLMouse *m);
unsigned ql_mouse_read(QLMouse *m, unsigned address, int consume);
#endif
