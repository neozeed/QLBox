/* Generated from original/M/bp/list.asm */
/* QL: * List (or delete) part or all of a program */
/* QL:         xdef    bp_list,bp_list2,bp_listd,bp_liste,bp_listf,bp_listr */
.globl bp_list,bp_list2,bp_listd,bp_liste,bp_listf,bp_listr
/* QL:         xdef    bp_chkls,bp_dline,bp_detok,bp_gsep,bp_gint,bp_lsqzp,bp_lszap */
.globl bp_chkls,bp_dline,bp_detok,bp_gsep,bp_gint,bp_lsqzp,bp_lszap
/* QL: * bp_listf is provided for a quicker entry point for tk2's ed. */
/* QL:         xref    bp_chand,bp_chunr */
/* QL:         xref    bv_chri,bv_chbfx,bv_chlnx,bv_clrt */
/* QL:         xref    ca_etos,ca_cnvrt */
/* QL:         xref    cn_ftod,cn_0tod */
/* QL:         xref    ib_glin0,ib_glin1,ib_nxtk,ib_steof,ib_whdel */
/* QL:         xref    mm_mrtor */
/* QL:         xref    pa_table,pa_tbops,pa_tbmon,pa_tbsep,pa_tbsym */
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: * Note: entry points bp_lista and bp_lists were unused, code moved to pf_relst. */
/* QL: * Also, the vector which is supposed to go to bp_liste gets here via pf_liste. */
/* QL: c.defls equ     2       default listing channel number */
.equ c.defls,2
/* QL:         section bp_list */
.section bp_list,"ax"
/* QL: * Gets separator type from name table. */
/* QL: bp_gsep */
bp_gsep:
/* QL:         addq.l  #8,a3           advance over argument */
    addq.l #8,a3
/* QL:         move.b  -7(a6,a3.l),d5  get vt and st */
    move.b (-7)(a6,a3.l),d5
/* QL:         lsr.b   #4,d5           separator only */
    lsr.b #4,d5
/* QL:         and.b   #15,-7(a6,a3.l) wipe it out of argument and set z if no arg */
    and.b #(15&255),(-7)(a6,a3.l)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * Basic DLINE. Uses a lot of routines shared with LIST. */
/* QL: * a3 -i  - base of args */
/* QL: * a5 -i  - top of args */
/* QL: * d0-d7/a0-a1/a3-a4 destroyed */
/* QL: * d4 lower line to write */
/* QL: * d5 separator type */
/* QL: * d6 upper line to write */
/* QL: * a0 where to write to */
/* QL: * a2 keyword table */
/* QL: * a4 program file */
/* QL: bp_dline */
bp_dline:
/* QL:         cmp.l   a5,a3 */
    cmp.l a5,a3
/* QL:         beq.s   rts0            refuse to consider no args as delete all! */
    beq.s rts0
/* QL:         st      d7              tell rest of prog we're deleting */
    st d7
/* QL: * Implements basic keyword LIST */
/* QL: * a0 - l - where to write to */
/* QL: * a2 - l - keyword table */
/* QL: * a3 -i  - base of args */
/* QL: * a4 - l - program file */
/* QL: * a5 -i o- top of args */
/* QL: * d4 - l - lower line to write */
/* QL: * d5 - l - separator type */
/* QL: * d6 - l - upper line to write */
/* QL: bp_list */
bp_list:
/* QL:         moveq   #c.defls,d1     if no # given, use 2 */
    moveq #c.defls,d1
/* QL:         jsr     bp_chand(pc) */
    jsr bp_chand(pc)
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL: * Lists a program like bp_list except that it does not set or check the output */
/* QL: * channel - it is used to list to devices. E.g. in SAVE. */
/* QL: * a0 - l - where to write to */
/* QL: * a2 - l - keyword table */
/* QL: * a3 -i  - base of args */
/* QL: * a4 - l - program file */
/* QL: * a5 -i  - top of args */
/* QL: * d4 - l - lower line to write */
/* QL: * d5 - l - separator type */
/* QL: * d6 - l - upper line to write */
/* QL: bp_listd */
bp_listd:
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         beq.s   notdel */
    beq.s notdel
/* QL:         jsr     bp_chunr(pc)    never get caught by delete via list entry point */
    jsr bp_chunr(pc)
/* QL: notdel */
notdel:
/* QL:         moveq   #0,d4           default from start of program */
    moveq #0,d4
/* QL:         move.w  d4,bv_lsfil(a6) turn fill screen flag off */
    move.w d4,bv_lsfil(a6)
/* QL:         st      bv_print(a6)    turn print flag on for list, save */
    st bv_print(a6)
/* QL:         sub.l   a3,a5 */
    sub.l a3,a5
/* QL:         move.l  a5,-(sp)        keep number of bytes of args on top of stack */
    move.l a5,-(sp)
/* QL:         ble.s   set_hi          no args at all - this will list all */
    ble.s set_hi
/* QL: get_rng */
get_rng:
/* QL:         moveq   #0,d1           default start from zero */
    moveq #0,d1
/* QL:         subq.l  #8,(sp)         one less arg remaining */
    subq.l #8,(sp)
/* QL:         bsr.s   bp_gsep         gets separator and checks for an argument */
    bsr.s bp_gsep
/* QL:         beq.s   set_fst         no arg, d1 is ready */
    beq.s set_fst
/* QL:         bsr.s   bp_gint */
    bsr.s bp_gint
/* QL:         bne.s   popret */
    bne.s popret
/* QL: set_fst */
set_fst:
/* QL:         move.w  d1,d4           first line, and also default last */
    move.w d1,d4
/* QL:         cmp.b   #b.septo,d5     is this a range? */
    cmp.b #(b.septo&255),d5
/* QL:         bne.s   set_lst         no - go check end of range */
    bne.s set_lst
/* QL:         tst.l   (sp)            any args left? */
    tst.l (sp)
/* QL:         ble.s   set_hi          no - default to end of program */
    ble.s set_hi
/* QL:         subq.l  #8,(sp)         one less arg remaining */
    subq.l #8,(sp)
/* QL:         bsr.s   bp_gsep         get new sep and check for arg */
    bsr.s bp_gsep
/* QL:         beq.s   set_hi          if none, go set highest */
    beq.s set_hi
/* QL:         bsr.s   bp_gint         get last line number to list */
    bsr.s bp_gint
/* QL:         bne.s   popret */
    bne.s popret
/* QL: set_lst */
set_lst:
/* QL:         move.w  d1,d6           check last */
    move.w d1,d6
/* QL:         bne.s   lstrdy          ok if it's not zero */
    bne.s lstrdy
/* QL:         tst.b   d7              do not want to delete the whole file */
    tst.b d7
/* QL:         bne.s   skip_it         unless they tell us properly */
    bne.s skip_it
/* QL: set_hi */
set_hi:
/* QL:         move.w  #32767,d6       highest possible line number */
    move.w #32767,d6
/* QL: lstrdy */
lstrdy:
/* QL:         cmp.w   d4,d6           check first line not greater than last */
    cmp.w d4,d6
/* QL:         blo.s   skip_it         ignore reversed ranges (used to show as error) */
    blo.s skip_it
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         beq.s   goliste         if list, go do it straight away */
    beq.s goliste
/* QL:         cmp.w   bv_lsbef(a6),d6 */
    cmp.w bv_lsbef(a6),d6
/* QL:         bls.s   goliste         range wholely before screen */
    bls.s goliste
/* QL:         cmp.w   bv_lsaft(a6),d4 */
    cmp.w bv_lsaft(a6),d4
/* QL:         bhs.s   goliste         range wholely after screen */
    bhs.s goliste
/* QL:         ext.w   d7              remember we've affected the screen, if a delete */
    ext.w d7
/* QL: goliste */
goliste:
/* QL:         sub.l   bv_ntp(a6),a3   gotta protect this against basic buffer shifts! */
    sub.l bv_ntp(a6),a3
/* QL:         bsr.l   bp_liste        actually do the listing/deleting! */
    bsr.w bp_liste
/* QL:         add.l   bv_ntp(a6),a3 */
    add.l bv_ntp(a6),a3
/* QL: skip_it */
skip_it:
/* QL:         move.l  (sp),d2         have we run out of arguments? */
    move.l (sp),d2
/* QL:         ble.s   end_rng         yes, we're all done */
    ble.s end_rng
/* QL:         subq.b  #b.sepcom,d5    was sep a comma? */
    subq.b #b.sepcom,d5
/* QL:         beq.s   get_rng         yes, go do next range, otherwise it's an error */
    beq.s get_rng
/* QL: badret */
badret:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         bra.s   popret */
    bra.s popret
/* QL: end_rng */
end_rng:
/* QL:         move.w  d7,d3           if this dline affected the screen we relist */
    move.w d7,d3
/* QL:         bpl.s   okpop */
    bpl.s okpop
/* QL:         bsr.l   bp_chkls        ah! but is this really the list channel? */
    bsr.w bp_chkls
/* QL:         bne.s   okpop           no - so forget it! (e.g. DLINE#0 for no relist) */
    bne.s okpop
/* QL:         bsr.s   relist          list from top (d2.w=0), deleted range (d3.b<0) */
    bsr.s relist
/* QL: okpop */
okpop:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: popret */
popret:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * Gets a positive integer on the ri stack from the argument pointed */
/* QL: * to by a3 and a5, converting from f.p. if necessary. */
/* QL: * d0 -  o- error return */
/* QL: * d1 -  o- (.w) 1..32767 result, if all ok */
/* QL: * a1 -  o- ri stack top where d1 was, bv_rip updated past it */
/* QL: * a3 -ip - nt top */
/* QL: * a5 -  o- copy of a3 */
/* QL: * d2/a4 destroyed */
/* QL: bp_gint */
bp_gint:
/* QL:         move.l  a3,a5 */
    move.l a3,a5
/* QL:         jsr     ca_etos(pc)     get it on top of stack */
    jsr ca_etos(pc)
/* QL:         bne.s   rts2 */
    bne.s rts2
/* QL:         moveq   #t.int,d0 */
    moveq #t.int,d0
/* QL:         jsr     ca_cnvrt(pc)    turn it into an integer */
    jsr ca_cnvrt(pc)
/* QL:         bne.s   rts2 */
    bne.s rts2
/* QL:         addq.l  #2,bv_rip(a6) */
    addq.l #2,bv_rip(a6)
/* QL:         move.w  0(a6,a1.l),d1   have the idiots put in a zero or negative no? */
    move.w 0(a6,a1.l),d1
/* QL:         bgt.s   tstrts */
    bgt.s tstrts
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: tstrts */
tstrts:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: rts2 */
rts2:
/* QL:         rts */
    rts 
/* QL: * Note: there does not seem to be any great attempt to leave registers */
/* QL: * in any predictable state on return. May be able to do optimisation... */
/* QL: * Relist the current screen for a renum */
/* QL: bp_listr */
bp_listr:
/* QL:         moveq   #0,d2           make line number the special, list all */
    moveq #0,d2
/* QL:         moveq   #0,d3           look as if a replaced line has happened */
    moveq #0,d3
/* QL: * Relist on list channel if d2/d3 implies screen should change */
/* QL: bp_list2 */
bp_list2:
/* QL:         bsr.s   pickls          get the list channel */
    bsr.s pickls
/* QL:         bmi.s   rts2 */
    bmi.s rts2
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL: * d2 -i  - line number in question, 0 for from top to fill */
/* QL: * d3 -ip - +ve for inserted line */
/* QL: *          0   for replaced line */
/* QL: *          -ve for deleted line */
/* QL: * a0 -ip - list channel id */
/* QL: * d0-d1/d4/d6/a1-a2/a4 destroyed */
/* QL: relist */
relist:
/* QL:         move.l  bv_lnbas(a6),a1 line number table */
    move.l bv_lnbas(a6),a1
/* QL:         cmp.l   bv_lnp(a6),a1   is there anything on the screen yet? */
    cmp.l bv_lnp(a6),a1
/* QL:         beq.s   just_d2         no - go list just d2 */
    beq.s just_d2
/* QL: * There was an attempt at clearing d0 above, but there's no reason to? */
/* QL:         move.w  0(a6,a1.l),d4   top line number on screen */
    move.w 0(a6,a1.l),d4
/* QL:         tst.w   d2              is current line set? */
    tst.w d2
/* QL:         bne.s   cur_set */
    bne.s cur_set
/* QL:         move.w  d4,d2           no - current line set to top */
    move.w d4,d2
/* QL: cur_set */
cur_set:
/* QL:         assert  bv_lsbef,bv_lsbas-2,bv_lsaft-4,bv_maxln-8,bv_totln-10 */
/* original assertion: bv_lsbef,bv_lsbas-2,bv_lsaft-4,bv_maxln-8,bv_totln-10 */
/* QL:         movem.w bv_lsbef(a6),d0-d1/d6/a1-a2/a4 */
    movem.w bv_lsbef(a6),d0-d1/d6/a1-a2/a4
/* QL:         cmp.w   d0,d2           lsbef: is lno before invisible top line? */
    cmp.w d0,d2
/* QL:         bcs.s   rts1            yes, do nothing */
    bcs.s rts1
/* QL:         cmp.w   d4,d2           is it between bef and top? */
    cmp.w d4,d2
/* QL:         bcs.s   top             yes, only print if not deleted */
    bcs.s top
/* QL:         cmp.w   d6,d2           lsaft: if after invisible base line, get out */
    cmp.w d6,d2
/* QL:         bhi.s   rts1 */
    bhi.s rts1
/* QL:         cmp.w   d6,d2           is it between bas and aft? */
    cmp.w d6,d2
/* QL:         bhi.s   basdel          yes, only print if not deleted */
    bhi.s basdel
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bpl.s   print1          lsbas: insert/mofify, print top to bas */
    bpl.s print1
/* QL:         bra.s   print6          lsaft: deleted, print top to aft */
    bra.s print6
/* QL: just_d2 */
just_d2:
/* QL:         move.w  d2,d4           set current line as the first in the range */
    move.w d2,d4
/* QL:         bne.s   prtod2          fill to the bottom of the window */
    bne.s prtod2
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: basdel */
basdel:
/* QL:         tst.b   d3              print top (which will disappear) to lno */
    tst.b d3
/* QL:         bmi.s   rts1            not interested if a deleted line */
    bmi.s rts1
/* QL: prtod2 */
prtod2:
/* QL:         move.w  d2,d6 */
    move.w d2,d6
/* QL:         bra.s   print6 */
    bra.s print6
/* QL: top */
top:
/* QL:         tst.b   d3              not interested if not new or updated */
    tst.b d3
/* QL:         bmi.s   rts1 */
    bmi.s rts1
/* QL:         move.w  d2,d4 */
    move.w d2,d4
/* QL:         cmp.w   a2,a4           maxln/totln */
    cmp.w a2,a4
/* QL:         blt.s   print1          if not yet full, print all the way to bas */
    blt.s print1
/* QL:         subq.w  #1,d1           print lno to one before bas (should work) */
    subq.w #1,d1
/* QL: print1 */
print1:
/* QL:         move.w  d1,d6 */
    move.w d1,d6
/* QL: print6 */
print6:
/* QL:         move.w  d2,bv_lsfil(a6) fill the screen at least to this line */
    move.w d2,bv_lsfil(a6)
/* QL:         moveq   #sd.pos,d0      put the cursor */
    moveq #sd.pos,d0
/* QL:         moveq   #0,d2           at the top */
    moveq #0,d2
/* QL:         moveq   #0,d1           left hand corner */
    moveq #0,d1
/* QL:         bsr.s   trap_3 */
    bsr.s trap_3
/* QL:         st      bv_print(a6)    turn print on */
    st bv_print(a6)
/* QL:         bsr.l   listp           list from d4 to d6 inclusive */
    bsr.w listp
/* QL:         moveq   #sd.clrrt,d0    clear to right of cursor */
    moveq #sd.clrrt,d0
/* QL:         bsr.s   trap_3 */
    bsr.s trap_3
/* QL: ; Already done the above, assuming anything was listed at all! */
/* QL: ; It is needed if we are called to list a deleted range, and nothing is left */
/* QL:         moveq   #sd.clrbt,d0    clear bottom of screen */
    moveq #sd.clrbt,d0
/* QL: trap_3 */
trap_3:
/* QL:         bra.l   trap3 */
    bra.w trap3
/* QL: * Pick up list channel into d0, return -ve if not present or closed */
/* QL: pickls */
pickls:
/* QL:         moveq   #-(c.defls+1)*ch.lench,d0 */
    moveq #((-(c.defls+1))*ch.lench),d0
/* QL:         add.l   bv_chp(a6),d0 */
    add.l bv_chp(a6),d0
/* QL:         sub.l   bv_chbas(a6),d0 actually check if list channel exists! */
    sub.l bv_chbas(a6),d0
/* QL:         bmi.s   nolstch         if not, d0 should be negative */
    bmi.s nolstch
/* QL:         move.l  bv_chbas(a6),d0 */
    move.l bv_chbas(a6),d0
/* QL:         move.l  ch.lench*c.defls(a6,d0.l),d0 get listing channel id */
    move.l (ch.lench*c.defls)(a6,d0.l),d0
/* QL: nolstch */
nolstch:
/* QL:         rts */
    rts 
/* QL: * Lists or deletes program lines in range indicated by d4 and d6 */
/* QL: * d4 -i  - lower line to write */
/* QL: * d6 -i  - upper line to write */
/* QL: * d7 -ip - if zero, list, else delete lines in range */
/* QL: * a0 -ip - where to write to */
/* QL: * d0-d3/a1-a2/a4 destroyed */
/* QL: * This entry point preserved for vector entry. */
/* QL: bp_liste */
bp_liste:
/* QL:         tst.b   d7              listing or deleting? */
    tst.b d7
/* QL:         beq.s   listp           if list, go there */
    beq.s listp
/* QL:         jsr     ib_glin0(pc)    go to the line number required */
    jsr ib_glin0(pc)
/* QL:         ble.s   okrts           we won't take the slightest notice if off top */
    ble.s okrts
/* QL:         move.w  4(a6,a4.l),d2   get current lno */
    move.w 4(a6,a4.l),d2
/* QL:         cmp.w   d2,d6           are we deleting a null range? */
    cmp.w d2,d6
/* QL:         blo.s   okrts           amazing, the things people think up */
    blo.s okrts
/* QL:         cmp.w   bv_linum(a6),d2 are we deleting before, or including ourself? */
    cmp.w bv_linum(a6),d2
/* QL:         bhi.s   delok */
    bhi.s delok
/* QL:         jsr     ib_steof(pc)    yes - make sure we don't continue! */
    jsr ib_steof(pc)
/* QL: delok */
delok:
/* QL:         jsr     ib_whdel(pc)    tell when processing which lines are going */
    jsr ib_whdel(pc)
/* QL: * whdel gets d2/d6 and can zap d0/a2, at least, plus a4 is easy to restore */
/* QL:         move.w  d6,d4           set top line to search for */
    move.w d6,d4
/* QL:         addq.w  #1,d4           n.b. 32767->32768, but glin1 uses unsigned cmps */
    addq.w #1,d4
/* QL:         move.w  d1,d6           save prior line length */
    move.w d1,d6
/* QL:         move.l  a0,-(sp)        save channel ID */
    move.l a0,-(sp)
/* QL:         move.l  a4,a0           where to shift code down to */
    move.l a4,a0
/* QL:         jsr     ib_glin1(pc)    position past top line of range */
    jsr ib_glin1(pc)
/* QL:         ble.s   put_pfp         at top of program, so nowt to copy */
    ble.s put_pfp
/* QL:         sub.w   d6,d1 */
    sub.w d6,d1
/* QL:         add.w   d1,0(a6,a4.l)   correct the line length change word */
    add.w d1,0(a6,a4.l)
/* QL:         move.l  a4,a1           source from remaining program lines */
    move.l a4,a1
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         sub.l   a1,d1           length */
    sub.l a1,d1
/* QL:         jsr     mm_mrtor(pc)    fast copy */
    jsr mm_mrtor(pc)
/* QL:         add.l   d1,a0           new top */
    add.l d1,a0
/* QL: put_pfp */
put_pfp:
/* QL:         st      bv_edit(a6)     this wasn't being done before! */
    st bv_edit(a6)
/* QL:         move.l  a0,bv_pfp(a6)   store new top of program */
    move.l a0,bv_pfp(a6)
/* QL:         move.l  (sp)+,a0        restore channel ID */
    move.l (sp)+,a0
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Verify if the current channel id is that of the listing channel (#2) */
/* QL: * d0 -  o- the listing window id, ccr z set if d0=a0, made -ve if no list chan */
/* QL: * a0 -ip - channel id */
/* QL: bp_chkls */
bp_chkls:
/* QL:         bsr.s   pickls */
    bsr.s pickls
/* QL:         bmi.s   notlst */
    bmi.s notlst
/* QL:         cmp.l   a0,d0           returns eq if this is the listing window */
    cmp.l a0,d0
/* QL: notlst */
notlst:
/* QL:         rts */
    rts 
/* QL: * Check if a0 is list channel, and if so wipe out current list info */
/* QL: * d0 -  o- 0 iff ccr=Z */
/* QL: * a0 -ip - channel id in question */
/* QL: bp_lsqzp */
bp_lsqzp:
/* QL:         bsr.s   bp_chkls */
    bsr.s bp_chkls
/* QL:         bne.s   notlst */
    bne.s notlst
/* QL: * Zap list info */
/* QL: * d0 -  o- 0 */
/* QL: bp_lszap */
bp_lszap:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: initls */
initls:
/* QL:         move.l  bv_lnbas(a6),bv_lnp(a6) empty table */
    move.l bv_lnbas(a6),bv_lnp(a6)
/* QL:         move.w  d0,bv_lsbef(a6) */
    move.w d0,bv_lsbef(a6)
/* QL:         assert  bv_lsbef,bv_lsbas-2 */
/* original assertion: bv_lsbef,bv_lsbas-2 */
/* QL:         move.l  d0,bv_lsbas(a6) */
    move.l d0,bv_lsbas(a6)
/* QL:         rts */
    rts 
/* QL: * Detokenise a line */
/* QL: * d4 -i o- line number to detokenise / keyword table pointer */
/* QL: * d6 -  o- as d4 input */
/* QL: * a4 -  o- pre-word of last line examined */
/* QL: * d0-d3/a1-a2 destroyed */
/* QL: bp_detok */
bp_detok:
/* QL:         move.w  d4,d6           (also top line) */
    move.w d4,d6
/* QL:         sf      bv_print(a6)    turn print off */
    sf bv_print(a6)
/* QL: listp */
listp:
/* QL:         jsr     ib_glin0(pc)    go to the line number required */
    jsr ib_glin0(pc)
/* QL:         sub.l   a2,a2           make invisible top line be zero */
    sub.l a2,a2
/* QL:         cmp.l   a4,d0           check if at first line of program */
    cmp.l a4,d0
/* QL:         beq.s   bp_listf        if so, top line zero is ready if we need it */
    beq.s bp_listf
/* QL:         move.l  a4,a2 */
    move.l a4,a2
/* QL:         sub.w   d1,a2 */
    sub.w d1,a2
/* QL:         move.w  4(a6,a2.l),a2   fetch a genuine invisible top line */
    move.w 4(a6,a2.l),a2
/* QL: * d0 -i  - pfbas */
/* QL: * d4 -  o- keyword table pointer */
/* QL: * d6 -ip - line number to stop printing at */
/* QL: * a0 -ip - channel id to print to */
/* QL: * a2 -i  - invisible top line (one before a4) */
/* QL: * a4 -i o- pre-word of first line to print / pre-word of last line examined */
/* QL: * d1-d3/a1 destroyed */
/* QL: bp_listf */
bp_listf:
/* QL:         move.l  a0,-(sp)        save channel id */
    move.l a0,-(sp)
/* QL:         move.b  bv_print(a6),bv_lsany(a6) see if we are printing at all */
    move.b bv_print(a6),bv_lsany(a6)
/* QL:         beq.s   lnskip          nope, so don't even think about it */
    beq.s lnskip
/* QL:         bsr.s   bp_chkls        is this the list window? */
    bsr.s bp_chkls
/* QL:         bne.s   setany          no - go stop table */
    bne.s setany
/* QL:         moveq   #sd.chenq,d0    get size of listing window */
    moveq #sd.chenq,d0
/* QL:         assert  bv_lenln,bv_maxln-2 */
/* original assertion: bv_lenln,bv_maxln-2 */
/* QL:         move.w  #bv_lenln,a1    length of a line.w, no of lines.w, hit 2 more */
    move.w #bv_lenln,a1
/* QL:         bsr.s   trap43 */
    bsr.s trap43
/* QL: setany */
setany:
/* QL:         seq     bv_lsany(a6)    if all ok, we'll do line number table */
    seq bv_lsany(a6)
/* QL:         bne.s   lnskip */
    bne.s lnskip
/* QL:         move.w  d0,bv_totln(a6) set no of lines to zero */
    move.w d0,bv_totln(a6)
/* QL:         move.w  a2,d0           for lsbef and lsaft, lsbas set zero for a mo */
    move.w a2,d0
/* QL:         bsr.s   initls */
    bsr.s initls
/* QL: lnskip */
lnskip:
/* QL:         pea     nxtline */
    pea nxtline(pc)
/* QL:         jmp     bv_chri(pc)     make certain we have some ri space for ftod */
    jmp bv_chri(pc)
/* QL: * End of line code. bv_bfp points at lf, a0 points at lf + 1 */
/* QL: preol */
preol:
/* QL:         addq.l  #2,a4           space over nl token to pre-word of next line */
    addq.l #2,a4
/* QL:         tst.b   bv_brk(a6)      check for a break input (don't reset it here!) */
    tst.b bv_brk(a6)
/* QL: end_ok1 */
end_ok1:
/* QL:         bpl.l   end_ok0         yes, don't do next line */
    bpl.w end_ok0
/* QL:         tst.b   bv_print(a6)    am I to print this ? */
    tst.b bv_print(a6)
/* QL:         beq.s   end_ok1         no - leave it in the buffer */
    beq.s end_ok1
/* QL:         sub.l   bv_bfbas(a6),a0 line length including lf */
    sub.l bv_bfbas(a6),a0
/* QL:         tst.b   bv_lsany(a6)    check if we have an active line number table */
    tst.b bv_lsany(a6)
/* QL:         beq.s   bufprt          no, so now just print it */
    beq.s bufprt
/* QL:         moveq   #4,d1 */
    moveq #4,d1
/* QL:         jsr     bv_chlnx(pc)    ensure space for one line number table entry */
    jsr bv_chlnx(pc)
/* QL:         assert  bv_lnbas,bv_lnp-4 */
/* original assertion: bv_lnbas,bv_lnp-4 */
/* QL:         movem.l bv_lnbas(a6),a1-a2 base and running pointer of lno table */
    movem.l bv_lnbas(a6),a1-a2
/* QL:         assert  bv_lsaft,bv_lenln-2,bv_maxln-4,bv_totln-6 */
/* original assertion: bv_lsaft,bv_lenln-2,bv_maxln-4,bv_totln-6 */
/* QL:         movem.w bv_lsaft(a6),d0-d3 */
    movem.w bv_lsaft(a6),d0-d3
/* QL:         moveq   #-1-1,d4        forget the lf and we will round up */
    moveq #((-1)-1),d4
/* QL:         add.l   a0,d4 */
    add.l a0,d4
/* QL:         divu    d1,d4 */
    divu d1,d4
/* QL:         addq.w  #1,d4           no of lines this will occupy */
    addq.w #1,d4
/* QL:         cmp.w   d4,d2           is this line bigger than whole screen? */
    cmp.w d4,d2
/* QL:         bge.s   notover         no, so we're not into finicky bits */
    bge.s notover
/* QL:         move.w  d2,d4           pretend it's just whole screen */
    move.w d2,d4
/* QL: notover */
notover:
/* QL:         add.w   d4,d3           add to running total */
    add.w d4,d3
/* QL:         bra.s   check           now we are guaranteed to leave it in table */
    bra.s check
/* QL: trap43 */
trap43:
/* QL:         trap    #4 */
    trap #4
/* QL: trap3 */
trap3:
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         trap    #3 */
    trap #3
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: roll_tab */
roll_tab:
/* QL:         sub.w   2(a6,a1.l),d3   take off lines encompassed in top ln */
    sub.w 2(a6,a1.l),d3
/* QL:         move.w  0(a6,a1.l),bv_lsbef(a6) update invisible top line */
    move.w 0(a6,a1.l),bv_lsbef(a6)
/* QL:         addq.l  #4,a1           roll the table forward */
    addq.l #4,a1
/* QL: check */
check:
/* QL:         cmp.w   d2,d3           will we scroll out of window */
    cmp.w d2,d3
/* QL:         ble.s   putlntab        no, just wind it in */
    ble.s putlntab
/* QL:         tst.w   bv_lsfil(a6)    are we supposed to just fill window? */
    tst.w bv_lsfil(a6)
/* QL:         beq.s   roll_tab        no, so keep going */
    beq.s roll_tab
/* QL:         cmp.w   bv_lsfil(a6),d0 have we done the "fill to" line yet? */
    cmp.w bv_lsfil(a6),d0
/* QL:         bls.s   roll_tab        no, so also keep going */
    bls.s roll_tab
/* QL: * We've done the fill to line, we can't fit this, but we must have space left, */
/* QL: * or we wouldn't have come back to do this line at all. (See below) */
/* QL:         sub.w   d2,d3           overflow in window */
    sub.w d2,d3
/* QL:         sub.w   d3,d4           reduce the space we recorded for this line */
    sub.w d3,d4
/* QL:         move.w  d2,d3           show screen as filled to the brim */
    move.w d2,d3
/* QL:         mulu    d4,d1           do a partial display of extra line at bottom */
    mulu d4,d1
/* QL:         move.l  d1,a0           override length */
    move.l d1,a0
/* QL: putlntab */
putlntab:
/* QL:         move.w  d3,bv_totln(a6) update the no of lines in the window */
    move.w d3,bv_totln(a6)
/* QL:         move.l  a1,bv_lnbas(a6) save base of lno table */
    move.l a1,bv_lnbas(a6)
/* QL:         movem.w d0/d4,0(a6,a2.l) put in the lno/lines to be printed (lsaft) */
    movem.w d0/d4,0(a6,a2.l)
/* QL:         addq.l  #4,bv_lnp(a6)   update the running lno table pointer */
    addq.l #4,bv_lnp(a6)
/* QL: bufprt */
bufprt:
/* QL:         move.w  a0,d2           length including lf (or trimmed final line) */
    move.w a0,d2
/* QL:         move.l  bv_bfbas(a6),a1 */
    move.l bv_bfbas(a6),a1
/* QL:         moveq   #io.sstrg,d0    send a string of bytes */
    moveq #io.sstrg,d0
/* QL:         move.l  (sp),a0         write it to here */
    move.l (sp),a0
/* QL:         bsr.s   trap43 */
    bsr.s trap43
/* QL:         bne.s   end_err */
    bne.s end_err
/* QL:         moveq   #sd.clrrt,d0    clear to end of line */
    moveq #sd.clrrt,d0
/* QL:         trap    #3 */
    trap #3
/* QL: nxtline */
nxtline:
/* QL:         move.w  #32768,d4       dummy next line number */
    move.w #32768,d4
/* QL:         cmp.l   bv_pfp(a6),a4   reached end of program file yet? */
    cmp.l bv_pfp(a6),a4
/* QL:         bge.s   nextset         yes - use dummy lno */
    bge.s nextset
/* QL:         addq.l  #2,a4           skip pre-word */
    addq.l #2,a4
/* QL:         move.w  2(a6,a4.l),d4   get the proper line number */
    move.w 2(a6,a4.l),d4
/* QL: nextset */
nextset:
/* QL:         tst.b   bv_lsany(a6)    check if we have an active line number table */
    tst.b bv_lsany(a6)
/* QL:         beq.s   skipaft */
    beq.s skipaft
/* QL:         jsr     bv_clrt(pc)     shift the lno tab down to butt into rtstk */
    jsr bv_clrt(pc)
/* QL:         ; d0=0, d1-d3/a0-a2 destroyed */
/* QL:         move.w  bv_lsaft(a6),bv_lsbas(a6) promote invisible line after to base */
    move.w bv_lsaft(a6),bv_lsbas(a6)
/* QL:         move.w  d4,bv_lsaft(a6) store invisible line number after screen */
    move.w d4,bv_lsaft(a6)
/* QL: skipaft */
skipaft:
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         move.l  pa_table(pc),d4 get keyword table address */
    move.l pa_table(pc),d4
/* QL: * We want to decide what to do with this line. */
/* QL: * If listing, we go operate range checks. */
/* QL: * If tokenising, we've either found the required line, or need to put a dummy. */
/* QL: * When on earth can we get here with print=0 and auto=0? */
/* QL:         tst.b   bv_print(a6)    listing? */
    tst.b bv_print(a6)
/* QL:         bne.s   tst_rnge        yes, go check range */
    bne.s tst_rnge
/* QL:         tst.b   bv_auto(a6)     detokenising for an auto/edit line? */
    tst.b bv_auto(a6)
/* QL:         beq.s   tst_rnge        no, go check range (happens for TK2?) */
    beq.s tst_rnge
/* QL:         cmp.w   bv_edlin(a6),d1 and is it the one they asked for? */
    cmp.w bv_edlin(a6),d1
/* QL:         beq.s   tst_rnge        yes, go continue (irrelevent) check on range */
    beq.s tst_rnge
/* QL:         move.w  bv_edlin(a6),d1 we are tokenising an absent auto/edit lno */
    move.w bv_edlin(a6),d1
/* QL:         bsr.s   prlno           put line number in buffer */
    bsr.s prlno
/* QL:         move.l  a0,bv_bfp(a6)   include the space */
    move.l a0,bv_bfp(a6)
/* QL: end_ok0 */
end_ok0:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: end_err */
end_err:
/* QL:         move.l  (sp)+,a0        restore channel id */
    move.l (sp)+,a0
/* QL:         rts */
    rts 
/* QL: * Now... we want to do one of two things: */
/* QL: * If lsfil is set, we absolutely must do that one, but we can then fill the */
/* QL: * screen to our heart's content. */
/* QL: * If lsfil is not set, we want to stop as soon as d6 has been done. */
/* QL: tst_rnge */
tst_rnge:
/* QL:         cmp.w   d6,d1           is it ok to print? */
    cmp.w d6,d1
/* QL:         bls.s   chk_top         yes, go do it */
    bls.s chk_top
/* QL:         tst.b   bv_lsany(a6)    listing to list channel? */
    tst.b bv_lsany(a6)
/* QL:         beq.s   end_ok0         no, finished printing */
    beq.s end_ok0
/* QL:         move.w  bv_lsfil(a6),d0 are we filling the window? */
    move.w bv_lsfil(a6),d0
/* QL:         beq.s   end_ok0         nope, so stop */
    beq.s end_ok0
/* QL:         cmp.w   d0,d1           have we done the required line yet? */
    cmp.w d0,d1
/* QL:         bls.s   chk_top         not, keep on printing */
    bls.s chk_top
/* QL:         move.w  bv_maxln(a6),d0 */
    move.w bv_maxln(a6),d0
/* QL:         cmp.w   bv_totln(a6),d0 do we have any space left on the screen? */
    cmp.w bv_totln(a6),d0
/* QL:         ble.s   end_ok0         no, stop now */
    ble.s end_ok0
/* QL: chk_top */
chk_top:
/* QL:         tst.w   d1              are we at the end of the program */
    tst.w d1
/* QL:         ble.s   end_ok0         yes, so this must be the end! */
    ble.s end_ok0
/* QL:         bsr.s   prlno */
    bsr.s prlno
/* QL:         pea     preol           return at w.eol up to print line */
    pea preol(pc)
/* QL: * Convert program file line to text in basic buffer */
/* QL: * d0 -  o- 10 */
/* QL: * d1 -  o- w.lno */
/* QL: * d3 -  o- 16  */
/* QL: * d4 -ip - keyword table address */
/* QL: * a0 -i o- base of basic buffer / after newline (bv_bfp left with a0-1) */
/* QL: * a1 -  o- pa_tbsym */
/* QL: * a4 -i o- lno token at start of line / newline token at end of line */
/* QL: * d2 destroyed */
/* QL: makeline */
makeline:
/* QL:         moveq   #16,d3          enough for known tokens + msb clear */
    moveq #16,d3
/* QL:         bsr.s   chbf */
    bsr.s chbf
/* QL:         jsr     ib_nxtk(pc)     1st byte in d0.l, full word in d1.l (msbs=0) */
    jsr ib_nxtk(pc)
/* QL:         pea     makeline */
    pea makeline(pc)
/* QL:         sub.b   d3,d0           this should sort valid tokens and fp ... */
    sub.b d3,d0
/* QL:         bvs.s   istok           tokens $80-$8f will go to $70-$7f with v set */
    bvs.s istok
/* QL:         rol.w   #8,d3           make it $1000 */
    rol.w #8,d3
/* QL:         add.w   d1,d3           this should get the exponent ok */
    add.w d1,d3
/* QL:         bcc.s   pr_prbad        it wasn't $fxxx, so it isn't really fp! */
    bcc.s pr_prbad
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.w  d3,0(a6,a1.l)   put corrected exponent */
    move.w d3,0(a6,a1.l)
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) and mantissa onto arithmetic stack */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL:         jmp     cn_ftod(pc)     do the conversion */
    jmp cn_ftod(pc)
/* QL: istok */
istok:
/* QL:         move.b  pr_tab-$70(pc,d0.w),d0 get offset of relevent print routine */
    move.b (pr_tab-0x70)(pc,d0.w),d0
/* QL:         jmp     pr_jmp(pc,d0.w) jump to it (a line feed drops return addr) */
.word 0x4efb
.word 0|((pr_jmp-.)&255)
/* QL: prlno */
prlno:
/* QL:         move.l  bv_bfbas(a6),a0 reset buffer */
    move.l bv_bfbas(a6),a0
/* QL:         bsr.s   itodd1          do conversion */
    bsr.s itodd1
/* QL:         bra.s   prtsp           tack on a space */
    bra.s prtsp
/* QL: pr_tab */
pr_tab:
/* QL: pr_tab macro */
/* QL:  pr_tab spc key bip bif sym ops mon syv nam shi lgi str txt lno sep bad */
/* QL:         assert 16,[.nparms] */
/* original assertion: 16,16 */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+1-1,b.spc&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2205:
.byte (((pr_prspc-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+2-1,b.key&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2215:
.byte (((pr_prkey-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+3-1,b.bip&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2225:
.byte (((pr_prbip-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+4-1,b.bif&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2235:
.byte (((pr_prbif-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+5-1,b.sym&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2245:
.byte (((pr_prsym-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+6-1,b.ops&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2255:
.byte (((pr_props-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+7-1,b.mon&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2265:
.byte (((pr_prmon-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+8-1,b.syv&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2275:
.byte (((pr_prsyv-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+9-1,b.nam&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2285:
.byte (((pr_prnam-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+10-1,b.shi&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2295:
.byte (((pr_prshi-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+11-1,b.lgi&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2305:
.byte (((pr_prlgi-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+12-1,b.str&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2315:
.byte (((pr_prstr-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+13-1,b.txt&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2325:
.byte (((pr_prtxt-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+14-1,b.lno&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2335:
.byte (((pr_prlno-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+15-1,b.sep&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2345:
.byte (((pr_prsep-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-pr_jmp)&$FFFF */
dc_anchor_2353:
.byte (((pr_prbad-pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL:         ds.w    0 */
.balign 2,0
/* QL: chbf */
chbf:
/* QL:         move.l  a0,bv_bfp(a6) set buffer ptr */
    move.l a0,bv_bfp(a6)
/* QL:         add.l   d3,a0 */
    add.l d3,a0
/* QL:         cmp.l   bv_bfp+4(a6),a0 */
    cmp.l (bv_bfp+4)(a6),a0
/* QL:         sub.l   d3,a0 */
    sub.l d3,a0
/* QL:         blt.s   rts6            allow one extra */
    blt.s rts6
/* QL:         move.l  d3,d1 */
    move.l d3,d1
/* QL:         addq.l  #1,d1           just to cope with quoted string */
    addq.l #1,d1
/* QL:         sub.l   bv_pfbas(a6),a4 relative pos of program file pointer */
    sub.l bv_pfbas(a6),a4
/* QL:         jsr     bv_chbfx(pc) */
    jsr bv_chbfx(pc)
/* QL:         add.l   bv_pfbas(a6),a4 restore */
    add.l bv_pfbas(a6),a4
/* QL: rts6 */
rts6:
/* QL:         rts */
    rts 
/* QL: pr_jmp ; jump table vectors come here */
pr_jmp:
/* QL: pr_prshi */
pr_prshi:
/* QL:         ext.w   d1 */
    ext.w d1
/* QL: itodd1 */
itodd1:
/* QL:         move.w  d1,d0 */
    move.w d1,d0
/* QL: itodd0 */
itodd0:
/* QL:         jmp     cn_0tod(pc) */
    jmp cn_0tod(pc)
/* QL: pr_prlgi */
pr_prlgi:
/* QL:         move.w  2(a6,a4.l),d0 */
    move.w 2(a6,a4.l),d0
/* QL:         bra.s   itodd0 */
    bra.s itodd0
/* QL: pr_prnam */
pr_prnam:
/* QL:         move.w  2(a6,a4.l),d0   get name number */
    move.w 2(a6,a4.l),d0
/* QL:         lsl.l   #3,d0           get byte offset */
    lsl.l #3,d0
/* QL:         move.l  bv_ntbas(a6),a1 base of name table */
    move.l bv_ntbas(a6),a1
/* QL:         add.l   d0,a1           pointer to name */
    add.l d0,a1
/* QL:         move.w  2(a6,a1.l),d2   get name list offset */
    move.w 2(a6,a1.l),d2
/* QL:         bpl.s   prnam           must have positive offset */
    bpl.s prnam
/* QL: pr_prlno ; shouldn't get these anywhere but at start of line! */
pr_prlno:
/* QL: pr_prbip */
pr_prbip:
/* QL: pr_prbif */
pr_prbif:
/* QL: pr_prsyv */
pr_prsyv:
/* QL: pr_prbad */
pr_prbad:
/* QL:         moveq   #4,d3 */
    moveq #4,d3
/* QL:         moveq   #'?',d2 */
    moveq #63,d2
/* QL:         bra.s   prmult */
    bra.s prmult
/* QL: pr_prkey */
pr_prkey:
/* QL:         move.l  d4,a1           get the pointer to the keyword table            */
    move.l d4,a1
/* QL:         move.b  d1,d3           get which keyword */
    move.b d1,d3
/* QL:         move.b  0(a1,d3.w),d3   get offset from start of keywords */
    move.b 0(a1,d3.w),d3
/* QL:         add.w   d3,a1           start of key */
    add.w d3,a1
/* QL:         move.b  (a1)+,d3        read pre-byte */
    move.b (a1)+,d3
/* QL:         lsr.b   #4,d3           get length */
    lsr.b #4,d3
/* QL:         bsr.s   prabs           print the keyword */
    bsr.s prabs
/* QL:         cmp.w   #w.eol,2(a6,a4.l) is this keyword at the eond of the line */
    cmp.w #w.eol,2(a6,a4.l)
/* QL:         beq.s   rts8            yes, so leave it at that */
    beq.s rts8
/* QL: prtsp */
prtsp:
/* QL:         moveq   #' ',d2 */
    moveq #32,d2
/* QL: prchr */
prchr:
/* QL:         move.b  d2,0(a6,a0.l) */
    move.b d2,0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL: rts8 */
rts8:
/* QL:         rts */
    rts 
/* QL: pr_prspc */
pr_prspc:
/* QL:         move.b  d1,d3 */
    move.b d1,d3
/* QL:         bsr.s   chbf            gotta check it'll fit */
    bsr.s chbf
/* QL:         moveq   #' ',d2         set space */
    moveq #32,d2
/* QL: prmult */
prmult:
/* QL:         bsr.s   prchr           do the print */
    bsr.s prchr
/* QL:         subq.b  #1,d3           finished yet? */
    subq.b #1,d3
/* QL:         bne.s   prmult          ..no */
    bne.s prmult
/* QL:         rts */
    rts 
/* QL: pr_prsym */
pr_prsym:
/* QL:         move.b  d1,d0           which symbol */
    move.b d1,d0
/* QL:         lea     pa_tbsym(pc),a1 */
    lea pa_tbsym(pc),a1
/* QL:         move.b  -1(a1,d0.w),d2 */
    move.b (-1)(a1,d0.w),d2
/* QL: * Sneaky trick based on the fact that the value of a line feed is = to its num */
/* QL:         cmp.b   d1,d2 */
    cmp.b d1,d2
/* QL:         bne.s   prchr           if not a line feed, just add it to buffer */
    bne.s prchr
/* QL:         addq.l  #4,sp           scrap normal return */
    addq.l #4,sp
/* QL:         bra.s   prchr           go tack on the newline then return */
    bra.s prchr
/* QL: pr_prstr */
pr_prstr:
/* QL:         bsr.s   quote           print opening string quote */
    bsr.s quote
/* QL:         bsr.s   pr_prtxt        print the string */
    bsr.s pr_prtxt
/* QL: quote */
quote:
/* QL:         move.b  1(a6,a4.l),d2   string delimiter single/double quotes */
    move.b 1(a6,a4.l),d2
/* QL:         bra.s   prchr */
    bra.s prchr
/* QL: pr_prmon */
pr_prmon:
/* QL:         lea     pa_tbmon(pc),a1 */
    lea pa_tbmon(pc),a1
/* QL: prky1 */
prky1:
/* QL:         move.b  d1,d3           get which thing */
    move.b d1,d3
/* QL:         move.b  0(a1,d3.w),d3   get offset from start of things */
    move.b 0(a1,d3.w),d3
/* QL:         add.w   d3,a1           start of thing */
    add.w d3,a1
/* QL:         moveq   #15,d3 */
    moveq #15,d3
/* QL:         and.b   (a1)+,d3        read pre-byte */
    and.b (a1)+,d3
/* QL: prabs */
prabs:
/* QL:         move.b  (a1)+,0(a6,a0.l) */
    move.b (a1)+,0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bgt.s   prabs */
    bgt.s prabs
/* QL:         rts */
    rts 
/* QL: prnam */
prnam:
/* QL:         move.l  bv_nlbas(a6),a1 base of name list */
    move.l bv_nlbas(a6),a1
/* QL:         lea     -3(a1,d2.w),a1  start of name, as if it were a text token */
    lea (-3)(a1,d2.w),a1
/* QL:         move.b  3(a6,a1.l),d3   name length */
    move.b 3(a6,a1.l),d3
/* QL:         sub.l   a4,a1           relative pos of text/name pointer */
    sub.l a4,a1
/* QL: rel_chk */
rel_chk:
/* QL:         beq.s   rts9            ignore zero length */
    beq.s rts9
/* QL:         bsr.l   chbf */
    bsr.w chbf
/* QL:         add.l   a4,a1           restore */
    add.l a4,a1
/* QL: prrel */
prrel:
/* QL:         move.b  4(a6,a1.l),0(a6,a0.l) */
    move.b 4(a6,a1.l),0(a6,a0.l)
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bgt.s   prrel */
    bgt.s prrel
/* QL: rts9 */
rts9:
/* QL:         rts */
    rts 
/* QL: pr_prtxt */
pr_prtxt:
/* QL:         sub.l   a1,a1           set where text token starts */
    sub.l a1,a1
/* QL:         move.w  2(a6,a4.l),d3   get length of text */
    move.w 2(a6,a4.l),d3
/* QL:         bra.s   rel_chk         print text */
    bra.s rel_chk
/* QL: pr_prsep */
pr_prsep:
/* QL:         lea     pa_tbsep(pc),a1 */
    lea pa_tbsep(pc),a1
/* QL:         bra.s   prky1 */
    bra.s prky1
/* QL: pr_props */
pr_props:
/* QL:         lea     pa_tbops(pc),a1 */
    lea pa_tbops(pc),a1
/* QL:         bra.s   prky1 */
    bra.s prky1
/* QL:         end */
