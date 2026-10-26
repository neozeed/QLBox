
|**********
|*
|*  BASIC2_ASM basic2_asm
|*
|**********


|* initialise Basic pointers

l0566e:	suba.l a3,a3
	moveq #0x48,d0
l05672:	move.l #0x100,0x00(a6,a3.l)
	addq.w #4,a3
	cmpa.w d0,a3
	blt.s l05672
	moveq #0x64,d0
l05682:	move.l a5,0x00(a6,a3.l)
	addq.w #4,a3
	cmpa.w d0,a3
	ble.s l05682
	sf 0x006e(a6)
	st 0x006d(a6)
	st 0x0082(a6)
	sf 0x00aa(a6)
	st 0x00ab(a6)
	move.w #0xffff,0x0088(a6)
	move.l #0xffffffff,0x00ca(a6)
	moveq #0x00,d0
	move.w d0,0x00c8(a6)
	move.l d0,0x0084(a6)
	move.l d0,0x0072(a6)
	jsr l04e32(pc)
	moveq #0x7e,d1
	jmp l04e6a(pc)

|* liberate memory 

l056c6:	movea.l 0x0048(a6),a1
	move.l a1,d1
	sub.l 0x0044(a6),d1
	andi.l #0xfffffe00,d1
	beq.s l05700
	movea.l a1,a0
	suba.l d1,a0
l056dc:	move.l 0x00(a6,a1.l),0x00(a6,a0.l)
	addq.w #4,a1
	addq.w #4,a0
	cmpa.l 0x0064(a6),a1
	blt.s l056dc
	moveq #0x48,d0
	moveq #0x64,d2
l056f0:	sub.l d1,0x00(a6,d0.l)
	addq.b #4,d0
	cmp.b d2,d0
	ble.s l056f0
	suba.l d1,a7
	moveq #0x17,d0
	trap #0x01
l05700:	rts


|* store value of variable

l05702:	cmpa.l 0x001c(a6),a5
	bne.s l0570c
	move.l a3,0x001c(a6)
l0570c:	cmpa.l a5,a3
	bge.w l057ee
	andi.b #0x0f,0x01(a6,a3.l)
	beq.s l05778
	cmpi.w #0xffff,0x02(a6,a3.l)
	bne.s l05728
	movea.l a3,a2
	bsr.s l05784
	bra.s l05778

l05728:	moveq #0x01,d0
	sub.b 0x00(a6,a3.l),d0
	bge.s l05778
	move.w 0x02(a6,a3.l),d0
	lsl.l #3,d0
	movea.l 0x0018(a6),a2
	adda.l d0,a2
	cmpi.b #0x03,0x00(a6,a2.l)
	bne.s l0576c
	cmpi.b #0x02,0x00(a6,a3.l)
	beq.s l05778
	movea.l 0x04(a6,a3.l),a0
	adda.l 0x0028(a6),a0
	moveq #0x00,d1
	move.w 0x04(a6,a0.l),d1
	lsl.w #2,d1
	addq.w #6,d1
	movem.l d2/a1-a3,-(a7)
	jsr l04fe8(pc)
	movem.l (a7)+,d2/a1-a3
	bra.s l05778

l0576c:	move.l 0x04(a6,a3.l),0x04(a6,a2.l)
	move.b 0x00(a6,a3.l),0x00(a6,a2.l)
l05778:	move.l d7,0x00(a6,a3.l)
	move.l d7,0x04(a6,a3.l)
	addq.w #8,a3
	bra.s l0570c

|* release memory that was occupied by a variable

l05784:	movem.l d2/d4/d6/a1-a3,-(a7)
	movea.l 0x0028(a6),a0
	move.l 0x04(a6,a2.l),d1
	blt.s l057e8
	adda.l d1,a0
	move.b 0x00(a6,a2.l),d0
	subq.b #2,d0
	ble.s l057c0
	subq.b #1,d0
	bne.s l057ac
	move.l d1,d4
	move.b 0x01(a6,a2.l),d6
	jsr l099fe(pc)
	bra.s l057e8

l057ac:	subq.b #3,d0
	beq.s l057bc
	subq.b #1,d0
	beq.s l057b8
	moveq #-0x0c,d0
	bra.s l057ea

l057b8:	moveq #0x1a,d1
	bra.s l057dc

l057bc:	moveq #0x0c,d1
	bra.s l057dc

l057c0:	move.b 0x01(a6,a2.l),d0
	subq.b #2,d0
	blt.s l057d2
	beq.s l057ce
	moveq #0x02,d1
	bra.s l057dc

l057ce:	moveq #0x06,d1
	bra.s l057dc

l057d2:	moveq #0x03,d1
	add.w 0x00(a6,a0.l),d1
	bclr #0x00,d1
l057dc:	move.l #0xffffffff,0x04(a6,a2.l)
	jsr l04fe8(pc)
l057e8:	moveq #0x00,d0
l057ea:	movem.l (a7)+,d2/d4/d6/a1-a3
l057ee:	rts

|* join strings (&!)
l057f0:	move.l a0,-(a7)
	move.w 0x00(a6,a1.l),d0
	addq.w #2,a1
	moveq #0x00,d1
	move.w d0,d1
	beq.w l0588a
	swap d0
	addq.w #1,d1
	bclr #0x00,d1
	move.w d1,d0
	suba.l 0x005c(a6),a1
	movem.l d0-d2/a1,-(a7)
	jsr l04df6(pc)
	movem.l (a7)+,d0-d2/a1
	adda.l 0x005c(a6),a1
l0581e:	move.w 0x00(a6,a1.l),0x00(a6,a0.l)
	addq.w #2,a1
	addq.w #2,a0
	subq.w #2,d1
	bgt.s l0581e
	suba.w d0,a0
	move.w 0x00(a6,a1.l),d2
	addq.w #2,a1
	movea.l a1,a2
	move.w d2,d1
	addq.w #1,d1
	bclr #0x00,d1
	adda.w d1,a1
	move.w d2,d1
	swap d0
	add.w d0,d1
	addq.w #1,d1
	bmi.s l05890
	bclr #0x00,d1
	suba.w d1,a1
	move.w d2,d1
	beq.s l05862
l05854:	move.b 0x00(a6,a2.l),0x00(a6,a1.l)
	addq.w #1,a2
	addq.w #1,a1
	subq.w #1,d1
	bgt.s l05854
l05862:	add.w d0,d2
	move.l d0,d1
l05866:	move.b 0x00(a6,a0.l),0x00(a6,a1.l)
	addq.w #1,a0
	addq.w #1,a1
	subq.w #1,d0
	bgt.s l05866
	suba.w d1,a0
	suba.w d2,a1
	subq.w #2,a1
	move.w d2,0x00(a6,a1.l)
	clr.w d1
	swap d1
	move.l a1,-(a7)
	jsr l04fe8(pc)
	movea.l (a7)+,a1
l0588a:	moveq #0x00,d0
l0588c:	movea.l (a7)+,a0
	rts

|* joined string was too long

l05890:	lea -0x0002(a2),a1
	move.w d0,d1
	move.l a1,-(a7)
	jsr l04fe8(pc)
	movea.l (a7)+,a1
	moveq #-0x12,d0
	bra.s l0588c

.balign 2, 0 ; l058a2:	.long 0x00020202
.balign 2, 0 ; 	.long 0x02050505
.balign 2, 0 ; 	.long 0x05050505
.balign 2, 0 ; 	.long 0x03030302
.balign 2, 0 ; 	.long 0x01020202
.balign 2, 0 ; 	.long 0x03030102
.balign 2, 0 ; 	.long 0x02030200

l058be:	andi.b #0x0f,-0x07(a6,a5.l)
	moveq #0x00,d0
	move.b l058a2(pc,d4.w),d0
	cmpi.b #0x16,d4
	bgt.w l0598c
	andi.b #0x0f,-0x0f(a6,a5.l)
	cmp.b -0x07(a6,a5.l),d0
	beq.s l05904
	cmpi.b #0x05,d0
	bne.s l058fa
	move.b -0x07(a6,a5.l),d2
	cmp.b -0x0f(a6,a5.l),d2
	bne.s l058f8
	subq.b #1,d2
	bne.s l058f8
	subq.w #8,a5
l058f4:	bra.w l05992

l058f8:	moveq #0x02,d0
l058fa:	bsr.w l05996
	bne.w l05994
	move.b d2,d0
l05904:	subq.w #8,a5
	cmp.b -0x07(a6,a5.l),d0
	beq.s l058f4
	move.b 0x01(a6,a5.l),d1
	subq.b #2,d1
	blt.s l0592a
	beq.s l0591e
	move.w 0x00(a6,a1.l),-(a7)
	addq.w #2,a1
	bra.s l05946

l0591e:	move.l 0x02(a6,a1.l),-(a7)
	move.w 0x00(a6,a1.l),-(a7)
	addq.w #6,a1
	bra.s l05946

l0592a:	moveq #0x03,d2
	add.w 0x00(a6,a1.l),d2
	bclr #0x00,d2
	suba.l d2,a7
	move.l d2,d1
	subq.w #1,d1
l0593a:	move.w 0x00(a6,a1.l),(a7)+
	addq.w #2,a1
	subq.w #2,d1
	bge.s l0593a
	suba.l d2,a7
l05946:	move.b d1,-(a7)
	move.l a1,0x0058(a6)
	bsr.s l05996
	move.b (a7)+,d2
	blt.s l05968
	beq.s l0595c
	subq.w #2,a1
	move.w (a7)+,0x00(a6,a1.l)
	bra.s l05980

l0595c:	subq.w #6,a1
	move.w (a7)+,0x00(a6,a1.l)
	move.l (a7)+,0x02(a6,a1.l)
	bra.s l05980

l05968:	moveq #0x03,d2
	add.w (a7),d2
	bclr #0x00,d2
	suba.l d2,a1
	move.l d2,d1
l05974:	move.w (a7)+,0x00(a6,a1.l)
	addq.w #2,a1
	subq.w #2,d1
	bgt.s l05974
	suba.l d2,a1
l05980:	move.l a1,0x0058(a6)
	tst.l d0
	beq.s l05994
	addq.w #8,a5
	rts

|* single operator

l0598c:	cmp.b -0x07(a6,a5.l),d0
	bne.s l05996
l05992:	moveq #0x00,d0
l05994:	rts

|* convert variables

l05996:	move.l d7,-(a7)
	move.l a0,-(a7)
	move.b d0,-(a7)
	move.b -0x07(a6,a5.l),d2
	moveq #0x0f,d1
	and.l d1,d0
	and.l d1,d2
	sub.b d2,d0
	beq.s l05a0a
	subq.b #2,d2
	blt.s l059de
	beq.s l059c4
	addq.b #1,d0
	blt.s l059ba
	jsr l047b8(pc)
	bra.s l05a0a

l059ba:	movea.l (a6),a0
	jsr l03e54(pc)
	bsr.s l05a20
	bra.s l05a0a

l059c4:	tst.b d0
	blt.s l059d4
	jsr l04796(pc)
	move.b #0x03,-0x07(a6,a5.l)
	bra.s l05a0a

l059d4:	movea.l (a6),a0
	jsr l03ef6(pc)
	bsr.s l05a20
	bra.s l05a0a

l059de:	subq.b #1,d0
	blt.s l05a0a
	beq.s l059f0
	bsr.s l05a34
	move.l a0,-(a7)
	addq.w #2,a0
	jsr l03dc2(pc)
	bra.s l059fa

l059f0:	bsr.s l05a34
	move.l a0,-(a7)
	addq.w #2,a0
	jsr l03d16(pc)
l059fa:	movea.l (a7)+,a0
	move.l d0,-(a7)
	bsr.s l05a66
	move.l (a7)+,d0
	beq.s l05a0a
	subq.w #2,a1
	clr.w 0x00(a6,a1.l)
l05a0a:	move.b (a7)+,d2
	movea.l (a7)+,a0
	move.l (a7)+,d7
	move.l a1,0x0058(a6)
	tst.l d0
	bne.s l05a1e
	move.b d2,-0x07(a6,a5.l)
	moveq #0x00,d0
l05a1e:	rts

|* copy ASCII on arithmetic stack

l05a20:	move.l a1,0x0058(a6)
	move.l a4,-(a7)
	move.l a0,d1
	movea.l (a6),a4
	sub.l a4,d1
	jsr l05f88(pc)
	movea.l (a7)+,a4
	bra.s l05a62


|* copy ASCII in variables zone

l05a34:	moveq #0x03,d1
	add.w 0x00(a6,a1.l),d1
	bclr #0x00,d1
	jsr l04df6(pc)
	movea.l 0x0058(a6),a1
	move.l a0,-(a7)
l05a48:	move.w 0x00(a6,a1.l),0x00(a6,a0.l)
	addq.w #2,a0
	addq.w #2,a1
	subq.l #2,d1
	bgt.s l05a48
	movea.l (a7)+,a0
	move.l a0,d7
	moveq #0x02,d1
	add.w 0x00(a6,a0.l),d1
	add.l d1,d7
l05a62:	moveq #0x00,d0
	rts


l05a66:	move.l a1,-(a7)
	moveq #0x03,d1
	add.w 0x00(a6,a0.l),d1
	bclr #0x00,d1
	jsr l04fe8(pc)
	movea.l (a7)+,a1
	rts

|* handling of expression after variable, function or instruction

	moveq #0x01,d0
	bra.s l05a84

l05a7e:	moveq #0x02,d0
	bra.s l05a84

l05a82:	moveq #0x03,d0
l05a84:	move.b d0,-(a7)
	bsr.s l05aa0
	bne.s l05a9a
	move.b (a7),d0
	bne.s l05a90
	moveq #0x01,d0
l05a90:	jsr l05996(pc)
	subq.l #8,a5
	move.l a5,0x001c(a6)
l05a9a:	addq.w #2,a7
	tst.l d0
	rts

l05aa0:	bsr.s l05aba
	bne.s l05aa8
	bsr.w l05ec8
l05aa8:	rts

l05aaa:

|* labels indicating jump relative to L05AF4

	.byte 0x00
	.byte l05b08-l05af4
	.byte l05b08-l05af4
	.byte l05b08-l05af4
	.byte l05af8-l05af4
	.byte l05b78-l05af4
	.byte l05b8c-l05af4
	.byte l05bac-l05af4
	.byte l05bb6-l05af4
	.byte l05b08-l05af4
	.byte l05b08-l05af4
	.byte l05bb2-l05af4
	.byte l05b08-l05af4
	.byte l05b08-l05af4
	.byte l05b08-l05af4
	.byte 0x00

l05aba:	movea.l 0x001c(a6),a5
	move.l a5,-(a7)
	movem.l d4-d6,-(a7)
	st -(a7)
	moveq #0x40,d1
	jsr l04e60(pc)
	moveq #0x02,d0
	jsr l04e32(pc)
	bra.s l05adc

l05ad4:	moveq #0x01,d6
	bra.s l05ade

l05ad8:	st d6
	bra.s l05ade

l05adc:	sf d6
l05ade:	moveq #0x7f,d4
	and.b 0x00(a6,a0.l),d4
	cmpi.b #0x70,d4
	bge.w l05c58
	move.b l05aaa(pc,d4.w),d4
	jmp l05af4(pc,d4.w)

l05af4:	addq.w #2,a0
	bra.s l05ade

l05af8:	move.b 0x01(a6,a0.l),d4
	cmpi.b #0x05,d4
	beq.s l05b0e
	cmpi.b #0x01,d4
	beq.s l05b72
l05b08:	moveq #0x00,d5
	bra.w l05d16

l05b0e:	addq.w #2,a0
	tst.b d6
	beq.s l05b42
	bgt.w l05bac
	cmpi.b #0x03,-0x08(a6,a5.l)
	beq.s l05b28
	jsr l063d0(pc)
	bne.s l05b2c
	bra.s l05ad8

l05b28:	jsr l06272(pc)
l05b2c:	bne.w l05ca2
	cmpi.b #0x03,-0x08(a6,a5.l)

	beq.s l05ad8
l05b38:	cmpi.b #0x01,-0x07(a6,a5.l)
	beq.s l05ad8
	bra.s l05ad4

l05b42:	bsr.w l05aa0
	bne.w l05ca2
	cmpi.w #0x8406,0x00(a6,a0.l)
	bne.s l05bac
	addq.w #2,a0
	bra.s l05b38

|* table of priorities of artihmetic operations

.balign 2, 0 ; l05b56:	.long 0x00050506
.balign 2, 0 ; 	.long 0x06040404
.balign 2, 0 ; 	.long 0x04040404
.balign 2, 0 ; 	.long 0x01020107
.balign 2, 0 ; 	.long 0x09010201
.balign 2, 0 ; 	.long 0x0606080b
.balign 2, 0 ; 	.long 0x0b030300

l05b72:	move.w #0x8508,0x00(a6,a0.l)
l05b78:	tst.b d6
	beq.s l05bac
	move.b 0x01(a6,a0.l),d4
	addq.w #2,a0
	move.b l05b56(pc,d4.w),d5
	swap d4
	bra.w l05d1a

l05b8c:	moveq #0x16,d4
	add.b 0x01(a6,a0.l),d4
	addq.w #2,a0
	move.b l05b56(pc,d4.w),d5
	bra.s l05ba2

l05b9a:	tst.b d5
	beq.w l05d06
	swap d4
l05ba2:	move.b d5,-(a7)
	move.b d4,0x0001(a7)
	bra.w l05adc

l05bac:	moveq #-0x11,d0
	bra.w l05ca2

l05bb2:	bra.w l05c6a

l05bb6:	movea.l 0x001c(a6),a5
	addq.l #8,0x001c(a6)
	moveq #0x00,d4
	move.w 0x02(a6,a0.l),d4
	move.l d4,d0
	addq.w #4,a0
	lsl.l #3,d4
	movea.l 0x0018(a6),a3
	adda.l d4,a3
	move.b 0x00(a6,a3.l),d4
	cmpi.b #0x09,d4
	beq.s l05c0c
	cmpi.b #0x05,d4
	beq.s l05c12
	cmpi.b #0x08,d4
	beq.s l05bac
	cmpi.b #0x04,d4
	beq.s l05bac
	move.w 0x00(a6,a3.l),0x00(a6,a5.l)
	andi.b #0x0f,0x01(a6,a5.l)
	move.w d0,0x02(a6,a5.l)
	move.l 0x04(a6,a3.l),0x04(a6,a5.l)
	addq.w #8,a5
	subq.b #3,d4
	beq.s l05c1e
	bra.w l05c94

l05c0c:	jsr l060b8(pc)
	bra.s l05c16

l05c12:	jsr l06060(pc)
l05c16:	bne.w l05ca2
	bra.w l05ad4

l05c1e:	moveq #0x00,d1
	move.l -0x04(a6,a5.l),d0
	blt.s l05bac
	movea.l 0x0028(a6),a3
	adda.l d0,a3
	move.w 0x04(a6,a3.l),d1
	lsl.w #2,d1
	addq.w #6,d1
	move.l a3,-(a7)
	bsr.w l05fc2
	movea.l (a7)+,a3
	move.l a2,d2
	sub.l 0x0028(a6),d2
	move.l d2,-0x04(a6,a5.l)
l05c46:	move.w 0x00(a6,a3.l),0x00(a6,a2.l)
	addq.w #2,a3
	addq.w #2,a2
	subq.w #2,d1
	bne.s l05c46
	bra.w l05ad8

l05c58:	movea.l a0,a4
	bsr.w l05f6c
	addq.w #6,a0
	andi.b #0x0f,0x00(a6,a1.l)
	moveq #0x02,d4
	bra.s l05c76

l05c6a:	addq.w #2,a0
	movea.l a0,a4
	bsr.w l05f80
	movea.l a4,a0
	moveq #0x01,d4
l05c76:	movea.l 0x001c(a6),a5
	addq.l #8,0x001c(a6)
	move.b #0x01,0x00(a6,a5.l)
	move.b d4,0x01(a6,a5.l)
	move.w #0xffff,0x02(a6,a5.l)
	clr.l 0x04(a6,a5.l)
	addq.w #8,a5
l05c94:	cmpi.b #0x01,-0x07(a6,a5.l)
	beq.w l05ad8
	bra.w l05ad4

l05ca2:	tst.w (a7)+
	bge.s l05ca2
	movem.l (a7)+,d4-d6
l05caa:	cmpa.l (a7),a5
	beq.s l05cb4
	moveq #0x01,d2
	bsr.s l05cbc
	bra.s l05caa

l05cb4:	move.l a5,0x001c(a6)
	addq.w #4,a7
	bra.s l05d12

l05cbc:	move.b -0x08(a6,a5.l),d1
	subq.b #1,d1
	bne.s l05cec
	subq.b #2,-0x07(a6,a5.l)
	blt.s l05cd6
	bgt.s l05cd0
	addq.l #4,0x0058(a6)
l05cd0:	addq.l #2,0x0058(a6)
	bra.s l05ce8

l05cd6:	movea.l 0x0058(a6),a1
	moveq #0x03,d1
	add.w 0x00(a6,a1.l),d1
	bclr #0x00,d1
	add.l d1,0x0058(a6)
l05ce8:	subq.w #8,a5
l05cea:	rts

l05cec:	tst.b d2
	beq.s l05cea
	subq.b #2,d1
	bne.s l05ce8
	move.l -0x04(a6,a5.l),d1
	blt.s l05ce8
	movea.l 0x0028(a6),a3
	adda.l d1,a3
	bsr.w l05f30
	bra.s l05ce8

l05d06:	moveq #0x00,d0
	addq.w #2,a7
	movem.l (a7)+,d4-d6
	cmpa.l (a7)+,a5
	seq d0
l05d12:	tst.l d0
	rts

l05d16:	tst.b (a7)
	ble.s l05d06
l05d1a:	bsr.w l05ec8
l05d1e:	bne.s l05ca2
l05d20:	cmp.b (a7),d5
	bgt.w l05b9a
	move.w (a7)+,d4
	andi.w #0x00ff,d4
	jsr l058be(pc)
	bne.s l05d1e
	move.l a5,0x001c(a6)
	add.w d4,d4
	move.w l05d4e(pc,d4.w),d4
	beq.w l05bac
	moveq #0x02,d0
	jsr l05d4e(pc,d4.w)
	bne.s l05d1e
	move.l a1,0x0058(a6)
	bra.s l05d20

l05d4e:
|* LABEL OF DISPLACEMENTS FOR JUMPS RELATIV TO 5D4E
.balign 2, 0 ; 	.word 0x0
.balign 2, 0 ; 	.word l04838-l05d4e
.balign 2, 0 ; 	.word l0482a-l05d4e
.balign 2, 0 ; 	.word l048de-l05d4e
.balign 2, 0 ; 	.word l0497e-l05d4e
.balign 2, 0 ; 	.word xl05d98-l05d4e
.balign 2, 0 ; 	.word xl05d8a-l05d4e
.balign 2, 0 ; 	.word xl05d90-l05d4e
.balign 2, 0 ; 	.word xl05d92-l05d4e
.balign 2, 0 ; 	.word xl05da4-l05d4e
.balign 2, 0 ; 	.word xl05d9e-l05d4e
.balign 2, 0 ; 	.word xl05d84-l05d4e
.balign 2, 0 ; 	.word xl05e6c-l05d4e
.balign 2, 0 ; 	.word xl05e74-l05d4e
.balign 2, 0 ; 	.word xl05e7c-l05d4e
.balign 2, 0 ; 	.word l043c2-l05d4e
.balign 2, 0 ; 	.word l057f0-l05d4e
.balign 2, 0 ; 	.word xl05e42-l05d4e
.balign 2, 0 ; 	.word xl05e48-l05d4e
.balign 2, 0 ; 	.word xl05e4e-l05d4e
.balign 2, 0 ; 	.word xl05e92-l05d4e
.balign 2, 0 ; 	.word xl05e98-l05d4e
.balign 2, 0 ; 	.word xl05e26-l05d4e
.balign 2, 0 ; 	.word xl05e10-l05d4e
.balign 2, 0 ; 	.word xl05e0c-l05d4e
.balign 2, 0 ; 	.word xl05e84-l05d4e
.balign 2, 0 ; 	.word xl05e54-l05d4e

|* operator <       
l05d84:	bsr.s l05daa
	blt.s l05df4
	bra.s l05e04
|*operator >
l05d8a:	bsr.s l05daa
	bgt.s l05df4
	bra.s l05e04
.equ xl05d84, l05d84
.equ xl05d8a, l05d8a

l05d90:	moveq #0x03,d0
l05d92:	bsr.s l05daa
	beq.s l05df4
	bra.s l05e04
.equ xl05d90, l05d90
.equ xl05d92, l05d92
|* opertor >=
l05d98:	bsr.s l05daa
	bge.s l05df4
	bra.s l05e04
.equ xl05d98, l05d98
|* operator<=
l05d9e:	bsr.s l05daa
l05da0:	ble.s l05df4
	bra.s l05e04
.equ xl05d9e, l05d9e
|* operator <>
l05da4:	bsr.s l05daa
	bne.s l05df4
	bra.s l05e04
.equ xl05da4, l05da4

l05daa:	cmpi.b #0x01,-0x07(a6,a5.l)
	bne.s l05dcc
	move.l a0,-(a7)
	bsr.s l05e16
	jsr l03a9c(pc)
	bsr.s l05e14
	lea -0x0006(a0),a1
	move.b #0x02,-0x07(a6,a5.l)
l05dc6:	movea.l (a7)+,a0
	tst.l d0
	rts

l05dcc:	move.w d0,d4
	jsr l0482a(pc)
l05dd2:	bne.s l05df0
	subq.w #3,d4
	beq.s l05dde
	tst.b 0x02(a6,a1.l)
	rts

.equ xl05dd2, l05dd2

l05dde:	addq.w #4,a7
	move.w 0x00(a6,a1.l),d0
	beq.s l05df4
	addi.w #0x0018,d0
	sub.w -0x06(a6,a1.l),d0
	bra.s l05da0

l05df0:	addq.w #4,a7
	rts

l05df4:	move.w #0x0801,0x00(a6,a1.l)
	move.l #0x40000000,0x02(a6,a1.l)
	bra.s l05e0c

l05e04:	clr.w 0x00(a6,a1.l)
	clr.l 0x02(a6,a1.l)
l05e0c:	moveq #0x00,d0
	rts
.equ xl05e0c, l05e0c

l05e10:	jmp l04a0c(pc)
.equ xl05e10, l05e10

l05e14:	movea.l a0,a1
l05e16:	move.w 0x00(a6,a1.l),d2
	addq.w #3,d2
	bclr #0x00,d2
	lea 0x00(a1,d2.w),a0
	rts

l05e26:	moveq #0x01,d0
	move.l a0,-(a7)
	bsr.s l05e16
	jsr l03a6e(pc)
	bsr.s l05e14
	lea -0x0002(a0),a1
	move.b #0x03,-0x07(a6,a5.l)
	move.w d1,0x00(a6,a1.l)
	bra.s l05dc6
.equ xl05e26, l05e26

l05e42:	bsr.s l05e5c
	or.b d1,d0
	bra.s l05e58
.equ xl05e42, l05e42

l05e48:	bsr.s l05e5c
	and.b d1,d0
	bra.s l05e58
.equ xl05e48, l05e48

l05e4e:	bsr.s l05e5c
	eor.b d1,d0
	bra.s l05e58
.equ xl05e4e, l05e4e

l05e54:	bsr.s l05e64
	not.b d0
l05e58:	beq.s l05e04
	bra.s l05df4
.equ xl05e54, l05e54

l05e5c:	addq.w #6,a1
	tst.l -0x04(a6,a1.l)
	sne d1
l05e64:	tst.l 0x02(a6,a1.l)
	sne d0
	rts

l05e6c:	bsr.s l05e8a
	or.w d0,0x00(a6,a1.l)
l05e72:	bra.s l05e0c
.equ xl05e6c, l05e6c

l05e74:	bsr.s l05e8a
	and.w d0,0x00(a6,a1.l)
	bra.s l05e0c
.equ xl05e74, l05e74

l05e7c:	bsr.s l05e8a
	eor.w d0,0x00(a6,a1.l)
	bra.s l05e0c
.equ xl05e7c, l05e7c

l05e84:	not.w 0x00(a6,a1.l)
	bra.s l05e0c
.equ xl05e84, l05e84

l05e8a:	move.w 0x00(a6,a1.l),d0
l05e8e:	addq.w #2,a1
	rts

l05e92:	bsr.s l05ea0
	move.w d0,d3
	bra.s l05e9a
.equ xl05e92, l05e92

l05e98:	bsr.s l05ea0
l05e9a:	move.w d3,0x00(a6,a1.l)
	bra.s l05e72
.equ xl05e98, l05e98
l05ea0:	move.w 0x02(a6,a1.l),d0
	ext.l d0
	move.w 0x00(a6,a1.l),d1
	beq.s l05ec2
	move.w d0,d2
	divs d1,d0
	move.w d0,d3
	swap d0
	eor.w d1,d2
	bpl.s l05e8e
	tst.w d0
	beq.s l05e8e
	add.w d1,d0
	subq.w #1,d3
	bra.s l05e8e

l05ec2:	moveq #-0x12,d0
	addq.w #4,a7
	bra.s l05e8e


l05ec8:	andi.b #0x0f,-0x07(a6,a5.l)
	move.b -0x08(a6,a5.l),d0
	beq.s l05ee8
	subq.b #1,d0
	beq.w l05fb4
	subq.b #2,d0
	blt.s l05f42
	beq.s l05ef6
	subq.b #3,d0
	blt.s l05ee8
	subq.b #1,d0
	ble.s l05f42
l05ee8:	moveq #0x01,d2
	bsr.w l05cbc
	move.l a5,0x001c(a6)
	moveq #-0x11,d0
	rts

l05ef6:	move.b -0x07(a6,a5.l),d0
	subq.b #1,d0
	bgt.s l05ee8
	movea.l -0x04(a6,a5.l),a3
	adda.l 0x0028(a6),a3
	movea.l 0x00(a6,a3.l),a4
	adda.l 0x0028(a6),a4
	cmpi.w #0x0001,0x04(a6,a3.l)

	bgt.s l05ee8
	move.b #0x01,-0x08(a6,a5.l)

	move.b #0x01,-0x07(a6,a5.l)

	moveq #0x00,d1
	move.w 0x06(a6,a3.l),d1
	bsr.s l05f30
	tst.b d0
	beq.s l05f80
	bra.s l05f88

l05f30:	movem.l d0-d1/a0-a1,-(a7)
	movea.l a3,a0
	moveq #0x0a,d1
	jsr l04fe8(pc)
	movem.l (a7)+,d0-d1/a0-a1
	rts

l05f42:	move.b -0x07(a6,a5.l),d0
	move.l -0x04(a6,a5.l),d1
	blt.s l05ee8
	move.b #0x01,-0x08(a6,a5.l)
	movea.l d1,a4
	adda.l 0x0028(a6),a4
	subq.b #2,d0
	blt.s l05f80
	beq.s l05f6c
	moveq #0x02,d1
	bsr.s l05fbc
	subq.w #2,a1
	move.w 0x00(a6,a4.l),0x00(a6,a1.l)
	bra.s l05fb4

l05f6c:	moveq #0x06,d1
	bsr.s l05fbc
	subq.w #6,a1
	move.l 0x02(a6,a4.l),0x02(a6,a1.l)

	move.w 0x00(a6,a4.l),0x00(a6,a1.l)

	bra.s l05fb4

l05f80:	moveq #0x00,d1
	move.w 0x00(a6,a4.l),d1
	addq.w #2,a4
l05f88:	move.l d1,-(a7)
	addq.l #3,d1
	bsr.s l05fbc
	move.l (a7),d1
	beq.s l05fac
	addq.l #1,d1
	bclr #0x00,d1
	move.l d1,d0
	suba.l d0,a1
l05f9c:	move.b 0x00(a6,a4.l),0x00(a6,a1.l)
	addq.w #1,a1
	addq.w #1,a4
	subq.l #1,d0
	bgt.s l05f9c
	suba.l d1,a1
l05fac:	subq.w #2,a1
	addq.w #2,a7
	move.w (a7)+,0x00(a6,a1.l)
l05fb4:	move.l a1,0x0058(a6)
	moveq #0x00,d0
	rts

l05fbc:	jsr l04e4e(pc)
	bra.s l05fcc

l05fc2:	move.l a0,-(a7)
	jsr l04df6(pc)
	movea.l a0,a2
	movea.l (a7)+,a0
l05fcc:	movea.l 0x0058(a6),a1
	rts

l05fd2:	jsr l05aba(pc)
	bne.s l06048
	andi.b #0x0f,-0x07(a6,a5.l)
	move.b -0x08(a6,a5.l),d0
	cmpi.b #0x01,d0
	bne.s l06046
	move.w #0xffff,-0x06(a6,a5.l)

	move.b #0x02,-0x08(a6,a5.l)

	move.b -0x07(a6,a5.l),d0
	subq.b #2,d0
	blt.s l06018
	beq.s l06008
	moveq #0x02,d1
	bsr.s l0604a
	addq.w #2,a2
	addq.w #2,a1
	bra.s l06042

l06008:	moveq #0x06,d1
	bsr.s l0604a
	move.l 0x02(a6,a1.l),0x02(a6,a2.l)
	addq.w #6,a2
	addq.w #6,a1
	bra.s l06042

l06018:	moveq #0x03,d1
	add.w 0x00(a6,a1.l),d1
	bclr #0x00,d1
	bsr.s l0604a
	move.w 0x00(a6,a1.l),d1
	addq.w #2,a1
	addq.w #2,a2
	beq.s l06042
	addq.w #1,d1
	bclr #0x00,d1
l06034:	move.w 0x00(a6,a1.l),0x00(a6,a2.l)
	addq.w #2,a1
	addq.w #2,a2
	subq.w #2,d1
	bgt.s l06034
l06042:	move.l a1,0x0058(a6)
l06046:	moveq #0x00,d0
l06048:	rts

l0604a:	jsr l05fc2(pc)
	move.l a2,d2
	sub.l 0x0028(a6),d2
	move.l d2,-0x04(a6,a5.l)
	move.w 0x00(a6,a1.l),0x00(a6,a2.l)
	rts

l06060:	movea.l a3,a2
	bsr.s l06094
	move.b 0x01(a6,a2.l),-0x07(a6,a5.l)
	bsr.s l060a6
	bne.s l06074
	addq.w #2,a0
	moveq #0x02,d5
	bra.s l06076

l06074:	moveq #0x03,d5
l06076:	movea.l a0,a4
	move.l d0,d4
	suba.l 0x0008(a6),a0
	move.l a0,-(a7)
	lea l04bfa:l,a0
	nop | * !!! to conform asm - leave it out
	move.l a0,-(a7)
	lea l0a8ea:l,a0
	move.l a0,-(a7)
	bra.w l094ca

|* initialise entry in name-table

l06094:	clr.w 0x00(a6,a5.l)
	move.w #0xffff,0x02(a6,a5.l)
	clr.l 0x04(a6,a5.l)
	addq.w #8,a5
	rts

l060a6:	cmpi.b #0x80,0x00(a6,a0.l)
	bne.s l060b0
	addq.w #2,a0
l060b0:	cmpi.w #0x8405,0x00(a6,a0.l)
	rts

|* execute basic's function

l060b8:	bsr.s l06094
	move.l a5,d0
	sub.l 0x0018(a6),d0
	move.l d0,-(a7)
	move.l 0x04(a6,a3.l),-(a7)
	bsr.s l060a6
	beq.s l060cc
	bra.s l060de

l060cc:	addq.w #2,a0
	jsr l0614a(pc)
	bne.s l06144
	cmpi.w #0x8406,0x00(a6,a0.l)
	bne.s l06142
	addq.w #2,a0
l060de:	movea.l (a7)+,a2
	movea.l 0x0018(a6),a3
	move.l a5,d0
	sub.l a3,d0
	adda.l (a7),a3
	move.l d0,-(a7)
	suba.l 0x0008(a6),a0
	movea.l 0x0058(a6),a1
	suba.l 0x005c(a6),a1
	movem.l d5-d7/a0-a1,-(a7)
	jsr (a2)
	move.l d0,d2
	movem.l (a7)+,d5-d7/a0-a1
	adda.l 0x0008(a6),a0
	beq.s l06112
	adda.l 0x005c(a6),a1
	move.l a1,0x0058(a6)
l06112:	movea.l 0x0058(a6),a1
	movea.l 0x0018(a6),a5
	movea.l a5,a3
	adda.l (a7)+,a5
	adda.l (a7)+,a3
	move.l a0,-(a7)
	move.l a3,-(a7)
	jsr l05702(pc)
	movea.l (a7)+,a5
	move.l d2,d0
	bne.s l06146
	move.b d4,-0x07(a6,a5.l)
	move.b #0x01,-0x08(a6,a5.l)
	clr.l -0x04(a6,a5.l)
	movea.l (a7)+,a0
	moveq #0x00,d0
	rts

l06142:	moveq #-0x11,d0
l06144:	addq.w #4,a7
l06146:	addq.w #4,a7
	rts

|* calculate and store value of a function

l0614a:	move.l d3,-(a7)
	move.l d4,-(a7)
	sf d4
l06150:	jsr l05fd2(pc)
	blt.s l061b6
	bgt.s l06162
	move.b 0x00(a6,a0.l),d0
	move.w 0x00(a6,a0.l),d1
	bra.s l0618c

l06162:	move.b 0x00(a6,a0.l),d0
	move.w 0x00(a6,a0.l),d1
	cmpi.b #0x8e,d0
	beq.s l0617c
	cmpi.w #0x8403,d1
	bne.s l061aa
	st d4
	addq.w #2,a0
	bra.s l06150

l0617c:	clr.w 0x00(a6,a5.l)
	move.w #0xffff,0x02(a6,a5.l)
	clr.l 0x04(a6,a5.l)
	addq.w #8,a5
l0618c:	move.l a5,0x001c(a6)
	cmpi.b #0x8e,d0
	bne.s l061aa
	tst.b d4
	beq.s l0619e
	bset #0x03,d1
l0619e:	sf d4
	addq.w #2,a0
	lsl.b #4,d1
	or.b d1,-0x07(a6,a5.l)
	bra.s l06150

l061aa:	tst.b d4
	beq.s l061b4
	bset #0x07,-0x07(a6,a5.l)

l061b4:	moveq #0x00,d0
l061b6:	move.l (a7)+,d4
	move.l (a7)+,d3
	tst.l d0
	rts

l061be:	bsr.s l061da
	bra.s l061cc

l061c2:	bsr.s l061e2
	bra.s l061cc

l061c6:	bsr.s l061de
	bra.s l061cc

l061ca:	bsr.s l061d6
l061cc:	bne.s l061d4
	subq.w #1,d3
	beq.s l061d4
	moveq #-0x0f,d0
l061d4:	rts

l061d6:	moveq #0x01,d0
	bra.s l061e6

l061da:	moveq #0x03,d0
	bra.s l061e6

l061de:	moveq #0x02,d0
	bra.s l061e6

l061e2:	moveq #0x05,d0
	ror.l #1,d0
l061e6:	movem.l d5/a4-a5,-(a7)
	move.l a3,-(a7)
	move.l d0,-(a7)
	moveq #0x00,d5
l061f0:	cmpa.l 0x0004(a7),a5
	ble.s l06228
	moveq #0x0f,d6
	and.b -0x07(a6,a5.l),d6
	move.b d6,-0x07(a6,a5.l)
	jsr l05ec8(pc)
	bne.s l0622a
	move.l (a7),d0
	jsr l05996(pc)
	move.b d6,-0x07(a6,a5.l)
	tst.l d0
	bne.s l0622a
	tst.l (a7)
	bpl.s l06222
	jsr l047aa(pc)
	bne.s l0622a
	move.l a1,0x0058(a6)
l06222:	addq.w #1,d5
	subq.w #8,a5
	bra.s l061f0

l06228:	moveq #0x00,d0
l0622a:	addq.w #4,a7
	move.l d5,d3
	movea.l (a7)+,a3
	movem.l (a7)+,d5/a4-a5
	tst.l d0
	rts

|* evaluate characteristics of a table

l06238:	andi.b #0x0f,-0x07(a6,a5.l)
	movea.l -0x04(a6,a5.l),a4
	adda.l 0x0028(a6),a4
	movea.l a4,a2
	move.l 0x00(a6,a4.l),d6
	move.w 0x04(a6,a4.l),d4
	addq.w #6,a4
	rts

|* store charecteristics evaluated above

l06254:	suba.l 0x0028(a6),a2
	suba.l 0x0028(a6),a4
	movem.l a2/a4-a5,-(a7)
	jsr l05a82(pc)
	movem.l (a7)+,a2/a4-a5
	adda.l 0x0028(a6),a4
	adda.l 0x0028(a6),a2
	rts

l06272:	bsr.s l06238
l06274:	moveq #0x00,d5
	bsr.s l06254
	blt.s l062d0
	beq.s l06288
	cmpi.w #0x8e05,0x00(a6,a0.l)

	beq.s l06292
l06284:	moveq #-0x11,d0
	bra.s l062d0

l06288:	addq.l #2,0x0058(a6)
	move.w 0x00(a6,a1.l),d5
	blt.s l062ce
l06292:	cmp.w 0x00(a6,a4.l),d5
	bgt.s l062ce
	move.w d5,d0
	mulu 0x02(a6,a4.l),d0
	move.b -0x07(a6,a5.l),d1
	subq.b #2,d1
	blt.s l062b0
	beq.s l062ac
	add.l d0,d0
	bra.s l062b0

l062ac:	mulu #0x0006,d0
l062b0:	add.l d0,d6
	moveq #0x00,d0
	move.l d6,0x00(a6,a2.l)
	cmpi.w #0x8e05,0x00(a6,a0.l)
	bne.s l062e6
	addq.w #2,a0
	bsr.s l06254
	blt.s l062d0
	beq.s l062d4
	move.w 0x00(a6,a4.l),d0
	bra.s l062e2

l062ce:	moveq #-0x04,d0
l062d0:	bra.w l063ce

l062d4:	addq.l #2,0x0058(a6)
	move.w 0x00(a6,a1.l),d0
	cmp.w 0x00(a6,a4.l),d0
	bgt.s l062ce
l062e2:	sub.w d5,d0
	blt.s l062ce
l062e6:	move.w d0,0x00(a6,a4.l)
	addq.w #4,a4
	subq.w #1,d4
	bne.s l0632a
	cmpi.b #0x01,-0x07(a6,a5.l)

	bgt.s l0632a
	beq.s l06308
	subq.l #1,0x00(a6,a2.l)
	addq.w #1,-0x04(a6,a4.l)
	tst.w d5
	beq.s l062ce
	bra.s l0632a

l06308:	clr.b -0x07(a6,a5.l)
	addq.w #1,-0x04(a6,a4.l)
	addq.l #1,0x00(a6,a2.l)
	tst.w d5
	bne.s l0632a
	tst.w d0
	bne.s l062ce
	subq.l #1,0x00(a6,a2.l)
	subq.w #1,-0x04(a6,a4.l)
	move.b #0x03,-0x07(a6,a5.l)

l0632a:	move.w 0x00(a6,a0.l),d0
	addq.w #2,a0
	cmpi.w #0x8406,d0
	beq.s l06346
	cmpi.w #0x8e01,d0
	bne.w l06284
	tst.w d4
	bgt.w l06274
	bra.s l062ce

l06346:	bsr.w l06238
	movea.l (a6),a3
	move.l 0x00(a6,a2.l),0x00(a6,a3.l)

	addq.w #6,a3
	moveq #0x00,d0
l06356:	tst.w 0x00(a6,a4.l)
	beq.s l06366
	move.l 0x00(a6,a4.l),0x00(a6,a3.l)

	addq.w #4,a3
	addq.w #1,d0
l06366:	addq.w #4,a4
	subq.w #1,d4
	bgt.s l06356
	movea.l (a6),a3
	move.w d0,0x04(a6,a3.l)
	move.w 0x04(a6,a2.l),d1
	lsl.l #2,d1
	addq.w #6,d1
	move.l a0,-(a7)
	move.l a3,-(a7)
	movea.l a2,a0
	jsr l04fe8(pc)
	movea.l (a7)+,a3
	movea.l (a7)+,a0
	move.w 0x04(a6,a3.l),d1
	bgt.s l063a2
	tst.b -0x07(a6,a5.l)
	beq.s l063a2
	move.l 0x00(a6,a3.l),-0x04(a6,a5.l)

	move.b #0x02,-0x08(a6,a5.l)

	bra.s l063cc

l063a2:	lsl.l #2,d1
	addq.w #6,d1
	move.l a0,-(a7)
	move.l a3,-(a7)
	jsr l04df6(pc)
	movea.l a0,a2
	movea.l (a7)+,a3
	movea.l (a7)+,a0
	move.l a2,d0
	sub.l 0x0028(a6),d0
	move.l d0,-0x04(a6,a5.l)
l063be:	move.w 0x00(a6,a3.l),0x00(a6,a2.l)
	addq.w #2,a3
	addq.w #2,a2
	subq.l #2,d1
	bgt.s l063be
l063cc:	moveq #0x00,d0
l063ce:	rts

|* evaluate substring of type x$( 4 to 8)

l063d0:	movem.l d5-d6/a2/a4,-(a7)
	cmpi.b #0x01,-0x08(a6,a5.l)
	beq.s l063ee
	move.l -0x04(a6,a5.l),d0
	blt.s l063ea
	movea.l 0x0028(a6),a2
	adda.l d0,a2
	bra.s l06404

l063ea:	moveq #-0x11,d0
	bra.s l0643e

l063ee:	move.l a0,-(a7)
	jsr l05a34(pc)
	moveq #0x00,d7
	move.l a1,0x0058(a6)
	movea.l a0,a2
	movea.l (a7)+,a0
	move.l a2,d0
	sub.l 0x0028(a6),d0
l06404:	move.l d0,-(a7)
	bsr.s l06446
	movea.l 0x0028(a6),a2
	adda.l (a7)+,a2
	bne.s l06420
	movea.l a2,a4
	addq.w #2,a4
	subq.w #1,d5
	adda.w d5,a4
	move.w d6,d1
	sub.w d5,d1
	jsr l05f88(pc)
l06420:	move.l d0,-(a7)
	cmpi.b #0x01,-0x08(a6,a5.l)

	bne.s l06434
	move.l a0,-(a7)
	movea.l a2,a0
	jsr l05a66(pc)
	movea.l (a7)+,a0
l06434:	move.l (a7)+,d0
	bne.s l0643e
	move.b #0x01,-0x08(a6,a5.l)

l0643e:	movem.l (a7)+,d5-d6/a2/a4
	tst.l d0
	rts

l06446:	move.w 0x00(a6,a2.l),-(a7)
	jsr l05a82(pc)
	blt.s l06496
	bgt.s l0649e
	addq.l #2,0x0058(a6)
	move.w 0x00(a6,a1.l),d5
	ble.s l0649e
	cmp.w (a7),d5
	bgt.s l0649e
	move.w d5,d6
	cmpi.w #0x8e05,0x00(a6,a0.l)
	bne.s l06482
	addq.w #2,a0
	jsr l05a82(pc)
	blt.s l06496
	bgt.s l06480
	addq.l #2,0x0058(a6)
	move.w 0x00(a6,a1.l),d6
	cmp.w (a7),d6
	ble.s l06482
l06480:	move.w (a7),d6
l06482:	move.w d6,d0
	addq.w #1,d0
	sub.w d5,d0
	blt.s l0649e
	cmpi.w #0x8406,0x00(a6,a0.l)
	bne.s l0649a
	addq.w #2,a0
	moveq #0x00,d0
l06496:	addq.w #2,a7
	rts


l0649a:	moveq #-0x11,d0
	bra.s l06496

l0649e:	moveq #-0x04,d0
	bra.s l06496

l064a2:	move.l a4,-(a7)
	moveq #0x0f,d0
	and.b -0x07(a6,a5.l),d0
	subq.b #1,d0
	beq.s l064d6
	moveq #0x00,d0
	move.w -0x06(a6,a5.l),d0
	blt.s l064dc
	movea.l 0x0018(a6),a1
	lsl.l #3,d0
	adda.l d0,a1
	movea.l 0x0020(a6),a0
	adda.w 0x02(a6,a1.l),a0
	moveq #0x00,d1
	move.b 0x00(a6,a0.l),d1
	lea 0x0001(a0),a4
	jsr l05f88(pc)
	bra.s l064de

l064d6:	jsr l05ec8(pc)
	bra.s l064de

l064dc:	moveq #-0x0c,d0
l064de:	movea.l (a7)+,a4
	rts

|**------------------------ B a u d
lbaud:	jsr l0803e(pc) | * search for parameter
	bne.s l064f6
	move.w 0x00(a6,a1.l),d1
	moveq #0x12,d0
	trap #0x01
	tst.l d0
	bmi.s l064f8
	moveq #0x00,d0
l064f6:	rts

l064f8:	moveq #-0x0f,d0
	rts

|**------------------- end BAUD

|* desplacements for parameters of BEEP
.balign 2, 0 ; l064fc:	.long 0x00060000
.balign 2, 0 ; 	.long 0x00020004
.balign 2, 0 ; 	.long 0x0008000a
.balign 2, 0 ; 	.long 0x000e000c

|* Beeperror

l0650c:	add.l d3,d3
	add.l d3,0x0058(a6)
l06512:	adda.w #0x0018,a7
	movem.l (a7)+,d4-d7/a3-a5
	tst.l d0
	rts

lbeep:	jsr l061da(pc)
	movem.l d4-d7/a3-a5,-(a7)
	adda.w #0xffe8,a7
	movea.l a7,a3
	bne.s l0650c
	moveq #-0x0f,d0
	cmpi.w #0,d3
	beq.s l065a8
	cmpi.w #1,d3
	beq.s l0650c
	cmpi.w #3,d3
	beq.s l0650c
	cmpi.w #4,d3
	beq.s l0650c
	cmpi.w #8,d3
	bgt.s l0650c
	lea l064fc(pc),a5
	moveq #0x01,d2
l06554:	move.w 0x0(a6,a1.l),d0
	cmpi.w #2,d2
	beq.s l06564
	cmpi.w #3,d2
	bne.s l06566
l06564:	addq.w #1,d0
l06566:	ror.w #8,d0
	jsr l065c0(pc)
	adda.w #2,a1
	cmp.w d3,d2
	ble.s l06554
	cmpi.w #0x0003,d2
	beq.s l06582
l0657a:	moveq #0,d0
	cmpi.w #8,d2
	bgt.s l06588
l06582:	jsr l065c0(pc)
	bra.s l0657a

l06588:	move.b #0x0a,(a3)
	move.b #0x10,0x0001(a3)
	move.l #0x4444aa66,0x0002(a3)
	move.b #0x01,0x0016(a3)
	moveq #0x11,d0
	trap #0x01
	bra.w l0650c

|* stop Beeper

l065a8:	move.b #0x0b,(a3)
	move.b #0x00,0x0001(a3)
	move.b #0x01,0x0006(a3)
	moveq #0x11,d0
	trap #0x01
	bra.w l06512

l065c0:	movea.w (a5)+,a4
	move.w d0,0x06(a3,a4.w)
	addq.w #1,d2
	rts

|*-------------- end BEEP

lcall:	jsr l061e2(pc)
	bne.s l065e4
	lsl.l #2,d3
	beq.s l065e2
	add.l d3,0x0058(a6)
	move.l 0x00(a6,a1.l),-(a7)
	movem.l 0x04(a6,a1.l),d1-d7/a0-a5

l065e2:	moveq #-0x0f,d0
l065e4:	rts

|*------------- end CALL

|* evaluate le #id corresponding to a Basic#nr

l065e6:	moveq #0x01,d1
l065e8:	move.l a5,-(a7)
	cmpa.l a3,a5
	bls.s l0661c
	bclr #0x07,0x01(a6,a3.l)
	beq.s l0661c
	move.l a3,-(a7)
	lea 0x0008(a3),a5
	andi.b #0x0f,0x01(a6,a3.l)
	jsr l05ec8(pc)
	bne.s l06642
	moveq #0x03,d0
	jsr l05996(pc)
	bne.s l06642
	movea.l (a7)+,a3
	addq.w #8,a3
	move.w 0x00(a6,a1.l),d1
	addq.l #2,0x0058(a6)
l0661c:	movea.l (a7)+,a5

l0661e:	move.l d1,d0
	movea.l 0x0030(a6),a0
	mulu #0x0028,d0
	adda.l d0,a0
	cmpa.l 0x0034(a6),a0
	bge.s l0663e
	move.l 0x00(a6,a0.l),d0
	blt.s l0663e
	movea.l a0,a2
	movea.l d0,a0
	moveq #0x00,d0
	rts

l0663e:	moveq #-0x06,d0
	rts

l06642:	addq.w #8,a7
	rts

|* initialise one of the Basic-#

l06646:	move.l a0,-(a7)
	bsr.s l0661e
	beq.s l0669e
	cmpa.l 0x0034(a6),a0
	blt.s l06680
	move.l d1,-(a7)
	move.l a0,d1
	addi.l #0x28,d1
	sub.l 0x34(a6),d1
	jsr l04e7a(pc)
	move.l (a7)+,d1
	bsr.s l0661e
l06668:	movea.l 0x0034(a6),a2
	addi.l #0x28,0x0034(a6)
	move.l #0xffffffff,0x00(a6,a2.l)
	cmpa.l a0,a2
	blt.s l06668
l06680:	movea.l a0,a2
	moveq #0x0a,d0
l06684:	clr.l 0x00(a6,a0.l)
	addq.w #4,a0
	subq.w #1,d0
	bgt.s l06684
	movea.l (a7)+,a0
	move.l a0,0x00(a6,a2.l)
	move.w #0x0050,0x22(a6,a2.l)
o669a:	moveq #0x00,d0
	rts

l0669e:	moveq #-0x08,d0
	rts

|*----------------------
lcsize:	jsr l08038(pc)
	bne.s l066c4
	subq.w #1,d3
	jsr l08028(pc)
	bne.s l066c4
	move.w -0x02(a6,a1.l),d2
	exg d1,d2
	cmpi.w #0x0003,d1
	bhi.s l066c2
	moveq #0x2d,d4
	jmp l07fc4(pc)

l066c2:	moveq #-0x0f,d0
l066c4:	rts

|*--------------------
lcursor:	moveq #-0x20,d0
	add.l a5,d0
	sub.l a3,d0
	beq.w l06be0
	moveq #0x17,d4
	bra.s l066d6

lat:	moveq #0x10,d4
l066d6:	jsr l08038(pc)
	bne.s l066f8
	cmpi.w #0x0002,d3
	bne.s l066f6
	move.w 0x00(a6,a1.l),d2
	move.w -0x02(a6,a1.l),d1
	cmpi.b #0x10,d4
	bne.s l066f2
	exg d1,d2
l066f2:	jmp l07fc4(pc)

l066f6:	moveq #-0x0f,d0
l066f8:	rts
|*-----------------

|* position pointer to next instruction of precompiled Basic

l066fa:	move.l 0x0068(a6),-(a7)
	move.l 0x006e(a6),-(a7)
	move.w 0x006c(a6),-(a7)
	move.l a4,-(a7)
	jsr l0958e(pc)
	bne.s l06784
	move.w 0x0094(a6),d4
	jsr l09fa2(pc)
	jsr l0a96a(pc)
	bne.s l06784
	move.b 0x0096(a6),d4
	jsr l0a00a(pc)
	jsr l0a56c(pc)
	cmpi.w #0x8118,d1
	bne.s l0674a
	move.b 0x0097(a6),d5
	addq.b #1,0x0097(a6)
l06736:	addq.w #2,a4
	jsr l0a56c(pc)
	subq.b #1,d5
	beq.s l0676e
	move.w #0x8404,d4
	jsr l0a5e0(pc)
	beq.s l06736
l0674a:	jsr l0a60e(pc)
	bne.s l06784
	jsr l0a56c(pc)
	cmpi.w #0x8118,d1
	bne.s l0674a
	addq.w #2,a4
	move.w 0x0068(a6),0x0094(a6)
	move.b 0x006c(a6),0x0096(a6)
	move.b #0x02,0x0097(a6)
l0676e:	movea.l a4,a0
	moveq #0x00,d0
l06772:	movea.l (a7)+,a4
	move.w (a7)+,0x006c(a6)
	move.l (a7)+,0x006e(a6)
	move.l (a7)+,0x0068(a6)
	tst.l d0
	rts

l06784:	moveq #-0x0a,d0
	bra.s l06772
|*---------------------
ladate:	jsr l061c2(pc)
	bne.s l067ae
	addq.l #4,0x0058(a6)
	move.l 0x00(a6,a1.l),d1
	moveq #0x15,d0
	trap #0x01
	bra.s l0680c

lsdate:	jsr l061e2(pc)
	bne.s l0680e
	moveq #-0x0f,d0
	lsl.l #2,d3
	add.l d3,0x0058(a6)
	lsr.l #2,d3
	subq.w #6,d3
l067ae:	bne.s l0680e
	move.l 0x00(a6,a1.l),d0
	subi.l #0x7a9,d0
	move.l d0,d1
	mulu #0x016d,d1
	move.l 0x04(a6,a1.l),d2
	divu #0x0004,d0
	swap d0
	cmpi.w #0x0003,d0
	bne.s l067d8
	cmpi.w #0x0002,d2
	ble.s l067d8
	addq.l #1,d1
l067d8:	clr.w d0
	swap d0
	add.l d0,d1
	subq.l #1,d2
	asl.w #1,d2
	lea l06812(pc,d2.w),a2
	clr.l d0
	move.w (a2),d0
	add.l d0,d1
	add.l 0x08(a6,a1.l),d1
	subq.w #1,d1
	moveq #0x18,d0
	bsr.s l0682a
	add.l 0x0c(a6,a1.l),d1
	moveq #0x3c,d0
	bsr.s l0682a
	add.l 0x10(a6,a1.l),d1
	bsr.s l0682a
	add.l 0x14(a6,a1.l),d1
	moveq #0x14,d0
	trap #0x01
l0680c:	moveq #0x00,d0
l0680e:	tst.l d0
	rts
|*------------------------
|* table of days

.balign 2, 0 ; l06812:	.long 0x0000001f
.balign 2, 0 ; 	.long 0x003b005a
.balign 2, 0 ; 	.long 0x00780097
.balign 2, 0 ; 	.long 0x00b500d4
.balign 2, 0 ; 	.long 0x00f30111
.balign 2, 0 ; 	.long 0x0130014e

|* multiply integer long in d0 wit interger long in d1

l0682a:	bsr.s l0684e
	move.l d4,d3
	swap d0
	swap d1
	bsr.s l0684e
	move.l d4,d2
	swap d0
	swap d3
	bsr.s l0684e
	bsr.s l06854
	swap d0
	swap d1
	bsr.s l0684e
	bsr.s l06854
	swap d3
	swap d0
	move.l d3,d1
	rts

l0684e:	move.l d0,d4
	mulu d1,d4
	rts

l06854:	add.w d4,d3
	clr.w d4
	swap d4
	addx.l d4,d2
	rts

|*-----------------------
lread:	move.l a5,-(a7)
l06860:	cmpa.l (a7),a3
	bge.s l06886
	jsr l07a8e(pc)
	bne.s l06888
	jsr l066fa(pc)
	bne.s l06888
	move.b 0x01(a6,a3.l),d0
	move.l a3,-(a7)
	jsr l05a84(pc)
	movea.l (a7)+,a3
	bne.s l06888
	jsr l072c2(pc)
	addq.w #8,a3
	bra.s l06860

l06886:	moveq #0x00,d0
l06888:	movea.l (a7)+,a5
	rts
|*------------------------
lexec:	moveq #0x00,d5
	bra.s l06892

lexecw:	moveq #-0x01,d5
l06892:	moveq #0x01,d4
	bsr.w l069c4
	bne.s l068f8
	moveq #0x47,d0
	moveq #0x0e,d2
	movea.l (a6),a1
	bsr.w l069a4
	bne.s l06912
	cmpi.b #0x01,-0x09(a6,a1.l)
	bne.w l06990
	moveq #0x01,d0
	moveq #-0x01,d1
	move.l -0x0e(a6,a1.l),d2
	move.l -0x08(a6,a1.l),d3
	suba.l a1,a1
	movem.l d2/a0/a3,-(a7)
	trap #0x01
	movea.l a0,a1
	movem.l (a7)+,d2/a0/a3
	tst.l d0
	bne.s l06912
	move.l d1,d6
	moveq #0x48,d0
	bsr.w l069a6
	bsr.w l0693a
	bne.s l068fa
	moveq #0x0a,d0
	move.l d6,d1
	moveq #0x20,d2
	move.l d5,d3
	trap #0x01
	tst.l d0
	bne.s l068fa
	tst.l d5
	bne.s l068f8
	moveq #0x08,d0
	moveq #-0x01,d1
	moveq #0x19,d3
	suba.l a1,a1
	trap #0x01
l068f8:	rts

l068fa:	move.l d0,d4
	moveq #0x04,d0
	move.l d6,d1
	trap #0x01
	move.l d4,d0
	rts
|*-----------------------

llbytes:	moveq #0x01,d4
	bsr.w l069c4
	bne.s l068f8
	jsr l061e2(pc)
l06912:	bne.s l06986
	subq.w #1,d3
	bne.s l06990
	btst #0x00,0x03(a6,a1.l)
	bne.s l06990
	movea.l 0x00(a6,a1.l),a1
	addq.l #4,0x0058(a6)
	moveq #0x47,d0
	moveq #0x0e,d2
	move.l a1,-(a7)
	bsr.s l069a6
	movea.l (a7)+,a1
	bne.s l06986
	move.l (a1),d2
	moveq #0x48,d0
	bsr.s l069a6
l0693a:	bra.s l06986

|*------------------
lsexec:	moveq #0x01,d5
	bra.s l06942

lsbytes:	moveq #0x00,d5
l06942:	move.l a3,0x00b4(a6)
	moveq #0x02,d4
	bsr.s l069c4
	bne.s l0698e
	jsr l061e2(pc)
	bne.s l06986
	subq.w #2,d3
	sub.w d5,d3
	bne.s l0699a
	movea.l 0x00(a6,a1.l),a2
	addq.w #2,a1
	move.l 0x02(a6,a1.l),0x00(a6,a1.l)
	move.w d5,0x04(a6,a1.l)
	moveq #0x46,d0
	move.l a1,-(a7)
	bsr.s l069a4
	movea.l (a7)+,a1
	bne.s l06986
	move.l 0x00(a6,a1.l),d2
	addq.w #6,a1
	lsl.w #4,d5
	adda.w d5,a1
	move.l a1,0x0058(a6)
	movea.l a2,a1
	moveq #0x49,d0
	bsr.s l069a6
l06986:	move.l d0,d4
l06988:	moveq #0x02,d0
	trap #0x02
l0698c:	move.l d4,d0
l0698e:	rts

l06990:	moveq #-0x0f,d0
	bra.s l06986

l06994:	addq.w #4,a7
l06996:	moveq #-0x0f,d0
	rts

l0699a:	bsr.s l06988
	movea.l 0x00b4(a6),a3
	bsr.s l069e6
	bra.s l06996

|*----------------
|* trap#3 - execution

l069a4:	trap #0x04
l069a6:	moveq #-0x01,d3
	trap #0x03
	tst.l d0
	rts
|*-------------
|* entry of variables name
l069ae:	cmpa.l a5,a3
	bge.s l06994
	move.l a5,-(a7)
	addq.w #8,a3
	movea.l a3,a5
	jsr l064a2(pc)
	movea.l (a7)+,a5
	beq.s l0698e
	addq.w #4,a7
	rts

|* open channel for Basic
l069c4:	bsr.s l069ae
	moveq #0x01,d0
	moveq #-0x01,d1
	move.l d4,d3
l069cc:	movea.l a1,a0
	move.w 0x00(a6,a1.l),-(a7)
	trap #0x04
	trap #0x02
	moveq #0x03,d3
	add.w (a7)+,d3
	bclr #0x00,d3
	add.l d3,0x0058(a6)
	tst.l d0
	rts

|*------------
ldelete:
l069e6:	bsr.s l069ae
	moveq #0x04,d0
	bra.s l069cc

ldir:	jsr l065e6(pc)
	bne.s l0698e
	movea.l a0,a4
	moveq #0x04,d4
	bsr.s l069c4
	bne.s l0698e
	movea.l a0,a5
	moveq #0x45,d0
	movea.l (a6),a1
	movea.l a5,a0
	bsr.s l069a4
	bne.s l06986
	move.l d1,-(a7)
	movea.l (a6),a1
	moveq #0x0a,d2
	bsr.s l06a6a
	moveq #0x05,d0
	moveq #0x0a,d1
	trap #0x03
	movem.w (a7)+,d1-d2
	bsr.s l06a40
l06a1a:	moveq #0x03,d0
	moveq #0x40,d2
	movea.l (a6),a1
	movea.l a5,a0
	moveq #0x00,d4
	bsr.w l069a4
	bne.w l06988
	suba.w #0x0030,a1
	move.w -0x02(a6,a1.l),d2
	beq.s l06a1a
	bsr.s l06a6a
	moveq #0x05,d0
	moveq #0x0a,d1
	trap #0x03
	bra.s l06a1a

|*-- add numbers of sectors

l06a40:	move.w d2,d4
	bsr.s l06a5a
	moveq #0x05,d0
	move.b #0x2f,d1
	trap #0x03
	move.w d4,d1
	bsr.s l06a5a
	moveq #-0x17,d0
	jsr l03968(pc)
	moveq #0x00,d0
	rts

|*----------
|* Add entire number

l06a5a:	movea.l (a6),a1
	lea 0x0002(a1),a0
	move.w d1,0x00(a6,a1.l)
	jsr l03e54(pc)
	move.w d1,d2
l06a6a:	moveq #0x07,d0
	movea.l a4,a0
	moveq #-0x01,d3
	bra.w l069a4
|*---

lformat:	jsr l065e6(pc)
	bne.w l0698e
	movea.l a0,a4
	bsr.w l069ae
	moveq #0x03,d0
	bsr.w l069cc
	bne.w l0698e
	bra.s l06a40

lcopy:	moveq #0x00,d5
	bra.s l06a94

lcopyn:	moveq #-0x01,d5
l06a94:	moveq #0x01,d4
	bsr.w l069c4
	bne.w l0698e
	movea.l a0,a4
	moveq #0x02,d4
	bsr.w l069c4
	bne.s l06b20
	tst.b d5
	bne.s l06aca
	moveq #-0x01,d5
	movea.l (a6),a1
	moveq #0x47,d0
	moveq #0x0e,d2
	exg a0,a4
	bsr.w l069a4
	exg a0,a4
	bne.s l06aca
	movea.l (a6),a1
	move.l 0x00(a6,a1.l),d5
	moveq #0x46,d0
	bsr.w l069a4
l06aca:	movea.l (a6),a1
	move.l 0x0008(a6),d2
	sub.l a1,d2
	moveq #0x00,d3
	exg a0,a4
	tst.l d5
	ble.s l06ae0
	cmp.l d5,d2
	ble.s l06ae0
	move.l d5,d2
l06ae0:	tas 0x008f(a6)
	beq.s l06b1e
	moveq #0x03,d0
	trap #0x04
	trap #0x03
	cmpi.l #0xffffffff,d0
	bne.s l06afa
	tst.w d1
	beq.s l06ae0
	bra.s l06b0c

l06afa:	cmpi.l #0xfffffff6,d0
	bne.s l06b08
	moveq #0x00,d0
	tst.w d1
	beq.s l06b1e
l06b08:	tst.l d0
	bne.s l06b1e
l06b0c:	moveq #0x07,d0
	move.w d1,d2
	exg a0,a4
	suba.w d1,a1
	bsr.w l069a4
	bne.s l06b1e
	sub.l d2,d5
	bne.s l06aca
l06b1e:	bsr.s l06b22
l06b20:	exg a0,a4
l06b22:	bra.w l06986

lclose:
l06b26:	cmpa.l a3,a5
	ble.s l06b44
	tst.b 0x01(a6,a3.l)
	bpl.s l06b44
	jsr l065e6(pc)
	bne.s l06b42
	move.l #0xffffffff,0x00(a6,a2.l)
	moveq #0x02,d0
	trap #0x02
l06b42:	rts

l06b44:	moveq #-0x0f,d0
	bra.s l06b42

lopen:	moveq #0x00,d4
	bra.s l06b52

lopenin:	moveq #0x01,d4
	bra.s l06b52

lopennew:	moveq #0x02,d4
l06b52:	bsr.s l06b26
	tst.l d0
	beq.s l06b5e
	moveq #-0x06,d2
	cmp.l d0,d2
	bne.s l06b42
l06b5e:	exg d1,d6
	bsr.w l069c4
	exg d1,d6
	bne.s l06b42
	jmp l06646(pc)

lsave:	move.l a3,0x00b4(a6)
	moveq #0x02,d4
	bsr.w l069c4
	bne.s l06b42
	jsr l07484(pc)
	beq.s l06b22
	move.l d0,d4
	bsr.w l0699a
	bra.w l0698c

lfill:	jsr l065e6(pc)
	bne.s l06ba4
	jsr l061c2(pc)
	bne.s l06ba4
	move.l 0x00(a6,a1.l),d1
	addq.l #4,a1
	move.l a1,0x0058(a6)
	moveq #0x35,d0
	moveq #-0x01,d3
	trap #0x03
l06ba4:	rts

lunder:	move.b #0x2b,d4
	bra.s l06bb0

lflash:	move.b #0x2a,d4
l06bb0:	jsr l08038(pc)
	bne.s l06bc0
	jsr l08028(pc)
	bne.s l06bc0
l06bbc:	jmp l07fc4(pc)

l06bc0:	rts

lover:	jsr l08038(pc)
	bne.s l06bc0
	move.b #0x2c,d4
	move.w 0x00(a6,a1.l),d1
	cmpi.w #0x0001,d1
	bgt.s l06bdc
	cmpi.w #0xffff,d1
	bge.s l06bbc
l06bdc:	moveq #-0x0f,d0
	rts

l06be0:	bsr.w l06cb6
	jsr l061de(pc)
	bne.s l06bf2
	moveq #0x36,d0
	moveq #-0x01,d3
	trap #0x04
	trap #0x03
l06bf2:	bra.w l06cae

lscale:	moveq #0x34,d4
	bsr.w l06cb6
	bsr.w l06d42
	bsr.w l06d46
	bra.w l06c96

lpoint:	moveq #0x30,d4
	bra.s l06c10

lpointr:	move.w #0x00b0,d4
l06c10:	bsr.w l06cb6
	bsr.w l06d1c
	bra.s l06c96

lline:	moveq #0x31,d4
	bra.s l06c22

lliner:	move.w #0x00b1,d4
l06c22:	bsr.w l06cb6
	bsr.w l06d0a
	bne.s l06ca4
	bsr.w l06d1c
	bra.s l06c96

lcircle:
lellips:	moveq #0x33,d4
	bra.s l06c3a

lellipsr:
lcircler:
	move.w #0x00b3,d4
l06c3a:	bsr.s l06cb6
	bsr.w l06d1c
	bsr.w l06d46
	cmpi.b #0x01,d5
	bne.s l06c50
	bsr.w l06d42
	bra.s l06c68

l06c50:	subq.l #8,a1
	subq.l #4,a1
	clr.l 0x00(a6,a1.l)
	move.l #0x801,0x04(a6,a1.l)
	move.l #0x40000000,0x08(a6,a1.l)
l06c68:	movem.w 0x06(a6,a1.l),d0-d2
	move.w 0x0c(a6,a1.l),0x06(a6,a1.l)
	move.l 0x0e(a6,a1.l),0x08(a6,a1.l)
	movem.w d0-d2,0x0c(a6,a1.l)
	bra.s l06c96

larc:	moveq #0x32,d4
	bra.s l06c8a

larcr:	move.w #0xb2,d4
l06c8a:	bsr.s l06cb6
	bsr.s l06d0a
	bsr.w l06d1c
	bsr.w l06d46
l06c96:	move.l d4,d0
	swap d0
	bclr #0x07,d0
	moveq #-0x01,d3
	trap #0x04
	trap #0x03
l06ca4:	cmpa.l d6,a3
	bge.s l06cac
	move.l a4,-(a7)
	move.w d5,d4
l06cac:	moveq #0x00,d0
l06cae:	move.l d7,0x0058(a6)
	movea.l d7,a1
	rts

|* execution of graphic commands

l06cb6:	swap d4
	clr.w d4
	clr.w d5
	move.l 0x0058(a6),d7
	move.l a5,d6
	cmpa.l d6,a3
	blt.s l06cca
	moveq #-0x0f,d0
	bra.s l06d06

l06cca:	move.b 0x01(a6,a3.l),d0
	andi.b #0x0f,d0
	bne.s l06cdc
	jsr l07452(pc)
	move.w d5,d4
	bra.s l06cee

l06cdc:	btst #0x07,0x01(a6,a3.l)
	beq.s l06cee
	move.b 0x01(a6,a3.l),d4
	bclr #0x07,d4
	lsr.b #4,d4
l06cee:	jsr l065e6(pc)
	bne.s l06d06
	move.w #0x0100,d1
	jsr l04e4e(pc)
	move.l 0x0058(a6),d7
	movea.l d7,a1
	movea.l (a7),a4
	rts

l06d06:	addq.l #4,a7
	bra.s l06cae

l06d0a:	cmpi.b #0x05,d4
	bne.s l06d1c
	bsr.s l06d6e
	bsr.s l06d7e
	move.l a1,0x0058(a6)
	moveq #0x00,d0
	rts

l06d1c:	bsr.s l06d4c
	bne.s l06d06
	btst #0x17,d4
	beq.s l06d2c
	bsr.s l06d6e
	jsr l04838(pc)
l06d2c:	bsr.s l06d4c
	bne.s l06d06
	btst #0x17,d4
	beq.s l06d3c
	bsr.s l06d7e
	jsr l04838(pc)
l06d3c:	bsr.s l06d8e
	moveq #0x01,d0
	rts

l06d42:	bsr.s l06d4c
	bne.s l06d06
l06d46:	bsr.s l06d4c
	bne.s l06d06
	rts

l06d4c:	move.l a4,-(a7)
	cmpa.l d6,a3
	blt.s l06d56
	moveq #-0x0f,d0
	bra.s l06d6a

l06d56:	move.w d5,d4
	jsr l07452(pc)
	movea.l a3,a5
	jsr l05ec8(pc)
	bne.s l06d6a
	moveq #0x02,d0
	jsr l05996(pc)
l06d6a:	movea.l (a7)+,a4
	rts

l06d6e:	subq.w #6,a1
	move.l 0x0a(a6,a2.l),0x00(a6,a1.l)
	move.w 0x0e(a6,a2.l),0x04(a6,a1.l)
	rts

l06d7e:	subq.w #6,a1
	move.l 0x04(a6,a2.l),0x00(a6,a1.l)
	move.w 0x08(a6,a2.l),0x04(a6,a1.l)
	rts

l06d8e:	move.l 0x00(a6,a1.l),0x04(a6,a2.l)
	move.l 0x04(a6,a1.l),0x08(a6,a2.l)
	move.l 0x08(a6,a1.l),0x0c(a6,a2.l)
	rts

l06da2:	lea l06e22(pc),a1
l06da6:	movem.l d1-d2/d5-d7/a0/a2-a3,-(a7)
	moveq #0x08,d6
l06dac:	moveq #0x00,d7
	moveq #0x00,d5
	move.w (a1)+,d5
	lsl.l #3,d5
	move.l d5,d1
	move.l a1,-(a7)
	jsr l04e60(pc)
	move.l d5,d1
	jsr l04e72(pc)
	movea.l (a7)+,a3
l06dc4:	movea.l a3,a1
	move.w (a3)+,d0
	beq.s l06e0c
	adda.w d0,a1
	move.l a1,-(a7)
	move.b (a3)+,d5
	move.b d5,-(a7)
	move.b d6,-(a7)
	move.b d5,d1
	movea.l (a6),a1
l06dd8:	move.b (a3)+,0x00(a6,a1.l)
	addq.w #1,a1
	subq.b #1,d1
	bgt.s l06dd8
	move.l a3,-(a7)
	movea.l (a6),a3
	lea l08b5a(pc),a2
	movea.l (a2),a2
	jsr l08622(pc)
	bra.s l06e16
	movea.l (a7)+,a3
	move.b (a7)+,d6
	move.b (a7)+,d5
	move.l (a7)+,0x04(a6,a2.l)
	move.b d6,0x00(a6,a2.l)
	move.b d7,0x01(a6,a2.l)
	btst d7,d5
	bne.s l06dc4
	addq.w #1,a3
	bra.s l06dc4

l06e0c:	subq.w #8,d6
	bne.s l06e1c
	moveq #0x09,d6
	movea.l a3,a1
	bra.s l06dac

l06e16:	adda.w #0x000c,a7
	moveq #-0x0c,d0
l06e1c:	movem.l (a7)+,d1-d2/d5-d7/a0/a2-a3
	rts

|*****END BASIC2_ASM basic2_asm
