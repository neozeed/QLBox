/* Generated from original/M/gw/trans.asm */
/* QL: * Transform conic section coefficients */
/* QL:         xdef    gw_trans */
.globl gw_trans
/* QL:         xref    gw_choct,gw_pixad */
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: * The equation which we have been told to work with is: */
/* QL: * f(x,y) = v * x - u * y + alpha/2 * y^2 + beta/2 * x^2 - gamma * x*y */
/* QL: * We are to draw f(x,y) = 0. We are to set off towards x=x0+u, y=y0+v, with */
/* QL: * the second order terms. */
/* QL: * If either alpha or beta is zero, both should be (our forte is ellipses, not */
/* QL: * paraboli). */
/* QL: * Finally, we should have gamma^2 <= alpha * beta, (as we're not too hot on */
/* QL: * drawing hyperboli!) with equality only when they are all zero (not too good */
/* QL: * at drawing pairs of intersecting, or parallel, lines!). Unfortuanately, it's */
/* QL: * all too late now to check this without great hassle, so it's possible we */
/* QL: * may draw just half of one side of a very narrow ellipse. */
/* QL: * Octants:                            v */
/* QL: *                                     ^ */
/* QL: *             y             *-*-*- -+- -*- -+- -*   choice of initial octant */
/* QL: *             ^             | 3 * 2 | 2 * 1 | 1 *   such that anticlockwise */
/* QL: *       \  2  |  1  /       +- -*-*-*- -*- -*-*-*   rotation works properly */
/* QL: *         \   |   /         | 3 | 3 * 2 * 1 * 0 |   across each boundary */
/* QL: *       3   \ | /   0       *-*-*-*-*-*-*-*-*- -+ */
/* QL: *       ------o------>x     | 4 | 4 * o * 0 | 0 |-->u */
/* QL: *       4   / | \   7       +- -*-*-*-*-*-*-*-*-* */
/* QL: *         /   |   \         | 4 * 5 * 6 * 7 | 7 |   what happens at u=0, v=0 */
/* QL: *       /  5  |  6  \       *-*-*- -*- -*-*-*- -+   is pretty irrelevent! */
/* QL: *                           * 5 | 5 * 6 | 6 * 7 | */
/* QL: *                           *- -+- -*- -+- -*-*-* */
/* QL:         section gw_trans */
.section gw_trans,"ax"
/* QL: * d0 -ip - start point x coordinate (lsw) */
/* QL: * d1 -ip - start point y coordinate (lsw) */
/* QL: * d2 -i o- alpha / pixel word mask */
/* QL: * d3 -i o- beta / colour masks */
/* QL: * d4 -i  - gamma */
/* QL: * d6 -i o- u / a0 */
/* QL: * d7 -i o- v / b0 */
/* QL: * a0 -i o- channel definition / d0 */
/* QL: * a1 -  o- k1 */
/* QL: * a2 -  o- k2 */
/* QL: * a3 -  o- k3 */
/* QL: * a5 -  o- pixel word address */
/* QL: * a6 -ip - stack frame */
/* QL: * d5 destroyed */
/* QL: gw_trans */
gw_trans:
/* QL: * Clean up which way we're being told to curve. If it's not anticlockwise, */
/* QL: * we effectively mirror across the y-axis. */
/* QL:         clr.w   -(sp)           set square y increment in lsw to zero */
    clr.w -(sp)
/* QL:         move.w  xinc(a6),-(sp)  get basic x increment into msw */
    move.w xinc(a6),-(sp)
/* QL:         move.l  d2,d5 */
    move.l d2,d5
/* QL:         or.l    d3,d5           are alpha and beta non-negative? */
    or.l d3,d5
/* QL:         bpl.s   clock           yes - going anticlockwise already */
    bpl.s clock
/* QL:         neg.l   d2              negate alpha */
    neg.l d2
/* QL:         neg.l   d3              negate beta */
    neg.l d3
/* QL:         neg.l   d6              negate u */
    neg.l d6
/* QL:         neg.w   (sp)            negate dx */
    neg.w (sp)
/* QL: clock */
clock:
/* QL: * Next we can simplify our initial octant decisions by a 180 degree rotation */
/* QL:         moveq   #1,d5           diagonal y-increment */
    moveq #1,d5
/* QL:         tst.l   d6 */
    tst.l d6
/* QL:         bpl.s   rotok           if u > 0, leave it alone */
    bpl.s rotok
/* QL:         bne.s   rotgo           if u < 0, rotate */
    bne.s rotgo
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         ble.s   rotok           if u = 0 and u <= 0, leave it alone */
    ble.s rotok
/* QL: rotgo */
rotgo:
/* QL:         neg.l   d6              negate u */
    neg.l d6
/* QL:         neg.l   d7              negate v */
    neg.l d7
/* QL:         neg.w   d5              change y increment to minus one */
    neg.w d5
/* QL:         neg.w   (sp)            negate dx */
    neg.w (sp)
/* QL: rotok */
rotok:
/* QL:         move.w  (sp),ddx(a6)    store octant zero diagonal move dx */
    move.w (sp),ddx(a6)
/* QL:         move.w  d5,ddy(a6)      store octant zero diagonal move dy */
    move.w d5,ddy(a6)
/* QL:         assert  sdx,sdy-2 */
/* original assertion: sdx,sdy-2 */
/* QL:         move.l  (sp)+,sdx(a6)   store octant zero square move dx,dy */
    move.l (sp)+,sdx(a6)
/* QL: * Now set up for how many octant changes remain to be done. */
/* QL: * We will only need to do at most one clockwise or one or two anti-clockwise. */
/* QL: * The reason this has had to be very finicky is because we must ensure that */
/* QL: * the octant we start in always curls clockwise properly. */
/* QL:         move.l  d7,-(sp) */
    move.l d7,-(sp)
/* QL:         smi     octch(a6)       if v >= 0, clockwise is diagonal first */
    smi octch(a6)
/* QL:         bmi.s   oct67           if v < 0, we need at least one anticlockwise */
    bmi.s oct67
/* QL:         not.l   (sp)            if v >= 0, we may need one clockwise */
    not.l (sp)
/* QL: oct67 */
oct67:
/* QL:         add.l   d6,(sp)         if 0 <= u < -v or 0 < u <= v ... see later */
    add.l d6,(sp)
/* QL: * Now set up all the algorithm's registers */
/* QL:         move.l  d3,a1           k1 = beta */
    move.l d3,a1
/* QL:         sub.l   d4,d3 */
    sub.l d4,d3
/* QL:         move.l  d3,a2           k2 = beta - gamma */
    move.l d3,a2
/* QL:         move.l  d2,a3 */
    move.l d2,a3
/* QL:         sub.l   d4,a3 */
    sub.l d4,a3
/* QL:         add.l   a2,a3           k3 = alpha - 2*gamma + beta */
    add.l a2,a3
/* QL:         asr.l   #1,d3 */
    asr.l #1,d3
/* QL:         add.l   d3,d7           b0 = v + k2/2 */
    add.l d3,d7
/* QL:         asr.l   #1,d2 */
    asr.l #1,d2
/* QL:         sub.l   d6,d2 */
    sub.l d6,d2
/* QL:         asr.l   #1,d2 */
    asr.l #1,d2
/* QL:         add.l   d7,d2           d0 = b0 - u/2 + alpha/4 */
    add.l d7,d2
/* QL:         sub.l   d7,d6           a0 = u - b0 */
    sub.l d7,d6
/* QL:         move.l  d2,-(sp)        save d0 */
    move.l d2,-(sp)
/* QL:         jsr     gw_pixad(pc)    find pixel address and masks */
    jsr gw_pixad(pc)
/* QL:         move.l  (sp)+,a0        put d0 where it belongs */
    move.l (sp)+,a0
/* QL: * Finally, we set which octant we are starting in */
/* QL:         move.b  octch(a6),3(sp) did we select anticlockwise? (and save it) */
    move.b octch(a6),3(sp)
/* QL:         bsr.s   choct           always one octant change if going anticlockwise */
    bsr.s choct
/* QL:         tst.b   (sp)+           did we want one clockwise or two anticlockwise? */
    tst.b (sp)+
/* QL:         bsr.s   choct           one more possible octant change */
    bsr.s choct
/* QL:         move.w  (sp)+,d5        get back which way we were spinning */
    move.w (sp)+,d5
/* QL:         eor.b   d5,octch(a6)    from here on in on we go clockwise */
    eor.b d5,octch(a6)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: choct */
choct:
/* QL:         bpl.s   rts0 */
    bpl.s rts0
/* QL:         jmp     gw_choct(pc)    we only do this if -ve flag was set */
    jmp gw_choct(pc)
/* QL:         end */
