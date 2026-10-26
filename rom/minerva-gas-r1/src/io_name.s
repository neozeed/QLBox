/* Generated from original/M/io/name.asm */
/* QL: * Parses a device name in standard format */
/* QL:         xdef   io_name */
.globl io_name
/* QL:         xref   cn_dtoi */
/* QL:         include 'win1_m_inc_err' */
/* QL: * error keys */
/* QL:         nolist */
/* QL: err.nc  equ     -1      not complete */
.equ err.nc,(-1)
/* QL: err.nj  equ     -2      invalid Job */
.equ err.nj,(-2)
/* QL: err.om  equ     -3      out of memory */
.equ err.om,(-3)
/* QL: err.or  equ     -4      out of range */
.equ err.or,(-4)
/* QL: err.bo  equ     -5      buffer full */
.equ err.bo,(-5)
/* QL: err.no  equ     -6      channel not open */
.equ err.no,(-6)
/* QL: err.nf  equ     -7      not found */
.equ err.nf,(-7)
/* QL: err.ex  equ     -8      already exists */
.equ err.ex,(-8)
/* QL: err.iu  equ     -9      in use */
.equ err.iu,(-9)
/* QL: err.ef  equ     -10     end of file */
.equ err.ef,(-10)
/* QL: err.df  equ     -11     drive full */
.equ err.df,(-11)
/* QL: err.bn  equ     -12     bad name */
.equ err.bn,(-12)
/* QL: err.te  equ     -13     Xmit error */
.equ err.te,(-13)
/* QL: err.ff  equ     -14     format failed */
.equ err.ff,(-14)
/* QL: err.bp  equ     -15     bad parameter */
.equ err.bp,(-15)
/* QL: err.fe  equ     -16     bad or changed medium */
.equ err.fe,(-16)
/* QL: err.xp  equ     -17     error in expression */
.equ err.xp,(-17)
/* QL: err.ov  equ     -18     overflow */
.equ err.ov,(-18)
/* QL: err.ni  equ     -19     not implemented yet */
.equ err.ni,(-19)
/* QL: err.ro  equ     -20     read only */
.equ err.ro,(-20)
/* QL: err.bl  equ     -21     bad line */
.equ err.bl,(-21)
/* QL: err.at  equ     -22     At line (+ space, no LF) */
.equ err.at,(-22)
/* QL: err.sc  equ     -23      sectors */
.equ err.sc,(-23)
/* QL: err.bt  equ     -24     <boot message> */
.equ err.bt,(-24)
/* QL: err.cp  equ     -25     <copyright message> */
.equ err.cp,(-25)
/* QL: err.wh  equ     -26     during WHEN processing */
.equ err.wh,(-26)
/* QL: err.pf  equ     -27     PROC/FN cleared */
.equ err.pf,(-27)
/* QL:         list */
/* QL:         section io_name */
.section io_name,"ax"
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - pointer to name, prefixed with word character count */
/* QL: * a3 -ip - pointer to result parameter block */
/* QL: * d1-d3/a1-a2 destroyed (in fact, d3 is preserved, but documentation says not!) */
/* QL: reglist reg d4/d7/a0/a3-a4 */
/* QL: io_name */
io_name:
/* QL:         move.l  (sp)+,a2        basic return address taken off stack */
    move.l (sp)+,a2
/* QL:         movem.l reglist,-(sp)   save useful registers */
    movem.l d4/d7/a0/a3-a4,-(sp)
/* QL:         lea     6(a2),a4        find start of description */
    lea 6(a2),a4
/* QL:         moveq   #0,d7           set up end of string address */
    moveq #0,d7
/* QL:         move.w  (a0)+,d7        fetch string length */
    move.w (a0)+,d7
/* QL:         add.l   a0,d7           add start address of string */
    add.l a0,d7
/* QL:         move.w  (a4)+,d2        find number of characters in name */
    move.w (a4)+,d2
/* QL:         moveq   #1,d4 */
    moveq #1,d4
/* QL:         and.b   d2,d4           remember if length is odd */
    and.b d2,d4
/* QL:         moveq   #err.nf,d0      ready for name not recognised */
    moveq #err.nf,d0
/* QL: name_lp */
name_lp:
/* QL:         bsr.s   fetch           get next character */
    bsr.s fetch
/* QL:         cmp.b   (a4)+,d1        how about it */
    cmp.b (a4)+,d1
/* QL:         bne.s   exit */
    bne.s exit
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL:         bne.s   name_lp */
    bne.s name_lp
/* QL:         add.w   d4,a4           round up to get word boundry */
    add.w d4,a4
/* QL:         move.w  (a4)+,d4        set up number of options */
    move.w (a4)+,d4
/* QL:         bra.s   end_opt */
    bra.s end_opt
/* QL: chk_opt */
chk_opt:
/* QL:         move.b  (a4)+,d1        check next option type */
    move.b (a4)+,d1
/* QL:         beq.s   char_lst */
    beq.s char_lst
/* QL:         blt.s   no_sep */
    blt.s no_sep
/* QL: sep */
sep:
/* QL:         bsr.s   fetch           fetch next character */
    bsr.s fetch
/* QL:         cmp.b   (a4)+,d1        is the right separator? */
    cmp.b (a4)+,d1
/* QL:         beq.s   read_val */
    beq.s read_val
/* QL:         subq.l  #1,a0           reset name pointer */
    subq.l #1,a0
/* QL:         move.w  (a4)+,(a3)+     put default on */
    move.w (a4)+,(a3)+
/* QL:         bra.s   end_opt */
    bra.s end_opt
/* QL: no_sep */
no_sep:
/* QL:         addq.l  #1,a4           move definition pointer on */
    addq.l #1,a4
/* QL: read_val */
read_val:
/* QL:         move.w  (a4)+,(a3)+     put default in result */
    move.w (a4)+,(a3)+
/* QL:         move.l  a6,-(sp)        save base register */
    move.l a6,-(sp)
/* QL:         sub.l   a6,a6           dtoi is double register addressed */
    sub.l a6,a6
/* QL:         move.l  a3,a1           succesful dtoi will overwrite default */
    move.l a3,a1
/* QL:         jsr     cn_dtoi(pc)     fetch integer */
    jsr cn_dtoi(pc)
/* QL:         move.l  (sp)+,a6 */
    move.l (sp)+,a6
/* QL:         bra.s   end_opt */
    bra.s end_opt
/* QL: char_lst */
char_lst:
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.b  (a4)+,d2        fetch number of possible characters */
    move.b (a4)+,d2
/* QL:         add.w   d2,a4           goto end of list */
    add.w d2,a4
/* QL:         move.l  a4,-(sp)        save it! */
    move.l a4,-(sp)
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         and.b   d2,d1 */
    and.b d2,d1
/* QL:         add.l   d1,(sp)         round saved pointer up to even */
    add.l d1,(sp)
/* QL:         bsr.s   fetch           get character */
    bsr.s fetch
/* QL: char_lop */
char_lop:
/* QL:         cmp.b   -(a4),d1        check this character */
    cmp.b -(a4),d1
/* QL:         beq.s   char_fnd */
    beq.s char_fnd
/* QL:         sub.w   #1,d2           decrement counter (character number) */
    sub.w #1,d2
/* QL:         bne.s   char_lop */
    bne.s char_lop
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL: char_fnd */
char_fnd:
/* QL:         move.w  d2,(a3)+        put character value in result */
    move.w d2,(a3)+
/* QL:         move.l  (sp)+,a4        point to next bit of definition */
    move.l (sp)+,a4
/* QL: end_opt */
end_opt:
/* QL:         dbra    d4,chk_opt      look at next option */
    dbra d4,chk_opt
/* QL:         addq.l  #2,a2           move return address by two */
    addq.l #2,a2
/* QL:         moveq   #err.bn,d0      bad parameter(s) */
    moveq #err.bn,d0
/* QL:         cmp.l   a0,d7           should now be pointing at end */
    cmp.l a0,d7
/* QL:         bne.s   exit */
    bne.s exit
/* QL:         addq.l  #2,a2           move return address by a further two */
    addq.l #2,a2
/* QL:         moveq   #0,d0           wow! all ok */
    moveq #0,d0
/* QL: exit */
exit:
/* QL:         movem.l (sp)+,reglist   restore all registers */
    movem.l (sp)+,d4/d7/a0/a3-a4
/* QL:         jmp     (a2) */
    jmp (a2)
/* QL: fetch */
fetch:
/* QL:         cmp.l   d7,a0           check if off end of buffer */
    cmp.l d7,a0
/* QL:         scs     d1              set $ff if still in buffer, 0 otherwise */
    scs d1
/* QL:         and.b   (a0)+,d1        fetch next character (0 iff off buffer) */
    and.b (a0)+,d1
/* QL:         cmp.b   #'_'+1,d1       is it outside TTY set */
    cmp.b #((95+1)&255),d1
/* QL:         blt.s   rts0            .. no */
    blt.s rts0
/* QL:         sub.b   #' ',d1 */
    sub.b #(32&255),d1
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL:         end */
