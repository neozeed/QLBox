/* Generated from original/M/sb/unvr.asm */
/* QL: * Basic universe */
/* QL:         xdef    sb_read,sb_unvr */
.globl sb_read,sb_unvr
/* QL:         xref    bv_chssx,bv_die */
/* QL:         xref    bp_chnid,bp_comch,bp_detok,bp_list2,bp_rdbuf */
/* QL:         xref    ib_ernol,ib_glin0,ib_gost,ib_npass,ib_st1,ib_start,ib_stnxi */
/* QL:         xref    ib_stop,ib_stsng,ib_unret */
/* QL:         xref    pa_graph,pa_mist,pa_strip,pa_table */
/* QL:         xref    pf_nwlin */
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
/* QL: c.defcn equ     0       default console channel */
.equ c.defcn,0
/* QL:         section sb_unvr */
.section sb_unvr,"ax"
/* QL: * Code for initial entry only. BV area has been generally zeroed out. */
/* QL: sb_unvr */
sb_unvr:
/* QL:         move.l  a6,sp           move stack right to top of area ... */
    move.l a6,sp
/* QL:         add.l   bv_ssbas(a6),sp ... by adding offset to top of superbasic */
    add.l bv_ssbas(a6),sp
/* QL:         tst.l   bv_comch(a6) */
    tst.l bv_comch(a6)
/* QL:         bne.s   nxlset */
    bne.s nxlset
/* QL:         subq.w  #1,bv_nxlin(a6) if no command channel, set nxlin -1 */
    subq.w #1,bv_nxlin(a6)
/* QL: nxlset */
nxlset:
/* QL:         bsr.s   universe        entry, putting out-of-memory return on stack */
    bsr.s universe
/* QL: errom */
errom:
/* QL:         jsr     ib_stop(pc)     come here when life gets hard */
    jsr ib_stop(pc)
/* QL:         bsr.s   sb_read         reinstate return for out-of-memory */
    bsr.s sb_read
/* QL:         bra.s   errom */
    bra.s errom
/* QL: eof */
eof:
/* QL:         tst.l   bv_comch(a6)    were were already reading #0? */
    tst.l bv_comch(a6)
/* QL:         beq.l   bv_die          yes - can't handle that! */
    beq.w bv_die
/* QL:         pea     rr_chk */
    pea rr_chk(pc)
/* QL: com_zap */
com_zap:
/* QL:         sub.l   a0,a0           flag for #0 */
    sub.l a0,a0
/* QL:         jmp     bp_comch(pc)    set as the new command channel */
    jmp bp_comch(pc)
/* QL: bad_rdb */
bad_rdb:
/* QL:         move.l  d0,d1           bad read, see why */
    move.l d0,d1
/* QL:         addq.l  #-err.no,d1     not open ... */
.word 20609|((((-err.no))&7)<<9)
/* QL:         beq.s   eof             ... treat as end of file */
    beq.s eof
/* QL:         addq.l  #err.no-err.ef,d1 really end of file? */
.word 20609|((((err.no-err.ef))&7)<<9)
/* QL:         beq.s   eof             yes - probably just end of a load, etc */
    beq.s eof
/* QL:         jsr     ib_ernol(pc)    different error, tell user */
    jsr ib_ernol(pc)
/* QL: off_auto */
off_auto:
/* QL:         sf      bv_auto(a6)     turn off the auto/edit flag */
    sf bv_auto(a6)
/* QL: sb_read */
sb_read:
/* QL:         bsr.s   com_zap         turn off any command file / set initial one */
    bsr.s com_zap
/* QL:         tst.b   (sp)            was there a command line to restore? */
    tst.b (sp)
/* QL:         bpl.s   universe        no, just read a new line then */
    bpl.s universe
/* QL:         addq.l  #2+4,sp         drop misc saved stuff */
    addq.l #(2+4),sp
/* QL:         add.w   (sp)+,sp        drop length and contents of command line */
    add.w (sp)+,sp
/* QL: universe */
universe:
/* QL:         clr.l   bv_sssav(a6)    set save pointer to top of ss stack */
    clr.l bv_sssav(a6)
/* QL:         move.l  bv_bfbas(a6),bv_bfp(a6) reset buffer */
    move.l bv_bfbas(a6),bv_bfp(a6)
/* QL:         moveq   #0,d3           show raw new line */
    moveq #0,d3
/* QL:         tst.b   bv_auto(a6)     is this an auto/edit or fetch? */
    tst.b bv_auto(a6)
/* QL:         beq.s   edit            ..fetch */
    beq.s edit
/* QL:         move.w  bv_edlin(a6),d4 set line to edit */
    move.w bv_edlin(a6),d4
/* QL:         ble.s   off_auto        if the line has become silly ... */
    ble.s off_auto
/* QL:         jsr     bp_detok(pc)    go and put the line in the buffer(no lf) */
    jsr bp_detok(pc)
/* QL:         move.w  bv_edinc(a6),d0 read the increment */
    move.w bv_edinc(a6),d0
/* QL:         sne     bv_auto(a6)     if it's zero then turn edit off again */
    sne bv_auto(a6)
/* QL:         add.w   d0,bv_edlin(a6) otherwise get line to edit next time */
    add.w d0,bv_edlin(a6)
/* QL:         move.l  bv_bfp(a6),d3 */
    move.l bv_bfp(a6),d3
/* QL:         sub.l   bv_bfbas(a6),d3 put cursor at end of line */
    sub.l bv_bfbas(a6),d3
/* QL: edit */
edit:
/* QL:         bsr.s   comch           only allow edit if reading from console */
    bsr.s comch
/* QL:         jsr     bp_rdbuf(pc)    read line into the buffer */
    jsr bp_rdbuf(pc)
/* QL:         bne.s   bad_rdb         problem... go sort it out */
    bne.s bad_rdb
/* QL:         tas     bv_brk(a6)      clear break */
    tas bv_brk(a6)
/* QL:         moveq   #' ',d7         for space trim and infinite pa_graph buffer */
    moveq #32,d7
/* QL:         moveq   #27,d0 */
    moveq #27,d0
/* QL:         sub.b   -1(a6,a1.l),d0  what was the delimiter? */
    sub.b (-1)(a6,a1.l),d0
/* QL:         scs     bv_arrow(a6)    0 if lf/esc, ff if up/down */
    scs bv_arrow(a6)
/* QL:         beq.s   off_auto        esc, turn off auto and get a new line */
    beq.s off_auto
/* QL:         add.b   #$d8-27,d0      was it down arrow?  */
    add.b #((0xd8-27)&255),d0
/* QL:         bne.s   trimit          no - all is ok */
    bne.s trimit
/* QL:         addq.b  #2,bv_arrow(a6) yes - change ff to 01 */
    addq.b #2,bv_arrow(a6)
/* QL: trimit */
trimit:
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         cmp.l   bv_bfbas(a6),a1 */
    cmp.l bv_bfbas(a6),a1
/* QL:         beq.s   universe        ignore totally blank line */
    beq.s universe
/* QL:         cmp.b   -1(a6,a1.l),d7  strip off trailing blanks */
    cmp.b (-1)(a6,a1.l),d7
/* QL:         beq.s   trimit */
    beq.s trimit
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         move.b  #10,-1(a6,a1.l) put in a straight line feed */
    move.b #(10&255),(-1)(a6,a1.l)
/* QL:         move.l  a1,bv_bfp(a6)   now update the buffer running pointer */
    move.l a1,bv_bfp(a6)
/* QL:         bra.s   parse           go parse the line */
    bra.s parse
/* QL: comch */
comch:
/* QL:         move.l  bv_comch(a6),a0 get command channel */
    move.l bv_comch(a6),a0
/* QL:         move.l  a0,d0           ..is there one? */
    move.l a0,d0
/* QL:         bne.s   rts0            yes, fine */
    bne.s rts0
/* QL:         moveq   #c.defcn,d1     get default channel */
    moveq #c.defcn,d1
/* QL:         move.w  #-1,a0          if channel not found, file not open will end us */
    move.w #(-1),a0
/* QL:         jmp     bp_chnid(pc) */
    jmp bp_chnid(pc)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: dumrt */
dumrt:
/* QL:         moveq   #4,d1           select stack depth */
    moveq #4,d1
/* QL:         jsr     ib_unret(pc)    error message and unravel all */
    jsr ib_unret(pc)
/* QL: parse */
parse:
/* QL:         lea     pa_table(pc),a2 set start of table */
    lea pa_table(pc),a2
/* QL:         jsr     pa_graph(pc)    go into graph parsing routine */
    jsr pa_graph(pc)
/* QL:         beq.s   strip           all ok, go use the line */
    beq.s strip
/* QL:         bgt.s   dumrt           lno (or new name?) input, unravel needed */
    bgt.s dumrt
/* QL:         bsr.s   comch           parse failed, is this a file or a user? */
    bsr.s comch
/* QL:         bne.s   mist            it's a file, write mistake into prog */
    bne.s mist
/* QL:         subq.l  #1,bv_bfp(a6)   lose the terminator */
    subq.l #1,bv_bfp(a6)
/* QL:         sub.l   bv_bfbas(a6),a4 we will show where the problems started */
    sub.l bv_bfbas(a6),a4
/* QL:         move.w  a4,-(sp) */
    move.w a4,-(sp)
/* QL:         moveq   #err.bl,d0 */
    moveq #err.bl,d0
/* QL:         jsr     ib_ernol(pc)    call error with no line number */
    jsr ib_ernol(pc)
/* QL:         move.w  (sp)+,d3 */
    move.w (sp)+,d3
/* QL:         bra.s   edit            continue edit */
    bra.s edit
/* QL: mist */
mist:
/* QL:         jsr     pa_mist(pc) */
    jsr pa_mist(pc)
/* QL: strip */
strip:
/* QL:         jsr     pa_strip(pc)    strip out superfluous spaces */
    jsr pa_strip(pc)
/* QL:         jsr     pf_nwlin(pc)    save the program line */
    jsr pf_nwlin(pc)
/* QL:         bra.s   doline          +0 - no line number, execute at once */
    bra.s doline
/* QL: *       sf      bv_sing(a6)     +2 - line inserted into program file */
/* QL: * Above line seems redundant - see if it falls over without it */
/* QL:         move.l  d0,d3           state of line for relisting */
    move.l d0,d3
/* QL:         bsr.s   qcomch          if lines from file, go to top */
    bsr.s qcomch
/* QL:         tst.l   d5              new pf_nwlin flag, zero if program is unchanged */
    tst.l d5
/* QL:         beq.s   sb_rd2          no change to program, so don't relist */
    beq.s sb_rd2
/* QL:         jsr     bp_list2(pc)    relist if d2/d3 imply extant screen change */
    jsr bp_list2(pc)
/* QL: sb_rd2 */
sb_rd2:
/* QL:         bra.l   sb_read         go and read the next line */
    bra.w sb_read
/* QL: qcomch */
qcomch:
/* QL:         bsr.s   comch           are we reading from a file? */
    bsr.s comch
/* QL:         beq.s   rts0            no - carry on */
    beq.s rts0
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         bra.l   universe        back up to the top */
    bra.w universe
/* QL: doline */
doline:
/* QL:         move.l  bv_tkbas(a6),a4 tell start where to start */
    move.l bv_tkbas(a6),a4
/* QL:         move.b  #1,bv_stmnt(a6) */
    move.b #(1&255),bv_stmnt(a6)
/* QL:         sf      bv_inlin(a6) */
    sf bv_inlin(a6)
/* QL:         st      bv_cont(a6)     turn continue flag on (ie stop off) */
    st bv_cont(a6)
/* QL: do_1 */
do_1:
/* QL:         st      bv_sing(a6) */
    st bv_sing(a6)
/* QL:         assert  bv_linum,bv_lengt-2 */
/* original assertion: bv_linum,bv_lengt-2 */
/* QL:         clr.l   bv_linum(a6)    initialise line number and length */
    clr.l bv_linum(a6)
/* QL:         jsr     ib_npass(pc) */
    jsr ib_npass(pc)
/* QL: *       sf      bv_comln(a6)    first unset the flag - not needed? */
/* QL:         jsr     ib_stsng(pc)    start the single line */
    jsr ib_stsng(pc)
/* QL:         bne.s   sb_rd2          had an error, close input, read a new line */
    bne.s sb_rd2
/* QL:         tst.b   bv_comln(a6)    must we save the command line */
    tst.b bv_comln(a6)
/* QL:         beq.s   resrun          no */
    beq.s resrun
/* QL:         subq.w  #4,bv_stopn(a6) */
    subq.w #4,bv_stopn(a6)
/* QL:         blt.s   do_1            if clear, carry on */
    blt.s do_1
/* QL:         beq.s   sb_rd2          if stop, get a new line */
    beq.s sb_rd2
/* QL:         assert  bv_tkbas,bv_tkp-4 */
/* original assertion: bv_tkbas,bv_tkp-4 */
/* QL:         movem.l bv_tkbas(a6),a0-a1 */
    movem.l bv_tkbas(a6),a0-a1
/* QL:         moveq   #(256+2+4+2+3)>>2,d1 */
    moveq #(((((256+2)+4)+2)+3)>>2),d1
/* QL:         lsl.l   #2,d1 */
    lsl.l #2,d1
/* QL:         add.l   a1,d1 */
    add.l a1,d1
/* QL:         sub.l   a0,d1 */
    sub.l a0,d1
/* QL:         jsr     bv_chssx(pc)    ensure space on the stack (added by lwr) */
    jsr bv_chssx(pc)
/* QL:         move.l  a1,a2 */
    move.l a1,a2
/* QL: push_com */
push_com:
/* QL:         subq.l  #2,a2 */
    subq.l #2,a2
/* QL:         move.w  0(a6,a2.l),-(sp) */
    move.w 0(a6,a2.l),-(sp)
/* QL:         cmp.l   a2,a0           finished yet? */
    cmp.l a2,a0
/* QL:         bne.s   push_com */
    bne.s push_com
/* QL: * N.B. The following assumes that the token list is never longer than 32766, */
/* QL: * but I guess that's fairly reasonable... lwr */
/* QL:         sub.l   a0,a1           length of token list saved */
    sub.l a0,a1
/* QL:         move.w  a1,-(sp) */
    move.w a1,-(sp)
/* QL:         assert  bv_inlin,bv_sing-1,bv_index-2 */
/* original assertion: bv_inlin,bv_sing-1,bv_index-2 */
/* QL:         move.l  bv_inlin(a6),-(sp) */
    move.l bv_inlin(a6),-(sp)
/* QL:         move.b  bv_stmnt(a6),1(sp) the statement number */
    move.b bv_stmnt(a6),1(sp)
/* QL:         sub.l   a4,a0           negative offset of where we got to */
    sub.l a4,a0
/* QL:         move.w  a0,-(sp) */
    move.w a0,-(sp)
/* QL: resrun */
resrun:
/* QL:         bsr.s   qcomch          if lines from file, go to top */
    bsr.s qcomch
/* QL: rr_chk */
rr_chk:
/* QL:         tst.w   bv_nxlin(a6)    should we restore or run? */
    tst.w bv_nxlin(a6)
/* QL:         bge.s   run */
    bge.s run
/* QL:         tst.b   (sp)            no, is there a command line to restore */
    tst.b (sp)
/* QL:         bpl.s   sb_rd3          no, just read a new line then */
    bpl.s sb_rd3
/* QL:         move.l  bv_tkbas(a6),a0 start at beginning of toklist */
    move.l bv_tkbas(a6),a0
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         sub.w   (sp)+,a4        a4 now pointing to next bit of sing to do */
    sub.w (sp)+,a4
/* QL:         move.b  1(sp),bv_stmnt(a6) restore the statement */
    move.b 1(sp),bv_stmnt(a6)
/* QL:         move.l  (sp)+,bv_inlin(a6) */
    move.l (sp)+,bv_inlin(a6)
/* QL:         move.w  (sp)+,d0        length of command line */
    move.w (sp)+,d0
/* QL: pop_com */
pop_com:
/* QL:         move.w  (sp)+,0(a6,a0.l) */
    move.w (sp)+,0(a6,a0.l)
/* QL:         addq.l  #2,a0 */
    addq.l #2,a0
/* QL:         subq.w  #2,d0           done yet? */
    subq.w #2,d0
/* QL:         bne.s   pop_com */
    bne.s pop_com
/* QL:         move.l  a0,bv_tkp(a6)   reset the running pointer */
    move.l a0,bv_tkp(a6)
/* QL:         bra.s   do_1 */
    bra.s do_1
/* QL: sb_rd3 */
sb_rd3:
/* QL:         bra.l   sb_read */
    bra.w sb_read
/* QL: run */
run:
/* QL:         jsr     ib_npass(pc) */
    jsr ib_npass(pc)
/* QL:         sf      bv_sing(a6) */
    sf bv_sing(a6)
/* QL:         move.b  #1,bv_stmnt(a6) */
    move.b #(1&255),bv_stmnt(a6)
/* QL:         move.w  bv_nxlin(a6),d4 now then, where are we to start? */
    move.w bv_nxlin(a6),d4
/* QL:         jsr     ib_glin0(pc)    find it */
    jsr ib_glin0(pc)
/* QL:         ble.s   sb_rd3          not in program, so ignore */
    ble.s sb_rd3
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         move.w  d1,bv_lengt(a6) set prior line length */
    move.w d1,bv_lengt(a6)
/* QL:         tst.w   d4 */
    tst.w d4
/* QL:         beq.s   ib_1            start at the top, ignore nxstm */
    beq.s ib_1
/* QL:         move.b  bv_nxstm(a6),d4 which statement? */
    move.b bv_nxstm(a6),d4
/* QL:         beq.s   ib_1            the first statement */
    beq.s ib_1
/* QL:         jsr     ib_stnxi(pc) */
    jsr ib_stnxi(pc)
/* QL:         jsr     ib_gost(pc) */
    jsr ib_gost(pc)
/* QL: go */
go:
/* QL:         jsr     ib_st1(pc)      start from next statement */
    jsr ib_st1(pc)
/* QL: ib_ret */
ib_ret:
/* QL:         bne.s   sb_rd3          had an error, read a new line (? work ?) */
    bne.s sb_rd3
/* QL:         tst.w   bv_stopn(a6)    why have we come back ? */
    tst.w bv_stopn(a6)
/* QL:         beq.s   go              if clear, carry straight on */
    beq.s go
/* QL:         bra.s   resrun          if not clear, then read, run or restore */
    bra.s resrun
/* QL: ib_1 */
ib_1:
/* QL:         jsr     ib_start(pc)    start from top of a line */
    jsr ib_start(pc)
/* QL:         bra.s   ib_ret */
    bra.s ib_ret
/* QL:         end */
