/* Generated from original/M/cs/char.asm */
/* QL: * Write a character to screen */
/* QL:         xdef    cs_char */
.globl cs_char
/* QL:         include 'win1_m_inc_sd' */
/* QL: * window data block definition */
/* QL:         nolist */
/* QL:         offset  $18 (end of basic channel definition) */
/* QL: sd_xmin ds.w    1       window left pixel, exclusive of border */
.equ sd_xmin,24
/* QL: sd_ymin ds.w    1       ditto top pixel */
.equ sd_ymin,26
/* QL: sd_xsize ds.w   1       window width, exclusive of border */
.equ sd_xsize,28
/* QL: sd_ysize ds.w   1       ditto height */
.equ sd_ysize,30
/* QL: sd_borwd ds.w   1       border height, border width is double this */
.equ sd_borwd,32
/* QL: sd_xpos ds.w    1       cursor position relative to left pixel above */
.equ sd_xpos,34
/* QL: sd_ypos ds.w    1       ditto top pixel */
.equ sd_ypos,36
/* QL: sd_xinc ds.w    1       cursor pixel width */
.equ sd_xinc,38
/* QL: sd_yinc ds.w    1       cursor pixel height */
.equ sd_yinc,40
/* QL: * note: the x values above should be even when in mode 8. */
/* QL: sd_font ds.l    2       font addresses, primary first. def char in secondary */
.equ sd_font,42
/* QL: sd_scrb ds.l    1       base address of screen */
.equ sd_scrb,50
/* QL: sd_pmask ds.l   1       paper colour mask */
.equ sd_pmask,54
/* QL: sd_smask ds.l   1       strip colour mask */
.equ sd_smask,58
/* QL: sd_imask ds.l   1       ink colour mask */
.equ sd_imask,62
/* QL: sd_cattr ds.b   1       character attributes (see below for bits) */
.equ sd_cattr,66
/* QL: sd_curf ds.b    1       cursor flag (0 suppressed, >0 visible, <0 invisible) */
.equ sd_curf,67
/* QL: sd_pcolr ds.b   1       paper colour byte */
.equ sd_pcolr,68
/* QL: sd_scolr ds.b   1       strip colour byte */
.equ sd_scolr,69
/* QL: sd_icolr ds.b   1       ink colour byte */
.equ sd_icolr,70
/* QL: sd_bcolr ds.b   1       border colour byte */
.equ sd_bcolr,71
/* QL: sd_nlsta ds.b   1       new line status (0 none, >0 implicit, <0 explicit) */
.equ sd_nlsta,72
/* QL: sd_fmod ds.b    1       fill mode (0 off, 1 on) */
.equ sd_fmod,73
/* QL: sd_yorg ds.w    3       graphics window origin (added to y coords) (float) */
.equ sd_yorg,74
/* QL: sd_xorg ds.w    3       ditto for x */
.equ sd_xorg,80
/* QL: sd_scal ds.w    3       graphics scale factor (from bottom row to top row) */
.equ sd_scal,86
/* QL: sd_fbuf ds.l    1       pointer to alchp'ed fill buffer, 0 if none */
.equ sd_fbuf,92
/* QL: sd_fuse ds.l    1       pointer to user defined fill vectors, not used */
.equ sd_fuse,96
/* QL: sd_linel ds.w   1       line length in bytes */
.equ sd_linel,100
/* QL: sd_flags ds.b   1       cleared by 1st time entry to driver (edlin needs this) */
.equ sd_flags,102
/* QL:         ds.b    1       spare */
/* QL: sd_end */
.equ sd_end,104
/* QL: * character attribute flag bits for sd_cattr */
/* QL: sd..ulin equ    0       underline (row 9, or the lowest row, is all ink) */
.equ sd..ulin,0
/* QL: sd..flsh equ    1       flash (ignored in mode 4) */
.equ sd..flsh,1
/* QL: sd..trns equ    2       transparent background (only character area is touched) */
.equ sd..trns,2
/* QL: sd..xor equ     3       xor characters/graphics (char/pixel colour xor'ed in) */
.equ sd..xor,3
/* QL: sd..dbht equ    4       double height (chars spread in y) */
.equ sd..dbht,4
/* QL: sd..exwd equ    5       extended width (8 bits used from char font entries) */
.equ sd..exwd,5
/* QL: sd..dbwd equ    6       double width (chars spread in x, mode 8 sets this) */
.equ sd..dbwd,6
/* QL: sd..gchr equ    7       graphics positioned chars (offscreen ignored until nl) */
.equ sd..gchr,7
/* QL: * screen entry parameter definition */
/* QL: sd.extop equ    $09     external operation (a2) */
.equ sd.extop,0x09
/* QL: sd.pxenq equ    $0a     pixel based size / position enquiry */
.equ sd.pxenq,0x0a
/* QL: sd.chenq equ    $0b     character based size / position enquiry */
.equ sd.chenq,0x0b
/* QL: sd.bordr equ    $0c     define window border */
.equ sd.bordr,0x0c
/* QL: sd.wdef equ     $0d     define window */
.equ sd.wdef,0x0d
/* QL: sd.cure equ     $0e     enable cursor */
.equ sd.cure,0x0e
/* QL: sd.curs equ     $0f     suppress cursor */
.equ sd.curs,0x0f
/* QL: sd.pos  equ     $10     absolute position */
.equ sd.pos,0x10
/* QL: sd.tab  equ     $11     tab (horizontal position) */
.equ sd.tab,0x11
/* QL: sd.nl   equ     $12     newline */
.equ sd.nl,0x12
/* QL: sd.pcol equ     $13     previous column */
.equ sd.pcol,0x13
/* QL: sd.ncol equ     $14     next column */
.equ sd.ncol,0x14
/* QL: sd.prow equ     $15     previous row */
.equ sd.prow,0x15
/* QL: sd.nrow equ     $16     next row */
.equ sd.nrow,0x16
/* QL: sd.pixp equ     $17     set pixel position */
.equ sd.pixp,0x17
/* QL: sd.scrol equ    $18     scroll whole window */
.equ sd.scrol,0x18
/* QL: sd.scrtp equ    $19     scroll top of window */
.equ sd.scrtp,0x19
/* QL: sd.scrbt equ    $1a     scroll bottom of window */
.equ sd.scrbt,0x1a
/* QL: sd.pan  equ     $1b     pan window */
.equ sd.pan,0x1b
/* QL: * ?     equ     $1c */
/* QL: * ?     equ     $1d */
/* QL: sd.panln equ    $1e     pan cursor line */
.equ sd.panln,0x1e
/* QL: sd.panrt equ    $1f     pan rhs of cursor line */
.equ sd.panrt,0x1f
/* QL: sd.clear equ    $20     clear whole window */
.equ sd.clear,0x20
/* QL: sd.clrtp equ    $21     clear top of window */
.equ sd.clrtp,0x21
/* QL: sd.clrbt equ    $22     clear bottom of window */
.equ sd.clrbt,0x22
/* QL: sd.clrln equ    $23     clear cursor line */
.equ sd.clrln,0x23
/* QL: sd.clrrt equ    $24     clear to right of cursor */
.equ sd.clrrt,0x24
/* QL: sd.fount equ    $25     set fount addresses */
.equ sd.fount,0x25
/* QL: sd.recol equ    $26     recolour a window */
.equ sd.recol,0x26
/* QL: sd.setpa equ    $27     set paper colour */
.equ sd.setpa,0x27
/* QL: sd.setst equ    $28     set strip colour */
.equ sd.setst,0x28
/* QL: sd.setin equ    $29     set ink colour */
.equ sd.setin,0x29
/* QL: sd.setfl equ    $2a     set flash on/off */
.equ sd.setfl,0x2a
/* QL: sd.setul equ    $2b     set underline on/off */
.equ sd.setul,0x2b
/* QL: sd.setmd equ    $2c     set write mode */
.equ sd.setmd,0x2c
/* QL: sd.setsz equ    $2d     set character size */
.equ sd.setsz,0x2d
/* QL: sd.fill equ     $2e     fill block */
.equ sd.fill,0x2e
/* QL: sd.donl equ     $2f     do pending newline */
.equ sd.donl,0x2f
/* QL: sd.point equ    $30     set point in window */
.equ sd.point,0x30
/* QL: sd.line equ     $31     draw line */
.equ sd.line,0x31
/* QL: sd.arc  equ     $32     draw arc */
.equ sd.arc,0x32
/* QL: sd.elips equ    $33     draw ellipse */
.equ sd.elips,0x33
/* QL: sd.scale equ    $34     set graphics scale */
.equ sd.scale,0x34
/* QL: sd.flood equ    $35     set fill mode/vectors */
.equ sd.flood,0x35
/* QL: sd.gcur equ     $36     set text cursor using graphics coords */
.equ sd.gcur,0x36
/* QL: * $6c..$74 $76..$77 $7a..$7f (at least) are used by the pointer interface */
/* QL:         list */
/* QL:         section cs_char */
.section cs_char,"ax"
/* QL: * Parameters: */
/* QL: * d0 x position */
/* QL: * d1 y position */
/* QL: * d2 character to display */
/* QL: * d3 attributes byte */
/* QL: * a0 channel control block */
/* QL: * a1 pointer to colour masks */
/* QL: * a2 primary fount pointer */
/* QL: * a3 secondary fount pointer */
/* QL: * all registers are preserved */
/* QL: * Internal usage: */
/* QL: * d0 bit 31 set if dh and even row count / lsw row loop index */
/* QL: * d1 bits 5-0 character shift */
/* QL: * d2 character field mask */
/* QL: * d3 bits 31-25 attributes, 31=dw / lsw character row */
/* QL: * d4 bit 31 dh / bit 30 dh row / bit 29 dh blank / lsw char row masked with ink */
/* QL: * d5 flash mask */
/* QL: * d6 paper colour masks */
/* QL: * d7 ink colour masks */
/* QL: * a1 pointer to screen */
/* QL: * a2 pointer to character in fount */
/* QL: * a3 saved char row for dh */
/* QL: * a4 internal jump address */
/* QL: * a5 underscore line number */
/* QL: reglist reg     d0-d7/a1-a5 */
/* QL: cs_char */
cs_char:
/* QL:         movem.l reglist,-(sp) */
    movem.l d0-d7/a1-a5,-(sp)
/* QL: * Set up the colour patterns */
/* QL:         movem.l (a1),d6-d7      fetch patterns */
    movem.l (a1),d6-d7
/* QL:         btst    #0,d1           odd row? */
    btst #0,d1
/* QL:         bne.s   masks_ok        ... yes - carry on */
    bne.s masks_ok
/* QL:         swap    d6              ... no - swap the colour masks */
    swap d6
/* QL:         swap    d7 */
    swap d7
/* QL: masks_ok */
masks_ok:
/* QL: * Set the fount address */
/* QL:         and.w   #$ff,d2         character is eight bit */
    and.w #0xff,d2
/* QL:         sub.b   (a2)+,d2        take away minimum character in first fount */
    sub.b (a2)+,d2
/* QL:         cmp.b   (a2)+,d2        is it in range? */
    cmp.b (a2)+,d2
/* QL:         bls.s   calc_font       ... yes - use it */
    bls.s calc_font
/* QL:         add.b   -2(a2),d2       ... no - restore character value */
    add.b (-2)(a2),d2
/* QL:         move.l  a3,a2           try alternative fount */
    move.l a3,a2
/* QL:         sub.b   (a2)+,d2        take away minimum character */
    sub.b (a2)+,d2
/* QL:         cmp.b   (a2)+,d2        is it in range? */
    cmp.b (a2)+,d2
/* QL:         bhi.s   font_set        ... no - we're already at invalid char pattern */
    bhi.s font_set
/* QL: calc_font */
calc_font:
/* QL:         add.w   d2,a2           address is now 9*character value on from base */
    add.w d2,a2
/* QL:         lsl.w   #3,d2 */
    lsl.w #3,d2
/* QL:         add.w   d2,a2 */
    add.w d2,a2
/* QL: font_set */
font_set:
/* QL: * Now find the screen position */
/* QL:         move.l  sd_scrb(a0),a1  base of screen */
    move.l sd_scrb(a0),a1
/* QL:         mulu    sd_linel(a0),d1 and y * bytes per row */
    mulu sd_linel(a0),d1
/* QL:         add.l   d1,a1           gives the row address */
    add.l d1,a1
/* QL:         moveq   #7,d1 */
    moveq #7,d1
/* QL:         and.w   d0,d1           the three ls bits of x form the shift */
    and.w d0,d1
/* QL:         lsr.w   #3,d0           and 8 pixels per byte */
    lsr.w #3,d0
/* QL:         add.w   d0,d0           ... or rather per pair of bytes */
    add.w d0,d0
/* QL:         add.w   d0,a1           ... finishes off the screen address */
    add.w d0,a1
/* QL: * Set up the attributes */
/* QL:         move.w  #-1,a5          underline at line -1!! */
    move.w #(-1),a5
/* QL:         btst    #sd..ulin,d3    is underline required */
    btst #sd..ulin,d3
/* QL:         beq.s   ul_ok           no - leave that */
    beq.s ul_ok
/* QL:         addq.l  #2,a5           yes - underline at row 1 */
    addq.l #2,a5
/* QL: ul_ok */
ul_ok:
/* QL:         moveq   #16,d4          max field width 16 and clear dh flags */
    moveq #16,d4
/* QL:         move.w  sd_xinc(a0),d2 */
    move.w sd_xinc(a0),d2
/* QL:         beq     getout          just in case x-inc was zero! */
    beq getout
/* QL:         sub.w   d2,d4 */
    sub.w d2,d4
/* QL:         bcc.s   inc_ok */
    bcc.s inc_ok
/* QL:         moveq   #0,d4           if x-inc is greater than 16, we stop at 16 */
    moveq #0,d4
/* QL:         ; This needs a bit more fiddling to stick paper into any further */
/* QL:         ; columns when normal writing is occuring.... */
/* QL: inc_ok */
inc_ok:
/* QL:         moveq   #0,d2           start field mask */
    moveq #0,d2
/* QL:         bset    d4,d2 */
    bset d4,d2
/* QL:         neg.w   d2 */
    neg.w d2
/* QL:         ror.l   #8,d2 */
    ror.l #8,d2
/* QL:         ror.l   d1,d2           rotate character mask to position */
    ror.l d1,d2
/* QL:         moveq   #0,d5           clear flash mask */
    moveq #0,d5
/* QL:         ror.l   #sd..dbwd+1,d3  are characters double width */
    ror.l #(sd..dbwd+1),d3
/* QL:         bpl.s   width_ok        ... no - that's done */
    bpl.s width_ok
/* QL:         addq.w  #8,d1           set double width shift */
    addq.w #8,d1
/* QL:         btst    #31-sd..dbwd+sd..flsh,d3 is flash required? */
    btst #((31-sd..dbwd)+sd..flsh),d3
/* QL:         beq.s   width_ok        ... no - check for extend */
    beq.s width_ok
/* QL:         move.w  #$4000,d5       set flash on bit */
    move.w #0x4000,d5
/* QL:         bchg    d4,d5           set flash off bit */
    bchg d4,d5
/* QL:         ror.l   d1,d5           rotate flash mask to position */
    ror.l d1,d5
/* QL: width_ok */
width_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.w  sd_yinc(a0),d0 */
    move.w sd_yinc(a0),d0
/* QL:         beq.l   getout          let's not mess with zero height chars! */
    beq.w getout
/* QL:         subq.w  #1,d0           ready for dbra */
    subq.w #1,d0
/* QL:         btst    #31-sd..dbwd+sd..dbht,d3 are tall characters required? */
    btst #((31-sd..dbwd)+sd..dbht),d3
/* QL:         beq.s   hght_ok */
    beq.s hght_ok
/* QL:         moveq   #-1,d4          set up tall flags */
    moveq #(-1),d4
/* QL:         ror.l   #1,d0           halve row count but save lsb in bit 31 */
    ror.l #1,d0
/* QL: hght_ok */
hght_ok:
/* QL: * Now set up the jump address for character writing mode */
/* QL:         lea     normal,a4       assume normal writing */
    lea normal(pc),a4
/* QL:         btst    #31-sd..dbwd+sd..trns,d3 check for transparent strip */
    btst #((31-sd..dbwd)+sd..trns),d3
/* QL:         beq.s   col_loop */
    beq.s col_loop
/* QL:         subq.l  #normal-transp,a4 */
.word 20876|((((normal-transp))&7)<<9)
/* QL:         btst    #31-sd..dbwd+sd..xor,d3 check for xor ink */
    btst #((31-sd..dbwd)+sd..xor),d3
/* QL:         beq.s   col_loop */
    beq.s col_loop
/* QL:         subq.l  #transp-xor,a4 */
.word 20876|((((transp-xor))&7)<<9)
/* QL: * Main loop for each word column occupied by character */
/* QL: collist reg     d0/d6-d7/a1-a2 */
/* QL: col_loop */
col_loop:
/* QL:         movem.l collist,-(sp) */
    movem.l d0/d6-d7/a1-a2,-(sp)
/* QL:         move.b  d2,d3           replicate character mask byte */
    move.b d2,d3
/* QL:         lsl.w   #8,d2 */
    lsl.w #8,d2
/* QL:         move.b  d3,d2 */
    move.b d3,d2
/* QL:         lsl.w   #8,d5           move flash mask up to ms byte */
    lsl.w #8,d5
/* QL: * Inner loop for each row */
/* QL: row_loop */
row_loop:
/* QL:         cmp.w   #9,d0           row number 9 or greater? */
    cmp.w #9,d0
/* QL:         bge.s   blank_row       if so, jump, to get blank line */
    bge.s blank_row
/* QL:         cmp.w   a5,d0           check for underline row */
    cmp.w a5,d0
/* QL:         beq.s   set_under */
    beq.s set_under
/* QL:         clr.w   d3              clear upper byte */
    clr.w d3
/* QL:         move.b  (a2)+,d3        and fetch next row */
    move.b (a2)+,d3
/* QL:         beq.s   blank_row       if zero - ignore all the next rubbish */
    beq.s blank_row
/* QL:         tst.l   d3              for double width, spread characters out */
    tst.l d3
/* QL:         bpl.s   shft_chr */
    bpl.s shft_chr
/* QL:         tst.l   d5              are we setting flash at all? */
    tst.l d5
/* QL:         beq.s   noflash         no - that's ok */
    beq.s noflash
/* QL:         and.b   #$7f,d3         yes - can't allow first bit to set ink! */
    and.b #(0x7f&255),d3
/* QL: noflash */
noflash:
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         and.b   #15,d4 */
    and.b #(15&255),d4
/* QL:         lsr.b   #4,d3 */
    lsr.b #4,d3
/* QL:         move.b  spread(pc,d3.w),d3 */
    move.b spread(pc,d3.w),d3
/* QL:         lsl.w   #8,d3 */
    lsl.w #8,d3
/* QL:         move.b  spread(pc,d4.w),d3 */
    move.b spread(pc,d4.w),d3
/* QL: shft_chr */
shft_chr:
/* QL:         ror.w   d1,d3           shift to position and replicate */
    ror.w d1,d3
/* QL:         move.b  d3,d4           replicate a byte */
    move.b d3,d4
/* QL:         lsl.w   #8,d3 */
    lsl.w #8,d3
/* QL:         move.b  d4,d3 */
    move.b d4,d3
/* QL:         and.w   d2,d3           mask character with field */
    and.w d2,d3
/* QL: mask_ink */
mask_ink:
/* QL:         move.w  d3,a3           save masked character row in case dh */
    move.w d3,a3
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         and.w   d7,d4           mask character with ink */
    and.w d7,d4
/* QL:         or.w    d5,d4           put flash in */
    or.w d5,d4
/* QL:         jmp     (a4)            jump to code for writing mode */
    jmp (a4)
/* QL: spread */
spread:
/* QL:         dc.l    $00030c0f,$30333c3f,$c0c3cccf,$f0f3fcff */
.balign 2,0
dc_anchor_442:
.long 0x00030c0f
.long 0x30333c3f
.long 0xc0c3cccf
.long 0xf0f3fcff
/* QL: set_under */
set_under:
/* QL:         move.w  d2,d3           full row underline */
    move.w d2,d3
/* QL:         addq.l  #1,a2           move fount pointer past ignored byte */
    addq.l #1,a2
/* QL:         move.w  d3,a3           save masked character row in case dh */
    move.w d3,a3
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         and.w   d7,d4           mask character with ink (can't flash) */
    and.w d7,d4
/* QL:         jmp     (a4)            jump to code for writing mode */
    jmp (a4)
/* QL: dh_row */
dh_row:
/* QL:         bchg    #30,d4          toggle row bit */
    bchg #30,d4
/* QL:         beq.s   next_row        if it was already second row, carry on normal */
    beq.s next_row
/* QL:         tst.l   d0              is it the last row of an odd height? */
    tst.l d0
/* QL:         beq.s   col_end         yes - then it's finished */
    beq.s col_end
/* QL:         bset    #29,d4          is it 2nd row of a blank character? */
    bset #29,d4
/* QL:         beq.s   blank_2nd       yes - go do that */
    beq.s blank_2nd
/* QL:         move.w  a3,d3           restore the character */
    move.w a3,d3
/* QL:         bra.s   mask_ink        go do normal stuff  */
    bra.s mask_ink
/* QL: blank_row */
blank_row:
/* QL:         bclr    #29,d4          clear flag in case dh */
    bclr #29,d4
/* QL: blank_2nd */
blank_2nd:
/* QL:         btst    #31-sd..dbwd+sd..trns,d3 is it anything but normal writing? */
    btst #((31-sd..dbwd)+sd..trns),d3
/* QL:         bne.s   end_row         yes - nothing to do */
    bne.s end_row
/* QL:         move.w  (a1),d4         pick up existing stuff */
    move.w (a1),d4
/* QL:         eor.w   d6,d4           flip with paper pattern bits */
    eor.w d6,d4
/* QL:         and.w   d2,d4           keep just the field area we want to affect */
    and.w d2,d4
/* QL: xor */
xor:
/* QL:         eor.w   d4,(a1)         xor into screen */
    eor.w d4,(a1)
/* QL:         bra.s   end_row */
    bra.s end_row
/* QL: transp */
transp:
/* QL:         not.w   d3              mask in background not part of character */
    not.w d3
/* QL:         and.w   (a1),d3 */
    and.w (a1),d3
/* QL:         bra.s   combine */
    bra.s combine
/* QL: normal */
normal:
/* QL:         eor.w   d2,d3           invert character in field */
    eor.w d2,d3
/* QL:         and.w   d6,d3           mask inverse character with paper */
    and.w d6,d3
/* QL:         or.w    d4,d3           put in ink/flash */
    or.w d4,d3
/* QL:         move.w  d2,d4           get inverted field mask in d4 */
    move.w d2,d4
/* QL:         not.w   d4 */
    not.w d4
/* QL:         and.w   (a1),d4         blank out character area of screen */
    and.w (a1),d4
/* QL: combine */
combine:
/* QL:         or.w    d3,d4           combine the two */
    or.w d3,d4
/* QL:         move.w  d4,(a1)         and put in screen */
    move.w d4,(a1)
/* QL: end_row */
end_row:
/* QL:         swap    d6              swap colours */
    swap d6
/* QL:         swap    d7 */
    swap d7
/* QL:         add.w   sd_linel(a0),a1 take next line */
    add.w sd_linel(a0),a1
/* QL:         tst.l   d4              check for double height */
    tst.l d4
/* QL:         bmi.s   dh_row */
    bmi.s dh_row
/* QL: next_row */
next_row:
/* QL:         dbra    d0,row_loop */
    dbra d0,row_loop
/* QL: col_end */
col_end:
/* QL:         movem.l (sp)+,collist   recover various registers */
    movem.l (sp)+,d0/d6-d7/a1-a2
/* QL:         clr.w   d2              check for any remaining bits */
    clr.w d2
/* QL:         rol.l   #8,d2           ... by rotating mask to next byte */
    rol.l #8,d2
/* QL:         bne.s   nxt_col         if there's more, go do it */
    bne.s nxt_col
/* QL: getout */
getout:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d7/a1-a5
/* QL:         rts */
    rts 
/* QL: nxt_col */
nxt_col:
/* QL:         clr.w   d5              roll in next byte's worth of flash mask */
    clr.w d5
/* QL:         rol.l   #8,d5 */
    rol.l #8,d5
/* QL:         asr.l   #4,d4           reset dh flags */
    asr.l #4,d4
/* QL:         eor.b   #8,d1           flip bytes on the rotate */
    eor.b #(8&255),d1
/* QL:         addq.l  #2,a1           move to next column */
    addq.l #2,a1
/* QL:         bra.l   col_loop */
    bra.w col_loop
/* QL:         end */
