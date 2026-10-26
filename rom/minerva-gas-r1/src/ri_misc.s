/* Generated from original/M/ri/misc.asm */
/* QL: * Miscellaneous arithmetic stack operations */
/* QL:         xdef    ri_halve,ri_k,ri_k_b,ri_n,ri_n_b,ri_one,ri_zero */
.globl ri_halve,ri_k,ri_k_b,ri_n,ri_n_b,ri_one,ri_zero
/* QL:         xref    ri_renrm */
/* QL:         section ri_misc */
.section ri_misc,"ax"
/* QL: ri_halve */
ri_halve:
/* QL:         subq.w  #1,0(a6,a1.l)   subtract one from exponent */
    subq.w #1,0(a6,a1.l)
/* QL:         bpl.s   okrts */
    bpl.s okrts
/* QL:         move.l  2(a6,a1.l),d0   get the mantissa */
    move.l 2(a6,a1.l),d0
/* QL:         asr.l   #1,d0           shift it down */
    asr.l #1,d0
/* QL:         addq.l  #6,a1           (using ri_zero code) */
    addq.l #6,a1
/* QL:         bra.s   unnorm          go put it back (now unnormalised, or zero) */
    bra.s unnorm
/* QL: * These put constants onto the stack: */
/* QL: * Note that the fact that a5 points to the block being interpreted is crucial */
/* QL: * for ri_n and ri_k. The entry points ri_n_b and ri_k_b can be used as direct */
/* QL: * calls, if the need arises, but note that only d0.b is used. */
/* QL: * Direct calls to ri_zero and ri_one are fine. */
/* QL: ri_one */
ri_one:
/* QL:         move.w  #$801,-6(a6,a1.l) */
    move.w #0x801,(-6)(a6,a1.l)
/* QL:         moveq   #1,d0           quick one */
    moveq #1,d0
/* QL:         ror.l   #2,d0 */
    ror.l #2,d0
/* QL:         bra.s   push */
    bra.s push
/* QL: ri_zero */
ri_zero:
/* QL:         moveq   #0,d0           quick zero */
    moveq #0,d0
/* QL: unnorm */
unnorm:
/* QL:         clr.w   -6(a6,a1.l) */
    clr.w (-6)(a6,a1.l)
/* QL: push */
push:
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL: put */
put:
/* QL:         move.l  d0,2(a6,a1.l) */
    move.l d0,2(a6,a1.l)
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: ri_n */
ri_n:
/* QL:         move.b  (a5)+,d0        convenient -128..127 */
    move.b (a5)+,d0
/* QL: ri_n_b */
ri_n_b:
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.b  d0,d1           set mantissa */
    move.b d0,d1
/* QL:         ror.l   #8,d1 */
    ror.l #8,d1
/* QL:         move.w  #$807,d0 */
    move.w #0x807,d0
/* QL:         jmp     ri_renrm(pc)    go renormalise (fairly quick) */
    jmp ri_renrm(pc)
/* QL: * These constants are accessed in a strange, but clever fashion. Only the */
/* QL: * mantissa is held here, and the exponent is constructed from part of the */
/* QL: * selecting byte. We limit ourselves to 16 mantissas, each of which will have */
/* QL: * an exponent constructed for it. E.g. we have the mantissa for pi here, */
/* QL: * but we can supply 2*pi, pi/2, pi/4, etc as well. There is a further twist, */
/* QL: * in that the sixteen constants are arranged in order of their typically */
/* QL: * required magnitude. The exponent we build for them is the sum of a base */
/* QL: * exponent and both nibbles of the selector, giving us a fairly wide range of */
/* QL: * possible values, and variations on the same. At present, we have only found */
/* QL: * duplication in the system code of the constants pi and pi/180, the other */
/* QL: * entries are not heavily used at the moment... */
/* QL: ri_k */
ri_k:
/* QL:         move.b  (a5)+,d0        convenient constants */
    move.b (a5)+,d0
/* QL: ri_k_b                          ;       exp     d0 */
ri_k_b:
/* QL:         move.w  #$07f0,-6(a6,a1.l)      07f0    xxhl */
    move.w #0x07f0,(-6)(a6,a1.l)
/* QL:         or.b    d0,-5(a6,a1.l)          07fl */
    or.b d0,(-5)(a6,a1.l)
/* QL:         lsr.b   #4,d0                           xx0h */
    lsr.b #4,d0
/* QL:         ext.w   d0                              000h */
    ext.w d0
/* QL:         add.w   d0,-6(a6,a1.l)          done */
    add.w d0,(-6)(a6,a1.l)
/* QL:         lsl.b   #2,d0 */
    lsl.b #2,d0
/* QL:         move.l  ktab-8*4(pc,d0.w),d0 mantissa */
    move.l (ktab-(8*4))(pc,d0.w),d0
/* QL:         bra.s   push */
    bra.s push
/* QL: *               mantissa  exp err  what     value         reference */
/* QL: ;       dc.l    $???????? ??? +.?? ???????? 0.??????????? $00-$4f */
/* QL:         dc.l    $477d1a89 7fb +.29 pi/180   0.01745329252 $56 ri.pi180 */
.balign 2,0
dc_anchor_110:
.long 0x477d1a89
/* QL:         dc.l    $6f2dec55 7ff -.41 log10(e) 0.4342944819  $69 ri.loge */
.balign 2,0
dc_anchor_114:
.long 0x6f2dec55
/* QL:         dc.l    $430548e1 800 -.29 pi/6     0.5235987756  $79 ri.pi6 */
.balign 2,0
dc_anchor_118:
.long 0x430548e1
/* QL: ktab */
ktab:
/* QL:         dc.l    $58b90bfc 800 -.09 ln(2)    0.6931471806  $88 ri.ln2 */
.balign 2,0
dc_anchor_124:
.long 0x58b90bfc
/* QL:         dc.l    $6ed9eba1 801 +.38 sqrt(3)  1.732050808   $98 ri.sqrt3 */
.balign 2,0
dc_anchor_128:
.long 0x6ed9eba1
/* QL:         dc.l    $6487ed51 802 +.07 pi       3.141592654   $a8 ri.pi $a7=ri.pi2 */
.balign 2,0
dc_anchor_132:
.long 0x6487ed51
/* QL: ;       dc.l    $???????? ??? +.?? ???????? ?.?????????   $b0-$ff */
/* QL:         end */
