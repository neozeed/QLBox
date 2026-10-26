# Minerva 1.98 in QLBox R23

Select `--rom minerva` in qlbox or qlrun, or set `rom=minerva` in the config.
JS stays the default; `--rom js` selects it explicitly. Both aliases locate
ROM files relative to the executable, including binaries under bin/win64,
bin/win32 and bin/linux64. Explicit ROM paths remain supported.

```bat
bin\win64\qlbox.exe --rom minerva --ram 640 --mount host --boot f1
bin\win64\qlrun.exe --rom minerva --ram 640 --mount elite --run ROM1_ZIP --args "WIN1_a WIN1_ELITEASM WIN1_README_MD"
bin\win64\qlrun.exe --rom minerva --ram 640 --mount elite --run ROM1_UNZIP --args "-t WIN1_a_zip"
```

The original 48,822-byte image is retained at
`rom/minerva-gas-r1/build/minerva.rom`. It boots BASIC but has no QLBox host
bridge. Use the adapted 65,536-byte `rom/minerva-rom.bin` for host storage,
ROM1 utilities, CLI execution and the modem. Other Minerva versions are not
recognized automatically: the emulator hooks deliberately match these exact
stock/adapted builds rather than guessing from a banner string.

## Source and integration

The supplied MINERVA198-GAS-R1-QLBOX-FULL-SOURCE archive supplies the original
Minerva source, 194 GNU assembler translations, source order, stock ROM and
verification tools. Its earlier R21 emulator patch provides the basis for
ROM profile recognition, F1/F2 boot injection, UK character mapping and the
empty-microdrive gap signal. R23 applies these to the R22 emulator, retaining
R22's modem retry and Telnet BINARY fixes.

`rom/minerva-gas-r1/tools/build_qlbox.py` first builds the byte-exact stock ROM.
It checks three source anchors and replaces them with fixed-width calls/jumps:

| Hook | Purpose |
|---|---|
| Channel setup | Give host files a directory-driver identity; retain stream identity for terminal/modem channels |
| IO.DELETE entry | Route host deletion through the existing QLBox request ABI, retaining native fallback |
| Startup window setup | Choose the CLI loader when requested, otherwise continue normal BOOT handling |

The new extension begins at 0xC000. It registers SHUTDOWN, allocates writable
driver links and installs them through native MT.LIOD/MT.LDD calls. The host
open/I/O/close and CLI routines are adapted from QLBox's JS host-driver source;
Minerva's native memory routines replace JS-specific internal addresses.
Minerva still performs trap dispatch, scheduling, channel ownership, job
creation and BASIC execution. The same C host filesystem/modem backend serves
both ROMs. The R22 JS ROM and embedded utility payloads are unchanged.

The builder verifies that every original core symbol retains its address and
that changes are confined to the three hook ranges (20 changed core bytes).
It emits the adapted ROM, ELF, symbol map and generated C profile hash.
The CLI ABI signature at 0xFFF0 remains QLBOX-R4; this is not a release number.

The extension also allocates empty writable default-directory records, using
the conventional 96-byte program extension and two 36-byte data/destination
strings. Stock Minerva leaves these optional pointers null. The bundled older
C runtime dereferences them unconditionally: it reads the nonzero reset word
at address zero as a string length and overwrites its stack. JS's zero word
at that address hides the same application assumption. Initializing proper
records fixes startup without changing ZIP, UNZIP or individual applications.

## Rebuild

Use Python 3 and modern GNU m68k binutils. No legacy QL assembler is needed.
From the project root:

```sh
make -C rom/minerva-gas-r1 verify CROSS=m68k-linux-gnu-
make minerva-rom CROSS=m68k-linux-gnu-
make headless
make minerva-test
```

Use `CROSS=m68k-elf-` if that is your toolchain prefix. The prefix may be an
absolute path. Rebuild the emulator after rebuilding the adapted ROM because
its exact hash is compiled into `src/minerva_profile.h`. Normal builds use the
included ROM and header and do not require a cross assembler.

The stock verification checks the original SHA-256 and 443 source assertions.
Stock SHA-256:
`aafbd3b0b2bf60d2cdeb139a355d552908b041ab021a1ff1b0be5547d9bcf2a2`.
The original source modules are not edited by the adaptation builder.

## Validation scope

Linux headless guest tests cover F1/F2, 128/640 KiB, keyboard IPC, BASIC loops
and arithmetic, MODE 4/8, BOOT, SAVE/LOAD, COPY/DELETE/DIR, EXEC/EXEC_W,
job-owned file cleanup, CLI arguments and I/O, exit status, SHUTDOWN and EXIT.
The actual ZIP and UNZIP utilities create/test/extract binary archives,
preserve executable metadata and run the extracted executable. Toolkit II
loading and commands pass. A real QDOS job dials a local TCP server and
transfers all 256 byte values with fragmented replies through the modem.
QL5A/QL5B/QLWA disk and QLAY MDV image tests also pass through Minerva,
including binary copies and executable-header handling.

These are integration tests, not a claim of compatibility with every QL game
or peripheral. Windows builds are cross-compiled; native Windows and macOS
runtime testing of R23 is not performed here. Existing timing options remain
available; this release does not change CPU timing or serial flow-control policy.
Run `make test` for the default JS regression suite and `make minerva-test`
for the selected Minerva suite. Individual shared Python tests accept
`QLBOX_TEST_ROM=/absolute/path/to/rom.bin`.

## Credits and license

Minerva is by Laurence Reeves. The author's GPL notice, mirrored at
https://www.sinclairql.net/djw/qlrom/min_copyright.txt, specifies GNU GPL
version 2 or later. The notice and full license accompany the source as
`COPYRIGHT.txt` and `COPYING`. The original website reference is
https://www.sinclairql.net/djw/qlrom/index.html.

The QLBox Minerva adaptations are dated 2026-10-26 and supplied under those
same terms. Original assembly, translated assembly, build scripts and new
bridge source are included. The JS host bridge supplied the integration
pattern; Musashi and QLAY supplied the existing CPU/emulation foundations.
See PROVENANCE.md and the individual component notices. Minerva's license
does not change the license status of the separately bundled JS ROM or utilities.
