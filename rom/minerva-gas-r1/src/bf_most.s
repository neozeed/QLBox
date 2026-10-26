/* Generated from original/M/bf/most.asm */
/* QL: * Trig, arithmetic and other functions */
/* QL:         xdef    bf_abs,bf_acot,bf_atan,bf_beepg,bf_chrs,bf_code,bf_deg,bf_dimn */
.globl bf_abs,bf_acot,bf_atan,bf_beepg,bf_chrs,bf_code,bf_deg,bf_dimn
/* QL:         xdef    bf_eof,bf_fills,bf_inkes,bf_int,bf_len,bf_peek,bf_peekl */
.globl bf_eof,bf_fills,bf_inkes,bf_int,bf_len,bf_peek,bf_peekl
/* QL:         xdef    bf_peekw,bf_pi,bf_rad,bf_respr,bf_rnd,bf_vers,bp_pause <-- N.B. */
.globl bf_peekw,bf_pi,bf_rad,bf_respr,bf_rnd,bf_vers,bp_pause
/* QL: * N.B. Various other xdef/xref stuff set in macro below */
/* QL:         xref    ri_arg,ri_div,ri_fllin,ri_k_b,ri_mult,ri_one,ri_renrm */
/* QL:         xref    ri_sss,ri_swap */
/* QL:         xref    ca_gtfp,ca_gtfp1,ca_gtin1,ca_gtint,ca_gtli1,ca_gtst1 */
/* QL:         xref    bv_chrix */
/* QL:         xref    bp_chand,bp_data,bp_pepo */
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
/* QL:         include 'win1_m_inc_ri' */
/* QL: * arithmetic interpreter op codes */
/* QL:         nolist */
/* QL: ri.term equ     $00  0  end of block */
.equ ri.term,0x00
/* QL: ri.one  equ     $01 -6  constant one */
.equ ri.one,0x01
/* QL: ri.nint equ     $02 +4  nearest short integer */
.equ ri.nint,0x02
/* QL: ri.zero equ     $03 -6  constant zero */
.equ ri.zero,0x03
/* QL: ri.int  equ     $04 +4  truncate towards negative to give a short integer */
.equ ri.int,0x04
/* QL: ri.n    equ     $05 -6  plus a signed byte to push fp -128 to 127 */
.equ ri.n,0x05
/* QL: ri.nlint equ    $06 +2  nearest long integer */
.equ ri.nlint,0x06
/* QL: ri.k    equ     $07 -6  plus a byte, nibbles give mantissa and adjust exponent */
.equ ri.k,0x07
/* QL: ri.float equ    $08 -4  float a short integer */
.equ ri.float,0x08
/* QL: ri.flong equ    $09 -2  float a long integer */
.equ ri.flong,0x09
/* QL: ri.add  equ     $0a +6  nos - tos */
.equ ri.add,0x0a
/* QL: ri.sub  equ     $0c +6  nos + tos */
.equ ri.sub,0x0c
/* QL: ri.halve equ    $0d  0  tos / 2 */
.equ ri.halve,0x0d
/* QL: ri.mult  equ    $0e +6  nos * tos */
.equ ri.mult,0x0e
/* QL: ri.doubl equ    $0f  0  tos * 2 */
.equ ri.doubl,0x0f
/* QL: ri.div  equ     $10 +6  nos / tos */
.equ ri.div,0x10
/* QL: ri.recip equ    $11  0  1 / tos */
.equ ri.recip,0x11
/* QL: ri.abs  equ     $12  0  abs(tos) */
.equ ri.abs,0x12
/* QL: ri.roll equ     $13  0  (tos)b, c, a -> (tos)a, b, c (roll 3rd to top) */
.equ ri.roll,0x13
/* QL: ri.neg  equ     $14  0  -tos */
.equ ri.neg,0x14
/* QL: ri.over equ     $15 -6  nos */
.equ ri.over,0x15
/* QL: ri.dup  equ     $16 -6  tos */
.equ ri.dup,0x16
/* QL: ri.swap equ     $17  0  nos <--> tos */
.equ ri.swap,0x17
/* QL: ri.cos  equ     $18  0  cos(tos) */
.equ ri.cos,0x18
/* QL: ri.sin  equ     $1a  0  sin(tos) */
.equ ri.sin,0x1a
/* QL: ri.tan  equ     $1c  0  tan(tos) */
.equ ri.tan,0x1c
/* QL: ri.cot  equ     $1e  0  cot(tos) */
.equ ri.cot,0x1e
/* QL: ri.asin equ     $20  0  arcsin(tos) */
.equ ri.asin,0x20
/* QL: ri.acos equ     $22  0  arccos(tos) */
.equ ri.acos,0x22
/* QL: ri.atan equ     $24  0  arctan(tos) */
.equ ri.atan,0x24
/* QL: ri.arg  equ     $25 +6  arg(tos,nos) = a, solves tos/nos = k*cos(a)/k*sin(a) */
.equ ri.arg,0x25
/* QL: ri.acot equ     $26  0  arccot(tos) */
.equ ri.acot,0x26
/* QL: ri.mod  equ     $27 +6  sqrt(tos^2 + nos^2) */
.equ ri.mod,0x27
/* QL: ri.sqrt equ     $28  0  sqrt(tos) */
.equ ri.sqrt,0x28
/* QL: ri.squar equ    $29  0  tos * tos */
.equ ri.squar,0x29
/* QL: ri.ln   equ     $2a  0  ln(tos) */
.equ ri.ln,0x2a
/* QL: ri.log10 equ    $2c  0  log10(tos) */
.equ ri.log10,0x2c
/* QL: ri.exp  equ     $2e  0  e ^ tos */
.equ ri.exp,0x2e
/* QL: ri.power equ    $2f +2  nos ^ tos, where tos is a signed short integer */
.equ ri.power,0x2f
/* QL: ri.powfp equ    $30 +6  nos ^ tos */
.equ ri.powfp,0x30
/* QL: ri.maxop equ    $30 */
.equ ri.maxop,0x30
/* QL: ri.load equ     $00     load operand key */
.equ ri.load,0x00
/* QL: ri.store equ    $01     store operand key (sets bit 0) */
.equ ri.store,0x01
/* QL: * for use after ri.k */
/* QL: ri.pi180 equ    $56 */
.equ ri.pi180,0x56
/* QL: ri.loge equ     $69 */
.equ ri.loge,0x69
/* QL: ri.pi6  equ     $79 */
.equ ri.pi6,0x79
/* QL: ri.ln2  equ     $88-$100 */
.equ ri.ln2,(0x88-0x100)
/* QL: ri.sqrt3 equ    $98-$100 */
.equ ri.sqrt3,(0x98-0x100)
/* QL: ri.pi   equ     $a8-$100 */
.equ ri.pi,(0xa8-0x100)
/* QL: ri.pi2  equ     $a7-$100 */
.equ ri.pi2,(0xa7-0x100)
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
/* QL:         include 'win1_m_inc_sx' */
/* QL: * system variables extension */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sx_case ds.l    1       non-zero = user rtn on ctrl/alt/shift/enter (c/a/s/e?) */
.equ sx_case,0
/* QL: sx_itran ds.l   1       input tranlation routine */
.equ sx_itran,4
/* QL: sx_otran ds.l   1       output translation routine */
.equ sx_otran,8
/* QL: sx_driv ds.l    1       mm_rechp is memory management driver, close entry point */
.equ sx_driv,12
/* QL: sx_kbenc ds.l   1       keyboard encoder routine */
.equ sx_kbenc,16
/* QL: sx_ipcom ds.l   1       linked list to front end mt.ipcom calls */
.equ sx_ipcom,20
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL: sx_trn  ds.l    1       default i/o translation table address */
.equ sx_trn,32
/* QL: sx_msg  ds.l    1       default message table address */
.equ sx_msg,36
/* QL: sx_f0   ds.l    1       default primary font */
.equ sx_f0,40
/* QL: sx_f1   ds.l    1       default secondary font */
.equ sx_f1,44
/* QL: sx_dspm ds.b    1       real display mode settings (dual screen) */
.equ sx_dspm,48
/* QL: sx_toe  ds.b    1       turn off ehancements: */
.equ sx_toe,49
/* QL:                 ; bit 7 set, allow format + files open */
/* QL:                 ; bit 1 set, treat -ve mt.baud as error (non-hermes) */
/* QL: sx_event ds.b   1       events: bit 4 = ctrl/space, 5=+alt, 6=+shift, 7=+both */
.equ sx_event,50
/* QL: sx_fstat ds.b   1       cursor flash rate, size and colour rrrrsccc */
.equ sx_fstat,51
/* QL: sx_kbste ds.b   12      special key remap table */
.equ sx_kbste,52
/* QL: sx_qdos ds.l    1       returned by mt.inf, ver$(-2) */
.equ sx_qdos,64
/* QL: sx_basic ds.w   1+4/2   length prefixed string returned by ver$, ver$(0) */
.equ sx_basic,68
/* QL:         ds.w    2       spare/reserved */
/* QL:         ds.b    1       21kxs10w   21: ser21 data pend, k: key held, x: shift */
/* QL:                         ; change while key held, s: sound in progress, 1: 1, */
/* QL:                         ; 0: zero Hermes, old IPC showed ser being zapped, */
/* QL:                         ; w: p26 (write protect) (experimental byte!) */
/* QL:         ds.b    1       spare/reserved */
/* QL: * initial ram based linkages */
/* QL:         ds.l    2       0 ip_poll */
/* QL:         ds.l    6       base+$60 sd_sched base+$68 ip_sched 0 io_scan */
/* QL:         ds.l    4       base+$80 od_serio od_serop od_sercl */
/* QL: sx_pipb ds.l    4       base+$90 io_serq  od_pipop od_pipcl */
.equ sx_pipb,128
/* QL: sx_con  ds.l    4       base+$a0 od_conio od_conop od_concl */
.equ sx_con,144
/* QL:         ds.l    4       0 od_netio od_netop od_netcl */
/* QL:         ds.l    8       0 dd_mdvio dd_mdvop dd_mdvcl md_slave 0 0 md_formt */
/* QL:         ds.b    4+2+3   md_end 3 'mdv' */
/* QL:         ds.b    3       spare bit */
/* QL: sx_pipc ds.l    1       pipe driver link word */
.equ sx_pipc,220
/* QL: * end of system extension */
/* QL:         list */
/* QL: bf_ri   macro */
/* QL:         section bf_most */
.section bf_most,"ax"
/* QL:         bf_ri   sin,cos,tan,cot,asin,acos,exp,ln,log10,sqrt */
/* QL: i       setnum  1 */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_sin
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_sin:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_791:
.word ((ri_sin-dc_anchor_791))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_cos
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_cos:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_805:
.word ((ri_cos-dc_anchor_805))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_tan
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_tan:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_819:
.word ((ri_tan-dc_anchor_819))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_cot
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_cot:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_833:
.word ((ri_cot-dc_anchor_833))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_asin
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_asin:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_847:
.word ((ri_asin-dc_anchor_847))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_acos
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_acos:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_861:
.word ((ri_acos-dc_anchor_861))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_exp
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_exp:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_875:
.word ((ri_exp-dc_anchor_875))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_ln
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_ln:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_889:
.word ((ri_ln-dc_anchor_889))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_log10
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_log10:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_903:
.word ((ri_log10-dc_anchor_903))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
.globl bf_sqrt
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   fn_trig */
bf_sqrt:
    bsr.s fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
dc_anchor_917:
.word ((ri_sqrt-dc_anchor_917))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: bf_abs */
bf_abs:
/* QL:         bsr.s   gtfp            get args */
    bsr.s gtfp
/* QL:         jsr     ri_sss(pc)      rountine invented espesially for this */
    jsr ri_sss(pc)
/* QL:         bra.s   fp_put1 */
    bra.s fp_put1
/* QL: bf_pi */
bf_pi:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         bne.s   err_bp0         should be no parameters for pi */
    bne.s err_bp0
/* QL:         bsr.s   get_ri1         make space */
    bsr.s get_ri1
/* QL:         moveq   #ri.pi,d0 */
    moveq #ri.pi,d0
/* QL:         bsr.s   do_trig */
    bsr.s do_trig
/* QL:         dc.w    ri_k_b-* */
.balign 2,0
dc_anchor_943:
.word ((ri_k_b-dc_anchor_943))&65535
/* QL: err_bp0 */
err_bp0:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: bf_acot */
bf_acot:
/* QL:         moveq   #-1,d7 */
    moveq #(-1),d7
/* QL: bf_atan */
bf_atan:
/* QL:         bsr.s   gtfp            get 1/2 args */
    bsr.s gtfp
/* QL:         subq.w  #2,d3 */
    subq.w #2,d3
/* QL:         beq.s   arggo */
    beq.s arggo
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL:         bne.s   err_bp0 */
    bne.s err_bp0
/* QL:         jsr     ri_one(pc) */
    jsr ri_one(pc)
/* QL: arggo */
arggo:
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         bpl.s   istan */
    bpl.s istan
/* QL:         jsr     ri_swap(pc) */
    jsr ri_swap(pc)
/* QL: istan */
istan:
/* QL:         bsr.s   do_trig */
    bsr.s do_trig
/* QL:         dc.w    ri_arg-* */
.balign 2,0
dc_anchor_983:
.word ((ri_arg-dc_anchor_983))&65535
/* QL: gtfp */
gtfp:
/* QL:         jsr     ca_gtfp(pc)     get all args as floating point */
    jsr ca_gtfp(pc)
/* QL:         bne.s   popifne */
    bne.s popifne
/* QL: get_ri1 */
get_ri1:
/* QL:         bra.l   get_ri0         ensure we have space on stack */
    bra.w get_ri0
/* QL: deg_rad */
deg_rad:
/* QL:         jsr     ca_gtfp1(pc)    get just one argument */
    jsr ca_gtfp1(pc)
/* QL:         bne.s   popifne */
    bne.s popifne
/* QL:         bsr.s   get_ri1         and get just a little bit more space */
    bsr.s get_ri1
/* QL:         moveq   #ri.pi180,d0 */
    moveq #ri.pi180,d0
/* QL:         jsr     ri_k_b(pc) */
    jsr ri_k_b(pc)
/* QL:         bra.s   do_trig */
    bra.s do_trig
/* QL: bf_deg */
bf_deg:
/* QL:         bsr.s   deg_rad */
    bsr.s deg_rad
/* QL:         dc.w    ri_div-*        divide by pi/180 */
.balign 2,0
dc_anchor_1015:
.word ((ri_div-dc_anchor_1015))&65535
/* QL: bf_rad */
bf_rad:
/* QL:         bsr.s   deg_rad */
    bsr.s deg_rad
/* QL:         dc.w    ri_mult-*       multiply by pi/180 */
.balign 2,0
dc_anchor_1023:
.word ((ri_mult-dc_anchor_1023))&65535
/* QL: fn_trig */
fn_trig:
/* QL:         jsr     ca_gtfp1(pc)    get one and only one fp arg */
    jsr ca_gtfp1(pc)
/* QL: popifne */
popifne:
/* QL:         bne.s   pop_4a */
    bne.s pop_4a
/* QL:         bsr.s   get_ri1         make sure there's enough room */
    bsr.s get_ri1
/* QL: do_trig */
do_trig:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         add.w   (a4),a4 */
    add.w (a4),a4
/* QL:         jsr     (a4)            do the trig function */
    jsr (a4)
/* QL: fp_put1 */
fp_put1:
/* QL:         bra.s   fp_put0 */
    bra.s fp_put0
/* QL: * Random number generator */
/* QL: rndold */
rndold:
/* QL: * old scheme when lsb of bv_rand is set. we use: */
/* QL: *       x'=a*x mod 2^32, a=89*2^2-1, period 2^30 */
/* QL:         mulu    #355,d5 */
    mulu #355,d5
/* QL:         mulu    #355,d6 */
    mulu #355,d6
/* QL:         swap    d6 */
    swap d6
/* QL:         clr.w   d6 */
    clr.w d6
/* QL:         bra.s   rndadd */
    bra.s rndadd
/* QL: bf_rnd */
bf_rnd:
/* QL:         move.l  bv_rand(a6),d5  get random number */
    move.l bv_rand(a6),d5
/* QL:         move.l  d5,d6           save it */
    move.l d5,d6
/* QL:         swap    d6 */
    swap d6
/* QL:         btst    d7,d5 */
    btst d7,d5
/* QL:         bne.s   rndold */
    bne.s rndold
/* QL: * new scheme when lsb of bv_rand is clear. with x=bv_rnd/2, we use: */
/* QL: *       x'=a*x+b mod 2^31 a=2^16+1 b=12517 period 2^31 */
/* QL: * the funny number for b is 32768*(3-sqrt(5))/2, which makes the lsw jump */
/* QL: * around in a fairly interesting way. */
/* QL:         move.w  #12517*2,d6 */
    move.w #(12517*2),d6
/* QL: rndadd */
rndadd:
/* QL:         add.l   d6,d5           add together */
    add.l d6,d5
/* QL:         move.l  d5,bv_rand(a6)  ... save it */
    move.l d5,bv_rand(a6)
/* QL:         jsr     ca_gtint(pc)    how many arguments? */
    jsr ca_gtint(pc)
/* QL:         bne.s   rts2 */
    bne.s rts2
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         beq.s   rand_1          ... one */
    beq.s rand_1
/* QL:         bgt.s   rand_2          ... two */
    bgt.s rand_2
/* QL:         bsr.s   get_ri1         none - make space for one argument */
    bsr.s get_ri1
/* QL:         move.l  d5,d1           and mantissa */
    move.l d5,d1
/* QL:         lsr.l   #1,d1           make positive */
    lsr.l #1,d1
/* QL:         move.w  #$0800,d0       set exponent */
    move.w #0x0800,d0
/* QL:         bsr.s   do_trig */
    bsr.s do_trig
/* QL:         dc.w    ri_renrm-*      return fp */
.balign 2,0
dc_anchor_1108:
.word ((ri_renrm-dc_anchor_1108))&65535
/* QL: rand_2 */
rand_2:
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bne.s   err_bp1 */
    bne.s err_bp1
/* QL:         move.w  0(a6,a1.l),d3   get base of range */
    move.w 0(a6,a1.l),d3
/* QL:         addq.l  #2,a1           lose extra integer on stack */
    addq.l #2,a1
/* QL: rand_1 */
rand_1:
/* QL:         move.w  0(a6,a1.l),d2   get top of range */
    move.w 0(a6,a1.l),d2
/* QL:         sub.w   d3,d2           less base */
    sub.w d3,d2
/* QL:         blt.s   err_bp1         oops, no good if top<base */
    blt.s err_bp1
/* QL:         addq.w  #1,d2           add one for total number of possible returns */
    addq.w #1,d2
/* QL:         beq.s   rndtop          cope with range -32768to 32767!!! */
    beq.s rndtop
/* QL:         swap    d5              use most significant end */
    swap d5
/* QL:         mulu    d2,d5           multiply */
    mulu d2,d5
/* QL: rndtop */
rndtop:
/* QL:         swap    d5              result is in top half */
    swap d5
/* QL:         add.w   d3,d5           ... plus base */
    add.w d3,d5
/* QL: put_int */
put_int:
/* QL:         move.w  d5,0(a6,a1.l)   set result */
    move.w d5,0(a6,a1.l)
/* QL:         moveq   #t.int,d4       result is integer */
    moveq #t.int,d4
/* QL: put_ok */
put_ok:
/* QL:         moveq   #0,d0           if here then good return */
    moveq #0,d0
/* QL: put_rip */
put_rip:
/* QL:         move.l  a1,bv_rip(a6)   all results on stack */
    move.l a1,bv_rip(a6)
/* QL: rts2 */
rts2:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 (no return on error) */
/* QL: * d1 -  o- long integer parameter */
/* QL: * d3 -  o- 0 */
/* QL: * a1 -  o- bv_rip, parameter removed */
/* QL: * d2 destroyed */
/* QL: gtli1 */
gtli1:
/* QL:         jsr     ca_gtli1(pc)    get a long integer (returned in d1) */
    jsr ca_gtli1(pc)
/* QL:         addq.l  #4,a1           remove from RI stack */
    addq.l #4,a1
/* QL:         beq.s   rts2 */
    beq.s rts2
/* QL: pop_4a */
pop_4a:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: bf_int */
bf_int:
/* QL:         bsr.s   gtli1           get as a long integer */
    bsr.s gtli1
/* QL: pushlin0 */
pushlin0:
/* QL:         jsr     ri_fllin(pc) */
    jsr ri_fllin(pc)
/* QL: fp_put0 */
fp_put0:
/* QL:         moveq   #t.fp,d4        result is floating point */
    moveq #t.fp,d4
/* QL:         bra.s   put_rip */
    bra.s put_rip
/* QL: bf_peekl */
bf_peekl:
/* QL:         moveq   #%10111-1,d7    peek a longword */
    moveq #(0b10111-1),d7
/* QL: bf_peekw */
bf_peekw:
/* QL:         addq.b  #1,d7           peek a word */
    addq.b #1,d7
/* QL: bf_peek */
bf_peek:
/* QL:         jsr     bp_pepo(pc)     get address, same code as poke routines */
    jsr bp_pepo(pc)
/* QL:         addq.l  #4,a1           adjust RI pointer */
    addq.l #4,a1
/* QL:         beq.s   pkent           should be no params remaining */
    beq.s pkent
/* QL: err_bp1 */
err_bp1:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: rts3 */
rts3:
/* QL:         rts */
    rts 
/* QL: peeklp */
peeklp:
/* QL:         rol.l   #8,d5 */
    rol.l #8,d5
/* QL: pkent */
pkent:
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bgt.s   absbn */
    bgt.s absbn
/* QL:         move.b  0(a6,a5.l),d5 */
    move.b 0(a6,a5.l),d5
/* QL:         addq.l  #1,a5 */
    addq.l #1,a5
/* QL:         bra.s   gotbn */
    bra.s gotbn
/* QL: absbn */
absbn:
/* QL:         move.b  (a5)+,d5        no address constraint */
    move.b (a5)+,d5
/* QL: gotbn */
gotbn:
/* QL:         lsr.b   #1,d7           roll out a bit */
    lsr.b #1,d7
/* QL:         bcs.s   peeklp          loop while one bits come out */
    bcs.s peeklp
/* QL:         beq.s   pushint0        if now zero, it wasn't peek_l */
    beq.s pushint0
/* QL:         move.l  d5,d1 */
    move.l d5,d1
/* QL:         ext.l   d5 */
    ext.l d5
/* QL:         cmp.l   d5,d1           does it fit in an integer? */
    cmp.l d5,d1
/* QL:         bne.s   pushlin0        no - make it into a float */
    bne.s pushlin0
/* QL:         bra.s   pushint0 */
    bra.s pushint0
/* QL: bf_respr */
bf_respr:
/* QL:         bsr.s   gtli1           get space required into d1 */
    bsr.s gtli1
/* QL:         move.l  a1,a5 */
    move.l a1,a5
/* QL:         moveq   #mt.alres,d0    allocate space in resident area (or chp!) */
    moveq #mt.alres,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.s   rts3 */
    bne.s rts3
/* QL:         move.l  a5,a1 */
    move.l a5,a1
/* QL: reta0 */
reta0:
/* QL:         move.l  a0,d1 */
    move.l a0,d1
/* QL: pushlin1 */
pushlin1:
/* QL:         bra.s   pushlin0 */
    bra.s pushlin0
/* QL: bf_beepg */
bf_beepg:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         bne.s   err_bp1         should be no parameters for beeping */
    bne.s err_bp1
/* QL:         moveq   #mt.inf,d0 */
    moveq #mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         moveq   #1,d5           mask out all but lsb */
    moveq #1,d5
/* QL:         and.b   sv_sound(a0),d5 is it happenning? */
    and.b sv_sound(a0),d5
/* QL: gtpshint */
gtpshint:
/* QL:         bsr.l   get_ri0         reserve space */
    bsr.w get_ri0
/* QL: pushint0 */
pushint0:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         bra.s   put_int */
    bra.s put_int
/* QL: bf_eof */
bf_eof:
/* QL:         cmp.l   a3,a5           is there a parameter? */
    cmp.l a3,a5
/* QL:         bne.s   eof_chan */
    bne.s eof_chan
/* QL:         jsr     bp_data(pc)     no, so get next data item */
    jsr bp_data(pc)
/* QL:         bra.s   set_eof */
    bra.s set_eof
/* QL: eof_chan */
eof_chan:
/* QL:         bsr.s   chan            check for channel */
    bsr.s chan
/* QL:         bne.s   rts3            error, return same */
    bne.s rts3
/* QL:         moveq   #io.pend,d0     test channel */
    moveq #io.pend,d0
/* QL:         clr.w   d3              immediate return */
    clr.w d3
/* QL:         trap    #3 */
    trap #3
/* QL: set_eof */
set_eof:
/* QL:         clr.w   d5              set false */
    clr.w d5
/* QL:         moveq   #-err.ef,d4     check eof */
    moveq #(-err.ef),d4
/* QL:         add.l   d0,d4 */
    add.l d0,d4
/* QL:         subq.l  #1,d4           is it eof? */
    subq.l #1,d4
/* QL:         addx.b  d5,d5           (only zero less one will set x) */
    addx.b d5,d5
/* QL:         bra.s   gtpshint */
    bra.s gtpshint
/* QL: bf_vers */
bf_vers:
/* QL:         bsr.l   opt_int */
    bsr.w opt_int
/* QL:         moveq   #mt.inf,d0 */
    moveq #mt.inf,d0
/* QL:         trap    #1              get OS stuff */
    trap #1
/* QL:         addq.w  #2,d7 */
    addq.w #2,d7
/* QL:         beq.s   reta0           -2: system variables address */
    beq.s reta0
/* QL:         bcs.s   pushlin1        -1: current job number */
    bcs.s pushlin1
/* QL:         subq.w  #2+1,d7 */
    subq.w #(2+1),d7
/* QL:         bcs.s   vertop          0: normal version */
    bcs.s vertop
/* QL:         bne.s   err_bp2 */
    bne.s err_bp2
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  d2,2(a6,a1.l)   1: QDOS OS version */
    move.l d2,2(a6,a1.l)
/* QL:         moveq   #4,d4 */
    moveq #4,d4
/* QL:         bra.s   len_put */
    bra.s len_put
/* QL: chan */
chan:
/* QL:         moveq   #0,d1           default to command screen */
    moveq #0,d1
/* QL:         jmp     bp_chand(pc)    get #n */
    jmp bp_chand(pc)
/* QL: vertop */
vertop:
/* QL:         moveq   #sx_basic,d7 */
    moveq #sx_basic,d7
/* QL:         move.l  sv_chtop(a0),a0 */
    move.l sv_chtop(a0),a0
/* QL:         add.l   d7,a0 */
    add.l d7,a0
/* QL:         move.w  (a0),d7 */
    move.w (a0),d7
/* QL:         bsr.s   room_str        get space, and verify length is sensible */
    bsr.s room_str
/* QL:         add.l   d1,a0 */
    add.l d1,a0
/* QL: vercop */
vercop:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  -(a0),0(a6,a1.l) version letters */
    move.w -(a0),0(a6,a1.l)
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         bne.s   vercop */
    bne.s vercop
/* QL:         bra.s   len_put */
    bra.s len_put
/* QL: bp_pause ; sad, but there's no sensible way to avoid this misnomer-ish entry */
bp_pause:
/* QL:         moveq   #-1,d7          infinite wait */
    moveq #(-1),d7
/* QL: bf_inkes */
bf_inkes:
/* QL:         bsr.s   chan            check for channel */
    bsr.s chan
/* QL:         bne.s   noinkch         the channel's no good */
    bne.s noinkch
/* QL:         bsr.s   opt_int         get an optional integer */
    bsr.s opt_int
/* QL:         move.w  d7,d3           set timeout */
    move.w d7,d3
/* QL:         move.l  a1,a4           save a1 */
    move.l a1,a4
/* QL:         moveq   #io.fbyte,d0 */
    moveq #io.fbyte,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  a4,a1 */
    move.l a4,a1
/* QL:         moveq   #0,d4           ready for null string */
    moveq #0,d4
/* QL:         addq.l  #-err.nc,d0 */
.word 20608|((((-err.nc))&7)<<9)
/* QL:         beq.s   len_push        if not complete - return null string */
    beq.s len_push
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         subq.l  #-err.nc,d0 */
.word 20864|((((-err.nc))&7)<<9)
/* QL: gotchrs */
gotchrs:
/* QL:         bne.s   noinkch */
    bne.s noinkch
/* QL:         move.b  d1,0(a6,a1.l)   set return character */
    move.b d1,0(a6,a1.l)
/* QL:         moveq   #1,d4           string length 1 */
    moveq #1,d4
/* QL: len_push */
len_push:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL: len_put */
len_put:
/* QL:         move.w  d4,0(a6,a1.l)   (re)place the length */
    move.w d4,0(a6,a1.l)
/* QL:         moveq   #t.str,d4       set type string */
    moveq #t.str,d4
/* QL:         bra.l   put_ok */
    bra.w put_ok
/* QL: noinkch */
noinkch:
/* QL:         tst.l   d7              0 = inkey$/chr$, -1 = pause */
    tst.l d7
/* QL:         bpl.s   rts5 */
    bpl.s rts5
/* QL:         moveq   #0,d0           cancel error if pause (compatibility!) */
    moveq #0,d0
/* QL: rts5 */
rts5:
/* QL:         rts */
    rts 
/* QL: err_bp2 */
err_bp2:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- 60 */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * d2 destroyed */
/* QL: get_ri0 */
get_ri0:
/* QL:         moveq   #10*6,d1        same as in bv_chri */
    moveq #(10*6),d1
/* QL: chrix */
chrix:
/* QL:         move.l  d1,a1 */
    move.l d1,a1
/* QL:         jsr     bv_chrix(pc) */
    jsr bv_chrix(pc)
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 (no return on error) */
/* QL: * d1 -  o- total length including length word and possible padding byte */
/* QL: * d4 -  o- copy of d7 */
/* QL: * d7 -ip - length of string required */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * d2 destroyed */
/* QL: room_str */
room_str:
/* QL:         move.w  d7,d4           copy length */
    move.w d7,d4
/* QL:         move.l  d7,d1 */
    move.l d7,d1
/* QL:         addq.w  #3,d1 */
    addq.w #3,d1
/* QL:         bcs.s   bp_pop          reject string length $FFFD..$FFFF */
    bcs.s bp_pop
/* QL:         bclr    #0,d1 */
    bclr #0,d1
/* QL:         bpl.s   chrix           accept string length 0..32764 */
    bpl.s chrix
/* QL: bp_pop */
bp_pop:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: pop_4b */
pop_4b:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: bf_chrs */
bf_chrs:
/* QL:         bsr.s   get_ri0         gotta get space, as we will need 2 bytes extra */
    bsr.s get_ri0
/* QL:         jsr     ca_gtin1(pc)    get one integer (value in d1) */
    jsr ca_gtin1(pc)
/* QL:         bra.s   gotchrs         store char, if no error */
    bra.s gotchrs
/* QL: * Skip one parameter, and expect an optional, single, integer (default d7) */
/* QL: * Same as opt_int below, except: */
/* QL: * a3 -i o- base of args / 8 added */
/* QL: opt_2nd */
opt_2nd:
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL: * Reserve 60 bytes on stack, get an optional, single, integer (default d7) */
/* QL: * d0 -  o- 0 (no return on error) */
/* QL: * d3 -  o- 0 if integer parameter was used, else -1 */
/* QL: * d7 -i o- default / same, or lsw from present parameter */
/* QL: * a3 -ip - base of args */
/* QL: * a1 -  o- RI stack pointer (optional integer removed, bv_rip same) */
/* QL: * a5 -ip - top of args */
/* QL: * d1-d2 destroyed */
/* QL: opt_int */
opt_int:
/* QL:         bsr.s   get_ri0         check for room on ri */
    bsr.s get_ri0
/* QL:         jsr     ca_gtint(pc) */
    jsr ca_gtint(pc)
/* QL:         bne.s   pop_4b */
    bne.s pop_4b
/* QL:         subq.l  #1,d3 */
    subq.l #1,d3
/* QL:         blt.s   rts5            no arg, leave default alone */
    blt.s rts5
/* QL:         bne.s   bp_pop          more than one arg, error */
    bne.s bp_pop
/* QL:         move.w  0(a6,a1.l),d7 */
    move.w 0(a6,a1.l),d7
/* QL: popword */
popword:
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         bra.l   put_rip */
    bra.w put_rip
/* QL: bf_fills */
bf_fills:
/* QL:         subq.l  #8,a5           leave off the second parameter for now */
    subq.l #8,a5
/* QL:         bsr.s   code_1          this ensures there are two parameters */
    bsr.s code_1
/* QL:         subq.w  #1,d3           how long was the string? */
    subq.w #1,d3
/* QL:         bgt.s   got_pair        >=2, use first 2 */
    bgt.s got_pair
/* QL:         blt.s   err_bp2         null string is no good */
    blt.s err_bp2
/* QL:         move.w  d5,-(sp) */
    move.w d5,-(sp)
/* QL:         move.b  (sp)+,d5        duplicate a single character */
    move.b (sp)+,d5
/* QL: got_pair */
got_pair:
/* QL:         addq.l  #8,a5           re-include the second parameter */
    addq.l #8,a5
/* QL:         bsr.s   opt_2nd         get the required length (must be there now) */
    bsr.s opt_2nd
/* QL:         bsr.s   room_str        make room for string */
    bsr.s room_str
/* QL: fillit */
fillit:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d5,0(a6,a1.l)   copy 2 chars */
    move.w d5,0(a6,a1.l)
/* QL:         subq.w  #2,d1           repeat filling string */
    subq.w #2,d1
/* QL:         bne.s   fillit */
    bne.s fillit
/* QL:         bra.s   len_put         go put length */
    bra.s len_put
/* QL: * Get a single string (d3=len, d5=0/1/2 chars), leave one word on the stack */
/* QL: code_1 */
code_1:
/* QL:         jsr     ca_gtst1(pc)    get a string */
    jsr ca_gtst1(pc)
/* QL:         bne.s   pop_4b */
    bne.s pop_4b
/* QL:         move.w  d1,d3           get length (returned in d1) */
    move.w d1,d3
/* QL:         move.w  2(a6,a1.l),d5   get first characters */
    move.w 2(a6,a1.l),d5
/* QL:         add.l   d3,a1 */
    add.l d3,a1
/* QL:         btst    d0,d3 */
    btst d0,d3
/* QL:         beq.s   popword */
    beq.s popword
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         bra.s   popword */
    bra.s popword
/* QL: bf_len */
bf_len:
/* QL:         bsr.s   code_1 */
    bsr.s code_1
/* QL: c_null */
c_null:
/* QL:         move.w  d3,d5 */
    move.w d3,d5
/* QL:         bra.s   pushint1 */
    bra.s pushint1
/* QL: bf_code */
bf_code:
/* QL:         bsr.s   code_1 */
    bsr.s code_1
/* QL:         tst.w   d3 */
    tst.w d3
/* QL:         beq.s   c_null          code('') is zero */
    beq.s c_null
/* QL:         lsr.w   #8,d5           just first character is the value */
    lsr.w #8,d5
/* QL:         bra.s   pushint1 */
    bra.s pushint1
/* QL: * Get the maximum size of a given dimension n of an array a (x=dimn(a{,n})) */
/* QL: bf_dimn */
bf_dimn:
/* QL:         moveq   #1,d7           default first dimension */
    moveq #1,d7
/* QL:         bsr.s   opt_2nd         get optional dimension parameter */
    bsr.s opt_2nd
/* QL:         clr.w   d5              if all else fails, return zero */
    clr.w d5
/* QL:         moveq   #t.arr,d1       if it's not an array, i'm not interested */
    moveq #t.arr,d1
/* QL:         sub.b   -8(a6,a3.l),d1  what sort was the first argument? */
    sub.b (-8)(a6,a3.l),d1
/* QL:         bne.s   pushint1        not an array, so say zero, regardless */
    bne.s pushint1
/* QL:         move.l  4-8(a6,a3.l),d1 offset of array descriptor */
    move.l (4-8)(a6,a3.l),d1
/* QL:         bmi.s   pushint1        say zero if not set! (better than error?) */
    bmi.s pushint1
/* QL:         add.l   bv_vvbas(a6),d1 */
    add.l bv_vvbas(a6),d1
/* QL:         cmp.w   4(a6,d1.l),d7   check number of dimensions */
    cmp.w 4(a6,d1.l),d7
/* QL:         bhi.s   pushint1        too many */
    bhi.s pushint1
/* QL:         lsl.w   #2,d7           which one? */
    lsl.w #2,d7
/* QL:         beq.s   pushint1        hmmm... there isn't a zero dimension */
    beq.s pushint1
/* QL:         add.w   d7,d1 */
    add.w d7,d1
/* QL:         move.w  2(a6,d1.l),d5   get max size */
    move.w 2(a6,d1.l),d5
/* QL: pushint1 */
pushint1:
/* QL:         bra.l   pushint0 */
    bra.w pushint0
/* QL:         end */
