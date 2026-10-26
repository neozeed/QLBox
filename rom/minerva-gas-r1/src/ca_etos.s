/* Generated from original/M/ca/etos.asm */
/* QL: * Evaluate top of stack */
/* QL:         xdef    ca_etos,ca_putss,ca_undo */
.globl ca_etos,ca_putss,ca_undo
/* QL:         xref    bv_chrix,bv_frvv */
/* QL:         xref    mm_mrtor */
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
/* QL:         section ca_etos */
.section ca_etos,"ax"
/* QL: * Evaluate current top of stack, guaranteeing a result on the RI stack. */
/* QL: * There is a problem to resolve here... is a1 guaranteed to match bv_rip on */
/* QL: * entry? This rather assumes so in some cases, but not in others! */
/* QL: * A similar problem crops up with a5, and usage of ca_undo... */
/* QL: * d0 -  o- error return code */
/* QL: * a1 -i o- pointer to arithmetic stack */
/* QL: * a5 -i o- pointer to name table */
/* QL: * d1-d2/a4 destroyed */
/* QL: ca_etos */
ca_etos:
/* QL:         and.b   #15,-7(a6,a5.l) mask any seps which may have crept in */
    and.b #(15&255),(-7)(a6,a5.l)
/* QL:         assert  2,2&t.var&t.arr&t.rep&t.for */
/* original assertion: 2,2&t.var&t.arr&t.rep&t.for */
/* QL:         assert  0,2&(t.unset!t.intern!t.bpr!t.bfn!t.mcp!t.mcf) */
/* original assertion: 0,2&(t.unset!t.intern!t.bpr!t.bfn!t.mcp!t.mcf) */
/* QL:         assert  64,t.intern<<6,256-t.arr<<6 */
/* original assertion: 64,t.intern<<6,256-t.arr<<6 */
/* QL:         moveq   #64,d0          for sorting out intern/arry */
    moveq #64,d0
/* QL:         move.b  -8(a6,a5.l),d1  look at msb of variable type */
    move.b (-8)(a6,a5.l),d1
/* QL:         ror.b   #2,d1 */
    ror.b #2,d1
/* QL:         bcc.s   qintern         divide into two sets */
    bcc.s qintern
/* QL:         add.b   d1,d0 */
    add.b d1,d0
/* QL:         beq.s   put_arry        array */
    beq.s put_arry
/* QL: put_item */
put_item:
/* QL:         move.l  -4(a6,a5.l),d1  get vv offset */
    move.l (-4)(a6,a5.l),d1
/* QL:         blt.s   ets_err         no value, that's an error */
    blt.s ets_err
/* QL:         move.l  d1,a4 */
    move.l d1,a4
/* QL:         add.l   bv_vvbas(a6),a4 make into rel a6 */
    add.l bv_vvbas(a6),a4
/* QL:         cmp.b   #t.fp,-7(a6,a5.l) check type */
    cmp.b #(t.fp&255),(-7)(a6,a5.l)
/* QL:         bne.s   put_qs          not floating point */
    bne.s put_qs
/* QL: put_fp */
put_fp:
/* QL:         moveq   #6,d1           put a floating point (6 bytes) */
    moveq #6,d1
/* QL:         bsr.s   chk_ri          make room */
    bsr.s chk_ri
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) move mantissa */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL:         bra.s   ets_wrd */
    bra.s ets_wrd
/* QL: qintern */
qintern:
/* QL:         sub.b   d1,d0 */
    sub.b d1,d0
/* QL:         beq.s   ets_exit        if internal it's already on RI stack */
    beq.s ets_exit
/* QL: ets_err */
ets_err:
/* QL:         moveq   #1,d2           undo anything */
    moveq #1,d2
/* QL:         bsr.l   ca_undo         remove the offending entry */
    bsr.w ca_undo
/* QL:         move.l  a5,bv_ntp(a6)   and reset the NT pointer */
    move.l a5,bv_ntp(a6)
/* QL:         moveq   #err.xp,d0 */
    moveq #err.xp,d0
/* QL:         rts */
    rts 
/* QL: moreri */
moreri:
/* QL:         move.l  d1,a1 */
    move.l d1,a1
/* QL:         jsr     bv_chrix(pc)    make room */
    jsr bv_chrix(pc)
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL: chk_ri */
chk_ri:
/* QL:         move.l  bv_rip(a6),a1   set arithmetic stack pointer */
    move.l bv_rip(a6),a1
/* QL:         sub.l   d1,a1 */
    sub.l d1,a1
/* QL:         cmp.l   bv_rip-4(a6),a1 */
    cmp.l (bv_rip-4)(a6),a1
/* QL:         blt.s   moreri */
    blt.s moreri
/* QL:         rts */
    rts 
/* QL: put_qs */
put_qs:
/* QL:         blt.s   putst           go if item is a string */
    blt.s putst
/* QL:         moveq   #2,d1           put an integer (2 bytes) */
    moveq #2,d1
/* QL:         bsr.s   chk_ri */
    bsr.s chk_ri
/* QL: ets_wrd */
ets_wrd:
/* QL:         move.w  0(a6,a4.l),d1 */
    move.w 0(a6,a4.l),d1
/* QL:         move.b  #t.intern,-8(a6,a5.l) internal now */
    move.b #(t.intern&255),(-8)(a6,a5.l)
/* QL: ets_put */
ets_put:
/* QL:         move.w  d1,0(a6,a1.l)  put integer (fp exponent) on RI stack */
    move.w d1,0(a6,a1.l)
/* QL: ets_exit */
ets_exit:
/* QL:         move.l  a1,bv_rip(a6)   save arithmetic stack pointer */
    move.l a1,bv_rip(a6)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: put_arry */
put_arry:
/* QL:         move.l  -4(a6,a5.l),d1  fetch address of array descriptor */
    move.l (-4)(a6,a5.l),d1
/* QL:         add.l   bv_vvbas(a6),d1 absolute */
    add.l bv_vvbas(a6),d1
/* QL:         move.l  0(a6,d1.l),a4   find base address of array */
    move.l 0(a6,d1.l),a4
/* QL:         add.l   bv_vvbas(a6),a4 absolute */
    add.l bv_vvbas(a6),a4
/* QL:         movem.w 4(a6,d1.l),d0/d2 get dimensions and possible substring length */
    movem.w 4(a6,d1.l),d0/d2
/* QL:         subq.w  #1,d0           array must be one dimensional */
    subq.w #1,d0
/* QL:         bgt.s   ets_err */
    bgt.s ets_err
/* QL:         move.b  -7(a6,a5.l),d0  it must be a (sub)string */
    move.b (-7)(a6,a5.l),d0
/* QL:         subq.b  #t.str,d0       check this */
    subq.b #t.str,d0
/* QL:         bgt.s   ets_err */
    bgt.s ets_err
/* QL:         bsr.s   fr_des          discard descriptor */
    bsr.s fr_des
/* QL:         exg     d2,d1           put possible substring length in right reg */
    exg d2,d1
/* QL:         bne.s   putss           it is a substring */
    bne.s putss
/* QL: putst */
putst:
/* QL:         move.w  0(a6,a4.l),d1   find length of string (assumed non-negative) */
    move.w 0(a6,a4.l),d1
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL: putss */
putss:
/* QL:         move.w  #t.intern<<8!t.str,-8(a6,a5.l) becoming internal string now */
    move.w #((t.intern<<8)|t.str),(-8)(a6,a5.l)
/* QL: * Puts a sub-string on the RI stack. */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- string length in lsw (if negative, made 0. msw destroyed) */
/* QL: * a1 -  o- RI stack */
/* QL: * a4 -i  - pointer to string characters (may be odd). */
/* QL: * d2 destroyed */
/* QL: ca_putss */
ca_putss:
/* QL:         ext.l   d1              want it long */
    ext.l d1
/* QL: * We don't really expect to be called with a negative length... */
/* QL: *       bpl.s   put_lok */
/* QL: *       moveq   #0,d1           just to be realy safe (lwr) */
/* QL: *put_lok */
/* QL:         addq.l  #2,d1           extra to store length and rely on even pointers */
    addq.l #2,d1
/* QL:         bsr.s   chk_ri */
    bsr.s chk_ri
/* QL:         subq.l  #2,d1           restore string length */
    subq.l #2,d1
/* QL:         beq.s   ets_put         nothing to copy */
    beq.s ets_put
/* QL:         moveq   #1,d2 */
    moveq #1,d2
/* QL:         and.b   d1,d2 */
    and.b d1,d2
/* QL:         sub.l   d2,a1           this is where it's going */
    sub.l d2,a1
/* QL:         add.l   d1,d2           length rounded up to even */
    add.l d1,d2
/* QL:         subq.l  #2,d2           check for 1/2 bytes only */
    subq.l #2,d2
/* QL:         bne.s   put_sg2         not just an odd one or two bytes */
    bne.s put_sg2
/* QL:         move.b  0(a6,a4.l),d2   get first byte */
    move.b 0(a6,a4.l),d2
/* QL:         rol.w   #8,d2           put it in msw */
    rol.w #8,d2
/* QL:         move.b  1(a6,a4.l),d2   get second byte, or junk */
    move.b 1(a6,a4.l),d2
/* QL:         move.w  d2,2(a6,a1.l)   put byte pair (we've allowed for 'ab'(2)) */
    move.w d2,2(a6,a1.l)
/* QL:         bra.s   ets_put         finished */
    bra.s ets_put
/* QL: * The above can be extended to cope with 1..4 bytes, should it seem too slow. */
/* QL: put_sg2 */
put_sg2:
/* QL:         exg     a0,a1           want destination in a0 */
    exg a1,a0
/* QL:         exg     a4,a1           want source in a1 */
    exg a1,a4
/* QL:         addq.l  #2,a0 */
    addq.l #2,a0
/* QL:         jsr     mm_mrtor(pc)    use the fast move */
    jsr mm_mrtor(pc)
/* QL:         subq.l  #2,a0 */
    subq.l #2,a0
/* QL:         exg     a4,a1 */
    exg a1,a4
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         bra.s   ets_put */
    bra.s ets_put
/* QL: * Free a string descriptor */
/* QL: * ccr-  o- result of "tst.l d0" */
/* QL: * d1 -i  - pointer to decriptor */
/* QL: fr_des */
fr_des:
/* QL:         move.l  a0,-(sp) */
    move.l a0,-(sp)
/* QL:         move.l  d1,a0           free from here */
    move.l d1,a0
/* QL:         moveq   #4+2+2+2,d1     this much space */
    moveq #(((4+2)+2)+2),d1
/* QL:         jsr     bv_frvv(pc) */
    jsr bv_frvv(pc)
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         rts */
    rts 
/* QL: * Undoes an entry on the name table and RI stack. */
/* QL: * z  -  o- if d2.l is zero, z is set iff a t.intern gets undone */
/* QL: * d2 -ip - longword flag zero, only undo t.intern, or non-zero, undo anything */
/* QL: * a5 -i o- NT stack */
/* QL: * d1 destroyed */
/* QL: ca_undo */
ca_undo:
/* QL:         moveq   #t.intern,d1 */
    moveq #t.intern,d1
/* QL:         sub.b   -8(a6,a5.l),d1 */
    sub.b (-8)(a6,a5.l),d1
/* QL:         beq.s   undo_int */
    beq.s undo_int
/* QL:         tst.l   d2              do non-int or stop at them? */
    tst.l d2
/* QL:         beq.s   ret_undo        stop */
    beq.s ret_undo
/* QL:         addq.b  #t.arr-t.intern,d1 do them */
.word 20481|((((t.arr-t.intern))&7)<<9)
/* QL:         bne.s   nxt_un          if not an array, kill it off */
    bne.s nxt_un
/* QL:         move.l  -4(a6,a5.l),d1  where is the copy descriptor? */
    move.l (-4)(a6,a5.l),d1
/* QL:         bmi.s   nxt_un          isn't one */
    bmi.s nxt_un
/* QL:         add.l   bv_vvbas(a6),d1 */
    add.l bv_vvbas(a6),d1
/* QL:         bsr.s   fr_des          go and free the descriptor */
    bsr.s fr_des
/* QL:         bra.s   nxt_un */
    bra.s nxt_un
/* QL: undo_int */
undo_int:
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   -7(a6,a5.l),d1 */
    and.b (-7)(a6,a5.l),d1
/* QL:         add.b   d1,d1           this is neatly ready for (t.int-t.fp)*2 = 2 */
    add.b d1,d1
/* QL:         subq.b  #t.fp*2,d1      what is the variable type? */
    subq.b #(t.fp*2),d1
/* QL:         bgt.s   int_int         integer */
    bgt.s int_int
/* QL:         beq.s   int_fp          floating point */
    beq.s int_fp
/* QL:         move.l  bv_rip(a6),d1 */
    move.l bv_rip(a6),d1
/* QL:         move.w  0(a6,d1.l),d1 */
    move.w 0(a6,d1.l),d1
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         subq.l  #6-3,d1 */
.word 20865|((((6-3))&7)<<9)
/* QL:         bclr    #0,d1           length of string + 2 for len and evened */
    bclr #0,d1
/* QL: int_fp */
int_fp:
/* QL:         addq.l  #6,d1           + 6 for fp */
    addq.l #6,d1
/* QL: int_int */
int_int:
/* QL:         add.l   d1,bv_rip(a6)   also, guarantee non-z on return */
    add.l d1,bv_rip(a6)
/* QL: nxt_un */
nxt_un:
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL: ret_undo */
ret_undo:
/* QL:         rts */
    rts 
/* QL:         end */
