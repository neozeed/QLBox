/* Generated from original/M/io/fopen.asm */
/* QL: * General file system open and delete */
/* QL:         xdef    io_fopen,io_relch */
.globl io_fopen,io_relch
/* QL:         xref    mm_alchp,mm_rechp */
/* QL:         xref    ut_unlnk,ut_cstr */
/* QL:         xref    io_fdriv */
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
/* QL:         include 'win1_m_inc_sv' */
/* QL: * system variable definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sv_ident ds.w   1       identification word */
.equ sv_ident,0
/* QL:         ds.w    1       spare */
/* QL: sv_cheap ds.l   1       base of common heap area */
.equ sv_cheap,4
/* QL: sv_chpfr ds.l   1       first free space in common heap area */
.equ sv_chpfr,8
/* QL: sv_free ds.l    1       base of free area */
.equ sv_free,12
/* QL: sv_basic ds.l   1       base of basic area */
.equ sv_basic,16
/* QL: sv_trnsp ds.l   1       base of transient program area */
.equ sv_trnsp,20
/* QL: sv_trnfr ds.l   1       first free space in transient program area */
.equ sv_trnfr,24
/* QL: sv_respr ds.l   1       base of resident procedure area */
.equ sv_respr,28
/* QL: sv_ramt ds.l    1       top of ram (+1) */
.equ sv_ramt,32
/* QL:         ds.w    5       spare */
/* QL: sv_rand ds.w    1       random number */
.equ sv_rand,46
/* QL: sv_pollm ds.w   1       count of poll interupts missed */
.equ sv_pollm,48
/* QL: sv_tvmod ds.b   1       0 if not tv display */
.equ sv_tvmod,50
/* QL: sv_scrst ds.b   1       screen status (0 = active) */
.equ sv_scrst,51
/* QL: sv_mcsta ds.b   1       display mode of current job 0/8 mode4/mode8 */
.equ sv_mcsta,52
/* QL: sv_pcint ds.b   1       current value of pc interrupt register */
.equ sv_pcint,53
/* QL:         ds.b    1       spare */
/* QL: sv_netnr ds.b   1       network station number */
.equ sv_netnr,55
/* QL: sv_i2lst ds.l   1       pointer to list of interrupt 2 drivers */
.equ sv_i2lst,56
/* QL: sv_plist ds.l   1       pointer to list of polled tasks */
.equ sv_plist,60
/* QL: sv_shlst ds.l   1       pointer to list of scheduler tasks */
.equ sv_shlst,64
/* QL: sv_drlst ds.l   1       pointer to list of device drivers */
.equ sv_drlst,68
/* QL: sv_ddlst ds.l   1       pointer to list of directory device drivers */
.equ sv_ddlst,72
/* QL: sv_keyq ds.l    1       pointer to a keyboard queue */
.equ sv_keyq,76
/* QL: sv_trapv ds.l   1       pointer to the trap redirection table */
.equ sv_trapv,80
/* QL: * Pointers to the resource management tables */
/* QL: * The slave block tables have 8 byte entries, the others 4 byte entries */
/* QL: sv_btpnt ds.l   1       pointer to most recent slave block entry */
.equ sv_btpnt,84
/* QL: sv_btbas ds.l   1       pointer to base of slave block table */
.equ sv_btbas,88
/* QL: sv_bttop ds.l   1       pointer to top of slave block table */
.equ sv_bttop,92
/* QL: sv_jbtag ds.w   1       current value of job tag */
.equ sv_jbtag,96
/* QL: sv_jbmax ds.w   1       highest current job number */
.equ sv_jbmax,98
/* QL: sv_jbpnt ds.l   1       pointer to current job table entry */
.equ sv_jbpnt,100
/* QL: sv_jbbas ds.l   1       pointer to base of job table */
.equ sv_jbbas,104
/* QL: sv_jbtop ds.l   1       pointer to top of job table */
.equ sv_jbtop,108
/* QL: sv_chtag ds.w   1       current value of channel tag */
.equ sv_chtag,112
/* QL: sv_chmax ds.w   1       highest current channel number */
.equ sv_chmax,114
/* QL: sv_chpnt ds.l   1       pointer to last channel checked */
.equ sv_chpnt,116
/* QL: sv_chbas ds.l   1       pointer to base of channel table */
.equ sv_chbas,120
/* QL: sv_chtop ds.l   1       pointer to top of channel table, and extended sysvars */
.equ sv_chtop,124
/* QL: sv_frbl ds.l    1       interrupt level release memory linked list (sms2) */
.equ sv_frbl,128
/* QL:         ds.b    1       spare */
/* QL:         ds.b    1       set to $ff by ptrgen if this is a ql! */
/* QL:         ds.w    1       spare */
/* QL: sv_caps ds.b    1       caps lock 0=off $ff=on */
.equ sv_caps,136
/* QL:         ds.b    1       but people may overwrite as above was defined as w! */
/* QL: sv_arbuf ds.w   1       autorepeat buffer */
.equ sv_arbuf,138
/* QL: sv_ardel ds.w   1       autorepeat delay */
.equ sv_ardel,140
/* QL: sv_arfrq ds.w   1       autorepeat 1/freq */
.equ sv_arfrq,142
/* QL: sv_arcnt ds.w   1       autorepeat count */
.equ sv_arcnt,144
/* QL: sv_cqch ds.w    1       keyboard change queue character code (can be + alt!) */
.equ sv_cqch,146
/* QL: sv_wp   ds.w    1       microdrive write protect (1st byte) ipc p26 input */
.equ sv_wp,148
/* QL: sv_sound ds.w   1       sound status (only 1st byte used?) */
.equ sv_sound,150
/* QL: sv_ser1c ds.l   1       receive  channel 1 queue address */
.equ sv_ser1c,152
/* QL: sv_ser2c ds.l   1       receive  channel 2 queue address */
.equ sv_ser2c,156
/* QL: sv_tmode ds.b   1       ZX8302 transmit mode (includes last baud rate) */
.equ sv_tmode,160
/* QL:         ds.b    1       spare */
/* QL: sv_csub ds.l    1       subroutine to jump to on capslock (only reach + 32767!) */
.equ sv_csub,162
/* QL: sv_timo ds.w    1       timeout for switching transmit mode */
.equ sv_timo,166
/* QL: sv_timov ds.w   1       ser1/2 control bytes: 7=lost 6=frame 3=inhib 2..0=baud */
.equ sv_timov,168
/* QL: sv_fstat ds.w   1       flashing cursor count (silly if > about 16!) */
.equ sv_fstat,170
/* QL: sv_progd ds.l   1       to $60 byte extension, old progd string + qlib_use */
.equ sv_progd,172
/* QL: sv_datad ds.l   1       to data default string, this -$24 = new progd */
.equ sv_datad,176
/* QL: sv_destd ds.l   1       to dest default string, this is above + $24 */
.equ sv_destd,180
/* QL: sv_thing ds.l   1       thing list */
.equ sv_thing,184
/* QL:         ds.w    25      spare */
/* QL: sv_mdrun ds.b   1       which drive is running? */
.equ sv_mdrun,238
/* QL: sv_mdcnt ds.b   1       microdrive run-up run-down counter */
.equ sv_mdcnt,239
/* QL: sv_mddid ds.b   8       drive id*4 of each microdrive */
.equ sv_mddid,240
/* QL: sv_mdsta ds.b   8       status, 0 = no pending ops */
.equ sv_mdsta,248
/* QL: sv_fsdef ds.l   16      pointers to file system physical definition */
.equ sv_fsdef,256
/* QL: sv_fslst ds.l   1       pointer to list of file channel definitions */
.equ sv_fslst,320
/* QL: sv_tran ds.b    1       key translation off(0) or on(1) */
.equ sv_tran,324
/* QL: sv_ichar ds.b   1       compose char workspace */
.equ sv_ichar,325
/* QL: sv_trtab ds.l   1       pointer to key translation tables */
.equ sv_trtab,326
/* QL: sv_mgtab ds.l   1       pointer to message table */
.equ sv_mgtab,330
/* QL: daytab   equ    $1c     err. for names of days */
.equ daytab,0x1c
/* QL: montab   equ    $1d    err. names of months */
.equ montab,0x1d
/* QL:         ds.w    3 */
/* QL: sv_turb1 ds.l   1       used by turbo */
.equ sv_turb1,340
/* QL: sv_turb2 ds.l   1 */
.equ sv_turb2,344
/* QL: sv_turb3 ds.w   1       length of file name!!!! */
.equ sv_turb3,348
/* QL: sv_turb4 ds.b   32      actually uses up to 41 bytes for file name!!!!!! */
.equ sv_turb4,350
/* QL: * taskmaster uses $154 l*4 */
/* QL: sv_stacb ds.l   192     bottom of stack */
.equ sv_stacb,382
/* QL: sv_stact ; big stack - no check */
.equ sv_stact,1150
/* QL: sv_trapo equ 2*($28+2) offset of trap vector table from (sv_trapv) */
.equ sv_trapo,(2*(0x28+2))
/* QL: sv.ident equ $d254 green, red, blue and black, with flash bits */
.equ sv.ident,0xd254
/* QL: * device driver definitions (for the driver's own pseudo system vars) */
/* QL:         offset  0 */
/* QL: sv_lxint ds.l   1       link to next external interrupt service */
.equ sv_lxint,0
/* QL: sv_axint ds.l   1       address of external interrupt service */
.equ sv_axint,4
/* QL: sv_lpoll ds.l   1       link to next polling interrupt service */
.equ sv_lpoll,8
/* QL: sv_apoll ds.l   1       address of polling interrupt service */
.equ sv_apoll,12
/* QL: sv_lschd ds.l   1       link to next scheduler task */
.equ sv_lschd,16
/* QL: sv_aschd ds.l   1       address of scheduler task */
.equ sv_aschd,20
/* QL: sv_lio  ds.l    1       link to next io driver */
.equ sv_lio,24
/* QL: sv_aio  ds.l    1       address of input/output routine */
.equ sv_aio,28
/* QL: sv_aopen ds.l   1       address of channel open routine */
.equ sv_aopen,32
/* QL: sv_aclos ds.l   1       address of channel close routine */
.equ sv_aclos,36
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         section io_fopen */
.section io_fopen,"ax"
/* QL: * General file system open routine. Access key in d3 is 0..4. */
/* QL: * Routine used by io.open trap (2) after non file devices have been checked. */
/* QL: * Also used for io.delet trap with special value ($ff) in d3. */
/* QL: * d0 -  o- error flag */
/* QL: * d3 -ip - access key, or $ff for delete */
/* QL: * a0 -i o- pointer to name / pointer to definition block */
/* QL: * a2 -  o- address of driver */
/* QL: reglist reg     d1-d6/a3-a6 */
/* QL: io_fopen */
io_fopen:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d6/a3-a6,-(sp)
/* QL: * First find the driver */
/* QL: * (This moved to start by lwr - why allocate the channel when you haven't even */
/* QL: * got a driver, or a physical definition block, yet! Saves chp fragments too!) */
/* QL:         move.l  a0,a5           save the name pointer for later on */
    move.l a0,a5
/* QL:         jsr     io_fdriv(pc)    get all lookup's over with */
    jsr io_fdriv(pc)
/* QL:         bmi.s   exit            that device was not found */
    bmi.s exit
/* QL:         beq.s   physok          zero means we already have physical defn ready */
    beq.s physok
/* QL:         move.l  d5,d0           fdriv left the free slot in d5... or err.no */
    move.l d5,d0
/* QL:         bmi.s   exit */
    bmi.s exit
/* QL:         lsl.l   #2,d0 */
    lsl.l #2,d0
/* QL:         add.l   d0,a4           ready to record new physdef */
    add.l d0,a4
/* QL:         move.b  d5,d4           note: new slot number moved to d4 */
    move.b d5,d4
/* QL:         move.b  d1,d5 */
    move.b d1,d5
/* QL:         move.l  ch_dflen(a2),d1 get length of physical definition block */
    move.l ch_dflen(a2),d1
/* QL:         jsr     mm_alchp(pc)    allocate space, now preserves registers */
    jsr mm_alchp(pc)
/* QL:         bne.s   exit */
    bne.s exit
/* QL:         move.l  a0,a1           set physdef address */
    move.l a0,a1
/* QL:         move.l  a2,fs_drivr(a1) set driver */
    move.l a2,fs_drivr(a1)
/* QL:         move.b  d5,fs_drivn(a1) ... and drive number */
    move.b d5,fs_drivn(a1)
/* QL:         move.l  a1,(a4)         put address in physdef list */
    move.l a1,(a4)
/* QL: physok */
physok:
/* QL: * Allocate file channel definition block */
/* QL:         moveq   #fs_end>>1,d1 */
    moveq #(fs_end>>1),d1
/* QL:         add.b   d1,d1 */
    add.b d1,d1
/* QL:         jsr     mm_alchp(pc) */
    jsr mm_alchp(pc)
/* QL:         bne.s   exit */
    bne.s exit
/* QL: * From now on, all pointers point to fs_next within the block */
/* QL:         add.w   #fs_next,a0 */
    add.w #fs_next,a0
/* QL: * Link this definition block into list */
/* QL:         lea     sv_fslst(a6),a3 (used to use ut_link, but we'd like to keep a1) */
    lea sv_fslst(a6),a3
/* QL:         move.l  (a3),(a0)       put pointer to next in this item */
    move.l (a3),(a0)
/* QL:         move.l  a0,(a3)         and link it in */
    move.l a0,(a3)
/* QL: * Put drive id, access key and name into fs */
/* QL:         move.b  d4,fs_drive-fs_next(a0) drive id */
    move.b d4,(fs_drive-fs_next)(a0)
/* QL:         move.b  d3,fs_acces-fs_next(a0) access key */
    move.b d3,(fs_acces-fs_next)(a0)
/* QL:         lea     fs_fname-fs_next(a0),a4 */
    lea (fs_fname-fs_next)(a0),a4
/* QL:         move.w  (a5)+,d0        get name length */
    move.w (a5)+,d0
/* QL:         move.w  ch_drnam(a2),d2 ... and drive name length */
    move.w ch_drnam(a2),d2
/* QL:         addq.w  #2,d2           ... skipping over n_ */
    addq.w #2,d2
/* QL:         add.w   d2,a5           move pointer on */
    add.w d2,a5
/* QL:         sub.w   d2,d0           ... and reduce length of name */
    sub.w d2,d0
/* QL:         move.w  d0,(a4)+        put name length in block */
    move.w d0,(a4)+
/* QL:         cmp.w   #fs.nmlen,d0 */
    cmp.w #fs.nmlen,d0
/* QL:         bls.s   end_name        we allow 0..fs.name, anything else is trash */
    bls.s end_name
/* QL:         moveq   #err.bn,d5      negative or too long is a bad name */
    moveq #err.bn,d5
/* QL: err_d5 */
err_d5:
/* QL:         bsr.s   relch           unlink and release definition block */
    bsr.s relch
/* QL:         move.l  d5,d0           set error key */
    move.l d5,d0
/* QL: exit */
exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d6/a3-a6
/* QL:         rts */
    rts 
/* QL: io_relch */
io_relch:
/* QL:         add.w   #fs_next,a0     point to link in block */
    add.w #fs_next,a0
/* QL: relch */
relch:
/* QL:         lea     sv_fslst(a6),a1 unlink definition block from list */
    lea sv_fslst(a6),a1
/* QL:         jsr     ut_unlnk(pc) */
    jsr ut_unlnk(pc)
/* QL:         sub.w   #fs_next,a0     reset to base of block */
    sub.w #fs_next,a0
/* QL:         jmp     mm_rechp(pc)    free definition block */
    jmp mm_rechp(pc)
/* QL: mov_name */
mov_name:
/* QL:         move.b  (a5)+,(a4)+     copy the file name part into the channel */
    move.b (a5)+,(a4)+
/* QL: end_name */
end_name:
/* QL:         dbra    d0,mov_name */
    dbra d0,mov_name
/* QL: * Now we check if there is already a file open with the same name */
/* QL:         move.l  a1,a5           save pointer to definition block */
    move.l a1,a5
/* QL:         move.l  a0,a1           start at next block in list */
    move.l a0,a1
/* QL: next_dup */
next_dup:
/* QL:         move.l  (a1),a1         next block */
    move.l (a1),a1
/* QL:         move.l  a1,d0 */
    move.l a1,d0
/* QL:         beq.s   end_dup         end of list */
    beq.s end_dup
/* QL:         cmp.b   fs_drive-fs_next(a1),d4 is this same drive */
    cmp.b (fs_drive-fs_next)(a1),d4
/* QL:         bne.s   next_dup */
    bne.s next_dup
/* QL:         moveq   #1,d0           comparison type 1 */
    moveq #1,d0
/* QL:         moveq   #fs_fname-fs_next,d5 */
    moveq #(fs_fname-fs_next),d5
/* QL:         exg     d5,a6           offset of name in block */
    exg d5,a6
/* QL:         jsr     ut_cstr(pc)     compare names */
    jsr ut_cstr(pc)
/* QL:         exg     d5,a6           restore system variables base */
    exg d5,a6
/* QL:         bne.s   next_dup        no match - try next */
    bne.s next_dup
/* QL: * A matching file name has been found - check for access conflict */
/* QL:         moveq   #err.ex,d5 */
    moveq #err.ex,d5
/* QL:         moveq   #io.new,d0 */
    moveq #io.new,d0
/* QL:         sub.b   fs_acces-fs_next(a0),d0 is open 'new'? */
    sub.b (fs_acces-fs_next)(a0),d0
/* QL:         beq.s   err_d5          ... yes and so error - exists */
    beq.s err_d5
/* QL:         moveq   #err.iu,d5 */
    moveq #err.iu,d5
/* QL:         subq.b  #io.new-io.share,d0 is open 'share'? */
.word 20736|((((io.new-io.share))&7)<<9)
/* QL:         bne.s   err_d5          ... no and so error - in use */
    bne.s err_d5
/* QL:         cmp.b   #io.share,fs_acces-fs_next(a1) is other channel 'share'? */
    cmp.b #(io.share&255),(fs_acces-fs_next)(a1)
/* QL: err_d5n */
err_d5n:
/* QL:         bne.s   err_d5          ... no and so error - in use */
    bne.s err_d5
/* QL: * file is already open - so we can copy block to save directory seach */
/* QL:         move.w  fs_filnr-fs_next(a1),fs_filnr-fs_next(a0) */
    move.w (fs_filnr-fs_next)(a1),(fs_filnr-fs_next)(a0)
/* QL:         assert  fs_eblok,fs_ebyte-2 */
/* original assertion: fs_eblok,fs_ebyte-2 */
/* QL:         move.l  fs_eblok-fs_next(a1),fs_eblok-fs_next(a0) */
    move.l (fs_eblok-fs_next)(a1),(fs_eblok-fs_next)(a0)
/* QL:         move.w  #fs.hdlen,fs_nbyte-fs_next(a0) set initial byte pointer */
    move.w #fs.hdlen,(fs_nbyte-fs_next)(a0)
/* QL: end_dup */
end_dup:
/* QL:         move.l  a5,a1           restore pointer to definition block */
    move.l a5,a1
/* QL:         tst.w   fs_filnr-fs_next(a0) has a duplicate file been found */
    tst.w (fs_filnr-fs_next)(a0)
/* QL:         bne.s   exit_ok         yes - all done */
    bne.s exit_ok
/* QL: * Device dependent open */
/* QL:         movem.l a0-a2,-(sp)     save pointers */
    movem.l a0-a2,-(sp)
/* QL:         sub.w   #fs_next,a0     reset a0 so driver will understand it */
    sub.w #fs_next,a0
/* QL:         lea     -sv_lio(a2),a3  get base of driver definition */
    lea (-sv_lio)(a2),a3
/* QL:         move.l  ch_open(a2),a4  ... and open entry address */
    move.l ch_open(a2),a4
/* QL:         jsr     (a4)            ... go */
    jsr (a4)
/* QL:         movem.l (sp)+,a0-a2     (driver can even scrud a0 now...) */
    movem.l (sp)+,a0-a2
/* QL:         move.l  d0,d5           was there an error? */
    move.l d0,d5
/* QL:         bne.s   err_d5n         yes - free block, report error */
    bne.s err_d5n
/* QL:         tst.b   fs_acces-fs_next(a0) was this delete? */
    tst.b (fs_acces-fs_next)(a0)
/* QL:         blt.s   err_d5n         yes - free block, no error */
    blt.s err_d5n
/* QL: * In this version we do not release space taken by physical definition */
/* QL: * Update count of files open on drive */
/* QL: exit_ok */
exit_ok:
/* QL:         sub.w   #fs_next,a0     restore a0 */
    sub.w #fs_next,a0
/* QL:         addq.b  #1,fs_files(a1) ... one more file is open */
    addq.b #1,fs_files(a1)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.l   exit */
    bra.w exit
/* QL:         end */
