/* Generated from original/M/gw/pixel.asm */
/* QL: * Draw in a pixel, filling a line if need be */
/* QL:         xdef    gw_pixel */
.globl gw_pixel
/* QL:         xref    cs_fill,cs_over */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         include 'win1_m_inc_gw' */
/* QL: * graphic routines stack frame definition */
/* QL:         nolist */
/* QL:         offset  -$30 */
/* QL: sav     reg     a0/a3/a5  required save register list */
/* QL: chnp    ds.l    1       saved a0 = pointer to channel definition block */
.equ chnp,-48
/* QL:         ds.l    2 */
/* QL: lnk ; negated save frame size */
.equ lnk,-36
/* QL: sdx     ds.w    1       square move x increment = -1..1 (*2 if 256 mode)  */
.equ sdx,-36
/* QL: sdy     ds.w    1       square move y increment = -1..1 */
.equ sdy,-34
/* QL: ddx     ds.w    1       diagonal move x increment */
.equ ddx,-32
/* QL: ddy     ds.w    1       diagonal move y increment */
.equ ddy,-30
/* QL: x0      ds.w    1       first point x coordinate */
.equ x0,-28
/* QL: y0      ds.w    1       first point y coordinate */
.equ y0,-26
/* QL: x1      ds.w    1       last point x coordinate */
.equ x1,-24
/* QL: y1      ds.w    1       last point y coordinate */
.equ y1,-22
/* QL: xmin    ds.w    1       left edge of window */
.equ xmin,-20
/* QL: ymin    ds.w    1       top edge of window */
.equ ymin,-18
/* QL: xsize   ds.w    1       window width */
.equ xsize,-16
/* QL: ysize   ds.w    1       window height */
.equ ysize,-14
/* QL: linem   ds.w    1       negated bytes between row addresses (-sd_linel) */
.equ linem,-12
/* QL: linel   ds.w    1       bytes between row addresses (sd_linel) */
.equ linel,-10
/* QL: xinc    ds.w    1       1 (512 mode) or 2 (256 mode) for shifts */
.equ xinc,-8
/* QL:         ds.b    1       spare                            */
/* QL: type    ds.b    1       $ec:line, $dc:arc, $3d:ellipse */
.equ type,-5
/* QL: octs    ds.b    1       maximum number of octant changes permitted */
.equ octs,-4
/* QL: octch   ds.b    1       expected octant change, 0=square, $ff=diagonal */
.equ octch,-3
/* QL: over    ds.b    1       non-zero if xor on (over -1) */
.equ over,-2
/* QL: fmod    ds.b    1       non-zero if area flood on (fill 1) */
.equ fmod,-1
/* QL:         list */
/* QL:         include 'win1_m_inc_hp' */
/* QL: * common heap header definition */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: hp_len  ds.l    1       length of definition block */
.equ hp_len,0
/* QL: hp_next ; pointer to next free space */
.equ hp_next,4
/* QL: hp_drivr ds.l   1       driver to free block when owner is deleted (-ch_close) */
.equ hp_drivr,4
/* QL: hp_owner ds.l   1       owner job (0 if free space) */
.equ hp_owner,8
/* QL: hp_rflag ds.l   1       address to be set when space released */
.equ hp_rflag,12
/* QL: hp_end */
.equ hp_end,16
/* QL: hp_close equ    12      offset of close entry point wrt driver add */
.equ hp_close,12
/* QL:         list */
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
/* QL: * The fill buffer is arranged to have at least a pair of words for each row of */
/* QL: * a window. Redefinion of a window always clears them all. */
/* QL: * The first word is the minimum pixel so far seen on the line and the second is */
/* QL: * minimum pixel never seen so far. */
/* QL: * One special case is the initial zero longword, indicating that no pixel has */
/* QL: * yet been seen for this line. */
/* QL: * Another special case crops up if a pixel at 32767 (or even 32766 in mode 8) */
/* QL: * is requested, when the pixel is effectively treated as zero width in order to */
/* QL: * avoid any problems. */
/* QL: * There is a flaw in this code, in that a mode change from 4 to 8 can result in */
/* QL: * a bit of a mess if an existing filled area starts or finishes at an odd */
/* QL: * pixel, and is then extended. It is not clear exactly how to avoid this. */
/* QL: * Note that the cs routines require d0-d3 and a1 as parameters, but preserve */
/* QL: * all registers. */
/* QL:         section gw_pixel */
.section gw_pixel,"ax"
/* QL: * d0 -ip - x coordinate (lsw) */
/* QL: * d1 -ip - y coordinate (lsw) */
/* QL: * d2 -ip - mask within word fro pixel (lsw) */
/* QL: * d3 -ip - colour masks (msw/lsw) */
/* QL: * a5 -ip - screen word address for pixel */
/* QL: * a6 -ip - stack frame */
/* QL: * d4 destroyed */
/* QL: reglist reg     d0-d3/a0-a1 */
/* QL: gw_pixel */
gw_pixel:
/* QL:         assert  xsize,ysize-2 */
/* original assertion: xsize,ysize-2 */
/* QL:         move.l  xsize(a6),d4 */
    move.l xsize(a6),d4
/* QL:         cmp.w   d4,d1           if y outside window then do nothing */
    cmp.w d4,d1
/* QL:         bcc.s   rts0 */
    bcc.s rts0
/* QL:         swap    d4 */
    swap d4
/* QL:         tst.b   fmod(a6) */
    tst.b fmod(a6)
/* QL:         bne.s   do_fill         if fill mode is on then go to it */
    bne.s do_fill
/* QL: dodot */
dodot:
/* QL:         cmp.w   d4,d0           if x outside window then do nothing */
    cmp.w d4,d0
/* QL:         bcc.s   rts0 */
    bcc.s rts0
/* QL:         move.w  d3,d4           set up colour mask */
    move.w d3,d4
/* QL:         and.w   d2,d4 */
    and.w d2,d4
/* QL:         tst.b   over(a6) */
    tst.b over(a6)
/* QL:         beq.s   setit */
    beq.s setit
/* QL:         eor.w   d4,(a5)         xor it in */
    eor.w d4,(a5)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: setit */
setit:
/* QL:         move.w  d2,d5           write colour on top */
    move.w d2,d5
/* QL:         or.w    (a5),d5         fetch old stuff, but set our bit all ones */
    or.w (a5),d5
/* QL:         sub.w   d2,d5           then knock them out */
    sub.w d2,d5
/* QL:         add.w   d4,d5           and put in what we want */
    add.w d4,d5
/* QL:         move.w  d5,(a5) */
    move.w d5,(a5)
/* QL:         rts */
    rts 
/* QL: first */
first:
/* QL:         move.w  d2,-(a1) */
    move.w d2,-(a1)
/* QL:         move.w  d0,-(a1)        store single pixel range */
    move.w d0,-(a1)
/* QL: single */
single:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d3/a0-a1
/* QL:         bge.s   dodot           now go back to put in this dot */
    bge.s dodot
/* QL:         rts */
    rts 
/* QL: do_fill */
do_fill:
/* QL:         movem.l reglist,-(sp)   ... save a few registers ! */
    movem.l d0-d3/a0-a1,-(sp)
/* QL:         move.l  chnp(a6),a0     retrieve the channel defn ptr */
    move.l chnp(a6),a0
/* QL:         move.w  d1,a1 */
    move.w d1,a1
/* QL:         add.l   a1,a1 */
    add.l a1,a1
/* QL:         lea     hp_end(a1,a1.l),a1 */
    lea hp_end(a1,a1.l),a1
/* QL:         add.l   sd_fbuf(a0),a1  256 word pairs, one pair for each line */
    add.l sd_fbuf(a0),a1
/* QL:         move.w  xinc(a6),d2     calculate right edge of pixel */
    move.w xinc(a6),d2
/* QL:         add.w   d0,d2 */
    add.w d0,d2
/* QL:         bvc.s   nothuge */
    bvc.s nothuge
/* QL:         move.w  d0,d2 */
    move.w d0,d2
/* QL: nothuge */
nothuge:
/* QL:         tst.l   (a1)+ */
    tst.l (a1)+
/* QL:         beq.s   first */
    beq.s first
/* QL:         cmp.w   -(a1),d0 */
    cmp.w -(a1),d0
/* QL:         bge.s   right */
    bge.s right
/* QL:         cmp.w   -(a1),d0 */
    cmp.w -(a1),d0
/* QL:         bge.s   inside */
    bge.s inside
/* QL:         move.w  (a1),d2         get left edge of existing area */
    move.w (a1),d2
/* QL:         move.w  d0,(a1)         replace with this pixel to extend it left */
    move.w d0,(a1)
/* QL: check */
check:
/* QL:         bge.s   lowok           if low is negative we must bring it up to zero */
    bge.s lowok
/* QL:         clr.w   d0 */
    clr.w d0
/* QL: lowok */
lowok:
/* QL:         cmp.w   d2,d4           if right edge escapes window, trim it down */
    cmp.w d2,d4
/* QL:         bge.s   highok */
    bge.s highok
/* QL:         move.w  d4,d2 */
    move.w d4,d2
/* QL: highok */
highok:
/* QL:         sub.w   d0,d2           now establish exactly how much we're doing */
    sub.w d0,d2
/* QL:         cmp.w   xinc(a6),d2 */
    cmp.w xinc(a6),d2
/* QL:         ble.s   single          if single then do it quick */
    ble.s single
/* QL:         swap    d3 */
    swap d3
/* QL:         move.w  d3,-(sp)        msw */
    move.w d3,-(sp)
/* QL:         move.l  d3,-(sp)        lsw,msw,msw */
    move.l d3,-(sp)
/* QL:         move.w  (sp),-(sp)      lsw,lsw,msw,msw */
    move.w (sp),-(sp)
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         add.w   xmin(a6),d0     add x origin */
    add.w xmin(a6),d0
/* QL:         add.w   ymin(a6),d1     add y origin */
    add.w ymin(a6),d1
/* QL:         moveq   #1,d3           just the one row high */
    moveq #1,d3
/* QL:         tst.b   over(a6) */
    tst.b over(a6)
/* QL:         beq.s   fill_it */
    beq.s fill_it
/* QL:         jsr     cs_over(pc) */
    jsr cs_over(pc)
/* QL: done */
done:
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL: inside */
inside:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d3/a0-a1
/* QL:         rts */
    rts 
/* QL: right */
right:
/* QL:         move.w  (a1),d0         get old right edge as start of fill area */
    move.w (a1),d0
/* QL:         move.w  d2,(a1)         extent right to new edge */
    move.w d2,(a1)
/* QL:         tst.w   d0 */
    tst.w d0
/* QL:         bra.s   check */
    bra.s check
/* QL: fill_it */
fill_it:
/* QL:         jsr     cs_fill(pc) */
    jsr cs_fill(pc)
/* QL:         bra.s   done */
    bra.s done
/* QL:         end */
