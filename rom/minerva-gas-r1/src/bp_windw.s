/* Generated from original/M/bp/windw.asm */
/* QL: * General basic window operations */
/* QL:         xdef    bp_at,bp_block,bp_bordr,bp_cls,bp_csize,bp_cursr */
.globl bp_at,bp_block,bp_bordr,bp_cls,bp_csize,bp_cursr
/* QL:         xdef    bp_fill,bp_flash,bp_ink,bp_over,bp_pan,bp_paper,bp_recol */
.globl bp_fill,bp_flash,bp_ink,bp_over,bp_pan,bp_paper,bp_recol
/* QL:         xdef    bp_scrol,bp_strip,bp_under,bp_width,bp_windw */
.globl bp_scrol,bp_strip,bp_under,bp_width,bp_windw
/* QL:         xref    bp_chan,bp_gcur,bp_lsqzp */
/* QL:         xref    ca_gtint,ca_gtli1 */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         include 'win1_m_inc_bv' */
/* QL: * pointers to basic variable lists and stacks */
/* QL:          nolist */
/* QL:         offset  0 */
/* QL: bv_start ; start of area and pointers */
.equ bv_start,0
/* QL: bv_bfbas ds.l   1       buffer base */
.equ bv_bfbas,0
/* QL: bv_bfp  ds.l    1       buffer running pointer */
.equ bv_bfp,4
/* QL: bv_tkbas ds.l   1       token list */
.equ bv_tkbas,8
/* QL: bv_tkp  ds.l    1 */
.equ bv_tkp,12
/* QL: bv_pfbas ds.l   1       program file */
.equ bv_pfbas,16
/* QL: bv_pfp  ds.l    1 */
.equ bv_pfp,20
/* QL: bv_ntbas ds.l   1       name table */
.equ bv_ntbas,24
/* QL: bv_ntp  ds.l    1 */
.equ bv_ntp,28
/* QL: bv_nlbas ds.l   1       name list */
.equ bv_nlbas,32
/* QL: bv_nlp  ds.l    1 */
.equ bv_nlp,36
/* QL: bv_vvbas ds.l   1       variable values */
.equ bv_vvbas,40
/* QL: bv_vvp  ds.l    1 */
.equ bv_vvp,44
/* QL: bv_chbas ds.l   1       channel table */
.equ bv_chbas,48
/* QL: bv_chp  ds.l    1 */
.equ bv_chp,52
/* QL: bv_rtbas ds.l   1       return table */
.equ bv_rtbas,56
/* QL: bv_rtp  ds.l    1 */
.equ bv_rtp,60
/* QL: bv_lnbas ds.l   1       line number table */
.equ bv_lnbas,64
/* QL: bv_lnp  ds.l    1 */
.equ bv_lnp,68
/* QL: bv_chang ; change of direction marker */
.equ bv_chang,72
/* QL: bv_btp  ds.l    1       backtrack stack during parsing */
.equ bv_btp,72
/* QL: bv_btbas ds.l   1 */
.equ bv_btbas,76
/* QL: bv_tgp  ds.l    1       temporary graph stack during parsing */
.equ bv_tgp,80
/* QL: bv_tgbas ds.l   1 */
.equ bv_tgbas,84
/* QL: bv_rip  ds.l    1       arithmetic stack */
.equ bv_rip,88
/* QL: bv_ribas ds.l   1 */
.equ bv_ribas,92
/* QL: bv_ssp  ds.l    1       system stack (real one!) */
.equ bv_ssp,96
/* QL: bv_ssbas ds.l   1 */
.equ bv_ssbas,100
/* QL: bv_endpt equ *-4 last of pointers */
.equ bv_endpt,(104-4)
/* QL: bv_linum ds.w   1       current line number */
.equ bv_linum,104
/* QL: bv_lengt ds.w   1       current length */
.equ bv_lengt,106
/* QL: bv_stmnt ds.b   1       current statement on line */
.equ bv_stmnt,108
/* QL: bv_cont ds.b    1       continue ($80) or stop (0) processing */
.equ bv_cont,109
/* QL: bv_inlin ds.b   1       in-line clause (1=loop or $ff=other) or not (0) */
.equ bv_inlin,110
/* QL: bv_sing ds.b    1       single line execution on ($ff) or off (0) */
.equ bv_sing,111
/* QL: bv_index ds.w   1       name tab row of last inline loop index read */
.equ bv_index,112
/* QL: bv_vvfre ds.l   1       first free space in vvtable */
.equ bv_vvfre,114
/* QL: bv_sssav ds.l   1       saved sp for out of memory to go back to */
.equ bv_sssav,118
/* QL:         ds.w    1       spare */
/* QL: bv_uproc ds.l   1       if sign set, rest is address of user trace procedure */
.equ bv_uproc,124
/* QL: bv_rand ds.l    1       random number */
.equ bv_rand,128
/* QL: bv_comch ds.l   1       command channel */
.equ bv_comch,132
/* QL: bv_nxlin ds.w   1       which line number to start after */
.equ bv_nxlin,136
/* QL: bv_nxstm ds.b   1       which statement to start after */
.equ bv_nxstm,138
/* QL: bv_comln ds.b   1       command line save ($ff) or not (0) */
.equ bv_comln,139
/* QL: bv_stopn ds.w   1       which stop number set */
.equ bv_stopn,140
/* QL: bv_edit ds.b    1       program has been edited ($ff) or not (0) */
.equ bv_edit,142
/* QL: bv_brk  ds.b    1       there has been a break (0) or not ($80) */
.equ bv_brk,143
/* QL: bv_unrvl ds.b   1       need to unravel ($ff) or not (0) */
.equ bv_unrvl,144
/* QL: bv_cnstm ds.b   1       statement to continue from */
.equ bv_cnstm,145
/* QL: bv_cnlno ds.w   1       line to continue from */
.equ bv_cnlno,146
/* QL: bv_dalno ds.w   1       current data line number */
.equ bv_dalno,148
/* QL: bv_dastm ds.b   1       current data statement number */
.equ bv_dastm,150
/* QL: bv_daitm ds.b   1       next data item to read */
.equ bv_daitm,151
/* QL: bv_cnind ds.w   1       inline loop index to continue with */
.equ bv_cnind,152
/* QL: bv_cninl ds.b   1       inline loop flag for continue */
.equ bv_cninl,154
/* QL: bv_lsany ds.b   1       whether checking list ($ff) or not (0) */
.equ bv_lsany,155
/* QL: bv_lsbef ds.w   1       invisible top line */
.equ bv_lsbef,156
/* QL: bv_lsbas ds.w   1       bottom line in window */
.equ bv_lsbas,158
/* QL: bv_lsaft ds.w   1       invisible bottom line */
.equ bv_lsaft,160
/* QL: bv_lenln ds.w   1       length of window line */
.equ bv_lenln,162
/* QL: bv_maxln ds.w   1       max number of window lines */
.equ bv_maxln,164
/* QL: * Note. the 2 following words will be overwritten on changing lenln and maxln: */
/* QL: bv_totln ds.w   1       number of window lines so far */
.equ bv_totln,166
/* QL:         ds.w    1       spare, but see above */
/* QL: bv_auto ds.b    1       whether auto/edit on ($ff) or off (0) */
.equ bv_auto,170
/* QL: bv_print ds.b   1       print from prtok ($ff) or leave in buffer (0) */
.equ bv_print,171
/* QL: bv_edlin ds.w   1       line number to edit next */
.equ bv_edlin,172
/* QL: bv_edinc ds.w   1       increment on auto edit range (+ve) or not auto (0) */
.equ bv_edinc,174
/* QL:         ds.l    1       bv_tkpos position of a4 in tklist on entry to proc */
/* QL:         ds.l    1       bv_ptemp temporary pointer for go_proc */
/* QL: bv_undo ds.b    1       undo rt stack immediately then redo procedure */
.equ bv_undo,184
/* QL: bv_arrow ds.b   1       up ($ff), down (1) or no (0) arrow on last line read */
.equ bv_arrow,185
/* QL: bv_lsfil ds.w   1       fill window when relisting at least to here */
.equ bv_lsfil,186
/* QL: bv_wrlno ds.w   1       when error line number */
.equ bv_wrlno,188
/* QL: bv_wrstm ds.b   1       statement */
.equ bv_wrstm,190
/* QL: bv_wrinl ds.b   1       inline ($ff) or not (0) */
.equ bv_wrinl,191
/* QL: bv_wherr ds.b   1       processing ($80) or not (0) */
.equ bv_wherr,192
/* QL: bv_erstm ds.b   1       last error statement (new, wa spare, we hope) */
.equ bv_erstm,193
/* QL: bv_error ds.l   1       last error number */
.equ bv_error,194
/* QL: bv_erlin ds.w   1       last error line */
.equ bv_erlin,198
/* QL: bv_wvnum ds.w   1       number of watched variables */
.equ bv_wvnum,200
/* QL: bv_wvbas ds.l   1       base of wv area wrt vvbas */
.equ bv_wvbas,202
/* QL:         ds.w    1       bv_lblen now spare, was used by fastload? */
/* QL:         ds.l    1       bv_lbuff now spare, ditto */
/* QL: bv_toe  ds.b    1       turn off enhancements: bit 7 int toks (was bv_filst) */
.equ bv_toe,212
/* QL:         ds.b    11      spare */
/* QL: bv_alchp ds.l   1       TK2 linked common heap allocations */
.equ bv_alchp,224
/* QL:         ds.l    2       spare */
/* QL: bv_qlibx ds.l   1       Qliberator stuff */
.equ bv_qlibx,236
/* QL:         ds.l    2       spare */
/* QL: bv_qliby ds.l   1       qliberator again! */
.equ bv_qliby,248
/* QL:         ds.l    1       spare */
/* QL: bv_end ; top of bv area */
.equ bv_end,256
/* QL:          list */
/* QL:         include 'win1_m_inc_choff' */
/* QL: * offsets in basic channel definition block */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: ch.id   ds.l    1       channel id */
.equ ch.id,0
/* QL: ch.ccpy ds.w    3       current cursor position, y (float) */
.equ ch.ccpy,4
/* QL: ch.ccpx ds.w    3       current cursor position, x (float) */
.equ ch.ccpx,10
/* QL: ch.angle ds.w   3       turtle angle (float) */
.equ ch.angle,16
/* QL: ch.pen  ds.b    1       pen status (up or down) */
.equ ch.pen,22
/* QL:         ds.b    9       spare */
/* QL: ch.chpos ds.w   1       character position on line */
.equ ch.chpos,32
/* QL: ch.width ds.w   1       width of line in characters */
.equ ch.width,34
/* QL: ch.spare ds.l   1       spare */
.equ ch.spare,36
/* QL: ch.lench ; length of a channel definition block */
.equ ch.lench,40
/* QL:         list */
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
/* QL:         section bp_windw */
.section bp_windw,"ax"
/* QL: * Colour parameter generator. */
/* QL: * Takes 1 to 3 items from stack and produces a byte containing colour */
/* QL: * information in the standard format. No return on error. */
/* QL: colour */
colour:
/* QL:         bsr.s   pickup          get final parameter */
    bsr.s pickup
/* QL:         move.w  d2,d1 */
    move.w d2,d1
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         beq.s   chk_256         if one parameter then exit */
    beq.s chk_256
/* QL:         moveq   #8,d0 */
    moveq #8,d0
/* QL:         cmp.w   d0,d1 */
    cmp.w d0,d1
/* QL:         bcc.s   err_pop         error if not in 0..7 */
    bcc.s err_pop
/* QL:         moveq   #3<<3,d2        default stipple is three */
    moveq #(3<<3),d2
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         beq.s   col_2p          only two parameters */
    beq.s col_2p
/* QL:         lsl.w   #3,d1           last was actually stipple pattern, shift it */
    lsl.w #3,d1
/* QL:         bsr.s   pickup          get contrast colour */
    bsr.s pickup
/* QL:         bcc.s   err_pop         error if not in 0..7 */
    bcc.s err_pop
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bne.s   err_pop         error if not 1..3 parameters */
    bne.s err_pop
/* QL: col_2p */
col_2p:
/* QL:         or.w    d2,d1           combine stipple and colour */
    or.w d2,d1
/* QL:         bsr.s   pickup          get background colour */
    bsr.s pickup
/* QL:         bcc.s   err_pop */
    bcc.s err_pop
/* QL:         eor.w   d2,d1 */
    eor.w d2,d1
/* QL:         lsl.w   #3,d1 */
    lsl.w #3,d1
/* QL:         or.w    d2,d1           bodge background in */
    or.w d2,d1
/* QL: chk_256 */
chk_256:
/* QL:         cmp.w   #256,d1         check single parameter 0..255 or stipple 0..3 */
    cmp.w #256,d1
/* QL:         bcs.s   rts0 */
    bcs.s rts0
/* QL: err_pop */
err_pop:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: pop_ret */
pop_ret:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * BLOCK{#chan;}width,height,x,y{,<colour>} */
/* QL: bp_block */
bp_block:
/* QL:         moveq   #sd.fill-sd.bordr,d7     fill a block */
    moveq #(sd.fill-sd.bordr),d7
/* QL: * BORDER{#chan;}{border{,<colour>}} */
/* QL: bp_bordr */
bp_bordr:
/* QL:         subq.b  #sd.wdef-sd.bordr,d7 redefine a border only */
.word 20743|((((sd.wdef-sd.bordr))&7)<<9)
/* QL: * WINDOW{#chan;}width,height,x,y{,border{,<colour>}} */
/* QL: bp_windw */
bp_windw:
/* QL:         bsr.s   iparm */
    bsr.s iparm
/* QL:         moveq   #0,d2           default width is zero */
    moveq #0,d2
/* QL:         moveq   #-128,d1        default colour is transparent (BLOCK=black) */
    moveq #(-128),d1
/* QL:         add.b   #sd.wdef,d7 */
    add.b #(sd.wdef&255),d7
/* QL:         bcs.s   brdr */
    bcs.s brdr
/* QL:         subq.w  #4,d3 */
    subq.w #4,d3
/* QL:         beq.s   blk_mod */
    beq.s blk_mod
/* QL:         assert  0,1-1&sd.wdef,1&sd.fill */
/* original assertion: 0,1-1&sd.wdef,1&sd.fill */
/* QL:         btst    d2,d7 */
    btst d2,d7
/* QL:         bne.s   brdr */
    bne.s brdr
/* QL:         bsr.s   colour */
    bsr.s colour
/* QL:         bra.s   blk_mod */
    bra.s blk_mod
/* QL: brdr */
brdr:
/* QL:         subq.w  #1,d3           correct range for colour parameters */
    subq.w #1,d3
/* QL:         bcs.s   blk_mod         if no parameters, full default */
    bcs.s blk_mod
/* QL:         beq.s   bord_w          if no colour then 'transparent' */
    beq.s bord_w
/* QL:         bsr.s   colour          get colour */
    bsr.s colour
/* QL: bord_w */
bord_w:
/* QL:         bsr.s   pickup          get width */
    bsr.s pickup
/* QL: blk_mod */
blk_mod:
/* QL:         subq.l  #4*2,a1 */
    subq.l #(4*2),a1
/* QL:         bra.s   trap4d7 */
    bra.s trap4d7
/* QL: pickup */
pickup:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  0(a6,a1.l),d2   get contrast/background colour */
    move.w 0(a6,a1.l),d2
/* QL:         cmp.w   d0,d2 */
    cmp.w d0,d2
/* QL:         rts */
    rts 
/* QL: * RECOL{#chan;}p0,p1,p2,p3,p4,p5,p6,p7 pn are replacement colours for colour n */
/* QL: bp_recol */
bp_recol:
/* QL:         bsr.s   iparm */
    bsr.s iparm
/* QL:         subq.w  #8,d3           must have 8 parameters */
    subq.w #8,d3
/* QL:         bne.s   err_bp */
    bne.s err_bp
/* QL:         move.l  a1,a2 */
    move.l a1,a2
/* QL:         moveq   #8-1,d0 */
    moveq #(8-1),d0
/* QL: tr_loop */
tr_loop:
/* QL:         subq.l  #2,a2 */
    subq.l #2,a2
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  1(a6,a2.l),0(a6,a1.l) compress words to bytes */
    move.b 1(a6,a2.l),0(a6,a1.l)
/* QL:         dbra    d0,tr_loop */
    dbra d0,tr_loop
/* QL:         moveq   #sd.recol,d7 */
    moveq #sd.recol,d7
/* QL: trap4d7 */
trap4d7:
/* QL:         trap    #4              it's rel a6 (all bar BORDER need this) */
    trap #4
/* QL:         bra.s   trap3d7 */
    bra.s trap3d7
/* QL: * WIDTH{#chan;}charsperline */
/* QL: bp_width */
bp_width:
/* QL:         bsr.s   iparm           get integer parameters */
    bsr.s iparm
/* QL:         subq.w  #1,d3           ... just one */
    subq.w #1,d3
/* QL:         bne.s   err_bp */
    bne.s err_bp
/* QL:         move.w  d2,ch.width(a6,a2.l) set width */
    move.w d2,ch.width(a6,a2.l)
/* QL:         rts */
    rts 
/* QL: * PAPER{#chan;}<colour> */
/* QL: bp_paper */
bp_paper:
/* QL:         subq.b  #sd.setin-sd.setpa,d7 */
.word 20743|((((sd.setin-sd.setpa))&7)<<9)
/* QL: * INK{#chan;}<colour> */
/* QL: bp_ink */
bp_ink:
/* QL:         addq.b  #sd.setin-sd.setst,d7 */
.word 20487|((((sd.setin-sd.setst))&7)<<9)
/* QL: * STRIP{#chan;}<colour> */
/* QL: bp_strip */
bp_strip:
/* QL:         bsr.s   iparm */
    bsr.s iparm
/* QL:         bsr.l   colour          turn parameter(s) into colour */
    bsr.w colour
/* QL: setxx */
setxx:
/* QL:         moveq   #sd.setst,d0    if paper ... */
    moveq #sd.setst,d0
/* QL:         add.b   d0,d7 */
    add.b d0,d7
/* QL:         bcc.s   trap3d7 */
    bcc.s trap3d7
/* QL:         bsr.s   trap3d0         ... do strip first */
    bsr.s trap3d0
/* QL: * d0 -  o- error code (ccr not set) */
/* QL: * d1 -i o- as per trap action */
/* QL: * d2 -i o- as per trap action */
/* QL: * d3 -  o- -1 */
/* QL: * d7 -ip - code for trap #3 */
/* QL: * a0 -ip - qdos channel id */
/* QL: * a1 -i  - as per trap action */
/* QL: trap3d7 */
trap3d7:
/* QL:         move.b  d7,d0           set operation key */
    move.b d7,d0
/* QL: trap3d0 */
trap3d0:
/* QL:         moveq   #-1,d3          infinite timeout */
    moveq #(-1),d3
/* QL:         trap    #3              perform it */
    trap #3
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code, with ccr set */
/* QL: * d1 -  o- last but one parameter */
/* QL: * d2 -  o- last parameter */
/* QL: * d3 -  o- number of parameters */
/* QL: * a0 -  o- qdos channel id */
/* QL: * a1 -  o- rel a6 pointer past last parameter */
/* QL: * a2 -  o- rel a6 pointer to channel table entry */
/* QL: * a3 -ip - start of nt entries for integer parameters */
/* QL: * a5 -ip - top of nt entries for integer parameters */
/* QL: iparm */
iparm:
/* QL:         jsr     bp_chan(pc)     get channel to a0 */
    jsr bp_chan(pc)
/* QL:         bne.s   popretne        error if it doesn't work */
    bne.s popretne
/* QL:         jsr     ca_gtint(pc)    call parameter routine */
    jsr ca_gtint(pc)
/* QL: popretne */
popretne:
/* QL:         bne.l   pop_ret         error if anything fails */
    bne.w pop_ret
/* QL:         add.l   d3,a1 */
    add.l d3,a1
/* QL:         add.l   d3,a1           point past last parameter */
    add.l d3,a1
/* QL:         movem.w -4(a6,a1.l),d1-d2 pick up last two parameters */
    movem.w (-4)(a6,a1.l),d1-d2
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: * OVER{#chan;}{flag} 0=ink on strip, 1=ink only, -1=ink xor (existing contents) */
/* QL: bp_over */
bp_over:
/* QL:         addq.b  #(sd.setmd-sd.setul)<<1!1,d7 */
.word 20487|((((((sd.setmd-sd.setul)<<1)|1))&7)<<9)
/* QL: * UNDER{#chan;}flag 0=off, 1=on. */
/* QL: bp_under */
bp_under:
/* QL:         addq.b  #(sd.setul-sd.setfl)<<1,d7 */
.word 20487|(((((sd.setul-sd.setfl)<<1))&7)<<9)
/* QL: * FLASH{#chan;}flag 0=off, 1=on. ignored in 512 mode. */
/* QL: bp_flash */
bp_flash:
/* QL:         addq.b  #(sd.setfl-sd.setst)<<1,d7 */
.word 20487|(((((sd.setfl-sd.setst)<<1))&7)<<9)
/* QL:         bsr.s   iparm */
    bsr.s iparm
/* QL:         move.w  d3,d1 */
    move.w d3,d1
/* QL:         beq.s   setxx */
    beq.s setxx
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bne.s   err_bp */
    bne.s err_bp
/* QL:         asr.b   #1,d7 */
    asr.b #1,d7
/* QL:         addx.b  d3,d3 */
    addx.b d3,d3
/* QL:         move.w  d2,d1 */
    move.w d2,d1
/* QL:         add.w   d3,d2 */
    add.w d3,d2
/* QL:         addq.w  #2,d3 */
    addq.w #2,d3
/* QL:         sub.w   d3,d2           error if not 0..1 or, for OVER, -1..1 */
    sub.w d3,d2
/* QL:         bcs.s   setxx */
    bcs.s setxx
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: * FILL{#chan;}parameter */
/* QL: bp_fill */
bp_fill:
/* QL:         jsr     bp_chan(pc)     get channel number, if any */
    jsr bp_chan(pc)
/* QL:         bne.s   rts1 */
    bne.s rts1
/* QL:         jsr     ca_gtli1(pc)    get a single long integer to d1 */
    jsr ca_gtli1(pc)
/* QL:         bne.s   rts1 */
    bne.s rts1
/* QL:         moveq   #sd.flood,d0 */
    moveq #sd.flood,d0
/* QL:         bra.s   trap3d0         go do it */
    bra.s trap3d0
/* QL: * CSIZE{#chan;}width,height width 0..3, height 0..1 */
/* QL: * Note: in 256 mode width 0 or 1 will appear as 2 and 3 respectively */
/* QL: bp_csize */
bp_csize:
/* QL:         moveq   #(sd.setsz-sd.pos)&255,d7 */
    moveq #((sd.setsz-sd.pos)&255),d7
/* QL: * AT{#chan;}row,column */
/* QL: bp_at */
bp_at:
/* QL:         subq.b  #(sd.pixp-sd.pos),d7 */
.word 20743|((((sd.pixp-sd.pos))&7)<<9)
/* QL: twopar */
twopar:
/* QL:         bsr.s   iparm */
    bsr.s iparm
/* QL:         subq.w  #2,d3 */
    subq.w #2,d3
/* QL: err_nebp */
err_nebp:
/* QL:         bne.s   err_bp          error if not two parameters */
    bne.s err_bp
/* QL:         add.b   #sd.pixp,d7     if it's AT ... */
    add.b #(sd.pixp&255),d7
/* QL:         bcc.s   trap3d7 */
    bcc.s trap3d7
/* QL:         exg     d1,d2           ... definition is reversed */
    exg d1,d2
/* QL: trap3d7a */
trap3d7a:
/* QL:         bra.s   trap3d7 */
    bra.s trap3d7
/* QL: * CURSOR{#chan;}{xgraph,ygraph,}xpixel,ypixel */
/* QL: bp_cursr */
bp_cursr:
/* QL:         lea     4*8(a3),a4      are there less than four params? */
    lea (4*8)(a3),a4
/* QL:         cmp.l   a4,a5           (2 or 3 is what we're after) */
    cmp.l a4,a5
/* QL:         blt.s   twopar          yes - it must be plain pixel position  */
    blt.s twopar
/* QL:         jmp     bp_gcur(pc)     no - go do graphics */
    jmp bp_gcur(pc)
/* QL: * PAN{#chan;}distance{,screen section} */
/* QL: * SCROLL{#chan;}distance{,screen section} */
/* QL: * CLS{#chan;}{screen section} */
/* QL: * distance may be positive or negative */
/* QL: * screen section may be:- */
/* QL: * 0: whole screen (default) */
/* QL: * 1: top of window (not pan) */
/* QL: * 2: bottom of window (not pan) */
/* QL: * 3: cursor line (not scroll) */
/* QL: * 4: right hand end of cursor line (not scroll) */
/* QL: bp_cls */
bp_cls:
/* QL:         moveq   #(sd.clear-sd.pan)<<1-1,d7 */
    moveq #(((sd.clear-sd.pan)<<1)-1),d7
/* QL: bp_pan */
bp_pan:
/* QL:         addq.b  #(sd.pan-sd.scrol)<<1,d7 */
.word 20487|(((((sd.pan-sd.scrol)<<1))&7)<<9)
/* QL: bp_scrol */
bp_scrol:
/* QL:         bsr.s   iparm           get distance to pan or scroll */
    bsr.s iparm
/* QL:         exg     d2,d0           get distance or part = last parameter (d2=0) */
    exg d2,d0
/* QL:         sub.w   d3,a1 */
    sub.w d3,a1
/* QL:         sub.w   d3,a1           back up to start of parameters */
    sub.w d3,a1
/* QL:         add.b   #sd.scrol<<1!1,d7 */
    add.b #(((sd.scrol<<1)|1)&255),d7
/* QL:         lsr.b   #1,d7 */
    lsr.b #1,d7
/* QL:         subx.w  d2,d3           insist on at least one parameter for pan/scroll */
    subx.w d2,d3
/* QL:         bcs.s   err_nebp */
    bcs.s err_nebp
/* QL:         movem.w 0(a6,a1.l),d1/d2 pick up one or two parameters */
    movem.w 0(a6,a1.l),d1/d2
/* QL:         subq.w  #1,d3           check if optional part parameter was present */
    subq.w #1,d3
/* QL:         bcs.s   chkls           ok if no option parameter */
    bcs.s chkls
/* QL:         add.b   d0,d7           add option to call byte */
    add.b d0,d7
/* QL: chkls */
chkls:
/* QL:         jsr     bp_lsqzp(pc)    if this is the list window, zap list info */
    jsr bp_lsqzp(pc)
/* QL:         bra.s   trap3d7a */
    bra.s trap3d7a
/* QL:         end */
