# Disk and microdrive images

`--mount` and `--mount2` through `--mount8` accept either a host directory or
an image file. The file signature selects the format, not its extension.
Configuration keys `mount1` through `mount8` accept the same paths.

Supported: raw QL5A floppy images with sector skew/interleave, flat QL5B
logical-sector images, QLAY raw microdrive cartridges (255 x 686-byte records, 174930 bytes),
and QLWA hard-disk containers (including fragmented
files/directories and nested QDOS directory prefixes).

Images are read-only. Host-directory mounts remain writable. Original QDOS
file headers supply type, dataspace and dates; no tagging is needed. The
64-byte on-disk header is removed from the data stream, as QDOS expects.
An image's explicit header takes precedence over any XTcc bytes in its data.

Each slot has four equivalent names: `WIN1_`, `HOST1_`, `FLP1_`, `MDV1_`, etc.
These are aliases, not separately mounted devices. Thus WIN1, FLP1 and MDV1 cannot
refer to different media in this release. ROM1_ remains the built-in utility
drive. Programs with hard-coded WIN1/FLP1/MDV1 paths should use slot 1.

## Supplied Lemmings image

From the QLBox directory, with your image beside it:

```
bin\win64\qlbox.exe --ram 640 --speed 4 --mount QLWA.win
```

Then in SuperBASIC:

```
LRUN WIN1_lemmings_bas
```

Tested: the supplied image contains 52 files; the loader, game binary and
menu graphics load, and the graphical main menu appears. This is a BASIC
loader plus a type-0 binary, so `qlrun --run lemmings_bin` is not the right
launch method. R13 adds SDL-to-QIMSI mouse input and has been tested through the menu into
the running first level. See MOUSE.md. Full gameplay is not validated. QSound AY audio is now implemented (see
QSOUND.md); automatic Pointer Environment driver installation remains absent.

For writable progress files, extract it first as described below, then mount
that directory. An image mounted directly will reject writes with QDOS -20.

## Supplied 198ad adventure floppy

```
bin\win64\qlbox.exe --ram 640 --speed 4 --mount "198adDisk ImageFinal.img"
```

The automatic BOOT displays its title but reports `At line 20 out of range`:
the supplied loader positions text on row 4 of console #0, which is too short
in the default TV layout. At the BASIC prompt enter:

```
LRUN ROM1_TK2_BAS
WINDOW #0,448,80,32,176
LRUN FLP1_BOOT
```

Then press a key and choose border art (1) or no border art (2). Toolkit 2
provides the loader's EXEC_W command. Tested through the opening story screen,
with the executable's original 512-byte dataspace preserved. The image has
five active files. Save-game behavior has not been validated.

For convenience the three commands are also in
`samples/image-launchers/198ad-start.txt`; add
`--type samples/image-launchers/198ad-start.txt` to the launch command.

## Writable copies and image inspection

`qlimage` is a standalone native command-line tool (no Python or SDL needed):

```
bin\win64\qlimage.exe --list QLWA.win
bin\win64\qlimage.exe --extract QLWA.win lemmings
bin\win64\qlbox.exe --ram 640 --speed 4 --mount lemmings
```

Run `LRUN WIN1_lemmings_bas` as before. The new directory contains payload
files and `.qlbox-meta` headers, and supports normal file creation, updates,
and deletion. The original image remains unchanged. The extraction target
must not already exist; partial output is reported on an I/O failure. QDOS
subdirectory prefixes are flattened, like the existing host backend.
Extraction rejects names that cannot safely be represented on Windows.

Win32 uses `bin\win32` in the same examples. Linux uses `bin/linux64/qlbox`
and `bin/linux64/qlimage`. macOS builds from the included Make/CMake sources.

You can also mix mounts and copy individual files in BASIC:

```
bin\win64\qlbox.exe --ram 640 --mount host --mount2 QLWA.win
```

```
DIR WIN2_
COPY WIN2_README.txt TO WIN1_LEMMINGS_README
```

## Scope and validation

This is filesystem-level mounting through QLBox's existing ROM driver. It
supports normal QDOS file I/O, not raw floppy-controller or sector access.
No formatting, in-place image writes, compressed/flux disk images, partitioned
host disks, QL5A/B subdirectories, or hot swapping are implemented. Inputs are
limited to 128 MiB and checked for geometry, length, allocation bounds,
duplicate blocks, chain loops and duplicate filenames before use. Invalid or
unsupported images fail at mount rather than being treated as host directories.
QLWA allocation-unit sizes come from the header, not a fixed 2 KiB assumption.

Tests generate skewed QL5A, QL5B and fragmented QLWA images, execute a QDOS
program from their native headers through all three aliases, copy binary and
empty files, traverse a nested QLWA directory, reject writes and malformed
images, verify unchanged source images, and execute an extracted program.
The normal emulator, storage, debugger, beeper and SDL keyboard regressions
also pass. Win32/Win64 are cross-built; interactive Windows testing remains
for the target machines. The two user-supplied games are not redistributed.

Format references: QDOS/SMS Reference Manual section 8
(https://kilgus.net/smsqe/QDOS%20SMS%20Reference%20Manual.pdf), and the QLAY
qlt-flp/qlt-qxl tools supplied with the earlier project sources.

## R15: QLAY microdrive (.mdv)

From the QLBox directory, with your cartridge image beside it:

```
bin\win64\qlbox.exe --ram 640 --mount ql26inv.mdv
```

The supplied cartridge's `boot` loads automatically. If already at a BASIC
prompt, `LRUN MDV1_BOOT` launches it. The original loader's `LBYTES
"mdv1_code",a` works unchanged. Verified: the 135-byte loader loads its
85,336-byte code file and runs the animated graphics/scroller.
The supplied image itself is not included in this release.

`DIR MDV1_` lists the cartridge. `--mount2 other.mdv` exposes it as `MDV2_`
(and WIN2_/FLP2_/HOST2_); the same applies through slot 8. Config `mountN`
settings work with cartridges too. MDV aliases also work for host directories.

List or extract, preserving the QDOS headers:

```
bin\win64\qlimage.exe --list ql26inv.mdv
bin\win64\qlimage.exe --extract ql26inv.mdv ql26inv-files
bin\win64\qlbox.exe --ram 640 --mount ql26inv-files
```

Extraction creates a new directory. Mount that directory for writable saves;
direct image mounts remain read-only. This is a filesystem reader, not a
microdrive motor/tape-controller emulator. Programs using raw hardware access
or other .mdv layouts are not covered. Spectrum cartridges are not supported.

The reader handles arbitrary tape-sector order and fragmented file blocks,
the real-cartridge $80 and QLAY-created $f8 map-record markers, header/data
checksums, and stale bytes in free sectors. Corrupt allocated sectors,
missing/duplicate file blocks, inconsistent maps and truncated images reject
mounting rather than yielding partial files. Reference: the existing QLAY
`qlt-mdv.c` record layout, cross-checked against this supplied cartridge.
