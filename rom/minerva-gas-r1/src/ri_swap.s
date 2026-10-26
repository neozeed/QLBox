/* Generated from original/M/ri/swap.asm */
/* QL: * Swap tos with nos, duplicate tos or nos and roll three */
/* QL:         xdef    ri_dup,ri_over,ri_roll,ri_swap */
.globl ri_dup,ri_over,ri_roll,ri_swap
/* QL: * Note: as all these routines are critical to the overall speed of the system, */
/* QL: * none of them (except roll) share any common code. */
/* QL:         section ri_swap */
.section ri_swap,"ax"
/* QL: * Swap tos and nos: b, a, ... --> a, b, ... */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * d1 -  o- new tos mantissa longword */
/* QL: * d2 -  o- new tos exponent word */
/* QL: ri_swap */
ri_swap:
/* QL:         move.w  0+1*6(a6,a1.l),d2 */
    move.w (0+(1*6))(a6,a1.l),d2
/* QL:         move.l  2+1*6(a6,a1.l),d1 */
    move.l (2+(1*6))(a6,a1.l),d1
/* QL:         move.w  0+0*6(a6,a1.l),0+1*6(a6,a1.l) */
    move.w (0+(0*6))(a6,a1.l),(0+(1*6))(a6,a1.l)
/* QL:         move.l  2+0*6(a6,a1.l),2+1*6(a6,a1.l) */
    move.l (2+(0*6))(a6,a1.l),(2+(1*6))(a6,a1.l)
/* QL: putit */
putit:
/* QL:         move.w  d2,0+0*6(a6,a1.l) */
    move.w d2,(0+(0*6))(a6,a1.l)
/* QL:         move.l  d1,2+0*6(a6,a1.l) */
    move.l d1,(2+(0*6))(a6,a1.l)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Copy nos over tos to becomes additional tos: b, a, ... --> a, b, a, ... */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: ri_over */
ri_over:
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.w  0+2*6(a6,a1.l),0+0*6(a6,a1.l) */
    move.w (0+(2*6))(a6,a1.l),(0+(0*6))(a6,a1.l)
/* QL:         move.l  2+2*6(a6,a1.l),2+0*6(a6,a1.l) */
    move.l (2+(2*6))(a6,a1.l),(2+(0*6))(a6,a1.l)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Duplicate tos as additional tos: a, ... --> a, a, ... */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: ri_dup */
ri_dup:
/* QL:         subq.l #6,a1 */
    subq.l #6,a1
/* QL:         move.w 0+1*6(a6,a1.l),0+0*6(a6,a1.l) */
    move.w (0+(1*6))(a6,a1.l),(0+(0*6))(a6,a1.l)
/* QL:         move.l 2+1*6(a6,a1.l),2+0*6(a6,a1.l) */
    move.l (2+(1*6))(a6,a1.l),(2+(0*6))(a6,a1.l)
/* QL:         moveq  #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Roll the third entry around to the top: b, c, a, ... --> a, b, c, ... */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * d1 -  o- new tos mantissa longword */
/* QL: * d2 -  o- new tos exponent word */
/* QL: ri_roll */
ri_roll:
/* QL:         move.w  0+2*6(a6,a1.l),d2 */
    move.w (0+(2*6))(a6,a1.l),d2
/* QL:         move.l  2+2*6(a6,a1.l),d1 */
    move.l (2+(2*6))(a6,a1.l),d1
/* QL:         move.l  2+1*6(a6,a1.l),2+2*6(a6,a1.l) */
    move.l (2+(1*6))(a6,a1.l),(2+(2*6))(a6,a1.l)
/* QL:         move.l  4+0*6(a6,a1.l),4+1*6(a6,a1.l) */
    move.l (4+(0*6))(a6,a1.l),(4+(1*6))(a6,a1.l)
/* QL:         move.l  0+0*6(a6,a1.l),0+1*6(a6,a1.l) */
    move.l (0+(0*6))(a6,a1.l),(0+(1*6))(a6,a1.l)
/* QL:         bra.s   putit */
    bra.s putit
/* QL:         end */
