# Terminal runner

## CLI contract

    qlrun [options] FILE [--args "raw QDOS command tail"]
    qlrun [options] --run FILE -- argument words

A path containing a slash/backslash mounts its parent; a bare filename uses
--mount or the default host directory. WINn_/HOSTn_/FLPn_/MDVn_ select the corresponding mount slot.
Up to eight slots are available through --mount and --mount2..--mount8.
ROM1_ selects the embedded utility drive. Do not combine --mount with a host
pathname executable; use its guest name instead.
After --, host argv words are joined with single spaces. Quotes removed by the
host shell are not reconstructed. Use --args for an exact raw tail.
The maximum tail is 1023 bytes; filenames remain limited to 36 ASCII bytes.

Executables require type 1 and the correct dataspace, supplied by .qlbox-meta,
an image/ROM1 header, or a valid XTcc trailer. Explicit sidecar metadata wins.
CLI rejects data files with no executable metadata.
It does not guess headers or convert DOS/Windows EXEs. No Python is needed to
run the included tagged samples; the metadata helper requires Python only
when tagging imported programs.

The loader skips BOOT in CLI mode. Ordinary SDL startup still executes BOOT.
No BASIC commands or keyboard events are injected to launch the program.

## Guest execution

The ROM's new startup branch opens the executable through the normal host
file driver, reads its header, checks size arithmetic, creates a QDOS job,
loads its code, closes the loader channel and activates it with wait enabled.
QDOS continues to own scheduling, resources and job removal. Its returned D0
is the target's signed exit status (D3 supplied to MT.FRJOB).

At job entry the stack contains:
- word: zero inherited channels, matching ordinary EXEC without channel args;
- word: command-tail byte count;
- command bytes, padded to an even allocation.

The data-space allocation includes additional storage for the tail. Original
data space must be at least four bytes; size arithmetic is checked against
configured RAM. Programs may open their own CON or SCR channels.

The host does not infer completion from a console string, program counter or
fixed delay. The ROM writes completion status only after QDOS returns from
the activation/wait call. An explicit frame limit is an optional watchdog.

## Terminal device

After TV initialization, CLI mode redirects new CON and SCR opens through the
ROM's normal host device entry. QDOS allocates each channel and closes it on
job removal. The backend handle has bit 31 set, separating terminal handles
from filesystem handles. Up to 128 terminal channels are supported.

Supported calls: pending input, byte/line/block input, byte/block output,
check and flush. SCR is output-only. Other requests return -19 (unsupported).
CON geometry in its name is accepted but has no terminal layout effect.
This release does not implement SD.EXTOP, cursor positioning or screen queries.

The host polls input outside CPU execution. Pending reads return -1, allowing
QDOS to suspend and retry the job through its own scheduler. Input is shared
across CON channels. CRLF/CR is normalized to QDOS LF. Redirected Windows stdout
uses binary mode so LF output matches Linux; interactive Windows console
output retains normal console newline translation. Stdout is flushed after
each guest write. There is no separate guest stderr channel.

## Extended ROM interface

R2 filesystem requests remain unchanged. Additional registers:
- 0x18115 byte, read: runner enabled.
- 0x18116 byte, write: enable stream-console driver after TV initialization.
- 0x18118 long, write: signed QDOS completion status.
- 0x1811C byte, write: completion flag.
- 0x18200: read-only counted guest filename, copied to RAM before IO.OPEN.
- 0x18300: read-only counted command tail.
- ROM 0xFFF0: QLBOX-R4 marker, checked before CLI execution.

These registers are QLBox-specific and not real QL hardware.

## Scope

This is an initial text-program runner, validated with real 68000 assembly
jobs. UnZip 5.32 and 5.41 now pass integration tests; broader application suites
remain to be tested. Programs using graphics, direct screen RAM, ROM screen driver
internals, non-ASCII input, window manipulation or inherited redirection
channels may need the SDL frontend or further compatibility work.
