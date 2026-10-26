
|************************
|*
|*    MDV_MAIN
|*
|**************************

.balign 2, 0 ; l01230:	.long 0x00000000 | * free for link pointer
.balign 2, 0 ; 	.long l01274 | * entry input / output
.balign 2, 0 ; 	.long l01730 | * entry addr. open channel
.balign 2, 0 ; 	.long l018b8 | * entry addr. close channel
.balign 2, 0 ; 	.long l029fc | * service routine
.balign 2, 0 ; 	.long 0x00 | * reserved
.balign 2, 0 ; 	.long 0x00 | * reserved
.balign 2, 0 ; 	.long l05000 | * entry addr format
.balign 2, 0 ; 	.long 0x428 | * lenght of physi. def. block
.balign 2, 0 ; 	.word 0x03
|;       DC.W    'MDV'		* Error : Cannot fit value 0x4d4456 (5063766) into word
.balign 2, 0 ; 	.long 0x004d4456

l0125a:
	movem.l d0/d2/d4-d7/a4-a5,-(a7) | * main mdv
l0125e:	movem.l (a7),d0/d2
	moveq #0x00,d3
	bsr.s l01274
	addq.l #1,d0
	beq.s l0125e
	subq.l #1,d0
	addq.w #4,a7
	movem.l (a7)+,d2/d4-d7/a4-a5
	rts

l01274:	moveq #0x00,d6 | * select mdv-routine
	move.b 0x001d(a0),d6
	lsl.b #2,d6
	lea 0x0100(a6),a2
	movea.l 0x00(a2,d6.w),a2
	lsl.b #2,d6
	cmpi.b #0x40,d0
	bcs.w l0135e
	cmpi.b #0x49,d0
	bhi.s l012a6
	move.b l0129c-0x40(pc,d0.w),d0
	jmp l0129c(pc,d0.w)

l0129c:	.byte xlverif-l0129c
	.byte xltrans-l0129c
	.byte xlposad-l0129c
	.byte xlposrad-l0129c
	.byte xlbadpar-l0129c
	.byte xlinfmd-l0129c
	.byte xlwrhead-l0129c
	.byte xlrehead-l0129c
	.byte xlloadmd-l0129c
	.byte xlsavemd-l0129c

lbadpar:
.equ xlbadpar, lbadpar
l012a6:	moveq #-0x0f,d0
	rts

lverif:
.equ xlverif, lverif
	moveq #0x03,d4
	moveq #-0x01,d5
	bra.s l012b4

ltrans:
.equ xltrans, ltrans
l012b0:	moveq #0x0c,d4
	moveq #0x00,d5

l012b4:	move.b 0x001d(a0),d3
	lsl.b #4,d3
	bset #0x00,d3
	move.w 0x001e(a0),d2
	movea.l 0x0058(a6),a4
l012c6:	moveq #-0x0f,d0
	and.b (a4),d0
	cmp.b d3,d0
	bne.s l012de
	cmp.w 0x0004(a4),d2
	bne.s l012de
	move.b (a4),d0
	eor.b d5,d0
	and.w d4,d0
	bne.w l0151c
l012de:	addq.w #8,a4
	cmpa.l 0x005c(a6),a4
	blt.s l012c6
	moveq #0x00,d0
	rts

lposad:
.equ xlposad, lposad
	jsr l01926(pc)
	bra.s l012f8

lposrad:
.equ xlposrad, lposrad
	tst.l d3
	bne.s l012f8
	jsr l0192c(pc)
l012f8:	moveq #0x00,d0
	bra.s l01362

linfmdv:
.equ xlinfmd, linfmdv
	lea 0x0016(a2),a3
	move.l (a3)+,(a1)+
	move.l (a3)+,(a1)+
	move.w (a3)+,(a1)+
	move.w #0x01fc,d0
	moveq #0x00,d1
	moveq #0x01,d2
l0130e:	cmpi.b #0xfd,0x28(a2,d0.w)
	bhi.s l0131c
	bne.s l0131a
	addq.w #1,d1
l0131a:	addq.w #1,d2
l0131c:	subq.w #2,d0
	bne.s l0130e
	swap d1
	move.w d2,d1
	rts

lloadmd:
.equ xlloadmd, lloadmd
	moveq #0x03,d0
	cmpi.l #l01000,d2
	blt.s l01362
	bsr.w l012b0
	beq.w l015da
	rts

lsavemdv:
.equ xlsavemd, lsavemdv
	moveq #0x07,d0
	bra.s l01362

lrehead:
.equ xlrehead, lrehead
	moveq #0x03,d0
	move.l a1,-(a7)
	bsr.s l01350
	moveq #0x40,d4
	movea.l (a7)+,a2
	sub.l d4,(a2)
	rts

lwrhead:
.equ xlwrhead, lwrhead
	moveq #0x07,d0
	moveq #0x0e,d2
l01350:	clr.l 0x0020(a0)
	bsr.s l0135e
	move.w #0x0040,0x0022(a0)
	rts

l0135e:	ext.l d1
	ext.l d2
l01362:	cmpi.b #0x07,d0
	bhi.w l012a6
	moveq #0x00,d7
	tst.l d3
	beq.s l01372
	sub.l d1,d7
l01372:	subq.b #4,d0
	beq.w l012a6
	blt.s l0138e
	cmpi.b #0x01,0x001c(a0)
	beq.s l013be
	moveq #-0x01,d3
	subq.w #2,d0
	beq.w l012a6
	blt.s l013ae
	bgt.s l013a0
l0138e:	moveq #0x00,d3
	addq.b #4,d0
	beq.s l013ae
	move.w #0x0100,d3
	subq.b #2,d0
	blt.s l013ae
	bgt.s l013a0
	moveq #0x0a,d3
l013a0:	add.l a1,d7
	move.l d7,-(a7)
	add.l d2,d7
	bsr.s l013c2
	move.l a1,d1
	sub.l (a7)+,d1
	rts

l013ae:	move.l d1,-(a7)
	lea 0x0003(a7),a1
	move.l a1,d7
	addq.l #1,d7
	bsr.s l013c2
	move.l (a7)+,d1
	rts

l013be:	moveq #-0x14,d0
	rts

l013c2:	tst.b 0x0023(a2)
	bge.s l013cc
l013c8:	moveq #-0x10,d0
	rts

l013cc:	move.l 0x001e(a0),d5
	move.l 0x0020(a0),d4
	cmp.l 0x0024(a0),d4
	blt.s l013e8
	bgt.s l013e0
	tst.b d3
	blt.s l013e4
l013e0:	moveq #-0x0a,d0
l013e2:	rts

l013e4:	tst.w d4
	beq.s l0140c
l013e8:	bsr.w l014d6
	bne.s l013e2
	tst.w d4
	bne.s l01422
	move.l a4,-(a7)
	addq.w #1,d5
	moveq #0x00,d2
	move.w d5,d2
	swap d2
	cmp.l 0x0024(a0),d2
	bge.s l01406
	bsr.w l014e2
l01406:	movea.l (a7)+,a4
	subq.w #1,d5
	bra.s l01422

l0140c:	cmp.l a1,d7
	bls.w l01496
	bsr.w l0159e
	bsr.w l01524
	move.w d0,0x0002(a4)
	ori.b #0x03,(a4)
l01422:	move.l a4,0x0028(a0)
	btst #0x01,(a4)
	beq.w l0151c
	tst.w d3
	beq.s l01496
	move.l a4,d0
	sub.l 0x0058(a6),d0
	lsl.l #6,d0
	movea.l d0,a5
	adda.l a6,a5
	adda.w d4,a5
	tst.w d3
	bgt.s l01464
l01444:	cmp.l a1,d7
	bls.s l01452
	move.b (a1)+,(a5)+
	bsr.s l014a2
	bne.s l01444
	jsr l029fc(pc)
l01452:	st 0x002c(a0)
	bsr.s l014b6
	cmp.l 0x0024(a0),d4
	blt.s l0147e
	move.l d4,0x0024(a0)
	bra.s l0147e

l01464:	moveq #0x00,d0
l01466:	cmp.l a1,d7
	bls.s l0147e
	cmp.l 0x0024(a0),d4
	bge.s l0149a
	move.b (a5)+,d0
	move.b d0,(a1)+
	cmp.w d0,d3
	bne.s l0147a
	move.l a1,d7
l0147a:	bsr.s l014a2
	bne.s l01466
l0147e:	move.l d4,0x0020(a0)
	cmp.l a1,d7
	bhi.w l013c2
	cmpi.w #0x000a,d3
	bne.s l01496
	cmp.b d0,d3
	beq.s l01496
	moveq #-0x05,d0
	rts

l01496:	moveq #0x00,d0
	rts

l0149a:	move.l d4,0x0020(a0)
	bra.w l013e0

l014a2:	addq.w #1,d4
	btst #0x09,d4
	beq.s l014b2
	addq.w #1,d5
	addi.l #0xfe00,d4
l014b2:	tst.w d4
	rts

l014b6:	moveq #0x07,d0
	or.b d6,d0
	move.b d0,(a4)
l014bc:	move.l a4,d1
	sub.l 0x0058(a6),d1
	lsr.l #3,d1
	adda.w 0x0002(a4),a2
	move.w d1,0x0228(a2)
	suba.w 0x0002(a4),a2
	sf 0x0024(a2)
	rts

l014d6:	movea.l 0x0028(a0),a4
	move.l a4,d0
	bne.s l014e2
	movea.l 0x0058(a6),a4
l014e2:	movea.l a4,a5
l014e4:	moveq #0x0e,d0
	and.b (a4),d0
	beq.s l014fa
	moveq #-0x10,d0
	and.b (a4),d0
	cmp.b d0,d6
	bne.s l014fa
	moveq #0x00,d0
	cmp.l 0x0004(a4),d5
	beq.s l01522
l014fa:	addq.l #8,a4
	cmpa.l 0x005c(a6),a4
	blt.s l01506
	movea.l 0x0058(a6),a4
l01506:	cmpa.l a4,a5
	bne.s l014e4
	bsr.w l01598
	bsr.w l0159e
	move.w d0,0x0002(a4)
	ori.b #0x09,(a4)
	bsr.s l014bc
l0151c:	jsr l029fc(pc)
l01520:	moveq #-0x01,d0
l01522:	rts

l01524:	bsr.s l0157a
	subq.b #1,d2
	bcc.s l01532
	moveq #-0x28,d0
	add.w 0x0226(a2),d0
	bra.s l01534

l01532:	bsr.s l01586
l01534:	subi.w #0x0018,d0
	bge.s l0154a
	move.w #0x01fe,d1
l0153e:	subq.w #2,d1
	cmpi.b #0xff,0x28(a2,d1.w)

	beq.s l0153e
	add.w d1,d0
l0154a:	move.w d0,-(a7)
l0154c:	subq.w #2,d0
	bpl.s l01554
	move.w #0x01fc,d0
l01554:	cmpi.b #0xfd,0x28(a2,d0.w)
	beq.s l01566
	cmp.w (a7),d0
	bne.s l0154c
	addq.w #6,a7
	moveq #-0x0b,d0
	rts

l01566:	addq.b #1,d2
	move.w d2,0x28(a2,d0.w)
	move.w d0,0x0226(a2)
	move.w #-1,0x0228(a2)
	addq.w #2,a7
	rts

l0157a:	move.w #0x01fe,d0
	move.l d5,d2
	lsl.w #8,d2
	lsr.l #8,d2
	rts

l01586:	subq.w #2,d0
	blt.s l01592
	cmp.w 0x28(a2,d0.w),d2
	bne.s l01586
	rts

l01592:	addq.w #8,a7
	bra.w l013c8

l01598:	bsr.s l0157a
	bsr.s l01586
	rts

l0159e:	movea.l 0x0054(a6),a4
	movea.l a4,a5
l015a4:	addq.w #8,a4
	cmpa.l 0x005c(a6),a4
	blt.s l015b0
	movea.l 0x0058(a6),a4
l015b0:	moveq #0x0f,d1
	and.b (a4),d1
	subq.b #1,d1
	beq.s l015c6
	subq.b #2,d1
	beq.s l015c6
	cmpa.l a5,a4
	bne.s l015a4
	addq.w #4,a7
	bra.w l01520

l015c6:	move.l a4,0x0054(a6)
	move.l a4,0x0028(a0)
	move.b d6,(a4)
	ori.b #0x01,(a4)
	move.l d5,0x0004(a4)
	rts

l015da:	jsr l0159e(pc)
	subq.l #8,0x0054(a6)
	move.l a4,d0
	sub.l 0x0058(a6),d0
	lsl.l #6,d0
	movea.l d0,a4
	adda.l a6,a4
	jsr l029fc(pc)
	lea 0x00018020,a3
	andi.b #0xdf,0x0035(a6)
	move.b 0x0035(a6),0x0001(a3)
	lsl.l #8,d0
	cmp.b 0x00ee(a6),d1
	beq.s l01612
	moveq #-0x01,d0
	bra.w l01724

l01612:	moveq #0x07,d0
	lea 0x0058(a0),a5
l01618:	clr.l (a5)+
	dbf d0,l01618
	move.l 0x0024(a0),d2
	tst.w d2
	bne.s l0162c
	subi.l #0xfe00,d2
l0162c:	move.l d2,0x0020(a0)
	swap d2
	move.w d2,d0
	lsr.w #3,d0
	lea 0x0058(a0),a5
	bra.s l0163e

l0163c:	st (a5)+
l0163e:	dbf d0,l0163c
	move.w #0xff01,d1
	moveq #0x07,d0
	and.w d2,d0
	rol.w d0,d1
	move.b d1,(a5)
	suba.w #0x0040,a1
	movem.l a0-a2/a4,-(a7)
l01656:	andi.w #0xf8ff,sr
	ori.w #0x0700,sr
l0165e:	movea.l (a7),a0
	lea 0x0078(a0),a1
	jsr l0523a:l
	bra.s l016d6 | * ERROR
	bra.s l01656 | * ERROR
	movem.l (a7),a0-a2/a4 | * SUCCESS
	add.w d7,d7
	beq.w l016fc
	move.b 0x28(a2,d7.w),d0
	cmp.b 0x001f(a0),d0
	bne.s l01656
	moveq #0x00,d4
	move.b 0x29(a2,d7.w),d4
	move.l d4,d7
	moveq #0x07,d5
	and.w d4,d5
	lsr.w #3,d4
	btst d5,0x58(a0,d4.w)
	beq.s l01656
	movea.w d4,a5
	movea.l a4,a1
	jsr l0525c:l
	bra.s l0165e | * ERROR
	movem.l (a7),a0-a2/a4 | * SUCCESS
	bclr d5,0x58(a0,a5.w)
	move.l #0x00000080,d0
	movea.l a1,a5
	move.l d7,d1
	lsl.w #8,d1
	add.l d1,d1
	adda.l d1,a5
	cmp.w 0x0020(a0),d7
	bne.s l016c6
	move.w 0x0022(a0),d0
	ror.l #2,d0
l016c6:	tst.w d7
	bne.s l016da
	moveq #0x40,d1
	adda.w d1,a4
	adda.w d1,a5
	subi.w #0x0010,d0
	bra.s l016da

l016d6:	bra.s l0170a

l016d8:	move.l (a4)+,(a5)+
l016da:	dbf d0,l016d8
	clr.w d0
	rol.l #2,d0
	bra.s l016e6

l016e4:	move.b (a4)+,(a5)+
l016e6:	dbf d0,l016e4
	moveq #0x08,d0
	lea 0x0058(a0),a5
l016f0:	tst.l (a5)+
	bne.w l0165e
	subq.w #1,d0
	bgt.s l016f0
	bra.s l0170c

l016fc:	addq.b #1,0x0024(a2)
	cmpi.b #0x08,0x0024(a2)
	blt.w l01656
l0170a:	moveq #-0x10,d0
l0170c:	movem.l (a7)+,a0-a2/a4
	sf 0x0024(a2)
	moveq #0x00,d7
	move.w 0x0024(a0),d7
	lsl.l #8,d7
	add.l d7,d7
	adda.l d7,a1
	adda.w 0x0026(a0),a1
l01724:	ori.b #0x20,0x0035(a6)
	andi.w #0xf8ff,sr
	rts

l01730:	movea.l a1,a2 | * open mdv-channel
	moveq #0x00,d1
	move.b 0x0014(a2),d1
	moveq #0x00,d0
	move.b 0x001d(a0),d0
	lsl.b #2,d0
	lea 0x00ee(a6),a4
	move.b d0,0x01(a4,d1.w)
	cmp.b (a4),d1
	beq.s l01766
	tst.b 0x07(a4,d1.w)
	bne.s l01766
	move.b #0x01,0x0023(a2)
	jsr l02a00(pc)
l0175c:	tst.b 0x0023(a2)
	bgt.s l0175c
	bmi.w l01844
l01766:	lea 0x0058(a0),a4
	moveq #0x40,d2
	move.l d2,0x0024(a0)
	moveq #-0x01,d3
	bsr.w l0184c
	move.l (a4),d4
	move.l d4,d0
	lsl.l #7,d0
	lsr.w #7,d0
	move.l d0,0x0024(a0)
	cmpi.b #0x04,0x001c(a0)
	beq.w l01840
	lsr.l #6,d4
	moveq #0x00,d5
	moveq #0x00,d6
	bra.s l017be

l01794:	bsr.w l0184c
	tst.l (a4)
	beq.s l017b8
	move.l a0,-(a7)
	move.l a6,-(a7)
	suba.l a6,a6
	lea 0x000e(a4),a1
	lea 0x0032(a0),a0
	moveq #0x01,d0
	jsr l03a9c(pc) | * UT.CSTR
	movea.l (a7)+,a6
	movea.l (a7)+,a0
	beq.s l01822
	bra.s l017be

l017b8:	tst.w d6
	bne.s l017be
	move.w d5,d6
l017be:	addq.w #1,d5
	cmp.w d4,d5
	blt.s l01794
	move.b 0x001c(a0),d0
	blt.s l01840
	cmpi.b #0x02,d0
	blt.s l01844
	tst.w d6
	beq.s l017e2
	move.l d6,d0
	lsl.l #6,d0
	lsl.l #7,d0
	lsr.w #7,d0
	move.l d0,0x0020(a0)
	move.l d6,d5
l017e2:	move.l d2,(a4)+
	clr.w (a4)+
	clr.l (a4)+
	clr.l (a4)+
	moveq #0x09,d0
	lea 0x0032(a0),a5
l017f0:	move.l (a5)+,(a4)+
	dbf d0,l017f0
	lea 0x0058(a0),a4
	bsr.s l01850
	tst.w d6
	bne.s l01810
	addq.w #1,d4
	lsl.l #6,d4
	move.l d4,(a4)
	clr.l 0x0020(a0)
	moveq #0x04,d2
	bsr.s l01850
	moveq #0x40,d2
l01810:	move.l d2,(a4)
	clr.l 0x0020(a0)
	clr.l 0x0024(a0)
	move.w d5,0x001e(a0)
	bsr.s l01850
	bra.s l01840

l01822:	move.b 0x001c(a0),d0
	blt.s l0185e
	cmpi.b #0x02,d0
	bge.s l01848
	move.l (a4),d0
	lsl.l #7,d0
	lsr.w #7,d0
	move.l d0,0x0024(a0)
	move.w d5,0x001e(a0)
	move.l d2,0x0020(a0)
l01840:	moveq #0x00,d0
	bra.s l0184a

l01844:	moveq #-0x07,d0
	bra.s l0184a

l01848:	moveq #-0x08,d0
l0184a:	rts

l0184c:	moveq #0x03,d0
	bra.s l01852

l01850:	moveq #0x07,d0
l01852:	movea.l a4,a1
	jsr l0125a(pc)
	beq.s l0184a
	addq.w #4,a7
	rts

l0185e:	moveq #-0x40,d1
	jsr l0192c(pc)
	clr.l (a4)
	clr.w 0x000e(a4)
	bsr.s l01850
	move.w #0x01fe,d0
	lea 0x28(a2,d0.w),a4
l01874:	cmp.b (a4),d5
	bne.s l01880
	move.w #0xfd00,(a4)
	clr.w 0x0200(a4)
l01880:	subq.w #2,a4
	subq.w #2,d0
	bne.s l01874
	move.b 0x001d(a0),d1
	lsl.b #4,d1
	addq.w #1,d1
	movea.l 0x0058(a6),a4
l01892:	moveq #-0x0f,d0
	and.b (a4),d0
	cmp.b d0,d1
	bne.s l018a4
	cmp.w 0x0004(a4),d5
	bne.s l018a4
	move.b #0x01,(a4)
l018a4:	addq.w #8,a4
	cmpa.l 0x005c(a6),a4
	blt.s l01892
	move.w #-1,0x0228(a2)
	jsr l029fc(pc)
	bra.s l01840

l018b8:	tst.b 0x002c(a0) | * close mdv-channel
	beq.s l018f0
	move.l 0x0024(a0),d0
	lsl.w #7,d0
	lsr.l #7,d0
	lea 0x0058(a0),a1
	move.l d0,(a1)
	clr.l 0x0020(a0)
	bsr.s l0191a
	moveq #0x00,d0
	move.w 0x001e(a0),d0
	lsl.l #6,d0
	lsl.l #7,d0
	lsr.w #7,d0
	move.l d0,0x0020(a0)
	clr.w 0x001e(a0)
	st 0x0025(a0)
	bsr.s l0191a
	jsr l029fc(pc)
l018f0:	moveq #0x00,d0
	move.b 0x001d(a0),d0
	lsl.b #2,d0
	lea 0x0100(a6),a2
	movea.l 0x00(a2,d0.w),a2
	subq.b #1,0x0022(a2)
	lea 0x0140(a6),a1
	lea 0x0018(a0),a0
	jsr l039e2(pc) | * UT.UNLNK
	lea -0x0018(a0),a0
	jsr l0305e(pc) | * MT.RECHP
	rts

l0191a:	moveq #0x07,d0
	moveq #0x04,d2
	jsr l0125a(pc)
	suba.w d1,a1
	rts

l01926:	moveq #0x40,d2
	add.l d2,d1
	bra.s l01938

l0192c:	moveq #0x40,d2
	move.l 0x0020(a0),d0
l01932:	lsl.w #7,d0
	lsr.l #7,d0
	add.l d0,d1
l01938:	move.l d1,d0
	lsl.l #7,d0
	lsr.w #7,d0
	cmp.l 0x0024(a0),d0
	ble.s l0194c
	move.l 0x0024(a0),d0
	moveq #0x00,d1
	bra.s l01932

l0194c:	sub.l d2,d1
	bge.s l01954
	move.l d2,d1
	bra.s l01938

l01954:	move.l d0,0x0020(a0)
	rts

|*** ---------End MDV_MAIN mdv_main---
