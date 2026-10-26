/* Generated from original/M/bp/misc.asm */
/* QL: * Various odd basic procedures */
/* QL:         xdef    bp_baud,bp_call,bp_mode,bp_net,bp_rande,bp_repot,bp_tra */
.globl bp_baud,bp_call,bp_mode,bp_net,bp_rande,bp_repot,bp_tra
/* QL:         xref    bp_chand */
/* QL: *        xref    bv_chri */
/* QL:         xref    ca_gtin1,ca_gtint,ca_gtlin */
/* QL:         xref    ib_errep */
/* QL: *        xref    mm_clrr */
/* QL:         xref    ut_err */
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
/* QL:         include 'win1_m_inc_bv' */
/* QL: * pointers to basic variable lists and stacks */
/* QL:          nolist */
/* QL:         offset  0 */
/* QL: bv_start ; start of area and pointers */
.equ bv_start,0
/* QL: bv_bfbas ds.l   1       buffer base */
.equ bv_bfbas,0
/* QL: bv_bfp  ds.l    1       buffer running pointer */
.equ bv_bfp,4
/* QL: bv_tkbas ds.l   1       token list */
.equ bv_tkbas,8
/* QL: bv_tkp  ds.l    1 */
.equ bv_tkp,12
/* QL: bv_pfbas ds.l   1       program file */
.equ bv_pfbas,16
/* QL: bv_pfp  ds.l    1 */
.equ bv_pfp,20
/* QL: bv_ntbas ds.l   1       name table */
.equ bv_ntbas,24
/* QL: bv_ntp  ds.l    1 */
.equ bv_ntp,28
/* QL: bv_nlbas ds.l   1       name list */
.equ bv_nlbas,32
/* QL: bv_nlp  ds.l    1 */
.equ bv_nlp,36
/* QL: bv_vvbas ds.l   1       variable values */
.equ bv_vvbas,40
/* QL: bv_vvp  ds.l    1 */
.equ bv_vvp,44
/* QL: bv_chbas ds.l   1       channel table */
.equ bv_chbas,48
/* QL: bv_chp  ds.l    1 */
.equ bv_chp,52
/* QL: bv_rtbas ds.l   1       return table */
.equ bv_rtbas,56
/* QL: bv_rtp  ds.l    1 */
.equ bv_rtp,60
/* QL: bv_lnbas ds.l   1       line number table */
.equ bv_lnbas,64
/* QL: bv_lnp  ds.l    1 */
.equ bv_lnp,68
/* QL: bv_chang ; change of direction marker */
.equ bv_chang,72
/* QL: bv_btp  ds.l    1       backtrack stack during parsing */
.equ bv_btp,72
/* QL: bv_btbas ds.l   1 */
.equ bv_btbas,76
/* QL: bv_tgp  ds.l    1       temporary graph stack during parsing */
.equ bv_tgp,80
/* QL: bv_tgbas ds.l   1 */
.equ bv_tgbas,84
/* QL: bv_rip  ds.l    1       arithmetic stack */
.equ bv_rip,88
/* QL: bv_ribas ds.l   1 */
.equ bv_ribas,92
/* QL: bv_ssp  ds.l    1       system stack (real one!) */
.equ bv_ssp,96
/* QL: bv_ssbas ds.l   1 */
.equ bv_ssbas,100
/* QL: bv_endpt equ *-4 last of pointers */
.equ bv_endpt,(104-4)
/* QL: bv_linum ds.w   1       current line number */
.equ bv_linum,104
/* QL: bv_lengt ds.w   1       current length */
.equ bv_lengt,106
/* QL: bv_stmnt ds.b   1       current statement on line */
.equ bv_stmnt,108
/* QL: bv_cont ds.b    1       continue ($80) or stop (0) processing */
.equ bv_cont,109
/* QL: bv_inlin ds.b   1       in-line clause (1=loop or $ff=other) or not (0) */
.equ bv_inlin,110
/* QL: bv_sing ds.b    1       single line execution on ($ff) or off (0) */
.equ bv_sing,111
/* QL: bv_index ds.w   1       name tab row of last inline loop index read */
.equ bv_index,112
/* QL: bv_vvfre ds.l   1       first free space in vvtable */
.equ bv_vvfre,114
/* QL: bv_sssav ds.l   1       saved sp for out of memory to go back to */
.equ bv_sssav,118
/* QL:         ds.w    1       spare */
/* QL: bv_uproc ds.l   1       if sign set, rest is address of user trace procedure */
.equ bv_uproc,124
/* QL: bv_rand ds.l    1       random number */
.equ bv_rand,128
/* QL: bv_comch ds.l   1       command channel */
.equ bv_comch,132
/* QL: bv_nxlin ds.w   1       which line number to start after */
.equ bv_nxlin,136
/* QL: bv_nxstm ds.b   1       which statement to start after */
.equ bv_nxstm,138
/* QL: bv_comln ds.b   1       command line save ($ff) or not (0) */
.equ bv_comln,139
/* QL: bv_stopn ds.w   1       which stop number set */
.equ bv_stopn,140
/* QL: bv_edit ds.b    1       program has been edited ($ff) or not (0) */
.equ bv_edit,142
/* QL: bv_brk  ds.b    1       there has been a break (0) or not ($80) */
.equ bv_brk,143
/* QL: bv_unrvl ds.b   1       need to unravel ($ff) or not (0) */
.equ bv_unrvl,144
/* QL: bv_cnstm ds.b   1       statement to continue from */
.equ bv_cnstm,145
/* QL: bv_cnlno ds.w   1       line to continue from */
.equ bv_cnlno,146
/* QL: bv_dalno ds.w   1       current data line number */
.equ bv_dalno,148
/* QL: bv_dastm ds.b   1       current data statement number */
.equ bv_dastm,150
/* QL: bv_daitm ds.b   1       next data item to read */
.equ bv_daitm,151
/* QL: bv_cnind ds.w   1       inline loop index to continue with */
.equ bv_cnind,152
/* QL: bv_cninl ds.b   1       inline loop flag for continue */
.equ bv_cninl,154
/* QL: bv_lsany ds.b   1       whether checking list ($ff) or not (0) */
.equ bv_lsany,155
/* QL: bv_lsbef ds.w   1       invisible top line */
.equ bv_lsbef,156
/* QL: bv_lsbas ds.w   1       bottom line in window */
.equ bv_lsbas,158
/* QL: bv_lsaft ds.w   1       invisible bottom line */
.equ bv_lsaft,160
/* QL: bv_lenln ds.w   1       length of window line */
.equ bv_lenln,162
/* QL: bv_maxln ds.w   1       max number of window lines */
.equ bv_maxln,164
/* QL: * Note. the 2 following words will be overwritten on changing lenln and maxln: */
/* QL: bv_totln ds.w   1       number of window lines so far */
.equ bv_totln,166
/* QL:         ds.w    1       spare, but see above */
/* QL: bv_auto ds.b    1       whether auto/edit on ($ff) or off (0) */
.equ bv_auto,170
/* QL: bv_print ds.b   1       print from prtok ($ff) or leave in buffer (0) */
.equ bv_print,171
/* QL: bv_edlin ds.w   1       line number to edit next */
.equ bv_edlin,172
/* QL: bv_edinc ds.w   1       increment on auto edit range (+ve) or not auto (0) */
.equ bv_edinc,174
/* QL:         ds.l    1       bv_tkpos position of a4 in tklist on entry to proc */
/* QL:         ds.l    1       bv_ptemp temporary pointer for go_proc */
/* QL: bv_undo ds.b    1       undo rt stack immediately then redo procedure */
.equ bv_undo,184
/* QL: bv_arrow ds.b   1       up ($ff), down (1) or no (0) arrow on last line read */
.equ bv_arrow,185
/* QL: bv_lsfil ds.w   1       fill window when relisting at least to here */
.equ bv_lsfil,186
/* QL: bv_wrlno ds.w   1       when error line number */
.equ bv_wrlno,188
/* QL: bv_wrstm ds.b   1       statement */
.equ bv_wrstm,190
/* QL: bv_wrinl ds.b   1       inline ($ff) or not (0) */
.equ bv_wrinl,191
/* QL: bv_wherr ds.b   1       processing ($80) or not (0) */
.equ bv_wherr,192
/* QL: bv_erstm ds.b   1       last error statement (new, wa spare, we hope) */
.equ bv_erstm,193
/* QL: bv_error ds.l   1       last error number */
.equ bv_error,194
/* QL: bv_erlin ds.w   1       last error line */
.equ bv_erlin,198
/* QL: bv_wvnum ds.w   1       number of watched variables */
.equ bv_wvnum,200
/* QL: bv_wvbas ds.l   1       base of wv area wrt vvbas */
.equ bv_wvbas,202
/* QL:         ds.w    1       bv_lblen now spare, was used by fastload? */
/* QL:         ds.l    1       bv_lbuff now spare, ditto */
/* QL: bv_toe  ds.b    1       turn off enhancements: bit 7 int toks (was bv_filst) */
.equ bv_toe,212
/* QL:         ds.b    11      spare */
/* QL: bv_alchp ds.l   1       TK2 linked common heap allocations */
.equ bv_alchp,224
/* QL:         ds.l    2       spare */
/* QL: bv_qlibx ds.l   1       Qliberator stuff */
.equ bv_qlibx,236
/* QL:         ds.l    2       spare */
/* QL: bv_qliby ds.l   1       qliberator again! */
.equ bv_qliby,248
/* QL:         ds.l    1       spare */
/* QL: bv_end ; top of bv area */
.equ bv_end,256
/* QL:          list */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         section bp_misc */
.section bp_misc,"ax"
/* QL: * report{#chan}{,errno} */
/* QL: repit */
repit:
/* QL:         bne.s   err_bp */
    bne.s err_bp
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         jsr     ut_err(pc) */
    jsr ut_err(pc)
/* QL:         bra.s   okrts */
    bra.s okrts
/* QL: bp_repot */
bp_repot:
/* QL:         moveq   #0,d1           if no channel, then use console */
    moveq #0,d1
/* QL:         jsr     bp_chand(pc) */
    jsr bp_chand(pc)
/* QL:         bsr.s   gtlin */
    bsr.s gtlin
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bcc.s   repit */
    bcc.s repit
/* QL:         assert  bv_error,bv_erlin-4 */
/* original assertion: bv_error,bv_erlin-4 */
/* QL:         movem.l bv_error(a6),d0/d3 get error number and line */
    movem.l bv_error(a6),d0/d3
/* QL:         move.b  bv_erstm(a6),d3 put in statement */
    move.b bv_erstm(a6),d3
/* QL:         jsr     ib_errep(pc)    write out the error */
    jsr ib_errep(pc)
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * MODE p1{,p2} sets the display mode */
/* QL: bp_mode */
bp_mode:
/* QL:         jsr     ca_gtint(pc) */
    jsr ca_gtint(pc)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         movem.w 0(a6,a1.l),d1-d2 */
    movem.w 0(a6,a1.l),d1-d2
/* QL:         subq.w  #2,d3 */
    subq.w #2,d3
/* QL:         beq.s   set_it */
    beq.s set_it
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL:         bne.s   err_bp */
    bne.s err_bp
/* QL:         moveq   #-1,d2          no change to monitor/tv byte */
    moveq #(-1),d2
/* QL:         and.w   #256+8,d1       only check bits corresponding to 8 or 256 */
    and.w #(256+8),d1
/* QL:         beq.s   set_it          512,4,etc - byte is zero */
    beq.s set_it
/* QL:         moveq   #8,d1           256,8,264 - byte is 08h */
    moveq #8,d1
/* QL: set_it */
set_it:
/* QL:         moveq   #mt.dmode,d0    set mode */
    moveq #mt.dmode,d0
/* QL:         bra.s   trap1 */
    bra.s trap1
/* QL: * NET number sets the network station number (1..127) */
/* QL: bp_net */
bp_net:
/* QL:         jsr     ca_gtin1(pc)    one integer */
    jsr ca_gtin1(pc)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         move.b  d1,d3           get argument */
    move.b d1,d3
/* QL:         ble.s   err_bp */
    ble.s err_bp
/* QL:         assert  0,mt.inf */
/* original assertion: 0,mt.inf */
/* QL:         trap    #1 */
    trap #1
/* QL:         move.b  d3,sv_netnr(a0) */
    move.b d3,sv_netnr(a0)
/* QL:         rts */
    rts 
/* QL: * CALL address(,long)...: longwords put into d1-d7/a0-a5, then "jsr address" */
/* QL: bp_call */
bp_call:
/* QL: * We could force there to be enough zeroes on the stack to complete the call */
/* QL: * parameters with all zeroes. There have to be at most 13 longwords of zero to */
/* QL: * cope with the worst case. We would have to push the whole lot, to make it */
/* QL: * easier in the case that the caller might even give to many parameters. */
/* QL: * However, as CALL gets replaced so often, maybe it's not worth the trouble. */
/* QL: * There is another bonus - call code may be happier with the extra stack space. */
/* QL: * Minimum cost is 22 bytes, and some time, plus switching to sup mode. */
/* QL: * Given the latter two considerations, maybe we'll just forget it! */
/* QL: *        jsr     bv_chri(pc)     this ensure 60 bytes, more than we need */
/* QL: *        moveq   #13*4,d1 */
/* QL: *        sub.l   d1,bv_rip(a6)   push extra longwords */
/* QL: *        move.l  bv_rip(a6),a0 */
/* QL: *        jsr     mm_clrr(pc)     set the extras to zero */
/* QL:         bsr.s   gtlin           get long integers */
    bsr.s gtlin
/* QL:         asl.l   #2,d3           remove the parameters from stack */
    asl.l #2,d3
/* QL:         ble.s   err_bp          if none (or too many!) give up */
    ble.s err_bp
/* QL: *        moveq   #13*4,d0        lose our extra longwords */
/* QL: *        add.l   d0,d3 */
/* QL:         add.l   d3,bv_rip(a6) */
    add.l d3,bv_rip(a6)
/* QL:         move.l  d1,-(sp)        set up address */
    move.l d1,-(sp)
/* QL:         movem.l 4(a6,a1.l),d1-d7/a0-a5 set up registers */
    movem.l 4(a6,a1.l),d1-d7/a0-a5
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: gtlin */
gtlin:
/* QL:         jsr     ca_gtlin(pc) */
    jsr ca_gtlin(pc)
/* QL:         movem.l 0(a6,a1.l),d1-d2 enough for some */
    movem.l 0(a6,a1.l),d1-d2
/* QL:         beq.s   rts0 */
    beq.s rts0
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * RANDOMISE{delimiter}{value}: initialises the random number generator. */
/* QL: * Two flavours are now supported. The old one is used if the lsb of bv_rand is */
/* QL: * set to one. The new (better!) one uses an lsb of zero, and is invoked by a */
/* QL: * null first argument. */
/* QL: bp_rande */
bp_rande:
/* QL:         moveq   #7,d5 */
    moveq #7,d5
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         beq.s   rndnorm         no parameters, don't set new scheme */
    beq.s rndnorm
/* QL:         and.b   1(a6,a3.l),d5   otherwise null 1st parameter is new scheme */
    and.b 1(a6,a3.l),d5
/* QL:         bne.s   rndnorm */
    bne.s rndnorm
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL: rndnorm */
rndnorm:
/* QL:         bsr.s   gtlin           get a seed */
    bsr.s gtlin
/* QL:         subq.w  #1,d3           was there one parameter? */
    subq.w #1,d3
/* QL:         beq.s   get_rand        just one, use it as seed */
    beq.s get_rand
/* QL:         bcc.s   err_bp          no parameters uses clock, nowt else allowed */
    bcc.s err_bp
/* QL:         moveq   #mt.rclck,d0    get time */
    moveq #mt.rclck,d0
/* QL:         trap    #1 */
    trap #1
/* QL: get_rand */
get_rand:
/* QL:         tst.b   d5 */
    tst.b d5
/* QL:         bne.s   rndgrot */
    bne.s rndgrot
/* QL:         add.l   d1,d1           new scheme keeps 31 given bits, plus clear lsb */
    add.l d1,d1
/* QL: rndput */
rndput:
/* QL:         move.l  d1,bv_rand(a6)  put seed and flag into location */
    move.l d1,bv_rand(a6)
/* QL:         rts */
    rts 
/* QL: rndgrot */
rndgrot:
/* QL:         move.l  d1,d2           make both ends significant */
    move.l d1,d2
/* QL:         swap    d1              this wastes a lot of randomisation bits */
    swap d1
/* QL:         add.l   d2,d1           tacky... but can't change it now! */
    add.l d2,d1
/* QL:         bset    d0,d1 */
    bset d0,d1
/* QL:         bra.s   rndput */
    bra.s rndput
/* QL: * BAUD rate: sets the baud rate for the serial ports */
/* QL: bp_baud */
bp_baud:
/* QL:         jsr     ca_gtin1(pc)    get the baud rate to d1 */
    jsr ca_gtin1(pc)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         moveq   #mt.baud,d0 */
    moveq #mt.baud,d0
/* QL: trap1 */
trap1:
/* QL:         trap    #1              go try to set it */
    trap #1
/* QL:         rts */
    rts 
/* QL: * specify translation modes */
/* QL: * this basic command has the format : */
/* QL: *       tra  arg1{,arg2}        or      tra  ,arg2 */
/* QL: * where arg1 controls the serial i/o translation tables: */
/* QL: *       <= -2   turn on translation */
/* QL: *       = -1    no change */
/* QL: *       = 0     turn off translation */
/* QL: *       = 1     set default i/o tables and turn it on */
/* QL: *       = other set user defined i/o tables and turn it on */
/* QL: * and arg2 controls the message table: */
/* QL: *       <= 0    no change */
/* QL: *       = 1     set default system messages */
/* QL: *       = other set user defined messages */
/* QL: * both user tables must be specified by an even address, at which the first */
/* QL: * word is $4afb. */
/* QL: * the translation tables then contain two words, giving the offset to the */
/* QL: * input and output translation tables. these may be given as zero to turn */
/* QL: * each off, or should point at a 256 byte direct translate list. only 128 */
/* QL: * bytes are needed if only 7-bit data is being used. */
/* QL: * the message table continues with a count of the number of messages in the */
/* QL: * table and then their offsets. each message must be on an even address, */
/* QL: * prefixed by its character count word. */
/* QL: bp_tra */
bp_tra:
/* QL:         move.l  a5,d5 */
    move.l a5,d5
/* QL:         sub.l   a3,d5 */
    sub.l a3,d5
/* QL:         ble.s   err_bp          no parameters, we don't like */
    ble.s err_bp
/* QL:         asr.l   #3,d5 */
    asr.l #3,d5
/* QL:         subq.l  #2,d5 */
    subq.l #2,d5
/* QL:         bgt.s   err_bp          1 (d5=-1) or 2 (d5=0) parameters we like */
    bgt.s err_bp
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   1(a6,a3.l),d1 */
    and.b 1(a6,a3.l),d1
/* QL:         bne.s   getem */
    bne.s getem
/* QL:         addq.l  #8,a3           skip omitted 1st param */
    addq.l #8,a3
/* QL: getem */
getem:
/* QL:         bsr.s   gtlin           get arguments */
    bsr.s gtlin
/* QL:         moveq   #mt.cntry,d0    set up trap code */
    moveq #mt.cntry,d0
/* QL:         subq.w  #2,d3           how many ? */
    subq.w #2,d3
/* QL:         beq.s   trap1           two - all must be ready */
    beq.s trap1
/* QL:         moveq   #-1,d2          maybe just 1st param */
    moveq #(-1),d2
/* QL:         cmp.w   d3,d5           did we have 1st param null? */
    cmp.w d3,d5
/* QL:         beq.s   trap1           no - we're there */
    beq.s trap1
/* QL:         exg     d1,d2           swap 'em over */
    exg d1,d2
/* QL:         bra.s   trap1           go to it */
    bra.s trap1
/* QL:         end */
