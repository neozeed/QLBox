/* Generated from original/M/gw/choct.asm */
/* QL: * Change octants */
/* QL:         xdef    gw_choct */
.globl gw_choct
/* QL:         include 'win1_m_inc_gw' */
/* QL: * graphic routines stack frame definition */
/* QL:         nolist */
/* QL:         offset  -$30 */
/* QL: sav     reg     a0/a3/a5  required save register list */
/* QL: chnp    ds.l    1       saved a0 = pointer to channel definition block */
.equ chnp,-48
/* QL:         ds.l    2 */
/* QL: lnk ; negated save frame size */
.equ lnk,-36
/* QL: sdx     ds.w    1       square move x increment = -1..1 (*2 if 256 mode)  */
.equ sdx,-36
/* QL: sdy     ds.w    1       square move y increment = -1..1 */
.equ sdy,-34
/* QL: ddx     ds.w    1       diagonal move x increment */
.equ ddx,-32
/* QL: ddy     ds.w    1       diagonal move y increment */
.equ ddy,-30
/* QL: x0      ds.w    1       first point x coordinate */
.equ x0,-28
/* QL: y0      ds.w    1       first point y coordinate */
.equ y0,-26
/* QL: x1      ds.w    1       last point x coordinate */
.equ x1,-24
/* QL: y1      ds.w    1       last point y coordinate */
.equ y1,-22
/* QL: xmin    ds.w    1       left edge of window */
.equ xmin,-20
/* QL: ymin    ds.w    1       top edge of window */
.equ ymin,-18
/* QL: xsize   ds.w    1       window width */
.equ xsize,-16
/* QL: ysize   ds.w    1       window height */
.equ ysize,-14
/* QL: linem   ds.w    1       negated bytes between row addresses (-sd_linel) */
.equ linem,-12
/* QL: linel   ds.w    1       bytes between row addresses (sd_linel) */
.equ linel,-10
/* QL: xinc    ds.w    1       1 (512 mode) or 2 (256 mode) for shifts */
.equ xinc,-8
/* QL:         ds.b    1       spare                            */
/* QL: type    ds.b    1       $ec:line, $dc:arc, $3d:ellipse */
.equ type,-5
/* QL: octs    ds.b    1       maximum number of octant changes permitted */
.equ octs,-4
/* QL: octch   ds.b    1       expected octant change, 0=square, $ff=diagonal */
.equ octch,-3
/* QL: over    ds.b    1       non-zero if xor on (over -1) */
.equ over,-2
/* QL: fmod    ds.b    1       non-zero if area flood on (fill 1) */
.equ fmod,-1
/* QL:         list */
/* QL:         section gw_choct */
.section gw_choct,"ax"
/* QL: * d6 -i o- a */
/* QL: * d7 -i o- b */
/* QL: * a0 -i o- d */
/* QL: * a1 -i o- k1 */
/* QL: * a2 -i o- k2 */
/* QL: * a3 -i o- k3 */
/* QL: * a6 -ip - stack frame */
/* QL: * d4-d5 destroyed */
/* QL: gw_choct */
gw_choct:
/* QL:         not.b   octch(a6)       which one are we expecting? */
    not.b octch(a6)
/* QL:         bne.s   diag            if diagonal, go do it */
    bne.s diag
/* QL: * Do a square octant change, to get b positive */
/* QL:         tst.w   sdx(a6) */
    tst.w sdx(a6)
/* QL:         bne.s   ddxok */
    bne.s ddxok
/* QL:         neg.w   ddx(a6) */
    neg.w ddx(a6)
/* QL: ddxok */
ddxok:
/* QL: * if sdy=0:ddy=-ddy */
/* QL:         tst.w   sdy(a6) */
    tst.w sdy(a6)
/* QL:         bne.s   ddyok */
    bne.s ddyok
/* QL:         neg.w   ddy(a6) */
    neg.w ddy(a6)
/* QL: ddyok */
ddyok:
/* QL: * Calculate new variable values for d,b,a,k1,k2,k3 */
/* QL:         move.l  a1,d4 */
    move.l a1,d4
/* QL:         neg.l   d4 */
    neg.l d4
/* QL:         move.l  d4,a1           k1' = -k1 */
    move.l d4,a1
/* QL:         add.l   a2,d4           w = k2 + k1' */
    add.l a2,d4
/* QL:         move.l  d4,a2 */
    move.l d4,a2
/* QL:         add.l   a1,a2           k2' = w + k1' */
    add.l a1,a2
/* QL:         neg.l   d7 */
    neg.l d7
/* QL:         add.l   d4,d7           b' = w - b */
    add.l d4,d7
/* QL:         move.l  d7,d5 */
    move.l d7,d5
/* QL:         sub.l   d6,d5 */
    sub.l d6,d5
/* QL:         sub.l   a0,d5 */
    sub.l a0,d5
/* QL:         move.l  d5,a0           d' = b' - a - d */
    move.l d5,a0
/* QL:         sub.l   d7,d6 */
    sub.l d7,d6
/* QL:         sub.l   d7,d6 */
    sub.l d7,d6
/* QL:         add.l   d4,d6           a' = a - 2*b' + w */
    add.l d4,d6
/* QL:         lsl.l   #2,d4 */
    lsl.l #2,d4
/* QL:         sub.l   a3,d4 */
    sub.l a3,d4
/* QL:         move.l  d4,a3           k3' = 4*w - k3 */
    move.l d4,a3
/* QL:         rts */
    rts 
/* QL: * Change the movement data across a diagonal boundary */
/* QL: diag */
diag:
/* QL:         tst.w   sdy(a6) */
    tst.w sdy(a6)
/* QL:         bne.s   sdyok           if sdy is zero */
    bne.s sdyok
/* QL:         clr.w   sdx(a6)         sdx = 0 */
    clr.w sdx(a6)
/* QL:         move.w  ddy(a6),sdy(a6) sdy = ddy */
    move.w ddy(a6),sdy(a6)
/* QL:         bra.s   sdxok */
    bra.s sdxok
/* QL: sdyok */
sdyok:
/* QL:         tst.w   sdx(a6) */
    tst.w sdx(a6)
/* QL:         bne.s   sdxok           else if sdx is zero */
    bne.s sdxok
/* QL:         clr.w   sdy(a6)         sdy = 0 */
    clr.w sdy(a6)
/* QL:         move.w  ddx(a6),sdx(a6) sdx = ddx */
    move.w ddx(a6),sdx(a6)
/* QL: sdxok */
sdxok:
/* QL: * Calculate new d,b,a,k1,k2 and k3 */
/* QL:         move.l  a3,d4 */
    move.l a3,d4
/* QL:         neg.l   d4 */
    neg.l d4
/* QL:         move.l  d4,a3           k3' = -k3 */
    move.l d4,a3
/* QL:         add.l   a2,d4 */
    add.l a2,d4
/* QL:         add.l   a2,d4           w = 2*k2 + k3' */
    add.l a2,d4
/* QL:         add.l   a3,a2           k2' = k2 + k3' */
    add.l a3,a2
/* QL:         move.l  d4,d5 */
    move.l d4,d5
/* QL:         sub.l   a1,d5 */
    sub.l a1,d5
/* QL:         move.l  d5,a1           k1' = w - k1 */
    move.l d5,a1
/* QL:         move.l  a2,d5 */
    move.l a2,d5
/* QL:         asr.l   #1,d5 */
    asr.l #1,d5
/* QL:         add.l   d6,d5 */
    add.l d6,d5
/* QL:         add.l   d5,d7           b' = b + a + k2'/2 */
    add.l d5,d7
/* QL:         asr.l   #1,d5 */
    asr.l #1,d5
/* QL:         add.l   a0,d5 */
    add.l a0,d5
/* QL:         neg.l   d5 */
    neg.l d5
/* QL:         add.l   d7,d5 */
    add.l d7,d5
/* QL:         move.l  d5,a0           d' = b' - d - a/2 - k2'/4 */
    move.l d5,a0
/* QL:         asr.l   #1,d4 */
    asr.l #1,d4
/* QL:         add.l   d4,d6 */
    add.l d4,d6
/* QL:         neg.l   d6              a' = - w/2 - a */
    neg.l d6
/* QL:         rts */
    rts 
/* QL:         end */
