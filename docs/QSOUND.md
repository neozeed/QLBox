# R17 firmware loading

Use `--qsound-rom rom/qsound-1.31.rom` or config `qsound_rom=PATH`.
The image loads before CPU execution at $C0000 and is discovered by the
existing JS expansion scan. The mapping is read-only, above the maximum
640 KiB RAM allocation. Hardware reads/writes at $C2000–$C2003 override
ROM bytes, including when the hardware is disabled. The supplied archive
contains two 8 KiB variants in one 16 KiB image; the first is the entry point.
No relocation or ROM-byte patching is performed. Missing files, bad headers,
and sizes other than 8192/16384 bytes fail startup. Loading is opt-in and
independent of the `--qsound`/`--no-qsound` hardware setting.

The bundled image is Jochen Merz QSound V1.31 (1987), supplied by the user
as QSOUND_V1.31 in qsound.zip; it is not QLBox-authored firmware.
Boot integration is tested using POKE_AY/PEEK_AY, hardware register readback,
ROM write protection, config loading, and invalid-file rejection.
This does not establish compatibility of every firmware command or printer I/O.

# QSound support (R16)

QSound is enabled by default. It is a low-level AY-3-8910 sound implementation
with the PIA register interface at $C2000..$C2003. By default it does not load a QSound
extension ROM or install PLAY / POKE_AY / other SuperBASIC extensions.
No printer, PIA interrupt lines, or selectable expansion-slot address is modeled.

- $C2000: PIA A / AY data bus (or DDRA when CRA bit 2 is clear).
- $C2001: CRA, lower six control bits.
- $C2002: PIA B / AY bus control (or DDRB when CRB bit 2 is clear).
- $C2003: CRB, lower six control bits.

Initial state is preconfigured for direct hardware access, as required by
players that assume a configured interface. Bit 0 is BC1, bit 1 BC2, bit 2
BDIR, and bit 3 /RESET. The demonstrated sequence is:

1. Write register number to $C2000, then $0F and $0A to $C2002.
2. Write value to $C2000, then $0E and $0A to $C2002.
3. For readback, select the register, write $0B to $C2002, read $C2000,
   then return $C2002 to $0A.

The PIA direction registers are retained/readable, but electrical pin behavior
and printer handshakes are not fully modeled. Unconnected AY input ports
read as all ones. Registers 0..13 implement tone periods, noise, mixer,
amplitudes and envelope; registers 14/15 retain output latches.

Audio uses the QSound manual's 750,000 Hz clock, three tone generators,
17-bit noise generator, 16 envelope shapes and logarithmic volume levels.
Eight sub-samples per output sample and a DC-blocking filter are used. This
is functional emulation, not an analogue-exact model or a guarantee that
all hardware-specific waveform techniques are reproduced.

The AY output mixes with the existing IPC beeper into 48 kHz mono SDL audio.
Neither sound chip's clock is multiplied by CPU speed. Register updates use
the existing 400-microsecond machine slices, so sub-slice DAC tricks are not
cycle-accurate. --mute disables host output for both; --no-qsound disables
QSound only; --qsound re-enables it. Config key qsound accepts true/false.

References:
- QSound/QPrint manual, pages 9 and 21–22 (PIA registers, AY clock/registers):
  https://sinclairql.net/djw/docs/manuals/QSOUND-QPRINT.pdf
- Hardware-emulator author confirming the $C2000 placement:
  https://theqlforum.com/viewtopic.php?t=5352
- The user-supplied ql26inv code, routine at runtime $3B418, which drives
  $C2000/$C2002 with the register-select/write strobes above.

## Validation

`make test` includes QSound pitch, channel/noise/envelope/register-interface
checks plus BASIC POKE/PEEK and CLI/config enable/disable checks.
For the real demo (cartridge supplied separately):

```
make qlbox-qsound-demo
./qlbox-qsound-demo path/to/ql26inv.mdv
```

An optional second argument captures 15 seconds of native-endian signed
16-bit mono 48 kHz PCM. Recorded: 9699 AY writes, 705597 nonzero samples,
no IPC beeper starts; observed sample range -9760..16410, no clipping.
This is an execution/signal test, not a listening comparison against real hardware.

## Star freeze investigation: still open

The supplied raw `code` is byte-identical to the cartridge's extracted code.
It relocates itself, uses standard eight-colour mode and swaps the screen
banks at $20000 and $28000. It installs a polled-task node at $3AB80 through
the system-variable pointer at $2803C.

A fresh 1x replay on the bundled JS-derived ROM loses the callback at frame
2730. The zero-fill MOVEM at $30B7A (reported next PC $30B80) clears the
pointer's bytes from $0003AB80 to zero. Traced clear-loop A6=$28000,
recorded lower bound=1, upper bound=128. The routine at $30B44 computes
its starting address using `(lower_bound-3)*128`, plus the screen-bank
base and 128. It expands the clear above the drawing bounds without
clamping away the system-variable area in the second screen bank.

Frame IRQ acknowledgements continue, but the demo tick at $3AB72 remains
2648 and scene-table offset $3AB70 remains 444. The foreground renderer
continues executing, producing the apparently frozen star. The JS ROM's
polled-task dispatcher reads $2803C each time and sees the empty list.

At 20x from a fresh boot the R15 and R16 replays passed the star and reached the
closing scene. This demonstrates speed dependence, not that 20x will fix
all cases. Changing speed after losing the pointer does not repair it.
No alternate ROM or real hardware comparison has established why that
setup avoids this write. R16 does not protect this RAM address, patch the
demo, or change ROM interrupt handling. Sound support is independent of
that unresolved compatibility issue.

R16 closing-scene check: frame 4500, stage offset 576, demo tick 4496.
