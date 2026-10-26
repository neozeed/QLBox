# UnZip compatibility and BASIC wrapper diagnosis

The supplied unzip532_bas and unzip541_bas are Job2Bas wrappers. They are DATA
encodings of executable files, not BASIC implementations of decompression.

| Version | Payload bytes | Original data space |
| --- | ---: | ---: |
| 5.32 | 108460 | 51270 |
| 5.41 | 111158 | 51810 |

Both wrappers use ALCHP at line 7 and RECHP at line 19. These names are absent
from the stock JS ROM's BASIC command table. A reduced ALCHP example reports
"error in expression". The wrappers themselves suggest RESPR as an alternative,
with RECHP removed. They also exceed 400 KB of source before allocating the
recovered program, making default 128 KiB unsuitable.

R4 avoids the wrappers entirely by decoding their declared DATA words and odd
bytes on the host. The declared count and numeric ranges are checked; original
data space is preserved in .qlbox-meta. No executable instructions are patched.
The original uploaded BASIC files remain in samples/unzip.

To reproduce recovery:

    python3 tools/recover-job2bas.py samples/unzip/unzip532_bas host/UNZIP532
    python3 tools/recover-job2bas.py samples/unzip/unzip541_bas host/UNZIP541

## ROM heap fix

The supplied disassembly contains:

    MOVE.L XL0075A,(A0)+

at L0074E in MT.ALCHP. This loads the contents at XL0075A, yielding instruction
bytes as the heap block's release-descriptor pointer. On job removal QDOS follows
that invalid pointer and fails instead of finishing cleanup.

The correct instruction is:

    MOVE.L #XL0075A,(A0)+

This stores the descriptor address. The instruction length and subsequent ROM
offsets are unchanged. This defect is also present in the preserved original
assembly; it is not caused by the UK keyboard table. A new assembly regression
job deliberately leaves an MT.ALCHP allocation for QDOS to release.

## File classification fix

The C runtime in these UnZip binaries inspects SV.DDLST to classify file handles.
R3's host driver appeared only in the stream-driver chain, so the runtime
classified its channels as non-seekable and did not issue FS.POSAB calls.
Small archives could work by sequential reads; archives larger than the input
buffer exposed bad seek assumptions.

R4 assigns host files a separate directory-driver descriptor, while retaining
stream-driver identity for terminal channels. It provides the standard drive
and counted-filename fields in a larger channel allocation. Actual seeks still
execute through QDOS trap 3 and the existing host backend.

Root directory opens now return type 255 headers, allowing stat-style queries
and UnZip's -d WIN1_ option to recognize the mount as an existing directory.

## Validation

Both original utilities pass:
- help and normal process completion;
- listing and compressed-data CRC testing;
- text and binary output through -p;
- extraction and byte comparison of a 65537-byte binary payload;
- executable type/data-space restoration from QDOS ZIP extra fields;
- running the freshly extracted executable without a tagging step;
- no-overwrite behavior;
- graphical EXEC_W, acknowledgement of the utility's "Press a key to exit"
  prompt, and return to BASIC.

The metadata test archive uses the QDOS02 ZIP extra field described by Info-ZIP:
https://sources.debian.org/src/unzip/6.0-29%2Bdeb13u1/proginfo/extrafld.txt
The qdos/izqdos.h and qdos/qdos.c sources describe the structure and FS.HEADS call:
https://fossies.org/linux/unzip/qdos/izqdos.h
https://fossies.org/linux/unzip/qdos/qdos.c

These tests run on Linux using the actual guest binaries. R4 Windows binaries
are cross-built, not live-tested here. File date/version extension calls remain
unsupported, so restored timestamps are not claimed. Nested host directories
remain unsupported; use -j for archives containing paths.

## Provenance

The recovered utilities are Info-ZIP's QDOS UnZip binaries supplied by the user
as BASIC wrappers. They retain their original embedded credits and provenance;
QLBox does not claim authorship or a new license for them. The recovery script,
demo archive and emulator changes are separate from the unchanged utilities.
