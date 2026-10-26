/* Generated from original/M/ib/call.asm */
/* QL: * Call and return from basic PROC/FN/GOSUB */
/* QL:         xdef    ib_bproc,ib_call,ib_cheos,ib_ret,ib_unret */
.globl ib_bproc,ib_call,ib_cheos,ib_ret,ib_unret
/* QL:         xref    bv_chrt,bv_upswp,bv_vtype */
/* QL:         xref    ca_carg,ca_eval,ca_garg,ca_newnt,ca_undo */
/* QL:         xref    ib_golin,ib_gost,ib_mkdim,ib_nxnam,ib_nxnon,ib_nxst */
/* QL:         xref    ib_s2non,ib_s4non,ib_stbas,ib_stimm,ib_stnxl */
/* QL:         xref    ut_err */
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
/* QL: * Call types */
/* QL: *x.gsb  equ     0       GOSUB */
/* QL: x.bpr   equ     1       PROCedure  */
.equ x.bpr,1
/* QL: x.bfn   equ     2       function */
.equ x.bfn,2
/* QL: x.bf0   equ     3       function (no arguments) */
.equ x.bf0,3
/* QL:         section ib_call */
.section ib_call,"ax"
/* QL: * In the case of a FN, 8(sp) holds the position in the expression wrt tkbas */
/* QL: * N.B. (lwr) This has been altered to continuously keep the NT pointers in the */
/* QL: * RT stack as offsets relative to nt_bas. The code could probably be improved! */
/* QL: ib_bproc */
ib_bproc:
/* QL:         moveq   #x.bpr,d5 */
    moveq #x.bpr,d5
/* QL: * d4 -i  - line number of GOSUB or name row PROC/FN */
/* QL: * d5 -i  - call type as above */
/* QL: * a2 -i  - nt entry for PROC, FN */
/* QL: * d0-d6/a0-a5 destroyed */
/* QL: ib_call */
ib_call:
/* QL:         jsr     bv_chrt(pc)     check enough room on the return table */
    jsr bv_chrt(pc)
/* QL:         moveq   #rt.lentl,d1    set space for PROC/FN */
    moveq #rt.lentl,d1
/* QL:         tst.b   d5 */
    tst.b d5
/* QL:         bne.s   lenset */
    bne.s lenset
/* QL:         moveq   #rt.lentl-rt.lenpr,d1 GOSUB requires less */
    moveq #(rt.lentl-rt.lenpr),d1
/* QL: lenset */
lenset:
/* QL:         add.l   d1,bv_rtp(a6)   move up return table */
    add.l d1,bv_rtp(a6)
/* QL:         move.l  bv_rtp(a6),a1   top of return table */
    move.l bv_rtp(a6),a1
/* QL:         move.b  bv_stmnt(a6),-rt.rsstm(a6,a1.l) statement to go back to */
    move.b bv_stmnt(a6),(-rt.rsstm)(a6,a1.l)
/* QL:         move.w  bv_linum(a6),-rt.rslno(a6,a1.l) linenumber to go back to */
    move.w bv_linum(a6),(-rt.rslno)(a6,a1.l)
/* QL:         assert  bv_inlin,bv_sing-1,bv_index-2 */
/* original assertion: bv_inlin,bv_sing-1,bv_index-2 */
/* QL:         move.l  bv_inlin(a6),-rt.rssta(a6,a1.l) inline, single flags,index var */
    move.l bv_inlin(a6),(-rt.rssta)(a6,a1.l)
/* QL:         move.b  d5,-rt.rsrtt(a6,a1.l) type of routine */
    move.b d5,(-rt.rsrtt)(a6,a1.l)
/* QL:         beq.s   rts0            finished for GOSUB, go back to that code */
    beq.s rts0
/* QL:         sf      bv_inlin(a6)    not inline now (hmm... fudge kills fudge. lwr) */
    sf bv_inlin(a6)
/* QL:         move.l  d4,d3           save name row */
    move.l d4,d3
/* QL:         bsr.s   set_bltl        set base and top of locals */
    bsr.s set_bltl
/* QL:         move.l  a5,-rt.rsba(a6,a1.l) set base of args */
    move.l a5,(-rt.rsba)(a6,a1.l)
/* QL:         move.b  1(a6,a2.l),-rt.rsfnt(a6,a1.l) function type */
    move.b 1(a6,a2.l),(-rt.rsfnt)(a6,a1.l)
/* QL:         sf      -rt.rsswp(a6,a1.l) set not swapped */
    sf (-rt.rsswp)(a6,a1.l)
/* QL:         move.w  4(a6,a2.l),-rt.rsdfl(a6,a1.l) line number of def line */
    move.w 4(a6,a2.l),(-rt.rsdfl)(a6,a1.l)
/* QL:         ble.l   err_nf1         was a single liner (???) */
    ble.w err_nf1
/* QL:         cmp.b   #x.bf0,d5       this might be a FN with no args */
    cmp.b #(x.bf0&255),d5
/* QL:         beq.s   no_arg */
    beq.s no_arg
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         jsr     ca_garg(pc)     get all the actual arguments */
    jsr ca_garg(pc)
/* QL:         move.l  bv_rtp(a6),a1 */
    move.l bv_rtp(a6),a1
/* QL:         bsr.s   set_bltl        base and top of locals */
    bsr.s set_bltl
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.s   clr_err */
    bne.s clr_err
/* QL:         cmp.b   #x.bfn,d5 */
    cmp.b #(x.bfn&255),d5
/* QL:         beq.s   ch_cbr */
    beq.s ch_cbr
/* QL:         bsr.l   ib_cheos        PROCedure - check end of statement next */
    bsr.w ib_cheos
/* QL:         beq.s   set_ok */
    beq.s set_ok
/* QL: clr_bp */
clr_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: clr_err */
clr_err:
/* QL:         moveq   #rt.lentl,d1 */
    moveq #rt.lentl,d1
/* QL:         sub.l   d1,bv_rtp(a6)   take this call off the return stack */
    sub.l d1,bv_rtp(a6)
/* QL:         bra.l   clr_arg         clear any args found so far */
    bra.w clr_arg
/* QL: set_bltl */
set_bltl:
/* QL:         move.l  bv_ntp(a6),a5 */
    move.l bv_ntp(a6),a5
/* QL:         sub.l   bv_ntbas(a6),a5 */
    sub.l bv_ntbas(a6),a5
/* QL:         move.l  a5,-rt.rstl(a6,a1.l) set top of locals */
    move.l a5,(-rt.rstl)(a6,a1.l)
/* QL:         move.l  a5,-rt.rsbl(a6,a1.l) set base of locals */
    move.l a5,(-rt.rsbl)(a6,a1.l)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: ch_cbr */
ch_cbr:
/* QL:         cmp.w   #w.cpar,d1      function - should be a close parenthesis here */
    cmp.w #w.cpar,d1
/* QL:         bne.s   clr_bp */
    bne.s clr_bp
/* QL:         addq.l  #2,a0           skip it */
    addq.l #2,a0
/* QL:         move.l  a0,d1 */
    move.l a0,d1
/* QL:         sub.l   bv_bfp+4(a6),d1 get wrt just above the buffer */
    sub.l (bv_bfp+4)(a6),d1
/* QL:         move.l  d1,8(sp)        update pos for eval to continue from */
    move.l d1,8(sp)
/* QL: set_ok */
set_ok:
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL: no_arg */
no_arg:
/* QL:         st      -rt.rsswp(a6,a1.l) set swapped flag */
    st (-rt.rsswp)(a6,a1.l)
/* QL:         ; (if error following this then it's practically irrecoverable anyway) */
/* QL:         move.l  -rt.rsba(a6,a1.l),a5 restore bottom of args */
    move.l (-rt.rsba)(a6,a1.l),a5
/* QL:         tst.b   bv_sing(a6)     if this is a single line command */
    tst.b bv_sing(a6)
/* QL:         bsr.l   qstbas          check if we have to start at the top again */
    bsr.w qstbas
/* QL:         bne.l   err_nf1         idiot's have lost the program */
    bne.w err_nf1
/* QL:         bsr.l   posdfl          go to the start of subroutine line */
    bsr.w posdfl
/* QL:         bsr.l   do_arg          do the formal arguments */
    bsr.w do_arg
/* QL: get_loc */
get_loc:
/* QL:         bsr.s   find_loc        find a local line */
    bsr.s find_loc
/* QL:         beq.s   nx_loc */
    beq.s nx_loc
/* QL:         tst.l   d0              was there an error? */
    tst.l d0
/* QL:         bne.s   rts0            yes, get out */
    bne.s rts0
/* QL:         addq.l  #4,sp           delete this return */
    addq.l #4,sp
/* QL:         jmp     ib_stimm(pc)    because we're going to start immediately */
    jmp ib_stimm(pc)
/* QL: nx_loc */
nx_loc:
/* QL:         bsr.s   s2non           get next token */
    bsr.s s2non
/* QL:         cmp.b   #b.nam,d0       is it a name? */
    cmp.b #(b.nam&255),d0
/* QL:         bne.s   ch_sym          no, better check for significant symbols */
    bne.s ch_sym
/* QL:         bsr.l   mk_dum          make a dummy entry and bump top of locals */
    bsr.w mk_dum
/* QL:         cmp.w   #w.opar,d1      is this a dimensioned local? */
    cmp.w #w.opar,d1
/* QL:         bne.s   ch_sym          no, good, get next one */
    bne.s ch_sym
/* QL:         addq.b  #t.arr-t.var,0(a6,a2.l) turn it into an array */
    addq.b #(t.arr-t.var),0(a6,a2.l)
/* QL:         jsr     ib_mkdim(pc)    and make all the dimension space in the VV */
    jsr ib_mkdim(pc)
/* QL:         bne.s   rts2 */
    bne.s rts2
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL: ch_sym */
ch_sym:
/* QL:         cmp.w   #w.symcom,d1    is it a comma? */
    cmp.w #w.symcom,d1
/* QL:         beq.s   nx_loc          yes, ok */
    beq.s nx_loc
/* QL:         bsr.l   ib_cheos        is it end of line then? */
    bsr.w ib_cheos
/* QL:         beq.s   get_loc         yes, get another local line */
    beq.s get_loc
/* QL:         moveq   #err.bl,d0      anything else is wrong */
    moveq #err.bl,d0
/* QL: rts2 */
rts2:
/* QL:         rts */
    rts 
/* QL: err_ef */
err_ef:
/* QL:         moveq   #err.ef,d0 */
    moveq #err.ef,d0
/* QL:         rts */
    rts 
/* QL: find_loc */
find_loc:
/* QL:         jsr     ib_nxst(pc)     get start of next statement */
    jsr ib_nxst(pc)
/* QL:         bne.s   err_ef          no file left */
    bne.s err_ef
/* QL:         bsr.s   nxnon */
    bsr.s nxnon
/* QL:         sub.w   #w.rem,d1       ignore remarks */
    sub.w #w.rem,d1
/* QL:         beq.s   find_loc */
    beq.s find_loc
/* QL:         addq.w  #w.rem-w.data,d1 ignore data statements too */
.word 20545|((((w.rem-w.data))&7)<<9)
/* QL:         beq.s   find_loc */
    beq.s find_loc
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         subq.w  #w.loc-w.data,d1 is it a LOCal? */
.word 20801|((((w.loc-w.data))&7)<<9)
/* QL:         rts */
    rts 
/* QL: s2non */
s2non:
/* QL:         jmp     ib_s2non(pc) */
    jmp ib_s2non(pc)
/* QL: swapit */
swapit:
/* QL:         addq.l  #8,a5           move on up the name table */
    addq.l #8,a5
/* QL: swapnew */
swapnew:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.w  2(a6,a4.l),d0   which name am I swapping with? */
    move.w 2(a6,a4.l),d0
/* QL:         lsl.l   #3,d0 */
    lsl.l #3,d0
/* QL:         move.l  bv_ntbas(a6),a2 base of name table */
    move.l bv_ntbas(a6),a2
/* QL:         add.l   d0,a2 */
    add.l d0,a2
/* QL:         tst.b   bv_uproc(a6) */
    tst.b bv_uproc(a6)
/* QL:         bpl.s   noup */
    bpl.s noup
/* QL:         jsr     bv_upswp(pc) */
    jsr bv_upswp(pc)
/* QL: noup */
noup:
/* QL:         move.w  0(a6,a2.l),d0   swap first word (not the NL pointer) */
    move.w 0(a6,a2.l),d0
/* QL:         move.w  -8(a6,a5.l),0(a6,a2.l) */
    move.w (-8)(a6,a5.l),0(a6,a2.l)
/* QL:         move.w  d0,-8(a6,a5.l) */
    move.w d0,(-8)(a6,a5.l)
/* QL:         move.l  4(a6,a2.l),d0   and then second long word */
    move.l 4(a6,a2.l),d0
/* QL:         move.l  -4(a6,a5.l),4(a6,a2.l) */
    move.l (-4)(a6,a5.l),4(a6,a2.l)
/* QL:         move.l  d0,-4(a6,a5.l) */
    move.l d0,(-4)(a6,a5.l)
/* QL:         addq.l  #4,a4           and along the PF line */
    addq.l #4,a4
/* QL:         rts */
    rts 
/* QL: mk_dum */
mk_dum:
/* QL:         jsr     ca_newnt(pc)    get a new 0/0/noname/noval nt entry */
    jsr ca_newnt(pc)
/* QL:         move.l  bv_rtp(a6),a1 */
    move.l bv_rtp(a6),a1
/* QL:         addq.l  #8,-rt.rstl(a6,a1.l) update top of locals, at least */
    addq.l #8,(-rt.rstl)(a6,a1.l)
/* QL:         addq.b  #t.var,-8(a6,a5.l) say it's a simple variable for now */
    addq.b #t.var,(-8)(a6,a5.l)
/* QL:         bsr.s   swapnew         now swap it */
    bsr.s swapnew
/* QL:         jsr     bv_vtype(pc)    make it unset + original type for its name */
    jsr bv_vtype(pc)
/* QL:         addq.b  #t.var,0(a6,a2.l) make extra formal or local into a simple var */
    addq.b #t.var,0(a6,a2.l)
/* QL: nxnon */
nxnon:
/* QL:         jmp     ib_nxnon(pc) */
    jmp ib_nxnon(pc)
/* QL: ib_cheos */
ib_cheos:
/* QL:         cmp.w   #w.eol,d1       end of line? */
    cmp.w #w.eol,d1
/* QL:         beq.s   rts1 */
    beq.s rts1
/* QL:         cmp.w   #w.colon,d1     colon? */
    cmp.w #w.colon,d1
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: * Check the DEF PROC/FN line and swap the formal arguments for real ones */
/* QL: do_arg */
do_arg:
/* QL:         bsr.s   nxnon           get the def token */
    bsr.s nxnon
/* QL:         bsr.s   s2non           get the PROC/FN token */
    bsr.s s2non
/* QL:         bsr.s   s2non           get the name */
    bsr.s s2non
/* QL:         tst.w   d3 */
    tst.w d3
/* QL:         blt.s   no_nmchk */
    blt.s no_nmchk
/* QL:         cmp.w   2(a6,a4.l),d3   is it the one we think we're calling? */
    cmp.w 2(a6,a4.l),d3
/* QL:         bne.s   err_nf4         you can't fool us */
    bne.s err_nf4
/* QL: no_nmchk */
no_nmchk:
/* QL:         jsr     ib_s4non(pc) */
    jsr ib_s4non(pc)
/* QL:         cmp.w   #w.opar,d1      is it a close parenthesis? */
    cmp.w #w.opar,d1
/* QL:         beq.s   get_arg         yes, good, get the arguments */
    beq.s get_arg
/* QL:         bsr.s   ib_cheos        at end of statement? */
    bsr.s ib_cheos
/* QL:         beq.s   rts4            yes: fine, we just get out here */
    beq.s rts4
/* QL: err_nf4 */
err_nf4:
/* QL:         addq.l  #4,sp           skip the return */
    addq.l #4,sp
/* QL: err_nf1 */
err_nf1:
/* QL:         moveq   #err.nf,d0      must be a duff line */
    moveq #err.nf,d0
/* QL: rts4 */
rts4:
/* QL:         rts */
    rts 
/* QL: nxarg */
nxarg:
/* QL:         cmp.w   #w.cpar,d1      end of args yet? */
    cmp.w #w.cpar,d1
/* QL:         beq.s   rts4            yes, get out */
    beq.s rts4
/* QL: get_arg */
get_arg:
/* QL:         addq.l  #2,a4           skip */
    addq.l #2,a4
/* QL: get_arg1 */
get_arg1:
/* QL:         bsr.s   nxnon */
    bsr.s nxnon
/* QL: get_arg2 */
get_arg2:
/* QL:         cmp.b   #b.nam,d0       is this a name? */
    cmp.b #(b.nam&255),d0
/* QL:         bne.s   nxarg */
    bne.s nxarg
/* QL:         move.l  bv_ntbas(a6),d1 */
    move.l bv_ntbas(a6),d1
/* QL:         add.l   -rt.rsbl(a6,a1.l),d1 */
    add.l (-rt.rsbl)(a6,a1.l),d1
/* QL:         cmp.l   d1,a5           is there a real arg to swap it with? */
    cmp.l d1,a5
/* QL:         bge.s   argshort */
    bge.s argshort
/* QL:         bsr.l   swapit          yes - swap it */
    bsr.w swapit
/* QL:         bra.s   get_arg1        and look for the next one */
    bra.s get_arg1
/* QL: * This happens when we have more formal than actual args */
/* QL: argshort */
argshort:
/* QL:         bsr.s   mk_dum          make a dummy one, just like a local */
    bsr.s mk_dum
/* QL:         addq.l  #8,-rt.rsbl(a6,a1.l) update base of locals as well */
    addq.l #8,(-rt.rsbl)(a6,a1.l)
/* QL:         bra.s   get_arg2 */
    bra.s get_arg2
/* QL: ib_ret */
ib_ret:
/* QL:         move.l  bv_rtp(a6),a1   now then, top of return table */
    move.l bv_rtp(a6),a1
/* QL:         cmp.l   bv_rtbas(a6),a1 anything on stack? */
    cmp.l bv_rtbas(a6),a1
/* QL:         ble.s   err_nf1         not been called so can't return */
    ble.s err_nf1
/* QL:         moveq   #rt.lentl-rt.lenpr,d1 ready to take GOSUB len off rt */
    moveq #(rt.lentl-rt.lenpr),d1
/* QL:         move.b  -rt.rsrtt(a6,a1.l),d5 what have we here? */
    move.b (-rt.rsrtt)(a6,a1.l),d5
/* QL:         beq.s   gohome          it's a GOSUB, so we're done */
    beq.s gohome
/* QL:         assert  0,x.bpr-1,x.bfn-2,x.bf0-3 */
/* original assertion: 0,x.bpr-1,x.bfn-2,x.bf0-3 */
/* QL:         lsr.b   #1,d5           is this a function? */
    lsr.b #1,d5
/* QL:         beq.s   not_fn */
    beq.s not_fn
/* QL:         move.b  -rt.rsfnt(a6,a1.l),d0 if so, get function type */
    move.b (-rt.rsfnt)(a6,a1.l),d0
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         jsr     ca_eval(pc) */
    jsr ca_eval(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         ble.s   err_ev */
    ble.s err_ev
/* QL:         move.l  bv_rtp(a6),a1 */
    move.l bv_rtp(a6),a1
/* QL: not_fn */
not_fn:
/* QL:         bsr.s   undo_ret */
    bsr.s undo_ret
/* QL:         moveq   #rt.lentl,d1    PROCs and FNs have an extra lump */
    moveq #rt.lentl,d1
/* QL: gohome */
gohome:
/* QL:         sub.l   d1,bv_rtp(a6)   take len off rt */
    sub.l d1,bv_rtp(a6)
/* QL:         move.l  -rt.rssta(a6,a1.l),bv_inlin(a6) restore inline, single, index */
    move.l (-rt.rssta)(a6,a1.l),bv_inlin(a6)
/* QL:         move.w  -rt.rslno(a6,a1.l),d4 linenumber to go back to */
    move.w (-rt.rslno)(a6,a1.l),d4
/* QL:         bsr.s   restart         go to it */
    bsr.s restart
/* QL:         move.l  -rt.rssta(a6,a1.l),bv_inlin(a6) restore inline, single, index */
    move.l (-rt.rssta)(a6,a1.l),bv_inlin(a6)
/* QL:         move.b  -rt.rsstm(a6,a1.l),d4 restore statement */
    move.b (-rt.rsstm)(a6,a1.l),d4
/* QL:         jsr     ib_gost(pc)     and go */
    jsr ib_gost(pc)
/* QL:         sf      bv_unrvl(a6)    turn off the unravel flag */
    sf bv_unrvl(a6)
/* QL:         tst.b   d5              is this a function? */
    tst.b d5
/* QL:         beq.s   okrts           no - we're done */
    beq.s okrts
/* QL:         move.l  bv_ntp(a6),a5   should be entry that goes with ri stack */
    move.l bv_ntp(a6),a5
/* QL:         assert  x.bfn>>1,x.bf0>>1,t.intern */
/* original assertion: x.bfn>>1,x.bf0>>1,t.intern */
/* QL:         move.b  d5,-8(a6,a5.l)  mark it as internal */
    move.b d5,(-8)(a6,a5.l)
/* QL:         addq.l  #8,sp           definately don't want to go back to start */
    addq.l #8,sp
/* QL:         move.l  (sp)+,a0        restore position in expression */
    move.l (sp)+,a0
/* QL:         add.l   bv_bfp+4(a6),a0 wrt a6 */
    add.l (bv_bfp+4)(a6),a0
/* QL:         move.l  bv_rip(a6),a1   restore arithmetic stack pointer */
    move.l bv_rip(a6),a1
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: err_ev */
err_ev:
/* QL:         blt.s   rts6 */
    blt.s rts6
/* QL:         moveq   #err.xp,d0 */
    moveq #err.xp,d0
/* QL: rts6 */
rts6:
/* QL:         rts */
    rts 
/* QL: qstbas */
qstbas:
/* QL:         beq.s   rts6            at eof? */
    beq.s rts6
/* QL:         jmp     ib_stbas(pc)    yes, have to start at the top again */
    jmp ib_stbas(pc)
/* QL: posdflq */
posdflq:
/* QL:         bsr.s   qstbas          check if we have to start at the top again */
    bsr.s qstbas
/* QL: posdfl */
posdfl:
/* QL:         move.w  -rt.rsdfl(a6,a1.l),d4 line number of def line */
    move.w (-rt.rsdfl)(a6,a1.l),d4
/* QL:         add.l   bv_ntbas(a6),a5 */
    add.l bv_ntbas(a6),a5
/* QL: restart */
restart:
/* QL:         jsr     ib_golin(pc) */
    jsr ib_golin(pc)
/* QL:         jmp     ib_stnxl(pc) */
    jmp ib_stnxl(pc)
/* QL: * a1 -i o- top of return table */
/* QL: undo_ret */
undo_ret:
/* QL:         cmp.l   bv_pfbas(a6),a4 */
    cmp.l bv_pfbas(a6),a4
/* QL:         ble.s   set_strt */
    ble.s set_strt
/* QL:         cmp.l   bv_pfp(a6),a4 */
    cmp.l bv_pfp(a6),a4
/* QL:         blt.s   get_lin */
    blt.s get_lin
/* QL: set_strt */
set_strt:
/* QL:         jsr     ib_stbas(pc)    set to top of PF & all the other bits */
    jsr ib_stbas(pc)
/* QL: get_lin */
get_lin:
/* QL:         move.b  -rt.rsswp(a6,a1.l),d0 have the args been swapped? */
    move.b (-rt.rsswp)(a6,a1.l),d0
/* QL:         beq.s   clr_arg         no, err must have occurred during garg */
    beq.s clr_arg
/* QL:         move.l  -rt.rsbl(a6,a1.l),a5 base of locals */
    move.l (-rt.rsbl)(a6,a1.l),a5
/* QL:         bsr.s   posdfl          go to def line */
    bsr.s posdfl
/* QL: get_loc1 */
get_loc1:
/* QL:         bsr.l   find_loc        find a LOCal statement */
    bsr.w find_loc
/* QL:         bne.s   end_loc         isn't one */
    bne.s end_loc
/* QL: nx_loc1 */
nx_loc1:
/* QL:         jsr     ib_nxnam(pc)    get next local name */
    jsr ib_nxnam(pc)
/* QL:         beq.s   get_loc1        loop if end of statement */
    beq.s get_loc1
/* QL:         bsr.l   swapit          and swap it back */
    bsr.w swapit
/* QL:         subq.l  #4,a4           else nxnam doesn't work on dimensioned local */
    subq.l #4,a4
/* QL:         bra.s   nx_loc1 */
    bra.s nx_loc1
/* QL: end_loc */
end_loc:
/* QL:         moveq   #-1,d3          we don't want to check the name */
    moveq #(-1),d3
/* QL:         move.l  -rt.rsba(a6,a1.l),a5 base of args */
    move.l (-rt.rsba)(a6,a1.l),a5
/* QL:         tst.b   d0              end of file? */
    tst.b d0
/* QL:         bsr.s   posdflq         go back to def line, from top if at eof */
    bsr.s posdflq
/* QL:         bsr.l   do_arg          do the argument swapping again */
    bsr.w do_arg
/* QL: * Now free the arguments */
/* QL: clr_arg */
clr_arg:
/* QL:         move.l  bv_ntbas(a6),a5 */
    move.l bv_ntbas(a6),a5
/* QL:         move.l  a5,a3 */
    move.l a5,a3
/* QL:         add.l   -rt.rsba(a6,a1.l),a3 base of args to free */
    add.l (-rt.rsba)(a6,a1.l),a3
/* QL:         add.l   -rt.rstl(a6,a1.l),a5 top of args to free */
    add.l (-rt.rstl)(a6,a1.l),a5
/* QL:         jmp     ca_carg(pc)     clear all the args (local as well) */
    jmp ca_carg(pc)
/* QL: rts8 */
rts8:
/* QL:         rts */
    rts 
/* QL: * d1 -i  - depth of stack that needs to be copied to top of stack */
/* QL: * a4 -i  - */
/* QL: * d0/a0-a1/a3/a5 destroyed */
/* QL: ib_unret */
ib_unret:
/* QL:         subq.l  #8,sp           68020 compatible */
    subq.l #8,sp
/* QL:         movem.l a6/sp,(sp)      get a snapshot of a6/sp */
    movem.l a6/sp,(sp)
/* QL:         movem.l (sp),d2-d3      get back snapshotted a6/sp */
    movem.l (sp),d2-d3
/* QL:         sub.l   d2,d3           this is the stack a6 offset */
    sub.l d2,d3
/* QL:         addq.l  #4,d3           we won't touch the out-of-memory return */
    addq.l #4,d3
/* QL:         sub.l   bv_ssbas(a6),d3 this is the distance to get to top (-ve) */
    sub.l bv_ssbas(a6),d3
/* QL:         sub.l   d3,sp           so put stack pointer up there */
    sub.l d3,sp
/* QL:         add.l   d1,d3           this is the distance to copy from */
    add.l d1,d3
/* QL: copystk */
copystk:
/* QL:         move.w  6(sp,d3.l),-(sp) copy requested stack depth up to top */
    move.w 6(sp,d3.l),-(sp)
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         bne.s   copystk */
    bne.s copystk
/* QL:         clr.l   bv_sssav(a6)    this can't be valid anymore! lwr */
    clr.l bv_sssav(a6)
/* QL: *        sf      bv_comln(a6)    neither can this! lwr (new system though...) */
/* QL:         sf      bv_unrvl(a6)    turn off the unravel flag */
    sf bv_unrvl(a6)
/* QL:         st      bv_sing(a6)     set single line on (really? lwr) */
    st bv_sing(a6)
/* QL:         move.l  bv_chbas(a6),a0 base of channels */
    move.l bv_chbas(a6),a0
/* QL:         move.l  0(a6,a0.l),a0   actual console channel id */
    move.l 0(a6,a0.l),a0
/* QL:         moveq   #err.pf,d0 */
    moveq #err.pf,d0
/* QL:         jsr     ut_err(pc)      tell user we're clearing out */
    jsr ut_err(pc)
/* QL: nxt_un */
nxt_un:
/* QL:         move.l  bv_rtp(a6),a1   now then, top of return table */
    move.l bv_rtp(a6),a1
/* QL:         cmp.l   bv_rtbas(a6),a1 anything on stack? */
    cmp.l bv_rtbas(a6),a1
/* QL:         ble.s   rts8 */
    ble.s rts8
/* QL:         move.b  -rt.rsrtt(a6,a1.l),d5 */
    move.b (-rt.rsrtt)(a6,a1.l),d5
/* QL:         beq.s   gosub_0         yes, and it's a GOSUB */
    beq.s gosub_0
/* QL:         bsr.l   undo_ret        unravel the return */
    bsr.w undo_ret
/* QL:         sub.w   #rt.lenpr,a1 */
    sub.w #rt.lenpr,a1
/* QL: gosub_0 */
gosub_0:
/* QL:         subq.l  #rt.lentl-rt.lenpr,a1 */
.word 20873|((((rt.lentl-rt.lenpr))&7)<<9)
/* QL:         move.l  a1,bv_rtp(a6)   set the return stack pointer down a level */
    move.l a1,bv_rtp(a6)
/* QL:         subq.b  #x.bfn,d5 */
    subq.b #x.bfn,d5
/* QL:         blt.s   nxt_un          GOSUB or PROCedure, do next */
    blt.s nxt_un
/* QL:         move.l  bv_ntp(a6),a5 */
    move.l bv_ntp(a6),a5
/* QL:         subq.l  #8,a5           function, remove return value entry */
    subq.l #8,a5
/* QL: nxt_exp */
nxt_exp:
/* QL:         moveq   #0,d2           unravel entries down to 1st non-internal */
    moveq #0,d2
/* QL:         jsr     ca_undo(pc) */
    jsr ca_undo(pc)
/* QL:         bne.s   nxt_exp */
    bne.s nxt_exp
/* QL:         move.l  a5,bv_ntp(a6)   reset the name table pointer */
    move.l a5,bv_ntp(a6)
/* QL:         bra.s   nxt_un */
    bra.s nxt_un
/* QL:         end */
