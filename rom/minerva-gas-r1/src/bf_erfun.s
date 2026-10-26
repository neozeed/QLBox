/* Generated from original/M/bf/erfun.asm */
/* QL: * Error functions */
/* QL:         xdef    bf_erlin,bf_ernum,bf_fllin + bf_errxx from macro */
.globl bf_erlin,bf_ernum,bf_fllin
/* QL:         xref    bv_chri,ri_fllin */
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
/* QL: bf_err macro */
/* QL:         section bf_erfun */
.section bf_erfun,"ax"
/* QL:         bf_err  nc nj om or bo no nf ex iu ef df bn te ff bp fe xp ov ni ro bl */
/* QL: i setnum [.nparms] */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -21,err.bl */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errbl
/* QL: [t] */
bf_errbl:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -20,err.ro */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errro
/* QL: [t] */
bf_errro:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -19,err.ni */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errni
/* QL: [t] */
bf_errni:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -18,err.ov */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errov
/* QL: [t] */
bf_errov:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -17,err.xp */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errxp
/* QL: [t] */
bf_errxp:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -16,err.fe */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errfe
/* QL: [t] */
bf_errfe:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -15,err.bp */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errbp
/* QL: [t] */
bf_errbp:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -14,err.ff */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errff
/* QL: [t] */
bf_errff:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -13,err.te */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errte
/* QL: [t] */
bf_errte:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -12,err.bn */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errbn
/* QL: [t] */
bf_errbn:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -11,err.df */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errdf
/* QL: [t] */
bf_errdf:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -10,err.ef */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_erref
/* QL: [t] */
bf_erref:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -9,err.iu */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_erriu
/* QL: [t] */
bf_erriu:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -8,err.ex */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errex
/* QL: [t] */
bf_errex:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -7,err.nf */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errnf
/* QL: [t] */
bf_errnf:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -6,err.no */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errno
/* QL: [t] */
bf_errno:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -5,err.bo */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errbo
/* QL: [t] */
bf_errbo:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -4,err.or */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_error
/* QL: [t] */
bf_error:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -3,err.om */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errom
/* QL: [t] */
bf_errom:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -2,err.nj */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errnj
/* QL: [t] */
bf_errnj:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL: l maclab */
/* QL:         assert -[i],err.[.parm([i])] */
/* original assertion: -1,err.nc */
/* QL: t setstr bf_err[.parm([i])] */
/* QL:         xdef    [t] */
.globl bf_errnc
/* QL: [t] */
bf_errnc:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: i setnum [i]-1 */
/* QL:  ifnum [i] <> 0 goto l */
/* QL:         add.l   bv_error(a6),d7 is it the right error? */
    add.l bv_error(a6),d7
/* QL:         beq.s   true */
    beq.s true
/* QL:         sub.l   d7,d7           yipe! I made this moveq, and X was left set! */
    sub.l d7,d7
/* QL: true */
true:
/* QL:         addx.b  d7,d7 */
    addx.b d7,d7
/* QL:         bra.s   numlin */
    bra.s numlin
/* QL: bf_erlin */
bf_erlin:
/* QL:         move.w  bv_erlin(a6),d7 should always be positive */
    move.w bv_erlin(a6),d7
/* QL:         bra.s   numlin */
    bra.s numlin
/* QL: bf_ernum */
bf_ernum:
/* QL:         move.l  bv_error(a6),d7 bv_error is long, get it right! */
    move.l bv_error(a6),d7
/* QL: numlin */
numlin:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         cmp.l   a3,a5           shouldn't be any parameters */
    cmp.l a3,a5
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         jsr     bv_chri(pc)     make sure enough room on stack */
    jsr bv_chri(pc)
/* QL:         move.l  bv_rip(a6),a1   where to put  */
    move.l bv_rip(a6),a1
/* QL:         subq.l  #2,a1           space for an integer */
    subq.l #2,a1
/* QL:         move.w  d7,0(a6,a1.l) */
    move.w d7,0(a6,a1.l)
/* QL:         moveq   #t.int,d4 */
    moveq #t.int,d4
/* QL:         move.l  d7,d1 */
    move.l d7,d1
/* QL:         ext.l   d7 */
    ext.l d7
/* QL:         cmp.l   d7,d1 */
    cmp.l d7,d1
/* QL:         beq.s   setrip */
    beq.s setrip
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL: bf_fllin */
bf_fllin:
/* QL:         jsr     ri_fllin(pc)    should rarely happen! */
    jsr ri_fllin(pc)
/* QL:         moveq   #t.fp,d4 */
    moveq #t.fp,d4
/* QL: setrip */
setrip:
/* QL:         move.l  a1,bv_rip(a6)   save a1 */
    move.l a1,bv_rip(a6)
/* QL:         moveq   #0,d0           no errors */
    moveq #0,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL:         end */
