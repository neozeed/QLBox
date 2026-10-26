/* Generated from original/M/ri/nabs.asm */
/* QL: * Negate or abs a normalised number */
/* QL:         xdef    ri_abs,ri_neg */
.globl ri_abs,ri_neg
/* QL:         section ri_nabs */
.section ri_nabs,"ax"
/* QL: * d0 -  o- zero */
/* QL: * d1 -  o- resulting a mantissa */
/* QL: * a1 -ip - rel a6 offset to fp to be negated */
/* QL: * Note: as a feature of this code, a zero resulting mantissa can only come out */
/* QL: * if the original mantissa was zero. This fact is used by at least ri_mult. */
/* QL: * Special cases must be coped with. The normalised +/-2**n must be handled. */
/* QL: * Also, extreme values need care and unnormalised values are now noticed. */
/* QL: * This routine never gives an error, though it does fudge two cases: */
/* QL: * 1) max negative ($0fff80000000) gives max positive ($0fff7fffffff).  */
/* QL: * 2) min positive ($000040000000) gives unnormalised ($0000c0000000). */
/* QL: * As an improvement, instead of comparing with $c0000000 to just detect */
/* QL: * negation of +2**n, this now does a check for an unnormalised result, which */
/* QL: * will also tend to normalise tiny values. */
/* QL: * Another mod is that zero is not treated specially, but is allowed to find its */
/* QL: * way through the unnormalised route, where it's exponent will be forced zero. */
/* QL: * This routine can be mildly slow if the impossible (sic) happened, and an */
/* QL: * unnormalised mantissa came in with an invalid exponent! */
/* QL: * The code is optimised to handle general values. */
/* QL: * It could be made quicker if zero and minus one were very frequent inputs. */
/* QL: unnorm */
unnorm:
/* QL:         exg     d0,d1           it was unnormalised, so used doubled one */
    exg d0,d1
/* QL:         subq.w  #1,0(a6,a1.l)   and decrement exponent */
    subq.w #1,0(a6,a1.l)
/* QL:         bpl.s   norm            no underflow, so we may be able to shift again! */
    bpl.s norm
/* QL:         exg     d0,d1           rats, gotta leave it unnormalised */
    exg d0,d1
/* QL:         clr.w   0(a6,a1.l)      return zero exponent for unnormalised */
    clr.w 0(a6,a1.l)
/* QL:         bra.s   stack           ok */
    bra.s stack
/* QL: ovfl */
ovfl:
/* QL:         move.w  0(a6,a1.l),d0   $80000000 overflowed, so get the exponent */
    move.w 0(a6,a1.l),d0
/* QL:         addq.w  #1,d0           increase it */
    addq.w #1,d0
/* QL: shift */
shift:
/* QL:         lsr.l   #1,d1           shift down mantissa ($40000000 or $7fffffff) */
    lsr.l #1,d1
/* QL:         move.w  d0,0(a6,a1.l)   put in the exponent */
    move.w d0,0(a6,a1.l)
/* QL:         lsl.w   #3,d0           has is it overflowed? */
    lsl.w #3,d0
/* QL:         bpl.s   stack           no, go stack mantissa */
    bpl.s stack
/* QL:         moveq   #-2,d1          ah well! go for 31 1's, largest positive value */
    moveq #(-2),d1
/* QL:         move.w  #$0fff,d0       precise maximum exponent */
    move.w #0x0fff,d0
/* QL:         bra.s   shift           go store them */
    bra.s shift
/* QL: ri_abs */
ri_abs:
/* QL:         tst.b   2(a6,a1.l)      check if already positive */
    tst.b 2(a6,a1.l)
/* QL:         bpl.s   exit            yes, then we don't touch it */
    bpl.s exit
/* QL: ri_neg */
ri_neg:
/* QL:         move.l  2(a6,a1.l),d1   get mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         neg.l   d1              negate it */
    neg.l d1
/* QL:         bvs.s   ovfl            must have been $80000000 */
    bvs.s ovfl
/* QL: norm */
norm:
/* QL:         move.l  d1,d0           take a copy of the result so far */
    move.l d1,d0
/* QL:         add.l   d0,d0           is the result now normalised? */
    add.l d0,d0
/* QL:         bvc.s   unnorm          no, go see what we can do */
    bvc.s unnorm
/* QL: stack */
stack:
/* QL:         move.l  d1,2(a6,a1.l)   put negated mantissa back on stack */
    move.l d1,2(a6,a1.l)
/* QL: exit */
exit:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
