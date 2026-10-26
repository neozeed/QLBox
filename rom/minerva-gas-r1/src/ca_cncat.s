/* Generated from original/M/ca/cncat.asm */
/* QL: * Concatenate strings at (a6,a1.l): b$, a$ -> a$&b$ */
/* QL:         xdef    ca_cncat */
.globl ca_cncat
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
/* QL:         include 'win1_m_inc_mt' */
/* QL: * manager trap #1 codes */
/* QL:         nolist */
/* QL: mt.inf  equ     $00     get system information */
.equ mt.inf,0x00
/* QL: mt.cjob equ     $01     create a job */
.equ mt.cjob,0x01
/* QL: mt.jinf equ     $02     get information on job */
.equ mt.jinf,0x02
/* QL: mt.extop equ    $03     convert called routine to supervisor, rte at end */
.equ mt.extop,0x03
/* QL: mt.rjob equ     $04     remove a job */
.equ mt.rjob,0x04
/* QL: mt.frjob equ    $05     force remove a job */
.equ mt.frjob,0x05
/* QL: mt.free equ     $06     find out how much free space there is */
.equ mt.free,0x06
/* QL: mt.trapv equ    $07     set pointer to trap redirection vectors */
.equ mt.trapv,0x07
/* QL: mt.susjb equ    $08     suspend a job */
.equ mt.susjb,0x08
/* QL: mt.reljb equ    $09     release a job */
.equ mt.reljb,0x09
/* QL: mt.activ equ    $0a     activate a job */
.equ mt.activ,0x0a
/* QL: mt.prior equ    $0b     set a job priority */
.equ mt.prior,0x0b
/* QL: mt.alloc equ    $0c     allocate a bit of a heap */
.equ mt.alloc,0x0c
/* QL: mt.lnkfr equ    $0d     release a bit of a heap */
.equ mt.lnkfr,0x0d
/* QL: mt.alres equ    $0e     allocate resident procedure area */
.equ mt.alres,0x0e
/* QL: mt.reres equ    $0f     release resident procedure area */
.equ mt.reres,0x0f
/* QL: mt.dmode equ    $10     set display mode */
.equ mt.dmode,0x10
/* QL: mt.ipcom equ    $11     send IPC command */
.equ mt.ipcom,0x11
/* QL: mt.baud equ     $12     set baud rate */
.equ mt.baud,0x12
/* QL: mt.rclck equ    $13     read clock */
.equ mt.rclck,0x13
/* QL: mt.sclck equ    $14     set clock */
.equ mt.sclck,0x14
/* QL: mt.aclck equ    $15     adjust clock */
.equ mt.aclck,0x15
/* QL: mt.albas equ    $16     allocate basic area */
.equ mt.albas,0x16
/* QL: mt.rebas equ    $17     release basic area */
.equ mt.rebas,0x17
/* QL: mt.alchp equ    $18     allocate space in common heap */
.equ mt.alchp,0x18
/* QL: mt.rechp equ    $19     release space in common heap */
.equ mt.rechp,0x19
/* QL: mt.lxint equ    $1a     link in external interrupt handler */
.equ mt.lxint,0x1a
/* QL: mt.rxint equ    $1b     remove external interrupt handler */
.equ mt.rxint,0x1b
/* QL: mt.lpoll equ    $1c     link in polled task */
.equ mt.lpoll,0x1c
/* QL: mt.rpoll equ    $1d     remove polled task */
.equ mt.rpoll,0x1d
/* QL: mt.lschd equ    $1e     link in scheduler task */
.equ mt.lschd,0x1e
/* QL: mt.rschd equ    $1f     remove scheduler task */
.equ mt.rschd,0x1f
/* QL: mt.liod equ     $20     link in I/O driver */
.equ mt.liod,0x20
/* QL: mt.riod equ     $21     remove I/O driver */
.equ mt.riod,0x21
/* QL: mt.ldd  equ     $22     link in directory driver */
.equ mt.ldd,0x22
/* QL: mt.rdd  equ     $23     remove directory driver */
.equ mt.rdd,0x23
/* QL: mt.cntry equ    $24     set translate/error tables */
.equ mt.cntry,0x24
/* QL:         list */
/* QL: * d0 -  o- zero if a$&b$ was done OK, err.ov if it was too long, CCR set */
/* QL: * a1 -i o- stack pointer to b$, then a$, returns with a$&b$ or null string */
/* QL: * a6 -ip - base address for a1 */
/* QL: * d1-d3 destroyed */
/* QL: * locally: */
/* QL: * a0 - low address for reversals or source of shuffle */
/* QL: * a3 - high address for reversals or destination of shuffle */
/* QL: * a4 - end of result string */
/* QL: * d0 - byte(s), etc, and completion code */
/* QL: * d1 - .w count of reversal or bit 7 = len(a$&b$)&&1 and bit 0 = len(a$)&&1 */
/* QL: * d2 - string length b$ */
/* QL: * d3 - string length a$, then a$&b$ */
/* QL: * N.B. As there are a lot of lax programers about, this routine now refuses to */
/* QL: * generate results longer than 32764 characters. See below for further info. */
/* QL: * This routine used to check that the string lengths on entry were positive, */
/* QL: * but that caused problems on handling the error return. */
/* QL: * Negative string lengths should never occur, but we now treat them as if they */
/* QL: * were unsigned, and hence just very long strings, and fail at the end when we */
/* QL: * find the generated result is far too long. */
/* QL: * Previously, the string left on the stack had a stupid value left as the */
/* QL: * length, and crashed when an attempt was made to drop it from the stack. */
/* QL: * We now guarantee that what is left behind on overflow is a genuine string */
/* QL: * (actually the null string), as we wish to adhere to the rule that whether an */
/* QL: * arithmetic stack operation succeeds or fails, it always leaves the stack with */
/* QL: * a result of the correct type. */
/* QL: reglist reg     a0/a2-a4 */
/* QL:         section ca_cncat */
.section ca_cncat,"ax"
/* QL: * This routine should be optimised to cater for some of the special cases: */
/* QL: * b$ null just needs a1+=2, if we ignore funny length a$ */
/* QL: * LEN(b$)=1 and a$ odd is fairly simple, but LEN(a$&b$) must have a check */
/* QL: * LEN(a$)+LEN(b$) small could be quicker */
/* QL: ca_cncat */
ca_cncat:
/* QL:         movem.l reglist,-(sp)   save anything we might want to keep */
    movem.l a0/a2-a4,-(sp)
/* QL:         lea     cncat,a2 */
    lea cncat(pc),a2
/* QL:         moveq   #mt.extop,d0 */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         movem.l (sp)+,reglist   restore registers */
    movem.l (sp)+,a0/a2-a4
/* QL:         moveq   #0,d0           assume we're OK */
    moveq #0,d0
/* QL: * The following is a protection against lazy programmers, who use */
/* QL: * "addq.w #3/bclr #0" to round up and get past a string plus its length: */
/* QL:         cmp.l   #32765,d3       might adding 3 make it overflow?  */
    cmp.l #32765,d3
/* QL:         bcs.s   rts0            good, it's not too long (even for cretins) */
    bcs.s rts0
/* QL:         addq.l  #1,d3 */
    addq.l #1,d3
/* QL:         bclr    d0,d3 */
    bclr d0,d3
/* QL:         add.l   d3,a1           drop all chars of the string */
    add.l d3,a1
/* QL:         move.w  d0,0(a6,a1.l)   make result the null string */
    move.w d0,0(a6,a1.l)
/* QL:         moveq   #err.ov,d0      'overflow' error code for too-long string */
    moveq #err.ov,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * supervisor mode code */
/* QL: cncat */
cncat:
/* QL:         add.l   a6,a1 */
    add.l a6,a1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  (a1)+,d2        get length of b$ and set source for b$ chars */
    move.w (a1)+,d2
/* QL:         lea     0(a1,d2.l),a0   end of b$ */
    lea 0(a1,d2.l),a0
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         and.b   d2,d0           get odd-ness of length of b$ */
    and.b d2,d0
/* QL:         add.l   d0,a0           skip any junk byte */
    add.l d0,a0
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.w  (a0)+,d3        get length of a$ and set source for a$ chars */
    move.w (a0)+,d3
/* QL:         lea     0(a0,d3.l),a3   end of a$ */
    lea 0(a0,d3.l),a3
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         and.b   d3,d1           get odd-ness of length of a$ */
    and.b d3,d1
/* QL:         add.l   d1,a3           skip any junk byte */
    add.l d1,a3
/* QL:         cmp.w   d1,d0           was either, but not both, string odd? */
    cmp.w d1,d0
/* QL:         beq.s   xeven           no, then this is the end of a$&b$ */
    beq.s xeven
/* QL:         move.b  -(a3),-1(a0)    if len(a$) was odd, this may need doing */
    move.b -(a3),(-1)(a0)
/* QL:         tas     d1              set bit 7 to remember odd length result */
    tas d1
/* QL: xeven */
xeven:
/* QL:         move.l  a3,a4           keep a copy of end of a$&b$ */
    move.l a3,a4
/* QL: * Now for some strategy... we can do little a$ or b$ strings by just grabbing */
/* QL: * the whole string into a register, shuffling the other string, then tacking */
/* QL: * in the saved string wherever it belongs. In particular, b$='' is real easy! */
/* QL:         moveq   #4,d0 */
    moveq #4,d0
/* QL:         cmp.w   d2,d0           N.B. little b$'s are favorite! */
    cmp.w d2,d0
/* QL:         bcc.s   ashuff          len(b$)<5, a$ words go down, or even stay put! */
    bcc.s ashuff
/* QL:         cmp.w   d3,d0 */
    cmp.w d3,d0
/* QL:         bcc.s   bshuff          len(a$)<5, b$ bytes, or even words, go up */
    bcc.s bshuff
/* QL:         bsr.s   reverse         reverse a$ bytes (plus a junk byte, maybe) */
    bsr.s reverse
/* QL:         sub.l   d3,a3           this is where the join is, and where b$ goes */
    sub.l d3,a3
/* QL:         bsr.s   reva1           reverse b$ bytes (plus some junk) */
    bsr.s reva1
/* QL:         bsr.s   seta1           set final a$&b$ regs */
    bsr.s seta1
/* QL:         pea     setlen          reverse a$&b$ to get it right, then set length */
    pea setlen(pc)
/* QL: reva1 */
reva1:
/* QL:         move.l  a1,a0           source from a1 */
    move.l a1,a0
/* QL: reverse */
reverse:
/* QL:         move.l  a3,d1 */
    move.l a3,d1
/* QL:         sub.l   a0,d1 */
    sub.l a0,d1
/* QL:         lsr.l   #1,d1           swap count, an odd middle byte stays put */
    lsr.l #1,d1
/* QL:         bra.s   revent          enter at the bottom of the loop */
    bra.s revent
/* QL: revlp */
revlp:
/* QL:         move.b  (a0),d0 */
    move.b (a0),d0
/* QL:         move.b  -(a3),(a0)+ */
    move.b -(a3),(a0)+
/* QL:         move.b  d0,(a3) */
    move.b d0,(a3)
/* QL: revent */
revent:
/* QL:         dbra    d1,revlp */
    dbra d1,revlp
/* QL:         move.l  a4,a3           needed two out of three times */
    move.l a4,a3
/* QL:         rts */
    rts 
/* QL: shuff */
shuff:
/* QL:         move.l  (a1),d0         grab the whole of the short string */
    move.l (a1),d0
/* QL: seta1 */
seta1:
/* QL:         add.l   d2,d3 */
    add.l d2,d3
/* QL:         sub.l   d3,a4 */
    sub.l d3,a4
/* QL:         move.l  a4,a1           this will be the final string pointer */
    move.l a4,a1
/* QL:         rts */
    rts 
/* QL: ashuff */
ashuff:
/* QL:         exg     d2,d3           we make d2 = len(a$) */
    exg d2,d3
/* QL:         bsr.s   shuff           set it up */
    bsr.s shuff
/* QL:         cmp.l   a0,a4           hmm... b$='' or len(b$)=1 and len(a$) odd? */
    cmp.l a0,a4
/* QL:         bne.s   apity           no, then we must do a proper shuffle. */
    bne.s apity
/* QL:         add.l   d2,a4           a$ isn't moving, so skip right past it */
    add.l d2,a4
/* QL:         bra.s   shent           go to copy in the possible single b$ byte */
    bra.s shent
/* QL: apity */
apity:
/* QL:         lsr.w   #2,d2           full longwords in a$ */
    lsr.w #2,d2
/* QL:         bcc.s   awent           no odd word to do */
    bcc.s awent
/* QL:         move.w  (a0)+,(a4)+     move the odd single word */
    move.w (a0)+,(a4)+
/* QL:         bra.s   awent           enter word copy loop */
    bra.s awent
/* QL: adown */
adown:
/* QL:         move.l  (a0)+,(a4)+     copy a$ down in longwords */
    move.l (a0)+,(a4)+
/* QL: awent */
awent:
/* QL:         dbra    d2,adown */
    dbra d2,adown
/* QL:         asr.b   #1,d1           did a$ have an odd byte? */
    asr.b #1,d1
/* QL:         bcc.s   short */
    bcc.s short
/* QL:         move.b  (a0)+,(a4)+     yes - we move it now */
    move.b (a0)+,(a4)+
/* QL: * As we know len(b$) was not zero, it's ok to drop straight in here */
/* QL: short */
short:
/* QL:         rol.l   #8,d0 */
    rol.l #8,d0
/* QL:         move.b  d0,(a4)+        move a small string byte into the result */
    move.b d0,(a4)+
/* QL: shent */
shent:
/* QL:         cmp.l   a3,a4 */
    cmp.l a3,a4
/* QL:         bcs.s   short           carry on to the end of the small string */
    bcs.s short
/* QL: setlen */
setlen:
/* QL:         move.w  d3,-(a1)        this is the final length, and a1 is ok! */
    move.w d3,-(a1)
/* QL:         sub.l   a6,a1           set a1 to be an offset again */
    sub.l a6,a1
/* QL:         rte */
    rte 
/* QL: bshuff */
bshuff:
/* QL:         exg     a1,a0           a$ is the short string */
    exg a0,a1
/* QL:         add.l   d2,a0           end of b$ is our source */
    add.l d2,a0
/* QL:         bsr.s   shuff           set it all up */
    bsr.s shuff
/* QL:         tst.b   d1              was len(a$&b$) odd? */
    tst.b d1
/* QL:         bpl.s   bword           no - don't need to do odd byte */
    bpl.s bword
/* QL:         move.b  -(a0),-(a3) */
    move.b -(a0),-(a3)
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL: bword */
bword:
/* QL:         asr.b   #1,d1           was len(a$) odd? */
    asr.b #1,d1
/* QL:         bcs.s   bbent           yes, that's tough, have to do all byte shuffle */
    bcs.s bbent
/* QL:         lsr.w   #2,d2           we know this is now even (figure it out!) */
    lsr.w #2,d2
/* QL:         bcc.s   bwent           no carry, do longwords! */
    bcc.s bwent
/* QL:         move.w  -(a0),-(a3)     copy the odd word */
    move.w -(a0),-(a3)
/* QL:         bra.s   bwent           enter loop at bottom */
    bra.s bwent
/* QL: bbloop */
bbloop:
/* QL:         move.b  -(a0),-(a3)     copy b$ bytes */
    move.b -(a0),-(a3)
/* QL: bbent */
bbent:
/* QL:         dbra    d2,bbloop */
    dbra d2,bbloop
/* QL:         bra.s   short           len(a$) odd implies at least one byte! */
    bra.s short
/* QL: bwloop */
bwloop:
/* QL:         move.l  -(a0),-(a3)     copy b$ longwords */
    move.l -(a0),-(a3)
/* QL: bwent */
bwent:
/* QL:         dbra    d2,bwloop */
    dbra d2,bwloop
/* QL:         bra.s   shent           len(a$) could have been zero */
    bra.s shent
/* QL:         end */
