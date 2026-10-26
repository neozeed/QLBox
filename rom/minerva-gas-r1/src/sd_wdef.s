/* Generated from original/M/sd/wdef.asm */
/* QL: * Redefines the window area */
/* QL:         xdef    sd_bordn,sd_bordr,sd_wdef */
.globl sd_bordn,sd_bordr,sd_wdef
/* QL:         xref    cs_color,cs_fill */
/* QL:         xref    gw_floof */
/* QL:         xref    sd_home */
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
/* QL:         section sd_wdef */
.section sd_wdef,"ax"
/* QL: * d0 -  o- error code */
/* QL: * d1 -i  - border colour */
/* QL: * d2 -i  - border width (we now use only the lsb, to avoid bug in TK2!) */
/* QL: * a0 -ip - window channel definition block */
/* QL: * a1 -i  - pointer to width, height, x and y (wdef only) */
/* QL: * d3-d4 destroyed */
/* QL: reglist reg     d1-d2/a2 */
/* QL: sd_wdef */
sd_wdef:
/* QL:         movem.l reglist,-(sp)   save registers, all but a2 get scrapped really */
    movem.l d1-d2/a2,-(sp)
/* QL:         move.l  a1,a2           save param pointer */
    move.l a1,a2
/* QL:         jsr     gw_floof(pc)    force flood off, in case window height changes */
    jsr gw_floof(pc)
/* QL:         jsr     sd_home(pc)     home the cursor */
    jsr sd_home(pc)
/* QL:         movem.w (a2),d0-d3      load up window definition */
    movem.w (a2),d0-d3
/* QL:         exg     d0,d2           put xmin */
    exg d0,d2
/* QL:         exg     d1,d3           and ymin in the right place */
    exg d1,d3
/* QL:         move.w  #256,d4         bit number 0 and ready to check y */
    move.w #256,d4
/* QL:         bclr    d4,d0           ensure both xwidth and xmin are even */
    bclr d4,d0
/* QL:         bclr    d4,d2 */
    bclr d4,d2
/* QL:         bsr.s   xycheck         check that ymin/ywidth are sensible */
    bsr.s xycheck
/* QL:         add.w   d4,d4           = 512, ready to check x */
    add.w d4,d4
/* QL:         bsr.s   xycheck         check that xmin/xwidth are sensible */
    bsr.s xycheck
/* QL:         clr.w   sd_borwd(a0)    reset border width (lwr: why?) */
    clr.w sd_borwd(a0)
/* QL:         bra.s   border */
    bra.s border
/* QL: xycheck */
xycheck:
/* QL:         tst.w   d3 */
    tst.w d3
/* QL:         ble.s   pop_err         width/height must be strict positive */
    ble.s pop_err
/* QL:         add.w   d3,d1           get rhs/bot */
    add.w d3,d1
/* QL:         cmp.w   d4,d1           compare to max */
    cmp.w d4,d1
/* QL:         bhi.s   pop_err         must be at most that */
    bhi.s pop_err
/* QL:         sub.w   d3,d1           go back to lhs/top */
    sub.w d3,d1
/* QL:         bmi.s   pop_err         that must be positive */
    bmi.s pop_err
/* QL:         exg     d0,d1           swap lhs/top for next call */
    exg d0,d1
/* QL:         exg     d3,d2           swap width/height for next call */
    exg d3,d2
/* QL:         rts */
    rts 
/* QL: * A little piece of code to adjust a window for a border */
/* QL: rst_wind */
rst_wind:
/* QL:         neg.w   d4              remove border */
    neg.w d4
/* QL: adj_wind */
adj_wind:
/* QL:         add.w   d4,d1           add border to ymin */
    add.w d4,d1
/* QL:         add.w   d4,d4           double the border */
    add.w d4,d4
/* QL:         sub.w   d4,d3           and take it away from ysize */
    sub.w d4,d3
/* QL:         ble.s   pop_err */
    ble.s pop_err
/* QL:         add.w   d4,d0           add border to xmin */
    add.w d4,d0
/* QL:         add.w   d4,d4           double it again */
    add.w d4,d4
/* QL:         sub.w   d4,d2           and take it away from xsize */
    sub.w d4,d2
/* QL:         ble.s   pop_err */
    ble.s pop_err
/* QL:         asr.w   #2,d4           restore border width and set z if it is zero */
    asr.w #2,d4
/* QL:         rts */
    rts 
/* QL: pop_err */
pop_err:
/* QL:         addq.l  #4,sp           remove return address */
    addq.l #4,sp
/* QL: error */
error:
/* QL:         moveq   #err.or,d0      out of range */
    moveq #err.or,d0
/* QL:         bra.s   exit */
    bra.s exit
/* QL: fill */
fill:
/* QL:         jmp     cs_fill(pc) */
    jmp cs_fill(pc)
/* QL: * Entry point to just redefine a border */
/* QL: sd_bordr */
sd_bordr:
/* QL:         move.b  d1,sd_bcolr(a0) save border colour */
    move.b d1,sd_bcolr(a0)
/* QL: sd_bordn */
sd_bordn:
/* QL:         movem.l reglist,-(sp)   save registers, all but a2 get scrapped really */
    movem.l d1-d2/a2,-(sp)
/* QL:         cmp.w   sd_borwd(a0),d2 has border width changed? */
    cmp.w sd_borwd(a0),d2
/* QL:         beq.s   rem_bord */
    beq.s rem_bord
/* QL:         jsr     sd_home(pc)     home cursor */
    jsr sd_home(pc)
/* QL: rem_bord */
rem_bord:
/* QL:         movem.w sd_xmin(a0),d0-d4 get old window definition */
    movem.w sd_xmin(a0),d0-d4
/* QL:         bsr.s   rst_wind        and remove the border */
    bsr.s rst_wind
/* QL: border */
border:
/* QL:         move.b  7(sp),d4        get new border width */
    move.b 7(sp),d4
/* QL:         ext.w   d4              check border width, ignoring msb (tk2 bug!!!) */
    ext.w d4
/* QL:         bmi.s   error           get out if it's silly */
    bmi.s error
/* QL:         bsr.s   adj_wind        adjust the window and set status on d4 */
    bsr.s adj_wind
/* QL:         movem.w d0-d4,sd_xmin(a0) put in definition block */
    movem.w d0-d4,sd_xmin(a0)
/* QL:         beq.s   exit_ok         if there is no border - give up now */
    beq.s exit_ok
/* QL:         move.l  (sp),d1         get new border colour */
    move.l (sp),d1
/* QL:         cmp.b   #128,d1         check if it is transparent */
    cmp.b #(128&255),d1
/* QL:         beq.s   exit_ok */
    beq.s exit_ok
/* QL:         move.l  sp,a1           put mask on stack */
    move.l sp,a1
/* QL:         jsr     cs_color(pc)    convert to colour mask */
    jsr cs_color(pc)
/* QL:         move.w  sd_ymin(a0),d1  restore the ymin */
    move.w sd_ymin(a0),d1
/* QL: * Now to draw the border */
/* QL: * For convenience we reset the window to full size */
/* QL:         bsr.s   rst_wind */
    bsr.s rst_wind
/* QL:         neg.w   d4 */
    neg.w d4
/* QL:         exg     d4,d3           set ysize to border width */
    exg d4,d3
/* QL:         bsr.s   fill            fill 1 */
    bsr.s fill
/* QL:         add.w   d4,d1           set ymin to bottom */
    add.w d4,d1
/* QL:         sub.w   d3,d1           less border width */
    sub.w d3,d1
/* QL:         bsr.s   fill            fill 2 */
    bsr.s fill
/* QL:         exg     d4,d3           restore ysize */
    exg d4,d3
/* QL:         sub.w   d3,d1           ymin less a border */
    sub.w d3,d1
/* QL:         add.w   d4,d4           double the border */
    add.w d4,d4
/* QL:         sub.w   d4,d3           ysize less two borders */
    sub.w d4,d3
/* QL:         add.w   d4,d1           ymin plus border */
    add.w d4,d1
/* QL:         exg     d4,d2           set xsize to border width */
    exg d4,d2
/* QL:         bsr.s   fill            fill 3 */
    bsr.s fill
/* QL:         add.w   d4,d0           set xmin to rhs */
    add.w d4,d0
/* QL:         sub.w   d2,d0           less border width */
    sub.w d2,d0
/* QL:         bsr.s   fill            fill 4 */
    bsr.s fill
/* QL: *       1111111111111111111     This is the pattern of filling that went on */
/* QL: *       1111111111111111111     above. Note that (unlike older versions) the */
/* QL: *       3333           4444     corners are not filled in twice. */
/* QL: *       3333           4444 */
/* QL: *       3333           4444 */
/* QL: *       2222222222222222222 */
/* QL: *       2222222222222222222 */
/* QL: exit_ok */
exit_ok:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: exit */
exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d2/a2
/* QL:         rts */
    rts 
/* QL:         end */
