# R18 experimental timing

## Selecting a mode

- `--timing fast`: R17 timing, default. No bus corrections or RAM waits.
- `--timing 68008`: charge additional transfers for the 8-bit external bus.
- `--timing ql`: also restrict $20000-$3FFFF accesses to local DRAM slots.

Config key `timing` accepts the same three values. CLI overrides config.
Use `--speed 1` for hardware-oriented experiments. Speed controls remain
available, but multiply virtual CPU clocks per frame, including the slot
schedule, so accelerated settings are not a physical QL timing model.
Audio and the existing 50 Hz frame interrupt cadence do not speed up.
An exit status line reports virtual clocks, additional bus clocks, RAM wait
clocks and carried slice debt when a timing mode is active.

## Hardware basis

Motorola specifies four clocks per external byte transfer on the 68008.
Relative to the core's 16-bit bus, each word transfer adds four clocks and
each long transfer adds eight. Byte operands need no width correction;
opcode and extension-word fetches also pass through the timed accessors.

Nasta's published ZX8301 hardware measurements describe 480 CPU clocks per
line, divided into forty 12-clock slots. For the first 32 slots, eight clocks
are reserved for video/refresh, leaving four for the CPU. The last eight
slots permit four-clock accesses without that restriction. Refresh retains
the reserved slots during vertical blanking. A transfer must fit completely
inside a CPU window. Both onboard 64 KiB banks use this schedule; ROM and
expansion RAM do not receive local-DRAM contention penalties.

Sources (hardware manuals and first-person hardware investigation):
- Motorola M68000 user manual, section 7, 8-bit execution times:
  https://www.silicon-ark.co.uk/datasheets/M68000-user-manual-9th-edition-motorola.pdf
- Sinclair QL service manual, section 1 paragraphs 5.2.4-5.2.6:
  https://www.sinclairql.net/djw/docs/ebooks/Sinclair%20QL%20Service%20Manual.pdf
- Nasta, ZX8301 measurements, 29 November 2017:
  https://theqlforum.com/viewtopic.php?start=50&t=1780

## Implementation and limits

The Musashi extension adds optional begin/end callbacks around instruction
execution and interrupt-entry groups, plus an API that consumes wait clocks.
It preserves the original cycle path when callbacks are absent. CPU bus
callbacks charge width corrections and DRAM waits only during CPU execution.
Debugger/disassembler inspection and host-side memory access do not consume
CPU clocks. Timing state resets with machine initialisation. Instruction
overshoot is carried between the 400 microsecond audio/CPU slices.

Within each execution group, accesses are scheduled in callback order from
the instruction start; remaining internal cycles follow those accesses.
If the scheduled transfers take longer than the adjusted instruction cost,
the group is padded to their completion. This is not the real per-opcode
microcycle ordering. Musashi's 68000 execution tables and fetch behaviour
remain in use: missing speculative/discarded prefetches, exact pipeline and
exception details, operand-dependent arithmetic costs, and some instruction
bus sequences can differ from a 68008. A full 68008 timing table/prefetch
implementation and real-machine calibration remain future work.

The horizontal slot clock runs continuously; its initial phase is zero.
The existing 50 Hz / 150000 clocks-per-frame scheduler is retained, rather
than changing presentation/audio/IRQ timing to 312*480=149760 clocks.
Consequently raster/frame phase is not exact. Display pixels are still
rendered from the final frame state, not fetched at each raster position.
The model does not implement issue-5 peripheral contention, exact I/O DTACK,
expansion-board wait states, or physical microdrive loading/rotation timing.
Fast host file I/O and the modified JS boot path are still present.

## Validation

`make test` includes independent slot-window checks across line boundaries,
simple no-wait Motorola instruction costs, byte/word/long transfers, both
onboard RAM banks versus expansion RAM, inspection isolation, machine reset,
slice-overrun carry, CLI/config selection and BASIC boot/SHUTDOWN in all modes.
The pre-existing regression suite continues to run with default fast timing.

Optional original-demo replay (image supplied separately):

```
python3 tests/timing_demo.py ./qlbox-headless /path/to/ql26inv.mdv
```

The demo is never identified or patched by emulator code. No callback-pointer
protection or application-specific timing adjustments are installed. The
separate bounds-test MDV from the earlier experiment is not used here.
A successful replay supports investigating contention as the compatibility
cause; it does not establish an exact match to real hardware or all ROMs.
