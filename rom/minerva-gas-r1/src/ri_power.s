/* Generated from original/M/ri/power.asm */
/* QL: * Raise fp to fp or integer power */
/* QL:         xdef    ri_power,ri_powfp */
.globl ri_power,ri_powfp
/* QL:         xref    ri_exp,ri_errov,ri_ln,ri_mult,ri_one,ri_recip,ri_squar,ri_swap */
/* QL:         section ri_power */
.section ri_power,"ax"
/* QL: * Raise a to power b... check if b is integer, and do faster code if so */
/* QL: * On entry */
/* QL: * 0(a1) - b exponent/mantissa */
/* QL: * 6(a1) - a exponent/mantissa */
/* QL: * On exit, both a and b will have been removed from the stack and replaced */
/* QL: * by the result (a**b) (a to the power of b) */
/* QL: * d0 -  o- error code */
/* QL: * a1 -i o- arithmetic stack pointer, 6 added */
/* QL: * d1-d3 destroyed */
/* QL: ri_powfp */
ri_powfp:
/* QL:         move.l  2(a6,a1.l),d1   get mantissa of b */
    move.l 2(a6,a1.l),d1
/* QL:         move.w  0(a6,a1.l),d2   get exponent of b */
    move.w 0(a6,a1.l),d2
/* QL:         beq.s   fp_to_un        it's zero */
    beq.s fp_to_un
/* QL:         move.w  #$80f,d0        set up shift to make integer */
    move.w #0x80f,d0
/* QL:         sub.w   d2,d0 */
    sub.w d2,d0
/* QL:         blt.s   fp_to_fp        too big (should we abs(a)? power is even?) */
    blt.s fp_to_fp
/* QL:         cmp.w   #$f,d0 */
    cmp.w #0xf,d0
/* QL:         bgt.s   fp_to_fp        too small */
    bgt.s fp_to_fp
/* QL:         tst.w   d1 */
    tst.w d1
/* QL:         bne.s   fp_to_fp        bottom end has some fractional bits */
    bne.s fp_to_fp
/* QL:         asr.l   d0,d1           shift it down */
    asr.l d0,d1
/* QL:         tst.w   d1 */
    tst.w d1
/* QL:         bne.s   fp_to_fp        bottom bit now has some fractional bits */
    bne.s fp_to_fp
/* QL: swap_i */
swap_i:
/* QL:         swap    d1              get integer in bottom end */
    swap d1
/* QL: fp_to_i */
fp_to_i:
/* QL:         addq.l  #4,a1           remove fp from stack */
    addq.l #4,a1
/* QL:         move.w  d1,0(a6,a1.l)   put integer on and do fp to integer */
    move.w d1,0(a6,a1.l)
/* QL: * Drop into ri_power */
/* QL: * On entry */
/* QL: *  (a1) - b signed integer, even including -32768! */
/* QL: * 2(a1) - a exponent */
/* QL: * 4(a1) - a mantissa */
/* QL: * On exit, both a and b will have been removed from the stack and replaced */
/* QL: * by the result (a**b) (a to the power of b) */
/* QL: * Hmmm.... there is a slightly better way of doing this, by examining the */
/* QL: * required power in more detail. The first power that can be improved upon is */
/* QL: * fifteen. This routine does a**15 as "a * a**2 * a**4 * a**8", which costs six */
/* QL: * multiplies. Doing it as (a * a**4)**3 only takes five, and is more accurate */
/* QL: * as well! The next cases that get worse are 63 (10 versus 8 multiplies), 255 */
/* QL: * (14 versus 10) and 4095 (22 versus 15). On average, up to the power of 4095, */
/* QL: * the current algorithm requires about 18% more multiplies than optimal. */
/* QL: * To the absolute top (32767) the average comes out at 22.37%. */
/* QL: * Unfortunately, a simpler algorithm than the one below for finding the optimal */
/* QL: * method escapes me at the moment, except that it's certainly not just */
/* QL: * factorising the power. E.g. 33 takes just six multiplies here, whereas done */
/* QL: * as 3*11 it takes eight! */
/* QL: * The optimal method can be done using the algorithm below, but one should */
/* QL: * notice that it will requires additional stack space. */
/* QL: * def fn f(b):loc k,i,l,t */
/* QL: *  if b<2:ret 0 */
/* QL: *  if b&&1=0:c=1:ret f(b/2)+1 */
/* QL: *  k=f(b-1)+1:t=2 */
/* QL: *  for i=3to sqrt(b)step 2 */
/* QL: *   if int(b/i)*i=i:l=f(b/i)+f(b):if l<=k:t=i:k=l */
/* QL: *   end for i:c=t:ret k:end def */
/* QL: * def fn p(a,b)  */
/* QL: *  if b=1:ret a */
/* QL: *  d=f(b) */
/* QL: *  if c=1:d=p(a,b/2):ret d*d */
/* QL: *  if c=2:d=p(a,(b-1)/2):ret d*d*a */
/* QL: *  ret p(p(a,b/i),i):end def */
/* QL: * def fn power(a,b):loc c,d */
/* QL: *  if b>0:ret p(a,b) */
/* QL: *  if b<0:ret p(1/a,-b) */
/* QL: *  ret 1:end def */
/* QL: * So it goes... */
/* QL: * d0 -  o- error code */
/* QL: * a1 -i o- arithmetic stack pointer, 2 added */
/* QL: * d1-d3 destroyed */
/* QL: reglist reg     d4-d6 */
/* QL: ri_power */
ri_power:
/* QL:         movem.l reglist,-(sp) */
    movem.l d4-d6,-(sp)
/* QL:         moveq   #0,d0           we get straight out if b = 0 or 1 */
    moveq #0,d0
/* QL:         moveq   #0,d6           clear flag in msb shows no partial result yet */
    moveq #0,d6
/* QL:         addq.l  #2,a1           adjust stack */
    addq.l #2,a1
/* QL:         move.w  -2(a6,a1.l),d6  take initial b off the stack */
    move.w (-2)(a6,a1.l),d6
/* QL:         bgt.s   shift           if b is positive, ok */
    bgt.s shift
/* QL:         bne.s   invert          if strictly negative, do (1/a)^(-b) */
    bne.s invert
/* QL:         tst.l   2(a6,a1.l)      are we trying to do 0^0? */
    tst.l 2(a6,a1.l)
/* QL:         beq.s   invert          yes, force it to give an error */
    beq.s invert
/* QL:         addq.l  #6,a1           drop a */
    addq.l #6,a1
/* QL:         jsr     ri_one(pc)      put answer, a^0 = 1.0 if a<>0 */
    jsr ri_one(pc)
/* QL:         bra.s   exit            that's all done */
    bra.s exit
/* QL: zapit */
zapit:
/* QL:         moveq   #-1,d1          force error for -ve^fp */
    moveq #(-1),d1
/* QL: zero_pow */
zero_pow:
/* QL:         addq.l  #6,a1           drop power */
    addq.l #6,a1
/* QL:         tst.l   d1              was it raise to positive power? */
    tst.l d1
/* QL:         bgt.s   rts0            0^+ve is finished, 0^0 and 0^-ve are no good */
    bgt.s rts0
/* QL:         jmp     ri_errov(pc) */
    jmp ri_errov(pc)
/* QL: fp_to_un */
fp_to_un:
/* QL:         tst.l   d1              check in case b is unnormal */
    tst.l d1
/* QL:         beq.s   fp_to_i         nope, go do a^0 */
    beq.s fp_to_i
/* QL: fp_to_fp */
fp_to_fp:
/* QL:         move.l  2+6(a6,a1.l),d0 are we doing 0 ^ b? */
    move.l (2+6)(a6,a1.l),d0
/* QL:         beq.s   zero_pow        yes, go check sign of power */
    beq.s zero_pow
/* QL:         jsr     ri_swap(pc)     save power */
    jsr ri_swap(pc)
/* QL:         jsr     ri_ln(pc)       log a */
    jsr ri_ln(pc)
/* QL:         bne.s   zapit           complains if trying to log zero or negative */
    bne.s zapit
/* QL:         pea     ri_exp(pc)      (note: huge negative power is fine!) */
    pea ri_exp(pc)
/* QL: mult */
mult:
/* QL:         jmp     ri_mult(pc) */
    jmp ri_mult(pc)
/* QL: invert */
invert:
/* QL:         jsr     ri_recip(pc)    take the reciprocal (force error if 0^0 now!) */
    jsr ri_recip(pc)
/* QL:         bne.s   exit            error on invert, leave it and get out */
    bne.s exit
/* QL:         neg.w   d6              negate power */
    neg.w d6
/* QL: shift */
shift:
/* QL:         lsr.w   #1,d6           get bottom-most bit of power */
    lsr.w #1,d6
/* QL:         bcc.s   square          0 there, so no multiply */
    bcc.s square
/* QL:         move.w  0(a6,a1.l),d5   save current a exp */
    move.w 0(a6,a1.l),d5
/* QL:         move.l  2(a6,a1.l),d4   save current a mantissa */
    move.l 2(a6,a1.l),d4
/* QL:         bset    #31,d6          have we had a partial result yet? */
    bset #31,d6
/* QL:         beq.s   putpart         no, effectively just dup */
    beq.s putpart
/* QL:         bsr.s   mult            yes, r = a * r */
    bsr.s mult
/* QL: putpart */
putpart:
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         bne.s   qdrop           overflowed? */
    bne.s qdrop
/* QL:         move.l  d4,2(a6,a1.l)   replace a on stack */
    move.l d4,2(a6,a1.l)
/* QL:         move.w  d5,0(a6,a1.l) */
    move.w d5,0(a6,a1.l)
/* QL:         tst.w   d6 */
    tst.w d6
/* QL: square */
square:
/* QL:         beq.s   qdrop           have we done all the bits of b? */
    beq.s qdrop
/* QL:         jsr     ri_squar(pc)    and square current a */
    jsr ri_squar(pc)
/* QL:         beq.s   shift           repeat if no error */
    beq.s shift
/* QL: qdrop */
qdrop:
/* QL:         tst.l   d6              did we just have b = 2**n? */
    tst.l d6
/* QL:         bpl.s   exit            yes, then answer is already at top of stack */
    bpl.s exit
/* QL: drop */
drop:
/* QL:         addq.l  #6,a1           reposition stack pointer */
    addq.l #6,a1
/* QL: exit */
exit:
/* QL:         movem.l (sp)+,reglist   restore external data */
    movem.l (sp)+,d4-d6
/* QL: rts0 */
rts0:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL:         end */
