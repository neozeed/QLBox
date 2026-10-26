# Provenance and acknowledgements

QLBox's contribution is its machine/host integration and tested combination
of desktop emulation, native host drives, real-QDOS terminal jobs, image
readers, audio, input and diagnostics. It uses substantial existing work.
This document distinguishes those dependencies from hardware/interface
references; it does not claim the CPU or operating system was written here.

| Component or reference | Relationship to QLBox | Evidence in this package |
|---|---|---|
| Sinclair JS ROM and supplied commented disassembly | Inherited OS/BASIC code, converted to GNU assembler and modified for this machine | `rom/js-rom-gas-r1/original/`, the R1/R2 READMEs and `rom/qlbox-rom/src/` |
| Musashi, Karl Stenerud | Bundled CPU implementation; QLBox uses its 68000 core and adds timing callback integration | `vendor/musashi/readme.txt`, source notices, `m68k_set_cycle_callbacks` and `m68k_add_wait_cycles` |
| SoftFloat | Bundled within the CPU dependency, with its own notices | `vendor/musashi/softfloat/` |
| QLAY, Jan Venema | Existing implementation informed IPC, keyboard, video and image-format handling | `QLAY-LICENSE.txt`; comments in `src/ql.c`, `beeper.c`, `imagefs.c` |
| SDL2 | Host window, input and audio services; bundled Windows runtime | `SDL2-LICENSE.txt`, `src/main.c`, `src/sdl_input.c` |
| Motorola and Sinclair hardware manuals; Nasta's ZX8301 investigation | Basis for the experimental bus/contention model, not copied CPU implementation | Source references and qualifications in `TIMING.md` |
| QDOS/SMS reference material and QLAY image tools | Disk allocation, directory/header and cartridge-format references | `IMAGES.md`, `src/imagefs.c` |
| QIMSI mouse interface documentation | Guest-visible packet/register compatibility target; other QIMSI devices are not emulated | Reference links in `MOUSE.md`, `src/mouse.c` |
| QSound/QPrint and AY documentation | Register, clock and synthesis behavior used by the functional sound model | `QSOUND.md`, `src/qsound.c` |
| Jochen Merz QSound V1.31 (1987) | User-supplied optional firmware, not QLBox-authored ROM code | `rom/qsound-1.31.rom`, `QSOUND.md` |
| Toolkit II | Bundled utility loader/binary, not a new QLBox BASIC implementation | `util/TK2_BAS`, `util/TK2_BIN`, original embedded notices |
| Info-ZIP | Unmodified QDOS ZIP and recovered UNZIP binaries, embedded in ROM1 | `ZIP-LICENSE.txt`, `UNZIP.md`, `util/`, `samples/unzip/` |
| Sarien and its QL port | Separate guest example project with retained upstream/GPL notices and local fixes | `samples/sarienQL-fixed/` and its source headers |

## The ROM is a foundation, not merely inspiration

The JS ROM executes as guest code and provides the real QDOS system services.
The source conversion retained the supplied disassembly's attribution and
comments; the reference build was checked against its original image as
documented in the ROM conversion README. The active QLBox ROM then adds the
host device bridge, runner startup, keyboard selection and SHUTDOWN entry.
The bridge still uses QDOS channel allocation, job creation and scheduling.

## What this source edition establishes

The documented C and bridge assembly expose how the integration works and
where existing components enter it. Function descriptions, an architecture
walkthrough and preserved upstream notices make those boundaries reviewable.
This is more precise than claiming universal superiority over other emulators
or describing all included code as original QLBox work.

No license or ownership has been reassigned by this documentation pass.
`LICENSE.md` remains the component-provenance entry point; each bundled
component retains its own notices. Where the supplied material does not
establish an author or grant, this edition does not invent one. The guide
adds no blanket license to Sinclair ROMs, utility binaries or sample code.

## R21 modem references

The modem is new QLBox bridge/transport code. The supplied QLTerm source was
read to identify its QDOS serial calls, port suffixes, initialization and
hangup sequences. QLTerm 3.00b2, copyright Jan Bredenbeek and contributors,
was exercised unchanged; its code is not copied into the modem. QLTerm is
not redistributed in this package. Its source identifies GPL-3.0-or-later.

Protocol references: RFC 854 (Telnet), RFC 856 (binary transmission), RFC 1091
(terminal type) and RFC 1073 (window size). MODEM.md links these and identifies
the intentionally limited Hayes command subset rather than claiming complete
compatibility with a particular physical modem model.

## Minerva ROM option (R23)

Minerva 1.98 by Laurence Reeves is bundled as a separate GPL-2.0-or-later
ROM option. The user-supplied GAS rebuild and original assembly are retained
in rom/minerva-gas-r1. R23 adds source-built host bridge adaptations derived
from QLBox’s existing JS integration. See [MINERVA.md](MINERVA.md) for the
source map, upstream notice, exact build checks and compatibility scope.
