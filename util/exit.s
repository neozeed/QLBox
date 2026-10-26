| Build: m68k-linux-gnu-as -m68000 -o exit.o util/exit.s
|        m68k-linux-gnu-objcopy -O binary -j .text exit.o util/EXIT
| ROM1 metadata: executable type 1, dataspace 128 bytes.
.text
 bra.s start
 .long 0
 .word 0x4afb,4
 .ascii "EXIT"
 .word 0
start:
 move.b #1,0x18122
wait:
 bra.s wait
