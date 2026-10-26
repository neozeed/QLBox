/* Generated from original/M/ca/stind.asm */
/* QL: * String var or exp index on rhs */
/* QL:         xdef    ca_ssind,ca_stind */
.globl ca_ssind,ca_stind
/* QL:         xref    ca_cnvrt,ca_etos,ca_putss,ca_range */
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
/* QL:         section ca_stind */
.section ca_stind,"ax"
/* QL: * d0 -  o- error code */
/* QL: * a0 -i o- expression pointer */
/* QL: * a1 -i o- ri stack pointer */
/* QL: * a5 -i o- name table entry top */
/* QL: * d1-d3/d5-d6/a3-a4 destroyed */
/* QL: ca_stind */
ca_stind:
/* QL:         cmp.b   #t.str,-7(a6,a5.l) is it really a string already? */
    cmp.b #(t.str&255),(-7)(a6,a5.l)
/* QL:         beq.s   isstr */
    beq.s isstr
/* QL:         jsr     ca_etos(pc) */
    jsr ca_etos(pc)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         moveq   #t.str,d0 */
    moveq #t.str,d0
/* QL:         jsr     ca_cnvrt(pc)    ho hum... we'll even convert numbers! */
    jsr ca_cnvrt(pc)
/* QL: *       bne.s   rts0            there's nothing that won't convert to string! */
/* QL: isstr */
isstr:
/* QL:         bsr.s   ca_ssind        get the indices */
    bsr.s ca_ssind
/* QL:         bne.s   rts0            couldn't get indices */
    bne.s rts0
/* QL:         move.l  a1,a4           maybe it's internal already */
    move.l a1,a4
/* QL:         move.b  -8(a6,a5.l),d3 */
    move.b (-8)(a6,a5.l),d3
/* QL:         subq.b  #t.intern,d3 */
    subq.b #t.intern,d3
/* QL:         beq.s   ptrset          yep - all set for internal */
    beq.s ptrset
/* QL:         move.l  -4(a6,a5.l),d2  string variable offset */
    move.l (-4)(a6,a5.l),d2
/* QL:         blt.s   err_xp          ouch - unset variable */
    blt.s err_xp
/* QL:         move.l  bv_vvbas(a6),a4 */
    move.l bv_vvbas(a6),a4
/* QL:         add.l   d2,a4 */
    add.l d2,a4
/* QL: ptrset */
ptrset:
/* QL:         move.w  0(a6,a4.l),d6   get length */
    move.w 0(a6,a4.l),d6
/* QL:         subq.w  #1,d5 */
    subq.w #1,d5
/* QL:         bcs.s   ready           just want the length, i.e. x$(0) */
    bcs.s ready
/* QL:         cmp.w   d1,d6 */
    cmp.w d1,d6
/* QL:         bcc.s   lenset */
    bcc.s lenset
/* QL:         move.w  d6,d1 */
    move.w d6,d1
/* QL: lenset */
lenset:
/* QL:         sub.w   d5,d1           get length of substring */
    sub.w d5,d1
/* QL:         bcs.s   err_or */
    bcs.s err_or
/* QL:         lea     2(a4,d5.w),a4   pointer to start */
    lea 2(a4,d5.w),a4
/* QL: ready */
ready:
/* QL:         moveq   #t.intern,d2 */
    moveq #t.intern,d2
/* QL:         move.b  d2,-8(a6,a5.l)  now definately internal */
    move.b d2,(-8)(a6,a5.l)
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   riset           variable is ready */
    bne.s riset
/* QL:         lea     2(a1,d6.w),a1 */
    lea 2(a1,d6.w),a1
/* QL:         assert  1,t.intern */
/* original assertion: 1,t.intern */
/* QL:         and.b   d6,d2 */
    and.b d6,d2
/* QL:         add.w   d2,a1           round up */
    add.w d2,a1
/* QL:         bsr.s   putrip          update ri pointer to drop old stack copy now */
    bsr.s putrip
/* QL: riset */
riset:
/* QL:         addq.w  #1,d5           were we doing length only */
    addq.w #1,d5
/* QL:         bcc.l   ca_putss        no - go put substring on stack */
    bcc.w ca_putss
/* QL: * N.B. putss never needs any space if the string was already internal, and its */
/* QL: * move is non-destructive, so it'll always work ok. */
/* QL: * Note: we evaluated a zero index and removed it, so ri must have space for int */
/* QL:         addq.b  #t.int-t.str,-7(a6,a5.l) now it becomes an integer! */
    addq.b #(t.int-t.str),(-7)(a6,a5.l)
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d6,0(a6,a1.l) */
    move.w d6,0(a6,a1.l)
/* QL: putrip */
putrip:
/* QL:         move.l  a1,bv_rip(a6) */
    move.l a1,bv_rip(a6)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: err_or */
err_or:
/* QL:         moveq   #err.or,d0 */
    moveq #err.or,d0
/* QL:         rts */
    rts 
/* QL: err_xp */
err_xp:
/* QL:         moveq   #err.xp,d0 */
    moveq #err.xp,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- as d6, except default is still left as -1 */
/* QL: * d5 -  o- lower index (1..32767 or 0) (msw preserved) */
/* QL: * d6 -  o- upper index found (no check, except d5=0->d6=0) (msw preserved) */
/* QL: * a0 -i o- expression pointer */
/* QL: * a1 -i o- ri pointer */
/* QL: * d2-d3/a3-a4 destroyed */
/* QL: * Enhanced to accept "a$='x':a$=a$(2to 1)", i.e. null slice at end. */
/* QL: * Also now sensibly accepts a$(to ...) as defaulting to a$(1to ...). */
/* QL: * For the moment, we only baulk at a$(32768to{ 32767})! */
/* QL: ca_ssind */
ca_ssind:
/* QL:         subq.l  #2,a0           we like to start early... */
    subq.l #2,a0
/* QL:         jsr     ca_range(pc)    go get subscript range */
    jsr ca_range(pc)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         move.w  d1,d6 */
    move.w d1,d6
/* QL:         bpl.s   topok */
    bpl.s topok
/* QL:         lsr.w   #1,d6           change defaulted end (-1) to max (32767) */
    lsr.w #1,d6
/* QL: topok */
topok:
/* QL:         cmp.w   d5,d6 */
    cmp.w d5,d6
/* QL:         beq.s   rangeok         allows through special cases of (0) or (0to 0) */
    beq.s rangeok
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         beq.s   err_or          if zero gets here, it's no good, mixed len/char */
    beq.s err_or
/* QL:         bgt.s   rangeok         start > 0 is good */
    bgt.s rangeok
/* QL:         addq.w  #2,d5           if defalted start (-1), change it to 1 */
    addq.w #2,d5
/* QL: rangeok */
rangeok:
/* QL:         cmp.w   #w.cpar,0(a6,a0.l) we rather hope this is a close parenthesis */
    cmp.w #w.cpar,0(a6,a0.l)
/* QL:         bne.s   err_xp */
    bne.s err_xp
/* QL:         addq.l  #2,a0           we can move over close bracket now */
    addq.l #2,a0
/* QL:         rts */
    rts 
/* QL:         end */
