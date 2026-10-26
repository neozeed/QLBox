/* Generated from original/M/dd/mdvcl.asm */
/* QL: * close microdrive channel (also write updated bits in dir/header) */
/* QL:         xdef    dd_mdvcd,dd_mdvcl,dd_mdvlu */
.globl dd_mdvcd,dd_mdvcl,dd_mdvlu
/* QL:         xref    dd_mdvpd,dd_mdvrr */
/* QL:         xref    io_relch */
/* QL:         xref    md_slave */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
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
/* QL:         include 'win1_m_inc_mt' */
/* QL: * manager trap #1 codes */
/* QL:         nolist */
/* QL: mt.inf  equ     $00     get system information */
.equ mt.inf,0x00
/* QL: mt.cjob equ     $01     create a job */
.equ mt.cjob,0x01
/* QL: mt.jinf equ     $02     get information on job */
.equ mt.jinf,0x02
/* QL: mt.extop equ    $03     convert called routine to supervisor, rte at end */
.equ mt.extop,0x03
/* QL: mt.rjob equ     $04     remove a job */
.equ mt.rjob,0x04
/* QL: mt.frjob equ    $05     force remove a job */
.equ mt.frjob,0x05
/* QL: mt.free equ     $06     find out how much free space there is */
.equ mt.free,0x06
/* QL: mt.trapv equ    $07     set pointer to trap redirection vectors */
.equ mt.trapv,0x07
/* QL: mt.susjb equ    $08     suspend a job */
.equ mt.susjb,0x08
/* QL: mt.reljb equ    $09     release a job */
.equ mt.reljb,0x09
/* QL: mt.activ equ    $0a     activate a job */
.equ mt.activ,0x0a
/* QL: mt.prior equ    $0b     set a job priority */
.equ mt.prior,0x0b
/* QL: mt.alloc equ    $0c     allocate a bit of a heap */
.equ mt.alloc,0x0c
/* QL: mt.lnkfr equ    $0d     release a bit of a heap */
.equ mt.lnkfr,0x0d
/* QL: mt.alres equ    $0e     allocate resident procedure area */
.equ mt.alres,0x0e
/* QL: mt.reres equ    $0f     release resident procedure area */
.equ mt.reres,0x0f
/* QL: mt.dmode equ    $10     set display mode */
.equ mt.dmode,0x10
/* QL: mt.ipcom equ    $11     send IPC command */
.equ mt.ipcom,0x11
/* QL: mt.baud equ     $12     set baud rate */
.equ mt.baud,0x12
/* QL: mt.rclck equ    $13     read clock */
.equ mt.rclck,0x13
/* QL: mt.sclck equ    $14     set clock */
.equ mt.sclck,0x14
/* QL: mt.aclck equ    $15     adjust clock */
.equ mt.aclck,0x15
/* QL: mt.albas equ    $16     allocate basic area */
.equ mt.albas,0x16
/* QL: mt.rebas equ    $17     release basic area */
.equ mt.rebas,0x17
/* QL: mt.alchp equ    $18     allocate space in common heap */
.equ mt.alchp,0x18
/* QL: mt.rechp equ    $19     release space in common heap */
.equ mt.rechp,0x19
/* QL: mt.lxint equ    $1a     link in external interrupt handler */
.equ mt.lxint,0x1a
/* QL: mt.rxint equ    $1b     remove external interrupt handler */
.equ mt.rxint,0x1b
/* QL: mt.lpoll equ    $1c     link in polled task */
.equ mt.lpoll,0x1c
/* QL: mt.rpoll equ    $1d     remove polled task */
.equ mt.rpoll,0x1d
/* QL: mt.lschd equ    $1e     link in scheduler task */
.equ mt.lschd,0x1e
/* QL: mt.rschd equ    $1f     remove scheduler task */
.equ mt.rschd,0x1f
/* QL: mt.liod equ     $20     link in I/O driver */
.equ mt.liod,0x20
/* QL: mt.riod equ     $21     remove I/O driver */
.equ mt.riod,0x21
/* QL: mt.ldd  equ     $22     link in directory driver */
.equ mt.ldd,0x22
/* QL: mt.rdd  equ     $23     remove directory driver */
.equ mt.rdd,0x23
/* QL: mt.cntry equ    $24     set translate/error tables */
.equ mt.cntry,0x24
/* QL:         list */
/* QL: blkbits equ     9 */
.equ blkbits,9
/* QL: *blksize equ    1<<blkbits */
/* QL: entbits equ     6 */
.equ entbits,6
/* QL:         assert  1<<entbits,fs.hdlen */
/* original assertion: 1<<entbits,fs.hdlen */
/* QL:         section dd_mdvcl */
.section dd_mdvcl,"ax"
/* QL: * d0 -  o- 0 */
/* QL: * d6 -  o- drive id * 16 + 1<<bt..file */
/* QL: * a0 -i  - channel definition */
/* QL: * a2 -  o- physical definition */
/* QL: * a3 -ip - directory driver linkage block (not used) */
/* QL: dd_mdvcl */
dd_mdvcl:
/* QL:         jsr     dd_mdvpd(pc)    sort out physdef stuff */
    jsr dd_mdvpd(pc)
/* QL:         bsr.s   dd_mdvlu        update length/date */
    bsr.s dd_mdvlu
/* QL:         subq.b  #1,md_files(a2) one fewer files */
    subq.b #1,md_files(a2)
/* QL:         jmp     io_relch(pc)    unlink and remove channel definition block */
    jmp io_relch(pc)
/* QL: * Update file header with data length and update date and copy it to directory. */
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - channel definition */
/* QL: * a2 -ip - physical definition */
/* QL: dd_mdvlu */
dd_mdvlu:
/* QL:         tst.b   fs_updt(a0)     was file updated? */
    tst.b fs_updt(a0)
/* QL:         bne.s   dd_mdvcd        yes - go update length and update date */
    bne.s dd_mdvcd
/* QL:         moveq   #0,d0           just to be consistent */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: reglist reg     d1-d3/a1/a3-a4 */
/* QL: dd_mdvcd */
dd_mdvcd:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a1/a3-a4,-(sp)
/* QL:         assert  fs_filnr,fs_nblok-2,fs_nbyte-4,fs_eblok-6,fs_ebyte-8 */
/* original assertion: fs_filnr,fs_nblok-2,fs_nbyte-4,fs_eblok-6,fs_ebyte-8 */
/* QL:         lea     fs_filnr(a0),a4 */
    lea fs_filnr(a0),a4
/* QL:         move.w  (a4)+,-(sp)     save file no */
    move.w (a4)+,-(sp)
/* QL:         move.l  (a4)+,-(sp)     save current */
    move.l (a4)+,-(sp)
/* QL:         move.l  (a4),-(sp)      save end */
    move.l (a4),-(sp)
/* QL:         clr.l   -(a4)           set current to zero to address header */
    clr.l -(a4)
/* QL:         moveq   #io.fstrg,d0 */
    moveq #io.fstrg,d0
/* QL:         bsr.s   rd_ent          get current image of file header */
    bsr.s rd_ent
/* QL:         bne.s   getout          couldn't read it! */
    bne.s getout
/* QL:         tst.b   fs_updt(a0)     was file really updated? (rename skips here) */
    tst.b fs_updt(a0)
/* QL:         beq.s   headok          no - don't actually change header */
    beq.s headok
/* QL:         move.l  (sp),d0 */
    move.l (sp),d0
/* QL:         lsl.w   #16-blkbits,d0  get file length */
    lsl.w #(16-blkbits),d0
/* QL:         lsr.l   #16-blkbits,d0  in true form */
    lsr.l #(16-blkbits),d0
/* QL:         move.l  d0,md_delen+fs_spare(a0) set file length */
    move.l d0,(md_delen+fs_spare)(a0)
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         moveq   #mt.rclck,d0    get a reading from the clock */
    moveq #mt.rclck,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         move.l  d1,md_deupd+fs_spare(a0) set update date */
    move.l d1,(md_deupd+fs_spare)(a0)
/* QL:         clr.l   (a4)            reset position to header */
    clr.l (a4)
/* QL:         bsr.s   wr_ent          write length and update date to file header */
    bsr.s wr_ent
/* QL:         bne.s   getout          yeuch! we're in trouble */
    bne.s getout
/* QL: headok */
headok:
/* QL:         move.w  -(a4),d0        get file number */
    move.w -(a4),d0
/* QL:         clr.w   (a4)+           directory is file 0 */
    clr.w (a4)+
/* QL:         lsl.l   #entbits,d0     and convert to directory position */
    lsl.l #entbits,d0
/* QL:         lsl.l   #16-blkbits,d0 */
    lsl.l #(16-blkbits),d0
/* QL:         lsr.w   #16-blkbits,d0 */
    lsr.w #(16-blkbits),d0
/* QL:         move.l  d0,(a4)         set current to directory */
    move.l d0,(a4)
/* QL:         st      fs_eblok+1(a0)  of great length!!! */
    st (fs_eblok+1)(a0)
/* QL:         bsr.s   wr_ent          write whole header to directory entry */
    bsr.s wr_ent
/* QL:         bne.s   getout */
    bne.s getout
/* QL:         jsr     md_slave(pc) */
    jsr md_slave(pc)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: getout */
getout:
/* QL:         sf      fs_updt(a0)     we can clear the flag, i hope! (lwr) */
    sf fs_updt(a0)
/* QL:         lea     fs_eblok(a0),a4 */
    lea fs_eblok(a0),a4
/* QL:         move.l  (sp)+,(a4)      restore end */
    move.l (sp)+,(a4)
/* QL:         move.l  (sp)+,-(a4)     restore current */
    move.l (sp)+,-(a4)
/* QL:         move.w  (sp)+,-(a4)     restore file no */
    move.w (sp)+,-(a4)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d3/a1/a3-a4
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * Write the length and update date */
/* QL: wr_ent */
wr_ent:
/* QL:         moveq   #io.sstrg,d0    send header or directory entry */
    moveq #io.sstrg,d0
/* QL: rd_ent */
rd_ent:
/* QL:         lea     fs_spare(a0),a1 use spare in block */
    lea fs_spare(a0),a1
/* QL:         moveq   #fs.hdlen,d2 */
    moveq #fs.hdlen,d2
/* QL:         jmp     dd_mdvrr(pc)    direct entry */
    jmp dd_mdvrr(pc)
/* QL:         end */
