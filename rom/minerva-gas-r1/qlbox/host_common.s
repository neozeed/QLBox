/* QLBox Minerva adaptation, 2026-10-26. GPL-2.0-or-later; see ../COPYING. */
/* QLBox QDOS bridge and CLI loader, adapted from the JS host_driver.s.
 * QDOS allocates channels and jobs; the host handles only device operations.
 */
host_open:
 movem.l d0-d3/a0-a1,-(a7)
 move.l a7,0x18104:l
 move.b #1,0x18100:l
 movem.l (a7)+,d0-d3/a0-a1
 tst.l d0
 bne.s host_return
 move.l a0,-(a7)  /* original counted filename */
 move.l d1,-(a7)  /* host handle */
 move.l #128,d1
 jsr mm_alchp:l  /* allocate a real QDOS channel block */
 move.l (a7)+,d1
 movea.l (a7)+,a1
 tst.l d0
 bne.s host_open_fail
 move.l d1,0x18(a0)
 tst.l d1
 bmi.s host_open_success  /* terminal/modem handles retain stream-driver identity */
 move.b #1,0x1d(a0)  /* drive 1 for C runtimes inspecting channel definitions */
 moveq #0,d2
 move.w (a1)+,d2
 cmpi.w #4,d2
 beq.s host_copy_channel_name  /* BOOT has no device prefix */
 cmpi.b #'_',4(a1)
 bne.s host_name_alias
 move.b 3(a1),d0
 subi.b #'0',d0
 move.b d0,0x1d(a0)
 addq.w #5,a1
 subq.w #5,d2
 bra.s host_copy_channel_name

 /* host_name_alias */
 /* Internal open branch: strip the six-character HOSTn_ prefix and retain its drive number. */
host_name_alias:
 move.b 4(a1),d0
 subi.b #'0',d0
 move.b d0,0x1d(a0)
 addq.w #6,a1
 subq.w #6,d2

 /* host_copy_channel_name */
 /* Internal open branch: copy the counted filename into the QDOS channel definition. */
host_copy_channel_name:
 move.w d2,0x32(a0)
 lea 0x34(a0),a2
 subq.w #1,d2
 bmi.s host_open_success

 /* host_name_loop */
 /* Copy one filename byte; DBF consumes the remaining length minus one. */
host_name_loop:
 move.b (a1)+,(a2)+
 dbf d2,host_name_loop

 /* host_open_success */
 /* Return success after the host handle and guest channel have both been established. */
host_open_success:
 moveq #0,d0

 /* host_return */
 /* Common return with D0 carrying the bridge status. */
host_return:
 rts

 /* host_open_fail */
 /* Release the host handle if allocating its QDOS channel failed; preserve the original error. */
host_open_fail:
 move.l d0,-(a7)
 bsr.s host_release
 move.l (a7)+,d0
 rts

 /* host_io */
 /* Bridge a QDOS I/O request through the six-register stack block; return updated registers and */
 /* D0 condition codes. */
host_io:
 movem.l d0-d3/a0-a1,-(a7)
 move.l a7,0x18104:l
 move.b #2,0x18100:l
 movem.l (a7)+,d0-d3/a0-a1
 tst.l d0
 rts

 /* host_close */
 /* Release the host resource, then tail-call the QDOS heap release for the guest channel. */
host_close:
 move.l a0,-(a7)
 move.l 0x18(a0),d1
 bsr.s host_release
 movea.l (a7)+,a0
 jmp mm_rechp:l  /* QDOS heap release */

 /* host_release */
 /* Send command 3 with the host handle in D1. Used by close and open-error cleanup. */
host_release:
 movem.l d0-d3/a0-a1,-(a7)
 move.l a7,0x18104:l
 move.b #3,0x18100:l
 movem.l (a7)+,d0-d3/a0-a1
 rts

host_run:
 move.b #1,0x18116:l
 suba.w #46,a7
 movea.l a7,a0
 lea 0x18200:l,a1
 moveq #22,d0

 /* host_run_copy_name */
 /* Copy the counted run name from the host MMIO window into temporary guest stack storage. */
host_run_copy_name:
 move.w (a1)+,(a0)+
 dbf d0,host_run_copy_name
 movea.l a7,a0
 moveq #-1,d1
 moveq #1,d3  /* shared read */
 moveq #1,d0
 trap #2
 adda.w #46,a7
 tst.l d0
 bne.w host_run_done
 movea.l a0,a4  /* loader file channel */
 suba.w #64,a7
 movea.l a7,a1
 moveq #14,d2
 moveq #-1,d3
 moveq #0x47,d0
 trap #3
 tst.l d0
 bne.w host_run_close_error
 cmpi.b #1,5(a7)
 bne.w host_run_not_exec
 move.l (a7),d2
 move.l 6(a7),d3
 cmpi.l #4,d3
 blo.w host_run_bad_size
 moveq #0,d5
 move.w 0x18300:l,d5  /* command length */
 addq.l #1,d5
 andi.l #0xfffffffe,d5  /* even argument storage */
 add.l d5,d3
 bcs.w host_run_bad_size
 move.l d2,d0
 add.l d3,d0
 bcs.w host_run_bad_size
 addi.l #0x68,d0
 bcs.w host_run_bad_size
 move.l 0x18110:l,d4
 subi.l #0x20000,d4
 cmp.l d4,d0
 bhi.w host_run_bad_size
 cmpi.l #4,d3
 blo.w host_run_bad_size
 tst.l d2
 beq.w host_run_bad_size
 move.l d2,d7
 moveq #-1,d1
 suba.l a1,a1
 moveq #1,d0
 trap #1  /* QDOS creates suspended child job */
 tst.l d0
 bne.w host_run_close_error
 move.l d1,d6
 movea.l a0,a5  /* program base */
 movea.l -12(a5),a2  /* initial USP from QDOS job header */
 suba.l d5,a2
 move.l a2,-12(a5)
 clr.w (a2)+  /* zero inherited channels, same convention as EXEC */
 lea 0x18300:l,a3
 move.w (a3)+,d4
 move.w d4,(a2)+
 subq.w #1,d4
 bmi.s host_run_load

 /* host_run_copy_args */
 /* Copy the command tail into the new job stack after the inherited-channel count and tail */
 /* length. */
host_run_copy_args:
 move.b (a3)+,(a2)+
 dbf d4,host_run_copy_args

 /* host_run_load */
 /* Load the payload through its QDOS channel, close it and activate/wait for the child. D6 is */
 /* job ID, A5 code base, A4 loader channel and D7 code length. */
host_run_load:
 movea.l a5,a1
 movea.l a4,a0
 move.l d7,d2
 moveq #-1,d3
 moveq #0x48,d0
 trap #3
 move.l d0,d4
 movea.l a4,a0
 moveq #2,d0
 trap #2
 adda.w #64,a7
 tst.l d4
 bne.s host_run_remove
 move.l d6,d1
 moveq #32,d2
 moveq #-1,d3
 moveq #10,d0
 trap #1  /* activate and wait: QDOS returns the child's D3 exit status in D0 */
 bra.s host_run_done

 /* host_run_remove */
 /* Remove the suspended job after a load failure, then report the saved error. */
host_run_remove:
 move.l d6,d1
 moveq #4,d0
 trap #1
 move.l d4,d0
 bra.s host_run_done

 /* host_run_not_exec */
 /* Reject a header whose file type is not executable (type 1). */
host_run_not_exec:
 moveq #-15,d0
 bra.s host_run_close_error

 /* host_run_bad_size */
 /* Report insufficient/invalid job allocation after size, overflow or dataspace validation. */
host_run_bad_size:
 moveq #-3,d0

 /* host_run_close_error */
 /* Close the loader channel, release the temporary header stack area and retain the error in */
 /* D0. */
host_run_close_error:
 move.l d0,d4
 movea.l a4,a0
 moveq #2,d0
 trap #2
 adda.w #64,a7
 move.l d4,d0

 /* host_run_done */
 /* Publish the signed job/loader result and completion flag for the host runner. */
host_run_done:
 move.l d0,0x18118:l
 move.b #1,0x1811c:l

 /* host_run_stopped */
 /* Wait for the host to observe completion; do not fall through into ROM data. */
host_run_stopped:
 bra.s host_run_stopped


host_shutdown:
 cmpa.l a3,a5
 bne.s host_shutdown_bad
 move.b #1,0x18122:l

 /* host_shutdown_wait */
 /* Wait for the emulator to terminate after accepting SHUTDOWN. */
host_shutdown_wait:
 bra.s host_shutdown_wait

 /* host_shutdown_bad */
 /* Return bad-parameter status when SHUTDOWN receives arguments. */
host_shutdown_bad:
 moveq #-15,d0
 rts

