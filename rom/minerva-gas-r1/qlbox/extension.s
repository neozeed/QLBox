/* Modified for QLBox R23, 2026-10-26. GPL-2.0-or-later; see ../COPYING.
 * QLBox extension for Minerva 1.98. Called by the standard ROM scanner.
 * The core ROM retains its original addresses; the three explicit hooks are
 * assembled from source and checked against the byte-exact baseline. */
.org 0xc000
qlbox_extension:
.long 0x4afb0001
.word host_procedures-qlbox_extension
.word host_install-qlbox_extension
.word 20
.ascii "QLBox Minerva bridge"
.balign 2,0

/* Allocate writable driver links owned by BASIC job 0, then link them through
 * Minerva's public MT.LIOD / MT.LDD calls. The two driver records occupy the first 128 bytes. */
host_install:
 movem.l d0-d7/a0-a6,-(sp)
 move.l #296,d1
 moveq #0,d2
 moveq #0x18,d0
 trap #1
 tst.l d0
 bne.s host_install_done
 movea.l a0,a4
 moveq #73,d1
host_install_clear:
 clr.l (a0)+
 dbf d1,host_install_clear
 movea.l a4,a0
 lea host_templates(pc),a1
 moveq #31,d1
host_install_copy:
 move.l (a1)+,(a0)+
 dbf d1,host_install_copy
 movea.l a4,a0
 moveq #0x20,d0
 trap #1
 lea 64(a4),a0
 moveq #0x22,d0
 trap #1
/* Supply empty, writable TK2-compatible default-directory records. Native
 * Minerva leaves these optional pointers null; older C runtimes dereference
 * them unconditionally (on JS, address zero happens to begin with zero).
 * Reserve the full 96-byte program extension and two 36-byte strings. */
 moveq #0,d0
 trap #1
 tst.l 0xac(a0)
 bne.s host_install_done
 lea 128(a4),a1
 move.l a1,0xac(a0)
 lea 224(a4),a1
 move.l a1,0xb0(a0)
 lea 260(a4),a1
 move.l a1,0xb4(a0)
host_install_done:
 movem.l (sp)+,d0-d7/a0-a6
 rts

/* The file identity is in SV.DDLST so C runtimes recognize seekable files.
 * The stream entry performs opens; negative terminal/modem handles keep it. */
host_templates:
 .long 0,host_io,host_open,host_close
 .space 64-(.-host_templates),0
host_file_template:
 .long 0,host_io,host_missing,host_close
 .long host_service,0,0,host_format
 .long 0x40
 .word 3
 .ascii "WIN"
 .balign 2,0
 .space 64-(.-host_file_template),0
host_service:
 moveq #0,d0
 rts
host_missing:
 moveq #-7,d0
 rts
host_format:
 moveq #-19,d0
 rts

/* Replace the six-byte channel setup prefix. Test the I/O entry instead of
 * an address because driver links reside in a QDOS-allocated RAM block. */
host_channel_setup:
 move.l a0,(a3)
 cmpi.l #host_io,4(a2)
 bne.s host_channel_store
 tst.l 0x18(a0)
 bmi.s host_channel_store
 lea 64(a2),a2
host_channel_store:
 addq.l #4,a0
 move.l a2,(a0)+
 rts

/* Keep Minerva's job validation and native deletion fallback. */
host_delete_entry:
 move.l a0,a1
 jsr ss_joby
 exg a1,a0
 movem.l d0-d3/a0-a1,-(sp)
 move.l sp,0x18104
 move.b #4,0x18100
 movem.l (sp)+,d0-d3/a0-a1
 cmpi.l #-19,d0
 bne.s host_delete_done
 st d3
 jsr io_fopen
host_delete_done:
 jmp ss_rte

/* Finish the original window setup, then choose CLI execution or the ROM's
 * normal BOOT lookup. A6 remains Minerva's BASIC base throughout. */
host_start:
 moveq #0,d4
 jsr M139_mov_wind
 jsr M139_mov_next
 jsr M139_mov_next
 tst.b 0x18115
 bne.w host_run
 rts

host_procedures:
 .word 1
 .word host_shutdown-.
 .byte 8
 .ascii "SHUTDOWN"
 .balign 2,0
 .word 0,0,0

.include "qlbox/host_common.s"
.org 0xfff0,0
.ascii "QLBOX-R4" /* Existing host-runner ABI signature, not ROM version. */
.org 0x10000,0
