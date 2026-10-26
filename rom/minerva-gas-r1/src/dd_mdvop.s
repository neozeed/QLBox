/* Generated from original/M/dd/mdvop.asm */
/* QL: * Open a file on a microdrive (delete and truncate are here too) */
/* QL:         xdef    dd_mdvop,dd_mdvtr */
.globl dd_mdvop,dd_mdvtr
/* QL:         xref    md_slavn */
/* QL:         xref    ut_cstr */
/* QL:         xref    dd_mdvlu,dd_mdvrr */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         include 'win1_m_inc_bt' */
/* QL: * memory block table definitions */
/* QL:         nolist */
/* QL: * memory block table entries */
/* QL:         offset  0 */
/* QL: bt_stat ds.b    1       drive id / status byte - see below */
.equ bt_stat,0
/* QL: bt_prior ds.b   1       block priority */
.equ bt_prior,1
/* QL: bt_sectr ds.w   1       sector number (microdrive*2) */
.equ bt_sectr,2
/* QL: bt_filnr ds.w   1       file number (microdrive)   } logical */
.equ bt_filnr,4
/* QL: bt_block ds.w   1       block number (microdrive)  } location */
.equ bt_block,6
/* QL: bt_end */
.equ bt_end,8
/* QL: * bits of status codes */
/* QL: bt..file equ    0       set if a file block */
.equ bt..file,0
/* QL: bt..accs equ    1       set if contents may be accessed */
.equ bt..accs,1
/* QL: bt..wreq equ    2       set if block required to be written */
.equ bt..wreq,2
/* QL: bt..rdvr equ    3       set if block required to be read / verified */
.equ bt..rdvr,3
/* QL: * The most significant 4 bits of the status byte contain the pointer to the */
/* QL: * physical device block sv_fsdef, the least significant are the status codes: */
/* QL: bt.unav equ     0                       unavailable to file system */
.equ bt.unav,0
/* QL: bt.empty equ    1<<bt..file             empty */
.equ bt.empty,(1<<bt..file)
/* QL: bt.rreq equ     bt.empty!1<<bt..rdvr    required to be read */
.equ bt.rreq,(bt.empty|(1<<bt..rdvr))
/* QL: bt.true equ     bt.empty!1<<bt..accs    true representation of file */
.equ bt.true,(bt.empty|(1<<bt..accs))
/* QL: bt.aver equ     bt.true!1<<bt..rdvr     awaiting verify */
.equ bt.aver,(bt.true|(1<<bt..rdvr))
/* QL: bt.updt equ     bt.true!1<<bt..wreq     updated */
.equ bt.updt,(bt.true|(1<<bt..wreq))
/* QL: * status code masks */
/* QL: bt.actn equ     1<<bt..rdvr!1<<bt..wreq check for read or write request */
.equ bt.actn,((1<<bt..rdvr)|(1<<bt..wreq))
/* QL: bt.inuse equ    bt.actn!1<<bt..accs     check if a file block in use */
.equ bt.inuse,(bt.actn|(1<<bt..accs))
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
/* QL: maxsec  equ     255 */
.equ maxsec,255
/* QL: vacant  equ     $fd */
.equ vacant,0xfd
/* QL: blkbits equ     9 */
.equ blkbits,9
/* QL: blklen  equ     1<<blkbits */
.equ blklen,(1<<blkbits)
/* QL: entbits equ     6 */
.equ entbits,6
/* QL:         assert  1<<entbits,fs.hdlen */
/* original assertion: 1<<entbits,fs.hdlen */
/* QL:         section dd_mdvop */
.section dd_mdvop,"ax"
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - base of channel definition block */
/* QL: * a1 -i  - base of physical definition block */
/* QL: * a2 -  o- base of physical definition block */
/* QL: * a3 -i  - base of driver definition block (not used) */
/* QL: * d1-d7/a4 destroyed */
/* QL: dd_mdvop */
dd_mdvop:
/* QL:         move.l  a1,a2           slave uses a2 */
    move.l a1,a2
/* QL: * First we set the drive id for this drive */
/* QL:         moveq   #0,d1           get drive number */
    moveq #0,d1
/* QL:         move.b  md_drivn(a2),d1 */
    move.b md_drivn(a2),d1
/* QL:         moveq   #0,d6 */
    moveq #0,d6
/* QL:         move.b  fs_drive(a0),d6 ... and drive id*4 */
    move.b fs_drive(a0),d6
/* QL:         lsl.b   #2,d6 */
    lsl.b #2,d6
/* QL:         lea     sv_mdrun(a6),a4 ... and put into table of ids */
    lea sv_mdrun(a6),a4
/* QL:         move.b  d6,sv_mddid-sv_mdrun-1(a4,d1.w) */
    move.b d6,((sv_mddid-sv_mdrun)-1)(a4,d1.w)
/* QL:         lsl.b   #4-2,d6 */
    lsl.b #(4-2),d6
/* QL:         addq.b  #1<<bt..file,d6 ready for delete file blocks */
    addq.b #(1<<bt..file),d6
/* QL: * Now check for drive running or any pending operations */
/* QL:         cmp.b   (a4),d1         is this one running? */
    cmp.b (a4),d1
/* QL:         beq.s   read_dir */
    beq.s read_dir
/* QL:         tst.b   sv_mdsta-sv_mdrun-1(a4,d1.w) is it waiting? */
    tst.b ((sv_mdsta-sv_mdrun)-1)(a4,d1.w)
/* QL:         bne.s   read_dir */
    bne.s read_dir
/* QL: * Now we get map if medium changed or first medium in drive */
/* QL:         move.b  #1,md_estat(a2) set error flag!! */
    move.b #(1&255),md_estat(a2)
/* QL:         jsr     md_slavn(pc) */
    jsr md_slavn(pc)
/* QL: wait */
wait:
/* QL:         tst.b   md_estat(a2)    check status */
    tst.b md_estat(a2)
/* QL:         bgt.s   wait            not yet acted upon */
    bgt.s wait
/* QL:         blt.s   err_nf          oops */
    blt.s err_nf
/* QL: read_dir */
read_dir:
/* QL:         lea     fs_spare(a0),a4 use spare bit of channel */
    lea fs_spare(a0),a4
/* QL:         moveq   #fs.hdlen,d2    keep entry length in d2 (almost) permanently */
    moveq #fs.hdlen,d2
/* QL:         move.l  d2,fs_eblok(a0) minimum size directory can be */
    move.l d2,fs_eblok(a0)
/* QL:         bsr.s   read_ent        read an entry */
    bsr.s read_ent
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         bsr.s   setsize         set up proper next/end positions, d4=end */
    bsr.s setsize
/* QL:         moveq   #0,d5           first vacant slot */
    moveq #0,d5
/* QL:         cmp.b   #io.dir,fs_acces(a0) was this open directory? */
    cmp.b #(io.dir&255),fs_acces(a0)
/* QL:         bne.s   nxt_file */
    bne.s nxt_file
/* QL:         clr.w   fs_fname(a0)    make name null for directory */
    clr.w fs_fname(a0)
/* QL:         rts */
    rts 
/* QL: empty */
empty:
/* QL:         tst.l   d5              is this the first vacant slot */
    tst.l d5
/* QL:         bne.s   nxt_file        no - leave it alone */
    bne.s nxt_file
/* QL:         move.l  d7,d5           yes - save vacant slot */
    move.l d7,d5
/* QL: nxt_file */
nxt_file:
/* QL:         move.l  fs_nblok(a0),d7 pick up current location */
    move.l fs_nblok(a0),d7
/* QL:         cmp.l   d4,d7           are we at the end? */
    cmp.l d4,d7
/* QL:         beq.s   file_new        yes - must be a new file */
    beq.s file_new
/* QL:         bsr.s   read_ent        read next directory entry */
    bsr.s read_ent
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         assert  0,md_delen */
/* original assertion: 0,md_delen */
/* QL:         tst.l   (a4)            vacant? */
    tst.l (a4)
/* QL:         beq.s   empty */
    beq.s empty
/* QL:         move.l  a6,-(sp) */
    move.l a6,-(sp)
/* QL:         lea     fs_fname,a6    base address for ut_cstr versus a0 */
    lea fs_fname,a6
/* QL:         lea     md_denam-fs_fname(a4),a1 a1 relative to a6 */
    lea (md_denam-fs_fname)(a4),a1
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         jsr     ut_cstr(pc)     compare */
    jsr ut_cstr(pc)
/* QL:         move.l  (sp)+,a6 */
    move.l (sp)+,a6
/* QL:         bne.s   nxt_file        are the names equal? */
    bne.s nxt_file
/* QL: * File found... put back pointer, so we can update if needed */
/* QL:         bsr.s   setentry        reposition file and calculate file no, d0.l=0 */
    bsr.s setentry
/* QL:         assert  0,io.old,io.share-1,io.new-2,io.overw-3 */
/* original assertion: 0,io.old,io.share-1,io.new-2,io.overw-3 */
/* QL:         move.b  fs_acces(a0),d0 get access mode */
    move.b fs_acces(a0),d0
/* QL:         subq.b  #io.new,d0 */
    subq.b #io.new,d0
/* QL:         beq.s   err_ex */
    beq.s err_ex
/* QL:         bpl.s   overw           n.b. d0.w = 1, for truncation in overwrite */
    bpl.s overw
/* QL:         bcc.s   delete          delete was $ff-2 as opposed to old/share */
    bcc.s delete
/* QL: * File found, all OK */
/* QL:         move.w  d5,fs_filnr(a0) set file number */
    move.w d5,fs_filnr(a0)
/* QL: setsize */
setsize:
/* QL:         move.l  (a4),d4         get length */
    move.l (a4),d4
/* QL:         lsl.l   #16-blkbits,d4  convert to block/byte format */
    lsl.l #(16-blkbits),d4
/* QL:         lsr.w   #16-blkbits,d4 */
    lsr.w #(16-blkbits),d4
/* QL:         assert  fs_nblok,fs_nbyte-2 */
/* original assertion: fs_nblok,fs_nbyte-2 */
/* QL:         move.l  d2,fs_nblok(a0) current file pointer */
    move.l d2,fs_nblok(a0)
/* QL:         assert  fs_eblok,fs_ebyte-2 */
/* original assertion: fs_eblok,fs_ebyte-2 */
/* QL:         move.l  d4,fs_eblok(a0) set length */
    move.l d4,fs_eblok(a0)
/* QL: ok_rts */
ok_rts:
/* QL:         moveq   #0,d0           no errors */
    moveq #0,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: err_nf */
err_nf:
/* QL:         moveq   #err.nf,d0 */
    moveq #err.nf,d0
/* QL:         rts */
    rts 
/* QL: * Reposition directory and calculate file number */
/* QL: setentry */
setentry:
/* QL:         move.l  d7,d5           make it the current entry */
    move.l d7,d5
/* QL:         move.l  d7,fs_nblok(a0) backspace the directory pointer */
    move.l d7,fs_nblok(a0)
/* QL:         lsl.w   #16-blkbits,d5  move byte up by block */
    lsl.w #(16-blkbits),d5
/* QL:         lsr.l   #16-blkbits,d5  move then both back down */
    lsr.l #(16-blkbits),d5
/* QL:         lsr.l   #entbits,d5     divide by entry size, to give file number */
    lsr.l #entbits,d5
/* QL:         bra.s   ok_rts          make sure d0 is zero */
    bra.s ok_rts
/* QL: * Read a directory entry */
/* QL: read_ent */
read_ent:
/* QL:         moveq   #io.fstrg,d0    read string */
    moveq #io.fstrg,d0
/* QL: rdwr_ent */
rdwr_ent:
/* QL:         move.l  a4,a1 */
    move.l a4,a1
/* QL:         jmp     dd_mdvrr(pc) */
    jmp dd_mdvrr(pc)
/* QL: err_ex */
err_ex:
/* QL:         moveq   #err.ex,d0 */
    moveq #err.ex,d0
/* QL:         rts */
    rts 
/* QL: * Delete an existing file */
/* QL: delete */
delete:
/* QL:         clr.w   md_denam(a4)    name is null */
    clr.w md_denam(a4)
/* QL:         clr.l   (a4)            clear length */
    clr.l (a4)
/* QL:         bsr.s   wr_ent */
    bsr.s wr_ent
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL: * Overwrite an existing file (and truncate for delete) */
/* QL: overw */
overw:
/* QL:         ; d0.w = 0 for truncation to nothing for a delete */
/* QL:         ; d0.w = 1 to leave header alone, for now, when overwriting */
/* QL:         bsr.s   dotrunc         perform the truncation */
    bsr.s dotrunc
/* QL:         moveq   #fs.hdlen,d7    overwrite is starting with 1st block retained */
    moveq #fs.hdlen,d7
/* QL:         bra.s   initit          go fill it in, if it's ovewrite */
    bra.s initit
/* QL: * File not found (or delete/overwrite has been done) */
/* QL: file_new */
file_new:
/* QL:         move.l  d5,d7           have we got a spare entry? */
    move.l d5,d7
/* QL:         bne.s   entryset        yes - use it */
    bne.s entryset
/* QL:         move.l  d4,d7           no - put it at eof */
    move.l d4,d7
/* QL: entryset */
entryset:
/* QL:         bsr.s   setentry        reposition file and calculate file number */
    bsr.s setentry
/* QL:         moveq   #0,d7           starting without any blocks in file */
    moveq #0,d7
/* QL: initit */
initit:
/* QL:         cmp.b   #io.new,fs_acces(a0) check access mode */
    cmp.b #(io.new&255),fs_acces(a0)
/* QL:         bcs.s   err_nf          old/share is no good */
    bcs.s err_nf
/* QL:         blt.s   ok_rts          delete is finished (or wasn't even found) */
    blt.s ok_rts
/* QL: * Set up file header and directory entry */
/* QL:         lea     0(a4,d2.w),a1 */
    lea 0(a4,d2.w),a1
/* QL: clearit */
clearit:
/* QL:         clr.l   -(a1)           clear out whole entry */
    clr.l -(a1)
/* QL:         cmp.l   a1,a4 */
    cmp.l a1,a4
/* QL:         bne.s   clearit */
    bne.s clearit
/* QL:         move.l  d2,(a4)         set length of file */
    move.l d2,(a4)
/* QL:         lea     md_denam(a4),a1 */
    lea md_denam(a4),a1
/* QL:         lea     fs_fname(a0),a3 */
    lea fs_fname(a0),a3
/* QL:         move.w  (a3),d0 */
    move.w (a3),d0
/* QL:         addq.w  #2-1,d0         move name and length thereof */
.word 20544|((((2-1))&7)<<9)
/* QL: move_nam */
move_nam:
/* QL:         move.b  (a3)+,(a1)+ */
    move.b (a3)+,(a1)+
/* QL:         dbra    d0,move_nam */
    dbra d0,move_nam
/* QL:         bsr.s   wr_ent          write directory entry */
    bsr.s wr_ent
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL: * Update length of directory, maybe */
/* QL:         move.l  fs_eblok(a0),d0 get end of directory */
    move.l fs_eblok(a0),d0
/* QL:         cmp.l   d4,d0           has this extended the directory */
    cmp.l d4,d0
/* QL:         beq.s   dlen_ok         no - that's ok */
    beq.s dlen_ok
/* QL:         lsl.w   #16-blkbits,d0 */
    lsl.w #(16-blkbits),d0
/* QL:         lsr.l   #16-blkbits,d0  calculate new length */
    lsr.l #(16-blkbits),d0
/* QL:         move.l  d0,(a4) */
    move.l d0,(a4)
/* QL:         moveq   #4,d2 */
    moveq #4,d2
/* QL:         bsr.s   wr_nb0          write 4 byte length to start of the directory */
    bsr.s wr_nb0
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         moveq   #fs.hdlen,d2    put back normal entry length */
    moveq #fs.hdlen,d2
/* QL:         move.l  d2,(a4)         set file length to header length again */
    move.l d2,(a4)
/* QL: dlen_ok */
dlen_ok:
/* QL:         move.w  d5,fs_filnr(a0) finally get to writing the file itself */
    move.w d5,fs_filnr(a0)
/* QL:         move.l  d7,fs_eblok(a0) overwrite held a block, rest didn't have any */
    move.l d7,fs_eblok(a0)
/* QL: wr_nb0 */
wr_nb0:
/* QL:         clr.l   fs_nblok(a0)    start at beginning of file */
    clr.l fs_nblok(a0)
/* QL: wr_ent */
wr_ent:
/* QL:         moveq   #io.sstrg,d0    send string */
    moveq #io.sstrg,d0
/* QL:         bra.s   rdwr_ent */
    bra.s rdwr_ent
/* QL: * d0 -ip - .w lowest block number to be discarded (i.e. 0 = whole file) */
/* QL: * d5 -ip - file number to truncate */
/* QL: * d6 -ip - drive id * 16 + 1<<bt..file */
/* QL: * d3/a3 destroyed */
/* QL: dotrunc */
dotrunc:
/* QL:         moveq   #256-maxsec,d3  scan through all sectors in map */
    moveq #(256-maxsec),d3
/* QL:         lea     md_map+2*maxsec(a2),a3 */
    lea (md_map+(2*maxsec))(a2),a3
/* QL: del_loop */
del_loop:
/* QL:         cmp.b   (a3),d5         is this the file to be truncated? */
    cmp.b (a3),d5
/* QL:         bne.s   del_next */
    bne.s del_next
/* QL:         cmp.b   1(a3),d0        is it a block to be discarded? */
    cmp.b 1(a3),d0
/* QL:         bhi.s   del_next        no - leave it */
    bhi.s del_next
/* QL:         move.w  #vacant<<8,(a3) set vacant */
    move.w #(vacant<<8),(a3)
/* QL:         clr.w   md_pendg-md_map(a3) clear any pending operations */
    clr.w (md_pendg-md_map)(a3)
/* QL: del_next */
del_next:
/* QL:         subq.l  #2,a3 */
    subq.l #2,a3
/* QL:         addq.b  #1,d3           next sector */
    addq.b #1,d3
/* QL:         bne.s   del_loop */
    bne.s del_loop
/* QL: * Now get rid of any slave blocks for this */
/* QL:         move.l  sv_btbas(a6),a3 get address of base of tables */
    move.l sv_btbas(a6),a3
/* QL: rem_loop */
rem_loop:
/* QL:         cmp.w   bt_filnr(a3),d5 the file number must match (1st, as it's quick) */
    cmp.w bt_filnr(a3),d5
/* QL:         bne.s   rem_next */
    bne.s rem_next
/* QL:         moveq   #-16+1<<bt..file,d3 mask out all but drive id and file flag */
    moveq #((-16)+(1<<bt..file)),d3
/* QL:         assert  0,bt_stat */
/* original assertion: 0,bt_stat */
/* QL:         and.b   (a3),d3 */
    and.b (a3),d3
/* QL:         cmp.b   d3,d6           the drive, of course, must match */
    cmp.b d3,d6
/* QL:         bne.s   rem_next */
    bne.s rem_next
/* QL:         cmp.w   bt_block(a3),d0 finally, the block must be one being discarded */
    cmp.w bt_block(a3),d0
/* QL:         bhi.s   rem_next */
    bhi.s rem_next
/* QL:         move.b  #bt.empty,(a3)  kill it */
    move.b #(bt.empty&255),(a3)
/* QL: rem_next */
rem_next:
/* QL:         addq.l  #bt_end,a3      next slave block */
    addq.l #bt_end,a3
/* QL:         cmp.l   sv_bttop(a6),a3 last ? */
    cmp.l sv_bttop(a6),a3
/* QL:         bne.s   rem_loop */
    bne.s rem_loop
/* QL:         move.w  #-1,md_pendg(a2) set write map key */
    move.w #(-1),md_pendg(a2)
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d6 -i  - drive id * 16 + 1<<bt..file */
/* QL: * a0 -ip - channel definition */
/* QL: * a2 -ip - physical definition */
/* QL: * d1-d3/a1/a3-a4 destroyed */
/* QL: dd_mdvtr */
dd_mdvtr:
/* QL:         cmp.b   #io.share,fs_acces(a0) is the file opened for writing? */
    cmp.b #(io.share&255),fs_acces(a0)
/* QL:         beq.s   err_ro */
    beq.s err_ro
/* QL:         move.w  fs_filnr(a0),d5 pick up file number */
    move.w fs_filnr(a0),d5
/* QL:         move.l  fs_nblok(a0),d0 + nbyte get current position */
    move.l fs_nblok(a0),d0
/* QL:         move.l  d0,fs_eblok(a0) + ebyte stuff it into the end position */
    move.l d0,fs_eblok(a0)
/* QL:         subq.l  #1,d0           if byte number is zero, decrement block number */
    subq.l #1,d0
/* QL:         swap    d0 */
    swap d0
/* QL:         addq.w  #2,d0           discard all blocks >= d0.w */
    addq.w #2,d0
/* QL:         st      fs_updt(a0)     show file updated */
    st fs_updt(a0)
/* QL:         bsr.s   dotrunc         get rid of map entries and slave blocks */
    bsr.s dotrunc
/* QL:         jmp     dd_mdvlu(pc)    will set d0=0 for us */
    jmp dd_mdvlu(pc)
/* QL: err_ro */
err_ro:
/* QL:         moveq   #err.ro,d0 */
    moveq #err.ro,d0
/* QL:         rts */
    rts 
/* QL:         end */
