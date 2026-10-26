|*                   JS - DISASSEMBLY
|*
|* ---------------------------------------------------------------
|* THIS VERSION CONTAINS IN BASIC3_ASM CORRECTIONS THAT HAVE BEEN
|* NECESSARY - SORRY I SELDOM USE BASIC, THAT'S WHY I DID NOT NOTICE
|* THE BUGS - LOCATION: L08B2A  L0932E  L08DAA
|* ALL CORRECTIONS ARE MARKED WITH !!! CORRECTED
|*
|* SOME ADDITIONAL COMMENTS HAVE BEEN MADE - YET THERE'S FEW
|* OF THEM!!
|* I hope that this disassembly is correct - if you find any faults:
|* Drop me a line. 
|* BY INTENSIVE TESTING OF OWN CODE I COULD FIND NO BUG -
|* BUT OF COURSE IT'S IMPOSSIBLE TO TEST ANY CONFIGURATION
|* THOUGH THERE MIGHT BE SOMEWHERE A WRONG DEFINITION THAT WILL
|* BE NOTICED ONLY, IF YOU HAPPEN TO INSERT JUST THERE SOME CODE.
|* IN FACT, I'M QUITE SURE THAT NOW EVERYTHING IS WORKING IN ANY 
|* CONIGURATION IF YOU KEEP IN MIND THAT SOME CODE RETURNS WITH
|* MANIPLUATED STACK - SEE ADDER ON MDV-VECTORS: THERE ARE THREE
|* POSSIBLE REUTRNS SOMETIMES.
|* Don't write to me with 'just one question' on details.
|* I think the disassembly is enough work.
|*
|* The disassembly is poorly commented - but those who will be
|* working with it, know what they are doing anyhow!
|*
|*                   IMPORTANT
|*
|* The disassembly is for private use only.
|* Any commercial usage is  N O T  allowed.
|* QDOS is copyright by SINCLAIR / ARMSTRAD!!!!
|*
|* Even TONY TEBBY was not allowed to use his QDOS on his
|* FUTURA project. He had to rewrite QDOS!
|*
|* It is evident, that nobody else may use QDOS commercial when even
|* he was not entitled to use it.
|*
|* I was offered to use this disassembly comercial. 
|*                I refused to do so.
|* 
|* Only fools (!!) will try to market any part of this disassembly.
|*
|* ---------------------------------------------------------------------
|* ---------------------------------------------------------------------
|*            How to use this disassembly
|*
|* LOOK and learn from it - you own programming technique might profit.
|*
|* Don't write progs that access direct the ROM.
|*
|* Use the defined TRAPS and VECTORS.
|*
|* If you want to change things ½ hope that you know what you are doing
|* 
|* REASSEMBLY ONLY WITH GST MACRO ASSEMBLER POSSIBLE
|* Minimum configuration: 256 K memory expansion + diskdrive
|*
|* USE OPTION -NOLIST OR YOU WILL RUN OUT OF DISKSPACE
|* 
|* ESSENTIAL FOR UNDERSTANDING: ADDER "QL ADVANCED USER GUIDE"
|* REFFERENCES TO THIS BOOK IN MY COMMENTS AS ½Adder 
|* ---------------------------------------------------------------
|* 
|* Please note: all values that I've been redifinig for use as Labels
|* have significant names: XL-labels are labels that are defined by
|* using an EQU somewhere in the Prog.
|* Tr -labels are labels for TRAPS e.g. 
|* Tr1d03 is label of Trap 1 with d0=3
|* Tr3d12 is label of Trap 3 with d0=$12
|* labels that start with 'o' have been installed for 
|* my own use during the disassembly-work
|* any critical comments are marked with '!!'
|* any doubts - yes there are some - are marked with '?'
|*
|* SOME comments might be silly - but have been of any value for
|* me when I did the disassembly. I don't want to put them out
|* you can enjoy them or erase them as you like.
|*
|* FOR TESTING PURPOSES I'VE ADDED SOME 'NOP' TO PREVENT THAT
|* THE GST-MACRO ASSEMBLER PRODUCES SHORTER CODE - MOST NOP's MIGHT
|* BE OMITTED - DO IT YOURSELF - But: Control it thoroughfully:
|* Especially in BASIC and MDV-routines returns form subroutines
|* manipulate the Stack(a7). Changing code could mean that
|* the adress for Return was wrong.
|* 
|* YOU WILL FIND INCLUDED EVEN KEYBOARD_ASM FOR MGG VERSION
|* THE JM_MDV_ROUTINES MIGHT NEED SOME MODIFICATIONS
|* IT'S JUST AN ATTEMPT TO REPLACE THE UNNECESSARY LONG JS-
|* ROUTINES.
|* BUT: THE JM-ROUTINES MIGHT HAVE A BUG. SO TRY IT WITH
|* CAUTION. 
|* ON TRA_TAB: SINCE I WORK ON MY QL WITH EPROMS AND LOST MY ORIGINAL
|* JS-FILE IT MIGHT BE WORTH, ADAPTING THAT PIECE OF BYTES EXACTLS
|* TO YOUR PRINTER. AS IT IS, IT WORKS PERFECTLY WELL WITH THE 
|* BROTHER EP 44 PRINTER IN T/W MODE - AT LEAST WITH THE VERSION THAT
|* HAS BEEN DELIVERED IN SWITZERLAND.
|* 
|* 
|* MY ADRESS:
|*             WOLFGANG GOELLER
|*             ROSENSTR. 21
|*             CH 8105 REGENSDORF
|*             SWITZERLAND
|*

	.global xl0016a ; .org 0x00, 0
	| nolist (no emitted bytes)
.balign 2, 0 ; 	.long 0x00030000 | * RESET supervisor-stack
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word xl0016a | * RESET prog - start
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word xl0005c | * bus error
.balign 2, 0 ; 	.long 0x00000028 | * adress - error
.balign 2, 0 ; 	.long 0x0000002a | * ilegal instruction
.balign 2, 0 ; 	.long 0x0000002c | * divison by zero
.balign 2, 0 ; 	.long 0x0000002e | * CHK-instruction
.balign 2, 0 ; 	.long 0x00000030 | * TRAPV
.balign 2, 0 ; 	.long 0x00000032 | * privilege violation
.balign 2, 0 ; 	.long 0x00000034 | * trace
o028:	bsr.s l00050 | * 1010-  trap * dc.l $61266124
o02a:	bsr.s l00050
o02c:	bsr.s l00050 | * 1111-  trap * dc.l $61226120
o02e:	bsr.s l00050
o030:	bsr.s l00050
o032:	bsr.s l00050
o034:	bsr.s l00050
o036:	bsr.s l00050
o038:	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
	bsr.s l00050
.balign 2, 0 ; 	.word 0x0000
l00050:	bra.w l0013c | * Test Interrupt
l00054:	subi.l #0x0000002a,(a7)+ | * suppress Backaddr
	bne.s l0005e | * erroradress 
l0005c:	addq.w #8,a7 | * yes: restore backaddr. 

.equ xl0005c, l0005c

l0005e:	rte
.balign 2, 0 ; oo60:	.long l0005e | * 
.balign 2, 0 ; oo64:	.long l0005e | *  interrupt L1
.balign 2, 0 ; oo68:	.long xl00352 | *            L2
.balign 2, 0 ; oo6c:	.long l0005e
.balign 2, 0 ; oo70:	.long l0005e
.balign 2, 0 ; oo74:	.long l0005e
.balign 2, 0 ; oo78:	.long l0005e
.balign 2, 0 ; oo7c:	.long 0x00000036 | *  ...       L7
.balign 2, 0 ; oo80:	.long xltrap0
.balign 2, 0 ; oo84:	.long xltrap1
.balign 2, 0 ; oo88:	.long xltrap2
.balign 2, 0 ; oo8c:	.long xltrap3
.balign 2, 0 ; oo90:	.long xltrap4
.balign 2, 0 ; 	.long 0x00000038 | * vectors for Trap 5 - 15
.balign 2, 0 ; oo98:	.long 0x0000003a
.balign 2, 0 ; oo9c:	.long 0x0000003c
.balign 2, 0 ; ooa0:	.long 0x0000003e
.balign 2, 0 ; ooa4:	.long 0x00000040
.balign 2, 0 ; ooa8:	.long 0x00000042
.balign 2, 0 ; ooac:	.long 0x00000044
.balign 2, 0 ; oob0:	.long 0x00000046
.balign 2, 0 ; oob4:	.long 0x00000048
.balign 2, 0 ; l000b8:	.long 0x0000004a
.balign 2, 0 ; 	.long 0x0000004c
.balign 2, 0 ; ooc0:	.word l02fae | * MM.ALCHP
.balign 2, 0 ; 	.word l0305e | * MM.RECHP
.balign 2, 0 ; ooc4:	.word l039f2 | * UT.WINDW
.balign 2, 0 ; 	.word l039f6 | * UT.CON
.balign 2, 0 ; ooc8:	.word l039fc | * UT.SCR
.balign 2, 0 ; 	.word l0395e | * UT.ERR0
.balign 2, 0 ; oocc:	.word l03968 | * UT.ERR
.balign 2, 0 ; 	.word l03990 | * UT.MINT
.balign 2, 0 ; ood0:	.word l039b2 | * UT.MTEXT
.balign 2, 0 ; 	.word l039dc | * UT.LINK
.balign 2, 0 ; ood4:	.word l039e2 | * UT.UNLNK
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; od8:	.word l03104 | * MM.ALLOC
.balign 2, 0 ; 	.word l03162 | * MM.LINKFR
.balign 2, 0 ; odc:	.word l037f4 | * IO.QSET
.balign 2, 0 ; 	.word l0380a | * IO.QTEST
.balign 2, 0 ; oe0:	.word l03838 | * IO.QIN
.balign 2, 0 ; 	.word l0385e | * IO.QOUT
.balign 2, 0 ; oe4:	.word l03888 | * IO.QEOF
.balign 2, 0 ; 	.word l03a9c | * UT.CSTR
.balign 2, 0 ; oe8:	.word l037cc | * IO.SERQ
.balign 2, 0 ; 	.word l0388c | * IO.SERIO
.balign 2, 0 ; oec:	.word l0405e | * CN.DATE
.balign 2, 0 ; 	.word l040be | * CN.DAY
.balign 2, 0 ; of0:	.word l03ef6 | * CN.FTOD
.balign 2, 0 ; 	.word l03e54 | * CN.ITOD
.balign 2, 0 ; l000f4:	.word l03edc | * CN.ITOBB
.balign 2, 0 ; 	.word l03ed8 | * CN.ITOBW
.balign 2, 0 ; 	.word l03ed4 | * CN.ITOBL
.balign 2, 0 ; 	.word l03eb0 | * CN.ITOHB
.balign 2, 0 ; l000fc:	.word l03eac | * CN.ITOHW
.balign 2, 0 ; 	.word l03ea8 | * CN.ITOHL
.balign 2, 0 ; o00100:	.word l03d16 | * CN.DTOF
.balign 2, 0 ; 	.word l03dc2 | * CN.DTOI
.balign 2, 0 ; o104:	.word l03e34 | * CN.BTOIB
.balign 2, 0 ; 	.word l03e38 | * CN.BTOIW
.balign 2, 0 ; o108:	.word l03e3c | * CN.BTOIL
.balign 2, 0 ; 	.word l03dd4 | * CN.HTOIB
.balign 2, 0 ; o10c:	.word l03dd8 | * CN.HTOIW
.balign 2, 0 ; 	.word l03ddc | * CN.HTOIL
.balign 2, 0 ; o110:	.word l06da6 | * BP.INIT
.balign 2, 0 ; 	.word l061da | * CA.GTINT
.balign 2, 0 ; 	.word l061de | * CA.GTFP
.balign 2, 0 ; 	.word l061d6 | * CA.GTSTR
.balign 2, 0 ; 	.word l061e2 | * CA.GTLIN
.balign 2, 0 ; 	.word l04e4e | * BV.CHRIX
.balign 2, 0 ; 	.word l041ac | * RI.EXEC
.balign 2, 0 ; 	.word l041b4 | * RI.EXECB
.balign 2, 0 ; 	.word l072c2 | * BP.LET
.balign 2, 0 ; o00122:	.word l0372c | * IO.DECODE
|* from now on: add $4000 to get the correct adress 
|* refer to Adder ½ vectors 124 ff

.balign 2, 0 ; o00124:	.word xl0125c | * MD.READ  - 525C
.balign 2, 0 ; 	.word xl011b0 | * MD.WRITE - 51B0
.balign 2, 0 ; 	.word xl01262 | * MD.VERIN - 5262
.balign 2, 0 ; 	.word xl0123a | * MD.SECTR - 523A
.balign 2, 0 ; 	.word xl047d4 | * BASIC SYNTAX ANALYSER               - 87D4
.balign 2, 0 ; 	.word xl04b5a | * FIRST SYNTAX TABLE - COMMANDS       - 8B5A
|* next adress is odd!! don't mistrust - it is really odd !!!
.balign 2, 0 ; 	.word xl04ce7 | * SECOND SYNTAX TABLE - EXPRESSIONS   - 8CE7
.balign 2, 0 ; 	.word xl04ab4 | * FORMAT PRECOMPILED BASIC LINE       - 8AB4
.balign 2, 0 ; 	.word xl04a4e | * ERROR WHEN COMPILING                - 8A4E
.balign 2, 0 ; 	.word xl04e88 | * STORE PRECOMPILE LINE               - 8E88
.balign 2, 0 ; 	.word xl03518 | * CONVERT PRECOMPILED BASIC TO ASCII  - 7518
.balign 2, 0 ; 	.word xl0490c | * INITIALISE BASIC STACKS             - 890C

l0013c:	tst.l 0x00028050 | * Test for redirection
	beq.w l00054 | * no
	move.l a6,-(a7) | * a6 on stack
	movea.w 0x0006(a7),a6 | *  
	adda.w a6,a6
	adda.l 0x00028050,a6 | * a6 pointer to redirect-routine
	move.l (a6),0x0004(a7)
	movea.l (a7)+,a6 | * restore a6
	rts

ramerror:
l0015c:	movea.l a3,a5 | * endless loop
l0015e:	move.w d7,(a5)+
	cmpa.l #0x00028000,a5
	bne.s l0015e
	bra.s l0015c

|* start QL init/reset
l0016a:
.equ xl0016a, l0016a
 movea.l 0x18110:l,a5 | host-provided RAM top; no destructive RAM test
 lea 0x20000:l,a0
qlbox_clear_ram:
 clr.l (a0)+
 cmpa.l a5,a0
 bne.s qlbox_clear_ram
 bra.s qlbox_init_continue
 .org 0x1cc,0
qlbox_init_continue:
	move.l #xl04a74,a1 | * Startadress of BASIC
	lea 0x00028000,a6 | * Startadress of sysvars
	lea 0x0480(a6),a7 | * top of suerivsor-stack
	lea 0x00018020,a3 | * statusregister of 8049
	move.b #0x08,0x0043(a3) | * initialise 8049 to mode 8
	sf -0x001e(a3)
	move.l #0x061f0000,(a3) | * initialise MDV
	move.b #0x1f,0x0001(a3)
	move.b #0x01,-0x001d(a3)
	move.b #0xc0,0x0035(a6)
	jsr l02c50(pc) | * stop mdv-motor
	move.w #0xd254,(a6) | * mark start of RAM
	move.l a5,0x0020(a6) | * A5=Ramtop
	suba.l #0x00000000,a5 | * !!! this makes hardly a sense
|* might be, that there was a change intended to have different
|* values for ramtop and base of resident procs
	move.l a5,0x001c(a6) | * base of resident procs
	move.l a5,0x0014(a6) | * base of transient procs
	move.l 0x0020(a6),d0 | * !!! look for previous comment !!
|* as the ROM is now A5 still is the same as 20(A6) but if value
|* of A5 would have been changed this was correct.
	sub.l a6,d0 | * ramtop-$2800 /64
	lsr.l #6,d0
	movea.l a7,a3 | * A3 = pointer ro supervisor stack
	lea 0x0054(a6),a4 | * A4 = SV.BPNT
	bsr.s l00250 | * initialise table of slave-blocks
	lsr.l #1,d0
	add.l d0,0x0054(a6)
	lsr.l #2,d0 | * D0 now ramtop-$2800/512
	addi.l #0x20,d0
	cmpi.w #0x01e0,d0 | * compare wit 480
	bls.s l00246 | * if less - use that value
	move.w #0x01e0,d0 | * if more: use only 480 (=$1E0)
l00246:	bsr.s l00250 | * init job table
	mulu #0x0003,d0 | * initalise table of channels
	bsr.s l00250
	bra.s l0025c

l00250:	move.l a3,(a4)+ | * initialising-routine
	move.l a3,(a4)+
	adda.w d0,a3
	move.l a3,(a4)+
	addq.w #4,a4
	rts

l0025c:	move.l a3,d0 | * init system variables
	sub.l a6,d0
	lsr.l #6,d0
	movea.l d0,a4
	adda.l a7,a4
	movea.l 0x005c(a6),a3 | * A3 = pointer to top of slave-blocks
	move.w #0x0200,d1 | * !!! the shortform of this two commands:
	lsr.w #6,d1 | * !!! MOVE.W #8,D1 - since I don't know
|* another part in ROM calling this routine MOVEQ #8,D1 was better
	suba.w d1,a3 | * !!! best: SUBQ.W #8,A3 / A3 = SV.BTPNT
	moveq #0x01,d0
l00274:	move.b d0,(a4) | * PLACE 0100 0000 0000 0000 in all
	addq.w #8,a4 | * slaveblock tables
	cmpa.l a3,a4
	blt.s l00274
	movea.l 0x0068(a6),a4 | * SV.JBBAS base of Job table
	movea.l 0x007c(a6),a3 | * SV.JBTOP
	moveq #-0x01,d0
l00286:	move.b d0,(a4) | * place FF00 0000 0000 0000 in all
	addq.w #4,a4 | * job and channel tables
	cmpa.l a3,a4
	blt.s l00286
	move.l a3,0x0004(a6) | * SV.CHEAP
	move.l a3,0x000c(a6) | * SV.FREE
	movea.l 0x001c(a6),a4 | * SV.RESPR
	lea -0x0200(a4),a4 | * ADRESS IF RAMTOP-512
	move.l a4,0x0010(a6) | * BASE OF BASIC STACK
	lea l02cf8(pc),a5 | * start of polled task
	move.l a5,0x003c(a6) | * SV.PLIST
	lea l01202(pc),a5
	move.l a5,0x0040(a6) | * SV.SHLIST
	move.l #host_driver,0x0044(a6)

	move.l #host_file_driver,0x0048(a6) | directory-driver identity for host files

	addq.b #1,0x0037(a6) | * network station nr. default 1
	addq.b #8,0x0034(a6) | * mode 8
	addq.b #1,0x00a0(a6) | * ULA TRANSMIT MODE
	addq.w #1,0x00a8(a6) | * SV.TIMVOV baud rate=9600
	move.w #0x001e,0x008c(a6) | * autorepeat delay
	addq.w #2,0x008e(a6) | * autorepeat frequency
	addq.w #3,0x0092(a6) | * 
	move.l 0xbfe6,0x014a(a6) | * BOOT-MESS ETC.
	move.l 0xbfe2,0x0146(a6) | * TRA-TABELLE
	movea.l 0x0068(a6),a4 | * SV.JBBAS
	move.l a4,0x0064(a6) | * SV.JBPNT
	movea.l 0x0014(a6),a3 | * SV.TRNSP
	clr.l -(a3) | * RAMTOP = 0
	movea.l 0x0010(a6),a0 | * SV.BASIC
	move.l a0,(a4) | * ADRESS OF JOB 0: BASIC
	move.b #0x20,0x0013(a0) | * jobs priority increment
	move.l a3,usp | * pointer of userstack=ramtop-4
	lea 0x0068(a0),a6 | * SV.JBBAS 
	movea.l a3,a5
	suba.l a6,a5 | * a5 = zone for basic
	move.w #0x0000,sr | * now user-mode
	jmp (a1) | * A1 = XL04A74=BASIC-START
|*                              find init roms, display F1/F2, do basic

ltrap0:	addq.w #2,a7 | * decrement user stack
	rts

.equ xltrap0, ltrap0
ltrap1:	bsr.s l00336 | * initialise A5 and A6
	bra.w l00460 | * Trap 1 continues
.equ xltrap1, ltrap1
ltrap2:	bsr.s l00336 | * initialise A5 and A6
	bra.w l032a2 | * Trap2 continues
.equ xltrap2, ltrap2
ltrap3:	bsr.s l00336 | * initialise A5 and A6
	bra.w l0337c | * Trap3 continues
.equ xltrap3, ltrap3
ltrap4:	bsr.s l00336 | * initialise A5 and A6
	bra.w l03432 | * Trap4 continues
.equ xltrap4, ltrap4

l00336:	subq.w #8,a7 | * initialise of A5 and A6
	move.l 0x0008(a7),-(a7)
	movem.l d7/a5-a6,0x0004(a7)
	movea.l #0x00028000,a6
	lea 0x0004(a7),a5
	moveq #0x7f,d7
	and.l d7,d0
	rts

l00352:	movem.l d7/a5-a6,-(a7) | *#: ext2int entry
.equ xl00352, l00352
	movea.l a7,a5
	movea.l #0x00028000,a6
	move.b 0x00018021,d7
	lsr.b #1,d7
	bcs.w l02abc
	lsr.b #1,d7
	bcs.w l02ccc | * 8049 interrupt
	lsr.b #1,d7
	bcs.w l02cd8
	lsr.b #1,d7
	bcs.w l00900 | * do poll loop
	lsr.b #1,d7
	bcc.s l003a0
	movem.l d0-d6/a0-a4,-(a7)
	moveq #0x00,d0
	movea.l 0x0038(a6),a0 | * interrupt list
	jsr l00a9e(pc) | * execute interrupt tasks
	move.b 0x0035(a6),d7
	ori.b #0x10,d7
	move.b d7,0x00018021
	movem.l (a7)+,d0-d6/a0-a4
l003a0:	bra.w l003b6 | * rte

|*#: ret from syscall, clear d0
l003a4:	moveq #0x00,d0
|*#: ret from syscall
l003a6:	btst #0x05,0x000c(a7) | * was it supervisor-mode?
	bne.s l003b6
	tst.w 0x0030(a6) | * time for a scheduler rerun?
	bne.w l00936
l003b6:	movem.l (a7)+,d7/a5-a6
	rte

|* returns bas addr. of JOB in A0
|*#: D1 jobid(-1)<>A0 base, D1 jobid
l003bc:	tst.w d1 | * test D1 Job's ID
	bge.s l003d8
	move.l 0x0064(a6),d1 | * SV.JBPNT
	movea.l d1,a0
	movea.l (a0),a0 | * start adress
	sub.l 0x0068(a6),d1 | * SV.JBBAS
	lsr.l #2,d1
	swap d1
	move.w 0x0010(a0),d1 | * TAG for JOB
	swap d1
l003d6:	rts

l003d8:	bsr.s l003e4 | * is valid job?
	beq.s l003d6
	moveq #-0x02,d0 | * invalid job
	addq.w #4,a7
	bra.w l003a6 | * return

|* D1= jobid
|* returns JOB.BASE in a0, ^Z flag if fails
l003e4:	cmp.w 0x0062(a6),d1 | * SV.JBMAX
	bhi.s l003d6
	movea.w d1,a0
	adda.w a0,a0
	adda.w a0,a0
	adda.l 0x0068(a6),a0 | * SV.JBBAS
	tst.b (a0)
	blt.s l003d6
	movea.l (a0),a0
	swap d1
	cmp.w 0x0010(a0),d1 | * TAG for JOB
	bne.s l003d6
	swap d1
	cmp.b d1,d1
	rts

|* returns ID of CURRENT JOB in in D0
|*         base adress in A3
|*#: > D0= currjob_id, A3= currjob base
l00408:	movea.l 0x0064(a6),a3 | * pointer to current job
	move.l a3,d0
	sub.l 0x0068(a6),d0 | * SV.JBBAS
	lsr.w #2,d0
	movea.l (a3),a3
	swap d0
	move.w 0x0010(a3),d0
	swap d0
	rts

|* initialise transmission through 8049

l00420:	move.b d0,-(a7)
l00422:	subq.w #1,0x00a6(a6) | * timeout for switching
	blt.s l00432
	move.w #0x208b,d0
l0042c:	dbf d0,l0042c
	bra.s l00422

l00432:	clr.w 0x00a6(a6) | * reset timeout
	andi.b #0xe7,0x00a0(a6)
	move.b (a7)+,d0
	or.b d0,0x00a0(a6)
	andi.b #0x7f,0x0035(a6)
l00448:	move.b 0x00a0(a6),0x00018002
	rts

|* stop transmission through 8049

l00452:	bclr #0x04,0x00a0(a6)
	ori.b #0x80,0x0035(a6)
	bra.s l00448


|* trap 1  jump according to D0

l00460:	cmpi.w #0x0024,d0
	bhi.s l004bc
	move.w d0,d7
	add.w d7,d7
	move.w l00472(pc,d7.w),d7
	jmp adummy(pc,d7.w)

l00472:
.equ adummy, l00472-0x12

.balign 2, 0 ; 	.word xltr1d00-l00460
.balign 2, 0 ; 	.word xltr1d01-l00460
.balign 2, 0 ; 	.word xltr1d02-l00460
.balign 2, 0 ; o78:	.word xltr1d03-l00460
.balign 2, 0 ; 	.word xltr1d04-l00460
.balign 2, 0 ; o7c:	.word xltr1d05-l00460
.balign 2, 0 ; o7e:	.word xltr1d06-l00460
.balign 2, 0 ; o80:	.word xltr1d07-l00460
.balign 2, 0 ; 	.word xltr1d08-l00460
.balign 2, 0 ; 	.word xltr1d09-l00460
.balign 2, 0 ; 	.word xltr1d0a-l00460
.balign 2, 0 ; 	.word xltr1d0b-l00460
.balign 2, 0 ; o8a:	.word xltr1d0c-l00460
.balign 2, 0 ; 	.word xltr1d0d-l00460
.balign 2, 0 ; 	.word xltr1d0e-l00460
.balign 2, 0 ; o90:	.word xltr1d0f-l00460
.balign 2, 0 ; 	.word xltr1d10-l00460
.balign 2, 0 ; 	.word xltr1d11-l00460
.balign 2, 0 ; 	.word xltr1d12-l00460
.balign 2, 0 ; 	.word xltr1d13-l00460
.balign 2, 0 ; 	.word xltr1d14-l00460
.balign 2, 0 ; 	.word xltr1d15-l00460
.balign 2, 0 ; oa0:	.word xltr1d16-l00460
.balign 2, 0 ; 	.word xltr1d17-l00460
.balign 2, 0 ; 	.word xltr1d18-l00460
.balign 2, 0 ; 	.word xltr1d19-l00460
.balign 2, 0 ; 	.word xltr1d1a-l00460
.balign 2, 0 ; 	.word xltr1d1b-l00460
.balign 2, 0 ; 	.word xltr1d1c-l00460
.balign 2, 0 ; 	.word xltr1d1d-l00460
.balign 2, 0 ; 	.word xltr1d1e-l00460
.balign 2, 0 ; 	.word xltr1d1f-l00460
.balign 2, 0 ; 	.word xltr1d20-l00460
.balign 2, 0 ; 	.word xltr1d21-l00460
.balign 2, 0 ; 	.word xltr1d22-l00460
.balign 2, 0 ; 	.word xltr1d23-l00460
.balign 2, 0 ; 	.word xltr1d24-l00460

|* If D0=3 or >$25   bad parameter
tr1d03:
l004bc:	moveq #-0x0f,d0
	bra.w l003a6
.equ xltr1d03, tr1d03

|* Info on QDOS
tr1d00:
.equ xltr1d00, tr1d00
o4c2:	moveq #-0x01,d1 | * get Job-ID
	jsr l003bc(pc)
	move.l 0xbff6,d2 | * D2 = Nr. of version
	movea.l a6,a0
	bra.w l003a4

|* Install new table of error messages or tra table
|* D2 = adress of error messages or 0
|* D1 = adress of tra-table or 0,1
tr1d24:
.equ xltr1d24, tr1d24
o4d4:	tst.l d2
l004d6:	beq.s l004ea | * no new message table
	btst #0x00,d2 | * test odd adress
	bne.s l0051e | * bad parameter
	movea.l d2,a0
	cmpi.w #0x4afb,(a0) | * starts with identifier
	bne.s l0051e | * errorend
	move.l a0,0x014a(a6) | * set new adress
l004ea:	clr.b 0x0144(a6) | * 
	tst.l d1 | * new tra-table ?
	beq.s l00518 | * no: end
	cmpi.l #0x0001,d1 | * is it TRA 1
	bne.s l00500 | * take adress from BFE2       
	move.l 0xbfe2,d1 | * ADRESSE VON TRA-TABELLE
l00500:	btst #0x00,d1 | * odd adress?
	bne.s l0051e
	movea.l d1,a0
	cmpi.w #0x4afb,(a0) | * starts with identifier
	bne.s l0051e | * errorend
	move.b #0x01,0x0144(a6) | * set 
	move.l a0,0x0146(a6)
l00518:	moveq #0x00,d0
	bra.w l003a6

l0051e:	moveq #-0x0f,d0 | * bad parameter
	bra.w l003a6

|* info on JOB
tr1d02:
.equ xltr1d02, tr1d02
o524:	jsr l003bc(pc) | * returns in d1 JOB-ID in a0 addr
	moveq #0x00,d3
	tst.w 0x0014(a0) | * JOB status
	beq.s l00532
	moveq #-0x01,d3
l00532:	move.b 0x0013(a0),d3 | * jobs priority increment
	move.l d2,d0
	move.l a0,-(a7)
	jsr l006c6(pc)
	movea.l (a7)+,a0
	move.l 0x0008(a0),d2 | * owner of job
	lea 0x0068(a0),a0 | * prog-start of job
	bra.w l003a4

|* create new job
|* mt.cjob
tr1d01:
.equ xltr1d01, tr1d01
o54c:	tst.l d1 | * identifier<>0
	beq.s l00554
	jsr l003bc(pc) | * get a0 base
l00554:	movem.l d1-d3/a1-a4,-(a7)
	moveq #0x00,d7
	movea.l 0x0068(a6),a4 | * SV.JBBAS
l0055e:	tst.b (a4) | * free entry ?
	blt.s l00570 | * initalise
	addq.w #1,d7
	addq.w #4,a4 | * next job
	cmpa.l 0x006c(a6),a4 | * too far
	blt.s l0055e | * try next table entry
	moveq #-0x02,d0 | * job table too small
	bra.s l005e0

|* activate job

l00570:	moveq #0x68,d1
	add.l d2,d1 | * add size of jobs descriptor to length
	add.l d3,d1
	jsr l02ffa(pc) | * reserve d1 Bytes
	bne.s l005e0
	movem.l (a7),d1-d3/a1
	move.l a0,(a4)

|* !!! from now on D1-D3,A0-A4 COULD BE USED without problems - see
|* end of routine - but only A0 is used !!!

	cmp.w 0x0062(a6),d7 | * jobnr < highest jobnr?
	bls.s l0058c | * old job
	move.w d7,0x0062(a6) | * new job
l0058c:	addq.w #4,a0 | * a0=jobbas+4
	moveq #0x18,d0 | * set job descriptor to 0
l00590:	clr.l (a0)+
	dbf d0,l00590
	suba.w #0x0060,a0 | * again start of job
	move.l d1,(a0)
	addq.w #8,a0
	swap d7
	move.w 0x0060(a6),d7 | * SV.JBTAG current value of job
	move.w d7,(a0)
	swap d7
	addq.w #1,0x0060(a6) | * increment value of SV.JBMAX
	move.l 0x0050(a6),0x000c(a0) | * pointer to trap redirection table
	adda.w #0x0040,a0
	move.l d2,(a0)+ | * length of job
	add.l d2,d3 | * + data-aera
	move.l d3,(a0)+
	moveq #0x10,d0
	add.l a0,d0 | * D0 = base of job's prog
	move.l d0,(a0)+
	add.l d0,d3 | * d3 = total length
	exg d3,a0
	clr.l -(a0)
	exg d3,a0
	move.l d3,(a0)
	addq.w #6,a0 | * start of prog
	move.l a1,d3
	beq.s l005d4
	move.l d3,d0
l005d4:	move.l d0,(a0)
	move.l d0,-0x005e(a0)
	lea 0x0006(a0),a0 | * start of prog-aera
	moveq #0x00,d0
l005e0:	movem.l (a7)+,d1-d3/a1-a4
	move.l d7,d1
	bra.w l003a6

tr1d04:
.equ xltr1d04, tr1d04
o5ea:	jsr l003bc(pc) | * returns bas addr. in A0; ID in D1
	move.l d1,d0
l005f0:	tst.b 0x0013(a0) | * jobs priority increment
	bne.w l006c0 | * 'not complete'
	jsr l006c6(pc) | * look for next job in tree
	tst.l d1
	bne.s l005f0 | *   ... for all jobs in tree
	move.l d0,d1 | * restore D1 (JOB-ID)
|* none active so far, fall through

|* mt.frjob
tr1d05:
.equ xltr1d05, tr1d05
	jsr l003bc(pc) | * returns bas addr. in A0
	move.l d1,d0 | * IOB-ID
	beq.w l006c0 | * BASIC? 'not complete'
	movea.w d1,a1
	adda.w a1,a1
	adda.w a1,a1
	adda.l 0x0068(a6),a1 | * find table entry
l00616:	addq.b #1,(a1) | * mark table entry
	jsr l006c6(pc) | * find next job in tree
	tst.l d1
	bne.s l00616 | *      ... while any job in tree

	sf -(a7) | * flag: jobid -1 removed?
	moveq #0x00,d1 | * now scan the marked jobs
	movea.l 0x0068(a6),a1 | * SV.JBBAS
l00628:	addq.w #4,a1 | * next table entry
	addq.w #1,d1 | * next job nr
	cmp.w 0x0062(a6),d1 | * SV.JBMAX
	bhi.w l006b6
	tst.b (a1) | * marked ?
	ble.s l00628 | * no ->
	sf (a1) | * clear mark
	movea.l (a1),a0
	swap d1
	move.w 0x0010(a0),d1 | * TAG for JOB
	swap d1
	cmpa.l 0x0064(a6),a1 | * SV.JBPNT
	bne.s l0064c
	st (a7) | * set if removed jobid=-1
l0064c:	tst.b 0x0017(a0) | * JOB.WFLAG
	beq.s l00670
	move.l 0x0018(a0),d0 | * D0 = ID of waiting JOB
	exg d0,d1
	jsr l003e4(pc) | *     get its base, Z flag
	exg d0,d1
	bne.s l00670 | *     ... invalid job
	cmpi.w #0xfffe,0x0014(a0) | * is it really waiting ?
	bne.s l00670
	clr.w 0x0014(a0) | *    release it
	move.l d3,0x0020(a0) | *    JOB.D0 = error code

|* now free jobs resources

l00670:	movea.l 0x0004(a6),a0 | * base of common heap
l00674:	cmp.l 0x0008(a0),d1 | * owner of this ?
	bne.s l0069a
	movem.l d1/d3/a0-a1,-(a7)
	move.l 0x000c(a0),d1
	beq.s l00688
	movea.l d1,a1
	st (a1) | * set flag on release
l00688:	movea.l 0x0004(a0),a1
	lea -0x0018(a1),a3
	movea.l 0x000c(a1),a1 | * dev_close
	jsr (a1) | * close channel or release memory
	movem.l (a7)+,d1/d3/a0-a1
l0069a:	adda.l (a0),a0
	cmpa.l 0x000c(a6),a0 | * SV.FREE
	blt.s l00674 | * try next block

	movem.l d1/d3/a1,-(a7)
	movea.l (a1),a0
	jsr l0308c(pc) | * RELEASE headerblock + program space
	movem.l (a7)+,d1/d3/a1
	st (a1) | * invalidate table entry
	bra.w l00628 | * remove some more jobs

l006b6:	tst.b (a7)+
	beq.w l003a4 | * return
	bra.w l0093a | * must run through scheduler(job -1 removed)

l006c0:	moveq #-0x01,d0 | * 'not complete'
	bra.w l003a6

|* look for ID of next JOB in tree

l006c6:	move.l d1,d2 | * D2 = owner job
	moveq #0x00,d1
l006ca:	addq.w #1,d1
	cmp.w 0x0062(a6),d1 | * SV.JBMAX
	bgt.s l006e0 | * -> try next branch
	bsr.s l006ee | * get Job base
	tst.b (a1) | * valid entry?
	blt.s l006ca
	cmp.l 0x0008(a0),d2 | * child of JOB ?
	beq.s l00700
	bra.s l006ca | * continue searching

l006e0:	cmp.w d2,d0 | * setup for next branch
	beq.s l006fc
	move.w d2,d1
	bsr.s l006ee
	move.l 0x0008(a0),d2 | * owner of JOB
	bra.s l006ca | * continue searching

l006ee:	movea.w d1,a1
	adda.w a1,a1
	adda.w a1,a1
	adda.l 0x0068(a6),a1 | * SV.JBBAS
	movea.l (a1),a0 | * a0 = base of JOB
	rts

l006fc:	moveq #0x00,d1
	rts

l00700:	swap d1
	move.w 0x0010(a0),d1 | * get job TAG
	swap d1
	rts

|* mt.trapv set for this job the trap vectors
tr1d07:
.equ xltr1d07, tr1d07

o70a:	jsr l003bc(pc) | * returns bas addr. of JOB in A0
	suba.w #0x0054,a1
	move.l a1,0x0050(a6) | * pointer to current trap redir. table
	move.l a1,0x001c(a0) | *        ...   jobs     ...
	bra.w l003a4


|* allocate area in a heap
tr1d0c:
.equ xltr1d0c, tr1d0c
o71e:	adda.l 0x0008(a5),a0 | * a0=pointer to pointer to free space
	jsr l03104(pc) | * MM.ALLOC
	suba.l 0x0008(a5),a0 | * base of allocated area
	bra.s l007a2

|* link free space
tr1d0d:
.equ xltr1d0d, tr1d0d
o72c:	adda.l 0x0008(a5),a0
	adda.l 0x0008(a5),a1
	jsr l03162(pc) | * MM.LINKFR
	bra.s l007a2

|* allocate common heap area       
tr1d18:
.equ xltr1d18, tr1d18
l0073a:	exg d1,d2
	jsr l003bc(pc) | * returns bas addr. in A0, ID in d1
	move.l d1,-(a7)
	moveq #0x10,d1
	add.l d2,d1 | * d2= number of bytes
	jsr l02fae(pc) | * allocate memory
	bne.s l007bc
	addq.w #4,a0
l0074e:
	move.l #xl0075a,(a0)+ | heap release descriptor ADDRESS, not contents
	move.l (a7)+,(a0)+ | * job id
	clr.l (a0)+
	bra.s l00766 | * !!! there: BRA L003A4


.balign 2, 0 ; l0075a:	.long l0305e | * adress for release of heap
.equ xl0075a, l0075a-0x0c | * that's the value, we need

|* release area in common heap
l0075e:
tr1d19:
.equ xltr1d19, tr1d19
	lea -0x0010(a0),a0 | * TAG for JOB
	jsr l0305e(pc) | * MT.RECHP
l00766:	bra.w l003a4

|* allocation (d0=E) and release (d0=F) of resident proc area
tr1d0e:
tr1d0f:
.equ xltr1d0e, tr1d0e
.equ xltr1d0f, tr1d0e
l0076a:	movea.l 0x001c(a6),a0 | * SV.RESPR
	cmpa.l 0x0014(a6),a0 | * SV.TRNSP 
	bne.s l007a0
	cmpi.b #0x0f,d0
	beq.s l00786
	tst.l d1
	ble.s l00766
	jsr l02ffa(pc) | * reserve d1 bytes
	blt.s l007be
	bra.s l00792

l00786:	move.l 0x0020(a6),d1 | * SV.RAMT
	sub.l 0x001c(a6),d1 | * SV.RESPR
	jsr l0308c(pc) | * RELEASE MEMORY
l00792:	move.l 0x0014(a6),0x001c(a6) | * SV TRNSP ½ SV.RESPR
	clr.l 0x0018(a6) | * SV.TRNFR
	bra.w l003a4
l007a0:	moveq #-0x01,d0 | * 'not complete'
l007a2:	bra.s l007be | * !!! Faster: Jump direct - used to save space

|* allocate Basic prog aera
tr1d16:
.equ xltr1d16, tr1d16
l007a4:	jsr l031b8(pc) | * allocate memory
	bra.s l007be | * !!! there: BRA L003A6 
|* Faster: Jump direct - used to save space

|* Release Basic Prog Aera 
tr1d17:
.equ xltr1d17, tr1d17
	move.l 0x0014(a6),-(a7) | * SV TRNSP
	sub.l d1,0x0014(a6) | * SV TRNSP
	jsr l031c8(pc) | * Release memory
	move.l (a7)+,0x0014(a6) | * SV TRNSP
	bra.s l007be | * !!! memory saving but time waisting
l007bc:	addq.w #4,a7
l007be:	bra.w l003a6

|* set or read display mode according to D1 and D2 ½ Adder
tr1d10:
.equ xltr1d10, tr1d10
o7c0:	move.b 0x0034(a6),d0 | * SV.MCSTA
	tst.b d1 | * read?
	blt.w l0085e | * yes
	andi.b #0xf7,d0 | * !!! this and next command used for security
	andi.b #0x08,d1 | * if calling routine did set word
|* 'cause all use moveq... not necessary
	or.b d1,d0
	move.b d0,0x0034(a6) | * set SV.MCSTA
	move.b d0,0x00018063 | * set 8049 according
	move.l a6,-(a7) | * preserves A6
	move.w #0x1fff,d0
l007e6:	clr.l -(a6) | * now cls of whole screen
	dbf d0,l007e6
	movea.l (a7)+,a6

|* reinitialisation of screen channels

	movea.l 0x0078(a6),a4 | * SV.CHBAS
l007f2:	move.l (a4)+,d0
	movem.l d1-d6/a0-a6,-(a7)
	blt.s l00852 | * channel closed?
	movea.l d0,a0
	cmpi.l #l00d36,0x0004(a0) | * is it no screen channel
	bne.s l00852 | * look for next channels
	move.b d1,-(a7)
	move.w 0x0020(a0),-(a7)
	moveq #0x00,d2
	jsr l01afc(pc) | * set border
	lea 0x0036(a0),a1 | * paper colour masque
	lea 0x0044(a0),a5 | * paper colour byte
	moveq #0x02,d0
l0081c:	move.b (a5)+,d1
	jsr l027d8(pc) | * set paper masque
	addq.w #4,a1
	dbf d0,l0081c
	jsr l01cae(pc) | * cls
	move.b (a5),d1
	move.w (a7)+,d2
	jsr l01af8(pc) | * set set border
	subq.w #5,a5
	andi.b #0x00,(a5) | * set char-attributes to 0
	move.l #0x0006000a,0x0026(a0) | * reset charsize
	tst.b (a7)+
	beq.s l0084e | * mode 4 ½ yes
	bset #0x06,(a5)+ | * mode 8
	lsl 0x0026(a0)
l0084e:	tst.b (a5) | * cursor-status
	sne (a5)
l00852:	movem.l (a7)+,d1-d6/a0-a6
	cmpa.l 0x007c(a6),a4 | * all channels checked
	blt.s l007f2 | * no, continue
	bra.s l00862

l0085e:	moveq #0x08,d1
	and.b d0,d1 | * if mode 4: D1=0, else: D1=8
l00862:	tst.b d2
	bge.s l0086a
	move.b 0x0032(a6),d2 | * SV.TVMOD
l0086a:	move.b d2,0x0032(a6)
	bra.w l003a4

tr1d11:
.equ xltr1d11, tr1d11

|* send command to 8049

l00872:	movem.l d4/d6/a0-a1/a3,-(a7)
	jsr l02c72(pc) | * execute command to 8049
	movem.l (a7)+,d4/d6/a0-a1/a3
	bra.w l003a4

tr1d12:
.equ xltr1d12, tr1d12

|* MT.BAUD

l00882:	movem.l d2/d6/a0-a2,-(a7)
	lea l008d6(pc),a0 | * table of baudrates
	moveq #0x07,d2
l0088c:	cmp.w (a0)+,d1 | * compare table with selecte rate
	beq.s l0089e | * match
	dbf d2,l0088c
	moveq #-0x0f,d0 | * no valid baudrate
l00896:	movem.l (a7)+,d2/d6/a0-a2
	bra.w l003a6

l0089e:	move.l #0x4b0,d0 | * dezimal 1200
	divu d1,d0 | * d0=$4b0/baudrate
	addq.w #1,d0
	move.w d0,0x00a8(a6) | * SV.TIMOV
	ori.w #0x0700,sr
	jsr l02f6e(pc) | * returns D6=6  A0=$18020  A1=$18003
	lea 0x00a0(a6),a2 | * SV.TMODE
	andi.b #0xf8,(a2)
	or.b d2,(a2)
	move.b (a2),-0x0001(a1)
	moveq #0x0d,d0 | * cammand 0D = serial settings
	jsr l02f7c(pc) | * command for 8079
	move.b d2,d0
	jsr l02f7c(pc) | * command for 8079
	andi.w #0xf8ff,sr
	moveq #0x00,d0
	bra.s l00896

.balign 2, 0 ; l008d6:	.long 0x004b012c | *   75 / 300 BAUD
.balign 2, 0 ; 	.long 0x025804b0 | *  600 /1200 BAUD
.balign 2, 0 ; 	.long 0x096012c0 | * 2400 /4800 BAUD
.balign 2, 0 ; 	.long 0x25804b00 | * 9600 /19200 BAUD

tr1d1a:
tr1d1c:
tr1d1e:
tr1d20:
tr1d22:
.equ xltr1d1a, tr1d1a
.equ xltr1d1c, tr1d1a
.equ xltr1d1e, tr1d1a
.equ xltr1d20, tr1d1a
.equ xltr1d22, tr1d1a
|* link traps
l008e6:	add.w d0,d0
	lea 0x04(a6,d0.w),a1
	jsr l039dc(pc) | * UT.LINK
	bra.s l008fc


tr1d1b:
tr1d1d:
tr1d1f:
tr1d21:
tr1d23:
.equ xltr1d1b, tr1d1b
.equ xltr1d1d, tr1d1b
.equ xltr1d1f, tr1d1b
.equ xltr1d21, tr1d1b
.equ xltr1d23, tr1d1b

|* task linking traps

l008f2:	add.w d0,d0
	lea 0x02(a6,d0.w),a1
	jsr l039e2(pc) | * UT.UNLNK
l008fc:	bra.w l003a4


|* polled interrupt
l00900:	addq.w #1,0x0030(a6) | * SV.POLLM
	bvc.s l0090a
	subq.w #1,0x0030(a6)
l0090a:	movem.l d0-d6/a0-a4,-(a7)
	moveq #-0x08,d0
	moveq #0x01,d3
	movea.l 0x003c(a6),a0 | * SV.PLIST
	jsr l00a9e(pc) | * execute poll tasks
	movem.l (a7)+,d0-d6/a0-a4
	move.b 0x0035(a6),d7 | * SV.PCINT
	ori.b #0x08,d7
	move.b d7,0x00018021
	btst #0x05,0x000c(a7) | * supervisor mode?
	bne.w l003b6 | * yes -> rte
|* else fall through into scheduler
l00936:	jsr l009d4(pc) | * save jobs data
l0093a:	move.w 0x0030(a6),d3 | * SV.POLLM
	clr.w 0x0030(a6)
	addq.w #1,0x002e(a6) | * SV.RAND
	moveq #-0x10,d0
	movea.l 0x0040(a6),a0 | * SV.SHLST
	jsr l00a9e(pc) | * execute sched tasks
	jsr l00a0c(pc) | * get highest job priority
	tst.l d0
	blt.s l0093a | * no runnable job ->
	move.l d0,0x0064(a6) | * SV.JBPNT: new current job
	jsr l00a78(pc) | * execute it

tr1d08:
.equ xltr1d08, tr1d08
|* suspend job
	jsr l003bc(pc) | * returns bas addr. in A0
	move.w d3,0x0014(a0) | * JOB status
	move.l a1,0x000c(a0)
	moveq #0x00,d0
	bra.w l00936

tr1d09:
.equ xltr1d09, tr1d09
|* reactivate job
	jsr l003bc(pc) | * returns bas addr. in A0
	tst.w 0x0014(a0) | * JOB status
	beq.s l0098a
	clr.w 0x0014(a0) | * JOB status
	move.l 0x000c(a0),d0 | * Adder S. 337
	beq.s l0098a
	movea.l d0,a0
	sf (a0)
l0098a:	moveq #0x00,d0
	bra.w l00936

tr1d0b:
.equ xltr1d0b, tr1d0b
|* change priority of job
o990:	jsr l003bc(pc) | * returns bas addr. in A0
	move.b d2,0x0013(a0) | * jobs priority increment
	bne.s l009ca
	sf 0x0012(a0) | * Jobs accumulated priority
	bra.s l009ca

tr1d0a:
.equ xltr1d0a, tr1d0a
|* activate job
o9a0:	jsr l003bc(pc) | * returns bas addr. in A0
	tst.b 0x0013(a0) | * jobs priority increment
	bne.s l009d0
	move.b d2,0x0013(a0) | * jobs priority increment
	move.l 0x0004(a0),0x0062(a0) | * START ½ Adder S. 335
	tst.w d3 | * wait ?
	beq.s l009ca | * no ->
	st 0x0017(a0)
	jsr l00408(pc)
	move.l d0,0x0018(a0) | * JOB.WJOB
	move.w #0xfffe,0x0014(a3)
l009ca:	moveq #0x00,d0
l009cc:	bra.w l00936

l009d0:	moveq #-0x01,d0
	bra.s l009cc

|* scheduler aux subroutines

|* save jobs registers into jobheader
l009d4:	move.l a6,-(a7)
	movea.l 0x0064(a6),a6 | * SV.JBPNT
	movea.l (a6),a6
	tst.b 0x0012(a6) | * accumulated priority
	beq.s l009e8
	move.b #0x01,0x0012(a6)
l009e8:	movem.l d0-d7/a0-a4,0x0020(a6) | * save regs into jobheader
	move.l (a5)+,0x003c(a6) | * D7
	move.l (a5)+,0x0054(a6) | * a5
	move.l (a5)+,0x0058(a6) | * a6
	move.l usp,a0 | * a7
	move.l a0,0x005c(a6) | *
	move.w (a5)+,0x0060(a6) | * SR
	move.l (a5)+,0x0062(a6) | * PC
	movea.l (a7)+,a6
	rts

|* get job with highest priority
|* D0=-2 if none ready
l00a0c:	moveq #-0x02,d0
	moveq #0x00,d1
	movea.l 0x0064(a6),a2 | * SV.JBPNT
	movea.l a2,a4 | * a4= current job
	move.w 0x0062(a6),d2 | * SV.JBMAX
	lsl.w #2,d2
	movea.l 0x0068(a6),a3 | * SV.JBBAS
	adda.w d2,a3

l00a22:	addq.w #4,a2 | * a2= currently examined job
	cmpa.l a3,a2 | * >SV.JBMAX ?
	ble.s l00a2c
	movea.l 0x0068(a6),a2 | *  ... wrap search
l00a2c:	tst.b (a2) | * valid job ?
	blt.s l00a72 | * no ->
	movea.l (a2),a0
	tst.b 0x0013(a0) | * jobs priority increment
	beq.s l00a72 | * 0 -> no chance
	tst.w 0x0014(a0) | * JOB status
	beq.s l00a54 | * -> runnable
	blt.s l00a72 | * -> indefintely suspended, try next
	sub.w d3,0x0014(a0) | * decrement timeout by SV.POLLM
	bgt.s l00a72 | * -> still suspended
	clr.w 0x0014(a0) | * make sure it doesn't get suspended by accident
	move.l 0x000c(a0),d2 | * JOB.HOLD
	beq.s l00a54
	movea.l d2,a1 | * release flag
	sf (a1)
l00a54:	move.b 0x0012(a0),d2 | * Jobs accumulated priority
	beq.s l00a64
	add.b 0x0013(a0),d2 | * jobs priority increment
	bcc.s l00a66
	st d2
	bra.s l00a66

l00a64:	moveq #0x01,d2
l00a66:	move.b d2,0x0012(a0) | * Jobs accumulated priority
	cmp.b d1,d2
	bls.s l00a72 | * no chance
	move.l a2,d0 | * best so far
	move.b d2,d1 | * ...         priority
l00a72:	cmpa.l a4,a2
	bne.s l00a22
	rts

|* return from scheduler and run job
l00a78:	movea.l 0x0064(a6),a0 | * SV.JBPNT
	movea.l (a0),a0
	adda.w #0x0016,a7
	move.l 0x0062(a0),-(a7) | * JOB.PC
	move.w 0x0060(a0),-(a7) | * JOB.SR
	move.l 0x001c(a0),0x0050(a6) | * SV.TRAPV <- JOB.TRAPV
	movea.l 0x005c(a0),a1
	move.l a1,usp | * JOB.A7
	movem.l 0x0020(a0),d0-d7/a0-a6
	rte

|*  execute linked tasks (extint,poll,sched)
|*  A0= list
l00a9e:	move.w d0,-(a7)
l00aa0:	movea.l a0,a3
	adda.w (a7),a3 | * offset to driver address
	move.l a0,-(a7)
	beq.s l00abc
	move.w d3,-(a7)
	andi.w #0x007f,d3
	movea.l 0x0004(a0),a0 | * A0=adress of task
	jsr (a0)
	move.w (a7)+,d3
	movea.l (a7)+,a0
	movea.l (a0),a0
	bra.s l00aa0

l00abc:	addq.l #6,a7
	rts

|* 'SER' driver
.balign 2, 0 ; l00ac0:	.long l00c88 | * pointer to next driver in link
.balign 2, 0 ; 	.long l00bb6 | * adress of in / out
.balign 2, 0 ; 	.long l00ad0 | * adress to open chan
.balign 2, 0 ; 	.long l00b8e | * adress to close 

l00ad0:	subq.w #8,a7
	movea.l a7,a3
	jsr l0372c(pc) | * IO.DECODE
	bra.s l00b20 | * ERROR
	bra.s l00b20 | * ERROR
	bra.s l00b28 | * SUCCESS

.balign 2, 0 ; l00ade:	.word 0x0003
	.ascii "SER"
	.byte 0x00
.balign 2, 0 ; 	.word 0x0004 | * 4 parameters
.balign 2, 0 ; 	.word 0xffff | * default values
.balign 2, 0 ; 	.word 0x0001 | * = ser1
.balign 2, 0 ; 	.word 0x0004 | * 4 options for second parameter
	.ascii "OEMS"
.balign 2, 0 ; 	.word 0x0002 | * 2 options for third
	.ascii "IH"
.balign 2, 0 ; 	.word 0x0003 | * 3 options for fourth
	.ascii "RZC" ; .byte 0x00
.balign 2, 0 ; l00afa:	.long 0x02000000 | * values for 8049 - open ser1
.balign 2, 0 ; 	.long 0x00000100
.balign 2, 0 ; 	.long 0x03000000 | * OPEN SER2
.balign 2, 0 ; 	.long 0x00000100
.balign 2, 0 ; l00b0a:	.long 0x04000000 | * close ser1
.balign 2, 0 ; 	.long 0x00000100
.balign 2, 0 ; 	.long 0x05000000 | * close ser2
.balign 2, 0 ; 	.long 0x00000100

l00b1a:	moveq #-0x07,d0 | * 'not found'
	bra.s l00b20

l00b1e:	moveq #-0x09,d0 | * 'in use'
l00b20:	addq.w #8,a7
	andi.w #0xf8ff,sr
	rts

|* open ser

l00b28:	ori.w #0x0700,sr
	move.w (a7),d4
	ble.s l00b1a
	subq.w #2,d4
	bgt.s l00b1a
	lea 0x0098(a6),a5 | * SV.SER1C
	lea l00afa(pc),a4 | * is it a serial channel
	blt.s l00b42 | * no½ look for next channel
	addq.w #4,a5
	addq.w #8,a4
l00b42:	move.l (a5),d0
	beq.s l00b56
	movea.l d0,a0
	suba.w #0x0020,a0
	bclr #0x07,0x0082(a0)
	bne.s l00b6a
	bra.s l00b1e

l00b56:	move.w #0x00e4,d1
	jsr l02fae(pc) | * MM.ALCHP
	bne.s l00b20
	moveq #0x51,d1
	lea 0x0082(a0),a2
	jsr l037f4(pc) | * IO.QSET
l00b6a:	moveq #0x51,d1
	lea 0x0020(a0),a2 | * pointer to buffer
	jsr l037f4(pc) | * IO.QSET
	move.l a2,(a5)
	move.l (a7),0x0018(a0)
	move.l 0x0004(a7),0x001c(a0)
	subq.w #1,0x001c(a0)
	subq.w #2,0x001e(a0)
	bsr.s l00baa
	moveq #0x00,d0
	bra.s l00b20

l00b8e:	lea l00b0a(pc),a4 | * close ser
	btst #0x01,0x0018(a0) | * input queue
	beq.s l00b9c
	addq.l #8,a4
l00b9c:	bsr.s l00baa
	lea 0x0082(a0),a2 | *
	jsr l03888(pc) | * IO.QEOF
	moveq #0x00,d0
	rts

l00baa:
	move.l a0,-(a7) | * serial I/O
	movea.l a4,a3
	jsr l02c72(pc) | * execute command to 8049
	movea.l (a7)+,a0
	rts

l00bb6:	jsr l0388c(pc) | * IO.SERIO
.balign 2, 0 ; 	.long l00bc8 | * test ser
.balign 2, 0 ; 	.long l00c24 | * read from ser
.balign 2, 0 ; 	.long l00bd0 | * write to ser
	rts

l00bc8:	lea 0x0020(a0),a2 | * pointer to buffer
	jmp l0380a(pc) | * IO.QTEST

|* what kind of ser-transmission is to do?

l00bd0:	cmpi.b #0x0a,d1
	bne.s l00bde
	tst.b 0x001f(a0)
	ble.s l00bde
	moveq #0x0d,d1
l00bde:	move.w 0x001a(a0),d0
	move.b l00bea(pc,d0.w),d0
	jmp l00bea(pc,d0.w) | * now its done

l00bea:	.byte xwnopar-l00bea
	.byte xwodd-l00bea
	.byte xweven-l00bea
	.byte xwbit7-l00bea
	.byte xwbit8-l00bea

wbit7:	bset #7,d1
.equ xwbit7, wbit7
wnopar:
.equ xwnopar, wnopar
l00bf4:	lea 0x0082(a0),a2
	tst.b 0x0144(a6)
	beq.s l00c0c
	move.l a3,-(a7)
	movea.l 0xbfee,a3 | * !!! PROG-LABEL
	jsr (a3)
	movea.l (a7)+,a3
	bra.s l00c74

l00c0c:	jsr l03838(pc) | * IO.QIN
	bra.s l00c74

wbit8:	bclr #0x07,d1
	bra.s l00bf4
.equ xwbit8, wbit8
wodd:	bsr.s l00c76
	bchg #0x07,d1
	bra.s l00bf4
.equ xwodd, wodd
weven:	bsr.s l00c76
	bra.s l00bf4
.equ xweven, weven
l00c24:	lea 0x0020(a0),a2 | * pointer to buffer
	jsr l0385e(pc) | * IO.QOUT
	bne.s l00c74
	move.w 0x001a(a0),d3
	move.b l00c3a(pc,d3.w),d3
	jmp l00c3a(pc,d3.w)

l00c3a:	.byte xrnopar-l00c3a | * displacement for read-ser
	.byte xrimpar-l00c3a
	.byte xrpar-l00c3a
	.byte xrbit71-l00c3a
	.byte xrbit70-l00c3a
	.byte 0x00

rbit71:	bchg #0x07,d1
	bra.s l00c4c

rimpar:	bchg #0x07,d1
rpar:	bsr.s l00c76
rbit70:
l00c4c:	btst #0x07,d1
	beq.s l00c54
	moveq #-0x0d,d0
l00c54:
rnopar:

.equ xrbit71, rbit71
.equ xrimpar, rimpar
.equ xrpar, rpar
.equ xrbit70, rbit70
.equ xrnopar, rnopar

	tst.b 0x0144(a6)
	beq.s l00c66
	move.l a3,-(a7)
	movea.l 0xbfea,a3
	jsr (a3)
	movea.l (a7)+,a3
l00c66:	cmpi.b #0x0d,d1
	bne.s l00c74
	tst.b 0x001f(a0)
	ble.s l00c74
	moveq #0x0a,d1
l00c74:	rts

l00c76:	moveq #0x06,d3
	move.b d1,d4
l00c7a:	ror.b #1,d1
	eor.b d1,d4
	dbf d3,l00c7a
	roxl.b #1,d4
	roxr.b #1,d1
	rts

|* 'PIPE' driver
.balign 2, 0 ; l00c88:	.long l00d36 | * pointer to next driver
.balign 2, 0 ; 	.long l037cc | * addr. for pipe I/O
.balign 2, 0 ; 	.long l00c98 | * addr. to open pipe#
.balign 2, 0 ; 	.long l00d0a | * addr. to close pipe#

l00c98:	subq.w #2,a7 | * open pipe#
	movea.l a7,a3
	jsr l0372c(pc) | * IO.DECODE
	bra.s l00d00 | * ERROR
	bra.s l00d00 | * ERROR
	bra.s l00cb2 | * SUCCESS

.balign 2, 0 ; o00ca6:	.word 0x0004
	.ascii "PIPE"
.balign 2, 0 ; 	.word 0x0001 | * 1 parameter
	.ascii " _" | * '_' necessary
.balign 2, 0 ; 	.word 0x0000 | * lenght parameter

l00cb2:	move.w (a7),d1 | * any length ?
	beq.s l00cd2
	addi.w #0x31,d1
	jsr l02fae(pc) | * MM.ALCHP
	bne.s l00d00
	move.w (a7),d1
	addq.w #1,d1
	lea 0x0020(a0),a2 | * pointer to buffer
	jsr l037f4(pc) | * IO.QSET
	move.l a2,0x001c(a0)
	bra.s l00cfe | * done

|* connect to another pipe
l00cd2:	movea.w d3,a2 | * chan id
	adda.l a2,a2
	adda.l a2,a2
	adda.l 0x0078(a6),a2
	movea.l (a2),a2 | * chan base
	cmpi.l #l00c88,0x0004(a2) | * is it a pipe channel ?
	bne.s l00d04 | * no ½ error
	move.l a2,-(a7) | * save its base
	moveq #0x20,d1
	jsr l02fae(pc) | *  MM.ALCHP
	movea.l (a7)+,a2
	bne.s l00d00 | * -> no mem
	lea 0x0020(a2),a2 | * pointer to queue
	move.l a0,(a2) | * link queues
	move.l a2,0x0018(a0)
l00cfe:	moveq #0x00,d0
l00d00:	addq.w #2,a7
	rts

l00d04:	moveq #-0x0f,d0
	addq.w #2,a7
	rts

|* close
l00d0a:	tst.l 0x0018(a0)
	bne.s l00d1c
	lea 0x0020(a0),a2 | * pointer to buffer
	tst.l (a2) | * queue empty?
	beq.s l00d32 | * yes: close channel
	jmp l03888(pc) | * IO.QEOF

l00d1c:	move.l 0x0018(a0),-(a7)
	bsr.s l00d32 | * close channel
	movea.l (a7)+,a2
	lea -0x0020(a2),a0
	tst.b (a2) | * file empty
	blt.s l00d32 | * yes: close channel
	clr.l (a2)
	moveq #0x00,d0
	rts

l00d32:	jmp l0305e(pc) | * MT.RECHP

|* 'CON' driver
.balign 2, 0 ; l00d36:	.long l01104 | * ADRESS ON NEXT LINKED DRIVER
.balign 2, 0 ; 	.long l00e76 | * I/O OF CON AND SER
.balign 2, 0 ; 	.long l00d46 | * OPEN CON OR SER
.balign 2, 0 ; 	.long l00e3a | * CLOSE CON OR SER

l00d46:	suba.w #0x000a,a7
	movea.l a7,a3
	jsr l0372c(pc) | * IO.DECODE
	bra.s l00d9e | * ERROR
	bra.s l00dc8 | * ERROR
	bra.s l00d72 | * SUCCESS

.balign 2, 0 ; o00d56:	.word 0x0003
	.ascii "CON"
	.byte 0x00
.balign 2, 0 ; 	.word 0x0005 | * 5 parameters
.balign 2, 0 ; 	.word 0x205f | * needs '_'
.balign 2, 0 ; 	.word 448 | * wide
.balign 2, 0 ; 	.word 0x2058 | * needs 'X'
.balign 2, 0 ; 	.word 180 | * high
.balign 2, 0 ; 	.word 0x2041 | * needs 'A' 
.balign 2, 0 ; 	.word 32 | * x-origin
.balign 2, 0 ; 	.word 0x2058 | * needs 'X'
.balign 2, 0 ; 	.word 16 | * y-origin
.balign 2, 0 ; 	.word 0x205f | * needs '_'
.balign 2, 0 ; 	.word 0x0080 | * default buffer:128 Bytes

l00d72:	moveq #0x7a,d1 | * initialise
	add.w 0x0008(a7),d1
	bsr.s l00dce | * open #
	bne.s l00dc8 | * out of memory
	lea 0x0068(a0),a2 | * initialise keyboard buffer
	subi.w #0x0078,d1
	jsr l037f4(pc) | * IO.QSET
	movea.l 0x004c(a6),a3
	move.l a3,d3
	bne.s l00d98 | * if buffer exists: create new one
	move.l a2,(a2)
	move.l a2,0x004c(a6) | * store addr of keyboard buffer
	bra.s l00dc6

l00d98:	move.l (a3),(a2) | * link buffer-adresses
	move.l a2,(a3)
	bra.s l00dc6 | * back without error

l00d9e:	jsr l0372c(pc) | * IO.DECODE
	bra.s l00dc8 | * ERROR
	bra.s l00dc8 | * ERROR
	bra.s l00dc0 | * SUCCESS

.balign 2, 0 ; o00da8:	.word 0x0003
	.ascii "SCR" ; .byte 0x00
.balign 2, 0 ; 	.word 0x0004 | * 4 parameters
.balign 2, 0 ; 	.word 0x205f | * needs '_'
.balign 2, 0 ; 	.word 448 | * wide 
.balign 2, 0 ; 	.word 0x2058 | * needs 'X'
.balign 2, 0 ; 	.word 180 | * high
.balign 2, 0 ; 	.word 0x2041 | * needs 'A'
.balign 2, 0 ; 	.word 32 | * x-origin
.balign 2, 0 ; 	.word 0x2058 | * needs 'X'
.balign 2, 0 ; 	.word 16 | * y-origin


|* open screen channel       
l00dc0:	moveq #0x6c,d1 | * lenght of description
	bsr.s l00dce | * open channel
	bra.s l00dc8

l00dc6:	moveq #0x00,d0
l00dc8:	adda.w #0x000a,a7
	rts

|* open channel
l00dce:	jsr l02fae(pc) | * MM.ALCHP
	bne.s l00e38
	move.w d1,-(a7)
	lea 0x0026(a0),a2
	move.l #0x0006000a,(a2)+ | * charsize:  6x10 pixels
	move.l #xl0ad9a,(a2)+ | * PIXEL-SCR
	move.l #xl0b106,(a2)+ | * PIXEL-SCR
	move.l #0x00020000,(a2)+ | * SCREENMEMORY
	move.w #0x80,0x64(a0) | * necessary ? lenght of buffer?
	lea 0x003e(a0),a1 | * define paper
	moveq #0x04,d1
	move.b d1,0x0046(a0)
	jsr l027d8(pc)
	move.l #0x08076400,0x56(a0) | * graphic shell
	btst #0x03,0x0034(a6) | * SV.MCSTA - mode 4 ?
	beq.s l00e20
	addq.w #6,0x0026(a0) | * adapt size
	bset #0x06,0x0042(a0)
l00e20:	moveq #0x00,d2
	lea 0x0006(a7),a1
	jsr l01ab6(pc)
	move.w (a7)+,d1
	tst.l d0 | * error ?
	beq.s l00e38 | * no
	move.l d0,-(a7)
	jsr l0305e(pc) | * MT.RECHP
	move.l (a7)+,d0 | * report
l00e38:	rts

l00e3a:	lea 0x0068(a0),a3 | * CLOSE CON / SER
	tst.l (a3)
	beq.s l00e70
	movea.l (a3),a2
	cmpa.l a2,a3
	bne.s l00e4e
	clr.l 0x004c(a6) | * SV.KEYQ
	bra.s l00e70

l00e4e:	cmpa.l 0x004c(a6),a3 | * SV.KEYQ
	bne.s l00e66
l00e54:	tst.b -0x0025(a2)
	bne.s l00e62
	cmpa.l (a2),a3
	beq.s l00e62
	movea.l (a2),a2
	bra.s l00e54

l00e62:	move.l a2,0x004c(a6) | * SV.KEYQ
l00e66:	movea.l a3,a2
l00e68:	movea.l (a2),a2
	cmpa.l (a2),a3
	bne.s l00e68
	move.l (a3),(a2)
l00e70:	jsr l0305e(pc) | * MT.RECHP
	rts

l00e76:	tst.b 0x0033(a6) | * I/O OF CON/SER screen freezed
	beq.s l00e80
	moveq #-1,d0 | * not complete
	rts

l00e80:	cmpi.b #0x07,d0
	bhi.s l00efc
	moveq #-1,d7
	moveq #0x00,d6
	move.w d2,d5
	move.l d1,d4
	movea.l a1,a4
	lea 0x0068(a0),a5
	tst.l d3
	blt.s l00eb0
	cmpi.b #0x04,d0
	bhi.s l00eb0
	tst.l (a5)
	beq.s l00eec
	movea.l 0x004c(a6),a2 | * SV.KEYQ
	tst.b -0x0025(a2)
	bne.s l00eb0
	move.l a5,0x004c(a6)
l00eb0:	move.b l00eb8(pc,d0.w),d0
	jmp l00eb8(pc,d0.w)

l00eb8:	.byte l00ec0-l00eb8 | * test pending input
	.byte l00ec6-l00eb8 | * put byte
	.byte l00f54-l00eb8
	.byte l00eca-l00eb8 | * edit line
	.byte l00f5a-l00eb8
	.byte l00f00-l00eb8 | * 
	.byte l00eec-l00eb8 | * not used
	.byte l00ede-l00eb8 | * put in queue

|*------------ general scr I/O       

l00ec0:	jmp l0380a(pc) | * IO.QTEST

l00ec6:	movea.l a5,a2 | * A2=buffer adress of keyboard
	jmp l0385e(pc) | * IO.QOUT

l00eca:	moveq #0x00,d0
l00ecc:	cmp.w d4,d5 | * all chars printed
	bls.s l00eee
	movea.l a5,a2
	jsr l0385e(pc) | * IO.QOUT
	blt.s l00eee
	move.b d1,(a4)+
	addq.w #1,d4
	bra.s l00ecc

l00ede:	moveq #0x00,d0
	cmp.w d4,d5
	bls.s l00eee
	move.b (a4)+,d1
	bsr.s l00f00
	addq.w #1,d4
	bra.s l00ede

l00eec:	moveq #-0x0f,d0
l00eee:	move.w d4,d1
	movea.l a4,a1
l00ef2:	bclr #0x07,0x0042(a0)
	rts

l00efa:	moveq #0x05,d0 | * add one character to screen
l00efc:	jmp l01992(pc)

l00f00:	moveq #0x00,d0
	cmpi.b #0x0a,d1 | * CR ?
	beq.s l00f36 | * add new line
	tst.b 0x0048(a0) | * new line status ½Adder S. 337
	beq.s l00f14 | * position cursor
	move.b d1,-(a7) | * byte to send on stack
	bsr.s l00f46 | * position cursor
	move.b (a7)+,d1
l00f14:	bsr.s l00efa | * put byte
	beq.s l00f44 | * succeeded ½ end
	move.w 0x0026(a0),d0 | * if not: increment cursor
	add.w d0,0x0022(a0)
	btst #0x07,0x0042(a0)
	bne.s l00f42
	move.b d0,0x0048(a0)
	tst.b 0x0043(a0) | * cursoff ?
	beq.s l00f42 | * end
	bsr.s l00f46 | * position cursor
	bra.s l00f42

l00f36:	tst.b 0x0048(a0) | * is curosr at end of line?
	bge.s l00f3e
	bsr.s l00f46 | * position cursor
l00f3e:	st 0x0048(a0)
l00f42:	moveq #0x00,d0
l00f44:	rts

|* position cursor
l00f46:	tst.b 0x0043(a0) | * new line - cursor activ
	ble.s l00f50 | * no
	jsr l01ba2(pc) | * test position
l00f50:	jmp l01bf8(pc) | * if necessary: NL

l00f54:	tst.l d3
	beq.s l00f6c
	bra.s l00f5e

|*----------------- Line editor

l00f5a:	moveq #-0x01,d4
	move.w d1,d4
l00f5e:	swap d1
	move.w d1,d6 | * d6=position of cursor
	suba.w d4,a4 | * position cursor in buffer
	adda.w d6,a4
	bne.s l00f84 | * end of buffer
	tst.l d3
	blt.s l00f84
l00f6c:	tst.b 0x0043(a0) | * curson ?
	ble.s l00f76
	jsr l01ba2(pc) | * position cursor ..
l00f76:	jsr l01bf2(pc) | * if neccessary to start
	bsr.w l010dc | * of next line
	move.w d4,d6
	sub.w d3,d6
	suba.w d3,a4
l00f84:	move.b 0x43(a0),-(a7)
l00f88:	movea.l a5,a2 | * keyboard buffer
	jsr l0385e(pc) | * IO.QOUT get byte
	blt.w l01018 | * EOF ?
	tst.b 0x43(a0) | * cursor activ
	ble.s l00fa0
	move.b d1,-(a7) | * received byte
	jsr l01ba2(pc) | * position cursor
	move.b (a7)+,d1
l00fa0:	cmpi.b #0x0a,d1 | * CR?
	beq.s l01002
	cmpi.b #0x1f,d1 | * less 31 - do nothing
	bls.s l00f88
	cmpi.b #0xbf,d1 | * higher 191 - append square
	bhi.s l00fda
	move.w d4,d0 | * d4 = length of line
	sub.w d6,d0 | * actual position
	bra.s l00fbe | * store byte

l00fb8:	move.b 0x00(a4,d0.w),0x01(a4,d0.w) | * line out
l00fbe:	dbf d0,l00fb8
	addq.w #1,d6
	addq.w #1,d4 | * correct pointer
	move.b d1,(a4)+ | * store bytes
	moveq #-0x01,d7
	bsr.w l010ac
	bsr.w l010ce | * scroll ?
	cmp.w d4,d5
	bhi.s l00f88 | * more bytes editable
	moveq #-0x05,d0 | * "buffer full "
	bra.s l01022

l00fda:	tst.l d4
	bge.s l00fea
	cmpi.b #0xd0,d1 | * cursor up
	beq.s l01002
	cmpi.b #0xd8,d1 | * down
	beq.s l01002
l00fea:	subi.b #0xc0,d1 | * left
	beq.s l01030
	subq.b #2,d1 | * ctrl-left
	beq.w l0107c
	subq.b #6,d1 | * right
	beq.s l01038
	subq.b #2,d1 | * ctrl-right
	beq.w l01080
l01000:	bra.s l00f88 | * position cursor

l01002:	move.b d1,-(a7) | * output of line - cursor up/down
	moveq #-0x01,d7
	bsr.w l010e0
	move.b (a7)+,(a4)+
	addq.w #1,d4
	jsr l01b94(pc)
	bsr.w l00f36
	bra.s l0102a

l01018:	tst.b (a7) | * end of edit
	blt.s l01022
	jsr l01b86(pc)
	moveq #-0x01,d0
l01022:	suba.w d6,a4
	adda.w d4,a4
	move.w d6,d1
	swap d1
l0102a:	addq.w #2,a7
	bra.w l00eee

l01030:
	bsr.s l01054 | * cursor left previous line ?
	beq.s l01000 | * pos. cursor
l01034:	addq.w #1,d6
	bra.s l01000

l01038:
	addq.w #1,d6 | * cursor right
	cmp.w d4,d6
	bhi.s l01050 | * end of buffer?
	addq.w #1,a4
	jsr l01c48(pc) | * pos cursor right
	beq.s l01000
	jsr l01bf8(pc)
	bsr.w l010ce
	bra.s l01000

l01050:	subq.w #1,d6
l01052:	bra.s l01000

l01054:	subq.w #1,d6 | * previous line to edit
	blt.s l0107a
	jsr l01c3e(pc)
	beq.s l01078
	jsr l01c56(pc)
	bne.s l010da
	move.w 0x001c(a0),d0
	divu 0x0026(a0),d0
	subq.w #1,d0
	mulu 0x0026(a0),d0
	move.w d0,0x0022(a0)
	moveq #0x00,d0
l01078:	subq.w #1,a4
l0107a:	bra.s l010da

l0107c:	bsr.s l01054 | * delete one char: ctrl-left-right
	bne.s l01034
l01080:	cmp.w d6,d4
	beq.s l01052
	subq.w #1,d4
	move.w d4,d0
	sub.w d6,d0
	move.w d0,d1
	bra.s l01092

l0108e:	move.b 0x0001(a4),(a4)+
l01092:	dbf d0,l0108e
	suba.w d1,a4
	move.l 0x0022(a0),-(a7)
	moveq #0x00,d7
	bsr.s l010e0
	bne.s l010a6
	moveq #0x20,d1
	bsr.s l010ac
l010a6:	move.l (a7)+,d7
	bsr.s l010d0
	bra.s l01052

l010ac:	bsr.w l00efa | * position cursor
	beq.s l010da
	jsr l01c32(pc)
	beq.s l010da
	tst.w d7
	blt.s l010c8
	sub.w 0x0028(a0),d7
	bge.s l010c8
	add.w 0x0028(a0),d7
	bra.s l01100

l010c8:	jsr l01bf8(pc) | * scroll if needed
	bra.s l010d8

l010ce:	bsr.s l010dc
l010d0:	suba.w d4,a4
	adda.w d6,a4
	move.l d7,0x0022(a0)
l010d8:	moveq #0x00,d0
l010da:	rts

l010dc:	move.l 0x0022(a0),d7
l010e0:	moveq #0x00,d0
	move.w d4,d3
	sub.w d6,d3
	bra.s l010f4

l010e8:	move.b (a4)+,d1
	move.w d3,-(a7)
	bsr.s l010ac
	move.w (a7)+,d3
	tst.l d0
	bne.s l010fc
l010f4:	dbf d3,l010e8
	moveq #0x00,d3
	rts

l010fc:	adda.w d3,a4
	addq.w #1,d3
l01100:	tst.l d0
	rts

|* ----------End of line editor

.balign 2, 0 ; l01104:	.long 0x0 | * nothing left to link
.balign 2, 0 ; 	.long l01186 | * I/O net
.balign 2, 0 ; 	.long l01114 | * open net#
.balign 2, 0 ; 	.long l01158 | * close net#

l01114:	subq.w #4,a7
	movea.l a7,a3
	jsr l0372c(pc) | * IO.DECODE
	bra.s l01154 | *  ERROR
	bra.s l01154 | *  ERROR
	bra.s l01132 | *  SUCCESS

.balign 2, 0 ; o1122:	.word 0x0003
	.ascii "NET"
	.byte 0x00
.balign 2, 0 ; 	.word 2 | * two parameters
.balign 2, 0 ; 	.word 2 | * initialise to second 
	.ascii "OI"
	.ascii " _"
.balign 2, 0 ; 	.word 0 | * number

l01132:	move.w #0x120,d1
	jsr l02fae(pc) | * MM.ALCHP
	bne.s l01154
	move.b 0x0003(a7),0x0018(a0)
	move.b 0x0037(a6),0x0019(a0) | * SV.NETNR
	move.b 0x0001(a7),0x001c(a0)
	subq.b #2,0x001c(a0)
	moveq #0x00,d0
l01154:	addq.w #4,a7
	rts

l01158:	tst.b 0x001c(a0) | * close net
	bge.s l0117e
	move.b #0x01,0x001c(a0)
	move.b 0x011f(a0),0x001d(a0)
l0116a:	tst.b 0x00ee(a6) | * SV.MDRUN
	bne.s l0116a
	move.w #0x0578,d4
l01174:	jsr l05538:l
	dbeq d4,l01174
l0117e:	jmp l0305e(pc) | * MT.RECHP

l01182:	moveq #-0x0f,d0
	rts

l01186:	jsr l0388c(pc) | * IO.SERIO for net#

l0118a:
.balign 2, 0 ; 	.long l01198 | * test byte
.balign 2, 0 ; 	.long l011c4 | * read
.balign 2, 0 ; 	.long l011d0 | * write
	rts | * if error: back

l01198:	move.b 0x001c(a0),d0 | * test byte
	blt.s l01182
	moveq #0x00,d2
	move.b 0x011f(a0),d2
	move.b 0x20(a0,d2.w),d1
	sub.b 0x001d(a0),d2
	bcs.s l011cc
	tst.b d0
	beq.s l011b6
	moveq #-0x0a,d0
	rts

l011b6:	sf 0x011f(a0)
	jsr l054a2:l
	beq.s l01198
	rts

l011c4:	bsr.s l01198 | * read net#
	bne.s l011ce
	addq.b #1,0x011f(a0)
l011cc:	moveq #0x00,d0
l011ce:	rts

l011d0:	tst.b 0x001c(a0) | * write net#
	bge.s l01182
	moveq #0x01,d2
	add.b 0x011f(a0),d2
	bcc.s l011f8
	move.b d1,-(a7)
	move.w #0x00ff,0x001c(a0)
	jsr l05538:l
	move.b (a7)+,d1
	st 0x001c(a0)
	tst.l d0
	bne.s l011ce
	moveq #0x01,d2
l011f8:	move.b d1,0x1f(a0,d2.w)
	move.b d2,0x011f(a0)
	bra.s l011cc

l01202:
.balign 2, 0 ; 	.long l02d00 | * pointer to list of scheduler tasks
.balign 2, 0 ; 	.long l0120a | * pointer to first task

l0120a:	move.l 0x004c(a6),d4 | * SV.KEYQ
	beq.s l0122e
	movea.l d4,a0
	lea -0x0068(a0),a0
	move.w 0x00aa(a6),d4 | * SV.FSTAT
	tst.b 0x0043(a0)
	beq.s l01228
	sub.w d3,d4
	bgt.s l0122a
	jsr l01ba2(pc) | * show cursor (flash)
l01228:	moveq #0x0c,d4
l0122a:	move.w d4,0x00aa(a6) | * SV.FSTAT
l0122e:	rts

	.include "mdv_main.s"

|* clock-traps       

tr1d13:
tr1d14:
tr1d15:
.equ xltr1d13, tr1d13
.equ xltr1d14, tr1d13
.equ xltr1d15, tr1d15

l0195a:	lea 0x00018000,a0

l01960:	move.l (a0),d2
	cmp.l (a0),d2
	bne.s l01960
	cmpi.b #0x14,d0
	bgt.s l01972
	beq.s l01974
	move.l d2,d1
	bra.s l0198e

l01972:	add.l d2,d1 | * adjust
l01974:	sf (a0)+
	moveq #-0x11,d0
	moveq #0x03,d3
l0197a:	rol.l #8,d1
	moveq #0x00,d2
	move.b d1,d2
	bra.s l01984
l01982:	move.b d0,(a0)
l01984:	dbf d2,l01982
	ror.b #1,d0
	dbf d3,l0197a

l0198e:	bra.w l003a4


|***********************
|*
|* START SCREEN + CON
|*
|***********************
|*
|* screen printing routine for trap 3 d0=5 or d0 = [$09 - $36]
|* this routine is extremely slow - it should be speeded up
|*
|***********************

l01992:	move.b 0x0043(a0),-(a7) | * cursor status 
	ble.s l019a4 | * cursor inactiv
	movem.w d0-d2,-(a7) | * calling params of TRAP 3
	jsr l01ba2(pc) | * get cursor positon
	movem.w (a7)+,d0-d2
l019a4:	cmpi.b #0x05,d0 | * is Trap3 d0=5 ?
	bne.s l019b0 | * no
	jsr l01a4c(pc) | * execute trap 
	bra.s l019ce

l019b0:	cmpi.w #0x0036,d0 | * d0>36
	bhi.s l019ee
	cmpi.w #0x0009,d0 | * do<9
	blt.s l019ee
	bgt.s l019c2
	jsr (a2) | * sd.extop: do userroutine
	bra.s l019ce

l019c2:	add.b d0,d0 | * adjust d0 for displacement
	movea.w l019f2-0x14(pc,d0.w),a3 | * !!!must depend on 19F2
	lsr.l #1,d0
	jsr l019f2-0x60(pc,a3.w) | * !!! $60=Tr3disp
l019ce:	tst.b (a7)+ | * test cursor status
	ble.s l019e8 | * inactiv
	tst.l d0 | * any errors?
	bne.s l019e8
	tst.b 0x0043(a0) | * again: test cursor status
	bge.s l019e8 | * inactiv
	movem.l d0-d2,-(a7) | * save cursor status
	jsr l01b86(pc) | * reposition cursor
	movem.l (a7)+,d0-d2
l019e8:	tst.l d0
	rts

tr3d1c:
tr3d1d:
.equ xtr3d1c, tr3d1c
.equ xtr3d1d, tr3d1c

l019ec:	addq.l #4,a7
l019ee:	moveq #-0x0f,d0
	bra.s l019ce

l019f2:
.equ tr3disp, l019f2-0x60

.balign 2, 0 ; 	.word xtr3d0a-tr3disp
.balign 2, 0 ; 	.word xtr3d0b-tr3disp
.balign 2, 0 ; 	.word xtr3d0c-tr3disp
.balign 2, 0 ; 	.word xtr3d0d-tr3disp
.balign 2, 0 ; 	.word xtr3d0e-tr3disp
.balign 2, 0 ; 	.word xtr3d0f-tr3disp
.balign 2, 0 ; 	.word xtr3d10-tr3disp
.balign 2, 0 ; 	.word xtr3d11-tr3disp
.balign 2, 0 ; 	.word xtr3d12-tr3disp
.balign 2, 0 ; 	.word xtr3d13-tr3disp
.balign 2, 0 ; 	.word xtr3d14-tr3disp
.balign 2, 0 ; 	.word xtr3d15-tr3disp
.balign 2, 0 ; 	.word xtr3d16-tr3disp
.balign 2, 0 ; 	.word xtr3d17-tr3disp
.balign 2, 0 ; 	.word xtr3d18-tr3disp
.balign 2, 0 ; 	.word xtr3d19-tr3disp
.balign 2, 0 ; 	.word xtr3d1a-tr3disp
.balign 2, 0 ; 	.word xtr3d1b-tr3disp
.balign 2, 0 ; 	.word xtr3d1c-tr3disp
.balign 2, 0 ; 	.word xtr3d1d-tr3disp
.balign 2, 0 ; 	.word xtr3d1e-tr3disp
.balign 2, 0 ; 	.word xtr3d1f-tr3disp
.balign 2, 0 ; 	.word xtr3d20-tr3disp
.balign 2, 0 ; 	.word xtr3d21-tr3disp
.balign 2, 0 ; 	.word xtr3d22-tr3disp
.balign 2, 0 ; 	.word xtr3d23-tr3disp
.balign 2, 0 ; 	.word xtr3d24-tr3disp
.balign 2, 0 ; 	.word xtr3d25-tr3disp
.balign 2, 0 ; 	.word xtr3d26-tr3disp
.balign 2, 0 ; 	.word xtr3d27-tr3disp
.balign 2, 0 ; 	.word xtr3d28-tr3disp
.balign 2, 0 ; 	.word xtr3d29-tr3disp
.balign 2, 0 ; 	.word xtr3d2a-tr3disp
.balign 2, 0 ; 	.word xtr3d2b-tr3disp
.balign 2, 0 ; 	.word xtr3d2c-tr3disp
.balign 2, 0 ; 	.word xtr3d2d-tr3disp
.balign 2, 0 ; 	.word xtr3d2e-tr3disp
.balign 2, 0 ; 	.word xtr3d2f-tr3disp
.balign 2, 0 ; 	.word xtr3d30-tr3disp
.balign 2, 0 ; 	.word xtr3d31-tr3disp
.balign 2, 0 ; 	.word xtr3d32-tr3disp
.balign 2, 0 ; 	.word xtr3d33-tr3disp
.balign 2, 0 ; 	.word xtr3d34-tr3disp
.balign 2, 0 ; 	.word xtr3d35-tr3disp
.balign 2, 0 ; 	.word xtr3d36-tr3disp

tr3d05:
.equ xtr3d05, tr3d05
l01a4c:	jsr l01bce(pc) | * trap#3,D0 = 05
	blt.s l01a76
	move.b d1,d2
	move.l 0x0018(a0),d0 | * window topleftside
	add.l 0x0022(a0),d0 | * cursor position
	move.w d0,d1
	swap d0
	move.b 0x0042(a0),d3 | * arguments for printing like
|* underline, strip, colour, size etc. are now in D3

	lea 0x003a(a0),a1 | * strip colour mask
	movem.l 0x002a(a0),a2-a3 | * font adress
	jsr l02840(pc) | * prin char
	bra.w l01c48 | * cursor-movement
l01a76:	rts

tr3d0a:
.equ xtr3d0a, tr3d0a
l01a78:
	jsr l01bf2(pc) | * trap#3,D0 = 0A
	move.l 0x001c(a0),(a1)
	move.l 0x0022(a0),0x0004(a1)
	moveq #0x00,d0
	rts

tr3d0b:
.equ xtr3d0b, tr3d0b
l01a8a:
	bsr.s l01a78 | * trap#3,D0 = 0B
	move.l d1,-(a7)
	move.w 0x0026(a0),d0
	bsr.s l01aaa
	bsr.s l01aaa
	subq.w #6,a1
	move.w 0x0028(a0),d0
	bsr.s l01aaa
	bsr.s l01aaa
	move.l (a7)+,d1
	suba.w #0x000a,a1
	moveq #0x00,d0
	rts

l01aaa:	moveq #0x00,d1
	move.w (a1),d1
	divu d0,d1
	move.w d1,(a1)
	addq.w #4,a1
	rts

l01ab6:
tr3d0d:
.equ xtr3d0d, tr3d0d
	movem.w d1-d4,-(a7) | * trap#3,D0 = 0D
	jsr l01c1c(pc)
	movem.w (a1),d0-d3
	exg d0,d2
	exg d1,d3
	moveq #0x00,d4
	bclr d4,d0
	bclr d4,d2
	tst.w d2
	beq.w l01b64
	tst.w d3
	beq.w l01b64
	move.w d0,d4
	add.w d2,d4
	bcs.w l01b64
	cmpi.w #0x0200,d4
	bhi.s l01b64
	move.w d1,d4
	add.w d3,d4
	bcs.s l01b64
	cmpi.w #0x0100,d4
	bhi.s l01b64
	clr.w 0x0020(a0)
	bra.s l01b12

|* set border
tr3d0c:
.equ xtr3d0c, tr3d0c
l01af8:	move.b d1,0x0047(a0) | * trap#3,D0 = 0C
l01afc:	movem.w d1-d4,-(a7)
	cmp.w 0x0020(a0),d2
	beq.s l01b0a
	jsr l01c1c(pc)
l01b0a:	movem.w 0x0018(a0),d0-d4
	bsr.s l01b6c
l01b12:	move.w 0x0002(a7),d4
	cmpi.w #0x0100,d4
	bhi.s l01b64
	bsr.s l01b6e
	movem.w d0-d4,0x0018(a0)
	beq.s l01b60
	move.w (a7),d1
	cmpi.b #0x80,d1
	beq.s l01b60
	movea.l a7,a1
	jsr l027d8(pc)
	move.w 0x001a(a0),d1
	bsr.s l01b6c
	neg.w d4
	exg d3,d4
	jsr l025be(pc)
	add.w d4,d1
	sub.w d3,d1
	jsr l025be(pc)
	add.w d3,d1
	sub.w d4,d1
	exg d3,d4
	add.w d4,d4
	exg d2,d4
	jsr l025be(pc)
	add.w d4,d0
	sub.w d2,d0
	jsr l025be(pc)
l01b60:	moveq #0x00,d0
	bra.s l01b66

l01b64:	moveq #-0x04,d0 | * 'out of range'
l01b66:	movem.w (a7)+,d1-d4
	rts

l01b6c:	neg.w d4
l01b6e:	add.w d4,d1
	add.w d4,d4
	sub.w d4,d3
	ble.s l01b82
	add.w d4,d0
	add.w d4,d4
	sub.w d4,d2
	ble.s l01b82
	asr.w #2,d4
	rts

l01b82:	addq.w #4,a7
	bra.s l01b64

tr3d0e:
.equ xtr3d0e, tr3d0e
l01b86:	moveq #0x01,d2
	tst.b 0x0043(a0)
	bgt.s l01bca
	jsr l01bf2(pc)
	bra.s l01baa

tr3d0f:
.equ xtr3d0f, tr3d0f
l01b94:	moveq #0x00,d2
	tst.b 0x0043(a0)
	bgt.s l01baa
	move.b d2,0x0043(a0)
	bra.s l01bca

l01ba2:	move.b 0x0043(a0),d2
	beq.s l01bca
	neg.b d2
l01baa:	jsr l01bce(pc)
	blt.s l01bcc
	move.b d2,0x0043(a0)
	move.l 0x0018(a0),d0
	add.l 0x0022(a0),d0
	move.w d0,d1
	swap d0
	movem.w 0x0026(a0),d2-d3
	jsr l02548(pc)
l01bca:	moveq #0x00,d0
l01bcc:	rts

l01bce:	move.l 0x0022(a0),d0 | * verify cursor in window
	bmi.s l01bee
	tst.w d0
	bmi.s l01bee
	add.l 0x0026(a0),d0
	cmp.w 0x001e(a0),d0
	bhi.s l01bee
	swap d0
	cmp.w 0x001c(a0),d0
	bhi.s l01bee
	moveq #0x00,d0
	rts

l01bee:	moveq #-0x04,d0 | * out of range
	rts

tr3d2f:
.equ xtr3d2f, tr3d2f
l01bf2:	tst.b 0x0048(a0)
	beq.s l01c1a
l01bf8:	movem.l d0-d2/a1,-(a7)
	jsr l01c32(pc)
	beq.s l01c12
	moveq #0x18,d0
	move.w 0x0028(a0),d1
	neg.w d1
	jsr l01cbe(pc)
	clr.w 0x0022(a0)
l01c12:	sf 0x0048(a0)
	movem.l (a7)+,d0-d2/a1
l01c1a:	rts

l01c1c:	clr.l 0x0022(a0)
	bra.s l01c9a

tr3d10:
.equ xtr3d10, tr3d10
	mulu 0x0028(a0),d2
	bra.s l01c2c

tr3d11:
.equ xtr3d11, tr3d11
	move.w 0x0024(a0),d2
l01c2c:	mulu 0x0026(a0),d1
	bra.s l01c6c

tr3d12:
.equ xtr3d12, tr3d12
l01c32:	moveq #0x00,d1
	move.w 0x0024(a0),d2
	add.w 0x0028(a0),d2
	bra.s l01c6c

tr3d13:
.equ xtr3d13, tr3d13
l01c3e:	move.w 0x0022(a0),d1
	sub.w 0x0026(a0),d1
	bra.s l01c50

tr3d14:
.equ xtr3d14, tr3d14
|* cursor-movement
l01c48:	move.w 0x0022(a0),d1
	add.w 0x0026(a0),d1
l01c50:	move.w 0x0024(a0),d2
	bra.s l01c6c

tr3d15:
.equ xtr3d15, tr3d15
l01c56:	move.w 0x0024(a0),d2
	sub.w 0x0028(a0),d2
	bra.s l01c68

tr3d16:
.equ xtr3d16, tr3d16
	move.w 0x0024(a0),d2
	add.w 0x0028(a0),d2
l01c68:	move.w 0x0022(a0),d1
tr3d17:
.equ xtr3d17, tr3d17
l01c6c:	move.w d1,d0
	blt.s l01ca2
	add.w 0x0026(a0),d0
	cmp.w 0x001c(a0),d0
	bhi.s l01ca2
	move.w d2,d0
	blt.s l01ca2
	add.w 0x0028(a0),d0
	cmp.w 0x001e(a0),d0
	bhi.s l01ca2
l01c88:	btst #0x03,0x0034(a6) | * SV.MCSTA
	beq.s l01c94
	bclr #0x00,d1
l01c94:	movem.w d1-d2,0x0022(a0)
l01c9a:	sf 0x0048(a0)
	moveq #0x00,d0
	rts

l01ca2:	moveq #-0x04,d0
	rts

tr3d26:
.equ xtr3d26, tr3d26
	moveq #0x00,d0
	lea l025d6(pc),a2
	bra.s l01ce0

tr3d20:
.equ xtr3d20, tr3d20
l01cae:	jsr l01c1c(pc)
	moveq #0x20,d0
tr3d21:
tr3d22:
tr3d23:
tr3d24:
.equ xtr3d21, tr3d21
.equ xtr3d22, tr3d22
.equ xtr3d23, tr3d23
.equ xtr3d24, tr3d24
	subi.w #0x0020,d0
	lea l025be(pc),a2
	bra.s l01cdc

tr3d18:
tr3d19:
tr3d1a:
.equ xtr3d18, tr3d18
.equ xtr3d19, tr3d19
.equ xtr3d1a, tr3d1a
l01cbe:	subi.w #0x0018,d0
	lea l025fe(pc),a2
	bra.s l01cdc
tr3d1b:
tr3d1e:
tr3d1f:
.equ xtr3d1b, tr3d1b
.equ xtr3d1e, tr3d1b
.equ xtr3d1f, tr3d1b
	subi.w #0x001b,d0
	lea l02648(pc),a2
	btst #0x03,0x0034(a6) | * SV.MCSTA
	beq.s l01cdc
	bclr #0x00,d1
l01cdc:	lea 0x0036(a0),a1
l01ce0:	movem.l d4-d5,-(a7)
	move.w d1,d4
	move.w d0,d5
	movem.w 0x0018(a0),d0-d3
	subq.w #1,d5
	blt.s l01d22
	bgt.s l01cfa
	move.w 0x0024(a0),d3
	bra.s l01d22

l01cfa:	add.w 0x0024(a0),d1
	subq.w #2,d5
	bge.s l01d12
	sub.w 0x0024(a0),d3
	move.w 0x0028(a0),d5
	add.w d5,d1
	sub.w d5,d3
	ble.s l01d24
	bra.s l01d22

l01d12:	move.w 0x0028(a0),d3
	tst.w d5
	beq.s l01d22
	add.w 0x0022(a0),d0
	sub.w 0x0022(a0),d2
l01d22:	jsr (a2)
l01d24:	moveq #0x00,d0
	movem.l (a7)+,d4-d5
	rts
tr3d2e:
.equ xtr3d2e, tr3d2e
	lea l025be(pc),a3
	btst #0x03,0x0042(a0)
	beq.s l01d3c
	lea l025ca(pc),a3
l01d3c:	movea.l a1,a2
	subq.w #4,a7
	movea.l a7,a1
	jsr l027d8(pc)
	move.l #0x01ff01ff,d3
	btst #0x03,0x0034(a6) | * SV.MCSTA
	beq.s l01d58
	bclr #0x10,d3
l01d58:	movem.l (a2),d0/d2
	exg d0,d2
	and.l d3,d0
	and.l d3,d2
	move.l d0,d3
	add.l d2,d3
	cmp.w 0x001e(a0),d3
	bgt.s l01d88
	swap d3
	cmp.w 0x001c(a0),d3
	bgt.s l01d88
	add.l 0x0018(a0),d0
	move.w d2,d3
	swap d2
	move.w d0,d1
	swap d0
	jsr (a3)
	moveq #0x00,d0
l01d84:	addq.w #4,a7
	rts

l01d88:	moveq #-0x04,d0
	bra.s l01d84

tr3d25:
.equ xtr3d25, tr3d25
	move.l a1,d0
	bgt.s l01d96
	lea l0ad9a:l,a1 | * PIXEL F§R SCREEN
l01d96:	move.l a2,d0
	bgt.s l01da0
	lea l0b106:l,a2 | * PIXEL-ADRESSEN
l01da0:	movem.l a1-a2,0x002a(a0)
	moveq #0x00,d0
	rts

tr3d27:
tr3d28:
tr3d29:
.equ xtr3d27, tr3d27
.equ xtr3d28, tr3d28
.equ xtr3d29, tr3d29
	subi.w #0x0027,d0
	move.b d1,0x44(a0,d0.w)
	lsl.w #2,d0
	lea 0x36(a0,d0.w),a1
	moveq #0x00,d0
	jmp l027d8(pc)

tr3d2a:
.equ xtr3d2a, tr3d2a
	btst #0x03,0x0034(a6) | * SV.MCSTA
	beq.w l01e3c
	moveq #0x02,d0
	bra.s l01dd4
tr3d2c:
.equ xtr3d2c, tr3d2c
	moveq #0x0c,d0
	lsl.b #2,d1
	bra.s l01e3e
tr3d2b:
.equ xtr3d2b, tr3d2b
	moveq #0x01,d0
l01dd4:	tst.b d1
	sne d1
	bra.s l01e3e
tr3d2d:
.equ xtr3d2d, tr3d2d
	jsr l01bf2(pc)
	andi.w #0x0003,d1
	andi.w #0x0001,d2
	btst #0x03,0x0034(a6) | * SV.MCSTA
	beq.s l01df2
	bset #0x01,d1
l01df2:
	move.b l01e4e(pc,d1.w),0x0027(a0) | * store horizontal increment
	move.b l01e52(pc,d2.w),0x0029(a0) | * vertical increment
	lsl.b #1,d1
	or.b d2,d1
	lsl.b #4,d1
	moveq #0x70,d0
	bsr.s l01e3e
	move.w 0x0022(a0),d0
	add.w 0x0026(a0),d0
	cmp.w 0x001c(a0),d0
	bls.s l01e1a
	jsr l01bf8(pc)
l01e1a:	move.w 0x0024(a0),d0
	add.w 0x0028(a0),d0
	cmp.w 0x001e(a0),d0
	bls.s l01e4a
	moveq #0x18,d0
	moveq #-0x0a,d1
	jsr l01cbe(pc)
	subi.w #0x000a,0x0024(a0)
	bge.s l01e4a
	clr.w 0x0024(a0)
l01e3c:	bra.s l01e4a

l01e3e:	and.b d0,d1
	not.b d0
	and.b d0,0x0042(a0)
	or.b d1,0x0042(a0)
l01e4a:	moveq #0x00,d0
	rts

.balign 2, 0 ; l01e4e:	.long 0x06080c10 | * 6,8,12,16 pixels
.balign 2, 0 ; l01e52:	.word 0x0a14 | * 10,20 pixels

tr3d36:
.equ xtr3d36, tr3d36
	lea 0x0018(a1),a4
	jsr l021dc(pc)
	move.l l02242(pc),-(a1)
	move.w l02240(pc),-(a1)
	jsr l020d8(pc)
	lea l01e90(pc),a3
	jsr l0419e(pc)
	lea 0x0018(a1),a1
	bsr.s l01e8a
	move.w (a1)+,d1
	bsr.s l01e8a
	move.w 0x001e(a0),d2
	sub.w (a1)+,d2
	bset #0x07,0x0042(a0)
	jmp l01c88(pc)

l01e8a:	moveq #0x02,d0
	jmp l04196(pc)

|* table for calculation of pixel-graphics

.balign 2, 0 ; l01e90:	.word 0x1210
.balign 2, 0 ; 	.word 0x16ee
.balign 2, 0 ; 	.word 0xdc0c
.balign 2, 0 ; 	.word 0x0efa
.balign 2, 0 ; 	.word 0x0cfb
.balign 2, 0 ; 	.word 0xe8e2
.balign 2, 0 ; 	.word 0x0c0e
.balign 2, 0 ; 	.word 0x0ef4
.balign 2, 0 ; 	.word 0x0af5
.balign 2, 0 ; 	.word 0x0000

tr3d34:
.equ xtr3d34, tr3d34
	lea 0x004a(a0),a2
	moveq #0x12,d0
l01eaa:	move.w (a1)+,(a2)+
	subq.w #2,d0
	bne.s l01eaa
	rts

tr3d35:
.equ xtr3d35, tr3d35
	movea.l a0,a4
	tst.l d1
	bne.s l01ec2
	bsr.s l01efa
	move.b #0x00,0x0049(a4)
	bra.s l01ef4

l01ec2:	cmpi.l #1,d1
	bne.s l01ee4
	bsr.s l01efa
	move.b #0x01,0x0049(a4)
	move.l #0x410,d1
	jsr l02fae(pc) | * MM.ALCHP
	bne.s l01ef6
	move.l a0,0x005c(a4)
	bra.s l01ef4

l01ee4:	btst #0x00,d1
	beq.s l01ef0
	clr.l 0x0060(a4)
	bra.s l01ef4

l01ef0:	move.l d1,0x0060(a4)
l01ef4:	moveq #0x00,d0
l01ef6:	movea.l a4,a0
	rts

l01efa:	tst.b 0x0049(a4)
	beq.s l01f08
	movea.l 0x005c(a4),a0
	jsr l0305e(pc) | * MT.RECHP
l01f08:	rts

tr3d30:
.equ xtr3d30, tr3d30
	move.l a4,-(a7)
	lea 0x000c(a1),a4
	move.l -(a4),-(a1)
	move.l -(a4),-(a1)
	move.l -(a4),-(a1)
	movea.l (a7)+,a4
tr3d31:
.equ xtr3d31, tr3d31
	movem.l a3/a5,-(a7)
	lea l01f26(pc),a3
	subq.l #6,a1
	bra.w l02100

.balign 2, 0 ; l01f26:	.word 0x0001 | !!! displ. for point and line ROUTINE 1
.balign 2, 0 ; 	.word xl01f45-. | !!! LAST ADDR. OF OPERATION TABLE          
.balign 2, 0 ; 	.word xl0205c-. | !!! first routine for calculation
.balign 2, 0 ; 	.word xl01f38-. | !!! ADRESS OF 2. OP. TABLE
.balign 2, 0 ; 	.word xl02136-. | !!! second routine for calcul.

l01f38:
.equ xl01f38, l01f38
.balign 2, 0 ; 	.long 0xdc16d00c
.balign 2, 0 ; 	.long 0x16161616
.balign 2, 0 ; 	.long 0xe8f40cbe
.balign 2, 0 ; 	.long 0x0efaee0c
.balign 2, 0 ; 	.long 0xbe0edc16
l01f44:	.byte 0x16
	.byte 0x00

.equ xl01f45, l01f44+1 | !!! TO HAVE LABELS ON EVEN ADDR.


tr3d32:
.equ xtr3d32, tr3d32
	movem.l a3/a5,-(a7)
	lea 0x0002(a1),a4
	tst.l (a4)+
	bgt.s l01f64
	moveq #0x14,d0
	jsr l04196(pc)
	movem.l (a4)+,d2-d7
	movem.l d2-d4,-(a4)
	movem.l d5-d7,-(a4)
l01f64:	lea l01f6c(pc),a3
	bra.w l02100

|* displacement for arc-routines

.balign 2, 0 ; l01f6c:	.word 0x0003 | ROUTINE AND TABLE
.balign 2, 0 ; 	.word xl01f45-. | LAST ADDR OF OPERATION TABLE
.balign 2, 0 ; 	.word xl0205c-. | first calculation routine
.balign 2, 0 ; of72:	.word xl01f7e-. | table of operators
.balign 2, 0 ; 	.word xl01fa8-. | calcul. routine
.balign 2, 0 ; of76:	.word xl01fd0-. | oper. table
.balign 2, 0 ; 	.word xl01fce-. | calcul rout (RTS)
.balign 2, 0 ; of7a:	.word xl021ea-. | oper. table
.balign 2, 0 ; 	.word xl02136-. | calcul routine

l01f7e:
.equ xl01f7e, l01f7e
.balign 2, 0 ; 	.word 0xfaee
.balign 2, 0 ; 	.word 0x0ce2
.balign 2, 0 ; 	.word 0xc40e
.balign 2, 0 ; 	.word 0xb810
.balign 2, 0 ; 	.word 0xd00a
.balign 2, 0 ; 	.word 0xf4e8
.balign 2, 0 ; 	.word 0x0c16
.balign 2, 0 ; 	.word 0x160e
.balign 2, 0 ; 	.word 0xa616
.balign 2, 0 ; 	.word 0x0e0a
.balign 2, 0 ; 	.word 0xe2ca
.balign 2, 0 ; 	.word 0x101a
.balign 2, 0 ; 	.word 0x160a
.balign 2, 0 ; 	.word 0x160e
.balign 2, 0 ; 	.word 0x1016
.balign 2, 0 ; 	.word 0x289a
.balign 2, 0 ; 	.word 0xa6b2
.balign 2, 0 ; 	.word 0x0a10
.balign 2, 0 ; 	.word 0x24e2
.balign 2, 0 ; 	.word 0xca10
.balign 2, 0 ; 	.word 0x0c00

l01fa8:
.equ xl01fa8, l01fa8
	tst.b -0x0058(a4)
l01fac:	bmi.s l01fbc
	move.l l0224e(pc),-(a1)
	move.w l0224c(pc),-(a1)
	moveq #0x0a,d0
	bsr.w l04196
l01fbc:	move.l -0x001e(a4),d0
	swap d0
	subq.w #1,d0
	swap d0
	cmp.l l0224c(pc),d0
	blt.s l01fce
	clr.l d2
l01fce:	rts
.equ xl01fce, l01fce

l01fd0:
.equ xl01fd0, l01fd0
.balign 2, 0 ; 	.word 0x16e2
.balign 2, 0 ; 	.word 0x0a16
.balign 2, 0 ; 	.word 0x0a18
.balign 2, 0 ; 	.word 0xd00a
.balign 2, 0 ; 	.word 0xa716
.balign 2, 0 ; 	.word 0x1816
.balign 2, 0 ; 	.word 0x8e0e
.balign 2, 0 ; 	.word 0xca8e
.balign 2, 0 ; 	.word 0x1016
.balign 2, 0 ; 	.word 0xb9b3
.balign 2, 0 ; 	.word 0x881a
.balign 2, 0 ; 	.word 0x168e
.balign 2, 0 ; 	.word 0x0e89
.balign 2, 0 ; 	.word 0x8f94
.balign 2, 0 ; 	.word 0x9b00

tr3d33:
.equ xtr3d33, tr3d33
	movem.l a3/a5,-(a7)
	lea l01ffc(pc),a3
	bra.w l02100
l01ffa:	rts
.equ xl01ffa, l01ffa
.balign 2, 0 ; l01ffc:	.word 0x0003
.balign 2, 0 ; o1fe:	.word xl0200e-.
.balign 2, 0 ; 	.word xl02018-.
.balign 2, 0 ; o202:	.word xl02017-.
.balign 2, 0 ; 	.word xl0205c-.
.balign 2, 0 ; o206:	.word xl0203a-.
.balign 2, 0 ; 	.word xl01ffa-.
.balign 2, 0 ; o20a:	.word xl021ea-.
.balign 2, 0 ; 	.word xl02136-.

l0200e:
.equ xl0200e, l0200e
.balign 2, 0 ; 	.word 0xe812
.balign 2, 0 ; 	.word 0xe9ee
.balign 2, 0 ; 	.word 0xee12
.balign 2, 0 ; 	.word 0xe80e
.balign 2, 0 ; 	.word 0xef00

l02018:
.equ xl02017, l02018-1
.equ xl02018, l02018

	cmpi.w #0x0801,(a1)
	addq.w #6,a1
	bge.s l02032
	move.l #0x6487ed51,-(a1)
	move.w #0x0801,-(a1)
	lea l02034(pc),a3
	jsr l0419e(pc)
l02032:	rts

|* table for ellipse-operations
.balign 2, 0 ; l02034:	.word 0x0aee
.balign 2, 0 ; 	.word 0xe8ef
.balign 2, 0 ; 	.word 0xe900
l0203a:
.equ xl0203a, l0203a
.balign 2, 0 ; 	.word 0xdcc4
.balign 2, 0 ; 	.word 0x160a
.balign 2, 0 ; 	.word 0xe816
.balign 2, 0 ; 	.word 0x0eee
.balign 2, 0 ; 	.word 0x160e
.balign 2, 0 ; 	.word 0xe21a
.balign 2, 0 ; 	.word 0x16e8
.balign 2, 0 ; 	.word 0x0e16
.balign 2, 0 ; 	.word 0xfa0a
.balign 2, 0 ; 	.word 0x16fb
.balign 2, 0 ; 	.word 0xefe2
.balign 2, 0 ; 	.word 0x1816
.balign 2, 0 ; 	.word 0xe80e
.balign 2, 0 ; 	.word 0x1614
.balign 2, 0 ; 	.word 0xf40a
.balign 2, 0 ; 	.word 0x16f5
.balign 2, 0 ; 	.word 0xe900

l0205c:
.equ xl0205c, l0205c
	movem.l d0-d1/a4,-(a7)
	clr.l -(a1)
	clr.w -(a1)
	moveq #0x01,d0
	ror.l #2,d0
	move.w #0x0800,d1
	moveq #0x04,d2
l0206e:	move.l d0,-(a1)
	move.w d1,-(a1)
	addq.w #1,d1
	dbf d2,l0206e
	addq.w #1,(a1)
	lea l02252(pc),a3
	moveq #0x08,d2
l02080:	move.w -(a3),-(a1)
	dbf d2,l02080
	move.w 0x001c(a0),-0x001a(a6)
	move.w 0x001e(a0),-0x001e(a6)
	clr.w -0x001c(a6)
	clr.w -0x0020(a6)
	move.w 0x0018(a0),-0x0034(a6)
	move.w 0x001a(a0),-0x0038(a6)
	clr.w -0x0036(a6)
	clr.w -0x003a(a6)
	move.b 0x0042(a0),-0x0023(a6)
	move.b 0x0049(a0),-0x0032(a6)
	move.l 0x005c(a0),-0x002a(a6)
	move.l 0x0060(a0),-0x002e(a6)
	moveq #0x01,d2
	bsr.s l020d8
	lea l020ee(pc),a3
	bsr.w l0419e
	movem.l (a7)+,d0-d1/a4
	rts

l020d8:	move.w 0x001e(a0),-(a1)
	subq.w #1,(a1)
	moveq #0x08,d0
	bsr.w l04196
	move.l 0x0058(a0),-(a1)
	move.w 0x0056(a0),-(a1)
	rts

l020ee:
|*operation table for coordinates
.balign 2, 0 ; 	.long 0x121016fa
.balign 2, 0 ; 	.long 0x0efb16f4
.balign 2, 0 ; 	.long 0x0ef516ee
.balign 2, 0 ; 	.long 0x0eefe80e
.balign 2, 0 ; 	.word 0xe900

l02100:	movem.l d1-d7/a0/a2/a4-a6,-(a7)
.balign 2, 0 ; 	.long 0x4e56ffc6 | * SHOULD BE: LINK A6,$FFC6 WHAT ASM REFUSED
	lea 0x001e(a1),a4
	move.w (a3)+,d1
l0210e:	pea 0x0002(a3)
	adda.w (a3),a3
	bsr.w l0419e
	movea.l (a7)+,a3
	pea 0x0002(a3)
	adda.w (a3),a3
	jsr (a3)
	movea.l (a7)+,a3
	dbf d1,l0210e
	unlk a6
	movem.l (a7)+,d1-d7/a0/a2/a4-a6
	movem.l (a7)+,a3/a5
	moveq #0x00,d0
	rts

l02136:
.equ xl02136, l02136
	movem.l d0-d1/a3,-(a7)
	tst.l d2
	beq.w l021c4
	move.l d2,-0x0010(a6)
	moveq #-0x01,d3
	btst #0x03,0x00028034
	beq.s l02158
	add.l d2,d2
	lsl.l #1,d3
	addq.w #1,-0x0030(a4)
l02158:	move.w d3,-0x0022(a6)
	neg.l d2
	move.l d2,-0x0004(a6)
	move.l d2,-0x000c(a6)
	clr.l -0x0008(a6)
	bsr.w l020d8
	moveq #0x10,d0
	bsr.w l04196
	bsr.s l021dc
	lea l02218(pc),a3
	bsr.w l0419e
	bsr.s l021ca
	move.l d1,d2
	bsr.s l021ca
	move.l d1,d3
	bsr.s l021ca
	move.l d1,d4
	bsr.s l021ca
	move.l d1,d6
	bsr.s l021ca
	move.l d1,d7
	lea -0x0060(a4),a1
	bsr.s l021d6
	movea.w (a1)+,a5
	lea -0x0018(a4),a1
	bsr.s l021d2
	move.l (a1)+,-0x0018(a6)
	bsr.s l021d2
	move.l (a1)+,d1
	and.w -0x0022(a6),d1
	move.l d1,-0x0014(a6)
	bsr.s l021d2
	move.l (a1)+,d1
	bsr.s l021d2
	move.l (a1)+,d0
	and.w -0x0022(a6),d0
	bsr.w l02252
	bsr.w l022ca
l021c4:	movem.l (a7)+,d0-d1/a3
	rts

l021ca:	addq.w #4,(a1)
	bsr.s l021d2
	move.l (a1)+,d1
	rts

l021d2:	moveq #0x06,d0
	bra.s l021d8


l021d6:	moveq #0x02,d0
l021d8:	jmp l04196(pc)


l021dc:	move.l 0x0052(a0),-(a1)
	move.l 0x004e(a0),-(a1)
	move.l 0x004a(a0),-(a1)
	rts

|*table to calculate convex. of arc & ellipse
l021ea:
.equ xl021ea, l021ea
.balign 2, 0 ; 	.word 0x949a
.balign 2, 0 ; 	.word 0x0c82
.balign 2, 0 ; 	.word 0x0e8e
.balign 2, 0 ; 	.word 0x0e8e
.balign 2, 0 ; 	.word 0x160e
.balign 2, 0 ; 	.word 0x169a
.balign 2, 0 ; 	.word 0x0e82
.balign 2, 0 ; 	.word 0x160e
.balign 2, 0 ; 	.word 0x169a
.balign 2, 0 ; 	.word 0x0e70
.balign 2, 0 ; 	.word 0x940e
.balign 2, 0 ; 	.word 0x0a71
.balign 2, 0 ; 	.word 0x940e
.balign 2, 0 ; 	.word 0x0a16
.balign 2, 0 ; 	.word 0x7c0e
.balign 2, 0 ; 	.word 0x7688
.balign 2, 0 ; 	.word 0x0e0a
.balign 2, 0 ; 	.word 0x1470
.balign 2, 0 ; 	.word 0x880e
.balign 2, 0 ; 	.word 0x767c
.balign 2, 0 ; 	.word 0x0e0a
.balign 2, 0 ; 	.word 0x837d
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; l02218:	.word 0x640e
.balign 2, 0 ; 	.word 0x1416
.balign 2, 0 ; 	.word 0xf40a
.balign 2, 0 ; 	.word 0xf5e8
.balign 2, 0 ; 	.word 0x0ae9
.balign 2, 0 ; 	.word 0x0e14
.balign 2, 0 ; 	.word 0x16fa
.balign 2, 0 ; 	.word 0x0aac
.balign 2, 0 ; 	.word 0x0efb
.balign 2, 0 ; 	.word 0xee0a
.balign 2, 0 ; 	.word 0xac0e
.balign 2, 0 ; 	.word 0xefd0
.balign 2, 0 ; 	.word 0xac10
.balign 2, 0 ; 	.word 0x1676
.balign 2, 0 ; 	.word 0x0e77
.balign 2, 0 ; 	.word 0x1682
.balign 2, 0 ; 	.word 0x0e83
.balign 2, 0 ; 	.word 0x160e
.balign 2, 0 ; 	.word 0x700e
.balign 2, 0 ; 	.word 0x7100
.balign 2, 0 ; l02240:	.word 0x0801
.balign 2, 0 ; l02242:	.word 0x56b8
.balign 2, 0 ; 	.long 0x51ec07f7
.balign 2, 0 ; 	.long 0x4189374c
.balign 2, 0 ; l0224c:	.word 0x0802
.balign 2, 0 ; l0224e:	.long 0x6487ed51

l02252:	cmpa.l #-1,a5
	beq.s l02264
	tst.l d2
	beq.s l022c0
	tst.l d3
	beq.s l022c0
	bra.s l02266

l02264:	suba.l a5,a5
l02266:	movea.l d3,a1
	movea.l d4,a2
	adda.l a1,a2
	movea.l d2,a3
	adda.l d4,a3
	adda.l a2,a3
	add.l d4,d3
	neg.l d3
	asr.l #1,d3
	add.l d7,d3
	move.l d6,d4
	sub.l d3,d4
	asr.l #2,d2
	neg.l d2
	sub.l d6,d2
	asr.l #1,d2
	add.l d3,d2
	move.l a5,-(a7)
	move.l d2,-(a7)
	move.l d3,d7
	move.l d4,d6
	jsr l02432(pc)
	movea.l (a7)+,a0
	movea.w #0x0008,a4
	move.b #0xff,-0x0024(a6)

l022a0:	tst.l d7
	blt.s l022a8
	tst.l d6
	bge.s l022c6
l022a8:	tst.b -0x0024(a6)
	bge.s l022b4
	bsr.w l0238a
	bra.s l022b8

l022b4:	bsr.w l023d0
l022b8:	cmpa.w #0x0000,a4
	bgt.s l022a0
	addq.l #4,a7
l022c0:	addq.l #4,a7
	jmp l021c4(pc)

l022c6:	movea.l (a7)+,a4
	rts

l022ca:	bsr.w l0248a
	bsr.s l02330
	move.l a0,d4
	bge.s l022e4
	move.l -0x0004(a6),d4
	move.l -0x0008(a6),d5
	sub.l a1,d7
	add.l a2,d6
	adda.l d7,a0
	bra.s l022f2


l022e4:	move.l -0x000c(a6),d4
	move.l -0x0010(a6),d5
	sub.l a2,d7
	add.l a3,d6
	suba.l d6,a0
l022f2:	add.l d4,d0
	add.l d5,d1
	tst.l d5
	bge.s l02302
	adda.l #0x80,a5
	bra.s l0230a


l02302:	beq.s l0230c
	suba.l #0x80,a5
l0230a:	swap d3
l0230c:	moveq #0x01,d5
	btst #0x03,0x00028034
	beq.s l0231a
	moveq #0x02,d5
l0231a:	tst.l d4
	bge.s l02326
	rol.w d5,d2
	bcc.s l0232e
	subq.l #2,a5
	bra.s l0232e


l02326:	beq.s l0232e
	ror.w d5,d2
	bcc.s l0232e
	addq.l #2,a5
l0232e:	bra.s l022ca


l02330:	move.w a4,d4
	blt.s l02386
	subq.w #2,d4
	bgt.s l02360
	move.l d1,d4
	sub.l -0x0018(a6),d4
	bge.s l02342
	neg.l d4
l02342:	subq.l #1,d4
	bgt.s l02360
	move.l d0,d4
	sub.l -0x0014(a6),d4
	bge.s l02350
	neg.l d4
l02350:	btst #0x03,0x00028034

	beq.s l0235c
	subq.l #1,d4
l0235c:	subq.l #1,d4
	ble.s l02386
l02360:	tst.l d7
	bne.s l02368
	tst.l d6
	beq.s l02386
l02368:	bge.s l02376
	tst.b -0x0024(a6)
	bgt.s l02376
	bsr.w l0238a
	bra.s l02330


l02376:	tst.l d6
	bge.s l02388
	tst.b -0x0024(a6)
	blt.s l02388
	bsr.w l023d0
	bra.s l02330


l02386:	addq.l #4,a7
l02388:	rts

l0238a:	tst.l -0x0004(a6)
	bne.s l02394
	neg.l -0x000c(a6)
l02394:	tst.l -0x0008(a6)
	bne.s l0239e
	neg.l -0x0010(a6)
l0239e:	move.l a1,d4
	neg.l d4
	movea.l d4,a1
	add.l a2,d4
	movea.l d4,a2
	adda.l a1,a2
	move.l d4,d5
	lsl.l #2,d5
	sub.l a3,d5
	movea.l d5,a3
	neg.l d7
	sub.l d4,d7
	move.l a0,d5
	neg.l d5
	sub.l d6,d5
	add.l d7,d5
	movea.l d5,a0
	sub.l d7,d6
	sub.l d7,d6
	sub.l d4,d6
	subq.l #1,a4
	move.b #0x01,-0x0024(a6)

	rts

l023d0:	tst.l -0x0008(a6)
	bne.s l023e2
	clr.l -0x0004(a6)
	move.l -0x0010(a6),-0x0008(a6)

	bra.s l023f2


l023e2:	tst.l -0x0004(a6)
	bne.s l023f2
	clr.l -0x0008(a6)
	move.l -0x000c(a6),-0x0004(a6)

l023f2:	move.l a2,d4
	lsl.l #1,d4
	sub.l a3,d4
	move.l d4,d5
	sub.l a1,d5
	movea.l d5,a1
	suba.l a3,a2
	move.l a3,d5
	neg.l d5
	movea.l d5,a3
	move.l a2,d5
	asr.l #1,d5
	neg.l d5
	add.l d6,d5
	add.l d5,d7
	move.l d6,d5
	asr.l #1,d5
	neg.l d5
	sub.l a0,d5
	add.l d7,d5
	movea.l d5,a0
	move.l a3,d5
	asr.l #3,d5
	adda.l d5,a0
	neg.l d6
	asr.l #1,d4
	add.l d4,d6
	subq.l #1,a4
	move.b #0xff,-0x0024(a6)

	rts

l02432:	movem.l d0-d1,-(a7)
	clr.l d2
	neg.l d1
	subq.l #1,d1
	move.w 0x001e(a0),d2
	add.w 0x001a(a0),d2
	add.l d2,d1
	move.w 0x0018(a0),d2
	add.l d2,d0
	move.l 0x003e(a0),d3
	btst #0x00,d1
	beq.s l02458
	swap d3
l02458:	movea.l #0x00020000,a5

	lsl.l #7,d1
	adda.l d1,a5
	move.l d0,d1
	lsr.l #3,d1
	lsl.l #1,d1
	adda.l d1,a5
	andi.w #0x000f,d0
	moveq #0x00,d2
	move.w #0x8080,d2
	btst #0x03,0x00028034

	beq.s l02482
	move.w #0xc0c0,d2
l02482:	ror.w d0,d2
	movem.l (a7)+,d0-d1
	rts

l0248a:	cmp.l -0x0020(a6),d1
	bcc.w l02546
	tst.b -0x0032(a6)
	beq.w l0251c
	movem.l d0-d3/a0-a1,-(a7)
	movea.l d1,a0
	adda.l a0,a0
	adda.l a0,a0
	adda.l #0x00000010,a0
	adda.l -0x002a(a6),a0
	move.l (a0),d2
	bset #0x1f,d0
	move.l d0,(a0)
	lsl.l #1,d0
	asr.l #1,d0
	lsl.l #1,d2
	bcc.s l02516
	asr.l #1,d2
	move.l d2,d4
	sub.l d0,d4
	bge.s l024c8
	exg d0,d2
l024c8:	tst.l d0
	bge.s l024ce
	moveq #0x00,d0
l024ce:	tst.l d2
	blt.s l02516
	cmp.l -0x001c(a6),d0
	bge.s l02516
	cmp.l -0x001c(a6),d2
	blt.s l024e2
	move.l -0x001c(a6),d2
l024e2:	sub.l d0,d2
	add.l -0x0036(a6),d0
	neg.l d1
	add.l -0x003a(a6),d1
	add.l -0x0020(a6),d1
	subq.l #1,d1
	move.w d3,-(a7)
	move.w d3,-(a7)
	swap d3
	move.w d3,-(a7)
	move.w d3,-(a7)
	movea.l a7,a1
	moveq #0x01,d3
	btst #0x03,-0x0023(a6)
	bne.s l02510
	jsr l025be(pc)
	bra.s l02514


l02510:	jsr l025ca(pc)
l02514:	addq.l #8,a7
l02516:	movem.l (a7)+,d0-d3/a0-a1
	rts

l0251c:	cmp.l -0x001c(a6),d0
	bcc.s l02546
	swap d2
	swap d3
	move.l d3,d4
	and.l d2,d4
	btst #0x03,-0x0023(a6)

	bne.s l02540
	move.l (a5),d5
	not.l d2
	and.l d2,d5
	not.l d2
	or.l d4,d5
	move.l d5,(a5)
	bra.s l02542


l02540:	eor.l d4,(a5)
l02542:	swap d2
	swap d3
l02546:	rts

l02548:	movem.l d0-d7/a0-a6,-(a7)
	bsr.s l0256a
	move.l #0x00ff00ff,d6
	move.l d6,d7
	bra.s l025d0


l02558:	move.l (a1),d6
	move.w d6,d7
	swap d7
	move.w d6,d7
	move.w (a1),d6
	btst #0x00,d1
	bne.s l0256a
	exg d6,d7
l0256a:	lsl.w #7,d1
	movea.l #0x00020000,a1 | * screen mem address
	adda.w d1,a1
	lsl.w #6,d3
	movea.w d3,a2
	adda.l a2,a2
	move.w d0,d1
	lsr.w #4,d1
	lsl.w #2,d1
	adda.w d1,a1
	adda.l a1,a2
	movea.w #0x0080,a3
	lsr.w #2,d1
	add.w d0,d2
	move.w d2,d3
	subq.w #1,d3
	asr.w #4,d3
	sub.w d1,d3
	movea.w d3,a5
	adda.w a5,a5
	adda.w a5,a5
	bsr.s l025aa
	move.l d5,d4
	move.w d2,d0
	bsr.s l025aa
	not.l d5
	bne.s l025a8
	moveq #-0x01,d5
l025a8:	rts

l025aa:	moveq #-0x01,d5
	andi.w #0x000f,d0
	lsr.w d0,d5
	move.w d5,d0
	lsl.l #8,d5
	move.w d0,d5
	lsl.l #8,d5
	move.b d0,d5
	rts

l025be:	movem.l d0-d7/a0-a6,-(a7)
	bsr.s l02558
l025c4:	lea l026ec(pc),a6
	bra.s l025f4


l025ca:	movem.l d0-d7/a0-a6,-(a7)
	bsr.s l02558
l025d0:	lea l026f4(pc),a6
	bra.s l025f4


l025d6:	movem.l d0-d7/a0-a6,-(a7)
	movea.l a1,a4
	bsr.s l0256a
	add.w d3,d3
	addq.w #1,d3
	btst #0x03,0x0034(a6) | * SV.MCSTA
	bne.s l025f0
	lea l0273e(pc),a6
	bra.s l025f4


l025f0:	lea l02708(pc),a6
l025f4:	bsr.w l026e6
	movem.l (a7)+,d0-d7/a0-a6
	rts

l025fe:	movem.l d0-d7/a0-a6,-(a7)
	bsr.w l02558
	move.w 0x0012(a7),d2
	neg.w d2
	lsl.w #7,d2
	bvs.s l025c4
	bgt.s l02630
	exg a1,a2
	movea.w #0xff80,a3
	adda.l a3,a1
	adda.l a3,a2
	move.w a1,d0
	sub.w a2,d0
	tst.b d0
	bne.s l02626
	exg d6,d7
l02626:	lea 0x00(a1,d2.w),a4
	cmpa.l a2,a4
	bls.s l025c4
	bra.s l02638


l02630:	lea 0x00(a1,d2.w),a4
	cmpa.l a4,a2
	bls.s l025c4
l02638:	lea l026fc(pc),a6
	suba.w d2,a2
	bsr.w l026e6
	adda.w d2,a2
	bra.w l025c4


l02648:	movem.l d0-d7/a0-a6,-(a7)
	bsr.w l02558
	swap d3
	move.w 0x0012(a7),d2
	neg.w d2
	bgt.s l0268a
	neg.w d2
	move.w d2,d3
	andi.w #0x000f,d3
	addi.w #0x0010,d3
	swap d3
	lsr.w #4,d2
	cmp.w d3,d2
	bhi.w l025c4
	sub.w d2,d3
	movea.w #0xfffc,a0
	adda.w a5,a1
	adda.w a5,a2
	movea.l a1,a4
	lsl.w #2,d2
	suba.w d2,a4
	move.l a5,d2
	neg.l d2
	movea.l d2,a5
	exg d4,d5
	bra.s l026ac


l0268a:	movea.w #0x0004,a0
	move.w d2,d3
	andi.w #0x000f,d3
	neg.w d3
	addi.w #0x0010,d3
	swap d3
	lsr.w #4,d2
	cmp.w d3,d2
	bhi.w l025c4
	sub.w d2,d3
	lsl.w #2,d2
	lea 0x00(a1,d2.w),a4
l026ac:	addq.w #1,d3
	lea l02770(pc),a6
	bra.w l025f4


l026b6:	move.w d3,d0
	bmi.s l026ea
	exg d6,d7
	move.l (a1),-(a7)
	move.l 0x00(a1,a5.w),-(a7)
	jmp (a6)


l026c4:	subq.w #4,a1
l026c6:	move.l (a1),d0
	and.l d5,d0
	move.l d5,d1
	not.l d1
	and.l (a7)+,d1
	or.l d1,d0
	move.l d0,(a1)
	suba.l a5,a1
	move.l (a1),d0
	and.l d4,d0
	move.l d4,d1
	not.l d1
	and.l (a7)+,d1
	or.l d1,d0
	move.l d0,(a1)
	adda.l a3,a1
l026e6:	cmpa.l a2,a1
	bne.s l026b6
l026ea:	rts

l026ec:	move.l d6,(a1)+
	dbf d0,l026ec
	bra.s l026c4

l026f4:	eor.l d6,(a1)+
	dbf d0,l026f4
	bra.s l026c4

l026fc:	lea 0x00(a1,d2.w),a4
l02700:	move.l (a4)+,(a1)+
	dbf d0,l02700
	bra.s l026c4

l02708:	move.b (a1),d6
	move.b 0x0001(a1),d7
	moveq #0x03,d1
l02710:	moveq #0x00,d2
	move.b d6,d2
	lsl.b #6,d2
	lsl.w #1,d2
	move.b d7,d2
	lsl.b #6,d2
	lsr.w #6,d2
	move.b 0x00(a4,d2.w),d2
	roxr.b #1,d2
	roxr.b #1,d7
	roxr.b #1,d2
	roxr.b #1,d7
	ror.b #1,d6
	roxr.b #1,d2
	roxr.b #1,d6
	dbf d1,l02710
	move.b d6,(a1)+
	move.b d7,(a1)+
	dbf d0,l02708
	bra.s l026c4


l0273e:	move.b (a1),d6
	move.b 0x0001(a1),d7
	moveq #0x07,d1
l02746:	moveq #0x00,d2
	move.b d6,d2
	lsl.b #7,d2
	lsl.w #1,d2
	move.b d7,d2
	lsl.b #7,d2
	lsr.w #6,d2
	move.b 0x00(a4,d2.w),d2
	roxr.b #2,d2
	roxr.b #1,d7
	roxr.b #1,d2
	roxr.b #1,d6
	dbf d1,l02746
	move.b d6,(a1)+
	move.b d7,(a1)+
	dbf d0,l0273e
	bra.w l026c4


l02770:	move.w a5,-(a7)
	move.l a4,-(a7)
	move.l d6,-(a7)
	adda.l a1,a5
	move.l (a5),d2
	and.l d5,d2
	move.l d5,d1
	not.l d1
	and.l d6,d1
	or.l d1,d2
	move.l d2,(a5)
	adda.l a0,a5
	swap d3
	movep.w 0x0000(a4),d1
	movep.w 0x0001(a4),d2
	bra.s l027b4


l02794:	adda.l a0,a4
l02796:	swap d1
	swap d2
	movep.w 0x0000(a4),d1
	movep.w 0x0001(a4),d2
	move.l d1,d6
	ror.l d3,d6
	movep.w d6,0x0000(a1)
	move.l d2,d6
	ror.l d3,d6
	movep.w d6,0x0001(a1)
	adda.l a0,a1
l027b4:	subq.w #1,d0
	bgt.s l02794
	blt.s l027be
	movea.l a7,a4
	bra.s l02796


l027be:	move.l (a7)+,d6
	movea.l (a7)+,a4
	swap d3
	bra.s l027ca


l027c6:	move.l d6,(a1)
	adda.l a0,a1
l027ca:	cmpa.l a1,a5
	bne.s l027c6
	movea.w (a7)+,a5
	adda.l a3,a4
	suba.l a0,a1
	bra.w l026c6


l027d8:	movem.l d1-d2,-(a7)
	bsr.s l0281e
	move.w d2,(a1)
	move.w d2,0x0002(a1)
	lsr.b #3,d1
	beq.s l02818
	bsr.s l0281e
	lsr.b #3,d1
	btst #0x00,d1
	beq.s l027f6
	eor.w d2,0x0002(a1)
l027f6:	cmpi.b #0x01,d1
	beq.s l02818
	btst #0x03,0x0034(a6) | * SV.MCSTA

	beq.s l0280a
	andi.w #0x3333,d2
	bra.s l0280e


l0280a:	andi.w #0x5555,d2
l0280e:	eor.w d2,(a1)
	tst.b d1
	beq.s l02818
	eor.w d2,0x0002(a1)
l02818:	movem.l (a7)+,d1-d2
	rts

l0281e:	move.b d1,d2
	andi.w #0x0007,d2
	ror.l #2,d2
	lsl.w #7,d2
	rol.l #2,d2
	btst #0x03,0x0034(a6) | * SV.MCSTA
	beq.s l02838
	mulu #0x0055,d2
	bra.s l0283e


l02838:	lsr.w #1,d2
	mulu #0x00ff,d2
l0283e:	rts

|* ROUTINE TO PRINT CHAR ON SCR
|* CALLED BY TRAP#3,D0=5

l02840:	movem.l d0-d7/a0-a6,-(a7)
	movem.l (a1),d6-d7 | * D7=ink mask
	btst #0x00,d1 | * odd adress
	bne.s l02852
	swap d6 | * invert masque
	swap d7 | *
l02852:	andi.w #0x00ff,d2 | * character to print
	movea.l a2,a4 | * pointer to first charfont
	sub.b (a4)+,d2 | * higher?
	cmp.b (a4)+,d2
	bls.s l0286a | * No
	add.b (a2),d2
	movea.l a3,a4 | * second char font
	sub.b (a4)+,d2
	cmp.b (a4)+,d2
	bls.s l0286a | * ok
	moveq #0x00,d2 | * char not printable
l0286a:	adda.w d2,a4 | * get value in charlist
	lsl.w #3,d2
	adda.w d2,a4
	movea.l #0x00020000,a1
	lsl.w #7,d1
	adda.w d1,a1
	move.w d0,d1
	lsr.w #3,d0
	add.w d0,d0
	adda.w d0,a1
	andi.w #0x0007,d1
	movea.w #-1,a5
	btst #0x00,d3 | * mode underline ?
	beq.s l02892 | * no
	addq.w #2,a5
l02892:	moveq #0x00,d0
	moveq #0x7e,d2
	add.w d2,d2 | * D2 = $FC
	moveq #0x00,d5
	btst #0x06,d3 | * mode 8
	beq.s l028b4
	moveq #-0x01,d0
	move.w #0xfff0,d2
	addq.w #8,d1
	btst #0x01,d3 | * mode flash?
	beq.s l028b4
	move.w #0x4010,d5
	ror.l d1,d5
l028b4:	btst #0x05,d3 | * mode extended width
	beq.s l028bc
	asr.b #4,d2
l028bc:	moveq #0x00,d4
	btst #0x04,d3 | * mode double height
	beq.s l028c6
	moveq #-0x01,d4
l028c6:	ror.l d1,d2
	lea l02924(pc),a6 | * adress for printing
	btst #0x02,d3 | * mode transparent background
	beq.s l028e0
	lea l0293a(pc),a6 | * adress for printing
	btst #0x03,d3 | * XOR characters/graphics
	beq.s l028e0
	lea l02936(pc),a6 | * adress for printing
l028e0:	movea.l a1,a2 | * adress on screen
	move.b d2,d0 | * copy byte to print in long word
	lsl.w #8,d2
	move.b d0,d2
	lsl.w #8,d5
	move.w #0x0009,d0 | * loop counter
	moveq #0x00,d3
	bra.s l0291c | * adress to add masque


l028f2:	moveq #0x00,d3 | * loop for printing
	cmp.w a5,d0 | * underline?
	bne.s l028fe
	moveq #-0x01,d3
	addq.w #1,a4
	bra.s l02914


l028fe:	move.b (a4)+,d3 | * char-matrix in d3
	beq.s l0291c
	tst.l d0 | * 6 or 8 pixels size
	bge.s l0290c
	lsr.b #1,d3
	move.w l0297c(pc,d3.w),d3 | * convert-table 6*9 to 12 * 9
l0290c:	ror.w d1,d3 | * calculate any pixel depending on size
	move.b d3,d4 | * and char-matrix
	lsl.w #8,d3
	move.b d4,d3
l02914:	and.w d2,d3
	move.w d3,d4
	swap d3
	move.w d4,d3
l0291c:	move.w d3,d4
	and.w d7,d4
	or.w d5,d4
	jmp (a6)

l02924:	eor.w d2,d3
	and.w d6,d3
	or.w d4,d3
	move.w d2,d4
	not.w d4
	and.w (a1),d4
	or.w d3,d4 | * at last - value to print
	move.w d4,(a1) | * on screen
	bra.s l02942 | * continue

l02936:	eor.w d4,(a1)
	bra.s l02942

l0293a:	not.w d3
	and.w (a1),d3
	or.w d4,d3
	move.w d3,(a1)
l02942:	swap d6
	swap d7
	adda.w #0x0080,a1
	tst.l d4 | * normal size
	bge.s l02956 | * yes
	swap d3
	bchg #0x1e,d4
	bne.s l0291c
l02956:	dbf d0,l028f2
	clr.w d2
	rol.l #8,d2
	beq.s l02976 | * character written ½ end
	clr.w d5
	rol.l #8,d5
	subq.b #8,d1
	andi.b #0x0f,d1
	movea.l a2,a1
	addq.w #2,a1
	suba.w #0x0009,a4
	bra.w l028e0 | * second run

l02976:	movem.l (a7)+,d0-d7/a0-a6
	rts

|*
|*       sreen-pixel translate code 
|*       transfers 6*9 matrix to 12 * 9 matrix
|*

.balign 2, 0 ; l0297c:	.word 0x0000
.balign 2, 0 ; 	.word 0x0030
.balign 2, 0 ; 	.word 0x00c0
.balign 2, 0 ; 	.word 0x00f0
.balign 2, 0 ; 	.word 0x0300
.balign 2, 0 ; 	.word 0x0330
.balign 2, 0 ; 	.word 0x03c0
.balign 2, 0 ; 	.word 0x03f0
.balign 2, 0 ; 	.word 0x0c00
.balign 2, 0 ; 	.word 0x0c30
.balign 2, 0 ; 	.word 0x0cc0
.balign 2, 0 ; 	.word 0x0cf0
.balign 2, 0 ; 	.word 0x0f00
.balign 2, 0 ; 	.word 0x0f30
.balign 2, 0 ; 	.word 0x0fc0
.balign 2, 0 ; 	.word 0x0ff0
.balign 2, 0 ; 	.word 0x3000
.balign 2, 0 ; 	.word 0x3030
.balign 2, 0 ; 	.word 0x30c0
.balign 2, 0 ; 	.word 0x30f0
.balign 2, 0 ; 	.word 0x3300
.balign 2, 0 ; 	.word 0x3330
.balign 2, 0 ; 	.word 0x33c0
.balign 2, 0 ; 	.word 0x33f0
.balign 2, 0 ; 	.word 0x3c00
.balign 2, 0 ; 	.word 0x3c30
.balign 2, 0 ; 	.word 0x3cc0
.balign 2, 0 ; 	.word 0x3cf0
.balign 2, 0 ; 	.word 0x3f00
.balign 2, 0 ; 	.word 0x3f30
.balign 2, 0 ; 	.word 0x3fc0
.balign 2, 0 ; 	.word 0x3ff0
.balign 2, 0 ; 	.word 0xc000
.balign 2, 0 ; 	.word 0xc030
.balign 2, 0 ; 	.word 0xc0c0
.balign 2, 0 ; 	.word 0xc0f0
.balign 2, 0 ; 	.word 0xc300
.balign 2, 0 ; 	.word 0xc330
.balign 2, 0 ; 	.word 0xc3c0
.balign 2, 0 ; 	.word 0xc3f0
.balign 2, 0 ; 	.word 0xcc00
.balign 2, 0 ; 	.word 0xcc30
.balign 2, 0 ; 	.word 0xccc0
.balign 2, 0 ; 	.word 0xccf0
.balign 2, 0 ; 	.word 0xcf00
.balign 2, 0 ; 	.word 0xcf30
.balign 2, 0 ; 	.word 0xcfc0
.balign 2, 0 ; 	.word 0xcff0
.balign 2, 0 ; 	.word 0xf000
.balign 2, 0 ; 	.word 0xf030
.balign 2, 0 ; 	.word 0xf0c0
.balign 2, 0 ; 	.word 0xf0f0
.balign 2, 0 ; 	.word 0xf300
.balign 2, 0 ; 	.word 0xf330
.balign 2, 0 ; 	.word 0xf3c0
.balign 2, 0 ; 	.word 0xf3f0
.balign 2, 0 ; 	.word 0xfc00
.balign 2, 0 ; 	.word 0xfc30
.balign 2, 0 ; 	.word 0xfcc0
.balign 2, 0 ; 	.word 0xfcf0
.balign 2, 0 ; 	.word 0xff00
.balign 2, 0 ; 	.word 0xff30
.balign 2, 0 ; 	.word 0xffc0
.balign 2, 0 ; 	.word 0xfff0

	.include "mdv_sys.s"

|* execution of command to 8049
l02c72:	move sr,-(a7) | * transmission with 8049 rts=rte
	ori.w #0x0700,sr | * disable interrupts
	jsr l02f6e(pc) | * returns D6=6  A0=$18020  A1=$18003
	move.b (a3)+,d0 | * d0 = command-type
	bsr.s l02cc8 | * do it
	move.b (a3)+,d7 | * number of params
	move.l (a3)+,d4 | * sort of params
l02c84:	subq.b #1,d7 | * no params
	blt.s l02ca4 | * go on
	move.b (a3)+,d0
	btst #0x00,d4
	bne.s l02ca0
	btst #0x01,d4
	beq.s l02c9e
	move.w d0,d5
	ror.w #4,d0
	bsr.s l02cc8
	move.w d5,d0
l02c9e:	bsr.s l02cc8
l02ca0:	ror.l #2,d4
	bra.s l02c84


l02ca4:	move.b (a3)+,d4
	btst #0x00,d4
	bne.s l02cbc
	btst #0x01,d4
	bne.s l02cb8
	jsr l02f96(pc)
	bra.s l02cbc


l02cb8:	jsr l02f9a(pc) | * the answer of 8049
l02cbc:	moveq #0x02,d7
	or.b 0x0035(a6),d7 | * SV.PCINT
	move.b d7,0x0001(a0)
	rte


l02cc8:	jmp l02f7c(pc) | * command for 8079


l02ccc:	movem.l d0-d6/a0-a4,-(a7) | * interrupt 2 - interface
	moveq #0x00,d3
	bsr.s l02d20
	moveq #0x02,d7
	bra.s l02ce6

l02cd8:	movem.l d0-d6/a0-a4,-(a7) | * interrupt 2 - transmission
	moveq #0x00,d3
	st d4
	bsr.w l02d74
	moveq #0x04,d7
l02ce6:	or.b 0x0035(a6),d7 | * SV.PCINT
	move.b d7,0x00018021
	movem.l (a7)+,d0-d6/a0-a4
	bra.w l003b6

|* table of interrupt tasks
l02cf8:
.balign 2, 0 ; 	.long 0 | * no following table
.balign 2, 0 ; 	.long l02d08 | * interrupt-routines

|* table of scheduler tasks
.balign 2, 0 ; l02d00:	.long l03480 | * List of next linkage
.balign 2, 0 ; 	.long l02d14 | * adress of scheduler task

l02d08:	move sr,-(a7) | * RTS=RTE !
	ori.w #0x0700,sr
	bsr.s l02d20 | * ask 8049
	jmp l02cbc(pc) | * end


l02d14:	move sr,-(a7) | * serial I/O
	ori.w #0x0700,sr
	sf d4 | * D4.B = 0
	bsr.s l02d74
	rte

l02d20:	jsr l02f6e(pc) | * returns D6=6  A0=$18020  A1=$18003
	moveq #0x01,d0 | * command 1 to 8049 = respond
	jsr l02f7c(pc) | * command for 8079
	jsr l02f9a(pc) | * receive demands
	move.b d1,d7 | * d7: received byte
	btst #0x06,d7 | * bit 6=0? mdv write not allowed
	seq 0x0094(a6) | * SV.WP
	btst #0x01,d7 | * bit 1=1 beeper activ
	sne 0x0096(a6) | * SV.SOUND
	btst #0x00,d7 | * bit 0=0 keyboard-buff empty
	beq.s l02d4a
	jsr l02e58(pc) | * transfer keyboard buff
l02d4a:	move.l 0x0098(a6),d0 | * no ser# open
	beq.s l02d5e
	btst #0x04,d7 | * bit 4 = 0 ser# did nothing receive
	beq.s l02d5e
	movea.l d0,a2
	moveq #0x06,d5
	jsr l02e18(pc) | * receive
l02d5e:	move.l 0x009c(a6),d0 | * now same proc with ser2
	beq.s l02d72
	btst #0x05,d7
	beq.s l02d72
	movea.l d0,a2
	moveq #0x07,d5
	jsr l02e18(pc)
l02d72:	rts

l02d74:	lea 0x00a0(a6),a4 | * prepare for ser# - receiving SV.TMODE
	btst #0x04,(a4)
	bne.s l02d88
	lea 0x00018020,a1
	btst #0x01,(a1)
l02d88:	bne.s l02e02
	moveq #0x00,d6 | * d6=0 : ser1
	move.b (a4),d6 | * d6=1 : ser2
	lsl.b #4,d6
	lsr.b #7,d6
	move.w d6,d7
	addq.b #4,d7
	lsl.b #2,d6
	lea 0x0098(a6),a5 | *SV.SER1C
	adda.w d6,a5
	move.l (a5),d0
	beq.s l02e04
	movea.w #0x0062,a2 | * a2= start addr. of out-file
	adda.l d0,a2
	tst.b -0x0065(a2)
	beq.s l02db2
	btst d7,(a1)
	bne.s l02dbe
l02db2:	jsr l0385e(pc) | * IO.QOUT
	beq.s l02df6 | * correct received
	addq.l #1,d0
	beq.s l02e04
	bra.s l02dd4

l02dbe:	jsr l0380a(pc) | * IO.QTEST
	cmpi.w #0xfff6,d0
	bne.s l02e04
	tst.b -0x0063(a2)
	blt.s l02dd4
	tst.b -0x0065(a2)
	bne.s l02e02
l02dd4:	tst.b d4
	bne.s l02e02
	move.b -0x0063(a2),d6
	lea -0x0082(a2),a0
	jsr l0305e(pc) | * MT.RECHP
	clr.l (a5)
	tst.b d6
	blt.s l02e02
	moveq #0x1a,d1
	btst #0x00,-0x0067(a2) | * parity even?
	beq.s l02df6
	moveq #-0x66,d1
l02df6:	move.b d1,0x00018022
	move.w 0x00a8(a6),0x00a6(a6) | * SV.TIMOV
l02e02:	rts

l02e04:	sub.w d3,0x00a6(a6) | * ser timing SV.TIMOV
	bge.s l02e02
	clr.w 0x00a6(a6)
	bchg #0x03,(a4)
	move.b (a4),-0x001e(a1)
	rts

l02e18:	jsr l0380a(pc) | * IO.QTEST  receive ser#
	cmpi.w #0x0019,d2
	blt.s l02e56
	move.l d5,d0
	jsr l02f7c(pc) | * command for 8079 depending on D0
	jsr l02f9a(pc)
	move.b d1,d4
	andi.w #0x003f,d4
|;       BEQ.S   L02E56(PC)		* Error : unexpected characters at end of statement <(PC)>
	beq.s l02e56
	subq.w #1,d4
l02e36:	jsr l02f9a(pc)
	tst.b -0x0002(a2)
	blt.s l02e4e
	moveq #0x7f,d0
	and.b d1,d0
	cmpi.b #0x1a,d0
	bne.s l02e4e
	jsr l03888(pc) | * IO.QEOF
l02e4e:	jsr l03838(pc) | * IO.QIN
	dbf d4,l02e36 | * continue reading
l02e56:	rts

l02e58:	movea.l 0x004c(a6),a2 | * clear 8049 - keyboard buffer
	move.l a2,d0
	beq.s l02ec0 | * = no con open
	moveq #0x08,d0 | * command 8=read keyboard
	jsr l02f7c(pc) | * command for 8079
	jsr l02f96(pc) | * receive
	move.b d1,d5 | * d1=d5=d4 : number of bytes in buffer
	move.b d1,d4
	andi.w #0x0007,d4
	beq.s l02e96 | * if empty - out
	subq.w #1,d4
l02e76:	clr.w 0x008a(a6) | * autorepeat buffer
	jsr l02f96(pc) | * receive ctrl alt shift
	move.b d1,d2
	jsr l02f9a(pc)
	movea.l 0xbff2,a3
	jsr (a3) | * convert to ASCII 
	bra.s l02ec4 | * ctrl - space
	bra.s l02ec2 | * no char implemented !!! change to 2ec0 !!!
	bsr.s l02eec
	dbf d4,l02e76 | * look for next bytes in buffer
l02e96:	btst #0x03,d5 | * if less then 8 chrs in buffer ½ end
	beq.s l02eba
	sub.w d3,0x0090(a6) | * SV.ARCNT
	bgt.s l02ec0
	jsr l0380a(pc) | * IO.QTEST
	tst.l d0 | * no new entries
	beq.s l02eb2
	move.w 0x008a(a6),d1 | * SV.ARBUF
	beq.s l02eb2
	bsr.s l02eec
l02eb2:	move.w 0x008e(a6),0x0090(a6) | * SV.ARFRQ ½ SV.ARCNT
	rts

l02eba:	move.w 0x008c(a6),0x0090(a6) | * restore autorepeat
l02ec0:	rts

|* !!! CHANGE ABOVE AND REMOVE - DOUBLE RTS IS NONSENS !!!

l02ec2:	rts

l02ec4:	sf 0x0033(a6) | * was ctrl-space ? clear SV.SCRST
	movea.l 0x0068(a6),a3 | * SV.JBBAS
	movea.l (a3),a3 | * SuperBasic
	sf 0x00f7(a3) | * BV.BRK
	move.w 0x0014(a3),d0 | * job.stat
	beq.s l02eea | * ok ->
	addq.w #1,d0
	blt.s l02eea | * waiting for job ->
	clr.w 0x0014(a3)
	move.l 0x000c(a3),d0 | * release flag
	beq.s l02eea
	movea.l d0,a3
	sf (a3)
l02eea:	rts

l02eec:	cmpi.w #0x00f9,d1 | * ctrl-f5 ?
	beq.s l02f3a | * invert screen status
	sf 0x0033(a6) | * SV.SCRST
	cmp.w 0x0092(a6),d1 | * ctrl-c ? SV.CQCH
	beq.s l02f40
	cmpi.w #0x00e0,d1 | * capslock ?
	bne.s l02f12
	not.b 0x0088(a6) | * invert capslock mode SV.CAPS
	tst.l 0x00a2(a6) | * if new: acitvate     SV.CSUB
	beq.s l02ec0
	lea 0x00a2(a6),a5
	jmp (a5) | * will return 

l02f12:	move.w 0x008c(a6),0x0090(a6) | * SV.ARDEL ½ SV.ARFRQ
	move.w d1,0x008a(a6) | * autorepeat - buffer
	cmpi.b #0xff,d1
	bne.s l02f36
	swap d1
	jsr l0380a(pc) | * IO.QTEST
	cmpi.w #0x0002,d2
	blt.s l02ec0
	swap d1
	jsr l03838(pc) | * IO.QIN
	lsr.w #8,d1
l02f36:	jmp l03838(pc) | * IO.QIN

l02f3a:	not.b 0x0033(a6) | * invert screen status
	rts

l02f40:	lea -0x0068(a2),a0 | * a0 = chbase
	tst.b 0x0043(a0)
	bge.s l02f54 | * cursor activ
	jsr l01b86:l | * reactivate
	nop | * !!! to conform asm !!!
	lea 0x0068(a0),a2 | * pointer to Job-base
l02f54:	movea.l (a2),a2
	cmpa.l 0x004c(a6),a2 | * keyboard-queue ok?
	beq.s l02f6a
	tst.b -0x0025(a2)
	beq.s l02f54
	move.l a2,0x004c(a6) | * SV.KEYQ
	clr.w 0xaa(a6)

|* omit instruction but let label !!!

l02f6a:	jmp l02f6e(pc) | * returns D6=6  A0=$18020  A1=$18003


|* set parameters for transmission to 8049        
l02f6e:	lea 0x00018003,a1 | * A1 = 8049 - write reg
	lea 0x001d(a1),a0 | * A0 = status-control 8049
	moveq #0x06,d6
	rts
|* command for 8079  - depends on value in D0
l02f7c:	lsl.b #4,d0 | * send command to 8049 D0 * 16
	ori.b #0x08,d0 | * bit 3 = 1
l02f82:	lsl.b #1,d0
	beq.s l02f94
	moveq #0x03,d1
	roxl.b #1,d1
	asl.b #1,d1
	move.b d1,(a1)
l02f8e:	btst d6,(a0) | * wait till bit 6 ist 0 - ackn of 8049
	bne.s l02f8e
	bra.s l02f82
l02f94:	rts

l02f96:	moveq #0x10,d1 | * decrement counter
	bra.s l02f9c | * receive

l02f9a:	moveq #0x01,d1
l02f9c:	move.b #0x0e,(a1) | * $0E an 8049 : ready to receive
l02fa0:	btst d6,(a0)
	bne.s l02fa0 | * wait
	move.b (a0),d0 | * receive bits
	roxl.b #1,d0
	roxl.b #1,d1
	bcc.s l02f9c | * till complete
	rts

|* Vector-handling

|* allocate memory in common heap

l02fae:	lea 0x0008(a6),a0 | * MM.ALCHP
	moveq #0x0f,d2
	jsr l03106(pc) | * reserve D1 bytes
	blt.s l02fd6
	lea 0x0004(a6),a2 | * SV.CHEAP
	cmpa.l a1,a2
	beq.s l02fc6
	clr.l 0x0008(a1)
l02fc6:	move.l d1,d0
	addq.w #4,a0
	subq.l #4,d0
l02fcc:	clr.l (a0)+
	subq.l #4,d0
	bgt.s l02fcc
	suba.l d1,a0 | * A0 = base of reserved space
	bra.s l02ff8

|* allocate memory in transient area

l02fd6:	move.l d1,-(a7)
	adda.l (a0),a1
	cmpa.l 0x000c(a6),a1 | * SV.FREE
	bne.s l02fe2
	sub.l (a0),d1
l02fe2:	jsr l0324e(pc)
	bne.s l02ff6
	suba.l d1,a0
	lea 0x0008(a6),a1 | * SV.CHPFR
	jsr l0315e(pc)
	move.l (a7)+,d1
	bra.s l02fae | * MM.ALCHP

l02ff6:	addq.w #4,a7
l02ff8:	rts


|* reserve in transient prog aera d1 bytes

l02ffa:	lea 0x0018(a6),a0 | * SV.TRNFR
	moveq #0x0f,d2
	moveq #0x01,d0
	jsr l03134(pc)
	tst.l d2
	bgt.s l03032
	move.l d1,-(a7)
	lea 0x0014(a6),a1 | * SV.TRNSP
	adda.l 0x0004(a1),a1
	cmpa.l 0x0014(a6),a1
	bne.s l0301c
	sub.l (a1),d1
l0301c:	jsr l031b8(pc) | * allocate memory
	bne.s l0305a
	sub.l d1,0x0014(a6)
	lea 0x0018(a6),a1 | * SV.TRNFR
	jsr l0315e(pc)
	move.l (a7)+,d1
	bra.s l02ffa | * reserve d1 bytes

|* release memory in transient area

l03032:	movea.l a2,a0
	adda.l 0x0004(a2),a0
	move.l (a0),d3
	cmp.l d1,d3
	bgt.s l0304e
	move.l 0x0004(a0),d3
	beq.s l03048
	add.l a0,d3
	sub.l a2,d3
l03048:	move.l d3,0x0004(a2)
	bra.s l03056

l0304e:	sub.l d1,d3
	move.l d3,(a0)
	adda.l d3,a0
	move.l d1,(a0)
l03056:	moveq #0x00,d0
	rts

l0305a:	addq.w #4,a7
	rts

|* MT.FREE find largest free space
l0305e:	move.l (a0),d1
	lea 0x0008(a6),a1 | * SV.CHPFR
	jsr l0315e(pc)
	move.l (a1),d2
	adda.l d2,a1
	cmpa.l 0x000c(a6),a1 | * SV.FREE
	bne.s l03088
	move.l d2,d1
	jsr l03282(pc)
	sub.l d1,d2
	beq.s l03084
	adda.l 0x0004(a2),a2
	move.l d2,(a2)
	bra.s l03088

l03084:	clr.l 0x0004(a2)
l03088:	moveq #0x00,d0
	rts

|* RELEASE MEMORY
l0308c:	move.l (a0),d1
	lea 0x0018(a6),a1 | * SV.TRNFR
	jsr l0315e(pc)
	lea 0x0014(a6),a2 | * SV.TRNSP
	adda.l 0x0004(a2),a2
	cmpa.l 0x0014(a6),a2
	bne.s l030de
	move.l 0x0004(a2),-(a7)
	move.l (a2),d2
	move.l d2,d1
	jsr l031c8(pc) | * Release memory
	add.l d1,0x0014(a6) | * SV.TRNSP
	sub.l d1,d2
	beq.s l030d2
	movea.l (a7)+,a1
	adda.l d1,a2
	add.l d1,0x0018(a6) | * SV.TRNFR
	move.l d2,(a2)
	clr.l 0x0008(a2)
	move.l a1,0x0004(a2)
	beq.s l030de
	sub.l d1,0x0004(a2)
	bra.s l030de

l030d2:	move.l (a7)+,d2
	beq.s l030da
	add.l 0x0018(a6),d2 | * SV.TRNFR
l030da:	move.l d2,0x0018(a6)
l030de:	rts


l030e0:
.equ xltr1d06, l030e0
	moveq #0x01,d0
	moveq #0x00,d1
	lea 0x0018(a6),a0 | * SV.TRNFR
	jsr l03134(pc)
	movea.l 0x0010(a6),a0 | * SV.BASIC
	suba.w #0x0200,a0
	suba.l 0x000c(a6),a0 | * SV.FREE
	move.l a0,d1
	cmp.l d1,d2
	ble.s l03100
	move.l d2,d1
l03100:	bra.w l003a4

l03104:	moveq #0x07,d2 | * MM.ALLOC
l03106:	moveq #0x00,d0
	jsr l03134(pc)
	cmp.l d1,d2
	beq.s l03122
	bgt.s l03116
	moveq #-0x03,d0
	rts

l03116:	add.l d1,0x0004(a1)
	movea.l a0,a1
	adda.l d1,a1
	sub.l d1,d3
	move.l d3,(a1)
l03122:	move.l 0x0004(a0),d2
	beq.s l0312c
	add.l a0,d2
	sub.l a1,d2
l0312c:	move.l d2,0x0004(a1)
	move.l d1,(a0)
	rts

|* general memory allocation

l03134:	subq.w #4,a0
	add.l d2,d1
	not.b d2
	and.b d2,d1
	moveq #0x00,d2
	movea.l d2,a2
l03140:	movea.l a0,a1
	move.l 0x0004(a0),d3
	beq.s l0315c
	adda.l d3,a0
	move.l (a0),d3
	cmp.l d1,d3
	blt.s l03140
	movea.l a1,a2
	cmp.l d2,d3
	ble.s l03158
	move.l d3,d2
l03158:	tst.b d0
	bne.s l03140
l0315c:	rts

|* link free space to task

l0315e:	clr.l 0x0008(a0)
l03162:	subq.w #4,a1 | * MM.LINKFR
	suba.l a2,a2
l03166:	movea.l a2,a3
	movea.l a1,a2
	move.l 0x0004(a1),d2
	beq.s l0317a
	adda.l d2,a1
	cmpa.l a0,a1
	ble.s l03166
	suba.l a0,a1
	bra.s l0317c

l0317a:	movea.l d2,a1
l0317c:	move.l a0,d2
	sub.l a2,d2
	move.l d2,0x0004(a2)
	move.l d1,(a0)+
	move.l a1,(a0)
l03188:	movea.l a2,a1
	movea.l a3,a2
l0318c:	move.l 0x0004(a1),d2
	beq.s l031b6
	movea.l a2,a3
	movea.l a1,a2
	adda.l d2,a1
	move.l a3,d2
	beq.s l0318c
	move.l (a2),d2
	add.l a2,d2
	cmp.l a1,d2
	bne.s l0318c
	move.l 0x0004(a1),d2
	beq.s l031ac
	add.l (a2),d2
l031ac:	move.l d2,0x0004(a2)
	move.l (a1),d2
	add.l d2,(a2)
	bra.s l03188

l031b6:	rts

|* test against memory Base
|* used to allocate memory
l031b8:	jsr l0323a(pc)
	bne.s l031de
	bsr.s l031e0
l031c0:	move.l (a1)+,(a0)+
	subq.l #4,d0
	bne.s l031c0
	bra.s l031de

|* test against top of memory
|* used to Release memory
l031c8:	jsr l03276(pc)
	neg.l d1
	beq.s l031de
	bsr.s l031e0
	neg.l d1
	adda.l d0,a0
	adda.l d0,a1
l031d8:	move.l -(a1),-(a0)
	subq.l #4,d0
	bne.s l031d8
l031de:	rts

|* update A6 and A7 for Basic

l031e0:	movea.l 0x0068(a6),a3 | * SV.JBBAS
	move.l a0,(a3)
	adda.l d1,a0
	sub.l d1,0x0058(a0)
	sub.l d1,0x005c(a0)
	movea.l a0,a1
	suba.l d1,a0
	move.l 0x0014(a6),d0
	sub.l a1,d0
	cmpa.l 0x0064(a6),a3 | * SV.JBPNT
	bne.s l0320a
	sub.l d1,0x0008(a5)
	move.l usp,a3
	suba.l d1,a3
	move.l a3,usp
l0320a:	rts


l0320c:	addi.l #0x1ff,d1 | * 512 Bytes round
l03212:	andi.w #0xfe00,d1
	rts

|* calculate new position of server block

l03218:	movea.l 0x0010(a6),a0 | * SV.BASIC
	moveq #-0x08,d3
	bra.s l03226

l03220:	movea.l 0x000c(a6),a0 | * SV.FREE
	moveq #0x08,d3
l03226:	move.l a0,d0
	sub.l a6,d0
	lsr.l #6,d0
	movea.l 0x0058(a6),a1 | * SV.BTBAS
	adda.w d0,a1
	move.l d1,d0
	lsr.l #6,d0
	lsr.l #3,d0
	rts

|* update server block

l0323a:	bsr.s l0320c
	bsr.s l03218
	suba.l d1,a0
	cmpa.l 0x000c(a6),a0 | * SV.FREE
	ble.s l0329e
	move.l a0,0x0010(a6) | * SV.BASIC
	adda.l d3,a1
	bra.s l03270

l0324e:	bsr.s l0320c
	bsr.s l03220
	adda.l d1,a0
	cmpa.l 0x0010(a6),a0
	bge.s l0329e
	move.l a0,0x000c(a6)
	bra.s l03270

l03260:	moveq #0x0c,d2
	and.b (a1),d2
	beq.s l0326c
	jsr l0352a(pc)
	bra.s l03260
l0326c:	clr.b (a1)
	adda.w d3,a1
l03270:	dbf d0,l03260

	bra.s l0329a

l03276:	bsr.s l03212
	bsr.s l03218
	adda.l d1,a0
	move.l a0,0x0010(a6)
	bra.s l03296

l03282:	bsr.s l03212
	bsr.s l03220
	suba.l d1,a0
	move.l a0,0x000c(a6) | * SV.FREE
	suba.w d3,a1
	bra.s l03296

l03290:	move.b #0x01,(a1)
	suba.w d3,a1
l03296:	dbf d0,l03290
l0329a:	moveq #0x00,d0
	bra.s l032a0

l0329e:	moveq #-0x03,d0 | * OUT OF MEMORY
l032a0:	rts


|* trap 2 dispatch
l032a2:	movea.l 0x0064(a6),a1 | * SV.JBPNT
	movea.l (a1),a1
	bclr #0x07,0x0016(a1)
	beq.s l032b4
	adda.l 0x0008(a5),a0
l032b4:	subq.b #1,d0
	beq.s l032d0 | * open
	subq.b #1,d0
	beq.w l03352 | * close
	subq.w #1,d0
	beq.w l036b6 | * format
	subq.w #1,d0
	beq.w l03552 | * delete
	moveq #-0x0f,d0 | * bad parameter
	bra.w l003a6


|* trap2, open
l032d0:	movem.l a1-a4,-(a7)
	movea.l a0,a1
	jsr l003bc(pc) | * returns bas addr. in A0, jobid in d1
	exg a0,a1
	movea.l 0x0078(a6),a3 | * SV.CHBAS
l032e0:	tst.b (a3) | * find free entry in chan table
	blt.s l032f0
	addq.w #4,a3
	cmpa.l 0x007c(a6),a3 | * SV.CHTOP
	blt.s l032e0
	moveq #-0x06,d0
	bra.s l0334c

l032f0:	movea.l 0x0044(a6),a2 | * SV.DRLIST
l032f4:	movem.l d1-d7/a1-a6,-(a7)
	lea -0x0018(a2),a3
	movea.l 0x0008(a2),a4
	jsr (a4)
	movem.l (a7)+,d1-d7/a1-a6
	tst.l d0
	beq.s l0331e
	cmpi.w #0xfff9,d0
	bne.s l0334c
	movea.l (a2),a2
	move.l a2,d0
	bgt.s l032f4
	jsr l0355a(pc) | * try directory drivers
	tst.l d0
	bne.s l0334c

|* chanel opened without error

l0331e:	jsr host_channel_setup:l
	addq.w #1,0x0070(a6)
	addq.w #4,a0
	move.l a2,(a0)+
	move.l d1,(a0)+
	move.l a3,(a0)+
	move.w d2,(a0)+
	clr.w (a0)+
	clr.l (a0)+
	swap d2
	suba.l 0x0078(a6),a3 | * SV.CHBAS
	move.w a3,d2
	lsr.w #2,d2
	movea.l d2,a0
	cmp.w 0x0072(a6),d2 | * SV.CHMAX
	bls.s l0334c
	move.w d2,0x0072(a6) | * SV.CHMAX
l0334c:	movem.l (a7)+,a1-a4
	bra.s l03378

|* maintain channel closing trap 2, d0 = 2
|* close channel a0
l03352:	move.l a0,d7
	jsr l03476(pc) | * channel base ->a0
	movem.l d1-d7/a1-a6,-(a7)
	movea.l 0x0004(a0),a4
	lea -0x0018(a4),a3
	movea.l 0x000c(a4),a4
	jsr (a4)
	movem.l (a7)+,d1-d7/a1-a6
	lsl.w #2,d7
	movea.l 0x0078(a6),a0 | * SV.CHBAS
	adda.w d7,a0
	st (a0)
l03378:	bra.w l003a6 | * invalidate table entry

|* do trap #3 call
|* see also L03480
l0337c:	move.l a0,d7
	jsr l03476(pc) | * channel base ->a0
	tas 0x0012(a0) | * CH.STAT
	bne.w l03414 | * blocked ->
	movem.l d2-d7/a2-a6,-(a7)
	clr.l -(a7) | * a6 relative offset
	andi.l #0x0000007f,d0
	cmpi.b #0x49,d0
	bgt.s l033b0
	cmpi.b #0x46,d0
	bge.s l033ae
	cmpi.b #0x07,d0
	bgt.s l033b0
	btst #0x01,d0
	beq.s l033b0
l033ae:	moveq #0x00,d1
l033b0:	movea.l 0x0064(a6),a3 | * SV.JBPNT
	movea.l (a3),a3
	bclr #0x07,0x0016(a3) | * tst&clear trap#4 bit
	beq.s l033c4
	move.l 0x0008(a5),(a7)
	adda.l (a7),a1 | * adjust for a6 relative
l033c4:	movea.l 0x0004(a0),a4 | * CH.DRIVR
	move.b d0,0x0013(a0) | * CH.ACTN
	moveq #0x00,d3 | * 1st call
	lea -0x0018(a4),a3
	movea.l 0x0004(a4),a4
	jsr (a4) | * do the I/O
	suba.l (a7),a1
	cmpi.w #-1,d0 | * err.nc?
	bne.s l03422
	move.w 0x000a(a7),d3
	beq.s l03422 | * tmout=0 -> return error
	movea.l 0x002c(a7),a6 | * restore SYS.BASE
	jsr l00408(pc) | * current jobid,jobheader=d0,a3
	move.l d0,0x0014(a0) | * channel busy with CH.JOBW
	lea 0x0012(a0),a0 | * CH.STAT
	tst.l (a7)+ | * already set?
	bne.s l033fc
	st (a0) | * no: channel busy
l033fc:	move.l a0,0x000c(a3) | * JOB.HOLD
	move.w d3,0x0014(a3) | * JOB.STAT=timeout
	sf 0x0012(a3) | * clear accumulated priority
	moveq #-0x01,d0
	movem.l (a7)+,d2-d7/a2-a6
l0340e:	movea.l d7,a0
	bra.w l00936

l03414:	tst.w d3 | * timeout ?
	beq.s l0341e | * -> return
	subq.l #2,0x000e(a7) | * adjust jobs PC before the trap#3
	bra.s l0340e | * since channel blocked by other job

l0341e:	moveq #-0x01,d0
	bra.s l0342c

l03422:	addq.w #4,a7
	movem.l (a7)+,d2-d7/a2-a6
	sf 0x0012(a0) | * clear CH.STAT
l0342c:	movea.l d7,a0
	bra.w l003a6

|* trap 4 execution

l03432:	move.l a3,-(a7)
	movea.l 0x0064(a6),a3 | * SV.JBPNT
	movea.l (a3),a3
	tas 0x0016(a3)
	movea.l (a7)+,a3
	bra.w l003a6

|* verify that channel exists and find its base

l03444:	move.l a0,-(a7)
	move.l d0,-(a7)
l03448:	move.l a0,d0
	cmp.w 0x0072(a6),d0 | * SV.CHMAX
	bhi.s l0346e
	lsl.w #2,d0
	movea.l 0x0078(a6),a0 | * SV.CHBAS
	adda.w d0,a0
	tst.b (a0)
	blt.s l0346e
	movea.l (a0),a0
	swap d0
	cmp.w 0x0010(a0),d0 | * CH.TAG
	bne.s l0346e
	move.l (a7)+,d0
	addq.w #4,a7
	cmp.b d0,d0 | * sets equ-flag
l0346c:	rts

l0346e:	addq.w #4,a7
	moveq #-0x06,d0 | * channel not open
	movea.l (a7)+,a0
	rts

l03476:	bsr.s l03444
	beq.s l0346c
	addq.w #4,a7
	bra.w l003a6

l03480:
.balign 2, 0 ; 	.long 0 | * no more scheduler tasks
.balign 2, 0 ; 	.long l03488 | * adress of task

l03488:	movea.l 0x0074(a6),a1 | * test for pending I/O on any channel
	movea.w 0x0072(a6),a2 | * SV.CHMAX
	adda.w a2,a2
	adda.w a2,a2
	adda.l 0x0078(a6),a2
	movea.l a1,a3
l0349a:	addq.w #4,a1 | * loop
	cmpa.l a2,a1
	ble.s l034a4
	movea.l 0x0078(a6),a1
l034a4:	tst.b (a1) | * valid entry ?
	blt.s l034b0
	movea.l (a1),a0
	move.b 0x0012(a0),d4 | * channel busy ?
	bne.s l034b6 | * -> work
l034b0:	cmpa.l a1,a3
	bne.s l0349a
	bra.s l03522 | * rts

l034b6:	move.l a1,0x0074(a6) | * SV.CHPNT
	move.l 0x0014(a0),d1 | * CH.JOBWT
	lsl.w #2,d1
	movea.l 0x0068(a6),a4 | * SV.JBBAS
	adda.w d1,a4
	tst.b (a4)
	blt.s l03524
	movea.l (a4),a4 | * JOB.BASE
	swap d1
	cmp.w 0x0010(a4),d1 | * JOB.TAG
	blt.s l03524
	moveq #0x00,d0 | * prepare for trap#3  restart
	move.b 0x0013(a0),d0 | * CH.ACTN
	moveq #-0x01,d3 | * restarted call
	movem.l 0x0024(a4),d1-d2
	movem.l 0x0044(a4),a1-a2
	move.l a4,-(a7)
	clr.l -(a7)
	addq.b #1,d4
	beq.s l034f6 | * -> not A6 relative
	move.l 0x0058(a4),(a7) | * job.a6
	adda.l (a7),a1
l034f6:	movea.l 0x0004(a0),a4
	lea -0x0018(a4),a3
	movea.l 0x0004(a4),a4
	jsr (a4)
	suba.l (a7)+,a1 | * adjust relative
	movea.l (a7)+,a4 | * JOB.BASE
	move.l d1,0x0024(a4)
	move.l a1,0x0044(a4)
	cmpi.b #0xff,d0
	beq.s l03522
	move.l d0,0x0020(a4) | * set D0 of job
	clr.b 0x0012(a0) | * CH.STAT
	clr.w 0x0014(a4) | * JOB.STAT
l03522:	rts

l03524:	clr.b 0x0012(a0) | * CH.STAT
	rts


|* MDV_Motor on
l0352a:	movem.l d0-d3/a0-a4,-(a7)
	moveq #0x00,d1
	move.b (a1),d1
	lsr.b #4,d1
	lsl.b #2,d1
	lea 0x0100(a6),a2 | * SV.FSDEF
	movea.l 0x00(a2,d1.w),a2
	movea.l 0x0010(a2),a4
	lea -0x0018(a4),a3
	movea.l 0x0010(a4),a4
	jsr (a4)
	movem.l (a7)+,d0-d3/a0-a4
	rts


|*#: delete file
l03552:	jmp host_delete_entry:l
	nop


|*#: open DDEV channel
l0355a:	cmpi.b #0x04,d3 | * -1,4
	bls.s l03564
	moveq #-0x0f,d0
	rts

l03564:	movem.l d1-d6/a3-a6,-(a7)
	movea.l a0,a5
	move.l #0x00a0,d1
	jsr l02fae(pc) | * MM.ALCHP
	bne.w l0368a
	adda.w #0x0018,a0
	lea 0x0140(a6),a1 | * SV.FSLIST
	jsr l039dc(pc) | * UT.LINK
	lea (a5),a1 | * ???
	jsr l036d4(pc)
	bne.w l0366e | * error: unlink, dealloc

	moveq #0x0f,d2 | * counter 16
	moveq #-0x01,d0
	lea 0x0140(a6),a4 | * SV.FSDEF+$40

l03596:	move.l -(a4),d3
	bne.s l0359e
	move.w d2,d0 | * remember free place
	bra.s l035ac | * next
l0359e:	movea.l d3,a1
	cmp.b 0x0014(a1),d1 | * drive# =?
	bne.s l035ac
	cmpa.l 0x0010(a1),a2 | * this driver ?
	beq.s l035dc
l035ac:	dbf d2,l03596

	move.w d0,d2 | * found free pointer ?
	blt.w l0366c
	movem.l d1-d2/a0/a2,-(a7) | * alloc new drive def block
	move.l 0x0020(a2),d1
	jsr l02fae(pc) | * MM.ALCHP
	movem.l (a7)+,d1-d2/a1-a2
	exg a0,a1
	bne.w l0366e
	move.l a2,0x0010(a1) | * driver
	move.b d1,0x0014(a1) | * drive#
	move.w d2,d0
	lsl.w #2,d0
	adda.w d0,a4
	move.l a1,(a4) | * set SV.FSDEF table entry

l035dc:	move.b d2,0x0005(a0) | * chdef+$18+$5
	move.b 0x000b(a7),0x0004(a0) | * delete(-1) or D3 code
	lea 0x001a(a0),a4 | * +$18, save name in channel defblock
	move.w (a5)+,d0
	move.w 0x0024(a2),d3
	addq.w #2,d3 | * drv namelen
	adda.w d3,a5
	sub.w d3,d0
	blt.s l03660
	cmpi.w #0x0024,d0 | * maxlen 36 + drive#_
	bgt.s l03660
	move.w d0,(a4)+
	bra.s l03604

l03602:	move.b (a5)+,(a4)+ | * copy name
l03604:	dbf d0,l03602
	movea.l a1,a5
	movea.l a0,a1
l0360c:	movea.l (a1),a1 | * next linked  channel
	move.l a1,d0
	beq.s l03652 | * no more ..., find file
	cmp.b 0x0005(a1),d2 | * same drive?
	bne.s l0360c
	moveq #0x01,d0 | * compare file names
	movea.w #0x001a,a6 | * name offset
	jsr l03a9c(pc) | * UT.CSTR
	movea.l 0x0024(a7),a6 | * restore
	bne.s l0360c | * not same file

	cmpi.b #0x02,0x0004(a0)
	beq.s l03664 | * already exists
	cmpi.b #0x01,0x0004(a0)
	bne.s l03668 | * in use
	cmpi.b #0x01,0x0004(a1)
	bne.s l03668
	move.w 0x0006(a1),0x0006(a0) | * read only, copy info
	move.l 0x000c(a1),0x000c(a0)
	move.w #0x0040,0x000a(a0)
l03652:	movea.l a5,a1 | * drive def
	tst.w 0x0006(a0) | * file already located ?
	beq.s l03690 | * -> no, find it
	suba.w #0x0018,a0
	bra.s l03684 | * ok, return

l03660:	moveq #-0x0c,d0
	bra.s l0366e

l03664:	moveq #-0x08,d0
	bra.s l0366e

l03668:	moveq #-0x09,d0
	bra.s l0366e

l0366c:	moveq #-0x06,d0
l0366e:	lea 0x0140(a6),a1 | * SV.FSLST
	jsr l039e2(pc) | * UT.UNLNK
	suba.w #0x0018,a0
	move.l d0,d4
	jsr l0305e(pc) | * MT.RECHP
	move.l d4,d0
	bra.s l0368a

l03684:	addq.b #1,0x0022(a1)
	moveq #0x00,d0
l0368a:	movem.l (a7)+,d1-d6/a3-a6
	rts


|*#: call ddev_open
l03690:	suba.w #0x0018,a0 | *
	move.l a1,-(a7)
	move.l a2,-(a7)
	lea -0x0018(a2),a3
	movea.l 0x0008(a2),a4
	jsr (a4)
	movea.l (a7)+,a2
	movea.l (a7)+,a1
	tst.b 0x001c(a0) | * delete file ?
	blt.s l036b0
	tst.l d0
	beq.s l03684 | * success
l036b0:	adda.w #0x0018,a0
	bra.s l0366e | * return D0


|*#: FORMAT SECTORED MEDIUM
l036b6:	movem.l d3-d7/a1-a5,-(a7)
	movea.l a0,a1
	jsr l036d4(pc)
	blt.s l036cc
	lea -0x0018(a2),a3
	movea.l 0x001c(a2),a4
	jsr (a4) | * dev_format
l036cc:	movem.l (a7)+,d3-d7/a1-a5
	bra.w l003a6


|* VERIFY NAME
|*#: find drive a1=file_name< >a2 driver > d1=drive#num
l036d4:	movem.l a1/a4,-(a7)
	movea.l 0x0048(a6),a2 | * SV.DDLST
l036dc:	lea 0x0024(a2),a4 | * DRIVE namelen
	move.w (a4)+,d0
	movea.l (a7),a1
	addq.w #2,a1
l036e6:	move.b (a1)+,d1
	bclr #0x05,d1 | * uppercase
	cmp.b (a4)+,d1
	bne.s l036f6 | * try next driver
	subq.w #1,d0
	bgt.s l036e6
	bra.s l036fe | * drive name matches

l036f6:	movea.l (a2),a2
	move.l a2,d0 | * next driver
	bne.s l036dc
	bra.s l03718 | * no more drivers

l036fe:	moveq #0x00,d1
	move.b (a1)+,d1
	subi.b #0x30,d1 | * 1<=drive number<=8
	ble.s l03718
	cmpi.b #0x09,d1
	bge.s l03718
	cmpi.b #0x5f,(a1) | * '_'
	bne.s l03718
	moveq #0x00,d0
	bra.s l0371a | * ok, rts

l03718:	moveq #-0x07,d0
l0371a:	movem.l (a7)+,a1/a4
	rts


|*#: a2= (a2+1)& (not 1)
l03720:	move.l a2,d2
	addq.l #1,d2
	bclr #0x00,d2
	movea.l d2,a2
	rts


|* ANALYSE SYNTAX
l0372c:	movea.l (a7),a2 | * IO.DECODE
	addq.w #6,a2
	movem.l d4/d7/a0/a3,-(a7)
	moveq #0x00,d7
	move.w (a0)+,d7
	add.l a0,d7
	move.w (a2)+,d2
l0373c:	bsr.s l037b6
	cmp.b (a2)+,d1
	bne.s l037a6
	subq.b #1,d2
	bne.s l0373c
	bsr.s l03720
	move.w (a2)+,d4
	bra.s l03790

l0374c:	bsr.s l03720
	move.b (a2)+,d1
	beq.s l03778
	blt.s l03760
	bsr.s l037b6
	cmp.b (a2)+,d1
	beq.s l03762
	subq.w #1,a0
	move.w (a2)+,(a3)+
	bra.s l03790

l03760:	addq.w #1,a2
l03762:	movea.l a7,a1
	move.w (a2)+,-(a7)
	suba.l a6,a0
	suba.l a6,a1
	sub.l a6,d7
	jsr l03dc2(pc)
	adda.l a6,a0
	add.l a6,d7
	move.w (a7)+,(a3)+
	bra.s l03790

l03778:	move.b (a2)+,d2
	ext.w d2
l0377c:	adda.w d2,a2 | * IO.SERQ
	move.l a2,-(a7)
	bsr.s l037b6
l03782:	cmp.b -(a2),d1
	beq.s l0378c
	subq.w #1,d2
	bne.s l03782
	subq.w #1,a0
l0378c:	move.w d2,(a3)+
	movea.l (a7)+,a2
l03790:	dbf d4,l0374c
	cmp.l a0,d7
	bne.s l0379c
	moveq #0x04,d1
	bra.s l037ae

l0379c:	movem.l (a7)+,d4/d7/a0/a3
	addq.l #2,(a7)
	moveq #-0x0c,d0
	rts

l037a6:	movem.l (a7)+,d4/d7/a0/a3
	moveq #-0x07,d0
	rts

l037ae:	movem.l (a7)+,d4/d7/a0/a3
	addq.l #4,(a7)
	rts

l037b6:	moveq #0x00,d1
	cmp.l a0,d7
	beq.s l037c8
	move.b (a0),d1
	cmpi.b #0x60,d1
	blt.s l037c8
	subi.b #0x20,d1
l037c8:	addq.w #1,a0
	rts


|* DIRECT FILE HANDLING
|* queue routines
l037cc:	lea 0x0018(a0),a2 | * pipe#  I / O
	cmpi.b #0x03,d0
	bls.s l037d8
	addq.w #4,a2
l037d8:	tst.l (a2)
	beq.s l037f0
	movea.l (a2),a2
	jsr l0388c(pc) | * IO.SERIO
.balign 2, 0 ; 	.long xl0380a | * ROUTINE TEST FILE
.balign 2, 0 ; 	.long xl0385e | * READ FROM PIPE
.balign 2, 0 ; 	.long xl03838 | * WRITE TO PIPE
	rts

l037f0:	moveq #-0x0f,d0
	rts


l037f4:	lea 0x10(a2,d1.w),a3 | * IO.QSET
	clr.l (a2)+
	move.l a3,(a2)+
	subq.w #1,a3
	move.l a3,(a2)+
	move.l a3,(a2)+
	suba.l #0x10,a2
	rts


|* test status of queue
l0380a:
.equ xl0380a, l0380a
	moveq #-0x11,d2 | * IO.QTEST
	add.l 0x0004(a2),d2
	sub.l a2,d2
	move.l 0x0008(a2),d0
	movea.l 0x000c(a2),a3
	move.b (a3),d1
	sub.l a3,d0
	bgt.s l03832
	blt.s l0382e
	tst.b (a2)
	blt.s l0382a
	moveq #-0x01,d0
	rts

l0382a:	moveq #-0x0a,d0
	rts

l0382e:	add.l d2,d0
	addq.l #1,d0
l03832:	sub.l d0,d2
	moveq #0x00,d0
	rts

|* put byte into queue
|* Vector EA
l03838:
.equ xl03838, l03838
	tst.b (a2) | * IO.QIN
	bne.s l0385a
	movea.l 0x0008(a2),a3
	move.b d1,(a3)+
	cmpa.l 0x0004(a2),a3
	blt.s l0384c
	lea 0x0010(a2),a3
l0384c:	cmpa.l 0x000c(a2),a3
	bne.s l03856
	moveq #-0x01,d0
	rts

l03856:	move.l a3,0x0008(a2)
l0385a:	moveq #0x00,d0
	rts

|* Vector E2 + WRITE TO PIPE

l0385e:
.equ xl0385e, l0385e
	movea.l 0x000c(a2),a3 | * IO.QOUT
	cmpa.l 0x0008(a2),a3
	bne.s l03874
	tst.b (a2)
	blt.s l03870
	moveq #-0x01,d0
	rts

l03870:	moveq #-0x0a,d0
	rts

l03874:	move.b (a3)+,d1
	cmpa.l 0x0004(a2),a3
	blt.s l03880
	lea 0x0010(a2),a3
l03880:	move.l a3,0x000c(a2)
	moveq #0x00,d0
	rts

.equ l03882, l03880+2

l03888:	tas (a2) | * IO.QEOF
	rts

|* Vector EA

l0388c:	addi.l #0x0000000c,(a7) | * IO.SERIO - d0 as trap 3
	movea.l (a7),a4
	move.l d2,d4
	move.l d1,d5
	cmpi.w #0x0045,d0
	bhi.s l038b2
	cmpi.w #0x0007,d0
	bhi.s l03914
	andi.l #0x0000ffff,d4
	move.b l038c0(pc,d0.w),d0
	jmp l038c0(pc,d0.w)

l038b2:	cmpi.b #0x49,d0
	bhi.s l03914
	move.b l038c0-0x3e(pc,d0.w),d0
	jmp l038c0(pc,d0.w)

l038c0:	.byte xl0390a-l038c0
	.byte xl0390c-l038c0
	.byte xl038cc-l038c0
	.byte xl038f8-l038c0
	.byte xl03914-l038c0
	.byte xl0390e-l038c0
	.byte xl03914-l038c0
	.byte xl038e4-l038c0
	.byte xl03930-l038c0
	.byte xl03944-l038c0
	.byte xl038f8-l038c0
	.byte xl038e4-l038c0

l038cc:	move.l -0x0008(a4),a4
.equ xl038cc, l038cc
l038d0:	cmp.l d5,d4
	bls.s l03918
	bsr.s l03922
	bne.s l0391e
	move.b d1,(a1)+
	addq.l #1,d5
	cmpi.b #0x0a,d1
	bne.s l038d0
	bra.s l0391e

l038e4:	movea.l -0x0004(a4),a4
l038e8:	cmp.l d5,d4
	bls.s l0391c
	move.b (a1),d1
	bsr.s l03922
	bne.s l0391e
	addq.w #1,a1
	addq.l #1,d5
	bra.s l038e8

.equ xl038e4, l038e4

l038f8:	movea.l -0x0008(a4),a4
.equ xl038f8, l038f8
l038fc:	cmp.l d5,d4
	bls.s l0391c
	bsr.s l03922
	bne.s l0391e
	move.b d1,(a1)+
	addq.l #1,d5
	bra.s l038fc

l0390a:	subq.w #4,a4
l0390c:	subq.w #4,a4
l0390e:	movea.l -0x0004(a4),a4
	bra.s l03922

.equ xl0390a, l0390a
.equ xl0390c, l0390c
.equ xl0390e, l0390e

l03914:	moveq #-0x0f,d0
	bra.s l0392c
.equ xl03914, l03914
l03918:	moveq #-0x05,d0
	bra.s l0391e

l0391c:	moveq #0x00,d0
l0391e:	move.l d5,d1
	bra.s l0392c

l03922:	movem.l d4-d5/a1/a4,-(a7)
	jsr (a4)
	movem.l (a7)+,d4-d5/a1/a4
l0392c:	tst.l d0
	rts

l03930:
.equ xl03930, l03930
	movea.l -0x0004(a4),a4
	moveq #0x0f,d4
	tst.w d5
	bgt.s l038e8
	st d1
	bsr.s l03922
	bne.s l0391e
	moveq #0x01,d5
	bra.s l038e8

l03944:
.equ xl03944, l03944
	moveq #0x0f,d4
	tst.w d5
	bgt.s l038f8
	movea.l -0x000c(a4),a4
	bsr.s l03922
	bne.s l0391e
	addq.b #1,d1
	bne.s l03914
	movea.l (a7),a4
	bsr.s l0390c
	moveq #0x01,d5
	bra.s l038fc

l0395e:	move.l a0,-(a7) | * UT.ERR0
	suba.l a0,a0
	bsr.s l03968 | * UT.ERR
	movea.l (a7)+,a0
	rts

l03968:	tst.l d0 | * UT.ERR
	bge.s l0398e
	movem.l d0-d3/a1,-(a7)
	movea.l d0,a1
	add.l d0,d0
	bvs.s l03986
	neg.w d0
	movea.l 0x0002814a,a1 | * TABLE OF ERROR-MESSAGES 
	move.w 0x00(a1,d0.w),d0
	lea 0x00(a1,d0.w),a1
l03986:	jsr l039b2(pc) | * UT.MTEXT
	movem.l (a7)+,d0-d3/a1
l0398e:	rts

l03990:	move.l a6,-(a7) | * UT.MINT
	suba.l a6,a6
	movea.l a7,a1
	subq.w #8,a7
	move.l a0,-(a7)
	lea 0x0004(a7),a0
	move.w d1,-(a1)
	jsr l03e54(pc) | * CN.ITOD
	movea.l (a7)+,a0
	movea.l a7,a1
	move.w d1,d2
	bsr.s l039b4
	addq.w #8,a7
	movea.l (a7)+,a6
	rts

l039b2:	move.w (a1)+,d2 | * UT.MTEXT
l039b4:	moveq #0x07,d0
	move.l a0,d3
	beq.s l039be
	moveq #-0x01,d3
	bra.s l039c4

l039be:	sf 0x00028033

l039c4:	trap #0x03
	cmpi.w #0xffff,d0
	bne.s l039d8
	move.l #0x00010001,a0 | * scr#1
	moveq #0x07,d0
	trap #0x03
	suba.l a0,a0
l039d8:	tst.l d0
	rts

|* vector d2

l039dc:	move.l (a1),(a0) | * UT.LINK
	move.l a0,(a1)
	rts

|* vector d4

l039e2:	cmpa.l (a1),a0 | * UT.UNLNK
	beq.s l039ee
	tst.l (a1)
	beq.s l039f0
	movea.l (a1),a1
	bra.s l039e2

l039ee:	move.l (a0),(a1)
l039f0:	rts

l039f2:	bsr.s l03a2a | * UT.WINDW
	bra.s l03a0c

l039f6:	lea l03a44(pc),a0 | * UT.CON
	bra.s l03a00

l039fc:	lea l03a4a(pc),a0 | * UT.SCR
l03a00:	bsr.s l03a2a
l03a02:	addq.w #4,a1
	moveq #0x0d,d0
	moveq #0x00,d2
	bsr.s l03a36
	subq.w #4,a1
l03a0c:	moveq #0x0c,d0
	move.b (a1)+,d1
	move.b (a1)+,d2
	bsr.s l03a36
	moveq #0x27,d0
	move.b (a1),d1
	bsr.s l03a36
	moveq #0x28,d0
	move.b (a1)+,d1
	bsr.s l03a36
	moveq #0x29,d0
	move.b (a1),d1
	bsr.s l03a36
	moveq #0x20,d0
	bra.s l03a36

|* open window#

l03a2a:	move.l a1,-(a7)
	moveq #0x01,d0
	moveq #-0x01,d1
	moveq #0x00,d3
	trap #0x02
	bra.s l03a3a

|* windowtrap

l03a36:	move.l a1,-(a7)
	trap #0x03
l03a3a:	movea.l (a7)+,a1
	tst.l d0
	beq.s l03a42
	addq.w #4,a7
l03a42:	rts

.balign 2, 0 ; l03a44:	.word 0x03
	.ascii "CON" ; .byte 0x00
.balign 2, 0 ; l03a4a:	.word 0x03
	.ascii "SCR" ; .byte 0x00

|* set pointer for string-compa.

l03a50:	moveq #0x00,d4
	move.b d0,d4
	ror.l #1,d4
	subq.b #2,d4
	move.w 0x00(a6,a0.l),d0
	addq.w #2,a0
	lea 0x00(a0,d0.w),a2
	move.w 0x00(a6,a1.l),d1
	addq.w #2,a1
	lea 0x00(a1,d1.w),a3
	rts

|* find pos of string 2 in string 1

l03a6e:	movem.l d4/a0-a4,-(a7)
	bsr.s l03a50
	lea 0x00(a1,d0.w),a4
	exg a3,a4
	moveq #0x00,d1
l03a7c:	cmpa.l a4,a3
	bgt.s l03a8c
	addq.l #1,d1
	bsr.s l03a96
	beq.s l03a90
	addq.w #1,a1
	addq.w #1,a3
	bra.s l03a7c

|* string comparison

l03a8c:	moveq #0x00,d1
	moveq #0x00,d0
l03a90:	movem.l (a7)+,d4/a0-a4
	rts

l03a96:	movem.l d1-d5/a0-a3,-(a7)
	bra.s l03aa2

l03a9c:	movem.l d1-d5/a0-a3,-(a7)
	bsr.s l03a50
l03aa2:	cmpa.l a2,a0
	bne.s l03aac
	cmpa.l a3,a1
	bne.s l03ac8
	bra.s l03acc

l03aac:	cmpa.l a3,a1
	beq.s l03ad0
	bsr.s l03ae8
	cmp.b d4,d0
	beq.s l03b2c
	cmp.b d3,d2
	bne.s l03ac6
	tst.b d0
	ble.s l03aa2
	tst.l d4
	blt.s l03aa2
	cmpi.b #0x02,d0
l03ac6:	bgt.s l03ad0
l03ac8:	moveq #-0x01,d0
	bra.s l03ad2

l03acc:	moveq #0x00,d0
	bra.s l03ad2

l03ad0:	moveq #0x01,d0
l03ad2:	movem.l (a7)+,d1-d5/a0-a3
	rts

|* Table of results of string comparison

.balign 2, 0 ; l03ad8:	.word 0x0000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x00ff
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0001
.balign 2, 0 ; 	.word 0x0000
.balign 2, 0 ; 	.word 0x0300

|* compare bytes of string

l03ae8:	exg a0,a1
	exg a2,a3
	bsr.s l03b04
	exg a0,a1
	exg a2,a3
	move.b d0,d1
	move.b d2,d3
	bsr.s l03b04
	lsl.b #2,d0
	add.b d1,d0
	ext.w d0
	move.b l03ad8(pc,d0.w),d0
	rts

|* correct decimal values (3.5)

l03b04:	move.b 0x00(a6,a0.l),d2
	addq.w #1,a0
	bsr.w l03bfa
	cmpi.b #0xce,d2
	bne.s l03b2a
	cmpa.l a2,a0
	beq.s l03b28
	cmpi.b #0x30,0x00(a6,a0.l)
	blt.s l03b28
	cmpi.b #0x39,0x00(a6,a0.l)
	ble.s l03b2a
l03b28:	clr.b d0
l03b2a:	rts

|* compare two ASCII numbers

l03b2c:	bsr.s l03b96
	move.w d3,d2
	move.w d1,d3
	exg a0,a1
	exg a2,a3
	bsr.s l03b96
	cmp.w d1,d3
l03b3a:	bne.s l03ac6
	suba.w d1,a0
	suba.w d1,a1
	bra.s l03b50

l03b42:	move.b 0x00(a6,a1.l),d5
	addq.w #1,a1
	cmp.b 0x00(a6,a0.l),d5
	addq.w #1,a0
	bne.s l03b3a
l03b50:	dbf d1,l03b42
	bsr.s l03bcc
	move.w d3,-(a7)
	move.w d1,-(a7)
	exg a0,a1
	exg a2,a3
	bsr.s l03bcc
	move.w (a7)+,d0
	move.w (a7)+,d2
	sub.w d2,d3
	bgt.s l03b6a
	add.w d3,d2
l03b6a:	tst.w d2
	beq.s l03b8c
	suba.w d1,a0
	suba.w d0,a1
	sub.w d2,d1
	sub.w d2,d0
l03b76:	move.b 0x00(a6,a0.l),d5
	addq.w #1,a0
	cmp.b 0x00(a6,a1.l),d5
	addq.w #1,a1
	bne.s l03b3a
	subq.w #1,d2
	bne.s l03b76
	adda.w d1,a0
	adda.w d0,a1
l03b8c:	tst.w d3
	bne.w l03ac6
	bra.w l03aa2

l03b96:	moveq #0x00,d1
l03b98:	cmpi.b #0xd0,d2
	bne.s l03bb0
	cmpa.l a2,a0
	beq.s l03bca
	move.b 0x00(a6,a0.l),d2
	addq.w #1,a0
	bsr.s l03bfa
	subq.b #1,d0
	bne.s l03bc8
	bra.s l03b98

l03bb0:	cmpi.b #0xce,d2
	beq.s l03bc8
	addq.w #1,d1
	cmpa.l a2,a0
	beq.s l03bca
	move.b 0x00(a6,a0.l),d2
	addq.w #1,a0
	bsr.s l03bfa
	subq.b #1,d0
	beq.s l03bb0
l03bc8:	subq.w #1,a0
l03bca:	rts

l03bcc:	moveq #0x00,d1
	moveq #0x00,d3
l03bd0:	cmpa.l a2,a0
	beq.s l03bf8
	move.b 0x00(a6,a0.l),d2
	bsr.s l03bfa
	subq.b #1,d0
	bne.s l03bf8
	cmpi.b #0xce,d2
	bne.s l03bea
	tst.l d1
	bne.s l03bf8
	moveq #-0x01,d1
l03bea:	addq.w #1,a0
	addq.w #1,d1
	cmpi.b #0xd0,d2
	beq.s l03bd0
	move.w d1,d3
	bra.s l03bd0

l03bf8:	rts

l03bfa:	move.b d2,d0
	blt.s l03c14
	cmpi.b #0x2e,d0
	beq.s l03c18
	ext.w d0
	addi.w #xvalue1,d0
	move.b l03bfa(pc,d0.w),d0
	beq.s l03c14
	subq.b #2,d0
	ble.s l03c18
l03c14:	clr.b d0
	rts

l03c18:	move.b d2,d0
	addi.b #0xa0,d2
	bcc.s l03c24
	subi.b #0x20,d2
l03c24:	lsr.b #5,d0
	rts

|* this label defines type of ASCII code
l03c28:
.equ xvalue1, l03c28-l03bfa
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x20030000
.balign 2, 0 ; 	.long 0x24250003
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x03000000
.balign 2, 0 ; 	.long 0x02020202
.balign 2, 0 ; 	.long 0x02020202
.balign 2, 0 ; 	.long 0x02020003
.balign 2, 0 ; 	.long 0x00000000
.balign 2, 0 ; 	.long 0x00010101
.balign 2, 0 ; 	.long 0x01010101
.balign 2, 0 ; 	.long 0x01010101
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x00
	.byte 0x00, 0x00, 0x00, 0x01
	.byte 0x00, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x01
	.byte 0x01, 0x01, 0x01, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

|* test sign of number to convert to floating-point number

l03ca8:	cmp.l a0,d7
	beq.s l03cca
	addq.w #1,a0
l03cae:	cmpi.b #0x20,0x00(a6,a0.l)
	beq.s l03ca8
	moveq #0x00,d5
	moveq #0x2b,d6
	sub.b 0x00(a6,a0.l),d6
	beq.s l03cc8
	addq.b #2,d6
	bne.s l03cca
	bset #0x1f,d5
l03cc8:	addq.w #1,a0
l03cca:	rts

|* convert ASCII to decimal

l03ccc:	moveq #0x00,d6
	cmp.l a0,d7
	beq.s l03cea
	move.b 0x00(a6,a0.l),d6
	subi.w #0x0030,d6
	blt.s l03ce6
	cmpi.w #0x0009,d6
	bgt.s l03ce6
	addq.l #2,(a7)
	bra.s l03cea

l03ce6:	addi.w #0x0030,d6
l03cea:	addq.w #1,a0
	rts

|* convert entire number from ASCII to decimal

l03cee:	bsr.s l03cae
	bsr.s l03ccc
	bra.s l03d08 | * ERROR
l03cf4:	move.l d6,d3
l03cf6:	bsr.s l03ccc
	bra.s l03d0c | * ERROR
l03cfa:	mulu #0x000a,d3
	add.l d6,d3
	cmpi.l #0x00007fff,d3
	ble.s l03cf6
l03d08:	moveq #-0x11,d0
	rts

|* TEST SIGN + / -

l03d0c:	tst.l d5
	bpl.s l03d12
	neg.w d3
l03d12:	moveq #0x00,d0
	rts

|* vector 100 - convert ASCII to floating point

l03d16:	movem.l d3-d6/a0-a1,-(a7) | * CN.DTOF
	moveq #0x00,d4
	bsr.s l03cae
	subq.w #6,a1
	clr.l 0x02(a6,a1.l)
	clr.w 0x00(a6,a1.l)
l03d28:	bsr.s l03ccc
	bra.s l03d48
l03d2c:	move.b #0xdf,d5 | * CN.DTOI
	tst.w d4
	beq.s l03d36
	addq.w #1,d4
l03d36:	bsr.s l03db6
	jsr l048de(pc)
	bne.s l03db0
	move.l d6,d1
	bsr.s l03db8
	jsr l04838(pc)
	bra.s l03d28

l03d48:	cmpi.b #0x2e,d6
	bne.s l03d56
	tst.w d4
	bne.s l03dae
	moveq #0x01,d4
	bra.s l03d28

l03d56:	tst.b d5
	beq.s l03dae
	tst.l d5
	bpl.s l03d62
	jsr l04a0c(pc)
l03d62:	moveq #0x00,d3
	and.b d5,d6
	cmpi.b #0x45,d6
	bne.s l03d70
	bsr.s l03cee
	bne.s l03db0
l03d70:	tst.w d4
	beq.s l03d76
	subq.w #1,d4
l03d76:	sub.w d3,d4
	bvs.s l03dae
	beq.s l03da2
	sge d5
	bge.s l03d82
	neg.w d4
l03d82:	bsr.s l03db6
	subq.w #2,a1
	move.w d4,0x00(a6,a1.l)
	jsr l047dc(pc)
	bne.s l03db0
	tst.b d5
	beq.s l03d9c
	jsr l0497e(pc)
	bne.s l03db0
	bra.s l03da2

l03d9c:	jsr l048de(pc)
	bne.s l03db0
l03da2:	movem.l (a7)+,d3-d6
	subq.w #1,a0
	addq.w #8,a7
	moveq #0x00,d0
	rts

l03dae:	moveq #-0x11,d0
l03db0:	movem.l (a7)+,d3-d6/a0-a1
	rts

l03db6:	moveq #0x0a,d1
l03db8:	move.l #0x0000081f,d0
	jmp l04830(pc)

|* vector 102 ASCII to int
|* CN.DTOI
l03dc2:	movem.l d3-d6/a0-a1,-(a7)
	bsr.w l03cee
	bne.s l03db0
	subq.w #2,a1
	move.w d3,0x00(a6,a1.l)
	bra.s l03da2

|* vector 10A

l03dd4:	moveq #0x02,d2 | * CN.HTOIB
	bra.s l03dde

|* vector 10C

l03dd8:	moveq #0x04,d2 | * CN.HTOIW
	bra.s l03dde

|* vector 10E

l03ddc:	moveq #0x08,d2 | * CN.HTOIL
l03dde:	movem.l d3-d6/a0-a1,-(a7)
	move.l d2,d4
	lsr.b #1,d4
	subq.w #2,a1
	move.b d4,0x01(a6,a1.l)
	move.b #0x0f,0x00(a6,a1.l)
	moveq #0x04,d4
l03df4:	move.l d2,d5
	moveq #0x00,d3
l03df8:	bsr.w l03ccc
	bra.s l03e00 | * error
	bra.s l03e0e | * ok

l03e00:	andi.b #0xdf,d6
	subi.b #0x41,d6
	blt.s l03e1e
	addi.b #0x0a,d6
l03e0e:	cmp.b 0x00(a6,a1.l),d6
	bhi.s l03e1e
	lsl.l d4,d3
	add.l d6,d3
	dbf d2,l03df8
	bra.s l03e30

l03e1e:	move.b 0x01(a6,a1.l),d4
	addq.l #2,a1
	move.l d3,-0x04(a6,a1.l)
	suba.l d4,a1
	cmp.w d2,d5
	bgt.w l03da2
l03e30:	bra.w l03dae

|* vector 104

l03e34:	moveq #0x08,d2 | * CN.BTOIB
	bra.s l03e3e

|* vector 106

l03e38:	moveq #0x10,d2 | * CN.BTOIW
	bra.s l03e3e

l03e3c:	moveq #0x20,d2 | * CN.BTOIB
l03e3e:	movem.l d3-d6/a0-a1,-(a7)
	move.l d2,d4
	lsr.b #3,d4
	subq.w #2,a1
	move.b d4,0x01(a6,a1.l)
	moveq #0x01,d4
	move.b d4,0x00(a6,a1.l)
	bra.s l03df4

|* vector F2

l03e54:	move.l a2,-(a7) | * CN.ITOD
	move.l a0,-(a7)
	moveq #0x00,d0
	move.w 0x00(a6,a1.l),d0
	addq.w #2,a1
	bge.s l03e6c
	move.b #0x2d,0x00(a6,a0.l)

	addq.w #1,a0
	neg.w d0
l03e6c:	move.l a0,-(a7)
	addq.w #5,a0
l03e70:	divu #0x000a,d0
	swap d0
	addi.b #0x30,d0
	subq.w #1,a0
	move.b d0,0x00(a6,a0.l)
	clr.w d0
	swap d0
	bne.s l03e70
	move.l (a7)+,d1
	sub.l a0,d1
	move.w d1,d0
	addq.w #4,d0
l03e8e:	lea 0x00(a0,d1.w),a2
	move.b 0x00(a6,a0.l),0x00(a6,a2.l)
	addq.w #1,a0
	dbf d0,l03e8e
	add.l a0,d1
	movea.l d1,a0
	sub.l (a7)+,d1
	movea.l (a7)+,a2
	rts

l03ea8:	bsr.w l03eac | * CN.ITOHL
l03eac:	bsr.w l03eb0 | * CN.ITOHW
l03eb0:	move.b 0x00(a6,a1.l),d0 | * CN.ITOHB
	lsr.b #4,d0
	bsr.s l03ec0
	moveq #0x0f,d0
	and.b 0x00(a6,a1.l),d0
	addq.w #1,a1
l03ec0:	addi.b #0x30,d0
	cmpi.b #0x39,d0
	bls.s l03ecc
	addq.b #7,d0
l03ecc:	move.b d0,0x00(a6,a0.l)
	addq.w #1,a0
	rts

l03ed4:	bsr.w l03ed8 | * CN.ITOBL  
l03ed8:	bsr.w l03edc | * CN.ITOBW
l03edc:	moveq #0x07,d0 | * CN.ITOBB
l03ede:	btst d0,0x00(a6,a1.l)
	seq 0x00(a6,a0.l)
	addi.b #0x31,0x00(a6,a0.l)
	addq.w #1,a0
	dbf d0,l03ede
	addq.w #1,a1
	rts

|* vector F0
|* float to ASCII
l03ef6:	movem.l d2-d5,-(a7) | * CN.FTOD
	move.l a0,-(a7)
	tst.l 0x02(a6,a1.l)
	beq.w l04000
	moveq #0x06,d4
	tst.b 0x02(a6,a1.l)
	bge.s l03f18
	move.b #0x2d,0x00(a6,a0.l)
	addq.w #1,a0
	jsr l04a0c(pc) | * float NEG
l03f18:	cmpi.l #0x081b5f60,0x00(a6,a1.l)
	blt.s l03f2c
	addq.w #1,d4
	bsr.s l03f40
	jsr l0497e(pc) | * float DIV
	bra.s l03f18

l03f2c:	cmpi.l #0x08184c4c,0x00(a6,a1.l)
	bge.s l03f6c
	subq.w #1,d4
	bsr.s l03f40
	jsr l048de(pc)
	bra.s l03f2c

l03f40:	subq.w #6,a1
	move.l #0x08045000,0x00(a6,a1.l)
	clr.w 0x04(a6,a1.l)
	rts

l03f50:	moveq #0x00,d0
	swap d1
	move.w d1,d0
	divu #0x000a,d0
	swap d0
	move.w d0,d1
	swap d1
	divu #0x000a,d1
	move.w d1,d0
	swap d1
	exg d0,d1
	rts

l03f6c:	moveq #0x1f,d0
	sub.w 0x00(a6,a1.l),d0
	move.l 0x02(a6,a1.l),d1
	lsr.l d0,d1
	addq.w #6,a1
l03f7a:	addq.l #5,d1
	bsr.s l03f50
	addq.w #1,d4
	cmpi.l #0x00989680,d1
	bge.s l03f7a
	addq.w #8,a0
	moveq #0x06,d2
l03f8c:	bsr.s l03f50
	addi.b #0x30,d0
	subq.w #1,a0
	move.b d0,0x00(a6,a0.l)
	dbf d2,l03f8c
	cmpi.w #0x0005,d4
	bgt.s l03fac
	cmpi.w #0xffff,d4
	blt.s l03fac
	moveq #0x00,d5
	bra.s l03fb0

l03fac:	move.l d4,d5
	moveq #0x00,d4
l03fb0:	addq.w #1,d4
	move.l a0,d2
	bra.s l03fbe

l03fb6:	move.b 0x00(a6,a0.l),-0x01(a6,a0.l)
	addq.w #1,a0
l03fbe:	dbf d4,l03fb6
	move.b #0x2e,-0x01(a6,a0.l)
	movea.l d2,a0
	addq.w #7,a0
l03fcc:	subq.w #1,a0
	cmpi.b #0x30,0x00(a6,a0.l)
	beq.s l03fcc
	cmpi.b #0x2e,0x00(a6,a0.l)
	beq.s l03fe0
	addq.w #1,a0
l03fe0:	tst.w d5
	beq.s l03ff6
	move.b #0x45,0x00(a6,a0.l)
	addq.w #1,a0
	subq.w #2,a1
	move.w d5,0x00(a6,a1.l)
	jsr l03e54(pc) | * CN.ITOD
l03ff6:	move.l a0,d1
	sub.l (a7)+,d1
	movem.l (a7)+,d2-d5
	rts

l04000:	move.b #0x30,0x00(a6,a0.l)
	addq.w #1,a0
	addq.w #6,a1
	bra.s l03ff6

l0400c:	movem.l d0/d5,-(a7)
	cmpi.w #0x000a,d0
	bge.s l04034
l04016:	subq.w #1,d5
	ble.s l04024
	move.b #0x30,0x00(a6,a1.l)
	addq.l #1,a1
	bra.s l04016

l04024:	addi.w #0x0030,d0
	move.b d0,0x00(a6,a1.l)
	addq.l #1,a1
	movem.l (a7)+,d0/d5
	rts

l04034:	andi.l #0x0000ffff,d0
	divu #0x000a,d0
	subq.w #1,d5
	bsr.s l0400c
	swap d0
	bra.s l04024

l04046:	bsr.s l0400c
	move.b #0x20,0x00(a6,a1.l)
	addq.l #1,a1
	rts

l04052:	bsr.s l0400c
	move.b #0x3a,0x00(a6,a1.l)
	addq.l #1,a1
	rts

|* vector CE

l0405e:	movem.l d1-d5/a2,-(a7) | * CN.DATE
	bsr.w l040f6
	suba.l #0x16,a1
	move.w #0x0014,0x00(a6,a1.l)
	addq.l #2,a1
	move.w d2,d0
	moveq #0x04,d5
	bsr.s l04046
	mulu #0x0003,d4
	movea.l 0x0002814a,a2 | * table of error messages
	move.w 0x003a(a2),d0
	lea 0x00(a2,d0.w),a2
	adda.w d4,a2
	bsr.s l040e8
	move.b #0x20,0x00(a6,a1.l)
	addq.l #1,a1
	moveq #0x02,d5
	move.w d1,d0
	bsr.s l04046
	swap d2
	move.w d2,d0
	bsr.s l04052
	move.w d3,d0
	bsr.s l04052
	swap d3
	move.w d3,d0
	bsr.w l0400c
	suba.l #0x00000016,a1
l040b6:	movem.l (a7)+,d1-d5/a2
	moveq #0x00,d0
	rts

|* vector CE

l040be:	movem.l d1-d5/a2,-(a7) | * CN.DAY
	bsr.s l040f6
	subq.l #6,a1
	move.w #0x0003,0x00(a6,a1.l)
	addq.l #2,a1
	mulu #0x0003,d0
	movea.l 0x0002814a,a2
	move.w 0x0038(a2),d1
	lea 0x00(a2,d1.w),a2
	adda.w d0,a2
	bsr.s l040e8
	subq.l #5,a1
	bra.s l040b6

l040e8:	moveq #0x02,d0
l040ea:	move.b (a2)+,0x00(a6,a1.l)
	addq.l #1,a1
	dbf d0,l040ea
	rts

l040f6:	move.w #0x003c,d2
	bsr.w l0417e
	move.w d0,d3
	swap d3
	bsr.s l0417e
	move.w d0,d3
	divu #0x0018,d1
	move.l d1,d2
	andi.l #0x0000ffff,d1
	move.l d1,d0
	divu #0x0007,d0
	swap d0
	divu #0x05b5,d1
	move.w d1,d2
	asl.w #2,d2
	addi.w #0x07a9,d2
	clr.w d1
	swap d1
	divu #0x016d,d1
	moveq #0x00,d4
	cmpi.w #0x0004,d1
	bne.s l0413c
	subq.w #1,d1
	move.w #0x016d,d4
l0413c:	add.w d1,d2
	swap d1
	add.w d4,d1
	moveq #0x00,d5
	move.w d2,d4
	andi.w #0x0003,d4
	bne.s l0414e
	moveq #0x01,d5
l0414e:	move.w d5,d4
	addi.w #0x003a,d4
	cmp.w d4,d1
	ble.s l0415c
	addq.w #2,d1
	sub.w d5,d1
l0415c:	move.w d1,d5
	addi.w #0x005c,d5
	mulu #0x0064,d5
	divu #0x0bef,d5
	move.w d5,d4
	addi.w #0x005c,d1
	mulu #0x0bef,d5
	divu #0x0064,d5
	sub.w d5,d1
	subq.w #3,d4
	rts

l0417e:	moveq #0x00,d0
	swap d1
	move.w d1,d0
	divu d2,d0
	swap d0
	move.w d0,d1
	swap d1
	divu d2,d1
	move.w d1,d0
	swap d1
	exg d0,d1
	rts

	.include "arithm_asm.s"

	.include "basic1_asm.s"

	.include "mdv_routines.s"

	.include "net_routines.s"

	.include "basic2_asm.s"

	.include "basic_commands.s"

	.include "basic3_asm.s"

	.include "charfount_asm.s"

l0b352:	andi.w #0x0007,d2
	andi.w #0x003f,d1
	cmpi.b #0x36,d1
	bne.s l0b368
	btst #0x01,d2
	beq.s l0b368
	rts

l0b368:	movem.l d3/d4/d5/a3,-(a7)
	lea l0b458:l,a3 | * keyboard - table
	move.w 0x8(a3),d4
	lea.l 0x0(a3,d4.w),a3
	moveq #0x4,d4
l0b37c:	cmp.b (a3)+,d1
	beq.s l0b388
	addq.l #1,a3
	dbf d4,l0b37c
	bra.s l0b392

l0b388:	move.b (a3),d1
	or.b d2,d1
	jmp l0b450:l

l0b392:	clr.w d5
	bclr #0x0,d2
	beq.s l0b39e
	move.b #0xff,d5
l0b39e:	lea l0b458:l,a3
	move.w 0x0(a3,d2.w),d3
	lea.l 0x0(a3,d3.w),a3
	clr.l d3
	move.b (a3)+,d3
	cmp.b d3,d1
	bge.s l0b3ba
	jmp l0b446:l | * !!! PC-RELATIV POSSIBLE !!!

l0b3ba:	cmp.b (a3)+,d1
	ble.s l0b3c4
	jmp l0b446:l
l0b3c4:	suba.w d3,a3
	move.b 0x0(a3,d1.w),d3
	cmpi.b #0xff,d3
	bne.s l0b3d8
	add.b d2,d1
	move.b d1,0x145(a6)
	bra.s l0b446

l0b3d8:	move.b d3,d1
	move.b 0x145(a6),d2
	beq.s l0b414
	clr.b 0x145(a6)
	lea l0b458:l,a3 | * !!! PC-RELATIV POSSIBLE !!!
	move.w 0xa(a3),d4
	lea 0x0(a3,d4.w),a3
l0b3f2:	tst.b (a3)
	beq.s l0b446
	cmp.b (a3)+,d2
	beq.s l0b404
	move.b (a3)+,d4
	asl.b #1,d4
	ext.w d4
	adda.w d4,a3
	bra.s l0b3f2

l0b404:	move.b (a3)+,d4
l0b406:	beq.s l0b446
	cmp.b (a3)+,d3
	beq.s l0b412
	addq.l #1,a3
	subq.b #1,d4
	bra.s l0b406

l0b412:	move.b (a3),d1
l0b414:	tst.b 0x88(a6) | * SV.CAPS
	beq.s l0b43c
	cmpi.b #0x61,d1
	bcs.s l0b43c
	cmpi.b #0x7a,d1
	bls.s l0b438
	cmpi.b #0x80,d1
	bcs.s l0b43c
	cmpi.b #0x8b,d1
	bhi.s l0b43c
	bset #0x5,d1
	bra.s l0b43c

l0b438:	bclr #0x5,d1
l0b43c:	tst.b d5
	beq.s l0b450
	lsl.w #8,d1
	move.b d5,d1
	bra.s l0b450

l0b446:	clr.w d1
	movem.l (a7)+,d3/d4/d5/a3
	addq.l #2,(a7)
	rts

l0b450:	movem.l (a7)+,d3/d4/d5/a3
	addq.l #4,(a7)
ob456:	rts

	.include "keyboard_asm.s"


l0b56c:	movem.l d1/d2/d3/a1,-(a7)
	moveq #0x0,d0
	move.l 0x146(a6),a1
	move.w 0x2(a1),d2
	lea 0x0(a1,d2.w),a1
	tst.b d1
	beq.s l0b5d6
	move.b 0x0(a1,d1.w),d0
	tst.b d0
	beq.s l0b58e
	move.b d0,d1
	bra.s l0b5d6
l0b58e:	move.l d1,d3
	jsr l0380a:l
	nop | * !!! to coform asm !!!
	move.l d3,d1
	cmpi.w #0xfff6,d0
	beq.s l0b5dc
	moveq #0x0,d0
	cmpi.w #0x3,d2
	bge.s l0b5aa
	moveq #-1,d0
	bra.s l0b5dc
l0b5aa:	move.l 0x146(a6),a1
	move.w 0x4(a1),d2
	lea 0x0(a1,d2.w),a1
	move.b (a1)+,d3
l0b5b8:	beq.s l0b5dc
	cmp.b (a1)+,d1
	beq.s l0b5c4
	addq.l #3,a1
	subq.b #1,d3
	bra.s l0b5b8
l0b5c4:	move.b (a1)+,d1
	jsr l03838:l
	nop | * !!! to conform asm !!!
	move.b (a1)+,d1
	jsr l03838:l
	nop | * !!! to conform asm !!!
	move.b (a1),d1
l0b5d6:	jsr l03838:l
	nop | * !!! to conform asm !!!
l0b5dc:	movem.l (a7)+,d1/d2/d3/a1
	rts

l0b5e2:	movem.l d0/d1/d2/a1,-(a7)
	move.l 0x146(a6),a1
	move.w 0x2(a1),d2
	lea 0x0(a1,d2.w),a1
	move.b 0x0(a1,d1.w),d0
	tst.b d0
	beq.s l0b60e
	move.w d1,d2
l0b5fc:	move.b 0x0(a1,d2.w),d0
	cmp.b d0,d1
	beq.s l0b60c
	addq.b #1,d2
	cmp.b d2,d1
	bne.s l0b5fc
	bra.s l0b60e
l0b60c:	move.b d2,d1
l0b60e:	movem.l (a7)+,d0/d1/d2/a1
	rts

	.include "tra_tab.s"

	.include "sys_mess.s"

	.include "1654_dcb0.s"
|;	include 5326_dbc0

	.org 0xbfe2, 0

.balign 2, 0 ; l0bfe2:	.long l0b614
.balign 2, 0 ; l0bfe6:	.long l0b71c
.balign 2, 0 ; l0bfea:	.long l0b5e2
.balign 2, 0 ; l0bfee:	.long l0b56c
.balign 2, 0 ; l0bff2:	.long l0b352

|* nr of version

.balign 2, 0 ; l0bbf6:	.long 0x312d3130
.balign 2, 0 ; l0bbfa:	.word 0x02
	.ascii "JS"
.balign 2, 0 ; 	.word 0x00

	| end (no emitted bytes)


.org 0xc000,0
.include "host_driver.s"
.org 0xfff0,0
.ascii "QLBOX-R4"
.org 0x10000,0
