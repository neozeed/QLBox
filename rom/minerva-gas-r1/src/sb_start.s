/* Generated from original/M/sb/start.asm */
/* QL: * Startup program for basic */
/* QL:         xdef    sb_start */
.globl sb_start
/* QL:         xref    bp_alvv,bp_chnew,bp_chnid,bp_init */
/* QL:         xref    bv_chnlx,bv_chnt,bv_namei,bv_om */
/* QL:         xref    cn_date,cn_day */
/* QL:         xref    ib_clvv */
/* QL:         xref    ii_clock */
/* QL:         xref    sb_unvr */
/* QL:         xref    ut_con,ut_err,ut_mint,ut_mtext,ut_wrdef */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
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
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL: * Parameters for window definitions: initial, monitor and TV */
/* QL: ;        if ntsc */
/* QL: ;tvmode  equ     2 */
/* QL: ;tot_ht  equ     192 number of scan lines for 525 version */
/* QL: ;ch_ht   equ     8 */
/* QL: ;tv_wid  equ     420 */
/* QL: ;        else */
/* QL: tvmode  equ     1 */
.equ tvmode,1
/* QL: tot_ht  equ     256 number of scan lines for 625 version */
.equ tot_ht,256
/* QL: ch_ht   equ     10 */
.equ ch_ht,10
/* QL: tv_wid  equ     448 */
.equ tv_wid,448
/* QL: ;        endif */
/* QL: ch_wid  equ     6 */
.equ ch_wid,6
/* QL: h_0     equ     4*ch_ht */
.equ h_0,(4*ch_ht)
/* QL: h_n     equ     20*ch_ht */
.equ h_n,(20*ch_ht)
/* QL: x_n     equ     (512-tv_wid)/4*2 */
.equ x_n,(((512-tv_wid)/4)*2)
/* QL: y_0     equ     tot_ht-h_0 */
.equ y_0,(tot_ht-h_0)
/* QL: y_n     equ     y_0-h_n */
.equ y_n,(y_0-h_n)
/* QL: h_c     equ     5*ch_ht+10 */
.equ h_c,((5*ch_ht)+10)
/* QL: y_c     equ     tot_ht-h_c */
.equ y_c,(tot_ht-h_c)
/* QL: w_c     equ     37*ch_wid+8 */
.equ w_c,((37*ch_wid)+8)
/* QL: x_c     equ     x_n */
.equ x_c,x_n
/* QL: h_b     equ     3*ch_ht+3 */
.equ h_b,((3*ch_ht)+3)
/* QL: y_b     equ     y_c+5 */
.equ y_b,(y_c+5)
/* QL: w_b     equ     23*ch_wid+4 */
.equ w_b,((23*ch_wid)+4)
/* QL: x_b     equ     x_c+(w_c-w_b+12*ch_wid)/4*2 */
.equ x_b,(x_c+((((w_c-w_b)+(12*ch_wid))/4)*2))
/* QL: minss   equ     256     minimum stack */
.equ minss,256
/* QL:         section sb_start */
.section sb_start,"ax"
/* QL: * Entry point for basic start up. */
/* QL: * a0 -i  - initial command channel, or zero */
/* QL: * a4 -i  - job 0 restart flags in lsb */
/* QL: * a5 -i  - total size of the basic area */
/* QL: * a6 -ip - bottom of the basic area */
/* QL: * a7 -i  - pointer to standard exec parameters (count/chans/length/text) */
/* QL: setbv */
setbv:
/* QL:         move.l  d1,-(a6) */
    move.l d1,-(a6)
/* QL:         dbra    d0,setbv */
    dbra d0,setbv
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: sb_start */
sb_start:
/* QL:         move.l  a5,d3 */
    move.l a5,d3
/* QL:         add.l   a6,d3 */
    add.l a6,d3
/* QL:         sub.l   sp,d3           remember stack offset for out-of-mem setup */
    sub.l sp,d3
/* QL:         assert  0,bv_chang&3,bv_endpt&3,bv_end&3 */
/* original assertion: 0,bv_chang&3,bv_endpt&3,bv_end&3 */
/* QL:         moveq   #bv_end>>2,d2   size of bv area */
    moveq #(bv_end>>2),d2
/* QL:         assert  minss,bv_end */
/* original assertion: minss,bv_end */
/* QL:         lsl.w   #2+1,d2 */
    lsl.w #(2+1),d2
/* QL:         cmp.l   d2,a5           have we been given enough space to start with? */
    cmp.l d2,a5
/* QL:         pea     bv_om(pc)       if anything goes wrong during startup, die! */
    pea bv_om(pc)
/* QL:         blt.s   rts1            no - don't go on... */
    blt.s rts1
/* QL:         pea     sb_unvr(pc)     get ready to enter superbasic universe */
    pea sb_unvr(pc)
/* QL: parms   equ     2*4             we have two longwords on stack before params */
.equ parms,(2*4)
/* QL:         lsr.w   #1,d2 */
    lsr.w #1,d2
/* QL:         add.w   d2,a6 */
    add.w d2,a6
/* QL:         moveq   #0,d1           top of bv area all zero */
    moveq #0,d1
/* QL:         moveq   #(bv_end-bv_endpt-4)>>2-1,d0 */
    moveq #((((bv_end-bv_endpt)-4)>>2)-1),d0
/* QL:         bsr.s   setbv */
    bsr.s setbv
/* QL:         move.w  a5,d1 */
    move.w a5,d1
/* QL:         move.l  d1,-(a6)        set ssbas to top of basic area */
    move.l d1,-(a6)
/* QL:         sub.w   d2,d1           and next bunch point to the minimum stack there */
    sub.w d2,d1
/* QL:         moveq   #(bv_endpt-bv_chang)>>2-1,d0 */
    moveq #(((bv_endpt-bv_chang)>>2)-1),d0
/* QL:         bsr.s   setbv */
    bsr.s setbv
/* QL:         move.l  d2,d1           last bunch point to top of bv area */
    move.l d2,d1
/* QL:         moveq   #bv_chang>>2-1,d0 */
    moveq #((bv_chang>>2)-1),d0
/* QL:         bsr.s   setbv           (a6 back to normal now) */
    bsr.s setbv
/* QL:         move.l  d3,bv_sssav(a6) save out-of-memory as death for now */
    move.l d3,bv_sssav(a6)
/* QL:         move.l  a0,bv_comch(a6) save any input command channel */
    move.l a0,bv_comch(a6)
/* QL: * In-line clause and auto/edit flags are off */
/* QL:         st      bv_rand+2(a6)   preset random number */
    st (bv_rand+2)(a6)
/* QL:         st      bv_cont(a6)     turn continue flag on (ie. stop off) */
    st bv_cont(a6)
/* QL: *        st      bv_print(a6)    set print from prtok flag on */
/* QL: * surely the above is a waste of time? */
/* QL:         jsr     ib_clvv(pc)     hit anything else that a clear would set up */
    jsr ib_clvv(pc)
/* QL: * We now have tables set up enough to become an interpreter */
/* QL:         jsr     bv_namei(pc)    go fetch m/c names, leaves RAM top in a3 ... */
    jsr bv_namei(pc)
/* QL:         move.l  d4,d0           ... and job id in d4 */
    move.l d4,d0
/* QL:         beq.l   ini_job0        if we're job zero, go start up now */
    beq.w ini_job0
/* QL:         sub.l   a4,a4           access passed info relative to sp */
    sub.l a4,a4
/* QL:         move.w  parms(sp),d5    get number of channels passed */
    move.w parms(sp),d5
/* QL:         beq.s   nochans         none - forget it */
    beq.s nochans
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         move.w  d5,d2           a counter (we assume it's positive!) */
    move.w d5,d2
/* QL: copych */
copych:
/* QL:         move.l  parms+2(sp,a4.l),a0 */
    move.l (parms+2)(sp,a4.l),a0
/* QL:         addq.l  #4,a4 */
    addq.l #4,a4
/* QL: samech */
samech:
/* QL:         addq.w  #1,d1           next channel to open */
    addq.w #1,d1
/* QL:         cmp.w   #2,d1           are we about to open #2? */
    cmp.w #2,d1
/* QL:         beq.s   samech          yes - skip that */
    beq.s samech
/* QL:         jsr     bp_chnew(pc) */
    jsr bp_chnew(pc)
/* QL:         subq.w  #1,d2           have we finished the channel list? */
    subq.w #1,d2
/* QL:         bgt.s   copych          no - skip test for duplicating channel #0 */
    bgt.s copych
/* QL:         tst.w   d1              have we opened channel #1 yet? */
    tst.w d1
/* QL:         beq.s   samech          no - let it repeat the same id as #0 */
    beq.s samech
/* QL: nochans */
nochans:
/* QL: * Build CMD$ as an initial variable */
/* QL:         moveq   #1+4,d1 */
    moveq #(1+4),d1
/* QL:         jsr     bv_chnlx(pc) */
    jsr bv_chnlx(pc)
/* QL:         jsr     bv_chnt(pc) */
    jsr bv_chnt(pc)
/* QL:         move.l  bv_ntp(a6),a3 */
    move.l bv_ntp(a6),a3
/* QL:         move.w  #$201,0(a6,a3.l) t.var<<8|t.str */
    move.w #0x201,0(a6,a3.l)
/* QL:         addq.l  #1+4,bv_nlp(a6) */
    addq.l #(1+4),bv_nlp(a6)
/* QL:         movem.l bv_nlbas(a6),d3/a1 */
    movem.l bv_nlbas(a6),d3/a1
/* QL:         lea     cmds+1+4,a0 */
    lea ((cmds+1)+4)(pc),a0
/* QL: ncpy */
ncpy:
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  (a0),0(a6,a1.l) copy in characters of CMD$'s name */
    move.b (a0),0(a6,a1.l)
/* QL:         tst.b   -(a0) */
    tst.b -(a0)
/* QL:         bne.s   ncpy */
    bne.s ncpy
/* QL:         sub.w   d3,a1 */
    sub.w d3,a1
/* QL:         move.w  a1,2(a6,a3.l)   set namelist offset */
    move.w a1,2(a6,a3.l)
/* QL:         st      4(a6,a3.l)      just in case... */
    st 4(a6,a3.l)
/* QL:         addq.l  #8,bv_ntp(a6) */
    addq.l #8,bv_ntp(a6)
/* QL:         moveq   #2,d1 */
    moveq #2,d1
/* QL:         add.w   parms+2(sp,a4.l),d1 get command length (we'll trust it's ok) */
    add.w (parms+2)(sp,a4.l),d1
/* QL: * It would be a bit of a waste of code here to check the length out. */
/* QL: * We'll just put up with the fact that other than 0..32766 will cause problems, */
/* QL: * with -2 and -1, at least, possibly crashing the machine! */
/* QL:         jsr     bp_alvv(pc) */
    jsr bp_alvv(pc)
/* QL: copycmd */
copycmd:
/* QL:         move.b  parms+2(sp,a4.l),0(a6,a0.l) */
    move.b (parms+2)(sp,a4.l),0(a6,a0.l)
/* QL:         addq.l  #1,a4 */
    addq.l #1,a4
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.l  #1,d1 */
    subq.l #1,d1
/* QL:         bne.s   copycmd */
    bne.s copycmd
/* QL:         tst.w   d5              did we get any channels passed in? */
    tst.w d5
/* QL:         bne.s   rts2            yes - that's fine */
    bne.s rts2
/* QL:         move.l  bv_comch(a6),d4 did we get a command channel? */
    move.l bv_comch(a6),d4
/* QL:         beq.l   all_wind        no - we have no channels, go produce defaults */
    beq.w all_wind
/* QL: rts2 */
rts2:
/* QL:         rts                     enter superbasic */
    rts 
/* QL: plug_chk */
plug_chk:
/* QL:         cmp.l   #$4afb0001,(a3) has it got the right id? */
    cmp.l #0x4afb0001,(a3)
/* QL:         bne.s   plug_inc        ... no */
    bne.s plug_inc
/* QL:         move.l  #$c000,a1       start from first conceivable slot */
    move.l #0xc000,a1
/* QL:         bra.s   plug_ent */
    bra.s plug_ent
/* QL: plug_dup */
plug_dup:
/* QL:         move.l  a3,a2 */
    move.l a3,a2
/* QL:         move.l  a1,a4 */
    move.l a1,a4
/* QL:         moveq   #128-1,d1       we'll check the first 512 bytes for a match */
    moveq #(128-1),d1
/* QL: plug_cp */
plug_cp:
/* QL:         cmp.l   (a4)+,(a2)+     does this still look like the same plug-in */
    cmp.l (a4)+,(a2)+
/* QL:         dbne    d1,plug_cp      keep matching */
    dbne d1,plug_cp
/* QL:         beq.s   plug_inc        512 bytes the same! presumably the same plug-in */
    beq.s plug_inc
/* QL:         exg     a1,a3 */
    exg a3,a1
/* QL:         bsr.s   plug_inc        move to next possible slot */
    bsr.s plug_inc
/* QL:         exg     a1,a3 */
    exg a3,a1
/* QL: plug_ent */
plug_ent:
/* QL:         cmp.l   a3,a1           are we back up to this one yet? */
    cmp.l a3,a1
/* QL:         bne.s   plug_dup        no - keep checking for replicates */
    bne.s plug_dup
/* QL: * The above attempts to avoid mapping in ROM's that appear more than once in */
/* QL: * the address space. */
/* QL: * This happens when address lines are not fully decoded and in cases like the */
/* QL: * Trump Card, which makes it's ROM at $10000 appear also at $c0000. */
/* QL: * Another point: the total ROM compared should be kept reasonably small, to */
/* QL: * avoid problems with ROM's that have their high addresses as hardware control. */
/* QL:         lsl.w   12(sp)          check if i2c is inhibiting this ROM */
    lsl.w 12(sp)
/* QL:         bcs.s   plug_inc        it is, so skip (works ok with duplicates) */
    bcs.s plug_inc
/* QL:         lea     8(a3),a1        write message from plug-in */
    lea 8(a3),a1
/* QL:         jsr     ut_mtext(pc) */
    jsr ut_mtext(pc)
/* QL:         move.w  4(a3),d0        get basic procedures from plug-in */
    move.w 4(a3),d0
/* QL:         beq.s   plug_exe */
    beq.s plug_exe
/* QL:         lea     0(a3,d0.w),a1   set the base address of procedure list */
    lea 0(a3,d0.w),a1
/* QL:         jsr     bp_init(pc)     set up the procedures */
    jsr bp_init(pc)
/* QL: plug_exe */
plug_exe:
/* QL:         move.w  6(a3),d0        execute plug-in initialisation */
    move.w 6(a3),d0
/* QL:         beq.s   plug_inc */
    beq.s plug_inc
/* QL:         jsr     0(a3,d0.w) */
    jsr 0(a3,d0.w)
/* QL: plug_inc */
plug_inc:
/* QL:         add.w   #$4000,a3       move on to next */
    add.w #0x4000,a3
/* QL:         cmp.l   #$18000,a3      is it end of low bits? (TK2!) */
    cmp.l #0x18000,a3
/* QL:         bne.s   plug_meg */
    bne.s plug_meg
/* QL:         move.l  8(sp),a3        set a3 to RAM top */
    move.l 8(sp),a3
/* QL: plug_meg */
plug_meg:
/* QL:         move.l  0,d0            pick up value from locn 0 */
    move.l 0,d0
/* QL:         rts */
    rts 
/* QL: ini_job0 */
ini_job0:
/* QL:         move.l  a4,-(sp)        save restart flags and clear ROM inhibits */
    move.l a4,-(sp)
/* QL:         move.l  a3,-(sp)        save RAM top address ... */
    move.l a3,-(sp)
/* QL:         move.l  a3,-(sp)        ... twice, to simplify ROM replication check */
    move.l a3,-(sp)
/* QL:         bsr.l   ini_disp */
    bsr.w ini_disp
/* QL: * Look for plug-ins */
/* QL:         btst    #1,11(sp)       have we been told not to scan ROM's? */
    btst #1,11(sp)
/* QL:         bne.s   plug_out        yes - skip the ROM scan */
    bne.s plug_out
/* QL:         move.l  #$c000,a3       first check ROM cartridge, etc */
    move.l #0xc000,a3
/* QL: plug_on */
plug_on:
/* QL:         bsr.s   plug_chk */
    bsr.s plug_chk
/* QL:         cmp.l   #$100000,a3 */
    cmp.l #0x100000,a3
/* QL:         bcs.s   plug_on         always scan first megabyte */
    bcs.s plug_on
/* QL:         cmp.l   (a3),d0         does it now look like we're wrapping? */
    cmp.l (a3),d0
/* QL:         bne.s   plug_on         no - keep going */
    bne.s plug_on
/* QL: plug_out */
plug_out:
/* QL:         assert  0,plug_on+2+12-plug_out */
/* original assertion: 0,plug_on+2+12-plug_out */
/* QL: * Above is all rearranged to cope with the horrendous MCS interface, which */
/* QL: * does the ROM check for itself, and then discards its own return address, adds */
/* QL: * twelve to the top of the stack and returns.... arghhhhh....!!!! */
/* QL:         addq.l  #8,sp           discard the RAM top addresses */
    addq.l #8,sp
/* QL:         moveq   #$0010,d3       f1-f4 bit, timeout and key count!!! */
    moveq #0x0010,d3
/* QL:         and.l   (sp),d3         test that flag */
    and.l (sp),d3
/* QL:         bne.s   go_key          not zero - initial tiny wait for f1-f4 */
    bne.s go_key
/* QL: * Find the mode */
/* QL: read_key */
read_key:
/* QL:         move.w  #$210,d3        normaly hang about for around 10 secs */
    move.w #0x210,d3
/* QL: go_key */
go_key:
/* QL:         moveq   #io.fbyte,d0 */
    moveq #io.fbyte,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         addq.l  #-err.nc,d0     check if timed out */
.word 20608|((((-err.nc))&7)<<9)
/* QL:         beq.s   set_mde1        yes, just use what we started with */
    beq.s set_mde1
/* QL:         addq.b  #8,d1           f5 key = $f8 */
    addq.b #8,d1
/* QL:         add.b   d1,d3           check if {ctrl+}{shift+}f1-f4 (d3.lsb = $10) */
    add.b d1,d3
/* QL:         bcc.s   read_key        not f1-f4, read again */
    bcc.s read_key
/* QL:         roxl.b  #5,d3           set quick reset bit and dual to extend */
    roxl.b #5,d3
/* QL:         ror.b   #3,d3           slide TV/128k/ROM/quick bits down */
    ror.b #3,d3
/* QL:         roxr.b  #1,d3           slip in the dual bit */
    roxr.b #1,d3
/* QL:         moveq   #$40000>>16,d1  start getting 128k mask ready */
    moveq #(0x40000>>16),d1
/* QL:         bset    d1,d3           flag byte now: dual/0/0/f1-f4/TV/128k/ROM/quick */
    bset d1,d3
/* QL:         and.b   d3,d1           isolate 128k bit */
    and.b d3,d1
/* QL:         swap    d1              put it up in msw, now $40000 if 128k requested */
    swap d1
/* QL:         move.b  d3,d1           d1.l now ready for re-reset call */
    move.b d3,d1
/* QL:         move.l  (sp),d3         get top of stack */
    move.l (sp),d3
/* QL:         move.l  d1,(sp)         replace top of stack */
    move.l d1,(sp)
/* QL:         eor.b   d1,d3           check which bits differ */
    eor.b d1,d3
/* QL:         and.b   #%10000110,d3   do dualscreen, 128k and romscan bits agree? */
    and.b #(0b10000110&255),d3
/* QL: set_mde1 */
set_mde1:
/* QL:         beq.s   set_mode        yes - we're happy to leave that as it is */
    beq.s set_mode
/* QL:         jmp     390             no - go to magic reset location with d1.l set */
    jmp 390
/* QL: get_mode */
get_mode:
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #mt.dmode,d0 */
    moveq #mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         lea     mon_def,a1      address of first monitor mode window definition */
    lea mon_def(pc),a1
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         beq.s   rts3 */
    beq.s rts3
/* QL:         lea     tv_def,a1       address of first TV mode window definition */
    lea tv_def(pc),a1
/* QL: rts3 */
rts3:
/* QL:         rts */
    rts 
/* QL: * No channels at all were passed. Do standard ones. */
/* QL: all_wind */
all_wind:
/* QL:         bsr.s   get_mode        sets up definition pointer for us */
    bsr.s get_mode
/* QL: ini_wind */
ini_wind:
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         bsr.s   def_wind        open window #0 */
    bsr.s def_wind
/* QL:         pea     def_next        open #1 and #2, then return */
    pea def_next(pc)
/* QL: def_next */
def_next:
/* QL:         addq.w  #1,d4           then do next # */
    addq.w #1,d4
/* QL:         add.w   #wdef_len,a1    step on pointer */
    add.w #wdef_len,a1
/* QL: def_wind */
def_wind:
/* QL:         jsr     ut_con(pc)      open a console */
    jsr ut_con(pc)
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         jmp     bp_chnew(pc)    and set up the basic channel */
    jmp bp_chnew(pc)
/* QL: * Maybe have a go at allowing TV windows but monitor mode, one day... or use */
/* QL: * both spare bits (6..5) as TV mode? (That even might get NTSC going!) */
/* QL: set_mode */
set_mode:
/* QL:         assert  1,tvmode */
/* original assertion: 1,tvmode */
/* QL:         moveq   #8,d1 */
    moveq #8,d1
/* QL:         and.l   (sp)+,d1        last use of restart flags, set display type */
    and.l (sp)+,d1
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         lsr.b   #3,d2           set monitor/TV mode */
    lsr.b #3,d2
/* QL:         moveq   #mt.dmode,d0    n.b. nice... all channels have black paper */
    moveq #mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         bsr.s   get_mode        sets up definition pointer for us */
    bsr.s get_mode
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         bsr.s   mov_wind        put #0 in proper place */
    bsr.s mov_wind
/* QL:         bsr.s   mov_next        put #1 in proper place */
    bsr.s mov_next
/* QL:         bsr.s   mov_next        put #2 in proper place */
    bsr.s mov_next
/* QL: * Look for a boot file */
/* QL:         moveq   #-3*boot_len,d4 */
    moveq #((-3)*boot_len),d4
/* QL: getboot */
getboot:
/* QL:         addq.w  #boot_len,d4    'mdv1_boot' string on 2nd try */
.word 20548|(((boot_len)&7)<<9)
/* QL:         beq.s   rts4            no boot file, so go enter superbasic */
    beq.s rts4
/* QL:         moveq   #io.open,d0     try to open a boot file */
    moveq #io.open,d0
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #io.share,d3 */
    moveq #io.share,d3
/* QL:         lea     boot+2*boot_len(pc,d4.w),a0 try plain 'boot' string first time */
    lea (boot+(2*boot_len))(pc,d4.w),a0
/* QL:         trap    #2 */
    trap #2
/* QL:         tst.l   d0              did the file open ok? */
    tst.l d0
/* QL:         bne.s   getboot         no - try next one */
    bne.s getboot
/* QL:         move.l  a0,bv_comch(a6) set command channel */
    move.l a0,bv_comch(a6)
/* QL: rts4 */
rts4:
/* QL:         rts                     enter superbasic */
    rts 
/* QL: mov_next */
mov_next:
/* QL:         addq.w  #1,d4           do next # */
    addq.w #1,d4
/* QL:         add.w   #wdef_len,a1    step on pointer */
    add.w #wdef_len,a1
/* QL: mov_wind */
mov_wind:
/* QL:         bsr.s   chnid           select channel */
    bsr.s chnid
/* QL: wrdef */
wrdef:
/* QL:         jmp     ut_wrdef(pc)    return via window redefinition */
    jmp ut_wrdef(pc)
/* QL: boot    dc.w    4,'boot' */
.balign 2,0
boot:
dc_anchor_1111:
.word 4
.byte 98,111,111,116
.balign 2,0
/* QL: mdv1_   dc.w    9,'mdv1_boot' */
.balign 2,0
mdv1_:
dc_anchor_1118:
.word 9
.byte 109,100,118,49,95,98,111,111,116
.balign 2,0
/* QL: boot_len equ mdv1_-boot */
.equ boot_len,(mdv1_-boot)
/* QL: ini_disp */
ini_disp:
/* QL:         lea     ini_def,a1 */
    lea ini_def(pc),a1
/* QL:         bsr.s   ini_wind        open channels #0, #1 and #2 */
    bsr.s ini_wind
/* QL:         assert  0,mt.inf */
/* original assertion: 0,mt.inf */
/* QL: *       moveq   #mt.inf,d0 */
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  d2,-(sp)        store qdos version number */
    move.l d2,-(sp)
/* QL:         move.l  #10<<24!10<<16!'  ',-(sp) nl,nl,sp,sp */
    move.l #(((10<<24)|(10<<16))|8224),-(sp)
/* QL:         jsr     ii_clock(pc)    get i2c clock if it's there */
    jsr ii_clock(pc)
/* QL: ;       moveq   #mt.rclck,d0 */
/* QL: ;       trap    #1 */
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         sub.w   #2+34-8,sp */
    sub.w #((2+34)-8),sp
/* QL:         sub.l   a6,a1 */
    sub.l a6,a1
/* QL:         jsr     cn_date(pc) */
    jsr cn_date(pc)
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         jsr     cn_day(pc) */
    jsr cn_day(pc)
/* QL:         moveq   #10,d3 */
    moveq #10,d3
/* QL:         move.b  d3,7(sp) */
    move.b d3,7(sp)
/* QL:         move.b  d3,19(sp) */
    move.b d3,19(sp)
/* QL:         move.l  #34<<16!'K ',(sp) */
    move.l #((34<<16)|19232),(sp)
/* QL: * We now have, word prefixed, "K day\yyyy mmm dd\hh:mm:ss\\  vern" */
/* QL:         moveq   #2,d4 */
    moveq #2,d4
/* QL:         bsr.s   chnid */
    bsr.s chnid
/* QL:         moveq   #err.bt,d0      put boot message in #2, redefine then select #1 */
    moveq #err.bt,d0
/* QL:         bsr.s   err_mov */
    bsr.s err_mov
/* QL:         move.l  2+34+4(sp),d1 */
    move.l ((2+34)+4)(sp),d1
/* QL:         lsl.l   #16-10,d1 */
    lsl.l #(16-10),d1
/* QL:         swap    d1 */
    swap d1
/* QL:         sub.w   #128,d1         don't count ROM, etc */
    sub.w #128,d1
/* QL:         jsr     ut_mint(pc)     print RAM size to #1 */
    jsr ut_mint(pc)
/* QL:         move.l  sp,a1           set buffer pointer */
    move.l sp,a1
/* QL:         jsr     ut_mtext(pc)    print rest of line #1 */
    jsr ut_mtext(pc)
/* QL:         add.w   (sp)+,sp        discard it all */
    add.w (sp)+,sp
/* QL:         moveq   #err.cp,d0      final copyright in #1, redefine then select #0 */
    moveq #err.cp,d0
/* QL: err_mov */
err_mov:
/* QL:         jsr     ut_err(pc)      print message */
    jsr ut_err(pc)
/* QL:         lea     ini_def,a1      put back defn block pointer as for #0 */
    lea ini_def(pc),a1
/* QL:         bsr.s   wrdef           redefine same as #0 */
    bsr.s wrdef
/* QL:         subq.w  #1,d4 */
    subq.w #1,d4
/* QL: chnid */
chnid:
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         jmp     bp_chnid(pc)    select next channel */
    jmp bp_chnid(pc)
/* QL: * Three sets of three window definitions: initial, monitor and TV */
/* QL: * NB. TK2 now searches for these window definitions, looking for the $ff010207 */
/* QL: * for window #1 in mon_def. It expects tv_def to follow, and all the defs to */
/* QL: * be in this order. No way can it use ini_def, but it doesn't want it... */
/* QL: mon_def */
mon_def:
/* QL:         dc.w    $0000,$0004,512,050,000,206     green on black, no border */
.balign 2,0
dc_anchor_1214:
.word 0x0000
.word 0x0004
.word 512
.word 50
.word 0
.word 206
/* QL:         dc.w    $ff01,$0207,256,202,256,000     white on red, grey border */
.balign 2,0
dc_anchor_1223:
.word 0xff01
.word 0x0207
.word 256
.word 202
.word 256
.word 0
/* QL:         dc.w    $ff01,$0702,256,202,000,000     red on white, grey border */
.balign 2,0
dc_anchor_1232:
.word 0xff01
.word 0x0702
.word 256
.word 202
.word 0
.word 0
/* QL: tv_def */
tv_def:
/* QL:         dc.w    $0000,$0007,tv_wid,h_0,x_n,y_0  white on black, no border */
.balign 2,0
dc_anchor_1243:
.word 0x0000
.word 0x0007
.word tv_wid
.word h_0
.word x_n
.word y_0
/* QL:         dc.w    $0000,$0207,tv_wid,h_n,x_n,y_n  white on red, no border */
.balign 2,0
dc_anchor_1252:
.word 0x0000
.word 0x0207
.word tv_wid
.word h_n
.word x_n
.word y_n
/* QL:         dc.w    $0000,$0107,tv_wid,h_n,x_n,y_n  white on blue, no border */
.balign 2,0
dc_anchor_1261:
.word 0x0000
.word 0x0107
.word tv_wid
.word h_n
.word x_n
.word y_n
/* QL: ini_def */
ini_def:
/* QL:         dc.w    $0000,$0004,tv_wid,y_c-y_n,x_n,y_n green on black, no border */
.balign 2,0
dc_anchor_1272:
.word 0x0000
.word 0x0004
.word tv_wid
.word ((y_c-y_n))&65535
.word x_n
.word y_n
/* QL:         dc.w    $3802,$1006,w_c,h_c,x_c,y_c     white on dk red dk grey border */
.balign 2,0
dc_anchor_1281:
.word 0x3802
.word 0x1006
.word w_c
.word h_c
.word x_c
.word y_c
/* QL:         dc.w    $ff01,$0206,w_b,h_b,x_b,y_b     white on red, grey border */
.balign 2,0
dc_anchor_1290:
.word 0xff01
.word 0x0206
.word w_b
.word h_b
.word x_b
.word y_b
/* QL: wdef_len equ (tv_def-mon_def)/3 */
.equ wdef_len,((tv_def-mon_def)/3)
/* QL: cmds    dc.w    4,'CMD$' */
.balign 2,0
cmds:
dc_anchor_1302:
.word 4
.byte 67,77,68,36
.balign 2,0
/* QL:         vect4000 sb_start */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl sb$start
/* QL: [o]     equ     [h]-$4000 */
.equ sb$start,(sb_start-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
