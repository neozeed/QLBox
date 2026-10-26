/* Generated from original/M/sd/entry.asm */
/* QL: * Screen driver general entry point */
/* QL:         xdef    sd_entry */
.globl sd_entry
/* QL:         xref    sd_chchk,sd_curt */
/* QL:         xref    cs_char */
/* QL: * + lots of other "xref"'s from the macro below */
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
/* QL:         section sd_entry */
.section sd_entry,"ax"
/* QL: * d0 cr  control parameter / error flag */
/* QL: * a3   s scratch (except for sbyte and extop keys) */
/* QL: * ...... any others used by called routines */
/* QL: reglist reg     d0-d2   need to save when adjusting the cursor */
/* QL: sd_entry */
sd_entry:
/* QL:         pea     exit            normally we just test d0 on return */
    pea exit(pc)
/* QL:         tst.b   sd_curf(a0)     check if cursor is visible */
    tst.b sd_curf(a0)
/* QL:         ble.s   branch          no - then that's it */
    ble.s branch
/* QL:         addq.l  #rest-exit,(sp) we want to check the cursor on return */
.word 20631|((((rest-exit))&7)<<9)
/* QL:         movem.l reglist,-(sp)   save call parameters */
    movem.l d0-d2,-(sp)
/* QL:         jsr     sd_curt(pc)     hide cursor */
    jsr sd_curt(pc)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d2
/* QL: branch */
branch:
/* QL:         subq.b  #io.sbyte,d0    check if write a character */
    subq.b #io.sbyte,d0
/* QL:         bne.s   range           no - go do all the others */
    bne.s range
/* QL: * This used to be the sd_wchar routine. */
/* QL: * Having it in here makes it a little quicker, as we cut out the long jumping, */
/* QL: * we know no one else uses it and we can see it doesn't care about d0 on entry. */
/* QL: * d0   s                    x position */
/* QL: * d1 c s character          y position */
/* QL: * d2   s                    character */
/* QL: * d3   s                    attributes */
/* QL: * a0 c   address of control block */
/* QL: * a1   s                    colour masks */
/* QL: * a2   s                    pointer to fount */
/* QL: * a3   s                    pointer to fount */
/* QL:         jsr     sd_chchk(pc)    check if room for character */
    jsr sd_chchk(pc)
/* QL:         bne.s   anrts */
    bne.s anrts
/* QL:         move.b  d1,d2           put character in position required */
    move.b d1,d2
/* QL:         move.l  sd_xmin(a0),d0  get position of top lhs */
    move.l sd_xmin(a0),d0
/* QL:         add.l   sd_xpos(a0),d0  ... then cursor position */
    add.l sd_xpos(a0),d0
/* QL:         move.w  d0,d1           ... and put them in the right position */
    move.w d0,d1
/* QL:         swap    d0 */
    swap d0
/* QL:         move.b  sd_cattr(a0),d3 set attributes */
    move.b sd_cattr(a0),d3
/* QL:         lea     sd_smask(a0),a1 ... colours */
    lea sd_smask(a0),a1
/* QL:         movem.l sd_font(a0),a2/a3 ... and font */
    movem.l sd_font(a0),a2/a3
/* QL:         pea     sd_ncol(pc)     move to next column on return */
    pea sd_ncol(pc)
/* QL:         jmp     cs_char(pc)     go do the character */
    jmp cs_char(pc)
/* QL: * Rest of the code for other sd entries */
/* QL: range */
range:
/* QL:         subq.b  #sd.extop-io.sbyte,d0 is it an extended operation? */
.word 20736|((((sd.extop-io.sbyte))&7)<<9)
/* QL:         beq.s   extop           yes - go do it */
    beq.s extop
/* QL:         cmp.b   #(top-bot)/2,d0 is it in our table? */
    cmp.b #(((top-bot)/2)&255),d0
/* QL:         bhi.s   error           no - that's bad */
    bhi.s error
/* QL:         add.b   d0,d0           d0 addresses words */
    add.b d0,d0
/* QL:         move.w  bot-2(pc,d0.w),a3 load entry offset */
    move.w (bot-2)(pc,d0.w),a3
/* QL:         lsr.b   #1,d0           restore d0 */
    lsr.b #1,d0
/* QL:         add.b   #sd.extop,d0    ... */
    add.b #(sd.extop&255),d0
/* QL:         jmp     bot(pc,a3.w)    call appropriate subroutine */
.word 0x4efb
.word 45056|((bot-.)&255)
/* QL: extop */
extop:
/* QL:         moveq   #sd.extop,d0    put d0 back, just in case it's wanted */
    moveq #sd.extop,d0
/* QL:         jmp     (a2)            extended operation */
    jmp (a2)
/* QL: cure */
cure:
/* QL:         movem.l reglist,-(sp)   save ds */
    movem.l d0-d2,-(sp)
/* QL:         jsr     sd_cure(pc)     make cursor visible */
    jsr sd_cure(pc)
/* QL:         movem.l (sp)+,reglist   restore ds */
    movem.l (sp)+,d0-d2
/* QL: exit */
exit:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: anrts */
anrts:
/* QL:         rts */
    rts 
/* QL: rest */
rest:
/* QL:         tst.b   sd_curf(a0)     has cursor been made invisible now? */
    tst.b sd_curf(a0)
/* QL:         bge.s   exit            yes - leave it off */
    bge.s exit
/* QL:         tst.l   d0              was there an error? */
    tst.l d0
/* QL:         beq.s   cure            no - go enable the cursor */
    beq.s cure
/* QL:         rts                     yes - leave the cursor as is */
    rts 
/* QL: error */
error:
/* QL:         addq.l  #4,sp           forget the call ... */
    addq.l #4,sp
/* QL:         moveq   #err.bp,d0      ... as we're setting an error code */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: * Set up the vector table for the sd/gw routines */
/* QL: t       macro */
/* QL: bot */
bot:
/* QL:  t                   sd_pxenq sd_chenq sd_bordr sd_wdef  sd_cure  sd_curs  ;0f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_421:
.word ((sd_pxenq-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_432:
.word ((sd_chenq-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_443:
.word ((sd_bordr-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_454:
.word ((sd_wdef-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_465:
.word ((sd_cure-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_476:
.word ((sd_curs-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_pos   sd_tab   sd_nl    sd_pcol  sd_ncol  sd_prow  sd_nrow  sd_pixp  ;17 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_490:
.word ((sd_pos-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_501:
.word ((sd_tab-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_512:
.word ((sd_nl-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_523:
.word ((sd_pcol-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_534:
.word ((sd_ncol-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_545:
.word ((sd_prow-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_556:
.word ((sd_nrow-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_567:
.word ((sd_pixp-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_scrol sd_scrol sd_scrol sd_pan   error    error    sd_pan   sd_pan   ;1f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_581:
.word ((sd_scrol-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_592:
.word ((sd_scrol-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_603:
.word ((sd_scrol-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_614:
.word ((sd_pan-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_624:
.word ((error-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_634:
.word ((error-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_645:
.word ((sd_pan-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_656:
.word ((sd_pan-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_clear sd_clrxx sd_clrxx sd_clrxx sd_clrxx sd_setfo sd_recol sd_setco ;27 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_670:
.word ((sd_clear-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_681:
.word ((sd_clrxx-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_692:
.word ((sd_clrxx-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_703:
.word ((sd_clrxx-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_714:
.word ((sd_clrxx-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_725:
.word ((sd_setfo-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_736:
.word ((sd_recol-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_747:
.word ((sd_setco-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_setco sd_setco sd_setfl sd_setul sd_setmd sd_setsz sd_fill  sd_donl  ;2f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_761:
.word ((sd_setco-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_772:
.word ((sd_setco-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_783:
.word ((sd_setfl-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_794:
.word ((sd_setul-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_805:
.word ((sd_setmd-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_816:
.word ((sd_setsz-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_827:
.word ((sd_fill-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_838:
.word ((sd_donl-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t gw_fig   gw_fig   gw_fig   gw_fig   gw_scale gw_flood gw_gcur           ;36 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_852:
.word ((gw_fig-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_863:
.word ((gw_fig-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_874:
.word ((gw_fig-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_885:
.word ((gw_fig-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_896:
.word ((gw_scale-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_907:
.word ((gw_flood-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-bot */
.balign 2,0
dc_anchor_918:
.word ((gw_gcur-bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: top */
top:
/* QL:         end */
