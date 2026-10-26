/* Generated from original/M/ri/sqrt.asm */
/* QL: * Square root and mod (2- or n-dimension) */
/* QL:         xdef    ri_mod,ri_sqrt,ri_sss */
.globl ri_mod,ri_sqrt,ri_sss
/* QL:         xref    ri_abs,ri_add,ri_chkov,ri_errov,ri_squar,ri_swap,ri_zero */
/* QL:         section ri_sqrt */
.section ri_sqrt,"ax"
/* QL: * Square root of sum of squares of tos and nos: tos, nos, ... --> result, ... */
/* QL: ri_mod */
ri_mod:
/* QL:         moveq   #2,d3 */
    moveq #2,d3
/* QL: * Square root of sum of squares of all parameters: list, ... --> result, ... */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * d3 -i  - count of fp values to operate on (0..32767!) */
/* QL: * a1 -i o- has (d3-1)*6 added */
/* QL: * d1-d2 destroyed */
/* QL: * Magic number of 17 is the exponent difference where a parameter becomes too */
/* QL: * small to affect the result. If there were a great number of such small */
/* QL: * parameters, this might not be quite right, but short of doing a sort to */
/* QL: * operate on the smaller values first, I don't see that it's too bad. Keeping */
/* QL: * to the minimum value is a moderately good idea, as this code will be able to */
/* QL: * skip parameters more often, saving calculation time where values that are */
/* QL: * "approximately" zero crop up. However, as we aren't being too pedantic about */
/* QL: * this, we'll use the value 20. */
/* QL: reglist reg     d4-d5/a0 */
/* QL: ri_sss */
ri_sss:
/* QL:         movem.l reglist,-(sp) */
    movem.l d4-d5/a0,-(sp)
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         moveq   #20,d5 */
    moveq #20,d5
/* QL:         bra.s   maxent */
    bra.s maxent
/* QL: maxlp */
maxlp:
/* QL:         addq.l  #6,a1 */
    addq.l #6,a1
/* QL:         cmp.w   -6(a6,a1.l),d5 */
    cmp.w (-6)(a6,a1.l),d5
/* QL:         bgt.s   maxent */
    bgt.s maxent
/* QL:         move.w  -6(a6,a1.l),d5 */
    move.w (-6)(a6,a1.l),d5
/* QL: maxent */
maxent:
/* QL:         dbra    d4,maxlp */
    dbra d4,maxlp
/* QL:         sub.w   #20,d5          d5 is zero or positive */
    sub.w #20,d5
/* QL:         move.l  a1,a0 */
    move.l a1,a0
/* QL:         bra.s   upent */
    bra.s upent
/* QL: uplp */
uplp:
/* QL:         subq.l  #6,a0 */
    subq.l #6,a0
/* QL:         tst.l   2(a6,a0.l)      skip any zero values, regardless */
    tst.l 2(a6,a0.l)
/* QL:         beq.s   upent */
    beq.s upent
/* QL:         cmp.w   0(a6,a0.l),d5   only use values within 17 of max exponent */
    cmp.w 0(a6,a0.l),d5
/* QL:         bgt.s   upent */
    bgt.s upent
/* QL:         addq.w  #1,d4           count the ones we will use */
    addq.w #1,d4
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.w  0(a6,a0.l),0(a6,a1.l) pack them all up the top of the stack */
    move.w 0(a6,a0.l),0(a6,a1.l)
/* QL:         move.l  2(a6,a0.l),2(a6,a1.l) */
    move.l 2(a6,a0.l),2(a6,a1.l)
/* QL: upent */
upent:
/* QL:         dbra    d3,uplp */
    dbra d3,uplp
/* QL:         tst.w   d4              check how many values we've finished up with */
    tst.w d4
/* QL:         bgt.s   dosss           more than one, actually do something! */
    bgt.s dosss
/* QL:         movem.l (sp)+,reglist   reload regs */
    movem.l (sp)+,d4-d5/a0
/* QL:         beq.l   ri_abs          abs if we have just one (significant) parameter */
    beq.w ri_abs
/* QL:         jmp     ri_zero(pc)     nothing (non-zero), so push a true zero */
    jmp ri_zero(pc)
/* QL: modsq */
modsq:
/* QL:         sub.w   d5,0(a6,a1.l) */
    sub.w d5,0(a6,a1.l)
/* QL:         jmp     ri_squar(pc) */
    jmp ri_squar(pc)
/* QL: dosss */
dosss:
/* QL:         sub.w   #$800,d5        exponents will be $800+(0..17) for square */
    sub.w #0x800,d5
/* QL:         bsr.s   modsq */
    bsr.s modsq
/* QL: addlp */
addlp:
/* QL:         jsr     ri_swap(pc) */
    jsr ri_swap(pc)
/* QL:         bsr.s   modsq */
    bsr.s modsq
/* QL:         jsr     ri_add(pc) */
    jsr ri_add(pc)
/* QL:         subq.w  #1,d4 */
    subq.w #1,d4
/* QL:         bne.s   addlp */
    bne.s addlp
/* QL:         bsr.s   ri_sqrt */
    bsr.s ri_sqrt
/* QL:         add.w   d5,0(a6,a1.l)   readjust final exponent */
    add.w d5,0(a6,a1.l)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d4-d5/a0
/* QL:         jmp     ri_chkov(pc)    finally check that we haven't overflowed */
    jmp ri_chkov(pc)
/* QL: * Square root: a, ... --> SQRT(a), ... */
/* QL: * d0 -  o- error code (ccr set) */
/* QL: * a1 -i o- ri stack pointer */
/* QL: * a6 -ip - base address */
/* QL: * d1-d2 destroyed */
/* QL: ri_sqrt */
ri_sqrt:
/* QL:         move.l  2(a6,a1.l),d0   get mantissa */
    move.l 2(a6,a1.l),d0
/* QL:         beq.s   rts0            if we actually have sqrt(0), then all is OK */
    beq.s rts0
/* QL:         bmi.l   ri_errov        no messing if it's not strictly positive */
    bmi.w ri_errov
/* QL:         move.w  0(a6,a1.l),d2   get exponent */
    move.w 0(a6,a1.l),d2
/* QL:         add.w   #$801,d2        adjust exponent prior to halving it */
    add.w #0x801,d2
/* QL: unnlp */
unnlp:
/* QL:         add.l   d0,d0 */
    add.l d0,d0
/* QL:         dbmi    d2,unnlp        roll up to ensure msb is set */
    dbmi d2,unnlp
/* QL:         lsr.w   #1,d2           halve exponent */
    lsr.w #1,d2
/* QL:         bcs.s   expodd */
    bcs.s expodd
/* QL:         lsr.l   #1,d0           if exponent was even, halve the mantissa */
    lsr.l #1,d0
/* QL: expodd */
expodd:
/* QL:         move.w  d2,0(a6,a1.l)   store the final exponent (always in range!) */
    move.w d2,0(a6,a1.l)
/* QL:         moveq   #1,d1           clear result mantissa */
    moveq #1,d1
/* QL:         ror.l   #32-30,d1       except for initial bit 30 */
    ror.l #(32-30),d1
/* QL:         sub.l   d1,d0           our first subtraction is always OK */
    sub.l d1,d0
/* QL:         moveq   #28,d2          next test bit is two down, i.e. bit 28 */
    moveq #28,d2
/* QL: loop */
loop:
/* QL:         bset    d2,d1           set the bit we want to compare for */
    bset d2,d1
/* QL:         cmp.l   d0,d1           check test value against remainder */
    cmp.l d0,d1
/* QL:         bhi.s   nosub           if it is greater, we don't want this bit set */
    bhi.s nosub
/* QL:         sub.l   d1,d0           subtract from remainder */
    sub.l d1,d0
/* QL:         addq.b  #1,d2 */
    addq.b #1,d2
/* QL:         bset    d2,d1           set the next bit up */
    bset d2,d1
/* QL:         subq.b  #1,d2 */
    subq.b #1,d2
/* QL: nosub */
nosub:
/* QL:         bclr    d2,d1           clear the test bit */
    bclr d2,d1
/* QL:         add.l   d0,d0           double up the remainder */
    add.l d0,d0
/* QL:         dbra    d2,loop */
    dbra d2,loop
/* QL:         cmp.l   d0,d1           check for final bit */
    cmp.l d0,d1
/* QL:         bcc.s   nolsb           (bearing in mind bit -1(!) should be set) */
    bcc.s nolsb
/* QL:         addq.b  #1,d1           this is a proper lsb */
    addq.b #1,d1
/* QL:         sub.l   d1,d0           over-subtract */
    sub.l d1,d0
/* QL:         add.b   d2,d2           x=1 corrects the over-subtraction above */
    add.b d2,d2
/* QL: nolsb */
nolsb:
/* QL:         addx.l  d0,d0           double up leftover stuff */
    addx.l d0,d0
/* QL:         cmp.l   d0,d1           final check for rounding */
    cmp.l d0,d1
/* QL:         bcc.s   nornd           (bit -2(!!) should be set) */
    bcc.s nornd
/* QL:         addq.l  #1,d1           rounding here never pushes up the exponent! */
    addq.l #1,d1
/* QL: nornd */
nornd:
/* QL:         move.l  d1,2(a6,a1.l) */
    move.l d1,2(a6,a1.l)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL:         end */
