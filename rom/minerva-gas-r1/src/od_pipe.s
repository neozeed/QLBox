/* Generated from original/M/od/pipe.asm */
/* QL: * Pipe device driver - extended for id and long pipes */
/* QL:         xdef    od_pipe,io_serq */
.globl od_pipe,io_serq
/* QL:         xref    io_relio,io_name,io_qsetl,io_qeof,io_qtest,io_qin,io_qout */
/* QL:         xref    mm_alchp,mm_rechp */
/* QL:         xref    tb_multi,tb_multx */
/* QL:         xref    ut_unlnk */
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
/* QL:         include 'win1_m_inc_hp' */
/* QL: * common heap header definition */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: hp_len  ds.l    1       length of definition block */
.equ hp_len,0
/* QL: hp_next ; pointer to next free space */
.equ hp_next,4
/* QL: hp_drivr ds.l   1       driver to free block when owner is deleted (-ch_close) */
.equ hp_drivr,4
/* QL: hp_owner ds.l   1       owner job (0 if free space) */
.equ hp_owner,8
/* QL: hp_rflag ds.l   1       address to be set when space released */
.equ hp_rflag,12
/* QL: hp_end */
.equ hp_end,16
/* QL: hp_close equ    12      offset of close entry point wrt driver add */
.equ hp_close,12
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
/* QL:         include 'win1_m_inc_q' */
/* QL: * io queue header definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: q_eoff ; end of file flag (msbit) */
.equ q_eoff,0
/* QL: q_nextq ds.l    1       link to next queue */
.equ q_nextq,0
/* QL: q_end   ds.l    1       pointer to end of queue */
.equ q_end,4
/* QL: q_nextin ds.l   1       pointer to next location to put byte in */
.equ q_nextin,8
/* QL: q_nxtout ds.l   1       pointer to next location to take byte from */
.equ q_nxtout,12
/* QL: q_queue ; start of queue */
.equ q_queue,16
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
/* QL:         include 'win1_m_inc_sx' */
/* QL: * system variables extension */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sx_case ds.l    1       non-zero = user rtn on ctrl/alt/shift/enter (c/a/s/e?) */
.equ sx_case,0
/* QL: sx_itran ds.l   1       input tranlation routine */
.equ sx_itran,4
/* QL: sx_otran ds.l   1       output translation routine */
.equ sx_otran,8
/* QL: sx_driv ds.l    1       mm_rechp is memory management driver, close entry point */
.equ sx_driv,12
/* QL: sx_kbenc ds.l   1       keyboard encoder routine */
.equ sx_kbenc,16
/* QL: sx_ipcom ds.l   1       linked list to front end mt.ipcom calls */
.equ sx_ipcom,20
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL: sx_trn  ds.l    1       default i/o translation table address */
.equ sx_trn,32
/* QL: sx_msg  ds.l    1       default message table address */
.equ sx_msg,36
/* QL: sx_f0   ds.l    1       default primary font */
.equ sx_f0,40
/* QL: sx_f1   ds.l    1       default secondary font */
.equ sx_f1,44
/* QL: sx_dspm ds.b    1       real display mode settings (dual screen) */
.equ sx_dspm,48
/* QL: sx_toe  ds.b    1       turn off ehancements: */
.equ sx_toe,49
/* QL:                 ; bit 7 set, allow format + files open */
/* QL:                 ; bit 1 set, treat -ve mt.baud as error (non-hermes) */
/* QL: sx_event ds.b   1       events: bit 4 = ctrl/space, 5=+alt, 6=+shift, 7=+both */
.equ sx_event,50
/* QL: sx_fstat ds.b   1       cursor flash rate, size and colour rrrrsccc */
.equ sx_fstat,51
/* QL: sx_kbste ds.b   12      special key remap table */
.equ sx_kbste,52
/* QL: sx_qdos ds.l    1       returned by mt.inf, ver$(-2) */
.equ sx_qdos,64
/* QL: sx_basic ds.w   1+4/2   length prefixed string returned by ver$, ver$(0) */
.equ sx_basic,68
/* QL:         ds.w    2       spare/reserved */
/* QL:         ds.b    1       21kxs10w   21: ser21 data pend, k: key held, x: shift */
/* QL:                         ; change while key held, s: sound in progress, 1: 1, */
/* QL:                         ; 0: zero Hermes, old IPC showed ser being zapped, */
/* QL:                         ; w: p26 (write protect) (experimental byte!) */
/* QL:         ds.b    1       spare/reserved */
/* QL: * initial ram based linkages */
/* QL:         ds.l    2       0 ip_poll */
/* QL:         ds.l    6       base+$60 sd_sched base+$68 ip_sched 0 io_scan */
/* QL:         ds.l    4       base+$80 od_serio od_serop od_sercl */
/* QL: sx_pipb ds.l    4       base+$90 io_serq  od_pipop od_pipcl */
.equ sx_pipb,128
/* QL: sx_con  ds.l    4       base+$a0 od_conio od_conop od_concl */
.equ sx_con,144
/* QL:         ds.l    4       0 od_netio od_netop od_netcl */
/* QL:         ds.l    8       0 dd_mdvio dd_mdvop dd_mdvcl md_slave 0 0 md_formt */
/* QL:         ds.b    4+2+3   md_end 3 'mdv' */
/* QL:         ds.b    3       spare bit */
/* QL: sx_pipc ds.l    1       pipe driver link word */
.equ sx_pipc,220
/* QL: * end of system extension */
/* QL:         list */
/* QL: idlink  equ     sx_pipc-sx_pipb should do this more properly! */
.equ idlink,(sx_pipc-sx_pipb)
/* QL: * The old style pipes, which are a pain to link up, are handled by: */
/* QL: *       pipe{_{<length>}}{k} */
/* QL: * where length is present and non-zero to open a pipe for output, with the */
/* QL: * optional "k" to allow long pipes as an enhacement. If the length is not */
/* QL: * given or is zero, the channel opened is an input pipe, and d3 at the open */
/* QL: * call must give the channel id number of the already opened output channel. */
/* QL: * The new pipes have one or two non-zero ids as in: */
/* QL: *       pipe<id1>{x|p|t}<id2>{_{<length>}}{k} */
/* QL: * Unlike the old pipes, any number of channels may be opened to the same pipe. */
/* QL: * The first channel must give a positive length for the pipe. The length is */
/* QL: * ignored on any subsequent opens. */
/* QL: * d3=io.dir at the open call is rejected, but the other normal values all open */
/* QL: * channels which may be used for input and/or output. */
/* QL: * If the "x", "p" or "t" flag is omitted, only one id can be given, and this */
/* QL: * becomes both input and output. */
/* QL: * If any flag is given, both ids may be used, with the first specifying the */
/* QL: * pipe to receive data sent to the channel and the second being the one to */
/* QL: * fetch data from. These may be the same id. */
/* QL: * When all channels that may send data to a pipe have been closed, if the last */
/* QL: * open that included a "p" or "t" flag gave a "t", or neither was ever given, */
/* QL: * the pipe is marked as at end of file and is no longer accessible by the id. */
/* QL: * Any remaining read-only channels continue to read data left in the pipe. */
/* QL: * If a "p" flag is given last, all channels may be closed and the data in the */
/* QL: * pipe will remain, waiting for another open to the id. */
/* QL: * Two additional pipe-like devices are supported: */
/* QL: *       pipep will give the data to allow a copy of multibasic to be execed. */
/* QL: *       pipet is a device that always gives eof on read and discards output. */
/* QL:         offset  hp_end-ch_qend */
/* QL: pp_tag  ds.w    1       flag as -ve for ided queues (ch_tag is always +ve!) */
.equ pp_tag,-16
/* QL: pp_id   ds.w    1       identifier for this queue */
.equ pp_id,-14
/* QL:         ds.w    3       padding, but always zero */
/* QL: pp_read ds.w    1       count of readers of this queue */
.equ pp_read,-6
/* QL: pp_perm ds.b    1       msb set if permanent */
.equ pp_perm,-4
/* QL:         ds.b    1       padding, but always zero */
/* QL: pp_write ds.w   1       count of writers to this queue */
.equ pp_write,-2
/* QL:         assert  0,* */
/* original assertion: 0,0 */
/* QL:         section od_pipe */
.section od_pipe,"ax"
/* QL: od_pipe */
od_pipe:
/* QL:         dc.w    io_serq-* */
.balign 2,0
dc_anchor_576:
.word ((io_serq-dc_anchor_576))&65535
/* QL:         dc.w    open-* */
.balign 2,0
dc_anchor_580:
.word ((open-dc_anchor_580))&65535
/* QL:         dc.w    close-* */
.balign 2,0
dc_anchor_584:
.word ((close-dc_anchor_584))&65535
/* QL: pop_exit */
pop_exit:
/* QL:         add.l   d4,sp           remove parameters from stack */
    add.l d4,sp
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: open */
open:
/* QL:         lea     sv_lio(a3),a4   keep driver definition link address */
    lea sv_lio(a3),a4
/* QL:         moveq   #2*5,d4         N.B. this is preserved by io.name (and it's 10) */
    moveq #(2*5),d4
/* QL:         sub.l   d4,sp           make room on stack for parameters */
    sub.l d4,sp
/* QL:         move.l  sp,a3           and point a3 to it */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     check device name */
    jsr io_name(pc)
/* QL:         bra.s   pop_exit        not pipe */
    bra.s pop_exit
/* QL:         bra.s   pop_exit        bad parameters */
    bra.s pop_exit
/* QL:         bra.s   opn_pipe        ok! */
    bra.s opn_pipe
/* QL:         dc.w    4,'PIPE',5,-1,0,3,'XTP',-1,0,' _',0,1,'K' */
.balign 2,0
dc_anchor_614:
.word 4
.byte 80,73,80,69
.balign 2,0
.word 5
.word ((-1))&65535
.word 0
.word 3
.byte 88,84,80
.balign 2,0
.word ((-1))&65535
.word 0
.byte 32,95
.balign 2,0
.word 0
.word 1
.byte 75
.balign 2,0
/* QL: * d0 -i o- io key / error flag */
/* QL: * d1 -i o- IOSS */
/* QL: * d2 -i o- IOSS */
/* QL: * d3 -i  - IOSS */
/* QL: * a0 -ip - pointer to channel definition block */
/* QL: * a1 -i o- IOSS */
/* QL: * a2-a3 destroyed */
/* QL: io_serq */
io_serq:
/* QL:         lea     ch_qin(a0),a2   get address of input queue */
    lea ch_qin(a0),a2
/* QL:         move.l  d0,a3           save I/O command */
    move.l d0,a3
/* QL:         subq.b  #io.fstrg,d0    is operation simple input? */
    subq.b #io.fstrg,d0
/* QL:         bls.s   test_q          yes - that's OK */
    bls.s test_q
/* QL:         sub.b   #fs.headr-io.fstrg,d0 */
    sub.b #((fs.headr-io.fstrg)&255),d0
/* QL:         subq.b  #fs.load-fs.headr,d0 */
.word 20736|((((fs.load-fs.headr))&7)<<9)
/* QL:         bls.s   test_q          fine - fs op is input */
    bls.s test_q
/* QL:         addq.l  #ch_qout-ch_qin,a2 get address of output queue */
.word 20618|((((ch_qout-ch_qin))&7)<<9)
/* QL: test_q */
test_q:
/* QL:         move.l  (a2),a2         point to queue */
    move.l (a2),a2
/* QL:         move.l  a2,d0           does queue exist (address non zero) */
    move.l a2,d0
/* QL:         exg     a3,d0           restore command */
    exg a3,d0
/* QL:         beq.s   err_bp          oops - no queue indeed */
    beq.s err_bp
/* QL:         jsr     io_relio(pc)    simple serial io with relative pointers */
    jsr io_relio(pc)
/* QL:         dc.w    io_qtest-* */
.balign 2,0
dc_anchor_671:
.word ((io_qtest-dc_anchor_671))&65535
/* QL:         dc.w    io_qout-* */
.balign 2,0
dc_anchor_675:
.word ((io_qout-dc_anchor_675))&65535
/* QL:         dc.w    io_qin-* */
.balign 2,0
dc_anchor_679:
.word ((io_qin-dc_anchor_679))&65535
/* QL: opn_pipe */
opn_pipe:
/* QL:         movem.w (sp)+,d2/d5-d7  grab all the parameters bar last */
    movem.w (sp)+,d2/d5-d7
/* QL:         mulu    (sp)+,d4        1->10 for length in kilobytes */
    mulu (sp)+,d4
/* QL:         asl.l   d4,d7 */
    asl.l d4,d7
/* QL:         moveq   #-4,d4          start with input queue (so as not to zap eof) */
    moveq #(-4),d4
/* QL:         ror.b   #2,d5           put -xpt up in top two bits */
    ror.b #2,d5
/* QL:         beq.s   old_pipe */
    beq.s old_pipe
/* QL:         cmp.w   #5,(a0) */
    cmp.w #5,(a0)
/* QL:         beq.s   special         got one of "pipex", "pipep" or "pipet" */
    beq.s special
/* QL: new_pipe */
new_pipe:
/* QL:         subq.w  #io.dir,d3 */
    subq.w #io.dir,d3
/* QL:         bcc.s   err_bp */
    bcc.s err_bp
/* QL:         bsr.s   alhead */
    bsr.s alhead
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL: newopen */
newopen:
/* QL:         tst.w   d2 */
    tst.w d2
/* QL:         beq.s   newnext */
    beq.s newnext
/* QL:         lea     idlink(a4),a2   point to base of linked list of id queues */
    lea idlink(a4),a2
/* QL:         bra.s   entry */
    bra.s entry
/* QL: lookup */
lookup:
/* QL:         move.l  d1,a2 */
    move.l d1,a2
/* QL:         cmp.w   pp_id(a2),d2    look for matching id */
    cmp.w pp_id(a2),d2
/* QL:         beq.s   gotit */
    beq.s gotit
/* QL: entry */
entry:
/* QL:         move.l  (a2),d1 */
    move.l (a2),d1
/* QL:         bne.s   lookup */
    bne.s lookup
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         ble.s   err_bp          must have a proper length now */
    ble.s err_bp
/* QL:         move.l  a2,a1           save link pointer */
    move.l a2,a1
/* QL:         move.l  a0,a5           remember our channel */
    move.l a0,a5
/* QL:         bsr.s   alqueue         much the same as old output pipe */
    bsr.s alqueue
/* QL:         move.l  a5,a0           put channel back */
    move.l a5,a0
/* QL:         bne.s   newfail */
    bne.s newfail
/* QL:         st      pp_tag(a2)      flag as new queue */
    st pp_tag(a2)
/* QL:         move.l  a2,(a1)         tack onto end of linked list */
    move.l a2,(a1)
/* QL:         move.w  d2,pp_id(a2)    store id */
    move.w d2,pp_id(a2)
/* QL: gotit */
gotit:
/* QL:         move.l  a2,ch_qout(a0,d4.w) store pipe */
    move.l a2,ch_qout(a0,d4.w)
/* QL:         addq.w  #1,pp_write(a2,d4.w) increment read/write */
    addq.w #1,pp_write(a2,d4.w)
/* QL:         move.b  d5,d1 */
    move.b d5,d1
/* QL:         bpl.s   newnext */
    bpl.s newnext
/* QL:         add.b   d1,d1 */
    add.b d1,d1
/* QL:         move.b  d1,pp_perm(a2) */
    move.b d1,pp_perm(a2)
/* QL: newnext */
newnext:
/* QL:         exg     d2,d6 */
    exg d2,d6
/* QL:         addq.w  #4,d4 */
    addq.w #4,d4
/* QL:         beq.s   newopen */
    beq.s newopen
/* QL:         rts */
    rts 
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: alhead */
alhead:
/* QL:         moveq   #ch_qend,d1     reserve just enough space for channel header */
    moveq #ch_qend,d1
/* QL: alchp */
alchp:
/* QL:         jmp     mm_alchp(pc)    allocate space */
    jmp mm_alchp(pc)
/* QL: old_pipe */
old_pipe:
/* QL:         move.w  d2,d6           as d5 was not set, d6 must have been zero */
    move.w d2,d6
/* QL:         bne.s   new_pipe        default out=in, if id present */
    bne.s new_pipe
/* QL:         tst.l   d7              check length of pipe */
    tst.l d7
/* QL:         ble.s   open_in         -ve can happen!, so this is safe! */
    ble.s open_in
/* QL:         bsr.s   alqueue */
    bsr.s alqueue
/* QL: setqout */
setqout:
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL: setqio */
setqio:
/* QL:         move.l  a2,ch_qout(a0,d4.w) put pointer to queue in definition data */
    move.l a2,ch_qout(a0,d4.w)
/* QL:         rts */
    rts 
/* QL: special */
special:
/* QL:         bsr.s   alqueue         set up queue channel */
    bsr.s alqueue
/* QL:         bne.s   rts1            give up if no good */
    bne.s rts1
/* QL:         bsr.s   setqio          make it input */
    bsr.s setqio
/* QL:         bsr.s   setqout         make it output */
    bsr.s setqout
/* QL:         assert  q_eoff,q_nextq,q_end-4,q_nextin-8,q_nxtout-12 */
/* original assertion: q_eoff,q_nextq,q_end-4,q_nextin-8,q_nxtout-12 */
/* QL:         subq.l  #1,(a2)+        mark as at eof immediately, and special */
    subq.l #1,(a2)+
/* QL:         add.b   d5,d5 */
    add.b d5,d5
/* QL:         bcc.s   specfail */
    bcc.s specfail
/* QL:         bpl.s   rts1            finished if "pipet", the throwaway pipe */
    bpl.s rts1
/* QL:         lea     tb_multx+1,a1   point to end of multibasic module, plus one */
    lea (tb_multx+1)(pc),a1
/* QL:         move.l  a1,(a2)+        set q_end */
    move.l a1,(a2)+
/* QL:         subq.l  #1,a1           point to actual end of module */
    subq.l #1,a1
/* QL:         move.l  a1,(a2)+        set q_nextin */
    move.l a1,(a2)+
/* QL:         lea     tb_multi,a1     point to start of multibasic module */
    lea tb_multi(pc),a1
/* QL:         move.l  a1,(a2) */
    move.l a1,(a2)
/* QL:         sub.l   a2,a2 */
    sub.l a2,a2
/* QL: setqio2 */
setqio2:
/* QL:         bra.s   setqio          "pipep" is read-only */
    bra.s setqio
/* QL: alqueue */
alqueue:
/* QL:         moveq   #ch_qend+q_queue+1,d1 */
    moveq #((ch_qend+q_queue)+1),d1
/* QL:         add.l   d7,d1 */
    add.l d7,d1
/* QL:         bsr.s   alchp */
    bsr.s alchp
/* QL:         bne.s   rts1 */
    bne.s rts1
/* QL:         lea     ch_qend(a0),a2  set up pointer to queue header */
    lea ch_qend(a0),a2
/* QL:         move.l  d7,d1           pass length of pipe */
    move.l d7,d1
/* QL:         addq.l  #1,d1           including the extra byte for wrap effect */
    addq.l #1,d1
/* QL:         jsr     io_qsetl(pc)    set up queue */
    jsr io_qsetl(pc)
/* QL:         moveq   #0,d0           ensure ccr is z (d0 was already zero) */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: specfail */
specfail:
/* QL:         moveq   #err.bn,d0 */
    moveq #err.bn,d0
/* QL: newfail */
newfail:
/* QL:         move.l  d0,d4 */
    move.l d0,d4
/* QL:         bsr.s   close           drop failed channel */
    bsr.s close
/* QL:         move.l  d4,d0 */
    move.l d4,d0
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: open_in */
open_in:
/* QL:         cmp.w   sv_chmax(a6),d3 */
    cmp.w sv_chmax(a6),d3
/* QL:         bhi.s   err_bp          don't wander off end of channel table! */
    bhi.s err_bp
/* QL:         lsl.w   #2,d3           fetch id */
    lsl.w #2,d3
/* QL:         move.l  sv_chbas(a6),a2 base of channel table */
    move.l sv_chbas(a6),a2
/* QL:         move.l  0(a2,d3.w),a2   pick up link channel */
    move.l 0(a2,d3.w),a2
/* QL:         move.l  a2,d1           is it ok? */
    move.l a2,d1
/* QL:         bmi.s   err_bp          no good, it's closed! */
    bmi.s err_bp
/* QL:         cmp.l   ch_drivr(a2),a4 is this the same driver? */
    cmp.l ch_drivr(a2),a4
/* QL: err_bpne */
err_bpne:
/* QL:         bne.s   err_bp          nope - don't think that's a good idea! */
    bne.s err_bp
/* QL:         add.w   #ch_qin,a2      find the other queue */
    add.w #ch_qin,a2
/* QL:         assert  ch_qin,ch_qout-4,ch_qend-8 */
/* original assertion: ch_qin,ch_qout-4,ch_qend-8 */
/* QL:         tst.l   (a2)+ */
    tst.l (a2)+
/* QL:         bne.s   err_bpne        can't open input to input! */
    bne.s err_bpne
/* QL:         cmp.l   (a2)+,a2        proper old pipe? */
    cmp.l (a2)+,a2
/* QL:         bne.s   err_bpne        no - complain */
    bne.s err_bpne
/* QL:         moveq   #err.iu,d0 */
    moveq #err.iu,d0
/* QL:         tst.l   (a2)            check q_nextq */
    tst.l (a2)
/* QL:         bne.s   rts1            ouch! already linked to an input pipe */
    bne.s rts1
/* QL:         bsr.l   alhead */
    bsr.w alhead
/* QL:         bne.s   rts1 */
    bne.s rts1
/* QL:         move.l  a0,(a2)         cross link the blocks */
    move.l a0,(a2)
/* QL:         bra.s   setqio2 */
    bra.s setqio2
/* QL: close */
close:
/* QL:         assert  ch_qin,ch_qout-4 */
/* original assertion: ch_qin,ch_qout-4 */
/* QL:         moveq   #-4,d3 */
    moveq #(-4),d3
/* QL:         bsr.s   closeque        close input connection */
    bsr.s closeque
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         bsr.s   closeque        close output connection */
    bsr.s closeque
/* QL: delete */
delete:
/* QL:         jmp     mm_rechp(pc) */
    jmp mm_rechp(pc)
/* QL: closeque */
closeque:
/* QL:         move.l  ch_qout(a0,d3.w),d0 get queue pointer (qout, then qin) */
    move.l ch_qout(a0,d3.w),d0
/* QL:         beq.s   rts1 */
    beq.s rts1
/* QL:         move.l  d0,a2 */
    move.l d0,a2
/* QL:         moveq   #-1,d1          special queue marker */
    moveq #(-1),d1
/* QL:         cmp.l   (a2),d1 */
    cmp.l (a2),d1
/* QL:         beq.s   rts1            no special handling needed for special queues */
    beq.s rts1
/* QL:         tst.b   pp_tag(a2) */
    tst.b pp_tag(a2)
/* QL:         bmi.s   closrdwr        go handle new id pipes */
    bmi.s closrdwr
/* QL:         move.l  d3,d0 */
    move.l d3,d0
/* QL:         bne.s   close_in        note d0=0 if we stay here */
    bne.s close_in
/* QL:         tst.l   (a2)            is output connected at the other end? */
    tst.l (a2)
/* QL:         beq.s   rts1            no - we will delete it */
    beq.s rts1
/* QL:         addq.l  #4,sp           discard return, as we will keep the pipe */
    addq.l #4,sp
/* QL: qeof */
qeof:
/* QL:         jmp     io_qeof(pc)     mark as at end of file */
    jmp io_qeof(pc)
/* QL: closrdwr */
closrdwr:
/* QL:         assert  pp_read,pp_perm-2,pp_write-4 */
/* original assertion: pp_read,pp_perm-2,pp_write-4 */
/* QL:         subq.l  #1,pp_write-2(a2,d3.w) dec read/write count */
    subq.l #1,(pp_write-2)(a2,d3.w)
/* QL:         tst.l   pp_perm(a2)     permanent or any writers? */
    tst.l pp_perm(a2)
/* QL: rtsne */
rtsne:
/* QL:         bne.s   rts1            yes - return, as we must keep this going */
    bne.s rts1
/* QL:         lea     sv_lio+idlink(a3),a1 point at base of our linked list */
    lea (sv_lio+idlink)(a3),a1
/* QL:         exg     a2,a0 */
    exg a0,a2
/* QL:         jsr     ut_unlnk(pc)    unlink from our list (if it's still there!) */
    jsr ut_unlnk(pc)
/* QL:         exg     a2,a0 */
    exg a0,a2
/* QL:         bsr.s   qeof            mark as at end of file */
    bsr.s qeof
/* QL:         tst.w   pp_read(a2)     any readers left? */
    tst.w pp_read(a2)
/* QL:         bne.s   rtsne           yes, so all done for the moment */
    bne.s rtsne
/* QL: delque */
delque:
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         lea     -ch_qend(a2),a0 */
    lea (-ch_qend)(a2),a0
/* QL:         bsr.s   delete */
    bsr.s delete
/* QL:         move.l  a1,a0 */
    move.l a1,a0
/* QL:         rts */
    rts 
/* QL: close_in */
close_in:
/* QL:         tst.b   (a2) */
    tst.b (a2)
/* QL:         bmi.s   delque          if eof is set, delete the old output channel */
    bmi.s delque
/* QL:         clr.l   (a2)            remove pointer to this block */
    clr.l (a2)
/* QL:         rts     */
    rts 
/* QL:         end */
