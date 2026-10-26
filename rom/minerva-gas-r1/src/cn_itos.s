/* Generated from original/M/cn/itos.asm */
/* QL: * Converts integers to strings */
/* QL:         xdef    cn_itod,cn_itobb,cn_itobw,cn_itobl,cn_itohb,cn_itohw,cn_itohl */
.globl cn_itod,cn_itobb,cn_itobw,cn_itobl,cn_itohb,cn_itohw,cn_itohl
/* QL:         xdef    cn_0tod */
.globl cn_0tod
/* QL:         section cn_itos */
.section cn_itos,"ax"
/* QL: * Decimal conversion */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- length of output number string */
/* QL: * a0 -i o- beginning of string in bottom-up buffer, output at end of number */
/* QL: * a1 -i o- top of arithmetic stack, output with number removed */
/* QL: cn_itod */
cn_itod:
/* QL:         move.w  0(a6,a1.l),d0   fetch number */
    move.w 0(a6,a1.l),d0
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL: * d0 -i o- lsw = signed value to be printed, return 0 */
/* QL: * d1 -  o- length of output number string */
/* QL: * a0 -i o- beginning of string in bottom-up buffer, output at end of number */
/* QL: cn_0tod */
cn_0tod:
/* QL:         move.w  a0,-(sp)        save start of buffer (only need lsw) */
    move.w a0,-(sp)
/* QL:         ext.l   d0 */
    ext.l d0
/* QL:         bpl.s   d_ok            is it negative */
    bpl.s d_ok
/* QL:         move.b  #'-',0(a6,a0.l) yes - put in minus sign */
    move.b #(45&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         neg.l   d0              make number unsigned absolute value */
    neg.l d0
/* QL: d_ok */
d_ok:
/* QL:         moveq   #1,d1           set flag for last of digits */
    moveq #1,d1
/* QL: d_loop */
d_loop:
/* QL:         divu    #10,d0          form remainder=lsdigit and quotient=msdigits */
    divu #10,d0
/* QL:         swap    d0              bring down digit */
    swap d0
/* QL:         ror.l   #1,d1           roll down flag */
    ror.l #1,d1
/* QL:         move.b  d0,d1           keep digit */
    move.b d0,d1
/* QL:         ror.l   #4,d1           roll down digit */
    ror.l #4,d1
/* QL:         clr.w   d0              discard digit */
    clr.w d0
/* QL:         swap    d0              bring down remainder */
    swap d0
/* QL:         bne.s   d_loop          loop until no more significant digits left */
    bne.s d_loop
/* QL: * We have now got at most five digits and flags tucked away in d1.l, making a */
/* QL: * total of 25 bits. The remaining seven bits are zero. Note d0.l is now zero. */
/* QL: d_put */
d_put:
/* QL:         addq.b  #'0'>>4,d1      make digit ascii */
    addq.b #(48>>4),d1
/* QL:         rol.l   #4,d1           roll back lsb's of next digit */
    rol.l #4,d1
/* QL:         move.b  d1,0(a6,a0.l)   put it in output */
    move.b d1,0(a6,a0.l)
/* QL:         addq.l  #1,a0           step on */
    addq.l #1,a0
/* QL:         sf      d1              clear that digit */
    sf d1
/* QL:         add.l   d1,d1           are there any more digits? */
    add.l d1,d1
/* QL:         bcc.s   d_put           until we hit the set flag bit, carry on */
    bcc.s d_put
/* QL:         move.w  a0,d1           end of string (d1.msw is zero) */
    move.w a0,d1
/* QL:         sub.w   (sp)+,d1        less start = length */
    sub.w (sp)+,d1
/* QL:         rts */
    rts 
/* QL: * Hex and binary conversions */
/* QL: * a0 -i o- beginning of string in bottom-up buffer, output at end of number */
/* QL: * a1 -i o- top of arithmetic stack, output with number removed */
/* QL: * d0 destroyed */
/* QL: cn_itohl */
cn_itohl:
/* QL:         pea     cn_itohw        for long do two words */
    pea cn_itohw(pc)
/* QL: cn_itohw */
cn_itohw:
/* QL:         pea     cn_itohb        for word do two bytes */
    pea cn_itohb(pc)
/* QL: cn_itohb */
cn_itohb:
/* QL:         move.b  0(a6,a1.l),d0   get first four bits */
    move.b 0(a6,a1.l),d0
/* QL:         lsr.b   #4,d0 */
    lsr.b #4,d0
/* QL:         bsr.s   put_hex         put character in buffer */
    bsr.s put_hex
/* QL:         moveq   #15,d0          get next four bits */
    moveq #15,d0
/* QL:         and.b   0(a6,a1.l),d0 */
    and.b 0(a6,a1.l),d0
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL: put_hex */
put_hex:
/* QL:         add.b   #'0',d0         convert to ascii digit */
    add.b #(48&255),d0
/* QL:         cmp.b   #'9',d0         is it greater than 9 */
    cmp.b #(57&255),d0
/* QL:         bls.s   put_hex1 */
    bls.s put_hex1
/* QL:         addq.b  #'A'-10-'0',d0  convert to letter a-f */
.word 20480|(((((65-10)-48))&7)<<9)
/* QL: put_hex1 */
put_hex1:
/* QL:         move.b  d0,0(a6,a0.l)   set digit */
    move.b d0,0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         rts */
    rts 
/* QL: cn_itobl */
cn_itobl:
/* QL:         pea     cn_itobw        for long do 2 words */
    pea cn_itobw(pc)
/* QL: cn_itobw */
cn_itobw:
/* QL:         pea     cn_itobb        for word do 2 bytes */
    pea cn_itobb(pc)
/* QL: cn_itobb */
cn_itobb:
/* QL:         moveq   #7,d0           for 8 bits */
    moveq #7,d0
/* QL: bit_loop */
bit_loop:
/* QL:         btst    d0,0(a6,a1.l)   test bit */
    btst d0,0(a6,a1.l)
/* QL:         seq     0(a6,a0.l)      set result to -1 for '0', 0 for '1' */
    seq 0(a6,a0.l)
/* QL:         add.b   #'1',0(a6,a0.l) form digit */
    add.b #(49&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         dbra    d0,bit_loop */
    dbra d0,bit_loop
/* QL:         addq.l  #1,a1           move stack pointer on */
    addq.l #1,a1
/* QL:         rts */
    rts 
/* QL:         end */
