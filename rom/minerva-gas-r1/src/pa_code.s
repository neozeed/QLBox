/* Generated from original/M/pa/code.asm */
/* QL: * Coded atom checking and tokenisation */
/* QL:         xdef    pa_cdlno,pa_cdnam,pa_cdnum,pa_cdspc,pa_cdstr,pa_cdsyv,pa_cdtxt */
.globl pa_cdlno,pa_cdnam,pa_cdnum,pa_cdspc,pa_cdstr,pa_cdsyv,pa_cdtxt
/* QL:         xdef    pa_cdval,pa_text,pa_tok1 + pa_(cd/tb)(mon/ops/sep) by macros */
.globl pa_cdval,pa_text,pa_tok1
/* QL:         xref    bv_chri,bv_chtkx */
/* QL:         xref    cn_dtof,cn_dtoi */
/* QL:         xref    pa_alfnm,pa_chnam,pa_chnlt,pa_chunr */
/* QL:         xref    ri_float,ri_int */
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
/* QL:         section pa_code */
.section pa_code,"ax"
/* QL: * Except where otherwise stated, all the routines operate as follows: */
/* QL: * return immediate if not recognised, or + 2 if sucessfully tokenised. */
/* QL: * a0 -i o- input text pointer (undefined on immediate return) */
/* QL: * a6 -ip - the base of basic */
/* QL: * d0-d6/a1-a3 destroyed */
/* QL: * Tokenise spaces - always suceeds and returns immediate */
/* QL: * a0 -i o- pointer to input text buffer */
/* QL: * a6 -ip - the base of basic */
/* QL: * d0-d5/a3 destroyed */
/* QL: pa_cdspc */
pa_cdspc:
/* QL:         moveq   #' ',d1 */
    moveq #32,d1
/* QL:         cmp.b   0(a6,a0.l),d1   any spaces at all? */
    cmp.b 0(a6,a0.l),d1
/* QL:         bne.s   rts0            no - make a quick return... speed */
    bne.s rts0
/* QL:         move.w  a0,d5 */
    move.w a0,d5
/* QL: nxchr */
nxchr:
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         cmp.b   0(a6,a0.l),d1   get first non-space */
    cmp.b 0(a6,a0.l),d1
/* QL:         beq.s   nxchr */
    beq.s nxchr
/* QL:         sub.w   a0,d5 */
    sub.w a0,d5
/* QL:         neg.b   d5 */
    neg.b d5
/* QL:         seq     d4 */
    seq d4
/* QL:         or.b    d4,d5           ensure we don't code up a zero for 256*n */
    or.b d4,d5
/* QL:         moveq   #b.spc,d4       space token */
    moveq #b.spc,d4
/* QL:         bra.l   pa_tok1 */
    bra.w pa_tok1
/* QL: * Check text and tokenise */
/* QL: pa_cdtxt */
pa_cdtxt:
/* QL:         move.l  bv_tkp(a6),a3   user might have typed "rem   ar" */
    move.l bv_tkp(a6),a3
/* QL:         cmp.b   #b.spc,-2(a6,a3.l) so spaces will have already been tokened */
    cmp.b #(b.spc&255),(-2)(a6,a3.l)
/* QL:         beq.s   pa_text         that'll be OK */
    beq.s pa_text
/* QL:         jsr     pa_alfnm(pc)    is first char alpha-numeric? */
    jsr pa_alfnm(pc)
/* QL:         bls.s   rts0            yes, that's no good here */
    bls.s rts0
/* QL: pa_text */
pa_text:
/* QL:         move.l  a0,a2           beginning of text line */
    move.l a0,a2
/* QL:         move.l  bv_bfp(a6),a0   end of text line */
    move.l bv_bfp(a6),a0
/* QL:         subq.l  #1,a0           ..not including the line feed of course.. */
    subq.l #1,a0
/* QL:         move.w  #w.txt,d4       text token and zero fill-in */
    move.w #w.txt,d4
/* QL:         move.l  a0,d1           point at line feed */
    move.l a0,d1
/* QL:         sub.l   a2,d1           length of text */
    sub.l a2,d1
/* QL:         bne.s   strlen          not zero, so we have to tokenise it */
    bne.s strlen
/* QL:         addq.l  #2,(sp)         now we're OK */
    addq.l #2,(sp)
/* QL: ;       bra.s   rts0 */
/* QL: ; */
/* QL: ;* Check system variable name */
/* QL: ; */
/* QL: pa_cdsyv */
pa_cdsyv:
/* QL: ;        cmp.b  #'&',0(a6,a0.l)  start with &? */
/* QL: ;        bne.s  rts0 */
/* QL: ;        addq.l #1,a0 */
/* QL: ;        moveq  #0,d3 */
/* QL: ;        jsr    pa_chnlt(pc)     and rest of name */
/* QL: ;        bra.s  rts0 */
/* QL: ; */
/* QL: ; must put in a test for existance when we know where they're kept */
/* QL: ; -- just save the token for now */
/* QL: ; */
/* QL: ;        move.w #w.syv,d4        name token and zero fill for now? */
/* QL: ;        bra.s  tok2             put in list */
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * Check string & tokenise */
/* QL: pa_cdstr */
pa_cdstr:
/* QL:         move.w  #w.str,d4       string token */
    move.w #w.str,d4
/* QL:         move.b  0(a6,a0.l),d4   move in delimiter */
    move.b 0(a6,a0.l),d4
/* QL:         moveq   #'''',d1        single quote ... */
    moveq #39,d1
/* QL:         sub.b   d4,d1 */
    sub.b d4,d1
/* QL:         beq.s   body */
    beq.s body
/* QL:         subq.b  #''''-'"',d1    ... or double quotes are OK */
.word 20737|((((39-34))&7)<<9)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL: body */
body:
/* QL:         addq.l  #1,a0           skip opening quote */
    addq.l #1,a0
/* QL:         move.l  a0,a2           this is where body of string starts */
    move.l a0,a2
/* QL:         moveq   #10,d5          avoid linefeeds */
    moveq #10,d5
/* QL: stnxt */
stnxt:
/* QL:         move.b  0(a6,a0.l),d1   next char */
    move.b 0(a6,a0.l),d1
/* QL:         cmp.b   d5,d1           check it isn't a line feed */
    cmp.b d5,d1
/* QL:         beq.s   rts0            we can't recover from that */
    beq.s rts0
/* QL:         addq.l  #1,a0           space over the byte */
    addq.l #1,a0
/* QL:         cmp.b   d4,d1           is it the matching quote? */
    cmp.b d4,d1
/* QL:         bne.s   stnxt           ..no, carry on then */
    bne.s stnxt
/* QL: * I'm tempted to add the syntax of repeated delim -> single... but it's a */
/* QL: * hassle for listing the program. Also, leaving off final delim as valid? */
/* QL:         move.l  a0,d1 */
    move.l a0,d1
/* QL:         subq.l  #1,d1           don't include the closing quote */
    subq.l #1,d1
/* QL:         sub.l   a2,d1           calculate length */
    sub.l a2,d1
/* QL: strlen */
strlen:
/* QL:         move.w  d1,d5           save the length */
    move.w d1,d5
/* QL: * Don't bother to validate the length, as the worst possible input we can ever */
/* QL: * get is an unnumbered line with 32767 characters, containing a string with */
/* QL: * it's delimiting quotes and a line feed. I.e. 32764, which is just OK! */
/* QL:         addq.w  #4,d1           string header takes 4 bytes */
    addq.w #4,d1
/* QL:         bsr.l   move4           do the first four bytes */
    bsr.w move4
/* QL:         bra.s   cent */
    bra.s cent
/* QL: copy */
copy:
/* QL:         move.b  0(a6,a2.l),4(a6,d2.l) copy a character */
    move.b 0(a6,a2.l),4(a6,d2.l)
/* QL:         addq.l  #1,d2 */
    addq.l #1,d2
/* QL:         addq.l  #1,a2 */
    addq.l #1,a2
/* QL: cent */
cent:
/* QL:         dbra    d5,copy */
    dbra d5,copy
/* QL:         rol.b   #8,d2           was the length odd or even? */
    rol.b #8,d2
/* QL:         bcc.s   retur2          even is OK */
    bcc.s retur2
/* QL:         clr.b   4(a6,d2.l)      fill any odd byte with a nought */
    clr.b 4(a6,d2.l)
/* QL:         addq.l  #1,a3           round up tk pointer to even */
    addq.l #1,a3
/* QL:         bra.s   retur2 */
    bra.s retur2
/* QL: * Check value and tokenise it */
/* QL: pa_cdnum */
pa_cdnum:
/* QL: pa_cdval */
pa_cdval:
/* QL:         lea     cn_dtof(pc),a3  convert decimal to float */
    lea cn_dtof(pc),a3
/* QL:         bsr.s   cndto           go do it */
    bsr.s cndto
/* QL:         move.l  2(a6,a1.l),d4   get the mantissa */
    move.l 2(a6,a1.l),d4
/* QL:         tst.b   bv_toe(a6)      bit 7 set means no integer tokenisation */
    tst.b bv_toe(a6)
/* QL:         bmi.s   mkfp */
    bmi.s mkfp
/* QL:         jsr     ri_int(pc) */
    jsr ri_int(pc)
/* QL:         bne.s   mkfp */
    bne.s mkfp
/* QL:         move.w  0(a6,a1.l),d6   get integer */
    move.w 0(a6,a1.l),d6
/* QL:         jsr     ri_float(pc)    send it back to f.p. */
    jsr ri_float(pc)
/* QL:         cmp.l   2(a6,a1.l),d4   is it identically the same? */
    cmp.l 2(a6,a1.l),d4
/* QL:         bne.s   mkfp */
    bne.s mkfp
/* QL:         cmp.w   0(a6,a1.l),d5 */
    cmp.w 0(a6,a1.l),d5
/* QL:         beq.s   mkint */
    beq.s mkint
/* QL: mkfp */
mkfp:
/* QL:         moveq   #6,d1           float takes six bytes */
    moveq #6,d1
/* QL:         bsr.s   tkchk */
    bsr.s tkchk
/* QL:         or.w    #$f000,d5       add the flpnt token */
    or.w #0xf000,d5
/* QL:         move.w  d5,-6(a6,a3.l)  put the tok+exponent into toklist */
    move.w d5,(-6)(a6,a3.l)
/* QL:         move.l  d4,-4(a6,a3.l)  followed by the mantissa */
    move.l d4,(-4)(a6,a3.l)
/* QL: retur2 */
retur2:
/* QL:         addq.l  #2,(sp)         OK now */
    addq.l #2,(sp)
/* QL: return */
return:
/* QL:         move.l  a3,bv_tkp(a6)   update token list pointer */
    move.l a3,bv_tkp(a6)
/* QL:         rts */
    rts 
/* QL: * Check for a line number and tokenise */
/* QL: pa_cdlno */
pa_cdlno:
/* QL:         lea     cn_dtoi(pc),a3  convert decimal to integer */
    lea cn_dtoi(pc),a3
/* QL:         bsr.s   cndto           go do it */
    bsr.s cndto
/* QL:         ble.s   rts1            don't allow neg or zero line numbers */
    ble.s rts1
/* QL:         moveq   #4+12,d0        total stack depth for unvr return */
    moveq #(4+12),d0
/* QL:         jsr     pa_chunr(pc)    no return if stuck in unravel */
    jsr pa_chunr(pc)
/* QL:         move.w  #w.lno,d4       line number token and zero fill */
    move.w #w.lno,d4
/* QL:         bra.s   tok2            put token on list */
    bra.s tok2
/* QL: cndto */
cndto:
/* QL:         jsr     bv_chri(pc)     reset and check ri stack */
    jsr bv_chri(pc)
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         move.l  a0,d3 */
    move.l a0,d3
/* QL:         jsr     (a3)            convert decimal to whatever */
    jsr (a3)
/* QL:         cmp.l   a0,d3 */
    cmp.l a0,d3
/* QL:         beq.s   poprts          if it fails or converts nowt, discard return */
    beq.s poprts
/* QL:         move.w  0(a6,a1.l),d5   get exponent/number */
    move.w 0(a6,a1.l),d5
/* QL:         rts */
    rts 
/* QL: poprts */
poprts:
/* QL:         addq.l #4,sp            discard top of stack */
    addq.l #4,sp
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: mkint */
mkint:
/* QL:         move.w  #w.lgi,d4 */
    move.w #w.lgi,d4
/* QL:         move.w  d6,d5 */
    move.w d6,d5
/* QL:         asl.w   #8,d6           check if we can squash integer in single byte */
    asl.w #8,d6
/* QL:         bvs.s   tok2            nope - tokenise as lgi */
    bvs.s tok2
/* QL:         moveq   #b.shi,d4       wow! yes, -128..127 is popular! */
    moveq #b.shi,d4
/* QL:         bra.s   goodtok1 */
    bra.s goodtok1
/* QL: moretk */
moretk:
/* QL:         move.l  d1,a3 */
    move.l d1,a3
/* QL:         jsr     bv_chtkx(pc)    get enough room */
    jsr bv_chtkx(pc)
/* QL:         move.l  a3,d1 */
    move.l a3,d1
/* QL: tkchk */
tkchk:
/* QL:         move.l  bv_tkp(a6),a3   get running toklist pointer */
    move.l bv_tkp(a6),a3
/* QL:         move.l  a3,d2           save it */
    move.l a3,d2
/* QL:         add.l   d1,a3           this is where we want to extend to */
    add.l d1,a3
/* QL:         cmp.l   bv_tkp+4(a6),a3 check next pointer */
    cmp.l (bv_tkp+4)(a6),a3
/* QL:         bgt.s   moretk          need more space */
    bgt.s moretk
/* QL: * Above arrangement to improve speed of tokenisation */
/* QL:         rts */
    rts 
/* QL: * Check name and tokenise */
/* QL: pa_cdnam */
pa_cdnam:
/* QL:         move.l  a0,a3           save buffer pointer */
    move.l a0,a3
/* QL:         jsr     pa_chnlt(pc)    check next thing in buffer looks like a name */
    jsr pa_chnlt(pc)
/* QL:         bra.s   rts1            ..it doesn't... */
    bra.s rts1
/* QL:         move.l  a0,d5           end of name */
    move.l a0,d5
/* QL:         sub.l   a3,d5           length of name */
    sub.l a3,d5
/* QL:         cmp.w   #256,d5         is name too long for a byte length? */
    cmp.w #256,d5
/* QL:         bcc.s   rts1            ..serves user right for trying it on.. */
    bcc.s rts1
/* QL:         move.l  a0,-(sp)        save buffer pos */
    move.l a0,-(sp)
/* QL: * N.B. Dirty tricks in chnam/chunr means we must have stack right here! */
/* QL:         jsr     pa_chnam(pc)    check name in table */
    jsr pa_chnam(pc)
/* QL:         bra.s   poprts          rats - it looks like a keyword */
    bra.s poprts
/* QL:         move.l  (sp)+,a0        restore buffer */
    move.l (sp)+,a0
/* QL:         move.w  #w.nam,d4       name token and zero fill */
    move.w #w.nam,d4
/* QL: * Put four byte token into the token list */
/* QL: tok2 */
tok2:
/* QL:         moveq   #4,d1           four byte token */
    moveq #4,d1
/* QL:         pea     retur2 */
    pea retur2(pc)
/* QL: move4 */
move4:
/* QL:         bsr.s   tkchk */
    bsr.s tkchk
/* QL:         movem.w d4-d5,0(a6,d2.l) (e.g. toktyp byte, delimiter and length) */
    movem.w d4-d5,0(a6,d2.l)
/* QL:         rts */
    rts 
/* QL: * Check for monadic operators, dyadic operators and separators. */
/* QL: * Note. The symbol table follows the call address, after the symbol type byte. */
/* QL: * The type is fetched, then the table must be in the form: */
/* QL: *        (a2).b no of symbols in table starting with 1 (n) */
/* QL: *       r(a2).b offset on a2 of r'th prebyte */
/* QL: *     n+1(a2).b 1st prebyte of the form 0XYh where Y is no of chars and X */
/* QL: *               is zero if no trailing space is required else 1 */
/* QL: *   n+1+c(a2).b c'th character of 1st symbol */
/* QL: * n+1+c+1(a2).b pre-byte of 2nd symbol */
/* QL: *         etc */
/* QL: end_sym */
end_sym:
/* QL:         lsl.w   #7,d6           did the prebyte say we need a space */
    lsl.w #7,d6
/* QL:         bpl.s   tok1ok          no space needed, we're OK */
    bpl.s tok1ok
/* QL:         jsr     pa_alfnm(pc)    want a non-alphanumeric */
    jsr pa_alfnm(pc)
/* QL:         bls.s   char1           not there, try the next (gets a0 sorted) */
    bls.s char1
/* QL: tok1ok */
tok1ok:
/* QL:         move.w  a3,d5 */
    move.w a3,d5
/* QL:         sub.w   a2,d5           token number */
    sub.w a2,d5
/* QL:         lsr.w   #8,d4           fetch down token type */
    lsr.w #8,d4
/* QL: goodtok1 */
goodtok1:
/* QL:         addq.l  #2,(sp)         good return */
    addq.l #2,(sp)
/* QL: * Put two byte token into the token list */
/* QL: * d4 -i  - token type */
/* QL: * d5 -i  - token lsb */
/* QL: * a6 -ip - the base of basic */
/* QL: * d0-d3/a3 destroyed */
/* QL: pa_tok1 */
pa_tok1:
/* QL:         moveq   #2,d1           two byte token */
    moveq #2,d1
/* QL:         bsr.s   tkchk           check space and get a3 */
    bsr.s tkchk
/* QL:         move.b  d4,-2(a6,a3.l)  first byte (toktyp) */
    move.b d4,(-2)(a6,a3.l)
/* QL:         move.b  d5,-1(a6,a3.l)  second byte (value) */
    move.b d5,(-1)(a6,a3.l)
/* QL:         bra.l   return */
    bra.w return
/* QL: nextchar */
nextchar:
/* QL:         addq.l  #1,a0           move to next buffer character */
    addq.l #1,a0
/* QL:         sub.b   d5,d6 */
    sub.b d5,d6
/* QL:         beq.s   end_sym         no chars left in symtab symbol */
    beq.s end_sym
/* QL:         bsr.s   getchar         and get it */
    bsr.s getchar
/* QL:         cmp.b   (a1)+,d1        does it match next table char? */
    cmp.b (a1)+,d1
/* QL:         beq.s   nextchar        no, start again with next symbol */
    beq.s nextchar
/* QL: char1 */
char1:
/* QL:         move.l  d0,a0           get posn of 1st char of buffer */
    move.l d0,a0
/* QL:         bsr.s   getchar         get 1st char, converted to single case */
    bsr.s getchar
/* QL: nextsym */
nextsym:
/* QL:         subq.b  #1,d4           any symbols left to check? */
    subq.b #1,d4
/* QL:         bcs.s   rts3            no, don't have a valid symbol then */
    bcs.s rts3
/* QL:         move.b  (a3)+,d2        get prebyte offset (n.b. alfnm clears d2 15-8) */
    move.b (a3)+,d2
/* QL:         lea     -1(a2,d2.w),a1  point to prebyte */
    lea (-1)(a2,d2.w),a1
/* QL:         move.b  (a1)+,d6        read prebyte and move on */
    move.b (a1)+,d6
/* QL:         cmp.b   (a1)+,d1        does 1st char match? */
    cmp.b (a1)+,d1
/* QL:         bne.s   nextsym         no, try the next symbol */
    bne.s nextsym
/* QL:         lsl.w   #4,d6           put space flag in bit 8 */
    lsl.w #4,d6
/* QL:         bra.s   nextchar */
    bra.s nextchar
/* QL: getchar */
getchar:
/* QL:         jsr     pa_alfnm(pc)    find out if char at (a0,a6) is a letter */
    jsr pa_alfnm(pc)
/* QL:         bcc.s   rts3            if it's a letter, force to a single case */
    bcc.s rts3
/* QL:         bclr    #5,d1           accented, lower case, or normal, upper case */
    bclr #5,d1
/* QL: rts3 */
rts3:
/* QL:         rts */
    rts 
/* QL: chsym */
chsym:
/* QL:         move.l  (sp)+,a2        get table base off stack */
    move.l (sp)+,a2
/* QL:         move.w  (a2)+,d4        get token type and count */
    move.w (a2)+,d4
/* QL:         move.l  a2,a3           set running pointer to offsets */
    move.l a2,a3
/* QL:         move.l  a0,d0           save where 1st char of buffer is */
    move.l a0,d0
/* QL:         moveq   #1<<4,d5        speed up counting */
    moveq #(1<<4),d5
/* QL:         bra.s   char1 */
    bra.s char1
/* QL: * Generate code/tables for text lexical stuff */
/* QL: alpha setstr ABCDEFGHIJKLMNOPQRSTUVWXYZ */
/* QL: pa_cd macro */
/* QL: * Generate entry points, code and tables for text lexical objects */
/* QL: sep pa_cd {,} {;} {\} ! to */
/* QL:         xdef    pa_cd[.lab],pa_tb[.lab] */
.globl pa_cdsep,pa_tbsep
/* QL: pa_cd[.lab] */
pa_cdsep:
/* QL:         bsr.s   chsym */
    bsr.s chsym
/* QL:         dc.b    b.[.lab] */
dc_anchor_1452:
.byte (b.sep)&255
/* QL: pa_tb[.lab] dc.b [.nparms] */
pa_tbsep:
dc_anchor_1456:
.byte (5)&255
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1462:
.byte (((sep1-dc_anchor_1462)+1))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1468:
.byte (((sep2-dc_anchor_1468)+2))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1474:
.byte (((sep3-dc_anchor_1474)+3))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1480:
.byte (((sep4-dc_anchor_1480)+4))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1486:
.byte (((sep5-dc_anchor_1486)+5))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: i setnum 0 */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
sep1:
dc_anchor_1495:
.byte (0x01)&255
.byte 44
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
sep2:
dc_anchor_1504:
.byte (0x01)&255
.byte 59
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
sep3:
dc_anchor_1513:
.byte (0x01)&255
.byte 92
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
sep4:
dc_anchor_1522:
.byte (0x01)&255
.byte 33
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
sep5:
dc_anchor_1531:
.byte (0x12)&255
.byte 84,79
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL:         ds.w    0 */
.balign 2,0
/* QL: mon pa_cd - + ~~ not */
/* QL:         xdef    pa_cd[.lab],pa_tb[.lab] */
.globl pa_cdmon,pa_tbmon
/* QL: pa_cd[.lab] */
pa_cdmon:
/* QL:         bsr.s   chsym */
    bsr.s chsym
/* QL:         dc.b    b.[.lab] */
dc_anchor_1545:
.byte (b.mon)&255
/* QL: pa_tb[.lab] dc.b [.nparms] */
pa_tbmon:
dc_anchor_1549:
.byte (4)&255
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1555:
.byte (((mon1-dc_anchor_1555)+1))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1561:
.byte (((mon2-dc_anchor_1561)+2))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1567:
.byte (((mon3-dc_anchor_1567)+3))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1573:
.byte (((mon4-dc_anchor_1573)+4))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: i setnum 0 */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
mon1:
dc_anchor_1582:
.byte (0x01)&255
.byte 45
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
mon2:
dc_anchor_1591:
.byte (0x01)&255
.byte 43
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
mon3:
dc_anchor_1600:
.byte (0x02)&255
.byte 126,126
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
mon4:
dc_anchor_1609:
.byte (0x13)&255
.byte 78,79,84
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL:         ds.w    0 */
.balign 2,0
/* QL: ops pa_cd + - * / >= > == = <> <= < || && ^^ ^ & or and xor mod div instr */
/* QL:         xdef    pa_cd[.lab],pa_tb[.lab] */
.globl pa_cdops,pa_tbops
/* QL: pa_cd[.lab] */
pa_cdops:
/* QL:         bsr.s   chsym */
    bsr.s chsym
/* QL:         dc.b    b.[.lab] */
dc_anchor_1623:
.byte (b.ops)&255
/* QL: pa_tb[.lab] dc.b [.nparms] */
pa_tbops:
dc_anchor_1627:
.byte (22)&255
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1633:
.byte (((ops1-dc_anchor_1633)+1))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1639:
.byte (((ops2-dc_anchor_1639)+2))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1645:
.byte (((ops3-dc_anchor_1645)+3))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1651:
.byte (((ops4-dc_anchor_1651)+4))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1657:
.byte (((ops5-dc_anchor_1657)+5))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1663:
.byte (((ops6-dc_anchor_1663)+6))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1669:
.byte (((ops7-dc_anchor_1669)+7))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1675:
.byte (((ops8-dc_anchor_1675)+8))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1681:
.byte (((ops9-dc_anchor_1681)+9))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1687:
.byte (((ops10-dc_anchor_1687)+10))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1693:
.byte (((ops11-dc_anchor_1693)+11))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1699:
.byte (((ops12-dc_anchor_1699)+12))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1705:
.byte (((ops13-dc_anchor_1705)+13))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1711:
.byte (((ops14-dc_anchor_1711)+14))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1717:
.byte (((ops15-dc_anchor_1717)+15))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1723:
.byte (((ops16-dc_anchor_1723)+16))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1729:
.byte (((ops17-dc_anchor_1729)+17))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1735:
.byte (((ops18-dc_anchor_1735)+18))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1741:
.byte (((ops19-dc_anchor_1741)+19))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1747:
.byte (((ops20-dc_anchor_1747)+20))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1753:
.byte (((ops21-dc_anchor_1753)+21))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
dc_anchor_1759:
.byte (((ops22-dc_anchor_1759)+22))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: i setnum 0 */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops1:
dc_anchor_1768:
.byte (0x01)&255
.byte 43
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops2:
dc_anchor_1777:
.byte (0x01)&255
.byte 45
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops3:
dc_anchor_1786:
.byte (0x01)&255
.byte 42
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops4:
dc_anchor_1795:
.byte (0x01)&255
.byte 47
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops5:
dc_anchor_1804:
.byte (0x02)&255
.byte 62,61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops6:
dc_anchor_1813:
.byte (0x01)&255
.byte 62
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops7:
dc_anchor_1822:
.byte (0x02)&255
.byte 61,61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops8:
dc_anchor_1831:
.byte (0x01)&255
.byte 61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops9:
dc_anchor_1840:
.byte (0x02)&255
.byte 60,62
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops10:
dc_anchor_1849:
.byte (0x02)&255
.byte 60,61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops11:
dc_anchor_1858:
.byte (0x01)&255
.byte 60
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops12:
dc_anchor_1867:
.byte (0x02)&255
.byte 124,124
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops13:
dc_anchor_1876:
.byte (0x02)&255
.byte 38,38
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops14:
dc_anchor_1885:
.byte (0x02)&255
.byte 94,94
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops15:
dc_anchor_1894:
.byte (0x01)&255
.byte 94
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops16:
dc_anchor_1903:
.byte (0x01)&255
.byte 38
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops17:
dc_anchor_1912:
.byte (0x12)&255
.byte 79,82
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops18:
dc_anchor_1921:
.byte (0x13)&255
.byte 65,78,68
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops19:
dc_anchor_1930:
.byte (0x13)&255
.byte 88,79,82
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops20:
dc_anchor_1939:
.byte (0x13)&255
.byte 77,79,68
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops21:
dc_anchor_1948:
.byte (0x13)&255
.byte 68,73,86
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
ops22:
dc_anchor_1957:
.byte (0x15)&255
.byte 73,78,83,84,82
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         end */
