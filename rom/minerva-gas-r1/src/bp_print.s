/* Generated from original/M/bp/print.asm */
/* QL: * Print or input something, including arrays. Also the buffer read routine. */
/* QL:         xdef    bp_input,bp_print,bp_rdbuf */
.globl bp_input,bp_print,bp_rdbuf
/* QL:         xref    bp_arend,bp_arind,bp_arnxt,bp_arset,bp_chan,bp_let,bp_rdchk */
/* QL:         xref    bv_chbfx,bv_chri */
/* QL:         xref    ca_gtin1,ca_putss */
/* QL:         xref    cn_dtoi,cn_dtof,cn_ftod,cn_0tod */
/* QL:         xref    mm_mrtor */
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
/* QL:         include 'win1_m_inc_nt' */
/* QL: * name table types */
/* QL:         nolist */
/* QL: * First byte */
/* QL: t.unset equ     0       unset (null if 2nd byte zero) */
.equ t.unset,0
/* QL: t.intern equ    1       internal value held on ri stack */
.equ t.intern,1
/* QL: t.var   equ     2       simple variable */
.equ t.var,2
/* QL: t.arr   equ     3       array (substring if 2nd byte zero) */
.equ t.arr,3
/* QL: t.bpr   equ     4       basic procedure */
.equ t.bpr,4
/* QL: t.bfn   equ     5       basic function */
.equ t.bfn,5
/* QL: t.rep   equ     6       repeat loop index */
.equ t.rep,6
/* QL: t.for   equ     7       for loop index */
.equ t.for,7
/* QL: t.mcp   equ     8       machine code procedure */
.equ t.mcp,8
/* QL: t.mcf   equ     9       machine code function */
.equ t.mcf,9
/* QL: * Second byte */
/* QL: t.str   equ     1       2 byte positive string length + char {+ pad} */
.equ t.str,1
/* QL: t.fp    equ     2       6 byte floating point */
.equ t.fp,2
/* QL: t.int   equ     3       2 byte signed integer */
.equ t.int,3
/* QL: t.log   equ     4       2 byte 0=false 1=true (internal only) */
.equ t.log,4
/* QL: * Second word is name pointer. This is either the offset into the name list, or */
/* QL: * may be -1 if no name is applicable. */
/* QL: * Second longword is the value pointer. Generally this is an offset into the */
/* QL: * variable values area, or -1 to indicate an unset entry. */
/* QL: * For t.mcp/t.mcf this is the absolute entry point. */
/* QL: * For t.bpr/t.bfn the msw is the define line number. */
/* QL:  list */
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
/* QL:         include 'win1_m_inc_token' */
/* QL: * equates for tokens */
/* QL:         nolist */
/* QL: b.w.num setnum  0 */
/* QL: b.w.def macro */
/* QL: spc     b.w.def ; lsb is space count */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.spc,(0xffffff80|0)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.spc,(-32768)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: key     b.w.def end for if rep sel when def proc fn go keyto sub {} err {} {}  rstr next exit else on ret rmndr data dim loc let then step rem mist */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.key,(0xffffff80|1)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.key,(-32512)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.end,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.end,(1|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.for,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.for,(2|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.if,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.if,(3|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rep,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rep,(4|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sel,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sel,(5|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.when,6
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.when,(6|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.def,7
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.def,(7|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.proc,8
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.proc,(8|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.fn,9
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.fn,(9|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.go,10
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.go,(10|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.keyto,11
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.keyto,(11|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sub,12
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sub,(12|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.err,14
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.err,(14|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rstr,17
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rstr,(17|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.next,18
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.next,(18|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.exit,19
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.exit,(19|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.else,20
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.else,(20|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.on,21
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.on,(21|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.ret,22
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.ret,(22|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rmndr,23
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rmndr,(23|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.data,24
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.data,(24|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.dim,25
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.dim,(25|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.loc,26
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.loc,(26|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.let,27
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.let,(27|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.then,28
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.then,(28|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.step,29
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.step,(29|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.rem,30
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.rem,(30|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.mist,31
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.mist,(31|(-32512))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: bip     b.w.def ; built-in procedure - not used */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.bip,(0xffffff80|2)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.bip,(-32256)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: bif     b.w.def ; built-in function - not used */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.bif,(0xffffff80|3)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.bif,(-32000)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: sym     b.w.def equal colon hash symcom opar cpar obrc cbrc space eol */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.sym,(0xffffff80|4)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.sym,(-31744)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.equal,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.equal,(1|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.colon,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.colon,(2|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.hash,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.hash,(3|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.symcom,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.symcom,(4|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.opar,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.opar,(5|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.cpar,6
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.cpar,(6|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.obrc,7
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.obrc,(7|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.cbrc,8
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.cbrc,(8|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.space,9
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.space,(9|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.eol,10
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.eol,(10|(-31744))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: ops     b.w.def sum dif mul fdiv ge gt near eq ne le lt bor band bxor exp  join lor land lxor mod idiv instr */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.ops,(0xffffff80|5)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.ops,(-31488)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sum,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sum,(1|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.dif,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.dif,(2|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.mul,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.mul,(3|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.fdiv,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.fdiv,(4|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.ge,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.ge,(5|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.gt,6
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.gt,(6|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.near,7
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.near,(7|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.eq,8
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.eq,(8|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.ne,9
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.ne,(9|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.le,10
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.le,(10|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lt,11
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lt,(11|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.bor,12
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.bor,(12|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.band,13
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.band,(13|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.bxor,14
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.bxor,(14|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.exp,15
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.exp,(15|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.join,16
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.join,(16|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lor,17
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lor,(17|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.land,18
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.land,(18|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lxor,19
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lxor,(19|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.mod,20
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.mod,(20|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.idiv,21
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.idiv,(21|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.instr,22
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.instr,(22|(-31488))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: mon     b.w.def neg pos bnot lnot */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.mon,(0xffffff80|6)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.mon,(-31232)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.neg,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.neg,(1|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.pos,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.pos,(2|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.bnot,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.bnot,(3|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.lnot,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.lnot,(4|(-31232))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: syv     b.w.def ; system variable - not used */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.syv,(0xffffff80|7)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.syv,(-30976)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: nam     b.w.def ; 2nd word is name index */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.nam,(0xffffff80|8)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.nam,(-30720)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: shi     b.w.def ; lsb is signed integer */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.shi,(0xffffff80|9)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.shi,(-30464)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: lgi     b.w.def ; 2nd word is signed integer */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.lgi,(0xffffff80|10)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.lgi,(-30208)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: str     b.w.def ; 2nd word is length, followed by chars and padded to even */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.str,(0xffffff80|11)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.str,(-29952)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: txt     b.w.def ; as above */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.txt,(0xffffff80|12)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.txt,(-29696)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: lno     b.w.def ; 2nd word is strictly positive line number */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.lno,(0xffffff80|13)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.lno,(-29440)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL: sep     b.w.def sepcom semi back excl septo */
/* QL: b.[.lab] equ $ffffff80![b.w.num] */
.equ b.sep,(0xffffff80|14)
/* QL: m setnum b.[.lab]<<8 */
/* QL: w.[.lab] equ [m] */
.equ w.sep,(-29184)
/* QL:  ifnum [.nparms] = 0 goto x */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.sepcom,1
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.sepcom,(1|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.semi,2
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.semi,(2|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.back,3
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.back,(3|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.excl,4
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.excl,(4|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr {[.parm([i])]} = {} goto n */
/* QL: b.[.parm([i])] equ [i] */
.equ b.septo,5
/* QL: w.[.parm([i])] equ [i]!([m]) */
.equ w.septo,(5|(-29184))
/* QL: n maclab */
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: x maclab */
/* QL: b.w.num setnum [b.w.num]+1 */
/* QL:         list */
/* QL: * By default, I/O is to channel #1, but #<channel number> is accepted at any */
/* QL: * time, allowing output to several channels. */
/* QL: * Separators have the following effect: */
/* QL: * Comma         Tab to next 8 char position. If this is < 8 from end of edge */
/* QL: *                       of window or over edge of window, then do a line feed. */
/* QL: * Semicolon     Take no action. */
/* QL: * Backslash     Move to a new line. */
/* QL: * Exclamation   Ignored if at the start of a line. Otherwise, if there is room */
/* QL: *               on the line for a space and the next arg, print a space, */
/* QL: *               otherwise throw a line. */
/* QL: * TO <posn>     Space to the given position provided it's between here & end. */
/* QL: *                       (Any separator after <posn> will do, and is ignored.) */
/* QL: * A separator (except to) after an array will be appended to each element of */
/* QL: * the array. No separator after an array is taken to be new line. */
/* QL: * A substring is taken to be a small string rather than a set of characters */
/* QL: * E.g. 'print alphabet(2 TO 4),' gives bcd      not b       c       d */
/* QL: * Register usage: */
/* QL: * d0-d3 general */
/* QL: * d4.msw length left on line when actioning !, undefined otherwise */
/* QL: * d4.bits15..1 various irrelevent values */
/* QL: * d4.bit0 set if prior separator was !, and not at the start of a line */
/* QL: * d5.lsb separator type (0..5) * 16 */
/* QL: * d5.bit15: clear for to<null> or final arg is followed by to (input/edit) */
/* QL: * d5.msw: -1 */
/* QL: * d6 -ve or vv offset to index counter block (bp_arxxx routines) */
/* QL: * d7.bits31..16 destroyed, but could easily be saved/used */
/* QL: * d7.bits16..8 zero, not used at present */
/* QL: * d7.bit7 clear for input, set for print */
/* QL: * d7.bit6..1 must be kept 0 */
/* QL: * d7.bit0 set if chenq fails, i.e. not a scr/con */
/* QL: * a0 channel id */
/* QL: * a1 general */
/* QL: * a2 ch channel descriptor */
/* QL: * a3 nt argument */
/* QL: * a4 vv array descriptor, etc */
/* QL: * a5 nt top, not used a great deal */
/* QL: * (sp) remaining argument count */
/* QL:         section bp_print */
.section bp_print,"ax"
/* QL: bp_print */
bp_print:
/* QL:         tas     d7              set flag to say print in progress */
    tas d7
/* QL: bp_input */
bp_input:
/* QL:         jsr     bv_chri(pc)     make space on ri stack, in case of int/fp */
    jsr bv_chri(pc)
/* QL:         bra.s   restart */
    bra.s restart
/* QL: steparg */
steparg:
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         move.l  (sp)+,a5 */
    move.l (sp)+,a5
/* QL:         add.l   a3,a5 */
    add.l a3,a5
/* QL:         tst.l   d0              any errors? */
    tst.l d0
/* QL:         bne.s   rts0            yes - get out now */
    bne.s rts0
/* QL:         cmp.l   a3,a5           end of args yet? */
    cmp.l a3,a5
/* QL:         bgt.s   getarg          no - pick up next one */
    bgt.s getarg
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: sendnwl */
sendnwl:
/* QL:         bsr.s   nwlinle         no args between channels, insert a newline */
    bsr.s nwlinle
/* QL: restart */
restart:
/* QL:         jsr     bp_chan(pc)     get channel */
    jsr bp_chan(pc)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         moveq   #-128,d4        no pending ! seps (bit0 = 0) */
    moveq #(-128),d4
/* QL:         and.b   d4,d7 */
    and.b d4,d7
/* QL:         blt.s   chkemp          if print, wade in */
    blt.s chkemp
/* QL:         bsr.l   chenq           check for readonly */
    bsr.w chenq
/* QL: chkemp */
chkemp:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL: nwlinle */
nwlinle:
/* QL:         ble.l   nwlin           no args after channel, finish with newline */
    ble.w nwlin
/* QL:         tst.b   1(a6,a3.l) */
    tst.b 1(a6,a3.l)
/* QL:         bmi.s   sendnwl         imediately following #<chan>, so newline here */
    bmi.s sendnwl
/* QL: getarg */
getarg:
/* QL:         moveq   #-16,d5         no to<null> if bits 15..8 are set */
    moveq #(-16),d5
/* QL:         and.b   1(a6,a3.l),d5   get hash and seps */
    and.b 1(a6,a3.l),d5
/* QL:         bmi.s   restart         allow embedded channel selection! */
    bmi.s restart
/* QL:         sub.l   a3,a5 */
    sub.l a3,a5
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL:         move.l  a5,-(sp)        save remaining arg count * 8, after this one */
    move.l a5,-(sp)
/* QL:         sub.l   bv_chbas(a6),a2 ch is above vv, so we must be careful */
    sub.l bv_chbas(a6),a2
/* QL:         jsr     bp_arset(pc)    set up in case we need an array */
    jsr bp_arset(pc)
/* QL:         add.l   bv_chbas(a6),a2 put ch pointer back straight */
    add.l bv_chbas(a6),a2
/* QL:         clr.w   d2              make null arg look like a zero length string */
    clr.w d2
/* QL:         move.w  #$ff0f,d3       set up mask for null arguments */
    move.w #0xff0f,d3
/* QL:         and.w   d3,0(a6,a3.l)   lose seps */
    and.w d3,0(a6,a3.l)
/* QL:         beq.s   picked1         null argument */
    beq.s picked1
/* QL:         move.b  d7,d1           check if print ... */
    move.b d7,d1
/* QL:         or.b    2(a6,a3.l),d1   ... or an expression */
    or.b 2(a6,a3.l),d1
/* QL:         blt.s   pr_elt          if so, no funny to<null> allowed */
    blt.s pr_elt
/* QL:         cmp.b   #b.septo<<4,d5  is it to? */
    cmp.b #((b.septo<<4)&255),d5
/* QL:         bne.s   pr_elt          no, forget this bit */
    bne.s pr_elt
/* QL:         and.w   8(a6,a3.l),d3   is it followed by a null argument? */
    and.w 8(a6,a3.l),d3
/* QL:         bne.s   tonullw         no, but have a look for no arguments left  */
    bne.s tonullw
/* QL:         move.w  8(a6,a3.l),d5   leapfrog to next seps/type (syntax->hash=0) */
    move.w 8(a6,a3.l),d5
/* QL: tonullw */
tonullw:
/* QL:         tst.l   (sp)            was there another argument at all? */
    tst.l (sp)
/* QL:         bne.s   pr_elt          yes, so this is all OK */
    bne.s pr_elt
/* QL:         clr.w   d5              show as to<null> and no separator */
    clr.w d5
/* QL: pr_elt */
pr_elt:
/* QL:         jsr     bp_arind(pc)    if need be, index any array element */
    jsr bp_arind(pc)
/* QL:         clr.w   d2              set length to zero as a starter */
    clr.w d2
/* QL:         move.b  d7,d1 */
    move.b d7,d1
/* QL:         bgt.l   input           input from non-edit cannot edit */
    bgt.w input
/* QL:         or.b    2(a6,a3.l),d1   check for print or expression */
    or.b 2(a6,a3.l),d1
/* QL:         bmi.s   pickup          either needs value to be picked up */
    bmi.s pickup
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         bmi.s   picked          skip unless we had to<null> on editable input */
    bmi.s picked
/* QL: pickup */
pickup:
/* QL:         move.l  4(a6,a3.l),d1 */
    move.l 4(a6,a3.l),d1
/* QL:         bpl.s   valok           if value defined, all is OK */
    bpl.s valok
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         beq.s   picked          if input to undefined, start with null string */
    beq.s picked
/* QL:         move.l  bv_bfbas(a6),a1 */
    move.l bv_bfbas(a6),a1
/* QL:         move.b  #'*',0(a6,a1.l) if print, make undefined be "*" */
    move.b #(42&255),0(a6,a1.l)
/* QL:         addq.w  #1,d2 */
    addq.w #1,d2
/* QL: picked1 */
picked1:
/* QL:         bra.s   picked */
    bra.s picked
/* QL: valok */
valok:
/* QL:         move.l  bv_vvbas(a6),a1 */
    move.l bv_vvbas(a6),a1
/* QL:         cmp.b   #t.arr,0(a6,a3.l) only 1 dim (sub-)string arrays are left */
    cmp.b #(t.arr&255),0(a6,a3.l)
/* QL:         bne.s   picksimp */
    bne.s picksimp
/* QL:         add.l   a1,d1 */
    add.l a1,d1
/* QL:         movem.l 0(a6,d1.l),d1-d2 get vv offset and possible substring length */
    movem.l 0(a6,d1.l),d1-d2
/* QL: picksimp */
picksimp:
/* QL:         add.l   d1,a1 */
    add.l d1,a1
/* QL:         bsr.s   chktype */
    bsr.s chktype
/* QL:         bcs.s   intfp */
    bcs.s intfp
/* QL:         bpl.s   picked          =0, substring, length is ready */
    bpl.s picked
/* QL:         move.w  0(a6,a1.l),d2   =1, string, get length */
    move.w 0(a6,a1.l),d2
/* QL:         addq.l  #2,a1           step past length */
    addq.l #2,a1
/* QL:         bra.s   picked          do it */
    bra.s picked
/* QL: intfp */
intfp:
/* QL:         movem.w 0(a6,a1.l),d0-d2 get integer or fp */
    movem.w 0(a6,a1.l),d0-d2
/* QL:         move.l  bv_bfbas(a6),a0 where to put string */
    move.l bv_bfbas(a6),a0
/* QL:         bmi.s   itod */
    bmi.s itod
/* QL:         move.l  bv_rip(a6),a1   use ri stack for int, fp */
    move.l bv_rip(a6),a1
/* QL:         subq.l  #6,a1           will be reset next time so extra no matter */
    subq.l #6,a1
/* QL:         movem.w d0-d2,0(a6,a1.l) put on ri stack */
    movem.w d0-d2,0(a6,a1.l)
/* QL:         jsr     cn_ftod(pc)     =2, fp, convert float to string */
    jsr cn_ftod(pc)
/* QL:         bra.s   numlen          and write out a number */
    bra.s numlen
/* QL: itod */
itod:
/* QL:         jsr     cn_0tod(pc)     =3, integer, convert integer to string */
    jsr cn_0tod(pc)
/* QL: numlen */
numlen:
/* QL:         move.l  ch.id(a6,a2.l),a0 reload channel id */
    move.l ch.id(a6,a2.l),a0
/* QL:         move.l  bv_bfbas(a6),a1 start of ascii number */
    move.l bv_bfbas(a6),a1
/* QL:         move.w  d1,d2           length of ascii number */
    move.w d1,d2
/* QL: picked */
picked:
/* QL:         lsr.b   #1,d4           can I print arg straight away? */
    lsr.b #1,d4
/* QL:         bcc.s   addlen          yes, so do it */
    bcc.s addlen
/* QL:         move.l  a1,d3 */
    move.l a1,d3
/* QL:         bsr.l   excl_do         action a pending ! operation */
    bsr.w excl_do
/* QL:         move.l  d3,a1 */
    move.l d3,a1
/* QL: addlen */
addlen:
/* QL:         tst.w   0(a6,a3.l) */
    tst.w 0(a6,a3.l)
/* QL:         beq.s   end_arh         null argument requires nothing more */
    beq.s end_arh
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         blt.s   print           if print - go print it */
    blt.s print
/* QL:         tst.b   2(a6,a3.l) */
    tst.b 2(a6,a3.l)
/* QL:         bpl.s   input           non-expression is to be input */
    bpl.s input
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         bgt.s   end_arh         ignore expressions on non-edit input */
    bgt.s end_arh
/* QL: print */
print:
/* QL:         add.w   d2,ch.chpos(a6,a2.l) update the running cursor */
    add.w d2,ch.chpos(a6,a2.l)
/* QL:         bsr.l   sstrg */
    bsr.w sstrg
/* QL: end_arh */
end_arh:
/* QL:         bra.l   end_arg */
    bra.w end_arg
/* QL: chktype */
chktype:
/* QL:         move.b  1(a6,a3.l),d3 */
    move.b 1(a6,a3.l),d3
/* QL:         rol.b   #7,d3 */
    rol.b #7,d3
/* QL:         rts */
    rts 
/* QL: input */
input:
/* QL:         jsr     bp_rdchk(pc) */
    jsr bp_rdchk(pc)
/* QL:         bne.s   end_arh         can't read into this, so get out */
    bne.s end_arh
/* QL:         sub.l   bv_chbas(a6),a2 keep ch entry as offset for now */
    sub.l bv_chbas(a6),a2
/* QL:         move.w  d2,a4           save length and extend it to long */
    move.w d2,a4
/* QL:         move.l  a4,d1           space required in buffer */
    move.l a4,d1
/* QL:         bsr.s   chktype         have we just done a number */
    bsr.s chktype
/* QL:         bcs.s   inpnow          yes - initial text is already in basic buffer */
    bcs.s inpnow
/* QL:         sub.l   a3,a1           offset */
    sub.l a3,a1
/* QL:         sub.l   bv_ntbas(a6),a3 offset */
    sub.l bv_ntbas(a6),a3
/* QL:         jsr     bv_chbfx(pc)    ensure buffer has space for current string */
    jsr bv_chbfx(pc)
/* QL:         add.l   bv_ntbas(a6),a3 proper */
    add.l bv_ntbas(a6),a3
/* QL:         add.l   a3,a1           proper */
    add.l a3,a1
/* QL:         move.l  a4,d1           put back length */
    move.l a4,d1
/* QL:         move.l  a0,a4           save channel id */
    move.l a0,a4
/* QL:         move.l  bv_bfbas(a6),a0 trundle it off to the basic bf area */
    move.l bv_bfbas(a6),a0
/* QL:         jsr     mm_mrtor(pc)    using fast copy (purely 'cos of code saving) */
    jsr mm_mrtor(pc)
/* QL:         move.l  a4,a0           restore channel id */
    move.l a4,a0
/* QL: inpnow */
inpnow:
/* QL:         move.w  d1,d3           initial cursor at end of string */
    move.w d1,d3
/* QL:         add.l   bv_bfbas(a6),d1 */
    add.l bv_bfbas(a6),d1
/* QL:         move.l  d1,bv_bfp(a6)   set buffer top */
    move.l d1,bv_bfp(a6)
/* QL:         move.b  d7,d0           whether user can edit this input */
    move.b d7,d0
/* QL:         sub.l   bv_ntbas(a6),a3 keep arg offset */
    sub.l bv_ntbas(a6),a3
/* QL:         bsr.l   bp_rdbuf        read a line */
    bsr.w bp_rdbuf
/* QL:         add.l   bv_ntbas(a6),a3 reset arg */
    add.l bv_ntbas(a6),a3
/* QL:         bne.s   rderrd0 */
    bne.s rderrd0
/* QL:         subq.l  #1,a1           discard the terminator */
    subq.l #1,a1
/* QL:         assert  -1,err.nc */
/* original assertion: -1,err.nc */
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         cmp.b   #27,0(a6,a1.l)  was it terminated by an esc? */
    cmp.b #(27&255),0(a6,a1.l)
/* QL:         beq.s   rderrd3         yes - give back a "not complete" error */
    beq.s rderrd3
/* QL:         move.w  d7,-(sp) */
    move.w d7,-(sp)
/* QL:         move.l  a1,d7           save end of buffer */
    move.l a1,d7
/* QL:         moveq   #sd.pcol,d0     remove the line feed from the screen */
    moveq #sd.pcol,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         moveq   #sd.ncol,d0 */
    moveq #sd.ncol,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  bv_bfbas(a6),a4 source in a4 */
    move.l bv_bfbas(a6),a4
/* QL:         bsr.s   chktype */
    bsr.s chktype
/* QL:         bcc.s   putss */
    bcc.s putss
/* QL:         exg     a0,a4           save channel and get source in a0 */
    exg a4,a0
/* QL:         move.l  bv_rip(a6),a1   get ri pointer */
    move.l bv_rip(a6),a1
/* QL:         bmi.s   dtoi */
    bmi.s dtoi
/* QL:         jsr     cn_dtof(pc) */
    jsr cn_dtof(pc)
/* QL:         bra.s   chkri */
    bra.s chkri
/* QL: putss */
putss:
/* QL:         sub.w   a4,d7           data length read */
    sub.w a4,d7
/* QL:         move.w  d7,d1 */
    move.w d7,d1
/* QL:         jsr     ca_putss(pc) */
    jsr ca_putss(pc)
/* QL:         bra.s   ritovv */
    bra.s ritovv
/* QL: dtoi */
dtoi:
/* QL:         jsr     cn_dtoi(pc) */
    jsr cn_dtoi(pc)
/* QL: chkri */
chkri:
/* QL:         move.l  a4,a0           restore channel */
    move.l a4,a0
/* QL:         bne.s   restd7 */
    bne.s restd7
/* QL:         move.l  a1,bv_rip(a6) */
    move.l a1,bv_rip(a6)
/* QL: ritovv */
ritovv:
/* QL:         jsr     bp_let(pc) */
    jsr bp_let(pc)
/* QL: restd7 */
restd7:
/* QL:         move.w  (sp)+,d7        reload d7 */
    move.w (sp)+,d7
/* QL: rderrd0 */
rderrd0:
/* QL:         move.l  d0,d3 */
    move.l d0,d3
/* QL:         beq.s   resta2 */
    beq.s resta2
/* QL:         moveq   #sd.curs,d0     suppress the cursor */
    moveq #sd.curs,d0
/* QL:         bsr.s   trap3 */
    bsr.s trap3
/* QL: rderrd3 */
rderrd3:
/* QL:         move.l  d3,d0 */
    move.l d3,d0
/* QL: resta2 */
resta2:
/* QL:         add.l   bv_chbas(a6),a2 reset a2 */
    add.l bv_chbas(a6),a2
/* QL: end_arg */
end_arg:
/* QL:         bsr.s   sepmost         if no error, action null and !,\ separators */
    bsr.s sepmost
/* QL:         bne.s   droparr         if any error, go clean up any array */
    bne.s droparr
/* QL:         jsr     bp_arnxt(pc)    scan any array elements */
    jsr bp_arnxt(pc)
/* QL:         bgt.l   pr_elt          there were some left, so loop */
    bgt.w pr_elt
/* QL: droparr */
droparr:
/* QL:         jsr     bp_arend(pc)    discard any array index block */
    jsr bp_arend(pc)
/* QL:         bne.s   notto           some error about */
    bne.s notto
/* QL:         tst.w   d5              look at our to<null> flag */
    tst.w d5
/* QL:         bmi.s   notonul         if we haven't been using to<null>, no prob */
    bmi.s notonul
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         subq.l  #8,(sp)         get rid of the <null> (possible overrun is OK) */
    subq.l #8,(sp)
/* QL: notonul */
notonul:
/* QL:         cmp.b   #b.septo<<4,d5  are we on for a to? */
    cmp.b #((b.septo<<4)&255),d5
/* QL:         bne.s   notto           no - skip this */
    bne.s notto
/* QL:         subq.l  #8,(sp)         using up another argument */
    subq.l #8,(sp)
/* QL:         bsr.s   septo           action the to */
    bsr.s septo
/* QL: notto */
notto:
/* QL:         bra.l   steparg         go back up to the top */
    bra.w steparg
/* QL: oddsep */
oddsep:
/* QL:         subq.b  #b.back>>1,d0 */
    subq.b #(b.back>>1),d0
/* QL:         bne.s   okrts5 */
    bne.s okrts5
/* QL: nwlin */
nwlin:
/* QL:         tst.b   d7              is this input only? */
    tst.b d7
/* QL:         bgt.s   okrts5 */
    bgt.s okrts5
/* QL:         moveq   #10,d1 */
    moveq #10,d1
/* QL:         clr.w   ch.chpos(a6,a2.l) */
    clr.w ch.chpos(a6,a2.l)
/* QL: print_1 */
print_1:
/* QL:         moveq   #io.sbyte,d0 */
    moveq #io.sbyte,d0
/* QL: trap3 */
trap3:
/* QL:         move.l  d3,-(sp)        save d3 */
    move.l d3,-(sp)
/* QL:         moveq   #-1,d3          infinite timeout */
    moveq #(-1),d3
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  (sp)+,d3        restore d3 */
    move.l (sp)+,d3
/* QL:         bra.s   tstrts */
    bra.s tstrts
/* QL: excl_do */
excl_do:
/* QL:         swap    d4              arg preceded by an ! */
    swap d4
/* QL:         cmp.w   d2,d4           how much room is there left on the line? */
    cmp.w d2,d4
/* QL: nwlinlt */
nwlinlt:
/* QL:         ble.s   nwlin           not enough, so do a new line */
    ble.s nwlin
/* QL: prints */
prints:
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         bgt.s   okrts5          if input from read only, write nothing */
    bgt.s okrts5
/* QL:         moveq   #' ',d1 */
    moveq #32,d1
/* QL:         addq.w  #1,ch.chpos(a6,a2.l) one more character */
    addq.w #1,ch.chpos(a6,a2.l)
/* QL:         bra.s   print_1 */
    bra.s print_1
/* QL: sepmost */
sepmost:
/* QL:         move.l  d0,d4           has an error occurred? (also set d4.bit0=0) */
    move.l d0,d4
/* QL:         bne.s   rts5            yes - get out straight away */
    bne.s rts5
/* QL:         moveq   #err.nc,d0 */
    moveq #err.nc,d0
/* QL:         tst.b   bv_brk(a6)      has a "break" keypress happened? */
    tst.b bv_brk(a6)
/* QL:         bpl.s   tstrts          yes - stop here */
    bpl.s tstrts
/* QL:         move.b  d5,d0 */
    move.b d5,d0
/* QL:         beq.s   nwlin           treat no separator same as backslash */
    beq.s nwlin
/* QL:         assert  1,b.sepcom,b.back&1,(b.excl-1)&1 */
/* original assertion: 1,b.sepcom,b.back&1,(b.excl-1)&1 */
/* QL:         lsr.b   #5,d0 */
    lsr.b #5,d0
/* QL:         beq.s   comma */
    beq.s comma
/* QL:         bcs.s   oddsep */
    bcs.s oddsep
/* QL:         subq.b  #b.excl>>1,d0 */
    subq.b #(b.excl>>1),d0
/* QL:         bne.s   okrts5          get out if not exclamation mark */
    bne.s okrts5
/* QL:         bsr.s   where           do nothing now but get space left */
    bsr.s where
/* QL:         sub.w   d1,d3 */
    sub.w d1,d3
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         swap    d4              save space left in msw */
    swap d4
/* QL:         tst.w   d1              check for beginning of a line */
    tst.w d1
/* QL:         sne     d4              if not at start of line, flag pending ! */
    sne d4
/* QL: okrts5 */
okrts5:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: rts5 */
rts5:
/* QL:         rts */
    rts 
/* QL: comma */
comma:
/* QL:         bsr.s   where           where am i */
    bsr.s where
/* QL:         moveq   #-8,d2 */
    moveq #(-8),d2
/* QL:         and.w   d1,d2           round down to multiple of eight */
    and.w d1,d2
/* QL:         addq.w  #8,d2           move on eight to where we want to finish */
    addq.w #8,d2
/* QL:         subq.w  #8,d3           remainder must be >=8 as well */
    subq.w #8,d3
/* QL:         bra.s   tab_to */
    bra.s tab_to
/* QL: sstrg */
sstrg:
/* QL:         moveq   #io.sstrg,d0    write out a string */
    moveq #io.sstrg,d0
/* QL: trap43 */
trap43:
/* QL:         trap    #4 */
    trap #4
/* QL:         bra.s   trap3 */
    bra.s trap3
/* QL: septo */
septo:
/* QL:         addq.l  #8,a3           step past current arg */
    addq.l #8,a3
/* QL:         move.l  a3,a5           set upper limit */
    move.l a3,a5
/* QL:         blt.s   gtin1           force error if there were no arguments left! */
    blt.s gtin1
/* QL: *       tst.b   1(a6,a3.l) */
/* QL: *       bmi.s   gtin1           force error if to #<arg> - may use this later */
/* QL:         addq.l  #8,a5           pretend there's only one arg */
    addq.l #8,a5
/* QL: gtin1 */
gtin1:
/* QL:         jsr     ca_gtin1(pc) */
    jsr ca_gtin1(pc)
/* QL:         bne.s   rts5 */
    bne.s rts5
/* QL:         move.w  d1,d2           where they want to go to */
    move.w d1,d2
/* QL:         addq.l  #2,bv_rip(a6) */
    addq.l #2,bv_rip(a6)
/* QL:         bsr.s   where           where we are now */
    bsr.s where
/* QL: tab_to */
tab_to:
/* QL:         cmp.w   d2,d3           what's left on line? */
    cmp.w d2,d3
/* QL:         blt.s   nwlinlt         not enough, so get out */
    blt.s nwlinlt
/* QL:         sub.w   d1,d2           print at least one, up to this many spaces */
    sub.w d1,d2
/* QL: re_spac */
re_spac:
/* QL:         bsr.s   prints */
    bsr.s prints
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL:         bgt.s   re_spac */
    bgt.s re_spac
/* QL: tstrts */
tstrts:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * Note: we only ever do this the once (per channel) */
/* QL: flagro */
flagro:
/* QL:         addq.b  #1,d7           input $00->$01, print $80->$81 */
    addq.b #1,d7
/* QL: where */
where:
/* QL:         assert  ch.chpos,ch.width-2 */
/* original assertion: ch.chpos,ch.width-2 */
/* QL:         movem.w ch.chpos(a6,a2.l),d1/d3 */
    movem.w ch.chpos(a6,a2.l),d1/d3
/* QL:         rol.b   #8,d7           have we set bit 0 yet? */
    rol.b #8,d7
/* QL:         bcs.s   okrts5          yes - then we know it's a read only channel */
    bcs.s okrts5
/* QL: chenq */
chenq:
/* QL:         moveq   #sd.chenq,d0 */
    moveq #sd.chenq,d0
/* QL:         move.l  bv_bfbas(a6),a1 */
    move.l bv_bfbas(a6),a1
/* QL:         bsr.s   trap43          if it's read only, we'll get an error */
    bsr.s trap43
/* QL:         bne.s   flagro          so go flag it */
    bne.s flagro
/* QL:         move.w  4(a6,a1.l),d1   position of cursor */
    move.w 4(a6,a1.l),d1
/* QL:         move.w  0(a6,a1.l),d3   length of line */
    move.w 0(a6,a1.l),d3
/* QL:         rts */
    rts 
/* QL: * Fetches string to or edits string in basic buffer. Routine that is used by */
/* QL: * basic to input command or program lines from the keyboard or other devices. */
/* QL: * d0 -i o- zero if input may be editted, output error code */
/* QL: * d3 -i o- lsw cursor position (msw preserved) */
/* QL: * a0 -ip - where to read from */
/* QL: * a1 -  o- where buffer has been filled to */
/* QL: * d1-d2 destroyed */
/* QL: bp_rdbuf */
bp_rdbuf:
/* QL:         move.l  d0,-(sp)        save edit or not */
    move.l d0,-(sp)
/* QL:         bne.s   goedit          can't edit, so leave out write */
    bne.s goedit
/* QL:         bsr.s   params          get parameters for the operation */
    bsr.s params
/* QL:         move.w  d3,d2           use cursor position for initial display */
    move.w d3,d2
/* QL: sendit */
sendit:
/* QL:         bsr.s   sstrg */
    bsr.s sstrg
/* QL: goedit */
goedit:
/* QL:         bsr.s   params          get parameters (again) */
    bsr.s params
/* QL:         add.w   d1,a1           set up current position */
    add.w d1,a1
/* QL:         moveq   #io.edlin,d0    set to edit a line */
    moveq #io.edlin,d0
/* QL:         tst.l   (sp)            allow edit? */
    tst.l (sp)
/* QL:         beq.s   trp_set */
    beq.s trp_set
/* QL:         moveq   #io.fline,d0    no, fetch a line */
    moveq #io.fline,d0
/* QL:         sub.w   d1,d2           or rather, a continuation of same!! */
    sub.w d1,d2
/* QL: trp_set */
trp_set:
/* QL:         bsr.s   trap43 */
    bsr.s trap43
/* QL:         moveq   #err.bo,d2 */
    moveq #err.bo,d2
/* QL:         cmp.l   d0,d2 */
    cmp.l d0,d2
/* QL:         beq.s   edmore          extend buffer if it overflows */
    beq.s edmore
/* QL:         tst.l   (sp)+           check and discard saved edit flag */
    tst.l (sp)+
/* QL:         bne.s   positit         we weren't editing, so no device check */
    bne.s positit
/* QL:         moveq   #err.bp,d2 */
    moveq #err.bp,d2
/* QL:         sub.l   d0,d2 */
    sub.l d0,d2
/* QL:         beq.s   edbpro */
    beq.s edbpro
/* QL:         subq.l  #err.bp-err.ro,d2 a pity, but drivers may say bp or ro */
.word 20866|((((err.bp-err.ro))&7)<<9)
/* QL:         beq.s   edbpro */
    beq.s edbpro
/* QL: positit */
positit:
/* QL:         move.l  a1,bv_bfp(a6)   save where we've got to */
    move.l a1,bv_bfp(a6)
/* QL:         bra.s   tstrts */
    bra.s tstrts
/* QL: edmore */
edmore:
/* QL:         bsr.s   positit         record where we got to */
    bsr.s positit
/* QL:         swap    d1              cursor into lsw */
    swap d1
/* QL:         move.w  d1,d3           save current cursor position */
    move.w d1,d3
/* QL:         moveq   #128-8,d1       want more bytes (will round up as 192 extra) */
    moveq #(128-8),d1
/* QL:         jsr     bv_chbfx(pc)    ask for it */
    jsr bv_chbfx(pc)
/* QL:         bra.s   goedit */
    bra.s goedit
/* QL: edbpro */
edbpro:
/* QL: * We only get here from reading a command channel line. */
/* QL: * If we were editing a "bad line", the cursor position may have been non-zero. */
/* QL: * If so, we've already sent the chars up to the cursor. */
/* QL: * To make that tidy, we need to send the rest, plus a linefeed. */
/* QL: * As it happens, the linefeed from the parser is still in the buffer! */
/* QL: * If the buffer is empty, we're OK already. */
/* QL:         move.l  d0,-(sp)        if edlin gives err.bp/ro, try without edit */
    move.l d0,-(sp)
/* QL:         bsr.s   params */
    bsr.s params
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         beq.s   goedit          nothing in buffer, so nothing pre-sent */
    beq.s goedit
/* QL:         move.l  a1,bv_bfp(a6)   lose contents of buffer now */
    move.l a1,bv_bfp(a6)
/* QL:         add.w   d3,a1           move past what we've sent */
    add.w d3,a1
/* QL:         sub.w   d3,d2           count that off */
    sub.w d3,d2
/* QL:         addq.w  #1,d2           include the linefeed */
    addq.w #1,d2
/* QL:         clr.w   d3              forget the cursor now */
    clr.w d3
/* QL:         bra.s   sendit          go start business */
    bra.s sendit
/* QL: params */
params:
/* QL:         assert  bv_bfbas,bv_bfp-4 */
/* original assertion: bv_bfbas,bv_bfp-4 */
/* QL:         movem.l bv_bfbas(a6),d0-d2 buffer base, top and next pointer */
    movem.l bv_bfbas(a6),d0-d2
/* QL:         move.w  #$7eff,a1       an arbitrary maximum */
    move.w #0x7eff,a1
/* QL:         exg     a1,d0 */
    exg a1,d0
/* QL:         sub.l   a1,d1           length of buffer so far */
    sub.l a1,d1
/* QL:         sub.l   a1,d2           maximum length of buffer */
    sub.l a1,d2
/* QL:         cmp.l   d2,d0           is the current buffer size reasonable? */
    cmp.l d2,d0
/* QL:         bcc.s   max_ok */
    bcc.s max_ok
/* QL:         move.l  d0,d2           no - truncate it */
    move.l d0,d2
/* QL: max_ok */
max_ok:
/* QL:         cmp.l   d1,d2           is the current number of characters now OK? */
    cmp.l d1,d2
/* QL:         bcc.s   off_ok */
    bcc.s off_ok
/* QL:         moveq   #0,d1           no - discard them - probably a duff file read */
    moveq #0,d1
/* QL: off_ok */
off_ok:
/* QL:         cmp.w   d3,d1           does the cursor make some sense? */
    cmp.w d3,d1
/* QL:         bcc.s   cur_ok */
    bcc.s cur_ok
/* QL:         clr.w   d3              no - discard it */
    clr.w d3
/* QL: cur_ok */
cur_ok:
/* QL:         swap    d1 */
    swap d1
/* QL:         move.w  d3,d1           put cursor in msw */
    move.w d3,d1
/* QL:         swap    d1 */
    swap d1
/* QL:         rts */
    rts 
/* QL:         end */
