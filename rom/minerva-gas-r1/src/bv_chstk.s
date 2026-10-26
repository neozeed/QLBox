/* Generated from original/M/bv/chstk.asm */
/* QL: * Check all stacks for space, or returns space from them */
/* QL:         xdef    bv_chbfx,bv_chbt,bv_chchx,bv_chlnx,bv_chnt,bv_chnlx,bv_chpfx */
.globl bv_chbfx,bv_chbt,bv_chchx,bv_chlnx,bv_chnt,bv_chnlx,bv_chpfx
/* QL:         xdef    bv_chri,bv_chrix,bv_chrt,bv_chss,bv_chssx,bv_chtkx,bv_chvvx */
.globl bv_chri,bv_chrix,bv_chrt,bv_chss,bv_chssx,bv_chtkx,bv_chvvx
/* QL:         xdef    bv_clear,bv_clrt,bv_die,bv_new,bv_om */
.globl bv_clear,bv_clrt,bv_die,bv_new,bv_om
/* QL:         xref    ut_err0,mm_move */
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
/* QL:         include 'win1_m_inc_rt' */
/* QL: * return stack pointers */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: rt.svba ds.l    1       base of args */
.equ rt.svba,0
/* QL: rt.svbl ds.l    1       base of locals */
.equ rt.svbl,4
/* QL: rt.svtl ds.l    1       top of locals */
.equ rt.svtl,8
/* QL: rt.svdfl ds.w   1       def line number */
.equ rt.svdfl,12
/* QL: rt.svfnt ds.b   1       function type */
.equ rt.svfnt,14
/* QL: rt.svswp ds.b   1       args swapped ($ff) or not (0) */
.equ rt.svswp,15
/* QL: rt.lenpr ; length of pr/fn bits */
.equ rt.lenpr,16
/* QL: * add rt.lenpr to next four if total wanted from base */
/* QL:         offset  0 */
/* QL: rt.svrtt ds.b   1       return type - 0 gosub, 1 proc, other fn */
.equ rt.svrtt,0
/* QL: rt.svstm ds.b   1       statement to return to */
.equ rt.svstm,1
/* QL: rt.svlno ds.w   1       line number to return to */
.equ rt.svlno,2
/* QL: rt.svsta ds.l   1       status flags - inlin, sing, index */
.equ rt.svsta,4
/* QL: rt.lentl equ    *+rt.lenpr total length */
.equ rt.lentl,(8+rt.lenpr)
/* QL: * restoring wants offsets working downwards */
/* QL: rt.rsba equ     rt.lentl-rt.svba */
.equ rt.rsba,(rt.lentl-rt.svba)
/* QL: rt.rsbl equ     rt.lentl-rt.svbl */
.equ rt.rsbl,(rt.lentl-rt.svbl)
/* QL: rt.rstl equ     rt.lentl-rt.svtl */
.equ rt.rstl,(rt.lentl-rt.svtl)
/* QL: rt.rsdfl equ    rt.lentl-rt.svdfl */
.equ rt.rsdfl,(rt.lentl-rt.svdfl)
/* QL: rt.rsfnt equ    rt.lentl-rt.svfnt */
.equ rt.rsfnt,(rt.lentl-rt.svfnt)
/* QL: rt.rsswp equ    rt.lentl-rt.svswp */
.equ rt.rsswp,(rt.lentl-rt.svswp)
/* QL: rt.rsrtt equ    rt.lentl-rt.lenpr-rt.svrtt */
.equ rt.rsrtt,((rt.lentl-rt.lenpr)-rt.svrtt)
/* QL: rt.rsstm equ    rt.lentl-rt.lenpr-rt.svstm */
.equ rt.rsstm,((rt.lentl-rt.lenpr)-rt.svstm)
/* QL: rt.rslno equ    rt.lentl-rt.lenpr-rt.svlno */
.equ rt.rslno,((rt.lentl-rt.lenpr)-rt.svlno)
/* QL: rt.rssta equ    rt.lentl-rt.lenpr-rt.svsta */
.equ rt.rssta,((rt.lentl-rt.lenpr)-rt.svsta)
/* QL:         list */
/* QL:         include 'win1_m_inc_stop' */
/* QL: * superbasic stop numbers */
/* QL:         nolist */
/* QL: s.clear equ     0 */
.equ s.clear,0
/* QL: s.new   equ     2 */
.equ s.new,2
/* QL: s.stop  equ     4 */
.equ s.stop,4
/* QL: s.run   equ     6 */
.equ s.run,6
/* QL: s.lrun  equ     8 */
.equ s.lrun,8
/* QL: s.load  equ     10 */
.equ s.load,10
/* QL: s.mrun  equ     12 */
.equ s.mrun,12
/* QL: s.merge equ     14 */
.equ s.merge,14
/* QL: s.retry equ     16 */
.equ s.retry,16
/* QL: s.outm  equ     18 */
.equ s.outm,18
/* QL:         list */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: bv..int equ     6       jb_rela6 flag that tells us if we're an interpreter */
.equ bv..int,6
/* QL: sssize  equ     256     size reqd by parse, exec, calc and m/c procedures */
.equ sssize,256
/* QL: headrm  equ     64      give up to this extra if we have to move anything */
.equ headrm,64
/* QL: rbits   equ     3       round movements to a multiple of eight */
.equ rbits,3
/* QL: * These check space in relevant memory areas and, if necessary, allocate more. */
/* QL: * The schemes go like this: */
/* QL: * 1) A call that already has enough space available should return as fast as */
/* QL: *       can possibly be arranged. */
/* QL: * 2) If a call is not imediately satisfied, the extra amount required is */
/* QL: *       rounded up a little, and this amount is looked for in the central free */
/* QL: *       area. If found, the involved sections are shuffled by this amount. */
/* QL: * 3) In extremis, the amount that the central area fell short by is requested */
/* QL: *       from the system by an albas trap. This will tell us how much extra we */
/* QL: *       got, which may have been rounded up a bit, e.g. to a multiple of 512. */
/* QL: *       The requested amount is added to the original place and any spare is */
/* QL: *       given over into the central area. */
/* QL: * 4) If we can't get enough memory off the system, we trundle off to the */
/* QL: *       return address held in bv_sssav, hopefully to report the problem. */
/* QL: * Actually, there is no requirement to round requests, other ensuring that any */
/* QL: * eventual shuffling of the areas moves them a sufficient even distance. */
/* QL: * The rounding happens to be convenient, as the headroom (which is desirable!) */
/* QL: * can be applied with an "addq" in the code. */
/* QL: * This code now only moves the active parts of each section. */
/* QL: * A serious flaw in the original code was that once it needed to move anything, */
/* QL: * it insisted on finding the originaly requested amount, plus headroom, plus */
/* QL: * rounding. This meant that, for instance, if a large array was re-dimensioned */
/* QL: * a little larger, although a mass of VV area might have been fully released, */
/* QL: * an "out of memory" could be reported when there was no real problem! */
/* QL: * This code now only goes for the, slightly bumped up, extra space needed. */
/* QL: * One other point that could be made here, is that it would be very nice if */
/* QL: * the entry points (or due to history and silly software, an new set) were */
/* QL: * added, that not only checked for the requested amount, but actually */
/* QL: * updated the pointer involved! */
/* QL: * Note: some of these routines are expected to be at fixed offsets from */
/* QL: * bv_chrix by silly s/w. So alter anything here with extreme care. */
/* QL:         section bv_chstk */
.section bv_chstk,"ax"
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i  - space required (bv_ch??x only, others entries set standard values) */
/* QL: * d1-d2 destroyed. */
/* QL: * N.B. d3 is now preserved! */
/* QL: * (A pity, but d2 could be preserved except for silly callers, as above) */
/* QL: bv_chri */
bv_chri:
/* QL:         moveq   #10*6,d1        RI trig stuff needs a fair bit... (lwr) */
    moveq #(10*6),d1
/* QL: bv_chrix */
bv_chrix:
/* QL:         moveq   #bv_rip,d2      arithmetic pointer */
    moveq #bv_rip,d2
/* QL:         bra.s   bv_down */
    bra.s bv_down
/* QL: bv_chbt */
bv_chbt:
/* QL:         moveq   #3*4,d1         3 long words */
    moveq #(3*4),d1
/* QL: *bv_chbtx */
/* QL:         moveq   #bv_btp,d2      backtrack pointer */
    moveq #bv_btp,d2
/* QL:         bra.s   bv_down */
    bra.s bv_down
/* QL: *bv_chtg */
/* QL:         moveq   #4,d1           1 long word */
    moveq #4,d1
/* QL: *bv_chtgx */
/* QL:         moveq   #bv_tgp,d2      temporary graph pointer */
    moveq #bv_tgp,d2
/* QL:         bra.s   bv_down */
    bra.s bv_down
/* QL: bv_chnt */
bv_chnt:
/* QL:         moveq   #1+1+2+4,d1     two byte, a word and a longword */
    moveq #(((1+1)+2)+4),d1
/* QL: *bv_chntx */
/* QL:         moveq   #bv_ntp,d2      name table */
    moveq #bv_ntp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chrt */
bv_chrt:
/* QL:         moveq   #rt.lentl,d1 */
    moveq #rt.lentl,d1
/* QL:         moveq   #bv_rtp,d2      return stack */
    moveq #bv_rtp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chbfx */
bv_chbfx:
/* QL:         moveq   #bv_bfp,d2      basic buffer pointer */
    moveq #bv_bfp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chtkx */
bv_chtkx:
/* QL:         moveq   #bv_tkp,d2      token pointer */
    moveq #bv_tkp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chnlx */
bv_chnlx:
/* QL:         moveq   #bv_nlp,d2      name list pointer */
    moveq #bv_nlp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chvvx */
bv_chvvx:
/* QL:         moveq   #bv_vvp,d2      variable value pointer */
    moveq #bv_vvp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chchx */
bv_chchx:
/* QL:         moveq   #bv_chp,d2      channel table */
    moveq #bv_chp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chlnx */
bv_chlnx:
/* QL:         moveq   #bv_lnp,d2      line number table (identical code to bv_chbtp!) */
    moveq #bv_lnp,d2
/* QL:         bra.s   bv_up */
    bra.s bv_up
/* QL: bv_chpfx */
bv_chpfx:
/* QL:         moveq   #bv_pfp,d2      program file */
    moveq #bv_pfp,d2
/* QL: bv_up */
bv_up:
/* QL:         addq.w  #4,d2           from now on, keep sensible value in d2 */
    addq.w #4,d2
/* QL: * Not a good idea to change the entry values for d2, as there are probably */
/* QL: * nasty people out there who jump in at bv_chrix+2, etc, with their own value! */
/* QL: bv_down */
bv_down:
/* QL:         add.l   -4(a6,d2.w),d1  add in previous pointer */
    add.l (-4)(a6,d2.w),d1
/* QL:         sub.l   0(a6,d2.w),d1   will the areas overlap? */
    sub.l 0(a6,d2.w),d1
/* QL:         bgt.s   meeting         yes - we'll have to move it */
    bgt.s meeting
/* QL: retzero */
retzero:
/* QL:         moveq   #0,d0           this was silly, but Qlib expected it! */
    moveq #0,d0
/* QL: return */
return:
/* QL:         rts */
    rts 
/* QL: * Sanitary, though odd looking, check on stack. No longer zaps a1. */
/* QL: bv_chss */
bv_chss:
/* QL:         moveq   #(sssize-4-2-2)>>1,d1 leave out return address and two words! */
    moveq #((((sssize-4)-2)-2)>>1),d1
/* QL:         add.w   d1,d1           ( ... to be friendly to sb startup.) */
    add.w d1,d1
/* QL: * New entry point! needed when unvr tries to stack a command line! */
/* QL: bv_chssx */
bv_chssx:
/* QL:         add.l   bv_ssp-4(a6),d1 intended offset to low address of stack */
    add.l (bv_ssp-4)(a6),d1
/* QL:         add.l   d1,a6 */
    add.l d1,a6
/* QL:         cmp.l   a7,a6           enough room between sp and previous area? */
    cmp.l a7,a6
/* QL:         sub.l   d1,a6 */
    sub.l d1,a6
/* QL:         ble.s   retzero         yes, so room is available */
    ble.s retzero
/* QL:         subq.l  #8,sp           no enough space, 68020 compatible... */
    subq.l #8,sp
/* QL:         movem.l a6-a7,(sp)      ...take a snapshot of a6 and a7 */
    movem.l a6-a7,(sp)
/* QL:         moveq   #-6*4,d0        we may need to stack 7 regs and a return */
    moveq #((-6)*4),d0
/* QL:         sub.l   (sp)+,d0 */
    sub.l (sp)+,d0
/* QL:         add.l   (sp)+,d0        offset to required base of stack */
    add.l (sp)+,d0
/* QL:         move.l  d0,bv_ssp(a6)    */
    move.l d0,bv_ssp(a6)
/* QL:         sub.l   d0,d1           this is the extra space we're after */
    sub.l d0,d1
/* QL: * Note: if d1 has become negative, it means the stack has overflowed! */
/* QL: * We don't need to take special notice of it here though, as the albas call */
/* QL: * will fail, since it treats requests as unsigned. */
/* QL:         moveq   #bv_ssp,d2      stack pointer offset */
    moveq #bv_ssp,d2
/* QL: * OK. So we have to do some shuffling, but we'll give the requestor a bit extra */
/* QL: * space so they don't come back pestering us too often! */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i  - extra space required */
/* QL: * d2 -i  - space is to be made between pointers at -4(a6,d2.w) and 0(a6,d2.w) */
/* QL: meeting */
meeting:
/* QL:         lsr.l   #rbits,d1       discard odd bits */
    lsr.l #rbits,d1
/* QL:         addq.l  #headrm>>rbits,d1 give headroom+1-1<<rbits to headroom extra */
    addq.l #(headrm>>rbits),d1
/* QL:         lsl.l   #rbits,d1       and round needed space */
    lsl.l #rbits,d1
/* QL: * If we're gonna move things about, make sure we get value for money! */
/* QL:         movem.l d1-d3/a0-a3,-(sp) save local registers */
    movem.l d1-d3/a0-a3,-(sp)
/* QL:         lea     getrela6,a2 */
    lea getrela6(pc),a2
/* QL:         moveq   #mt.extop,d0 */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         assert  6,bv..int */
/* original assertion: 6,bv..int */
/* QL:         add.b   d0,d0 */
    add.b d0,d0
/* QL:         bpl.s   bv_om           not an interpreter, so we die! */
    bpl.s bv_om
/* QL: * See if we can satisfy the request from the middle of the basic area */
/* QL: chkfree */
chkfree:
/* QL:         move.l  (sp),d1         get extra space requested */
    move.l (sp),d1
/* QL:         add.l   bv_chang-4(a6),d1 add bottom of free space area */
    add.l (bv_chang-4)(a6),d1
/* QL:         sub.l   bv_chang(a6),d1 compare to top of free space */
    sub.l bv_chang(a6),d1
/* QL:         ble.s   midok           enough space there - go get it */
    ble.s midok
/* QL: * Not enough space in middle. have to add a block to the top and move up */
/* QL: albas */
albas:
/* QL:         moveq   #mt.albas,d0 */
    moveq #mt.albas,d0
/* QL:         trap    #1              get the extra and move basic */
    trap #1
/* QL:         tst.l   d0              did we get our memory OK? */
    tst.l d0
/* QL:         bne.s   outmem          no - report out of memory */
    bne.s outmem
/* QL:         moveq   #bv_chang,d2    it may be going to the middle */
    moveq #bv_chang,d2
/* QL:         move.l  4(sp),d3        get the requested pointer */
    move.l 4(sp),d3
/* QL:         cmp.w   d2,d3           are we trying to add between top areas? */
    cmp.w d2,d3
/* QL:         ble.s   uptop           no - that's straightforward now */
    ble.s uptop
/* QL: * We've found new space from the system and need to put between upper areas */
/* QL:         move.l  d3,d2           transfer space to below requested upper area */
    move.l d3,d2
/* QL:         sub.l   d1,(sp)         remainder to be transferred from middle */
    sub.l d1,(sp)
/* QL: * ( This is likely to be negative, i.e. give some of the new space to middle ) */
/* QL: * ( There is also the (unlikely?) event that it might be zero! ) */
/* QL: uptop */
uptop:
/* QL:         moveq   #bv_endpt+4,d3  space coming from top of basic area */
    moveq #(bv_endpt+4),d3
/* QL:         bsr.s   moveset         move up the stack, at least */
    bsr.s moveset
/* QL: midok */
midok:
/* QL:         move.l  (sp)+,d1        get extra space required */
    move.l (sp)+,d1
/* QL:         move.l  (sp)+,d2        restore requested pointer */
    move.l (sp)+,d2
/* QL:         moveq   #bv_chang,d3    middle pointer offset */
    moveq #bv_chang,d3
/* QL:         bsr.s   moveset */
    bsr.s moveset
/* QL:         movem.l (sp)+,d3/a0-a3  restore all local registers */
    movem.l (sp)+,d3/a0-a3
/* QL: retz2 */
retz2:
/* QL:         bra.s   retzero */
    bra.s retzero
/* QL: * Hmmm.... someone has asked for space beyond the available, but they're not */
/* QL: * an interpreter! Only thing to do is kill them off. */
/* QL: bv_om */
bv_om:
/* QL:         moveq   #err.om,d0      we were out of memory */
    moveq #err.om,d0
/* QL:         jsr     ut_err0(pc)     try to write error message to chans 0/1 */
    jsr ut_err0(pc)
/* QL: bv_die */
bv_die:
/* QL:         move.l  d0,d3           tell any waiting jobs */
    move.l d0,d3
/* QL:         moveq   #-1,d1          commit suicide */
    moveq #(-1),d1
/* QL:         moveq   #mt.frjob,d0 */
    moveq #mt.frjob,d0
/* QL:         trap    #1 */
    trap #1
/* QL: * We ask the system for more memory, and it said "No!" ... boo hoo. */
/* QL: outmem */
outmem:
/* QL:         move.w  #s.outm,bv_stopn(a6) set the stop number */
    move.w #s.outm,bv_stopn(a6)
/* QL:         clr.b   bv_cont(a6)     tell it to stop, and set zero ccr */
    clr.b bv_cont(a6)
/* QL:         move.l  bv_ssbas(a6),a0 top of basic wrt base of basic */
    move.l bv_ssbas(a6),a0
/* QL:         sub.l   bv_sssav(a6),a0 get to the saved position in start */
    sub.l bv_sssav(a6),a0
/* QL:         lea     -4(a6,a0.l),sp  here is the return, we hope */
    lea (-4)(a6,a0.l),sp
/* QL:         rts */
    rts 
/* QL: * Clear low areas for new, etc. Move the areas individually, for speed. */
/* QL: * The BF has been reset to minimal, and TK + PF are empty and at bfp. */
/* QL: * Upper stacks have been removed. */
/* QL: * d0 -  o- 0 */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_new */
bv_new:
/* QL:         moveq   #bv_ntbas,d3    move name table onwards down onto program file */
    moveq #bv_ntbas,d3
/* QL:         bra.s   clrlp */
    bra.s clrlp
/* QL: * Clear and return room for a clear, etc. VV onward are squashed down here. */
/* QL: * Upper stacks have been removed. */
/* QL: * d0 -  o- 0 */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_clear */
bv_clear:
/* QL:         moveq   #bv_vvbas,d3    move VV onwards down to butt into each other */
    moveq #bv_vvbas,d3
/* QL: clrlp */
clrlp:
/* QL:         move.l  d3,-(sp) */
    move.l d3,-(sp)
/* QL:         bsr.s   clrm */
    bsr.s clrm
/* QL:         move.l  (sp)+,d3 */
    move.l (sp)+,d3
/* QL:         addq.l  #8,d3 */
    addq.l #8,d3
/* QL:         cmp.w   #bv_chang,d3 */
    cmp.w #bv_chang,d3
/* QL:         bne.s   clrlp */
    bne.s clrlp
/* QL: * There has to be some way of building the above into the main routine, but it */
/* QL: * all seems too complicated to me at the moment! */
/* QL: * Move top section of basic down and then try to release space to system */
/* QL:         moveq   #bv_endpt+4,d2  current top of basic area */
    moveq #(bv_endpt+4),d2
/* QL:         move.l  0(a6,d3.w),d1   get base of next area */
    move.l 0(a6,d3.w),d1
/* QL:         sub.l   -4(a6,d3.w),d1  less top of area gives its current free amount */
    sub.l (-4)(a6,d3.w),d1
/* QL:         and.w   #-512,d1        round space to a multiple of 512 (2^9) */
    and.w #(-512),d1
/* QL:         bsr.s   moveset         move spare room in middle to top of basic */
    bsr.s moveset
/* QL:         moveq   #mt.rebas,d0    release space at top of basic area and move */
    moveq #mt.rebas,d0
/* QL:         trap    #1              the whole shebang up. sp changed too. */
    trap #1
/* QL:         bra.s   retz2           just to be nice, say d0=0 */
    bra.s retz2
/* QL: * Clear top of rt stack, so ln can come down */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_clrt */
bv_clrt:
/* QL:         moveq   #bv_lnbas,d3 */
    moveq #bv_lnbas,d3
/* QL: clrm */
clrm:
/* QL:         move.l  d3,d2 */
    move.l d3,d2
/* QL:         addq.l  #8,d2 */
    addq.l #8,d2
/* QL:         move.l  0(a6,d3.w),d1   get base of area being moved */
    move.l 0(a6,d3.w),d1
/* QL:         sub.l   -4(a6,d3.w),d1  less top of prior area gives free space */
    sub.l (-4)(a6,d3.w),d1
/* QL:         and.w   #-2,d1          make it even */
    and.w #(-2),d1
/* QL: * A routine to manage basic areas. */
/* QL: * The call sequence is kept as simple as possible to avoid having lots of */
/* QL: * complex code in the calling routines. */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -ip - even amount of space to transfer (positive or negative) */
/* QL: * d2 -i  - offset to between pointer pairs where d1 is to be added to the space */
/* QL: * d3 -i  - ditto, but where d1 is to be subtracted from the space */
/* QL: * a6 -ip - base of basic area */
/* QL: * a7 -i o- basic stack pointer (updated if need be) */
/* QL: * a0-a2 destroyed */
/* QL: movsav  reg     d1/d6-d7 */
/* QL: moveset */
moveset:
/* QL:         movem.l movsav,-(sp) */
    movem.l d1/d6-d7,-(sp)
/* QL:         lea     moveop,a2       code to call */
    lea moveop(pc),a2
/* QL:         moveq   #mt.extop,d0    do it in supervisor mode */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         movem.l (sp)+,movsav */
    movem.l (sp)+,d1/d6-d7
/* QL:         rts */
    rts 
/* QL: moveop */
moveop:
/* QL:         cmp.w   d2,d3 */
    cmp.w d2,d3
/* QL:         bgt.s   movdir */
    bgt.s movdir
/* QL:         exg     d2,d3           turn it round, so we have: */
    exg d2,d3
/* QL:         neg.l   d1              amount by which to relocate pointers */
    neg.l d1
/* QL: movdir */
movdir:
/* QL:         moveq   #8,d6           pointer step */
    moveq #8,d6
/* QL:         move.l  d1,d7 */
    move.l d1,d7
/* QL:         beq.s   movstp          if no actual movement, get out now! */
    beq.s movstp
/* QL:         bmi.s   movnxt */
    bmi.s movnxt
/* QL:         exg     d2,d3           if up, we need to move upper areas first */
    exg d2,d3
/* QL:         neg.w   d6 */
    neg.w d6
/* QL:         add.w   d6,d3           remember to stop in the right place */
    add.w d6,d3
/* QL:         bra.s   movadd */
    bra.s movadd
/* QL: movptr */
movptr:
/* QL:         lea     4(a6,d2.w),a1   pointer pair to operate on */
    lea 4(a6,d2.w),a1
/* QL:         add.l   d7,(a1)         relocate high pointer */
    add.l d7,(a1)
/* QL:         move.l  (a1),d1         get its new value */
    move.l (a1),d1
/* QL:         add.l   d7,-(a1)        relocate low pointer */
    add.l d7,-(a1)
/* QL:         move.l  (a1),a0         get its new value */
    move.l (a1),a0
/* QL:         cmp.w   #bv_vvbas,d2    are we moving the VV area ... */
    cmp.w #bv_vvbas,d2
/* QL:         bne.s   isss */
    bne.s isss
/* QL:         tst.l   bv_vvfre(a6)    ... and does it have any free space set? */
    tst.l bv_vvfre(a6)
/* QL:         beq.s   ssok */
    beq.s ssok
/* QL:         add.l   d7,bv_vvfre(a6) yes, add movement to base free space ptr */
    add.l d7,bv_vvfre(a6)
/* QL: isss */
isss:
/* QL:         cmp.w   #bv_ssp,d2      are we moving the SS area? */
    cmp.w #bv_ssp,d2
/* QL:         bne.s   ssok */
    bne.s ssok
/* QL:         move    usp,a0          yes - get the real SS pointer */
    move usp,a0
/* QL:         add.l   d7,a0           relocate it */
    add.l d7,a0
/* QL:         move    a0,usp          and save it */
    move a0,usp
/* QL:         sub.l   a6,a0           make it relative for a moment */
    sub.l a6,a0
/* QL: * There is a query here... should this try to record the new bv_ssp(a6) value? */
/* QL: * All it essentially needs is: */
/* QL: *       move.l  a0,(a1)         set exact ssp value */
/* QL: * However, we get out quick when the movement is zero, and it would miss this. */
/* QL: ssok */
ssok:
/* QL:         sub.l   a0,d1           overall size of area */
    sub.l a0,d1
/* QL:         add.l   a6,a0           make new base absolute */
    add.l a6,a0
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         sub.l   d7,a1           form old absolute base */
    sub.l d7,a1
/* QL:         jsr     mm_move(pc) */
    jsr mm_move(pc)
/* QL: movadd */
movadd:
/* QL:         add.w   d6,d2 */
    add.w d6,d2
/* QL: movnxt */
movnxt:
/* QL:         cmp.w   d2,d3 */
    cmp.w d2,d3
/* QL:         bne.s   movptr */
    bne.s movptr
/* QL: movstp */
movstp:
/* QL:         rte */
    rte 
/* QL: * Called in supervisor mode to get jb_rela6 flag byte */
/* QL: getrela6 */
getrela6:
/* QL:         move.l  d0,a2 */
    move.l d0,a2
/* QL:         move.l  sv_jbpnt(a2),a2 */
    move.l sv_jbpnt(a2),a2
/* QL:         move.l  (a2),a2 */
    move.l (a2),a2
/* QL:         move.b  jb_rela6(a2),d0 hang on... what am I? ... */
    move.b jb_rela6(a2),d0
/* QL:         rte */
    rte 
/* QL:         end */
