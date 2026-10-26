/* Generated from original/M/ii/clock.asm */
/* QL: * Copy clock to internal from I2C, if it's there */
/* QL:         xdef    ii_clock */
.globl ii_clock
/* QL:         xref    bf_datez */
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
/* QL:         include 'win1_m_inc_vect' */
/* QL: * vect user vectors */
/* QL:         nolist */
/* QL: addr setnum $c0 */
/* QL: vec macro */
/* QL: * utility vectors - words */
/* QL: s vec.w 0 mm alchp 0 mm rechp 0 ut windw 0 ut con   ;  $c0 -  $c6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.alchp,192
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.rechp,194
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.windw,196
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.con,198
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 ut scr   0 ut err0  0 ut err   0 ut mint  ;  $c8 -  $ce */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.scr,200
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.err0,202
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.err,204
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.mint,206
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 ut mtext 0 ut link  0 ut unlnk k .. 0     ;  $d0 -  $d6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.mtext,208
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.link,210
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.unlnk,212
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 mm alloc 0 mm lnkfr 0 io qset  0 io qtest ;  $d8 -  $de */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.alloc,216
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.lnkfr,218
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qset,220
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qtest,222
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 io qin   0 io qout  0 io qeof  0 ut cstr  ;  $e0 -  $e6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qin,224
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qout,226
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qeof,228
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.cstr,230
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 io serq  0 io serio 0 cn date  0 cn day   ;  $e8 -  $ee */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.serq,232
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.serio,234
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.date,236
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.day,238
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn ftod  0 cn itod  0 cn itobb 0 cn itobw ;  $f0 -  $f6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.ftod,240
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itod,242
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itobb,244
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itobw,246
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn itobl 0 cn itohb 0 cn itohw 0 cn itohl ;  $f8 -  $fe */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itobl,248
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itohb,250
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itohw,252
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itohl,254
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn dtof  0 cn dtoi  0 cn btoib 0 cn btoiw ; $100 - $106 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.dtof,256
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.dtoi,258
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.btoib,260
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.btoiw,262
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn btoil 0 cn htoib 0 cn htoiw 0 cn htoil ; $108 - $10e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.btoil,264
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.htoib,266
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.htoiw,268
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.htoil,270
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 bp init  0 ca gtint 0 ca gtfp  0 ca gtstr ; $110 - $116 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.init,272
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtint,274
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtfp,276
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtstr,278
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 ca gtlin 0 bv chrix 0 ri exec  0 ri execb ; $118 - $11e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtlin,280
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bv.chrix,282
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ri.exec,284
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ri.execb,286
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 bp let   0 io name  4 md read  4 md write ; $120 - $126 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.let,288
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.name,290
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.read,292
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.write,294
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 md verin 4 md sectr 4 pa graph 4 pa table ; $128 - $12e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.verin,296
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.sectr,298
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.graph,300
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.table,302
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 pa expr  4 pa strip 4 pa mist  4 ed nwlin ; $130 - $136 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.expr,304
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.strip,306
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.mist,308
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ed.nwlin,310
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ed liste 4 pa ini   4 ut istr  4 go new   ; $138 - $13e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ed.liste,312
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.ini,314
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.istr,316
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ go.new,318
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 bp chan  4 bp chand 4 bp chnid 4 bp chnew ; $140 - $146 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chan,320
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chand,322
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chnid,324
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chnew,326
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 bp fname 4 ca cnvrt 4 ca opexe 4 ca eval  ; $148 - $14e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.fname,328
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.cnvrt,330
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.opexe,332
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.eval,334
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ip kbrd  4 ip kbend 4 sb start k .. -1    ; $150 - $156 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ip.kbrd,336
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ip.kbend,338
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ sb.start,340
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 mm move  4 mm mrtoa 4 mm mator 4 mm mrtor ; $158 - $15e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.move,344
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.mrtoa,346
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.mator,348
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.mrtor,350
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ss wser  4 ss rser  4 md selec 4 md desel ; $160 - $166 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ss.wser,352
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ss.rser,354
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.selec,356
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.desel,358
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 mm clear 4 mm clrr  4 io qsetl k .. -1    ; $168 - $16e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.clear,360
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.clrr,362
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qsetl,364
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ii raw   4 ii drive k .. -1    k .. -1    ; $170 - $176 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ii.raw,368
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ii.drive,370
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL:         list */
/* QL: * I2C RAM layout: */
/* QL: * 0-7 clock */
/* QL: * 8-15 alarm (not used) */
/* QL: * 16-19 QDOS version number (must match for 28+ to be used) */
/* QL: * 20-23 auto boot d1 value (lsw reset to 8 when it is used) */
/* QL: * 24-25 year*2+month/10 */
/* QL: * 26-27 replacement for auto boot lsw */
/* QL: * 28-29 selective ROM disable (msb disables first ROM, and so on) */
/* QL: * 30 network number (sv_netnr) */
/* QL: * 31 turn off enhancements in QDOS (sx_toe) */
/* QL: * 32 turn off enhancements in basic job 0 (bv_toe) */
/* QL: * 33-34 spare */
/* QL: * 35 keyboard stuff count (1-128) */
/* QL: * 36-163 up to 128 char type in at boot */
/* QL: * 164-255 spare */
/* QL: * Offsets on sp which are used: */
/* QL:         offset  0 */
/* QL:         ds.l    1       return address */
/* QL:         ds.w    1       nl, nl, */
/* QL: sp_flag ds.b    1       space, changed to cursor left if I2C is present */
.equ sp_flag,6
/* QL:         ds.b    1       space */
/* QL: sp_id   ds.l    1       expected to have the QDOS version */
.equ sp_id,8
/* QL:         ds.l    1       higher return address */
/* QL:         ds.l    2       two copies of RAM top */
/* QL: sp_rom  ds.w    1       .w where the ROM disable word is sent */
.equ sp_rom,24
/* QL:         ds.w    1       restart flags */
/* QL:         section ii_clock */
.section ii_clock,"ax"
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- seconds since dot */
/* QL: * a0 -i  - system variables base */
/* QL: * a6 -ip - basic variables base */
/* QL: * d2-d4/d6/a1-a4 destroyed */
/* QL: ii_clock */
ii_clock:
/* QL:         move.l  sv_free(a0),a1  set buffer pointer */
    move.l sv_free(a0),a1
/* QL:         move.l  a1,a4           duplicate start of transfer */
    move.l a1,a4
/* QL:         lea     cmd,a3          point to command sequence and masks */
    lea cmd(pc),a3
/* QL:         bsr.s   ii_drive        try to get the I2C clock stuff */
    bsr.s ii_drive
/* QL:         move.l  a1,a2           top of clock data */
    move.l a1,a2
/* QL:         beq.s   more            if it works, great (1st byte is junk) */
    beq.s more
/* QL:         moveq   #mt.rclck,d0    fall back to internal clock read */
    moveq #mt.rclck,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         rts */
    rts 
/* QL: ii_drive */
ii_drive:
/* QL:         move.w  ii.drive,a2 */
    move.w ii.drive,a2
/* QL:         jmp     $4000(a2) */
    jmp 0x4000(a2)
/* QL: more */
more:
/* QL:         and.b   -(a2),d0        use mask byte to junk msd flags bits */
    and.b -(a2),d0
/* QL:         moveq   #15,d1          mask for lsd and msbs all zero */
    moveq #15,d1
/* QL:         and.b   (a2),d1         get lsd */
    and.b (a2),d1
/* QL:         lsr.b   #1,d0 */
    lsr.b #1,d0
/* QL:         add.b   d0,d1           lsd + msd/2 */
    add.b d0,d1
/* QL:         lsr.b   #2,d0 */
    lsr.b #2,d0
/* QL:         add.b   d0,d1           lsd + msd*16/2 + msd*16/8 = lsd + 10*msd */
    add.b d0,d1
/* QL:         move.l  d1,(a1)+        push onto stack */
    move.l d1,(a1)+
/* QL:         move.b  (a3)+,d0        get next mask byte */
    move.b (a3)+,d0
/* QL:         bne.s   more            if not ending zero, keep on going */
    bne.s more
/* QL: * This bit copes with 12/24 hour + am/pm */
/* QL:         move.l  (a2)+,d3        ss:mm:hh dd, just want 2 lsbs of hh */
    move.l (a2)+,d3
/* QL:         add.w   d3,d3           check them */
    add.w d3,d3
/* QL:         bcc.s   notpm           skip if 24hr */
    bcc.s notpm
/* QL:         bpl.s   notpm           skip if 12hr and am */
    bpl.s notpm
/* QL:         add.b   #12,-9(a1)      add 12 to hours for 12hr and pm */
    add.b #(12&255),(-9)(a1)
/* QL: notpm */
notpm:
/* QL: * This bit clicks the year by using a copy of the tens of month at the year lsb */
/* QL:         movem.l (a4)+,d3-d4/d6  take up id, junk and year+flag+rebooter */
    movem.l (a4)+,d3-d4/d6
/* QL:         swap    d6              swap to rebooter and year+flag */
    swap d6
/* QL:         move.b  (a2),d1         get bcd month again */
    move.b (a2),d1
/* QL:         lsr.b   #4,d1           move ten months to lsb */
    lsr.b #4,d1
/* QL:         eor.b   d6,d1           flip with ten month flag after lsb of year */
    eor.b d6,d1
/* QL:         asr.b   #1,d1           move to x reg */
    asr.b #1,d1
/* QL:         addx.w  d0,d6           if they differed, increment year+flag */
    addx.w d0,d6
/* QL:         move.l  d6,(a1)         put them in the buffer */
    move.l d6,(a1)
/* QL:         move.l  a1,d4           save stack top for later */
    move.l a1,d4
/* QL:         lsr.w   #1,d6           lose the 10 month flag now */
    lsr.w #1,d6
/* QL:         bsr.s   ii_drive        slot back in the lsw of boot and the year+flag */
    bsr.s ii_drive
/* QL:         cmp.l   sp_id(sp),d3    check QDOS id */
    cmp.l sp_id(sp),d3
/* QL:         bne.s   clock           no match, so don't trust the ram layout */
    bne.s clock
/* QL:         moveq   #$c0-256,d3     left arrow key */
    moveq #(0xc0-256),d3
/* QL:         move.b  d3,sp_flag(sp)  show them I2C is around */
    move.b d3,sp_flag(sp)
/* QL:         move.l  sv_keyq(a0),a2  get #0's key queue */
    move.l sv_keyq(a0),a2
/* QL:         move.w  io.qtest,a3 */
    move.w io.qtest,a3
/* QL:         jsr     (a3)            see what character is present */
    jsr (a3)
/* QL:         cmp.b   d1,d3 */
    cmp.b d1,d3
/* QL:         beq.s   clock           if left arrow, they are avoiding I2C */
    beq.s clock
/* QL:         move.w  (a4)+,sp_rom(sp) set ROM inhibit word */
    move.w (a4)+,sp_rom(sp)
/* QL:         move.b  (a4)+,sv_netnr(a0) set network address */
    move.b (a4)+,sv_netnr(a0)
/* QL:         move.l  sv_chtop(a0),a0 get system extension address */
    move.l sv_chtop(a0),a0
/* QL:         move.b  (a4)+,sx_toe(a0) set turn off enhancements flag */
    move.b (a4)+,sx_toe(a0)
/* QL:         move.b  (a4),bv_toe(a6) set basic tokenisation flag */
    move.b (a4),bv_toe(a6)
/* QL: * Two spare bytes */
/* QL:         move.l  (a4)+,d3        get stuffer length */
    move.l (a4)+,d3
/* QL:         move.w  io.qin,a1 */
    move.w io.qin,a1
/* QL:         bra.s   stent */
    bra.s stent
/* QL: stuff */
stuff:
/* QL:         move.b  (a4)+,d1 */
    move.b (a4)+,d1
/* QL:         jsr     (a1)            put byte into keyboard queue */
    jsr (a1)
/* QL: stent */
stent:
/* QL:         subq.b  #1,d3 */
    subq.b #1,d3
/* QL:         bpl.s   stuff           allow max 128 stuffer chars */
    bpl.s stuff
/* QL: clock */
clock:
/* QL:         move.w  d6,d1           we kept the year and msw d1 is zero */
    move.w d6,d1
/* QL:         move.l  d4,a1           reload clock data stack pointer */
    move.l d4,a1
/* QL:         sub.l   a6,a1           set rel a6 pointer to 5 longs */
    sub.l a6,a1
/* QL:         jsr     bf_datez(pc)    go convert year and the rest to seconds-dot */
    jsr bf_datez(pc)
/* QL:         moveq   #mt.sclck,d0    now set the internal clock with it all */
    moveq #mt.sclck,d0
/* QL:         trap    #1              read or set clock */
    trap #1
/* QL:         rts */
    rts 
/* QL: * Command sequences: i/o 10srbpa0, special 11gvdc1q */
/* QL: cmd */
cmd:
/* QL:         dc.b    0,$a0/2,%11011110       set device */
dc_anchor_1486:
.byte (0)&255
.byte ((0xa0/2))&255
.byte (0b11011110)&255
/* QL:         dc.b    1,%10100000,16          start, write address of id word */
dc_anchor_1491:
.byte (1)&255
.byte (0b10100000)&255
.byte (16)&255
/* QL:         dc.b    1,128-16+8-1,%10111100  start, read most of ram, stop */
dc_anchor_1496:
.byte (1)&255
.byte ((((128-16)+8)-1))&255
.byte (0b10111100)&255
/* QL:         dc.b    $ff                     finish */
dc_anchor_1501:
.byte (0xff)&255
/* QL:         dc.b    $10,$30,$30,$70,$70,0   masks for mm/dd hh:mm:ss & stop */
dc_anchor_1504:
.byte (0x10)&255
.byte (0x30)&255
.byte (0x30)&255
.byte (0x70)&255
.byte (0x70)&255
.byte (0)&255
/* QL:         dc.b    1,%10100000,22          start, write address of lsw of boot */
dc_anchor_1512:
.byte (1)&255
.byte (0b10100000)&255
.byte (22)&255
/* QL:         dc.b    4,%10001100             write boot/year+flag from buffer, stop */
dc_anchor_1517:
.byte (4)&255
.byte (0b10001100)&255
/* QL:         dc.b    $ff                     finish */
dc_anchor_1521:
.byte (0xff)&255
/* QL:         end */
