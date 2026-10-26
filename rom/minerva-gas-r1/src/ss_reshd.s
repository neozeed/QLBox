/* Generated from original/M/ss/reshd.asm */
/* QL: * Scheduler entry / re-entry */
/* QL:         xdef    ss_reshd,ss_dljob,ss_rj0 */
.globl ss_reshd,ss_dljob,ss_rj0
/* QL:         xref    ss_tlist */
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: sx..brk equ     4       low bit number that indicates ctrl{/alt}/space events */
.equ sx..brk,4
/* QL: bv..int equ     6       bit number that indicates an interpreter job */
.equ bv..int,6
/* QL:         section ss_reshd */
.section ss_reshd,"ax"
/* QL: * Break (ctrl/space) handling moved here to avoid having it inside interrupt */
/* QL: * service code! Also, ctrl/alt/space breaks all other interpreters. */
/* QL: * The usage of job priorities has been enhanced somewhat. They now behave as: */
/* QL: *       -128..-1        background tasks (see below) */
/* QL: *       0               job is inactive */
/* QL: *       1-127           major active jobs, as before */
/* QL: * Background tasks are split into sixteen levels, according to their top */
/* QL: * nibble, within each of which the low nibble now gives the priority increment. */
/* QL: * Tasks of a given level are never given time unless no major job and no tasks */
/* QL: * at a higher level want time. */
/* QL: * Re-scheduling entry point */
/* QL: ss_reshd */
ss_reshd:
/* QL:         move.l  sv_jbpnt(a6),a5 find address of base of job */
    move.l sv_jbpnt(a6),a5
/* QL:         move.l  (a5),a5 */
    move.l (a5),a5
/* QL:         move.l  (sp)+,d7        the real value of d7 */
    move.l (sp)+,d7
/* QL:         movem.l d0-d7/a0-a4,jb_d0(a5) save most of the registers */
    movem.l d0-d7/a0-a4,jb_d0(a5)
/* QL:         add.w   #jb_a0+5*4,a5 */
    add.w #(jb_a0+(5*4)),a5
/* QL:         assert  jb_a0+8*4,jb_sr,jb_pc-2 */
/* original assertion: jb_a0+8*4,jb_sr,jb_pc-2 */
/* QL:         move.l  (sp)+,(a5)+     saved a5 */
    move.l (sp)+,(a5)+
/* QL:         move.l  (sp)+,(a5)+     saved a6 */
    move.l (sp)+,(a5)+
/* QL:         move    usp,a0 */
    move usp,a0
/* QL:         move.l  a0,(a5)+        user stack pointer (a7) */
    move.l a0,(a5)+
/* QL:         move.w  (sp)+,(a5)+     status register */
    move.w (sp)+,(a5)+
/* QL:         move.l  (sp)+,(a5)      program counter */
    move.l (sp)+,(a5)
/* QL:         tst.b   jb_prior-jb_pc(a5) reduce priority */
    tst.b (jb_prior-jb_pc)(a5)
/* QL:         beq.s   ss_dljob        if it is already zero - don't bother */
    beq.s ss_dljob
/* QL:         move.b  #1,jb_prior-jb_pc(a5) */
    move.b #(1&255),(jb_prior-jb_pc)(a5)
/* QL: * Entry when a job has been deleted by man_djob = main scheduler loop */
/* QL: ss_dljob */
ss_dljob:
/* QL:         lea     sv_pollm(a6),a0 */
    lea sv_pollm(a6),a0
/* QL:         move.w  (a0),d3         fetch number of missing polls */
    move.w (a0),d3
/* QL:         sub.w   d3,(a0)         and reset */
    sub.w d3,(a0)
/* QL:         assert  sv_rand,sv_pollm-2 */
/* original assertion: sv_rand,sv_pollm-2 */
/* QL:         addq.w  #1,-(a0)        update random number */
    addq.w #1,-(a0)
/* QL: * Now execute all tasks to be done by the scheduler/ioss */
/* QL:         moveq   #sv_shlst-sv_i2lst,d4 set offset of sched list from int 2 list */
    moveq #(sv_shlst-sv_i2lst),d4
/* QL:         jsr     ss_tlist(pc)    go do them (sets d1.l=0) */
    jsr ss_tlist(pc)
/* QL: * Look for next job to execute */
/* QL: * d0 -  o- address of job entry with highest priority (if d1.b is not zero) */
/* QL: * d1 -i o- 0/priority of job d0 or zero if no one can run */
/* QL: * d3 -i  - number of polled interrupts since last go */
/* QL: * a6 -  i- base address of system variables */
/* QL: * d2 priority of this job */
/* QL: * d4 priority increment */
/* QL: * d5 temporary */
/* QL: * d6 break events, bit 31 = ctrl/space and bit 0 = ctrl/alt/space */
/* QL: * d7 max job * 4, complemented as we swap marker */
/* QL: * a0 address of job */
/* QL: * a1 address of hold flag */
/* QL: * a2 address of job entry */
/* QL: * a3 address of marker job entry */
/* QL: * a4 address of system extension block */
/* QL: *       moveq   #0,d1           highest priority starts as zero = no job yet */
/* QL:         assert  sv_jbmax+2,sv_jbpnt,sv_jbbas-4 */
/* original assertion: sv_jbmax+2,sv_jbpnt,sv_jbbas-4 */
/* QL:         movem.l sv_jbpnt-4(a6),d7/a2-a3 max job, current job and base of table */
    movem.l (sv_jbpnt-4)(a6),d7/a2-a3
/* QL:         lsl.w   #2,d7           highest job number * 4 */
    lsl.w #2,d7
/* QL:         move.l  sv_chtop(a6),a4 get sysext address */
    move.l sv_chtop(a6),a4
/* QL:         moveq   #3<<sx..brk,d6 */
    moveq #(3<<sx..brk),d6
/* QL:         and.b   sx_event(a4),d6 get both break events (ctrl/{alt/}space) */
    and.b sx_event(a4),d6
/* QL:         eor.b   d6,sx_event(a4) invert events we have picked up */
    eor.b d6,sx_event(a4)
/* QL:         ror.l   #sx..brk+1,d6   sx..brk to bit 31, sx..brk+1 to bit 0 */
    ror.l #(sx..brk+1),d6
/* QL: chk_end */
chk_end:
/* QL:         cmp.l   a2,a3           are we at the marker? */
    cmp.l a2,a3
/* QL:         beq.s   chk_stp         yes - go see it that was the full loop */
    beq.s chk_stp
/* QL:         move.l  -(a2),d2        is this entry vacant? */
    move.l -(a2),d2
/* QL:         blt.s   chk_end         yes - see if end of scan */
    blt.s chk_end
/* QL:         move.l  d2,a0           get address of job */
    move.l d2,a0
/* QL:         move.w  #$7000,d4       positive princ's get msb $70 */
    move.w #0x7000,d4
/* QL:         assert  jb_stat-1,jb_princ */
/* original assertion: jb_stat-1,jb_princ */
/* QL:         lea     jb_stat-1(a0),a1 */
    lea (jb_stat-1)(a0),a1
/* QL:         move.b  (a1)+,d4        check if this job is active */
    move.b (a1)+,d4
/* QL:         beq.s   chk_end */
    beq.s chk_end
/* QL:         bpl.s   pri_ok */
    bpl.s pri_ok
/* QL:         lsl.w   #4,d4 */
    lsl.w #4,d4
/* QL:         lsr.b   #4,d4           turn -ve princ into 16 absolute low levels */
    lsr.b #4,d4
/* QL: pri_ok */
pri_ok:
/* QL:         btst    #bv..int,jb_rela6(a0) is this an interpreter? */
    btst #bv..int,jb_rela6(a0)
/* QL:         beq.s   brk_off         no - break events don't apply */
    beq.s brk_off
/* QL:         moveq   #jb_end+bv_brk-$7f,d2 job 0 offset of break flag less a bit */
    moveq #((jb_end+bv_brk)-0x7f),d2
/* QL:         cmp.l   sv_jbbas(a6),a2 is this job 0? */
    cmp.l sv_jbbas(a6),a2
/* QL:         seq     d5              job 0 - test bit 7, others - test bit 0 */
    seq d5
/* QL:         beq.s   set_brk */
    beq.s set_brk
/* QL:         add.w   jb_end+2(a0),d2 others have extra offset */
    add.w (jb_end+2)(a0),d2
/* QL: set_brk */
set_brk:
/* QL:         btst    d5,d6           are we processing the appropriate break event? */
    btst d5,d6
/* QL:         beq.s   brk_off         no - forget it */
    beq.s brk_off
/* QL:         sf      $7f(a0,d2.w) set break flag */
    sf 0x7f(a0,d2.w)
/* QL:         move.w  (a1),d2         get status */
    move.w (a1),d2
/* QL:         beq.s   susp_ok         if not suspended, let it carry on */
    beq.s susp_ok
/* QL:         addq.w  #1,d2           is it waiting on another job (wait -2) */
    addq.w #1,d2
/* QL:         bge.s   clr_stat        anything but that, release it */
    bge.s clr_stat
/* QL: brk_off */
brk_off:
/* QL:         move.w  (a1),d2         check if this job is suspended */
    move.w (a1),d2
/* QL:         beq.s   susp_ok         no - go process priority */
    beq.s susp_ok
/* QL:         blt.s   chk_end         it's waiting permanently */
    blt.s chk_end
/* QL:         sub.w   d3,(a1)         tick its clock */
    sub.w d3,(a1)
/* QL:         bgt.s   chk_end         not timed out yet, keep it waiting */
    bgt.s chk_end
/* QL: clr_stat */
clr_stat:
/* QL:         clr.w   (a1)            clear suspension */
    clr.w (a1)
/* QL:         move.l  jb_hold(a0),d2  is this job held on something? */
    move.l jb_hold(a0),d2
/* QL:         beq.s   susp_ok */
    beq.s susp_ok
/* QL:         move.l  d2,a1 */
    move.l d2,a1
/* QL:         sf      (a1)            yes - clear hold flag */
    sf (a1)
/* QL: susp_ok */
susp_ok:
/* QL:         move.b  jb_prior(a0),d2 get current priority */
    move.b jb_prior(a0),d2
/* QL:         bne.s   add_prio */
    bne.s add_prio
/* QL:         move.b  #1,d4           if first time round - just move up one */
    move.b #(1&255),d4
/* QL: add_prio */
add_prio:
/* QL:         add.b   d2,d4           add increment */
    add.b d2,d4
/* QL:         scs     d2              has it overflowed? */
    scs d2
/* QL:         or.b    d2,d4           yes - set it to max */
    or.b d2,d4
/* QL:         move.b  d4,jb_prior(a0) save new priority */
    move.b d4,jb_prior(a0)
/* QL:         cmp.w   d4,d1           is this greater than highest so far */
    cmp.w d4,d1
/* QL:         bcc.s   chk_end */
    bcc.s chk_end
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         move.l  a2,d0           yes - save it */
    move.l a2,d0
/* QL: chk_end2 */
chk_end2:
/* QL:         bra.s   chk_end */
    bra.s chk_end
/* QL: chk_stp */
chk_stp:
/* QL: * Either: a2=a3=bottom of table and d7<>0, or: a2=a3=current job and d7=0 */
/* QL:         lea     4(a3,d7.w),a2   address after highest job */
    lea 4(a3,d7.w),a2
/* QL:         move.l  sv_jbpnt(a6),a3 stop when we've looked at current job */
    move.l sv_jbpnt(a6),a3
/* QL:         not.w   d7              was this the full loop over? */
    not.w d7
/* QL:         bmi.s   chk_end2        no - do rest of scan */
    bmi.s chk_end2
/* QL:         tst.w   d1              check if any job found (priority non-zero) */
    tst.w d1
/* QL:         beq.l   ss_dljob        if not - do (poll)/io operations again */
    beq.w ss_dljob
/* QL:         move.l  d0,sv_jbpnt(a6) set current job table entry */
    move.l d0,sv_jbpnt(a6)
/* QL: * Entry point from ss_init to start up job zero */
/* QL: * super GC requires a0 to be used here! */
/* QL: ss_rj0 */
ss_rj0:
/* QL:         move.l  sv_jbpnt(a6),a0 find address of job in table */
    move.l sv_jbpnt(a6),a0
/* QL:         move.l  (a0),a0         thus base of job */
    move.l (a0),a0
/* QL:         move.l  jb_trapv(a0),sv_trapv(a6) redirect traps */
    move.l jb_trapv(a0),sv_trapv(a6)
/* QL:         add.w   #jb_pc,a0 */
    add.w #jb_pc,a0
/* QL:         move.l  (a0),-(sp)      put the program counter on */
    move.l (a0),-(sp)
/* QL:         move.w  -(a0),-(sp)     and status register */
    move.w -(a0),-(sp)
/* QL:         move.l  -(a0),a1 */
    move.l -(a0),a1
/* QL:         move    a1,usp          restore user stack pointer */
    move a1,usp
/* QL:         assert  jb_d0+8*4,jb_a0 */
/* original assertion: jb_d0+8*4,jb_a0 */
/* QL:         movem.l jb_d0-jb_a0-7*4(a0),d0-d7/a0-a6 and all other registers */
    movem.l ((jb_d0-jb_a0)-(7*4))(a0),d0-d7/a0-a6
/* QL:         rte                     and go! */
    rte 
/* QL:         end */
