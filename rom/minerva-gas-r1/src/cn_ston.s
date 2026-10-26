/* Generated from original/M/cn/ston.asm */
/* QL: * Convert a string to a number */
/* QL:         xdef    cn_dtof,cn_dtoi */
.globl cn_dtof,cn_dtoi
/* QL:         xdef    cn_htoib,cn_htoiw,cn_htoil */
.globl cn_htoib,cn_htoiw,cn_htoil
/* QL:         xdef    cn_btoib,cn_btoiw,cn_btoil */
.globl cn_btoib,cn_btoiw,cn_btoil
/* QL:         xref    ri_add,ri_div,ri_fllin,ri_mult,ri_neg,ri_power,ri_zero */
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
/* QL:         section cn_ston */
.section cn_ston,"ax"
/* QL: * Because too many people expected the old, slack definition of what a floating */
/* QL: * point number can look like, the definition here now accepts a total lack of */
/* QL: * valid digits as a complete number, value zero. */
/* QL: * We now accept: {+|-}{<digitlist>}{.<digitlist>}{{E|e}{+|-}<digitlist>} */
/* QL: * I.e. "." is accepted as zero, as is a null string. */
/* QL: * We also stop the number on a second decimal point, rather than treating that */
/* QL: * as an error. */
/* QL: * d0 -  o- error code */
/* QL: * d7 -i  - points to byte after string (may be a0-1, etc to show as infinite) */
/* QL: * a0 -i o- points to beginning of string in bottom-up buffer */
/* QL: * a1 -i o- points to last pos in top-down arithmetic stack */
/* QL: * d1-d2 destroyed */
/* QL: reglist reg     d3-d6/a0-a1 */
/* QL: put_10 */
put_10:
/* QL:         moveq   #10,d1 */
    moveq #10,d1
/* QL: put_d */
put_d:
/* QL:         jmp     ri_fllin(pc) */
    jmp ri_fllin(pc)
/* QL: * Decimal to floating point */
/* QL: cn_dtof */
cn_dtof:
/* QL:         movem.l reglist,-(sp)   save a0,a1 because i'm going to use 'em */
    movem.l d3-d6/a0-a1,-(sp)
/* QL:         jsr     ri_zero(pc)     push zero onto stack */
    jsr ri_zero(pc)
/* QL:         bsr.l   get_sign        get the sign (if any) */
    bsr.w get_sign
/* QL:         move.w  a0,d5           remember where we start */
    move.w a0,d5
/* QL: decpt */
decpt:
/* QL:         move.w  a0,d4           remember position after decimal point */
    move.w a0,d4
/* QL:         bra.s   nxfchr          enter loop */
    bra.s nxfchr
/* QL: add_fdig */
add_fdig:
/* QL:         bsr.s   put_10          put 10 on stack */
    bsr.s put_10
/* QL:         jsr     ri_mult(pc) */
    jsr ri_mult(pc)
/* QL:         bne.s   cn_errne */
    bne.s cn_errne
/* QL:         move.l  d6,d1 */
    move.l d6,d1
/* QL:         bsr.s   put_d           put new digit on stack */
    bsr.s put_d
/* QL:         jsr     ri_add(pc)      add it to the running total (can't overflow!) */
    jsr ri_add(pc)
/* QL: nxfchr */
nxfchr:
/* QL:         bsr.l   fetch_d         get next digit */
    bsr.w fetch_d
/* QL:         bcs.s   add_fdig        go add digit */
    bcs.s add_fdig
/* QL:         addq.b  #'0'-'.',d6     yes, is it a dot? */
.word 20486|((((48-46))&7)<<9)
/* QL:         bne.s   fp_sgn */
    bne.s fp_sgn
/* QL:         cmp.w   d4,d5           have we already had a decimal point? */
    cmp.w d4,d5
/* QL:         beq.s   decpt           no, so go remember this position */
    beq.s decpt
/* QL: fp_sgn */
fp_sgn:
/* QL:         tst.l   d5              was it negative? */
    tst.l d5
/* QL:         bpl.s   man_ok */
    bpl.s man_ok
/* QL:         jsr     ri_neg(pc)      yes - negate */
    jsr ri_neg(pc)
/* QL: man_ok */
man_ok:
/* QL:         sub.w   d5,d4           was there a decimal point? */
    sub.w d5,d4
/* QL:         beq.s   exp_set         no - exponent set */
    beq.s exp_set
/* QL:         addq.w  #1,d5           allow for decimal point from char count */
    addq.w #1,d5
/* QL:         add.w   d5,d4 */
    add.w d5,d4
/* QL:         sub.w   a0,d4           get -ve decimal places */
    sub.w a0,d4
/* QL: exp_set */
exp_set:
/* QL:         moveq   #0,d3           set e-exponent to zero */
    moveq #0,d3
/* QL:         addq.w  #1,d5           we have moved past the last character */
    addq.w #1,d5
/* QL:         cmp.w   a0,d5           make sure we got at least one digit */
    cmp.w a0,d5
/* QL:         beq.s   nodigs          oops. no digits, go see what we HAVE got */
    beq.s nodigs
/* QL:         cmp.b   #'E'-'.',d6     E (or e)? */
    cmp.b #((69-46)&255),d6
/* QL:         bne.s   exp_end */
    bne.s exp_end
/* QL:         bsr.s   dtoi            yes - read integer into d3 */
    bsr.s dtoi
/* QL:         beq.s   exp_end */
    beq.s exp_end
/* QL:         bne.s   cn_error */
    bne.s cn_error
/* QL: nodigs */
nodigs:
/* QL:         add.l   d5,d5           did we have a sign? */
    add.l d5,d5
/* QL:         bmi.s   cn_bum          yes - that's bad */
    bmi.s cn_bum
/* QL: ; we ONLY accept pure blanks as a valid number (0) */
/* QL: exp_end */
exp_end:
/* QL:         add.w   d3,d4           total power of ten */
    add.w d3,d4
/* QL:         bvs.s   cn_bum          could just happen - we don't want to mess up! */
    bvs.s cn_bum
/* QL:         beq.s   cn_end          if zero, no point raising 10 to it */
    beq.s cn_end
/* QL:         move.w  d4,d5           set exponent sign flag */
    move.w d4,d5
/* QL:         bpl.s   power */
    bpl.s power
/* QL:         neg.w   d4              has to be pos for routine */
    neg.w d4
/* QL: power */
power:
/* QL:         bsr.s   put_10          put 10 on stack */
    bsr.s put_10
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d4,0(a6,a1.l)   put positive power on stack */
    move.w d4,0(a6,a1.l)
/* QL:         jsr     ri_power(pc)    and get 10 to the exp */
    jsr ri_power(pc)
/* QL:         bne.s   cn_error */
    bne.s cn_error
/* QL:         tst.w   d5              negative exponent? */
    tst.w d5
/* QL:         bpl.s   mult */
    bpl.s mult
/* QL:         jsr     ri_div(pc)      yes - calculate number/10^exp */
    jsr ri_div(pc)
/* QL:         bra.s   cn_errne */
    bra.s cn_errne
/* QL: mult */
mult:
/* QL:         jsr     ri_mult(pc)     no - calculate number*10^exp */
    jsr ri_mult(pc)
/* QL: cn_errne */
cn_errne:
/* QL:         bne.s   cn_error */
    bne.s cn_error
/* QL: cn_end */
cn_end:
/* QL:         subq.l  #1,a0           back up over the character we stopped on */
    subq.l #1,a0
/* QL:         movem.l (sp)+,d3-d6     restore the status quo */
    movem.l (sp)+,d3-d6
/* QL:         addq.l  #8,sp           ignore saved a0,a1 */
    addq.l #8,sp
/* QL:         moveq   #0,d0           good return */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: spaces */
spaces:
/* QL:         addq.l  #1,a0           move to next character */
    addq.l #1,a0
/* QL: get_sign */
get_sign:
/* QL:         moveq   #' ',d5         clear flags and set useful value */
    moveq #32,d5
/* QL:         cmp.l   a0,d7           end of string? */
    cmp.l a0,d7
/* QL:         beq.s   rts0            yes - later bits will fail */
    beq.s rts0
/* QL:         cmp.b   0(a6,a0.l),d5   is it a space? */
    cmp.b 0(a6,a0.l),d5
/* QL:         beq.s   spaces */
    beq.s spaces
/* QL:         moveq   #'+',d6         compare char against '+' */
    moveq #43,d6
/* QL:         sub.b   0(a6,a0.l),d6 */
    sub.b 0(a6,a0.l),d6
/* QL:         beq.s   bump */
    beq.s bump
/* QL:         addq.b  #'-'-'+',d6     ... and against '-' */
.word 20486|((((45-43))&7)<<9)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL: bump */
bump:
/* QL:         moveq   #-1,d5          use msw set for either sign seen flag */
    moveq #(-1),d5
/* QL:         roxr.l  #1,d5           set bit 31 for minus sign, bit 30 set if either */
    roxr.l #1,d5
/* QL:         addq.l  #1,a0           remove accepted sign character */
    addq.l #1,a0
/* QL:         rts */
    rts 
/* QL: * Integer conversion */
/* QL: dtoi */
dtoi:
/* QL:         bsr.s   get_sign */
    bsr.s get_sign
/* QL:         bsr.s   fetch_d         fetch first character */
    bsr.s fetch_d
/* QL:         exg     d3,d6           set running total */
    exg d3,d6
/* QL:         bcs.s   in_ent          first must be a digit */
    bcs.s in_ent
/* QL: in_error */
in_error:
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL: cn_bum */
cn_bum:
/* QL:         moveq   #err.xp,d0 */
    moveq #err.xp,d0
/* QL: cn_error */
cn_error:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d3-d6/a0-a1
/* QL:         rts */
    rts 
/* QL: in_accum */
in_accum:
/* QL:         mulu    #10,d3          multiply running total by 10 */
    mulu #10,d3
/* QL:         swap    d3 */
    swap d3
/* QL:         tst.w   d3              make sure nothing creeps into msw */
    tst.w d3
/* QL:         bne.s   in_error */
    bne.s in_error
/* QL:         swap    d3 */
    swap d3
/* QL:         add.l   d6,d3           add digit */
    add.l d6,d3
/* QL: in_ent */
in_ent:
/* QL:         bsr.s   fetch_d         fetch next digit */
    bsr.s fetch_d
/* QL:         bcs.s   in_accum        go accumulate digits */
    bcs.s in_accum
/* QL:         tst.l   d5              is it really negative? */
    tst.l d5
/* QL:         bpl.s   no_neg */
    bpl.s no_neg
/* QL:         neg.l   d3              yes - negate it */
    neg.l d3
/* QL: no_neg */
no_neg:
/* QL:         move.w  d3,d5 */
    move.w d3,d5
/* QL:         ext.l   d5 */
    ext.l d5
/* QL:         sub.l   d3,d5 */
    sub.l d3,d5
/* QL:         bne.s   in_error        must have been out of range */
    bne.s in_error
/* QL:         rts */
    rts 
/* QL: fetch_d */
fetch_d:
/* QL:         moveq   #'0',d6         clear msb's of d6 */
    moveq #48,d6
/* QL:         cmp.l   a0,d7           a0 going off end? */
    cmp.l a0,d7
/* QL:         addq.l  #1,a0           always move on a character */
    addq.l #1,a0
/* QL:         beq.s   clearc          clear carry to show nowt left */
    beq.s clearc
/* QL:         neg.b   d6 */
    neg.b d6
/* QL:         add.b   -1(a6,a0.l),d6  fetch possible digit value */
    add.b (-1)(a6,a0.l),d6
/* QL:         bmi.s   clearc          clear carry and it might be a decimal point */
    bmi.s clearc
/* QL:         cmp.b   #10,d6          is it really a decimal digit */
    cmp.b #(10&255),d6
/* QL:         bcs.s   rts0            yes, then return with carry set to say so */
    bcs.s rts0
/* QL:         and.b   #$df,d6         convert rejects to upper case (hex or exp) */
    and.b #(0xdf&255),d6
/* QL: clearc */
clearc:
/* QL:         and.b   d6,d6           clear carry flag */
    and.b d6,d6
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * Convert decimal string to integer */
/* QL: cn_dtoi */
cn_dtoi:
/* QL:         movem.l reglist,-(sp)   save registers consistent with cn_dtof */
    movem.l d3-d6/a0-a1,-(sp)
/* QL:         bsr.s   dtoi            convert */
    bsr.s dtoi
/* QL:         bne.s   cn_error        bad return */
    bne.s cn_error
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d3,0(a6,a1.l)   good return - put result on stack */
    move.w d3,0(a6,a1.l)
/* QL: cn_end1 */
cn_end1:
/* QL:         bra     cn_end */
    bra cn_end
/* QL: * Hex to byte, word or long integer */
/* QL: cn_htoib */
cn_htoib:
/* QL:         moveq   #2,d2           2 hex characters only */
    moveq #2,d2
/* QL:         bra.s   htoi */
    bra.s htoi
/* QL: cn_htoiw */
cn_htoiw:
/* QL:         moveq   #4,d2           4 hex characters only */
    moveq #4,d2
/* QL:         bra.s   htoi */
    bra.s htoi
/* QL: cn_htoil */
cn_htoil:
/* QL:         moveq   #8,d2           8 hex characters */
    moveq #8,d2
/* QL: htoi */
htoi:
/* QL:         movem.l reglist,-(sp)   save registers consistent with cn_dtof */
    movem.l d3-d6/a0-a1,-(sp)
/* QL:         move.l  d2,d4           put number of bytes in result in d4 */
    move.l d2,d4
/* QL:         lsr.b   #1,d4 */
    lsr.b #1,d4
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.b  d4,1(a6,a1.l)   .. then put on stack */
    move.b d4,1(a6,a1.l)
/* QL:         move.b  #15,0(a6,a1.l)  put maximum digit value on stack */
    move.b #(15&255),0(a6,a1.l)
/* QL:         moveq   #4,d4           put shift in d4 */
    moveq #4,d4
/* QL: hxb_ent */
hxb_ent:
/* QL:         move.l  d2,d5           put maximum character count in d5 */
    move.l d2,d5
/* QL:         moveq   #0,d3           initialise value */
    moveq #0,d3
/* QL: hxb_loop */
hxb_loop:
/* QL:         bsr.s   fetch_d         get next character (digit) */
    bsr.s fetch_d
/* QL:         bcs.s   hxb_add         add this digit */
    bcs.s hxb_add
/* QL:         sub.b   #'A'-'0',d6     check for >= A (or 'a') */
    sub.b #((65-48)&255),d6
/* QL:         blt.s   hxb_end */
    blt.s hxb_end
/* QL:         add.b   #10,d6          set to hex letter value */
    add.b #(10&255),d6
/* QL: hxb_add */
hxb_add:
/* QL:         cmp.b   0(a6,a1.l),d6   check digit against maximum value */
    cmp.b 0(a6,a1.l),d6
/* QL:         bhi.s   hxb_end */
    bhi.s hxb_end
/* QL:         lsl.l   d4,d3           shift number up */
    lsl.l d4,d3
/* QL:         add.l   d6,d3           .. and add next digit */
    add.l d6,d3
/* QL:         dbra    d2,hxb_loop     .. take next digit */
    dbra d2,hxb_loop
/* QL:         bra.s   hxb_err         too many digits */
    bra.s hxb_err
/* QL: hxb_end */
hxb_end:
/* QL:         move.b  1(a6,a1.l),d4   retrieve number of bytes in result */
    move.b 1(a6,a1.l),d4
/* QL:         addq.l  #2,a1           remove maximum digit from stack */
    addq.l #2,a1
/* QL:         move.l  d3,-4(a6,a1.l)  put result on stack */
    move.l d3,(-4)(a6,a1.l)
/* QL:         sub.l   d4,a1           adjust stack pointer for different lengths */
    sub.l d4,a1
/* QL:         cmp.w   d2,d5           check if any digits found */
    cmp.w d2,d5
/* QL:         bgt.s   cn_end1 */
    bgt.s cn_end1
/* QL: hxb_err */
hxb_err:
/* QL:         bra.l   cn_bum */
    bra.w cn_bum
/* QL: * Binary to byte, word or long integer */
/* QL: cn_btoib */
cn_btoib:
/* QL:         moveq   #8,d2           8 bin characters only */
    moveq #8,d2
/* QL:         bra.s   btoi */
    bra.s btoi
/* QL: cn_btoiw */
cn_btoiw:
/* QL:         moveq   #$10,d2         16 bin characters only */
    moveq #0x10,d2
/* QL:         bra.s   btoi */
    bra.s btoi
/* QL: cn_btoil */
cn_btoil:
/* QL:         moveq   #$20,d2         32 bin characters */
    moveq #0x20,d2
/* QL: btoi */
btoi:
/* QL:         movem.l reglist,-(sp)   save registers consistent with cn_dtof */
    movem.l d3-d6/a0-a1,-(sp)
/* QL:         move.l  d2,d4           put number of bytes in result in d4 */
    move.l d2,d4
/* QL:         lsr.b   #3,d4 */
    lsr.b #3,d4
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.b  d4,1(a6,a1.l)   .. then put on stack */
    move.b d4,1(a6,a1.l)
/* QL:         moveq   #1,d4           put shift in d4 */
    moveq #1,d4
/* QL:         move.b  d4,0(a6,a1.l)   .. put maximum value (=shift) on stack */
    move.b d4,0(a6,a1.l)
/* QL:         bra.s   hxb_ent */
    bra.s hxb_ent
/* QL:         end */
