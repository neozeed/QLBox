/* Generated from original/M/ri/add.asm */
/* QL: * Floating point additive routines */
/* QL:         xdef    ri_add,ri_chkov,ri_cmp,ri_doubl,ri_errov */
.globl ri_add,ri_chkov,ri_cmp,ri_doubl,ri_errov
/* QL:         xdef    ri_fllin,ri_float,ri_flong,ri_renrm,ri_sub */
.globl ri_fllin,ri_float,ri_flong,ri_renrm,ri_sub
/* QL:         xref    ri_neg */
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
/* QL: * General comments: */
/* QL: * All routines return d0 as zero, except for sub/add/renrm/doubl, which may */
/* QL: * return with err.ov, and of course errov, in which case an appropriate +/- */
/* QL: * huge value is left as result. */
/* QL: * Conditions codes on return are effectively the result of "tst.l d0". */
/* QL: * Most routines destroy d1/d2, with the exception that cmp and errov may be */
/* QL: * relied on to return with d1 containing the the mantissa of the result, */
/* QL: * doubl only sets d1 if it overflows, and neither errov nor doubl touches d2. */
/* QL: * The only routine that affects anything on the stack, other than where the */
/* QL: * result is put, is sub, which will have negated the original top of stack. */
/* QL: * These used to be clever(sic) in doing multibit shifts to normalise the result */
/* QL: * for add/sub. This was pretty stupid, as the run-of-the-mill such operations */
/* QL: * will result in numbers not wildly differring from the one with the larger */
/* QL: * exponent. It is still valid to be clever when called specificly to do */
/* QL: * renormalisations, as these probably do have more bits to tidy up. */
/* QL:         section ri_add */
.section ri_add,"ax"
/* QL: * d0 -  o- 0 or err.ov (ccr set) */
/* QL: * a1 -i o- pointer to arithmetic stack, six added */
/* QL: * d1-d2 destroyed */
/* QL: ri_sub  ;...,a1:b(float),a(float),... ==> ...,-b(float),a1:a-b(float),... */
ri_sub:
/* QL:         jsr     ri_neg(pc)      negate b - no error exit */
    jsr ri_neg(pc)
/* QL: ri_add  ;...,a1:b(float),a(float),... ==> ...,b(float),a1:a+b(float),... */
ri_add:
/* QL:         addq.l  #6,a1           only one return arg */
    addq.l #6,a1
/* QL:         move.l  2(a6,a1.l),d1   get a mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         move.l  -4(a6,a1.l),d0  get b mantissa */
    move.l (-4)(a6,a1.l),d0
/* QL:         move.w  0(a6,a1.l),d2   get a exponent */
    move.w 0(a6,a1.l),d2
/* QL:         sub.w   -6(a6,a1.l),d2  subtract b exponent from a exponent (if z, x=0) */
    sub.w (-6)(a6,a1.l),d2
/* QL:         bge.s   expok           if aexp >= bexp, keep it */
    bge.s expok
/* QL:         neg.w   d2              make shift positive */
    neg.w d2
/* QL:         add.w   d2,0(a6,a1.l)   change aexp to be bexp */
    add.w d2,0(a6,a1.l)
/* QL:         exg     d0,d1           swap over mantissae */
    exg d0,d1
/* QL: expok */
expok:
/* QL:         cmp.w   #32,d2          check downshift */
    cmp.w #32,d2
/* QL:         bgt.s   addput          if too large, just (re)store mantissa */
    bgt.s addput
/* QL:         asr.l   d2,d0           shift down (note: if d2=0, x=0 already) */
    asr.l d2,d0
/* QL:         subx.l  d2,d2           remember the rounding we're using */
    subx.l d2,d2
/* QL:         addx.l  d0,d1           add mantissae, and rounding */
    addx.l d0,d1
/* QL:         bvs.s   addvs           if v is set, we modify rounding and downshift */
    bvs.s addvs
/* QL:         move.l  d1,2(a6,a1.l)   store the result, with luck, it's ok now */
    move.l d1,2(a6,a1.l)
/* QL:         add.l   d1,d1           check if number really is already normalised */
    add.l d1,d1
/* QL:         bvs.s   rtsok           if so, we can skip out this instant */
    bvs.s rtsok
/* QL:         move.w  0(a6,a1.l),d0   get current exponent */
    move.w 0(a6,a1.l),d0
/* QL:         beq.s   rtsok           if both a and b were unnormal, all done */
    beq.s rtsok
/* QL:         add.l   d2,d1           put back any rounding we may have used, as lsb */
    add.l d2,d1
/* QL:         bvc.s   addvc           we can have $80000000+$ffffffff */
    bvc.s addvc
/* QL:         addq.l  #1,d1           if so, restore the $80000000, it's better */
    addq.l #1,d1
/* QL: addvc */
addvc:
/* QL:         bne.s   addnlp          if not pure zero, go to normalise it */
    bne.s addnlp
/* QL:         moveq   #1,d0           force drop out of loop */
    moveq #1,d0
/* QL: addnlp */
addnlp:
/* QL:         subq.w  #1,d0 */
    subq.w #1,d0
/* QL:         beq.s   addend          stick at zero exponent, maybe unnormal result */
    beq.s addend
/* QL:         add.l   d1,d1           try for more normalisation */
    add.l d1,d1
/* QL:         bvc.s   addnlp          if there is, keep winding down the exponent */
    bvc.s addnlp
/* QL:         roxr.l  #1,d1           we overshot normalising, so roll back */
    roxr.l #1,d1
/* QL: addend */
addend:
/* QL:         move.w  d0,0(a6,a1.l)   store the exponent */
    move.w d0,0(a6,a1.l)
/* QL: addput */
addput:
/* QL:         move.l  d1,2(a6,a1.l)   store the result */
    move.l d1,2(a6,a1.l)
/* QL: rtsok */
rtsok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: addvs */
addvs:
/* QL:         roxr.l  #1,d1           put result back down */
    roxr.l #1,d1
/* QL: * Four possibilities: */
/* QL: * x=0 d2=0  q0.0 fine, we didn't round and lsb was zero anyway */
/* QL: * x=0 d2=-1 q1.1 fine, we have already rounded according to next bit */
/* QL: * x=1 d2=0  q1.0 bad! we still need to round up by one */
/* QL: * x=1 d2=-1 q0.1 fine, no rounding was needed, and we just scrapped it anyway */
/* QL:         bcc.s   chovflw */
    bcc.s chovflw
/* QL:         addx.l  d2,d1 */
    addx.l d2,d1
/* QL: * Note: if d2=-1, it cancels the x=1, and we're OK */
/* QL: * If d2=0, we round up, but the worst case we could have is $7fffffff+$7ffffffe */
/* QL: * -> (x=0)$fffffffd -> $7ffffffe(x=1) -> $7fffffff, so it never overflows. */
/* QL: chovflw */
chovflw:
/* QL:         move.l  d1,2(a6,a1.l)   store result mantissa */
    move.l d1,2(a6,a1.l)
/* QL: * Double floating point value at top of stack. */
/* QL: * d0 -  o- 0 if no problem, err.ov if exponent out of range 0..$FFF, ccr set */
/* QL: * d1 -  o- unchanged if not overflow, else result mantissa */
/* QL: * a1 -ip - pointer to float to be doubled */
/* QL: ri_doubl */
ri_doubl:
/* QL:         addq.w  #1,0(a6,a1.l)   add one to exponent */
    addq.w #1,0(a6,a1.l)
/* QL: * This does a proper check for overflow. */
/* QL: * d0 -  o- 0 if no problem, err.ov if exponent out of range 0..$FFF, ccr set */
/* QL: * d1 -  o- unchanged if not overflow, else result mantissa */
/* QL: * a1 -ip - RI stack pointer, value replaced by large result on overflow */
/* QL: ri_chkov */
ri_chkov:
/* QL:         moveq   #-16,d0         mask $f0 */
    moveq #(-16),d0
/* QL:         and.b   0(a6,a1.l),d0   is exponent now out of range? */
    and.b 0(a6,a1.l),d0
/* QL:         beq.s   rtsok           nope, that's what we hoped */
    beq.s rtsok
/* QL:         ;       we could've allowed min -> max exp like ri_neg, but ... */
/* QL: * This routine replaces the top element of the stack with a maximum value of */
/* QL: * the same sign as was there. It always comes back with err.ov. The usage of */
/* QL: * this, instead of just bombing out on an overflow error, means that callers */
/* QL: * who happen not to check all error returns will likely get away with the odd */
/* QL: * occasion of an overflow error. Also, the top of stack will never get silly. */
/* QL: * d0.l is err.ov, d1.l is the maximum mantissa which has been stored. */
/* QL: ri_errov */
ri_errov:
/* QL:         asl     2(a6,a1.l)      was it positive or negative? */
    asl 2(a6,a1.l)
/* QL:         subx.l  d1,d1           x/d0.l = 0/00000000 or 1/ffffffff */
    subx.l d1,d1
/* QL:         not.l   d1              x/d0.l = 0/ffffffff or 1/00000000 */
    not.l d1
/* QL:         roxr.l  #1,d1           x/d0.l = 1/7fffffff or 0/80000000 */
    roxr.l #1,d1
/* QL:         move.l  d1,2(a6,a1.l)   store the maximum mantissa */
    move.l d1,2(a6,a1.l)
/* QL:         move.w  #$fff,0(a6,a1.l) maximum exponent */
    move.w #0xfff,0(a6,a1.l)
/* QL:         moveq   #err.ov,d0 */
    moveq #err.ov,d0
/* QL:         rts */
    rts 
/* QL: * Float a short integer which is on the stack */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * a1 -i o- pointer to arithmetic stack, four subtracted */
/* QL: * d1-d2 destroyed */
/* QL: ri_float;...,?(long),a1:a(short),... ==> ...,a1:a(float),... */
ri_float:
/* QL:         move.l  0(a6,a1.l),d1   fetch integer and junk */
    move.l 0(a6,a1.l),d1
/* QL:         move.w  #$80f,d0        set exponent */
    move.w #0x80f,d0
/* QL: dropjunk */
dropjunk:
/* QL:         clr.w   d1              scrap junk */
    clr.w d1
/* QL: setshft */
setshft:
/* QL:         subq.l  #4,a1           space for result */
    subq.l #4,a1
/* QL:         move.l  d1,d2           duplicate mantissa */
    move.l d1,d2
/* QL:         beq.s   minexp          ah! zero mantissa */
    beq.s minexp
/* QL:         asl.l   #8,d2           try eight bit shift */
    asl.l #8,d2
/* QL:         bvc.s   did8            that worked, so go try 4 using d2 as source */
    bvc.s did8
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         asl.l   #4,d2 */
    asl.l #4,d2
/* QL:         bvc.s   did4            go try two bit shift on d2 */
    bvc.s did4
/* QL: try2 */
try2:
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         asl.l   #2,d2 */
    asl.l #2,d2
/* QL:         bvc.s   did2            go try single bit shift on d2 */
    bvc.s did2
/* QL: try1 */
try1:
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         add.l   d2,d2 */
    add.l d2,d2
/* QL:         bvc.s   did1            go finish off copying d2 into d1 */
    bvc.s did1
/* QL:         bra.s   stack */
    bra.s stack
/* QL: did8 */
did8:
/* QL:         subq.w  #8,d0           successful eight bit shift */
    subq.w #8,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         asl.l   #4,d2 */
    asl.l #4,d2
/* QL:         bvs.s   try2 */
    bvs.s try2
/* QL: did4 */
did4:
/* QL:         subq.w  #4,d0           successful four bit shift */
    subq.w #4,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         asl.l   #2,d2 */
    asl.l #2,d2
/* QL:         bvs.s   try1 */
    bvs.s try1
/* QL: did2 */
did2:
/* QL:         subq.w  #2,d0           successful two bit shift */
    subq.w #2,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         add.l   d2,d2 */
    add.l d2,d2
/* QL:         bvs.s   stack */
    bvs.s stack
/* QL: did1 */
did1:
/* QL:         subq.w  #1,d0           successful one bit shift */
    subq.w #1,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL: stack */
stack:
/* QL:         move.w  d0,0(a6,a1.l)   put exponent on */
    move.w d0,0(a6,a1.l)
/* QL:         move.l  d1,2(a6,a1.l)   put mantissa on */
    move.l d1,2(a6,a1.l)
/* QL:         moveq   #0,d0           good return */
    moveq #0,d0
/* QL: rtsrnrm */
rtsrnrm:
/* QL:         rts */
    rts 
/* QL: * Renormalise a value from registers and put it onto the stack */
/* QL: * d0 -i o- exponent in lsw / 0 or err.ov if result overflows (ccr set) */
/* QL: * d1 -i  - mantissa */
/* QL: * a1 -i o- stack pointer, six subtracted */
/* QL: * d2 destroyed */
/* QL: ri_renrm;...,?(float),a1:,... ==> ...,a1:a(float),... */
ri_renrm:
/* QL:         bsr.s   renrm           nest down to renormalise as ... */
    bsr.s renrm
/* QL:         move.b  0(a6,a1.l),d0   ... only here can we end up with duff exponent */
    move.b 0(a6,a1.l),d0
/* QL:         asr.b   #4,d0 */
    asr.b #4,d0
/* QL:         bgt.s   ri_errov */
    bgt.s ri_errov
/* QL:         beq.s   rtsrnrm */
    beq.s rtsrnrm
/* QL:         move.w  0(a6,a1.l),d0   underflow, so we have to pick up exponent again */
    move.w 0(a6,a1.l),d0
/* QL:         neg.w   d0              what a tiny number */
    neg.w d0
/* QL:         asr.l   d0,d1           move mantissa by underflow amount */
    asr.l d0,d1
/* QL: minexp */
minexp:
/* QL:         moveq   #0,d0           set exponent to zero */
    moveq #0,d0
/* QL:         bra.s   stack */
    bra.s stack
/* QL: * Float a long integer, input and result on the stack */
/* QL: * d0 -i o- 0 (ccr set) */
/* QL: * a1 -i o- stack pointer, two subtracted */
/* QL: * d1/d2 destroyed */
/* QL: ri_flong;...,?(word),a1:a(long),... ==> ...,a1:a(float),... */
ri_flong:
/* QL:         move.l  0(a6,a1.l),d1   fetch long integer */
    move.l 0(a6,a1.l),d1
/* QL:         addq.l  #4,a1           drop it for now */
    addq.l #4,a1
/* QL: * Float a long integer from a register onto the stack */
/* QL: * d0 -i o- 0 (ccr set) */
/* QL: * d1 -i  - mantissa */
/* QL: * a1 -i o- stack pointer, six subtracted */
/* QL: * d2 destroyed */
/* QL: ri_fllin;...,?(float),a1:,... ==> ...,a1:a(float),... */
ri_fllin:
/* QL:         move.w  #$81f,d0        set exponent */
    move.w #0x81f,d0
/* QL: renrm */
renrm:
/* QL:         subq.l  #2,a1           make room like an integer */
    subq.l #2,a1
/* QL:         move.l  d1,d2           take a copy */
    move.l d1,d2
/* QL:         ext.l   d2              extend to long */
    ext.l d2
/* QL:         cmp.l   d1,d2           did that change it? */
    cmp.l d1,d2
/* QL:         bne.s   setshft         yes - go start little shifts */
    bne.s setshft
/* QL:         sub.w   #16,d0          no - knock sixteen of exponent ... */
    sub.w #16,d0
/* QL:         swap    d1              ... swap single word to msw ... */
    swap d1
/* QL:         bra.s   dropjunk        ... and go on like an integer */
    bra.s dropjunk
/* QL: * ri_cmp simplifies, speeds up, and makes consistent, floating point compares. */
/* QL: * It expects two fp values on the stack, and leaves only one. This is similar */
/* QL: * to ri_sub, but the value left is arranged to make determination of the */
/* QL: * comparison result very easy. */
/* QL: * In essence, the value left will be zero for identical equality, negative for */
/* QL: * a < b or positive for a > b. The absolute value of the result will be */
/* QL: * approximate the condition abs(a-b) > max(abs(a),abs(b)) / 1e7, i.e. the */
/* QL: * result will be +/-1 if the comparison is pretty definate, +/- a tiny value if */
/* QL: * we have a == b but not a = b, and zero iff a is exactly equal to b (a = b). */
/* QL: * The actual bytes stored are arranged for easy tests as follows: */
/* QL: *       a < b and not a == b    08 00 80 00 00 00 */
/* QL: *           a < b and a == b    00 00 80 00 00 00 */
/* QL: *                      a = b    00 00 00 00 00 00 */
/* QL: *           a > b and a == b    00 01 40 00 00 00 */
/* QL: *       a > b and not a == b    08 01 40 00 00 00 */
/* QL: * Thus testing the msb of the exponent establishes approximate equality if it */
/* QL: * is zero, and testing the msb of the mantissa is used in all other cases. */
/* QL: * Registers... */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * d1 -  o- mantissa of result */
/* QL: * a1 -i o- stack pointer, six subtracted */
/* QL: * d2 destroyed */
/* QL: ri_cmp;...,a1:b(float),a(float),... ==> ...,b(float),a1:sgn(a-b)ish(float),... */
ri_cmp:
/* QL:         addq.l  #6,a1           set stack ready for exit */
    addq.l #6,a1
/* QL:         move.w  0(a6,a1.l),d2   get a exponent */
    move.w 0(a6,a1.l),d2
/* QL:         clr.w   0(a6,a1.l)      wipe it out */
    clr.w 0(a6,a1.l)
/* QL:         move.l  2(a6,a1.l),d0   get a mantissa */
    move.l 2(a6,a1.l),d0
/* QL:         bne.s   anz */
    bne.s anz
/* QL: * a is zero, therefore we need only consider the sign, and zero-ness of b */
/* QL:         move.l  -4(a6,a1.l),d1  how is b? */
    move.l (-4)(a6,a1.l),d1
/* QL:         beq.s   ret0            if it's zero, we only need to get out now (0=0) */
    beq.s ret0
/* QL:         bpl.s   msbexp          if it's positive, a < b (0<+ve) */
    bpl.s msbexp
/* QL: setagb */
setagb:
/* QL:         addq.b  #1,1(a6,a1.l)   set the "a > b" bit */
    addq.b #1,1(a6,a1.l)
/* QL: msbexp */
msbexp:
/* QL:         addq.b  #8,0(a6,a1.l)   set the "not a == b" bit */
    addq.b #8,0(a6,a1.l)
/* QL: msbman */
msbman:
/* QL:         moveq   #2,d1           2 */
    moveq #2,d1
/* QL:         sub.b   1(a6,a1.l),d1   (1/2) did we set "a > b"? */
    sub.b 1(a6,a1.l),d1
/* QL:         ror.l   #2,d1           $40000000/$80000000 */
    ror.l #2,d1
/* QL: setman */
setman:
/* QL:         move.l  d1,2(a6,a1.l)   store mantissa */
    move.l d1,2(a6,a1.l)
/* QL: ret0 */
ret0:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Right, a isn't zero, so we'll see what b looks like */
/* QL: anz */
anz:
/* QL:         move.l  -4(a6,a1.l),d1  pick up b mantissa */
    move.l (-4)(a6,a1.l),d1
/* QL:         bne.s   bnz */
    bne.s bnz
/* QL: btozero */
btozero:
/* QL:         tst.l   d0              if b is 0 direction from a, check a's sign */
    tst.l d0
/* QL:         bpl.s   setagb          if positive set a > b (big+ve>little+ve,0,-ve) */
    bpl.s setagb
/* QL:         bra.s   msbexp          if negative leave it (big-ve<little-ve,0,+ve) */
    bra.s msbexp
/* QL: * Neither a or b is zero, so see if a and b differ in sign */
/* QL: bnz */
bnz:
/* QL:         eor.l   d0,d1           temporarily flip b */
    eor.l d0,d1
/* QL:         bmi.s   btozero         their sign's differ, go set accordingly */
    bmi.s btozero
/* QL:         eor.l   d0,d1           put b back normal */
    eor.l d0,d1
/* QL: * Now we're getting down to the nitty-gritty bits. Have to look at exponents */
/* QL:         sub.w   -6(a6,a1.l),d2  calculate exp(a) - exp(b) */
    sub.w (-6)(a6,a1.l),d2
/* QL:         bne.s   shuff           not the same, so we haven't got exact equals */
    bne.s shuff
/* QL:         sub.l   d0,d1           are they exactly the same? */
    sub.l d0,d1
/* QL:         beq.s   setman          yes - that's exact equality finished with */
    beq.s setman
/* QL: bitgame */
bitgame:
/* QL:         bgt.s   bitlook         if a < b leave that (nb see below why bgt test) */
    bgt.s bitlook
/* QL:         addq.b  #1,1(a6,a1.l)   set the "a > b" bit */
    addq.b #1,1(a6,a1.l)
/* QL:         not.l   d1              now difference is positive */
    not.l d1
/* QL: bitlook */
bitlook:
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         lsr.l   #8,d2           are difference bits 31 to 8 all zero? */
    lsr.l #8,d2
/* QL:         bne.s   msbexp          no - then go set not == */
    bne.s msbexp
/* QL:         mulu    #39063,d1       multiply by 1e7/256 (exact is 39062.5) */
    mulu #39063,d1
/* QL:         asl.l   #8,d1           did any bits get right into the top? */
    asl.l #8,d1
/* QL:         bvs.s   msbexp          yes - then set not == */
    bvs.s msbexp
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bpl.s   okbig */
    bpl.s okbig
/* QL:         not.l   d0              saves checking for overflow, and is good enuff */
    not.l d0
/* QL: okbig */
okbig:
/* QL:         cmp.l   d0,d1           finally compare them */
    cmp.l d0,d1
/* QL:         bge.s   msbexp          if abs(a-b)*1e7 >= abs(b or a), set not == */
    bge.s msbexp
/* QL:         bra.s   msbman          otherwise, leave == */
    bra.s msbman
/* QL: shuff */
shuff:
/* QL:         subq.w  #1,d2           is exp(a) > exp(b) + 1? */
    subq.w #1,d2
/* QL:         bgt.s   btozero         yes, then set result according to sign */
    bgt.s btozero
/* QL:         beq.s   shft            if exp(a) = exp(b) + 1, go do shift */
    beq.s shft
/* QL:         exg     d0,d1           swap over a and b */
    exg d0,d1
/* QL:         not.l   d0              and invert both */
    not.l d0
/* QL:         not.l   d1              which will be good enough for our purposes */
    not.l d1
/* QL:         addq.w  #2,d2           is exp(a) < exp(b) - 1? */
    addq.w #2,d2
/* QL:         bne.s   btozero         yes, once again the sign is the answer */
    bne.s btozero
/* QL: shft */
shft:
/* QL:         asr.l   #1,d1           shift down the smaller exponent */
    asr.l #1,d1
/* QL:         sub.l   d0,d1           how do they compare? */
    sub.l d0,d1
/* QL:         bra.s   bitgame         nb test up there is bgt, so lost carry is ok */
    bra.s bitgame
/* QL:         end */
