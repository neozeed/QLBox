
|**************
|*
|* BASIC3_ASM  basic3_asm
|*
|**************
l072c2:	movem.l d4/a0/a3-a5,-(a7)
	move.b 0x01(a6,a3.l),d0
	andi.b #0x0f,d0
	subq.b #2,d0
	bgt.s l072ee
	beq.s l072f8
	cmpi.b #0x03,0x00(a6,a3.l)
	beq.s l072e4
	addq.b #2,d0
	bgt.s l07350
	bra.w l07396

l072e4:	addq.b #2,d0
	bgt.w l073b4
	bra.w l073be

l072ee:	moveq #0x02,d1
	bsr.s l07308
	add.l d1,0x0058(a6)
	bra.s l07330

l072f8:	moveq #0x06,d1
	bsr.s l07308
	move.l 0x02(a6,a1.l),0x02(a6,a0.l)
	add.l d1,0x0058(a6)
	bra.s l07330

l07308:	move.l 0x04(a6,a3.l),d4
	bge.s l07310
	bsr.s l07338
l07310:	movea.l 0x0028(a6),a0
	adda.l d4,a0
	movea.l 0x0058(a6),a1
	move.w 0x00(a6,a1.l),0x00(a6,a0.l)
l07320:	moveq #0x01,d0
	sub.b 0x00(a6,a3.l),d0
	blt.s l07334
	move.b #0x02,0x00(a6,a3.l)
	bra.s l07334

l07330:	movem.l (a7)+,d4/a0/a3-a5
l07334:	moveq #0x00,d0
	rts

l07338:	movem.l a2-a3,-(a7)
	jsr l04df6(pc)
	movem.l (a7)+,a2-a3
	move.l a0,d4
	sub.l 0x0028(a6),d4
	move.l d4,0x04(a6,a3.l)
	rts

l07350:	bsr.s l073c6
	andi.l #0xffff,d1
	move.l 0x04(a6,a3.l),d4
	blt.s l07382
	movea.l 0x0028(a6),a0
	adda.l d4,a0
	moveq #0x01,d2
	add.w 0x00(a6,a0.l),d2
	bclr #0x00,d2
	cmp.w d1,d2
	beq.s l07388
	addq.l #2,d2
	movem.l d1/a1/a3,-(a7)
	move.l d2,d1
	jsr l04fe8(pc)
	movem.l (a7)+,d1/a1/a3
l07382:	addq.l #2,d1
	bsr.s l07338
	subq.l #2,d1
l07388:	bsr.s l073de
	bsr.s l073ec
	moveq #0x00,d0
	moveq #0x00,d2
	bsr.s l07400
	bsr.s l07320
l07394:	bra.s l07330

l07396:	move.b #0x01,0x01(a6,a3.l)
	bsr.s l073c6
	subq.w #1,d5
	addq.w #2,a2
	adda.w d5,a2
	movea.l a2,a0
	sub.w d5,d6
	move.w d6,d2
	bsr.w l0743c
	addq.w #2,a1
l073b0:	bsr.s l07400
	bra.s l07394

l073b4:	bsr.s l073c6
	bsr.s l0742c
	bsr.s l073de
	bsr.s l073ec
	bra.s l073b0

l073be:	bsr.s l073c6
	bsr.s l0742c
	bsr.s l073de
	bra.s l073b0

l073c6:	movea.l 0x0058(a6),a1
	moveq #0x00,d1
	move.w 0x00(a6,a1.l),d1
	move.w d1,d0
	swap d1
	move.w d0,d1
	addq.w #1,d1
	bclr #0x00,d1
	rts

l073de:	movea.l 0x0028(a6),a0
	adda.l d4,a0
	movea.l 0x0058(a6),a1
	addq.w #2,a1
	rts

l073ec:	move.w -0x02(a6,a1.l),0x00(a6,a0.l)
	cmp.w 0x00(a6,a0.l),d1
	bcc.s l073fc
	move.w d1,0x00(a6,a0.l)
l073fc:	addq.w #2,a0
	rts

l07400:	tst.w d1
l07402:	beq.s l07412
	move.b 0x00(a6,a1.l),0x00(a6,a0.l)
	addq.w #1,a0
	addq.w #1,a1
	subq.w #1,d1
	bra.s l07402

l07412:	tst.w d2
l07414:	beq.s l07422
	move.b #0x20,0x00(a6,a0.l)
	addq.w #1,a0
	subq.w #1,d2
	bra.s l07414

l07422:	adda.w d0,a1
	move.l a1,0x0058(a6)
	moveq #0x00,d0
	rts

l0742c:	movea.l 0x04(a6,a3.l),a0
	adda.l 0x0028(a6),a0
	move.w 0x06(a6,a0.l),d2
	move.l 0x00(a6,a0.l),d4
l0743c:	move.w d1,d0
	swap d1
	cmp.w d2,d1
	bhi.s l0744a
	sub.w d1,d2
	sub.w d1,d0
	rts

l0744a:	move.w d2,d1
	sub.w d2,d0
	moveq #0x00,d2
	rts

l07452:	move.b 0x01(a6,a3.l),d5
	lsr.b #4,d5
	andi.b #0x0f,0x01(a6,a3.l)
	addq.w #8,a3
	rts

ldline:	cmpa.l a5,a3
	bge.w l0750e
	st d7
	jsr l07e30(pc)
	beq.s l07476
	st 0x00b8(a6)
l07474:	rts

l07476:	bsr.s l0747a
	bra.s l07492

l0747a:	moveq #0x02,d1
	jmp l065e8(pc)

llist:	bsr.s l0747a
	blt.s l07474
l07484:	st 0x00ab(a6)
	clr.w 0x00ba(a6)
	cmpa.l a5,a3
	bge.w l07512
l07492:	move.l a5,-(a7)
l07494:	cmpa.l (a7),a3
	bge.s l074de
	bsr.s l07452
	bne.s l074a0
	moveq #0x00,d4
	bra.s l074a6

l074a0:	bsr.s l074f0
	bne.s l074da
	move.w d1,d4
l074a6:	subq.b #5,d5
	beq.s l074b6
	addq.b #5,d5
	move.w d4,d6
	bne.s l074ce
	tst.b d7
	bne.s l07494
	bra.s l074be

l074b6:	cmpa.l (a7),a3
	bge.s l074be
	bsr.s l07452
	bne.s l074c4
l074be:	move.w #0x7fff,d6
	bra.s l074ce

l074c4:	bsr.s l074f0
	bne.s l074da
	move.w d1,d6
	cmp.w d4,d6
	blt.s l074da
l074ce:	bsr.s l07518
	cmpi.b #0x01,d5
	beq.s l07494
	tst.b d5
	beq.s l074de
l074da:	moveq #-0x0f,d0
	bra.s l074ec

l074de:	tst.b d7
	beq.s l074ea
	moveq #0x00,d2
	moveq #0x00,d5
	jsr l08fe6(pc)
l074ea:	moveq #0x00,d0
l074ec:	movea.l (a7)+,a5
	rts

l074f0:	movea.l a3,a5
	jsr l05ec8(pc)
	bne.s l07510
	moveq #0x03,d0
	jsr l05996(pc)
	bne.s l07510
	addq.l #2,0x0058(a6)
	move.w 0x00(a6,a1.l),d1
	bgt.s l0750e
	moveq #-0x0f,d0
	rts

l0750e:	moveq #0x00,d0
l07510:	rts

l07512:	moveq #0x00,d4
	move.w #0x7fff,d6

l07518:	movea.l 0x0010(a6),a4
.equ xl03518, l07518-0x4000
	clr.l 0x0068(a6)
	tst.w d4
	beq.s l07530
	move.l a0,-(a7)
	jsr l09fbe(pc)
	movea.l (a7)+,a0
	move.w d2,0x0068(a6)
l07530:	tst.b d7
	bne.s l0753c
	lea l08b5a(pc),a2
	jmp l090b6(pc)

l0753c:	cmp.w 0x04(a6,a4.l),d6
	blt.s l0750e
	move.l a4,-(a7)
	move.w 0x006a(a6),-(a7)
l07548:	cmpa.l 0x0014(a6),a4
	bge.s l07588
	move.w 0x00(a6,a4.l),d1
	addq.w #2,a4
	add.w d1,0x006a(a6)
	adda.w 0x006a(a6),a4
	cmp.w 0x04(a6,a4.l),d6
	bge.s l07548
	move.w 0x00(a6,a4.l),d1
	add.w 0x006a(a6),d1
	sub.w (a7)+,d1
	move.w d1,0x00(a6,a4.l)
	movea.l (a7)+,a2
l07572:	move.w 0x00(a6,a4.l),0x00(a6,a2.l)
	addq.w #2,a4
	addq.w #2,a2
	cmpa.l 0x0014(a6),a4
	blt.s l07572
	move.l a2,0x0014(a6)
l07586:	bra.s l0750e

l07588:	addq.w #2,a7
	move.l (a7)+,0x0014(a6)
	bra.s l07586

|*--------end LIST

lmode:	jsr l061be(pc)
	bne.s l075ac
	addq.l #2,0x0058(a6)
	move.w #0x0108,d1
	and.w d1,0x00(a6,a1.l)
	bne.s l075a6
	moveq #0x00,d1
l075a6:	moveq #-0x01,d2
	moveq #0x10,d0
	trap #0x01
l075ac:	rts


lnet:	jsr l061be(pc)
	bne.s l075c4
	addq.l #2,0x0058(a6)
	move.b 0x01(a6,a1.l),d1
	ble.s l075c6
	move.b d1,0x00028037
l075c4:	rts

l075c6:	moveq #-0x0f,d0
	rts

link:	moveq #0x29,d4
	bra.s l075d4

lstrip:	moveq #0x28,d4
	bra.s l075d4

lpaper:	moveq #0x27,d4
l075d4:	jsr l08038(pc)
	bne.s l075ee
	bsr.w l07fd4
	bne.s l075ee
	cmpi.b #0x27,d4
	bne.s l075ea
	bsr.s l075ea
	moveq #0x28,d4
l075ea:	jmp l07fc4(pc)

l075ee:	rts

lcls:	moveq #0x20,d4
	bra.s l075fa

lpan:	moveq #0x1b,d4
	bra.s l075fa

lscroll:	moveq #0x18,d4
l075fa:	jsr l08038(pc)
	bne.s l07642
	move.w 0x00(a6,a1.l),d1
	cmpi.b #0x20,d4
	beq.s l0760e
	subq.l #2,a1
	subq.l #1,d3
l0760e:	subq.w #1,d3
	bhi.s l07640
	blt.s l0762c
	move.w d4,d3
	subi.w #0x0017,d3
	lsr.w #2,d3
	lea l07644(pc),a2
	btst d1,0x00(a2,d3.w)
	beq.s l07640
	add.l d1,d4
	move.w 0x00(a6,a1.l),d1
l0762c:	jsr l090a2(pc)
	bne.s l0763c
	move.l 0x0040(a6),0x0044(a6)
	clr.w 0x009e(a6)
l0763c:	jmp l07fc4(pc)

l07640:	moveq #-0x0f,d0
l07642:	rts

l07644:	btst d3,(a1)+
	move.b d0,-(a7)
lpause:	jsr l061da(pc)
	subq.w #1,d3
	blt.s l0765a
	bgt.s l07668
	addq.l #2,0x0058(a6)
	move.w 0x00(a6,a1.l),d3
l0765a:	moveq #0x00,d1
	jsr l0661e(pc)
	moveq #0x01,d0
	trap #0x03
	moveq #0x00,d0
	rts

l07668:	moveq #-0x0f,d0
	rts

lpoke:	moveq #0x00,d4
	bsr.s l07682
	move.b d1,(a4)
	rts

lpokew:	bsr.s l07680
	move.w d1,(a4)
	rts

lpokel:	bsr.s l07680
	move.l d1,(a4)
	rts

l07680:	moveq #0x01,d4
l07682:	jsr l061e2(pc)
	bne.s l076a4
	subq.w #2,d3
	bne.s l076a0
	addq.l #8,0x0058(a6)
	movea.l 0x00(a6,a1.l),a4
	move.l 0x04(a6,a1.l),d1
	move.l a4,d0
	and.l d4,d0
	bne.s l076a0
	rts
l076a0:	addq.w #4,a7
	moveq #-0x0f,d0
l076a4:	rts

linput:	st d7
lprint:	jsr l04e4c(pc)
	moveq #0x00,d4
	jsr l065e6(pc)
	bne.w l0784e
	move.l a5,-(a7)
	movea.l a2,a5
	moveq #0x00,d5
	tst.b d7
	beq.s l076d0
	moveq #0x0b,d0
	movea.l (a6),a1
	bsr.w l0796e
	cmpi.w #0xfff1,d0
	bne.s l076d0
	moveq #0x01,d7
l076d0:	cmpa.l (a7),a3
	bge.w l0783e
	move.b 0x01(a6,a3.l),d0
	move.b d0,d5
	lsr.b #4,d5
	andi.b #0x0f,d0
	bne.s l076f2
	tst.b 0x00(a6,a3.l)
	bne.s l076f2
	bsr.w l0795a
	bra.w l07832

l076f2:	tst.w 0x02(a6,a3.l)
	sge d1
	and.b d7,d1
	beq.s l07714
	move.w d0,-(a7)
	bsr.w l0795a
	move.w (a7)+,d0
	movea.l (a7),a4
	jsr l07a0c(pc)
	bne.w l07850
	move.l a4,(a7)
	bra.w l07832

l07714:	tst.b d7
	bgt.w l07838
	movea.l 0x0028(a6),a0
	move.l 0x04(a6,a3.l),d1
	blt.w l07828
	adda.l d1,a0
	cmpi.b #0x03,0x00(a6,a3.l)
	bne.w l07824
	tst.b d5
	beq.s l07740
	cmpi.b #0x05,d5
	bne.s l07742
	swap d5
	bra.s l07742

l07740:	moveq #0x03,d5
l07742:	move.b d0,-(a7)
	movea.l a0,a2
	bsr.w l0781a
	suba.l 0x0028(a6),a2
	suba.l 0x0030(a6),a5
	movem.l a2-a3/a5,-(a7)
	jsr l04df6(pc)
	movem.l (a7)+,a2-a3/a5
	adda.l 0x0030(a6),a5
	adda.l 0x0028(a6),a2
	movea.l a0,a4
l07768:	subq.w #1,d1
	lea 0x00(a4,d1.w),a1
	sf 0x00(a6,a1.l)
	bne.s l07768
	move.w 0x04(a6,a2.l),d1
	move.b (a7),d0
	subq.b #2,d0
	blt.s l07788
	beq.s l07784
	moveq #0x02,d0
	bra.s l0778c

l07784:	moveq #0x06,d0
	bra.s l0778c

l07788:	subq.w #1,d1
	moveq #0x01,d0
l0778c:	move.w d0,0x00(a6,a4.l)
	lsl.w #1,d1
	move.w d1,0x02(a6,a4.l)
l07796:	movea.l 0x0028(a6),a0
	adda.l 0x00(a6,a2.l),a0
	move.w 0x04(a6,a2.l),d0
	lsl.w #2,d0
	lea 0x02(a2,d0.w),a1
	move.w 0x00(a6,a1.l),d3
	lsr.w #1,d0
l077ae:	lea 0x02(a4,d0.w),a1
	move.w 0x00(a6,a1.l),d1
	lsl.w #1,d0
	lea 0x04(a2,d0.w),a1
	lsr.w #1,d0
	mulu 0x00(a6,a1.l),d1
	mulu 0x00(a6,a4.l),d1
	adda.l d1,a0
	subq.w #2,d0
	bne.s l077ae
	move.b (a7),d0
	bsr.w l0785e
	bne.s l077fe
	move.w 0x02(a6,a4.l),d0
	beq.s l077fe
l077da:	lsl.w #1,d0
	lea 0x02(a2,d0.w),a1
	move.w 0x00(a6,a1.l),d1
	lsr.w #1,d0
	lea 0x02(a4,d0.w),a1
	cmp.w 0x00(a6,a1.l),d1
	beq.s l077f6
	addq.w #1,0x00(a6,a1.l)
	bra.s l07796

l077f6:	clr.w 0x00(a6,a1.l)
	subq.w #2,d0
	bne.s l077da
l077fe:	bsr.s l0781a
	movea.l a4,a0
	move.l d0,-(a7)
	move.l a3,-(a7)
	jsr l04fe8(pc)
	movea.l (a7)+,a3
	move.l (a7)+,d0
	addq.w #2,a7
	bne.s l0784c
	tst.b d5
	bne.s l07838
	swap d5
	bra.s l07832

l0781a:	moveq #0x02,d1
	add.w 0x04(a6,a2.l),d1
	lsl.w #1,d1
	rts

l07824:	bsr.s l0785e
	bra.s l07836

l07828:	bsr.w l0795a
	moveq #0x2a,d1
	bsr.w l07960
l07832:	bsr.w l078e0
l07836:	bne.s l0784c
l07838:	addq.w #8,a3
	bra.w l076d0

l0783e:	tst.b d5
	bne.s l0784a
	tst.b d7
	bgt.s l0784a
	bsr.w l07934
l0784a:	moveq #0x00,d0
l0784c:	movea.l (a7)+,a5
l0784e:	rts

l07850:	move.l a4,(a7)
	move.l d0,-(a7)
	moveq #0x0f,d0
	bsr.w l07970
	move.l (a7)+,d0
	bra.s l0784c

l0785e:	movea.l 0x0058(a6),a1
	subq.w #6,a1
	tst.b d0
	beq.s l07878
	subq.b #2,d0
	bgt.s l0787e
	beq.s l0788e
	move.w 0x00(a6,a0.l),d2
	movea.l a0,a1
	addq.w #2,a1
	bra.s l078aa

l07878:	movea.l a0,a1
	move.w d3,d2
	bra.s l078aa

l0787e:	move.w 0x00(a6,a0.l),0x00(a6,a1.l)
	movea.l (a6),a0
	addq.w #1,a0
	jsr l03e54(pc)
	bra.s l078a2

l0788e:	move.l 0x02(a6,a0.l),0x02(a6,a1.l)
	move.w 0x00(a6,a0.l),0x00(a6,a1.l)
	movea.l (a6),a0
	addq.w #1,a0
	jsr l03ef6(pc)
l078a2:	movea.l (a6),a1
	addq.w #1,a1
	move.l a0,d2
	sub.l a1,d2
l078aa:	tst.b d4
	beq.s l078d2
	swap d4
	addq.w #1,d2
	subq.w #1,a1
	move.b 0x00(a6,a1.l),-(a7)
	sub.w d2,d4
	blt.s l078c4
	move.b #0x20,0x00(a6,a1.l)
	bra.s l078d0

l078c4:	move.b #0x0a,0x00(a6,a1.l)
	move.w #-1,0x20(a6,a5.l)
l078d0:	swap d4
l078d2:	bsr.w l07968
	tst.b d4
	beq.s l078e0
	suba.w d2,a1
	move.b (a7)+,0x00(a6,a1.l)
l078e0:	tas 0x008f(a6)
	bne.s l078e8
	moveq #-0x01,d0
l078e8:	tst.l d0
	bne.s l07958
	tst.b d7
	bgt.s l07956
	sf d4
	cmpi.b #0x01,d5
	beq.s l0793e
	cmpi.b #0x03,d5
	beq.s l07934
	cmpi.b #0x04,d5
	beq.s l07926
	cmpi.b #0x05,d5
	bne.s l07956
	move.l a5,-(a7)
	addq.w #8,a3
	lea 0x0008(a3),a5
	jsr l061be(pc)
	movea.l (a7)+,a5
	bne.s l07958
	move.w 0x00(a6,a1.l),d2
	addq.l #2,0x0058(a6)
	bsr.s l0797a
	bra.s l0794a

l07926:	bsr.s l0797a
	sub.w d0,d1
	move.w d1,d4
	swap d4
	tst.w d0
	sne d4
	bra.s l07956

l07934:	moveq #0x0a,d1
	bsr.s l07960
	clr.w 0x20(a6,a5.l)
	bra.s l07956

l0793e:	bsr.s l0797a
	move.w d0,d2
	addq.w #8,d2
	andi.w #0x00f8,d2
	subq.w #8,d1
l0794a:	sub.w d2,d1
	blt.s l07934
	sub.w d0,d2
l07950:	bsr.s l0795e
	subq.w #1,d2
	bgt.s l07950
l07956:	moveq #0x00,d0
l07958:	rts

l0795a:	tst.b d4
	beq.s l07958
l0795e:	moveq #0x20,d1
l07960:	moveq #0x05,d0
	addq.w #1,0x20(a6,a5.l)
	bra.s l07970

l07968:	moveq #0x07,d0
	add.w d2,0x20(a6,a5.l)
l0796e:	trap #0x04
l07970:	moveq #-0x01,d3
	movea.l 0x00(a6,a5.l),a0
	trap #0x03
	rts

l0797a:	moveq #0x0b,d0
	movea.l (a6),a1
	bsr.s l0796e
	tst.l d0
	bne.s l0798e
	move.w 0x04(a6,a1.l),d0
	move.w 0x00(a6,a1.l),d1
	rts

l0798e:	move.w 0x22(a6,a5.l),d1
	move.w 0x20(a6,a5.l),d0
	rts

lrandomise:	jsr l061e2(pc)
	bne.s l079be
	subq.w #1,d3
	bgt.s l079c0
	beq.s l079aa
	moveq #0x13,d0
	trap #0x01
	bra.s l079b4

l079aa:	move.l 0x00(a6,a1.l),d1
	addq.l #4,0x0058(a6)
	moveq #0x00,d0
l079b4:	move.l d1,d2
	swap d1
	add.l d2,d1
	move.l d1,0x0080(a6)
l079be:	rts

l079c0:	moveq #-0x0f,d0
	rts

l079c4:	move.l d0,-(a7)
	moveq #0x00,d4
l079c8:	moveq #0x04,d0
	trap #0x04
	movea.l 0x0004(a6),a1
	move.l 0x0008(a6),d2
	sub.l (a6),d2
	move.l a1,d1
	sub.l (a6),d1
	move.w d1,d4
	move.l d4,d1
	tst.l (a7)
	beq.s l079e6
	moveq #0x02,d0
	sub.w d1,d2
l079e6:	moveq #-0x01,d3
	trap #0x03
	tst.l d0
	bge.s l07a06
	cmpi.b #0xfb,d0
	bne.s l07a06
	move.l d1,d4
	move.l a1,0x0004(a6)
	move.l a0,-(a7)
	moveq #0x7e,d1
	jsr l04e6a(pc)
	movea.l (a7)+,a0
	bra.s l079c8

l07a06:	addq.w #4,a7
l07a08:	tst.l d0
	rts

l07a0c:	move.l d7,-(a7)
	move.w d0,-(a7)
	bsr.s l07a8e
	beq.s l07a1a
l07a14:	addq.w #2,a7
l07a16:	move.l (a7)+,d7
	bra.s l07a08

l07a1a:	movea.l 0x00(a6,a5.l),a0
	move.l (a6),0x0004(a6)
	tst.b d7
	sgt d0
	suba.l 0x0008(a6),a3
	suba.l 0x0008(a6),a4
	suba.l 0x0008(a6),a5
	movem.l a3-a5,-(a7)
	bsr.s l079c4
	movem.l (a7)+,a3-a5
	adda.l 0x0008(a6),a3
	adda.l 0x0008(a6),a4
	adda.l 0x0008(a6),a5
	bne.s l07a14
	move.l a3,-(a7)
	moveq #0x13,d0
	trap #0x03
	moveq #0x14,d0
	trap #0x03
	movea.l (a7)+,a3
	movea.l (a6),a0
	move.l a1,d7
	movea.l 0x0058(a6),a1
	move.w (a7)+,d0
	subq.b #2,d0
	blt.s l07a74
	beq.s l07a6c
	jsr l03dc2(pc)
	bra.s l07a70

l07a6c:	jsr l03d16(pc)
l07a70:	bne.s l07a16
	bra.s l07a7c

l07a74:	movea.l d7,a0
	subq.w #1,a0
	jsr l05a20(pc)
l07a7c:	move.l a1,0x0058(a6)
	suba.l 0x0030(a6),a5
	jsr l072c2(pc)
	adda.l 0x0030(a6),a5
	bra.s l07a16

l07a8e:	move.b 0x00(a6,a3.l),d0
	subq.b #2,d0
	ble.s l07ac0
	subq.b #1,d0
	bne.s l07ab8
	move.b 0x01(a6,a3.l),d0
	andi.b #0x0f,d0
	subq.b #1,d0
	bgt.s l07ac8
	movea.l 0x04(a6,a3.l),a2
	adda.l 0x0028(a6),a2
	cmpi.w #0x0001,0x04(a6,a2.l)
	bgt.s l07ac8
	bra.s l07ac0

l07ab8:	subq.b #3,d0
	blt.s l07ac4
	subq.b #1,d0
	bgt.s l07ac4
l07ac0:	moveq #0x00,d0
	rts

l07ac4:	moveq #-0x0c,d0
	rts

l07ac8:	moveq #-0x13,d0
	rts

lrecol:	jsr l08038(pc)
	bne.s l07af4
	cmpi.w #0x0008,d3
	bne.s l07af2
	movea.l a1,a2
	moveq #0x07,d0
l07adc:	move.b 0x01(a6,a2.l),0x01(a6,a1.l)
	subq.w #2,a2
	subq.w #1,a1
	dbf d0,l07adc
	addq.w #2,a1
	moveq #0x26,d4
	jmp l07fc4(pc)

l07af2:	moveq #-0x0f,d0
l07af4:	rts

ledit:	moveq #0x00,d4
	bra.s l07afc

lauto:	moveq #0x0a,d4
l07afc:	st 0x00aa(a6)
	tst.b 0x0090(a6)
	bne.s l07b32
	bra.s l07b26

l07b08:	moveq #0x00,d5
	cmpa.l 0x0004(a7),a3
	beq.s l07b20
	jsr l07452(pc)
	beq.s l07b20
	jsr l074f0(pc)
	beq.s l07b22
	addq.w #4,a7
	bra.s l07b84

l07b20:	moveq #0x01,d0
l07b22:	rts

lrenum:	moveq #0x0a,d4
l07b26:	jsr l07e30(pc)
	beq.s l07b32
	st 0x00b8(a6)
	rts

l07b32:	move.l a5,-(a7)
	move.w #0x7fff,d7
	moveq #0x64,d6
	swap d4
	bsr.s l07b08
	cmpi.b #0x05,d5
	bne.s l07b5a
	tst.b d0
	bne.s l07b4a
	move.w d1,d4
l07b4a:	bsr.s l07b08
	cmpi.b #0x02,d5
	bne.s l07b84
	tst.b d0
	bne.s l07b66
	move.w d1,d7
	bra.s l07b66

l07b5a:	cmpi.b #0x02,d5
	bne.s l07b68
	tst.b d0
	bne.s l07b66
	move.w d1,d4
l07b66:	bsr.s l07b08
l07b68:	tst.b d0
	bne.s l07b6e
	move.w d1,d6
l07b6e:	swap d4
	cmpi.b #0x01,d5
	bne.s l07b7c
	bsr.s l07b08
	bne.s l07b7c
	move.w d1,d4
l07b7c:	move.w d4,d3
	swap d4
	tst.b d5
	beq.s l07b94
l07b84:	sf 0x00aa(a6)
	addq.w #4,a7
	moveq #-0x0f,d0
	rts

l07b8e:	addq.w #2,a7
	moveq #-0x04,d0
	rts

l07b94:	move.w d7,d5
	addq.w #4,a7
	tst.b 0x00aa(a6)
	beq.s l07baa
	move.w d6,0x00ac(a6)
	move.w d3,0x00ae(a6)
l07ba6:	moveq #0x00,d0
	rts

l07baa:	movea.l 0x0010(a6),a4
	cmpa.l 0x0014(a6),a4
	bge.s l07ba6
	clr.w -(a7)
	clr.l 0x0068(a6)
	tst.w d4
	beq.s l07bd8
	jsr l09fbe(pc)
	cmpa.l (a6),a4
	beq.s l07bd8
	suba.w 0x006a(a6),a4
	move.w 0x02(a6,a4.l),d2
	cmp.w d2,d6
	ble.s l07b8e
	adda.w 0x006a(a6),a4
	move.w d2,(a7)
l07bd8:	moveq #0x00,d0
l07bda:	addq.w #1,d0
	bsr.s l07c4e
	beq.s l07bda
	bgt.s l07be6
	move.w #0x7fff,d2
l07be6:	move.l d0,d1
	subq.w #1,d1
	mulu d3,d1
	add.l d6,d1
	ext.l d2
	cmp.l d2,d1
	bge.s l07b8e
	move.w d2,-(a7)
	moveq #0x02,d1
	add.l d0,d1
	lsl.l #2,d1
	jsr l04df6(pc)
	movea.l a0,a3
	suba.l 0x0028(a6),a3
	move.l d1,0x00(a6,a0.l)
	suba.w 0x006a(a6),a4
	move.w 0x02(a6,a4.l),0x0068(a6)
	adda.w 0x006a(a6),a4
	jsr l09fbe(pc)
	bsr.w l07d56
	move.w d6,d0
	move.w 0x04(a6,a4.l),d2
	move.w 0x0002(a7),d6
	swap d4
l07c2c:	move.w d2,0x00(a6,a0.l)
	move.w d0,0x02(a6,a0.l)
	move.w d0,0x04(a6,a4.l)
	addq.w #4,a0
	add.w d4,d0
	bsr.s l07c4e
	beq.s l07c2c
	move.w (a7),d5
	move.w d5,0x00(a6,a0.l)
	move.w d5,0x02(a6,a0.l)
	addq.w #4,a7
	bra.s l07c7a

l07c4e:	move.w 0x00(a6,a4.l),d1
	addq.w #2,a4
	add.w d1,0x006a(a6)
	adda.w 0x006a(a6),a4
	cmpa.l 0x0014(a6),a4
	bge.s l07c72
	move.w 0x04(a6,a4.l),d2
	cmp.w d2,d5
	blt.s l07c6e
	moveq #0x00,d1
	rts

l07c6e:	moveq #0x01,d1
	rts

l07c72:	moveq #-0x01,d1
	rts

l07c76:	jmp l0a56c(pc)

l07c7a:	st 0x008e(a6)
	jsr l0958e(pc)
	bra.s l07c8a

l07c84:	jsr l0a60e(pc)
	bne.s l07d06
l07c8a:	bsr.s l07c76
	cmpi.w #0x8111,d1
	beq.s l07cb2
	cmpi.w #0x810a,d1
	beq.s l07cae
	cmpi.w #0x8115,d1
	bne.s l07c84
l07c9e:	jsr l09072(pc)
	jsr l09686(pc)
	beq.s l07c84
	cmpi.w #0x810a,d1
	bne.s l07c9e
l07cae:	addq.w #2,a4
	bsr.s l07c76
l07cb2:	addq.w #2,a4
	bsr.s l07c76
	cmpi.w #0x840a,d1
	beq.s l07c84
	subi.w #0xf000,d1
	bge.s l07cce
l07cc2:	move.w #0x8404,d4
	jsr l0a5e0(pc)
	bne.s l07c84
	bra.s l07cb2


l07cce:	movea.l 0x0058(a6),a1
	subq.w #6,a1
	move.w d1,0x00(a6,a1.l)
	move.l 0x02(a6,a4.l),0x02(a6,a1.l)
	jsr l04796(pc)
	move.w 0x00(a6,a1.l),d1
	bsr.s l07d60
	ble.s l07cc2
	move.w d1,0x00(a6,a1.l)
	jsr l047b8(pc)
	move.w 0x00(a6,a1.l),d0
	addi.w #0xf000,d0
	move.w d0,0x00(a6,a4.l)
	move.l 0x02(a6,a1.l),0x02(a6,a4.l)
	bra.s l07cc2

l07d06:	move.w 0x009c(a6),d1
	bsr.s l07d60
	move.w d1,0x009c(a6)
	move.w 0x009e(a6),d1
	bsr.s l07d60
	move.w d1,0x009e(a6)
	move.w 0x00a0(a6),d1
	bsr.s l07d60
	move.w d1,0x00a0(a6)
	movea.l 0x0040(a6),a1
	move.w 0x00(a6,a1.l),d1
	bsr.s l07d60
	move.w d1,0x00(a6,a1.l)
	st 0x006d(a6)
	bsr.s l07d56
	subq.w #4,a0
	move.l 0x00(a6,a0.l),d1
	jsr l04fe8(pc)
	moveq #0x00,d2
	moveq #0x00,d5
	suba.l a0,a0
	jsr l090a2(pc)
	movea.l d0,a0
	jsr l08fe6(pc)
	moveq #0x00,d0
	rts

l07d56:	movea.l 0x0028(a6),a0
	adda.l a3,a0
	addq.w #4,a0
	rts

l07d60:	cmp.w d6,d1
	ble.s l07d76
	cmp.w d1,d5
	blt.s l07d76
	bsr.s l07d56
l07d6a:	cmp.w 0x00(a6,a0.l),d1
	addq.w #4,a0
	bgt.s l07d6a
	move.w -0x02(a6,a0.l),d1
l07d76:	rts

lreport:	moveq #0x00,d1
	jsr l065e8(pc)
	move.l 0x00c2(a6),d0
	move.w 0x0068(a6),-(a7)
	move.w 0x00c6(a6),0x0068(a6)
	jsr l09bdc(pc)
	move.w (a7)+,0x0068(a6)
	moveq #0x00,d0
	rts

lclear:	moveq #0x00,d6
	moveq #0x00,d0
	move.w #-1,0x0088(a6)
	bra.s l07de0

lrun:	jsr l061da(pc)
	bne.s l07e1e
	moveq #0x06,d6
	move.w d7,0x0088(a6)
	subq.w #1,d3
	blt.s l07e14
	beq.s l07dba
	moveq #-0x0f,d0
	rts

l07dba:	move.w 0x00(a6,a1.l),0x0088(a6)
	move.b d7,0x008a(a6)
	addq.l #2,0x0058(a6)
	bra.s l07e14

lmerge:	bsr.s l07e30
	moveq #0x0e,d6
	tst.b 0x006f(a6)
	bne.s l07df6
lmrun:	bsr.s l07e30
	moveq #0x0c,d6
	bsr.s l07e20
	bne.s l07e0e
	move.w d7,0x0088(a6)
l07de0:	tst.b 0x006f(a6)
	bne.s l07e14
	move.w 0x0068(a6),0x0088(a6)
	move.b 0x006c(a6),0x008a(a6)
	bra.s l07e14

lload:	moveq #0x0a,d6
l07df6:	bsr.s l07e20
	bra.s l07e0e

llrun:	moveq #0x08,d6
	bsr.s l07e20
	bne.s l07e0e
	move.w d7,0x0088(a6)
	bra.s l07e14

lnew:	moveq #0x02,d6
	bra.s l07e0c

lstop:	moveq #0x04,d6
l07e0c:	moveq #0x00,d0
l07e0e:	move.w #-1,0x0088(a6)
l07e14:	sf 0x006d(a6)
	move.w d6,0x008c(a6)
	tst.l d0
l07e1e:	rts

l07e20:	moveq #0x01,d4
	jsr l069c4(pc)
	bne.s l07e1e
	move.l a0,0x0084(a6)
	moveq #0x00,d0
	rts

l07e30:	tst.b 0x0090(a6)
	bne.s l07e44
	move.l 0x003c(a6),d0
	sub.l 0x0038(a6),d0
	beq.s l07e44
	addq.w #4,a7
	moveq #-0x13,d0
l07e44:	rts

lretry:	subq.b #1,0x0091(a6)
	bge.s l07e50
	sf 0x0091(a6)

lcontinue:
l07e50:	sf 0x00c0(a6)
	moveq #0x10,d6
	bra.s l07e0c

ltra:	jsr l061e2(pc)
	bne.s l07e8a
	clr.l d2
	subq.w #1,d3
	beq.s l07e78
	subq.w #1,d3
	bne.s l07e8c
	addq.l #4,0x0058(a6)
	move.l 0x04(a6,a1.l),d2
	bne.s l07e78
	move.l 0xbfe6,d2

l07e78:	addq.l #4,0x0058(a6)
	move.l 0x00(a6,a1.l),d1
	moveq #0x24,d0
	trap #0x01
	tst.l d0
	bmi.s l07e8c
	moveq #0x00,d0
l07e8a:	rts
l07e8c:	moveq #-0x0f,d0
	rts

lturnto:	bsr.w l07f24
	bne.s l07ed0
	bra.s l07ea6

lturn:	bsr.w l07f24
	bne.s l07ed0
	bsr.w l07f42
	jsr l04838(pc)
l07ea6:	lea l07f52(pc),a3
	lea 0x0006(a1),a4
	subq.w #6,a1
	move.w #0x0809,0x00(a6,a1.l)
	move.l #0x5a000000,0x02(a6,a1.l)
	jsr l041b4(pc)
	move.w 0x00(a6,a1.l),0x10(a6,a2.l)
	move.l 0x02(a6,a1.l),0x12(a6,a2.l)
l07ece:	moveq #0x00,d0

l07ed0:	rts

lpenup:	moveq #0x00,d4
	bra.s l07ed8

lpendown:	moveq #0x01,d4
l07ed8:	jsr l065e6(pc)
	bne.s l07ed0
	move.b d4,0x16(a6,a2.l)
	bra.s l07ece

lmove:	bsr.s l07f24
	bne.s l07f22
	bsr.s l07f42
	subq.w #6,a1
	move.w #0x07fb,0x00(a6,a1.l)
	move.l #0x477d1a89,0x02(a6,a1.l)
	jsr l048de(pc)
	jsr l06d6e(pc)
	jsr l06d7e(pc)
	lea l07f5a(pc),a3
	lea 0x0018(a1),a4
	jsr l041b4(pc)
	jsr l06d8e(pc)
	tst.b 0x16(a6,a2.l)
	beq.s l07ece
	moveq #0x31,d0
	trap #0x04
	trap #0x03
l07f22:	rts

l07f24:	move.w #0x0100,d1
	jsr l04e4e(pc)
	jsr l065e6(pc)
	bne.s l07f40
	move.l 0x0058(a6),-(a7)
	jsr l061c6(pc)
	move.l (a7)+,0x0058(a6)
	tst.l d0
l07f40:	rts

l07f42:	subq.w #6,a1
	move.w 0x10(a6,a2.l),0x00(a6,a1.l)
	move.l 0x12(a6,a2.l),0x02(a6,a1.l)
	rts

|* TABLE FOR TURN OPERATIONS
.balign 2, 0 ; l07f52:	.long 0xfaf41004
.balign 2, 0 ; 	.long 0x080e0c00
.balign 2, 0 ; l07f5a:	.long 0xfaf4180e
.balign 2, 0 ; 	.long 0xee0afaf4
.balign 2, 0 ; 	.long 0x1a0ee80a
.balign 2, 0 ; 	.word 0x0000

lwidth:	jsr l08038(pc)
	bne.s l07f78
	subq.w #1,d3
	bne.s l07f7a
	move.w 0x00(a6,a1.l),0x22(a6,a2.l)
l07f78:	rts

l07f7a:	moveq #-0x0f,d0
	rts

lwindow:	jsr l08038(pc)
	bne.s l07fa2
	moveq #0x0d,d4
	moveq #-0x80,d1
	clr.w d2
	bra.s l07f9c

lblock:	jsr l08038(pc)
	bne.s l07fa2
	moveq #0x2e,d4
	subq.w #4,d3
	jsr l07fd4(pc)
	bne.s l07fa2
l07f9c:	subq.w #6,a1
	jmp l07fc4(pc)

l07fa2:	rts

lborder:	jsr l08038(pc)
	bne.s l07fa2
	moveq #0x0c,d4
	moveq #-0x80,d1
	cmpi.w #0x0001,d3
	bls.s l07fbc
	subq.w #1,d3
	jsr l07fd4(pc)
	bne.s l07fa2
l07fbc:	move.w 0x00(a6,a1.l),d2
	jmp l07fc4(pc)

l07fc4:	move.l d4,d0
	moveq #-0x01,d3
	move.l a1,-(a7)
	trap #0x04
	trap #0x03
	movea.l (a7)+,a1
	tst.l d0
	rts

l07fd4:	move.w 0x00(a6,a1.l),d1
	subq.l #2,a1
	subq.w #1,d3
	beq.s l0801a
	cmpi.w #0x0007,d1
	bhi.s l08024
	ori.w #0x0018,d1
	cmpi.w #0x0001,d3
	beq.s l08004
	andi.w #0x0007,d1
	move.w 0x00(a6,a1.l),d2
	subq.l #2,a1
	subq.w #1,d3
	lsl.w #3,d1
	cmpi.w #0x0007,d2
	bhi.s l08024
	or.w d2,d1
l08004:	move.w 0x00(a6,a1.l),d2
	subq.l #2,a1
	subq.w #1,d3
	bne.s l08024
	cmpi.w #0x0007,d2
	bhi.s l08024
	eor.w d2,d1
	lsl.w #3,d1
	or.w d2,d1
l0801a:	cmpi.w #0x00ff,d1
	bhi.s l08024
l08020:	moveq #0x00,d0
	rts

l08024:	moveq #-0x0f,d0
	rts

l08028:	cmpi.w #0x0001,d3
	bne.s l08024
	move.w 0x00(a6,a1.l),d1
	cmp.w d3,d1
	bhi.s l08024
	bra.s l08020

l08038:	jsr l065e6(pc)
	bne.s l08052
l0803e:	jsr l061da(pc)
	bne.s l08052
	add.l d3,d3
	add.l d3,0x0058(a6)
	adda.l d3,a1
	subq.l #2,a1
	lsr.w #1,d3
	moveq #0x00,d0
l08052:	rts

lacos:	lea l042e4(pc),a4
	bra.s l080c6

lacot:	lea l0431e(pc),a4
	bra.s l080c6

lasin:	lea l042f2(pc),a4
	bra.s l080c6

latan:	lea l04326(pc),a4
	bra.s l080c6

lcos:	lea l0423e(pc),a4
	bra.s l080c6

lcot:	lea l0426a(pc),a4
	bra.s l080c6

lexp:	lea l044de(pc),a4
	bra.s l080c6

lln:	lea l04446(pc),a4
	bra.s l080c6

llog10:	lea l0442c(pc),a4
	bra.s l080c6

lsin:	lea l04236(pc),a4
	bra.s l080c6

lsqrt:	lea l0452c(pc),a4
	bra.s l080c6

ltan:	lea l04262(pc),a4
	bra.s l080c6

ldeg:	lea l0497e(pc),a4
	bra.s l080a6

lrad:	lea l048de(pc),a4
l080a6:	jsr l061c6(pc)
	bne.s l080de
	bsr.w l08162
	subq.w #6,a1
	move.w #0x07fb,0x00(a6,a1.l)
	move.l #0x477d1a89,0x02(a6,a1.l)
	bra.s l080d6

labs:	lea l04a06(pc),a4
l080c6:	jsr l061c6(pc)
	bne.s l080de
	moveq #0x30,d1
	jsr l04e4e(pc)
	movea.l 0x0058(a6),a1
l080d6:	jsr (a4)
l080d8:	moveq #0x02,d4
l080da:	move.l a1,0x0058(a6)
l080de:	rts

l080e0:	moveq #0x03,d4
	moveq #0x00,d0
	bra.s l080da

o80e6:	addq.w #4,a7
	rts

lrnd:	moveq #0x01,d5
	or.l 0x0080(a6),d5
	move.l d5,d6
	mulu #0x0163,d5
	swap d6
	mulu #0x0163,d6
	swap d6
	clr.w d6
	add.l d6,d5
	move.l d5,0x0080(a6)
	jsr l061da(pc)
	bne.s l080de
	subq.w #1,d3
	beq.s l0812a
	bgt.s l08124
	bsr.w l08162
	move.l d5,d1
	lsr.l #1,d1
	move.w #0x0800,d0
l0811e:	jsr l04830(pc)
	bra.s l080d8

l08124:	move.w 0x00(a6,a1.l),d3
	addq.w #2,a1
l0812a:	move.w 0x00(a6,a1.l),d2
	sub.w d3,d2
	blt.s l0819e
	addq.w #1,d2
	swap d5
	mulu d2,d5
	swap d5
	add.w d3,d5
l0813c:	move.w d5,0x00(a6,a1.l)
	bra.s l080e0

lpi:	cmpa.l a3,a5
	bne.s l0819e
	bsr.s l08162
	move.w #0x0802,d0
	move.l #0x6487ed51,d1
	bra.s l0811e

lint:	jsr l061c2(pc)
	bne.s l080de
	move.l 0x00(a6,a1.l),d1
	addq.w #4,a1
	bra.s l08186

l08162:	jsr l04e4c(pc)
	movea.l 0x0058(a6),a1
	rts

lpeek:	bsr.s l0818c
	moveq #0x00,d5
	move.b (a4),d5
	bra.s l0817a

lpeekw:	bsr.s l0818c
	bcs.s l0819e
	move.w (a4),d5
l0817a:	addq.w #2,a1
	bra.s l0813c

lpeekl:	bsr.s l0818c
	bcs.s l0819e
	move.l (a4),d1
l08184:	addq.w #4,a1
l08186:	move.w #0x081f,d0
	bra.s l0811e

l0818c:	jsr l061c2(pc)
	bne.w l0821a
	movea.l 0x00(a6,a1.l),a4
	move.l a4,d1
	ror.w #1,d1
	rts

l0819e:	moveq #-0x0f,d0
l081a0:	rts

lrespr:	bsr.s l0818c
	moveq #0x0e,d0
	move.l 0x00(a6,a1.l),d1
	movea.l a1,a4
	trap #0x01
	move.l a0,d1
	movea.l a4,a1
	tst.l d0
	beq.s l08184
	bra.s l081a0

lbeeping:	cmpa.l a3,a5
	bne.s l0819e
	bsr.s l08162
	moveq #0x01,d1
	and.b 0x00028096,d1
	bra.s l08186

leof:	cmpa.l a3,a5
	bne.s l081d6
	jsr l066fa(pc)
	subq.b #1,0x0097(a6)
	bra.s l081e0

l081d6:	bsr.w l0825a
	moveq #0x00,d0
	moveq #0x00,d3
	trap #0x03
l081e0:	moveq #-0x0a,d4
	sub.l d0,d4
	bsr.w l08162
	moveq #0x00,d1
	tst.l d4
	bne.s l08186
	moveq #0x01,d1
	bra.s l08186

lvers:	cmpa.l a3,a5
	bne.s l0819e
	bsr.w l08162
	subq.w #6,a1
	move.l 0xbffa,0x00(a6,a1.l)
	move.w 0xbffe,0x04(a6,a1.l)
	bra.s l08252

linkeys:	bsr.s l0825a
	move.l a0,-(a7)
	bsr.w l08162
	jsr l061da(pc)
l0821a:	bne.s l08262
	movea.l (a7)+,a0
	cmpi.w #0x0001,d3
	bgt.w l0819e
	blt.s l0822e
	move.w 0x00(a6,a1.l),d3
	addq.w #2,a1
l0822e:	movea.l a1,a4
	moveq #0x01,d0
	trap #0x03
	movea.l a4,a1
	addq.l #1,d0
	beq.s l0824c
	subq.l #1,d0
	bne.s l08264
	subq.w #4,a1
l08240:	move.b d1,0x02(a6,a1.l)
	move.w #0x0001,0x00(a6,a1.l)
	bra.s l08252

l0824c:	subq.w #2,a1
	clr.w 0x00(a6,a1.l)
l08252:	moveq #0x01,d4
	moveq #0x00,d0
	bra.w l080da

l0825a:	moveq #0x00,d1
	jsr l065e8(pc)
	beq.s l08264
l08262:	addq.w #4,a7
l08264:	rts

lchrs:	bsr.w l08162
	jsr l061be(pc)
	bne.s l08264
	move.w 0x00(a6,a1.l),d1
	subq.w #2,a1
	bra.s l08240

lfills:	subq.w #8,a5
	bsr.s l082ce
	beq.w l0819e
	subq.l #1,d1
	bgt.s l0828a
	move.b 0x02(a6,a1.l),0x03(a6,a1.l)
l0828a:	move.w 0x02(a6,a1.l),d5
	addq.l #4,d1
	bclr #0x00,d1
	adda.l d1,a1
	move.l a1,0x0058(a6)
	movea.l a5,a3
	addq.w #8,a5
	jsr l061be(pc)
	bne.s l08264
	addq.l #2,0x0058(a6)
	moveq #0x00,d4
	move.w 0x00(a6,a1.l),d4
	blt.w l0819e
	beq.s l08252
	move.l d4,d1
	bsr.s l082f2
l082b8:	subq.w #2,a1
	move.w d5,0x00(a6,a1.l)
	subq.l #2,d1
	bgt.s l082b8
	move.w d4,0x00(a6,a1.l)
	bra.s l08252

llen:	bsr.s l082ce
	move.w d1,d5
	bra.s l082e6

l082ce:	jsr l061ca(pc)
	bne.s l08262
	moveq #0x00,d5
	moveq #0x00,d1
	move.w 0x00(a6,a1.l),d1
	rts

lcode:	bsr.s l082ce
	beq.s l082ee
	move.b 0x02(a6,a1.l),d5
l082e6:	addq.l #1,d1
	bclr #0x00,d1
	adda.l d1,a1
l082ee:	bra.w l0813c

l082f2:	addq.l #3,d1
	bclr #0x00,d1
	move.l d1,-(a7)
	jsr l04e4e(pc)
	movea.l 0x0058(a6),a1
	move.l (a7)+,d1
l08304:	rts

ldimn:	move.b 0x00(a6,a3.l),d1
	subq.b #3,d1
	bne.s l0834e
	move.l a3,-(a7)
	addq.w #8,a3
	jsr l061da(pc)
	movea.l (a7)+,a3
	bne.s l08304
	subq.w #1,d3
	bgt.s l08304
	beq.s l08328
	bsr.s l0836a
	subq.w #2,a1
	moveq #0x01,d1
	bra.s l0832e

l08328:	move.w 0x00(a6,a1.l),d1
	ble.s l08352
l0832e:	movea.l 0x04(a6,a3.l),a2
	adda.l 0x0028(a6),a2
	move.w 0x04(a6,a2.l),d2
	sub.w d1,d2
	blt.s l08352
	addq.w #2,a2
	lsl.w #2,d1
	adda.w d1,a2
	move.w 0x00(a6,a2.l),0x00(a6,a1.l)
	bra.w l080e0

l0834e:	bsr.s l0836a
	subq.w #2,a1
l08352:	moveq #0x00,d5
	bra.s l082ee

ldate:	cmpa.l a3,a5
	bne.w l0819e
	bsr.s l0836a
	moveq #0x13,d0
	trap #0x01
	bclr #0x1f,d1
	bra.w l08186

l0836a:	bra.w l08162

lkeyrow:	jsr l061be(pc)
	subq.w #8,a7
	bne.s l083b0
	movea.l a7,a3
	move.b #0x09,(a3)
	move.b #0x01,0x0001(a3)
	move.l #0x0000,0x0002(a3)
	move.b 0x01(a6,a1.l),0x0006(a3)
	move.b #0x02,0x0007(a3)
	move.l a1,-(a7)
	moveq #0x11,d0
	trap #0x01
	movea.l (a7)+,a1
	move.w d1,0x00(a6,a1.l)
	moveq #0x03,d4
	movea.l 0x0002804c,a2
	move.l 0x000c(a2),0x0008(a2)
l083b0:	addq.w #8,a7
	rts

ldates:	lea l0405e(pc),a4
	bra.s l083be

ldays:	lea l040be(pc),a4
l083be:	jsr l04e4c(pc)
	cmpa.l a3,a5
	ble.s l083d4
	jsr l061c2(pc)
	bne.s l083e6
	move.l 0x00(a6,a1.l),d1
	addq.l #4,a1
	bra.s l083dc

l083d4:	moveq #0x13,d0
	trap #0x01
	movea.l 0x0058(a6),a1
l083dc:	jsr (a4)
	moveq #0x01,d4
	move.l a1,0x0058(a6)
	moveq #0x00,d0
l083e6:	rts

lerrbl:	bsr.s l08414
lerrro:	bsr.s l08414
lerrni:	bsr.s l08414
lerrov:	bsr.s l08414
lerrxp:	bsr.s l08414
lerrfe:	bsr.s l08414
lerrbp:	bsr.s l08414
lerrff:	bsr.s l08414
lerrte:	bsr.s l08414
lerrbn:	bsr.s l08414
lerrdf:	bra.s l08414 | * !!! ERROR ?  BSR ??!!
lerref:	bsr.s l08414
lerriu:	bsr.s l08414
lerrex:	bsr.s l08414
lerrnf:	bsr.s l08414
lerrno:	bsr.s l08414
lerrbo:	bsr.s l08414
lerror:	bsr.s l08414
lerrom:	bsr.s l08414
lerrnj:	bsr.s l08414
lerrnc:	bsr.s l08414
	nop
l08414:	pea l08414(pc)
	move.l (a7)+,d4
	sub.l (a7)+,d4
	lsr.l #1,d4
	bsr.s l08446
	subq.w #6,a1
	clr.w 0x00(a6,a1.l)
	clr.l 0x02(a6,a1.l)
	add.l 0x00c2(a6),d4
	bne.s l0843c
	move.w #0x0801,0x00(a6,a1.l)
	move.b #0x40,0x02(a6,a1.l)
l0843c:	moveq #0x02,d4
l0843e:	move.l a1,0x0058(a6)
	moveq #0x00,d0
	rts

l08446:	cmpa.l a3,a5
	bne.s l08454
	jsr l04e4c(pc)
	movea.l 0x0058(a6),a1
	rts

l08454:	addq.w #4,a7
	moveq #-0x0f,d0
	rts

lernum:	bsr.s l08446
	subq.w #2,a1
	move.w 0x00c4(a6),0x00(a6,a1.l)
l08464:	moveq #0x03,d4
	bra.s l0843e

lerlin:	bsr.s l08446
	subq.w #2,a1
	move.w 0x00c6(a6),0x00(a6,a1.l)
	bra.s l08464

|* create coded prog
|* code ligne number

l08474:	jsr l04e4c(pc)
	movea.l 0x0058(a6),a1
	jsr l03dc2(pc)
	bne.s l084a4
	tst.w 0x00(a6,a1.l)
	ble.s l084a4
	tst.b 0x0090(a6)
	beq.s l08496
l0848e:	adda.w #0x000c,a7
	moveq #0x01,d0
	rts

l08496:	moveq #0x04,d1
	moveq #-0x73,d4
	move.w 0x00(a6,a1.l),d5
	jsr l08e0a(pc)
	addq.l #2,(a7)
l084a4:	rts

l084a6:	.byte 0x04, 0x05, 0x07, 0x09, 0x0c, 0x01, 0x2d, 0x01

l084ae:	.byte 0x2b, 0x02, 0x7e, 0x7e
	.byte 0x13, 0x4e, 0x4f, 0x54

l084b6:	lea l084a6(pc),a2
	jsr l08748(pc)
	bra.s l084c8

l084c0:	moveq #-0x7a,d4
	jsr l08dfa(pc)
	addq.l #2,(a7)
l084c8:	rts

l084ca:	moveq #0x01,d3
	bra.s l084d0

l084ce:	moveq #0x00,d3
l084d0:	movea.l a0,a3
	jsr l08706(pc)
	bra.s l084f8

l084d8:	move.l a0,d5
	sub.l a3,d5
	cmpi.w #0x00ff,d5
	bgt.s l084f8
	move.l a0,-(a7)
	jsr l08622(pc)
	bra.s l084f6 | * ERROR
l084ea:	movea.l (a7)+,a0
	moveq #-0x78,d4
	jsr l08e0a(pc)
	addq.l #2,(a7)
	rts

l084f6:	movea.l (a7)+,a0
l084f8:	rts



l084fa:	.byte 0x16 | * THERE ARE $16=#22 OPERATORS
|* TO EACH OPERATOR IS POINTED WITH ONE BYTE DISPLACEMENT
	.byte 0x17, 0x19, 0x1b, 0x1d
	.byte 0x1f, 0x22, 0x24, 0x27
	.byte 0x29, 0x2c, 0x2f, 0x31
	.byte 0x34, 0x37, 0x3a, 0x3c
	.byte 0x3e, 0x41, 0x45, 0x49, 0x4d, 0x51

|* THESE ARE THE OPERATORS - LENGTH AND ASCII
|* VALUES LIKE $12 FOR LENGHT MEAN: STRING OPERATOR, LENGHT 2
l08511:	.byte 0x01 ; .ascii "+" ; .byte 0x01 ; .ascii "-" ; .byte 0x01 ; .ascii "*"
	.byte 0x01 ; .ascii "/" ; .byte 0x02 ; .ascii ">=" ; .byte 0x01 ; .ascii ">"
	.byte 0x02 ; .ascii "==" ; .byte 0x01 ; .ascii "=" ; .byte 0x02 ; .ascii "<>"
	.byte 0x02 ; .ascii "<=" ; .byte 0x01 ; .ascii "<" ; .byte 0x02 ; .ascii "||"
	.byte 0x02 ; .ascii "&&" ; .byte 0x02 ; .ascii "^^" ; .byte 0x01 ; .ascii "^"
	.byte 0x01 ; .ascii "&" ; .byte 0x12 ; .ascii "OR"
	.byte 0x13 ; .ascii "AND" ; .byte 0x13 ; .ascii "XOR" ; .byte 0x13 ; .ascii "MOD"
	.byte 0x13 ; .ascii "DIV" ; .byte 0x15 ; .ascii "INSTR"
	.byte 0x00


l08552:	lea l084fa(pc),a2
	jsr l08748(pc)
	bra.s l08564
	moveq #-123,d4
	jsr l08dfa(pc)
	addq.l #2,(a7)
l08564:	rts

|* TABLE OF 5 SEPARATORS - LIKE ABOVE  JM 7D48
.balign 2, 0 ; l08566:	.long 0x0506080a
.balign 2, 0 ; 	.word 0x0c0e
|* HERE THEY ARE
	.byte 0x01 ; .ascii "," ; .byte 0x01 ; .ascii ";" ; .byte 0x01 ; .ascii "\\"
	.byte 0x01 ; .ascii "!" ; .byte 0x12 ; .ascii "TO"
	.byte 0x00

l08578:	lea.l l08566(pc),a2
	jsr l08748(pc)
	bra.s l0858a | * ERROR
	moveq #-114,d4
	jsr l08dfa(pc)
	addq.l #2,(a7)
l0858a:	rts

l0858c:	moveq #0,d1
	moveq #0,d5
l08590:	addq.w #1,d5
	move.b 0x0(a6,a0.l),d1
	addq.w #1,a0
	cmpi.b #0x20,d1
	beq.s l08590
	subq.w #1,a0
	subq.w #1,d5
	beq.s l085aa
	moveq #-0x80,d4
	jsr l08dfa(pc)
l085aa:	rts

l085ac:	move.b 0x0(a6,a0.l),d2
	cmpi.b #0x22,d2
	beq.s l085bc
	cmpi.b #0x27,d2
	bne.s l085de
l085bc:	lea 0x1(a0),a2
	moveq #-1,d5
	moveq #0xa,d3
l085c4:	addq.w #1,a0
	addq.w #1,d5
	move.b 0x0(a6,a0.l),d1
	cmp.b d3,d1
	beq.s l085de
	cmp.b d2,d1
	bne.s l085c4
	addq.w #1,a0
	moveq #-117,d4
	jsr l08e38(pc)
	addq.l #2,(a7)
l085de:	rts

l085e0:	jsr l0872c(pc)
	bne.s l085f2
	move.l 0xc(a6),a3
	cmpi.b #0x80,-2(a6,a3.l)
	bne.s l0860a
l085f2:	move.l a0,a2
	move.l 4(a6),d5
	subq.l #1,d5
	movea.l d5,a0
	sub.l a2,d5
	beq.s l08608
	moveq #-0x74,d4
	moveq #0x00,d2
	jsr l08e38(pc)
l08608:	addq.l #2,(a7)
l0860a:	rts

l0860c:	jsr l04e4c(pc)
	movea.l 0x0058(a6),a1
	jsr l03d16(pc)
	bne.s l08620
	jsr l08e12(pc)
	addq.l #2,(a7)
l08620:	rts

l08622:	move.l a2,-(a7)
	move.b d5,d2
	move.b d2,d1
	moveq #0x05,d3
	movea.l 0x0018(a6),a2
	movea.l a3,a1
l08630:	cmpa.l 0x001c(a6),a2
	bge.s l08684
	tst.l 0x00(a6,a2.l)
	beq.s l0864c
	movea.l 0x0020(a6),a4
	adda.w 0x02(a6,a2.l),a4
	move.b 0x00(a6,a4.l),d5
	cmp.b d2,d5
	beq.s l08650
l0864c:	addq.w #8,a2
	bra.s l08630

l08650:	tst.b d2
	beq.s l08672
	move.b 0x00(a6,a3.l),d4
	addq.w #1,a3
	bclr d3,d4
	tst.b d5
	beq.s l0867c
	addq.w #1,a4
	move.b 0x00(a6,a4.l),d6
	bclr d3,d6
	cmp.b d4,d6
	bne.s l0867c
	subq.b #1,d2
	subq.b #1,d5
	bra.s l08650

l08672:	tst.b d5
	bne.s l0867c
	move.l a2,d5
	addq.w #4,a7
	bra.s l086fa

l0867c:	movea.l a1,a3
	move.b d1,d2
	addq.w #8,a2
	bra.s l08630

l08684:	moveq #0x00,d6
	movea.l a3,a0
	movea.l (a7)+,a2
	jsr l08966(pc)
	bra.s l08692 | * ERROR       
	bra.s l08704

l08692:	tst.b 0x0090(a6)
	beq.s l0869e
	addq.w #8,a7
	jmp l0848e(pc)

l0869e:	moveq #0x00,d4
	move.b d2,d4
	jsr l04de8(pc)
	move.l d4,d2
	move.l #-1,0x04(a6,a2.l)
	movea.l 0x0024(a6),a4
	move.l a4,d3
	sub.l 0x0020(a6),d3
	move.w d3,0x02(a6,a2.l)
	add.l a3,d2
	move.b -0x01(a6,d2.l),d3
	moveq #0x00,d1
	subi.b #0x25,d3
	blt.s l086d2
	bgt.s l086d0
	addq.w #1,d1
l086d0:	addq.w #1,d1
l086d2:	addq.w #1,d1
	move.w d1,0x00(a6,a2.l)
	move.l a2,d5
	moveq #0x01,d1
	add.w d4,d1
	jsr l04e72(pc)
	move.b d4,0x00(a6,a4.l)
l086e6:	addq.w #1,a4
	move.b 0x00(a6,a3.l),0x00(a6,a4.l)
	addq.w #1,a3
	subq.b #1,d4
	bne.s l086e6
	addq.w #1,a4
	move.l a4,0x0024(a6)
l086fa:	movea.l d5,a2
	sub.l 0x0018(a6),d5
	lsr.l #3,d5
	addq.l #2,(a7)
l08704:	rts

l08706:	bsr.s l0872c
	bne.s l0872a
	cmpi.b #0x01,d2
	bne.s l0872a
l08710:	addq.w #1,a0
	bsr.s l0872c
	beq.s l08710
	cmpi.b #0x24,d2
	beq.s l08722
	cmpi.b #0x25,d2
	bne.s l08728
l08722:	tst.b d3
	bne.s l0872a
	addq.w #1,a0
l08728:	addq.l #2,(a7)
l0872a:	rts

l0872c:	moveq #0x00,d1
	move.b 0x00(a6,a0.l),d1
	blt.s l08746
	lea l03c28(pc),a1
	move.b 0x00(a1,d1.w),d2
	cmpi.b #0x01,d2
	beq.s l08746
	cmpi.b #0x02,d2
l08746:	rts

l08748:	move.l a0,-(a7)
	moveq #0x00,d5
l0874c:	movea.l (a7),a0
	bsr.s l08794
l08750:	addq.w #1,d5
	movea.l a2,a1
	cmp.b (a1),d5
	bgt.s l08790
	moveq #0x00,d1
	move.b 0x00(a1,d5.w),d1
	adda.w d1,a1
	move.b (a1)+,d1
	cmp.b (a1)+,d0
	bne.s l08750
	move.b d1,d0
	swap d1
	move.b d0,d1
	andi.b #0x0f,d1
l08770:	subq.b #1,d1
	ble.s l0877e
	addq.w #1,a0
	bsr.s l08794
	cmp.b (a1)+,d0
	beq.s l08770
	bra.s l0874c

l0877e:	swap d1
	lsr.b #4,d1
	addq.w #1,a0
	beq.s l0878c
	jsr l0872c(pc)
	beq.s l0874c
l0878c:	addq.l #2,0x0004(a7)
l08790:	addq.w #4,a7
	rts

l08794:	moveq #0x00,d0
	move.b 0x00(a6,a0.l),d0
	blt.s l087ac
	lea l03c28(pc),a3
	cmpi.b #0x01,0x00(a3,d0.w)
	bne.s l087ac
	bclr #0x05,d0
l087ac:	rts

|* DISPLACEMENT - JUMPS RELATIV TO 87C4

.balign 2, 0 ; l087ae:	.word l084ce-edummy
.balign 2, 0 ; 	.word l0860c-edummy
.balign 2, 0 ; 	.word l0860c-edummy
|* NEXT VALUE IS REST OF JM - LABEL SHOULD POINT TO RTS
|* IN JM 4FFC WAS CLOSE TO THESE LABELS - CHANGE IT TO ANY
|* OTHER LABEL
.balign 2, 0 ; 	.word l04ffc-edummy
.balign 2, 0 ; 	.word l08552-edummy
.balign 2, 0 ; 	.word l084b6-edummy
.balign 2, 0 ; 	.word l08578-edummy
.balign 2, 0 ; 	.word l085ac-edummy
.balign 2, 0 ; 	.word l085e0-edummy
.balign 2, 0 ; 	.word l08474-edummy
.balign 2, 0 ; 	.word l084ca-edummy

l087c4:	lsr.b #1,d6
l087c6:	jsr l0858c(pc)
	add.b d6,d6
	move.w l087ae-0x02(pc,d6.w),d6
l087d0:	jmp edummy(pc,d6.w)

.equ edummy, l087d0-0x0c

l087d4:
.equ xl047d4, l087d4-0x4000
	moveq #0x00,d7
	moveq #0x00,d6
	move.l (a2)+,-(a7)
	move.l (a2),-(a7)
	movea.l (a7),a5
	move.w (a5),d6
	adda.w d6,a5
	moveq #0x00,d4
	jsr l08aa0(pc)
	movea.l (a6),a0
	bra.s l0880e

l087ec:	subi.b #0x80,d6
	lsr.b #1,d6
	bne.s l087fe
	subq.w #1,a5
	jsr l08a7a(pc)
	bra.w l088ce

l087fe:	move.l a5,d4
	jsr l08aa0(pc)
	add.b d6,d6
	movea.l (a7),a5
	move.w -0x02(a5,d6.w),d6
	adda.w d6,a5
l0880e:	jsr l08a7e(pc)
l08812:	moveq #0x00,d6
	move.b (a5)+,d6
	beq.s l0887a
	bmi.s l087ec
	bclr #0x06,d6
	beq.s l0882c
	movea.l 0x0004(a7),a2
	jsr l08966(pc)
	bra.s l08846 | * ERROR
	bra.s l08864

l0882c:	bclr #0x05,d6
	beq.s l0883a
	jsr l08b34(pc)
	bra.s l08846 | * ERROR       
	bra.s l08864

l0883a:	movea.l 0x0004(a7),a2
	jsr l087c4(pc)
	bra.s l08846 | * ERROR       
	bra.s l08864

l08846:	movea.l 0x0048(a6),a2
l0884a:	movea.l 0x00(a6,a2.l),a3
	movea.l 0x04(a6,a2.l),a0
	move.l 0x08(a6,a2.l),d3
	adda.w #0x000c,a2
	blt.s l0884a
	addq.w #1,a5
	move.l a3,0x000c(a6)
	bra.s l08812

l08864:	jsr l08a7a(pc)
l08868:	moveq #0x00,d6
	move.b (a5),d6
	beq.s l088ce
	bmi.s l08874
	adda.w d6,a5
	bra.s l08812

l08874:	neg.b d6
	suba.w d6,a5
	bra.s l08812

l0887a:	movea.l 0x0048(a6),a4
	cmpa.l 0x004c(a6),a4
	bgt.s l088b2
	movea.l 0x00(a6,a4.l),a3
	movea.l 0x04(a6,a4.l),a0
	movea.l 0x08(a6,a4.l),a5
	adda.w #0x000c,a4
	move.l a4,0x0048(a6)
	move.l a5,d3
	bgt.s l088a6
	beq.s l088b8
	move.l a0,d4
	jsr l08aa0(pc)
	bra.s l0887a

l088a6:	btst d7,-0x0001(a5)
	beq.s l08846
	move.l -0x10(a6,a4.l),d3
	bmi.s l08846
l088b2:	addq.w #8,a7
	moveq #-0x01,d0
	rts
l088b8:	movea.l 0x0050(a6),a4
	movea.l 0x00(a6,a4.l),a5
	addq.w #4,a4
	move.l a4,0x0050(a6)
	move.l a5,d3
	beq.s l088b2
	bra.w l08846

l088ce:	jsr l04e52(pc)
	movea.l 0x0048(a6),a4
	movea.l 0x0050(a6),a2
	subq.w #8,a4
	move.l #-1,0x04(a6,a4.l)
	move.l 0x00(a6,a2.l),0x00(a6,a4.l)
	movea.l 0x00(a6,a4.l),a5
	subq.w #4,a4
	move.l 0x000c(a6),0x00(a6,a4.l)
	addq.w #4,a2
	move.l a2,0x0050(a6)
	move.l a4,0x0048(a6)
	move.l a5,d3
	bne.w l08868
	addq.w #8,a7
	moveq #0x00,d0
	rts

l0890c:	move.l 0x4c(a6),0x48(a6)
.equ xl0490c, l0890c-0x4000
	move.l 0x54(a6),0x50(a6)
	move.l 0x8(a6),0xc(a6)
	moveq #0x7e,d1
	jsr l04e6e(pc)
	moveq #0x20,d1
	jsr l04e4e(pc)
	move.l 0x0058(a6),0x0054(a6)
	subi.l #0x0020,0x0054(a6)
	move.l 0x0054(a6),0x0050(a6)
	moveq #0x50,d1
	jsr l04e5a(pc)
	move.l 0x0050(a6),0x004c(a6)
	subi.l #0x0050,0x004c(a6)
	move.l 0x004c(a6),0x0048(a6)
	moveq #0x00,d0
	jsr l04e32(pc)
	move.w #0x0200,d1
	jmp l04e54(pc)

l08966:	movem.l d0-d5/a1-a5,-(a7)
	movea.l a2,a3
	movea.l a0,a1
	moveq #0x00,d3
	moveq #0x00,d4
	moveq #0x00,d5
	moveq #0x00,d0
	lsr.b #1,d6
	beq.s l08980
	jsr l0858c(pc)
	bra.s l08986

l08980:	st d0
	swap d0
	moveq #0x01,d6
l08986:	moveq #0x00,d1
	cmp.b (a2),d6
	bgt.w l08a48
	move.b 0x00(a2,d6.w),d1
	adda.l d1,a2
	move.b (a2)+,d1
	ror.l #4,d1
	move.b d1,d4
	swap d1
	rol.w #4,d1
	move.b d1,d3
l089a0:	subq.b #1,d4
	blt.s l089fc
	move.b (a2)+,d2
	cmpi.b #0x60,d2
	bgt.s l089b2
	st d0
	sf d5
	bra.s l089bc

l089b2:	sf d0
	tst.b d5
	bne.s l089a0
	subi.b #0x20,d2
l089bc:	move.b 0x00(a6,a0.l),d1
	addq.w #1,a0
	cmpi.b #0x60,d1
	ble.s l089cc
	subi.b #0x20,d1
l089cc:	cmp.b d2,d1
	beq.s l089a0
	tst.b d0
	bne.s l089da
	st d5
	subq.w #1,a0
	bra.s l089a0

l089da:	swap d0
	tst.b d0
	beq.s l08a48
	swap d5
	tst.b d5
	swap d5
	beq.s l089ec
	tst.b d3
	bne.s l089f4
l089ec:	addq.w #1,d6
	movea.l a1,a0
	movea.l a3,a2
	bra.s l08986

l089f4:	movea.l a4,a0
	subq.b #1,d3
	adda.l d4,a2
	bra.s l08a30

l089fc:	swap d0
	tst.b d0
	beq.s l08a38
	move.b 0x00(a6,a0.l),d1
	blt.s l08a48
	lea l03c28(pc),a5
	cmpi.b #0x01,0x00(a5,d1.w)
	beq.s l08a1e
	cmpi.b #0x02,0x00(a5,d1.w)
	beq.s l08a48
	bra.s l08a40

l08a1e:	swap d5
	tst.b d5
	bne.s l08a48
	tst.b d3
	beq.s l08a48
	st d5
	swap d5
	subq.b #1,d3
	movea.l a0,a4
l08a30:	move.b (a2)+,d4
	lsr.b #4,d4
	bra.w l089a0

l08a38:	moveq #-0x7f,d4
	move.b d6,d5
	jsr l08dfa(pc)
l08a40:	movem.l (a7)+,d0-d5/a1-a5
	addq.l #2,(a7)
	rts

l08a48:	movem.l (a7)+,d0-d5/a1-a5
	rts

l08a4e:	move.l 0x0008(a6),0x000c(a6)
.equ xl04a4e, l08a4e-0x4000
	movea.l (a6),a0
	jsr l08474(pc)
	bra.s l08a76 | *ERROR
o08a5c:	moveq #-0x7f,d4 | *ERROR
	moveq #0x1f,d5
	jsr l08dfa(pc)
	jsr l085f2(pc) | *SUCCESS
	bra.s l08a76

o08a6a:	moveq #-0x7c,d4
	moveq #0x0a,d5
	jsr l08dfa(pc)
	moveq #0x00,d0
	rts

l08a76:	moveq #-0x15,d0
	rts

l08a7a:	move.l a5,d4
	bra.s l08a80

l08a7e:	moveq #0x00,d4
l08a80:	jsr l04e52(pc)
	movea.l 0x0048(a6),a4
	suba.w #0x000c,a4
	move.l d4,0x08(a6,a4.l)
	move.l a0,0x04(a6,a4.l)
	move.l 0x000c(a6),0x00(a6,a4.l)
	move.l a4,0x0048(a6)
	rts

l08aa0:	jsr l04e58(pc)
	movea.l 0x0050(a6),a4
	subq.w #4,a4
	move.l d4,0x00(a6,a4.l)
	move.l a4,0x0050(a6)
	rts

l08ab4:	movea.l 0x0008(a6),a0
.equ xl04ab4, l08ab4-0x4000
l08ab8:	cmpa.l 0x000c(a6),a0
	bge.s l08ada
	cmpi.b #0x81,0x00(a6,a0.l)
	bne.s l08acc
	addq.w #2,a0
	bsr.s l08af4
	bra.s l08ab8

l08acc:	cmpi.w #0x8409,0x00(a6,a0.l)
	addq.w #2,a0
	bne.s l08ab8
	bsr.s l08b10
	bra.s l08ab8

l08ada:	movea.l 0x0008(a6),a0
	cmpi.b #0x80,0x00(a6,a0.l)
	bne.s l08aea
	addq.w #2,a0
	bsr.s l08b10
l08aea:	cmpi.w #0x8d00,0x00(a6,a0.l)
.equ xl04aea, l08aea-0x4000
	bne.s l08b0e
	addq.w #4,a0
l08af4:	cmpi.b #0x80,0x00(a6,a0.l)
	bne.s l08b0e
	move.b 0x01(a6,a0.l),d1
	addq.w #2,a0
	subq.b #1,d1
	bgt.s l08b0a
	bsr.s l08b10
	bra.s l08b0e

l08b0a:	move.b d1,-0x01(a6,a0.l)
l08b0e:	rts

l08b10:	lea -0x0002(a0),a2
l08b14:	move.w 0x00(a6,a0.l),-0x02(a6,a0.l)
	addq.w #2,a0
	cmpa.l 0x000c(a6),a0
	blt.s l08b14
	subq.l #2,0x000c(a6)
	movea.l a2,a0
	rts
|* NOW SEPERATORS =:#,(){} SPACE AND CR
|* THIS WAS INTERPRETED AS CODE !!! CORRECTED

.balign 2, 0 ; l08b2a:	.long 0x3d3a232c
.balign 2, 0 ; 	.long 0x28297b7d
.balign 2, 0 ; 	.word 0x200a
.equ l08b29, l08b2a-0x01

l08b34:	lsr.b #1,d6
l08b36:	move.b 0x00(a6,a0.l),d1
	cmp.b l08b29(pc,d6.w),d1 | * !!! LABEL REDEFINED
	beq.s l08b4c
	cmpi.b #0x20,d1
	bne.s l08b58
	jsr l0858c(pc)
	bra.s l08b36

l08b4c:	addq.w #1,a0
	moveq #-0x7c,d4
	move.b d6,d5
	jsr l08dfa(pc)
	addq.l #2,(a7)
l08b58:	rts

l08b5a:
.equ xl04b5a, l08b5a-0x4000
.balign 2, 0 ; 	.long xl08d2b | * BASE OF INSTRUCTION-LIST
.balign 2, 0 ; 	.long xl08b62 | * BASE OF SYTAX ANAYSIS

.balign 2, 0 ; l08b62:	.long 0x0022004e
.equ xl08b62, l08b62
.balign 2, 0 ; 	.long 0x00ae0060
.balign 2, 0 ; 	.long 0x006600bc
.balign 2, 0 ; 	.long 0x00c400e3
.balign 2, 0 ; 	.long 0x00fa0163
.balign 2, 0 ; 	.long 0x01780185
.balign 2, 0 ; 	.long 0x019901a2
.balign 2, 0 ; 	.long 0x01b001bd
.balign 2, 0 ; 	.long 0x01be1401
.balign 2, 0 ; 	.long 0x840f8a12
.balign 2, 0 ; 	.long 0x861e8809
.balign 2, 0 ; 	.long 0x68f98c05
.balign 2, 0 ; 	.long 0x90039201
.balign 2, 0 ; 	.long 0x25f13500
.balign 2, 0 ; 	.long 0x00780625
.balign 2, 0 ; 	.long 0xea350000
.balign 2, 0 ; 	.long 0x33e525e3
.balign 2, 0 ; 	.long 0x35000035
.balign 2, 0 ; 	.long 0x0025018e
.balign 2, 0 ; 	.long 0xda004e02
.balign 2, 0 ; 	.long 0x00500452
.balign 2, 0 ; 	.long 0x02003202
.balign 2, 0 ; 	.long 0x00020200
.balign 2, 0 ; 	.long 0x80940000
.balign 2, 0 ; 	.long 0x44084812
.balign 2, 0 ; 	.long 0x4c164608
.balign 2, 0 ; 	.long 0x00320200
.balign 2, 0 ; 	.long 0x17160033
.balign 2, 0 ; 	.long 0x02009800
.balign 2, 0 ; 	.long 0x00320200
.balign 2, 0 ; 	.long 0x0200005c
.balign 2, 0 ; 	.long 0x0a320200
.balign 2, 0 ; 	.long 0x02190023
.balign 2, 0 ; 	.long 0x0c008033
.balign 2, 0 ; 	.long 0x02009808
.balign 2, 0 ; 	.long 0x00270900
.balign 2, 0 ; 	.long 0x960d0080
.balign 2, 0 ; 	.long 0x28f50098
.balign 2, 0 ; 	.long 0x0c00809a
.balign 2, 0 ; 	.long 0x00007a09
.balign 2, 0 ; 	.long 0x8028ee00
.balign 2, 0 ; 	.long 0x8028e700
.balign 2, 0 ; 	.long 0x33020098
.balign 2, 0 ; 	.long 0xf4004a02
.balign 2, 0 ; 	.long 0x00320200
.balign 2, 0 ; 	.long 0x6a041600
.balign 2, 0 ; 	.long 0x0033fc00
.balign 2, 0 ; 	.long 0x660a6408
.balign 2, 0 ; 	.long 0x6c0c6a11
.balign 2, 0 ; 	.long 0x22150032

.balign 2, 0 ; l08c2a:	.long 0x02000200
.balign 2, 0 ; 	.long 0x00803202
.balign 2, 0 ; 	.long 0x00980000
.balign 2, 0 ; 	.long 0x32020002
.balign 2, 0 ; 	.long 0xec006e00
.balign 2, 0 ; 	.long 0x96020028
.balign 2, 0 ; 	.long 0xfc800042
.balign 2, 0 ; 	.long 0x0200480d
.balign 2, 0 ; 	.long 0x440b4600
.balign 2, 0 ; 	.long 0x4a004c00
.balign 2, 0 ; 	.long 0x4e020080
.balign 2, 0 ; 	.long 0x32020002
.balign 2, 0 ; 	.long 0x00006216
.balign 2, 0 ; 	.long 0x704d7219
.balign 2, 0 ; 	.long 0x74217c2b
.balign 2, 0 ; 	.long 0x7e29542a
.balign 2, 0 ; 	.long 0x6a337649
.balign 2, 0 ; 	.long 0x9e4d0251
.balign 2, 0 ; 	.long 0x00803202
.balign 2, 0 ; 	.long 0x00980000
.balign 2, 0 ; 	.long 0x3202009c
.balign 2, 0 ; 	.long 0x020028fc
.balign 2, 0 ; 	.long 0x80003202
.balign 2, 0 ; 	.long 0x0002049c
.balign 2, 0 ; 	.long 0x020028fa
.balign 2, 0 ; o8c8e:	.long 0x80001200
.balign 2, 0 ; 	.long 0x00560458
.balign 2, 0 ; 	.long 0x02003202
.balign 2, 0 ; 	.long 0x00980000
.balign 2, 0 ; 	.long 0x32020098
.balign 2, 0 ; 	.long 0x02005402
.balign 2, 0 ; 	.long 0x00560458
.balign 2, 0 ; 	.long 0x02003302
.balign 2, 0 ; 	.long 0x00980200
.balign 2, 0 ; 	.long 0x28fc8000
.balign 2, 0 ; 	.long 0x3202009e
.balign 2, 0 ; 	.long 0x02002202
.balign 2, 0 ; 	.long 0x00980000
.balign 2, 0 ; 	.long 0xa000002b
.balign 2, 0 ; 	.long 0x02000204
.balign 2, 0 ; 	.long 0x2b070028
.balign 2, 0 ; 	.long 0xfa2d0000
.balign 2, 0 ; o8cd2:	.long 0x02020028
.balign 2, 0 ; 	.long 0xfc2df700
.balign 2, 0 ; 	.long 0x98020056
.balign 2, 0 ; 	.long 0x03800032
.balign 2, 0 ; 	.long 0x02009800
.balign 2, 0 ; l08ce6:	.long 0x000c012a
.equ xl04ce7, l08ce6-0x3fff
.balign 2, 0 ; 	.long 0x08100c04
.balign 2, 0 ; 	.long 0x0c020800
.balign 2, 0 ; 	.long 0x9802002c
.balign 2, 0 ; 	.long 0x04002a05
.balign 2, 0 ; 	.long 0x800aeb00
.balign 2, 0 ; 	.long 0xa202002c
.balign 2, 0 ; 	.long 0xf6000202
.balign 2, 0 ; 	.long 0x002a0200
.balign 2, 0 ; 	.long 0x98020028
.balign 2, 0 ; 	.long 0xfc2c0000
.balign 2, 0 ; 	.long 0x02020080
.balign 2, 0 ; 	.long 0x2a0200a2
.balign 2, 0 ; 	.long 0x02002cf8
.balign 2, 0 ; 	.long 0x00800efe
.balign 2, 0 ; 	.long 0x26019802
.balign 2, 0 ; 	.long 0x000ef780
.balign 2, 0 ; 	.word 0x001f
.balign 2, 0 ; l08d2c:	.long 0x2024282b
.equ xl08d2b, l08d2c-1
.balign 2, 0 ; 	.word 0x3239
.balign 2, 0 ; 	.long 0x3e454f58
.balign 2, 0 ; 	.long 0x5b5e6267
.balign 2, 0 ; 	.long 0x6d71777f
.balign 2, 0 ; 	.long 0x84898e91
.balign 2, 0 ; 	.long 0x98a2a7ab
.balign 2, 0 ; 	.long 0xb1b5babf
.balign 2, 0 ; 	.word 0xc636
	.ascii "END" ; .byte 0x30 ; .ascii "FOR"
	.byte 0x20 ; .ascii "IF" ; .byte 0x60 ; .ascii "REPeat"
	.byte 0x60 ; .ascii "SELect" ; .byte 0x40 ; .ascii "WHEN"
	.byte 0x62 ; .ascii "DEFine" ; .byte 0x90 ; .ascii "PROCedure"
	.byte 0x80 ; .ascii "FuNction" ; .byte 0x22 ; .ascii "GO TO"
	.byte 0x30 ; .ascii "SUB" ; .byte 0x41 ; .ascii "WHEN" ; .byte 0x50 ; .ascii "ERRor"
	.byte 0x30 ; .ascii "END" ; .byte 0x50 ; .ascii "ERRor" ; .byte 0x70 ; .ascii "RESTORE"

|* LABEL L08DAA WAS SET WRONG !!! CORRECTED

l08daa:	.byte 0x40 ; .ascii "NEXT" ; .byte 0x40 ; .ascii "EXIT" ; .byte 0x40 ; .ascii "ELSE"
	.byte 0x20 ; .ascii "ON" ; .byte 0x60 ; .ascii "RETurn"
	.byte 0x90 ; .ascii "REMAINDER" ; .byte 0x40 ; .ascii "DATA"
	.byte 0x30 ; .ascii "DIM" ; .byte 0x50 ; .ascii "LOCal"
	.byte 0x30 ; .ascii "LET" ; .byte 0x40 ; .ascii "THEN" ; .byte 0x40 ; .ascii "STEP"
	.byte 0x60 ; .ascii "REMark" ; .byte 0x70 ; .ascii "MISTake" ; .byte 0x00

l08dfa:	moveq #0x02,d1
	bsr.s l08e68
	move.b d4,0x00(a6,a3.l)
	move.b d5,0x01(a6,a3.l)
	addq.w #2,a3
	bra.s l08e5e

l08e0a:	moveq #0x04,d1
	moveq #0x00,d2
	bsr.s l08e76
l08e10:	bra.s l08e5e

l08e12:	moveq #0x06,d1
l08e14:	move.l a1,0x0058(a6)
	bsr.s l08e68
	movea.l 0x0058(a6),a1
	addq.l #6,0x0058(a6)
	move.w 0x00(a6,a1.l),d2
	addi.w #0xf000,d2
	move.w d2,0x00(a6,a3.l)
	move.l 0x02(a6,a1.l),0x02(a6,a3.l)
	addq.w #6,a3
	bra.s l08e5e

l08e38:	moveq #0x01,d1
	add.w d5,d1
	bvs.s l08e64
l08e3e:	addq.w #4,d1
	bsr.s l08e76
	beq.s l08e5e
	move.w d5,d1
l08e46:	move.b 0x00(a6,a2.l),0x00(a6,a3.l)
	addq.w #1,a3
	addq.w #1,a2
	subq.w #1,d1
	bne.s l08e46
	btst d7,d5
	beq.s l08e5e
	move.b d7,0x00(a6,a3.l)
	addq.w #1,a3
l08e5e:	move.l a3,0x000c(a6)
l08e62:	rts

l08e64:	addq.w #4,a7
	rts

l08e68:	move.b d2,-(a7)
	jsr l04e6e(pc)
	move.b (a7)+,d2
	movea.l 0x000c(a6),a3
	rts

l08e76:	bsr.s l08e68
	move.b d4,0x00(a6,a3.l)
	move.b d2,0x01(a6,a3.l)
	move.w d5,0x02(a6,a3.l)
	addq.w #4,a3
	rts

l08e88:	movea.l 0x0008(a6),a1
.equ xl04e88, l08e88-0x4000
	cmpi.b #0x8d,0x00(a6,a1.l)
	bne.w l08f82
	move.w 0x02(a6,a1.l),d2
	move.l 0x000c(a6),d1
	sub.l a1,d1
	subq.w #6,d1
	seq d0
	addq.w #6,d1
	moveq #0x00,d6
	moveq #0x00,d5
	movea.l 0x0010(a6),a0
	moveq #0x00,d3
	bra.s l08eb6

l08eb2:	move.w 0x02(a6,a0.l),d3
l08eb6:	add.w d5,d6
	adda.l d6,a0
	move.w 0x00(a6,a0.l),d5
	addq.w #2,a0
	cmpa.l 0x0014(a6),a0
	blt.s l08ece
	addq.b #1,d0
	bgt.s l08f44
	subq.w #2,a0
	bra.s l08efe

|* insert new line in prog

l08ece:	cmp.w 0x02(a6,a0.l),d2
	bgt.s l08eb2
	beq.s l08f00
	subq.w #2,a0
	tst.b d0
	bne.s l08efe
	addq.w #2,d1
	bsr.w l08f84
	bsr.s l08f3a
	subq.w #2,d1
	move.w d1,d5
	sub.w d6,d5
	move.w d5,0x00(a6,a0.l)
	moveq #0x01,d0
l08ef0:	bsr.w l08f92
	add.w 0x00(a6,a0.l),d6
	sub.w d1,d6
	move.w d6,0x00(a6,a0.l)
l08efe:	bra.s l08f5c

|* replace existing line in prog

l08f00:	tst.b d0
	beq.s l08f06
	moveq #-0x02,d1
l08f06:	add.w d6,d5
	lea -0x0002(a0),a3
	adda.l d5,a0
	cmpa.l 0x0014(a6),a0
	bge.s l08f3c
	sub.w d5,d1
	blt.s l08f1a
	bsr.s l08f84
l08f1a:	bsr.s l08f3a
	movea.l a3,a0
	add.w d5,d1
	bgt.s l08f2e
	add.w 0x00(a6,a0.l),d5
	sub.w d6,d5
	move.w d5,0x00(a6,a0.l)
	bra.s l08f5c

l08f2e:	move.w d1,d4
	sub.w d6,d4
	move.w d4,0x00(a6,a0.l)
	move.w d5,d6
	bra.s l08ef0

l08f3a:	bra.s l08fa6

l08f3c:	lea 0x0002(a3),a0
	move.l a3,0x0014(a6)
l08f44:	subq.w #2,a0
	tst.b d0
	blt.s l08f5c
	addq.w #2,d1
	bsr.s l08f84
	subq.w #2,d1
	sub.w d6,d1
	move.w d1,0x00(a6,a0.l)
	bsr.s l08f92
	move.l a0,0x0014(a6)
l08f5c:	tst.b 0x00b9(a6)
	beq.s l08f80
	sf 0x00aa(a6)
	bgt.s l08f70
	move.w d3,0x00ac(a6)
	bne.s l08f7c
	bra.s l08f80

l08f70:	cmpa.l 0x0014(a6),a0
	bge.s l08f7c
	move.w 0x04(a6,a0.l),0x00ac(a6)
l08f7c:	st 0x00aa(a6)
l08f80:	addq.l #2,(a7)
l08f82:	rts

l08f84:	movem.l d0-d3/a0-a3,-(a7)
	jsr l04e82(pc)
	movem.l (a7)+,d0-d3/a0-a3
	rts

l08f92:	addq.w #2,a0
	move.w 0x00(a6,a1.l),0x00(a6,a0.l)
	addq.w #2,a1
	cmpa.l 0x000c(a6),a1
	blt.s l08f92
	addq.w #2,a0
	rts

l08fa6:	movem.l d0-d3/a0-a3,-(a7)
	ext.l d1
	tst.l d1
	beq.s l08fe0
	movea.l 0x0014(a6),a1
	blt.s l08fca
	lea 0x00(a1,d1.w),a2
l08fba:	subq.w #2,a1
	subq.w #2,a2
	move.w 0x00(a6,a1.l),0x00(a6,a2.l)
	cmpa.l a0,a1
	bgt.s l08fba
	bra.s l08fdc

l08fca:	lea 0x00(a0,d1.w),a2
l08fce:	move.w 0x00(a6,a0.l),0x00(a6,a2.l)
	addq.w #2,a0
	addq.w #2,a2
	cmpa.l a1,a0
	blt.s l08fce
l08fdc:	add.l d1,0x0014(a6)
l08fe0:	movem.l (a7)+,d0-d3/a0-a3
	rts

l08fe6:	st 0x00ab(a6)
	movea.l 0x0040(a6),a1
	move.l 0x0044(a6),d0
	sub.l a1,d0
	bne.s l09000
	move.w d2,d4
	beq.s l09060
	move.w d2,d6
	bra.s l09044

l08ffe:	move.w d4,d2
l09000:	move.w 0x00(a6,a1.l),d4
	tst.w d2
	beq.s l08ffe
	move.w 0x009e(a6),d6
	cmp.w 0x009c(a6),d2
	blt.s l09060
	cmp.w d4,d2
	blt.s l09032
	cmp.w 0x00a0(a6),d2
	bgt.s l09060
	cmp.w d6,d2
	bgt.s l0902a
	tst.b d5
	bge.s l09044
	move.w 0x00a0(a6),d6
	bra.s l09044

l0902a:	tst.b d5
	blt.s l09060
	move.w d2,d6
	bra.s l09044

l09032:	tst.b d5
	blt.s l09060
	move.w d2,d4
	move.w 0x00a4(a6),d0
	sub.w 0x00a6(a6),d0
	bgt.s l09044
	subq.w #1,d6
l09044:	move.w d2,0x00ba(a6)
	moveq #0x10,d0
	moveq #0x00,d2
	moveq #0x00,d1
	bsr.s l0905c
	moveq #0x00,d7
	jsr l07518(pc)
	moveq #0x24,d0
	bsr.s l0905c
	moveq #0x22,d0
l0905c:	moveq #-0x01,d3
	trap #0x03
l09060:	rts

.balign 2, 0 ; l09062:	.long 0x02020404
.balign 2, 0 ; 	.long 0x02020204
.balign 2, 0 ; 	.long 0x040204fb
.balign 2, 0 ; 	.long 0xfb040200

l09072:	moveq #0x00,d0
	moveq #0x06,d1
	move.b 0x00(a6,a4.l),d0
	beq.s l09098
	subi.b #0x80,d0
	cmpi.b #0x70,d0
	bge.s l09096
	move.b l09062(pc,d0.w),d1
	bge.s l09096
	neg.b d1
	add.w 0x02(a6,a4.l),d1
	bclr #0x00,d1
l09096:	adda.l d1,a4
l09098:	move.b 0x00(a6,a4.l),d0
	move.w 0x00(a6,a4.l),d1
	rts

l090a2:	move.l a1,-(a7)
	movea.l 0x0030(a6),a1
	adda.w #0x0050,a1
	move.l 0x00(a6,a1.l),d0
	sub.l a0,d0
	movea.l (a7)+,a1
	rts

l090b6:	move.l a5,-(a7)
	movea.l a0,a5
	bsr.s l090a2
	seq 0x009b(a6)
	bne.s l09108
	moveq #0x0b,d0
	lea 0x00a2(a6),a1
	moveq #-0x01,d3
	trap #0x03
	move.l 0x0040(a6),0x0044(a6)
	clr.w 0x00a6(a6)
	moveq #0x64,d1
	jsr l04e7e(pc)
	move.w 0x0068(a6),0x009c(a6)
	move.w #0x7fff,0x00a0(a6)
	bra.s l09108

.balign 2, 0 ; l090ea:	.word l092f8-l090ea
.balign 2, 0 ; 	.word l09314-l090ea
.balign 2, 0 ; 	.word l09292-l090ea
.balign 2, 0 ; 	.word l09292-l090ea
.balign 2, 0 ; 	.word l09338-l090ea
.balign 2, 0 ; 	.word l0930e-l090ea
.balign 2, 0 ; 	.word l0931a-l090ea
.balign 2, 0 ; 	.word l09292-l090ea
.balign 2, 0 ; 	.word l0929c-l090ea
.balign 2, 0 ; 	.word l09292-l090ea
.balign 2, 0 ; 	.word l09292-l090ea
.balign 2, 0 ; 	.word l092e2-l090ea
.balign 2, 0 ; 	.word l092ec-l090ea
.balign 2, 0 ; 	.word l09238-l090ea
.balign 2, 0 ; 	.word l09308-l090ea

l09108:	move.l (a2),-(a7)
	addq.w #2,a4
	moveq #0x00,d4
	move.b #0x8d,d4
l09112:	move.l (a6),0x0004(a6)
l09116:	cmpa.l 0x0014(a6),a4
	blt.s l09130
	tst.b 0x00ab(a6)
	bne.w l09202
	tst.b 0x00aa(a6)
	beq.w l09202
	bsr.w l09250
l09130:	moveq #0x10,d1
	bsr.w l092c0
	movea.l (a7),a1
	subi.b #0x80,d4
	cmpi.b #0x70,d4
	bge.w l091f2
	add.b d4,d4
	move.w l090ea(pc,d4.w),d4
	jsr l090ea(pc,d4.w)
	cmpi.b #0x8d,d4
	bne.w l091f4
	tst.b 0x00ab(a6)
	beq.w l091fe
	tst.b 0x009b(a6)
	beq.s l091b8
	movea.l (a6),a1
	move.l 0x0004(a6),d2
	sub.l a1,d2
	movea.l 0x0044(a6),a2
	move.w 0x009e(a6),0x00(a6,a2.l)
	subq.w #2,d2
	divu 0x00a2(a6),d2
	addq.w #1,d2
	move.w d2,0x02(a6,a2.l)
	add.w 0x00a6(a6),d2
l09186:	cmp.w 0x00a4(a6),d2
	ble.s l091ac
	move.w 0x00ba(a6),d0
	beq.s l09198
	cmp.w 0x009e(a6),d0
	blt.s l091e4
l09198:	movea.l 0x0040(a6),a2
	sub.w 0x02(a6,a2.l),d2
	move.w 0x00(a6,a2.l),0x009c(a6)
	addq.l #4,0x0040(a6)
	bra.s l09186

l091ac:	move.w d2,0x00a6(a6)
	addq.l #4,0x0044(a6)
	jsr l04f9e(pc)
l091b8:	moveq #0x07,d0
	movea.l (a6),a1
	move.l 0x0004(a6),d2
	sub.l a1,d2
	movea.l a5,a0
	moveq #-0x01,d3
	trap #0x04
	trap #0x03
	tst.l d0
	bne.s l09204
	move.l d1,d2
	moveq #0x24,d0
	trap #0x03
	tas 0x008f(a6)
	bne.w l09112
	move.w 0x009e(a6),0x00a0(a6)
	bra.s l09202

l091e4:	move.w 0x009e(a6),0x00a0(a6)
	move.w -0x04(a6,a2.l),0x009e(a6)
	bra.s l09202

l091f2:	bsr.s l09216
l091f4:	jsr l09072(pc)
	move.w d0,d4
	bra.w l09116

l091fe:	subq.l #1,0x0004(a6)
l09202:	moveq #0x00,d0
l09204:	addq.w #4,a7
	movea.l a5,a0
	movea.l (a7)+,a5
	rts

l0920c:	jsr l04e4c(pc)
	movea.l 0x0058(a6),a1
	rts

l09216:	bsr.s l0920c
	move.w 0x00(a6,a4.l),d2
	subi.w #0xf000,d2
	subq.w #6,a1
	move.w d2,0x00(a6,a1.l)
	move.l 0x02(a6,a4.l),0x02(a6,a1.l)
	movea.l 0x0004(a6),a0
	jsr l03ef6(pc)
	bra.w l09364

l09238:	bsr.s l0920c
	move.w 0x02(a6,a4.l),d1
	tst.b 0x00ab(a6)
	bne.s l0925c
	tst.b 0x00aa(a6)
	beq.s l0925c
	cmp.w 0x00ac(a6),d1
	beq.s l0925c
l09250:	bsr.s l0920c
	move.w 0x00ac(a6),d1
	bsr.s l09276
l09258:	addq.w #4,a7
	bra.s l09202

l0925c:	tst.b 0x009b(a6)
	beq.s l09288
	cmp.w d6,d1
	ble.s l09272
	tst.w 0x00ba(a6)
	bne.s l09272
	move.w d1,0x00a0(a6)
	bra.s l09258

l09272:	move.w d1,0x009e(a6)
l09276:	subq.w #2,a1
	move.w d1,0x00(a6,a1.l)
	movea.l 0x0004(a6),a0
	jsr l03e54(pc)
	bra.w l09316

l09288:	cmp.w d6,d1
	bgt.s l09258
	bra.s l09276
.balign 2, 0 ; l0928e:	.long 0x3f3f3f3f
l09292:	moveq #0x04,d1
	lea l0928e(pc),a1
	bra.w l0935a

l0929c:	move.w 0x02(a6,a4.l),d2
	lsl.l #3,d2
	movea.l 0x0018(a6),a1
	adda.w d2,a1
	move.w 0x02(a6,a1.l),d2
	blt.s l09292
	movea.l 0x0020(a6),a1
	adda.w d2,a1
	moveq #0x00,d1
	move.b 0x00(a6,a1.l),d1
	addq.w #1,a1
	bra.w l09354

l092c0:	suba.l 0x0010(a6),a4
	suba.l 0x0010(a6),a1
	movem.l d1/a1/a4,-(a7)
	jsr l04e6a(pc)
	movea.l 0x0004(a6),a0
	movem.l (a7)+,d1/a1/a4
	adda.l 0x0010(a6),a1
	adda.l 0x0010(a6),a4
	rts

l092e2:	bsr.s l092e6
	bsr.s l092ec
l092e6:	move.b 0x01(a6,a4.l),d2
	bra.s l0934c

l092ec:	move.w 0x02(a6,a4.l),d1
	beq.s l09306
	lea 0x0004(a4),a1
	bra.s l09354

l092f8:	move.b 0x01(a6,a4.l),d1
	bsr.s l092c0
l092fe:	moveq #0x20,d2
	bsr.s l0934c
	subq.b #1,d1
	bgt.s l092fe
l09306:	rts

l09308:	lea l0936c(pc),a1
	bra.s l0931e

l0930e:	lea l0938e(pc),a1
	bra.s l0931e

l09314:	bsr.s l0931e
l09316:	moveq #0x20,d2
	bra.s l0934c

l0931a:	lea l0937e(pc),a1
l0931e:	move.b 0x01(a6,a4.l),d1
	move.b 0x00(a1,d1.w),d1
	adda.l d1,a1
	move.b (a1)+,d1
	lsr.l #4,d1
l0932c:	bra.s l0935a

|* SAME BUG AS IN L08B2A - SEPARATORS INSTEAD OF CODE
|* CORRECTED

.balign 2, 0 ; l0932e:	.long 0x3d3a232c
.balign 2, 0 ; 	.long 0x28297b7d
.balign 2, 0 ; 	.word 0x200a
.equ xl0932d, l0932e-0x01

l09338:	move.b 0x01(a6,a4.l),d1
l0933c:	move.b xl0932d(pc,d1.w),d2
	moveq #0x00,d4
	sub.b d2,d1
	bne.s l0934c
	addq.w #4,a4
	move.b #0x8d,d4
l0934c:	move.b d2,0x00(a6,a0.l)
	addq.w #1,a0
	bra.s l09364

l09354:	bsr.w l092c0
	adda.l a6,a1
l0935a:	move.b (a1)+,0x00(a6,a0.l)
	addq.w #1,a0
	subq.w #1,d1
	bgt.s l0935a
l09364:	move.l a0,0x0004(a6)
	moveq #0x00,d0
	rts


|* ASCII-CODE FOR SEPARATORS
|* THERE ARE 5 -EACH BYTE SHOWS DISPLACEMENT
l0936c:	.byte 0x05, 0x06, 0x08, 0x0a, 0x0c, 0x0e
|* HERE THEY ARE - 10 MEANS LENGTH 1
	.byte 0x10 ; .ascii ","
	.byte 0x10 ; .ascii ";" ; .byte 0x10 ; .ascii "\\"
	.byte 0x10 ; .ascii "!" ; .byte 0x20 ; .ascii "TO" ; .byte 0x00

|* NEXT LIST OF 4 OPERATORS
l0937e:	.byte 0x04, 0x05, 0x07, 0x09, 0x0c
	.byte 0x10 ; .ascii "-" ; .byte 0x10 ; .ascii "+"
	.byte 0x20 ; .ascii "~~" ; .byte 0x30 ; .ascii "NOT"

|* NEXT LIST OF $16 OPERATORS 
.balign 2, 0 ; l0938e:	.long 0x1617191b
.balign 2, 0 ; 	.long 0x1d1f2224
.balign 2, 0 ; 	.long 0x27292c2f
.balign 2, 0 ; 	.long 0x3134373a
.balign 2, 0 ; 	.long 0x3c3e4145
.balign 2, 0 ; 	.word 0x494d
	.byte 0x51
|* HERE THEY COME
	.byte 0x10 ; .ascii "+" ; .byte 0x10 ; .ascii "-" ; .byte 0x10 ; .ascii "*"
	.byte 0x10 ; .ascii "/" ; .byte 0x20 ; .ascii ">=" ; .byte 0x10 ; .ascii ">"
	.byte 0x20 ; .ascii "==" ; .byte 0x10 ; .ascii "=" ; .byte 0x20 ; .ascii "<>" ; .byte 0x20 ; .ascii "<="
	.byte 0x10 ; .ascii "<" ; .byte 0x20 ; .ascii "||" ; .byte 0x20 ; .ascii "&&" ; .byte 0x20 ; .ascii "^^"
	.byte 0x10 ; .ascii "^" ; .byte 0x10 ; .ascii "&" ; .byte 0x20 ; .ascii "OR"
	.byte 0x30 ; .ascii "AND" ; .byte 0x30 ; .ascii "XOR" ; .byte 0x30 ; .ascii "MOD"
	.byte 0x30 ; .ascii "DIV" ; .byte 0x50 ; .ascii "INSTR"
	.byte 0x00

|* CREATE ENTRY IN NAME-TABLE AND STORE VALUE

l093e6:	andi.b #0x0f,0x01(a6,a2.l)
	tst.l 0x04(a6,a2.l)
	bge.s l093f6
	moveq #-0x0c,d0
	rts

l093f6:	jsr l04e5e(pc)
	movea.l 0x001c(a6),a3
	addq.l #8,0x001c(a6)
	move.w 0x00(a6,a2.l),0x00(a6,a3.l)
	move.w d4,0x02(a6,a3.l)
	movea.l 0x04(a6,a2.l),a2
	adda.l 0x0028(a6),a2
	move.w 0x04(a6,a2.l),d1
	lsl.l #2,d1
	addq.w #6,d1
	jsr l07338(pc)
l09420:	move.w 0x00(a6,a2.l),0x00(a6,a0.l)
	addq.w #2,a2
	addq.w #2,a0
	subq.w #2,d1
	bgt.s l09420
l0942e:	jsr l0a56c(pc)
	cmpi.w #0x8401,d1
	beq.s l09456
	cmpi.w #0x8405,d1
	bne.w l094c2
	addq.w #2,a4
	movea.l a4,a0
	lea 0x0008(a3),a5
	jsr l06272(pc)
	lea -0x0008(a5),a3
	movea.l a0,a4
	bne.s l0948e
	bra.s l0942e

l09456:	addq.w #2,a4
	cmpi.b #0x02,0x00(a6,a3.l)
	beq.s l09478
	cmpi.b #0x01,0x01(a6,a3.l)
	bgt.s l094c6
	movea.l 0x04(a6,a3.l),a2
	adda.l 0x0028(a6),a2
	cmpi.w #0x0001,0x04(a6,a2.l)
	bgt.s l094c6
l09478:	movea.l a4,a0
	move.b 0x01(a6,a3.l),d0
	move.l a3,-(a7)
	jsr l05a84(pc)
	movea.l (a7)+,a3
	movea.l a0,a4
	bne.s l0948e
	jsr l072c2(pc)
l0948e:	cmpi.b #0x03,0x00(a6,a3.l)
	bne.s l094aa
	movea.l 0x04(a6,a3.l),a2
	adda.l 0x0028(a6),a2
	move.l d0,-(a7)
	move.l a3,-(a7)
	jsr l09a3c(pc)
	movea.l (a7)+,a3
	move.l (a7)+,d0
l094aa:	clr.l 0x00(a6,a3.l)
	clr.l 0x04(a6,a3.l)
	addq.w #8,a3
	cmpa.l 0x001c(a6),a3
	bne.s l094be
	subq.l #8,0x001c(a6)
l094be:	tst.l d0
	rts

l094c2:	moveq #-0x11,d0
	bra.s l0948e

l094c6:	moveq #-0x13,d0
	bra.s l0948e

l094ca:	jsr l04e64(pc)
	movea.l 0x003c(a6),a5
	tst.b d5
	beq.s l09504
	move.l d4,d3
	movea.l 0x001c(a6),a3
	move.l a3,0x00(a6,a5.l)
	move.l a3,0x04(a6,a5.l)
	move.l a3,0x08(a6,a5.l)
	move.w 0x04(a6,a2.l),d4
	bne.s l094f2
	moveq #-0x07,d0
	rts

l094f2:	move.w d4,0x0c(a6,a5.l)
	move.b 0x01(a6,a2.l),0x0e(a6,a5.l)
	sf 0x0f(a6,a5.l)
	adda.w #0x0010,a5
l09504:	move.b d5,0x00(a6,a5.l)
	move.b 0x006c(a6),0x01(a6,a5.l)
	move.w 0x0068(a6),0x02(a6,a5.l)
	move.l 0x006e(a6),0x04(a6,a5.l)
	addq.w #8,a5
	move.l a5,0x003c(a6)
	tst.b d5
	beq.s l09580
	cmpi.b #0x03,d5
	beq.s l09578
	movea.l a4,a0
	jsr l0614a(pc)
	movea.l 0x003c(a6),a5
	move.l 0x001c(a6),-0x14(a6,a5.l)
	move.l 0x001c(a6),-0x10(a6,a5.l)
	tst.l d0
	bne.s l09552
	move.w 0x00(a6,a0.l),d1
	cmpi.b #0x02,d5
	beq.s l09562
	bsr.s l0959e
	beq.s l09576
l09552:	bsr.w l097c8
	subi.l #0x0018,0x003c(a6)
	moveq #-0x0f,d0
	rts

l09562:	cmpi.w #0x8406,d1
	bne.s l09552
	addq.w #2,a0
	suba.l 0x0008(a6),a0
	move.l a0,0x0008(a7)
	adda.l 0x0008(a6),a0
l09576:	movea.l a0,a4
l09578:	st -0x09(a6,a5.l)
	movea.l -0x18(a6,a5.l),a3
l09580:	tst.b 0x006f(a6)
	beq.s l095a2
	bsr.s l0958e
	beq.s l095a2
	moveq #-0x07,d0
	bra.s l095b4

l0958e:	movea.l 0x0010(a6),a4
	sf 0x006f(a6)
	clr.w 0x006a(a6)
	jmp l0a966(pc)

l0959e:	bra.w l09686

l095a2:	tst.b d5
	beq.w l0a078
	bsr.w l09760
	bsr.w l09692
l095b0:	bsr.s l0960c
	beq.s l095dc
l095b4:	movea.l 0x003c(a6),a5
	move.l 0x001c(a6),-0x10(a6,a5.l)
	move.l 0x0018(a6),d1
	sub.l d1,-0x18(a6,a5.l)
	sub.l d1,-0x14(a6,a5.l)
	sub.l d1,-0x10(a6,a5.l)
	tst.l d0
	bne.s l095da
	addq.w #4,a7
	jmp l0a8c0(pc)

	moveq #0x00,d0
l095da:	rts

l095dc:	addq.w #2,a4
	bsr.s l0965c
	cmpi.b #0x88,d0
	bne.s l095fe
	bsr.s l09660
	bsr.s l0965c
	cmpi.w #0x8405,d1
	bne.s l095fe
	addq.b #1,0x00(a6,a2.l)
	subq.w #4,a4
	jsr l098e8(pc)
	bne.s l095b4
	bsr.s l0965c
l095fe:	cmpi.w #0x8404,d1
	beq.s l095dc
	bsr.s l0959e
	beq.s l095b0
	moveq #-0x15,d0
	bra.s l095b4

l0960c:	jsr l0a60e(pc)
	bne.s l09628
	bsr.s l0965c
	moveq #0x00,d0
	cmpi.w #0x811e,d1
	beq.s l0960c
	cmpi.w #0x8118,d1
	beq.s l0960c
	cmpi.w #0x811a,d1
	rts

l09628:	moveq #-0x0a,d0
	rts

l0962c:	moveq #0x00,d0
	move.w 0x02(a6,a4.l),d0
	lsl.l #3,d0
	movea.l 0x0018(a6),a2
	adda.l d0,a2
	move.w 0x00(a6,a2.l),d0
	move.w 0x00(a6,a3.l),0x00(a6,a2.l)
	move.w d0,0x00(a6,a3.l)
	move.l 0x04(a6,a2.l),d0
	move.l 0x04(a6,a3.l),0x04(a6,a2.l)
	move.l d0,0x04(a6,a3.l)
	addq.w #8,a3
	addq.w #4,a4
	rts

l0965c:	jmp l0a56c(pc)

l09660:	movea.l 0x001c(a6),a3
	move.b #0x02,0x00(a6,a3.l)
	move.w #-1,0x02(a6,a3.l)
	move.l #-1,0x04(a6,a3.l)
	bsr.s l0962c
	move.b -0x07(a6,a3.l),0x01(a6,a2.l)
	move.l a3,0x001c(a6)
	rts

l09686:	cmpi.w #0x840a,d1
	beq.s l09690
	cmpi.w #0x8402,d1
l09690:	rts

l09692:	bsr.s l0965c
	addq.w #2,a4
	bsr.s l0965c
	addq.w #2,a4
	bsr.s l0965c
	tst.w d3
	blt.s l096a6
	cmp.w 0x02(a6,a4.l),d3
	bne.s l096b4
l096a6:	addq.w #4,a4
	bsr.s l0965c
	cmpi.w #0x8405,d1
	beq.s l096c0
	bsr.s l09686
	beq.s l096ba
l096b4:	addq.w #4,a7
l096b6:	moveq #-0x07,d0
	rts

l096ba:	movea.l -0x14(a6,a5.l),a3
	rts

l096c0:	addq.w #2,a4
l096c2:	bsr.s l0965c
	cmpi.b #0x88,d0
	bne.s l096de
	cmpa.l -0x14(a6,a5.l),a3
	blt.s l096d8
	bsr.s l09660
	move.l a3,-0x14(a6,a5.l)
	bra.s l096c2

l096d8:	bsr.w l0962c
	bra.s l096c2

l096de:	cmpi.w #0x8406,d1
	bne.s l096c0
l096e4:	rts

|* execute RETURN
l096e6:	movea.l 0x003c(a6),a5
	cmpa.l 0x0038(a6),a5
	ble.s l096b6
	move.b -0x08(a6,a5.l),d5
	beq.s l09718
	move.b d5,d0
	subq.b #2,d0
	blt.s l09714
	move.b -0x0a(a6,a5.l),d0
	movea.l a4,a0
	jsr l05a84(pc)
	movea.l a0,a4
	blt.s l096e4
	beq.s l09710
	moveq #-0x11,d0
	rts

l09710:	movea.l 0x003c(a6),a5
l09714:	bsr.s l09768
	bne.s l096e4
l09718:	move.l -0x04(a6,a5.l),0x006e(a6)
	move.w -0x06(a6,a5.l),d4
	bsr.s l09760
	move.l -0x04(a6,a5.l),0x006e(a6)
	move.b -0x07(a6,a5.l),d4
	jsr l0a00a(pc)
	subq.w #8,a5
	tst.b d5
	beq.s l0973c
	suba.w #0x0010,a5
l0973c:	sf 0x0090(a6)
	move.l a5,0x003c(a6)
	moveq #0x00,d0
	subq.b #2,d5
	blt.s l0975c
	movea.l 0x001c(a6),a5
	move.b #0x01,-0x08(a6,a5.l)
	addq.w #8,a7
	movea.l (a7)+,a0
	adda.l 0x0008(a6),a0
l0975c:	tst.l d0
	rts

l09760:	jsr l09fa2(pc)
	jmp l0a966(pc)

l09768:	move.l 0x0018(a6),d0
	add.l d0,-0x18(a6,a5.l)
	add.l d0,-0x14(a6,a5.l)
	add.l d0,-0x10(a6,a5.l)
	cmpa.l 0x0010(a6),a4
	ble.s l09784
	cmpa.l 0x0014(a6),a4
	blt.s l09788
l09784:	bsr.w l0958e
l09788:	tst.b -0x09(a6,a5.l)
	beq.s l097c8
	move.w -0x0c(a6,a5.l),d4
	movea.l -0x14(a6,a5.l),a3
	bsr.s l09760
l09798:	bsr.w l0960c
	bne.s l097b0
l0979e:	move.w #0x8800,d4
	jsr l0a5e0(pc)
	bne.s l09798
	bsr.w l0962c
	subq.w #4,a4
	bra.s l0979e

l097b0:	move.w -0x0c(a6,a5.l),d4
	movea.l -0x18(a6,a5.l),a3
	tst.b d0
	beq.s l097c0
	bsr.w l0958e
l097c0:	bsr.s l09760
	moveq #-0x01,d3
	bsr.w l09692
l097c8:	movea.l -0x18(a6,a5.l),a3
	movea.l -0x10(a6,a5.l),a5
	jsr l05702(pc)
	bne.s l0975c
	movea.l 0x003c(a6),a5
	rts

l097dc:	bsr.s l097e0
	rts

l097e0:	movea.l 0x0030(a6),a0
	movea.l 0x00(a6,a0.l),a0
	move.l d0,-(a7)
	moveq #-0x1b,d0
	jsr l03968(pc)
	move.l (a7)+,d0
l097f2:	movea.l 0x003c(a6),a5
	cmpa.l 0x0038(a6),a5
	ble.s l09828
	move.b -0x08(a6,a5.l),d5
	beq.s l0980a
	bsr.w l09768
	suba.w #0x0010,a5
l0980a:	subq.w #8,a5
	move.l a5,0x003c(a6)
	subq.b #2,d5
	blt.s l097f2
	movea.l 0x001c(a6),a5
	subq.w #8,a5
l0981a:	moveq #0x00,d2
	jsr l05cbc(pc)
	bne.s l0981a
	move.l a5,0x001c(a6)
	bra.s l097f2

l09828:	sf 0x0090(a6)
	movea.l (a7)+,a3
	movea.l (a7)+,a5
	trap #0x00
	movea.l 0x0064(a6),a1
	adda.l a6,a1
	subq.w #4,a1
	move.l a1,usp
	move.w #0x0000,sr
	move.l a5,-(a7)
	move.l a3,-(a7)
	st 0x006f(a6)
	tst.b 0x00b8(a6)
	bne.w l0a6ee
	rts

l09852:	move.l a4,-(a7)
	jsr l09b32(pc)
	blt.s l09872
l0985a:	addq.w #2,a4
	jsr l0a56c(pc)
	move.l a4,-(a7)
	jsr l09b32(pc)
	cmpa.l (a7)+,a4
	bne.s l09870
	tst.b d0
	bge.s l0985a
	bra.s l09872

l09870:	moveq #0x00,d0
l09872:	movea.l (a7)+,a4
	rts

l09876:	moveq #0x00,d6
	move.l a4,d3
l0987a:	move.w 0x00(a6,a4.l),d1
	cmpi.w #0x810a,d1
	beq.s l098a0
	jsr l09686(pc)
	beq.s l098a2
	cmpi.w #0x8401,d1
	bne.s l0989a
	tst.b d6
	bne.s l0989a
	addq.w #2,a4
	move.l a4,d3
	moveq #0x01,d6
l0989a:	jsr l09072(pc)
	bra.s l0987a

l098a0:	moveq #-0x01,d0
l098a2:	movea.l d3,a4
	rts

|* execute DEFINE
l098a6:	moveq #0x07,d2
l098a8:	jsr l0a60e(pc)
	bne.s l098c2
	jsr l0a56c(pc)
	cmpi.w #0x8101,d1
	bne.s l098a8
	addq.w #2,a4
	jsr l0a56c(pc)
	cmp.b d2,d1
	bne.s l098a8
l098c2:	moveq #0x00,d0
	rts

|* execute DIM
l098c6:	movem.l d4-d6/a5,-(a7)
	subq.w #2,a4
l098cc:	addq.w #2,a4
	jsr l0a56c(pc)
	bsr.s l098e8
	bne.s l098e2
	jsr l0a56c(pc)
	cmpi.w #0x8404,d1
	beq.s l098cc
	moveq #0x00,d0
l098e2:	movem.l (a7)+,d4-d6/a5
	rts

l098e8:	moveq #0x00,d4
	move.w 0x02(a6,a4.l),d4
	addq.w #4,a4
	jsr l0a56c(pc)
	addq.w #2,a4
	moveq #0x00,d5
	movea.l (a6),a5
	movea.l a4,a0
l098fc:	move.l a5,-(a7)
	jsr l05a82(pc)
	movea.l (a7)+,a5
	movea.l a0,a4
	bne.s l09980
	addq.l #1,d5
	move.w 0x00(a6,a1.l),0x00(a6,a5.l)
	blt.s l0997a
	addq.w #4,a5
	addq.l #2,0x0058(a6)
	addq.w #2,a0
	cmpi.w #0x8404,-0x02(a6,a0.l)
	beq.s l098fc
	cmpi.w #0x8406,-0x02(a6,a0.l)
	bne.s l0997e
	lsl.l #3,d4
	movea.l 0x0018(a6),a3
	adda.l d4,a3
	cmpi.b #0x03,0x00(a6,a3.l)
	bne.s l09982
	move.b 0x01(a6,a3.l),d6
	cmpi.b #0x01,d6
	bne.s l09958
	move.w -0x04(a6,a5.l),d1
	addq.w #1,d1
	bclr #0x00,d1
	move.w d1,-0x04(a6,a5.l)
	ble.s l0997a
	moveq #0x02,d1
	bra.s l0995a

l09958:	moveq #0x01,d1
l0995a:	move.l d5,d0
	moveq #0x01,d2
l0995e:	subq.w #4,a5
	move.w d2,0x02(a6,a5.l)
	subq.l #1,d0
	beq.s l09986
	move.l d1,d3
	moveq #0x01,d1
	add.w 0x00(a6,a5.l),d3
	mulu d3,d2
	move.l d2,d3
	swap d3
	tst.w d3
	beq.s l0995e
l0997a:	moveq #-0x04,d0
	rts

l0997e:	moveq #-0x11,d0
l09980:	rts

l09982:	moveq #-0x0c,d0
	rts

l09986:	movea.l a0,a4
	move.l 0x04(a6,a3.l),d4
	blt.s l09990
	bsr.s l099fe
l09990:	move.l d5,d1
	lsl.l #2,d1
	addq.l #6,d1
	move.l a3,-(a7)
	jsr l04df6(pc)
	movea.l (a7)+,a3
	move.l a0,d1
	sub.l 0x0028(a6),d1
	move.l d1,0x04(a6,a3.l)
	move.l a0,-(a7)
	move.w d5,0x04(a6,a0.l)
	addq.w #6,a0
l099b0:	move.l 0x00(a6,a5.l),0x00(a6,a0.l)

	addq.w #4,a5
	addq.w #4,a0
	subq.l #1,d5
	bgt.s l099b0
	movea.l (a6),a5
	moveq #0x01,d1
	add.w 0x00(a6,a5.l),d1
	mulu 0x02(a6,a5.l),d1
	subq.b #2,d6
	blt.s l099dc
	beq.s l099d4
	add.l d1,d1
	bra.s l099dc

l099d4:	add.l d1,d1
	move.l d1,d0
	add.l d1,d1
	add.l d0,d1
l099dc:	move.l a3,-(a7)
	jsr l04df6(pc)
	movea.l (a7)+,a3
	move.l a0,d2
	sub.l 0x0028(a6),d2
	movea.l (a7)+,a2
	move.l d2,0x00(a6,a2.l)
l099f0:	clr.w 0x00(a6,a0.l)
	addq.w #2,a0
	subq.l #2,d1
	bgt.s l099f0
	moveq #0x00,d0
	rts

l099fe:	movea.l 0x0028(a6),a2
	adda.l d4,a2
	moveq #0x01,d2
	add.w 0x06(a6,a2.l),d2
	mulu 0x08(a6,a2.l),d2
	move.b d6,d1
	subq.b #2,d1
	blt.s l09a22
	beq.s l09a1a
	add.l d2,d2
	bra.s l09a22

l09a1a:	add.l d2,d2
	move.l d2,d1
	add.l d2,d2
	add.l d1,d2
l09a22:	move.l d2,d1
	movea.l 0x0028(a6),a0
	adda.l 0x00(a6,a2.l),a0
	move.l a3,-(a7)
	move.l a2,-(a7)
	jsr l04fe8(pc)
	movea.l (a7)+,a2
	bsr.s l09a3c
	movea.l (a7)+,a3
	rts

l09a3c:	moveq #0x00,d1
	move.w 0x04(a6,a2.l),d1
	lsl.l #2,d1
	addq.l #6,d1
	movea.l a2,a0
	jmp l04fe8(pc)

|* execute ELSE
l09a4c:	moveq #0x00,d4
l09a4e:	jsr l09b32(pc)
	bge.s l09a5a
	tst.b 0x006e(a6)
	bne.s l09aa4
l09a5a:	jsr l0a60e(pc)
	bne.s l09aa4
	jsr l0a56c(pc)
	cmpi.b #0x81,d0
	bne.s l09a4e
	addq.w #2,a4
	cmpi.b #0x03,d1
	bne.s l09a8c
	jsr l09852(pc)
	blt.s l09a88
	tst.b 0x006e(a6)
	bne.s l09a88
l09a7e:	jsr l09b32(pc)
	blt.s l09a5a
	addq.w #2,a4
	bra.s l09a7e

l09a88:	addq.w #1,d4
	bra.s l09a4e

l09a8c:	cmpi.b #0x01,d1
	bne.s l09a4e
	jsr l0a56c(pc)
	cmpi.w #0x8103,d1
	bne.s l09a4e
	tst.b d4
	beq.s l09aa4
	subq.w #1,d4
	bra.s l09a4e

l09aa4:	moveq #0x00,d0
	rts

|* exec END
l09aa8:	jsr l0a56c(pc)
	cmpi.w #0x8107,d1
	beq.w l096e6
	cmpi.w #0x8106,d1
	beq.s l09ae6
	moveq #0x06,d5
	cmpi.w #0x8104,d1
	beq.s l09aca
	moveq #0x07,d5
	cmpi.w #0x8102,d1
	bne.s l09b28
l09aca:	addq.w #2,a4
	jsr l0a09e(pc)
	bne.s l09b2a
	cmp.b d5,d1
	bne.s l09b2e
	move.w 0x0068(a6),0x08(a6,a2.l)
	move.b 0x006c(a6),0x0b(a6,a2.l)
	jmp l0a37a(pc)

l09ae6:	tst.b 0x00c0(a6)
	bne.w l07e50 | * LCONTINUE
l09aee:	move.w 0x0068(a6),d4
	moveq #-0x01,d3
	jsr l0acc2(pc)
	bne.s l09b28
l09afa:	move.w 0x08(a6,a2.l),d4
	seq 0x006f(a6)
	move.b 0x0a(a6,a2.l),-(a7)
	move.b 0x0b(a6,a2.l),0x006e(a6)
	move.w 0x0c(a6,a2.l),0x0070(a6)
	st 0x08(a6,a2.l)
	jsr l09fa2(pc)
	bne.s l09b2c
	jsr l0a96a(pc)
	bne.s l09b2c
	move.b (a7)+,d4
	jsr l0a00a(pc)
l09b28:	moveq #0x00,d0
l09b2a:	rts

l09b2c:	addq.w #2,a7
l09b2e:	moveq #-0x07,d0
	rts

l09b32:	moveq #0x00,d0
	move.w 0x00(a6,a4.l),d1
	cmpi.w #0x8402,d1
	beq.s l09b5c
	cmpi.w #0x840a,d1
	beq.s l09b5a
	moveq #0x01,d0
	cmpi.w #0x811c,d1
	beq.s l09b5c
	moveq #0x02,d0
	cmpi.w #0x8114,d1
	beq.s l09b5c
	jsr l09072(pc)
	bra.s l09b32

l09b5a:	moveq #-0x01,d0
l09b5c:	rts

l09b5e:	move.w 0x0068(a6),0x0092(a6)

	tst.b 0x006f(a6)
	beq.s l09b70
	move.w #-1,0x0092(a6)

l09b70:	move.b 0x006c(a6),0x0091(a6)
	move.b 0x006e(a6),0x009a(a6)
	move.w 0x0070(a6),0x0098(a6)
	move.l 0x003c(a6),d1
	sub.l 0x0038(a6),d1
	sne 0x0090(a6)
	rts

l09b90:	moveq #-1,d0
l09b92:	tst.b 0x00c0(a6)
	bne.s l09bb6
	bsr.s l09b5e
	bra.s l09bd4

l09b9c:	st 0x006f(a6) | * error handling
	cmpi.l #-21,d0
	beq.s l09b92
l09ba8:	cmpi.l #-1,d0
	beq.s l09b92
	tst.b 0x00c0(a6)
	beq.s l09bc0
l09bb6:	bsr.s l09bd4
	moveq #-26,d0
	jsr l03968(pc)
	bra.s l09c18

l09bc0:	bsr.s l09b5e
	move.w 0x0068(a6),0x00c6(a6)
	move.l d0,0x00c2(a6)
	bge.s l09c18
	move.w 0x00bc(a6),d4
	bne.s l09c1c
l09bd4:	movea.l 0x0030(a6),a0
	movea.l 0x00(a6,a0.l),a0
l09bdc:	move.w #-1,0x0088(a6)
	tst.b 0x006f(a6)
	bne.s l09c14
	move.l d0,-(a7)
	moveq #-0x16,d0
	jsr l03968(pc)
	movea.l a0,a5
	movea.w #0x0068,a1
	movea.l (a6),a0
	jsr l03e54(pc)
	move.b #0x20,0x00(a6,a0.l)
	addq.w #1,d1
	movea.l (a6),a1
	move.w d1,d2
	movea.l a5,a0
	moveq #0x07,d0
	moveq #-0x01,d3
	trap #0x04
	trap #0x03
	move.l (a7)+,d0
l09c14:	jsr l03968(pc)
l09c18:	moveq #-0x01,d0
	rts

l09c1c:	st 0x00c0(a6)
	move.l d0,-(a7)
	tst.b 0x006f(a6)
	beq.s l09c2e
	jsr l0958e(pc)
	bne.s l09c56
l09c2e:	jsr l09fa2(pc)
	jsr l0a966(pc)
	bne.s l09c56
	jsr l0a56c(pc)
	cmpi.w #0x8106,d1
	bne.s l09c56
	addq.w #4,a7
	move.b 0x00bf(a6),0x006e(a6)
	move.b 0x00be(a6),d4
	jsr l0a00a(pc)
	jmp l0a90c(pc)

l09c56:	clr.w 0x00bc(a6)
	sf 0x00c0(a6)
	move.l (a7)+,d0
	bra.w l09bd4

|* execute EXIT
l09c64:	jsr l0a09e(pc)
	bne.w l09cfc
	move.w 0x08(a6,a2.l),d4
	beq.s l09c88
	jsr l09fa2(pc)
	bne.s l09c86
	jsr l0a966(pc)
	bne.s l09c86
	move.b 0x0b(a6,a2.l),d4
	jsr l0a00a(pc)
l09c86:	bra.s l09cfa

l09c88:	move.w -0x02(a6,a4.l),d4
	moveq #0x07,d5
	sub.b d1,d5
l09c90:	jsr l09b32(pc)
	blt.s l09c9e
	addq.w #2,a4
	addq.b #1,0x006c(a6)
	bra.s l09cc0

l09c9e:	tst.b 0x006e(a6)
	beq.s l09cb2
	sf 0x006e(a6)
	move.w 0x0068(a6),d0
	cmp.w 0x06(a6,a2.l),d0
	beq.s l09cfa
l09cb2:	tst.b 0x006f(a6)
	bne.s l09cfa
	addq.w #2,a4
	jsr l0a966(pc)
	bne.s l09cfa
l09cc0:	jsr l0a56c(pc)
	cmpi.w #0x8101,d1
	bne.s l09c90
	addq.w #2,a4
	jsr l0a56c(pc)
	tst.b d5
	beq.s l09cdc
	cmpi.w #0x8104,d1
	bne.s l09c90
	bra.s l09ce2

l09cdc:	cmpi.w #0x8102,d1
	bne.s l09c90
l09ce2:	addq.w #2,a4
	jsr l0a56c(pc)
	cmp.w 0x02(a6,a4.l),d4
	bne.s l09c90
	move.w 0x0068(a6),0x08(a6,a2.l)

	move.b 0x006c(a6),0x0b(a6,a2.l)

l09cfa:	moveq #0x00,d0
l09cfc:	rts

l09cfe:	moveq #0x00,d5
l09d00:	bsr.s l09d46
	bne.s l09d56
	jsr l0a56c(pc)
	cmpi.b #0x81,d0
	bne.s l09d00
	addq.w #2,a4
	cmpi.b #0x01,d1
	bne.s l09d26
	jsr l0a56c(pc)
	cmpi.w #0x8105,d1
	bne.s l09d00
	subq.w #1,d5
	blt.s l09d56
	bra.s l09d00

l09d26:	cmpi.b #0x05,d1
	bne.s l09d00
	jsr l09852(pc)
	blt.s l09d38
	tst.b 0x006e(a6)
	beq.s l09d3c
l09d38:	addq.w #1,d5
	bra.s l09d00

l09d3c:	jsr l09b32(pc)
	blt.s l09d00
	addq.w #2,a4
	bra.s l09d3c

l09d46:	jsr l0a60e(pc)
	bne.s l09d64
	tst.b d0
	beq.s l09d56
	tst.b 0x006e(a6)
	bne.s l09d5a
l09d56:	moveq #0x00,d0
	rts

l09d5a:	subq.w #8,a4
	move.w 0x02(a6,a4.l),d0
	sub.w d0,0x006a(a6)
l09d64:	tst.b 0x006e(a6)
	bgt.s l09d6e
	sf 0x006e(a6)
l09d6e:	moveq #0x01,d0
	rts

l09d72:	moveq #0x00,d5
l09d74:	jsr l09d46(pc)
	bne.s l09dec
	jsr l0a56c(pc)
	cmpi.w #0x8401,d1
	bne.s l09d8c
	addq.w #2,a4
	tst.b d5
	beq.s l09dee
	bra.s l09d74

l09d8c:	cmpi.b #0x81,d0
	bne.s l09d74
	cmpi.b #0x15,d1
	bne.s l09db6
	tst.b d5
	bne.s l09d74
	jsr l09876(pc)
	blt.s l09d74
	movea.l a4,a3
l09da4:	subq.w #2,a3
	cmpi.w #0x8800,0x00(a6,a3.l)

	bne.s l09da4
	cmp.w 0x02(a6,a3.l),d4
	bne.s l09d74
	bra.s l09dee

l09db6:	cmpi.b #0x05,d1
	bne.s l09dd6
	jsr l09852(pc)
	blt.s l09dc8
	tst.b 0x006e(a6)
	beq.s l09dcc
l09dc8:	addq.w #1,d5
	bra.s l09d74

l09dcc:	jsr l09b32(pc)
	blt.s l09d74
	addq.w #2,a4
	bra.s l09dcc

l09dd6:	cmpi.b #0x01,d1
	bne.s l09d74
	addq.w #2,a4
	jsr l0a56c(pc)
	cmpi.w #0x8105,d1
	bne.s l09d74
	subq.w #1,d5
	bge.s l09d74
l09dec:	rts

l09dee:	moveq #0x00,d0
	rts

|* execute FOR
l09df2:	movea.l a4,a5
	jsr l0a56c(pc)
	moveq #0x00,d4
	move.w 0x02(a6,a4.l),d4
	addq.w #4,a4
	jsr l09852(pc)
	blt.s l09e10
	move.b #0x01,0x006e(a6)
	move.w d4,0x0070(a6)
l09e10:	jsr l09f96(pc)
	move.b 0x01(a6,a2.l),d2
	subq.b #2,d2
	bne.s l09e30
	move.b 0x00(a6,a2.l),d2
	moveq #0x06,d1
	subq.b #2,d2
	beq.s l09e34
	moveq #0x0c,d1
	subq.b #4,d2
	beq.s l09e34
	subq.b #1,d2
	beq.s l09e5c
l09e30:	moveq #-0x0c,d0
	rts

l09e34:	move.l a2,-(a7)
	move.l 0x04(a6,a2.l),d2
	blt.s l09e46
	movea.l 0x0028(a6),a0
	adda.l d2,a0
	jsr l04fe8(pc)
l09e46:	moveq #0x1a,d1
	jsr l04df6(pc)
	suba.l 0x0028(a6),a0
	movea.l (a7)+,a2
	move.b #0x07,0x00(a6,a2.l)
	move.l a0,0x04(a6,a2.l)
l09e5c:	jsr l0a2fe(pc)
	jsr l0a56c(pc)
	move.l a4,d0
	sub.l a5,d0
	move.l d7,0x0c(a6,a2.l)
	move.l d7,0x10(a6,a2.l)
	move.l d7,0x14(a6,a2.l)
	move.w d0,0x18(a6,a2.l)
	jsr l09e88(pc)
	bgt.s l09e80
	rts

l09e80:	moveq #0x00,d5
	jmp l09c90(pc)

l09e86:	.byte 0x01
l09e87:	.byte 0x40
l09e88:	move.l a4,-(a7)
	move.w 0x00(a6,a4.l),d1
	jsr l09686(pc)
	bne.s l09e98
	moveq #0x01,d0
	bra.s l09ea6

l09e98:	cmpi.w #0x8401,d1
	beq.s l09eaa
	cmpi.w #0x8404,d1
	beq.s l09eaa
	moveq #-0x04,d0
l09ea6:	addq.w #4,a7
	rts

l09eaa:	addq.w #2,a4
	movea.l a4,a0
	move.l d4,d6
	jsr l05a7e(pc)
	movea.l a0,a4
	bne.s l09ea6
	bsr.w l09f7e
	move.w 0x00(a6,a1.l),0x00(a6,a2.l)
	move.l 0x02(a6,a1.l),0x02(a6,a2.l)
	addq.l #6,0x0058(a6)
	cmpi.w #0x810b,0x00(a6,a4.l)
	beq.s l09ef4
	move.w 0x00(a6,a2.l),0x0c(a6,a2.l)
	move.l 0x02(a6,a2.l),0x0e(a6,a2.l)
	move.w d7,0x12(a6,a2.l)
	move.l d7,0x14(a6,a2.l)
	move.l a4,d0
	sub.l (a7)+,d0
	add.w d0,0x18(a6,a2.l)
	bra.w l09f76

l09ef4:	addq.w #2,a4
	movea.l a4,a0
	jsr l05a7e(pc)
	movea.l a0,a4
l09efe:	bne.s l09ea6
	bsr.s l09f7e
	move.w 0x00(a6,a1.l),0x0c(a6,a2.l)
	move.l 0x02(a6,a1.l),0x0e(a6,a2.l)
	addq.l #6,0x0058(a6)
	cmpi.w #0x811d,0x00(a6,a4.l)
	beq.s l09f32
	move.b #0x08,0x12(a6,a2.l)
	move.b l09e86(pc),0x13(a6,a2.l)
	move.l d7,0x14(a6,a2.l)
	move.b l09e87(pc),0x14(a6,a2.l)
	bra.s l09f50

l09f32:	addq.w #2,a4
	movea.l a4,a0
	jsr l05a7e(pc)
	movea.l a0,a4
	bne.s l09efe
	bsr.s l09f7e
	move.w 0x00(a6,a1.l),0x12(a6,a2.l)
	move.l 0x02(a6,a1.l),0x14(a6,a2.l)
	addq.l #6,0x0058(a6)
l09f50:	move.l a4,d0
	sub.l (a7)+,d0
	add.w d0,0x18(a6,a2.l)
	jsr l04e4c(pc)
	movea.l 0x0058(a6),a1
	subq.w #6,a1
	move.l 0x02(a6,a2.l),0x02(a6,a1.l)
	move.w 0x00(a6,a2.l),0x00(a6,a1.l)
	jsr l0a404(pc)
	bra.s l09f78

	bra.s l09f7a

l09f76:	moveq #0x00,d0
l09f78:	rts

l09f7a:	bra.w l09e88

l09f7e:	move.l d6,d4
l09f80:	bsr.s l09f96
	move.b 0x00(a6,a2.l),d1
	move.b 0x01(a6,a2.l),d2
	move.l 0x04(a6,a2.l),d0
	movea.l 0x0028(a6),a2
	adda.l d0,a2
	rts

l09f96:	move.l d4,d0
	movea.l 0x0018(a6),a2
	lsl.l #3,d0
	adda.w d0,a2
	rts

l09fa2:	tst.b 0x006f(a6)
	beq.s l09fae
	movea.l 0x0008(a6),a4
	bra.s l0a006

l09fae:	cmpi.w #0x840a,0x00(a6,a4.l)
	beq.s l09fbc
	jsr l09072(pc)
	bra.s l09fae

l09fbc:	addq.w #2,a4
l09fbe:	moveq #0x00,d1
	moveq #0x00,d2
	cmp.w 0x0068(a6),d4
	ble.s l09fec
l09fc8:	cmpa.l 0x0014(a6),a4
	blt.s l09fd2
	jmp l0a994(pc)

l09fd2:	cmp.w 0x04(a6,a4.l),d4
	ble.s l0a006
l09fd8:	move.w 0x04(a6,a4.l),d2
	move.w 0x00(a6,a4.l),d1
	addq.w #2,a4
	add.w d1,0x006a(a6)
	adda.w 0x006a(a6),a4
	bra.s l09fc8

l09fec:	suba.w 0x006a(a6),a4
	subq.w #2,a4
	move.w 0x00(a6,a4.l),d1
	sub.w d1,0x006a(a6)
	cmp.w 0x04(a6,a4.l),d4
	bgt.s l09fd8
	cmpa.l 0x0010(a6),a4
	bgt.s l09fec
l0a006:	moveq #0x00,d0
	rts

l0a00a:	cmp.b 0x006c(a6),d4
	ble.s l0a01e
	jsr l09b32(pc)
	blt.s l0a01e
	addq.w #2,a4
	addq.b #1,0x006c(a6)
	bra.s l0a00a

l0a01e:	moveq #0x00,d0
	rts

|* execute GO
l0a022:	moveq #0x01,d4
	bra.s l0a038

|* execute ON ...
l0a026:	jsr l09876(pc)
	bge.w l09cfe
	bsr.s l0a086
	move.w 0x00(a6,a1.l),d4
	ble.s l0a082
	addq.w #2,a4
l0a038:	jsr l0a56c(pc)
	cmpi.b #0x0b,d1
	seq d5
l0a042:	move.w 0x00(a6,a4.l),d1
	jsr l09686(pc)
	beq.s l0a082
	addq.w #2,a4
	bsr.s l0a086
	bgt.s l0a042
	subq.w #1,d4
	bne.s l0a042
	move.w 0x00(a6,a1.l),d4
	tst.b d5
	beq.w l094ca
	sf 0x006e(a6)
	tst.b 0x006f(a6)
	beq.s l0a078
	sf 0x006f(a6)
	movea.l 0x0010(a6),a4
	jsr l0a966(pc)
	bne.s l0a07e
l0a078:	jsr l09fa2(pc)
	subq.w #2,a4
l0a07e:	moveq #0x00,d0
	rts

l0a082:	moveq #-0x04,d0
	rts

l0a086:	movea.l a4,a0
	jsr l05a82(pc)
	movea.l a0,a4
	blt.s l0a09a
	bgt.s l0a098
	addq.l #2,0x0058(a6)
	moveq #0x00,d0
l0a098:	rts

l0a09a:	addq.w #4,a7
	rts

l0a09e:	jsr l0a56c(pc)
	moveq #0x00,d4
	move.w 0x02(a6,a4.l),d4
	addq.w #4,a4
l0a0aa:	jsr l09f80(pc)
	moveq #0x00,d0
	move.b d1,d0
	subq.b #6,d0
	beq.s l0a0bc
	subq.b #1,d0
	beq.s l0a0bc
	moveq #-0x07,d0
l0a0bc:	rts

|* execute IF
l0a0be:	movea.l a4,a0
	jsr l05a7e(pc)
	movea.l a0,a4
	bne.w l0a150
	jsr l09852(pc)
	blt.s l0a0da
	tst.b 0x006e(a6)
	bne.s l0a0da
	st 0x006e(a6)
l0a0da:	addq.l #6,0x0058(a6)
	tst.w 0x00(a6,a1.l)
	bne.s l0a14e
	moveq #0x00,d4
l0a0e6:	jsr l09b32(pc)
	bge.s l0a0f2
	tst.b 0x006e(a6)
	bne.s l0a14e
l0a0f2:	jsr l0a60e(pc)
	bne.s l0a14e
	jsr l0a56c(pc)
	cmpi.b #0x81,d0
	bne.s l0a0e6
	addq.w #2,a4
	cmpi.b #0x03,d1
	bne.s l0a124
	jsr l09852(pc)
	blt.s l0a120
	tst.b 0x006e(a6)
	bne.s l0a120
l0a116:	jsr l09b32(pc)
	blt.s l0a0f2
	addq.w #2,a4
	bra.s l0a116

l0a120:	addq.w #1,d4
	bra.s l0a0e6

l0a124:	cmpi.b #0x01,d1
	bne.s l0a13c
	jsr l0a56c(pc)
	cmpi.w #0x8103,d1
	bne.s l0a0e6
	tst.b d4
	beq.s l0a14e
	subq.w #1,d4
	bra.s l0a0e6

l0a13c:	cmpi.b #0x14,d1
	bne.s l0a0e6
	tst.b d4
	beq.s l0a14c
	addq.b #1,0x006c(a6)
	bra.s l0a0e6

l0a14c:	subq.w #2,a4
l0a14e:	moveq #0x00,d0
l0a150:	rts


|* LABELS RELATIV TO A190
|* USED TO EXECUTE DEPENDING INSTRUCTIONS 
.balign 2, 0 ; l0a152:	.word l09aa8-l0a190 | * END
.balign 2, 0 ; 	.word l09df2-l0a190 | * FOR
.balign 2, 0 ; 	.word l0a0be-l0a190 | * IF
.balign 2, 0 ; 	.word l0a7b6-l0a190 | * REPEAT
.balign 2, 0 ; 	.word l0a84a-l0a190 | * SELECT
.balign 2, 0 ; 	.word l0ac00-l0a190 | * WHEN
.balign 2, 0 ; 	.word l098a6-l0a190 | * DEFINE
.balign 2, 0 ; 	.word 0x0 | * PROCEDURE:USELESS IF ALONE
.balign 2, 0 ; 	.word 0x0 | * FUNCTION: USELESS IF ALONE
.balign 2, 0 ; 	.word l0a022-l0a190 | * GO
.balign 2, 0 ; 	.word 0x0 | * TO:USELESS IF ALONE
.balign 2, 0 ; 	.word 0x0 | * SUB: USELESS F ALONE
.balign 2, 0 ; 	.word 0x0 | * WHEN: USELESS IF ALONE
.balign 2, 0 ; 	.word 0x0 | * ERROR: USELESS IF ALONE
.balign 2, 0 ; 	.word 0x0 | * EOF
.balign 2, 0 ; 	.word 0x0 | * INPUT
.balign 2, 0 ; 	.word l0a820-l0a190 | * RESTORE
.balign 2, 0 ; 	.word l0a372-l0a190 | * NEXT
.balign 2, 0 ; 	.word l09c64-l0a190 | * EXIT
.balign 2, 0 ; 	.word l09a4c-l0a190 | * ELSE
.balign 2, 0 ; 	.word l0a026-l0a190 | * ON
.balign 2, 0 ; 	.word l096e6-l0a190 | * RETURN
.balign 2, 0 ; 	.word 0x0 | * REMAINDER
.balign 2, 0 ; 	.word l0a7b2-l0a190 | * DATA
.balign 2, 0 ; 	.word l098c6-l0a190 | * DIM
.balign 2, 0 ; 	.word l0a2fa-l0a190 | * LOCAL
.balign 2, 0 ; 	.word l0a332-l0a190 | * LET
.balign 2, 0 ; 	.word 0x0 | * THEN
.balign 2, 0 ; 	.word 0x0 | * STEP
.balign 2, 0 ; 	.word l0a7b2-l0a190 | * REMARK
.balign 2, 0 ; 	.word l0a2fa-l0a190 | * MISTAKE

l0a190:	moveq #0,d0
	move.b 0x01(a6,a4.l),d0
	addq.w #2,a4
	add.b d0,d0
	move.w l0a150(pc,d0.w),d0
	beq.s l0a1a4
	jmp l0a190(pc,d0.w)
l0a1a4:	moveq #-7,d0
	rts

l0a1a8:	move.l a2,a3
	andi.b #0x0f,0x01(a6,a3.l)
	move.l a3,-(a7)
	move.b 0x1(a6,a3.l),-(a7)
	jsr l07a8e(pc)
	bne.s l0a1e8
	cmpi.w #0x8405,d1
	bne.s l0a1f6
	cmpi.b #0x01,0x01(a6,a3.l)
	bne.s l0a242
	move.l 0x04(a6,a3.l),d0
	blt.s l0a242
	movea.l 0x0028(a6),a2
	adda.l d0,a2
	move.l d0,-(a7)
	lea 0x0002(a4),a0
	jsr l06446(pc)
	movea.l a0,a4
	movea.l 0x0028(a6),a2
	adda.l (a7)+,a2
l0a1e8:	bne.s l0a244
	jsr l0a56c(pc)
	cmpi.w #0x8401,d1
	bne.s l0a242
	sf (a7)
l0a1f6:	cmpi.w #0x8401,d1
	bne.s l0a242
	addq.w #2,a4
	move.b (a7),d0
	movea.l a4,a0
	suba.l 0x0028(a6),a2
	move.l a2,-(a7)
	jsr l05a84(pc)
	movea.l 0x0028(a6),a2
	adda.l (a7)+,a2
	movea.l a0,a4
	bne.s l0a23c
	move.b (a7)+,d0
	movea.l (a7)+,a3
	move.b d0,0x01(a6,a3.l)
	jsr l072c2(pc)
	bne.s l0a23a
	tst.w 0x00c8(a6)
	beq.s l0a23a
	move.b 0x00(a6,a3.l),d1
	subq.b #2,d1
	beq.s l0a248
	subq.b #4,d1
	beq.s l0a248
	subq.b #1,d1
	beq.s l0a248
l0a23a:	rts


l0a23c:	blt.s l0a244
	moveq #-0x11,d0
	bra.s l0a244

|* handling of MISTAKE and LOCAL
l0a242:	moveq #-0x0c,d0
l0a244:	addq.w #6,a7
	rts

|* initialise WHEN

l0a248:	move.l a3,d4
	sub.l 0x0018(a6),d4
	lsr.l #3,d4
	moveq #0x01,d3
	jsr l0acc2(pc)
l0a256:	bne.w l0a2da
	tst.w 0x08(a6,a2.l)
	blt.s l0a268
l0a260:	moveq #0x01,d3
	jsr l0acda(pc)
	bra.s l0a256

l0a268:	move.w 0x0068(a6),0x08(a6,a2.l)
	move.b 0x006c(a6),0x0a(a6,a2.l)
	move.b 0x006e(a6),0x0b(a6,a2.l)
	move.w 0x0070(a6),0x0c(a6,a2.l)
	move.w d4,-(a7)
	move.w d2,-(a7)
	move.l d1,-(a7)
	move.w 0x02(a6,a2.l),d4
	move.b 0x04(a6,a2.l),d1
	suba.l 0x0028(a6),a2
	move.l a2,-(a7)
	move.b d1,-(a7)
	tst.b 0x006f(a6)
	beq.s l0a2a0
	jsr l0958e(pc)
l0a2a0:	jsr l09fa2(pc)
	bne.s l0a2f2
	jsr l0a96a(pc)
	bne.s l0a2f2
	move.b (a7)+,d4
	jsr l0a00a(pc)
	jsr l0a56c(pc)
	lea 0x0002(a4),a0
	jsr l05a7e(pc)
	movea.l a0,a4
	movea.l (a7)+,a2
	bne.s l0a2f6
	adda.l 0x0028(a6),a2
	addq.l #6,0x0058(a6)
	tst.w 0x00(a6,a1.l)
	beq.s l0a2de
	addq.w #8,a7
	move.b 0x0e(a6,a2.l),0x006e(a6)

l0a2da:	moveq #0x00,d0
	rts

l0a2de:	move.l a2,-(a7)
	jsr l09afa(pc)
	movea.l (a7)+,a2
	bne.s l0a2f6
	move.l (a7)+,d1
	move.w (a7)+,d2
	move.w (a7)+,d4
	bra.w l0a260

l0a2f2:	moveq #-0x07,d0
	addq.w #6,a7
l0a2f6:	addq.w #8,a7
	rts

|* execute LOCAL and MISTAKE
l0a2fa:	moveq #-0x15,d0
	rts
|*---------- END INITIALISE WHEN

|* 'STODEBOU'
l0a2fe:	movea.l 0x04(a6,a2.l),a2
	adda.l 0x0028(a6),a2
	move.w d7,0x00(a6,a2.l)
	move.l d7,0x02(a6,a2.l)
	move.w 0x0068(a6),d1
	move.b 0x006c(a6),d0
	cmp.w 0x06(a6,a2.l),d1
	bne.s l0a322
	cmp.b 0x0a(a6,a2.l),d0
	beq.s l0a32e
l0a322:	move.w d1,0x06(a6,a2.l)
	move.l d7,0x08(a6,a2.l)
	move.b d0,0x0a(a6,a2.l)
l0a32e:	moveq #0x00,d0
	rts

|* handling of LET

l0a332:	jsr l0a56c(pc)
	cmpi.b #0x88,d0
	bne.s l0a36e
l0a33c:	moveq #0x00,d4
	move.w 0x02(a6,a4.l),d4
	addq.w #4,a4
	jsr l0a56c(pc)
	jsr l09f96(pc)
	move.b 0x00(a6,a2.l),d0
	cmpi.b #0x03,d0
	beq.w l093e6
	cmpi.b #0x08,d0
	beq.w l0a6f6
	moveq #0x01,d5
	cmpi.b #0x04,d0
	beq.w l094ca
	jmp l0a1a8(pc)

l0a36e:	moveq #-0x13,d0
	rts
|*-------- end of LET

|*-------- NEXT
l0a372:	jsr l0a09e(pc)
	blt.w l0a402
l0a37a:	move.l d4,d6
	cmpi.b #0x06,d1
	beq.s l0a3d4
	move.l a2,-(a7)
	jsr l04e4c(pc)
	movea.l (a7),a2
	movea.l 0x0058(a6),a1
	suba.w #0x000c,a1
	move.l 0x14(a6,a2.l),0x02(a6,a1.l)
	beq.s l0a3de
	move.w 0x12(a6,a2.l),0x00(a6,a1.l)
	move.w 0x00(a6,a2.l),0x06(a6,a1.l)
	move.l 0x02(a6,a2.l),0x08(a6,a1.l)
	jsr l04838(pc)
	blt.s l0a3d6
	move.l a1,0x0058(a6)
	jsr l04a4a(pc)
	movea.l (a7),a2
	bsr.s l0a404 | * test for end of function
	bra.s l0a3d6 | * error
	bra.s l0a3da | * end of loop

|* back to start of loop
	movea.l (a7)+,a2
	move.w 0x00(a6,a0.l),0x00(a6,a2.l)
	move.l 0x02(a6,a0.l),0x02(a6,a2.l)
	addq.l #6,0x0058(a6)
l0a3d4:	bra.s l0a3e4

l0a3d6:	addq.w #4,a7
	rts

|*-- end of loop
l0a3da:	addq.l #6,0x0058(a6)
l0a3de:	movea.l (a7)+,a2
	moveq #0x01,d3
	bra.s l0a3e6

l0a3e4:	moveq #0x00,d3
l0a3e6:	bsr.s l0a44c
	bne.s l0a402
	tst.b 0x006e(a6)
	bgt.s l0a3f4
	sf 0x006e(a6)
l0a3f4:	cmpi.b #0x7f,0x006c(a6)
	bne.s l0a400
	sf 0x006e(a6)
l0a400:	moveq #0x00,d0
l0a402:	rts

|* test start and end of a loop

l0a404:	move.l a2,-(a7)
	subq.w #6,a1
	move.l 0x0e(a6,a2.l),0x02(a6,a1.l)
	move.w 0x0c(a6,a2.l),0x00(a6,a1.l)
	jsr l0482a(pc)
	movea.l (a7)+,a2
	blt.s l0a44a
	moveq #0x0d,d1
	add.w 0x00(a6,a1.l),d1
	cmp.w 0x12(a6,a2.l),d1
	bgt.s l0a42e
	lea 0x000c(a2),a0
	bra.s l0a446

l0a42e:	movea.l 0x0058(a6),a0
	tst.b 0x02(a6,a1.l)
	blt.s l0a440
	tst.b 0x14(a6,a2.l)
	blt.s l0a446
	bra.s l0a448

l0a440:	tst.b 0x14(a6,a2.l)
	blt.s l0a448
l0a446:	addq.l #2,(a7)
l0a448:	addq.l #2,(a7)
l0a44a:	rts

|* ---- positon pointer to code after loop

l0a44c:	move.b 0x006c(a6),-(a7)
	move.l 0x0068(a6),-(a7)
	move.l a4,-(a7)
	move.w 0x06(a6,a2.l),d4
	jsr l09fa2(pc)
	bne.s l0a4aa
	jsr l0a96a(pc)
	bne.s l0a4aa
	move.b 0x0a(a6,a2.l),d4
	jsr l0a00a(pc)
	jsr l0a56c(pc)
	cmpi.w #0x8102,d1
	beq.s l0a47e
	cmpi.w #0x8104,d1
	bne.s l0a4aa
l0a47e:	addq.w #2,a4
	movea.l a4,a5
	jsr l0a56c(pc)
	cmp.w 0x02(a6,a4.l),d6
	bne.s l0a4aa
	tst.b d3
	beq.s l0a4a4
	movea.l a5,a4
	adda.w 0x18(a6,a2.l),a4
	move.l d6,d4
	jsr l09e88(pc)
	blt.s l0a4ac
	beq.s l0a4a4
	moveq #0x00,d0
	bra.s l0a4ac

l0a4a4:	adda.w #0x000a,a7
	rts

l0a4aa:	moveq #-0x07,d0
l0a4ac:	movea.l (a7)+,a4
	move.l (a7)+,0x0068(a6)
	move.b (a7)+,0x006c(a6)
	tst.l d0
	rts

|*--- initialise all variables tables procs and funcs of prog or line
l0a4ba:	move.l a4,-(a7)
	move.b 0x006f(a6),d6
	beq.s l0a4cc
	movea.l 0x0008(a6),a4
	moveq #0x00,d5
	bra.s l0a4ee

l0a4ca:	sf d6
l0a4cc:	tst.b 0x008e(a6)
	sf 0x008e(a6)
	beq.s l0a4ea
	movea.l 0x0010(a6),a4
l0a4da:	tst.b d6
	bne.s l0a4ca
	move.w 0x04(a6,a4.l),d5
	addq.w #6,a4
	cmpa.l 0x0014(a6),a4
	blt.s l0a4ee
l0a4ea:	movea.l (a7)+,a4
	rts

l0a4ee:	bsr.s l0a56c | * omit spaces
	cmpi.b #0x88,d0
	beq.s l0a526
	cmpi.b #0x81,d0
	bne.s l0a55c
	addq.w #2,a4
	cmpi.b #0x14,d1
	beq.s l0a4ee
	cmpi.b #0x02,d1
	bne.s l0a50e
	bsr.s l0a56c
	bra.s l0a534

l0a50e:	cmpi.b #0x04,d1
	bne.s l0a51e
	bsr.s l0a56c
	cmpi.b #0x88,d0
	bne.s l0a55c
	bra.s l0a534

l0a51e:	cmpi.b #0x1b,d1
	bne.s l0a53a
	bsr.s l0a56c
l0a526:	move.l a4,d4
	addq.w #4,a4
	bsr.s l0a56c
	cmpi.w #0x8401,d1
	bne.s l0a55c
	movea.l d4,a4
l0a534:	moveq #0x02,d1
l0a536:	bsr.s l0a57e
	bra.s l0a55c

l0a53a:	cmpi.b #0x07,d1
	bne.s l0a554
	bsr.s l0a56c
	move.w d1,d4
	addq.w #2,a4
	bsr.s l0a56c
	moveq #0x04,d1
	cmpi.b #0x08,d4
	beq.s l0a536
	moveq #0x05,d1
	bra.s l0a536

l0a554:	cmpi.b #0x19,d1
	bne.s l0a55c
	bsr.s l0a5ce
l0a55c:	jsr l09b32(pc)
	bge.s l0a568
	addq.w #2,a4
	bra.w l0a4da

l0a568:	addq.w #2,a4
	bra.s l0a4ee

l0a56c:	move.w 0x00(a6,a4.l),d1
	move.b 0x00(a6,a4.l),d0
	cmpi.b #0x80,d0
	bne.s l0a5cc
	jmp l09072(pc)

l0a57e:	moveq #0x00,d0
	move.w 0x02(a6,a4.l),d0
	lsl.l #3,d0
	movea.l 0x0018(a6),a0
	adda.l d0,a0
	move.b 0x00(a6,a0.l),d0
	cmp.b d0,d1
	beq.s l0a5bc
	subq.b #2,d0
	blt.s l0a5bc
	beq.s l0a5ac
	subq.b #1,d0
	beq.s l0a5cc
	subq.b #2,d0
	ble.s l0a5a6
	subq.b #3,d0
	blt.s l0a5ac
l0a5a6:	cmpi.b #0x04,d1
	bge.s l0a5bc
l0a5ac:	movea.l a0,a2
	movem.l d1/a0,-(a7)
	jsr l05784(pc)
	movem.l (a7)+,d1/a0
	bne.s l0a5cc
l0a5bc:	move.b d1,0x00(a6,a0.l)
	subq.b #4,d1
	beq.s l0a5c8
	subq.b #1,d1
	bne.s l0a5cc
l0a5c8:	move.w d5,0x04(a6,a0.l)
l0a5cc:	rts

|* initialise variable in name-table

l0a5ce:	moveq #0x00,d3
	subq.w #2,a4
l0a5d2:	move.w #0x8800,d4
	bsr.s l0a5e0
	bne.s l0a60c
	moveq #0x03,d1
	bsr.s l0a57e
	bra.s l0a5d2

|* look for first variable without parenthesis

l0a5e0:	moveq #0x00,d3
l0a5e2:	jsr l09072(pc)
	cmp.w d4,d1
	bne.s l0a5f0
	tst.b d3
l0a5ed:	beq.s l0a60c
	bra.s l0a5e2

l0a5f0:	cmpi.w #0x8405,d1
	bne.s l0a5fa
	addq.b #1,d3
	bra.s l0a5e2

l0a5fa:	cmpi.w #0x8406,d1
	bne.s l0a604
	subq.b #1,d3
	bra.s l0a5e2

l0a604:	jsr l09686(pc)
	bne.s l0a5e2
	moveq #0x01,d1
l0a60c:	rts

|* point to next instruction in line

l0a60e:	jsr l09b32(pc)
	bge.s l0a640
	tst.b 0x006f(a6)
	bne.s l0a63e
	addq.w #2,a4
	cmpa.l 0x0014(a6),a4
	blt.s l0a626
	jmp l0a994(pc)

l0a626:	move.w 0x00(a6,a4.l),d0
	add.w d0,0x006a(a6)
	move.w 0x04(a6,a4.l),0x0068(a6)
	moveq #0x01,d0
	move.b d0,0x006c(a6)
	addq.w #6,a4
	moveq #0x00,d1
l0a63e:	rts

l0a640:	addq.w #2,a4
	addq.b #1,0x006c(a6)
	moveq #0x00,d0
	rts

|* point according to value of SELECT

l0a64a:	jsr l0a56c(pc)
	cmpi.w #0x8117,d1
	beq.s l0a6ce
	bsr.s l0a68c
	cmpi.w #0x810b,0x00(a6,a4.l)
	beq.s l0a672
	bsr.s l0a6d6
	move.w 0x00(a6,a1.l),d0
	beq.s l0a6ca
	addi.w #0x0018,d0
	sub.w -0x06(a6,a1.l),d0
	ble.s l0a6ca
	bra.s l0a6a6

l0a672:	bsr.s l0a6d6
	tst.b 0x02(a6,a1.l)
	bgt.s l0a6a6
	addq.w #2,a4
	addq.l #6,0x0058(a6)
	bsr.s l0a68c
	bsr.s l0a6d6
	tst.b 0x02(a6,a1.l)
	blt.s l0a6a6
	bra.s l0a6ca

l0a68c:	movea.l a4,a0
	suba.l 0x0028(a6),a2
	move.l a2,-(a7)
	jsr l05a7e(pc)
	movea.l 0x0028(a6),a2
	adda.l (a7)+,a2
	movea.l a0,a4
	beq.s l0a6d4
	addq.w #4,a7
	rts

l0a6a6:	addq.l #6,0x0058(a6)
l0a6aa:	move.w 0x00(a6,a4.l),d0
	cmpi.w #0x8404,d0
	bne.s l0a6b8
	addq.w #2,a4
	bra.s l0a64a

l0a6b8:	cmpi.w #0x840a,d0
	beq.s l0a6d2
	cmpi.w #0x8402,d0
	beq.s l0a6d2
	jsr l09072(pc)
	bra.s l0a6aa

l0a6ca:	addq.l #6,0x0058(a6)
l0a6ce:	moveq #0x00,d0
	rts

l0a6d2:	moveq #-0x01,d0
l0a6d4:	rts

l0a6d6:	subq.w #6,a1
	move.l 0x02(a6,a2.l),0x02(a6,a1.l)
	move.w 0x00(a6,a2.l),0x00(a6,a1.l)
	jsr l0482a(pc)
	beq.s l0a6ec
	addq.w #4,a7
l0a6ec:	rts

|* execute Basic instruction

l0a6ee:	movea.l 0x00b0(a6),a4
	movea.l 0x00b4(a6),a2
l0a6f6:	sf 0x00b8(a6)
	move.l a4,0x00b0(a6)
	move.l a2,0x00b4(a6)
	move.l 0x04(a6,a2.l),d4
	movea.l a4,a0
	move.l 0x001c(a6),d0
	sub.l 0x0018(a6),d0
	move.l d0,-(a7)
	jsr l0614a(pc)
	bne.s l0a724
	move.w 0x00(a6,a0.l),d1
	jsr l09686(pc)
	beq.s l0a732
	moveq #-0x0f,d0
l0a724:	move.l 0x0018(a6),d1
	add.l (a7)+,d1
	move.l d1,0x001c(a6)
	tst.l d0
	rts

l0a732:	move.l a5,d0
	sub.l 0x0018(a6),d0
	move.l d0,-(a7)
	movea.l a0,a4
	movea.l 0x0018(a6),a3
	adda.l 0x0004(a7),a3
	movea.l d4,a2
	movea.l 0x0058(a6),a1
	suba.l 0x005c(a6),a1
	suba.l 0x0008(a6),a4
	movem.l d5-d7/a1/a4,-(a7)
	move.l 0x0068(a6),-(a7)
	move.b 0x006c(a6),-(a7)
	move.l 0x006e(a6),-(a7)
	jsr (a2)
	move.l d0,d2
	move.l (a7)+,0x006e(a6)
	move.b (a7)+,0x006c(a6)
	move.l (a7)+,0x0068(a6)
	movem.l (a7)+,d5-d7/a1/a4
	adda.l 0x0008(a6),a4
	adda.l 0x005c(a6),a1
	move.l a1,0x0058(a6)
	movea.l 0x0018(a6),a5
	movea.l a5,a3
	adda.l (a7)+,a5
	adda.l (a7)+,a3
	jsr l05702(pc)
	move.l d2,d0
	tst.b 0x00b8(a6)
	bne.w l097e0
	rts

l0a79c:	move.b #0x7f,0x006c(a6)
	moveq #0x00,d4
	move.w 0x0070(a6),d4
	jsr l0a0aa(pc)
	bge.w l0a37a
	rts

|* execute DATA and REMark lines
l0a7b2:	moveq #0x00,d0
	rts

|* execute a conditioned repeat 
l0a7b6:	jsr l0a56c(pc)
	cmpi.b #0x88,d0
	bne.s l0a7f0
	moveq #0x00,d4
	move.w 0x02(a6,a4.l),d4
	addq.w #4,a4
	jsr l09852(pc)
	blt.s l0a7d8
	move.b #0x01,0x006e(a6)
	move.w d4,0x0070(a6)
l0a7d8:	jsr l09f96(pc)
	move.b 0x00(a6,a2.l),d2
	moveq #0x06,d1
	subq.b #2,d2
	beq.s l0a7f4
	subq.b #4,d2
	beq.s l0a81c
	moveq #0x1a,d1
	subq.b #1,d2
	beq.s l0a7f4
l0a7f0:	moveq #-0x0c,d0
	rts

|* initialise conditions of repeat-loop

l0a7f4:	move.l a2,-(a7)
	move.l 0x04(a6,a2.l),d2
	blt.s l0a806
	movea.l 0x0028(a6),a0
	adda.l d2,a0
	jsr l04fe8(pc)
l0a806:	moveq #0x0c,d1
	jsr l04df6(pc)
	suba.l 0x0028(a6),a0
	movea.l (a7)+,a2
	move.l a0,0x04(a6,a2.l)
	move.b #0x06,0x00(a6,a2.l)
l0a81c:	jmp l0a2fe(pc)

|* Execute RESTore
l0a820:	clr.w 0x0094(a6)
	movea.l a4,a0
	jsr l05a82(pc)
	movea.l a0,a4
	blt.s l0a848
	bgt.s l0a83a
	addq.l #2,0x0058(a6)
	move.w 0x00(a6,a1.l),0x0094(a6)
l0a83a:	move.b #0x01,0x0096(a6)
	move.b #0x01,0x0097(a6)
	moveq #0x00,d0
l0a848:	rts

|* Execute conditons for SELECT
l0a84a:	jsr l0a56c(pc)
	cmpi.w #0x8115,d1
	bne.s l0a85a
	addq.w #2,a4
	jsr l0a56c(pc)
l0a85a:	moveq #0x00,d4
	move.w 0x02(a6,a4.l),d4
	addq.w #4,a4
	jsr l09f80(pc)
	subq.b #2,d2
	bne.s l0a8a0
	tst.l d0
	blt.s l0a89c
	jsr l09852(pc)
	blt.s l0a88c
	tst.b 0x006e(a6)
	bne.s l0a87e
	st 0x006e(a6)
l0a87e:	jsr l0a56c(pc)
	cmpi.w #0x8401,d1
	bne.s l0a88c
	addq.w #2,a4
	bra.s l0a892

l0a88c:	jsr l09d72(pc)
	bne.s l0a898
l0a892:	jsr l0a64a(pc)
	blt.s l0a88c
l0a898:	moveq #0x00,d0
	rts

l0a89c:	moveq #-0x11,d0
	rts

l0a8a0:	moveq #-0x0c,d0
	rts

|* supervisor of direct or progr lines

l0a8a4:	movea.l 0x0010(a6),a4
l0a8a8:	sf 0x006e(a6)
	tst.b 0x006f(a6)
	bne.s l0a8b8
l0a8b2:	bsr.w l0a966
	bne.s l0a8f8
l0a8b8:	moveq #0x01,d0
	jsr l04e32(pc)
	moveq #0x00,d0
l0a8c0:	jsr l0a56c(pc)
	cmpi.b #0x81,d0
	bne.s l0a8d0
	jsr l0a190(pc)
	bra.s l0a8ea

l0a8d0:	cmpi.b #0x88,d0
	bne.s l0a8dc
	jsr l0a33c(pc)
	bra.s l0a8ea

l0a8dc:	cmpi.b #0x84,d0
	bne.s l0a8e8
	jsr l0abf0(pc)
	bra.s l0a8ea

|* test for errors and Break

l0a8e8:	moveq #-0x13,d0
l0a8ea:	tst.l d0
	bne.w l09ba8
	tas 0x008f(a6)
	beq.w l09b90
l0a8f8:	tas 0x006d(a6)
	beq.w l0a9ba
	tst.b 0x006f(a6)
	bne.s l0a90c
	cmpa.l 0x0010(a6),a4
	ble.s l0a8a4
l0a90c:	jsr l09b32(pc)
	bge.s l0a95c
	tst.b 0x006e(a6)
	beq.s l0a94e
	blt.s l0a924
	jsr l0a79c(pc)
	tst.b 0x006e(a6)
	bne.s l0a8ea
l0a924:	tst.b 0x00c0(a6) | * WHEN ERROR ?
	beq.s l0a93c
	tst.b 0x00bf(a6)
	beq.s l0a94e
	jsr l07e50(pc)
	st 0x006d(a6)
	jmp l0a9ba(pc)

l0a93c:	move.w 0x0068(a6),d4
	moveq #-0x01,d3
	jsr l0acc2(pc)
	bne.s l0a94e
	jsr l09aee(pc)
	bra.s l0a90c

|* test for return after lineend
l0a94e:	tst.b 0x006f(a6)
	addq.w #2,a4
	beq.w l0a8b2
	bsr.s l0a998
	bra.s l0a990

l0a95c:	addq.w #2,a4
	addq.b #1,0x006c(a6)
	bra.w l0a8b8

|* point to first instruction in line

l0a966:	sf 0x006e(a6)
l0a96a:	clr.w 0x0068(a6)
	tst.b 0x006f(a6)
	bne.s l0a98a
	cmpa.l 0x0014(a6),a4
	bge.s l0a994
	move.w 0x00(a6,a4.l),d0
	add.w d0,0x006a(a6)
	move.w 0x04(a6,a4.l),0x0068(a6)
	addq.w #6,a4
l0a98a:	move.b #0x01,0x006c(a6)
l0a990:	moveq #0x00,d0
	rts

|* Set flags after end of prog

l0a994:	sf 0x006d(a6)
l0a998:	move.w #-1,0x0088(a6)
	move.w #0x0004,0x008c(a6)
	rts


|* execute system commands    JM 9F7E
|* Labels relativ to L0A9BA
|* NOTE: ALL following commands have been rewritten
|* by Tony Tebby - if you use TOOLKIT II you can easily
|* omit all the code that is following

.balign 2, 0 ; l0a9a6:	.word xl0a9f2-l0a9ba | CLEAR
.balign 2, 0 ; 	.word xl0aadc-l0a9ba | NEW
.balign 2, 0 ; 	.word xl0abca-l0a9ba | STOP
.balign 2, 0 ; 	.word xl0aa5e-l0a9ba | RUN
.balign 2, 0 ; 	.word xl0aadc-l0a9ba | LRUN
.balign 2, 0 ; 	.word xl0aadc-l0a9ba | LOAD
.balign 2, 0 ; 	.word xl0abdc-l0a9ba | MRUN
.balign 2, 0 ; 	.word xl0abdc-l0a9ba | MERGE
.balign 2, 0 ; 	.word xl0aba6-l0a9ba | CONNTINUE-RETRY
.balign 2, 0 ; 	.word l0a9c6-l0a9ba | ERROR-RETURN

l0a9ba:	move.w 0x008c(a6),d1
	move.w l0a9a6(pc,d1.w),d1
	jmp l0a9ba(pc,d1.w)

|* restor system and error-return

l0a9c6:	jsr l09ba8(pc)
	movea.l 0x003c(a6),a0
	sf 0x00aa(a6)
l0a9d2:	cmpa.l 0x0038(a6),a0
	ble.s l0a9fc
	move.b -0x08(a6,a0.l),d0
	beq.s l0a9ee
	move.l -0x18(a6,a0.l),d0
	add.l 0x0018(a6),d0
	move.l d0,0x001c(a6)
	suba.w #0x0010,a0
l0a9ee:	subq.w #8,a0
	bra.s l0a9d2

|*system command Clear

sysclear:

l0a9f2:	tst.b 0x0090(a6)
.equ xl0a9f2, l0a9f2
	beq.s l0a9fc
	jsr l097e0(pc)
l0a9fc:	bsr.w l0aa88
	jsr l056c6(pc)
	movea.l 0x0018(a6),a0
l0aa08:	move.b 0x00(a6,a0.l),d0
	subq.b #1,d0
	beq.s l0aa4a
	subq.b #3,d0
	blt.s l0aa1c
	subq.b #2,d0
	blt.s l0aa52
	subq.b #2,d0
	bge.s l0aa52
l0aa1c:	move.w 0x02(a6,a0.l),d0
	blt.s l0aa4a
	bsr.w l0aacc
	move.b -0x01(a6,a1.l),d0
	moveq #0x01,d1
	subi.b #0x25,d0
	blt.s l0aa38
	bgt.s l0aa36
	addq.w #1,d1
l0aa36:	addq.w #1,d1
l0aa38:	move.b d1,0x01(a6,a0.l)
	move.b d7,0x00(a6,a0.l)
	move.l #-1,0x04(a6,a0.l)
	bra.s l0aa52

l0aa4a:	move.l d7,0x00(a6,a0.l)
	move.l d7,0x04(a6,a0.l)
l0aa52:	addq.w #8,a0
	cmpa.l 0x001c(a6),a0
	blt.s l0aa08
	st 0x008e(a6)

|* execute RUN

l0aa5e:
.equ xl0aa5e, l0aa5e
	tst.b 0x0090(a6)
	beq.s l0aa80
	move.w 0x0088(a6),0x00b4(a6)
	move.w 0x008c(a6),0x00b6(a6)
	jsr l097e0(pc)
	move.w 0x00b4(a6),0x0088(a6)
	move.w 0x00b6(a6),0x008c(a6)
l0aa80:	jsr l0a4ba(pc)
	bra.w l0abe6

|* clear stacks and storage-places

l0aa88:	moveq #0x00,d7
	move.l d7,0x0094(a6)
	move.b #0x01,0x0097(a6)
	move.l 0x0028(a6),0x002c(a6)
	move.l #-1,0x00ca(a6)
	move.w d7,0x00c8(a6)
	move.l 0x0038(a6),0x003c(a6)
	moveq #0x58,d0
l0aaae:	move.l 0x005c(a6),0x00(a6,d0.w)
	subq.w #4,d0
	cmpi.b #0x48,d0
	bge.s l0aaae
	sf 0x0090(a6)
	move.l d7,0x0072(a6)
	jsr l04f9e(pc)
	jmp l04f96(pc)

|* point to end of namelist

l0aacc:	movea.l 0x0020(a6),a1
	adda.w d0,a1
	moveq #0x01,d0
	add.b 0x00(a6,a1.l),d0
	adda.w d0,a1
	rts

sysload:
syslrun:
sysnew:

l0aadc:
.equ xl0aadc, l0aadc

	movea.l 0x0034(a6),a3
	movea.l 0x0030(a6),a2
	adda.w #0x0078,a2
	move.l a2,0x0034(a6)
l0aaec:	cmpa.l a3,a2
	bge.s l0ab02
	move.l 0x00(a6,a2.l),d0
	blt.s l0aafc
	movea.l d0,a0
	moveq #0x02,d0
	trap #0x02
l0aafc:	adda.w #0x0028,a2
	bra.s l0aaec

l0ab02:	moveq #0x10,d0
	moveq #-0x01,d1
	moveq #-0x01,d2
	trap #0x01
	moveq #0x10,d0
	trap #0x01
	move.l 0x0040(a6),0x0044(a6)
	clr.w 0x009e(a6)
	bsr.w l0aa88
	move.l 0x0010(a6),0x0014(a6)
	moveq #0x00,d0
	moveq #0x00,d5
	movea.l 0x0018(a6),a0
	moveq #0x08,d1
l0ab2c:	cmpa.l 0x001c(a6),a0
	beq.s l0ab84
	cmp.b 0x00(a6,a0.l),d1
	bgt.s l0ab42
	tst.b d5
	bne.s l0ab50
	move.w 0x02(a6,a0.l),d0
	bra.s l0ab80

l0ab42:	tst.b d5
	bne.s l0ab80
	movea.l a0,a2
	bsr.s l0aacc
	movea.l a1,a3
	st d5
	bra.s l0ab80

l0ab50:	move.l 0x00(a6,a0.l),0x00(a6,a2.l)
	move.l 0x04(a6,a0.l),0x04(a6,a2.l)
	move.w 0x02(a6,a2.l),d0
	bsr.w l0aacc
	suba.w d0,a1
	move.l a3,d2
	sub.l 0x0020(a6),d2
	move.w d2,0x02(a6,a2.l)
	addq.w #8,a2
l0ab72:	move.b 0x00(a6,a1.l),0x00(a6,a3.l)
	addq.w #1,a1
	addq.w #1,a3
	subq.w #1,d0
	bgt.s l0ab72
l0ab80:	addq.w #8,a0
	bra.s l0ab2c

l0ab84:	tst.b d5
	beq.s l0ab90
	move.l a2,0x001c(a6)
	move.l a3,0x0024(a6)
l0ab90:	jsr l04f9a(pc)
	jsr l04f8e(pc)
	jsr l04f92(pc)
	jsr l04f8a(pc)
	jsr l056c6(pc)
	bra.s l0abc4


|* execute RETRY or CONTINUE

l0aba6:	move.w 0x0092(a6),0x0088(a6)
	move.b 0x0091(a6),0x008a(a6)
	move.w #-1,0x0092(a6)
	move.b 0x009a(a6),0x006e(a6)
	move.w 0x0098(a6),0x0070(a6)
l0abc4:	sf 0x8b(a6)
	bra.s l0abec
.equ xl0aba6, l0aba6

|* execute STOP

l0abca:
.equ xl0abca, l0abca

	tst.b 0x00c0(a6)
	sf 0x00c0(a6)
	bne.s l0abe6
	moveq #0x00,d0
	jsr l09b5e(pc)
	bra.s l0abec

|* execute MRUN or MERGE

l0abdc:	tst.b 0x0090(a6)
	beq.s l0abe6
	jsr l097e0(pc)
l0abe6:	move.b 0x006f(a6),0x008b(a6)
l0abec:	moveq #0x00,d0
	rts
.equ xl0abdc, l0abdc

|* handling of lines starting with =

l0abf0:	cmpi.w #0x8401,d1
	bne.s l0abfc
	addq.w #2,a4
	jmp l09cfe(pc) | * search end of SELECT

l0abfc:	moveq #0x00,d0
	rts

|* execute WHEN
l0ac00:	jsr l0a56c(pc)
	cmpi.w #0x810e,d1
	bne.s l0ac32
	move.w 0x0068(a6),0x00bc(a6)
	move.b 0x006c(a6),0x00be(a6)
	jsr l09852(pc)
	seq 0x00bf(a6)
	beq.s l0ac28
	moveq #0x06,d2
	jmp l098a8(pc)

l0ac26:	addq.w #2,a4
l0ac28:	jsr l09b32(pc)
	bge.s l0ac26
l0ac2e:	moveq #0x00,d0
	rts

|* WHENvar

l0ac32:	move.w 0x02(a6,a4.l),d4
	addq.w #4,a4
	jsr l0a56c(pc)
	cmpi.b #0x85,d0
	beq.s l0ac54
l0ac42:	moveq #0x01,d3
	jsr l0acc2(pc)
	bne.s l0ac2e
	st 0x00(a6,a2.l)
	subq.w #1,0x00c8(a6)
	bra.s l0ac42

l0ac54:	moveq #0x01,d3
	jsr l0acc2(pc)
l0ac5a:	bne.s l0ac6c
	move.w 0x0068(a6),d0
	cmp.w 0x02(a6,a2.l),d0
	beq.s l0ac76
	jsr l0acda(pc)
	bra.s l0ac5a

l0ac6c:	moveq #0x00,d3
	jsr l0acc2(pc)
	addq.w #1,0x00c8(a6)
l0ac76:	move.w d4,0x00(a6,a2.l)
	move.w 0x0068(a6),0x02(a6,a2.l)
	move.b 0x006c(a6),0x04(a6,a2.l)
	move.w 0x0068(a6),0x06(a6,a2.l)
	move.b #0x7f,0x05(a6,a2.l)
	clr.l 0x0a(a6,a2.l)
	st 0x08(a6,a2.l)
	move.l a2,-(a7)
	jsr l09852(pc)
	movea.l (a7)+,a2
	seq 0x0e(a6,a2.l)
	beq.s l0ac28
	moveq #0x06,d2
	move.l a2,-(a7)
	jsr l098a8(pc)
	move.l (a7)+,d2
	move.w 0x0068(a6),0x06(a6,a2.l)
	move.b 0x006c(a6),0x05(a6,a2.l)
	bra.w l0ac2e

l0acc2:	move.w 0x00c8(a6),d2
	beq.s l0ad06
	bsr.s l0ad10
l0acca:	move.w 0x00(a6,a2.l),d0
	blt.s l0acec
	tst.b d3
	blt.s l0acf2
	beq.s l0acde
	cmp.w d0,d4
	beq.s l0acfe
l0acda:	subq.w #1,d2
	beq.s l0ad02
l0acde:	adda.w #0x0010,a2
	subi.l #0x0010,d1
	bge.s l0acca
	bra.s l0ad26

l0acec:	tst.b d3
	bne.s l0acde
	rts

l0acf2:	cmp.w 0x06(a6,a2.l),d4
	bne.s l0acda
	tst.w 0x08(a6,a2.l)
	blt.s l0acda
l0acfe:	moveq #0x00,d0
	rts

l0ad02:	moveq #-0x01,d0
	rts

l0ad06:	tst.b d3
	bne.s l0ad02
	tst.l 0x00ca(a6)
	blt.s l0ad26
l0ad10:	movea.l 0x0028(a6),a2
	adda.l 0x00ca(a6),a2
	move.l 0x00(a6,a2.l),d1
	subi.l #0x0014,d1
	addq.w #4,a2
	rts

l0ad26:	move.l 0x00ca(a6),d1
	bge.s l0ad32
	moveq #0x00,d1
	moveq #0x00,d0
	bra.s l0ad3c

l0ad32:	movea.l 0x0028(a6),a2
	adda.l d1,a2
	move.l 0x00(a6,a2.l),d0
l0ad3c:	addi.l #0x0140,d1
	move.l a2,-(a7)
	move.l d0,-(a7)
	jsr l04df6(pc)
	move.l (a7)+,d0
	movea.l (a7)+,a2
	move.l d1,0x00(a6,a0.l)
	move.l a0,-(a7)
	sub.l d0,d1
l0ad56:	addq.w #4,a2
	addq.w #4,a0
	subq.w #4,d0
	ble.s l0ad66
	move.l 0x00(a6,a2.l),0x00(a6,a0.l)
	bra.s l0ad56

l0ad66:	move.l a0,-(a7)
l0ad68:	st 0x00(a6,a0.l)
	adda.w #0x0010,a0
	subi.l #0x0010,d1
	bgt.s l0ad68
	move.l 0x00ca(a6),d1
	blt.s l0ad8c
	movea.l 0x0028(a6),a0
	adda.l d1,a0
	move.l 0x00(a6,a0.l),d1
	jsr l04fe8(pc)
l0ad8c:	movea.l (a7)+,a2
	move.l (a7)+,d1
	sub.l 0x0028(a6),d1
	move.l d1,0x00ca(a6)
	rts

|***** Ende von Basic BASIC3_ASM basic3_asm
