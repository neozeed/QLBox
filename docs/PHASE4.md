# R6 / Phase 4: concurrent jobs and basic beeper

## Beeper

SDL builds play a single square-wave beeper by default. `--mute` disables host
output while retaining guest sound timing and status. If SDL cannot open an audio
device, the emulator reports it and continues. CLI/headless builds update beeper
state without opening an audio device or adding an SDL dependency.

Implemented: IPC command 10's complete 16-nibble packet, duration, first pitch,
zero-duration continuous tone, replacement tone, command 11 stop, and IPC status
bit 1. Consequently the real ROM's BASIC `BEEP` and `BEEPING`, as well as QDOS
MT.IPCOM callers, use the same backend. No ROM change was needed.

The first version intentionally uses the first pitch only: pitch 2, gradient,
wrap, fuzz and random parameters are consumed but do not modulate the waveform.
This is a functional beeper, not an instruction-accurate 8049 sound emulator.
The model uses 72 microseconds per duration unit, and a half-period of 72
microseconds times the encoded pitch (zero encoding means 256). BASIC adds one
to its pitch before passing it to IPC. Output is mono signed 16-bit PCM at 48 kHz.
Sound timing is independent of the CPU multiplier. Commands are sampled in
400-microsecond emulated-time slices. SDL queues audio on the main thread;
there is no audio callback racing the emulator. A small initial silence buffer
absorbs scheduling jitter, and queue growth is bounded. Host overload can still
cause audio gaps.

Try from BASIC:

```
BEEP 14000,20
BEEP 0,40
PRINT BEEPING
BEEP
LRUN WIN1_BEEP_BAS
```

The demo emits three finite tones then a continuous tone and stops it. Existing
Sarien executables can now produce sound from their current BEEP calls, but the
port's AGI-to-QL pitch/duration conversion remains experimental. Some calls last
only fractions of a millisecond. This release does not claim correct AGI music,
multiple voices, or fix the previously identified function-key mismatch.

References used for the functional model:
- Sinclair QL User Guide, BEEP: https://sinclairql.speccy.org/archivo/docs/sys/QL_UsersGuide.pdf
- User-supplied QLAY source, qlio.c, IPC sound packet and sound_process.

## Concurrent jobs

The new multijob test launches two genuine QDOS executables with EXEC. Each
opens two shared read channels on the same input and one exclusive output.
BASIC also holds a shared read channel. The jobs synchronize through a start
barrier, alternate reads with MT.SUSJB yields, verify that their two read positions
are independent, and write all 64 input bytes to separate outputs. Each exits
without closing its three channels. BASIC subsequently reopens both outputs;
RAM markers, output bytes and freed QDOS job slots are verified. This passes at
CPU multipliers 1 and 8. It tests seven simultaneous host-file channels, not
multiple emulator processes or arbitrary external file sharing.

## Validation

- Make: all existing boot/BASIC/video/storage/CLI/UnZip/backend suites pass.
- New beeper test: exact 72 ms sample duration, continuous tone, stop, actual ROM
  packet pitch/duration, BEEPING status, and operation at speed 8.
- SDL input regression passes unchanged.
- New concurrent jobs test passes at speeds 1 and 8.
- CMake Release without SDL: all seven tests pass.
- SDL disk audio backend receives nonzero PCM from the real BASIC demo; tested
  without physical speakers. Live Windows sound output is still to be verified.
- Win32 and Win64 SDL and CLI executables are cross-built. macOS was not built.
- Source remains C99, with no new library dependency besides SDL2 for the GUI.

Run `make test` for regression tests and `make test-sdl` with SDL development
headers for input tests. `tools/build-samples.sh` rebuilds the worker executables
using GNU m68k tools. The ROM retains its R4 ABI marker; R5 input/speed fixes and
its optional corrected Sarien sources remain included.
