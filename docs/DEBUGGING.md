# GDB remote debugging and guest messages

Start the SDL machine, paused before its first instruction:

    bin\win64\qlbox.exe --ram 640 --gdb 1234 --gdb-wait

Use a GDB build with m68k support (e.g. gdb-multiarch):

    set endian big
    set architecture m68k
    target remote 127.0.0.1:1234
    info registers
    x/8i $pc
    si
    break *0x30000
    continue

Omit --gdb-wait to boot normally; attaching pauses the CPU. Ctrl+C in GDB
interrupts execution. Detach resumes; an unexpected disconnect also resumes
and clears breakpoints. The listener remains available for reconnection.
The GUI continues handling events while paused. Headless debugging with no
--frames limit stays running until stopped externally. Close the SDL window
or stop the host process to terminate the machine; the RSP kill packet detaches.

This debugs the entire CPU, not individual QDOS jobs. Addresses are absolute
runtime addresses. Use add-symbol-file with the actual loaded address for an
ELF debug symbol file. QDOS relocation and job discovery are not automatic.
The bundled rom/qlbox-rom/build/qlbox.elf provides ROM symbols; original JAS
objects may not be readable by modern GDB.

Supported: target XML; D0-D7, A0-A7, SR and PC; register reads/writes; ROM/RAM
reads; RAM writes; instruction stepping; continue; Ctrl+C; up to 64 execution
breakpoints; detach and reconnect. Z0/Z1 both use address comparisons, including
ROM addresses: no patching of guest code. No data watchpoints, reverse execution,
per-job threads, exception catchpoints, or host filesystem remote commands.
Memory reads/writes exclude MMIO to avoid inspection triggering devices.
The stub binds only 127.0.0.1 and is off unless --gdb PORT is supplied.
Execution with debugging enabled is slower because it uses instruction-sized
CPU slices. For normal performance, start without --gdb.

## Diagnostic ports

Byte write to $18120: append a character. LF emits the current line; CR and NUL
are ignored. Long lines flush in bounded chunks. Output goes to host stderr
with a [guest] prefix, keeping qlrun stdout suitable for pipes.
Byte write to $18121: bit 0 flushes a partial line; bit 1 requests a debugger
stop after the current instruction, if --gdb is active. Without a debugger,
the stop request has no effect. --debug-log FILE sends guest output to a file
instead (overwritten on startup). Neither port needs supervisor mode.

BASIC example:

    POKE 98592,72:POKE 98592,105:POKE 98592,10

JAS example:

    move.b #'H',$18120
    move.b #'i',$18120
    move.b #10,$18120
    move.b #2,$18121

C and JAS string helpers are in samples/debug. These addresses are QLBox
extensions; they are not real QL hardware or a portable QDOS API.

Protocol references:
https://sourceware.org/gdb/current/onlinedocs/gdb.html/Packets.html
https://sourceware.org/gdb/current/onlinedocs/gdb.html/M68K-Features.html

## Validation

The integration test drives a live 68000 via RSP and checks target XML,
registers, RAM access, ROM/MMIO write rejection, stepping, breakpoints, Ctrl+C,
port output, guest-requested stops and detach. GDB multiarch 15.1 was also
connected to the Linux build: register writes, stepping from $30000 to $30002,
and a breakpoint at $30004 were verified. Windows binaries were cross-built;
the Windows debugger connection has not been live-tested here.
