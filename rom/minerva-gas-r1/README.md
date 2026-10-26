> R23 update: this tree now also builds the QLBox-integrated ROM.
> See ../../docs/MINERVA.md and `make qlbox`. The historical R1 notes below
> describe the byte-exact stock build and its original R21 experiment.

# Minerva 1.98: byte-exact GNU assembler build — R1

This is a source translation of the supplied Minerva 1.98 QL ROM, not a binary
wrapper or a disassembly substituted for the original source. All 194 original
modules are represented in `src/`. The built 48,822-byte ROM is identical to
`min198.rom` from the supplied `min198.zip`.

SHA-256 of both images:

```
aafbd3b0b2bf60d2cdeb139a355d552908b041ab021a1ff1b0be5547d9bcf2a2
```

## Build

Requirements: Python 3, Make, and modern GNU m68k ELF binutils (`as`, `ld`,
`objcopy`, `nm`; `objdump` for disassembly). No GCC, QL-hosted assembler, original
linker, binary ROM input, or external Python packages are needed to build.

```
make CROSS=m68k-elf-
make verify CROSS=m68k-elf-
```

GNU tools normally call the assembler `m68k-elf-as`, rather than
`m68k-elf-gas`. A full absolute tool prefix also works.

The actual validation here used GNU binutils 2.42's `m68k-linux-gnu-` tools,
which produce ELF32/m68k objects and use the same GAS m68k backend:

```
make verify CROSS=m68k-linux-gnu-
```

This prefix distinction is recorded deliberately: a separately configured
`m68k-elf-` installation was not executed during this run.

`make verify` checks every ROM byte and evaluates **443 original source
assertion comparisons** against the generated symbols. Normal builds do not
read the reference ROM. The oracle is used only by verification.

`make regenerate` translates the untouched files under `original/M` again.
It overwrites `src/`; ordinary builds do not. Edit the generated GAS files for
experiments, or edit the translator if changes must survive regeneration.

## Outputs and navigation

- `build/minerva.rom`: raw, unpadded, byte-identical ROM.
- `build/minerva.elf`: linked ELF, with reset entry at 0x410.
- `build/minerva.s`: self-contained combined GAS source.
- `build/minerva.map`: GNU linker map.
- `build/minerva.symbols`: ordered symbol map, including original entry names.
- `src/*.s`: translated modules, retaining original lines/comments alongside
  the GAS output. Macros are expanded into actual source, not opaque bytes.
- `order.json`: module ordering recovered from ROM/link and the library cct files.
- `original/M`: supplied original source, unchanged.
- `reference/min198.rom`: supplied comparison image, unchanged.
- `tests/qlbox_minerva.py`: boots and exercises the actual ROM in QLBox.
- `qlbox-patch/`: changed emulator files and a patch against the supplied R21.

Duplicate local names are prefixed `M<number>_` in the combined assembly;
module numbers are the zero-based positions in `order.json`. Shared entry
names keep their names. `dc_anchor_*` symbols preserve the old assembler's
meaning of `*` for a complete data directive. They are not routines.

The modules are collected into one ELF text section in original section order.
This allows original cross-module differences to resolve at assembly time.
Export directives are used to resolve names, then omitted in the combined unit
so GAS can fully resolve local branches rather than emit unnecessary relocations.

## QLBox boot

The enclosing package contains a patched **R21-based experimental QLBox fork**.
It is not a replacement for any later modem/flow-control release.

From the QLBox directory, using the included Windows 64-bit build:

```
bin\win64\qlbox.exe --rom rom\minerva-gas-r1\build\minerva.rom --boot f2 --ram 640
```

Or double-click `run-minerva-win64.cmd` (32-bit launcher also included).
For a source build:

```
make
./qlbox --rom rom/minerva-gas-r1/build/minerva.rom --boot f2 --ram 640
```

For headless validation:

```
make qlbox-headless
python3 rom/minerva-gas-r1/tests/qlbox_minerva.py ./qlbox-headless
```

The ROM needs **no padding and no byte patches**. QLBox changes:

1. Accept ROM file lengths between 32 and 64 KiB, while rejecting unsupported
   keyboard/profile combinations and files outside the bounds.
2. Recognize this exact Minerva 1.98 image using length and an FNV-1a fingerprint;
   its keyboard and readiness addresses come from the newly generated map.
3. Supply a persistent empty-microdrive gap status and periodic gap interrupts
   when Minerva enables them. This permits the original driver to report a
   missing boot medium rather than hang waiting for an interrupt never raised.
4. Deliver F1/F2 startup selection as a real queued IPC key; detect BASIC's
   original entry point and translate ASCII scripting through its UK keyboard
   tables. CPU instructions and guest BASIC execution remain real.

The empty-drive response is intentionally a minimal compatibility model, not
flux-level microdrive emulation. It is gated to the recognized Minerva profile.
Unknown modified Minerva ROMs are not automatically assigned these fixed hooks.
If changing ROM layout, update the profile from the new map and revalidate.

This is an original Minerva ROM, so QLBox's JS-specific host filesystem, modem,
and other ROM extensions are **not automatically ported to it**. A `--mount`
path supplies QLBox's backend, but does not install a Minerva guest driver.
This release proves the ROM build, boot and BASIC execution, not peripheral
feature parity with the patched JS ROM.

## Validation

- Complete byte equality and matching SHA-256 against the supplied ROM.
- 443 original assembler assertion comparisons pass.
- F1 and F2 startup, each with 128 and 640 KiB RAM.
- IPC-typed BASIC arithmetic and a FOR/END FOR loop.
- Guest RAM result: `42, 11, 22, 33, 99` at address 250000.
- Guest-reported RAM top checked for all four configurations.
- Invalid short, oversized and unsupported ROMs rejected.
- Existing QLBox JS smoke tests pass: boot, typing, arithmetic, loop, 128/640 KiB,
  and MODE 4/8. Detailed run output is in `docs/QLBOX-TESTS.txt`.
- Windows executables are cross-built; runtime tests were on Linux headless.

The test script also issues BEEP, but these checks do not establish audio
fidelity, full application compatibility, or native Minerva disk/serial support.

## Translation details that mattered

- The original macro system uses string/numeric variables, generated names,
  local variables, conditional jumps, loops and parameter introspection.
  `tools/convert.py` implements the subset used by this source tree.
- Original symbols are case-insensitive. GAS symbols are not.
- Leading zeros remain decimal: original `050` means 50, not octal 40.
- Expressions are explicitly parenthesized to preserve the original precedence.
- Original `*` in a multi-value DC directive is the directive's start, not the
  changing address of each separately emitted GAS value.
- Word/long data and section starts need explicit even alignment.
- Original long branch spelling `.l` means a 16-bit displacement on 68000,
  hence GAS `.w`; it does not mean a 68020 32-bit branch.
- Absolute constants versus relocatable bare LEA/PEA operands need different
  handling; relocatable bare addresses default to PC-relative in this source.
- GAS can synthesize jump-table trampolines for `.word symbol1-symbol2` when
  the difference exceeds signed 16 bits. Explicit low-word expressions preserve
  the intended tables without inserting code.
- Some quick-immediate expressions and indexed JMP extensions are emitted as
  symbolic opcode words to retain their exact original encoding.
- Equivalent EXG address-register encodings were normalized to match the oracle.
- Backslashes used to draw comment brackets are not macro continuation lines.

The source archives and their existing notices are preserved. This translation
does not assign a new license to the original Minerva material.
