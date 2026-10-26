/* Generated from original/M/ut/windw.asm */
/* QL: * Simplified window open */
/* QL:         xdef    ut_windw,ut_con,ut_scr,ut_wrdef */
.globl ut_windw,ut_con,ut_scr,ut_wrdef
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
/* QL:         include 'win1_m_inc_io' */
/* QL: * basic I/O keys */
/* QL:         nolist */
/* QL: * trap #2 d0 codes */
/* QL: io.open equ     1       open channel */
.equ io.open,1
/* QL: io.close equ    2       close channel */
.equ io.close,2
/* QL: io.formt equ    3       format medium */
.equ io.formt,3
/* QL: io.delet equ    4       delete file */
.equ io.delet,4
/* QL: * trap #2 d3 codes */
/* QL: io.old  equ     0       open old (exclusive) file or device */
.equ io.old,0
/* QL: io.share equ    1       open shared (old) file */
.equ io.share,1
/* QL: io.new  equ     2       open new (exclusive) file */
.equ io.new,2
/* QL: io.overw equ    3       open overwrite (or open new) file */
.equ io.overw,3
/* QL: io.dir  equ     4       open directory */
.equ io.dir,4
/* QL: * trap #3 d0 codes */
/* QL: io.pend equ     0       check for pending input */
.equ io.pend,0
/* QL: io.fbyte equ    1       fetch a byte */
.equ io.fbyte,1
/* QL: io.fline equ    2       fetch a line of bytes */
.equ io.fline,2
/* QL: io.fstrg equ    3       fetch a string of bytes */
.equ io.fstrg,3
/* QL: io.edlin equ    4       edit a line */
.equ io.edlin,4
/* QL: io.sbyte equ    5       send a byte */
.equ io.sbyte,5
/* QL: io.sstrg equ    7       send a string of bytes */
.equ io.sstrg,7
/* QL:         list */
/* QL:         section ut_windw */
.section ut_windw,"ax"
/* QL: * N.B. ut_windw now correctly gets the top byte of d2.w zero before sd.bordr. */
/* QL: * Also, other than ut_wrdef, the rest now do close the channel they've opened */
/* QL: * if any subsequent part of the setup fails. They used to leave it open! */
/* QL: * a0 i o pointer to name / channel id */
/* QL: * a1 i p pointer to parameter block */
/* QL: * d0   o error code */
/* QL: * d1-d3 destroyed (ut_wrdef preserves d3) */
/* QL: ut_windw */
ut_windw:
/* QL:         bsr.s   open */
    bsr.s open
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL:         bsr.s   set_attr */
    bsr.s set_attr
/* QL:         bra.s   chk_ok */
    bra.s chk_ok
/* QL: ut_con */
ut_con:
/* QL:         bsr.s   open_wnd */
    bsr.s open_wnd
/* QL:         dc.w    3,'con' */
.balign 2,0
dc_anchor_243:
.word 3
.byte 99,111,110
.balign 2,0
/* QL: go_scr */
go_scr:
/* QL:         bsr.s   open_wnd */
    bsr.s open_wnd
/* QL:         dc.w    3,'scr' */
.balign 2,0
dc_anchor_253:
.word 3
.byte 115,99,114
.balign 2,0
/* QL: * Oh bother! The latest TK2 wants to jump 6 on from the ut.scr vector to get */
/* QL: * this code that does the window redefinition. Naturally enough, it doesn't */
/* QL: * want to re-open the channels: they are the magic ones. Hence the following: */
/* QL: ut_scr */
ut_scr:
/* QL:         bra.s   go_scr */
    bra.s go_scr
/* QL: open_wnd */
open_wnd:
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         bsr.s   open */
    bsr.s open
/* QL: * TK2 comes in here */
/* QL:         bsr.s   ut_wrdef */
    bsr.s ut_wrdef
/* QL: chk_ok */
chk_ok:
/* QL:         beq.s   ret */
    beq.s ret
/* QL:         moveq   #io.close,d0 */
    moveq #io.close,d0
/* QL:         trap    #2 */
    trap #2
/* QL:         move.l  d2,d0           copy of error went to d2 */
    move.l d2,d0
/* QL: ret */
ret:
/* QL:         rts */
    rts 
/* QL: ut_wrdef */
ut_wrdef:
/* QL:         addq.l  #4,a1           move to window definition */
    addq.l #4,a1
/* QL:         moveq   #sd.wdef,d0     set window size */
    moveq #sd.wdef,d0
/* QL:         moveq   #0,d2           remove any existing border */
    moveq #0,d2
/* QL:         bsr.s   trap3 */
    bsr.s trap3
/* QL: set_attr */
set_attr:
/* QL:         moveq   #sd.setin,d0    set ink */
    moveq #sd.setin,d0
/* QL:         bsr.s   trap3d */
    bsr.s trap3d
/* QL:         moveq   #sd.setpa,d0    set paper */
    moveq #sd.setpa,d0
/* QL:         bsr.s   trap3d */
    bsr.s trap3d
/* QL:         moveq   #sd.setst,d0    set strip */
    moveq #sd.setst,d0
/* QL:         move.b  (a1),d1 */
    move.b (a1),d1
/* QL:         bsr.s   trap3 */
    bsr.s trap3
/* QL:         moveq   #sd.bordr,d0    set border */
    moveq #sd.bordr,d0
/* QL:         move.b  -(a1),d2        (if we get here, d2.l has been zeroed) */
    move.b -(a1),d2
/* QL:         bsr.s   trap3d */
    bsr.s trap3d
/* QL:         moveq   #sd.clear,d0    clear screen without a border */
    moveq #sd.clear,d0
/* QL:         bsr.s   trap3 */
    bsr.s trap3
/* QL:         rts     N.B. must keep bsr and rts, in case of error causing addq #4,sp */
    rts 
/* QL: open */
open:
/* QL:         move.l  a1,-(sp)        save parameter pointer */
    move.l a1,-(sp)
/* QL:         moveq   #io.open,d0 */
    moveq #io.open,d0
/* QL:         moveq   #-1,d1          for this job */
    moveq #(-1),d1
/* QL:         moveq   #0,d3           old/exclusive */
    moveq #0,d3
/* QL:         trap    #2              ... do it */
    trap #2
/* QL:         bra.s   trap_tst */
    bra.s trap_tst
/* QL: trap3d */
trap3d:
/* QL:         move.b  -(a1),d1 */
    move.b -(a1),d1
/* QL: trap3 */
trap3:
/* QL:         move.l  a1,-(sp)        save parameter pointer */
    move.l a1,-(sp)
/* QL:         trap    #3 */
    trap #3
/* QL: trap_tst */
trap_tst:
/* QL:         move.l  (sp)+,a1        restore parameter pointer */
    move.l (sp)+,a1
/* QL:         move.l  d0,d2           check error return + save it + ok d2 for bordr */
    move.l d0,d2
/* QL:         beq.s   trap_xit */
    beq.s trap_xit
/* QL:         addq.l  #4,sp           remove return */
    addq.l #4,sp
/* QL: trap_xit */
trap_xit:
/* QL:         rts */
    rts 
/* QL:         end */
