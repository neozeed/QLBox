
|**************************
|*
|*  JS MDV_ROUTINES  mdv_routines
|*
|***************************

l05000:	tst.b 0xee(a6) | * Format mdv-Routine: is mdv actif ?
	beq.s l0500a | * yes
	moveq #-9,d0 | * "in use"
	rts

l0500a:	move.l d1,d7
	movea.l a1,a4
	move.l #1152,d1 | * reserved space
	jsr l02fae:l | * MM.ALCHP
	nop | * !!! to overvome asm - remove it !!!
	beq.s l0501e | * sucess
	rts | * error out of mem

l0501e:	lea 0x0010(a0),a0
	movea.l a0,a5
	moveq #-0x01,d0
	move.w d0,(a0)+
	moveq #0x09,d1
l0502a:	move.b #0x20,(a0)+
	dbf d1,l0502a
	move.w 0x002e(a6),(a0) | * SV.RND
	suba.w #0x000a,a0
	move.w (a4)+,d1
	addq.w #5,a4
	subq.w #5,d1
	cmpi.w #0x000a,d1
	bls.s l05048
	moveq #0x0a,d1
l05048:	move.b (a4)+,(a0)+
	subq.w #1,d1
	bgt.s l05048
	lea 0x000e(a5),a0
	move.l #0xfd000c10,(a0)+
	addq.w #6,a0
	move.w d0,(a0)+
	move.w #0x012a,d1
l05060:	move.w #0xaa55,(a0)+
	dbf d1,l05060
	move.w #0x0f0e,0x021a(a5)
	move.w d7,d1
	lea 0x00018020,a3 | * A3 status of 8049
	moveq #0x10,d0
	jsr l00420:l
	nop | * !!! to conform asm leave it !!!
	ori.w #0x0700,sr | * interrupts
	jsr l02c56:l | * motor on
	nop | * !!! to conform asm leave it !!!
	move.l #0x0001e848,d0 | * time 3750600 about 0.5 secs
l0508e:	subq.l #1,d0
	bne.s l0508e
	move.b #0x0a,(a3)
l05096:	movea.l a5,a1
	moveq #0x0d,d1
	move.w #0x0479,d0
l0509e:	dbf d0,l0509e
	jsr l051a6(pc)
	move.w #0x0261,d1
	move.w #0x047b,d0
l050ae:	dbf d0,l050ae
	jsr l051a6(pc)
	subq.b #1,-0x026f(a1)
	bcc.s l05096
	move.b #0x02,(a3)
	clr.l -(a7)
	moveq #0x00,d5
l050c4:	move.w #0x00ff,d5
l050c8:	movea.l a5,a1
	jsr l0523a(pc) | * read sector header
	bra.s l050e6 | * error - no synchronisation
	bra.s l050e2 | * read - error
	jsr l052a4(pc) | * correct - read more
	bra.s l050e2 | * error
	add.w d7,d7 | * next sector
	subq.b #1,0x00(a1,d7.w) | * adapt sector nr.
	tst.w d7 | * sector 0
	beq.s l050ea | * end verifying
l050e2:	dbf d5,l050c8
l050e6:	bra.w l05180 | * format failed

l050ea:	tst.l d5 | * 1. verify
	blt.s l050f2 | * no
	moveq #-0x01,d5
	bra.s l050c4

l050f2:	moveq #0x00,d5 | * list formatted sectors
l050f4:	subq.b #1,(a1)
	cmpi.b #0xfe,(a1)
	bgt.s l05108
	beq.s l05100
	addq.w #1,(a7)
l05100:	move.b d5,0x0003(a7)
	move.b (a1),d4
	movea.l a1,a4
l05108:	addq.w #2,a1
	addq.b #1,d5
	bcc.s l050f4
	st (a4)
	addq.b #2,d4
	beq.s l05116
	subq.w #1,(a7)
l05116:	cmpi.w #0x00c8,(a7) | * less than 200 sectors?
	blt.s l05180 | * error 
	lea 0x000e(a5),a1
	moveq #0x00,d0
l05122:	clr.l (a1)+
	addq.b #1,d0
	bpl.s l05122
	lea 0x0270(a5),a1
	move.b #0xf8,(a1)
	move.l (a7),d1
	add.w d1,d1
	subi.w #0x0010,d1
l05138:	subq.w #2,d1
	cmpi.b #0xfd,0x00(a1,d1.w)
	bne.s l05138
	clr.b 0x00(a1,d1.w)
	move.w d1,0x01fe(a1)
	lsr.w #1,d1
	move.b d1,(a7)
	moveq #0x00,d2
	jsr l05222(pc) | * search sector 0
	bra.s l05180 | * not found - error
	lea 0x0270(a5),a1
	move.w (a1),-(a7)
	jsr l051b0(pc) | * write sector catalogue
	addq.w #2,a7
	move.b (a7),d2 | * last sector in d2
	jsr l05222(pc) | * read header
	bra.s l05180 | * failed
	lea 0x000e(a5),a1 | * 
	move.l #0x0040,(a1)
	clr.w -(a7)
	jsr l051b0(pc) | * write errors
	addq.w #2,a7
	moveq #0x00,d7
	bra.s l05182 | * no errors o.k

l05180:	moveq #-0x0e,d7 | * format failed
l05182:	jsr l02c50:l | * stop motor
	nop | * !!! to conform asm - leave it out !!!
	lea -0x0010(a5),a0
	jsr l0305e:l
	nop | * !!! to conform asm - leave it out !!!
	jsr l00452:l
	nop | * !!! to conform asm - leave it out !!
	andi.w #0xf0ff,sr
	clr.b (a7)
	move.w (a7)+,d1
	move.w (a7)+,d2
	move.l d7,d0
	rts

l051a6:	lea l051ac(pc),a4
	bra.s l051e4

l051ac:	moveq #0x0a,d4
	bra.s l051da

l051b0:
.equ xl011b0, l051b0-0x4000
	move.b #0x0a,(a3) | * write a sector
	move.w #0x05c9,d0
l051b8:	dbf d0,l051b8
	movea.l a1,a0
	lea 0x0004(a7),a1
	moveq #0x01,d1
	lea l051ca(pc),a4
	bra.s l051e4

l051ca:	movea.l a0,a1
	move.w #0x01ff,d1
	moveq #0x05,d5
	lea l051d8(pc),a4
	bra.s l051f2

l051d8:	moveq #0x02,d4
l051da:	moveq #0x30,d0
l051dc:	dbf d0,l051dc
	move.b d4,(a3)
	rts

l051e4:	moveq #0x0e,d0 | * common mdv write routine
	move.b d0,(a3)
	move.b d0,(a3)
	moveq #0x01,d6
	lea 0x0002(a3),a2
	moveq #0x09,d5
l051f2:	moveq #0x00,d4
l051f4:	bsr.s l0521a
	subq.b #1,d5
	bge.s l051f4
	moveq #-0x01,d4
	bsr.s l0521a
	bsr.s l0521a
	move.w #0x0f0f,d3
	moveq #0x00,d4
l05206:	move.b (a1)+,d4
	add.w d4,d3
	bsr.s l0521a
	dbf d1,l05206
	move.w d3,d4
	bsr.s l0521a
	lsr.w #8,d4
	bsr.s l0521a
	jmp (a4)

l0521a:	btst d6,(a3) | * test if 8049 busy
	bne.s l0521a
	move.b d4,(a2)
	rts

l05222:	moveq #0x00,d5 | * search sector header mdv
l05224:	movea.l a5,a1
	bsr.s l0523a
	rts | * failed
	bra.s l05224 | * read-error
	cmp.b d7,d2 | * was selected sector?
	beq.s l05236
	addq.b #1,d5
	bcc.s l05224 | * til 255 sectors read
	rts | * normal return adress

l05236:	addq.l #2,(a7) | * return addr. + 2
	rts

l0523a:
.equ xl0123a, l0523a-0x4000
	jsr l05448(pc) | * read sector header
	rts | * failed
	addq.l #2,(a7) | * correct
	moveq #0x0d,d1
	bsr.w l052ce | * read 
	bra.s l0525a | * failed
	cmpi.b #0xff,-0x000e(a1) | * sector nr. ok
	bne.s l0525a
	moveq #0x00,d7
	move.b -0x000d(a1),d7 | * return sector nr.
	addq.l #2,(a7)
l0525a:	rts

l0525c:
.equ xl0125c, l0525c-0x4000
	lea l052ce(pc),a0 | * read sector (addr. in a0)
	bra.s l05266

l05262:
.equ xl01262, l05262-0x4000
	lea l05354(pc),a0 | * verify sector addr. in a0
l05266:	jsr l05448(pc) | * do it
	rts | * failed
	move.l a1,-(a7)
	clr.w -(a7)
	movea.l a7,a1
	moveq #0x01,d1
	bsr.s l052ce | * read header
	bra.s l05296 | * failed
	move.b #0x02,d1 | * ok
	move.b d1,(a3) | * set timing (8049)
	moveq #0x08,d0 | * wait a little
l05280:	dbf d0,l05280
	move.b d1,(a3) | * again timing
	move.w #0x01ff,d1
	movea.l 0x0002(a7),a1 | * a1= buffer address
	jsr (a0) | * do it
	bra.s l05296 | * error
	addq.l #2,0x0006(a7)
l05296:	moveq #0x00,d1
	moveq #0x00,d2
	move.b 0x0001(a7),d2
	move.b (a7)+,d1
	addq.w #4,a7
	rts

l052a4:	jsr l05448(pc) | * verify formatted sector / read header
	rts | * failed
	move.w #0x0261,d1
	bsr.w l05354 | * read sector
	rts | * failed
	addq.l #2,(a7)
	rts

l052b8:	move.w #0x0100,d0 | * initialise parameters
	move.w #0x0f0f,d3 | * d0=counter, d3=checksum
	moveq #0x00,d4
	moveq #0x02,d6
	lea 0x0002(a3),a2 | * to read track 1
	lea 0x0003(a3),a4 | * to read track 2
	rts

l052ce:	bsr.w l052b8 | * read number of bits - initialise
l052d0:	btst d6,(a3)
	dbne d0,l052d0 | * till buffer is empty
	exg a4,a4 | * !!! WHAT'S THAT ??? !!!
	move.b (a2),d4
	exg a2,a4 | * !!! REALLY NECESSARY ?? !!!
	move.b d4,(a1)+
	add.w d4,d3
	tst.w d0
	blt.w l05446
	moveq #0x14,d0
	subq.w #1,d1
l052ea:	btst d6,(a3) | * !!! better: DBNE D0,L052EA (as in JM ROM
	bne.s l05338 | * but set D0 for better reliability to 28)
l052ee:	btst d6,(a3) | * then omit the following code)!!!
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
	btst d6,(a3)
	bne.s l05338
o05336:	moveq #-1,d0
l05338:	nop
	nop | * including this line but: - reset label!
	move.b (a2),d4
	exg a2,a4
	move.b d4,(a1)+
	add.w d4,d3
	tst.w d0
	blt.w l05446
	moveq #0x14,d0
	subq.w #1,d1
	bge.s l052ea | * try evtl second track
	bra.w l053de

l05354:	bsr.w l052b8 | * verify reading - initialise
l05358:	btst d6,(a3)
	dbne d0,l05358
	exg a4,a4
	move.b (a2),d4
	exg a2,a4
	cmp.b (a1)+,d4
	bne.w l05446
	add.w d4,d3
	tst.w d0
	blt.w l05446
	moveq #0x14,d0
	subq.w #1,d1
l05376:	btst d6,(a3) | * again wasting ROM space
	bne.s l053c4 | * !!! replace with dbne d0,L05376 !!!
	btst d6,(a3) | * again d0 set to 28
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	btst d6,(a3)
	bne.s l053c4
	moveq #-0x01,d0
l053c4:	nop
	nop | * wasting ends here
	move.b (a2),d4
	exg a2,a4
	cmp.b (a1)+,d4
	bne.s l05446
	add.w d4,d3
	tst.w d0
	blt.w l05446
	moveq #0x14,d0
	subq.w #1,d1
	bge.s l05376

l053de:	btst d6,(a3) | * !!! again as above: dbne d0,L053DE
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	btst d6,(a3)
	bne.s l0542c
	moveq #-0x01,d0
l0542c:	nop
	nop

l05430:	move.b (a2),d4
	exg a2,a4
	ror.w #8,d4
	tst.w d0 | * if too long waited
	blt.s l05446 | * back
	moveq #0x14,d0 | * timer
	addq.w #1,d1
	beq.s l053de
	cmp.w d4,d3 | * compare checksum
	bne.s l05446 | * not equal
	addq.l #2,(a7)
l05446:	rts

l05448:	moveq #0x00,d1 | * wait for pulsing interrupts
l0544a:	subq.w #1,d1 | * 0.38 seconds
	beq.s l05476
	btst #0x03,(a3) | * from 8049
	beq.s l0544a
	moveq #0x00,d1
l05456:	subq.w #1,d1 | * wait again 0.38 sec
	beq.s l05476
	moveq #0x17,d0
l0545c:	btst #0x03,(a3)
	bne.s l05456
	dbf d0,l0545c
	move.b #0x02,d1
	move.b d1,(a3)
	moveq #0x08,d0
l0546e:	dbf d0,l0546e
	move.b d1,(a3)
	addq.l #2,(a7)
l05476:	rts

|**************************************************
|*                                                *
|* End MDV_ROUTINES mdv_routines                  *
|*                                                *
|**************************************************
