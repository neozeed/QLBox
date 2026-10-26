

|*******************************
|*
|*  BASIC1_ASM basic1_asm
|*
|*******************************

|* initialise basic, search for ROMS, display F1/F2 menu
l04a74:	bra.s l04aaa
.equ xl04a74, l04a74
l04a76:	cmpi.l #0x4afb0001,(a3)
	bne.s l04a9e
	lea 0x0008(a3),a1 | * number of commands
	jsr l039b2(pc) | * link in name table
	move.w 0x0004(a3),d0 | * number of functions
	beq.s l04a94
	lea 0x00(a3,d0.w),a1 | * list of functions
	jsr l06da6(pc)
l04a94:	move.w 0x0006(a3),d0 | * initialisation routine
	beq.s l04a9e | * no routine supplied
	jsr 0x00(a3,d0.w) | * init routine
l04a9e:	rts

l04aa0:	jsr l039f6(pc) | * install window
	move.l d4,d1 | * D1 = #
	jmp l06646(pc)

|* basic init
l04aaa:	jsr l0566e(pc)
	jsr l06da2(pc)
	lea l04bba(pc),a1 | * window def
	moveq #0x00,d4
	bsr.s l04aa0 | * init window 0
	lea 0x0c000,a3 | * ROM EXTENSION
	bsr.s l04a76 | * try to initialise extension
	movea.l #0xc0000,a3 | * EXTENSIONS at C0000 ff 
l04ac8:	bsr.s l04a76 | * SAME AS BEFORE
	adda.w #0x4000,a3 | * add 16 K
	cmpa.l #0xcc000,a3 | * till end of RAM

|*
|* !!! to avoid software - problems caused by bad decoding of ROM-port
|* hardware: - modification of ROM-Port 
|*           - or make sure to have no expansion at CC000
|* software: - omit the first test for C000 (is done when testing CC000)
|*           - or set top to $CC000 instead of $100000
|*         !!!! (t h a t ' s     w h a t    I  d i d   h e r e !)

	blt.s l04ac8
	lea l04bc6(pc),a1 | * WINDOW 1
	moveq #0x01,d4
	bsr.s l04aa0
	moveq #-0x19,d0 | * START-MESSAGE
	jsr l03968(pc)
l04ae4:	lea l04bd2(pc),a1 | * WINDOW 2
	moveq #0x02,d4
	bsr.s l04aa0
	moveq #-0x18,d0 | * F1-MONI ETC
	nop
	nop | suppress F1/F2 prompt
getmod:	jsr host_bootmode:l | default TV; --boot f1 selects monitor
	moveq #0x00,d6 | * INIT MODE 4
	moveq #0x00,d7
	moveq #0x20,d5
	subi.b #0xe8,d1 | * F1 ?
	beq.s inimon
	subq.b #0x4,d1 | * F2 ?
	bne.s getmod
	moveq #0x00,d6
	moveq #0x01,d7
	moveq #0x44,d5 | * d5=displacement for windows
inimon:	move.b d6,d1
	move.b d7,d2
	moveq #0x10,d0
	trap #0x01 | * SCREEN-INIT
	lea xl04b72-0x08(pc,d5.w),a1 | * #2 DEFI
	bsr.s l04b6e
	movea.l #0x00010001,a0
	lea xl04b72-0x14(pc,d5.w),a1 | * #1 DEFI
	bsr.s l04b6e
	suba.l a0,a0
	lea xl04b72-0x20(pc,d5.w),a1 | * #0 DEFI
	bsr.s l04b6e
	jsr host_start:l | graphical BOOT or text-mode job launcher
	beq.s l04b40 | * success
	moveq #-7,d0
	nop
	nop
	bne.s l04b52 | * nothing
l04b40:	clr.w 0x0088(a6) | * clear line-number
	bra.s l04b54

l04b46:	moveq #0x01,d0 | * try to open boot
	moveq #-0x01,d1
	moveq #0x00,d3
	trap #0x02
	tst.l d0
	rts

l04b52:	suba.l a0,a0 | * A0=0: no boot actioned
l04b54:	move.l (a6),0x0004(a6)
	moveq #0x00,d7
	moveq #0x7e,d1
	jsr l04e6a(pc)
	move.l a0,0x0084(a6)
	lea l04bf0(pc),a5
	move.l a5,-(a7)
l04b6a:	jmp l04c04(pc) | * try to execute line or prog

l04b6e:	jmp l03a02(pc)
l04b72:
.equ xl04b72, l04b72
|* Moni#0
	.byte 0x00, 0x00, 0x00, 0x04 | * size border/size colour/paper/ink
	.byte 0x02, 0x00, 0x00 ; .ascii "2" | * width hight
	.byte 0x00, 0x00, 0x00, 0xce | * origin horiz and verti
|* Moni#1       
	.byte 0xff, 0x01, 0x02, 0x07
	.byte 0x01, 0x00, 0x00, 0xca
	.byte 0x01, 0x00, 0x00, 0x00
|* Moni#2
	.byte 0xff, 0x01, 0x02, 0x07
	.byte 0x01, 0x00, 0x00, 0xca
	.byte 0x00, 0x00, 0x00, 0x00
|* TV#0
	.byte 0x00, 0x00, 0x00, 0x07
	.byte 0x01, 0xc0, 0x00 ; .ascii "("
	.byte 0x00 ; .ascii " " ; .byte 0x00, 0xd8
|*TV#1
	.byte 0x00, 0x00, 0x02, 0x07
	.byte 0x01, 0xc0, 0x00, 0xc8
	.byte 0x00 ; .ascii " " ; .byte 0x00, 0x10
|* TV#2     
	.byte 0x00, 0x00, 0x01, 0x07
	.byte 0x01, 0xc0, 0x00, 0xc8
	.byte 0x00 ; .ascii " " ; .byte 0x00, 0x10
|* init window
l04bba:	.byte 0x00, 0x00, 0x00, 0x04
	.byte 0x01, 0xc0, 0x00, 0xaa
	.byte 0x00 ; .ascii " " ; .byte 0x00 ; .ascii " "

|* copyright window
l04bc6:	.byte 0x07, 0x02, 0x02, 0x07
	.byte 0x01 ; .ascii "p" ; .byte 0x00, 0x0e
	.byte 0x00 ; .ascii "H" ; .byte 0x00, 0xee

|* window for extensions message
l04bd2:	.byte 0x04, 0x04, 0x07, 0x02
	.byte 0x00, 0xa8, 0x00, 0x1c
	.byte 0x00, 0xae, 0x00, 0xce

.balign 2, 0 ; l04bde:	.word 0x0004
	.ascii "BOOT"
.balign 2, 0 ; l04be4:	.word 0x0009
	.ascii "MDV1_BOOT"
	.byte 0x00

l04bf0:	jsr l0a9ba(pc) | * SYSTEM COMMAND
	lea l04bf0(pc),a5 | * 4BF0 - adrr fo errors
	move.l a5,-(a7)
l04bfa:	clr.l 0x0084(a6)
	moveq #0x00,d1
	jsr l0661e(pc)
l04c04:	clr.l 0x0076(a6)
	move.l (a6),0x0004(a6)
	tst.b 0x00aa(a6)
	beq.s l04c2c
	move.w 0x00ac(a6),d4
	move.w d4,d6
	sf 0x00ab(a6)
	jsr l07518(pc)
	move.w 0x00ae(a6),d0
	sne 0x00aa(a6)
	add.w d0,0x00ac(a6)
l04c2c:	move.l a0,d0
	jsr l079c4(pc)
	beq.s l04c64
	bgt.s l04c3c
	cmpi.b #0xf6,d0
	beq.s l04c50
l04c3c:	sf 0x00aa(a6)
	jsr l09b9c(pc) | * error-report
l04c44:	bsr.w l04cfa
	beq.s l04c4e
	moveq #0x02,d0
	trap #0x02
l04c4e:	bra.s l04bfa

l04c50:	moveq #0x02,d0 | * CLOSE MDV1_BOOT
	trap #0x02
	clr.l 0x0084(a6) | * command channel=0
	tst.w 0x0088(a6) | * LINE TO EXECUTE ?
	blt.w l04d6a | * NO
	bra.w l04d9e | * YES

l04c64:	tas 0x008f(a6) | * initialise BREAK
	move.l a1,d1
	sub.l (a6),d1
	sf 0x00b9(a6) | * BV.ARROW
	move.b -0x01(a6,a1.l),d0
	subi.b #0xd0,d0
	bcs.s l04c86
	st 0x00b9(a6) | * BV.ARROW
	beq.s l04c86
	move.b #0x01,0x00b9(a6)
l04c86:	subq.w #1,d1
	ble.w l04c04
	cmpi.b #0x20,-0x02(a6,a1.l)
	bne.s l04c98
	subq.w #1,a1
	bra.s l04c86

l04c98:	move.b #0x0a,-0x01(a6,a1.l)
	move.l a1,0x0004(a6)
l04ca2:	jsr l0890c(pc)
	lea l08b5a(pc),a2
	jsr l087d4(pc)
	beq.s l04cd0
	blt.s l04cb8
	jsr l097dc(pc)
	bra.s l04ca2

|* error handling of direct commands

l04cb8:	tst.l 0x0084(a6) | * was it # 0
	bne.s l04ccc
	moveq #-0x15,d0 | * report bad line
	jsr l09b9c(pc)
	subq.l #1,0x0004(a6)
	bra.w l04c2c | * edit offending line

|* error handling of direct input from other # than 0
l04ccc:	jsr l08a4e(pc)
l04cd0:	jsr l08ab4(pc)
	jsr l08e88(pc)
	bra.s l04d02 | * ERROR
	sf 0x006f(a6)
	st 0x008e(a6)
	move.l d0,d5
	bsr.s l04cfa
	bne.w l04c04
	moveq #0x02,d1
	jsr l0661e(pc)
	blt.s l04cf6
	jsr l08fe6(pc)
l04cf6:	bra.w l04bfa

|* get input #

l04cfa:	movea.l 0x0084(a6),a0
	move.l a0,d0
	rts

|* supervisor for direct commands
|* enter command mode
l04d02:	movea.l 0x0008(a6),a4 | * BV.TKBAS
	move.b #0x01,0x006c(a6) | * BV.STMNT
	sf 0x006e(a6) | * BV.INLIN
	st 0x006d(a6) | * BV.CONT
l04d14:	st 0x006f(a6) | * BV.SING
	clr.l 0x0068(a6) | * BV.LINUM
	jsr l0a4ba(pc)
	jsr l0a8b8(pc)
	bne.w l04c44
	tst.b 0x008b(a6) | * BV.COMLN
	beq.s l04d5e
	subq.w #4,0x008c(a6) | * BV.STOPN
	beq.s l04cf6
	blt.s l04d14
	movea.l 0x0008(a6),a0 | * BV.TKBAS
	move.l 0x000c(a6),d0 | * BV.TKTOP
	suba.l a0,a4
	sub.l a0,d0
	move.l d0,d1
	suba.l d0,a7
l04d46:	move.w 0x00(a6,a0.l),(a7)+
	addq.w #2,a0
	subq.w #2,d1
	bgt.s l04d46
	suba.l d0,a7
	move.w d0,-(a7)
	move.w a4,-(a7)
	move.b 0x006c(a6),-(a7)
	move.l 0x006e(a6),-(a7)
l04d5e:	tst.w 0x0088(a6)
	bge.s l04d98
	bsr.s l04cfa
l04d66:	bne.w l04c04
l04d6a:	tst.b 0x008b(a6)
	beq.s l04cf6
	sf 0x008b(a6)
	move.l (a7)+,0x006e(a6)
	move.b (a7)+,0x006c(a6)
	movea.l 0x0008(a6),a0
	movea.l a0,a4
	adda.w (a7)+,a4
	move.w (a7)+,d0
l04d86:	move.w (a7)+,0x00(a6,a0.l)
	addq.w #2,a0
	subq.w #2,d0
	bgt.s l04d86
	move.l a0,0x000c(a6)
	bra.w l04d14

|* execution of Basic progs

l04d98:	bsr.w l04cfa | * store channel ID
	bne.s l04d66 | * not #0
l04d9e:	jsr l0a4ba(pc) | * init variables and procs
	movea.l 0x0010(a6),a4 | * BV.PFBAS
	sf 0x006f(a6)
	clr.l 0x0068(a6)
	move.b #0x01,0x006c(a6)
	move.w 0x0088(a6),d4
	beq.s l04dd6
	jsr l09fbe(pc)
	bne.w l04bfa
	move.b 0x008a(a6),d4
	beq.s l04dd6
	jsr l0a96a(pc) | * first instruction in line
	jsr l0a00a(pc)
l04dd0:	jsr l0a90c(pc) | * execute prog
	bra.s l04dda

l04dd6:	jsr l0a8a8(pc) | * execute prog
l04dda:	bne.w l04bfa | * error or end
	tst.w 0x008c(a6) | * system command ?
	bne.w l04d5e | * no
	bra.s l04dd0 | * continue

|* !! only once needed ??? !!!

l04de8:	jsr l04e5e(pc) | * reserve memory for name table entry
	movea.l 0x001c(a6),a2
	addq.l #8,0x001c(a6)
	rts

l04df6:	move.l d1,-(a7) | * reserve memory for variables
	addq.l #7,d1
	andi.w #0xfff8,d1
l04dfe:	movea.w #0x0072,a0
	moveq #0x0c,d0
	trap #0x01
	tst.l d0
	blt.s l04e0c | * memory insufficient
	bra.s l04e26

l04e0c:	move.l d1,-(a7)
	jsr l04e76(pc)
	movea.l 0x002c(a6),a0
	add.l d1,0x002c(a6)
	movea.w #0x0072,a1
	moveq #0x0d,d0
	trap #0x01
	move.l (a7)+,d1
	bra.s l04dfe

l04e26:	move.l (a7)+,d1
	rts

.balign 2, 0 ; l04e2a:	.word 0x0100 | * table for memory reservation
.balign 2, 0 ; 	.word 0x0100
.balign 2, 0 ; 	.word 0x0100
.balign 2, 0 ; 	.word 0x0100

|* !!! table above and command below are fuzzy - in all cases same amount
|* of memory is reserved so it can be shortened - instead of 
|* first four lines only move.l #$0100,d1 would be sufficient !!!

l04e32:	lea l04e2a(pc),a1
	add.w d0,d0
	moveq #0x00,d1
	move.w 0x00(a1,d0.w),d1 | * fuzzy
	moveq #0x60,d2
	move.l a7,0x0060(a6)
	move.l a6,d0
	sub.l d0,0x0060(a6)
	bra.s l04e90 | * reserve 256 bytes

l04e4c:	moveq #0x20,d1 | * reserve 32 bytes artihm stack
l04e4e:	moveq #0x58,d2
	bra.s l04e90

l04e52:	moveq #0x0c,d1 | * 12 Bytes on stack
l04e54:	moveq #0x48,d2
	bra.s l04e90

|* !!! only once needed ??? !!! - YES! AVOID JSR

l04e58:	moveq #4,d1 | * reserve 4 BYTES
l04e5a:	moveq #0x50,d2
	bra.s l04e90

l04e5e:	moveq #0x08,d1
l04e60:	moveq #0x1c,d2
	bra.s l04e84

|* !!! only once needed ??? !!! - YES! AVOID JSR

l04e64:	moveq #0x16,d1
	moveq #0x3c,d2
	bra.s l04e84

l04e6a:	moveq #0x04,d2
	bra.s l04e84

|* !!! only once needed ??? !!! - YES! AVOID JSR

l04e6e:	moveq #0x0c,d2
	bra.s l04e84

l04e72:	moveq #0x24,d2
	bra.s l04e84

|* !!! only once needed ??? !!! - YES! AVOID JSR

l04e76:	moveq #0x2c,d2
	bra.s l04e84

|* !!! only once needed ??? !!! - YES! AVOID JSR

l04e7a:	moveq #0x34,d2
	bra.s l04e84

|* !!! only once needed ??? !!! - YES! AVOID JSR
l04e7e:	moveq #0x44,d2
	bra.s l04e84

l04e82:	moveq #0x14,d2
l04e84:	moveq #0x00,d0
	move.l 0x04(a6,d2.l),d3
	sub.l 0x00(a6,d2.l),d3
	bra.s l04e9a

|* RESERVE MEMORY ON BASE OF STACK

l04e90:	moveq #-0x01,d0
	move.l 0x00(a6,d2.l),d3
	sub.l -0x04(a6,d2.l),d3
l04e9a:	cmp.l d1,d3 | * enough memory for reservation
	bge.s l04ee2
	movem.l a0-a3,-(a7)
	addi.l #0xf,d1
	andi.w #0xfff0,d1
l04eac:	move.l 0x0048(a6),d3
	sub.l 0x0044(a6),d3
	cmp.l d1,d3
	bgt.s l04f14
	movem.l d0-d2,-(a7)
	moveq #0x16,d0
	trap #0x01
	tst.l d0
	beq.s l04ee4
	move.w #0x0012,0x008c(a6)
	trap #0x00
	movea.l 0x0064(a6),a5
	adda.l a6,a5
	suba.l 0x0076(a6),a5
	subq.w #4,a5
	move.l a5,usp
	move.w #0x0004,sr
	sf 0x006d(a6)
l04ee2:	rts

l04ee4:	movea.l 0x0048(a6),a0
	movea.l 0x0064(a6),a1
	lea 0x00(a1,d1.l),a2
l04ef0:	subq.w #4,a2
	subq.w #4,a1
	move.l 0x00(a6,a1.l),0x00(a6,a2.l)
	cmpa.l a0,a1
	bgt.s l04ef0
	moveq #0x48,d0
	moveq #0x64,d2
l04f02:	add.l d1,0x00(a6,d0.l)
	addq.w #4,d0
	cmp.l d2,d0
	ble.s l04f02
	adda.l d1,a7
	movem.l (a7)+,d0-d2
	bra.s l04eac

l04f14:	tst.b d0
	bmi.s l04f54
	cmpi.l #0x44,d2
	beq.s l04f84
	movea.l 0x44(a6),a1
	movea.l 0x04(a6,d2.l),a0
	lea 0x00(a1,d1.l),a2
l04f2c:	subq.w #4,a1
	subq.w #4,a2
	move.l 0x00(a6,a1.l),0x00(a6,a2.l)
	cmpa.l a0,a1
	bgt.s l04f2c
	moveq #0x04,d0
	add.w d2,d0
	moveq #0x48,d2
	tst.l 0x0072(a6)
	beq.s l04f7a
	cmpi.l #0x28,d0
	bgt.s l04f7a
	add.l d1,0x0072(a6)
	bra.s l04f7a

l04f54:	cmpi.l #0x48,d2
	beq.s l04f84
	movea.l -0x04(a6,d2.l),a1
	movea.l 0x0048(a6),a0
	neg.l d1
	lea 0x00(a0,d1.l),a2
l04f6a:	move.l 0x00(a6,a0.l),0x00(a6,a2.l)
	addq.w #4,a0
	addq.w #4,a2
	cmpa.l a1,a0
	ble.s l04f6a
	moveq #0x48,d0
l04f7a:	add.l d1,0x00(a6,d0.l)
	addq.w #4,d0
	cmp.l d2,d0
	blt.s l04f7a
l04f84:	movem.l (a7)+,a0-a3
	rts

l04f8a:	moveq #0x14,d2
	bra.s l04fa0

l04f8e:	moveq #0x24,d2
	bra.s l04fa0

l04f92:	moveq #0x1c,d2
	bra.s l04fa0

l04f96:	moveq #0x2c,d2
	bra.s l04fa0

l04f9a:	moveq #0x34,d2
	bra.s l04fa0

l04f9e:	moveq #0x3c,d2
l04fa0:	movea.l 0x04(a6,d2.l),a1
	move.l a1,d1
	move.l 0x00(a6,d2.l),d0
	addq.w #1,d0
	bclr #0x00,d0
	movea.l d0,a0
	sub.l a0,d1
	beq.s l04fe6
l04fb6:	move.l 0x00(a6,a1.l),0x00(a6,a0.l)
	addq.w #4,a1
	addq.w #4,a0
	cmpa.l 0x0044(a6),a1
	blt.s l04fb6
	moveq #0x04,d0
	add.b d2,d0
	tst.l 0x0072(a6)
	beq.s l04fda
	cmpi.b #0x28,d2
	bge.s l04fda
	sub.l d1,0x0072(a6)
l04fda:	moveq #0x48,d2
l04fdc:	sub.l d1,0x00(a6,d0.l)
	addq.b #4,d0
	cmp.b d2,d0
	blt.s l04fdc
l04fe6:	rts

l04fe8:	addq.l #7,d1
	andi.l #0xfffffff8,d1
	beq.s l04ffa
	movea.w #0x0072,a1
	moveq #0x0d,d0
	trap #0x01
l04ffa:	rts

.balign 2, 0 ; l04ffc:	.word 0x4e75
.balign 2, 0 ; 	.word 0x0000
|***End BASIC1_ASM  basic1_asm
