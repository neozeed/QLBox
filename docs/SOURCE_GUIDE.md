# Reading QLBox

This edition documents R20 without changing its executable logic. Begin with
`src/main.c`, `src/ql.h` and `src/ql.c`, then follow one device at a time.
Every function in `src/*.c` and `tools/qlimage.c` has a purpose comment;
[FUNCTIONS.md](FUNCTIONS.md) is the corresponding searchable index.

## What runs where

QLBox has three cooperating layers. Musashi executes guest 68k instructions.
The JS-derived ROM supplies QDOS, SuperBASIC, channel management and job
scheduling. QLBox supplies machine devices, host integration and presentation.
The host does not reimplement SuperBASIC or schedule QDOS jobs itself.

The desktop and command-line runners share the same CPU and machine state.
SDL presents pixels, audio and input. The terminal runner instead starts a
QDOS executable through the ROM loader and connects stream channels to host
stdin/stdout. It is still a running guest OS, not a host translation of the
QDOS executable.

## Suggested reading order

| File | What to look for |
|---|---|
| `src/main.c` | Config precedence, initialization, desktop/headless loop and cleanup |
| `src/ql.h` | Single-machine state and guest address-space backing array |
| `src/ql.c` | CPU callbacks, address decoding, IPC, frame scheduling and pixels |
| `rom/qlbox-rom/src/host_driver.s` | Guest half of host file and terminal operations |
| `src/hostfs.c` | Host half: mount selection, handles, sidecars and QDOS errors |
| `src/terminal.c` | Tagged stream handles, input buffering and asynchronous retry |
| `src/imagefs.c` | Validating read-only image decoders |
| `src/beeper.c`, `src/qsound.c` | Independent emulated sound clocks and PCM mixing |
| `src/mouse.c`, `src/sdl_input.c` | Device packet state versus desktop capture policy |
| `src/debugger.c` | GDB packet processing, execution control and guest diagnostics |
| `tools/qlimage.c` | Image listing and metadata-preserving extraction |

## A file read, end to end

A guest program invokes a QDOS trap. QDOS locates its channel and calls
`host_io` in the ROM driver. That routine saves D0-D3/A0-A1 as six big-endian
longs on the guest stack, writes their address to $18104 and writes command 2
to $18100. The CPU memory callback reaches `raw_write8`, which first offers
the request to the terminal driver and then to `hostfs_command`.

The host checks the guest range, decodes the registers and resolves the
channel's host handle. `io_file` selects the QDOS operation; `transfer` moves
bytes and updates the position, count and guest pointer. Results are written
back into the same six slots. The ROM restores the registers and returns to
QDOS. A pending terminal read returns not-complete so QDOS can retry through
its normal scheduling machinery.

File payload and QDOS metadata are different things. Native payload files
contain their original bytes; `.qlbox-meta` holds 64-byte headers. XTcc can
provide executable type/dataspace when no explicit sidecar exists. Image
headers and ROM1 entries supply the equivalent information themselves.
Filename matching folds ASCII case but does not equate dots with underscores:
`VOL.0` and `VOL_0` are distinct. This explains the Sarien startup failure
whose unchecked read left the bytes `vo` (766f) in its signature buffer.

## Addresses and byte order

| Guest address | Purpose |
|---|---|
| $00000-$0FFFF | Bundled 64 KiB JS-derived ROM |
| $0FEDD-$0FEDF | QIMSI mouse registers, taking priority over underlying ROM |
| $18000-$18003 | Clock reads; IPC serial writes at $18003 |
| $18020-$18021 | IPC reads and interrupt status/control |
| $18063 | Display mode and screen-bank control |
| $18100 / $18104 | Bridge command / six-register request pointer |
| $18110-$1811C | Configured RAM, boot/runner state and result handshake |
| $18120-$18122 | Guest diagnostics, debugger control and SHUTDOWN |
| $18200 / $18300 | Counted runner filename / command tail |
| $20000-$3FFFF | Original onboard RAM, including screen banks |
| $40000 to configured top | Expansion RAM, up to $BFFFF |
| $C0000 | Optional QSound expansion ROM |
| $C2000-$C2003 | QSound PIA registers; these override expansion-ROM bytes |

The 1 MiB backing array is not proof that every address is writable memory.
`raw_read8` and `raw_write8` define the bus contract. Multibyte guest values
are assembled explicitly; host pointer width and host byte order are not
used as the guest data layout. `r[0..5]` in bridge code means D0,D1,D2,D3,A0,A1.
Most driver routines return zero or a negative QDOS error, whereas startup
helpers commonly return a boolean. Read the function contract before testing
its result; these conventions intentionally differ.

## Frame and sound timing

`ql_frame` asserts the frame IRQ and runs fifty 400-microsecond slices per
nominal 20 ms frame. Each slice executes the CPU budget, renders the beeper
into a PCM buffer and adds QSound. CPU speed changes the instruction budget,
not the sound-chip clock. Video is rendered from memory after execution;
there is no per-pixel raster fetch history.

Fast mode retains Musashi timing. Optional callbacks account for 68008 byte
bus costs and local RAM contention. Their bus cursor follows callback order,
not a complete real-CPU microcycle/prefetch model. Overshoot is carried as
slice debt. See [TIMING.md](TIMING.md) for the hardware sources, approximations
and the original ql26inv callback-overwrite investigation. A demo passing is
a compatibility result, not a claim of cycle-exact hardware calibration.

## Ownership and state

`QL ql` is the single guest instance. Host file handles and terminal channels
live in their respective modules. An ImageFS owns copies of decoded file
payloads and is freed on unmount/shutdown. Temporary directory snapshots and
allocation-chain buffers are freed by their callers. SDL capture is frontend
state; mouse packet/read activity is device state. Keeping those separate
allows guest polling to gate capture without automatically grabbing a cursor.

The debugger's memory packet handler restricts direct access to ROM/RAM.
Musashi disassembler callbacks avoid timing charges and mouse consumption,
but their fallback raw reads are not a universal side-effect-free MMIO API.

## ROM source and historical labels

The original JS disassembly is an essential inherited component. Labels such
as `l02fae` preserve historical addresses and cross-references; they are not
an attempt to hide new code. The original commented material and GAS
conversion are kept in `rom/js-rom-gas-r1` and `rom/js-rom-gas-r2`.
The active modified ROM is in `rom/qlbox-rom`.

New bridge routines in `host_driver.s` now have descriptions, including
internal branch targets and the driver tables that are data rather than
procedures. `host_basic_commands.s` extends the existing BASIC table with
SHUTDOWN while retaining the stock table's layout and provenance. Existing
JS assembly and comments are preserved rather than inventing meanings for
thousands of inherited labels. The source guide does not claim a fresh
procedure-by-procedure annotation of the whole Sinclair ROM.

## Generated code and third-party code

`src/builtin_files.h` is a generated byte representation of ROM1 utilities.
Its large arrays are executable/data payloads, not handwritten emulator
logic. Edit `util/` and run `tools/embed-utils.py` to regenerate them.
`src/rom_symbols.h` names the bundled ROM observation points.

Musashi, its generated opcode handlers and SoftFloat retain their original
formatting and notices. Tests, helper scripts and historical sample projects
also retain their existing behavior and source. This pass concentrates on
QLBox's runtime C, the image tool and the new guest bridge. See
[PROVENANCE.md](PROVENANCE.md) for the distinction between inherited source,
interface references and QLBox integration work.

## Maintenance

The included `.clang-format` expands compressed statements without sorting
includes or changing identifiers. Keep the compact and documented R20
packages separate if comparing them. `tools/verify-readable.py BASELINE`
checks C lexical tokens, function-comment coverage, assembly non-comment
content and protected third-party/generated files against the original R20.
See [READABILITY_VALIDATION.md](READABILITY_VALIDATION.md) for results.
