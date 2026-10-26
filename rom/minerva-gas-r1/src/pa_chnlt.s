/* Generated from original/M/pa/chnlt.asm */
/* QL: * Check name letters */
/* QL:         xdef    pa_alfnm,pa_chnlt */
.globl pa_alfnm,pa_chnlt
/* QL:         section pa_chnlt */
.section pa_chnlt,"ax"
/* QL: * a0 -i o- buffer pointer (unchanged if ret+0 or moved past valid name ret+2) */
/* QL: * d1-d2 destroyed */
/* QL: pa_chnlt */
pa_chnlt:
/* QL:         bsr.s   pa_alfnm */
    bsr.s pa_alfnm
/* QL:         bcc.s   cdunrec         first char must be a letter */
    bcc.s cdunrec
/* QL: nxchr */
nxchr:
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         bsr.s   pa_alfnm        is next alphanumeric? */
    bsr.s pa_alfnm
/* QL:         bls.s   nxchr           yes - keep going */
    bls.s nxchr
/* QL:         sub.b   #'$',d1 */
    sub.b #(36&255),d1
/* QL:         lsr.b   #1,d1           note: '$'+1='%' */
    lsr.b #1,d1
/* QL:         bne.s   end_nam */
    bne.s end_nam
/* QL:         addq.l  #1,a0           move past a final '$' or '%' */
    addq.l #1,a0
/* QL: end_nam */
end_nam:
/* QL:         addq.l  #2,(sp) */
    addq.l #2,(sp)
/* QL: cdunrec */
cdunrec:
/* QL:         rts */
    rts 
/* QL: * Fetch a character and establish its alphanumeric type. */
/* QL: * d1 -  o- character fetched */
/* QL: * d2 -  o- lsw char type, 0=numeric 1=uppercase 2=other 3=lowercase. msw junk */
/* QL: * a0 -ip - pointer, relative to a6, for character under test */
/* QL: * Flags: */
/* QL: *       z       0     beq for numeric */
/* QL: *       c       1/3   bcs for alpha */
/* QL: *       zvc     0/1/3 bls for alphanumeric */
/* QL: pa_alfnm */
pa_alfnm:
/* QL:         moveq   #0,d1           default is zero */
    moveq #0,d1
/* QL:         move.b  0(a6,a0.l),d1   look at initial char */
    move.b 0(a6,a0.l),d1
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         ror.l   #2,d2           d2.w has char/4 - top has bottom bits */
    ror.l #2,d2
/* QL:         move.b  chtypes(pc,d2.w),d2 gives bits for 4 chars */
    move.b chtypes(pc,d2.w),d2
/* QL:         swap    d2              byte from type-table in d2 top word */
    swap d2
/* QL:         rol.w   #3,d2           get 2 bottom bits into d2.w bits 1,2 */
    rol.w #3,d2
/* QL:         lsr.l   d2,d2           shift (upper word) right 2n bits */
    lsr.l d2,d2
/* QL:         clr.w   d2              clear lsw */
    clr.w d2
/* QL:         ror.l   #2,d2           bits 15-14 get char value */
    ror.l #2,d2
/* QL:         rol.w   #2,d2           bits 1-0 of d2 have char type */
    rol.w #2,d2
/* QL:         rts */
    rts 
/* QL: * the table of char types yields the folowing: */
/* QL: *       00 - digits '0' to '9' */
/* QL: *       01 - uppercase 'A' to 'Z', '_' and chars 160-171. */
/* QL: *       11 - lowercase 'a' to 'z' and chars 128-156. */
/* QL: *       10 - non-alphanumeric, i.e. all other characters */
/* QL: * The lowest character code is in the least significant bits of each byte */
/* QL: nnnn equ %00000000 */
.equ nnnn,0b00000000
/* QL: uuuu equ %01010101 */
.equ uuuu,0b01010101
/* QL: xuuu equ %01010110 */
.equ xuuu,0b01010110
/* QL: xxxu equ %01101010 */
.equ xxxu,0b01101010
/* QL: uuux equ %10010101 */
.equ uuux,0b10010101
/* QL: nnxx equ %10100000 */
.equ nnxx,0b10100000
/* QL: xxxx equ %10101010 */
.equ xxxx,0b10101010
/* QL: lxxx equ %10101011 */
.equ lxxx,0b10101011
/* QL: lllx equ %10111111 */
.equ lllx,0b10111111
/* QL: xlll equ %11111110 */
.equ xlll,0b11111110
/* QL: llll equ %11111111 */
.equ llll,0b11111111
/* QL: chtypes */
chtypes:
/* QL:  dc.b xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx 0-31 */
dc_anchor_102:
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
/* QL:  dc.b xxxx,xxxx,xxxx,xxxx,nnnn,nnnn,nnxx,xxxx space to '?' */
dc_anchor_112:
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (nnnn)&255
.byte (nnnn)&255
.byte (nnxx)&255
.byte (xxxx)&255
/* QL:  dc.b xuuu,uuuu,uuuu,uuuu,uuuu,uuuu,uuux,xxxu '@' to '_' */
dc_anchor_122:
.byte (xuuu)&255
.byte (uuuu)&255
.byte (uuuu)&255
.byte (uuuu)&255
.byte (uuuu)&255
.byte (uuuu)&255
.byte (uuux)&255
.byte (xxxu)&255
/* QL:  dc.b xlll,llll,llll,llll,llll,llll,lllx,xxxx '`' to del */
dc_anchor_132:
.byte (xlll)&255
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (lllx)&255
.byte (xxxx)&255
/* QL:  dc.b llll,llll,llll,llll,llll,llll,llll,lxxx 128-159 */
dc_anchor_142:
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (llll)&255
.byte (lxxx)&255
/* QL:  dc.b uuuu,uuuu,uuuu,xxxx,xxxx,xxxx,xxxx,xxxx 160-191 */
dc_anchor_152:
.byte (uuuu)&255
.byte (uuuu)&255
.byte (uuuu)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
/* QL:  dc.b xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx 192-223 */
dc_anchor_162:
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
/* QL:  dc.b xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx 224-255 */
dc_anchor_172:
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
.byte (xxxx)&255
/* QL:         end */
