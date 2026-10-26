
|*********************************************************
|*                                                       *
|*     NET_ROUTINES   net_routines                       *
|*                                                       *
|*********************************************************       

l05478:	btst #0x04,0x00a0(a6)
	bne.s l0549a
	lea 0x00018020,a3
	lea -0x001e(a3),a2
	moveq #0x18,d0
	jsr l00420:l
	nop | * !!! to conform asm - leave it out !!!
	ori.w #0x0700,sr
	moveq #0x00,d7
	rts

l0549a:	addq.w #4,a7
	moveq #-0x01,d0
	bra.w l055a8

l054a2:	movem.l d4-d7,-(a7)
	clr.w 0x001c(a0)
	bsr.s l05478
l054ac:	move.w #0x16e2,d4
l054b0:	move.w #0x01b5,d0
l054b4:	btst d7,(a3)
	beq.s l054be
	dbf d4,l054b0
	bra.s l05532

l054be:	dbf d0,l054b4
	move.w #0x0c34,d0
l054c6:	btst d7,(a3)
	bne.s l054d0
	dbf d0,l054c6
	bra.s l05532

l054d0:	move.w #0x00da,d0
l054d4:	dbf d0,l054d4
	lea 0x0020(a0),a1
	moveq #0x08,d1
	bsr.w l055b4
	blt.s l054ac
	sub.b -(a1),d3
	cmp.b (a1),d3
	bne.s l054ac
	subq.w #7,a1
	move.w 0x0018(a0),d3
	ror.w #8,d3
	tst.b d3
	beq.s l05500
	cmp.b 0x0019(a0),d3
	beq.s l05500
	cmp.w (a1),d3
	bra.s l05504

.balign 2, 0 ; l05500:	.long 0xb6290000 | * ½ CMP.B  $0000(A1),D3
|* !!! ABOVE INSERTED 'CAUSE ASM COMPILES SHORT (CORRECT) TO:
|* CMP.B  (A1),D3 - 2 BYTES LESS AND FASTER - CHANGE IT !!!
l05504:	bne.s l05532
	move.w 0x0002(a1),d6
	sub.w 0x001a(a0),d6
	bne.s l05516
	move.l 0x0004(a1),0x001c(a0)

l05516:	bsr.w l0563a
	move.b 0x001d(a0),d1
	bsr.w l055b4
	bne.s l05532
	cmp.b 0x001e(a0),d3
	bne.s l05532
	bsr.w l0563a
	tst.w d6
	beq.s l05592
l05532:	clr.w 0x001c(a0)
	bra.s l055a0

l05538:	movem.l d4-d7,-(a7)
	bsr.w l05478
	move.b 0x001d(a0),d1
	moveq #0x00,d3
	lea 0x0020(a0),a1
l0554a:	add.b (a1)+,d3
	subq.b #1,d1
	bne.s l0554a
	move.b d3,0x001e(a0)
	moveq #0x07,d1
	moveq #0x00,d3
	lea 0x0018(a0),a1
l0555c:	add.b (a1)+,d3
	subq.b #1,d1
	bne.s l0555c
	move.b d3,(a1)
	subq.w #7,a1
	bsr.w l055f2
	bne.s l055a2
	moveq #0x08,d1
	moveq #0x01,d5
l05570:	bsr.w l05648
	moveq #0x01,d1
	lea 0x001f(a0),a1
	bsr.s l055b4
	beq.s l05586
	tst.b 0x0018(a0)
	bne.s l055a0
	moveq #0x01,d3
l05586:	subq.b #1,d3
	bne.s l055a0
	move.b 0x001d(a0),d1
	dbf d5,l05570
l05592:	addq.b #1,0x001a(a0)
	bcc.s l0559c
	addq.b #1,0x001b(a0)
l0559c:	moveq #0x00,d0
	bra.s l055a2

l055a0:	moveq #-0x01,d0
l055a2:	jsr l00452:l
	nop | * !!! to conform asm - leave it out !!!
l055a8:	andi.w #0xf8ff,sr
	movem.l (a7)+,d4-d7
	tst.l d0
	rts

l055b4:	move.w #0x018f,d0
	moveq #0x00,d3
l055ba:	btst d7,(a3)
	beq.s l055c0
	bra.s l055c6

l055c0:	dbf d0,l055ba
	bra.s l055ee

l055c6:	moveq #0x46,d0
l055c8:	btst d7,(a3)
	dbeq d4,l055c8
	bne.s l055ee
	moveq #0x07,d4
	moveq #0x13,d0
l055d4:	ror.b d0,d7
	move.b (a3),d0
	roxr.b #1,d0
	roxr.b #1,d2
	moveq #0x06,d0
	dbf d4,l055d4
	move.b d2,(a1)+
	add.b d2,d3
	subq.b #1,d1
	bne.s l055c6
l055ea:	moveq #0x00,d0
	rts

l055ee:	moveq #-0x01,d0
	rts

l055f2:	moveq #0x73,d0
	mulu 0x002e(a6),d0
	move.w d0,0x002e(a6)
	ext.w d0
	addi.w #0x0297,d0
l05602:	btst d7,(a3)
	bne.s l055ee
	dbf d0,l05602
	move.b 0x0019(a0),d4
	not.b d4
	move.b 0x00a0(a6),d2
	moveq #0x09,d1
l05616:	lsl.b #1,d4
	rol.b #1,d2
	roxr.b #1,d2
	move.b d2,(a2)
	bmi.s l0562e
	moveq #0x05,d0
l05622:	btst d7,(a3)
	beq.s l05628
	bra.s l055ee

l05628:	dbf d0,l05622
	bra.s l05634

l0562e:	moveq #0x10,d0
l05630:	dbf d0,l05630
l05634:	dbf d1,l05616
l05638:	bra.s l055ea

l0563a:	tst.b 0x0018(a0)
	beq.s l055ea
	moveq #0x01,d1
	move.w #0xff01,d4
	bra.s l0564c

l05648:	moveq #-0x01,d4
l0564a:	move.b (a1)+,d4
l0564c:	lsl.w #1,d4
	rol.w #2,d4
	moveq #0x0c,d3
	move.b 0x00a0(a6),d0
l05656:	asr.w #1,d4
	rol.b #1,d0
	roxr.b #1,d0
	moveq #0x00,d7
	move.b d0,(a2)
	subq.w #1,d3
	bge.s l05656
	subq.b #1,d1
	bne.s l0564a
	move.b 0x00a0(a6),(a2)
	bra.s l05638

|****** END NET_ROUTINES net_routines
