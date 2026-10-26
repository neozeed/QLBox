# QLBox release notes

## R21 — outgoing Hayes TCP modem

- Added selectable SER1/SER2 modem (SER2 by default) through the existing
  QDOS channel bridge; the JS ROM binary is unchanged.
- ATDT accepts hostnames, IPv4 and bracketed IPv6, with optional port; default 23.
- Async DNS, nonblocking TCP, bounded queues, command/data modes, escape guard,
  Telnet option handling and raw binary transport.
- Added loopback transport tests, QDOS bridge tests and a real guest binary
  round trip; verified the supplied unmodified QLTerm 3.00b2 through its UI.
- Integrated the MSYS2 console-link fix and rebuilt Linux/Win32/Win64 binaries.
- No public BBS runtime, physical UART timing or Windows runtime validation is
  claimed. See docs/MODEM.md and docs/VALIDATION.md.

## R20 documented source edition

- Expanded runtime C formatting without changing identifiers or executable tokens.
- Added descriptions for all 152 runtime/image-tool C functions and every
  labeled block in the QLBox host-driver assembly.
- Added source walkthrough, function index and component acknowledgements.
- Preserved generated utility payloads, vendor code, historical JS source and
  existing binaries. No behavioral fixes or new features are part of this edition.
- See docs/READABILITY_VALIDATION.md for equivalence and regression checks.

## R20 — built-in ZIP and consolidated documentation

- Added the user-supplied, unmodified Info-ZIP 2.3 QDOS executable as
  `ROM1_ZIP`. Its XTcc trailer specifies 309476 bytes of job dataspace.
  The 94318-byte executable is also supplied as `util/ZIP`.
- ZIP is part of the embedded read-only utility drive; no ZIP file is needed
  in the mounted directory to use ROM1_ZIP. The JS ROM binary is unchanged.
- Added native guest ZIP/UNZIP round-trip tests, host CRC/payload checks,
  QDOS executable metadata restoration and execution after extraction.
- Replaced README.md with the overall project guide, examples, testing scope,
  timing investigation and known limitations. Earlier release entries follow.
- Supplied utility remains an Info-ZIP binary, not newly authored ZIP source.
  See docs/ZIP-LICENSE.txt for its embedded license.

## Earlier release entries

These describe the state at each release; the main README documents R20.

# QLBox R19 — capture only while the guest polls the mouse

Click-to-grab and Ctrl+F9 capture now require guest reads of the QIMSI mouse
registers on at least two distinct emulated frames within the last second.
A one-frame hardware probe or debugger/disassembler inspection does not arm
capture. BASIC and applications that do not poll the mouse leave it ungrabbed.

If polling stops for 50 emulated frames (about one second), capture releases
automatically. Focus loss and Ctrl+F9 still release immediately. Polling alone
never captures: click or press Ctrl+F9 again after a mouse-aware program starts.
The window title indicates when mouse capture is inactive.

Includes all R18 timing options and R17 QSound ROM support, plus updated
Win32/Win64/Linux binaries and full source. See docs/MOUSE.md for controls.

# QLBox R18 — optional bus and RAM-contention timing

Try the original, unpatched ql26inv.mdv with:

```
bin\win64\qlbox.exe --timing ql --speed 1 --ram 640 --mount ql26inv.mdv
```

`--timing fast` is the default and retains R17 behaviour. `--timing 68008`
adds the cost of 8-bit bus transfers. `--timing ql` also models the onboard
128 KiB RAM's ZX8301 access slots. Config equivalent: `timing=ql`.
QSound and the optional `--qsound-rom rom/qsound-1.31.rom` remain available.
Use 1x for hardware-oriented comparisons; higher multipliers accelerate
this model and are not an original-machine timing setting.

This is an experimental instruction-level timing model, not a cycle-exact
68008/ULA implementation. The original demo passes the star in the tested
contention configuration, but that alone is not timing calibration.
See [docs/TIMING.md](docs/TIMING.md) for implementation, sources and limits.

Includes Win32, Win64 and Linux binaries, full source and tests.

# QLBox R17 — QSound boot ROM

Load the included QSound 1.31 firmware during normal JS ROM startup:

```
bin\win64\qlbox.exe --qsound-rom rom/qsound-1.31.rom
```

This adds the firmware's SuperBASIC commands, including `POKE_AY` and
`PEEK_AY`. The optional ROM maps read-only at $C0000; the PIA registers at
$C2000–$C2003 still take precedence. No changes to the JS ROM are needed.
The supplied 16 KiB image is included byte-for-byte from QSOUND_V1.31.
Valid 8 KiB images are also accepted. Configuration equivalent:
`qsound_rom=rom/qsound-1.31.rom` (paths relative to the working directory).
The switch loads firmware; `--no-qsound` still independently disables the
sound hardware. Without the switch, R16's direct-access audio remains available.

Includes updated Win32, Win64 and Linux binaries and full source.

# QLBox R16 — QSound / AY audio

QSound audio is enabled by default at $C2000. Direct hardware players such
as ql26inv now produce audio alongside the existing IPC beeper.

```
bin\win64\qlbox.exe --ram 640 --speed 20 --mount ql26inv.mdv
```

Includes three tone channels, noise, all envelope shapes, register readback,
and a functional PIA interface. Sound-chip time remains independent of CPU
speed. `--mute` silences both chips; `--no-qsound` disables only QSound.
Configuration: `qsound=true` (default) or `qsound=false`.

The demo's speed-sensitive star freeze remains; booting at 20x passed that
scene in testing. Increasing speed after it freezes does not restore its
lost callback. No guest code or ROM is patched to conceal this behavior.
See [docs/QSOUND.md](docs/QSOUND.md) for implementation and investigation notes.

Includes Win32/Win64/Linux binaries, full source, and all R15 features.
In R16, no QSound firmware or new SuperBASIC AY commands were installed;
direct register access was available immediately. The user's demo is not bundled.

# QLBox R15 — microdrive images

QLAY `.mdv` cartridges now mount directly, with `MDV1_`–`MDV8_` aliases.
This supports the supplied 174930-byte `ql26inv.mdv` without modifying it:

```
bin\win64\qlbox.exe --ram 640 --mount ql26inv.mdv
```

Its original BOOT runs automatically; the animated graphics/scroller is
verified. Existing floppy/hard-disk formats and R14 shutdown commands remain.

Image mounts are read-only. `qlimage --extract IMAGE NEW_DIRECTORY` preserves
QDOS file headers and gives you a writable directory mount. See
[docs/IMAGES.md](docs/IMAGES.md) for supported format details and examples.

Includes Win32/Win64/Linux binaries and full source. Cartridge not bundled.

# QLBox R14 — graceful shutdown

Type `SHUTDOWN` at the BASIC prompt or use it in a BASIC program.
Alternatively use `EXEC ROM1_EXIT` (or `EXEC_W ROM1_EXIT` with Toolkit 2).
Both request normal host cleanup: open files and metadata are saved, debug
connections close, and SDL/audio resources are released. Host exit status is 0.
Use the bundled updated `rom/js-rom.bin` and emulator together.

`EXIT loopname` retains stock SuperBASIC behavior. No EXIT parser changes.
The executable stub lives in the built-in read-only drive; no installation
or Toolkit 2 is needed for `EXEC ROM1_EXIT` or `SHUTDOWN`.

Guest byte write 1 to $18122 requests shutdown (other values ignored).
Shutdown closes the emulator; it does not run application-specific save commands.

Includes Win32, Win64, Linux64, full source and all R13 features below.

# QLBox R13 — mouse input

Lemmings now detects a QIMSI-compatible mouse automatically. Click the window
to capture, then use the mouse normally. **Ctrl+F9 releases/recaptures**;
losing focus also releases it. Left/right/middle buttons and wheel are supported.
`--mouse-speed N` selects gain 1..8 (default 2); `--no-mouse` disables it.

```
bin\win64\qlbox.exe --ram 640 --speed 4 --mount QLWA.win
```

Then `LRUN WIN1_lemmings_bas`. Verified by mouse from the main menu into the
running first level, using the unmodified game. See [docs/MOUSE.md](docs/MOUSE.md)
for controls, tests and the limits of this mouse interface. General Pointer
Environment applications require their own QIMSI driver; no AY sound added.

Win32/Win64 and Linux64 binaries, full source; macOS source only.
All R12 disk-image and earlier debugger/storage/beeper features are retained.

## Previous release notes

# QLBox R12 — floppy and hard-disk image mounts

Mount QL5A/QL5B floppy images or QLWA hard-disk images directly with `--mount`:

```
bin\win64\qlbox.exe --ram 640 --speed 4 --mount QLWA.win
```

Then `LRUN WIN1_lemmings_bas`. The supplied Lemmings image reaches its menu;
the supplied 198ad floppy reaches its opening story with the loader workaround
in [docs/IMAGES.md](docs/IMAGES.md). Images preserve QDOS headers automatically.
`FLP1_`..`FLP8_` are aliases of the corresponding WIN/HOST mount slots.

Image mounts are read-only. For writable games/saves, use the new native tool:

```
bin\win64\qlimage.exe --extract QLWA.win lemmings
bin\win64\qlbox.exe --ram 640 --speed 4 --mount lemmings
```

Extraction preserves metadata and requires a new destination directory.
See [docs/IMAGES.md](docs/IMAGES.md) for both games, mounting, limits and tests.
Win32/Win64 and Linux64 binaries included; macOS source support only.
GDB, beeper, ROM1 utilities, keyboard, configs and XTcc detection are retained.

## Previous release notes

# QLBox R11 — debugger, guest diagnostics, keyboard and multiple mounts

GDB: `qlbox --ram 640 --gdb 1234 --gdb-wait`, then connect a m68k-capable
GDB to `127.0.0.1:1234`. Guest byte output port: `$18120`; control: `$18121`.
See [docs/DEBUGGING.md](docs/DEBUGGING.md) for commands, examples and limits.

This package also completes the interrupted R10 work: F6-F10 keyboard aliases,
Sarien function-key source fix, WIN1_..WIN8_ mounts, and optional qlbox.conf.
See [docs/R10-QOL.md](docs/R10-QOL.md) and qlbox.conf.example.
Use the included ROM with these binaries: channel drive numbers were updated
for multiple mounts. R9 XTcc detection and R8 ROM1_ utilities are retained.

Windows 32/64 and Linux64 binaries plus full sources. macOS source support;
no macOS binary was built here.

## Earlier releases

# QLBox R9 — automatic XTcc executable metadata

Copy a QDOS GCC/C68 executable carrying an XTcc trailer into your mounted
directory and run it directly. No qlfile tagging or sidecar is needed:

```
bin\win64\qlrun.exe --ram 640 path\to\hello
```

Or from BASIC: `EXEC_W WIN1_hello`.

When no explicit QDOS sidecar metadata exists, QLBox checks the last eight
bytes for `XTcc` followed by a big-endian 32-bit dataspace value. It exposes
executable type 1 and that dataspace in file headers and directory entries.
The trailer remains in the file and file length is unchanged. Detection
writes neither the payload nor metadata. Explicit metadata, including an
intentional data-file type, takes precedence. Unrecognised files stay data.
Values that would overflow the supported signed job-allocation size are not
accepted. Memory availability is still decided by QDOS when loading the job.

`tools/qlfile.py info FILE` also reports inferred metadata and its source.
The existing `exec` and `data` actions remain explicit overrides.

Validated with the supplied 14028-byte GCC hello (dataspace 910) through
qlrun and BASIC EXEC_W, plus header/directory reads, explicit overrides,
invalid/truncated trailers and preservation of file bytes.

Includes the R8 utility drive and R7 runtime speed controls below.
Win32/Win64 and Linux64 binaries included; macOS source support only.

# QLBox R8 — built-in utility drive

`ROM1_` is a read-only drive embedded in the executable. It is available
alongside `WIN1_` regardless of which host directory you mount.

```basic
DIR ROM1_
LRUN ROM1_TK2_BAS
EXEC_W ROM1_UNZIP; "-o -j WIN1_ARCHIVE_ZIP -d WIN1_"
```

Load Toolkit 2 once per boot when wanted. The loader reserves 17396 bytes,
loads the supplied 16396-byte TK2 v2.12 image, and calls offset 1380.
It does not install automatically. Loading a BASIC program with LRUN replaces
the current BASIC program, so save any work first.

The argument-taking EXEC_W example above uses TK2. Plain `EXEC_W ROM1_UNZIP`
also displays Unzip help. Use `--ram 640` for Unzip and larger applications.
From a host terminal:

```
qlrun --ram 640 --mount YOUR_DIRECTORY --run ROM1_UNZIP --args "-o -j WIN1_ARCHIVE_ZIP -d WIN1_"
```

Contents: UNZIP (Info-ZIP 5.41, with executable metadata), TK2_BIN, TK2_BAS,
README_TXT. Files cannot be overwritten, renamed, truncated or deleted.
The source inputs are in `util/`; `python3 tools/embed-utils.py` regenerates
`src/builtin_files.h` before rebuilding. The drive needs no runtime asset folder.
TK2_BIN is the user-supplied RAM-loadable image; its existing credits remain
intact. Unzip is the same recovered executable distributed with R6/R7.

R7 speed controls remain: Ctrl+F12 increases by 1x, Ctrl+F11 decreases by 1x,
Ctrl+F10 resets to 1x. Range 1–64; the title shows the setting. Timers/audio
retain their normal rate. Windows 32/64 and Linux64 binaries are included;
macOS has source/build support but was not built here.

## Earlier changes

# QLBox R6 — Phase 4: concurrent jobs and beeper

R6 adds audible single-tone IPC beeper support to SDL builds (on by default;
`--mute` disables output) and validates concurrent QDOS jobs with shared files
and job-owned channel cleanup. Try `LRUN WIN1_BEEP_BAS` from BASIC.
Duration, pitch, stop and BEEPING work; advanced sweep/noise effects are not yet
implemented. See `docs/PHASE4.md` for behavior, tests and limits.


R5 adds `--speed 1..64` (default 1) while retaining the 50 Hz timer, and fixes
synthetic Ctrl being lost when Backspace/Delete repeat or another key changes.
Try `bin\win64\qlbox.exe --ram 640 --mount C:\path\to\sar --speed 8`,
then `EXEC_W WIN1_sar` in BASIC. At Sarien's drive prompt, press Enter for WIN1_.

Corrected Sarien source is in `samples/sarienQL-fixed`; rebuild it using your
existing QDOS compiler (`make clean`, then `make`). No rebuilt Sarien binary is
included. See `docs/SARIEN.md` for findings, validation and remaining limitations.
The R4 ROM is unchanged and remains the required ROM ABI.

QLBox runs the UK QDOS JS ROM on Musashi with SDL2 video and keyboard.
The graphical emulator boots directly into TV mode and skips the hardware RAM test
(RAM is still cleared). QDOS retains its BASIC interpreter, console, graphics,
scheduler, job loader and channel management.

## Included UnZip programs

UNZIP532 and UNZIP541 are recovered directly from your uploaded Job2Bas
wrappers, with their original executable metadata. No toolkit or Python is
needed to run these bundled binaries.

    bin\win64\qlrun.exe --ram 640 host\UNZIP532 --args "-h"
    bin\win64\qlrun.exe --ram 640 host\UNZIP532 --args "-t WIN1_DEMO_ZIP"
    bin\win64\qlrun.exe --ram 640 host\UNZIP532 --args "-o -j WIN1_DEMO_ZIP -d WIN1_"
    bin\win64\qlrun.exe host\FROMZIP_EXE

Use win32 for the 32-bit binaries, or UNZIP541 for version 5.41.
The demo archive contains a text file and a QDOS executable. Extraction restores
the executable metadata automatically. -o overwrites existing destination files;
-n instead preserves them. -j discards archive directory paths because this
release still provides a flat mounted directory.

For your own archive, copy it into host (for example MYFILES_ZIP) and substitute
WIN1_MYFILES_ZIP in the command. The entire ZIP remains a normal host file.
Not every ZIP carries QDOS metadata: only those with QDOS header extra fields
can restore executable type and data space automatically.

The uploaded BASIC wrappers use ALCHP/RECHP, which are not stock JS BASIC
commands, and contain over 400 KB of DATA text. The default 128 KiB is insufficient.
Direct recovery avoids these loader requirements. UnZip itself does not require
those BASIC extensions. Use --ram 640 for these utilities.

R4 fixes common-heap job cleanup in the ROM, gives host file channels a
directory-driver identity so C runtimes allow seeks, and supplies correct root
directory header semantics. The UnZip executables themselves are unmodified.
See docs/UNZIP.md for details.

## Run a program in the terminal

The new qlrun executable needs no SDL DLL. Extract the whole archive and try
these commands from the project directory on Windows:

    bin\win64\qlrun.exe host\HELLO_EXE
    echo hello | bin\win64\qlrun.exe host\ECHO_EXE --args "test arguments"
    bin\win64\qlrun.exe host\ECHO_EXE --args exit37
    echo %ERRORLEVEL%

Use bin\win32 for 32-bit Windows. On Linux:

    ./bin/linux64/qlrun host/HELLO_EXE
    printf 'hello\n' | ./bin/linux64/qlrun host/ECHO_EXE --args "test arguments"

--run FILE is an explicit equivalent to the positional executable argument.
The SDL executable also accepts --run and opens no window in that mode.

A host path automatically mounts its parent directory. Alternatively:

    bin\win64\qlrun.exe --mount "C:\QLFILES" --run WIN1_MY_PROGRAM --args "raw command tail"

The ROM is found relative to the executable, including from another working
directory; --rom overrides it. Keep the extracted directory structure intact.
CLI startup initializes TV mode, skips BOOT and launches the selected job
through QDOS. Output goes to stdout; input comes from stdin; diagnostics go to
stderr. The process exits when QDOS reports that the launched job has finished.
Exit 0 means success; nonzero QDOS status is printed and mapped to its absolute
value, capped at 255. Ctrl+C returns 130. --frames N limits execution and
returns 124 if the job has not finished.

This is a stream terminal, not a full-screen terminal emulator. CON/SCR text
writes work; CON reads support bytes, lines and blocks. Screen positioning,
graphics, window-control calls and custom screen-driver extensions return
unsupported. All text channels share stdin/stdout. Use SDL for graphical
programs. Interactive input is line-oriented on POSIX; Windows supports basic
typing/backspace. Non-ASCII character conversion is not implemented.

See docs/RUNNER.md for the guest stack contract, limits and implementation.

## Run the graphical emulator

Extract the whole archive. On Windows double-click run-win64.cmd or
run-win32.cmd. On Linux run ./bin/linux64/qlbox from this directory.
The Linux SDL executable needs the system SDL2 runtime. F12 exits.

At the BASIC prompt try:

    DIR WIN1_
    LOAD WIN1_HELLO_BAS
    RUN
    EXEC_W WIN1_HELLO_EXE

HELLO_EXE is a real 68000 QDOS job, with its own console window.
EXEC starts a job asynchronously; EXEC_W waits for it to finish.

The default mount is the included host directory. Select another existing
directory with --mount, for example:

    bin\win64\qlbox.exe --mount "C:\QLFILES"
    ./bin/linux64/qlbox --mount /home/me/qlfiles

WIN1_ and HOST1_ refer to the same mount. SAVE, LOAD, COPY, DELETE, DIR,
LBYTES/SBYTES and executable loading use the ROM's ordinary file channels
and the new host-backed device driver. File operations can modify real files.
A file named BOOT in the mounted directory runs at startup.

--boot f1 selects monitor layout; TV is the default.
--ram 640 selects 640 KiB RAM (default 128; 64 KiB steps).
--help lists diagnostic and scripted-input options.
UK ROM keyboard tables are included. ASCII input, arrows, function keys,
Ctrl/Alt chords and held-key scanning are supported. Ctrl+Space is BREAK.

## Host files and executable metadata

The mount is flat: WIN1_MY_FILE maps to the host file MY_FILE. Underscores are
literal. Names are case-insensitive, at most 36 ASCII characters, and must
also be valid portable Windows filenames. Avoid names differing only by case.
Subdirectories, symbolic links and Windows reparse-point files are excluded.

Host files contain raw payload bytes. QDOS metadata lives separately in
host/.qlbox-meta. Preserve this directory when copying a collection of files.
Ordinary BASIC/data files do not need manually created metadata. An executable
needs its QDOS type and additional data-space requirement:

    python3 tools/qlfile.py exec host/MY_PROGRAM --data-space 4096
    python3 tools/qlfile.py info host/MY_PROGRAM

Use the program's actual required data-space value. This does not convert
Windows/DOS EXEs or arbitrary bytes into QDOS programs. Strip any external
container headers before importing a raw QDOS payload. QDOS SEXEC can also
set executable metadata through the driver.

The driver supports open/create/overwrite/shared-read/directory channels,
byte/line/block I/O, headers, seek, flush, rename, truncate and delete.
QDOS owns channel allocation and closes a job's channels when it exits.
There are 64 host handles. Directory listings use synthetic capacity values.
Metadata updates are not crash-atomic; concurrent external editing is unsupported.

## Build

A C99 compiler and SDL2 development files are sufficient; Musashi's generated
opcode sources and the ROM binary are included.

    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build --parallel
    ctest --test-dir build --output-on-failure
    ./build/qlbox

Or use make and make test; make test-sdl tests the input frontend.
make headless needs no SDL. CMake -DQLBOX_SDL=OFF does likewise.

Linux: install a compiler, CMake and SDL2 development package.
macOS Intel/Apple Silicon: install Xcode Command Line Tools, CMake and matching
SDL2; set CMAKE_PREFIX_PATH to the SDL2 installation if needed.
Windows: use MinGW-w64 and SDL2 for the target architecture; copy SDL2.dll next
to the executable. tools/build-mingw.sh builds SDL and standalone CLI binaries for both Windows targets.
MSVC and macOS builds have not been validated here.

The included Windows R6 binaries were cross-built; live Windows R6 validation
is pending. Linux R6 regression and SDL input tests pass. See docs/SARIEN.md.
The Linux binaries were built on Ubuntu 24.04; rebuild for older glibc systems.

## ROM and implementation

rom/js-rom-gas-r2 preserves the supplied UK source. rom/qlbox-rom is the
modified source; rom/js-rom.bin is the resulting 64 KiB QLBox-specific ROM.
It is not a hardware-compatible replacement ROM.

To rebuild using GNU m68k binutils:

    make -C rom/qlbox-rom CROSS=m68k-linux-gnu-
    cp rom/qlbox-rom/build/qlbox.bin rom/js-rom.bin
    python3 tools/rom-symbols.py

The ROM registers a QDOS device driver with ordinary open/I/O/close entries.
A compact MMIO request bridge calls the C host backend; system calls are not
intercepted by matching the guest program counter. See docs/HOSTFS.md.

This remains an early compatibility runtime: no physical microdrives,
networking or cycle-accurate hardware. One flat writable mount, no extended
filesystem date/version services, and no non-ASCII host text input.
Without --run, --headless remains the diagnostic framebuffer mode. With
--run, both qlrun and qlbox-headless use the same terminal runner.

See docs/VALIDATION.md for checks and LICENSE.md for component provenance.
