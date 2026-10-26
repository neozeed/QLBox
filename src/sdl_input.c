#include "ql.h"
#include "sdl_input.h"
/**
 * keycode
 *
 * Map SDL special/physical keys to QL key numbers; return the unmapped sentinel for keys handled
 * elsewhere.
 */
static int keycode(SDL_Keycode c) {
    static const int alpha[] = {0x1c, 0x2c, 0x2b, 0x1e, 0xc,  0x24, 0x26, 0x1a, 0x12,
                                0x1f, 0x22, 0x18, 0x2e, 6,    0x17, 0x1d, 0xb,  0x14,
                                0x23, 0xe,  0xf,  4,    0x11, 3,    0x16, 0x29};
    static const int digit[] = {0xd, 0x1b, 9, 0x19, 0x3e, 0x3a, 0xa, 0x3f, 8, 0x10};
    if (c >= SDLK_a && c <= SDLK_z)
        return alpha[c - SDLK_a];
    if (c >= SDLK_0 && c <= SDLK_9)
        return digit[c - SDLK_0];
    switch (c) {
    case SDLK_F1:
        return 0x39;
    case SDLK_F2:
        return 0x3b;
    case SDLK_F3:
        return 0x3c;
    case SDLK_F4:
        return 0x38;
    case SDLK_F5:
        return 0x3d;
    case SDLK_F6:
        return 0x439;
    case SDLK_F7:
        return 0x43b;
    case SDLK_F8:
        return 0x43c;
    case SDLK_F9:
        return 0x438;
    case SDLK_F10:
        return 0x43d;
    case SDLK_HOME:
        return 0x431;
    case SDLK_END:
        return 0x434;
    case SDLK_UP:
        return 0x32;
    case SDLK_DOWN:
        return 0x37;
    case SDLK_LEFT:
        return 0x31;
    case SDLK_RIGHT:
        return 0x34;
    case SDLK_BACKSPACE:
        return 0x231;
    case SDLK_DELETE:
        return 0x234;
    case SDLK_SPACE:
        return 0x36;
    case SDLK_RETURN:
    case SDLK_KP_ENTER:
        return 0x30;
    case SDLK_TAB:
        return 0x13;
    case SDLK_ESCAPE:
        return 0x33;
    case SDLK_CAPSLOCK:
        return 0x21;
    case SDLK_LEFTBRACKET:
        return 0x20;
    case SDLK_RIGHTBRACKET:
        return 0x28;
    case SDLK_SEMICOLON:
        return 0x27;
    case SDLK_COMMA:
        return 7;
    case SDLK_PERIOD:
        return 0x2a;
    case SDLK_SLASH:
        return 5;
    case SDLK_BACKSLASH:
        return 0x35;
    case SDLK_QUOTE:
        return 0x2f;
    case SDLK_MINUS:
        return 0x15;
    case SDLK_EQUALS:
        return 0x25;
    case SDLK_BACKQUOTE:
        return 0x2d;
    default:
        return -1;
    }
}

/**
 * ql_sdl_input
 *
 * Translate SDL keyboard/text/focus events into guest key state. Coordinate text input with
 * physical keys to avoid duplicate characters.
 */
void ql_sdl_input(const SDL_Event *e) {
    static int pressed[SDL_NUM_SCANCODES]; /* guest code + 1, zero = released */
    unsigned mods = 0, i;
    int k, down, sc;
    if (e->type == SDL_WINDOWEVENT && e->window.event == SDL_WINDOWEVENT_FOCUS_LOST) {
        unsigned i;
        ql_release_keys();
        for (i = 0; i < SDL_NUM_SCANCODES; i++)
            pressed[i] = 0;
        return;
    }
    if (e->type == SDL_TEXTINPUT) {
        const unsigned char *t = (const unsigned char *)e->text.text;
        /* Host text input follows the host layout. ROM still translates IPC. */
        if (!(ql.modifiers & 0x300))
            for (; *t; t++)
                if (*t < 128)
                    ql_type(*t);
        return;
    }
    if (e->type != SDL_KEYDOWN && e->type != SDL_KEYUP)
        return;
    down = e->type == SDL_KEYDOWN;
    sc = (int)e->key.keysym.scancode;
    if (sc < 0 || sc >= SDL_NUM_SCANCODES)
        return;
    if (e->key.keysym.mod & KMOD_SHIFT)
        mods |= 0x400;
    if (e->key.keysym.mod & KMOD_CTRL)
        mods |= 0x200;
    if (e->key.keysym.mod & KMOD_ALT)
        mods |= 0x100;
    /* Keep synthetic modifiers while their host keys remain held. */
    if (!down) {
        k = pressed[sc];
        pressed[sc] = 0;
        for (i = 0; i < SDL_NUM_SCANCODES; i++)
            if (pressed[i])
                mods |= (pressed[i] - 1) & 0x700;
        ql.modifiers = mods;
        if (k) {
            unsigned other;
            int shared = 0;
            for (other = 0; other < SDL_NUM_SCANCODES; other++)
                if (pressed[other] && ((pressed[other] - 1) & 63) == ((k - 1) & 63))
                    shared = 1;
            if (!shared)
                ql_key((unsigned)(k - 1), mods, 0);
        }
        pressed[sc] = 0;
        return;
    }
    for (i = 0; i < SDL_NUM_SCANCODES; i++)
        if (pressed[i])
            mods |= (pressed[i] - 1) & 0x700;
    ql.modifiers = mods;
    if (e->key.repeat)
        return; /* TEXTINPUT supplies printable host repeats */
    k = keycode(e->key.keysym.sym);
    if (e->key.keysym.sym >= 32 && e->key.keysym.sym < 127) {
        k = ql_map_char((unsigned char)e->key.keysym.sym);
        if (k < 0)
            return;
        if (!(mods & 0x300)) {
            ql.held[k & 63] = 1;
            pressed[sc] = (k & 63) + 1;
            return;
        }
    }
    if (k >= 0) {
        ql_key((unsigned)k, mods | (k & 0x700), 1);
        pressed[sc] = k + 1;
    }
}

/* Consume both edges, even if Ctrl was released before the function key.
 * Only keydown changes speed; OS key repeat is intentionally ignored. */
/**
 * ql_sdl_speed_control
 *
 * Handle CPU-speed hotkeys and report whether the event was consumed.
 */
int ql_sdl_speed_control(const SDL_Event *e) {
    static unsigned held;
    unsigned bit;
    SDL_Keycode key;
    if (e->type == SDL_WINDOWEVENT && e->window.event == SDL_WINDOWEVENT_FOCUS_LOST) {
        held = 0;
        return 0;
    }
    if (e->type != SDL_KEYDOWN && e->type != SDL_KEYUP)
        return 0;
    key = e->key.keysym.sym;
    if (key < SDLK_F10 || key > SDLK_F12)
        return 0;
    bit = 1u << (key - SDLK_F10);
    if (e->type == SDL_KEYUP) {
        if (held & bit) {
            held &= ~bit;
            return 1;
        }
        return 0;
    }
    if (!(e->key.keysym.mod & KMOD_CTRL) && !(held & bit))
        return 0;
    held |= bit;
    if (!e->key.repeat) {
        if (key == SDLK_F10)
            ql.speed = 1;
        else if (key == SDLK_F11 && ql.speed > 1)
            ql.speed--;
        else if (key == SDLK_F12 && ql.speed < 64)
            ql.speed++;
    }
    return 1;
}

static int mouse_captured, mouse_hotkey, mouse_was_active;
static unsigned mouse_gain = 2, mouse_buttons;
/**
 * ql_sdl_mouse_captured
 *
 * Return the frontend capture flag used by the title and event loop.
 */
int ql_sdl_mouse_captured(void) {
    return mouse_captured;
}
/**
 * ql_sdl_mouse_speed
 *
 * Set the host-motion gain used when forming guest mouse reports.
 */
void ql_sdl_mouse_speed(unsigned speed) {
    mouse_gain = speed;
}
/**
 * capture_mouse
 *
 * Request SDL relative mouse mode, update the capture flag on success and release guest buttons
 * when leaving capture.
 */
static int capture_mouse(int capture) {
    if (SDL_SetRelativeMouseMode(capture ? SDL_TRUE : SDL_FALSE)) {
        SDL_Log("Mouse capture failed: %s", SDL_GetError());
        return 0;
    }
    mouse_captured = capture;
    mouse_buttons = 0;
    ql_mouse_release(&ql.mouse);
    return 1;
}
/**
 * ql_sdl_mouse_update
 *
 * Release capture when guest polling is no longer active; report whether capture eligibility
 * changed so the window title can be refreshed.
 */
int ql_sdl_mouse_update(void) {
    int active = ql_mouse_active(&ql.mouse, ql.frame), changed = active != mouse_was_active;
    mouse_was_active = active;
    if (mouse_captured && !active)
        changed |= capture_mouse(0);
    return changed;
}
/**
 * ql_sdl_mouse
 *
 * Handle capture/release hotkeys, focus changes and relative mouse events. Capture requires
 * recent guest reads and an explicit click or hotkey.
 */
int ql_sdl_mouse(const SDL_Event *e) {
    ql_sdl_mouse_update();
    if (e->type == SDL_KEYUP && e->key.keysym.sym == SDLK_F9 && mouse_hotkey) {
        mouse_hotkey = 0;
        return 1;
    }
    if (e->type == SDL_KEYDOWN && e->key.keysym.sym == SDLK_F9 && (e->key.keysym.mod & KMOD_CTRL)) {
        if (e->key.repeat && !mouse_hotkey)
            return 0;
        mouse_hotkey = 1;
        if (!e->key.repeat && (mouse_captured || ql_mouse_active(&ql.mouse, ql.frame)))
            capture_mouse(!mouse_captured);
        return 1;
    }
    if (e->type == SDL_WINDOWEVENT && e->window.event == SDL_WINDOWEVENT_FOCUS_LOST) {
        if (mouse_captured)
            capture_mouse(0);
        mouse_hotkey = 0;
        mouse_buttons = 0;
        ql_mouse_release(&ql.mouse);
        return 0;
    }
    if (!ql.mouse.enabled)
        return 0;
    if (e->type == SDL_MOUSEBUTTONDOWN || e->type == SDL_MOUSEBUTTONUP) {
        unsigned mask = e->button.button == SDL_BUTTON_LEFT     ? 1
                        : e->button.button == SDL_BUTTON_RIGHT  ? 2
                        : e->button.button == SDL_BUTTON_MIDDLE ? 4
                                                                : 0;
        if (e->button.which == SDL_TOUCH_MOUSEID)
            return 1;
        if (!mouse_captured) {
            if (e->type == SDL_MOUSEBUTTONDOWN && mask == 1 && ql_mouse_active(&ql.mouse, ql.frame))
                capture_mouse(1);
            return 1;
        }
        if (e->type == SDL_MOUSEBUTTONDOWN)
            mouse_buttons |= mask;
        else
            mouse_buttons &= ~mask;
        ql_mouse_event(&ql.mouse, 0, 0, 0, mouse_buttons);
        return 1;
    }
    if (e->type == SDL_MOUSEMOTION) {
        if (mouse_captured && e->motion.which != SDL_TOUCH_MOUSEID) {
            /* Bound pathological host deltas before scaling or packet splitting. */
            int x = e->motion.xrel, y = e->motion.yrel;
            if (x > 4096)
                x = 4096;
            if (x < -4096)
                x = -4096;
            if (y > 4096)
                y = 4096;
            if (y < -4096)
                y = -4096;
            ql_mouse_event(&ql.mouse, x * (int)mouse_gain, -y * (int)mouse_gain, 0, mouse_buttons);
        }
        return 1;
    }
    if (e->type == SDL_MOUSEWHEEL) {
        if (mouse_captured) {
            int z = e->wheel.y;
            if (z > 32)
                z = 32;
            if (z < -32)
                z = -32;
            if (e->wheel.direction == SDL_MOUSEWHEEL_FLIPPED)
                z = -z;
            ql_mouse_event(&ql.mouse, 0, 0, z, mouse_buttons);
        }
        return 1;
    }
    return 0;
}
