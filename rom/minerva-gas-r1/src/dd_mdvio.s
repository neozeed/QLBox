/* Generated from original/M/dd/mdvio.asm */
/* QL: * Microdrive io operations */
/* QL:         xdef    dd_mdvio,dd_mdvpd,dd_mdvrr */
.globl dd_mdvio,dd_mdvpd,dd_mdvrr
/* QL:         xref    dd_mdvbu,dd_mdvlu,dd_mdvrn,dd_mdvsc,dd_mdvtr */
/* QL:         xref    md_slave */
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
/* QL: vacant  equ     $fd */
.equ vacant,0xfd
/* QL: maxsec  equ     255 */
.equ maxsec,255
/* QL:         section dd_mdvio */
.section dd_mdvio,"ax"
/* QL: * d0 -i o- operation / error return */
/* QL: * d1 -i o- i/o byte */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i o- read/write buffer */
/* QL: * a2 -  o- physical definition */
/* QL: * d3/a3 destroyed */
/* QL: * A routine version of mdvio for mdvop and mdvcl */
/* QL: dd_mdvrr */
dd_mdvrr:
/* QL:         movem.l d0/d2/d4-d7/a4-a5,-(sp) */
    movem.l d0/d2/d4-d7/a4-a5,-(sp)
/* QL: mdvrr */
mdvrr:
/* QL:         movem.l (sp),d0/d2      restore call parameters */
    movem.l (sp),d0/d2
/* QL:         moveq   #0,d3           treat all calls as initial entry */
    moveq #0,d3
/* QL:         bsr.s   dd_mdvio */
    bsr.s dd_mdvio
/* QL:         addq.l  #-err.nc,d0     if err.nc do again */
.word 20608|((((-err.nc))&7)<<9)
/* QL:         beq.s   mdvrr */
    beq.s mdvrr
/* QL:         subq.l  #-err.nc,d0 */
.word 20864|((((-err.nc))&7)<<9)
/* QL:         addq.l  #4,sp           discard saved op */
    addq.l #4,sp
/* QL:         movem.l (sp)+,d2/d4-d7/a4-a5 */
    movem.l (sp)+,d2/d4-d7/a4-a5
/* QL:         rts */
    rts 
/* QL: fetch */
fetch:
/* QL:         moveq   #0,d3           assume pending */
    moveq #0,d3
/* QL:         addq.b  #io.edlin,d0 */
    addq.b #io.edlin,d0
/* QL:         beq.s   byte */
    beq.s byte
/* QL:         move.w  #1<<8,d3        assume read (normal) */
    move.w #(1<<8),d3
/* QL:         subq.b  #io.fline,d0 */
    subq.b #io.fline,d0
/* QL:         bne.s   byte_str */
    bne.s byte_str
/* QL:         moveq   #10,d3          read to newline */
    moveq #10,d3
/* QL: str */
str:
/* QL:         add.l   a1,d7           find original start of buffer */
    add.l a1,d7
/* QL:         move.l  d7,-(sp)        and save it */
    move.l d7,-(sp)
/* QL:         add.l   d2,d7           find original end of buffer */
    add.l d2,d7
/* QL:         jsr     dd_mdvbu(pc) */
    jsr dd_mdvbu(pc)
/* QL:         move.l  a1,d1           end address of part done */
    move.l a1,d1
/* QL:         sub.l   (sp)+,d1        total bytes so far transfered */
    sub.l (sp)+,d1
/* QL:         rts */
    rts 
/* QL: err_ro */
err_ro:
/* QL:         moveq   #err.ro,d0      write on read only device */
    moveq #err.ro,d0
/* QL:         rts */
    rts 
/* QL: go_ser */
go_ser:
/* QL:         moveq   #0,d7           initialise end pointer */
    moveq #0,d7
/* QL:         tst.l   d3              is it reentry? */
    tst.l d3
/* QL:         beq.s   ser_op */
    beq.s ser_op
/* QL:         sub.l   d1,d7           yes - some bytes have already been moved */
    sub.l d1,d7
/* QL: ser_op */
ser_op:
/* QL:         addq.b  #io.sstrg-io.edlin,d0 check operation */
.word 20480|((((io.sstrg-io.edlin))&7)<<9)
/* QL:         beq.s   err_bp */
    beq.s err_bp
/* QL:         bmi.s   fetch */
    bmi.s fetch
/* QL:         cmp.b   #io.share,fs_acces(a0) is write permitted? */
    cmp.b #(io.share&255),fs_acces(a0)
/* QL:         beq.s   err_ro */
    beq.s err_ro
/* QL:         moveq   #-1,d3          a write operation */
    moveq #(-1),d3
/* QL:         subq.b  #io.sbyte+1-io.edlin,d0 which type of write? */
.word 20736|(((((io.sbyte+1)-io.edlin))&7)<<9)
/* QL:         beq.s   err_bp */
    beq.s err_bp
/* QL: byte_str */
byte_str:
/* QL:         bcc.s   str */
    bcc.s str
/* QL: byte */
byte:
/* QL:         move.l  sp,d7           pointer to end of buffer on stack */
    move.l sp,d7
/* QL:         move.l  d1,-(sp)        put whole of d1 onto stack */
    move.l d1,-(sp)
/* QL:         lea     3(sp),a1        and point to the lsb */
    lea 3(sp),a1
/* QL:         jsr     dd_mdvbu(pc) */
    jsr dd_mdvbu(pc)
/* QL:         move.l  (sp)+,d1        replace only lsb of d1 with result */
    move.l (sp)+,d1
/* QL:         rts */
    rts 
/* QL: * d6 -  o- drive id * 16 + 1<<bt.file, ready for slave block stuff */
/* QL: * a0 -ip - channel definition */
/* QL: * a2 -  o- physical definition */
/* QL: dd_mdvpd */
dd_mdvpd:
/* QL:         moveq   #0,d6           get drive id */
    moveq #0,d6
/* QL:         move.b  fs_drive(a0),d6 */
    move.b fs_drive(a0),d6
/* QL:         lsl.b   #2,d6           make an address */
    lsl.b #2,d6
/* QL:         lea     sv_fsdef(a6),a2 get pointer to physical definition */
    lea sv_fsdef(a6),a2
/* QL:         move.l  0(a2,d6.w),a2 */
    move.l 0(a2,d6.w),a2
/* QL:         lsl.b   #4-2,d6         into bits 7-4 ready for slave blocks */
    lsl.b #(4-2),d6
/* QL:         addq.l  #1<<bt..file,d6 and set file bit */
    addq.l #(1<<bt..file),d6
/* QL:         rts */
    rts 
/* QL: * Driver entry point for input/output */
/* QL: * d0 -i o- operation / error return */
/* QL: * d1 -i o- bytes transferred so far or i/o byte */
/* QL: * d2 -i  - buffer maximum length */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i o- read/write buffer */
/* QL: * a2 -  o- physical definition */
/* QL: * d4-d7/a3-a5 destroyed */
/* QL: dd_mdvio */
dd_mdvio:
/* QL:         bsr.s   dd_mdvpd        get id and address of physical definition */
    bsr.s dd_mdvpd
/* QL: * Sort out operation */
/* QL:         cmp.b   #fs.check,d0    check if it is a file operation */
    cmp.b #(fs.check&255),d0
/* QL:         bcc.s   fileio */
    bcc.s fileio
/* QL:         ext.l   d1              normal io calls use word counters only */
    ext.l d1
/* QL:         ext.l   d2 */
    ext.l d2
/* QL: serio */
serio:
/* QL:         subq.b  #io.sstrg,d0    is operation in range? */
    subq.b #io.sstrg,d0
/* QL:         bls.s   go_ser          yes - putter on up above */
    bls.s go_ser
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: fileio */
fileio:
/* QL:         cmp.b   #fs.check+fop_top-fop_tab-1,d0 is it out of range? */
    cmp.b #((((fs.check+fop_top)-fop_tab)-1)&255),d0
/* QL:         bhi.s   err_bp */
    bhi.s err_bp
/* QL:         move.b  fop_tab-fs.check(pc,d0.w),d0 branch to file operation */
    move.b (fop_tab-fs.check)(pc,d0.w),d0
/* QL:         add.w   d0,d0 */
    add.w d0,d0
/* QL:         jmp     fop_jmp(pc,d0.w) */
.word 0x4efb
.word 0|((fop_jmp-.)&255)
/* QL: fop_jmp */
fop_jmp:
/* QL: load */
load:
/* QL: * N.B. This is a bit wierd, to say the least! */
/* QL: * If the length requested is less than 4096, the current file position is used, */
/* QL: * d2 bytes are read from there and the buffer address can be odd. */
/* QL: * However, if the length is greater than or equal to 4096, the scatter load */
/* QL: * totally ignores the current file postion and d2 then reads the whole file. */
/* QL: * The latter even used to crash if the buffer address was odd. */
/* QL:         moveq   #io.fstrg,d0    load is fetch string */
    moveq #io.fstrg,d0
/* QL:         cmp.l   #4096,d2        is file not very huge? */
    cmp.l #4096,d2
/* QL:         blt.s   serio           ... yes - serial load */
    blt.s serio
/* QL:         move.w  a1,d4 */
    move.w a1,d4
/* QL:         asr.b   #1,d4 */
    asr.b #1,d4
/* QL:         bcs.s   serio           serial if address is odd (lwr) */
    bcs.s serio
/* QL:         bsr.s   flush           ensure all blocks are on medium */
    bsr.s flush
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         jmp     dd_mdvsc(pc)    load is scatter */
    jmp dd_mdvsc(pc)
/* QL: save */
save:
/* QL:         moveq   #io.sstrg,d0    save is send string */
    moveq #io.sstrg,d0
/* QL:         bra.s   serio */
    bra.s serio
/* QL: * Read and set header calls are assumed to complete in one operation */
/* QL: * as the header is all in one block */
/* QL: heads */
heads:
/* QL:         moveq   #io.sstrg,d0 to set header - send string */
    moveq #io.sstrg,d0
/* QL:         moveq   #md_denam,d2    of 14 bytes (up to, not including, name length) */
    moveq #md_denam,d2
/* QL: head */
head:
/* QL:         assert  fs_nblok,fs_nbyte-2 */
/* original assertion: fs_nblok,fs_nbyte-2 */
/* QL:         clr.l   fs_nblok(a0)    read from / write to 0 */
    clr.l fs_nblok(a0)
/* QL:         bsr.s   serio           serially */
    bsr.s serio
/* QL:         moveq   #fs.hdlen,d4 */
    moveq #fs.hdlen,d4
/* QL:         move.w  d4,fs_nbyte(a0) reset pointer to start of file */
    move.w d4,fs_nbyte(a0)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: headr */
headr:
/* QL:         moveq   #io.fstrg,d0    to read header - read string (no length limit!) */
    moveq #io.fstrg,d0
/* QL:         move.l  a1,-(sp)        save header pointer */
    move.l a1,-(sp)
/* QL:         bsr.s   head */
    bsr.s head
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL:         sub.l   d4,(a2)         (N.B. caller buffer must be even addr!!!) */
    sub.l d4,(a2)
/* QL:         rts */
    rts 
/* QL: test_bof */
test_bof:
/* QL:         sub.l   d2,d1           take away header length */
    sub.l d2,d1
/* QL:         bge.s   set_nblk */
    bge.s set_nblk
/* QL: set_bof */
set_bof:
/* QL:         moveq   #0,d1           show caller new position */
    moveq #0,d1
/* QL:         move.l  d2,d0           reset to beginning of file */
    move.l d2,d0
/* QL: set_nblk */
set_nblk:
/* QL:         move.l  d0,fs_nblok(a0) */
    move.l d0,fs_nblok(a0)
/* QL: set_iop */
set_iop:
/* QL:         moveq   #io.pend,d0 */
    moveq #io.pend,d0
/* QL:         bra.s   serio */
    bra.s serio
/* QL: posab */
posab:
/* QL:         moveq   #fs.hdlen,d2    get length of header */
    moveq #fs.hdlen,d2
/* QL:         add.l   d2,d1           set actual file pointer */
    add.l d2,d1
/* QL: test_ovf */
test_ovf:
/* QL:         bvc.s   test_eof        ok if it didn't overflow */
    bvc.s test_eof
/* QL:         roxr.l  #1,d1           otherwise this'll set an extreme value */
    roxr.l #1,d1
/* QL: test_eof */
test_eof:
/* QL:         move.l  d1,d0           preserve address */
    move.l d1,d0
/* QL:         bmi.s   set_bof         negative then force to bottom */
    bmi.s set_bof
/* QL:         asl.l   #6,d0           and put new byte address in appropriate form */
    asl.l #6,d0
/* QL:         bvs.s   set_eof         if huge, set eof */
    bvs.s set_eof
/* QL:         add.l   d0,d0 */
    add.l d0,d0
/* QL:         lsr.w   #7,d0 */
    lsr.w #7,d0
/* QL:         cmp.l   fs_eblok(a0),d0 is it beyond end of file? */
    cmp.l fs_eblok(a0),d0
/* QL:         bls.s   test_bof */
    bls.s test_bof
/* QL: set_eof */
set_eof:
/* QL:         assert  fs_eblok,fs_ebyte-2 */
/* original assertion: fs_eblok,fs_ebyte-2 */
/* QL:         move.l  fs_eblok(a0),d0 yes - set pointer to end of file */
    move.l fs_eblok(a0),d0
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         bra.s   con_byte */
    bra.s con_byte
/* QL: posre */
posre:
/* QL:         tst.l   d3              do not move pointer if it is re-entry */
    tst.l d3
/* QL:         bne.s   set_iop */
    bne.s set_iop
/* QL:         moveq   #fs.hdlen,d2    get length of header */
    moveq #fs.hdlen,d2
/* QL:         assert  fs_nblok,fs_nbyte-2 */
/* original assertion: fs_nblok,fs_nbyte-2 */
/* QL:         move.l  fs_nblok(a0),d0 get current pointer */
    move.l fs_nblok(a0),d0
/* QL: con_byte */
con_byte:
/* QL:         lsl.w   #7,d0           ... in byte address form */
    lsl.w #7,d0
/* QL:         lsr.l   #7,d0 */
    lsr.l #7,d0
/* QL:         add.l   d0,d1           add it to adjustment */
    add.l d0,d1
/* QL:         bra.s   test_ovf */
    bra.s test_ovf
/* QL: fop_tab */
fop_tab:
/* QL:         dc.b    (check-fop_jmp)/2 */
dc_anchor_811:
.byte (((check-fop_jmp)/2))&255
/* QL:         dc.b    (flush-fop_jmp)/2 */
dc_anchor_814:
.byte (((flush-fop_jmp)/2))&255
/* QL:         dc.b    (posab-fop_jmp)/2 */
dc_anchor_817:
.byte (((posab-fop_jmp)/2))&255
/* QL:         dc.b    (posre-fop_jmp)/2 */
dc_anchor_820:
.byte (((posre-fop_jmp)/2))&255
/* QL:         dc.b    (err_bp-fop_jmp)/2 */
dc_anchor_823:
.byte (((err_bp-fop_jmp)/2))&255
/* QL:         dc.b    (mdinf-fop_jmp)/2 */
dc_anchor_826:
.byte (((mdinf-fop_jmp)/2))&255
/* QL:         dc.b    (heads-fop_jmp)/2 */
dc_anchor_829:
.byte (((heads-fop_jmp)/2))&255
/* QL:         dc.b    (headr-fop_jmp)/2 */
dc_anchor_832:
.byte (((headr-fop_jmp)/2))&255
/* QL:         dc.b    (load-fop_jmp)/2 */
dc_anchor_835:
.byte (((load-fop_jmp)/2))&255
/* QL:         dc.b    (save-fop_jmp)/2 */
dc_anchor_838:
.byte (((save-fop_jmp)/2))&255
/* QL:         dc.b    (renam-fop_jmp)/2 */
dc_anchor_841:
.byte (((renam-fop_jmp)/2))&255
/* QL:         dc.b    (trunc-fop_jmp)/2 */
dc_anchor_844:
.byte (((trunc-fop_jmp)/2))&255
/* QL: fop_top */
fop_top:
/* QL:         ds.w    0 */
.balign 2,0
/* QL: check */
check:
/* QL:         moveq   #bt.true,d4     check all blocks are true copies */
    moveq #bt.true,d4
/* QL:         moveq   #-1,d5          nc if not true */
    moveq #(-1),d5
/* QL:         bra.s   cf_com */
    bra.s cf_com
/* QL: flush */
flush:
/* QL:         moveq   #bt.actn,d4     check if any action pending */
    moveq #bt.actn,d4
/* QL:         moveq   #0,d5           nc if true */
    moveq #0,d5
/* QL: cf_com */
cf_com:
/* QL:         jsr     dd_mdvlu(pc)    make sure length and update are set */
    jsr dd_mdvlu(pc)
/* QL:         bne.s   rts1            ouch - it didn't work */
    bne.s rts1
/* QL:         move.w  fs_filnr(a0),d2 get file number */
    move.w fs_filnr(a0),d2
/* QL:         move.l  sv_bttop(a6),a4 scan through slave blocks */
    move.l sv_bttop(a6),a4
/* QL: cf_loop */
cf_loop:
/* QL:         cmp.l   sv_btbas(a6),a4 done bottom yet? */
    cmp.l sv_btbas(a6),a4
/* QL:         beq.s   rts1 */
    beq.s rts1
/* QL:         subq.l  #bt_end,a4      next block */
    subq.l #bt_end,a4
/* QL:         moveq   #-16+1<<bt..file,d3 check drive number, file block bit */
    moveq #((-16)+(1<<bt..file)),d3
/* QL:         assert  0,bt_stat */
/* original assertion: 0,bt_stat */
/* QL:         and.b   (a4),d3 */
    and.b (a4),d3
/* QL:         cmp.b   d6,d3 */
    cmp.b d6,d3
/* QL:         bne.s   cf_loop         not the right drive */
    bne.s cf_loop
/* QL:         cmp.w   bt_filnr(a4),d2 */
    cmp.w bt_filnr(a4),d2
/* QL:         bne.s   cf_loop         not the right file */
    bne.s cf_loop
/* QL:         move.b  (a4),d0         check the status bits (the right way round) */
    move.b (a4),d0
/* QL:         eor.b   d5,d0 */
    eor.b d5,d0
/* QL:         and.b   d4,d0 */
    and.b d4,d0
/* QL:         beq.s   cf_loop */
    beq.s cf_loop
/* QL:         jmp     md_slave(pc)    sets d0=err.nc for us */
    jmp md_slave(pc)
/* QL: renam */
renam:
/* QL:         jmp     dd_mdvrn(pc) */
    jmp dd_mdvrn(pc)
/* QL: trunc */
trunc:
/* QL:         jmp     dd_mdvtr(pc) */
    jmp dd_mdvtr(pc)
/* QL: mdinf */
mdinf:
/* QL:         lea     md_mname(a2),a3 copy name (nb user buffer may now be odd! lwr) */
    lea md_mname(a2),a3
/* QL:         moveq   #10,d1 */
    moveq #10,d1
/* QL: copyinf */
copyinf:
/* QL:         move.b  (a3)+,(a1)+ */
    move.b (a3)+,(a1)+
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         bne.s   copyinf */
    bne.s copyinf
/* QL:         move.w  #maxsec*2-2,d0  search for good (and vacant sectors) */
    move.w #((maxsec*2)-2),d0
/* QL:         moveq   #1,d2           include sector 0 in good count */
    moveq #1,d2
/* QL: inf_loop */
inf_loop:
/* QL:         cmp.b   #vacant,md_map(a2,d0.w) is it vacant? */
    cmp.b #(vacant&255),md_map(a2,d0.w)
/* QL:         bhi.s   inf_next        bad */
    bhi.s inf_next
/* QL:         bne.s   inf_good        in use */
    bne.s inf_good
/* QL:         addq.w  #1,d1           vacant */
    addq.w #1,d1
/* QL: inf_good */
inf_good:
/* QL:         addq.w  #1,d2           good */
    addq.w #1,d2
/* QL: inf_next */
inf_next:
/* QL:         subq.w  #2,d0           take next sector */
    subq.w #2,d0
/* QL:         bne.s   inf_loop        (N.B. d0.l = 0 at end) */
    bne.s inf_loop
/* QL:         swap    d1              put both the return args in d1 */
    swap d1
/* QL:         move.w  d2,d1 */
    move.w d2,d1
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL:         end */
