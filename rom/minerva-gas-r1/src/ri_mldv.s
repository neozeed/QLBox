/* Generated from original/M/ri/mldv.asm */
/* QL: * multiplication and division */
/* QL:         xdef    ri_div,ri_mult,ri_rdiv,ri_recip,ri_squar */
.globl ri_div,ri_mult,ri_rdiv,ri_recip,ri_squar
/* QL:         xref    ri_dup,ri_errov,ri_one,ri_swap */
/* QL:         section ri_mldv */
.section ri_mldv,"ax"
/* QL: * Multiplication and division routines: */
/* QL: * On entry: */
/* QL: *  (a6,a1.l) - b exponent/mantissa */
/* QL: * 6(a6,a1.l) - a exponent/mantissa */
/* QL: * On return, b will be totally unchanged, but the result (a*b or a/b) will have */
/* QL: * replaced a and will now be top of the stack (a1 will have had 6 added). */
/* QL: * Square and reciprocal routines: */
/* QL: * On entry: */
/* QL: * 0(a6,a1.l) - a exponent/mantissa */
/* QL: * On return, a copy of a will have appeared at -6(a6,a1.l), but the result */
/* QL: * (a^2 or 1/a) will have replaced a. */
/* QL: * Note that these routine now not only work with unnormalised inputs, but will */
/* QL: * keep accuracy with them. Unnormalised results may be produced, but they may */
/* QL: * be one bit out, as precise rounding is a lot of extra work. */
/* QL: * All routines expect/affect registers as follows: */
/* QL: * d0 -  o- error code: 0=ok or err.ov (ccr set) */
/* QL: * d1 -  o- result mantissa, always */
/* QL: * d2 -  o- result exponent (only if d0=0) */
/* QL: * a1 -i o- always six added in ri_mult/div, unchanged by ri_squar/recip */
/* QL: * a6 -ip - base address for a1 */
/* QL: * d3 destroyed */
/* QL: * Low order words of a and/or b were zero, so we can save multiplies */
/* QL: mbl0 */
mbl0:
/* QL:         exg     d1,d3           swap over am and bm to make life easier */
    exg d1,d3
/* QL: mjusta */
mjusta:
/* QL:         swap    d1              am(bm): high order mantissa ($8000..$ffff) */
    swap d1
/* QL:         swap    d3              bm(am): high order mantissa ($8000..$ffff) */
    swap d3
/* QL:         mulu    d1,d3           am*bm ($40000000..$fffe0001) */
    mulu d1,d3
/* QL:         mulu    d2,d1           am*bl(bm*al) (0..$fffd2002) */
    mulu d2,d1
/* QL:         sub.b   d0,d0           set x=0, as we have no clever carry to do */
    sub.b d0,d0
/* QL:         bra.s   mbasic          can now go back to form basic mantissa */
    bra.s mbasic
/* QL: mal0 */
mal0:
/* QL:         move.w  d3,d2           bl: low order mantissa ($0..$fffe) */
    move.w d3,d2
/* QL:         bne.s   mjusta          can only save two multiplies if bl non-zero */
    bne.s mjusta
/* QL:         move.w  0(a6,a1.l),d2   get basic exponent */
    move.w 0(a6,a1.l),d2
/* QL:         swap    d1              am: high order mantissa ($8000..$ffff) */
    swap d1
/* QL:         swap    d3              bm: high order mantissa ($8000..$ffff) */
    swap d3
/* QL:         mulu    d3,d1           am*bm ($40000000..$fffe0001) */
    mulu d3,d1
/* QL:         bmi.s   mround          skip if we're unnormalised at the moment */
    bmi.s mround
/* QL:         bra.s   result          already normalised - go finish exponent */
    bra.s result
/* QL: ri_squar */
ri_squar:
/* QL:         jsr     ri_dup(pc)      duplicate tos, then multiply */
    jsr ri_dup(pc)
/* QL: ri_mult */
ri_mult:
/* QL:         add.l   #6,a1           drop b */
    add.l #6,a1
/* QL:         move.w  -6(a6,a1.l),d2  get b exponent */
    move.w (-6)(a6,a1.l),d2
/* QL:         sub.w   #$17ff,d2       adjust exponent */
    sub.w #0x17ff,d2
/* QL:         move.l  2(a6,a1.l),d1   get a mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         bgt.s   manorm          if it's positive, we're ok to go on */
    bgt.s manorm
/* QL:         beq.s   mzera           if zero, leave pure zero result */
    beq.s mzera
/* QL:         neg.l   d1 */
    neg.l d1
/* QL:         bvs.s   maset           if msb set, all ok */
    bvs.s maset
/* QL: manorm */
manorm:
/* QL:         subq.w  #1,d2           reduce exponent */
    subq.w #1,d2
/* QL:         add.l   d1,d1           shuffle up a (to force msb always 1) */
    add.l d1,d1
/* QL:         bvc.s   manorm          insist on msb 1, even if exponent goes -ve */
    bvc.s manorm
/* QL: maset */
maset:
/* QL:         move.l  -4(a6,a1.l),d3  get b mantissa */
    move.l (-4)(a6,a1.l),d3
/* QL:         bgt.s   mbnorm */
    bgt.s mbnorm
/* QL: mzera */
mzera:
/* QL:         beq.s   zero            if zero, make zero result */
    beq.s zero
/* QL:         not.b   2(a6,a1.l)      invert negative flag */
    not.b 2(a6,a1.l)
/* QL:         neg.l   d3 */
    neg.l d3
/* QL:         bvs.s   mbset */
    bvs.s mbset
/* QL: mbnorm */
mbnorm:
/* QL:         subq.w  #1,d2           reduce exponent */
    subq.w #1,d2
/* QL:         add.l   d3,d3           shift along b (so msb is always 1) */
    add.l d3,d3
/* QL:         bvc.s   mbnorm          insist on msb 1, even if exponent goes -ve */
    bvc.s mbnorm
/* QL: mbset */
mbset:
/* QL:         add.w   d2,0(a6,a1.l)   add modified b exponent into a exponent */
    add.w d2,0(a6,a1.l)
/* QL:         move.w  d1,d2           al: low order mantissa (0..$fffe) */
    move.w d1,d2
/* QL:         beq.s   mal0            can save two or three multiplies if al is zero */
    beq.s mal0
/* QL:         move.w  d3,d0           bl: low order mantissa ($0..$fffe) */
    move.w d3,d0
/* QL:         beq.s   mbl0            can save two multiplies bl is zero */
    beq.s mbl0
/* QL:         swap    d1              am: high order mantissa ($8000..$ffff) */
    swap d1
/* QL:         mulu    d2,d0           al*bl (1..$fffc0001) */
    mulu d2,d0
/* QL:         move.w  d3,d0           we don't need al*bl lsw, but we want bl again */
    move.w d3,d0
/* QL:         swap    d3              bm: high order mantissa ($8000..$ffff) */
    swap d3
/* QL:         mulu    d3,d2           al*bm (0..$fffd2002) */
    mulu d3,d2
/* QL:         mulu    d1,d3           am*bm ($40000000..$fffe0001) */
    mulu d1,d3
/* QL:         mulu    d0,d1           am*bl (0..$fffd2002) */
    mulu d0,d1
/* QL:         clr.w   d0              finished with bl, want zero for msw */
    clr.w d0
/* QL:         swap    d0              wriggle top 16 down (0..$0000fffc) */
    swap d0
/* QL:         add.l   d0,d1           cannot overflow! ($0..$fffdfffe) */
    add.l d0,d1
/* QL:         add.l   d2,d1           this may (0..$xfffb0000) */
    add.l d2,d1
/* QL: mbasic */
mbasic:
/* QL:         move.w  0(a6,a1.l),d2   get basic exponent */
    move.w 0(a6,a1.l),d2
/* QL:         move.w  d1,d0           save bit 15 of sum, in case normalised mantissa */
    move.w d1,d0
/* QL:         clr.w   d1              clear bottom */
    clr.w d1
/* QL:         addx.w  d1,d1           put extend bit in there */
    addx.w d1,d1
/* QL:         swap    d1              ready for final add (0..$0001fffb) */
    swap d1
/* QL:         add.l   d3,d1           basic mantissa ($40000000..$fffffffb) */
    add.l d3,d1
/* QL:         bmi.s   mround          skip if we're unnormalised at the moment */
    bmi.s mround
/* QL:         add.w   d0,d0           get saved rounding bit into extend */
    add.w d0,d0
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         addx.l  d0,d1           add it into the mantissa ($40000001..$80000000) */
    addx.l d0,d1
/* QL:         bvc.s   result          provided it's not $80000000 we're ok */
    bvc.s result
/* QL: mround */
mround:
/* QL:         addq.w  #1,d2           add one to basic exponent */
    addq.w #1,d2
/* QL: dround */
dround:
/* QL:         addq.l  #1,d1           round up ($80000001..$fffffffc) */
    addq.l #1,d1
/* QL: down */
down:
/* QL:         lsr.l   #1,d1           normalised now ($40000000..$7ffffffe) */
    lsr.l #1,d1
/* QL: result */
result:
/* QL:         tst.b   2(a6,a1.l)      do we want a negative result? */
    tst.b 2(a6,a1.l)
/* QL:         bpl.s   sortit          no, leave it at that */
    bpl.s sortit
/* QL:         neg.l   d1 */
    neg.l d1
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         add.l   d0,d0 */
    add.l d0,d0
/* QL:         bvs.s   sortit          tacky, but we mustn't return $c0... for -1 */
    bvs.s sortit
/* QL:         move.l  d0,d1 */
    move.l d0,d1
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL: sortit */
sortit:
/* QL:         add.w   #$1000,d2       final exponent, if all is ok */
    add.w #0x1000,d2
/* QL:         bcs.s   stack           finished up in range 0..$fff, so it's fine */
    bcs.s stack
/* QL: errov */
errov:
/* QL:         bpl.l   ri_errov        finished up in range $1000..$7fff, overflow */
    bpl.w ri_errov
/* QL:         neg.w   d2              ok, so how far did it underflow? */
    neg.w d2
/* QL:         asr.l   d2,d1           adjust mantissa, but correct rounding is tough! */
    asr.l d2,d1
/* QL:         asr.w   #5,d2           was shift count more than 31? */
    asr.w #5,d2
/* QL:         beq.s   stack           no - that's an ok unnormalised mantissa */
    beq.s stack
/* QL: zero */
zero:
/* QL:         moveq   #0,d2           clear exponent */
    moveq #0,d2
/* QL:         moveq   #0,d1           clear mantissa */
    moveq #0,d1
/* QL: stack */
stack:
/* QL:         move.w  d2,0(a6,a1.l)   store exponent */
    move.w d2,0(a6,a1.l)
/* QL:         move.l  d1,2(a6,a1.l)   store mantissa */
    move.l d1,2(a6,a1.l)
/* QL:         moveq   #0,d0           good exit */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: fastdiv */
fastdiv:
/* QL:         swap    d3              divisor to lsw */
    swap d3
/* QL:         cmp.w   #-$8000,d3      even better if the divisor is a power of two! */
    cmp.w #(-0x8000),d3
/* QL:         bne.s   usediv */
    bne.s usediv
/* QL:         move.l  d0,d1           did we adjust the value down? */
    move.l d0,d1
/* QL:         bpl.s   result          yes, go stack it as it is */
    bpl.s result
/* QL:         addq.w  #1,d2           put exponent up */
    addq.w #1,d2
/* QL: dshift */
dshift:
/* QL:         bra.s   down            go shift result down one */
    bra.s down
/* QL: usediv */
usediv:
/* QL:         divu    d3,d0           main divide */
    divu d3,d0
/* QL:         move.w  d0,d1           save msw of result (always >= $8000) */
    move.w d0,d1
/* QL:         swap    d1 */
    swap d1
/* QL:         clr.w   d0              clear the lsw */
    clr.w d0
/* QL:         divu    d3,d0           get lsw of result */
    divu d3,d0
/* QL:         move.w  d0,d1           put in result */
    move.w d0,d1
/* QL:         bra.s   dround          go round and shift result down one */
    bra.s dround
/* QL: ri_recip */
ri_recip:
/* QL:         jsr     ri_one(pc)      put 1.0 on tos */
    jsr ri_one(pc)
/* QL: ri_rdiv */
ri_rdiv:
/* QL:         jsr     ri_swap(pc)     divide tos by nos */
    jsr ri_swap(pc)
/* QL: ri_div */
ri_div:
/* QL:         addq.l  #6,a1           move past b */
    addq.l #6,a1
/* QL:         move.w  0(a6,a1.l),d2   get a exponent */
    move.w 0(a6,a1.l),d2
/* QL:         move.l  2(a6,a1.l),d0   get a mantissa */
    move.l 2(a6,a1.l),d0
/* QL:         sub.w   #$800,d2        adjust exponent */
    sub.w #0x800,d2
/* QL:         sub.w   -6(a6,a1.l),d2  subtract b exponent */
    sub.w (-6)(a6,a1.l),d2
/* QL:         move.l  -4(a6,a1.l),d3  get b mantissa */
    move.l (-4)(a6,a1.l),d3
/* QL:         bgt.s   dbnorm */
    bgt.s dbnorm
/* QL:         beq.s   errov           zero divide */
    beq.s errov
/* QL:         not.b   2(a6,a1.l)      flip input a sign for result sign */
    not.b 2(a6,a1.l)
/* QL:         neg.l   d3              negate b mantissa */
    neg.l d3
/* QL:         bvs.s   dbset           if $80..., we're in luck! */
    bvs.s dbset
/* QL: dbnorm */
dbnorm:
/* QL:         addq.w  #1,d2 */
    addq.w #1,d2
/* QL:         add.l   d3,d3           make sure b has msb set, and lsb 0 */
    add.l d3,d3
/* QL:         bpl.s   dbnorm          shouldn't happen, unless b was unnormalised */
    bpl.s dbnorm
/* QL: dbset */
dbset:
/* QL:         tst.l   d0              check a mantissa */
    tst.l d0
/* QL:         bgt.s   danorm */
    bgt.s danorm
/* QL:         beq.s   zero            make certain all is tidy for 0/b, b<>0 */
    beq.s zero
/* QL:         neg.l   d0 */
    neg.l d0
/* QL:         bvs.s   daset           once again, in luck if $80... */
    bvs.s daset
/* QL: danorm */
danorm:
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL:         add.l   d0,d0           make sure a has msb set and lsb zero */
    add.l d0,d0
/* QL:         bpl.s   danorm          shouldn't happen, unless a was unnormalised */
    bpl.s danorm
/* QL: daset */
daset:
/* QL:         cmp.l   d3,d0           is dividend less than divisor? */
    cmp.l d3,d0
/* QL:         bcs.s   divok           yes - that's just how we like it */
    bcs.s divok
/* QL:         addq.w  #1,d2           otherwise, increment the exponent */
    addq.w #1,d2
/* QL:         lsr.l   #1,d0           and put back the normalised dividend */
    lsr.l #1,d0
/* QL: divok */
divok:
/* QL:         tst.w   d3              interesting... if lsw of divisor is zero... */
    tst.w d3
/* QL:         beq.s   fastdiv         ... we can use the machine's divide! */
    beq.s fastdiv
/* QL:         lsr.l   #1,d3           we guarantee that the top bit will be clear */
    lsr.l #1,d3
/* QL:         sub.l   d3,d0           do first subtraction */
    sub.l d3,d0
/* QL:         moveq   #-2,d1          31 more one bits to shift out */
    moveq #(-2),d1
/* QL: dloop */
dloop:
/* QL:         add.l   d0,d0           shift next dividend up one */
    add.l d0,d0
/* QL:         sub.l   d3,d0           take divisor away from dividend */
    sub.l d3,d0
/* QL:         bcc.s   doksub          good one */
    bcc.s doksub
/* QL:         add.l   d3,d0           put it back (c/x will be set again) */
    add.l d3,d0
/* QL: doksub */
doksub:
/* QL:         addx.l  d1,d1           roll in this bit */
    addx.l d1,d1
/* QL:         bmi.s   dloop           carry on while our one bits are coming out */
    bmi.s dloop
/* QL:         neg.l   d1              all the bits were inverted, and this rounds it */
    neg.l d1
/* QL:         bra.s   dshift          go shift result down one */
    bra.s dshift
/* QL:         end */
