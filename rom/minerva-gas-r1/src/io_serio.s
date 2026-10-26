/* Generated from original/M/io/serio.asm */
/* QL: * generic serial i/o drviers */
/* QL:         xdef    io_serio,io_relio */
.globl io_serio,io_relio
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
/* QL: * The rules for serio and relio go like this: */
/* QL: * When serio or relio is called: */
/* QL: * d0 -i o- trap key / error code (ccr set) */
/* QL: * d1 -i o- ioss */
/* QL: * d2 -i  - ioss */
/* QL: * d3 -i  - ioss */
/* QL: * a0 -ip - ioss */
/* QL: * a1 -i o- ioss */
/* QL: * d4-d5/a4 destroyed */
/* QL: * Routines for test, fetch and send are supplied. For io_serio, they are */
/* QL: * absolute addresses in the three longwords at the return address, and return */
/* QL: * is made to the word after them. For io_relio, the three words at the return */
/* QL: * address are the relative offsets from themselves to the routines, and return */
/* QL: * is made to the next level up on the stack. */
/* QL: * Any values in d6-d7/a5 (and indeed a6, though one rather expects this to be */
/* QL: * the base of the system variables!) are passed down to the supplied routines. */
/* QL: * They may make no assumptions about the contents of d0-d1/d5-d6/a1/a4. */
/* QL: * When the supplied routines are called, they should either return an error in */
/* QL: * d0 or, if they are succesful, they should return zero in d0. */
/* QL: * The send routine will be passed the byte to be send in d1.b, msbs undefined. */
/* QL: * They may destroy d1-d3 and a1-a3, with the exception that the test and fetch */
/* QL: * routines must return the next available byte in d1.b if they succeed. */
/* QL: * Note that once the test routine has indicated success, further calls to it */
/* QL: * should keep succeeding, and returning the same value in d1.b, until such time */
/* QL: * as a fetch call is made, which should also succeed, and return the same byte. */
/* QL: * While in here, the least significant bit of the return address is a flag. */
/* QL: * The bit is set for an io_serio call. It is employed to action appropriate */
/* QL: * code for fetching the routine addresses to a4 and doing the final return. */
/* QL: * We maintain a1 in the IOSS manner, with d4 as a copy of the buffer length */
/* QL: * from the initial d2 and d5 as the count of characters done from the initial */
/* QL: * d1, as appropriate. */
/* QL:         section io_serio */
.section io_serio,"ax"
/* QL: tabent  macro   t */
/* QL: off */
off:
/* QL:         tabent  io_pend */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_210:
.byte (((io_pend-io_pend)&0x7fffffff))&255
/* QL:         tabent  io_fbyte */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_214:
.byte (((io_fbyte-io_pend)&0x7fffffff))&255
/* QL:         tabent  io_fline */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_218:
.byte (((io_fline-io_pend)&0x7fffffff))&255
/* QL:         tabent  io_fstrg */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_222:
.byte (((io_fstrg-io_pend)&0x7fffffff))&255
/* QL:         tabent  err_bp ; io.edlin */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_226:
.byte (((err_bp-io_pend)&0x7fffffff))&255
/* QL:         tabent  io_sbyte */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_230:
.byte (((io_sbyte-io_pend)&0x7fffffff))&255
/* QL:         tabent  err_bp */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_234:
.byte (((err_bp-io_pend)&0x7fffffff))&255
/* QL:         tabent  io_sstrg */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_238:
.byte (((io_sstrg-io_pend)&0x7fffffff))&255
/* QL:         tabent  fs_heads */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_242:
.byte (((fs_heads-io_pend)&0x7fffffff))&255
/* QL:         tabent  fs_headr */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_246:
.byte (((fs_headr-io_pend)&0x7fffffff))&255
/* QL:         tabent  io_fstrg */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_250:
.byte (((io_fstrg-io_pend)&0x7fffffff))&255
/* QL:         tabent  io_sstrg */
/* QL:         dc.b    (([t])-io_pend)&$7fffffff */
dc_anchor_254:
.byte (((io_sstrg-io_pend)&0x7fffffff))&255
/* QL: io_serio */
io_serio:
/* QL:         addq.l  #1,(sp)         set flag for old serio call */
    addq.l #1,(sp)
/* QL: io_relio */
io_relio:
/* QL:         move.l  (sp),a4         get a copy of return address ready */
    move.l (sp),a4
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         move.w  d2,d4           io.xxx calls use word buffer lengths */
    move.w d2,d4
/* QL:         move.l  d1,d5           set copy of d1 */
    move.l d1,d5
/* QL:         subq.w  #io.sstrg+1,d0 */
    subq.w #(io.sstrg+1),d0
/* QL:         bcs.s   action          key in io.xxx range, go do it */
    bcs.s action
/* QL:         move.l  d2,d4           fs.xxx calls use longword buffer lengths */
    move.l d2,d4
/* QL:         sub.w   #fs.save-io.sstrg,d0 */
    sub.w #(fs.save-io.sstrg),d0
/* QL:         addq.w  #fs.save-fs.heads+1,d0 */
.word 20544|(((((fs.save-fs.heads)+1))&7)<<9)
/* QL:         bcs.s   action          key in fs.xxx range, go do it */
    bcs.s action
/* QL:         moveq   #6-io.sstrg-1,d0 force report of bad parameter */
    moveq #((6-io.sstrg)-1),d0
/* QL: action */
action:
/* QL:         addq.w  #io.sstrg+1,d0 */
    addq.w #(io.sstrg+1),d0
/* QL:         move.b  off(pc,d0.w),d0 */
    move.b off(pc,d0.w),d0
/* QL:         jsr     io_pend(pc,d0.w) call code to do the work */
    jsr io_pend(pc,d0.w)
/* QL:         moveq   #3*4-1,d4 */
    moveq #((3*4)-1),d4
/* QL:         add.l   (sp)+,d4        get ready for return */
    add.l (sp)+,d4
/* QL:         btst    #0,d4           check call type */
    btst #0,d4
/* QL:         bne.s   tstret          relio: returns up a level after setting ccr */
    bne.s tstret
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         move.l  d4,a4 */
    move.l d4,a4
/* QL:         jmp     (a4)            serio: return to word past the addresses */
    jmp (a4)
/* QL: io_pend */
io_pend:
/* QL: *       moveq   #0,d0           test routine is the first element */
/* QL:         bsr.s   vectest         set up test routine address */
    bsr.s vectest
/* QL:         bra.s   callit          go do it */
    bra.s callit
/* QL: fs_heads */
fs_heads:
/* QL:         moveq   #15,d4          fixed buffer length of 15 */
    moveq #15,d4
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         beq.s   heads1          if nothing done yet, go send the $ff prefix */
    beq.s heads1
/* QL: io_sstrg */
io_sstrg:
/* QL:         bsr.s   vecsend         set routine address for sending bytes */
    bsr.s vecsend
/* QL: sslp */
sslp:
/* QL:         cmp.l   d4,d5           check count sent against buffer length */
    cmp.l d4,d5
/* QL:         bcc.s   setd1_ok        if we have finished, get out */
    bcc.s setd1_ok
/* QL:         move.b  (a1),d1         get a byte from the buffer */
    move.b (a1),d1
/* QL:         bsr.s   callit          call the send routine */
    bsr.s callit
/* QL:         bne.s   setd1           on error, return d1/a1 updated by count sent */
    bne.s setd1
/* QL:         addq.l  #1,a1           move past the byte */
    addq.l #1,a1
/* QL: ssadd1 */
ssadd1:
/* QL:         addq.l  #1,d5           count what we've done so far */
    addq.l #1,d5
/* QL:         bra.s   sslp            go see if more to send */
    bra.s sslp
/* QL: heads1 */
heads1:
/* QL:         st      d1              prefix byte for file header is $ff */
    st d1
/* QL:         bsr.s   io_sbyte        send that */
    bsr.s io_sbyte
/* QL:         bne.s   setd1           on error, return with no bytes sent */
    bne.s setd1
/* QL:         bra.s   ssadd1          continue as per send string */
    bra.s ssadd1
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0      report error for bad key or bad header prefix */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: vecsend */
vecsend:
/* QL:         moveq   #2*2,d0         send vector is offset by two elements */
    moveq #(2*2),d0
/* QL: vector */
vector:
/* QL:         add.w   d0,a4           address for relio, needs another add for serio */
    add.w d0,a4
/* QL: vectest */
vectest:
/* QL:         exg     a4,d0 */
    exg a4,d0
/* QL:         btst    #0,d0           test lsb of address register */
    btst #0,d0
/* QL:         exg     a4,d0 */
    exg a4,d0
/* QL:         beq.s   vecrel          if zero, go do relative vector */
    beq.s vecrel
/* QL:         move.l  -1(a4,d0.w),a4  pick up serio's absolute vector */
    move.l (-1)(a4,d0.w),a4
/* QL:         rts */
    rts 
/* QL: vecrel */
vecrel:
/* QL:         add.w   (a4),a4         add relio's relative vector to get absolute */
    add.w (a4),a4
/* QL:         rts */
    rts 
/* QL: io_sbyte */
io_sbyte:
/* QL:         bsr.s   vecsend         set up send routine address */
    bsr.s vecsend
/* QL:         bra.s   callit          go do it */
    bra.s callit
/* QL: io_fbyte */
io_fbyte:
/* QL:         bsr.s   vecfetch        set up fetch routine address */
    bsr.s vecfetch
/* QL: callit */
callit:
/* QL:         movem.l d4-d5/a1/a4,-(sp) save our registers */
    movem.l d4-d5/a1/a4,-(sp)
/* QL:         jsr     (a4)            call the test/fetch/send routine */
    jsr (a4)
/* QL:         movem.l (sp)+,d4-d5/a1/a4 restore our registers */
    movem.l (sp)+,d4-d5/a1/a4
/* QL: tstret */
tstret:
/* QL:         tst.l   d0              ensure set ccr before returning */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: vecfetch */
vecfetch:
/* QL:         moveq   #2,d0           fetch routing is offset by one element */
    moveq #2,d0
/* QL:         bra.s   vector          go set up the fetch routine address */
    bra.s vector
/* QL: fs_headr */
fs_headr:
/* QL:         moveq   #15,d4          fix header read buffer size as 15 */
    moveq #15,d4
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         beq.s   headr1          if nothing yet read, go check the prefix byte */
    beq.s headr1
/* QL: io_fstrg */
io_fstrg:
/* QL:         bsr.s   vecfetch        set up the fetch routine address */
    bsr.s vecfetch
/* QL:         bra.s   fslp            enter the loop */
    bra.s fslp
/* QL: fsnxt */
fsnxt:
/* QL:         bsr.s   callit          call the fetch routine */
    bsr.s callit
/* QL:         bne.s   setd1           on error, return updated d1/a1 */
    bne.s setd1
/* QL:         move.b  d1,(a1)+        store byte read and update buffer pointer */
    move.b d1,(a1)+
/* QL: fsadd1 */
fsadd1:
/* QL:         addq.l  #1,d5           count it */
    addq.l #1,d5
/* QL: fslp */
fslp:
/* QL:         cmp.l   d4,d5           check count against buffer size */
    cmp.l d4,d5
/* QL:         bcs.s   fsnxt           if not yet full, keep fetching */
    bcs.s fsnxt
/* QL: setd1_ok */
setd1_ok:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: setd1 */
setd1:
/* QL:         move.l  d5,d1           copy our count, or return byte, to d1 */
    move.l d5,d1
/* QL:         bra.s   tstret          set ccr before returning */
    bra.s tstret
/* QL: headr1 */
headr1:
/* QL:         bsr.s   io_pend         see if there is a byte available yet */
    bsr.s io_pend
/* QL:         bne.s   setd1           if not, or there's a problem, return updated */
    bne.s setd1
/* QL:         not.b   d1              check the value of the waiting byte */
    not.b d1
/* QL:         bne.s   err_bp          error if it isn't $ff */
    bne.s err_bp
/* QL:         move.l  4(sp),a4        restore a4, as we need a new routine now */
    move.l 4(sp),a4
/* QL:         bsr.s   io_fbyte        fetch the $ff byte, and throw it away */
    bsr.s io_fbyte
/* QL:         bra.s   fsadd1          continue as per fetch string for the rest */
    bra.s fsadd1
/* QL: io_fline */
io_fline:
/* QL:         bsr.s   vecfetch        set up the fetch routine address */
    bsr.s vecfetch
/* QL: fllp */
fllp:
/* QL:         moveq   #err.bo,d0      error if the buffer fills up with no line feed */
    moveq #err.bo,d0
/* QL:         cmp.l   d4,d5           check count against buffer length */
    cmp.l d4,d5
/* QL:         bcc.s   setd1           full up and no line feed, return updated d1/a1 */
    bcc.s setd1
/* QL:         bsr.s   callit          call the fetch routine */
    bsr.s callit
/* QL:         bne.s   setd1           on error, return with updated d1/a1 */
    bne.s setd1
/* QL:         move.b  d1,(a1)+        store fetched byte and update pointer */
    move.b d1,(a1)+
/* QL:         addq.l  #1,d5           count it */
    addq.l #1,d5
/* QL:         cmp.b   #10,d1          was it a line feed? */
    cmp.b #(10&255),d1
/* QL:         bne.s   fllp            no, keep fetching bytes */
    bne.s fllp
/* QL:         bra.s   setd1           successful fetch line, go return updated d1/a1 */
    bra.s setd1
/* QL:         end */
