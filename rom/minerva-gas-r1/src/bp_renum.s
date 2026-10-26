/* Generated from original/M/bp/renum.asm */
/* QL: * RENUM: renumber a program file (also handles AUTO and EDIT) */
/* QL:         xdef    bp_auto,bp_edit,bp_renum */
.globl bp_auto,bp_edit,bp_renum
/* QL:         xref    bp_chunr,bp_gint,bp_gsep,bp_listr */
/* QL:         xref    bv_alvv,bv_chpfx,bv_frvv,bv_uprnm */
/* QL:         xref    ib_cheos,ib_glin0,ib_nxcom,ib_nxnon,ib_nxst,ib_nxtk */
/* QL:         xref    ib_stbas,ib_whrnm */
/* QL:         xref    mm_mrtor */
/* QL:         xref    ri_float,ri_nint */
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
/* QL:         include 'win1_m_inc_token' */
/* QL: * equates for tokens */
/* QL:         nolist */
/* QL: b.w.num setnum  0 */
/* QL: b.w.def macro */
/* QL: spc     b.w.def ; lsb is space count */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.spc,(0xffffff80|0)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.spc,(-32768)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: key     b.w.def end for if rep sel when def proc fn go keyto sub {} err {} {}  rstr next exit else on ret rmndr data dim loc let then step rem mist */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.key,(0xffffff80|1)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.key,(-32512)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.end,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.end,(1|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.for,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.for,(2|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.if,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.if,(3|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rep,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rep,(4|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sel,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sel,(5|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.when,6
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.when,(6|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.def,7
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.def,(7|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.proc,8
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.proc,(8|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.fn,9
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.fn,(9|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.go,10
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.go,(10|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.keyto,11
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.keyto,(11|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sub,12
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sub,(12|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.err,14
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.err,(14|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rstr,17
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rstr,(17|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.next,18
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.next,(18|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.exit,19
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.exit,(19|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.else,20
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.else,(20|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.on,21
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.on,(21|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.ret,22
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.ret,(22|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rmndr,23
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rmndr,(23|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.data,24
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.data,(24|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.dim,25
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.dim,(25|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.loc,26
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.loc,(26|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.let,27
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.let,(27|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.then,28
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.then,(28|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.step,29
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.step,(29|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rem,30
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rem,(30|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.mist,31
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.mist,(31|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: bip     b.w.def ; built-in procedure - not used */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.bip,(0xffffff80|2)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.bip,(-32256)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: bif     b.w.def ; built-in function - not used */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.bif,(0xffffff80|3)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.bif,(-32000)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: sym     b.w.def equal colon hash symcom opar cpar obrc cbrc space eol */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.sym,(0xffffff80|4)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.sym,(-31744)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.equal,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.equal,(1|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.colon,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.colon,(2|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.hash,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.hash,(3|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.symcom,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.symcom,(4|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.opar,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.opar,(5|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.cpar,6
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.cpar,(6|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.obrc,7
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.obrc,(7|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.cbrc,8
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.cbrc,(8|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.space,9
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.space,(9|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.eol,10
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.eol,(10|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: ops     b.w.def sum dif mul fdiv ge gt near eq ne le lt bor band bxor exp  join lor land lxor mod idiv instr */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.ops,(0xffffff80|5)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.ops,(-31488)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sum,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sum,(1|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.dif,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.dif,(2|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.mul,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.mul,(3|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.fdiv,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.fdiv,(4|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.ge,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.ge,(5|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.gt,6
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.gt,(6|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.near,7
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.near,(7|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.eq,8
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.eq,(8|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.ne,9
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.ne,(9|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.le,10
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.le,(10|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lt,11
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lt,(11|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.bor,12
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.bor,(12|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.band,13
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.band,(13|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.bxor,14
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.bxor,(14|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.exp,15
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.exp,(15|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.join,16
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.join,(16|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lor,17
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lor,(17|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.land,18
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.land,(18|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lxor,19
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lxor,(19|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.mod,20
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.mod,(20|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.idiv,21
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.idiv,(21|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.instr,22
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.instr,(22|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: mon     b.w.def neg pos bnot lnot */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.mon,(0xffffff80|6)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.mon,(-31232)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.neg,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.neg,(1|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.pos,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.pos,(2|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.bnot,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.bnot,(3|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lnot,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lnot,(4|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: syv     b.w.def ; system variable - not used */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.syv,(0xffffff80|7)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.syv,(-30976)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: nam     b.w.def ; 2nd word is name index */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.nam,(0xffffff80|8)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.nam,(-30720)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: shi     b.w.def ; lsb is signed integer */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.shi,(0xffffff80|9)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.shi,(-30464)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: lgi     b.w.def ; 2nd word is signed integer */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.lgi,(0xffffff80|10)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.lgi,(-30208)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: str     b.w.def ; 2nd word is length, followed by chars and padded to even */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.str,(0xffffff80|11)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.str,(-29952)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: txt     b.w.def ; as above */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.txt,(0xffffff80|12)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.txt,(-29696)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: lno     b.w.def ; 2nd word is strictly positive line number */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.lno,(0xffffff80|13)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.lno,(-29440)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: sep     b.w.def sepcom semi back excl septo */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.sep,(0xffffff80|14)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.sep,(-29184)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sepcom,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sepcom,(1|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.semi,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.semi,(2|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.back,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.back,(3|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.excl,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.excl,(4|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.septo,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.septo,(5|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL:         list */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         section bp_renum */
.section bp_renum,"ax"
/* QL: bp_auto */
bp_auto:
/* QL:         moveq   #10,d7          default increment is 10 for auto */
    moveq #10,d7
/* QL: bp_edit         ;               default increment zero for edit */
bp_edit:
/* QL:         moveq   #-1,d6          flag edit/auto by having all 1's in last line */
    moveq #(-1),d6
/* QL:         bra.s   st_arg */
    bra.s st_arg
/* QL: bp_renum */
bp_renum:
/* QL:         moveq   #10,d7          default steps of 10 for renumber */
    moveq #10,d7
/* QL:         moveq   #-2,d6          flag renum by having a zero lsb. */
    moveq #(-2),d6
/* QL: st_arg */
st_arg:
/* QL:         jsr     bp_chunr(pc)    make sure we're allowed to */
    jsr bp_chunr(pc)
/* QL: * First get the arguments. d7 = renumber/edit step, d6 = -1, or -2 for RENUM */
/* QL:         move.l  a5,-(sp)        if all else fails, renumber from top */
    move.l a5,-(sp)
/* QL:         move.l  d7,-(sp)        save default step at 2(sp) */
    move.l d7,-(sp)
/* QL:         moveq   #100,d7         default starting renumber/edit from 100 */
    moveq #100,d7
/* QL:         ror.w   #1,d6           form 32767 (max line number) for renum */
    ror.w #1,d6
/* QL:         bmi.s   ch_num          auto/edit - just go for " {start} {,step} " */
    bmi.s ch_num
/* QL: * RENUM has optional range first: "{ {first} to {last} }" or "{first/last} ;" */
/* QL:         moveq   #1,d4           first line */
    moveq #1,d4
/* QL:         bsr.s   get_arg         get arg and its separator */
    bsr.s get_arg
/* QL:         cmp.b   #b.septo,d5     " {first} to ... " ? */
    cmp.b #(b.septo&255),d5
/* QL:         bne.s   s_semi */
    bne.s s_semi
/* QL:         tst.b   d0              " first to ... " ? */
    tst.b d0
/* QL:         bne.s   ch_last */
    bne.s ch_last
/* QL:         move.w  d1,d4           yes, set first line */
    move.w d1,d4
/* QL: ch_last */
ch_last:
/* QL:         bsr.s   get_arg         get another arg, is it " ... to last ... " ? */
    bsr.s get_arg
/* QL:         bne.s   to_set */
    bne.s to_set
/* QL:         move.w  d1,d6           yes, set last line */
    move.w d1,d6
/* QL: to_set */
to_set:
/* QL:         cmp.b   #b.semi,d5      " {first} to {last} ; ... " ? */
    cmp.b #(b.semi&255),d5
/* QL:         beq.s   ch_num          yes, go get start line */
    beq.s ch_num
/* QL:         bra.s   ch_sep          no, go see if final " , {step} " is present */
    bra.s ch_sep
/* QL: get_arg */
get_arg:
/* QL:         moveq   #0,d5 */
    moveq #0,d5
/* QL:         cmp.l   8(sp),a3        any args left? */
    cmp.l 8(sp),a3
/* QL:         beq.s   null_arg */
    beq.s null_arg
/* QL:         jsr     bp_gsep(pc)     get separator & see if there's an arg */
    jsr bp_gsep(pc)
/* QL:         beq.s   null_arg */
    beq.s null_arg
/* QL:         jsr     bp_gint(pc)     get an integer arg > 0 */
    jsr bp_gint(pc)
/* QL:         beq.s   rts0 */
    beq.s rts0
/* QL:         addq.l  #4,sp           skip this return */
    addq.l #4,sp
/* QL:         bra.s   pop8            and complain */
    bra.s pop8
/* QL: null_arg */
null_arg:
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: s_semi */
s_semi:
/* QL:         cmp.b   #b.semi,d5      " {first/last=only} ; " ? */
    cmp.b #(b.semi&255),d5
/* QL:         bne.s   s_com */
    bne.s s_com
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         bne.s   ch_num */
    bne.s ch_num
/* QL:         move.w  d1,d4           set 1st line */
    move.w d1,d4
/* QL:         move.w  d1,d6           set last line */
    move.w d1,d6
/* QL: * All can have now is " ... {start} { , {step} } " */
/* QL: ch_num */
ch_num:
/* QL:         bsr.s   get_arg */
    bsr.s get_arg
/* QL: s_com */
s_com:
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         bne.s   ch_sep */
    bne.s ch_sep
/* QL:         move.w  d1,d7           set new start line */
    move.w d1,d7
/* QL: ch_sep */
ch_sep:
/* QL:         cmp.b   #b.sepcom,d5 */
    cmp.b #(b.sepcom&255),d5
/* QL:         bne.s   no_sep */
    bne.s no_sep
/* QL:         bsr.s   get_arg */
    bsr.s get_arg
/* QL:         bne.s   no_sep */
    bne.s no_sep
/* QL:         move.l  d1,(sp)         overwrite step size at 2(sp) */
    move.l d1,(sp)
/* QL: no_sep */
no_sep:
/* QL:         moveq   #err.bp,d0      in case they try to sneak sommat funny past us! */
    moveq #err.bp,d0
/* QL:         subq.l  #1,d5 */
    subq.l #1,d5
/* QL:         bcc.s   pop8            ok if no separator left, and set d5.l=-1 */
    bcc.s pop8
/* QL: * d7.l = start line to edit or renumber to */
/* QL: * 2(sp).w = step for edit or renumber range */
/* QL:         move.w  d7,(sp)         form start/step on stack at (sp) and 2(sp) */
    move.w d7,(sp)
/* QL:         ext.l   d6              what are we doing? (clear msw if renum) */
    ext.l d6
/* QL:         bpl.s   renum */
    bpl.s renum
/* QL:         assert  bv_edlin,bv_edinc-2 */
/* original assertion: bv_edlin,bv_edinc-2 */
/* QL:         move.l  (sp),bv_edlin(a6) start line and increment for subsequent lines */
    move.l (sp),bv_edlin(a6)
/* QL:         st      bv_auto(a6)     set auto/edit flag for unvrs */
    st bv_auto(a6)
/* QL: exit */
exit:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: pop8 */
pop8:
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL:         rts */
    rts 
/* QL: * Now check that all is OK for renumbering */
/* QL: * d4.l = first line in old range to be renumbered */
/* QL: * d5.l = -1 */
/* QL: * d6.l = last line in old range to be renumbered */
/* QL: * d7.l = first line in new renumbered range */
/* QL: * (sp).w = also first line in renumbered range */
/* QL: * 2(sp).w = step for renumbered range */
/* QL: renum */
renum:
/* QL:         jsr     ib_glin0(pc)    goto the start line */
    jsr ib_glin0(pc)
/* QL:         ble.s   exit            not in program - that requires no work! */
    ble.s exit
/* QL:         move.l  a4,a3           duplicate pointer */
    move.l a4,a3
/* QL:         cmp.l   d0,a4 */
    cmp.l d0,a4
/* QL:         ble.s   preok           no check if at start, and d5=-1 is ok */
    ble.s preok
/* QL:         sub.w   d1,a4 */
    sub.w d1,a4
/* QL:         cmp.w   4(a6,a4.l),d7   check that new start > previous lno */
    cmp.w 4(a6,a4.l),d7
/* QL:         ble.s   pop_or          we could allow renumber of no lines through... */
    ble.s pop_or
/* QL:         sub.w   4(a6,a4.l),d5   we need pre-start lno plus one - this negated */
    sub.w 4(a6,a4.l),d5
/* QL:         add.w   d1,a4 */
    add.w d1,a4
/* QL: preok */
preok:
/* QL: * Establish how many lines in range, and get a final, out-of-range line number */
/* QL:         move.w  d1,d4           duplicate length+2 */
    move.w d1,d4
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL: countup */
countup:
/* QL:         move.w  4(a6,a3.l),d0   get line number */
    move.w 4(a6,a3.l),d0
/* QL:         cmp.w   d0,d6           have we gone past end of range? */
    cmp.w d0,d6
/* QL:         blt.s   counted         yes - we're ready */
    blt.s counted
/* QL:         addq.l  #1,d3           counting lines after 1st line in range */
    addq.l #1,d3
/* QL:         add.w   0(a6,a3.l),d1   adjust length */
    add.w 0(a6,a3.l),d1
/* QL:         add.w   d1,a3           and move to the end */
    add.w d1,a3
/* QL:         cmp.l   d2,a3 */
    cmp.l d2,a3
/* QL:         blt.s   countup */
    blt.s countup
/* QL: * Note: we have one problem that we must avoid. If there is not yet a line */
/* QL: * number 32767, we cannot allow renumbering to produce one, in case there exist */
/* QL: * references to beyond the last line actually present! */
/* QL:         addq.w  #1,d0           check if genuine line 32767 was present */
    addq.w #1,d0
/* QL:         bmi.s   counted         yes! leave with 32768 as pseudo end line */
    bmi.s counted
/* QL:         move.w  #32767,d0       pretend post-range lno is max possible lno */
    move.w #32767,d0
/* QL: counted */
counted:
/* QL:         move.w  d0,d6           now we have the first line above range ready */
    move.w d0,d6
/* QL:         move.l  (sp),d2         step in lsw */
    move.l (sp),d2
/* QL:         muls    d3,d2           * ( lines - 1 ) */
    muls d3,d2
/* QL:         bmi.s   exit            if there were no lines in range, exit ok! */
    bmi.s exit
/* QL:         add.l   d7,d2           + start line = new number for last line */
    add.l d7,d2
/* QL:         cmp.l   d6,d2           check renumbered end < post range line number */
    cmp.l d6,d2
/* QL:         blt.s   ready           good stuff, now we can get on! */
    blt.s ready
/* QL: pop_or */
pop_or:
/* QL:         moveq   #err.or,d0 */
    moveq #err.or,d0
/* QL:         bra.s   pop8            go report out-of-range */
    bra.s pop8
/* QL: ready */
ready:
/* QL:         move.l  (sp),d7         more convenient later to keep start/step in d7 */
    move.l (sp),d7
/* QL: * We are now fully prepared to start actioning the renum */
/* QL: * Some (rambling) implementation notes: */
/* QL: * We can keep d5-d7 and a-regs except a1 preserved while we actually do the */
/* QL: * program renumbering (plus a4 is program pointer). */
/* QL: * It does not matter if we include the post lno in the renumber, but all is */
/* QL: * much nicer if we don't include it! */
/* QL: * The range of the renumber contains just pre+1 to post-1 inclusive. */
/* QL: * We want a fast compare by "move (),ds:sub.w dy,ds:add.w dx,ds:bcc.s done". */
/* QL: * So we must get a value 0..post-(pre+1)-1 in ds after the comparison. */
/* QL: * So we want post-(pre+1) and post for dx/dy. We'll use d5=dx and d6=dy. */
/* QL: * We need post and lastreal-(pre+1) so we can renumber final set. */
/* QL: * We only need table entries for the comparisons we need to make. */
/* QL: * Table entry "-1" is a pseudo zero, so they must have (pre+1) knocked off. */
/* QL: * Last table entry will be lastreal-(pre+1), used only for final set. */
/* QL: * Total table comparison words needed is number of real lines. */
/* QL: * Need table base and top, for which we'll use a0/a3. */
/* QL: * Need start, step for renumbering all but last set in range (in d7 now). */
/* QL: * d3.l lines in range less one (i.e. 0 if single line) */
/* QL: * d4.w length of line at a4, plus 2 for effeciency */
/* QL: * d5.l (-ve) pre-range line number plus one (i.e. first line ref to be altered) */
/* QL: * d6.l post range line number (may be real line or pseudo 32767/8) */
/* QL: * d7.msw start line for renumbered range */
/* QL: * d7.lsw step for renumber line */
/* QL: * Allocate table, then fill it in as we renumber lines in the range. */
/* QL: * Minimal table (for single line renumber) will contain just 1 word (plus w/s). */
/* QL: * We're using a VV area, so called routines shouldn't be too restricted. */
/* QL: * Also, using space there is probably not causing the VV area to expand */
/* QL: * unneccessarily, as the space used will be proportionate to the size of the */
/* QL: * program, and, assume that does do some work, it'll probably need variables! */
/* QL: * Finally, at least CLEAR will wipe the VV area if it's called later on. */
/* QL: ren.ws  equ     6*2             workspace used as RI type stack at top of table */
.equ ren.ws,(6*2)
/* QL:         moveq   #1+ren.ws/2,d1  we need one line, plus the workspace. */
    moveq #(1+(ren.ws/2)),d1
/* QL:         add.l   d3,d1 */
    add.l d3,d1
/* QL:         add.l   d1,d1           * 2 = no bytes needed in table */
    add.l d1,d1
/* QL:         jsr     bv_alvv(pc)     allocate the space */
    jsr bv_alvv(pc)
/* QL:         move.l  a0,a3           copy table base */
    move.l a0,a3
/* QL: nx_lno */
nx_lno:
/* QL:         move.w  4(a6,a4.l),d2   get old lno */
    move.w 4(a6,a4.l),d2
/* QL:         add.w   d5,d2           adjust to what we want in table */
    add.w d5,d2
/* QL:         move.w  d2,0(a6,a3.l)   store old line number less (pre+1) */
    move.w d2,0(a6,a3.l)
/* QL:         move.w  (sp),4(a6,a4.l) edit program to new line number */
    move.w (sp),4(a6,a4.l)
/* QL:         add.w   d7,(sp)         update new line number */
    add.w d7,(sp)
/* QL:         add.w   0(a6,a4.l),d4   adjust length */
    add.w 0(a6,a4.l),d4
/* QL:         add.w   d4,a4           and move to the end */
    add.w d4,a4
/* QL:         addq.l  #2,a3           next table entry */
    addq.l #2,a3
/* QL:         dbra    d3,nx_lno       we now know exactly how many lines we're doing */
    dbra d3,nx_lno
/* QL:         add.l   d6,d5           now we have post-(pre+1), as we wish for */
    add.l d6,d5
/* QL:         lea     get_new,a2      address of renumber routine */
    lea get_new(pc),a2
/* QL: * Notes: */
/* QL: * d5-d7/a0/a2-a3 must be preserved for the renumber routine. */
/* QL: * a2 is the address of the renumber routine. */
/* QL: * The when and uproc routines may use d4 and a5 as they wish. */
/* QL: * On calling the routine at a2, they must supply d5-d7/a0/a3 as given to them. */
/* QL: * They must set a1 as the rel-a6 pointer to the word containing the line number */
/* QL: * to be adjusted. a1 is preserved. */
/* QL: * If the line is renumbered, its new value is returned in d0.l (1-32767). */
/* QL: * If the line is not renumbered, d0.l returns with zero. */
/* QL: * The condition code on return is the result of testing d0.l, in effect. */
/* QL: * d1-d3 will be destroyed. */
/* QL: * N.B. d0-d4/a1 variously zapped in the following */
/* QL:         tst.b   bv_uproc(a6)    is there a user trace procedure? */
    tst.b bv_uproc(a6)
/* QL:         bpl.s   noup */
    bpl.s noup
/* QL:         jsr     bv_uprnm(pc)    yes - go see to it */
    jsr bv_uprnm(pc)
/* QL: noup */
noup:
/* QL:         jsr     ib_whrnm(pc)    go let when do it's checks */
    jsr ib_whrnm(pc)
/* QL:         jsr     ib_stbas(pc) */
    jsr ib_stbas(pc)
/* QL:         bra.s   on_line         go start a new line */
    bra.s on_line
/* QL: st_1 */
st_1:
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         beq.s   on_stmt */
    beq.s on_stmt
/* QL: on_line */
on_line:
/* QL:         move.l  a4,(sp)         save marker for start of line, in case shi->lgi */
    move.l a4,(sp)
/* QL: on_stmt */
on_stmt:
/* QL:         bsr.s   nxnon           get 1st token in statement */
    bsr.s nxnon
/* QL:         sub.w   #w.go,d1 */
    sub.w #w.go,d1
/* QL:         beq.s   skip_go         if go, skip it */
    beq.s skip_go
/* QL:         subq.w  #w.rstr-w.go,d1 */
.word 20801|((((w.rstr-w.go))&7)<<9)
/* QL:         beq.s   ch_fp           go skip restore and look for fp */
    beq.s ch_fp
/* QL:         subq.w  #w.on-w.rstr,d1 */
.word 20801|((((w.on-w.rstr))&7)<<9)
/* QL:         bne.s   nx_stmnt        if not on, try again */
    bne.s nx_stmnt
/* QL: nx_token */
nx_token:
/* QL:         jsr     ib_nxtk(pc)     get next token */
    jsr ib_nxtk(pc)
/* QL:         bsr.s   noncheos        skip spaces & check for end-statement */
    bsr.s noncheos
/* QL:         beq.s   nx_stmnt */
    beq.s nx_stmnt
/* QL:         cmp.w   #w.go,d1 */
    cmp.w #w.go,d1
/* QL:         bne.s   nx_token        if not go, go get next token */
    bne.s nx_token
/* QL: skip_go */
skip_go:
/* QL:         bsr.s   skpnonc         skip go, get to/sub */
    bsr.s skpnonc
/* QL: ch_fp */
ch_fp:
/* QL:         bsr.s   skpnonc         get 1st token of expression, checking for eos */
    bsr.s skpnonc
/* QL:         beq.s   nx_stmnt */
    beq.s nx_stmnt
/* QL:         sub.b   #b.lgi,d0       long integers are lovely, and most frequent */
    sub.b #(b.lgi&255),d0
/* QL:         bne.s   others */
    bne.s others
/* QL:         lea     2(a4),a1 */
    lea 2(a4),a1
/* QL:         jsr     (a2) */
    jsr (a2)
/* QL: nx_exp */
nx_exp:
/* QL:         jsr     ib_nxcom(pc)    get a comma not inside ()'s */
    jsr ib_nxcom(pc)
/* QL:         bne.s   ch_fp           ok, check the first token */
    bne.s ch_fp
/* QL: nx_stmnt */
nx_stmnt:
/* QL:         jsr     ib_nxst(pc)     get start of next statement */
    jsr ib_nxst(pc)
/* QL:         beq.s   st_1 */
    beq.s st_1
/* QL:         bra.s   tidy_up */
    bra.s tidy_up
/* QL: skpnonc */
skpnonc:
/* QL:         addq.l  #2,a4           skip over word token */
    addq.l #2,a4
/* QL: noncheos */
noncheos:
/* QL:         pea     ib_cheos(pc)    check end-of-statement after nxnon */
    pea ib_cheos(pc)
/* QL: nxnon */
nxnon:
/* QL:         jmp     ib_nxnon(pc) */
    jmp ib_nxnon(pc)
/* QL: others */
others:
/* QL:         lea     6(a3),a1        use RI-type workspace at top of table */
    lea 6(a3),a1
/* QL:         addq.b  #b.lgi-b.shi,d0 short integers are a pain! they may not fit! */
.word 20480|((((b.lgi-b.shi))&7)<<9)
/* QL:         beq.s   doshi           changing lgi/shi both ways needs PF reshuffle! */
    beq.s doshi
/* QL:         sub.w   #$f000,d1       float needs some fiddling */
    sub.w #0xf000,d1
/* QL:         bcs.s   nx_exp          anything else, we'll skip, cos we're dumb */
    bcs.s nx_exp
/* QL:         move.w  d1,0(a6,a1.l)   put on exponent */
    move.w d1,0(a6,a1.l)
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) put on mantissa */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL:         jsr     ri_nint(pc)     convert it to an integer line number */
    jsr ri_nint(pc)
/* QL:         bne.s   nx_exp          didn't convert, so ignore it */
    bne.s nx_exp
/* QL:         jsr     (a2)            give the current number and get new one */
    jsr (a2)
/* QL:         beq.s   nx_exp          not renumbered, so leave original unchanged */
    beq.s nx_exp
/* QL:         jsr     ri_float(pc) */
    jsr ri_float(pc)
/* QL:         movem.w 0(a6,a1.l),d0-d2 get new fp */
    movem.w 0(a6,a1.l),d0-d2
/* QL:         or.w    #$f000,d0       insert token into exponent */
    or.w #0xf000,d0
/* QL:         movem.w d0-d2,0(a6,a4.l) replace fp */
    movem.w d0-d2,0(a6,a4.l)
/* QL: nx_exp2 */
nx_exp2:
/* QL:         bra.s   nx_exp */
    bra.s nx_exp
/* QL: tidy_up */
tidy_up:
/* QL:         addq.l  #8,sp           we're finished with the stacked values */
    addq.l #8,sp
/* QL:         st      bv_cont(a6)     because nxst will have set stop */
    st bv_cont(a6)
/* QL:         st      bv_edit(a6)     say the program has changed */
    st bv_edit(a6)
/* QL: * Finally, tidy up all line numbers in bv area, and relist */
/* QL:         movem.l bv_lnbas(a6),a1/a5 get line number table pointers */
    movem.l bv_lnbas(a6),a1/a5
/* QL:         bra.s   lnent           enter loop at end */
    bra.s lnent
/* QL: * This is the naff one... renumbering a short integer */
/* QL: doshi */
doshi:
/* QL:         ext.w   d1 */
    ext.w d1
/* QL:         move.w  d1,0(a6,a1.l)   put on word value */
    move.w d1,0(a6,a1.l)
/* QL:         jsr     (a2)            give the current number and get new one */
    jsr (a2)
/* QL:         beq.s   nx_exp          not renumbered, so leave original unchanged */
    beq.s nx_exp
/* QL:         move.b  d0,1(a6,a4.l)   replace value, we hope */
    move.b d0,1(a6,a4.l)
/* QL:         cmp.w   #128,d0         does it still fit? */
    cmp.w #128,d0
/* QL:         bcs.s   nx_exp          yes - great */
    bcs.s nx_exp
/* QL: * Disaster time... we can't fit the new line number in. We have to move the */
/* QL: * program. We don't like this, but we have had complaints. This is pretty much */
/* QL: * guaranteed to work, assuming that we have managed to save the right amount of */
/* QL: * info. I don't think it's going to be a major disaster, provided someone is */
/* QL: * not lunatic enough to have a RENUM inside their program code! */
/* QL: * If we get an out of memory error, it's a total disaster. */
/* QL:         sub.l   a0,a3 */
    sub.l a0,a3
/* QL:         sub.l   bv_vvbas(a6),a0 protect our table pointers */
    sub.l bv_vvbas(a6),a0
/* QL:         moveq   #2,d1           one extra word needed */
    moveq #2,d1
/* QL:         jsr     bv_chpfx(pc)    we hope this does nothing... */
    jsr bv_chpfx(pc)
/* QL:         add.l   bv_vvbas(a6),a0 restore our table pointers */
    add.l bv_vvbas(a6),a0
/* QL:         add.l   a0,a3 */
    add.l a0,a3
/* QL:         move.l  (sp),a1         get marker for start of line */
    move.l (sp),a1
/* QL:         addq.w  #2,bv_lengt(a6) this line will get longer */
    addq.w #2,bv_lengt(a6)
/* QL:         addq.w  #2,-6(a6,a1.l)  its pre-word goes up */
    addq.w #2,(-6)(a6,a1.l)
/* QL:         add.w   bv_lengt(a6),a1 step to end of line (includes pre-word) */
    add.w bv_lengt(a6),a1
/* QL:         subq.w  #2,-6(a6,a1.l)  next pre-word (or word past pfp) goes down */
    subq.w #2,(-6)(a6,a1.l)
/* QL:         move.l  a4,a1           source (include token, to save a word) */
    move.l a4,a1
/* QL:         move.l  a0,-(sp)        save table base */
    move.l a0,-(sp)
/* QL:         lea     2(a1),a0        destination */
    lea 2(a1),a0
/* QL:         move.l  bv_pfp(a6),d1   top of program */
    move.l bv_pfp(a6),d1
/* QL:         addq.l  #2,bv_pfp(a6)   it's growing */
    addq.l #2,bv_pfp(a6)
/* QL:         sub.l   a1,d1           total length */
    sub.l a1,d1
/* QL:         jsr     mm_mrtor(pc)    shuffle the whole damn thing up         */
    jsr mm_mrtor(pc)
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         addq.b  #b.lgi-b.shi,0(a6,a4.l) change token to long integer */
    addq.b #(b.lgi-b.shi),0(a6,a4.l)
/* QL:         ; N.B. we've left the lsb with junk, instead of the "official" zero. */
/* QL:         ; This shouldn't be a problem, and a SAVE/LOAD is a good idea anyway. */
/* QL:         move.w  6(a6,a3.l),2(a6,a4.l) put new line number */
    move.w 6(a6,a3.l),2(a6,a4.l)
/* QL:         bra.s   nx_exp2 */
    bra.s nx_exp2
/* QL: * Finishing off bits */
/* QL: lnloop */
lnloop:
/* QL:         jsr     (a2) */
    jsr (a2)
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL: lnent */
lnent:
/* QL:         cmp.l   a1,a5 */
    cmp.l a1,a5
/* QL:         bgt.s   lnloop */
    bgt.s lnloop
/* QL:         lea     bvtab,a5        miscellaneous variables */
    lea bvtab(pc),a5
/* QL:         moveq   #bv_linum,d0    start with this one */
    moveq #bv_linum,d0
/* QL: newlp */
newlp:
/* QL:         move.w  d0,a1 */
    move.w d0,a1
/* QL:         jsr     (a2)            renumber it */
    jsr (a2)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.b  (a5)+,d0 */
    move.b (a5)+,d0
/* QL:         bne.s   newlp */
    bne.s newlp
/* QL:         moveq   #ren.ws,d1 */
    moveq #ren.ws,d1
/* QL:         add.l   a3,d1 */
    add.l a3,d1
/* QL:         sub.l   a0,d1           amount to free */
    sub.l a0,d1
/* QL:         jsr     bv_frvv(pc) */
    jsr bv_frvv(pc)
/* QL:         jsr     bp_listr(pc)    relist the current window */
    jsr bp_listr(pc)
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Renumbering subroutine */
/* QL: * d0 -  o- new line number value at 0(a6,a1.l), or zero if not changed. */
/* QL: * d5 -ip - post lno - (pre+1) */
/* QL: * d6 -ip - post lno */
/* QL: * d7 -ip - start/step for renumbered line numbers */
/* QL: * a0 -ip - base of table */
/* QL: * a1 -i o- rel a6 pointer to line number to examine */
/* QL: * a3 -ip - top of table */
/* QL: * ccr-  o- zero if line not renumbered or positive if it was */
/* QL: * d1-d3 destroyed */
/* QL: * 0(a6,a0.l) first, or only, real lno of renumber range, less (pre+1) */
/* QL: * -2(a6,a3.l) last, or only, real lno of renumber range, less (pre+1) */
/* QL: get_new */
get_new:
/* QL:         move.w  0(a6,a1.l),d3   get line number there */
    move.w 0(a6,a1.l),d3
/* QL:         sub.w   d6,d3           subtract post-lno, which is out of the range */
    sub.w d6,d3
/* QL:         add.w   d5,d3           add line range: post-lno less pre-lno less one */
    add.w d5,d3
/* QL:         bcc.s   okrts           not in range, go say we didn't change this one */
    bcc.s okrts
/* QL:         move.w  d6,d0           lines above last renumber to post-lno */
    move.w d6,d0
/* QL:         cmp.w   -2(a6,a3.l),d3  are we matching the last+1 to post-1 range? */
    cmp.w (-2)(a6,a3.l),d3
/* QL:         bhi.s   lkput           yes, we've finished, so go put new number */
    bhi.s lkput
/* QL:         move.l  a0,d1           lower limit (may stop here) */
    move.l a0,d1
/* QL:         move.l  a3,d2           upper limit (never stop here) */
    move.l a3,d2
/* QL: lkup */
lkup:
/* QL:         addq.l  #2,d1           round up this time */
    addq.l #2,d1
/* QL:         move.l  d1,d0           set new low limit */
    move.l d1,d0
/* QL:         cmp.l   d0,d2           is there still more than one entry to check? */
    cmp.l d0,d2
/* QL:         ble.s   lklast          no, so we finish at this, or the earlier one */
    ble.s lklast
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL: lkchop */
lkchop:
/* QL:         lsr.l   #2,d1           lose lsb's */
    lsr.l #2,d1
/* QL:         add.l   d1,d1           middle, rounded */
    add.l d1,d1
/* QL:         cmp.w   -2(a6,d1.l),d3 */
    cmp.w (-2)(a6,d1.l),d3
/* QL:         bhi.s   lkup            search > entry, so we can move low limit */
    bhi.s lkup
/* QL: lkent */
lkent:
/* QL:         subq.l  #2,d1           search <= entry, so never look there again */
    subq.l #2,d1
/* QL:         move.l  d1,d2           save upper limit which may still work */
    move.l d1,d2
/* QL:         add.l   d0,d1 */
    add.l d0,d1
/* QL:         cmp.l   d0,d2           ah! but what is left in the range? */
    cmp.l d0,d2
/* QL:         bgt.s   lkchop          more than one, so keep chopping */
    bgt.s lkchop
/* QL: lklast */
lklast:
/* QL:         bne.s   lkback          if range exhasted, must want earlier one */
    bne.s lkback
/* QL:         cmp.w   -2(a6,d0.l),d3  final, single compare */
    cmp.w (-2)(a6,d0.l),d3
/* QL:         bhi.s   lkok            search > entry, so this is the one */
    bhi.s lkok
/* QL: lkback */
lkback:
/* QL:         subq.l  #2,d0           back up to final one that worked */
    subq.l #2,d0
/* QL: * We have {-2(a6,d0.l)} < d3 <= 0(a6,d0.l), therefore... */
/* QL: lkok */
lkok:
/* QL:         sub.w   a0,d0 */
    sub.w a0,d0
/* QL:         lsr.w   #1,d0 */
    lsr.w #1,d0
/* QL:         mulu    d7,d0 */
    mulu d7,d0
/* QL:         swap    d7 */
    swap d7
/* QL:         add.w   d7,d0           calculate new lno */
    add.w d7,d0
/* QL:         swap    d7 */
    swap d7
/* QL: lkput */
lkput:
/* QL:         move.w  d0,0(a6,a1.l) */
    move.w d0,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL:                ;bv_linum done at start */
/* QL: bvtab   dc.b    bv_nxlin,bv_cnlno,bv_dalno,bv_lsbef,bv_lsbas,bv_lsaft */
bvtab:
dc_anchor_1727:
.byte (bv_nxlin)&255
.byte (bv_cnlno)&255
.byte (bv_dalno)&255
.byte (bv_lsbef)&255
.byte (bv_lsbas)&255
.byte (bv_lsaft)&255
/* QL:         dc.b    bv_edlin,bv_lsfil,bv_erlin,0 (bv_wrlno already done) */
dc_anchor_1735:
.byte (bv_edlin)&255
.byte (bv_lsfil)&255
.byte (bv_erlin)&255
.byte (0)&255
/* QL: *       Note: only some of these used to be done... some are almost certainly */
/* QL: *       irrelevant... but adding dalno was really needed! */
/* QL:         end */
