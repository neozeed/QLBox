# Documented source edition

See [READABILITY_VALIDATION.md](READABILITY_VALIDATION.md) for token checks,
byte-identical rebuilds and the repeated Linux regression suite.

# R20 validation

- Full `make test` passed, including the new real-QDOS ZIP/UNZIP round trip.
- Embedded ROM1_ZIP and a mounted WIN1_ZIP copy both execute. ZIP 2.3 creates
  archives whose CRCs and text/binary payloads pass host ZIP verification.
- Guest UNZIP tests, pipes and extracts the archive; QDOS executable type and
  dataspace survive, and the extracted program executes successfully.
- The requested ELITEASM/README_MD command created a_zip successfully.
- The documented two-mount UNZIP extraction and BASIC Toolkit II ZIP
  command-tail launch passed.
- SDL keyboard/input and mouse-capture policy tests passed.
- Linux, Win32 and Win64 builds succeeded. Windows executables were
  cross-built, not runtime-tested. Real desktop cursor grabbing was not tested.

# R19 validation

- Full `make test` regression suite passed.

- Capture-policy test passes through real guest-read and SDL-event paths;
  only SDL_SetRelativeMouseMode is mocked to avoid requiring a desktop.
  Covers no-reader clicks/hotkeys, one-frame probes, disassembler reads,
  two-frame polling, 50-frame timeout/re-arm, focus loss, disable and wrap.
- SDL keyboard/input regression passes.
- Real Lemmings from the supplied QLWA.win: 991 of 1000 sampled frames
  eligible for capture after startup at 8x; continued QIMSI polling observed.
- Supplied ELITEASM: 0 of 1000 sampled frames eligible; no mouse-interface
  reads. Its title/load-commander screen was inspected to confirm execution.
- BASIC boot remains ineligible without mouse polling.
- Win32/Win64 cross-builds succeeded; Windows runtime testing is not available
  here. Real desktop cursor grabbing was not exercised in this environment.

# R18 validation

- Full `make test` passed, including timing slot boundaries, bus-width costs,
  selected Motorola instruction costs, both onboard DRAM banks, debugger-read
  isolation, reset, cycle carry, CLI/config precedence and BASIC in all modes.
- SDL input test passed; Linux and Win32/Win64 builds succeeded. Windows
  binaries were cross-built and not runtime-tested in this environment.
- Original unmodified ql26inv.mdv replay at 1x (no guest patch or debug hook):

| Mode | QSound firmware | Frames | Callback | Stage | Tick |
|---|---|---:|---|---:|---:|
| fast | no | 6000 | 0 | 444 | 2648 |
| 68008 | no | 6000 | 0 | 444 | 2648 |
| ql | no | 8000 | $3AB80 | 576 | 7822 |
| ql | yes | 8000 | $3AB80 | 576 | 7797 |

The ql-mode closing-scene image was inspected. The replay is a compatibility
result, not calibration against physical hardware; see TIMING.md for limits.

# R17 validation

- Full `make test` passed, including new firmware boot checks.
- QSound 1.31: 8 KiB and 16 KiB images initialise through JS expansion scan;
  POKE_AY/PEEK_AY commands work and direct PIA readback confirms hardware writes.
- ROM write protection, config loading, malformed/oversize/truncated/missing
  ROM rejection passed.
- SDL input test passed. Win32/Win64 cross-builds succeeded; Windows binaries
  were not runtime-tested in this environment.
- Firmware supplied by user; full command and printer compatibility unverified.

# R16 validation

- QSound unit/integration tests pass: 750 kHz tone pitch, A/B/C channels,
  deterministic noise, all 16 envelope shapes, retrigger, register masks,
  readback, PIA DDR/data selection, reset, MMIO and IPC beeper mixing.
- BASIC POKE/PEEK confirms default enable, --no-qsound, config disable,
  and CLI override of config. Full regression suite and SDL input pass.
- Actual unmodified ql26inv: 15 seconds at 20x, 9699 AY writes, 705597
  nonzero samples, no beeper calls; no clipping. No real-hardware listening
  comparison performed.
- Fresh 20x full replay reaches closing scene at frame 4500 with demo timer
  advancing. The 1x star freeze remains, traced to a guest screen clear
  overwriting the polled-task pointer. See QSOUND.md.
- Win32/Win64 cross-builds included; runtime validation performed on Linux.

# R15 validation

- Supplied ql26inv.mdv: 255 raw tape records; checksums valid. Two files:
  boot (135 bytes) and code (85336 bytes). Extraction compared byte-for-byte
  against independent assembly of the original image's file blocks.
- Original BOOT/LBYTES MDV1_CODE path launches animated graphics/scroller.
  Observed at frames 1200 and 3500 with 640 KiB RAM, speed 4.
- Generated cartridges: physical-order shuffle, fragmented blocks, $80/$f8
  map markers, stale free sectors, empty files, executable dataspace 910,
  MDV1 and MDV8 aliases, directory/copy/extract and execution after extraction.
- Read/seek/header and all write-rejection backend checks pass on MDV.
- Checksum, size, map, duplicate/missing-block and inconsistent-header
  corruption cases reject loading. Original image bytes remain unchanged.
- Full make test regression suite and SDL keyboard/input tests pass on Linux.
- Win32 and Win64 cross-builds included; not runtime-tested on Windows here.
- MDV support is limited to the documented QLAY raw cartridge layout;
  raw microdrive hardware access is not emulated.

# R14 validation

- SHUTDOWN at prompt, in a program, after IF, before a colon; case/whitespace.
- Named EXIT in FOR and REPeat loops retains stock behavior.
- Open host-file output and QDOS metadata survive shutdown.
- ROM1_EXIT via EXEC, TK2 EXEC_W, and headless --run.
- Full make test regression suite passed on Linux.
- SDL keyboard/input regression passed. Mouse capture test could not run with
  the available SDL dummy driver (no relative mouse mode); mouse code unchanged.
- Win32 and Win64 cross-compiled; Windows runtime check remains for the user.
- util/exit.s assembles byte-identically to the embedded util/EXIT.

# R6 validation — 23 October 2026

See [PHASE4.md](PHASE4.md) for the current R6 checks: seven CTest suites,
SDL input and audio capture, and concurrent jobs at speeds 1 and 8 all passed.
The following records the inherited R4 baseline.

# R4 validation — 23 October 2026

Linux x86-64:
- ROM rebuild and GCC builds for SDL and standalone CLI.
- CMake Release without SDL: ROM/BASIC, storage, backend and runner suites.
- SDL input regression: TV startup, text/Enter, guest POKE, held keys/focus.
- R2 tests retained: BASIC arithmetic/loops, 128/640 KiB, monitor/TV,
  MODE 4/8, SAVE/LOAD across restart, aliases, COPY/DELETE/DIR, BOOT,
  EXEC/EXEC_W and job-owned file cleanup.
- CLI tests: exact stdout, CRLF input, EOF, delayed input through QDOS retry,
  raw/joined/max-length command tails, successful and positive/negative
  error exits, timeout, missing file, untagged data, BOOT bypass,
  job-owned host-file cleanup, invalid/overflowing data-space metadata,
  incompatible ROM rejection and SIGINT.
- Launcher verified from another working directory and with 640 KiB RAM.
- SDL executable --run path also verified without opening a window.
- Main/terminal C99 strict warning checks are clean.
- No broad external application compatibility claim.

Windows:
- User live-validated R3 Win32 and Win64.
- R4 SDL and standalone qlrun binaries cross-built for both architectures.
- PE architecture and DLL import checks; qlrun requires no SDL DLL.
- R4 Windows runtime tests are still needed.

macOS:
- Portable source paths provided, including executable-relative ROM lookup.
- Not built or executed here.

ROM rebuilding retains the upstream disassembly's existing odd-alignment
warnings in serial tables. The original UK R2 source remains included.


R4 additions:
- Common-heap cleanup regression job exits after deliberately leaving an
  MT.ALCHP allocation owned by the job.
- Root directory headers identify directories in shared-read mode.
- Both unmodified recovered UnZip programs pass help, list, CRC, text/binary
  pipe, binary extraction over 64 KiB, executable metadata restoration,
  execution of the extracted job and no-overwrite checks.
- Both also run through graphical EXEC_W and return to BASIC after their
  deliberate exit-key prompt is acknowledged.
- All five CMake suites and the SDL input regression pass.
- No toolkit ROM was installed for these tests.
