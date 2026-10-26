/* Generated from original/M/dd/mdvrn.asm */
/* QL: * Rename a file on a microdrive */
/* QL:         xdef    dd_mdvrn */
.globl dd_mdvrn
/* QL:         xref    ut_cstr */
/* QL:         xref    dd_mdvcd,dd_mdvrr */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         include 'win1_m_inc_ch' */
/* QL: * channel definition block / driver headers */
/* QL:         nolist */
/* QL: * channel definition header for all channels */
/* QL:         offset  0 */
/* QL: ch_len  ds.l    1       length of definition block */
.equ ch_len,0
/* QL: ch_drivr ds.l   1       address of driver */
.equ ch_drivr,4
/* QL: ch_owner ds.l   1       owner job */
.equ ch_owner,8
/* QL: ch_rflag ds.l   1       address to be set when space released */
.equ ch_rflag,12
/* QL: ch_tag  ds.w    1       channel tag */
.equ ch_tag,16
/* QL: ch_stat ds.b    1       status: 0 ok, else waiting -1 a1 abs, $80 a1 rel a6 */
.equ ch_stat,18
/* QL: ch_actn ds.b    1       stored action for waiting job */
.equ ch_actn,19
/* QL: ch_jobwt ds.l   1       ID of job waiting on I/O */
.equ ch_jobwt,20
/* QL: ch_end */
.equ ch_end,24
/* QL: * extended channel definition for plain serial queues */
/* QL: ch_qin  ds.l    1       pointer to input queue (or zero) */
.equ ch_qin,24
/* QL: ch_qout ds.l    1       pointer to output queue (or zero) */
.equ ch_qout,28
/* QL: ch_qend */
.equ ch_qend,32
/* QL: * device driver header */
/* QL:         offset  0 */
/* QL: ch_next ds.l    1       pointer to next driver */
.equ ch_next,0
/* QL: ch_inout ds.l   1       entry for input and output */
.equ ch_inout,4
/* QL: ch_open ds.l    1       entry for open */
.equ ch_open,8
/* QL: ch_close ds.l   1       entry for close */
.equ ch_close,12
/* QL: * the following are for directory devices (file system) only: */
/* QL: ch_slave ds.l   1       entry for slaving blocks */
.equ ch_slave,16
/* QL: ch_renam ds.l   1       entry reserved for rename */
.equ ch_renam,20
/* QL:         ds.l    1 */
/* QL: ch_formt ds.l   1       entry for format medium */
.equ ch_formt,28
/* QL: ch_dflen ds.l   1       length of physical definition block */
.equ ch_dflen,32
/* QL: ch_drnam ds.w   1       length prefixed drive name */
.equ ch_drnam,36
/* QL:         list */
/* QL:         include 'win1_m_inc_err' */
/* QL: * error keys */
/* QL:         nolist */
/* QL: err.nc  equ     -1      not complete */
.equ err.nc,(-1)
/* QL: err.nj  equ     -2      invalid Job */
.equ err.nj,(-2)
/* QL: err.om  equ     -3      out of memory */
.equ err.om,(-3)
/* QL: err.or  equ     -4      out of range */
.equ err.or,(-4)
/* QL: err.bo  equ     -5      buffer full */
.equ err.bo,(-5)
/* QL: err.no  equ     -6      channel not open */
.equ err.no,(-6)
/* QL: err.nf  equ     -7      not found */
.equ err.nf,(-7)
/* QL: err.ex  equ     -8      already exists */
.equ err.ex,(-8)
/* QL: err.iu  equ     -9      in use */
.equ err.iu,(-9)
/* QL: err.ef  equ     -10     end of file */
.equ err.ef,(-10)
/* QL: err.df  equ     -11     drive full */
.equ err.df,(-11)
/* QL: err.bn  equ     -12     bad name */
.equ err.bn,(-12)
/* QL: err.te  equ     -13     Xmit error */
.equ err.te,(-13)
/* QL: err.ff  equ     -14     format failed */
.equ err.ff,(-14)
/* QL: err.bp  equ     -15     bad parameter */
.equ err.bp,(-15)
/* QL: err.fe  equ     -16     bad or changed medium */
.equ err.fe,(-16)
/* QL: err.xp  equ     -17     error in expression */
.equ err.xp,(-17)
/* QL: err.ov  equ     -18     overflow */
.equ err.ov,(-18)
/* QL: err.ni  equ     -19     not implemented yet */
.equ err.ni,(-19)
/* QL: err.ro  equ     -20     read only */
.equ err.ro,(-20)
/* QL: err.bl  equ     -21     bad line */
.equ err.bl,(-21)
/* QL: err.at  equ     -22     At line (+ space, no LF) */
.equ err.at,(-22)
/* QL: err.sc  equ     -23      sectors */
.equ err.sc,(-23)
/* QL: err.bt  equ     -24     <boot message> */
.equ err.bt,(-24)
/* QL: err.cp  equ     -25     <copyright message> */
.equ err.cp,(-25)
/* QL: err.wh  equ     -26     during WHEN processing */
.equ err.wh,(-26)
/* QL: err.pf  equ     -27     PROC/FN cleared */
.equ err.pf,(-27)
/* QL:         list */
/* QL:         include 'win1_m_inc_fs' */
/* QL: * file system definitions */
/* QL:         nolist */
/* QL: fs.nmlen  equ    36     max length of file name */
.equ fs.nmlen,36
/* QL: fs.hdlen  equ    64     length of file system header */
.equ fs.hdlen,64
/* QL: * file system channel channel definition block */
/* QL:         offset  $18 ( = ch_end, end of standard channel header ) */
/* QL: fs_next ds.l    1       link to next file system channel */
.equ fs_next,24
/* QL: fs_acces ds.b   1       access mode */
.equ fs_acces,28
/* QL: fs_drive ds.b   1       drive id */
.equ fs_drive,29
/* QL: fs_filnr ds.w   1       file number */
.equ fs_filnr,30
/* QL: fs_nblok ds.w   1       block containing next byte */
.equ fs_nblok,32
/* QL: fs_nbyte ds.w   1       next byte in block */
.equ fs_nbyte,34
/* QL: fs_eblok ds.w   1       end of file (block) */
.equ fs_eblok,36
/* QL: fs_ebyte ds.w   1       end of file (byte in block) */
.equ fs_ebyte,38
/* QL: fs_cblok ds.l   1       pointer to table for current slave block */
.equ fs_cblok,40
/* QL: fs_updt ds.b    1       set if file is updated */
.equ fs_updt,44
/* QL:         ds.b    5       spare */
/* QL: fs_fname ds.w   1+fs.nmlen/2  length prefixed file name */
.equ fs_fname,50
/* QL: fs_spare ds.b   72 */
.equ fs_spare,88
/* QL: fs_end */
.equ fs_end,160
/* QL: * common part of a physical file system definition block */
/* QL:         offset  0 */
/* QL:         ds.b    $10 */
/* QL: fs_drivr ds.l   1       pointer to driver */
.equ fs_drivr,16
/* QL: fs_drivn ds.b   1       drive number */
.equ fs_drivn,20
/* QL:         ds.b    1 */
/* QL: fs_mname ds.w   1+10/2  length prefixed medium name */
.equ fs_mname,22
/* QL: fs_files ds.b   1       number of files open */
.equ fs_files,34
/* QL: * file system trap #3 codes */
/* QL: fs.check  equ    $40                check all pending operations */
.equ fs.check,0x40
/* QL: fs.flush  equ    $41                flush buffers */
.equ fs.flush,0x41
/* QL: fs.posab  equ    $42                position file pointer (absolute) */
.equ fs.posab,0x42
/* QL: fs.posre  equ    $43                position file pointer (relative) */
.equ fs.posre,0x43
/* QL: fs.mdinf  equ    $45                information about medium */
.equ fs.mdinf,0x45
/* QL: fs.heads  equ    $46                set file header */
.equ fs.heads,0x46
/* QL: fs.headr  equ    $47                read file header */
.equ fs.headr,0x47
/* QL: fs.load   equ    $48                load file */
.equ fs.load,0x48
/* QL: fs.save   equ    $49                save file */
.equ fs.save,0x49
/* QL: fs.renam  equ    $4a                rename file */
.equ fs.renam,0x4a
/* QL: fs.trunc  equ    $4b                truncate file */
.equ fs.trunc,0x4b
/* QL:         list */
/* QL:         include 'win1_m_inc_io' */
/* QL: * basic I/O keys */
/* QL:         nolist */
/* QL: * trap #2 d0 codes */
/* QL: io.open equ     1       open channel */
.equ io.open,1
/* QL: io.close equ    2       close channel */
.equ io.close,2
/* QL: io.formt equ    3       format medium */
.equ io.formt,3
/* QL: io.delet equ    4       delete file */
.equ io.delet,4
/* QL: * trap #2 d3 codes */
/* QL: io.old  equ     0       open old (exclusive) file or device */
.equ io.old,0
/* QL: io.share equ    1       open shared (old) file */
.equ io.share,1
/* QL: io.new  equ     2       open new (exclusive) file */
.equ io.new,2
/* QL: io.overw equ    3       open overwrite (or open new) file */
.equ io.overw,3
/* QL: io.dir  equ     4       open directory */
.equ io.dir,4
/* QL: * trap #3 d0 codes */
/* QL: io.pend equ     0       check for pending input */
.equ io.pend,0
/* QL: io.fbyte equ    1       fetch a byte */
.equ io.fbyte,1
/* QL: io.fline equ    2       fetch a line of bytes */
.equ io.fline,2
/* QL: io.fstrg equ    3       fetch a string of bytes */
.equ io.fstrg,3
/* QL: io.edlin equ    4       edit a line */
.equ io.edlin,4
/* QL: io.sbyte equ    5       send a byte */
.equ io.sbyte,5
/* QL: io.sstrg equ    7       send a string of bytes */
.equ io.sstrg,7
/* QL:         list */
/* QL:         include 'win1_m_inc_md' */
/* QL: * microdrive physical layer definition */
/* QL:         nolist */
/* QL:         offset  $10 */
/* QL: md_drivr ds.l   1       pointer to driver */
.equ md_drivr,16
/* QL: md_drivn ds.b   1       drive number */
.equ md_drivn,20
/* QL:         ds.b    1       spare */
/* QL: md_mname ds.w   1+10/2  length prefixed medium name and check number */
.equ md_mname,22
/* QL: md_files ds.b   1       number of files open */
.equ md_files,34
/* QL: md_estat ds.b   1       error status 0=ok -1=bad */
.equ md_estat,35
/* QL: md_fail ds.b    1       failure count */
.equ md_fail,36
/* QL:         ds.b    3       spare */
/* QL: md_map  ds.w    255     microdrive map (fe bad, fd vac, fc pending delete) */
.equ md_map,40
/* QL: md_lsect ds.w   1       last sector allocated. */
.equ md_lsect,550
/* QL: md_pendg ds.w   256     pending operations: 0 no, >0 slave block nr */
.equ md_pendg,552
/* QL:                                         ;   -1 write map, -2 verify map */
/* QL: md_end */
.equ md_end,1064
/* QL: * directory structure definitions */
/* QL:         offset  0 */
/* QL: md_delen ds.l   1       length */
.equ md_delen,0
/* QL: md_deacs ds.b   1       access key */
.equ md_deacs,4
/* QL: md_detyp ds.b   1       type */
.equ md_detyp,5
/* QL: md_deinf ds.l   2       information (data space first) */
.equ md_deinf,6
/* QL: md_denam ds.w   1+36/2  length prefixed file name */
.equ md_denam,14
/* QL: md_deupd ds.l   1       update date */
.equ md_deupd,52
/* QL:          ds.w   2       unit and version */
/* QL: md_debkd ds.l   1       backup date */
.equ md_debkd,60
/* QL: md_deend */
.equ md_deend,64
/* QL:         list */
/* QL: blkbits equ     9 */
.equ blkbits,9
/* QL:         section dd_mdvrn */
.section dd_mdvrn,"ax"
/* QL: * A problem child, this rename call... we have the rename string with the */
/* QL: * "mdvn_" still on the front. This means it's not convenient for ut_cstr. */
/* QL: * I don't think we're able to mess with the name in our channel, as multitask */
/* QL: * operation could screw up. (Well, it can anyway... as we change the name, */
/* QL: * conceivably someone else can change it simultaneously). Also, there's no */
/* QL: * guarantee we could mess with the user's copy, it could even be ROM! */
/* QL: * There are two reasonable courses of action one can take: */
/* QL: * Firstly, we could try nesting down a level, and doing an open.new on the */
/* QL: * user's filename. If it works, we then exchange the names and close the silly */
/* QL: * one. This could be enhanced by a special access code, maybe? Doubtfull. */
/* QL: * Secondly, one could scan the directory here, but keep shuffling the name read */
/* QL: * in to prepend the "mdvn_". This sounds pretty tacky, but it looks like the */
/* QL: * way we'll have to do it. It's only an error check, after all. */
/* QL: * The update date is no longer altered by a rename, per se. */
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i  - requested new name, with byte count word prefix */
/* QL: * a2 -ip - physical definition */
/* QL: * a3 -i  - driver definition */
/* QL: * d1-d3/d5/d7/a4 destroyed */
/* QL: dd_mdvrn */
dd_mdvrn:
/* QL:         assert  fs_filnr,fs_nblok-2,fs_nbyte-4,fs_eblok-6,fs_ebyte-8 */
/* original assertion: fs_filnr,fs_nblok-2,fs_nbyte-4,fs_eblok-6,fs_ebyte-8 */
/* QL:         lea     fs_filnr(a0),a4 */
    lea fs_filnr(a0),a4
/* QL:         move.w  (a4),-(sp)      save file number */
    move.w (a4),-(sp)
/* QL:         clr.w   (a4)+           file number zero is the directory */
    clr.w (a4)+
/* QL:         move.l  (a4),-(sp)      save current position */
    move.l (a4),-(sp)
/* QL:         clr.l   (a4)+           current position zero */
    clr.l (a4)+
/* QL:         move.l  (a4),-(sp)      save end position */
    move.l (a4),-(sp)
/* QL:         moveq   #fs.hdlen,d2    we want the length of the directory */
    moveq #fs.hdlen,d2
/* QL:         move.l  d2,(a4)         just say the directory is a single entry */
    move.l d2,(a4)
/* QL:         lea     ch_end+ch_drnam(a3),a3 */
    lea (ch_end+ch_drnam)(a3),a3
/* QL:         move.w  (a3),d5 */
    move.w (a3),d5
/* QL:         addq.w  #2,d5 */
    addq.w #2,d5
/* QL:         movem.l d5/a0-a1/a6,-(sp) keep extra and caller's new name + cstr regs */
    movem.l d5/a0-a1/a6,-(sp)
/* QL: * The stack is now loaded up with lots of goodies, start verifying name. */
/* QL:         moveq   #err.bn,d0 */
    moveq #err.bn,d0
/* QL:         sub.w   (a1)+,d5        is their name too short ... */
    sub.w (a1)+,d5
/* QL:         add.w   #fs.nmlen,d5    ... or too long? */
    add.w #fs.nmlen,d5
/* QL:         bcc.s   done            (note, we don't allow null name length) */
    bcc.s done
/* QL:         move.w  (a3)+,d5 */
    move.w (a3)+,d5
/* QL: nloop */
nloop:
/* QL:         moveq   #-1-32,d1 */
    moveq #((-1)-32),d1
/* QL:         and.b   (a1)+,d1 */
    and.b (a1)+,d1
/* QL:         cmp.b   (a3)+,d1 */
    cmp.b (a3)+,d1
/* QL:         bne.s   done            prefix didn't match our driver name */
    bne.s done
/* QL:         subq.w  #1,d5 */
    subq.w #1,d5
/* QL:         bne.s   nloop */
    bne.s nloop
/* QL:         moveq   #'0',d1 */
    moveq #48,d1
/* QL:         add.b   fs_drivn(a2),d1 */
    add.b fs_drivn(a2),d1
/* QL:         sub.b   (a1)+,d1        must match drive number */
    sub.b (a1)+,d1
/* QL:         bne.s   done */
    bne.s done
/* QL:         cmp.b   #'_',(a1)       must match underscore */
    cmp.b #(95&255),(a1)
/* QL:         bne.s   done */
    bne.s done
/* QL: * That's the easy checks over with. Now we must scan the directory. */
/* QL:         bsr.s   rd_ent */
    bsr.s rd_ent
/* QL:         bne.s   done */
    bne.s done
/* QL:         move.l  fs_spare(a0),d7 */
    move.l fs_spare(a0),d7
/* QL:         lsl.l   #16-blkbits,d7 */
    lsl.l #(16-blkbits),d7
/* QL:         lsr.w   #16-blkbits,d7 */
    lsr.w #(16-blkbits),d7
/* QL:         move.l  d7,(a4)         set true end of directory */
    move.l d7,(a4)
/* QL:         subq.l  #4,a4           point at current location */
    subq.l #4,a4
/* QL: scan */
scan:
/* QL:         moveq   #md_denam,d2    skip a bit */
    moveq #md_denam,d2
/* QL:         add.l   d2,(a4) */
    add.l d2,(a4)
/* QL:         moveq   #2,d2           read name length */
    moveq #2,d2
/* QL:         bsr.s   rd_ent */
    bsr.s rd_ent
/* QL:         bne.s   done */
    bne.s done
/* QL:         movem.l (sp),d5/a0/a3 */
    movem.l (sp),d5/a0/a3
/* QL:         add.w   d5,-(a1)        add extra to file name length */
    add.w d5,-(a1)
/* QL:         move.w  (a1)+,d1 */
    move.w (a1)+,d1
/* QL:         cmp.w   (a3)+,d1        it must now match caller's length */
    cmp.w (a3)+,d1
/* QL:         bne.s   tweak           (don't need to be so precise, compare fails) */
    bne.s tweak
/* QL: fillup */
fillup:
/* QL:         move.b  (a3)+,(a1)+     copy prefix from caller's buffer */
    move.b (a3)+,(a1)+
/* QL:         subq.b  #1,d5 */
    subq.b #1,d5
/* QL:         bne.s   fillup */
    bne.s fillup
/* QL: tweak */
tweak:
/* QL:         moveq   #fs.hdlen-2-md_denam,d2 read rest of entry */
    moveq #((fs.hdlen-2)-md_denam),d2
/* QL:         bsr.s   rd_more */
    bsr.s rd_more
/* QL:         bne.s   done */
    bne.s done
/* QL:         movem.l (sp),d5/a0-a1 */
    movem.l (sp),d5/a0-a1
/* QL:         moveq   #1,d0           comparison type */
    moveq #1,d0
/* QL:         sub.l   a6,a6           base register */
    sub.l a6,a6
/* QL:         lea     fs_spare(a0),a0 */
    lea fs_spare(a0),a0
/* QL:         jsr     ut_cstr(pc) */
    jsr ut_cstr(pc)
/* QL:         movem.l (sp),d5/a0/a3/a6 */
    movem.l (sp),d5/a0/a3/a6
/* QL:         beq.s   err_ex */
    beq.s err_ex
/* QL:         cmp.l   (a4),d7 */
    cmp.l (a4),d7
/* QL:         bne.s   scan */
    bne.s scan
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.s   done */
    bra.s done
/* QL: * Routines to read/write data */
/* QL: rd_ent */
rd_ent:
/* QL:         lea     fs_spare(a0),a1 */
    lea fs_spare(a0),a1
/* QL: rd_more */
rd_more:
/* QL:         moveq   #io.fstrg,d0 */
    moveq #io.fstrg,d0
/* QL: mdvrr */
mdvrr:
/* QL:         jmp     dd_mdvrr(pc) */
    jmp dd_mdvrr(pc)
/* QL: * We get here once we have decided what to do. Restore the file header first. */
/* QL: err_ex */
err_ex:
/* QL:         moveq   #err.ex,d0 */
    moveq #err.ex,d0
/* QL: done */
done:
/* QL:         movem.l (sp)+,d5/a0/a1/a6 */
    movem.l (sp)+,d5/a0/a1/a6
/* QL:         move.l  (sp)+,4(a4) */
    move.l (sp)+,4(a4)
/* QL:         move.l  (sp)+,(a4) */
    move.l (sp)+,(a4)
/* QL:         move.w  (sp)+,-2(a4) */
    move.w (sp)+,(-2)(a4)
/* QL:         tst.l   d0              did we ok the rename? */
    tst.l d0
/* QL:         bne.s   rts0            no - return the error */
    bne.s rts0
/* QL: * We're going to (try to) change the name. It's convenient to put it in the */
/* QL: * channel first, as we then only need a single write to send it out. */
/* QL: * This also means we can pad out the entry with nulls, like it should be. */
/* QL: * The drawback is that we might then find we can't write the file! Ho hum. lwr. */
/* QL:         lea     fs_fname+2+fs.nmlen(a0),a3 */
    lea ((fs_fname+2)+fs.nmlen)(a0),a3
/* QL:         moveq   #fs.nmlen/2,d0 */
    moveq #(fs.nmlen/2),d0
/* QL: zap */
zap:
/* QL:         clr.w   -(a3)           wipe out the old name */
    clr.w -(a3)
/* QL:         dbra    d0,zap */
    dbra d0,zap
/* QL:         move.w  (a1)+,d0        get new length */
    move.w (a1)+,d0
/* QL:         sub.w   d5,d0           correct length */
    sub.w d5,d0
/* QL:         add.w   d5,a1           skip drive bit */
    add.w d5,a1
/* QL:         move.w  d0,(a3)+        store the new name length */
    move.w d0,(a3)+
/* QL: newnam */
newnam:
/* QL:         move.b  (a1)+,(a3)+     put the new name in the channel */
    move.b (a1)+,(a3)+
/* QL:         subq.w  #1,d0 */
    subq.w #1,d0
/* QL:         bne.s   newnam */
    bne.s newnam
/* QL: * Now write it to the file header. we will presrve the file update state. */
/* QL:         move.b  fs_updt(a0),d5  save update flag */
    move.b fs_updt(a0),d5
/* QL:         move.l  (a4),d7         pick current back up */
    move.l (a4),d7
/* QL:         lea     fs_fname(a0),a1 */
    lea fs_fname(a0),a1
/* QL:         moveq   #md_denam,d2 */
    moveq #md_denam,d2
/* QL:         move.l  d2,(a4)         that's the bit we'll alter */
    move.l d2,(a4)
/* QL:         moveq   #2+fs.nmlen,d2 */
    moveq #(2+fs.nmlen),d2
/* QL:         moveq   #io.sstrg,d0 */
    moveq #io.sstrg,d0
/* QL:         bsr.s   mdvrr */
    bsr.s mdvrr
/* QL:         move.l  d7,(a4)         reset current location */
    move.l d7,(a4)
/* QL:         move.b  d5,fs_updt(a0)  restore update flag */
    move.b d5,fs_updt(a0)
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.s   rts0            ouch! that's not nice! channel already changed! */
    bne.s rts0
/* QL:         jmp     dd_mdvcd(pc)    this will copy it to the directory */
    jmp dd_mdvcd(pc)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL:         end */
