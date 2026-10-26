/* Generated from original/M/dd/mdvbu.asm */
/* QL: * Microdrive slave block buffering operations */
/* QL:         xdef    dd_mdvbu,dd_mdvnb */
.globl dd_mdvbu,dd_mdvnb
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
/* QL: badsec  equ     $ff */
.equ badsec,0xff
/* QL: maxsec  equ     255 */
.equ maxsec,255
/* QL: blkbits equ     9 */
.equ blkbits,9
/* QL: btbits  equ     3 */
.equ btbits,3
/* QL:         assert  1<<btbits,bt_end */
/* original assertion: 1<<btbits,bt_end */
/* QL:         section dd_mdvbu */
.section dd_mdvbu,"ax"
/* QL: * d0 -  o- error return */
/* QL: * d3 -ip - action -ve send, 0 check, +ve fetch (10 = fetch line) */
/* QL: * d6 -ip - drive id * 16 + 1<<bt..file */
/* QL: * d7 -i o- end of buffer (reduced by fline when terminator found) */
/* QL: * a0 -ip - pointer to channel definition */
/* QL: * a1 -i  - pointer to read/write buffer */
/* QL: * a2 -ip - pointer to physical definition */
/* QL: * d1-d2/d4-d5/a3-a5 destroyed */
/* QL: * Byte buffer/unbuffer code */
/* QL: dd_mdvbu */
dd_mdvbu:
/* QL:         tst.b   md_estat(a2)    is it ok? */
    tst.b md_estat(a2)
/* QL:         bmi     err_fe */
    bmi err_fe
/* QL:         assert  fs_filnr,fs_nblok-2 */
/* original assertion: fs_filnr,fs_nblok-2 */
/* QL:         move.l  fs_filnr(a0),d5 fetch file number/block number reqd */
    move.l fs_filnr(a0),d5
/* QL:         assert  fs_nblok,fs_nbyte-2 */
/* original assertion: fs_nblok,fs_nbyte-2 */
/* QL:         move.l  fs_nblok(a0),d4 fetch block number/byte number */
    move.l fs_nblok(a0),d4
/* QL:         assert  fs_eblok,fs_ebyte-2 */
/* original assertion: fs_eblok,fs_ebyte-2 */
/* QL:         cmp.l   fs_eblok(a0),d4 compare against end of file */
    cmp.l fs_eblok(a0),d4
/* QL:         bcs.s   set_bk          not there yet, so all is ok */
    bcs.s set_bk
/* QL:         bne.s   err_ef          grim if the pointer is beyond end */
    bne.s err_ef
/* QL:         tst.b   d3              is operation a write? */
    tst.b d3
/* QL:         bpl.s   err_ef          no - can't extend the file with a test/read! */
    bpl.s err_ef
/* QL:         tst.w   d4              is this new byte in a new block */
    tst.w d4
/* QL:         bne.s   set_bk          no - just go pick up the block */
    bne.s set_bk
/* QL:         cmp.l   a1,d7           is there actually anything to go in block? */
    cmp.l a1,d7
/* QL:         ble     ok_rts          no so exit */
    ble ok_rts
/* QL:         bsr     dd_mdvnb        find space for a new block */
    bsr dd_mdvnb
/* QL:         bsr     new_sect        find new sector */
    bsr new_sect
/* QL:         move.w  d0,bt_sectr(a4) set sector number */
    move.w d0,bt_sectr(a4)
/* QL:         addq.b  #1<<bt..accs,(a4) and say it is a true buffer */
    addq.b #(1<<bt..accs),(a4)
/* QL:         bra.s   bk_found */
    bra.s bk_found
/* QL: err_ef */
err_ef:
/* QL:         moveq   #err.ef,d0      end of file */
    moveq #err.ef,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: set_bk */
set_bk:
/* QL:         bsr     bk_find         get the block for this sector */
    bsr bk_find
/* QL:         bne.s   rts0            ... if block not there - give up */
    bne.s rts0
/* QL:         tst.w   d4              is it the first byte in a block? */
    tst.w d4
/* QL:         bne.s   bk_found        no - do not go through all that prefetch */
    bne.s bk_found
/* QL:         addq.w  #1,d5           find the block for the next */
    addq.w #1,d5
/* QL:         moveq   #0,d2           and set up the block/byte address of next */
    moveq #0,d2
/* QL:         move.w  d5,d2 */
    move.w d5,d2
/* QL:         swap    d2 */
    swap d2
/* QL:         move.l  a4,-(sp)        save the block pointer */
    move.l a4,-(sp)
/* QL:         cmp.l   fs_eblok(a0),d2 at end of file? */
    cmp.l fs_eblok(a0),d2
/* QL:         bcc.s   rst_pref        yes - do not prefetch */
    bcc.s rst_pref
/* QL:         bsr     bk_find1 */
    bsr bk_find1
/* QL: rst_pref */
rst_pref:
/* QL:         move.l  (sp)+,a4        restore the block pointer */
    move.l (sp)+,a4
/* QL:         subq.w  #1,d5           restore the block number */
    subq.w #1,d5
/* QL: bk_found */
bk_found:
/* QL:         move.l  a4,fs_cblok(a0) save pointer to this slave block */
    move.l a4,fs_cblok(a0)
/* QL:         btst    #bt..accs,(a4)  check contents of slave block */
    btst #bt..accs,(a4)
/* QL:         beq     err_ncs         not accessable, so slave to make it proper */
    beq err_ncs
/* QL:         move.l  a4,d0           calculate address of next byte */
    move.l a4,d0
/* QL:         sub.l   sv_btbas(a6),d0 table pointer - base address of table */
    sub.l sv_btbas(a6),d0
/* QL:         lsl.l   #blkbits-btbits,d0 */
    lsl.l #(blkbits-btbits),d0
/* QL:         move.l  d0,a5 */
    move.l d0,a5
/* QL:         add.l   a6,a5           plus base of memory */
    add.l a6,a5
/* QL:         add.w   d4,a5           plus byte pointer */
    add.w d4,a5
/* QL:         tst.w   d3              what operation are we doing */
    tst.w d3
/* QL:         beq.s   ok_rts          just a check, so we're done */
    beq.s ok_rts
/* QL:         bmi.s   put_byts        negative is a send */
    bmi.s put_byts
/* QL:         moveq   #0,d0           clear top byte of d0.w for fetch terminator */
    moveq #0,d0
/* QL: get_loop */
get_loop:
/* QL:         cmp.l   a1,d7           end of string? */
    cmp.l a1,d7
/* QL:         ble.s   com_exit        yes - go finish off */
    ble.s com_exit
/* QL:         cmp.l   fs_eblok(a0),d4 are we now at end of file? */
    cmp.l fs_eblok(a0),d4
/* QL:         beq.s   exit_eof */
    beq.s exit_eof
/* QL:         move.b  (a5)+,d0        get a byte from the buffer */
    move.b (a5)+,d0
/* QL:         move.b  d0,(a1)+        and save it */
    move.b d0,(a1)+
/* QL:         cmp.w   d0,d3           is it the terminating character? */
    cmp.w d0,d3
/* QL:         beq.s   termin          yes - go sort it */
    beq.s termin
/* QL:         bsr.s   move_ptr        update the pointers */
    bsr.s move_ptr
/* QL:         bne.s   get_loop        if buffer not emptied - carry on */
    bne.s get_loop
/* QL:         bra.s   com_exit        otherwise, go finish up this transfer */
    bra.s com_exit
/* QL: exit_eof */
exit_eof:
/* QL:         moveq   #err.ef,d0      end of file */
    moveq #err.ef,d0
/* QL: set_ptr */
set_ptr:
/* QL:         move.l  d4,fs_nblok(a0) set current block / byte pointer */
    move.l d4,fs_nblok(a0)
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: put_byts */
put_byts:
/* QL:         cmp.l   a1,d7           end of string? */
    cmp.l a1,d7
/* QL:         ble.s   put_exit */
    ble.s put_exit
/* QL:         move.b  (a1)+,(a5)+     put a byte in the buffer */
    move.b (a1)+,(a5)+
/* QL:         bsr.s   move_ptr        ... and update the pointers */
    bsr.s move_ptr
/* QL:         bne.s   put_byts        if buffer not full - continue */
    bne.s put_byts
/* QL:         jsr     md_slave(pc)    buffer full - slave it */
    jsr md_slave(pc)
/* QL: put_exit */
put_exit:
/* QL:         st      fs_updt(a0)     mark file updated */
    st fs_updt(a0)
/* QL:         move.b  d6,(a4)         set drive id and file bit */
    move.b d6,(a4)
/* QL:         addq.b  #bt.updt-1<<bt..file,(a4) and mark record updated */
    addq.b #(bt.updt-(1<<bt..file)),(a4)
/* QL:         bsr.s   set_pend        set pending op to write */
    bsr.s set_pend
/* QL:         cmp.l   fs_eblok(a0),d4 is this a new end of file? */
    cmp.l fs_eblok(a0),d4
/* QL:         bcs.s   com_exit */
    bcs.s com_exit
/* QL:         move.l  d4,fs_eblok(a0) ... yes - update eof */
    move.l d4,fs_eblok(a0)
/* QL: com_exit */
com_exit:
/* QL:         bsr.s   set_ptr         store current position */
    bsr.s set_ptr
/* QL:         cmp.l   a1,d7           are there any more bytes to transfer? */
    cmp.l a1,d7
/* QL:         bne     dd_mdvbu        ... yes - go back to the start */
    bne dd_mdvbu
/* QL:         cmp.w   #256,d3         were we looking for a terminator? */
    cmp.w #256,d3
/* QL:         bcc.s   ok_rts          no - fine */
    bcc.s ok_rts
/* QL:         moveq   #err.bo,d0      at end of caller's buffer with no terminator */
    moveq #err.bo,d0
/* QL:         rts */
    rts 
/* QL: termin */
termin:
/* QL:         bsr.s   move_ptr        update the pointers for terminator */
    bsr.s move_ptr
/* QL:         bsr.s   set_ptr         store current position */
    bsr.s set_ptr
/* QL:         move.l  a1,d7           set end pointer */
    move.l a1,d7
/* QL: ok_rts */
ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: move_ptr */
move_ptr:
/* QL:         addq.w  #1,d4           add 1 to byte pointer */
    addq.w #1,d4
/* QL:         btst    #blkbits,d4     is it off end of block */
    btst #blkbits,d4
/* QL:         beq.s   exit_ptr        ... no */
    beq.s exit_ptr
/* QL:         addq.w  #1,d5           add 1 to block */
    addq.w #1,d5
/* QL:         add.l   #1<<16-1<<blkbits,d4 add 1 to block, take block size off byte */
    add.l #((1<<16)-(1<<blkbits)),d4
/* QL: exit_ptr */
exit_ptr:
/* QL:         tst.w   d4              set status to z if new block required */
    tst.w d4
/* QL:         rts */
    rts 
/* QL: * Routine to initiate slaving */
/* QL: set_pend */
set_pend:
/* QL:         move.l  a4,d1           set slave block number */
    move.l a4,d1
/* QL:         sub.l   sv_btbas(a6),d1 */
    sub.l sv_btbas(a6),d1
/* QL:         lsr.l   #btbits,d1 */
    lsr.l #btbits,d1
/* QL:         add.w   bt_sectr(a4),a2 set up pending operation */
    add.w bt_sectr(a4),a2
/* QL:         move.w  d1,md_pendg(a2) */
    move.w d1,md_pendg(a2)
/* QL:         sub.w   bt_sectr(a4),a2 restore physical address */
    sub.w bt_sectr(a4),a2
/* QL:         sf      md_fail(a2)     clear fail flag */
    sf md_fail(a2)
/* QL:         rts */
    rts 
/* QL: * Routine to find the slave block for a sector */
/* QL: * d0 -  o- err.nc if not found (block fetching may have been started)  */
/* QL: * d5 -ip - file (msw) and block (lsw) */
/* QL: * d6 -ip - physdef drive id * 16 + 1<<bt..file (lsb) */
/* QL: * a4 -  o- bt pointer */
/* QL: * a3/a5 destroyed, also d1/d2 if err return */
/* QL: bk_find */
bk_find:
/* QL:         move.l  fs_cblok(a0),a4 get pointer to current block */
    move.l fs_cblok(a0),a4
/* QL:         move.l  a4,d0           is it set? */
    move.l a4,d0
/* QL:         bne.s   bk_find1        yes - start here */
    bne.s bk_find1
/* QL:         move.l  sv_btbas(a6),a4 start at base of tables */
    move.l sv_btbas(a6),a4
/* QL: bk_find1 */
bk_find1:
/* QL:         move.l  sv_bttop(a6),a5 first marker is top of table */
    move.l sv_bttop(a6),a5
/* QL: bk_markr */
bk_markr:
/* QL:         move.l  a4,a3           keep copy of start */
    move.l a4,a3
/* QL: bk_check */
bk_check:
/* QL:         cmp.l   bt_filnr(a4),d5 is it the right file/block */
    cmp.l bt_filnr(a4),d5
/* QL:         bne.s   bk_next         ... no */
    bne.s bk_next
/* QL:         moveq   #-16+1<<bt..file,d0 set mask of drive id and file bit */
    moveq #((-16)+(1<<bt..file)),d0
/* QL:         and.b   (a4),d0         get drive id and file bit */
    and.b (a4),d0
/* QL:         cmp.b   d0,d6           is it the right drive */
    cmp.b d0,d6
/* QL:         bne.s   bk_next         ... no */
    bne.s bk_next
/* QL:         cmp.b   (a4),d6         check if this block is in use */
    cmp.b (a4),d6
/* QL:         bne.s   ok_rts          yes - this is what we want */
    bne.s ok_rts
/* QL: bk_next */
bk_next:
/* QL:         addq.l  #bt_end,a4      move to next entry in slave block tables */
    addq.l #bt_end,a4
/* QL:         cmp.l   a5,a4           have we hit a marker? */
    cmp.l a5,a4
/* QL:         bne.s   bk_check        no - look at next entry */
    bne.s bk_check
/* QL:         move.l  a3,a5           set the marker to where started this pass */
    move.l a3,a5
/* QL:         move.l  sv_btbas(a6),a4 restart at bottom of table */
    move.l sv_btbas(a6),a4
/* QL:         cmp.l   a3,a4           is that where we started? */
    cmp.l a3,a4
/* QL:         bne.s   bk_markr        no, so carry on with bottom section of table */
    bne.s bk_markr
/* QL: * Sector is not in slave blocks */
/* QL:         bsr     fnd_sect        ... find the sector + allocate a new block */
    bsr fnd_sect
/* QL:         move.w  d0,bt_sectr(a4) ... set the sector number */
    move.w d0,bt_sectr(a4)
/* QL:         addq.b  #1<<bt..rdvr,(a4) tell md to read it */
    addq.b #(1<<bt..rdvr),(a4)
/* QL:         bsr.s   set_pend        set pending */
    bsr.s set_pend
/* QL: err_ncs */
err_ncs:
/* QL:         jmp     md_slave(pc)    sets d0=err.nc */
    jmp md_slave(pc)
/* QL: * Routine to allocate a new sector */
/* QL: intrlace equ    12 */
.equ intrlace,12
/* QL: run_down equ    8 */
.equ run_down,8
/* QL: new_sect */
new_sect:
/* QL:         bsr.s   ini_fsec        get file nr/block nr in d2.w */
    bsr.s ini_fsec
/* QL:         subq.b  #1,d2           find previous block */
    subq.b #1,d2
/* QL:         bcc.s   look_fil        was it allocate first block? */
    bcc.s look_fil
/* QL:         moveq   #-2*(intrlace+run_down),d0 set start position for search */
    moveq #((-2)*(intrlace+run_down)),d0
/* QL:         add.w   md_lsect(a2),d0 last sector allocated - interlace etc. */
    add.w md_lsect(a2),d0
/* QL:         bra.s   look_nsec */
    bra.s look_nsec
/* QL: look_fil */
look_fil:
/* QL:         bsr.s   look_sec        look for sector */
    bsr.s look_sec
/* QL: * Now look for next suitable blank hole */
/* QL: look_nsec */
look_nsec:
/* QL:         sub.w   #2*intrlace,d0  leave some blank sectors */
    sub.w #(2*intrlace),d0
/* QL:         bge.s   look_fd         if a sector in file look for fd */
    bge.s look_fd
/* QL: * The we have got to the lowest sector - so find the highest */
/* QL:         move.w  #maxsec*2,d1    look from top but one sector */
    move.w #(maxsec*2),d1
/* QL: look_top */
look_top:
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         cmp.b   #badsec,md_map(a2,d1.w) is this totally bad? */
    cmp.b #(badsec&255),md_map(a2,d1.w)
/* QL:         beq.s   look_top */
    beq.s look_top
/* QL:         add.w   d1,d0           set next sector to search */
    add.w d1,d0
/* QL: * Look for empty sector */
/* QL: look_fd */
look_fd:
/* QL:         move.w  d0,-(sp)        save sector */
    move.w d0,-(sp)
/* QL: loop_fd */
loop_fd:
/* QL:         subq.w  #2,d0           on one */
    subq.w #2,d0
/* QL:         bpl.s   chk_fd          beyond 0? */
    bpl.s chk_fd
/* QL:         move.w  #maxsec*2-2,d0 */
    move.w #((maxsec*2)-2),d0
/* QL: chk_fd */
chk_fd:
/* QL:         cmp.b   #vacant,md_map(a2,d0.w) vacant? */
    cmp.b #(vacant&255),md_map(a2,d0.w)
/* QL:         beq.s   set_sect */
    beq.s set_sect
/* QL:         cmp.w   (sp),d0         checked all? */
    cmp.w (sp),d0
/* QL:         bne.s   loop_fd */
    bne.s loop_fd
/* QL:         addq.l  #2+4,sp         remove sector and return address */
    addq.l #(2+4),sp
/* QL:         moveq   #err.df,d0      drive full */
    moveq #err.df,d0
/* QL:         rts */
    rts 
/* QL: set_sect */
set_sect:
/* QL:         addq.b  #1,d2           restore block number */
    addq.b #1,d2
/* QL:         move.w  d2,md_map(a2,d0.w) set file/block number */
    move.w d2,md_map(a2,d0.w)
/* QL:         move.w  d0,md_lsect(a2) and save last sector allocated */
    move.w d0,md_lsect(a2)
/* QL:         move.w  #-1,md_pendg(a2) set map modified */
    move.w #(-1),md_pendg(a2)
/* QL:         addq.l  #2,sp           remove sector from stack */
    addq.l #2,sp
/* QL:         rts */
    rts 
/* QL: * Set up top of map in d0, file/block in microdrive map form in d2 */
/* QL: ini_fsec */
ini_fsec:
/* QL:         move.w  #maxsec*2,d0    start looking one down from top */
    move.w #(maxsec*2),d0
/* QL:         move.l  d5,d2           00ff00bb d5.l = file/block */
    move.l d5,d2
/* QL:         lsr.l   #8,d2           0000ff00 */
    lsr.l #8,d2
/* QL:         move.b  d5,d2           0000ffbb d2.w = file/block */
    move.b d5,d2
/* QL:         rts */
    rts 
/* QL: * General look for sector */
/* QL: isit_sec */
isit_sec:
/* QL:         cmp.w   md_map(a2,d0.w),d2 the right one? */
    cmp.w md_map(a2,d0.w),d2
/* QL:         beq.s   rts1 */
    beq.s rts1
/* QL: look_sec */
look_sec:
/* QL:         subq.w  #2,d0           move down a sector */
    subq.w #2,d0
/* QL:         bpl.s   isit_sec */
    bpl.s isit_sec
/* QL:         addq.l  #4+4,sp         drop 2 levels of call! */
    addq.l #(4+4),sp
/* QL: err_fe */
err_fe:
/* QL:         moveq   #err.fe,d0      file system error */
    moveq #err.fe,d0
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: * Find a sector for existing block */
/* QL: fnd_sect */
fnd_sect:
/* QL:         bsr.s   ini_fsec        initialise */
    bsr.s ini_fsec
/* QL:         bsr.s   look_sec        ... and look (nb. failure drops 2 levels!) */
    bsr.s look_sec
/* QL: * Drop into mdvnb */
/* QL: * The algorithm to allocate a new slave block (first version - very simple) */
/* QL: * the BT table is scanned, starting from btpnt (the latest allocated entry), */
/* QL: * looking for 4 lsb's of status showing empty or true copy. The first such is */
/* QL: * set as the latest allocated and generally marked up as empty. */
/* QL: * The entry that btpnt initially pointed to is never considered as available. */
/* QL: * A normal return is only made if a block has been acquired. */
/* QL: * If no block is found, the return address is discarded, d0 is set to err.nc, */
/* QL: * d1 is destroyed, a4=btbas and a5=btpnt. */
/* QL: * d1 -  o- 0 */
/* QL: * d5 -ip - file (msw) and block (lsw) */
/* QL: * d6 -ip - physdef drive id * 16 + 1<<bt..file (lsb) */
/* QL: * a4 -  o- pointer to acquired slave block table entry */
/* QL: * a5 destroyed (may be old btpnt or bttop) */
/* QL: dd_mdvnb */
dd_mdvnb:
/* QL:         move.l  sv_btpnt(a6),a4 start looking 1 after last block allocated */
    move.l sv_btpnt(a6),a4
/* QL:         move.l  sv_bttop(a6),a5 set marker = top */
    move.l sv_bttop(a6),a5
/* QL:         bra.s   new_next */
    bra.s new_next
/* QL: new_stat */
new_stat:
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   (a4),d1         look at status */
    and.b (a4),d1
/* QL:         subq.b  #bt.empty,d1    is it empty? */
    subq.b #bt.empty,d1
/* QL:         beq.s   new_fnd         ... yes */
    beq.s new_fnd
/* QL:         subq.b  #bt.true-bt.empty,d1 is it true copy */
.word 20737|((((bt.true-bt.empty))&7)<<9)
/* QL:         beq.s   new_fnd         ... yes */
    beq.s new_fnd
/* QL: new_next */
new_next:
/* QL:         addq.l  #bt_end,a4      look at next slave block */
    addq.l #bt_end,a4
/* QL: newbtbas */
newbtbas:
/* QL:         cmp.l   a5,a4           has this hit out marker? */
    cmp.l a5,a4
/* QL:         bne.s   new_stat        no - keep going */
    bne.s new_stat
/* QL:         move.l  sv_btpnt(a6),a5 make the marker into last block allocated */
    move.l sv_btpnt(a6),a5
/* QL:         cmp.l   a4,a5           was that where we were anyway? */
    cmp.l a4,a5
/* QL:         move.l  sv_btbas(a6),a4 no - start again at bottom of table */
    move.l sv_btbas(a6),a4
/* QL:         bne.s   newbtbas        no - we can carry on, if bas<>pnt that is */
    bne.s newbtbas
/* QL: nonewbt */
nonewbt:
/* QL:         addq.l  #4,sp           remove return address */
    addq.l #4,sp
/* QL:         moveq   #err.nc,d0      not complete */
    moveq #err.nc,d0
/* QL:         rts */
    rts 
/* QL: new_fnd */
new_fnd:
/* QL:         move.l  a4,sv_btpnt(a6) reset pointer to last block allocated */
    move.l a4,sv_btpnt(a6)
/* QL:         move.l  a4,fs_cblok(a0) and set pointer to current block */
    move.l a4,fs_cblok(a0)
/* QL:         move.b  d6,(a4)         mark new block with drive number, empty */
    move.b d6,(a4)
/* QL:         move.l  d5,bt_filnr(a4) set file and block number */
    move.l d5,bt_filnr(a4)
/* QL:         rts */
    rts 
/* QL:         end */
