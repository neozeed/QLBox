/* Generated from original/M/ib/next.asm */
/* QL: * NEXT statement, etc */
/* QL:         xdef    ib_fname,ib_frnge,ib_gtlpl,ib_index,ib_loop,ib_next,ib_psend */
.globl ib_fname,ib_frnge,ib_gtlpl,ib_index,ib_loop,ib_next,ib_psend
/* QL:         xref    ib_cheos,ib_golin,ib_gost,ib_nxnon,ib_stnxi,ib_wtest */
/* QL:         xref    ri_add,ri_cmp,ri_dup,ri_sub */
/* QL:         xref    ca_eval */
/* QL:         xref    bv_chri */
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
/* QL:         include 'win1_m_inc_lpoff' */
/* QL: * offsets within loop index decription */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: lp.iexp ds.w    3       index (max 4 byte string, fp or integer) */
.equ lp.iexp,0
/* QL: lp.lnvar ; length of a simple variable */
.equ lp.lnvar,6
/* QL: lp.sl   ds.w    1       start line */
.equ lp.sl,6
/* QL: lp.el   ds.w    1       end line */
.equ lp.el,8
/* QL: lp.ss   ds.b    1       statement on start line */
.equ lp.ss,10
/* QL: lp.es   ds.b    1       statement on end line */
.equ lp.es,11
/* QL: lp.lnrep ; length of a rep description */
.equ lp.lnrep,12
/* QL: lp.eexp ds.w    3       endval (max 4 byte string, fp or integer) */
.equ lp.eexp,12
/* QL: lp.sexp ds.w    3       step (max 4 byte string, fp or integer) */
.equ lp.sexp,18
/* QL: lp.chpos ds.w   1       character position along line (word) */
.equ lp.chpos,24
/* QL: lp.lnfor ; length of a for description */
.equ lp.lnfor,26
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
/* QL:         section ib_next */
.section ib_next,"ax"
/* QL: * d6 - l - keeps name row safe, msb flags assignment made */
/* QL: * d4 -il - name row(i), arg for golin, gost(l) */
/* QL: * a4 -i o- program file */
/* QL: * a2 - l - loop description */
/* QL: isfp */
isfp:
/* QL:         jsr     bv_chri(pc)     check ri */
    jsr bv_chri(pc)
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         sub.w   #2*6,a1 */
    sub.w #(2*6),a1
/* QL:         move.l  lp.sexp+2(a6,a2.l),2(a6,a1.l) put step onto ari stack */
    move.l (lp.sexp+2)(a6,a2.l),2(a6,a1.l)
/* QL:         beq.s   finx            zero mantissa */
    beq.s finx
/* QL:         move.w  lp.sexp(a6,a2.l),0(a6,a1.l) step exponent */
    move.w lp.sexp(a6,a2.l),0(a6,a1.l)
/* QL:         move.w  lp.iexp(a6,a2.l),6(a6,a1.l) put index onto ari stack */
    move.w lp.iexp(a6,a2.l),6(a6,a1.l)
/* QL:         move.l  lp.iexp+2(a6,a2.l),6+2(a6,a1.l) */
    move.l (lp.iexp+2)(a6,a2.l),(6+2)(a6,a1.l)
/* QL:         jsr     ri_add(pc)      add step to index value */
    jsr ri_add(pc)
/* QL:         bne.s   finx */
    bne.s finx
/* QL:         jsr     ri_dup(pc)      copy result */
    jsr ri_dup(pc)
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  lp.eexp+2(a6,a2.l),2(a6,a1.l) put end value onto ari stack */
    move.l (lp.eexp+2)(a6,a2.l),2(a6,a1.l)
/* QL:         move.w  lp.eexp(a6,a2.l),0(a6,a1.l) */
    move.w lp.eexp(a6,a2.l),0(a6,a1.l)
/* QL:         jsr     ri_sub(pc) */
    jsr ri_sub(pc)
/* QL:         moveq   #13,d1          diff in exps (1e4) neccessary for equality */
    moveq #13,d1
/* QL:         add.w   0(a6,a1.l),d1   add the (index+step-endval) exponent */
    add.w 0(a6,a1.l),d1
/* QL:         cmp.w   lp.sexp(a6,a2.l),d1 compare it with the step exponent */
    cmp.w lp.sexp(a6,a2.l),d1
/* QL:         lea     lp.eexp-6(a2),a0 if we're near end value, make it exact */
    lea (lp.eexp-6)(a2),a0
/* QL:         ble.s   cont            this is so close, use exact endval */
    ble.s cont
/* QL:         move.l  a1,a0           the saved result is just above here */
    move.l a1,a0
/* QL:         tst.b   2(a6,a1.l)      look at top of mantissa */
    tst.b 2(a6,a1.l)
/* QL:         blt.s   neg_0           negative */
    blt.s neg_0
/* QL:         tst.b   lp.sexp+2(a6,a2.l) pos, what about top of step? */
    tst.b (lp.sexp+2)(a6,a2.l)
/* QL:         blt.s   cont            negative, continue stepping */
    blt.s cont
/* QL: finx */
finx:
/* QL:         bra.l   fin1            range exhausted */
    bra.w fin1
/* QL: neg_0 */
neg_0:
/* QL:         tst.b   lp.sexp+2(a6,a2.l) step sign? */
    tst.b (lp.sexp+2)(a6,a2.l)
/* QL:         blt.s   finx            end of range */
    blt.s finx
/* QL: cont */
cont:
/* QL:         move.w  6(a6,a0.l),lp.iexp(a6,a2.l) update the index with new value */
    move.w 6(a6,a0.l),lp.iexp(a6,a2.l)
/* QL:         move.l  6+2(a6,a0.l),lp.iexp+2(a6,a2.l) */
    move.l (6+2)(a6,a0.l),(lp.iexp+2)(a6,a2.l)
/* QL:         bra.s   assign */
    bra.s assign
/* QL: ib_next */
ib_next:
/* QL:         bsr.l   ib_gtlpl */
    bsr.w ib_gtlpl
/* QL:         beq.s   ib_loop */
    beq.s ib_loop
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * Set psuedo end for inline consrtucts */
/* QL: ib_psend */
ib_psend:
/* QL:         move.b  #127,bv_stmnt(a6) highly unlikely statement number */
    move.b #(127&255),bv_stmnt(a6)
/* QL:         move.w  bv_index(a6),d4 last inline index name spotted */
    move.w bv_index(a6),d4
/* QL:         bsr.l   gtind           get everything else from gtlpl */
    bsr.w gtind
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL: * Machinery for NEXT */
/* QL: ib_loop */
ib_loop:
/* QL:         moveq   #0,d6           clear msb of d6 as flag for no assignment yet */
    moveq #0,d6
/* QL:         move.w  d4,d6           save name row */
    move.w d4,d6
/* QL:         subq.b  #t.rep,d1       is this a REP loop? */
    subq.b #t.rep,d1
/* QL:         beq.s   simple_0        yes */
    beq.s simple_0
/* QL:         subq.b  #t.fp,d2        what type are we doing? */
    subq.b #t.fp,d2
/* QL:         bgt.s   isint */
    bgt.s isint
/* QL:         beq.l   isfp */
    beq.w isfp
/* QL:         move.b  lp.sexp+2(a6,a2.l),d0 */
    move.b (lp.sexp+2)(a6,a2.l),d0
/* QL:         beq.s   fin1            step zero, so finish */
    beq.s fin1
/* QL:         spl     d3 */
    spl d3
/* QL:         tst.b   lp.iexp+1(a6,a2.l) */
    tst.b (lp.iexp+1)(a6,a2.l)
/* QL:         beq.s   fin1            someone's made it a null, i'll stop here */
    beq.s fin1
/* QL:         move.b  lp.iexp+2(a6,a2.l),d1 */
    move.b (lp.iexp+2)(a6,a2.l),d1
/* QL:         add.b   d0,d1 */
    add.b d0,d1
/* QL:         bvs.s   fin1            went over top, forget it */
    bvs.s fin1
/* QL:         cmp.b   lp.eexp+2(a6,a2.l),d1 */
    cmp.b (lp.eexp+2)(a6,a2.l),d1
/* QL:         beq.s   usestr */
    beq.s usestr
/* QL:         sgt     d0 */
    sgt d0
/* QL:         eor.b   d0,d3 */
    eor.b d0,d3
/* QL:         beq.s   fin1 */
    beq.s fin1
/* QL: usestr */
usestr:
/* QL:         move.b  d1,lp.iexp+2(a6,a2.l) */
    move.b d1,(lp.iexp+2)(a6,a2.l)
/* QL:         bra.s   assign */
    bra.s assign
/* QL: useint */
useint:
/* QL:         move.w  d1,lp.iexp(a6,a2.l) */
    move.w d1,lp.iexp(a6,a2.l)
/* QL: assign */
assign:
/* QL:         bset    #31,d6          set flag for assignment made */
    bset #31,d6
/* QL: simple_0 */
simple_0:
/* QL:         sf      d3 */
    sf d3
/* QL:         bra.s   simple */
    bra.s simple
/* QL: isint */
isint:
/* QL:         move.w  lp.sexp(a6,a2.l),d0 */
    move.w lp.sexp(a6,a2.l),d0
/* QL:         beq.s   fin1            step zero, so we're done */
    beq.s fin1
/* QL:         spl     d3              remember it's sign */
    spl d3
/* QL:         move.w  lp.iexp(a6,a2.l),d1 */
    move.w lp.iexp(a6,a2.l),d1
/* QL:         add.w   d0,d1 */
    add.w d0,d1
/* QL:         bvs.s   fin1            went over the top, so must be finished! */
    bvs.s fin1
/* QL:         cmp.w   lp.eexp(a6,a2.l),d1 */
    cmp.w lp.eexp(a6,a2.l),d1
/* QL:         beq.s   useint          exact match, use it */
    beq.s useint
/* QL:         sgt     d0 */
    sgt d0
/* QL:         eor.b   d0,d3           ok, so was inc +ve and we're gt, or the reverse */
    eor.b d0,d3
/* QL:         bne.s   useint          yes - straight end of range */
    bne.s useint
/* QL: fin1 */
fin1:
/* QL:         moveq   #1,d3 */
    moveq #1,d3
/* QL: simple */
simple:
/* QL:         bsr.s   ch_lplin */
    bsr.s ch_lplin
/* QL:         bne.s   exit */
    bne.s exit
/* QL:         tst.b   bv_inlin(a6)    in-line for? */
    tst.b bv_inlin(a6)
/* QL:         ble.s   offinl          no, turn it off */
    ble.s offinl
/* QL:         cmp.b   #127,bv_stmnt(a6) real end or pseudo end? */
    cmp.b #(127&255),bv_stmnt(a6)
/* QL:         bne.s   leaveinl */
    bne.s leaveinl
/* QL: offinl */
offinl:
/* QL:         sf      bv_inlin(a6)    turn inline flag off */
    sf bv_inlin(a6)
/* QL: leaveinl */
leaveinl:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: exit */
exit:
/* QL:         move.l  d6,d4           has a var. been assigned to? */
    move.l d6,d4
/* QL:         bpl.s   back            no, go back */
    bpl.s back
/* QL:         tst.w   bv_wvnum(a6)    are there any when vars. to check? */
    tst.w bv_wvnum(a6)
/* QL:         beq.s   back            no */
    beq.s back
/* QL:         jmp     ib_wtest(pc)    if when var. cond. satisfied, act */
    jmp ib_wtest(pc)
/* QL: * Check loop line is all it is supposed to be */
/* QL: * a2 -i  - loop index entry */
/* QL: * d3 -i  - 0 if just check wanted, non-0 if next frange required */
/* QL: * d6 -i o- name row */
/* QL: ch_lplin */
ch_lplin:
/* QL:         move.b  bv_stmnt(a6),-(sp) save statement */
    move.b bv_stmnt(a6),-(sp)
/* QL:         move.l  bv_linum(a6),-(sp) save line num, length */
    move.l bv_linum(a6),-(sp)
/* QL:         move.l  a4,-(sp) */
    move.l a4,-(sp)
/* QL:         move.w  lp.sl(a6,a2.l),d4 start line of loop */
    move.w lp.sl(a6,a2.l),d4
/* QL:         jsr     ib_golin(pc)    set prog file pointer to FOR */
    jsr ib_golin(pc)
/* QL:         bne.s   rest_nf */
    bne.s rest_nf
/* QL:         jsr     ib_stnxi(pc)    start the next line off not changing i/l */
    jsr ib_stnxi(pc)
/* QL:         move.b  lp.ss(a6,a2.l),d4 read start statement */
    move.b lp.ss(a6,a2.l),d4
/* QL:         jsr     ib_gost(pc)     go to statement */
    jsr ib_gost(pc)
/* QL:         jsr     ib_nxnon(pc)    look at first thing on it */
    jsr ib_nxnon(pc)
/* QL:         sub.w   #w.for,d1       is it a FOR */
    sub.w #w.for,d1
/* QL:         assert  2,w.rep-w.for */
/* original assertion: 2,w.rep-w.for */
/* QL:         roxr.w  #2,d1           or a REP? */
    roxr.w #2,d1
/* QL:         bne.s   rest_nf */
    bne.s rest_nf
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL:         move.l  a4,a5 */
    move.l a4,a5
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   2(a6,a4.l),d6   does the name match? */
    cmp.w 2(a6,a4.l),d6
/* QL:         bne.s   rest_nf */
    bne.s rest_nf
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   do_range */
    bne.s do_range
/* QL: end_ch */
end_ch:
/* QL:         add.w   #4+4+2,sp */
    add.w #((4+4)+2),sp
/* QL:         rts */
    rts 
/* QL: rest_nf */
rest_nf:
/* QL:         moveq   #err.nf,d0 */
    moveq #err.nf,d0
/* QL:         bra.s   rest_ch */
    bra.s rest_ch
/* QL: do_range */
do_range:
/* QL:         move.l  a5,a4 */
    move.l a5,a4
/* QL:         add.w   lp.chpos(a6,a2.l),a4 add previous char pos to pf pointer */
    add.w lp.chpos(a6,a2.l),a4
/* QL:         move.w  d6,d4           need this for forange */
    move.w d6,d4
/* QL:         bsr.s   ib_frnge */
    bsr.s ib_frnge
/* QL:         beq.s   end_ch          good range */
    beq.s end_ch
/* QL:         blt.s   rest_ch         error in range line */
    blt.s rest_ch
/* QL:         moveq   #0,d0           exhausted all ranges */
    moveq #0,d0
/* QL: rest_ch */
rest_ch:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         move.l  (sp)+,bv_linum(a6) restore line number, length */
    move.l (sp)+,bv_linum(a6)
/* QL:         move.b  (sp)+,bv_stmnt(a6) restore which statement */
    move.b (sp)+,bv_stmnt(a6)
/* QL: back */
back:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * a2 -i  - beginning of index description */
/* QL: * d0 -  o- -ve error in exp */
/* QL: *            0 good range found */
/* QL: *           +1 for line exhausted */
/* QL: * N.B. Unlike previously, this doesn't zap the value in a variable when it */
/* QL: * finds a range that is already exhausted. It acheives this by putting the */
/* QL: * start value into the step slot first, then only copying it across to its */
/* QL: * proper place when it has established that the range is not exhausted. */
/* QL: ib_frnge */
ib_frnge:
/* QL:         move.l  a4,-(sp)        save current pf position */
    move.l a4,-(sp)
/* QL:         move.w  0(a6,a4.l),d1 */
    move.w 0(a6,a4.l),d1
/* QL:         jsr     ib_cheos(pc)    line feed or colon next? */
    jsr ib_cheos(pc)
/* QL:         bne.s   chk_rng */
    bne.s chk_rng
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         bra.s   pop_4 */
    bra.s pop_4
/* QL: chk_rng */
chk_rng:
/* QL:         cmp.w   #w.equal,d1 */
    cmp.w #w.equal,d1
/* QL:         beq.s   read_rng */
    beq.s read_rng
/* QL:         cmp.w   #w.symcom,d1 */
    cmp.w #w.symcom,d1
/* QL:         bne.s   pop4_or */
    bne.s pop4_or
/* QL: read_rng */
read_rng:
/* QL:         move.w  d4,d6           keep name row safe */
    move.w d4,d6
/* QL:         bsr.l   ib_index        pick up info first time in */
    bsr.w ib_index
/* QL:         bsr.l   getexpr         get the first expression */
    bsr.w getexpr
/* QL:         cmp.w   #w.keyto,0(a6,a4.l) is it a TO ? */
    cmp.w #w.keyto,0(a6,a4.l)
/* QL:         beq.s   range           yes, otherwise single value, set defaults */
    beq.s range
/* QL:         move.w  d0,lp.eexp(a6,a2.l) len, exp or val of the index value */
    move.w d0,lp.eexp(a6,a2.l)
/* QL:         move.l  d1,lp.eexp+2(a6,a2.l) mantissa/chars of the index value */
    move.l d1,(lp.eexp+2)(a6,a2.l)
/* QL:         clr.w   lp.sexp(a6,a2.l) use a step of zero */
    clr.w lp.sexp(a6,a2.l)
/* QL:         clr.l   lp.sexp+2(a6,a2.l) */
    clr.l (lp.sexp+2)(a6,a2.l)
/* QL:         move.l  (sp)+,d2 */
    move.l (sp)+,d2
/* QL:         move.w  d0,lp.iexp(a6,a2.l) copy index value exponent */
    move.w d0,lp.iexp(a6,a2.l)
/* QL:         move.l  d1,lp.iexp+2(a6,a2.l) and mantissa */
    move.l d1,(lp.iexp+2)(a6,a2.l)
/* QL:         sub.l   a4,d2 */
    sub.l a4,d2
/* QL:         sub.w   d2,lp.chpos(a6,a2.l) initial character position */
    sub.w d2,lp.chpos(a6,a2.l)
/* QL:         bra.l   done */
    bra.w done
/* QL: range */
range:
/* QL:         move.w  d0,lp.sexp(a6,a2.l) len, exp or val of the index value */
    move.w d0,lp.sexp(a6,a2.l)
/* QL:         move.l  d1,lp.sexp+2(a6,a2.l) mantissa/chars of the index value */
    move.l d1,(lp.sexp+2)(a6,a2.l)
/* QL:         addq.b  #t.fp,d2        what was the type? */
    addq.b #t.fp,d2
/* QL:         bcc.s   do_to           not string, so we're happy */
    bcc.s do_to
/* QL:         subq.w  #1,d0           is it a single char? */
    subq.w #1,d0
/* QL:         beq.s   do_to           yes - we understand how to do that */
    beq.s do_to
/* QL: pop4_or */
pop4_or:
/* QL:         moveq   #err.or,d0 */
    moveq #err.or,d0
/* QL: pop_4 */
pop_4:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: do_to */
do_to:
/* QL:         bsr.l   getexpr         get the to value */
    bsr.w getexpr
/* QL:         move.w  d0,lp.eexp(a6,a2.l) and copy it into the descriptor */
    move.w d0,lp.eexp(a6,a2.l)
/* QL:         move.l  d1,lp.eexp+2(a6,a2.l) */
    move.l d1,(lp.eexp+2)(a6,a2.l)
/* QL:         addq.b  #t.fp,d2        once again, was it a string? */
    addq.b #t.fp,d2
/* QL:         bcc.s   dostep */
    bcc.s dostep
/* QL:         subq.w  #1,d0 */
    subq.w #1,d0
/* QL:         bne.s   pop4_or */
    bne.s pop4_or
/* QL: dostep */
dostep:
/* QL:         moveq   #1,d1           constructing default step of one */
    moveq #1,d1
/* QL:         moveq   #1,d0           step int 1 or strlen */
    moveq #1,d0
/* QL:         subq.b  #t.fp,d2 */
    subq.b #t.fp,d2
/* QL:         bgt.s   gostep */
    bgt.s gostep
/* QL:         blt.s   dorot */
    blt.s dorot
/* QL:         move.w  #$801,d0        fp exp */
    move.w #0x801,d0
/* QL:         moveq   #$40,d1         fp mant (soon) */
    moveq #0x40,d1
/* QL: dorot */
dorot:
/* QL:         ror.l   #8,d1           position chr$(1) or fp mant $40000000 */
    ror.l #8,d1
/* QL: gostep */
gostep:
/* QL:         cmp.w   #w.step,0(a6,a4.l) is next token step ? */
    cmp.w #w.step,0(a6,a4.l)
/* QL:         bne.s   setstep         nope, use what we just constructed */
    bne.s setstep
/* QL:         addq.b  #t.fp,d2 */
    addq.b #t.fp,d2
/* QL:         bsr.l   getexpr */
    bsr.w getexpr
/* QL:         tst.b   d2              last time, is is a string? */
    tst.b d2
/* QL:         bpl.s   setstep */
    bpl.s setstep
/* QL:         cmp.w   #1,d0 */
    cmp.w #1,d0
/* QL:         bne.s   pop4_or */
    bne.s pop4_or
/* QL: setstep */
setstep:
/* QL:         move.l  (sp)+,d3        take off previous pf pos */
    move.l (sp)+,d3
/* QL:         sub.l   a4,d3           current pf position */
    sub.l a4,d3
/* QL:         sub.w   d3,lp.chpos(a6,a2.l) and add the difference to prev ch pos */
    sub.w d3,lp.chpos(a6,a2.l)
/* QL:         tst.b   d2              which type are we doing? */
    tst.b d2
/* QL:         bgt.s   strtint */
    bgt.s strtint
/* QL:         beq.s   strtfp */
    beq.s strtfp
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         rol.l   #8,d2 */
    rol.l #8,d2
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         beq.s   swap6           step zero is good */
    beq.s swap6
/* QL:         spl     d3 */
    spl d3
/* QL:         move.b  lp.sexp+2(a6,a2.l),d2 */
    move.b (lp.sexp+2)(a6,a2.l),d2
/* QL:         cmp.b   lp.eexp+2(a6,a2.l),d2 */
    cmp.b (lp.eexp+2)(a6,a2.l),d2
/* QL: fpset */
fpset:
/* QL:         bne.s   strint */
    bne.s strint
/* QL: swap6 */
swap6:
/* QL:         move.l  lp.sexp+2(a6,a2.l),lp.iexp+2(a6,a2.l) */
    move.l (lp.sexp+2)(a6,a2.l),(lp.iexp+2)(a6,a2.l)
/* QL:         move.l  d1,lp.sexp+2(a6,a2.l) */
    move.l d1,(lp.sexp+2)(a6,a2.l)
/* QL: swap2 */
swap2:
/* QL:         move.w  lp.sexp(a6,a2.l),lp.iexp(a6,a2.l) */
    move.w lp.sexp(a6,a2.l),lp.iexp(a6,a2.l)
/* QL:         move.w  d0,lp.sexp(a6,a2.l) */
    move.w d0,lp.sexp(a6,a2.l)
/* QL: done */
done:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: strtint */
strtint:
/* QL:         tst.w   d0 */
    tst.w d0
/* QL:         beq.s   swap2            step zero is good */
    beq.s swap2
/* QL:         spl     d3 */
    spl d3
/* QL:         move.w  lp.sexp(a6,a2.l),d2 */
    move.w lp.sexp(a6,a2.l),d2
/* QL:         cmp.w   lp.eexp(a6,a2.l),d2 */
    cmp.w lp.eexp(a6,a2.l),d2
/* QL:         beq.s   swap2 */
    beq.s swap2
/* QL: strint */
strint:
/* QL:         slt     d2 */
    slt d2
/* QL:         eor.b   d2,d3 */
    eor.b d2,d3
/* QL:         bpl.s   swap6 */
    bpl.s swap6
/* QL: next */
next:
/* QL:         bra.l   ib_frnge */
    bra.w ib_frnge
/* QL: strtfp */
strtfp:
/* QL:         tst.l   d1 */
    tst.l d1
/* QL:         beq.s   swap6           step zero is good */
    beq.s swap6
/* QL:         move.l  d1,-(sp)        save stuff for a moment */
    move.l d1,-(sp)
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         jsr     bv_chri(pc)     make sure we've got some space */
    jsr bv_chri(pc)
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         moveq   #12,d0 */
    moveq #12,d0
/* QL:         add.l   d0,a2 */
    add.l d0,a2
/* QL: pushfp */
pushfp:
/* QL:         subq.l  #4,a2           put initial, then end, value on stack */
    subq.l #4,a2
/* QL:         subq.l  #4,a1 */
    subq.l #4,a1
/* QL:         move.l  lp.eexp(a6,a2.l),0(a6,a1.l) */
    move.l lp.eexp(a6,a2.l),0(a6,a1.l)
/* QL:         subq.w  #4,d0 */
    subq.w #4,d0
/* QL:         bne.s   pushfp */
    bne.s pushfp
/* QL:         jsr     ri_cmp(pc)      compare them */
    jsr ri_cmp(pc)
/* QL:         move.w  (sp)+,d0 */
    move.w (sp)+,d0
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         spl     d3 */
    spl d3
/* QL:         move.b  2(a6,a1.l),d2 */
    move.b 2(a6,a1.l),d2
/* QL:         bra.s   fpset */
    bra.s fpset
/* QL: * Evaluate one of x, y or z from "for var = x to y step z" */
/* QL: * d2 = var type, d6 = name row, a4 = program  */
/* QL: pop_8 */
pop_8:
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL:         rts */
    rts 
/* QL: getexpr */
getexpr:
/* QL:         addq.l  #2,a4           skip the token we just matched */
    addq.l #2,a4
/* QL:         move.l  a4,a0           beg of expression */
    move.l a4,a0
/* QL:         move.b  d2,d0 */
    move.b d2,d0
/* QL:         jsr     ca_eval(pc)     evaluate it */
    jsr ca_eval(pc)
/* QL:         move.l  a0,a4           points to 1st non-expression token */
    move.l a0,a4
/* QL:         ble.s   pop_8 */
    ble.s pop_8
/* QL:         bsr.s   ib_indx1        get beg of loop description */
    bsr.s ib_indx1
/* QL:         move.w  0(a6,a1.l),d0   len, exp or val of the index value */
    move.w 0(a6,a1.l),d0
/* QL:         bsr.s   formoff         make up a nice adjuster for ri stack */
    bsr.s formoff
/* QL:         add.l   d1,bv_rip(a6) */
    add.l d1,bv_rip(a6)
/* QL:         move.l  2(a6,a1.l),d1   mantissa/chars of the index value */
    move.l 2(a6,a1.l),d1
/* QL:         rts */
    rts 
/* QL: formoff */
formoff:
/* QL:         moveq   #2,d1 */
    moveq #2,d1
/* QL:         subq.b  #t.fp,d2        what is it's type? */
    subq.b #t.fp,d2
/* QL:         bgt.s   rts1            integer, we're ready */
    bgt.s rts1
/* QL:         beq.s   form4p          fp, a bit more to drop */
    beq.s form4p
/* QL:         move.w  d0,d1           copy the length */
    move.w d0,d1
/* QL:         subq.l  #4,d1           is it a bit too long? */
    subq.l #4,d1
/* QL:         bcs.s   formrnd         no, so go round it */
    bcs.s formrnd
/* QL:         sub.w   d1,d0           truncate to max. four */
    sub.w d1,d0
/* QL: formrnd */
formrnd:
/* QL:         addq.l  #3,d1           incorporate length and one for rounding */
    addq.l #3,d1
/* QL:         bclr    #0,d1           round to even */
    bclr #0,d1
/* QL: form4p */
form4p:
/* QL:         addq.l  #4,d1 */
    addq.l #4,d1
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- found(0) or not (o) */
/* QL: * d1 -  o- 1st byte of nt description */
/* QL: * d2 -  o- 2nd byte of nt description */
/* QL: * d4 -  o- name row */
/* QL: * a2 -  o- pointer to loop description */
/* QL: * a4 -i o- program file */
/* QL: ib_gtlpl */
ib_gtlpl:
/* QL:         jsr     ib_nxnon(pc)    get non-space */
    jsr ib_nxnon(pc)
/* QL:         move.w  2(a6,a4.l),d4   read name */
    move.w 2(a6,a4.l),d4
/* QL:         addq.l  #4,a4 */
    addq.l #4,a4
/* QL: gtind */
gtind:
/* QL:         bsr.s   ib_index        get offset on vv of loop description */
    bsr.s ib_index
/* QL:         moveq   #t.for,d0 */
    moveq #t.for,d0
/* QL:         sub.b   d1,d0           is it a FOR */
    sub.b d1,d0
/* QL:         assert  1,t.for-t.rep */
/* original assertion: 1,t.for-t.rep */
/* QL:         lsr.b   #1,d0           or a REP? */
    lsr.b #1,d0
/* QL:         beq.s   rts2 */
    beq.s rts2
/* QL:         moveq   #err.nf,d0 */
    moveq #err.nf,d0
/* QL: rts2 */
rts2:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- vv offset from vvbas */
/* QL: * d1 -  o- 1st byte of name description (name type) */
/* QL: * d2 -  o- 4 lsbs of 2nd byte (variable type) */
/* QL: * d4 -ip - name row */
/* QL: * a2 -  o- beg of vv desc */
/* QL: ib_indx1 */
ib_indx1:
/* QL:         move.w  d6,d4           put_str in eval uses d4 in strings */
    move.w d6,d4
/* QL: ib_index */
ib_index:
/* QL:         bsr.s   ib_fname */
    bsr.s ib_fname
/* QL:         move.b  0(a6,a2.l),d1   name type */
    move.b 0(a6,a2.l),d1
/* QL:         moveq   #15,d2 */
    moveq #15,d2
/* QL:         and.b   1(a6,a2.l),d2   variable type */
    and.b 1(a6,a2.l),d2
/* QL:         move.l  4(a6,a2.l),d0   get value offset */
    move.l 4(a6,a2.l),d0
/* QL:         move.l  bv_vvbas(a6),a2 base of var tab */
    move.l bv_vvbas(a6),a2
/* QL:         add.l   d0,a2           move to beginning of index description */
    add.l d0,a2
/* QL:         rts */
    rts 
/* QL: * d0 -  o- name offset */
/* QL: * d4 -ip - name row */
/* QL: * a2 -  o- beg of name table data */
/* QL: ib_fname */
ib_fname:
/* QL:         moveq   #0,d0           (being cautious, don't expect msw 0. lwr) */
    moveq #0,d0
/* QL:         move.w  d4,d0 */
    move.w d4,d0
/* QL:         lsl.l   #3,d0           offset of name entry */
    lsl.l #3,d0
/* QL:         move.l  bv_ntbas(a6),a2 */
    move.l bv_ntbas(a6),a2
/* QL:         add.l   d0,a2           point at name entry */
    add.l d0,a2
/* QL:         rts */
    rts 
/* QL:         end */
