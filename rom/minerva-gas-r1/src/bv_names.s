/* Generated from original/M/bv/names.asm */
/* QL: * Compact or copy name table and name list */
/* QL:         xdef    bv_names,bv_namei */
.globl bv_names,bv_namei
/* QL:         xref    bv_chbfx,bv_chnlx,bv_new */
/* QL:         xref    bp_init,bp_init0 */
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: bv..int equ     6       jb_rela6 flag that tells us if a job is an interpreter */
.equ bv..int,6
/* QL:         section bv_names */
.section bv_names,"ax"
/* QL: * Compact or copy machine code proedures and functions */
/* QL: * This is used at startup of a new copy of basic, to acquire names from it's */
/* QL: * interpreting ancestor, the ROM or even elsewhere. */
/* QL: * In the interest of making the process fairly simple, though we could be */
/* QL: * terribly subtle, we get space for the whole of the nt and nl, then compact it */
/* QL: * as we copy it across. We could go to the bother of doing two scans, the first */
/* QL: * just to establish the size, but it seems a bit pedantic, as the extra space */
/* QL: * can be imediately released to the central area, and it won't be vast usually. */
/* QL: * d0 -o  - 0 */
/* QL: * d4 -  o- current job id */
/* QL: * a1 -i  - if not zero, -ve will force rom names or positive some other set! */
/* QL: * a3 -  o- ram top address (wanted by job 0, and we happen to have it handy) */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_namei */
bv_namei:
/* QL:         lea     interp,a2       turn ourselves into an interpreter */
    lea interp(pc),a2
/* QL:         moveq   #mt.extop,d0 */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  sv_ramt(a0),-(sp) save ram top */
    move.l sv_ramt(a0),-(sp)
/* QL:         jsr     bv_chbfx(pc)    set buffer up right away (small one! 128 bytes) */
    jsr bv_chbfx(pc)
/* QL:         tst.l   d4 */
    tst.l d4
/* QL:         lea     bp_init0(pc),a2 */
    lea bp_init0(pc),a2
/* QL:         beq.s   init            job 0 always uses rom m/c */
    beq.s init
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL:         beq.s   jobscan */
    beq.s jobscan
/* QL:         bmi.s   init            if table is given as positive, use it! */
    bmi.s init
/* QL:         lea     bp_init(pc),a2 */
    lea bp_init(pc),a2
/* QL: init */
init:
/* QL:         jsr     (a2)            initialise rom m/c procedures and functions */
    jsr (a2)
/* QL:         bra.s   donew */
    bra.s donew
/* QL: retry */
retry:
/* QL:         sub.l   a2,d1           revert to required space */
    sub.l a2,d1
/* QL:         jsr     bv_chnlx(pc)    allocate the space, and try again */
    jsr bv_chnlx(pc)
/* QL: jobscan */
jobscan:
/* QL:         lea     jobfind,a2 */
    lea jobfind(pc),a2
/* QL:         moveq   #mt.extop,d0 */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         tst.l   d2              check if we copied the tables OK */
    tst.l d2
/* QL:         bpl.s   retry           not copied, so go increase our space */
    bpl.s retry
/* QL:         bra.s   donew           OK, we've done it, so continue to finish off */
    bra.s donew
/* QL: * This is used by the NEW, etc commands to compact the local tables. */
/* QL: * d0-d3/a0-a2 destroyed */
/* QL: bv_names */
bv_names:
/* QL:         move.l  a3,-(sp)        just to agree with namei */
    move.l a3,-(sp)
/* QL:         assert  bv_ntbas,bv_ntp-4,bv_nlbas-8 */
/* original assertion: bv_ntbas,bv_ntp-4,bv_nlbas-8 */
/* QL:         movem.l bv_ntbas(a6),d1-d2/a3 start at bottom of name table, up to top */
    movem.l bv_ntbas(a6),d1-d2/a3
/* QL:         sub.l   d1,d2           total size of nt */
    sub.l d1,d2
/* QL:         moveq   #3,d3           bit to test for m/c (msbs zero) */
    moveq #3,d3
/* QL: nx_mc */
nx_mc:
/* QL:         addq.l  #8,d1 */
    addq.l #8,d1
/* QL:         subq.l  #8,d2           was there nothing but mc? */
    subq.l #8,d2
/* QL:         bcs.s   donew           yes - all done */
    bcs.s donew
/* QL:         btst    d3,-8(a6,d1.l)  are we still on mc procs & fns */
    btst d3,(-8)(a6,d1.l)
/* QL:         bne.s   nx_mc           yes - keep looking */
    bne.s nx_mc
/* QL: * We musn't confuse people when moving names, so do it in supervisor mode */
/* QL:         lea     names,a2 */
    lea names(pc),a2
/* QL:         moveq   #mt.extop,d0    increment non-sheduling mode (d0.l=0) */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL: donew */
donew:
/* QL:         move.l  (sp)+,a3        get back saved a3 for names or ramtop for namei */
    move.l (sp)+,a3
/* QL:         jmp     bv_new(pc) */
    jmp bv_new(pc)
/* QL: * Set up stuff for job handling */
/* QL: info */
info:
/* QL:         moveq   #mt.inf,d0      get system info */
    moveq #mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  d1,d4           save own job id */
    move.l d1,d4
/* QL:         moveq   #64+bv..int,d1  flag number and initial buffer request */
    moveq #(64+bv..int),d1
/* QL:         assert  sv_jbpnt,sv_jbbas-4 */
/* original assertion: sv_jbpnt,sv_jbbas-4 */
/* QL:         movem.l sv_jbpnt(a0),a2/a3 get jbpnt and jbbas */
    movem.l sv_jbpnt(a0),a2/a3
/* QL:         move.l  (a2),a2         get pointer to header of current job */
    move.l (a2),a2
/* QL:         rts */
    rts 
/* QL: * Entry point for turning job into an interpreter */
/* QL: interp */
interp:
/* QL:         bsr.s   info            get info */
    bsr.s info
/* QL:         clr.l   jb_start(a2)    we can't be re-activated! */
    clr.l jb_start(a2)
/* QL:         bset    d1,jb_rela6(a2) set interpreter flag */
    bset d1,jb_rela6(a2)
/* QL:         rte */
    rte 
/* QL: * Entry point to supervisor mode code scanning for interpreter ancestor */
/* QL: jobfind */
jobfind:
/* QL:         bsr.s   info            set a2 = job header, a3 = jbbas */
    bsr.s info
/* QL: ancest */
ancest:
/* QL:         move.w  jb_owner+2(a2),d0 get owner job number (tag MUST match!) */
    move.w (jb_owner+2)(a2),d0
/* QL:         lsl.w   #2,d0 */
    lsl.w #2,d0
/* QL:         move.l  0(a3,d0.w),a2   get owner header address */
    move.l 0(a3,d0.w),a2
/* QL:         beq.s   j0ok            job 0 keeps its table at job base */
    beq.s j0ok
/* QL:         btst    d1,jb_rela6(a2) is this an interpreting ancestor? */
    btst d1,jb_rela6(a2)
/* QL:         beq.s   ancest          no - keep looking */
    beq.s ancest
/* QL:         add.w   jb_end+2(a2),a2 an interpreter must show where its tables are! */
    add.w (jb_end+2)(a2),a2
/* QL: j0ok */
j0ok:
/* QL:         lea     jb_end(a2),a0   point to tables */
    lea jb_end(a2),a0
/* QL: * We have found an ancestor who is an interpreter... now copy their m/c stuff. */
/* QL:         assert  bv_ntbas,bv_ntp-4,bv_nlbas-8,bv_nlp-12 */
/* original assertion: bv_ntbas,bv_ntp-4,bv_nlbas-8,bv_nlp-12 */
/* QL:         lea     bv_ntbas(a6),a1 */
    lea bv_ntbas(a6),a1
/* QL:         move.l  (a1)+,a2 */
    move.l (a1)+,a2
/* QL:         move.l  a2,(a1)+ */
    move.l a2,(a1)+
/* QL:         move.l  a2,(a1)+ */
    move.l a2,(a1)+
/* QL:         move.l  a2,(a1)+        reset our existing tables */
    move.l a2,(a1)+
/* QL:         movem.l bv_ntbas(a0),d0/d2-d3/a3 */
    movem.l bv_ntbas(a0),d0/d2-d3/a3
/* QL:         sub.l   d3,a3           size of their name list */
    sub.l d3,a3
/* QL:         sub.l   d0,d2           size of their name table */
    sub.l d0,d2
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         add.l   a3,d1           total space in their name table + name list */
    add.l a3,d1
/* QL:         add.l   a2,d1           our new offset to top of name list */
    add.l a2,d1
/* QL:         cmp.l   (a1),d1         will it fit in below our nlp+4 */
    cmp.l (a1),d1
/* QL:         bhi.s   rte0            no - go back and retry (d2 >= 0) */
    bhi.s rte0
/* QL: * We have a succesful check on space, so now copy their tables. */
/* QL:         move.l  d1,-(a1)        set nlp */
    move.l d1,-(a1)
/* QL:         sub.l   a3,d1 */
    sub.l a3,d1
/* QL:         move.l  d1,-(a1)        set nlbas */
    move.l d1,-(a1)
/* QL:         move.l  d1,-(a1)        set ntp */
    move.l d1,-(a1)
/* QL:         add.l   a0,d3           where their name list starts */
    add.l a0,d3
/* QL:         add.l   d0,a0           where their name table starts */
    add.l d0,a0
/* QL:         add.l   a6,a2           absolute base of our name table as destination */
    add.l a6,a2
/* QL:         move.l  a2,a3 */
    move.l a2,a3
/* QL:         add.l   d2,a3           absolute base of our name list as destination */
    add.l d2,a3
/* QL:         move.l  a3,d0           copy it for offset calculation */
    move.l a3,d0
/* QL:         bra.s   nx_nt */
    bra.s nx_nt
/* QL: * Note that d2.l < 0 when we have copied tables here  */
/* QL: nx_end */
nx_end:
/* QL:         sub.l   a6,a2           make new nt top relative */
    sub.l a6,a2
/* QL:         sub.l   a6,a3           make new nl top relative */
    sub.l a6,a3
/* QL:         move.l  a2,bv_ntp(a6)   reset the top nt pointer */
    move.l a2,bv_ntp(a6)
/* QL:         move.l  a3,bv_nlp(a6)   reset the top namelist pointer */
    move.l a3,bv_nlp(a6)
/* QL: rte0 */
rte0:
/* QL:         rte */
    rte 
/* QL: * Entry point for supervisor mode code for our own name table/list compaction */
/* QL: names */
names:
/* QL:         lea     -8(a6,d1.l),a0  this the first non-mc */
    lea (-8)(a6,d1.l),a0
/* QL:         move.l  a0,a2           two copies, one to scan and one to move */
    move.l a0,a2
/* QL:         add.l   a6,a3           make name list base absolute */
    add.l a6,a3
/* QL:         move.l  a3,d0           save destination name list base */
    move.l a3,d0
/* QL:         add.w   -6(a0),a3       set address of the last m/c name */
    add.w (-6)(a0),a3
/* QL:         move.b  (a3)+,d3        get it's length */
    move.b (a3)+,d3
/* QL:         add.w   d3,a3           any further m/c names move down to here */
    add.w d3,a3
/* QL:         move.l  d0,d3           duplicate as source base, so we can share code */
    move.l d0,d3
/* QL: * d0 - absolute base of destination name list */
/* QL: * d1 - temporary (name length counter) */
/* QL: * d2 - remaining nt entry length */
/* QL: * d3 - absolute base of source name list */
/* QL: * a0 - absolute nt pointer */
/* QL: * a1 - temporary (old nl name pointer) */
/* QL: * a2 - absolute destination to copy nt entries down to */
/* QL: * a3 - absolute pointer to new name list */
/* QL: nx_add */
nx_add:
/* QL:         addq.l  #8,a0           step to next nt entry */
    addq.l #8,a0
/* QL: nx_nt */
nx_nt:
/* QL:         subq.l  #8,d2           have we finished yet? */
    subq.l #8,d2
/* QL:         bcs.s   nx_end          yes - go finish off */
    bcs.s nx_end
/* QL: look */
look:
/* QL:         btst    #3,(a0)         is this entry a mc proc/fn */
    btst #3,(a0)
/* QL:         beq.s   nx_add          no - keep looking */
    beq.s nx_add
/* QL:         move.w  (a0)+,(a2)+     move first word of nt entry down */
    move.w (a0)+,(a2)+
/* QL:         move.w  (a0)+,a1        get the old name list offset */
    move.w (a0)+,a1
/* QL:         add.l   d3,a1           this is where the name comes from */
    add.l d3,a1
/* QL:         move.w  a3,(a2) */
    move.w a3,(a2)
/* QL:         sub.w   d0,(a2)+        put in the new name list offset */
    sub.w d0,(a2)+
/* QL:         move.l  (a0)+,(a2)+     copy the other longword of the nt entry */
    move.l (a0)+,(a2)+
/* QL:         move.b  (a1),d1         get the name length */
    move.b (a1),d1
/* QL: copy_nl */
copy_nl:
/* QL:         move.b  (a1)+,(a3)+     copy a char */
    move.b (a1)+,(a3)+
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         bcc.s   copy_nl         until they're all gone */
    bcc.s copy_nl
/* QL:         bra.s   nx_nt */
    bra.s nx_nt
/* QL:         end */
