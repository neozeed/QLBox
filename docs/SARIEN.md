Historical R5 investigation. R6 now adds a basic audible beeper; see PHASE4.md.

# Sarien investigation and R5 changes

The supplied `sar.zip` executable ran in the R4 machine core, progressed through
Space Quest's intro into the first room, opened the restore dialog and restored
slot 0 (`attacked in ship`). The game displayed "Game restored" and the saved
room. This establishes that this restore path can complete; it is not proof of
all save/restore paths, nor of a new save/write round trip. The uploaded saves
predate this emulator test.

Sarien polls the keyboard matrix rather than relying solely on queued console
characters. Short taps during expensive redraws can be missed. The reproduction
used held keys and release intervals. An unchanging screen alone is not evidence
of a CPU hang.

## QLBox changes

* Backspace and Delete synthesize Ctrl+Left and Ctrl+Right. R4 discarded the
  synthetic modifier on host repeat events and unrelated key events. R5 retains
  it until the corresponding key is released, including overlapping keys.
* `--speed N`, integer 1..64, increases CPU cycles per frame from 150,000 to
  N times that value. Timer interrupts and display scheduling remain at 50 Hz.
  Default 1 preserves existing behavior. Try 8 first. Actual throughput is
  limited by the host; increasing the number cannot accelerate intentional
  guest timer waits and may affect programs that use CPU busy loops for timing.
* No ROM or host-filesystem ABI changes. The bundled ROM still identifies as R4.

Example from an extracted package on Windows:

```
bin\win64\qlbox.exe --ram 640 --mount C:\path\to\sar --speed 8
```

Then enter `EXEC_W WIN1_sar` in BASIC. Press Enter at Sarien's drive prompt to
accept WIN1_. Use win32 instead of win64 for the 32-bit build.

## Sarien source fixes

The full corrected source is in `samples/sarienQL-fixed`, with a small diff in
`samples/sarienQL-fixes.patch`. Build with the user's existing QDOS compiler:
`make clean` then `make`. Copy the resulting `sar` into the existing mounted
working directory, retaining its executable metadata/data-space requirements.
No new Sarien executable is supplied: the QDOS C compiler/runtime is not
installed in this build environment. GNU m68k ELF tools are not a substitute
for that QDOS C toolchain. Existing object/library files are omitted to force a
clean build. Space Quest data and the supplied saves are not redistributed here.

* `qlvid.c`: `pc_keypress()` returned no value despite its `int` declaration and
  its caller testing that value. Return `ql_kbhit` explicitly; release transitions
  update state without queuing a zero key.
* `qlkeyboard.c`: scan eight rows rather than ten; mask the three modifier bits
  from row 7 (the old `& 0xFF` masked none); store key codes as unsigned bytes.
* `sound.c`: remove the cursor movement and `beep:` console diagnostics during
  gameplay. Sarien writes graphics directly into screen RAM; simultaneous console
  writes can alter or scroll it. This is a plausible source of the reported shift,
  not a claim that the exact shift was reproduced. Sound calls remain intact;
  QLBox still does not synthesize audio.
* `savegame.c`: copy the selected slot's description using `active`, not `i`.
  The redraw loop has already left `i == NUM_SLOTS`, an out-of-bounds index.

## Validation

* Existing Linux boot/BASIC, video, host storage, executable, CLI, UnZip 532/541
  and host-backend suites passed.
* SDL input regression passes, including Backspace autorepeat, unrelated key
  release, overlapping Delete and Backspace, and modifier release.
* BASIC and CLI stdin/arguments passed at speed 1, 8 and 64; malformed speed
  values reject with status 2.
* Native mocked-QDOS tests compile the corrected Sarien keyboard/vid sources and
  exercise row bounds, modifiers, Backspace, arrows and release/repress behavior.
  This is a focused source test, not a rebuilt QDOS executable test. Reproduce:

```
cc -std=gnu89 -O2 -D__QDOS__ -ffunction-sections -fdata-sections \
  -Itests/sarien/stubs -Isamples/sarienQL-fixed/include \
  tests/sarien/keyboard.c -Wl,--gc-sections -o /tmp/sarien-keyboard-test
/tmp/sarien-keyboard-test
```

* Both Windows architectures were cross-built. Live Windows verification of R5
  and the rebuilt Sarien source remains for the user. macOS was not built here.
