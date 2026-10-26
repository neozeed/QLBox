/* Generated from original/M/ca/opexe.asm */
/* QL: * operation evaluator */
/* QL:         xdef    ca_opexe */
.globl ca_opexe
/* QL:         xref    ca_cncat,ca_cnvrt */
/* QL:         xref    mm_mrtor */
/* QL:         xref    ri_add,ri_cmp,ri_div,ri_fllin,ri_mult,ri_neg,ri_power,ri_powfp */
/* QL:         xref    ri_sub */
/* QL:         xref    ut_cstr,ut_istr */
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
/* QL:         include 'win1_m_inc_nt' */
/* QL: * name table types */
/* QL:         nolist */
/* QL: * First byte */
/* QL: t.unset equ     0       unset (null if 2nd byte zero) */
.equ t.unset,0
/* QL: t.intern equ    1       internal value held on ri stack */
.equ t.intern,1
/* QL: t.var   equ     2       simple variable */
.equ t.var,2
/* QL: t.arr   equ     3       array (substring if 2nd byte zero) */
.equ t.arr,3
/* QL: t.bpr   equ     4       basic procedure */
.equ t.bpr,4
/* QL: t.bfn   equ     5       basic function */
.equ t.bfn,5
/* QL: t.rep   equ     6       repeat loop index */
.equ t.rep,6
/* QL: t.for   equ     7       for loop index */
.equ t.for,7
/* QL: t.mcp   equ     8       machine code procedure */
.equ t.mcp,8
/* QL: t.mcf   equ     9       machine code function */
.equ t.mcf,9
/* QL: * Second byte */
/* QL: t.str   equ     1       2 byte positive string length + char {+ pad} */
.equ t.str,1
/* QL: t.fp    equ     2       6 byte floating point */
.equ t.fp,2
/* QL: t.int   equ     3       2 byte signed integer */
.equ t.int,3
/* QL: t.log   equ     4       2 byte 0=false 1=true (internal only) */
.equ t.log,4
/* QL: * Second word is name pointer. This is either the offset into the name list, or */
/* QL: * may be -1 if no name is applicable. */
/* QL: * Second longword is the value pointer. Generally this is an offset into the */
/* QL: * variable values area, or -1 to indicate an unset entry. */
/* QL: * For t.mcp/t.mcf this is the absolute entry point. */
/* QL: * For t.bpr/t.bfn the msw is the define line number. */
/* QL:  list */
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
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section ca_opexe */
.section ca_opexe,"ax"
/* QL: * Primary operator table... sorts out major decisions */
/* QL: optab1 */
optab1:
/* QL:  dc.w i_asm-e,i_asm-e,i_asm-e,fp2-e     + - * (i/i) / (f/f) */
.balign 2,0
dc_anchor_1087:
.word ((i_asm-e))&65535
.word ((i_asm-e))&65535
.word ((i_asm-e))&65535
.word ((fp2-e))&65535
/* QL:  dc.w c-e,c-e,c-e,c-e,c-e,c-e,c-e       >= > == = <> <= < (i/i or s/s) */
.balign 2,0
dc_anchor_1094:
.word ((c-e))&65535
.word ((c-e))&65535
.word ((c-e))&65535
.word ((c-e))&65535
.word ((c-e))&65535
.word ((c-e))&65535
.word ((c-e))&65535
/* QL:  dc.w b_dyad-e,b_dyad-e,b_dyad-e        || && ^^ (i/i) */
.balign 2,0
dc_anchor_1104:
.word ((b_dyad-e))&65535
.word ((b_dyad-e))&65535
.word ((b_dyad-e))&65535
/* QL:  dc.w exp-e,str2-e                      ^ (f/i) & (s/s) */
.balign 2,0
dc_anchor_1110:
.word ((exp-e))&65535
.word ((str2-e))&65535
/* QL:  dc.w l_dyad-e,l_dyad-e,l_dyad-e        or and xor (i/i) */
.balign 2,0
dc_anchor_1115:
.word ((l_dyad-e))&65535
.word ((l_dyad-e))&65535
.word ((l_dyad-e))&65535
/* QL:  dc.w int2-e,int2-e,str2-e              mod div (i/i) instr (s/s) */
.balign 2,0
dc_anchor_1121:
.word ((int2-e))&65535
.word ((int2-e))&65535
.word ((str2-e))&65535
/* QL: * Monadics */
/* QL:  dc.w i_minus-e,i_plus-e,b_not-e,l_not-e - (i) + (n) ~~ not (i) (monadic ops) */
.balign 2,0
dc_anchor_1128:
.word ((i_minus-e))&65535
.word ((i_plus-e))&65535
.word ((b_not-e))&65535
.word ((l_not-e))&65535
/* QL: * Secondary operator table... catches all the fp/fp stuff we had trouble with */
/* QL: optab2 */
optab2:
/* QL:  dc.w ri_add-e,ri_sub-e,ri_mult-e,ri_div-e      + - * / */
.balign 2,0
dc_anchor_1138:
.word ((ri_add-e))&65535
.word ((ri_sub-e))&65535
.word ((ri_mult-e))&65535
.word ((ri_div-e))&65535
/* QL:  dc.w f-e,f-e,f-e,f-e,f-e,f-e,f-e               >= > == = <> <= < */
.balign 2,0
dc_anchor_1145:
.word ((f-e))&65535
.word ((f-e))&65535
.word ((f-e))&65535
.word ((f-e))&65535
.word ((f-e))&65535
.word ((f-e))&65535
.word ((f-e))&65535
/* QL:  dc.w ri_powfp-e                                ^ (adjusted to save waste) */
.balign 2,0
dc_anchor_1155:
.word ((ri_powfp-e))&65535
/* QL: * d0 -  o- error code (not neccesarily in condition codes) */
/* QL: * d4 -i  - operation code in lsb - must not touch msw */
/* QL: * a1 -i o- arithmetic stack pointer (must be stored by calling routine) */
/* QL: * a5 -i o- name table pointer (updated properly here) */
/* QL: * d1-d3 destroyed */
/* QL: * Care must be taken that the exit from this module ensures that the data types */
/* QL: * recorded in the top NT entries always match the data on the RI stack. */
/* QL: * If a dyadic operation removes it's second operand, a5 must be decremented by */
/* QL: * eight and stored in bv_ntp. The returned value of a1 must be stored in bv_rip */
/* QL: * by the calling routine (ca_eval). */
/* QL: * These rules must be followed even on exit with a non-error code, when */
/* QL: * unraveling the table/stack is particularly sensitive! */
/* QL: ca_opexe */
ca_opexe:
/* QL:         moveq   #15,d2 */
    moveq #15,d2
/* QL:         and.b   -7(a6,a5.l),d2  mask any separator which may be here */
    and.b (-7)(a6,a5.l),d2
/* QL:         move.b  d2,-7(a6,a5.l)  store the masked type */
    move.b d2,(-7)(a6,a5.l)
/* QL:         clr.w   d1 */
    clr.w d1
/* QL: jmp2 */
jmp2:
/* QL:         moveq   #0,d0           assume we'll have no errors */
    moveq #0,d0
/* QL:         add.b   d4,d1 */
    add.b d4,d1
/* QL:         add.w   d1,d1 */
    add.w d1,d1
/* QL:         move.w  optab1-2(pc,d1.w),d1 what might we do for this operation? */
    move.w (optab1-2)(pc,d1.w),d1
/* QL:         subq.b  #t.fp,d2        set up condition code for the 2nd operand type */
    subq.b #t.fp,d2
/* QL:         jmp     e(pc,d1.w)      go do something */
.word 0x4efb
.word 4096|((e-.)&255)
/* QL: i_asm */
i_asm:
/* QL:         ble.s   fp2             not an integer, so we'll have to do fp/fp */
    ble.s fp2
/* QL:         bsr.s   try1st          what's the 1st operand type? */
    bsr.s try1st
/* QL:         ble.s   fp2             not integer, so must do fp/fp again */
    ble.s fp2
/* QL:         bsr.l   drop2           we're definately happy... */
    bsr.w drop2
/* QL:         move.w  -2(a6,a1.l),d1 */
    move.w (-2)(a6,a1.l),d1
/* QL:         subq.b  #b.dif,d4       which of +, - or * is it? */
    subq.b #b.dif,d4
/* QL:         bgt.s   i_mul */
    bgt.s i_mul
/* QL:         beq.s   i_sub */
    beq.s i_sub
/* QL:         add.w   d1,0(a6,a1.l) */
    add.w d1,0(a6,a1.l)
/* QL:         bvs.s   i_ext           ouch! have to extend answer into fp */
    bvs.s i_ext
/* QL: doneit */
doneit:
/* QL:         rts */
    rts 
/* QL: i_sub */
i_sub:
/* QL:         sub.w   d1,0(a6,a1.l) */
    sub.w d1,0(a6,a1.l)
/* QL:         bvc.s   doneit          nice! */
    bvc.s doneit
/* QL:         scc     d3 */
    scc d3
/* QL:         add.b   d3,d3           invert the extend bit */
    add.b d3,d3
/* QL: i_ext */
i_ext:
/* QL:         move.w  0(a6,a1.l),d3   get the bulk of the answer */
    move.w 0(a6,a1.l),d3
/* QL:         swap    d3 */
    swap d3
/* QL:         roxr.l  #1,d3           roll in the extend bit */
    roxr.l #1,d3
/* QL:         subq.l  #4,a1 */
    subq.l #4,a1
/* QL:         move.w  #$810,0(a6,a1.l) */
    move.w #0x810,0(a6,a1.l)
/* QL:         move.l  d3,2(a6,a1.l) */
    move.l d3,2(a6,a1.l)
/* QL: make_fp */
make_fp:
/* QL:         subq.b  #t.int-t.fp,-7(a6,a5.l)  change type from int to fp */
    subq.b #(t.int-t.fp),(-7)(a6,a5.l)
/* QL:         rts */
    rts 
/* QL: i_mul */
i_mul:
/* QL:         muls    0(a6,a1.l),d1 */
    muls 0(a6,a1.l),d1
/* QL:         move.w  d1,0(a6,a1.l)   store lsw, and hope it's ok... */
    move.w d1,0(a6,a1.l)
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         ext.l   d2 */
    ext.l d2
/* QL:         cmp.l   d2,d1           did the result still fit into a short integer? */
    cmp.l d2,d1
/* QL:         beq.s   anrts           hurrah! */
    beq.s anrts
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         jsr     ri_fllin(pc)    go float it */
    jsr ri_fllin(pc)
/* QL:         bra.s   make_fp         change it to fp */
    bra.s make_fp
/* QL: try1st */
try1st:
/* QL:         moveq   #15,d3 */
    moveq #15,d3
/* QL:         and.b   -15(a6,a5.l),d3 what's the 1st operand type? */
    and.b (-15)(a6,a5.l),d3
/* QL:         move.b  d3,-15(a6,a5.l) */
    move.b d3,(-15)(a6,a5.l)
/* QL:         subq.b  #t.fp,d3 */
    subq.b #t.fp,d3
/* QL:         rts */
    rts 
/* QL: e */
e:
/* QL: fp2x */
fp2x:
/* QL:         subq.w  #3,d4           adjust opcode to save 3 words in table for pow */
    subq.w #3,d4
/* QL: fp2 */
fp2:
/* QL:         bsr.s   cnvrtf          convert 2nd operand to float */
    bsr.s cnvrtf
/* QL:         bne.s   anrts           nasty - it didn't work! */
    bne.s anrts
/* QL:         bsr.s   drop6           that's taken care of */
    bsr.s drop6
/* QL:         move.l  -4(a6,a1.l),-(sp) */
    move.l (-4)(a6,a1.l),-(sp)
/* QL:         move.w  -6(a6,a1.l),-(sp) save 2nd operand */
    move.w (-6)(a6,a1.l),-(sp)
/* QL:         bsr.s   cnvrtf          convert 1st operand to float */
    bsr.s cnvrtf
/* QL:         bne.s   ohdear6 */
    bne.s ohdear6
/* QL:         subq.l  #6,a1           space down the stack */
    subq.l #6,a1
/* QL:         move.w  (sp)+,0(a6,a1.l) restore 2nd operand */
    move.w (sp)+,0(a6,a1.l)
/* QL:         move.l  (sp)+,2(a6,a1.l) */
    move.l (sp)+,2(a6,a1.l)
/* QL:         moveq   #(optab2-optab1)/2,d1 */
    moveq #((optab2-optab1)/2),d1
/* QL:         bra.l   jmp2            go do secondary jump table */
    bra.w jmp2
/* QL: ohdear6 */
ohdear6:
/* QL:         addq.l  #6,sp           discard the saved fp */
    addq.l #6,sp
/* QL: anrts */
anrts:
/* QL:         rts */
    rts 
/* QL: exp */
exp:
/* QL:         ble.s   fp2x            2nd operand not integer - do the standard stuff */
    ble.s fp2x
/* QL:         bsr.s   drop2 */
    bsr.s drop2
/* QL:         move.w  -2(a6,a1.l),-(sp) save integer power */
    move.w (-2)(a6,a1.l),-(sp)
/* QL:         bsr.s   cnvrtf          convert 1st operand to float */
    bsr.s cnvrtf
/* QL:         bne.s   ohdear2 */
    bne.s ohdear2
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  (sp)+,0(a6,a1.l) */
    move.w (sp)+,0(a6,a1.l)
/* QL:         jmp     ri_power(pc)    go do integer power */
    jmp ri_power(pc)
/* QL: * Various comparisons */
/* QL: c */
c:
/* QL:         beq.s   fp2             if fp, make both fp */
    beq.s fp2
/* QL:         bmi.l   c_fpstr         if str, go see if both are strings */
    bmi.w c_fpstr
/* QL:         bsr.s   try1st          what's the 1st operand like? */
    bsr.s try1st
/* QL:         ble.s   fp2             if not int, must do fp/fp */
    ble.s fp2
/* QL:         bsr.s   drop2           yipee! we have int/int compare... do it here */
    bsr.s drop2
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         move.w  0(a6,a1.l),d1 */
    move.w 0(a6,a1.l),d1
/* QL:         cmp.w   -2(a6,a1.l),d1 */
    cmp.w (-2)(a6,a1.l),d1
/* QL:         bgt.s   c_bit */
    bgt.s c_bit
/* QL:         sne     d0 */
    sne d0
/* QL:         ext.w   d0 */
    ext.w d0
/* QL: c_bit */
c_bit:
/* QL:         clr.w   d1 */
    clr.w d1
/* QL:         dc.w    $093b,patcmp+1-*-2 btst    d4,patcmp+1(pc,d0.w) */
.balign 2,0
dc_anchor_1371:
.word 0x093b
.word ((((patcmp+1)-dc_anchor_1371)-2))&65535
/* QL:         sne     d1 */
    sne d1
/* QL:         neg.b   d1 */
    neg.b d1
/* QL: storeint */
storeint:
/* QL:         move.w  d1,0(a6,a1.l) */
    move.w d1,0(a6,a1.l)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         assert  8+b.near-7,8+b.gt-6,8+b.ge-5,8,b.lt-3,b.le-2,b.ne-1,b.eq */
/* original assertion: 8+b.near-7,8+b.gt-6,8+b.ge-5,8,b.lt-3,b.le-2,b.ne-1,b.eq */
/* QL: patcmp  dc.b    %00001110,%10100101,%01100010,0 patterns for <, = and > */
patcmp:
dc_anchor_1390:
.byte (0b00001110)&255
.byte (0b10100101)&255
.byte (0b01100010)&255
.byte (0)&255
/* QL: cnvrtf */
cnvrtf:
/* QL:         moveq   #t.fp,d0 */
    moveq #t.fp,d0
/* QL:         jmp     ca_cnvrt(pc) */
    jmp ca_cnvrt(pc)
/* QL: drop6 */
drop6:
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL: drop2 */
drop2:
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         move.l  a1,bv_rip(a6) */
    move.l a1,bv_rip(a6)
/* QL: drop */
drop:
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL:         move.l  a5,bv_ntp(a6) */
    move.l a5,bv_ntp(a6)
/* QL:         rts */
    rts 
/* QL: int2 */
int2:
/* QL:         moveq   #t.int,d0 */
    moveq #t.int,d0
/* QL:         bsr.s   cnvrt0          convert 2nd operand to int */
    bsr.s cnvrt0
/* QL:         bne.s   aprts */
    bne.s aprts
/* QL:         bsr.s   drop2           that's taken care of */
    bsr.s drop2
/* QL:         move.w  -2(a6,a1.l),-(sp) save 2nd operand */
    move.w (-2)(a6,a1.l),-(sp)
/* QL:         moveq   #t.int,d0 */
    moveq #t.int,d0
/* QL:         bsr.s   cnvrt0          convert 1st operand to int */
    bsr.s cnvrt0
/* QL:         beq.l   div_mod */
    beq.w div_mod
/* QL: ohdear2 */
ohdear2:
/* QL:         addq.l  #2,sp           discard saved 2nd operand */
    addq.l #2,sp
/* QL: aprts */
aprts:
/* QL:         rts */
    rts 
/* QL: cnvrts */
cnvrts:
/* QL:         moveq   #t.str,d0       make operand into a string (can't fail!) */
    moveq #t.str,d0
/* QL: cnvrt0 */
cnvrt0:
/* QL:         jmp     ca_cnvrt(pc) */
    jmp ca_cnvrt(pc)
/* QL: gostr2 */
gostr2:
/* QL:         lsr.b   #2,d4           which of & or instr are we doing? */
    lsr.b #2,d4
/* QL:         bcc.s   gocncat         & is the hard one */
    bcc.s gocncat
/* QL:         movem.l d7/a0,-(sp) */
    movem.l d7/a0,-(sp)
/* QL:         bsr.s   add_a1          step over first string */
    bsr.s add_a1
/* QL:         move.l  a1,d7           remember where it started */
    move.l a1,d7
/* QL:         bsr.s   add_a1_0        step past second string */
    bsr.s add_a1_0
/* QL:         exg     a0,d7           now put a0/a1 strings and d7 = top of stack */
    exg a0,d7
/* QL:         bra.s   istrnow */
    bra.s istrnow
/* QL: gocncat */
gocncat:
/* QL:         pea     ca_cncat(pc) */
    pea ca_cncat(pc)
/* QL: drops */
drops:
/* QL:         bra.s   drop */
    bra.s drop
/* QL: str2 */
str2:
/* QL:         bsr.s   cnvrts          make the 2nd operand into a string */
    bsr.s cnvrts
/* QL:         bsr.l   try1st          what's the 1st parameter like? */
    bsr.w try1st
/* QL:         blt.s   gostr2          phew! already a string, so no need for .... */
    blt.s gostr2
/* QL:         movem.l d7/a0,-(sp)     registers that need to be saved */
    movem.l d7/a0,-(sp)
/* QL:         bsr.s   add_a1          find out where the second operand lives */
    bsr.s add_a1
/* QL:         moveq   #2,d7           length of an int */
    moveq #2,d7
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   cop1wrd */
    bne.s cop1wrd
/* QL:         moveq   #6,d7           length of an fp */
    moveq #6,d7
/* QL:         move.l  2(a6,a0.l),-4(a6,a1.l) copy mantissa */
    move.l 2(a6,a0.l),(-4)(a6,a1.l)
/* QL: cop1wrd */
cop1wrd:
/* QL:         sub.l   d7,a1 */
    sub.l d7,a1
/* QL:         move.w  0(a6,a0.l),0(a6,a1.l) copy exponent or integer */
    move.w 0(a6,a0.l),0(a6,a1.l)
/* QL:         add.l   a0,d7           this is the top of the stack */
    add.l a0,d7
/* QL:         move.l  a1,bv_rip(a6)   say where we are at the moment */
    move.l a1,bv_rip(a6)
/* QL:         move.b  -15(a6,a5.l),-7(a6,a5.l) fudge top entry look like 2nd!!! */
    move.b (-15)(a6,a5.l),(-7)(a6,a5.l)
/* QL:         sub.l   bv_ribas(a6),d7 make it depth of stack, in case it moves */
    sub.l bv_ribas(a6),d7
/* QL:         bsr.s   cnvrts          make the 1st operand into a string (d0.l=0) */
    bsr.s cnvrts
/* QL:         add.l   bv_ribas(a6),d7 add back base of stack */
    add.l bv_ribas(a6),d7
/* QL:         assert  0,b.join&2,b.instr&2-2 */
/* original assertion: 0,b.join&2,b.instr&2-2 */
/* QL:         lsr.b   #2,d4           which of & or instr are we doing? */
    lsr.b #2,d4
/* QL:         bcc.s   gocnc           & is the hard one */
    bcc.s gocnc
/* QL:         bsr.s   add_a1 */
    bsr.s add_a1
/* QL: istrnow */
istrnow:
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         moveq   #1,d0           set for instr */
    moveq #1,d0
/* QL:         jsr     ut_istr(pc) */
    jsr ut_istr(pc)
/* QL:         move.l  d7,a1 */
    move.l d7,a1
/* QL:         movem.l (sp)+,d7/a0 */
    movem.l (sp)+,d7/a0
/* QL:         subq.l  #2,a1           where to put integer result */
    subq.l #2,a1
/* QL:         bsr.s   drops */
    bsr.s drops
/* QL:         move.b  #t.int,-7(a6,a5.l) */
    move.b #(t.int&255),(-7)(a6,a5.l)
/* QL:         bra.l   storeint */
    bra.w storeint
/* QL: add_a1_0 */
add_a1_0:
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL: add_a1 */
add_a1:
/* QL:         move.w  0(a6,a1.l),d2   length of string now at tos */
    move.w 0(a6,a1.l),d2
/* QL:         lea     2(a1,d2.w),a0   drop length and chars */
    lea 2(a1,d2.w),a0
/* QL:         rol.b   #8,d2           check for odd length */
    rol.b #8,d2
/* QL:         bcc.s   rts9 */
    bcc.s rts9
/* QL:         addq.l  #1,a0           skip pad byte */
    addq.l #1,a0
/* QL: rts9 */
rts9:
/* QL:         rts */
    rts 
/* QL: * d0.l = 0 */
/* QL: gocnc */
gocnc:
/* QL:         bsr.s   drops */
    bsr.s drops
/* QL:         move.b  #t.str,-7(a6,a5.l) */
    move.b #(t.str&255),(-7)(a6,a5.l)
/* QL:         bsr.s   add_a1          now a1 = 1st string, a0 = 2nd string */
    bsr.s add_a1
/* QL:         move.w  d2,d4           save 1st string length */
    move.w d2,d4
/* QL:         move.w  0(a6,a0.l),d1   2nd string length */
    move.w 0(a6,a0.l),d1
/* QL:         add.w   d1,d2           combined length */
    add.w d1,d2
/* QL:         exg     d7,a1 */
    exg d7,a1
/* QL:         exg     a0,a1           source into a1, destination into a0 */
    exg a1,a0
/* QL: * d7/d4 = tos string, a1/d1 = nos string, a0 = all removed, d2 = d1+d4 */
/* QL:         cmp.w   #32765,d2       we won't let it get too huge... */
    cmp.w #32765,d2
/* QL:         bcs.l   cncat */
    bcs.w cncat
/* QL:         moveq   #err.ov,d0      overflow error */
    moveq #err.ov,d0
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL: putlen */
putlen:
/* QL:         lea     -2(a0),a1 */
    lea (-2)(a0),a1
/* QL:         movem.l (sp)+,d7/a0 */
    movem.l (sp)+,d7/a0
/* QL:         move.w  d2,0(a6,a1.l) */
    move.w d2,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: c_fpstr */
c_fpstr:
/* QL:         bsr.l   try1st          what's the 1st operand like? */
    bsr.w try1st
/* QL:         bge.l   fp2             if not str, must do fp/fp */
    bge.w fp2
/* QL: * We have two strings to compare... so do it */
/* QL:         bsr.l   drop */
    bsr.w drop
/* QL:         cmp.b   #b.near,d4      is it == ? */
    cmp.b #(b.near&255),d4
/* QL:         sne     d0 */
    sne d0
/* QL:         addq.b  #3,d0 */
    addq.b #3,d0
/* QL:         move.l  a0,-(sp) */
    move.l a0,-(sp)
/* QL:         bsr.s   add_a1          a0 is at start of string b */
    bsr.s add_a1
/* QL:         jsr     ut_cstr(pc) */
    jsr ut_cstr(pc)
/* QL:         bsr.s   add_a1_0        a0 is at end of string b */
    bsr.s add_a1_0
/* QL:         lea     -2(a0),a1       a1 is now ready for t or f value */
    lea (-2)(a0),a1
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         bra.l   c_bt2 */
    bra.w c_bt2
/* QL: b_dyad */
b_dyad:
/* QL:         moveq   #t.int,d0 */
    moveq #t.int,d0
/* QL:         bra.s   logic */
    bra.s logic
/* QL: l_dyad */
l_dyad:
/* QL:         assert  b.lor-b.bor,b.land-b.band,b.land-b.band */
/* original assertion: b.lor-b.bor,b.land-b.band,b.land-b.band */
/* QL:         subq.b  #b.lor-b.bor,d4 */
.word 20740|((((b.lor-b.bor))&7)<<9)
/* QL:         moveq   #t.log,d0 */
    moveq #t.log,d0
/* QL: logic */
logic:
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         bsr.s   lcnv */
    bsr.s lcnv
/* QL:         bsr.l   drop2 */
    bsr.w drop2
/* QL:         move.w  (sp),d0 */
    move.w (sp),d0
/* QL:         move.w  -2(a6,a1.l),(sp) */
    move.w (-2)(a6,a1.l),(sp)
/* QL:         bsr.s   lcnv */
    bsr.s lcnv
/* QL:         move.w  (sp)+,d1 */
    move.w (sp)+,d1
/* QL:         assert  0,b.bor&3,b.band&3-1,b.bxor&3-2 */
/* original assertion: 0,b.bor&3,b.band&3-1,b.bxor&3-2 */
/* QL:         asl.b   #7,d4 */
    asl.b #7,d4
/* QL:         bmi.s   l_and */
    bmi.s l_and
/* QL:         bcs.s   l_xor */
    bcs.s l_xor
/* QL:         or.w    d1,0(a6,a1.l) */
    or.w d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: l_and */
l_and:
/* QL:         and.w   d1,0(a6,a1.l) */
    and.w d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: l_xor */
l_xor:
/* QL:         eor.w   d1,0(a6,a1.l) */
    eor.w d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: lcnv */
lcnv:
/* QL:         bsr.s   cnv0 */
    bsr.s cnv0
/* QL:         beq.s   aorts */
    beq.s aorts
/* QL:         addq.l  #6,sp           drop saved word and return address */
    addq.l #6,sp
/* QL:         rts */
    rts 
/* QL: i_minus */
i_minus:
/* QL:         ble.s   f_minus         rats! have to do it in fp */
    ble.s f_minus
/* QL:         neg.w   0(a6,a1.l) */
    neg.w 0(a6,a1.l)
/* QL:         bvc.s   aorts           only $8000 screws up here, and stays! */
    bvc.s aorts
/* QL: f_minus */
f_minus:
/* QL:         bsr.s   cnvf */
    bsr.s cnvf
/* QL:         bne.s   aorts */
    bne.s aorts
/* QL:         jmp     ri_neg(pc) */
    jmp ri_neg(pc)
/* QL: i_plus */
i_plus:
/* QL:         bge.s   aorts           don't bother if it's already numeric */
    bge.s aorts
/* QL: cnvf */
cnvf:
/* QL:         moveq   #t.fp,d0 */
    moveq #t.fp,d0
/* QL: cnv0 */
cnv0:
/* QL:         jmp     ca_cnvrt(pc) */
    jmp ca_cnvrt(pc)
/* QL: b_not */
b_not:
/* QL:         moveq   #t.int,d0 */
    moveq #t.int,d0
/* QL:         bsr.s   cnv0 */
    bsr.s cnv0
/* QL:         bne.s   aorts */
    bne.s aorts
/* QL:         not.w   0(a6,a1.l)      invert all bits */
    not.w 0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: l_not */
l_not:
/* QL:         moveq   #t.log,d0 */
    moveq #t.log,d0
/* QL:         bsr.s   cnv0 */
    bsr.s cnv0
/* QL:         bne.s   aorts */
    bne.s aorts
/* QL:         bchg    d0,1(a6,a1.l)   swap 0 <--> 1 */
    bchg d0,1(a6,a1.l)
/* QL: aorts */
aorts:
/* QL:         rts */
    rts 
/* QL: f */
f:
/* QL:         jsr     ri_cmp(pc) */
    jsr ri_cmp(pc)
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL:         cmp.b   #b.near,d4      if op was == ... */
    cmp.b #(b.near&255),d4
/* QL:         beq.s   f_approx        go see to that */
    beq.s f_approx
/* QL:         move.b  -2(a6,a1.l),d0  get msb mantissa, $80 <, 0 = or $40 > */
    move.b (-2)(a6,a1.l),d0
/* QL:         beq.s   c_bt2           zero result is ready */
    beq.s c_bt2
/* QL:         rol.b   #2,d0           that was $40 -> 1, $80 -> 2 */
    rol.b #2,d0
/* QL:         bcs.s   c_bt2           so carry will be set if we've got a good 1 */
    bcs.s c_bt2
/* QL: c_bt1 */
c_bt1:
/* QL:         moveq   #-1,d0          set -1 */
    moveq #(-1),d0
/* QL: c_bt2 */
c_bt2:
/* QL:         move.b  #t.int,-7(a6,a5.l) make into an integer */
    move.b #(t.int&255),(-7)(a6,a5.l)
/* QL:         bra.l   c_bit */
    bra.w c_bit
/* QL: f_approx */
f_approx:
/* QL:         move.b  -4(a6,a1.l),d0  msb exponent is 0 if == is true, 8 otherwise */
    move.b (-4)(a6,a1.l),d0
/* QL:         bne.s   c_bt1 */
    bne.s c_bt1
/* QL:         bra.s   c_bt2 */
    bra.s c_bt2
/* QL: div_mod */
div_mod:
/* QL:         move.w  0(a6,a1.l),d1   get a */
    move.w 0(a6,a1.l),d1
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         move.w  (sp)+,d0        get b */
    move.w (sp)+,d0
/* QL:         beq.s   dmzero          oops */
    beq.s dmzero
/* QL:         smi     d2              flag if negative, as remainder will need negate */
    smi d2
/* QL:         bpl.s   dmbypos */
    bpl.s dmbypos
/* QL:         neg.l   d1              if b was -ve, negate a and b */
    neg.l d1
/* QL:         neg.w   d0 */
    neg.w d0
/* QL:         bvs.s   dmby32k         sort out div/mod -32768 */
    bvs.s dmby32k
/* QL: dmbypos */
dmbypos:
/* QL:         divs    d0,d1           get a/b */
    divs d0,d1
/* QL:         bvs.s   dmovr           oops (must have been trying to do -32768/-1) */
    bvs.s dmovr
/* QL: dmok */
dmok:
/* QL:         tst.l   d1              has remainder come out negative? */
    tst.l d1
/* QL:         bpl.s   dmrpos          no, that's ok */
    bpl.s dmrpos
/* QL:         swap    d0              (note, msw was zero, as no error at int cnvrt) */
    swap d0
/* QL:         add.l   d0,d1           force remainder to positive */
    add.l d0,d1
/* QL:         subq.w  #1,d1           push quotient down one (can't overflow) */
    subq.w #1,d1
/* QL: dmrpos */
dmrpos:
/* QL:         assert  0,b.idiv&1-1,b.mod&1 */
/* original assertion: 0,b.idiv&1-1,b.mod&1 */
/* QL:         asr.b   #1,d4 */
    asr.b #1,d4
/* QL:         bcs.s   storint2 */
    bcs.s storint2
/* QL:         swap    d1 */
    swap d1
/* QL:         tst.b   d2              was it a negative divisor? */
    tst.b d2
/* QL:         beq.s   storint2        no - leave positive remainder */
    beq.s storint2
/* QL:         neg.w   d1              yes - make remainder negative */
    neg.w d1
/* QL: storint2 */
storint2:
/* QL:         bra.l   storeint */
    bra.w storeint
/* QL: dmby32k */
dmby32k:
/* QL:         add.w   d1,d1           was original a zero or -32768? */
    add.w d1,d1
/* QL:         beq.s   dma32k0         yes, go sort those as special cases */
    beq.s dma32k0
/* QL:         lsr.w   #1,d1           force +ve and mod is ready */
    lsr.w #1,d1
/* QL:         swap    d1              +/-ve div -32768 = -1/0, mod is -a&&32767 */
    swap d1
/* QL:         bra.s   dmrpos */
    bra.s dmrpos
/* QL: dma32k0 */
dma32k0:
/* QL:         addx.b  d1,d1           ahah! 0 = 0/0, -32768 div/mod -32768 = 1/0 */
    addx.b d1,d1
/* QL:         bra.s   dmrpos */
    bra.s dmrpos
/* QL: dmovr */
dmovr:
/* QL:         clr.w   d1              -32768 mod -1 = 0 is a valid answer ... */
    clr.w d1
/* QL:         asr.b   #1,d4           ... but -32768 div -1 = 32768 doesn't fit! */
    asr.b #1,d4
/* QL:         bcc.s   storint2 */
    bcc.s storint2
/* QL: dmzero */
dmzero:
/* QL:         moveq   #err.ov,d0 */
    moveq #err.ov,d0
/* QL:         rts */
    rts 
/* QL: * d0=0, d7/d4 = tos string, a1/d1 = nos string, a0 = all removed, d2 = d1+d4 */
/* QL: cncat */
cncat:
/* QL:         btst    d0,d2           is length going to be odd? */
    btst d0,d2
/* QL:         beq.s   notodd */
    beq.s notodd
/* QL:         subq.l  #1,a0           yes - leave the odd junk byte */
    subq.l #1,a0
/* QL: notodd */
notodd:
/* QL:         bsr.s   copup           copy 2nd operand bytes up the stack */
    bsr.s copup
/* QL:         move.l  d7,a1           get back 1st string */
    move.l d7,a1
/* QL:         move.w  d4,d1           length of 1st string */
    move.w d4,d1
/* QL:         pea     putlen          go back to store length */
    pea putlen(pc)
/* QL: copup */
copup:
/* QL: * The following test needs tuning... the break even point must come somewhere */
/* QL:         add.w   d1,a1           end of source string */
    add.w d1,a1
/* QL:         cmp.w   #64,d1          is it worth getting clever? */
    cmp.w #64,d1
/* QL:         bcs.s   copsent         no - go do slow stuff */
    bcs.s copsent
/* QL:         sub.w   d1,a1           back to start of source string */
    sub.w d1,a1
/* QL:         addq.l  #2,a1           miss out length */
    addq.l #2,a1
/* QL:         sub.w   d1,a0           start of destination area */
    sub.w d1,a0
/* QL:         ext.l   d1              clear msw */
    ext.l d1
/* QL:         jmp     mm_mrtor(pc)    go use the fast copy */
    jmp mm_mrtor(pc)
/* QL: copsl */
copsl:
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  2(a6,a1.l),0(a6,a0.l) */
    move.b 2(a6,a1.l),0(a6,a0.l)
/* QL: copsent */
copsent:
/* QL:         dbra    d1,copsl */
    dbra d1,copsl
/* QL:         rts */
    rts 
/* QL:         vect4000 ca_opexe */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl ca$opexe
/* QL: [o]     equ     [h]-$4000 */
.equ ca$opexe,(ca_opexe-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
