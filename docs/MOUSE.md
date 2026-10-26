# Mouse support (R19 capture policy)

QIMSI-compatible PS/2 mouse input is enabled by default. Lemmings detects it
without changing its BASIC loader, game binary, or disk image.

- While the guest is actively polling the mouse, click inside the window to
  capture it. The first click only captures;
  click again to interact with the game. The host cursor disappears.
- Ctrl+F9 releases it, or captures it while the guest is actively polling. Alt+Tab/focus loss releases capture and
  clears guest buttons. Plain F9 still goes to the QL.
- Relative movement, left/right/middle buttons and wheel are delivered.
- `--mouse-speed 1` through `--mouse-speed 8` adjust movement gain (default 2).
  Guest programs apply their own acceleration/scaling. CPU speed is separate.
- `--no-mouse` disables the interface; `--mouse` reenables it. Config supports
  `mouse=true` / `mouse=false` and `mouse_speed=2`. CLI overrides config.

Example:

```
bin\win64\qlbox.exe --ram 640 --speed 4 --mount QLWA.win
```

In BASIC:

```
LRUN WIN1_lemmings_bas
```

Capture the mouse, click New Game, then click again on the level briefing.
The supplied game uses right-click plus horizontal movement to scroll.
For writable progress files, extract the image with qlimage first, as in
[IMAGES.md](IMAGES.md). Image mounts remain read-only.

## Capture eligibility (R19)

Reads of any mouse register must occur on two distinct emulated frames,
less than 50 frames apart. Further reads keep capture eligible. After 50
frames without a read, capture releases automatically and requires another
click/hotkey after polling resumes. This uses emulated time: pausing the CPU
also pauses the timeout. Disabled mouse hardware cannot arm capture.
One-frame detection probes and disassembler/debug inspection do not count.
A resident mouse driver that keeps polling qualifies even if its current
application does not use the resulting pointer events.

`make mouse-capture-test` checks the capture policy with a mocked SDL grab
operation, exercising the real guest-read and SDL-event paths without a
window system. It covers probe filtering, idle/active capture, Ctrl+F9,
timeout/re-arm, focus loss, disabled hardware and frame-counter wrap.

## Interface and scope

The byte registers at $FEDD..$FEDF override only those three ROM-space reads:

| Register | Read behavior |
| --- | --- |
| $FEDD | Current PS/2 byte, unchanged until unlock |
| $FEDE | Acknowledge byte and advance to the next byte |
| $FEDF | Bit 0: data ready; bit 4: four-byte IntelliMouse packets |

Packets carry status/buttons, signed X, signed Y, and signed wheel movement.
Y is positive upward in the PS/2 stream. Long movement is split into bounded
reports. The queue retains packet alignment across focus loss and overload;
button release is retained even when old movement must be discarded.
Disassembler reads do not acknowledge bytes.

This emulates the mouse receive interface only: no QIMSI CPU, keyboard, SD,
QSound/AY or other audio hardware is added. Programs that read QIMSI directly,
including this Lemmings build, can use it immediately. General Pointer
Environment programs still require PTR_GEN and a QIMSI mouse driver; those
are not automatically installed or bundled by this change. Beeper support
remains as before. Headless builds expose the registers but have no host mouse.

Sources consulted: QIMSI manual and Peter Graf's published QIMSI mouse driver
(source used to confirm the register protocol; not copied into this release):
https://sinclairql.net/djw/qimsi/index.html
https://sinclairql.net/djw/qimsi/qimsi_mouse.zip

## Validation

The supplied unmodified Lemmings image was run through the real ROM and
Musashi CPU. Tests confirmed QIMSI auto-detection, SDL capture, exact movement
through the game's own decoder, left/right button states, focus-loss release,
and mouse clicks from the main menu through the briefing into the running
first level. This is not a full-game compatibility claim.

`make mouse-test` tests latching, unlock, wheel, large movement, queue overload,
focus loss between CODE and UNLOCK, capture, release and disabled mapping.
It needs a real or virtual SDL display; the dummy video driver cannot capture
relative input. Tested here with SDL2/Xvfb. `tests/lemmings_mouse.c` is an
optional integration harness for the user's 331252-byte game build (game data
not included). Normal ROM, disk, GDB, keyboard and beeper regressions pass.
Win32/Win64 are cross-built; Linux executes the tests. macOS source only.
