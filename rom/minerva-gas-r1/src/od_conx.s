/* Generated from original/M/od/conx.asm */
/* QL: * Console/screen driver */
/* QL:         xdef    od_con */
.globl od_con
/* QL:         xref    gw_floof */
/* QL:         xref    io_name,io_qout,io_qsetl,io_qtest */
/* QL:         xref    ip_dspm */
/* QL:         xref    mm_alchp,mm_rechp */
/* QL:         xref    sd_clrxx,sd_cure,sd_curs,sd_curt,sd_donl,sd_entry,sd_modes */
/* QL:         xref    sd_newl,sd_scrol,sd_setfo,sd_wdef */
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
/* QL:         include 'win1_m_inc_jb' */
/* QL: * job header and save area definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: jb_len  ds.l    1       length of job segment */
.equ jb_len,0
/* QL: jb_start ds.l   1       start address */
.equ jb_start,4
/* QL: jb_owner ds.l   1       owner of this job */
.equ jb_owner,8
/* QL: jb_hold ds.l    1       ptr to byte to be clr when job released */
.equ jb_hold,12
/* QL: jb_tag  ds.w    1       tag for this job */
.equ jb_tag,16
/* QL: jb_prior ds.b   1       current accumulated priority */
.equ jb_prior,18
/* QL: jb_princ ds.b   1       priority increment, if =0 job inactive */
.equ jb_princ,19
/* QL: jb_stat ds.w    1       job status: */
.equ jb_stat,20
/* QL: *               0 potentially active, >0 delay time (frames), <0 suspended */
/* QL: jb_rela6 ds.b   1       bit 7: next trap #2/3 is rel a6, bit 6: interpreter */
.equ jb_rela6,22
/* QL: jb_wflag ds.b   1       set if there is a job waiting on completion */
.equ jb_wflag,23
/* QL: jb_wjob ds.l    1       job id of waiting job */
.equ jb_wjob,24
/* QL: jb_trapv ds.l   1       pointer to trap redirection vectors */
.equ jb_trapv,28
/* QL: jb_d0   ds.l    8       saved d0-d7 */
.equ jb_d0,32
/* QL: jb_a0   ds.l    8       saved a0-a7 */
.equ jb_a0,64
/* QL: jb_sr   ds.w    1       saved sr */
.equ jb_sr,96
/* QL: jb_pc   ds.l    1       saved pc */
.equ jb_pc,98
/* QL:         ds.w    1       spare */
/* QL: jb_end */
.equ jb_end,104
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
/* QL:         include 'win1_m_inc_sd' */
/* QL: * window data block definition */
/* QL:         nolist */
/* QL:         offset  $18 (end of basic channel definition) */
/* QL: sd_xmin ds.w    1       window left pixel, exclusive of border */
.equ sd_xmin,24
/* QL: sd_ymin ds.w    1       ditto top pixel */
.equ sd_ymin,26
/* QL: sd_xsize ds.w   1       window width, exclusive of border */
.equ sd_xsize,28
/* QL: sd_ysize ds.w   1       ditto height */
.equ sd_ysize,30
/* QL: sd_borwd ds.w   1       border height, border width is double this */
.equ sd_borwd,32
/* QL: sd_xpos ds.w    1       cursor position relative to left pixel above */
.equ sd_xpos,34
/* QL: sd_ypos ds.w    1       ditto top pixel */
.equ sd_ypos,36
/* QL: sd_xinc ds.w    1       cursor pixel width */
.equ sd_xinc,38
/* QL: sd_yinc ds.w    1       cursor pixel height */
.equ sd_yinc,40
/* QL: * note: the x values above should be even when in mode 8. */
/* QL: sd_font ds.l    2       font addresses, primary first. def char in secondary */
.equ sd_font,42
/* QL: sd_scrb ds.l    1       base address of screen */
.equ sd_scrb,50
/* QL: sd_pmask ds.l   1       paper colour mask */
.equ sd_pmask,54
/* QL: sd_smask ds.l   1       strip colour mask */
.equ sd_smask,58
/* QL: sd_imask ds.l   1       ink colour mask */
.equ sd_imask,62
/* QL: sd_cattr ds.b   1       character attributes (see below for bits) */
.equ sd_cattr,66
/* QL: sd_curf ds.b    1       cursor flag (0 suppressed, >0 visible, <0 invisible) */
.equ sd_curf,67
/* QL: sd_pcolr ds.b   1       paper colour byte */
.equ sd_pcolr,68
/* QL: sd_scolr ds.b   1       strip colour byte */
.equ sd_scolr,69
/* QL: sd_icolr ds.b   1       ink colour byte */
.equ sd_icolr,70
/* QL: sd_bcolr ds.b   1       border colour byte */
.equ sd_bcolr,71
/* QL: sd_nlsta ds.b   1       new line status (0 none, >0 implicit, <0 explicit) */
.equ sd_nlsta,72
/* QL: sd_fmod ds.b    1       fill mode (0 off, 1 on) */
.equ sd_fmod,73
/* QL: sd_yorg ds.w    3       graphics window origin (added to y coords) (float) */
.equ sd_yorg,74
/* QL: sd_xorg ds.w    3       ditto for x */
.equ sd_xorg,80
/* QL: sd_scal ds.w    3       graphics scale factor (from bottom row to top row) */
.equ sd_scal,86
/* QL: sd_fbuf ds.l    1       pointer to alchp'ed fill buffer, 0 if none */
.equ sd_fbuf,92
/* QL: sd_fuse ds.l    1       pointer to user defined fill vectors, not used */
.equ sd_fuse,96
/* QL: sd_linel ds.w   1       line length in bytes */
.equ sd_linel,100
/* QL: sd_flags ds.b   1       cleared by 1st time entry to driver (edlin needs this) */
.equ sd_flags,102
/* QL:         ds.b    1       spare */
/* QL: sd_end */
.equ sd_end,104
/* QL: * character attribute flag bits for sd_cattr */
/* QL: sd..ulin equ    0       underline (row 9, or the lowest row, is all ink) */
.equ sd..ulin,0
/* QL: sd..flsh equ    1       flash (ignored in mode 4) */
.equ sd..flsh,1
/* QL: sd..trns equ    2       transparent background (only character area is touched) */
.equ sd..trns,2
/* QL: sd..xor equ     3       xor characters/graphics (char/pixel colour xor'ed in) */
.equ sd..xor,3
/* QL: sd..dbht equ    4       double height (chars spread in y) */
.equ sd..dbht,4
/* QL: sd..exwd equ    5       extended width (8 bits used from char font entries) */
.equ sd..exwd,5
/* QL: sd..dbwd equ    6       double width (chars spread in x, mode 8 sets this) */
.equ sd..dbwd,6
/* QL: sd..gchr equ    7       graphics positioned chars (offscreen ignored until nl) */
.equ sd..gchr,7
/* QL: * screen entry parameter definition */
/* QL: sd.extop equ    $09     external operation (a2) */
.equ sd.extop,0x09
/* QL: sd.pxenq equ    $0a     pixel based size / position enquiry */
.equ sd.pxenq,0x0a
/* QL: sd.chenq equ    $0b     character based size / position enquiry */
.equ sd.chenq,0x0b
/* QL: sd.bordr equ    $0c     define window border */
.equ sd.bordr,0x0c
/* QL: sd.wdef equ     $0d     define window */
.equ sd.wdef,0x0d
/* QL: sd.cure equ     $0e     enable cursor */
.equ sd.cure,0x0e
/* QL: sd.curs equ     $0f     suppress cursor */
.equ sd.curs,0x0f
/* QL: sd.pos  equ     $10     absolute position */
.equ sd.pos,0x10
/* QL: sd.tab  equ     $11     tab (horizontal position) */
.equ sd.tab,0x11
/* QL: sd.nl   equ     $12     newline */
.equ sd.nl,0x12
/* QL: sd.pcol equ     $13     previous column */
.equ sd.pcol,0x13
/* QL: sd.ncol equ     $14     next column */
.equ sd.ncol,0x14
/* QL: sd.prow equ     $15     previous row */
.equ sd.prow,0x15
/* QL: sd.nrow equ     $16     next row */
.equ sd.nrow,0x16
/* QL: sd.pixp equ     $17     set pixel position */
.equ sd.pixp,0x17
/* QL: sd.scrol equ    $18     scroll whole window */
.equ sd.scrol,0x18
/* QL: sd.scrtp equ    $19     scroll top of window */
.equ sd.scrtp,0x19
/* QL: sd.scrbt equ    $1a     scroll bottom of window */
.equ sd.scrbt,0x1a
/* QL: sd.pan  equ     $1b     pan window */
.equ sd.pan,0x1b
/* QL: * ?     equ     $1c */
/* QL: * ?     equ     $1d */
/* QL: sd.panln equ    $1e     pan cursor line */
.equ sd.panln,0x1e
/* QL: sd.panrt equ    $1f     pan rhs of cursor line */
.equ sd.panrt,0x1f
/* QL: sd.clear equ    $20     clear whole window */
.equ sd.clear,0x20
/* QL: sd.clrtp equ    $21     clear top of window */
.equ sd.clrtp,0x21
/* QL: sd.clrbt equ    $22     clear bottom of window */
.equ sd.clrbt,0x22
/* QL: sd.clrln equ    $23     clear cursor line */
.equ sd.clrln,0x23
/* QL: sd.clrrt equ    $24     clear to right of cursor */
.equ sd.clrrt,0x24
/* QL: sd.fount equ    $25     set fount addresses */
.equ sd.fount,0x25
/* QL: sd.recol equ    $26     recolour a window */
.equ sd.recol,0x26
/* QL: sd.setpa equ    $27     set paper colour */
.equ sd.setpa,0x27
/* QL: sd.setst equ    $28     set strip colour */
.equ sd.setst,0x28
/* QL: sd.setin equ    $29     set ink colour */
.equ sd.setin,0x29
/* QL: sd.setfl equ    $2a     set flash on/off */
.equ sd.setfl,0x2a
/* QL: sd.setul equ    $2b     set underline on/off */
.equ sd.setul,0x2b
/* QL: sd.setmd equ    $2c     set write mode */
.equ sd.setmd,0x2c
/* QL: sd.setsz equ    $2d     set character size */
.equ sd.setsz,0x2d
/* QL: sd.fill equ     $2e     fill block */
.equ sd.fill,0x2e
/* QL: sd.donl equ     $2f     do pending newline */
.equ sd.donl,0x2f
/* QL: sd.point equ    $30     set point in window */
.equ sd.point,0x30
/* QL: sd.line equ     $31     draw line */
.equ sd.line,0x31
/* QL: sd.arc  equ     $32     draw arc */
.equ sd.arc,0x32
/* QL: sd.elips equ    $33     draw ellipse */
.equ sd.elips,0x33
/* QL: sd.scale equ    $34     set graphics scale */
.equ sd.scale,0x34
/* QL: sd.flood equ    $35     set fill mode/vectors */
.equ sd.flood,0x35
/* QL: sd.gcur equ     $36     set text cursor using graphics coords */
.equ sd.gcur,0x36
/* QL: * $6c..$74 $76..$77 $7a..$7f (at least) are used by the pointer interface */
/* QL:         list */
/* QL:         include 'win1_m_inc_ra' */
/* QL: * ram size definitions */
/* QL:         nolist */
/* QL: ra_bot  equ     $20000  bottom of ram */
.equ ra_bot,0x20000
/* QL: ra_min  equ     $20000  minimum ram size - 128 kbytes */
.equ ra_min,0x20000
/* QL: ra_ssize equ    $8000   screen size */
.equ ra_ssize,0x8000
/* QL:         list */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: * Frame of data used by io.edlin/io.fline */
/* QL:         offset  0 */
/* QL: width   ds.w    1       character width of window */
.equ width,0
/* QL: dx      ds.w    1       finicky bit at left of window */
.equ dx,2
/* QL: dy      ds.w    1       finicky bit at top of window */
.equ dy,4
/* QL: size    ds.w    1       total chars in window */
.equ size,6
/* QL: frame   ds.b    1       saved cursor flag */
.equ frame,8
/* QL:         ds.b    1       padding */
/* QL: buflen  ds.w    1       buffer length */
.equ buflen,10
/* QL:         section od_con */
.section od_con,"ax"
/* QL: od_con */
od_con:
/* QL:         dc.w    io-* */
.balign 2,0
dc_anchor_685:
.word ((io-dc_anchor_685))&65535
/* QL:         dc.w    open-* */
.balign 2,0
dc_anchor_689:
.word ((open-dc_anchor_689))&65535
/* QL:         dc.w    close-* */
.balign 2,0
dc_anchor_693:
.word ((close-dc_anchor_693))&65535
/* QL: open */
open:
/* QL:         sub.w   #5*2,sp         make room on stack for parameters */
    sub.w #(5*2),sp
/* QL:         move.l  sp,a3           and point a3 to it */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     check device name (con) */
    jsr io_name(pc)
/* QL:         bra.s   scr             not found - try open screen */
    bra.s scr
/* QL:         bra.s   opn_exit        bad parameter */
    bra.s opn_exit
/* QL:         bra.s   open_con        recognised!! */
    bra.s open_con
/* QL: ;        if ntsc */
/* QL: ;        dc.w    3,'CON',5,' _',420,' X',160,' A',46,' X',0,' _',128 */
/* QL: ;        else */
/* QL:         dc.w    3,'CON',5,' _',448,' X',180,' A',32,' X',16,' _',128 */
.balign 2,0
dc_anchor_714:
.word 3
.byte 67,79,78
.balign 2,0
.word 5
.byte 32,95
.balign 2,0
.word 448
.byte 32,88
.balign 2,0
.word 180
.byte 32,65
.balign 2,0
.word 32
.byte 32,88
.balign 2,0
.word 16
.byte 32,95
.balign 2,0
.word 128
/* QL: ;        endif */
/* QL: open_con */
open_con:
/* QL:         moveq   #sd_end+q_queue+2,d1 window def + key header + min 2 queue */
    moveq #((sd_end+q_queue)+2),d1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  8(sp),d2        get queue length (-ve lengths as unsiged!) */
    move.w 8(sp),d2
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL:         bsr.s   open_sub        open channel and initialise */
    bsr.s open_sub
/* QL:         bne.s   opn_exit */
    bne.s opn_exit
/* QL:         lea     sd_end(a0),a2   find address of queue header */
    lea sd_end(a0),a2
/* QL:         moveq   #sd_end+q_queue,d2 */
    moveq #(sd_end+q_queue),d2
/* QL:         sub.l   d2,d1           set actual length of queue */
    sub.l d2,d1
/* QL:         jsr     io_qsetl(pc)    set up queue header */
    jsr io_qsetl(pc)
/* QL:         lea     sv_keyq(a6),a3  point to keyboard queue pointer */
    lea sv_keyq(a6),a3
/* QL:         tst.l   (a3)            is this going to be the only queue? */
    tst.l (a3)
/* QL:         bne.s   link_in         no - go slot it in with the rest */
    bne.s link_in
/* QL:         move.l  a2,(a3)         make this the current queue (and link to self) */
    move.l a2,(a3)
/* QL: link_in */
link_in:
/* QL:         assert  q_nextq,0 */
/* original assertion: q_nextq,0 */
/* QL:         move.l  (a3),a3 */
    move.l (a3),a3
/* QL:         move.l  (a3),(a2)       move next queue pointer across */
    move.l (a3),(a2)
/* QL:         move.l  a2,(a3)         and link in */
    move.l a2,(a3)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.s   opn_exit */
    bra.s opn_exit
/* QL: scr */
scr:
/* QL:         jsr     io_name(pc)     check name (scr) */
    jsr io_name(pc)
/* QL:         bra.s   opn_exit        not recognised */
    bra.s opn_exit
/* QL:         bra.s   opn_exit        bad parameters */
    bra.s opn_exit
/* QL:         bra.s   open_scr        recognised!! */
    bra.s open_scr
/* QL: ;        if ntsc */
/* QL: ;        dc.w    3,'SCR',4,' _',420,' X',160,' A',46,' X',0 */
/* QL: ;        else */
/* QL:         dc.w    3,'SCR',4,' _',448,' X',180,' A',32,' X',16 */
.balign 2,0
dc_anchor_794:
.word 3
.byte 83,67,82
.balign 2,0
.word 4
.byte 32,95
.balign 2,0
.word 448
.byte 32,88
.balign 2,0
.word 180
.byte 32,65
.balign 2,0
.word 32
.byte 32,88
.balign 2,0
.word 16
/* QL: ;        endif */
/* QL: open_scr */
open_scr:
/* QL:         moveq   #sd_end+4,d1    window def + 1 dummy */
    moveq #(sd_end+4),d1
/* QL:         bsr.s   open_sub */
    bsr.s open_sub
/* QL: opn_exit */
opn_exit:
/* QL:         add.w   #5*2,sp          remove parameters from stack */
    add.w #(5*2),sp
/* QL:         rts */
    rts 
/* QL: open_sub */
open_sub:
/* QL:         jsr     mm_alchp(pc)    allocate table space */
    jsr mm_alchp(pc)
/* QL:         bne.s   ops_exit */
    bne.s ops_exit
/* QL:         move.l  d1,-(sp)        save length allocated */
    move.l d1,-(sp)
/* QL:         sub.l   a1,a1 */
    sub.l a1,a1
/* QL:         move.l  a1,a2 */
    move.l a1,a2
/* QL:         jsr     sd_setfo(pc)    set fount pointers */
    jsr sd_setfo(pc)
/* QL:         addq.b  #4,sd_icolr(a0) set ink colour to green */
    addq.b #4,sd_icolr(a0)
/* QL:         tas     sd_linel+1(a0)  set 128 bytes per line */
    tas (sd_linel+1)(a0)
/* QL:         move.l  #$807<<16!100<<(15-7),sd_scal(a0) initial scale 100.0 */
    move.l #((0x807<<16)|(100<<(15-7))),sd_scal(a0)
/* QL:         assert  $20000,ra_bot */
/* original assertion: $20000,ra_bot */
/* QL:         assert  $8000,ra_ssize */
/* original assertion: $8000,ra_ssize */
/* QL:         jsr     ip_dspm(pc)     make sure sx_dspm is up-to-date */
    jsr ip_dspm(pc)
/* QL:         move.b  sx_dspm(a4),d0 */
    move.b sx_dspm(a4),d0
/* QL:         addq.b  #ra_bot>>16,sd_scrb+1(a0) set base of first screen */
    addq.b #(ra_bot>>16),(sd_scrb+1)(a0)
/* QL:         move.l  sv_jbpnt(a6),a1 */
    move.l sv_jbpnt(a6),a1
/* QL:         move.l  (a1),a1 */
    move.l (a1),a1
/* QL:         move.w  a6,d1           are two screens available? */
    move.w a6,d1
/* QL:         btst    #0,jb_rela6(a1) and is job default screen one? (lsb set) */
    btst #0,jb_rela6(a1)
/* QL:         ble.s   setscr0         no - then we're there */
    ble.s setscr0
/* QL:         tas     sd_scrb+2(a0)   set $28000, base of second screen */
    tas (sd_scrb+2)(a0)
/* QL:         bra.s   setscr1 */
    bra.s setscr1
/* QL: setscr0 */
setscr0:
/* QL:         add.b   d0,d0           fetch up screen 0 bits */
    add.b d0,d0
/* QL: setscr1 */
setscr1:
/* QL:         move.b  sv_mcsta(a6),-(sp) hold onto the current mode */
    move.b sv_mcsta(a6),-(sp)
/* QL:         move.b  d0,sv_mcsta(a6) replace temporarily with mode 4/8 as needed */
    move.b d0,sv_mcsta(a6)
/* QL:         jsr     sd_modes(pc)    go set up mode dependent info */
    jsr sd_modes(pc)
/* QL:         clr.w   d2              no border */
    clr.w d2
/* QL:         lea     2+4+4(sp),a1    definition is on stack */
    lea ((2+4)+4)(sp),a1
/* QL:         jsr     sd_wdef(pc) */
    jsr sd_wdef(pc)
/* QL:         move.b  (sp)+,sv_mcsta(a6) restore the current mode */
    move.b (sp)+,sv_mcsta(a6)
/* QL:         move.l  (sp),d1         restore length allocated */
    move.l (sp),d1
/* QL:         move.l  d0,(sp)         save error key */
    move.l d0,(sp)
/* QL:         beq.s   ops_pop         if not zero ... */
    beq.s ops_pop
/* QL:         bsr.s   rechp           ... release space allocated */
    bsr.s rechp
/* QL: ops_pop */
ops_pop:
/* QL:         move.l  (sp)+,d0        restore error key */
    move.l (sp)+,d0
/* QL: ops_exit */
ops_exit:
/* QL:         rts */
    rts 
/* QL: close */
close:
/* QL:         lea     sd_end(a0),a3   set pointer to keyboard queue */
    lea sd_end(a0),a3
/* QL:         move.l  (a3),d1         is there one? */
    move.l (a3),d1
/* QL:         beq.s   rechp */
    beq.s rechp
/* QL:         sub.l   a2,a2           in case it's the only one */
    sub.l a2,a2
/* QL:         cmp.l   d1,a3           is it the only queue? */
    cmp.l d1,a3
/* QL:         beq.s   new_q           yes - this'll sort it out */
    beq.s new_q
/* QL:         move.l  a3,a2           now we need to unlink */
    move.l a3,a2
/* QL:         cmp.l   sv_keyq(a6),a3  is this current queue? */
    cmp.l sv_keyq(a6),a3
/* QL:         bne.s   unlk_q          no - leave the cursor alone */
    bne.s unlk_q
/* QL: more_q */
more_q:
/* QL:         move.l  (a2),a2         get next q */
    move.l (a2),a2
/* QL:         tst.b   sd_curf-sd_end(a2) is cursor of next queue active? */
    tst.b (sd_curf-sd_end)(a2)
/* QL:         bne.s   new_q           ... yes - use it */
    bne.s new_q
/* QL:         cmp.l   (a2),a3         was that the last? */
    cmp.l (a2),a3
/* QL:         bne.s   more_q          ... no - keep looking */
    bne.s more_q
/* QL: new_q */
new_q:
/* QL:         move.l  a2,sv_keyq(a6)  set new queue */
    move.l a2,sv_keyq(a6)
/* QL:         move.l  a3,a2 */
    move.l a3,a2
/* QL: unlk_q */
unlk_q:
/* QL:         move.l  (a2),a2         look at next queue */
    move.l (a2),a2
/* QL:         cmp.l   (a2),a3         does this point to queue to be closed? */
    cmp.l (a2),a3
/* QL:         bne.s   unlk_q */
    bne.s unlk_q
/* QL:         move.l  (a3),(a2)       link past this queue */
    move.l (a3),(a2)
/* QL: rechp */
rechp:
/* QL:         jsr     gw_floof(pc)    release any fill buffer! */
    jsr gw_floof(pc)
/* QL:         jmp     mm_rechp(pc)    release table space */
    jmp mm_rechp(pc)
/* QL: io.bp equ 6 makes macro simpler */
.equ io.bp,6
/* QL: io_tabl macro */
/* QL:         io_tabl pend fbyte fline fstrg edlin sbyte bp sstrg */
/* QL: io_tabl */
io_tabl:
/* QL: io_tabe setstr (io_bp-$78) */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 1-1 io.pend */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_971:
.byte (((io_pend-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 2-1 io.fbyte */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_979:
.byte (((io_fbyte-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 3-1 io.fline */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_987:
.byte (((io_fline-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 4-1 io.fstrg */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_995:
.byte (((io_fstrg-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 5-1 io.edlin */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_1003:
.byte (((io_edlin-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 6-1 io.sbyte */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_1011:
.byte (((io_sbyte-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 7-1 io.bp */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_1019:
.byte (((io_bp-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 8-1 io.sstrg */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
dc_anchor_1027:
.byte (((io_sstrg-(io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL:         assert  8 [.nparms] */
/* original assertion: 8 8 */
/* QL: * First byte of next instruction is $78, which completes the above table with */
/* QL: * a ninth entry (for entry code $08) which also goes to io_bp. */
/* QL: io */
io:
/* QL:         moveq   #sd.extop,d4    N.B. see above!!!! */
    moveq #sd.extop,d4
/* QL:         assert  1,sd.extop&7 */
/* original assertion: 1,sd.extop&7 */
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   tst_stat */
    bne.s tst_stat
/* QL:         bset    d4,sd_flags(a0) set flag bit 1 on 1st entry */
    bset d4,sd_flags(a0)
/* QL: tst_stat */
tst_stat:
/* QL:         tst.b   sv_scrst(a6)    is screen frozen? */
    tst.b sv_scrst(a6)
/* QL:         beq.s   io_chk */
    beq.s io_chk
/* QL:         moveq   #err.nc,d0      yes - operation not complete */
    moveq #err.nc,d0
/* QL:         rts */
    rts 
/* QL: io_chk */
io_chk:
/* QL:         bclr    d4,sd_flags(a0) clear flag bit 1 if we get here */
    bclr d4,sd_flags(a0)
/* QL:         sne     d7              iff it was set, set d7.b for 1st entry  */
    sne d7
/* QL:         cmp.b   d4,d0           check if normal serial i/o */
    cmp.b d4,d0
/* QL:         bhs.s   io_dirct */
    bhs.s io_dirct
/* QL:         move.w  d2,d5           set d5 to buffer length */
    move.w d2,d5
/* QL:         move.l  d1,d4           set d4 to character count (msw 0 for fline) */
    move.l d1,d4
/* QL:         cmp.b   #io.sbyte,d0    check if an input operation */
    cmp.b #(io.sbyte&255),d0
/* QL:         bcc.s   io_jump         no - ok */
    bcc.s io_jump
/* QL:         lea     sd_end(a0),a2   find address of keyboard queue */
    lea sd_end(a0),a2
/* QL:         tst.l   (a2)            check if input queue exists */
    tst.l (a2)
/* QL:         beq.s   io_bp           no - bum */
    beq.s io_bp
/* QL:         tst.b   d7              is this the first time to here? */
    tst.b d7
/* QL:         beq.s   io_jump         no - don't try to switch queues */
    beq.s io_jump
/* QL:         move.l  sv_keyq(a6),a4  yes - get current input queue */
    move.l sv_keyq(a6),a4
/* QL:         tst.b   sd_curf-sd_end(a4) is the cursor for this active? */
    tst.b (sd_curf-sd_end)(a4)
/* QL:         bne.s   io_jump */
    bne.s io_jump
/* QL:         move.l  a2,sv_keyq(a6)  no - switch to this one */
    move.l a2,sv_keyq(a6)
/* QL: io_jump */
io_jump:
/* QL:         move.l  a1,a4           buffer address in a4 */
    move.l a1,a4
/* QL:         move.b  io_tabl(pc,d0.w),d0 find code for fancy entry points */
    move.b io_tabl(pc,d0.w),d0
/* QL:         jmp     [io_tabe](pc,d0.w) */
.word 0x4efb
.word 0|(((io_bp-0x78)-.)&255)
/* QL: io_sbyte */
io_sbyte:
/* QL:         cmp.b   #10,d1          is it newline */
    cmp.b #(10&255),d1
/* QL:         beq.s   new_line */
    beq.s new_line
/* QL:         tst.b   sd_nlsta(a0)    check for out of range flag */
    tst.b sd_nlsta(a0)
/* QL:         beq.s   out_byt1 */
    beq.s out_byt1
/* QL:         move.b  d1,-(sp) */
    move.b d1,-(sp)
/* QL:         bsr.s   nl_sub */
    bsr.s nl_sub
/* QL:         move.b  (sp)+,d1 */
    move.b (sp)+,d1
/* QL: out_byt1 */
out_byt1:
/* QL:         bsr.s   sd_sbyte */
    bsr.s sd_sbyte
/* QL:         beq.s   rts_2           only error is out of range! */
    beq.s rts_2
/* QL:         move.w  sd_xinc(a0),d0  move the cursor across (not done if o/r) */
    move.w sd_xinc(a0),d0
/* QL:         add.w   d0,sd_xpos(a0) */
    add.w d0,sd_xpos(a0)
/* QL:         assert  sd..gchr,7 */
/* original assertion: sd..gchr,7 */
/* QL:         tst.b   sd_cattr(a0)    is this graphics (no auto nl?) */
    tst.b sd_cattr(a0)
/* QL:         bmi.s   out_exok */
    bmi.s out_exok
/* QL:         move.b  #1,sd_nlsta(a0) set implicit newline (rats! no reg byte > 0) */
    move.b #(1&255),sd_nlsta(a0)
/* QL:         tst.b   sd_curf(a0)     check if cursor visible */
    tst.b sd_curf(a0)
/* QL:         beq.s   out_exok        ... no it is alright */
    beq.s out_exok
/* QL: nl_sub */
nl_sub:
/* QL:         bsr.s   curoff          if cursor is visible, hide it */
    bsr.s curoff
/* QL:         moveq   #0,d0           ensure no error... sd_newl preserves this */
    moveq #0,d0
/* QL:         jmp     sd_newl(pc) */
    jmp sd_newl(pc)
/* QL: io_pend */
io_pend:
/* QL:         jmp     io_qtest(pc)    check this queue */
    jmp io_qtest(pc)
/* QL: io_sslop */
io_sslop:
/* QL:         move.b  (a4)+,d1        get character */
    move.b (a4)+,d1
/* QL:         bsr.s   io_sbyte        write it */
    bsr.s io_sbyte
/* QL:         addq.w  #1,d4 */
    addq.w #1,d4
/* QL: io_sstrg */
io_sstrg:
/* QL:         cmp.w   d4,d5           end of buffer? */
    cmp.w d4,d5
/* QL:         bne.s   io_sslop        nope - go send it */
    bne.s io_sslop
/* QL:         bra.s   io_ok */
    bra.s io_ok
/* QL: sd_sbyte */
sd_sbyte:
/* QL:         moveq   #io.sbyte,d0    send byte */
    moveq #io.sbyte,d0
/* QL: io_dirct */
io_dirct:
/* QL:         jmp     sd_entry(pc)    use screen driver */
    jmp sd_entry(pc)
/* QL: io_bp */
io_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         bra.s   io_mexit */
    bra.s io_mexit
/* QL: new_line */
new_line:
/* QL:         tst.b   sd_nlsta(a0)    test newline pending */
    tst.b sd_nlsta(a0)
/* QL:         bge.s   new_exp         ... it was not explicit before */
    bge.s new_exp
/* QL:         bsr.s   nl_sub          a new line was pending so do it */
    bsr.s nl_sub
/* QL: new_exp */
new_exp:
/* QL:         st      sd_nlsta(a0)    ... and this one is explicit */
    st sd_nlsta(a0)
/* QL: out_exok */
out_exok:
/* QL:         moveq   #0,d0           no error - newline given or done */
    moveq #0,d0
/* QL: rts_2 */
rts_2:
/* QL:         rts */
    rts 
/* QL: io_fbyte */
io_fbyte:
/* QL:         lea     sd_end(a0),a2   a2 is io_q.. queue pointer */
    lea sd_end(a0),a2
/* QL:         jmp     io_qout(pc) */
    jmp io_qout(pc)
/* QL: io_fslop */
io_fslop:
/* QL:         bsr.s   io_fbyte        get next character */
    bsr.s io_fbyte
/* QL:         bne.s   io_mexit        is it available? */
    bne.s io_mexit
/* QL:         move.b  d1,(a4)+        put in buffer */
    move.b d1,(a4)+
/* QL:         addq.w  #1,d4 */
    addq.w #1,d4
/* QL: io_fstrg */
io_fstrg:
/* QL:         cmp.w   d4,d5           check for end of buffer */
    cmp.w d4,d5
/* QL:         bne.s   io_fslop */
    bne.s io_fslop
/* QL: io_ok */
io_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: io_mexit */
io_mexit:
/* QL:         move.w  d4,d1           set character count */
    move.w d4,d1
/* QL:         move.l  a4,a1           save buffer pointer */
    move.l a4,a1
/* QL:         bclr    #sd..gchr,sd_cattr(a0) reset normal character positioning */
    bclr #sd..gchr,sd_cattr(a0)
/* QL:         rts */
    rts 
/* QL: curoff */
curoff:
/* QL:         tst.b   sd_curf(a0) */
    tst.b sd_curf(a0)
/* QL:         ble.s   rts_2 */
    ble.s rts_2
/* QL:         jmp     sd_curt(pc)     toggle the cursor */
    jmp sd_curt(pc)
/* QL: * During edlin/fline: */
/* QL: * d0 returned error code only */
/* QL: * d4.msw -1=edlin, 0=fline */
/* QL: * d4.lsw current count of valid chars in buffer ( < d5.lsw, except at end ) */
/* QL: * d5.msw not used (zero, at present) */
/* QL: * d5.lsw screen offset of start of buffer (-ve = off top of screen) */
/* QL: * d6.msw not used (undefined, could easily be 0) */
/* QL: * d6.lsw cursor position within buffer ( <= d4.lsw ) */
/* QL: * a0 chan / a2 queue ptr */
/* QL: * a4 start of buffer */
/* QL: * a5 stack frame pointer to screen info */
/* QL: * d1-d3/a1-a3 destroyed */
/* QL: io_edlin */
io_edlin:
/* QL:         moveq   #-1,d4          for edlin set flag in msb of d4 */
    moveq #(-1),d4
/* QL: io_fline        ;               n.b. ioss set d1.l to 0 before fline entry */
io_fline:
/* QL:         move.l  d1,d6           get the cursor position */
    move.l d1,d6
/* QL:         swap    d6 */
    swap d6
/* QL:         move.w  d1,d4           to be safe, refuse chars > 32767 ... */
    move.w d1,d4
/* QL:         bmi.s   io_bp */
    bmi.s io_bp
/* QL:         cmp.w   d4,d5           ... or chars so far > buffer length ... */
    cmp.w d4,d5
/* QL:         blt.s   io_bp */
    blt.s io_bp
/* QL:         cmp.w   d6,d4           ... or cursor > chars so far */
    cmp.w d6,d4
/* QL:         bcs.s   io_bp */
    bcs.s io_bp
/* QL:         sub.w   d4,a4           reset buff pointer to base */
    sub.w d4,a4
/* QL:         move.w  d5,-(sp)        save buffer length */
    move.w d5,-(sp)
/* QL:         move.b  sd_curf(a0),-(sp) save state of cursor */
    move.b sd_curf(a0),-(sp)
/* QL:         tst.b   d7              is this the first time we've got this far? */
    tst.b d7
/* QL:         beq.s   ed_next         no - skip this stuff */
    beq.s ed_next
/* QL:         bsr.s   curoff          if cursor is visible, hide it */
    bsr.s curoff
/* QL:         jsr     sd_donl(pc)     *** this should probably be somewhere else */
    jsr sd_donl(pc)
/* QL: ed_next */
ed_next:
/* QL:         move.b  d7,d1           1st time in? */
    move.b d7,d1
/* QL:         bne.s   ed_gotc         yes: use alt prefix as redraw, nice for startup */
    bne.s ed_gotc
/* QL:         bsr.s   io_fbyte        fetch byte from input queue */
    bsr.s io_fbyte
/* QL:         beq.s   ed_gotc         something there */
    beq.s ed_gotc
/* QL:         tst.b   (sp)            check state of cursor */
    tst.b (sp)
/* QL:         blt.s   ed_exit         it is meant to be invisible */
    blt.s ed_exit
/* QL:         move.l  d0,-(sp) */
    move.l d0,-(sp)
/* QL:         jsr     sd_cure(pc)     enable the cursor */
    jsr sd_cure(pc)
/* QL:         move.l  (sp)+,d0         */
    move.l (sp)+,d0
/* QL: ed_exit */
ed_exit:
/* QL:         add.w   d4,a4           set a4 to end of line */
    add.w d4,a4
/* QL:         move.w  d6,d1           save the cursor position */
    move.w d6,d1
/* QL:         swap    d1 */
    swap d1
/* QL:         addq.l  #4,sp           get rid of cursor status and save max len */
    addq.l #4,sp
/* QL:         bra.s   io_mexit */
    bra.s io_mexit
/* QL: ed_gotc */
ed_gotc:
/* QL:         bsr.s   curoff          ensure cursor is off */
    bsr.s curoff
/* QL: * create stack frame with all details on current position and screen size */
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         lea     sd_xinc(a0),a1 */
    lea sd_xinc(a0),a1
/* QL: enqset */
enqset:
/* QL:         move.l  d0,d2 */
    move.l d0,d2
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         moveq   #0,d5 */
    moveq #0,d5
/* QL:         move.w  sd_xsize-sd_xinc(a1),d5 */
    move.w (sd_xsize-sd_xinc)(a1),d5
/* QL:         move.w  sd_xpos-sd_xinc(a1),d0 */
    move.w (sd_xpos-sd_xinc)(a1),d0
/* QL:         bpl.s   enqlft */
    bpl.s enqlft
/* QL:         clr.w   d0              pull in from off left of screen */
    clr.w d0
/* QL: enqlft */
enqlft:
/* QL:         sub.w   d0,d5 */
    sub.w d0,d5
/* QL:         bpl.s   enqrgt */
    bpl.s enqrgt
/* QL:         add.w   d5,d0 */
    add.w d5,d0
/* QL:         clr.w   d5              pull in from off right of screen */
    clr.w d5
/* QL: enqrgt */
enqrgt:
/* QL:         divu    (a1),d0 */
    divu (a1),d0
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         divu    (a1)+,d5 */
    divu (a1)+,d5
/* QL:         add.w   d5,d0 */
    add.w d5,d0
/* QL:         bne.s   enqok */
    bne.s enqok
/* QL:         moveq   #1,d0           protect against silly windows/cursors! */
    moveq #1,d0
/* QL: enqok */
enqok:
/* QL:         not.b   d3 */
    not.b d3
/* QL:         bne.s   enqset */
    bne.s enqset
/* QL: * d0=dy/height, d2=dx/width, (sp)=row, 2(sp)=col */
/* QL:         move.w  (sp)+,d5        pick off row */
    move.w (sp)+,d5
/* QL:         mulu    d2,d5 */
    mulu d2,d5
/* QL:         move.w  (sp)+,a2        pick off col */
    move.w (sp)+,a2
/* QL:         add.w   a2,d5           width*row+col = screen loc of cursor */
    add.w a2,d5
/* QL:         sub.w   d6,d5           screen loc of start of buff, signed */
    sub.w d6,d5
/* QL:         move.w  d2,d3 */
    move.w d2,d3
/* QL:         swap    d2 */
    swap d2
/* QL:         mulu    d0,d3 */
    mulu d0,d3
/* QL:         move.w  d3,d0 */
    move.w d3,d0
/* QL:         move.l  d0,-(sp)        save dy,size */
    move.l d0,-(sp)
/* QL:         assert  4,dy,size-2 */
/* original assertion: 4,dy,size-2 */
/* QL:         move.l  d2,-(sp)        save width,dx */
    move.l d2,-(sp)
/* QL:         assert  0,width,dx-2 */
/* original assertion: 0,width,dx-2 */
/* QL:         move.l  sp,a5           mark the frame */
    move.l sp,a5
/* QL: * Stack frame now active */
/* QL:         lea     edittabl,a1 */
    lea edittabl(pc),a1
/* QL: ed_tloop */
ed_tloop:
/* QL:         move.w  (a1)+,d0        fetch table bytes: msb=jmp/2, lsb=topchar */
    move.w (a1)+,d0
/* QL:         sub.b   d1,d0           is the character > lsb byte of entry? */
    sub.b d1,d0
/* QL:         bcs.s   ed_tloop        yes, continue scan */
    bcs.s ed_tloop
/* QL:         lsr.w   #8,d0           pull down execute vector byte */
    lsr.w #8,d0
/* QL:         add.b   d0,d0 */
    add.b d0,d0
/* QL:         subx.l  d7,d7           put delete flag into d7 ms bits */
    subx.l d7,d7
/* QL:         lea     0(a4,d6.w),a1   pointer to cursor byte */
    lea 0(a4,d6.w),a1
/* QL:         moveq   #' ',d2         for word searches */
    moveq #32,d2
/* QL:         move.w  d6,d7           set convenient initial value for d7.lsw */
    move.w d6,d7
/* QL:         jsr     dis_base(pc,d0.w) go action the byte */
    jsr dis_base(pc,d0.w)
/* QL:         bsr.s   ed_exec1 */
    bsr.s ed_exec1
/* QL:         addq.l  #frame,sp       lose stack frame */
    addq.l #frame,sp
/* QL:         moveq   #err.bo,d0      in case buffer has become full */
    moveq #err.bo,d0
/* QL:         asl.l   #8,d7           clear 1st time flag and test exit flag */
    asl.l #8,d7
/* QL:         bvc.l   ed_next         still all ones or zeroes, that's fine */
    bvc.w ed_next
/* QL: ed_exitp */
ed_exitp:
/* QL:         bpl.s   ed_exit         buffer is full */
    bpl.s ed_exit
/* QL:         addq.w  #1,d4           terminator present */
    addq.w #1,d4
/* QL:         jsr     sd_curs(pc)     get rid of cursor */
    jsr sd_curs(pc)
/* QL:         bsr.l   new_line  */
    bsr.w new_line
/* QL:         clr.w   d6 */
    clr.w d6
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.s   ed_exitp */
    bra.s ed_exitp
/* QL: dis_base */
dis_base:
/* QL: dis_entr */
dis_entr:
/* QL:         moveq   #10,d1          convert shift/enter to normal enter */
    moveq #10,d1
/* QL: dis_endr */
dis_endr:
/* QL:         move.b  d1,0(a4,d4.w)   store terminator in final byte */
    move.b d1,0(a4,d4.w)
/* QL:         bset    #31-8,d7        cause termination after positioning */
    bset #(31-8),d7
/* QL:         bra.s   dis_allr        move cursor across rest of line */
    bra.s dis_allr
/* QL: dis_escp */
dis_escp:
/* QL:         tst.l   d4 */
    tst.l d4
/* QL:         bmi.s   dis_endr */
    bmi.s dis_endr
/* QL:         bra.s   dis_ignr        change up/down/esc to ignore for fline */
    bra.s dis_ignr
/* QL: dis_rowl */
dis_rowl:
/* QL:         cmp.w   a2,d6 */
    cmp.w a2,d6
/* QL:         ble.s   dis_escp */
    ble.s dis_escp
/* QL:         sub.w   width(a5),d7 */
    sub.w width(a5),d7
/* QL:         bge.s   dis_sbc */
    bge.s dis_sbc
/* QL: dis_alll */
dis_alll:
/* QL:         clr.w   d7 */
    clr.w d7
/* QL:         bra.s   dis_sbc */
    bra.s dis_sbc
/* QL: dis_rowr */
dis_rowr:
/* QL:         add.w   d4,a2 */
    add.w d4,a2
/* QL:         sub.w   width(a5),a2 */
    sub.w width(a5),a2
/* QL:         cmp.w   a2,d6           is cursor going to go down off line with eod? */
    cmp.w a2,d6
/* QL:         bgt.s   dis_escp        yes: go check for edlin termination */
    bgt.s dis_escp
/* QL:         add.w   width(a5),d7    move whole row */
    add.w width(a5),d7
/* QL:         bra.s   dis_rgt         go check if we need to trim it to eod */
    bra.s dis_rgt
/* QL: dis_onel */
dis_onel:
/* QL:         beq.s   dis_rts */
    beq.s dis_rts
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bra.s   dis_sbc */
    bra.s dis_sbc
/* QL: dis_oner */
dis_oner:
/* QL:         addq.w  #1,d7 */
    addq.w #1,d7
/* QL:         bra.s   dis_rgt */
    bra.s dis_rgt
/* QL: dis_tabl */
dis_tabl:
/* QL:         beq.s   dis_rts */
    beq.s dis_rts
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bra.s   dis_tabx */
    bra.s dis_tabx
/* QL: dis_tabr */
dis_tabr:
/* QL:         addq.w  #8,d7 */
    addq.w #8,d7
/* QL: dis_tabx */
dis_tabx:
/* QL:         and.w   #-8,d7 */
    and.w #(-8),d7
/* QL: dis_rgt */
dis_rgt:
/* QL:         cmp.w   d4,d7 */
    cmp.w d4,d7
/* QL:         ble.s   dis_sbc */
    ble.s dis_sbc
/* QL: dis_allr */
dis_allr:
/* QL:         move.w  d4,d7 */
    move.w d4,d7
/* QL: dis_ignr */
dis_ignr:
/* QL: dis_sbc */
dis_sbc:
/* QL:         sub.w   d6,d7 */
    sub.w d6,d7
/* QL: dis_rts */
dis_rts:
/* QL:         rts */
    rts 
/* QL: ed_exec1 */
ed_exec1:
/* QL:         bra.s   ed_exec */
    bra.s ed_exec
/* QL: dis_spac */
dis_spac:
/* QL:         moveq   #' ',d1         change shift/space to ordinary space */
    moveq #32,d1
/* QL: dis_char */
dis_char:
/* QL:         bsr.s   dis_allr        tail end char count */
    bsr.s dis_allr
/* QL:         add.w   d7,a1           start at top of buffer */
    add.w d7,a1
/* QL:         bra.s   ins_ent */
    bra.s ins_ent
/* QL: dis_wrdl */
dis_wrdl:
/* QL: wrdls */
wrdls:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   wrdx */
    bcs.s wrdx
/* QL:         cmp.b   -(a1),d2 */
    cmp.b -(a1),d2
/* QL:         beq.s   wrdls */
    beq.s wrdls
/* QL: wrdln */
wrdln:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   wrdx */
    bcs.s wrdx
/* QL:         cmp.b   -(a1),d2 */
    cmp.b -(a1),d2
/* QL:         bne.s   wrdln */
    bne.s wrdln
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         bra.s   wrdx */
    bra.s wrdx
/* QL: dis_wrdr */
dis_wrdr:
/* QL:         bsr.s   dis_allr */
    bsr.s dis_allr
/* QL: wrdrn */
wrdrn:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   wrdx */
    bcs.s wrdx
/* QL:         cmp.b   (a1)+,d2 */
    cmp.b (a1)+,d2
/* QL:         bne.s   wrdrn */
    bne.s wrdrn
/* QL: wrdrs */
wrdrs:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   wrdx */
    bcs.s wrdx
/* QL:         cmp.b   (a1)+,d2 */
    cmp.b (a1)+,d2
/* QL:         beq.s   wrdrs */
    beq.s wrdrs
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL: wrdx */
wrdx:
/* QL:         move.w  a1,d7 */
    move.w a1,d7
/* QL:         sub.w   a4,d7 */
    sub.w a4,d7
/* QL:         bra.s   dis_sbc */
    bra.s dis_sbc
/* QL: ins_lp */
ins_lp:
/* QL:         move.b  -(a1),1(a1) */
    move.b -(a1),1(a1)
/* QL: ins_ent */
ins_ent:
/* QL:         dbra    d7,ins_lp */
    dbra d7,ins_lp
/* QL:         move.b  d1,(a1)         insert new char at cursor */
    move.b d1,(a1)
/* QL:         addq.w  #1,d4           add this into buffer count */
    addq.w #1,d4
/* QL:         move.w  d4,d7 */
    move.w d4,d7
/* QL:         add.w   d5,d7 */
    add.w d5,d7
/* QL:         move.w  d6,d0 */
    move.w d6,d0
/* QL:         add.w   d5,d0 */
    add.w d5,d0
/* QL:         bsr.s   redraw1         write to end of data (or end of screen) */
    bsr.s redraw1
/* QL:         moveq   #1,d7           force finish up with position right one */
    moveq #1,d7
/* QL:         rts                     if buffer is full it'll catch it after this */
    rts 
/* QL: ed_exec */
ed_exec:
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         bpl.s   op_move */
    bpl.s op_move
/* QL: * Delete */
/* QL:         move.w  d5,d3 */
    move.w d5,d3
/* QL:         add.w   d4,d3           offset to end of displayed/displayable data */
    add.w d4,d3
/* QL:         tst.w   d7              check distance for delete left/right */
    tst.w d7
/* QL:         bpl.s   op_bdel */
    bpl.s op_bdel
/* QL:         neg.w   d7              make delete left distance positive */
    neg.w d7
/* QL:         sub.w   d7,d6           new cursor for delete left */
    sub.w d7,d6
/* QL: op_bdel */
op_bdel:
/* QL:         sub.w   d7,d4           less chars in buffer */
    sub.w d7,d4
/* QL:         lea     0(a4,d6.w),a1   char destination */
    lea 0(a4,d6.w),a1
/* QL:         move.w  d4,d0 */
    move.w d4,d0
/* QL:         sub.w   d6,d0           chars to be shifted down in buffer */
    sub.w d6,d0
/* QL:         bra.s   op_bdent */
    bra.s op_bdent
/* QL: op_bdlp */
op_bdlp:
/* QL:         move.b  0(a1,d7.w),(a1)+ pack buffer chars down */
    move.b 0(a1,d7.w),(a1)+
/* QL: op_bdent */
op_bdent:
/* QL:         dbra    d0,op_bdlp */
    dbra d0,op_bdlp
/* QL:         move.w  d3,d7           set old eod */
    move.w d3,d7
/* QL:         move.w  d6,d0 */
    move.w d6,d0
/* QL:         add.w   d5,d0           start display here, maybe */
    add.w d5,d0
/* QL:         bpl.s   redraw          ready now if cursor is staying on screen */
    bpl.s redraw
/* QL:         not.w   d0 */
    not.w d0
/* QL:         ext.l   d0 */
    ext.l d0
/* QL:         divu    width(a5),d0    rows that need pulling in, less one */
    divu width(a5),d0
/* QL:         addq.w  #1,d0 */
    addq.w #1,d0
/* QL:         mulu    width(a5),d0    total to adjust base by */
    mulu width(a5),d0
/* QL:         add.w   d0,d5           pull base up */
    add.w d0,d5
/* QL:         move.w  d4,d3 */
    move.w d4,d3
/* QL:         add.w   d5,d3           new eod */
    add.w d5,d3
/* QL:         cmp.w   d3,d7           is it now further down than the old one? */
    cmp.w d3,d7
/* QL:         bge.s   redeodok */
    bge.s redeodok
/* QL:         move.w  d3,d7           yes, so use new eod */
    move.w d3,d7
/* QL: redeodok */
redeodok:
/* QL:         assert  2,dy-dx,sd_ypos-sd_xpos */
/* original assertion: 2,dy-dx,sd_ypos-sd_xpos */
/* QL:         move.l  dx(a5),sd_xpos(a0) */
    move.l dx(a5),sd_xpos(a0)
/* QL:         moveq   #sd.scrtp,d0    clean up top row scrap, maybe */
    moveq #sd.scrtp,d0
/* QL:         bsr.s   scrxx */
    bsr.s scrxx
/* QL: *       clr.w   d0              need to display from start of screen */
/* QL: redraw1 */
redraw1:
/* QL:         bra.s   redraw */
    bra.s redraw
/* QL: op_move */
op_move:
/* QL:         add.w   d7,d6           go straight to new cursor position */
    add.w d7,d6
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.w  d6,d1 */
    move.w d6,d1
/* QL:         add.w   d5,d1 */
    add.w d5,d1
/* QL:         bmi.s   op_scrdn        have to scroll screen down to get cursor on */
    bmi.s op_scrdn
/* QL:         clr.w   d0 */
    clr.w d0
/* QL:         sub.w   size(a5),d1 */
    sub.w size(a5),d1
/* QL:         blt.s   op_noscr */
    blt.s op_noscr
/* QL: * We need to display the cursor, so we'll have to scroll up some */
/* QL:         divu    width(a5),d1 */
    divu width(a5),d1
/* QL:         addq.w  #1,d1           this number of rows */
    addq.w #1,d1
/* QL:         bsr.s   negscrol */
    bsr.s negscrol
/* QL:         move.w  d1,d0 */
    move.w d1,d0
/* QL: op_noscr */
op_noscr:
/* QL:         move.w  size(a5),d7 */
    move.w size(a5),d7
/* QL:         add.w   d7,d0 */
    add.w d7,d0
/* QL:         bra.s   redraw */
    bra.s redraw
/* QL: negscrol */
negscrol:
/* QL:         neg.w   d1 */
    neg.w d1
/* QL: scrol */
scrol:
/* QL:         moveq   #sd.scrol,d0 */
    moveq #sd.scrol,d0
/* QL: scrxx */
scrxx:
/* QL:         move.w  d1,-(sp) */
    move.w d1,-(sp)
/* QL:         muls    sd_yinc(a0),d1 */
    muls sd_yinc(a0),d1
/* QL:         jsr     sd_scrol(pc)   do the scroll */
    jsr sd_scrol(pc)
/* QL:         move.w  (sp)+,d1 */
    move.w (sp)+,d1
/* QL:         muls    width(a5),d1 */
    muls width(a5),d1
/* QL:         add.w   d1,d5 */
    add.w d1,d5
/* QL:         rts */
    rts 
/* QL: op_scrdn */
op_scrdn:
/* QL:         not.w   d1 */
    not.w d1
/* QL:         divu    width(a5),d1 */
    divu width(a5),d1
/* QL:         addq.w  #1,d1           this number of rows */
    addq.w #1,d1
/* QL:         bsr.s   scrol */
    bsr.s scrol
/* QL: *       clr.w   d0 */
/* QL:         move.w  d1,d7 */
    move.w d1,d7
/* QL: *       bra.s   redraw          draw that */
/* QL: * Draw any amount of the screen, includes final position to cursor */
/* QL: * d0 start screen offset */
/* QL: * d4 eod */
/* QL: * d5 buffer screen offset */
/* QL: * d6 cursor */
/* QL: * d7 end screen offset */
/* QL: redraw */
redraw:
/* QL:         move.w  d6,-(sp) */
    move.w d6,-(sp)
/* QL:         add.w   d5,d4 */
    add.w d5,d4
/* QL:         add.w   d5,d6 */
    add.w d5,d6
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         cmp.w   d6,d1           is cursor supposed to be at eod? */
    cmp.w d6,d1
/* QL:         beq.s   redecur */
    beq.s redecur
/* QL:         subq.w  #1,d1           no - so relax a bit (signed arith on this now!) */
    subq.w #1,d1
/* QL: redecur */
redecur:
/* QL:         sub.w   size(a5),d1 */
    sub.w size(a5),d1
/* QL:         add.w   width(a5),d1 */
    add.w width(a5),d1
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         divs    width(a5),d1    we'd like to scroll up this many rows */
    divs width(a5),d1
/* QL:         ext.l   d6 */
    ext.l d6
/* QL:         divs    width(a5),d6    this is how many rows we can scroll up */
    divs width(a5),d6
/* QL:         cmp.w   d6,d1 */
    cmp.w d6,d1
/* QL:         ble.s   redscrl */
    ble.s redscrl
/* QL:         move.w  d6,d1           at most, push cursor to top row */
    move.w d6,d1
/* QL: redscrl */
redscrl:
/* QL:         tst.w   d1 */
    tst.w d1
/* QL:         ble.s   redscrex        either we couldn't, or didn't want to scroll! */
    ble.s redscrex
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         bsr.s   negscrol */
    bsr.s negscrol
/* QL:         move.w  (sp)+,d0 */
    move.w (sp)+,d0
/* QL:         add.w   d1,d0 */
    add.w d1,d0
/* QL:         add.w   d1,d4 */
    add.w d1,d4
/* QL:         move.w  d4,d7           we must now want to show to eod */
    move.w d4,d7
/* QL: redscrex */
redscrex:
/* QL:         move.w  d0,d6 */
    move.w d0,d6
/* QL:         bpl.s   redent */
    bpl.s redent
/* QL:         clr.w   d6 */
    clr.w d6
/* QL: redloop */
redloop:
/* QL:         cmp.w   size(a5),d6 */
    cmp.w size(a5),d6
/* QL:         bcc.s   redlast */
    bcc.s redlast
/* QL:         moveq   #5,d0           clear space at end */
    moveq #5,d0
/* QL:         lea     sd_clrxx(pc),a1 new call: lets us wipe space to paper colour */
    lea sd_clrxx(pc),a1
/* QL:         cmp.w   d4,d6 */
    cmp.w d4,d6
/* QL:         bge.s   redgo           after eod must want clearing */
    bge.s redgo
/* QL:         move.w  d6,d1 */
    move.w d6,d1
/* QL:         sub.w   d5,d1 */
    sub.w d5,d1
/* QL:         blt.s   redgo           before start of data must want clearing */
    blt.s redgo
/* QL:         lea     sd_sbyte,a1 */
    lea sd_sbyte(pc),a1
/* QL:         move.b  0(a4,d1.w),d1   get a real data byte to display */
    move.b 0(a4,d1.w),d1
/* QL: redgo */
redgo:
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  d6,d2 */
    move.w d6,d2
/* QL:         divu    width(a5),d2 */
    divu width(a5),d2
/* QL:         move.w  d2,d3 */
    move.w d2,d3
/* QL:         lea     sd_yinc(a0),a2 */
    lea sd_yinc(a0),a2
/* QL:         mulu    (a2),d3 */
    mulu (a2),d3
/* QL:         swap    d2 */
    swap d2
/* QL:         assert  sd_xpos,sd_ypos-2,sd_xinc-4,sd_yinc-6 */
/* original assertion: sd_xpos,sd_ypos-2,sd_xinc-4,sd_yinc-6 */
/* QL:         mulu    -(a2),d2 */
    mulu -(a2),d2
/* QL:         swap    d2 */
    swap d2
/* QL:         move.w  d3,d2 */
    move.w d3,d2
/* QL:         add.l   dx(a5),d2 */
    add.l dx(a5),d2
/* QL:         assert  dx,dy-2 */
/* original assertion: dx,dy-2 */
/* QL:         move.l  d2,-(a2)        store calculated cursor position */
    move.l d2,-(a2)
/* QL:         jsr     (a1)            clear char to paper, draw real char or get out */
    jsr (a1)
/* QL:         addq.w  #1,d6 */
    addq.w #1,d6
/* QL: redent */
redent:
/* QL:         cmp.w   d7,d6 */
    cmp.w d7,d6
/* QL:         blt.s   redloop */
    blt.s redloop
/* QL: redlast */
redlast:
/* QL:         lea     redstop,a1 */
    lea redstop(pc),a1
/* QL:         move.w  (sp)+,d6 */
    move.w (sp)+,d6
/* QL:         add.w   d5,d6 */
    add.w d5,d6
/* QL:         bra.s   redgo */
    bra.s redgo
/* QL: redstop */
redstop:
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         sub.w   d5,d6 */
    sub.w d5,d6
/* QL:         sub.w   d5,d4 */
    sub.w d5,d4
/* QL:         cmp.w   buflen(a5),d4   is the buffer full yet? */
    cmp.w buflen(a5),d4
/* QL:         bne.s   redok           no - we're ok */
    bne.s redok
/* QL:         moveq   #1,d7 */
    moveq #1,d7
/* QL:         ror.l   #1,d7           $80000000 for buffer overflow */
    ror.l #1,d7
/* QL: redok */
redok:
/* QL:         rts */
    rts 
/* QL: flg.del equ     $8000           flag for deletion (or initial re-display) */
.equ flg.del,0x8000
/* QL: flg.    equ     0               no flag */
.equ flg.,0
/* QL: cno setnum 0 */
/* QL:  assert 0 (dis_ignr-dis_base)&$ff01 */
/* original assertion: 0 (dis_ignr-dis_base)&$ff01 */
/* QL: ed macro chr,dis,del */
/* QL: edittabl */
edittabl:
/* QL:  ed $09 tabr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_1997:
.word (((((dis_ignr-dis_base)<<7)|flg.)|(0x09-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_tabr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2006:
.word (((((dis_tabr-dis_base)<<7)|flg.)|0x09))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $0a entr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_entr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2018:
.word (((((dis_entr-dis_base)<<7)|flg.)|0x0a))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $1b escp */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2025:
.word (((((dis_ignr-dis_base)<<7)|flg.)|(0x1b-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_escp-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2034:
.word (((((dis_escp-dis_base)<<7)|flg.)|0x1b))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $20 char */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2041:
.word (((((dis_ignr-dis_base)<<7)|flg.)|(0x20-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: chr setnum $c0-1 */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_char-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2051:
.word (((((dis_char-dis_base)<<7)|flg.)|191))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c0 onel */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_onel-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2063:
.word (((((dis_onel-dis_base)<<7)|flg.)|0xc0))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c1 alll */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_alll-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2075:
.word (((((dis_alll-dis_base)<<7)|flg.)|0xc1))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c2 onel del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_onel-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2087:
.word (((((dis_onel-dis_base)<<7)|flg.del)|0xc2))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c3 alll del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_alll-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2099:
.word (((((dis_alll-dis_base)<<7)|flg.del)|0xc3))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c4 wrdl */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_wrdl-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2111:
.word (((((dis_wrdl-dis_base)<<7)|flg.)|0xc4))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c6 wrdl del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2118:
.word (((((dis_ignr-dis_base)<<7)|flg.del)|(0xc6-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_wrdl-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2127:
.word (((((dis_wrdl-dis_base)<<7)|flg.del)|0xc6))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c8 oner */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2134:
.word (((((dis_ignr-dis_base)<<7)|flg.)|(0xc8-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_oner-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2143:
.word (((((dis_oner-dis_base)<<7)|flg.)|0xc8))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c9 allr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_allr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2155:
.word (((((dis_allr-dis_base)<<7)|flg.)|0xc9))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $ca oner del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_oner-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2167:
.word (((((dis_oner-dis_base)<<7)|flg.del)|0xca))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $cb allr del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_allr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2179:
.word (((((dis_allr-dis_base)<<7)|flg.del)|0xcb))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $cc wrdr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_wrdr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2191:
.word (((((dis_wrdr-dis_base)<<7)|flg.)|0xcc))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $ce wrdr del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2198:
.word (((((dis_ignr-dis_base)<<7)|flg.del)|(0xce-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_wrdr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2207:
.word (((((dis_wrdr-dis_base)<<7)|flg.del)|0xce))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $d0 rowl */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2214:
.word (((((dis_ignr-dis_base)<<7)|flg.)|(0xd0-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_rowl-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2223:
.word (((((dis_rowl-dis_base)<<7)|flg.)|0xd0))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $d8 rowr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2230:
.word (((((dis_ignr-dis_base)<<7)|flg.)|(0xd8-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_rowr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2239:
.word (((((dis_rowr-dis_base)<<7)|flg.)|0xd8))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $fc spac */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (dis_ignr-dis_base)<<7!flg.[del]!([chr]-1) */
.balign 2,0
dc_anchor_2246:
.word (((((dis_ignr-dis_base)<<7)|flg.)|(0xfc-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_spac-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2255:
.word (((((dis_spac-dis_base)<<7)|flg.)|0xfc))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $fd tabl */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_tabl-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2267:
.word (((((dis_tabl-dis_base)<<7)|flg.)|0xfd))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $fe entr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_entr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2279:
.word (((((dis_entr-dis_base)<<7)|flg.)|0xfe))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $ff ignr del ; alt cheats a bits. Initial entry uses it. Shorter macro def. */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-dis_base)&$ff01 */
/* original assertion: 0 (dis_ignr-dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-dis_base)<<7!flg.[del]![chr] */
.balign 2,0
dc_anchor_2291:
.word (((((dis_ignr-dis_base)<<7)|flg.del)|0xff))&65535
/* QL: cno setnum [chr]+1 */
/* QL:         end */
