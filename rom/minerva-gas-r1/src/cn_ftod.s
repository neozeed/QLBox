/* Generated from original/M/cn/ftod.asm */
/* QL: * Convert floating point to string */
/* QL:         xdef    cn_ftod */
.globl cn_ftod
/* QL:         xref    ri_neg,ri_div,ri_mult,ri_n_b */
/* QL:         xref    cn_0tod */
/* QL: ndigs   equ     7 */
.equ ndigs,7
/* QL: maxint  equ     10000000        10 ^ 7 */
.equ maxint,10000000
/* QL: fptiny  equ     $07ed 431bde81  10 ^ 7-13       highest*1e13 < 1.91e7 */
.equ fptiny,0x07ed
/* QL: fplow   equ     $08184c4b 4000  10 ^ 7          highest > 1e7 */
.equ fplow,0x08184c4b
/* QL: fphigh  equ     $081b5f5e 1000  10 ^ 7+1        highest/10 > 1e7 */
.equ fphigh,0x081b5f5e
/* QL: fphuge  equ     $0843 56bc75e3  10 ^ 7+13       highest/1e13 > 1.47e7 */
.equ fphuge,0x0843
/* QL: * The technique used is to adjust the input value until it is greater than */
/* QL: * 10^ndigs by factor of less than about 10. */
/* QL: * This uses repeated scaling by 10 or 10^13 (the largest exact fp power of 10). */
/* QL: * The resultant 8 digit integer (maybe squeaking to 9 digits) is then ready to */
/* QL: * divide by ten once (or maybe twice, on a bad day) and the remainder can be */
/* QL: * used to round the value (if it glitches over maxint, another divide by 10). */
/* QL: * The seven digits are used to build the output string. */
/* QL:         section cn_ftod */
.section cn_ftod,"ax"
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- number of characters in string */
/* QL: * a0 -i o- start of string buffer, output at end */
/* QL: * a1 -i o- arithmetic stack, float removed */
/* QL: reglist reg     d2-d4 */
/* QL: cn_ftod */
cn_ftod:
/* QL:         movem.l reglist,-(sp) */
    movem.l d2-d4,-(sp)
/* QL:         move.w  a0,-(sp)        only need lsw to calculate length */
    move.w a0,-(sp)
/* QL:         moveq   #0,d4           set exponent */
    moveq #0,d4
/* QL:         move.l  2(a6,a1.l),d0   check mantissa */
    move.l 2(a6,a1.l),d0
/* QL:         bgt.s   redent          positive is ok */
    bgt.s redent
/* QL:         beq.l   zero            zero is a special case */
    beq.w zero
/* QL:         move.b  #'-',0(a6,a0.l) put negative in */
    move.b #(45&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         jsr     ri_neg(pc)      negate (will make it strictly positive) */
    jsr ri_neg(pc)
/* QL:         bra.s   redent */
    bra.s redent
/* QL: put_10 */
put_10:
/* QL:         subq.w  #1,d4           take one from exponent */
    subq.w #1,d4
/* QL:         moveq   #10,d0 */
    moveq #10,d0
/* QL:         jmp     ri_n_b(pc) */
    jmp ri_n_b(pc)
/* QL: rep13 */
rep13:
/* QL:         move.w  #$82c,0(a6,a1.l) 1e13 = largest power of 10 with exact fp */
    move.w #0x82c,0(a6,a1.l)
/* QL:         move.l  #$48c27395,2(a6,a1.l) */
    move.l #0x48c27395,2(a6,a1.l)
/* QL:         sub.w   #13-1,d4        take additional from exponent */
    sub.w #(13-1),d4
/* QL:         rts */
    rts 
/* QL: redloop */
redloop:
/* QL:         bsr.s   put_10          divide by ten or ... */
    bsr.s put_10
/* QL:         cmp.w   #fphuge,0(a6,a1.l) */
    cmp.w #fphuge,0(a6,a1.l)
/* QL:         ble.s   godiv */
    ble.s godiv
/* QL:         bsr.s   rep13           ... 1e13 if it is huge */
    bsr.s rep13
/* QL: godiv */
godiv:
/* QL:         jsr     ri_div(pc) */
    jsr ri_div(pc)
/* QL: redent */
redent:
/* QL:         cmp.l   #fphigh,0(a6,a1.l) have we got less than ndigs+2 yet? */
    cmp.l #fphigh,0(a6,a1.l)
/* QL:         bgt.s   redloop         no - divide down by something */
    bgt.s redloop
/* QL:         neg.w   d4              negate exponent for proper value */
    neg.w d4
/* QL: increase */
increase:
/* QL:         cmp.l   #fplow,0(a6,a1.l) have we got at least ndigs+1 yet? */
    cmp.l #fplow,0(a6,a1.l)
/* QL:         bgt.s   integer         yes - go do integer calcs now */
    bgt.s integer
/* QL:         bsr.s   put_10          multiply by 10 or ... */
    bsr.s put_10
/* QL:         cmp.w   #fptiny,0(a6,a1.l) */
    cmp.w #fptiny,0(a6,a1.l)
/* QL:         bgt.s   gomul */
    bgt.s gomul
/* QL:         bsr.s   rep13           ... 1e13 if it was tiny */
    bsr.s rep13
/* QL: gomul */
gomul:
/* QL:         jsr     ri_mult(pc) */
    jsr ri_mult(pc)
/* QL:         bra.s   increase        try again */
    bra.s increase
/* QL: divl_10 */
divl_10:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         swap    d1 */
    swap d1
/* QL:         move.w  d1,d0           get msw of number */
    move.w d1,d0
/* QL:         divu    #10,d0          divide it by 10 */
    divu #10,d0
/* QL:         move.w  d0,d1 */
    move.w d0,d1
/* QL:         swap    d1              msw of quotient ready */
    swap d1
/* QL:         move.w  d1,d0           now remainder of 1st div and lsw of number */
    move.w d1,d0
/* QL:         divu    #10,d0          divide this by 10 */
    divu #10,d0
/* QL:         move.w  d0,d1           whole of quotient ready */
    move.w d0,d1
/* QL:         swap    d0              leave remainder in lsw */
    swap d0
/* QL:         addq.w  #1,d4           say we've done it */
    addq.w #1,d4
/* QL:         rts */
    rts 
/* QL: integer */
integer:
/* QL:         moveq   #31,d0          convert reduced fp to integer */
    moveq #31,d0
/* QL:         sub.w   0(a6,a1.l),d0   find shift */
    sub.w 0(a6,a1.l),d0
/* QL:         move.l  2(a6,a1.l),d1   get mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         lsr.l   d0,d1           shift it (will be 4..7 shifts) */
    lsr.l d0,d1
/* QL:         move.l  #maxint,d2      this is number we want to finish below */
    move.l #maxint,d2
/* QL: round */
round:
/* QL:         bsr.s   divl_10         divide by 10 */
    bsr.s divl_10
/* QL:         cmp.l   d2,d1           is it more than ndigs digits */
    cmp.l d2,d1
/* QL:         bge.s   round           this should happen one in about 64k times */
    bge.s round
/* QL:         subq.b  #5,d0           is remainder >= 5 */
    subq.b #5,d0
/* QL:         bmi.s   remok           no - that's ok then */
    bmi.s remok
/* QL:         addq.l  #1,d1           round up */
    addq.l #1,d1
/* QL:         cmp.l   d2,d1           that might just sneak over ... */
    cmp.l d2,d1
/* QL:         blt.s   remok           nope... that's ok */
    blt.s remok
/* QL:         bsr.s   divl_10         one in a million times! */
    bsr.s divl_10
/* QL: remok */
remok:
/* QL:         addq.w  #ndigs+1,a0     convert digits leaving one space for dp */
    addq.w #(ndigs+1),a0
/* QL:         moveq   #ndigs-1,d2 */
    moveq #(ndigs-1),d2
/* QL:         moveq   #'0',d3 */
    moveq #48,d3
/* QL: con_dig */
con_dig:
/* QL:         bsr.s   divl_10         divide by 10 */
    bsr.s divl_10
/* QL:         add.b   d3,d0           add ascii '0' to remainder to make char */
    add.b d3,d0
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL:         move.b  d0,0(a6,a0.l)   put char in string */
    move.b d0,0(a6,a0.l)
/* QL:         dbra    d2,con_dig */
    dbra d2,con_dig
/* QL: * Check if exponent is required */
/* QL:         move.l  a0,d2           copy buffer pointer for leading char move */
    move.l a0,d2
/* QL:         addq.l  #ndigs,a0       move a0 to last char of string */
    addq.l #ndigs,a0
/* QL:         moveq   #1,d0           no exponent required? (also d0.msw=0) */
    moveq #1,d0
/* QL:         cmp.w   #ndigs,d4       is exponent too small or large? */
    cmp.w #ndigs,d4
/* QL:         bcs.s   dp_end          0..ndigs-1 then we're in business */
    bcs.s dp_end
/* QL:         move.w  d4,d0           exponent required, dp after after 1st digit */
    move.w d4,d0
/* QL:         moveq   #0,d4           just move the first character */
    moveq #0,d4
/* QL: dp_loop */
dp_loop:
/* QL:         move.b  0(a6,d2.l),-1(a6,d2.l) move leading characters down */
    move.b 0(a6,d2.l),(-1)(a6,d2.l)
/* QL:         addq.l  #1,d2 */
    addq.l #1,d2
/* QL: dp_end */
dp_end:
/* QL:         dbra    d4,dp_loop */
    dbra d4,dp_loop
/* QL:         moveq   #'.',d1         dp */
    moveq #46,d1
/* QL:         move.b  d1,-1(a6,d2.l)  put dp into string */
    move.b d1,(-1)(a6,d2.l)
/* QL: zer_loop */
zer_loop:
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL:         cmp.b   0(a6,a0.l),d3   is trailing digit a zero? */
    cmp.b 0(a6,a0.l),d3
/* QL:         beq.s   zer_loop        ... yes check next */
    beq.s zer_loop
/* QL:         cmp.b   0(a6,a0.l),d1   is last char now the dp */
    cmp.b 0(a6,a0.l),d1
/* QL:         beq.s   put_exp         yes - ignore it */
    beq.s put_exp
/* QL:         addq.l  #1,a0           no  - include it */
    addq.l #1,a0
/* QL: put_exp */
put_exp:
/* QL:         subq.w  #1,d0           was exponent required */
    subq.w #1,d0
/* QL:         beq.s   exit            ... no (now d0.l=0) */
    beq.s exit
/* QL:         move.b  #'e',0(a6,a0.l) ... yes put in e */
    move.b #(101&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL: zero */
zero:
/* QL:         jsr     cn_0tod(pc)     convert to string */
    jsr cn_0tod(pc)
/* QL: exit */
exit:
/* QL:         addq.l  #6,a1           remove fp from stack */
    addq.l #6,a1
/* QL:         move.w  a0,d1           get end pointer (we have d1.msw=0 here) */
    move.w a0,d1
/* QL:         sub.w   (sp)+,d1        take away start to give length of string */
    sub.w (sp)+,d1
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d2-d4
/* QL:         rts */
    rts 
/* QL:         end */
