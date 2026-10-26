
|*******
|*
|* MDV_System MDV_SYS mdv_sys
|*
|**********


l029fc:	sf 0x0023(a2) | * mdv: motor on
l02a00:	moveq #0x00,d1
	move.b 0x0014(a2),d1
	lea 0x00ee(a6),a3
	st 0x09(a3,d1.w)
	tst.b (a3)
	bne.s l02a38
	moveq #0x10,d0
	jsr l00420(pc)
	move.b d1,(a3)
	move.b #0xfa,0x00ef(a6)
	lea 0x00018020,a3
	jsr l02c56(pc)
	ori.b #0x20,0x0035(a6)
	move.b 0x0035(a6),0x00018021
l02a38:	rts

l02a3a:	move.w 0x0008(a7),d0 | * update server-block mdv
	lsl.w #2,d0
	addq.w #1,d0
	movea.l 0x0058(a6),a1
l02a46:	moveq #-0x0f,d1
	and.b (a1),d1
	cmp.b d1,d0
	bne.s l02a52
	move.b #0x01,(a1)
l02a52:	addq.w #8,a1
	cmpa.l 0x005c(a6),a1
	blt.s l02a46
	lea 0x0228(a5),a1
	moveq #0x7f,d0
l02a60:	clr.l (a1)+
	dbf d0,l02a60
	rts

l02a68:	tst.b 0x0023(a5) | * Test sectortype
	ble.s l02a9c
	tst.b 0x0022(a5)
	bne.s l02a9c
	tst.b d7
	bne.s l02a98
	lea 0x0028(a5),a1
	jsr l0525c:l | * read sector 0
	bra.s l02a98 | * error
	lea 0x0008(a7),a1
	lea 0x0016(a5),a2
	move.l (a1)+,(a2)+
	move.l (a1)+,(a2)+
	move.l (a1)+,(a2)+
	bsr.s l02a3a
l02a94:	sf 0x0023(a5)
l02a98:	bra.w l02b84 | * stop motor


l02a9c:	lea 0x0016(a5),a1 | * a1 = $16 of PDB
	tst.b (a1)
	beq.s l02ab2
	suba.l a0,a0
	moveq #0x0a,d2
	jsr l039b4(pc) | * append name
	moveq #-0x10,d0
	jsr l03968(pc) | * UT.ERR
l02ab2:	bsr.s l02a3a | * update server block
	st 0x0023(a5)
	bra.w l02be2

l02abc:	movem.l d0-d6/a0-a4,-(a7) | * interrupt 2 of mdv
	lea 0x00018020,a3
	moveq #0x00,d0
	move.b 0x00ee(a6),d0
	beq.w l02b88
	suba.w #0x000e,a7
	movea.l a7,a1
	lea 0x00f0(a6),a5
	sf 0x07(a5,d0.w)
	move.b -0x01(a5,d0.w),d0
	move.w d0,-(a7)
	movea.l 0x10(a5,d0.w),a5
	move.l a5,-(a7)
	move.b 0x00ef(a6),d2
	bge.s l02af2
	addq.b #1,d2
l02af2:	jsr l0523a:l | * read header
l02af8:	bra.s l02a9c | * error
	bra.s l02a98 | * mistake
	moveq #0x0b,d0
	lea 0x0022(a5),a2
l02b02:	move.b -(a2),d1
	cmp.b -(a1),d1
	bne.w l02a68
	dbf d0,l02b02
	tst.b 0x0023(a5)
	bgt.s l02a94
	add.w d7,d7
	bne.s l02b24
	addq.b #1,0x0024(a5)
	cmpi.b #0x08,0x0024(a5)
	bgt.s l02af8
l02b24:	adda.w d7,a5
	moveq #0x00,d1
	move.w 0x0228(a5),d1
	beq.w l02bc4
	tst.b d2
	ble.s l02b36
	sf d2
l02b36:	move.b d2,0x00ef(a6)
	tst.w d1
	blt.w l02c1c
	lsl.l #3,d1
	movea.l 0x0058(a6),a4
	adda.l d1,a4
	move.l a4,-(a7)
	lsl.l #6,d1
	lea 0x00(a6,d1.l),a1
	btst #0x02,(a4)
	bne.s l02ba6
	btst #0x01,(a4)
	bne.s l02b66
	jsr l0525c:l
	bra.s l02b82
	bra.s l02b6e


l02b66:	jsr l05262:l
	bra.s l02b7e


l02b6e:	moveq #0x03,d0
	clr.w 0x0228(a5)
	movea.l 0x0004(a7),a1
	sf 0x0024(a1)
	bra.s l02bb8

l02b7e:	moveq #0x07,d0
	bra.s l02bb8


l02b82:	addq.w #4,a7
l02b84:	adda.w #0x0014,a7
l02b88:	move.b 0x0035(a6),d7
	ori.b #0x01,d7
	andi.b #0xdf,d7
	move.b d7,0x0001(a3)
	move.b 0x0035(a6),0x0001(a3)
	movem.l (a7)+,d0-d6/a0-a4
	bra.w l003b6


l02ba6:	tst.b d2 | * rewrite-block
	bmi.s l02b82
	move.w 0x0028(a5),-(a7)
	jsr l051b0:l
	addq.w #2,a7
	moveq #0x0b,d0
l02bb8:	moveq #-0x10,d1
	movea.l (a7)+,a4
	and.b (a4),d1
	or.b d0,d1
	move.b d1,(a4)
	moveq #0x05,d2
l02bc4:	tst.b d2
	bmi.s l02c14
	addq.b #1,d2
	cmpi.b #0x08,d2
	blt.s l02c14
	moveq #0x00,d2
	moveq #0x00,d0
	movea.l (a7),a5
	lea 0x0228(a5),a5
l02bda:	tst.w (a5)+
	bne.s l02c14
	addq.b #1,d0
	bne.s l02bda
l02be2:	jsr l02c50:l
	moveq #0x08,d1
	lea 0x00f8(a6),a5
l02bee:	tst.b -0x01(a5,d1.w)
	bne.s l02c08
	subq.b #1,d1
	bne.s l02bee
	clr.b 0x00ee(a6)
	andi.b #0xdf,0x0035(a6) | * mdv inactif
	jsr l00452(pc) | * 8049 - routine
	bra.s l02c18

l02c08:	move.b d1,0x00ee(a6) | * check for other mdv waiting
	jsr l02c56:l
	moveq #-0x06,d2
l02c14:	move.b d2,0x00ef(a6)
l02c18:	bra.w l02b84


l02c1c:	lea 0x0028(a5),a1 | * do sectorjob -2 = verify -1 = read
	addq.w #1,d1
	bne.s l02c3a
	tst.b d2
	bmi.w l02b84
	move.w #0x8000,-(a7)
	jsr l051b0:l
	addq.w #2,a7
	moveq #-0x02,d1
	bra.s l02c48

l02c3a:	jsr l05262:l | * verify sector
	bra.s l02c46 | * error
	moveq #0x00,d1
	bra.s l02c48
l02c46:	moveq #-0x01,d1
l02c48:	move.w d1,0x0228(a5)
	bra.w l02b84 | * 


l02c50:	moveq #0x02,d2 | * stop mdv-motor
	moveq #0x07,d1
	bra.s l02c5a

l02c56:	moveq #0x03,d2 | * transmit for mdv-motor control
	subq.w #1,d1
l02c5a:	move.b d2,(a3)
	moveq #0x39,d0
	ror.l d0,d0
	bclr #0x01,d2 | * 1 = go 0 = stop
	move.b d2,(a3)
	moveq #0x39,d0
	ror.l d0,d0
	moveq #0x02,d2
	dbf d1,l02c5a
	rts
|*** END MDV_SYS mdv_sys
