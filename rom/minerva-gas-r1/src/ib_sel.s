/* Generated from original/M/ib/sel.asm */
/* QL: * do a SELect */
/* QL:         xdef    ib_sel */
.globl ib_sel
/* QL:         xref    bv_chrix */
/* QL:         xref    ca_eval */
/* QL:         xref    ib_chinl,ib_eos,ib_fchk,ib_index,ib_nxcom,ib_nxnon,ib_s2non */
/* QL:         xref    ri_cmp */
/* QL:         xref    ut_csstr */
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
/* QL:         section ib_sel */
.section ib_sel,"ax"
/* QL: * d0 -  o- error code */
/* QL: * a4 -i o- program file pointer */
/* QL: * d0-d6/a0-a2 destroyed */
/* QL: * Locally: */
/* QL: * d3 - nest level */
/* QL: * d4 - name row */
/* QL: * d5 - variable type */
/* QL: * d6 - string length, fp exponent or integer value */
/* QL: * a1 - ri stack */
/* QL: * a2 - vv offset to string, fp mantissa or unused */
/* QL: ib_sel */
ib_sel:
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #w.on,d1 */
    cmp.w #w.on,d1
/* QL:         bne.s   nametok */
    bne.s nametok
/* QL:         jsr     ib_s2non(pc)    don't need it */
    jsr ib_s2non(pc)
/* QL: nametok */
nametok:
/* QL:         move.l  0(a6,a4.l),d4   read name row, and keep msw as w.nam */
    move.l 0(a6,a4.l),d4
/* QL:         jsr     ib_index(pc)    find its value (d0=offset, d1=use, d2=type) */
    jsr ib_index(pc)
/* QL:         bge.s   valok           ok if the offset is >= 0 */
    bge.s valok
/* QL: err_xp */
err_xp:
/* QL:         moveq   #err.xp,d0 */
    moveq #err.xp,d0
/* QL:         rts */
    rts 
/* QL: valok */
valok:
/* QL:         move.b  d2,d5           set variable type */
    move.b d2,d5
/* QL:         subq.b  #t.arr,d1       we need to catch (sub)string arrays */
    subq.b #t.arr,d1
/* QL:         bne.s   simple          (too bad if it's some silly type) */
    bne.s simple
/* QL:         move.w  6(a6,a2.l),d6   possible sub-string length */
    move.w 6(a6,a2.l),d6
/* QL:         assert  0,t.str-1,t.fp-2,t.int-3 */
/* original assertion: 0,t.str-1,t.fp-2,t.int-3 */
/* QL:         moveq   #t.str,d3 */
    moveq #t.str,d3
/* QL:         cmp.w   4(a6,a2.l),d3 */
    cmp.w 4(a6,a2.l),d3
/* QL:         bne.s   err_xp          one dimension only */
    bne.s err_xp
/* QL:         move.l  0(a6,a2.l),a2   get VV offset to data */
    move.l 0(a6,a2.l),a2
/* QL:         cmp.b   d3,d2 */
    cmp.b d3,d2
/* QL:         bhi.s   err_xp          don't allow fp/int arrays (d2 now -1) */
    bhi.s err_xp
/* QL:         bne.s   all_set         substring is ready now */
    bne.s all_set
/* QL:         move.l  a2,d0           save the offset            */
    move.l a2,d0
/* QL:         add.l   bv_vvbas(a6),a2 need to pick up length of string */
    add.l bv_vvbas(a6),a2
/* QL: simple */
simple:
/* QL:         movem.l -2(a6,a2.l),d6/a2 pick up length, exponent+mantissa or integer */
    movem.l (-2)(a6,a2.l),d6/a2
/* QL:         subq.b  #t.fp,d2 */
    subq.b #t.fp,d2
/* QL:         bcc.s   all_set         ready except for string */
    bcc.s all_set
/* QL:         move.l  d0,a2           put back just the offset */
    move.l d0,a2
/* QL:         addq.l  #2,a2           step past the length */
    addq.l #2,a2
/* QL: all_set */
all_set:
/* QL:         clr.w   d3              set nest level zero */
    clr.w d3
/* QL:         tst.b   bv_inlin(a6)    are we already embedded? */
    tst.b bv_inlin(a6)
/* QL:         bne.s   entry           yes, leave it as is */
    bne.s entry
/* QL:         jsr     ib_chinl(pc)    is this now an in-line clause? */
    jsr ib_chinl(pc)
/* QL:         blt.s   entry           no, get on with it */
    blt.s entry
/* QL:         st      bv_inlin(a6)    only set to -1 if not already set */
    st bv_inlin(a6)
/* QL:         bra.s   entry */
    bra.s entry
/* QL: * find an ON (or =) for a SELect, or drop out at END SELect, etc. */
/* QL: skipto */
skipto:
/* QL:         jsr     ib_nxcom(pc)    skip over "TO expr", looking for a comma */
    jsr ib_nxcom(pc)
/* QL: nextrnge */
nextrnge:
/* QL:         cmp.w   #w.symcom,0(a6,a4.l) is token a comma? */
    cmp.w #w.symcom,0(a6,a4.l)
/* QL:         beq.s   onrng           yes, then the list carries on */
    beq.s onrng
/* QL:         moveq   #-1,d3          reset count of nested sels */
    moveq #(-1),d3
/* QL: add1 */
add1:
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL: nxstat */
nxstat:
/* QL:         jsr     ib_fchk(pc)     find next statement and check it */
    jsr ib_fchk(pc)
/* QL:         bne.s   chklev          not starting with a keyword */
    bne.s chklev
/* QL:         subq.b  #b.end,d1       is it END? */
    subq.b #b.end,d1
/* QL:         beq.s   do_end */
    beq.s do_end
/* QL:         subq.b  #w.sel-w.end,d1 is it SELect? */
.word 20737|((((w.sel-w.end))&7)<<9)
/* QL:         beq.s   do_sel */
    beq.s do_sel
/* QL:         assert  1<<4,w.on-w.sel */
/* original assertion: 1<<4,w.on-w.sel */
/* QL:         roxl.b  #4,d1           is it ON? */
    roxl.b #4,d1
/* QL:         bne.s   nxstat */
    bne.s nxstat
/* QL:         jsr     ib_s2non(pc)    skip the ON and get the next thing */
    jsr ib_s2non(pc)
/* QL:         cmp.l   0(a6,a4.l),d4   is it a name, and the same name? */
    cmp.l 0(a6,a4.l),d4
/* QL:         bne.s   nxstat */
    bne.s nxstat
/* QL: entry */
entry:
/* QL:         addq.l  #4,a4           move over name, now we may find '=' */
    addq.l #4,a4
/* QL:         ;                       (this could still be ON <expr> GO) */
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL: chklev */
chklev:
/* QL:         tst.w   d3              is count equal to zero */
    tst.w d3
/* QL:         bne.s   nxstat          carry on if nested */
    bne.s nxstat
/* QL: chkeq */
chkeq:
/* QL:         cmp.w   #w.equal,d1     is first, or after "{SEL} ON <name>", an = ? */
    cmp.w #w.equal,d1
/* QL:         bne.s   nxstat          no */
    bne.s nxstat
/* QL: * check on range against value */
/* QL: onrng */
onrng:
/* QL:         jsr     ib_s2non(pc)    skip token and look for range */
    jsr ib_s2non(pc)
/* QL:         cmp.w   #w.rmndr,d1     REMAINDER ? */
    cmp.w #w.rmndr,d1
/* QL:         beq.s   okrts */
    beq.s okrts
/* QL:         bsr.s   eval            read lower or only limit */
    bsr.s eval
/* QL:         cmp.w   #w.keyto,0(a6,a4.l) */
    cmp.w #w.keyto,0(a6,a4.l)
/* QL:         beq.s   do_to */
    beq.s do_to
/* QL:         sf      d1 */
    sf d1
/* QL:         moveq   #3,d0           (string comparison type is ==) */
    moveq #3,d0
/* QL:         bsr.s   docmp           check for a1==a2 */
    bsr.s docmp
/* QL: qgood */
qgood:
/* QL:         bne.s   nextrnge */
    bne.s nextrnge
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: do_sel */
do_sel:
/* QL:         tst.b   bv_inlin(a6)    are we in-line already? */
    tst.b bv_inlin(a6)
/* QL:         bne.s   add1            yes, inc nest count, else skip over whole line */
    bne.s add1
/* QL:         jsr     ib_chinl(pc)    select in-line? */
    jsr ib_chinl(pc)
/* QL:         bne.s   add1            no, inc nest count */
    bne.s add1
/* QL: loop */
loop:
/* QL:         addq.l  #2,a4           move over the token */
    addq.l #2,a4
/* QL:         jsr     ib_eos(pc)      get end of statement */
    jsr ib_eos(pc)
/* QL:         bge.s   loop            if not end of line, try again */
    bge.s loop
/* QL:         bra.s   nxstat */
    bra.s nxstat
/* QL: do_end */
do_end:
/* QL:         jsr     ib_s2non(pc)    step past end */
    jsr ib_s2non(pc)
/* QL:         cmp.w   #w.sel,d1       END SELect? */
    cmp.w #w.sel,d1
/* QL:         bne.s   nxstat */
    bne.s nxstat
/* QL:         dbra    d3,nxstat       yes, drop a level and continue if still nested */
    dbra d3,nxstat
/* QL:         bra.s   okrts           found an END SELect or nothing */
    bra.s okrts
/* QL: do_to */
do_to:
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         bsr.s   docmp2          check for a2>=a1 */
    bsr.s docmp2
/* QL:         bne.l   skipto          failed first part of range */
    bne.w skipto
/* QL:         addq.l  #2,a4           skip to */
    addq.l #2,a4
/* QL:         bsr.s   eval            get upper limit */
    bsr.s eval
/* QL:         st      d1 */
    st d1
/* QL:         bsr.s   docmp2          check for a2<=a1 */
    bsr.s docmp2
/* QL:         bra.s   qgood */
    bra.s qgood
/* QL: eval */
eval:
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         move.l  a2,-(sp) */
    move.l a2,-(sp)
/* QL:         move.b  d5,d0 */
    move.b d5,d0
/* QL:         jsr     ca_eval(pc)     read limit */
    jsr ca_eval(pc)
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         bgt.s   rts1 */
    bgt.s rts1
/* QL:         addq.l  #4,sp           give up if there's any problem in eval */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: docmp2 */
docmp2:
/* QL:         moveq   #2,d0           (string comparison type is <= or >=) */
    moveq #2,d0
/* QL: docmp */
docmp:
/* QL:         cmp.b   #t.fp,d5        which type are we doing? */
    cmp.b #(t.fp&255),d5
/* QL:         beq.s   comfp */
    beq.s comfp
/* QL:         blt.s   comstr */
    blt.s comstr
/* QL: * right... integer select, do it! */
/* QL:         addq.l  #2,bv_rip(a6)   discard integer */
    addq.l #2,bv_rip(a6)
/* QL:         cmp.w   0(a6,a1.l),d6   check against on variable value */
    cmp.w 0(a6,a1.l),d6
/* QL:         beq.s   rts1            equal is always good */
    beq.s rts1
/* QL:         slt     d3              set flag */
    slt d3
/* QL:         subq.b  #1,d1           were we looking for equality? */
    subq.b #1,d1
/* QL:         bcs.s   rts1            yes - then this is no good */
    bcs.s rts1
/* QL: eorb */
eorb:
/* QL:         eor.b   d3,d1           this establishes the sign bit as what we want */
    eor.b d3,d1
/* QL:         asr.b   #7,d1           so this is the answer! */
    asr.b #7,d1
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: comfp */
comfp:
/* QL:         move.b  d1,d3           save comparison type */
    move.b d1,d3
/* QL:         moveq   #6,d1 */
    moveq #6,d1
/* QL:         jsr     bv_chrix(pc)    gotta make sure of space */
    jsr bv_chrix(pc)
/* QL:         move.l  bv_rip(a6),a1   reload pointer */
    move.l bv_rip(a6),a1
/* QL:         addq.l  #6,bv_rip(a6)   discard comparand from bv_rip */
    addq.l #6,bv_rip(a6)
/* QL:         subq.l  #6,a1           make space for our comparison */
    subq.l #6,a1
/* QL:         move.l  a2,2(a6,a1.l)   copy mantissa */
    move.l a2,2(a6,a1.l)
/* QL:         move.w  d6,0(a6,a1.l)   copy exponent */
    move.w d6,0(a6,a1.l)
/* QL:         jsr     ri_cmp(pc)      calculate comparison (this is nice, saves d3) */
    jsr ri_cmp(pc)
/* QL:         neg.b   d3              check comparison type */
    neg.b d3
/* QL:         bne.s   frel            not zero means we want to test <= and >= */
    bne.s frel
/* QL:         tst.b   0(a6,a1.l)      msb exponent is 0 if == true, otherwise 8 */
    tst.b 0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: frel */
frel:
/* QL:         move.b  2(a6,a1.l),d1   get msb mantissa which will be $80, 0 or $40 */
    move.b 2(a6,a1.l),d1
/* QL:         bne.s   eorb            if not zero, we go to eor signs for answer */
    bne.s eorb
/* QL:         rts                     if zero, this is an exact =, which is fine */
    rts 
/* QL: comstr */
comstr:
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  0(a6,a1.l),d2 */
    move.w 0(a6,a1.l),d2
/* QL:         addq.l  #3,d2 */
    addq.l #3,d2
/* QL:         bclr    #0,d2 */
    bclr #0,d2
/* QL:         add.l   d2,bv_rip(a6)   discard string on RI stack */
    add.l d2,bv_rip(a6)
/* QL:         move.l  a2,a0 */
    move.l a2,a0
/* QL:         add.l   bv_vvbas(a6),a0 */
    add.l bv_vvbas(a6),a0
/* QL:         move.w  d6,d2 */
    move.w d6,d2
/* QL:         jsr     ut_csstr(pc) */
    jsr ut_csstr(pc)
/* QL:         beq.s   rts1            equal is always great */
    beq.s rts1
/* QL:         cmp.b   d0,d1           otherwise compare it to comparison type */
    cmp.b d0,d1
/* QL:         rts */
    rts 
/* QL:         end  */
