/* Generated from original/M/mm/move.asm */
/* QL: * Move memory as quickly as practical (within 5% of max possible!) */
/* QL:         xdef    mm_clear,mm_clrr,mm_move,mm_mrtoa,mm_mrtor */
.globl mm_clear,mm_clrr,mm_move,mm_mrtoa,mm_mrtor
/* QL:         include 'win1_m_inc_mt' */
/* QL: * manager trap #1 codes */
/* QL:         nolist */
/* QL: mt.inf  equ     $00     get system information */
.equ mt.inf,0x00
/* QL: mt.cjob equ     $01     create a job */
.equ mt.cjob,0x01
/* QL: mt.jinf equ     $02     get information on job */
.equ mt.jinf,0x02
/* QL: mt.extop equ    $03     convert called routine to supervisor, rte at end */
.equ mt.extop,0x03
/* QL: mt.rjob equ     $04     remove a job */
.equ mt.rjob,0x04
/* QL: mt.frjob equ    $05     force remove a job */
.equ mt.frjob,0x05
/* QL: mt.free equ     $06     find out how much free space there is */
.equ mt.free,0x06
/* QL: mt.trapv equ    $07     set pointer to trap redirection vectors */
.equ mt.trapv,0x07
/* QL: mt.susjb equ    $08     suspend a job */
.equ mt.susjb,0x08
/* QL: mt.reljb equ    $09     release a job */
.equ mt.reljb,0x09
/* QL: mt.activ equ    $0a     activate a job */
.equ mt.activ,0x0a
/* QL: mt.prior equ    $0b     set a job priority */
.equ mt.prior,0x0b
/* QL: mt.alloc equ    $0c     allocate a bit of a heap */
.equ mt.alloc,0x0c
/* QL: mt.lnkfr equ    $0d     release a bit of a heap */
.equ mt.lnkfr,0x0d
/* QL: mt.alres equ    $0e     allocate resident procedure area */
.equ mt.alres,0x0e
/* QL: mt.reres equ    $0f     release resident procedure area */
.equ mt.reres,0x0f
/* QL: mt.dmode equ    $10     set display mode */
.equ mt.dmode,0x10
/* QL: mt.ipcom equ    $11     send IPC command */
.equ mt.ipcom,0x11
/* QL: mt.baud equ     $12     set baud rate */
.equ mt.baud,0x12
/* QL: mt.rclck equ    $13     read clock */
.equ mt.rclck,0x13
/* QL: mt.sclck equ    $14     set clock */
.equ mt.sclck,0x14
/* QL: mt.aclck equ    $15     adjust clock */
.equ mt.aclck,0x15
/* QL: mt.albas equ    $16     allocate basic area */
.equ mt.albas,0x16
/* QL: mt.rebas equ    $17     release basic area */
.equ mt.rebas,0x17
/* QL: mt.alchp equ    $18     allocate space in common heap */
.equ mt.alchp,0x18
/* QL: mt.rechp equ    $19     release space in common heap */
.equ mt.rechp,0x19
/* QL: mt.lxint equ    $1a     link in external interrupt handler */
.equ mt.lxint,0x1a
/* QL: mt.rxint equ    $1b     remove external interrupt handler */
.equ mt.rxint,0x1b
/* QL: mt.lpoll equ    $1c     link in polled task */
.equ mt.lpoll,0x1c
/* QL: mt.rpoll equ    $1d     remove polled task */
.equ mt.rpoll,0x1d
/* QL: mt.lschd equ    $1e     link in scheduler task */
.equ mt.lschd,0x1e
/* QL: mt.rschd equ    $1f     remove scheduler task */
.equ mt.rschd,0x1f
/* QL: mt.liod equ     $20     link in I/O driver */
.equ mt.liod,0x20
/* QL: mt.riod equ     $21     remove I/O driver */
.equ mt.riod,0x21
/* QL: mt.ldd  equ     $22     link in directory driver */
.equ mt.ldd,0x22
/* QL: mt.rdd  equ     $23     remove directory driver */
.equ mt.rdd,0x23
/* QL: mt.cntry equ    $24     set translate/error tables */
.equ mt.cntry,0x24
/* QL:         list */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL: * The call sequence is kept as simple as possible to avoid having lots of */
/* QL: * complex code in the calling routines. To this end, these preserve the values */
/* QL: * of all registers (except d0/ccr), including their call parameters. */
/* QL: * Setting d0.l to zero on exit is a concession to the fact that the routines */
/* QL: * are available as vectored routines, and can conveniently be "call"'ed. */
/* QL: * The main routines (move and clear) use absolute addresses and may be called */
/* QL: * in either user or supervisor mode. */
/* QL: * The additional entry points must be called in user mode and they then provide */
/* QL: * for switching to supervisor mode and handling source and/or destination as a6 */
/* QL: * relative addresses. */
/* QL: * Moves are always non-destructive. If the source is below the destination and */
/* QL: * overlaps it, this will do the move starting from the top of the areas. */
/* QL: * A bit of a waste on a normal QL, but in order to provide for the astounding */
/* QL: * medusa spec, we'll leave the code so it can actually trundle more than a */
/* QL: * megabyte around! After all, it only costs 32 bytes of code. */
/* QL: * The choice of instruction sequences to acheive the move is based on some very */
/* QL: * exhaustive testing of alternatives. The only improvement could be to employ */
/* QL: * "movem.l", but at some considerable expense for a very minor speed increase.  */
/* QL: * This version is inefficient when called to move small amounts of memory, but */
/* QL: * the current callers are usually asking for much more, or have already spent */
/* QL: * so much time setting up for this that it doesn't matter? */
/* QL: * With normal (slow) internal RAM, the overhead seems to be around about fifty */
/* QL: * bytes worth of move. I.e. it's a moot point whether string copying should use */
/* QL: * this routine, though I believe that it should, as it has already done such a */
/* QL: * vast amount of processing before deciding to move a string, one might just as */
/* QL: * well get the speed improvement for very long strings, without hassle. */
/* QL:         section mm_move */
.section mm_move,"ax"
/* QL: * d0 -  o- 0 (sets ccr) */
/* QL: * d1 -ip - number of bytes to move */
/* QL: * a0 -ip - destination address */
/* QL: * a1 -ip - source address (ignored by clear and clrr) */
/* QL: * a6 -ip - base address (ignored by move and clear) */
/* QL: mm_clrr */
mm_clrr:
/* QL:         moveq   #clrr-mrtor,d0 */
    moveq #(clrr-mrtor),d0
/* QL:         bra.s   mvrel */
    bra.s mvrel
/* QL: mm_mrtoa */
mm_mrtoa:
/* QL:         moveq   #mrtoa-mrtor,d0 */
    moveq #(mrtoa-mrtor),d0
/* QL:         bra.s   mvrel */
    bra.s mvrel
/* QL: mm_mator */
mm_mator:
/* QL:         moveq   #mator-mrtor,d0 */
    moveq #(mator-mrtor),d0
/* QL:         bra.s   mvrel */
    bra.s mvrel
/* QL: mm_mrtor */
mm_mrtor:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: mvrel */
mvrel:
/* QL:         move.l  a2,-(sp) */
    move.l a2,-(sp)
/* QL:         lea     mrtor(pc,d0.w),a2 */
    lea mrtor(pc,d0.w),a2
/* QL:         moveq   #mt.extop,d0 */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 (sets ccr) */
/* QL: * d1 -ip - number of bytes to clear (<=0 = none) */
/* QL: * a0 -ip - address of area to clear */
/* QL: * a6 -ip - base address (clrr only) */
/* QL: clrr */
clrr:
/* QL:         add.l   a6,a0           make address absolute */
    add.l a6,a0
/* QL:         pea     matorex         return via common code */
    pea matorex(pc)
/* QL: mm_clear */
mm_clear:
/* QL:         moveq   #32,d0          this needs tuning, though it's about right */
    moveq #32,d0
/* QL:         cmp.l   d1,d0 */
    cmp.l d1,d0
/* QL:         ble.s   clr32           only do the hoopy clear if a fair bit needed */
    ble.s clr32
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         ble.s   okrts           finished if <= 0 bytes to do here */
    ble.s okrts
/* QL: clr1 */
clr1:
/* QL:         sf      (a0)+           clear small areas a byte at a time */
    sf (a0)+
/* QL:         subq.b  #1,d0 */
    subq.b #1,d0
/* QL: clrq */
clrq:
/* QL:         bne.s   clr1 */
    bne.s clr1
/* QL:         sub.l   d1,a0           restore pointer */
    sub.l d1,a0
/* QL:         rts */
    rts 
/* QL: clr32 */
clr32:
/* QL:         move.l  d1,-(sp)        save original length */
    move.l d1,-(sp)
/* QL:         move.w  a0,d0           check start address */
    move.w a0,d0
/* QL:         lsr.b   #1,d0 */
    lsr.b #1,d0
/* QL:         bcc.s   clreven */
    bcc.s clreven
/* QL:         sf      (a0)+           if odd, clear the initial byte */
    sf (a0)+
/* QL:         subq.l  #1,d1 */
    subq.l #1,d1
/* QL: clreven */
clreven:
/* QL:         moveq   #0,d0           move.l is quicker than clr.l! */
    moveq #0,d0
/* QL:         move.b  d1,-(sp)        save any odd bytes needed at end */
    move.b d1,-(sp)
/* QL:         lsr.l   #5,d1           do rest in blocks of 32 */
    lsr.l #5,d1
/* QL:         bra.s   clre            enter loop */
    bra.s clre
/* QL: clrh */
clrh:
/* QL:         swap    d1 */
    swap d1
/* QL: clrw */
clrw:
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL: clre */
clre:
/* QL:         dbra    d1,clrw */
    dbra d1,clrw
/* QL:         swap    d1 */
    swap d1
/* QL:         dbra    d1,clrh */
    dbra d1,clrh
/* QL:         moveq   #31,d0 */
    moveq #31,d0
/* QL:         and.b   (sp)+,d0        get back any odd bytes that need doing */
    and.b (sp)+,d0
/* QL:         move.l  (sp)+,d1        reload full length */
    move.l (sp)+,d1
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         bra.s   clrq            go do last bit */
    bra.s clrq
/* QL: mrtoa */
mrtoa:
/* QL:         add.l   a6,a1 */
    add.l a6,a1
/* QL:         bsr.s   mm_move */
    bsr.s mm_move
/* QL:         sub.l   a6,a1 */
    sub.l a6,a1
/* QL:         rte */
    rte 
/* QL: mrtor */
mrtor:
/* QL:         add.l   a6,a1 */
    add.l a6,a1
/* QL:         bsr.s   movtor */
    bsr.s movtor
/* QL:         sub.l   a6,a1 */
    sub.l a6,a1
/* QL: matorex */
matorex:
/* QL:         sub.l   a6,a0 */
    sub.l a6,a0
/* QL:         rte */
    rte 
/* QL: mvreg   reg     d5-d6/a0-a1 */
/* QL: * Using "movep" instructions is a little faster than eight single byte moves on */
/* QL: * standard memory. Even quicker on faster memory. */
/* QL: mvpreg  reg     d2-d5   we need some more work registers */
/* QL: mvph */
mvph:
/* QL:         swap    d0 */
    swap d0
/* QL: mvpw */
mvpw:
/* QL:         movep.l 0(a1),d2 */
    movep.l 0(a1),d2
/* QL:         movep.l 1(a1),d3 */
    movep.l 1(a1),d3
/* QL:         movep.l 8(a1),d4 */
    movep.l 8(a1),d4
/* QL:         movep.l 9(a1),d5 */
    movep.l 9(a1),d5
/* QL:         movep.l d2,0(a0) */
    movep.l d2,0(a0)
/* QL:         movep.l d3,1(a0) */
    movep.l d3,1(a0)
/* QL:         movep.l d4,8(a0) */
    movep.l d4,8(a0)
/* QL:         movep.l d5,9(a0) */
    movep.l d5,9(a0)
/* QL: mvpu */
mvpu:
/* QL:         add.l   d6,a1 */
    add.l d6,a1
/* QL:         add.l   d6,a0 */
    add.l d6,a0
/* QL: mvpd */
mvpd:
/* QL:         dbra    d0,mvpw */
    dbra d0,mvpw
/* QL:         swap    d0 */
    swap d0
/* QL:         dbra    d0,mvph */
    dbra d0,mvph
/* QL:         movem.l (sp)+,mvpreg */
    movem.l (sp)+,d2-d5
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bpl.s   mvdbe */
    bpl.s mvdbe
/* QL:         sub.l   d6,a1 */
    sub.l d6,a1
/* QL:         sub.l   d6,a0 */
    sub.l d6,a0
/* QL:         bra.s   mvube */
    bra.s mvube
/* QL: mvp */
mvp:
/* QL:         moveq   #15,d5 */
    moveq #15,d5
/* QL:         and.b   d0,d5 */
    and.b d0,d5
/* QL:         asr.l   #4,d0 */
    asr.l #4,d0
/* QL:         movem.l mvpreg,-(sp) */
    movem.l d2-d5,-(sp)
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bpl.s   mvpd */
    bpl.s mvpd
/* QL:         bra.s   mvpu */
    bra.s mvpu
/* QL: mator */
mator:
/* QL:         pea     matorex */
    pea matorex(pc)
/* QL: movtor */
movtor:
/* QL:         add.l   a6,a0 */
    add.l a6,a0
/* QL: mm_move */
mm_move:
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         ble.s   mvok            don't bother if zero (or negative!) amount */
    ble.s mvok
/* QL:         movem.l mvreg,-(sp) */
    movem.l d5-d6/a0-a1,-(sp)
/* QL:         moveq   #16,d6          flag for move down and maybe "movep" step */
    moveq #16,d6
/* QL:         move.l  a0,d5 */
    move.l a0,d5
/* QL:         sub.l   a1,d5           going up or going down? */
    sub.l a1,d5
/* QL:         bcs.s   mvset           down - start doing it */
    bcs.s mvset
/* QL:         beq.s   mvend           neither - leave memory just where it is! */
    beq.s mvend
/* QL:         cmp.l   d0,d5           do areas overlap? */
    cmp.l d0,d5
/* QL:         bcc.s   mvset           no - we can move down, it's quicker! */
    bcc.s mvset
/* QL:         add.l   d0,a1           top of source */
    add.l d0,a1
/* QL:         add.l   d0,a0           top of destination */
    add.l d0,a0
/* QL:         moveq   #-16,d6         "movep" step and direction flag */
    moveq #(-16),d6
/* QL: mvset */
mvset:
/* QL:         asr.b   #1,d5           is move travelling an odd distance? */
    asr.b #1,d5
/* QL:         bcs.s   mvp             yes - use "movep" instructions */
    bcs.s mvp
/* QL:         move.w  a1,d5 */
    move.w a1,d5
/* QL:         asr.b   #1,d5           are addresses currently odd? */
    asr.b #1,d5
/* QL:         bcc.s   mvword */
    bcc.s mvword
/* QL:         subq.l  #1,d0           yes - count one off the total */
    subq.l #1,d0
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bmi.s   mv1up */
    bmi.s mv1up
/* QL:         move.b  (a1)+,(a0)+     move odd byte to get both on word bdrys */
    move.b (a1)+,(a0)+
/* QL:         bra.s   mvword */
    bra.s mvword
/* QL: mvub */
mvub:
/* QL:         move.b  -(a1),-(a0) */
    move.b -(a1),-(a0)
/* QL: mvube */
mvube:
/* QL:         dbra    d5,mvub */
    dbra d5,mvub
/* QL:         bra.s   mvend */
    bra.s mvend
/* QL: mvdb */
mvdb:
/* QL:         move.b  (a1)+,(a0)+ */
    move.b (a1)+,(a0)+
/* QL: mvdbe */
mvdbe:
/* QL:         dbra    d5,mvdb */
    dbra d5,mvdb
/* QL: mvend */
mvend:
/* QL:         movem.l (sp)+,mvreg */
    movem.l (sp)+,d5-d6/a0-a1
/* QL: mvok */
mvok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: mvulh */
mvulh:
/* QL:         swap    d0 */
    swap d0
/* QL: mvulw */
mvulw:
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL: mvule */
mvule:
/* QL:         dbra    d0,mvulw */
    dbra d0,mvulw
/* QL:         swap    d0 */
    swap d0
/* QL:         dbra    d0,mvulh */
    dbra d0,mvulh
/* QL:         bra.s   mvube */
    bra.s mvube
/* QL: mvdlh */
mvdlh:
/* QL:         swap    d0 */
    swap d0
/* QL: mvdlw */
mvdlw:
/* QL: * We've taken so long getting here, make it worth our while! */
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL: mvdle */
mvdle:
/* QL:         dbra    d0,mvdlw */
    dbra d0,mvdlw
/* QL:         swap    d0 */
    swap d0
/* QL:         dbra    d0,mvdlh */
    dbra d0,mvdlh
/* QL:         bra.s   mvdbe */
    bra.s mvdbe
/* QL: mv1up */
mv1up:
/* QL:         move.b  -(a1),-(a0) */
    move.b -(a1),-(a0)
/* QL: mvword */
mvword:
/* QL:         moveq   #31,d5          addresses even, move 32 bytes at a go */
    moveq #31,d5
/* QL:         and.l   d0,d5 */
    and.l d0,d5
/* QL:         lsr.l   #5,d0 */
    lsr.l #5,d0
/* QL:         tst.w   d6 */
    tst.w d6
/* QL:         bpl.s   mvdle */
    bpl.s mvdle
/* QL:         bra.s   mvule */
    bra.s mvule
/* QL:         vect4000 mm_clear,mm_clrr,mm_mator,mm_move,mm_mrtoa,mm_mrtor */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl mm$clear
/* QL: [o]     equ     [h]-$4000 */
.equ mm$clear,(mm_clear-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl mm$clrr
/* QL: [o]     equ     [h]-$4000 */
.equ mm$clrr,(mm_clrr-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl mm$mator
/* QL: [o]     equ     [h]-$4000 */
.equ mm$mator,(mm_mator-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl mm$move
/* QL: [o]     equ     [h]-$4000 */
.equ mm$move,(mm_move-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl mm$mrtoa
/* QL: [o]     equ     [h]-$4000 */
.equ mm$mrtoa,(mm_mrtoa-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl mm$mrtor
/* QL: [o]     equ     [h]-$4000 */
.equ mm$mrtor,(mm_mrtor-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
