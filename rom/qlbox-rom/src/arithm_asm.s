
|****************************
|*
|* start of arithmetic packagebe careful with changes - in this part
|* the relativ labels are not calculated best: don't make changes
|*
|***************************

l04196:	move.l a6,-(a7)
	suba.l a6,a6
	bsr.s l041ac | * RI.EXEC
	bra.s l041a4

l0419e:	move.l a6,-(a7)
	suba.l a6,a6
	bsr.s l041b4
l041a4:	beq.s l041a8
	moveq #0,d2
l041a8:	movea.l (a7)+,a6
	rts

l041ac:	movem.l d1-d3/a0/a2-a3/a5,-(a7) | * RI.EXEC
	suba.l a5,a5
	bra.s l041c0

l041b4:	movem.l d1-d3/a0/a2-a3/a5,-(a7) | * RI.EXECB
	movea.l a3,a5
l041ba:	moveq #0,d0
	move.b (a5)+,d0
	beq.s l041f8
l041c0:	cmpi.b #0x30,d0
	bhi.s l041cc | * ->variable
	bsr.s l041fe | * ->opcode
	bne.s l041f8
	bra.s l041ba

l041cc:	ori.w #0xff00,d0
	bclr #0,d0
	adda.w d0,a4
	bne.s l041de
	subq.w #6,a1
	bsr.s l041ea
	bra.s l041e6

l041de:	exg a1,a4
	bsr.s l041ea
	exg a1,a4
	addq.w #6,a1
l041e6:	suba.w d0,a4
	bra.s l041ba

l041ea:	move.w 0x00(a6,a4.l),0x00(a6,a1.l)
	move.l 0x02(a6,a4.l),0x02(a6,a1.l)
	rts

l041f8:	movem.l (a7)+,d1-d3/a0/a2-a3/a5
	rts

|* select on opcode
l041fe:	move.w l04206-0x02(pc,d0.w),d0
	jmp l04206(pc,d0.w)

.balign 2, 0 ; l04206:	.word l04796-l04206 | * RI.NINT
.balign 2, 0 ; 	.word l0479a-l04206 | * RI.INT
.balign 2, 0 ; 	.word l047a6-l04206 | * RI.NLINT
.balign 2, 0 ; 	.word l047b8-l04206 | * RI.FLOAT
.balign 2, 0 ; 	.word l04838-l04206 | * RI.ADD
.balign 2, 0 ; 	.word l0482a-l04206 | * RI.SUB
.balign 2, 0 ; 	.word l048de-l04206 | * RI.MULT
.balign 2, 0 ; 	.word l0497e-l04206 | * RI.DIV
.balign 2, 0 ; 	.word l04a06-l04206 | * RI.ABS
.balign 2, 0 ; 	.word l04a0c-l04206 | * RI.NEG
.balign 2, 0 ; 	.word l04a4a-l04206 | * RI.DUP
.balign 2, 0 ; 	.word l0423e-l04206 | * RI.COS
.balign 2, 0 ; 	.word l04236-l04206 | * RI.SIN
.balign 2, 0 ; 	.word l04262-l04206 | * RI.TAN
.balign 2, 0 ; 	.word l0426a-l04206 | * RI.COT
.balign 2, 0 ; 	.word l042f2-l04206 | * RI.ASIN
.balign 2, 0 ; 	.word l042e4-l04206 | * RI.ACOS
.balign 2, 0 ; 	.word l04326-l04206 | * RI.ATAN
.balign 2, 0 ; 	.word l0431e-l04206 | * RI.ACOT
.balign 2, 0 ; 	.word l0452c-l04206 | * RI.SQRT
.balign 2, 0 ; 	.word l04446-l04206 | * RI.LN
.balign 2, 0 ; 	.word l0442c-l04206 | * RI.LOG10
.balign 2, 0 ; 	.word l044de-l04206 | * RI.EXP
.balign 2, 0 ; 	.word l043c2-l04206 | * RI.POWFP

l04236:	movem.l d4-d7/a4,-(a7)
	moveq #0,d7
	bra.s l04248

l0423e:	movem.l d4-d7/a4,-(a7)
	jsr l04a06(pc)
	moveq #-1,d7
l04248:	jsr l04684(pc)
	bne.s l042b0
	bsr.s l042b6
	lea l045ae(pc),a4
	bsr.s l042c6
	btst #0,d7
	beq.s l042b0
	jsr l04a0c(pc)
	bra.s l042b0

l04262:	movem.l d4-d7/a4,-(a7)
	moveq #0,d6
	bra.s l04274

l0426a:	movem.l d4-d7/a4,-(a7)
	moveq #-0x01,d6
	jsr l04a0c(pc)
l04274:	moveq #0,d7
	jsr l04674(pc)
	bne.s l042b0
	eor.b d6,d7
	bsr.s l042b6
	lea l045d6(pc),a4
	jsr l04726(pc)
	addq.w #6,a1
	bsr.s l042ca
	subq.w #6,a1
	move.l -0x0a(a6,a1.l),0x02(a6,a1.l)
	move.w -0x0c(a6,a1.l),0x00(a6,a1.l)
	btst #0,d7
	beq.s l042aa
	jsr l04a5c(pc)
	jsr l04a0c:l | * !!! could be relativ !!!
l042aa:	jsr l0497e(pc)
l042ae:	moveq #0,d0
l042b0:	movem.l (a7)+,d4-d7/a4
	rts

l042b6:	jsr l04a4a(pc)
l042ba:	jsr l04a4a(pc)
	jsr l04a4a(pc)
	jmp l048de(pc)

l042c6:	jsr l0472c(pc)
l042ca:	jsr l048de(pc)
	jmp l04838(pc)

l042d2:	subq.w #6,a1
	clr.w 0x04(a6,a1.l)
	move.l #0x08014000,0x00(a6,a1.l)
	jmp l04a5c(pc)

l042e4:	jsr l04a0c(pc)
	bsr.s l042f2
	bne.s l0431c
	bsr.s l0430c
	jmp l04838(pc)

l042f2:	bsr.s l042ba
	bsr.s l042d2
	jsr l0482a(pc)
	bsr.w l0452c
	bne.s l0431c
	jsr l0497e(pc)
	beq.s l04326
	bsr.s l0430c
	jmp l048de(pc)

l0430c:	subq.w #6,a1
	move.l #0x6487ed51,0x02(a6,a1.l)
	move.w #0x0801,0x00(a6,a1.l)
l0431c:	rts

l0431e:	movem.l d4-d7/a4,-(a7)
	moveq #0x02,d7
	bra.s l0432c

l04326:	movem.l d4-d7/a4,-(a7)
	moveq #0,d7
l0432c:	tst.b 0x02(a6,a1.l)
	bge.s l04338
	addq.b #4,d7
	jsr l04a0c(pc)
l04338:	cmpi.w #0x0800,0x00(a6,a1.l)
	ble.s l0434a
	bsr.s l042d2
	jsr l0497e(pc)
	bchg #1,d7
l0434a:	jsr l04a4a(pc)
	subq.w #6,a1
	move.l #0x4498517a,0x02(a6,a1.w)
	move.w #0x07ff,0x00(a6,a1.l)
	jsr l0482a(pc)
	addq.w #6,a1
	tst.b -0x04(a6,a1.l)
	ble.s l04378
	lea l045f2(pc),a4
	jsr l04726(pc)
	jsr l0497e(pc)
	addq.b #1,d7
l04378:	bsr.w l042b6
	lea l0461a(pc),a4
	jsr l04726(pc)
	jsr l0497e(pc)
	bsr.w l042ca
	lsr.b #1,d7
	bcc.s l043a4
	subq.w #6,a1
	move.l #0x430548e1,0x02(a6,a1.l)
	move.w #0x0800,0x00(a6,a1.l)
	jsr l04838(pc)
l043a4:	lsr.b #1,d7
	bcc.s l043b4
	jsr l04a0c(pc)
	bsr.w l0430c
	jsr l04838(pc)
l043b4:	lsr.b #1,d7
	bcc.w l042ae
	jsr l04a0c(pc)
	bra.w l042b0

l043c2:	move.w 0x00(a6,a1.l),d1
	beq.s l043e6
	move.w #0x080f,d0
	sub.w d1,d0
	blt.s l043f0
	cmpi.w #0xf,d0
	bgt.s l043f0
	move.l 0x02(a6,a1.l),d1
	tst.w d1
	bne.s l043f0
	asr.l d0,d1
	tst.w d1
	bne.s l043f0
	swap d1
l043e6:	addq.w #4,a1
	move.w d1,0x00(a6,a1.l)
	jmp l047dc(pc)

l043f0:	movem.l d4-d7/a4,-(a7)
	move.w 0x00(a6,a1.l),d4
	move.l 0x02(a6,a1.l),d5
	addq.w #6,a1
	tst.b 0x02(a6,a1.l)
	beq.s l04420
	bsr.s l04446
	bne.w l042b0
	subq.w #6,a1
	move.l d5,0x02(a6,a1.l)
	move.w d4,0x00(a6,a1.l)
	jsr l048de(pc)
	bne.w l042b0
	bra.w l044e4

l04420:	tst.b -0x04(a6,a1.l)
	bge.w l042ae
	bra.w l044d8

l0442c:	bsr.s l04446
	bne.s l04444
	subq.w #6,a1
	move.l #0x6f2dec55,0x02(a6,a1.l)
	move.w #0x07ff,0x00(a6,a1.l)
	jsr l048de(pc)
l04444:	rts

l04446:	movem.l d4-d7/a4,-(a7)
	move.w 0x00(a6,a1.l),d4
	move.l 0x02(a6,a1.l),d5
	addq.w #6,a1
	ble.w l044d8
	move.w #0x0800,d0
	move.l d5,d1
	lsr.l #1,d5
	cmpi.l #0x5a82799a,d1
	bgt.s l04476
	subq.w #1,d4
	addi.l #0x20000000,d5
	bclr #0x1e,d1
	bra.s l0447e
l04476:	bset #0x1e,d5
	bset #0x1f,d1
l0447e:	tst.l d1
	jsr l04830(pc)
	subq.w #6,a1
	move.l d5,0x02(a6,a1.l)
	move.w #0x800,0x00(a6,a1.l)
	jsr l0497e(pc)
	bsr.w l042b6
	jsr l04a4a(pc)
	lea l04636(pc),a4
	move.w d4,d7
	jsr l04726(pc)
	jsr l0497e(pc)
	jsr l048de(pc)
	bsr.w l042ca
	subi.w #0x0800,d7
	subq.w #2,a1
	move.w d7,0x00(a6,a1.l)
	jsr l047b8(pc)
	subq.w #6,a1
	move.l #0x58b90bfc,0x02(a6,a1.l)
	move.w #0x800,0x00(a6,a1.l)
	bsr.w l042ca
	bra.w l042ae

l044d8:	moveq #-0x12,d0
l044da:	bra.w l042b0

l044de:	movem.l d4-d7/a4,-(a7)
	moveq #0,d7
l044e4:	jsr l04692(pc)
	bne.s l044da
	bsr.w l042ba
	lea l04658(pc),a4
	jsr l04726(pc)
	addq.w #6,a1
	jsr l048de(pc)
	jsr l04a4a(pc)
	subq.w #6,a1
	jsr l04a5c(pc)
	jsr l0482a(pc)
	jsr l0497e(pc)
	subq.w #6,a1
	move.l #0x40000000,0x02(a6,a1.l)
	move.w #0x0800,0x00(a6,a1.l)
	jsr l04838(pc)
	addq.w #1,d7
	add.w d7,0x00(a6,a1.l)
	bra.w l042ae

l0452c:	movem.l d4-d7/a4,-(a7)
	move.w 0x00(a6,a1.l),d6
	tst.l 0x02(a6,a1.l)
	beq.w l042ae
	blt.s l044d8
	lea l04666(pc),a4
	move.w d6,d7
	subi.w #0x0800,d7
	sub.w d7,0x00(a6,a1.l)
	asr.w #1,d7
	bcc.s l04554
	lea l04674(pc),a4
l04554:	swap d6
	jsr l0472c(pc)
	swap d6
	add.w d7,0x00(a6,a1.l)
	moveq #1,d7
l04562:	jsr l04a4a(pc)
	subq.w #6,a1
	move.l d5,0x02(a6,a1.l)
	move.w d6,0x00(a6,a1.l)
	jsr l04a5c(pc)
	jsr l0497e(pc)
	jsr l04838(pc)
	subq.w #1,0x00(a6,a1.l)
	dbf d7,l04562
l04584:	bra.w l042ae
|* LABEL WAS SET WRONG !!! CORRECTED

.balign 2, 0 ; l04588:	.word 0x0000
.balign 2, 0 ; 	.word 0x0000 | * list of parameters for floating nrs
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x07fe
.balign 2, 0 ; 	.word 0xaaaa
.balign 2, 0 ; 	.word 0xaab0
.balign 2, 0 ; 	.word 0x07fa
.balign 2, 0 ; 	.word 0x4444
.balign 2, 0 ; 	.word 0x42dd
.balign 2, 0 ; 	.word 0x07f4
.balign 2, 0 ; 	.word 0x97fa
.balign 2, 0 ; 	.word 0x15c1
.balign 2, 0 ; 	.word 0x07ee
.balign 2, 0 ; 	.word 0x5c5a
.balign 2, 0 ; 	.word 0xe940
.balign 2, 0 ; 	.word 0x07e7
.balign 2, 0 ; 	.word 0x997c
.balign 2, 0 ; 	.word 0x79c0
.balign 2, 0 ; 	.word 0x0005
.balign 2, 0 ; l045ae:	.word 0x0801
.balign 2, 0 ; 	.word 0x4000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x07ff
.balign 2, 0 ; 	.word 0x8e28
.balign 2, 0 ; 	.word 0x7bc1
.balign 2, 0 ; 	.word 0x07fb
.balign 2, 0 ; 	.word 0x416d
.balign 2, 0 ; 	.word 0x50cd
.balign 2, 0 ; 	.word 0x0002
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x07fd
.balign 2, 0 ; 	.word 0x8df7
.balign 2, 0 ; 	.word 0x443e
.balign 2, 0 ; 	.word 0x07f7
.balign 2, 0 ; 	.word 0x4676
.balign 2, 0 ; 	.word 0x1a70
.balign 2, 0 ; 	.word 0x0002
.balign 2, 0 ; l045d6:	.word 0x0801
.balign 2, 0 ; 	.word 0x6ed9
.balign 2, 0 ; 	.word 0xeba1
.balign 2, 0 ; 	.word 0x0801
.balign 2, 0 ; 	.word 0x4000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0001
.balign 2, 0 ; 	.word 0x0800
.balign 2, 0 ; 	.word 0x8000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0801
.balign 2, 0 ; 	.word 0x6ed9
.balign 2, 0 ; 	.word 0xeba1
.balign 2, 0 ; 	.word 0x0001
.balign 2, 0 ; l045f2:	.word 0x0803
.balign 2, 0 ; l045f4:	.word 0x451f
.balign 2, 0 ; 	.word 0xbedf
.balign 2, 0 ; 	.word 0x0803
.balign 2, 0 ; 	.word 0x4c09
.balign 2, 0 ; 	.word 0x1df8
.balign 2, 0 ; 	.word 0x0801
.balign 2, 0 ; 	.word 0x4000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0002
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0801
.balign 2, 0 ; 	.word 0xa3d5
.balign 2, 0 ; 	.word 0xac3b
.balign 2, 0 ; 	.word 0x0800
.balign 2, 0 ; 	.word 0xa3d6
.balign 2, 0 ; 	.word 0x2904
.balign 2, 0 ; 	.word 0x0002
.balign 2, 0 ; l0461a:	.word 0x0803
.balign 2, 0 ; 	.word 0xa6bc
.balign 2, 0 ; 	.word 0xeee1
.balign 2, 0 ; 	.word 0x0801
.balign 2, 0 ; 	.word 0x4000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0001
.balign 2, 0 ; 	.word 0x07ff
.balign 2, 0 ; 	.word 0x88fb
.balign 2, 0 ; 	.word 0xe7c1
.balign 2, 0 ; 	.word 0x07fa
.balign 2, 0 ; l04630:	.word 0x6f6b
.balign 2, 0 ; 	.word 0x44f3
.balign 2, 0 ; 	.word 0x0001
.balign 2, 0 ; l04636:	.word 0x0800
.balign 2, 0 ; 	.word 0x4000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x07fc
.balign 2, 0 ; 	.word 0x6db4
.balign 2, 0 ; 	.word 0xce83
.balign 2, 0 ; 	.word 0x07f5
.balign 2, 0 ; l04644:	.word 0x4def
.balign 2, 0 ; 	.word 0x09ca
.balign 2, 0 ; 	.word 0x0002
.balign 2, 0 ; 	.word 0x07ff
.balign 2, 0 ; 	.word 0x4000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x07f9
.balign 2, 0 ; 	.word 0x617d
.balign 2, 0 ; 	.word 0xe4ba
.balign 2, 0 ; 	.word 0x0001
.balign 2, 0 ; l04658:	.word 0x07ff
.balign 2, 0 ; 	.word 0x6ad4
.balign 2, 0 ; 	.word 0xd402
.balign 2, 0 ; 	.word 0x0800
.balign 2, 0 ; 	.word 0x4b8a
.balign 2, 0 ; 	.word 0x5ce6
.balign 2, 0 ; 	.word 0x0001
.balign 2, 0 ; l04666:	.word 0x0800
.balign 2, 0 ; 	.word 0x4b8a
.balign 2, 0 ; 	.word 0x5ce6
.balign 2, 0 ; 	.word 0x0800
.balign 2, 0 ; 	.word 0x6ad4
.balign 2, 0 ; 	.word 0xd402
.balign 2, 0 ; 	.word 0x0001

l04674:	addq.w #1,0x00(a6,a1.l)
	bsr.s l04684
	bne.s l046ee
	subq.w #1,0x00(a6,a1.l)
	moveq #0,d0
	rts

l04684:	lea l04714(pc),a4
	cmpi.w #0x0810,0x00(a6,a1.l)
	bgt.s l046ec
	bra.s l0469e

l04692:	lea l04726(pc),a4
	cmpi.w #0x0809,0x00(a6,a1.l)
	bgt.s l046ec
l0469e:	jsr l04a4a(pc)
	subq.w #6,a1
	move.l -(a4),0x02(a6,a1.l)
	move.w -(a4),0x00(a6,a1.l)
	jsr l048de(pc)
	tst.b d7
	bne.s l046c0
	jsr l04796(pc)
	move.w d1,d7
	jsr l047b8(pc)
	bra.s l046d6

l046c0:	jsr l0479a(pc)
	add.w d1,d7
	add.w d1,0x00(a6,a1.l)
	addq.w #1,0x00(a6,a1.l)
	jsr l047b8(pc)
	subq.w #1,0x00(a6,a1.l)
l046d6:	move.w 0x00(a6,a1.l),d4
	move.l 0x02(a6,a1.l),d5
	bsr.s l046f0
	subq.w #6,a1
	move.l d5,0x02(a6,a1.l)
	move.w d4,0x00(a6,a1.l)
	bra.s l046f0

l046ec:	moveq #-0x12,d0
l046ee:	rts

l046f0:	subq.w #6,a1
	move.l -(a4),0x02(a6,a1.l)
	move.w -(a4),0x00(a6,a1.l)
	jsr l048de(pc)
	jmp l0482a(pc)

.balign 2, 0 ; l04702:	.word 0x07f0
.balign 2, 0 ; 	.word 0xb544 | * trigonometric params
.balign 2, 0 ; 	.word 0x42d1
.balign 2, 0 ; 	.word 0x0802
.balign 2, 0 ; 	.word 0x6488
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x07ff
.balign 2, 0 ; 	.word 0x517c
.balign 2, 0 ; 	.word 0xc1b7
.balign 2, 0 ; l04714:	.word 0x07f4
.balign 2, 0 ; 	.word 0x90bf
.balign 2, 0 ; 	.word 0xbe8f
.balign 2, 0 ; 	.word 0x0800
.balign 2, 0 ; 	.word 0x58c0
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0801
.balign 2, 0 ; 	.word 0x5c55
.balign 2, 0 ; l04724:	.word 0x1d95


l04726:	bsr.s l0472c
	subq.w #6,a1
	bra.s l04734

l0472c:	move.w 0x00(a6,a1.l),d4
	move.l 0x02(a6,a1.l),d5
l04734:	move.w -(a4),d6
	move.l -(a4),0x02(a6,a1.l)
	move.w -(a4),0x00(a6,a1.l)
l0473e:	subq.w #6,a1
	move.l d5,0x02(a6,a1.l)
	move.w d4,0x00(a6,a1.l)
	jsr l048de(pc)
	subq.w #6,a1
	move.l -(a4),0x02(a6,a1.l)
	move.w -(a4),0x00(a6,a1.l)
	jsr l04838(pc)
	subq.w #1,d6
	bgt.s l0473e
	rts

l04760:	subq.w #6,a1
	clr.w 0x04(a6,a1.l)
	move.l #0x08004000,0x00(a6,a1.l)
	jsr l04838(pc)
l04772:	move.w 0x00(a6,a1.l),d0
	move.l 0x02(a6,a1.l),d1
	addq.w #2,a1
	clr.l 0x00(a6,a1.l)
	subi.w #0x0800,d0
	bge.s l04788
	moveq #0,d0
l04788:	subi.w #0x1f,d0
	neg.w d0
	asr.l d0,d1
	move.l d1,0x00(a6,a1.l)
	rts

l04796:	bsr.s l04760
	bra.s l0479c

l0479a:	bsr.s l04772
l0479c:	addq.l #2,a1
	cmpi.w #0x10,d0
	blt.s l047b4
	bra.s l047b0

l047a6:	bsr.s l04760
	bra.s l047ac

l047aa:	bsr.s l04772
l047ac:	tst.w d0
	blt.s l047b4
l047b0:	moveq #0,d0
	rts

l047b4:	moveq #-0x12,d0
	rts

l047b8:	move.w #0x081f,d0
	move.w 0x00(a6,a1.l),d1
	addq.w #2,a1
	ext.l d1
	jmp l04830(pc)

l047c8:	subq.w #6,a1
	clr.w 0x04(a6,a1.l)
	move.l #0x08014000,0x00(a6,a1.l)
	jsr l04a5c(pc)
	rts

l047dc:	movem.l d4-d6,-(a7)
	move.w 0x00(a6,a1.l),d6
	addq.w #2,a1
	bge.s l047f2
	neg.w d6
	bsr.s l047c8
	jsr l0497e(pc)
	bne.s l04824
l047f2:	bsr.s l047c8
l047f4:	lsr.w #1,d6
	bcc.s l04810
	move.w 0x00(a6,a1.l),d5
	move.l 0x02(a6,a1.l),d4
	jsr l048de(pc)
	subq.w #6,a1
	bne.s l04822
	move.l d4,0x02(a6,a1.l)
	move.w d5,0x00(a6,a1.l)
l04810:	tst.w d6
	beq.s l04820
	jsr l04a4a(pc)
	jsr l048de(pc)
	bne.s l04822
	bra.s l047f4

l04820:	moveq #0,d0
l04822:	addq.w #6,a1
l04824:	movem.l (a7)+,d4-d6
	rts

|* substraction of two floating point numbers

l0482a:	jsr l04a0c(pc)
	bra.s l04838

l04830:	subq.w #6,a1
	moveq #0,d2
	tst.l d1
	bra.s l04870

|* addition of two floating point numbers

l04838:	addq.w #6,a1
	move.w 0x00(a6,a1.l),d0
	sub.w -0x06(a6,a1.l),d0 | * compare exponents
	bge.s l0485c
	neg.w d0
	cmpi.w #0x0020,d0 | * > 32 bits?
	bge.s l048ae
	move.l 0x02(a6,a1.l),d1
	bsr.s l048c2 | * adjust mantisssa
	move.w -0x06(a6,a1.l),d0
	add.l -0x04(a6,a1.l),d1 | *  add it
	bra.s l04870

l0485c:	cmpi.w #0x20,d0
	bge.s l048be
	move.l -0x04(a6,a1.l),d1
	bsr.s l048c2
	move.w 0x00(a6,a1.l),d0
	add.l 0x02(a6,a1.l),d1
l04870:	bvs.s l04898 | *
	beq.s l048aa
	move.l d1,d3
	add.l d3,d3
	bvs.s l048b6
	sub.l d2,d3
	bvc.s l04880
	add.l d2,d3
l04880:	subq.w #1,d0
	move.l d3,d1
	moveq #0x10,d2
l04886:	move.l d1,d3
	asl.l d2,d3
	bvs.s l04892
	move.l d3,d1
	sub.w d2,d0
	blt.s l048a6
l04892:	asr.l #1,d2
	bne.s l04886
	bra.s l048b6

l04898:	roxr.l #1,d1
	addq.w #1,d0
	btst #0x0c,d0
	beq.s l048b6
	moveq #-0x12,d0
	rts

l048a6:	neg.w d0
	asr.l d0,d1
l048aa:	clr.w d0
	bra.s l048b6

l048ae:	move.w -0x06(a6,a1.l),d0
	move.l -0x04(a6,a1.l),d1
l048b6:	move.l d1,0x02(a6,a1.l)
	move.w d0,0x00(a6,a1.l)
l048be:	moveq #0,d0
	rts

l048c2:	moveq #0,d2
	tst.w d0
	beq.s l048dc
	asr.l d0,d1
	bcc.s l048dc
	addq.l #1,d1
	moveq #0x01,d2
	subq.w #1,d0
	bgt.s l048dc
	bclr #0,d1
	beq.s l048dc
	moveq #-0x01,d2
l048dc:	rts

|* multiplication of two floating point numbers

l048de:	movem.l d4-d6,-(a7)
	sf d5
	sf d6
	move.l 0x02(a6,a1.l),d3
	bge.s l048f4
	jsr l04a0c(pc)
	move.l d1,d3
	st d6
l048f4:	addq.w #6,a1
	move.l 0x02(a6,a1.l),d1
	bgt.s l04904
	beq.s l0496a
	jsr l04a0c(pc)
	st d5
l04904:	lsl.l #1,d1
	move.l d1,d0
	swap d0
	lsl.l #1,d3
l0490c:	move.l d3,d2 | * label-adressed (Label 13A)
	swap d2
	move.w d3,d4
	mulu d1,d4
	clr.w d4
	swap d4
	mulu d0,d3
	mulu d2,d1
	add.l d4,d3
	add.l d3,d1
	move.w d1,d4
	clr.w d1
	swap d1
	roxr.w #1,d1
	roxl.l #1,d1
	mulu d0,d2
	move.w 0x00(a6,a1.l),d0
	add.w -0x06(a6,a1.l),d0
	subi.w #0x0800,d0
	blt.s l04956
	add.l d2,d1
	bmi.s l04948
	beq.s l04956
	subq.w #1,d0
	blt.s l04956
	asl.w #1,d4
	bra.s l0494a

l04948:	lsr.l #1,d1
l0494a:	moveq #0,d4
	addx.l d4,d1
	bpl.s l0495a
	lsr.l #1,d1
	addq.w #1,d0
	bra.s l0495a

l04956:	clr.w d0
	clr.l d1
l0495a:	move.l d1,0x02(a6,a1.l)
	move.w d0,0x00(a6,a1.l)
	cmp.b d5,d6
	beq.s l0496a
	jsr l04a0c(pc)
l0496a:	movem.l (a7)+,d4-d6
	btst #0x04,0x00(a6,a1.l)
	bne.s l0497a
	moveq #0,d0
	rts

l0497a:	moveq #-0x12,d0
	rts


|* division of two floating-point numbers

l0497e:	move.l d4,-(a7)
	move.l d5,-(a7)
	sf d5
	move.l 0x02(a6,a1.l),d2 | * mantisa1
	bgt.s l04994
	beq.s l04a00
	jsr l04a0c(pc)
	move.l d1,d2
	st d5
l04994:	addq.w #6,a1
	move.l 0x02(a6,a1.l),d1 | * mantisa2
	bgt.s l049a4
	beq.s l049f6
	jsr l04a0c(pc)
	not.b d5
l049a4:	move.w 0x00(a6,a1.l),d0 | * exp2
	addi.w #0x0800,d0
	sub.w -0x06(a6,a1.l),d0 | *      - exp1
	bge.s l049b8
	clr.w d0
	clr.l d3
	bra.s l049e6

l049b8:	btst #0x0c,d0 | * exp overflow ?
	bne.s l04a02
	moveq #0x1f,d4 | * for 32 bits
	moveq #0,d3 | * result

|* compute D1/D2
l049c2:	sub.l d2,d1 | * fits D2 into D1?
	bcs.s l049ca | * no, too much subtracted
	bset d4,d3
	bra.s l049cc
l049ca:	add.l d2,d1
l049cc:	add.l d1,d1 | * next bit
	dbeq d4,l049c2

	tst.l d3
	blt.s l049de
	sub.l d1,d2
	bhi.s l049e6
	addq.l #1,d3
	bvc.s l049e6
l049de:	addq.w #1,d0
	lsr.l #1,d3
	moveq #0,d1
	addx.l d1,d3
l049e6:	move.l d3,0x02(a6,a1.l)
	move.w d0,0x00(a6,a1.l)
	tst.b d5
	beq.s l049f6
	jsr l04a0c(pc)
l049f6:	moveq #0,d0
l049f8:	move.l (a7)+,d5
	move.l (a7)+,d4
	tst.l d0
	rts

l04a00:	addq.w #6,a1
l04a02:	moveq #-0x12,d0
	bra.s l049f8

l04a06:	tst.b 0x02(a6,a1.l)
	bge.s l04a46
l04a0c:	move.l 0x02(a6,a1.l),d1
	neg.l d1
	bvs.s l04a2c
	cmpi.l #0xc0000000,d1
	bne.s l04a42
	lsl.l #1,d1
	subq.w #1,0x00(a6,a1.l)
	bge.s l04a42
	asr.l #1,d1
	clr.w 0x00(a6,a1.l)
	bra.s l04a42

l04a2c:	lsr.l #1,d1
	addq.w #1,0x00(a6,a1.l)
	btst #0x04,0x00(a6,a1.l)
	beq.s l04a42
	subq.w #1,0x00(a6,a1.l)
	moveq #-0x01,d1
	lsr.l #1,d1
l04a42:	move.l d1,0x02(a6,a1.l)
l04a46:	moveq #0,d0
	rts

l04a4a:	subq.w #6,a1
l04a4c:	move.w 0x06(a6,a1.l),0x00(a6,a1.l)
	move.l 0x08(a6,a1.l),0x02(a6,a1.l)
	moveq #0,d0
	rts

l04a5c:	move.w 0x00(a6,a1.l),d2
	move.l 0x02(a6,a1.l),d1
	jsr l04a4c(pc)
	move.w d2,0x06(a6,a1.l)
	move.l d1,0x08(a6,a1.l)
	moveq #0,d0
o4a72:	rts

|**** end of arithmetic package  ****
