/* Generated from original/M/gw/fig.asm */
/* QL: * Common routine to draw graphics figures */
/* QL:         xdef    gw_asp,gw_fig,gw_pscal,gw_psorg */
.globl gw_asp,gw_fig,gw_pscal,gw_psorg
/* QL:         xref    gw_pitt,gw_pixad,gw_pixel,gw_trans */
/* QL:         xref    ri_abex,ri_abexb */
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
/* QL:         include 'win1_m_inc_ri' */
/* QL: * arithmetic interpreter op codes */
/* QL:         nolist */
/* QL: ri.term equ     $00  0  end of block */
.equ ri.term,0x00
/* QL: ri.one  equ     $01 -6  constant one */
.equ ri.one,0x01
/* QL: ri.nint equ     $02 +4  nearest short integer */
.equ ri.nint,0x02
/* QL: ri.zero equ     $03 -6  constant zero */
.equ ri.zero,0x03
/* QL: ri.int  equ     $04 +4  truncate towards negative to give a short integer */
.equ ri.int,0x04
/* QL: ri.n    equ     $05 -6  plus a signed byte to push fp -128 to 127 */
.equ ri.n,0x05
/* QL: ri.nlint equ    $06 +2  nearest long integer */
.equ ri.nlint,0x06
/* QL: ri.k    equ     $07 -6  plus a byte, nibbles give mantissa and adjust exponent */
.equ ri.k,0x07
/* QL: ri.float equ    $08 -4  float a short integer */
.equ ri.float,0x08
/* QL: ri.flong equ    $09 -2  float a long integer */
.equ ri.flong,0x09
/* QL: ri.add  equ     $0a +6  nos - tos */
.equ ri.add,0x0a
/* QL: ri.sub  equ     $0c +6  nos + tos */
.equ ri.sub,0x0c
/* QL: ri.halve equ    $0d  0  tos / 2 */
.equ ri.halve,0x0d
/* QL: ri.mult  equ    $0e +6  nos * tos */
.equ ri.mult,0x0e
/* QL: ri.doubl equ    $0f  0  tos * 2 */
.equ ri.doubl,0x0f
/* QL: ri.div  equ     $10 +6  nos / tos */
.equ ri.div,0x10
/* QL: ri.recip equ    $11  0  1 / tos */
.equ ri.recip,0x11
/* QL: ri.abs  equ     $12  0  abs(tos) */
.equ ri.abs,0x12
/* QL: ri.roll equ     $13  0  (tos)b, c, a -> (tos)a, b, c (roll 3rd to top) */
.equ ri.roll,0x13
/* QL: ri.neg  equ     $14  0  -tos */
.equ ri.neg,0x14
/* QL: ri.over equ     $15 -6  nos */
.equ ri.over,0x15
/* QL: ri.dup  equ     $16 -6  tos */
.equ ri.dup,0x16
/* QL: ri.swap equ     $17  0  nos <--> tos */
.equ ri.swap,0x17
/* QL: ri.cos  equ     $18  0  cos(tos) */
.equ ri.cos,0x18
/* QL: ri.sin  equ     $1a  0  sin(tos) */
.equ ri.sin,0x1a
/* QL: ri.tan  equ     $1c  0  tan(tos) */
.equ ri.tan,0x1c
/* QL: ri.cot  equ     $1e  0  cot(tos) */
.equ ri.cot,0x1e
/* QL: ri.asin equ     $20  0  arcsin(tos) */
.equ ri.asin,0x20
/* QL: ri.acos equ     $22  0  arccos(tos) */
.equ ri.acos,0x22
/* QL: ri.atan equ     $24  0  arctan(tos) */
.equ ri.atan,0x24
/* QL: ri.arg  equ     $25 +6  arg(tos,nos) = a, solves tos/nos = k*cos(a)/k*sin(a) */
.equ ri.arg,0x25
/* QL: ri.acot equ     $26  0  arccot(tos) */
.equ ri.acot,0x26
/* QL: ri.mod  equ     $27 +6  sqrt(tos^2 + nos^2) */
.equ ri.mod,0x27
/* QL: ri.sqrt equ     $28  0  sqrt(tos) */
.equ ri.sqrt,0x28
/* QL: ri.squar equ    $29  0  tos * tos */
.equ ri.squar,0x29
/* QL: ri.ln   equ     $2a  0  ln(tos) */
.equ ri.ln,0x2a
/* QL: ri.log10 equ    $2c  0  log10(tos) */
.equ ri.log10,0x2c
/* QL: ri.exp  equ     $2e  0  e ^ tos */
.equ ri.exp,0x2e
/* QL: ri.power equ    $2f +2  nos ^ tos, where tos is a signed short integer */
.equ ri.power,0x2f
/* QL: ri.powfp equ    $30 +6  nos ^ tos */
.equ ri.powfp,0x30
/* QL: ri.maxop equ    $30 */
.equ ri.maxop,0x30
/* QL: ri.load equ     $00     load operand key */
.equ ri.load,0x00
/* QL: ri.store equ    $01     store operand key (sets bit 0) */
.equ ri.store,0x01
/* QL: * for use after ri.k */
/* QL: ri.pi180 equ    $56 */
.equ ri.pi180,0x56
/* QL: ri.loge equ     $69 */
.equ ri.loge,0x69
/* QL: ri.pi6  equ     $79 */
.equ ri.pi6,0x79
/* QL: ri.ln2  equ     $88-$100 */
.equ ri.ln2,(0x88-0x100)
/* QL: ri.sqrt3 equ    $98-$100 */
.equ ri.sqrt3,(0x98-0x100)
/* QL: ri.pi   equ     $a8-$100 */
.equ ri.pi,(0xa8-0x100)
/* QL: ri.pi2  equ     $a7-$100 */
.equ ri.pi2,(0xa7-0x100)
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
/* QL: * This code is entered with d0 and a1 as follows: */
/* QL: *             (a1) stack: top (low address),   ...,   bottom (high address) */
/* QL: * sd.point                                                      y,        x */
/* QL: * sd.line                        y finish,     x finish,  y start,  x start */
/* QL: * sd.arc      subtended angle,   y finish,     x finish,  y start,  x start */
/* QL: * sd.elips     rotation angle, minor axis, eccentricity, y centre, x centre */
/* QL:         assert  sd.point,sd.line-1,sd.arc-2,sd.elips-3 */
/* original assertion: sd.point,sd.line-1,sd.arc-2,sd.elips-3 */
/* QL:         offset  -17*6 */
/* QL: alpha   ds.w    3       coefficient of x^2 */
.equ alpha,-102
/* QL: beta    ds.w    3       coefficient of y^2 */
.equ beta,-96
/* QL: gamma   ds.w    3       coefficient of x*y */
.equ gamma,-90
/* QL: u       ds.w    3       coefficient of y */
.equ u,-84
/* QL: v       ds.w    3       coefficient of x */
.equ v,-78
/* QL: asp     ds.w    3       aspect ratio */
.equ asp,-72
/* QL: masp    ds.w    3       aspect ratio, divided by two if mode 8 */
.equ masp,-66
/* QL: sc      ds.w    3       scale / (height - 1) */
.equ sc,-60
/* QL: h1      ds.w    3       screen height - 1 */
.equ h1,-54
/* QL: yo      ds.w    3       y origin */
.equ yo,-48
/* QL: xo      ds.w    3       x origin */
.equ xo,-42
/* QL: base */
.equ base,-36
/* QL: sa      ds.w    3       sine(angle) */
.equ sa,-36
/* QL: ca      ds.w    3       cosine(angle) */
.equ ca,-30
/* QL: ax      ds.w    3       axis of ellipse, normally minor with eccentricity >= 1 */
.equ ax,-24
/* QL: ec      ds.w    3       eccentricity of ellipse, normally greater than one */
.equ ec,-18
/* QL:         offset  ca */
/* QL: a       ds.w    3       angle */
.equ a,-30
/* QL: yf      ds.w    3       finish point y-coord */
.equ yf,-24
/* QL: xf      ds.w    3       finish point x-coord */
.equ xf,-18
/* QL: ys      ds.w    3       start point y-coord */
.equ ys,-12
/* QL: xs      ds.w    3       start point x-coord */
.equ xs,-6
/* QL:         assert  0,* */
/* original assertion: 0,0 */
/* QL:         section gw_fig */
.section gw_fig,"ax"
/* QL: gw_fig */
gw_fig:
/* QL:         link    a6,#lnk         make data frame */
    link a6,#lnk
/* QL:         movem.l sav,-(sp)       save required registers at base of frame */
    movem.l a0/a3/a5,-(sp)
/* QL:         lea     menu-sd.point(pc,d0.w),a5 */
    lea (menu-sd.point)(pc,d0.w),a5
/* QL:         move.b  (a5),d0         pick up pointer byte */
    move.b (a5),d0
/* QL:         add.w   d0,a5           point to menu list for operation */
    add.w d0,a5
/* QL:         move.b  (a5)+,d0        pick up byte that says how many bytes at a1 */
    move.b (a5)+,d0
/* QL:         lea     0(a1,d0.w),a4   point a4 to base of stack */
    lea 0(a1,d0.w),a4
/* QL:         move.b  (a5)+,d0        pick up first proc type byte */
    move.b (a5)+,d0
/* QL:         moveq   #8,d7           start octant count register (ok for elipse) */
    moveq #8,d7
/* QL:         jsr     prep(pc,d0.w)   go to first section of code for operation */
    jsr prep(pc,d0.w)
/* QL:         move.l  a4,a1           just in case caller would like it reset */
    move.l a4,a1
/* QL:         moveq   #0,d0           always return ok, even if we drew nothing */
    moveq #0,d0
/* QL:         movem.l (sp)+,sav       restore a few registers */
    movem.l (sp)+,a0/a3/a5
/* QL:         unlk    a6              release the data frame */
    unlk a6
/* QL:         rts */
    rts 
/* QL: menu dc.b men_p-*,men_l-*-1,men_a-*-2,men_e-*-3 */
menu:
dc_anchor_511:
.byte ((men_p-dc_anchor_511))&255
.byte (((men_l-dc_anchor_511)-1))&255
.byte (((men_a-dc_anchor_511)-2))&255
.byte (((men_e-dc_anchor_511)-3))&255
/* QL: men_p dc.b -ys,pre_p-prep,sca_p-m,pro_p-proc point */
men_p:
dc_anchor_518:
.byte ((-ys))&255
.byte ((pre_p-prep))&255
.byte ((sca_p-m))&255
.byte ((pro_p-proc))&255
/* QL: men_l dc.b -yf,pre_l-prep,sca_p-m,pro_l-proc,swa_p-m,sca_p-m,$ec line */
men_l:
dc_anchor_525:
.byte ((-yf))&255
.byte ((pre_l-prep))&255
.byte ((sca_p-m))&255
.byte ((pro_l-proc))&255
.byte ((swa_p-m))&255
.byte ((sca_p-m))&255
.byte (0xec)&255
/* QL: men_a dc.b -a,pre_a-prep,octs_a-m,sincos-m,sca_p-m,pro_a-proc */
men_a:
dc_anchor_535:
.byte ((-a))&255
.byte ((pre_a-prep))&255
.byte ((octs_a-m))&255
.byte ((sincos-m))&255
.byte ((sca_p-m))&255
.byte ((pro_a-proc))&255
/* QL:         dc.b swa_p-m,sca_p-m,calc_a-m,opt_x-m,$dc arc */
dc_anchor_543:
.byte ((swa_p-m))&255
.byte ((sca_p-m))&255
.byte ((calc_a-m))&255
.byte ((opt_x-m))&255
.byte (0xdc)&255
/* QL: men_e dc.b -a,pre_e-prep,sincos-m,sca_e-m,pro_e-proc */
men_e:
dc_anchor_551:
.byte ((-a))&255
.byte ((pre_e-prep))&255
.byte ((sincos-m))&255
.byte ((sca_e-m))&255
.byte ((pro_e-proc))&255
/* QL:         dc.b calc_e-m,opt_x-m,$3d ellipse */
dc_anchor_558:
.byte ((calc_e-m))&255
.byte ((opt_x-m))&255
.byte (0x3d)&255
/* QL:  ds.w 0 note: the type byte need no longer be so obscure. */
.balign 2,0
/* QL: gw_psorg */
gw_psorg:
/* QL:         assert  6,sd_xorg-sd_yorg */
/* original assertion: 6,sd_xorg-sd_yorg */
/* QL:         move.l  sd_yorg+8(a0),-(a1) */
    move.l (sd_yorg+8)(a0),-(a1)
/* QL:         move.l  sd_yorg+4(a0),-(a1) */
    move.l (sd_yorg+4)(a0),-(a1)
/* QL:         move.l  sd_yorg+0(a0),-(a1) */
    move.l (sd_yorg+0)(a0),-(a1)
/* QL:         rts */
    rts 
/* QL: gw_pscal */
gw_pscal:
/* QL:         move.w  sd_ysize(a0),-(a1) */
    move.w sd_ysize(a0),-(a1)
/* QL:         subq.w  #1,(a1) */
    subq.w #1,(a1)
/* QL:         moveq   #ri.float,d0 */
    moveq #ri.float,d0
/* QL:         jsr     ri_abex(pc) */
    jsr ri_abex(pc)
/* QL:         move.l  sd_scal+2(a0),-(a1) */
    move.l (sd_scal+2)(a0),-(a1)
/* QL:         move.w  sd_scal(a0),-(a1) */
    move.w sd_scal(a0),-(a1)
/* QL:         rts */
    rts 
/* QL: * Push screen aspect ratio onto stack */
/* QL: gw_asp */
gw_asp:
/* QL: ; if ntsc */
/* QL: ;       move.l  #$6623b79c,-(a1) 2/(4/3*575/512*51.2/51.95) * 1.173 */
/* QL: ;       move.w  #$801,-(a1) */
/* QL: ; else */
/* QL: *        move.l  #$56b851ec,-(a1) 2 / ( (4/3) * (575/512) * (51.2/51.95) ) */
/* QL: *        move.w  #$801,-(a1)      (acually rounded(?) to 1.355) */
/* QL: * The aspect ratio, according to the above, should have been pushing */
/* QL: * $56bbe1ba onto the stack! as we can multiply/divide quicker (now) if the */
/* QL: * least significant half of the mantissa is zero (and keeping as close, one */
/* QL: * part in 32647, to the wrong value, but on the right side of it) ... */
/* QL:         clr.w   -(a1) */
    clr.w -(a1)
/* QL:         move.l  #$80156b9,-(a1)  2 / ( (4/3) * (575/512) * (51.2/51.95) ) */
    move.l #0x80156b9,-(a1)
/* QL: ; endif */
/* QL:         rts */
    rts 
/* QL: prep */
prep:
/* QL: pre_e */
pre_e:
/* QL:         bsr.s   abexm           go convert angle to sine/cosine */
    bsr.s abexm
/* QL:         moveq   #ord_e-m,d0 */
    moveq #(ord_e-m),d0
/* QL:         cmp.w   #$801,ec(a4)    we want major >= minor ... */
    cmp.w #0x801,ec(a4)
/* QL:         bcc.s   eccok           ... so if eccentricity is less than 1.0 ... */
    bcc.s eccok
/* QL:         moveq   #inv_e-m,d0     ... first rotate by pi/2 and flip eccentricity */
    moveq #(inv_e-m),d0
/* QL: eccok */
eccok:
/* QL:         bsr.s   abexn           do eccentricity calcs */
    bsr.s abexn
/* QL:         bra.s   setoct */
    bra.s setoct
/* QL: pre_a */
pre_a:
/* QL:         bsr.s   abexm           get octants (also halves the angle) */
    bsr.s abexm
/* QL:         and.w   (a1),d7         check if int(angle/(pi/4)) bit 3 is set */
    and.w (a1),d7
/* QL:         beq.s   noflip          not set, it's ok (this works for big angles!) */
    beq.s noflip
/* QL:         not.w   (a1)            if set, invert it all (gets -ve ok) */
    not.w (a1)
/* QL: noflip */
noflip:
/* QL:         move.w  (a1)+,d7        found number of octants in subtended angle */
    move.w (a1)+,d7
/* QL: * This only needs to be a low estimate, as the algorithm understands that arcs */
/* QL: * are a pain, and it will let them search on for a bit to find their end point. */
/* QL:         bsr.s   abexm           convert angle to sine/cosine */
    bsr.s abexm
/* QL: pre_l */
pre_l:
/* QL:         and.b   #7,d7           line -> 0, arc -> 0..7 */
    and.b #(7&255),d7
/* QL: setoct */
setoct:
/* QL:         move.b  d7,octs(a6)     set the octant count */
    move.b d7,octs(a6)
/* QL: pre_p */
pre_p:
/* QL:         lea     base(a4),a1     put a1 at standard position */
    lea base(a4),a1
/* QL:         bsr.s   gw_psorg        copy origins to stack */
    bsr.s gw_psorg
/* QL:         bsr.s   gw_pscal        copy scale data to stack */
    bsr.s gw_pscal
/* QL:         moveq   #setsc-m,d0     adjust the scale stuff */
    moveq #(setsc-m),d0
/* QL:         bsr.s   abexn */
    bsr.s abexn
/* QL: * Set up miscellaneous bits of the frame data */
/* QL:         btst    #sd..xor,sd_cattr(a0) */
    btst #sd..xor,sd_cattr(a0)
/* QL:         sne     over(a6)        flag $ff = "over -1" */
    sne over(a6)
/* QL:         move.b  sd_fmod(a0),fmod(a6) flag <>0 = "fill 1" */
    move.b sd_fmod(a0),fmod(a6)
/* QL:         assert  sd_xmin,sd_ymin-2,sd_xsize-4,sd_ysize-6 */
/* original assertion: sd_xmin,sd_ymin-2,sd_xsize-4,sd_ysize-6 */
/* QL:         assert  xmin,ymin-2,xsize-4,ysize-6 */
/* original assertion: xmin,ymin-2,xsize-4,ysize-6 */
/* QL:         movem.l sd_xmin(a0),d0-d1 */
    movem.l sd_xmin(a0),d0-d1
/* QL:         movem.l d0-d1,xmin(a6)  window top left corner and size */
    movem.l d0-d1,xmin(a6)
/* QL: * Set up stuff that's dependent on the current screen mode */
/* QL:         moveq   #mt.dmode,d0 */
    moveq #mt.dmode,d0
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         trap    #1 */
    trap #1
/* QL:         asr.b   #4,d1           shift bit 3 into x. x = 0/1, mode 512/256 */
    asr.b #4,d1
/* QL:         subx.w  d0,d0 */
    subx.w d0,d0
/* QL:         bsr.s   gw_asp          put on a copy of the aspect ratio for scaling */
    bsr.s gw_asp
/* QL:         add.w   d0,(a1)         divide scale by factor of two if mode 256 */
    add.w d0,(a1)
/* QL:         bsr.s   gw_asp          put on aspect ratio */
    bsr.s gw_asp
/* QL:         neg.w   d0 */
    neg.w d0
/* QL:         addq.w  #1,d0          */
    addq.w #1,d0
/* QL:         move.w  d0,xinc(a6)     2 for mode 256 or 1 for mode 512 */
    move.w d0,xinc(a6)
/* QL:         bsr.s   abexm           scale the start point input params */
    bsr.s abexm
/* QL:         lea     x0(a6),a2       where to put start point */
    lea x0(a6),a2
/* QL:         bsr.s   xyext           pick off and adjust start point */
    bsr.s xyext
/* QL:         move.b  (a5)+,d0 */
    move.b (a5)+,d0
/* QL:         jmp     proc(pc,d0.w)   jump to what to do next */
.word 0x4efb
.word 0|((proc-.)&255)
/* QL: abexm */
abexm:
/* QL:         move.b  (a5)+,d0        use next menu byte to decide what calcs to do */
    move.b (a5)+,d0
/* QL: abexn */
abexn:
/* QL:         ext.w   d0 */
    ext.w d0
/* QL:         beq.s   rts0            dummy entries have d0=0 at this point */
    beq.s rts0
/* QL:         lea     m,a3 */
    lea m(pc),a3
/* QL:         add.w   d0,a3 */
    add.w d0,a3
/* QL:         jsr     ri_abexb(pc) */
    jsr ri_abexb(pc)
/* QL:         beq.s   rts0 */
    beq.s rts0
/* QL:         addq.l  #4,sp           don't accept errors, draw nothing */
    addq.l #4,sp
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: xyext */
xyext:
/* QL:         move.l  (a1)+,d1        get x/y (doubled) */
    move.l (a1)+,d1
/* QL:         asr.w   #1,d1           make y proper, propagating sign */
    asr.w #1,d1
/* QL:         subx.w  d2,d2           carry = rounding */
    subx.w d2,d2
/* QL:         sub.w   d2,d1           do y rounding */
    sub.w d2,d1
/* QL:         swap    d1              put y in msw for now */
    swap d1
/* QL:         move.w  xinc(a6),d0     get x-increment, 1/2 */
    move.w xinc(a6),d0
/* QL:         asr.w   d0,d1           make x near proper, propagating sign */
    asr.w d0,d1
/* QL:         subx.w  d2,d2           carry = rounding */
    subx.w d2,d2
/* QL:         sub.w   d2,d1           do x rounding */
    sub.w d2,d1
/* QL:         subq.w  #1,d0           change shift to 0/1 */
    subq.w #1,d0
/* QL:         lsl.w   d0,d1           put x to final place (lsb=0 for mode 8) */
    lsl.w d0,d1
/* QL:         swap    d1              swap back to right way round */
    swap d1
/* QL:         move.l  d1,(a2)+        store x/y */
    move.l d1,(a2)+
/* QL:         rts */
    rts 
/* QL: proc */
proc:
/* QL: * sd.point: call just the bits we need, and forget all the dross. */
/* QL: pro_p */
pro_p:
/* QL:         movem.w x0(a6),d0-d1 */
    movem.w x0(a6),d0-d1
/* QL:         jsr     gw_pixad(pc) */
    jsr gw_pixad(pc)
/* QL:         jmp     gw_pixel(pc) */
    jmp gw_pixel(pc)
/* QL: * Process the ellipse */
/* QL: pro_e */
pro_e:
/* QL:         move.l  d1,(a2)+        repeat start point as end point */
    move.l d1,(a2)+
/* QL:         cmp.w   #$800,ax(a4)    is the narrow bit less than one pixel? */
    cmp.w #0x800,ax(a4)
/* QL:         bcs.s   rts0            yes - we'll not bother to draw anything! */
    bcs.s rts0
/* QL: * There is the idea of drawing two shallow arcs, but I don't know (lwr)... */
/* QL: * However, eventually it would be a good idea to break an ellipse into */
/* QL: * sections, anyway, so we can draw huge ones without wandering miles offscreen */
/* QL: * in the process. */
/* QL: allset */
allset:
/* QL:         bsr.s   abexm           do the main calculations */
    bsr.s abexm
/* QL:         bsr.s   abexm           produce the rounding factor */
    bsr.s abexm
/* QL:         bra.s   abguv */
    bra.s abguv
/* QL: * sd.line: simple one */
/* QL: pro_l */
pro_l:
/* QL:         bsr.s   abexm           swap in end point */
    bsr.s abexm
/* QL:         bsr.s   abexm           process end point */
    bsr.s abexm
/* QL:         bsr.s   xyext           fetch end point */
    bsr.s xyext
/* QL:         moveq   #0,d2           alpha = 0 */
    moveq #0,d2
/* QL:         moveq   #0,d3           beta = 0 */
    moveq #0,d3
/* QL:         moveq   #0,d4           gamma = 0 */
    moveq #0,d4
/* QL:         assert  x0,y0-2,x1-4,y1-6 */
/* original assertion: x0,y0-2,x1-4,y1-6 */
/* QL:         movem.w x0(a6),d0-d1/d6-d7 get start and end points (sign extended) */
    movem.w x0(a6),d0-d1/d6-d7
/* QL:         sub.l   d0,d6 */
    sub.l d0,d6
/* QL:         cmp.b   #2,xinc+1(a6)   mode 512? */
    cmp.b #(2&255),(xinc+1)(a6)
/* QL:         beq.s   uset            (note: 512 mode start/end x already even) */
    beq.s uset
/* QL:         add.l   d6,d6           u = delta x * 2 / mode */
    add.l d6,d6
/* QL: uset */
uset:
/* QL:         sub.l   d1,d7 */
    sub.l d1,d7
/* QL:         add.l   d7,d7           v = delta y * 2 */
    add.l d7,d7
/* QL:         bra.s   trans           go do it! */
    bra.s trans
/* QL: * Process an arc */
/* QL: pro_a */
pro_a:
/* QL:         bsr.s   abexm           swap in end point */
    bsr.s abexm
/* QL:         bsr.s   abexm           process end point */
    bsr.s abexm
/* QL:         bsr.s   xyext           fetch end point */
    bsr.s xyext
/* QL:         movem.w x0(a6),d0-d4    pick up start and end points */
    movem.w x0(a6),d0-d4
/* QL:         sub.l   d0,d2           x1 - x0 */
    sub.l d0,d2
/* QL:         sub.l   d1,d3           y1 - y0 */
    sub.l d1,d3
/* QL:         movem.l d2-d3,-(a1)     put them on the stack */
    movem.l d2-d3,-(a1)
/* QL:         bra.s   allset */
    bra.s allset
/* QL: * We wish to arrange for the values used in squch and diach to have as many */
/* QL: * significant bits as we can, to keep accuracy. */
/* QL: * Also, in order to have no rounding errors, the values we set up need alpha */
/* QL: * and beta multiples of four and gamma, u and v even. */
/* QL: * Further to the above, the following are the worst case values that we will */
/* QL: * need to cope with signed arithmetic on: */
/* QL: *       alpha + beta + 2*gamma */
/* QL: *       alpha/2 + gamma/2 + u + v */
/* QL: *       beta/2 + gamma/2 + u + v */
/* QL: *       alpha/4 + u/2 + beta/2 + gamma/2 + v */
/* QL: *       beta/4 + v/2 + alpha/2 + gamma/2 + u */
/* QL: * We actually know that alpha, beta and gamma are less than one, except for */
/* QL: * an arc, when alpha and beta are less than two, but gamma is zero. */
/* QL: * The main interest is the values of u and v. If these are less than one, we've */
/* QL: * got a pretty degenerate figure to draw! */
/* QL: * Finally, when the ellipse was set up, it tried to arrange itself a start */
/* QL: * point on the minor axis. However, aspect ratio scaling will disturb this, */
/* QL: * meaning we need an extra guard bit to stop the algorithm screwing up. */
/* QL: * We have already arranged the top of the arithmetic stack to contain: */
/* QL: * abs(u')+abs(v')+8,alpha/2,beta/2,gamma,u,v,... */
/* QL: abguv */
abguv:
/* QL:         move.w  (a1),d5 */
    move.w (a1),d5
/* QL:         addq.l  #6,a1 */
    addq.l #6,a1
/* QL:         sub.w   #$800+27,d5     dividing power of two */
    sub.w #(0x800+27),d5
/* QL:         bsr.s   optim */
    bsr.s optim
/* QL:         add.l   d7,d7 */
    add.l d7,d7
/* QL:         move.l  d7,d2           alpha */
    move.l d7,d2
/* QL:         bsr.s   optim */
    bsr.s optim
/* QL:         add.l   d7,d7 */
    add.l d7,d7
/* QL:         move.l  d7,d3           beta */
    move.l d7,d3
/* QL:         bsr.s   optim */
    bsr.s optim
/* QL:         move.l  d7,d4           gamma */
    move.l d7,d4
/* QL:         bsr.s   optim */
    bsr.s optim
/* QL:         move.l  d7,d6           u */
    move.l d7,d6
/* QL:         bsr.s   optim           v */
    bsr.s optim
/* QL:         movem.w x0(a6),d0-d1    put start coords them into their registers */
    movem.w x0(a6),d0-d1
/* QL: trans */
trans:
/* QL:         move.b  (a5)+,type(a6)  finally set the call type: l=ec a=dc e=3d */
    move.b (a5)+,type(a6)
/* QL: * Now transform from coefficients to pitteway algorithm variables and set up */
/* QL: * the initial values. Also find the starting octant of the figure, the pixel */
/* QL: * address and masks, and rearrange the registers */
/* QL:         jsr     gw_trans(pc) */
    jsr gw_trans(pc)
/* QL: * Now the figure may be drawn. Call Pitteway! */
/* QL:         jmp     gw_pitt(pc) */
    jmp gw_pitt(pc)
/* QL: optim */
optim:
/* QL:         sub.w   d5,(a1)         scale parameters to improve numerics */
    sub.w d5,(a1)
/* QL:         bpl.s   goopt           are we getting a tiny value (too tiny!) */
    bpl.s goopt
/* QL:         clr.w   (a1)            yes, just zap exponent so nlint is happy */
    clr.w (a1)
/* QL: goopt */
goopt:
/* QL:         moveq   #ri.nlint,d0 */
    moveq #ri.nlint,d0
/* QL:         jsr     ri_abex(pc) */
    jsr ri_abex(pc)
/* QL:         move.l  (a1)+,d7 */
    move.l (a1)+,d7
/* QL:         add.l   d7,d7           most want to be even */
    add.l d7,d7
/* QL:         rts */
    rts 
/* QL: * Execution blocks for initial arc / elipse parameter arithmetic. */
/* QL: octs_a */
octs_a:
/* QL: * Note: for arc, we are only interested in the half angle. */
/* QL: * a*2, yf, xf, ys, xs */
/* QL:  dc.b ri.halve,ri.dup,ri.k,ri.pi-3,ri.div,ri.int,ri.term */
dc_anchor_951:
.byte (ri.halve)&255
.byte (ri.dup)&255
.byte (ri.k)&255
.byte ((ri.pi-3))&255
.byte (ri.div)&255
.byte (ri.int)&255
.byte (ri.term)&255
/* QL: * int(a*2/(pi/4)).w, a, yf, xf, ys, xs */
/* QL:         assert  a,ca,sa+6 */
/* original assertion: a,ca,sa+6 */
/* QL: sincos */
sincos:
/* QL: * N.B. We've turned the y-axis upside down! */
/* QL: * a, ... */
/* QL:  dc.b ri.dup,ri.cos,ri.swap       ca = cosine(a) */
dc_anchor_967:
.byte (ri.dup)&255
.byte (ri.cos)&255
.byte (ri.swap)&255
/* QL:  dc.b ri.sin,ri.neg,ri.term       sa = -sine(a) */
dc_anchor_972:
.byte (ri.sin)&255
.byte (ri.neg)&255
.byte (ri.term)&255
/* QL: * sa, ca, ... */
/* QL: inv_e */
inv_e:
/* QL: * -ca, sa, ax/ec, 1/ec, yc, xc */
/* QL:  dc.b ri.neg,ri.swap                    angle = angle' + pi/2 */
dc_anchor_981:
.byte (ri.neg)&255
.byte (ri.swap)&255
/* QL:  dc.b ax,ec,ri.mult,ri.store+ax,ri.term ax = ax' * ec' = minor axis */
dc_anchor_985:
.byte (ax)&255
.byte (ec)&255
.byte (ri.mult)&255
.byte ((ri.store+ax))&255
.byte (ri.term)&255
/* QL: * sa, ca, ax, -, yc, xc */
/* QL: ord_e */
ord_e:
/* QL: * sa, ca, ax, ec, yc, xc */
/* QL:  dc.b ec,ri.recip,ri.store+ec,ri.term   ec = 1/ec */
dc_anchor_996:
.byte (ec)&255
.byte (ri.recip)&255
.byte ((ri.store+ec))&255
.byte (ri.term)&255
/* QL: * sa, ca, ax, -, yc, xc */
/* QL: * Execution blocks for scaling */
/* QL: setsc */
setsc:
/* QL: * scale, h-1, yo, xo, asp, masp,... */
/* QL:  dc.b ri.over,ri.swap,ri.div,ri.term */
dc_anchor_1007:
.byte (ri.over)&255
.byte (ri.swap)&255
.byte (ri.div)&255
.byte (ri.term)&255
/* QL: * (h-1)/scale, h-1, yo, xo, asp, masp,... */
/* QL: * N.B. Note that both start and end point use the same calculation. This */
/* QL: * ensures that sequences of lines and arcs, where the end point of one is the */
/* QL: * start point of the next, will be guaranteed to come up with the same pixel. */
/* QL: sca_e */
sca_e:
/* QL: * ..., sa, ca, ax, -, yc, xc */
/* QL:  dc.b ax,sa,ri.mult,xs,ri.add,ri.store+xs       xs = xc + v */
dc_anchor_1020:
.byte (ax)&255
.byte (sa)&255
.byte (ri.mult)&255
.byte (xs)&255
.byte (ri.add)&255
.byte ((ri.store+xs))&255
/* QL: * ..., sa, ca, ax, ec, yc, xs */
/* QL:  dc.b ax,ca,ri.mult,ys,ri.add,ri.store+ys       ys = yc + u (later negation) */
dc_anchor_1029:
.byte (ax)&255
.byte (ca)&255
.byte (ri.mult)&255
.byte (ys)&255
.byte (ri.add)&255
.byte ((ri.store+ys))&255
/* QL:  dc.b ax,sc,ri.mult,ri.store+ax                 ax = ax*(h-1)/scale */
dc_anchor_1037:
.byte (ax)&255
.byte (sc)&255
.byte (ri.mult)&255
.byte ((ri.store+ax))&255
/* QL: sca_p */
sca_p:
/* QL: * ..., (h-1)/scale, h-1, yo, xo, asp, masp, ... */
/* QL:  dc.b yo,ys,ri.sub,sc,ri.mult */
dc_anchor_1046:
.byte (yo)&255
.byte (ys)&255
.byte (ri.sub)&255
.byte (sc)&255
.byte (ri.mult)&255
/* QL:  dc.b h1,ri.add,ri.doubl,ri.int                 int(2*((y-yf)*(h-1)/scale+h-1)) */
dc_anchor_1053:
.byte (h1)&255
.byte (ri.add)&255
.byte (ri.doubl)&255
.byte (ri.int)&255
/* QL:  dc.b xs,xo,ri.sub,sc,ri.mult */
dc_anchor_1059:
.byte (xs)&255
.byte (xo)&255
.byte (ri.sub)&255
.byte (sc)&255
.byte (ri.mult)&255
/* QL:  dc.b asp,ri.mult,ri.doubl,ri.int,ri.term       int(2*(x-xo)*(h-1)/scale*asp) */
dc_anchor_1066:
.byte (asp)&255
.byte (ri.mult)&255
.byte (ri.doubl)&255
.byte (ri.int)&255
.byte (ri.term)&255
/* QL: * int(x').w, int(y').w, ... */
/* QL: swa_p */
swa_p:
/* QL:  dc.b yf,ri.store+ys,xf,ri.store+xs replace start point with end point */
dc_anchor_1076:
.byte (yf)&255
.byte ((ri.store+ys))&255
.byte (xf)&255
.byte ((ri.store+xs))&255
/* QL: m dc.b ri.term */
m:
dc_anchor_1083:
.byte (ri.term)&255
/* QL: * Execution blocks are referenced byte relative to m. An entry in the menu of */
/* QL: * zero will in fact skip doing any calculations at all. This is used so that we */
/* QL: * can break up the calcuations into convienient bits. */
/* QL: * Execution block for arc arithmetic */
/* QL: calc_a */
calc_a:
/* QL: * int(x1-x0).l, int(y1-y0).l, ... */
/* QL:  dc.b ri.flong,asp,ri.div,ri.store+xf re-incorporate aspect ratio with delta x */
dc_anchor_1093:
.byte (ri.flong)&255
.byte (asp)&255
.byte (ri.div)&255
.byte ((ri.store+xf))&255
/* QL:  dc.b ri.flong */
dc_anchor_1099:
.byte (ri.flong)&255
/* QL: * yf-ys, ...  */
/* QL:  dc.b ri.dup,ca,ri.mult         (yf - ys) * ca */
dc_anchor_1103:
.byte (ri.dup)&255
.byte (ca)&255
.byte (ri.mult)&255
/* QL:  dc.b xf,sa,ri.mult             (xf - xs) * sa */
dc_anchor_1108:
.byte (xf)&255
.byte (sa)&255
.byte (ri.mult)&255
/* QL:  dc.b ri.sub,masp,ri.div                v = ((yf-ys) * ca - (xf-xs) * sa)/masp */
dc_anchor_1113:
.byte (ri.sub)&255
.byte (masp)&255
.byte (ri.div)&255
/* QL:  dc.b ri.swap,sa,ri.mult        (yf - ys) * sa */
dc_anchor_1118:
.byte (ri.swap)&255
.byte (sa)&255
.byte (ri.mult)&255
/* QL:  dc.b xf,ca,ri.mult             (xf - xs) * ca */
dc_anchor_1123:
.byte (xf)&255
.byte (ca)&255
.byte (ri.mult)&255
/* QL:  dc.b ri.add                            u = (xf-xs) * ca + (yf-ys) * sa */
dc_anchor_1128:
.byte (ri.add)&255
/* QL: * u, v, ... */
/* QL:  dc.b ri.zero                           gamma = 0 */
dc_anchor_1132:
.byte (ri.zero)&255
/* QL:  dc.b sa,masp,ri.squar,ri.div           beta/2 = 2 * sa / 2 / masp^2 */
dc_anchor_1135:
.byte (sa)&255
.byte (masp)&255
.byte (ri.squar)&255
.byte (ri.div)&255
/* QL:  dc.b sa,ri.term                        alpha/2 = 2 * sa / 2 */
dc_anchor_1141:
.byte (sa)&255
.byte (ri.term)&255
/* QL: * alpha/2, beta/2, gamma, u, v, ... */
/* QL: opt_x */
opt_x:
/* QL: * alpha/2, beta/2, gamma, u, v, ... */
/* QL:  dc.b u,ri.abs,v,ri.abs,ri.add,ri.n,8,ri.add    abs(u')+abs(v')+8 (for round) */
dc_anchor_1149:
.byte (u)&255
.byte (ri.abs)&255
.byte (v)&255
.byte (ri.abs)&255
.byte (ri.add)&255
.byte (ri.n)&255
.byte (8)&255
.byte (ri.add)&255
/* QL: * abs(u')+abs(v')+8, alpha/2, beta/2, gamma, u, v, ... */
/* QL:  dc.b ri.term */
dc_anchor_1160:
.byte (ri.term)&255
/* QL: * Execution block for ellipse calculations (last, to give m more room) */
/* QL: calc_e */
calc_e:
/* QL: * ... */
/* QL:  dc.b ax,sa,ri.mult,masp,ri.div         v = ax * sa / masp */
dc_anchor_1167:
.byte (ax)&255
.byte (sa)&255
.byte (ri.mult)&255
.byte (masp)&255
.byte (ri.div)&255
/* QL: * v, ... */
/* QL:  dc.b ax,ca,ri.mult                     u = ax * ca */
dc_anchor_1175:
.byte (ax)&255
.byte (ca)&255
.byte (ri.mult)&255
/* QL: * u, v, ... */
/* QL:  dc.b ri.one,ec,ri.squar,ri.sub         ee = 1 - 1 / ec^2 */
dc_anchor_1181:
.byte (ri.one)&255
.byte (ec)&255
.byte (ri.squar)&255
.byte (ri.sub)&255
/* QL: * ee, u, v, ... */
/* QL:  dc.b ri.dup,sa,ri.mult */
dc_anchor_1188:
.byte (ri.dup)&255
.byte (sa)&255
.byte (ri.mult)&255
/* QL: * ee*sa, ee, u, v, ... */
/* QL:  dc.b ri.dup,sa,ri.mult */
dc_anchor_1194:
.byte (ri.dup)&255
.byte (sa)&255
.byte (ri.mult)&255
/* QL: * ee*sa^2, ee*sa, ee, u, v, ... */
/* QL:  dc.b ri.swap,ca,ri.mult,masp,ri.div    gamma = ee * sa * ca / masp */
dc_anchor_1200:
.byte (ri.swap)&255
.byte (ca)&255
.byte (ri.mult)&255
.byte (masp)&255
.byte (ri.div)&255
/* QL: * gamma, ee*sa^2, ee, u, v, ... */
/* QL:  dc.b ri.one,ri.roll,ri.sub,ri.halve    alpha/2 = (1 - ee * sa^2) / 2 */
dc_anchor_1208:
.byte (ri.one)&255
.byte (ri.roll)&255
.byte (ri.sub)&255
.byte (ri.halve)&255
/* QL: * (1-ee*sa^2)/2, gamma, ee, u, v, ... */
/* QL:  dc.b ri.roll,ri.halve,ri.one,ri.swap,ri.sub */
dc_anchor_1215:
.byte (ri.roll)&255
.byte (ri.halve)&255
.byte (ri.one)&255
.byte (ri.swap)&255
.byte (ri.sub)&255
/* QL: * 1-ee/2, (1-ee*sa^2)/2, gamma, u, v, ... */
/* QL:  dc.b ri.over,ri.sub */
dc_anchor_1223:
.byte (ri.over)&255
.byte (ri.sub)&255
/* QL: * (1-ee*ca^2)/2, (1-ee*sa^2)/2, gamma, u, v, ... */
/* QL:  dc.b masp,ri.squar,ri.div              beta/2 = (1-ee*ca^2) / masp^2 / 2 */
dc_anchor_1228:
.byte (masp)&255
.byte (ri.squar)&255
.byte (ri.div)&255
/* QL: * beta, alpha, gamma, u, v, ... */
/* QL:  dc.b ri.swap,ri.term */
dc_anchor_1234:
.byte (ri.swap)&255
.byte (ri.term)&255
/* QL: * alpha, beta, gamma, u, v, ... */
/* QL:         end */
