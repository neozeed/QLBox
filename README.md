# QLBox

QLBox runs Sinclair QL software using a Musashi 68k CPU core and a modified,
UK-keyboard JS ROM. It combines an SDL desktop emulator with a command-line
QDOS program runner, writable host-directory drives, read-only disk and
microdrive images, sound, mouse input and debugging tools.

This is **R22**, fixing fragmented serial transfers and requesting Telnet BINARY mode for the outgoing Hayes TCP modem.

For QLTerm 3.00b2 downloads to WIN1, set **F3 → B → 32 → Enter** first.
This avoids its unbuffered final-block duplication. XMODEM and YMODEM downloads
have been verified with exact binary file comparisons; see [modem notes](docs/MODEM.md).
The readable source and contributor guides from R20 are retained. Start with
[the source guide](docs/SOURCE_GUIDE.md), [function reference](docs/FUNCTIONS.md)
and [provenance](docs/PROVENANCE.md). Changes are in
[RELEASE_NOTES.md](RELEASE_NOTES.md); test evidence is in
[docs/VALIDATION.md](docs/VALIDATION.md).

## Start here

Extract the complete package. Run commands below from its top-level folder;
keep the `rom`, `host` and `bin` directories in place. Windows 64-bit examples
are shown; replace `win64` with `win32` for the 32-bit build. Linux binaries
are in `bin/linux64`, without `.exe` suffixes.

```bat
bin\win64\qlbox.exe --ram 640 --mount host
```

This opens the QL screen and boots into SuperBASIC, executing the mounted
slot-1 BOOT file if present. `run-win64.cmd` and `run-win32.cmd` are convenience
launchers. The default without `--ram` is 128 KiB; 640 KiB is useful for games
and larger utilities. RAM options are 128 through 640 KiB in 64 KiB steps.
Use `--boot f1` for monitor layout; the default is F2/TV layout.

Inside BASIC:

```text
DIR WIN1_
DIR ROM1_
EXEC_W WIN1_ELITEASM
```

Use `EXEC_W` for a QDOS executable and `LRUN` for a BASIC loader. A type-0 raw
binary may need its supplied BASIC loader rather than direct execution.
The supplied guest software in your own mounts is not included automatically.

## What the package provides

| Area | Implemented features |
|---|---|
| CPU and OS | Musashi CPU, JS-derived 64 KiB ROM, UK keyboard table, real QDOS jobs/channels and scheduling |
| Display | Standard QL four-colour and eight-colour modes, both screen banks, SDL window scaling |
| Storage | Up to eight mount slots; writable host files with QDOS metadata; read-only QL5A, QL5B, QLWA and QLAY MDV images |
| Utilities | Embedded ROM1_ drive with ZIP, UNZIP, Toolkit II loader/binary, EXIT and README |
| Terminal | qlrun launches one QDOS executable with a command tail and host stdin/stdout |
| Sound | IPC beeper plus QSound AY tones/noise/envelopes; optional QSound ROM at boot |
| Serial modem | Hayes AT commands on SER1/SER2, outgoing hostname/IP TCP dialing, Telnet or raw mode |
| Mouse | QIMSI-compatible PS/2 packets; capture enabled only while the guest polls the interface |
| Timing | Fast default, optional 68008 bus-cost model, optional onboard-RAM contention |
| Debugging | Local GDB remote connection, registers/memory, stepping and execution breakpoints, guest logs, screen/RAM dumps |

`ROM1_` is a virtual read-only drive embedded in the emulator executable.
Adding ZIP there does not insert its machine code into the 64 KiB JS ROM
address space or consume guest RAM until it is loaded as a job.

## Drives, files and executable metadata

```bat
bin\win64\qlbox.exe --ram 640 --mount elite --mount2 utilities
```

Slot 1 exposes the host folder `elite`; slot 2 exposes `utilities`.
For each slot, `WINn_`, `HOSTn_`, `FLPn_` and `MDVn_` are equivalent aliases.
They are not four separate drives. `ROM1_` is always the utility drive.
Paths after `--mount` are host paths. Names such as `WIN1_ELITEASM` are guest
names, with at most 36 ASCII bytes for the file name.

Host payloads remain ordinary files. QDOS type, dataspace and other header
metadata are stored in a `.qlbox-meta` subdirectory; preserve it when moving
QL files. A valid trailing `XTcc` record supplies executable metadata when
no explicit sidecar exists. ZIP supplied with R20 has such a trailer, so a
mounted copy does not need manual tagging. Explicit sidecar metadata wins.

For an imported executable without metadata, use the correct dataspace from
its build or original header, for example:

```bat
python tools\qlfile.py exec elite\MYPROGRAM --data-space 4096
python tools\qlfile.py info elite\MYPROGRAM
```

4096 is an example, not a universal requirement. Incorrect dataspace can
break a program. Arbitrary Windows/DOS executables cannot run as QDOS jobs.
See [HOSTFS.md](docs/HOSTFS.md) for storage and metadata implementation.

## Command-line QDOS programs

`qlrun` boots the QDOS environment, starts one job, connects its console I/O
to the host terminal, waits for it to exit, and returns its status. It skips
the mounted BOOT file. It is intended for text utilities, not SDL games.

```bat
bin\win64\qlrun.exe --ram 640 --mount host --run WIN1_HELLO_EXE
```

`--args` supplies the exact QDOS command tail. Keep the complete tail inside
host-shell quotes. Alternatively, words after `--` are joined with spaces;
that form cannot preserve host-shell quoting that has already been removed.
`--frames N` is an optional execution watchdog, not normally required.
Use `--no-config` when you need a reproducible run unaffected by local settings.

See [RUNNER.md](docs/RUNNER.md) for the terminal and job-launch contract.

## ZIP: create an archive from a mounted directory

Suppose `elite` contains `ELITEASM` and `README_MD`. The built-in ZIP needs
no extra executable in that directory:

```bat
bin\win64\qlrun.exe --ram 640 --mount elite --run ROM1_ZIP --args "WIN1_a WIN1_ELITEASM WIN1_README_MD"
```

This creates `elite\a_zip`. The guest ZIP utility appends the QDOS `_zip`
extension when the archive name has none. It writes a standard ZIP archive,
including QDOS extra metadata where applicable. `ELITEASM` stays `ELITEASM`
inside the archive; `README_MD` becomes `README.MD`.

To use a mounted copy, copy the supplied executable first:

```bat
copy util\ZIP elite\ZIP
bin\win64\qlrun.exe --ram 640 --mount elite --run WIN1_ZIP --args "WIN1_a WIN1_ELITEASM WIN1_README_MD"
```

With `qlrun.exe` on your PATH, the same example is:

```bat
qlrun.exe --ram 640 --mount elite --run WIN1_ZIP --args "WIN1_a WIN1_ELITEASM WIN1_README_MD"
```

ZIP 2.3 runs as a genuine QDOS job. `util/ZIP` is not a host Windows program.
Use 640 KiB RAM: this binary requests 309476 bytes of dataspace in addition
to its code and OS/job overhead. The default 128 KiB is insufficient.
ZIP's normal default action adds or replaces archive entries.

Help and license:

```bat
bin\win64\qlrun.exe --ram 640 --run ROM1_ZIP --args "-h"
bin\win64\qlrun.exe --ram 640 --run ROM1_ZIP --args "-L"
```

## UNZIP: list, test, extract and pipe

The built-in utility is QDOS UnZip 5.41. These commands read the archive
created above:

```bat
bin\win64\qlrun.exe --ram 640 --mount elite --run ROM1_UNZIP --args "-l WIN1_a_zip"
bin\win64\qlrun.exe --ram 640 --mount elite --run ROM1_UNZIP --args "-t WIN1_a_zip"
bin\win64\qlrun.exe --ram 640 --mount elite --run ROM1_UNZIP --args "-p WIN1_a_zip README.MD"
```

The `-p` entry name is the name *inside* the ZIP, hence `README.MD` here.
Host redirection can save the output, for example `> readme.txt` in cmd.exe
or a POSIX shell. Use a binary-safe shell when redirecting binary contents.

To extract to a separate host folder while leaving the source folder alone:

```bat
mkdir extracted
bin\win64\qlrun.exe --ram 640 --mount extracted --mount2 elite --run ROM1_UNZIP --args "-n -j WIN2_a_zip -d WIN1_"
```

`-n` keeps existing files; use `-o` if you intend to overwrite them.
`-j` discards archive directory paths for a flat destination. QDOS names are
restored (`README.MD` becomes `README_MD`); executable headers/dataspace are
restored when the archive contains the appropriate QDOS extra fields.
A generic ZIP of a raw executable without QDOS metadata may require tagging.

From graphical BASIC, load Toolkit II once to use command tails:

```text
LRUN ROM1_TK2_BAS
EXEC_W ROM1_ZIP; "WIN1_a WIN1_ELITEASM WIN1_README_MD"
EXEC_W ROM1_UNZIP; "-l WIN1_a_zip"
```

Graphical utility builds may pause for a key before returning to BASIC.
The terminal runner avoids the need to automate the screen console.

## Disk and microdrive images

```bat
bin\win64\qlbox.exe --ram 640 --mount QLWA.win
bin\win64\qlbox.exe --ram 640 --mount ql26inv.mdv
```

Recognised formats are QL5A floppy images (with sector skew/interleave),
QL5B logical-sector images, QLWA containers and QLAY raw MDV cartridges
(255 records of 686 bytes). Formats are identified from content.
Image mounts are read-only. This is logical file access, not emulation of
physical tape rotation or disk-controller timing.

To obtain writable files, extract into a new directory:

```bat
bin\win64\qlimage.exe --list QLWA.win
bin\win64\qlimage.exe --extract QLWA.win extracted-game
bin\win64\qlbox.exe --ram 640 --mount extracted-game
```

Extraction preserves QDOS metadata and refuses an existing destination.
See [IMAGES.md](docs/IMAGES.md) for format scope and limitations.

## Keyboard, mouse and exit controls

| Control | Action |
|---|---|
| F12 | Quit the emulator |
| Ctrl+Space | QL BREAK |
| Ctrl+F11 / Ctrl+F12 | Decrease / increase CPU multiplier |
| Ctrl+F10 | Return to 1x CPU |
| Click / Ctrl+F9 | Capture mouse only while the guest actively polls it |
| Ctrl+F9 while captured | Release mouse |
| Window focus loss | Release mouse and guest button state |

Lemmings reads the QIMSI mouse registers and enables capture. The supplied
Elite executable does not, so clicking its window does not grab the mouse.
Polling must occur on two distinct frames; a one-frame probe is insufficient.
Capture releases after 50 emulated frames without reads. A resident mouse
driver that continues polling also qualifies. Polling never grabs the mouse
without a click/hotkey. `--mouse-speed 1..8` sets gain; `--no-mouse` disables it.

For the supplied Lemmings QLWA image, launch with 640 KiB and enter:

```text
LRUN WIN1_lemmings_bas
```

The first click captures; the next click reaches the game. See [MOUSE.md](docs/MOUSE.md).

In BASIC, `SHUTDOWN` exits cleanly. `EXEC_W ROM1_EXIT` provides an executable
exit stub. Ordinary BASIC `EXIT loopname` retains its normal language meaning.

## Dial a BBS through a serial terminal

```bat
bin\win64\qlbox.exe --ram 640 --mount qlterm --modem ser2
```

Start your terminal (`EXEC_W WIN1_QLTERM` for the supplied QLTerm build),
select `SER2I`, keep terminal local echo off, then type:

```text
AT
ATDT vert.synchro.net
ATDT test.whatever:2323
```

`AT` returns `OK`. Dialing uses port 23 unless a port is supplied; success
returns `CONNECT` and subsequent bytes travel to the server. These hostnames
are usage examples; release validation used local test servers only.

The supplied QLTerm 3.00b2 defaults to its own native TCP/Telnet interface.
Use F3, I (Interface), Enter to keep Echo Off, then select SER2I with the arrow
keys, Enter, and Enter again to retain baud. Use its serial interface here:
QLBox handles the TCP/Telnet connection beneath the modem.

Wait one second, type `+++` without Enter, then wait one second to enter
online command mode. `ATH` hangs up; `ATO` returns to the connection.
`--modem-mode raw` selects binary raw TCP. The default Telnet mode handles
IAC negotiation, ANSI terminal type, 80x24 size and NVT carriage returns.
`--modem off` disables this bridge. No connection is made until a guest dials.
QIMSI mouse support does not occupy either serial port.

See [MODEM.md](docs/MODEM.md) for installation, commands, testing and scope.

## Sound and QSound firmware

IPC beeper and QSound AY audio are enabled by default and mixed together.
QSound supports three tone channels, noise, envelopes and register access
through the PIA-compatible interface at $C2000. `--mute` silences host output;
`--no-qsound` disables the QSound hardware interface.

Optional firmware adds the QSound ROM's BASIC extensions:

```bat
bin\win64\qlbox.exe --ram 640 --qsound-rom rom\qsound-1.31.rom
```

The supplied firmware maps read-only at $C0000 and is found during JS startup.
Hardware registers override the overlapping ROM bytes. POKE_AY and PEEK_AY
are tested; not every firmware command or printer feature is validated.
Direct-register music players do not require the firmware. Sound-chip time
is independent of the CPU multiplier. See [QSOUND.md](docs/QSOUND.md).

## Timing: fast execution versus hardware-oriented experiments

| Option | Behaviour |
|---|---|
| `--timing fast` | Default, preserves the earlier instruction timing |
| `--timing 68008` | Adds cost for the 68008's 8-bit external transfers |
| `--timing ql` | Also applies ZX8301 contention to onboard RAM $20000-$3FFFF |

Use `--speed 1` for hardware-oriented comparisons. Higher multipliers remain
available for usability, but are not original-machine timing configurations.
The timing model is experimental and instruction-level, not cycle-exact.
Frame/audio pacing stays at the existing 50 Hz; exact raster phase, full
68008 prefetch/microcycle behaviour and physical peripheral timing remain
outside this model. See [TIMING.md](docs/TIMING.md) for sources and details.

### Example: the ql26inv star freeze

Disassembly and memory tracing found an initial screen-clear bound of 1 in
the decompressed scene. Its clear routine expands upwards and can erase the
polled-task pointer at $2803C when the active clear bank is $28000. IRQs and
foreground rendering continue, but the demo's scene tick stops at 2648.
At a different execution speed, that clear can hit bank $20000 instead,
leaving the callback intact. Merely running faster was therefore not a
reliable correctness fix.

A separate test cartridge changed two initial bounds from 1 to 4 and passed
at 1x. Subsequently the optional contention model let the **original,
unpatched cartridge** reach the closing scene, with and without QSound ROM:

```bat
bin\win64\qlbox.exe --ram 640 --speed 1 --timing ql --mount ql26inv.mdv
```

In the tested runs, `fast` and bus-only timing still froze, while `ql` timing
preserved the callback. This supports the contention hypothesis; it does
not prove a cycle-exact match to hardware or establish JS ROM incompatibility.
There is no demo-specific memory protection or patch in the emulator.

## Configuration

Copy `qlbox.conf.example` to `qlbox.conf` in the working directory, or use
`--config FILE`. Command-line options override config. `--no-config` ignores
it. Relative paths use the working directory, not the config file's folder.
Supported settings include RAM, speed, boot layout, ROM path, mount1..mount8,
mute, mouse/gain, QSound, QSound firmware and timing mode.

## Debugging and reproducible runs

```bat
bin\win64\qlbox.exe --ram 640 --gdb 1234 --gdb-wait
```

Connect an m68k-capable GDB to `127.0.0.1:1234`. Register/memory inspection,
stepping and execution breakpoints operate on the whole CPU. There are no
data watchpoints or reverse execution; guest job symbols/relocation are not
automatically discovered. Debugging is off by default and slows execution.

For a bounded headless run:

```bat
bin\win64\qlbox.exe --headless --ram 640 --mount host --frames 1000 --dump screen.ppm --ram-dump memory.bin
```

`--type FILE --type-at N` injects text through the guest keyboard path.
`--trace` logs IPC/key activity; `--debug-log FILE` captures guest diagnostics.
See [DEBUGGING.md](docs/DEBUGGING.md) for supported GDB operations and log ports.

## Building and testing

Linux with a C compiler, make and SDL2 development files:

```sh
make
make test
make test-sdl
make mouse-capture-test
```

`make headless` builds the runner and image tool without SDL. CMake is also
provided (`-DQLBOX_SDL=OFF` for a headless build). Windows cross-build support
is in `tools/build-mingw.sh`, using MinGW and an SDL2 MinGW SDK. No Python is
needed to run packaged binaries; Python 3 is used by tests and helper tools.
The build uses the supplied ROM binary; rebuilding its assembly requires
GNU m68k binutils and `make -C rom/qlbox-rom`.

`tools/embed-utils.py` regenerates `src/builtin_files.h` from `util/`.
Regenerate it and rebuild after changing an embedded utility. Full emulator
and modified ROM source are included; third-party utility binaries and
firmware do not imply their original source is included.

Tests cover ROM boot/keyboard, host files and metadata, concurrent jobs,
terminal execution, ZIP/UNZIP, Toolkit II, SHUTDOWN/EXIT, supported images,
extraction, XTcc detection, GDB, beeper, AY synthesis/firmware, timing slots,
configuration and mouse-capture policy. Mouse policy tests mock the host
SDL grab call; `make mouse-test` requires a display capable of relative input.
Optional game harnesses require separately supplied guest files.

Linux tests execute here; Windows binaries are cross-built. Full Windows
runtime testing, every game/ROM combination and physical-machine timing
calibration are not claimed. Consult [VALIDATION.md](docs/VALIDATION.md) for
specific evidence rather than treating a test pass as universal compatibility.

## Scope, provenance and limitations

QLBox deliberately uses ROM-assisted host storage and terminal services;
it is not a complete electrical simulation of a stock QL. It needs its
compatible JS-derived ROM, rather than supporting arbitrary ROM replacement.
Standard QL video is implemented, not later high-colour/high-resolution cards.
Image writing/formatting, physical microdrive timing and full expansion-board
emulation are not provided. Native mounts have constrained QDOS name/path
semantics, not a transparent mapping of arbitrary host filesystem trees.

The project grew through real-program tests: preserving QDOS headers matters
as much as copying payload bytes; a utility can work in a terminal while its
graphical console behaves differently; and instruction throughput alone is
not enough for timing-sensitive demos. Separate compatibility modes and
reproducible tests keep those distinctions visible.

See [LICENSE.md](LICENSE.md) for component provenance. Musashi, SDL2, Sinclair
ROM material, Toolkit II, QSound firmware and Info-ZIP retain their original
notices. ZIP 2.3 is the unchanged user-supplied QDOS binary; its embedded
license is reproduced in [ZIP-LICENSE.txt](docs/ZIP-LICENSE.txt). No Sierra,
Lemmings or Elite game data is bundled in this emulator release.
