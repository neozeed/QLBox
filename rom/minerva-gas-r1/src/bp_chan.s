/* Generated from original/M/bp/chan.asm */
/* QL: * Get channel id if possible */
/* QL:         xdef    bp_chan,bp_chand,bp_chnid,bp_chnew */
.globl bp_chan,bp_chand,bp_chnid,bp_chnew
/* QL:         xref    ca_gtin1 */
/* QL:         xref    bv_chchx */
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
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL: c.defex equ     1               default channel to use if none specd */
.equ c.defex,1
/* QL: * Should really be taken from the bv area depending on what we're doing */
/* QL:         section bp_chan */
.section bp_chan,"ax"
/* QL: * Start up a new superbasic channel number. */
/* QL: * d0 -  o- 0 if ok or err.ex if channel already open */
/* QL: * d1 -ip - channel number , 0 - n, n undecided and may exceed max so far */
/* QL: * a0 -ip - new channel id */
/* QL: * a2 -  o- sb channel location */
/* QL: * All other registers preserved */
/* QL: * If the channel was already open, nothing will have been changed */
/* QL: * If the channel table is extended, it is done with all $ff's */
/* QL: * If a good slot is found, the new id will be stored and the rest zero, except */
/* QL: * for filling in 80 as the line width. */
/* QL: extend */
extend:
/* QL:         movem.l d1-d2,-(sp)     save channo/? */
    movem.l d1-d2,-(sp)
/* QL:         moveq   #ch.lench,d1    we need a whole extra slot */
    moveq #ch.lench,d1
/* QL:         add.l   a2,d1 */
    add.l a2,d1
/* QL:         sub.l   bv_chp(a6),d1   extra amount needed */
    sub.l bv_chp(a6),d1
/* QL:         move.l  d1,-(sp)        save it */
    move.l d1,-(sp)
/* QL:         jsr     bv_chchx(pc)    make sure there's enough room */
    jsr bv_chchx(pc)
/* QL:         movem.l (sp)+,d0-d2     get back extra/channo/? */
    movem.l (sp)+,d0-d2
/* QL: fill */
fill:
/* QL:         move.l  bv_chp(a6),a2   pick up current pointer */
    move.l bv_chp(a6),a2
/* QL:         st      0(a6,a2.l)      wipe all new space to -1 (closed) */
    st 0(a6,a2.l)
/* QL:         addq.l  #1,bv_chp(a6)   update by extra */
    addq.l #1,bv_chp(a6)
/* QL:         subq.l  #1,d0 */
    subq.l #1,d0
/* QL:         bne.s   fill */
    bne.s fill
/* QL: bp_chnew */
bp_chnew:
/* QL:         move.l  a0,-(sp)        save new id */
    move.l a0,-(sp)
/* QL:         bsr.s   bp_chnid        where does channel id go? */
    bsr.s bp_chnid
/* QL:         move.l  (sp)+,a0        reload new id */
    move.l (sp)+,a0
/* QL:         beq.s   err_ex          ouch, channel is already open */
    beq.s err_ex
/* QL:         subx.b  d0,d0           is slot there? */
    subx.b d0,d0
/* QL:         bpl.s   extend          no, so go make more room */
    bpl.s extend
/* QL:         move.l  a0,ch.id(a6,a2.l) insert the new channel id */
    move.l a0,ch.id(a6,a2.l)
/* QL:         moveq   #ch.lench-4,d0  less one long word per channel to be cleared */
    moveq #(ch.lench-4),d0
/* QL:         add.l   d0,a2 */
    add.l d0,a2
/* QL: clr_block */
clr_block:
/* QL:         clr.l   0(a6,a2.l) */
    clr.l 0(a6,a2.l)
/* QL:         subq.l  #4,a2 */
    subq.l #4,a2
/* QL:         subq.l  #4,d0 */
    subq.l #4,d0
/* QL:         bne.s   clr_block */
    bne.s clr_block
/* QL:         move.w  #80,ch.width(a6,a2.l) 80 character line */
    move.w #80,ch.width(a6,a2.l)
/* QL: ok_rts */
ok_rts:
/* QL:         moveq   #0,d0           and no errors */
    moveq #0,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: err_ex */
err_ex:
/* QL:         moveq   #err.ex,d0      channel exists */
    moveq #err.ex,d0
/* QL:         rts */
    rts 
/* QL: * Determines whether or not next parameter is a channel number and, if so, */
/* QL: * returns the channel id, else returns default */
/* QL: * d0 - lo- error return */
/* QL: * d1 -i o- channel number (set to c.defex if entry at bp_chan) */
/* QL: * a0 -  o- channel id if one exists */
/* QL: * a2 -  o- position of channel block if channel exists */
/* QL: * a3 -i o- next parameter (o=i if no chan given, o=i+8 else) */
/* QL: * a5 -ilo- top parameter(i,o) parameter to convert(l) */
/* QL: * All other registers preserved */
/* QL: regsav  reg     d2-d3/a5 */
/* QL: bp_chan */
bp_chan:
/* QL:         moveq   #c.defex,d1     standard default for most things */
    moveq #c.defex,d1
/* QL: bp_chand */
bp_chand:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         ble.s   bp_chnid */
    ble.s bp_chnid
/* QL:         tst.b   1(a6,a3.l)      check hash flag */
    tst.b 1(a6,a3.l)
/* QL:         bpl.s   bp_chnid        not set, so this isn't a channel */
    bpl.s bp_chnid
/* QL:         movem.l regsav,-(sp) */
    movem.l d2-d3/a5,-(sp)
/* QL:         lea     8(a3),a5 */
    lea 8(a3),a5
/* QL:         jsr     ca_gtin1(pc)    get a single integer */
    jsr ca_gtin1(pc)
/* QL:         move.l  a5,a3 */
    move.l a5,a3
/* QL:         movem.l (sp)+,regsav */
    movem.l (sp)+,d2-d3/a5
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         addq.l  #2,bv_rip(a6) */
    addq.l #2,bv_rip(a6)
/* QL:         moveq   #err.bp,d0      don't like negative channels! (lwr added) */
    moveq #err.bp,d0
/* QL:         tst.w   d1 */
    tst.w d1
/* QL:         bmi.s   rts0 */
    bmi.s rts0
/* QL: * Look up a channel number, return location and, if open, the ID */
/* QL: * d1 -ip - channel number required */
/* QL: * d0 -  o- 0 or err.no */
/* QL: * a0 -i o- if d0=0, the channel id, otherwise input value preserved */
/* QL: * a2 -  o- sb channel location (if d0=err.no and x=0, this is above table) */
/* QL: * x  -  o- if d0=err.no, 0: need more space or 1: closed slot found */
/* QL: * All other registers preserved */
/* QL: bp_chnid */
bp_chnid:
/* QL:         moveq   #ch.lench,d0    chan length */
    moveq #ch.lench,d0
/* QL:         mulu    d1,d0 */
    mulu d1,d0
/* QL:         add.l   bv_chbas(a6),d0 add base of channels */
    add.l bv_chbas(a6),d0
/* QL:         move.l  d0,a2           save the position */
    move.l d0,a2
/* QL:         sub.l   bv_chp(a6),d0   does it exist? */
    sub.l bv_chp(a6),d0
/* QL:         bcc.s   err_no          note: x=1 iff slot is available */
    bcc.s err_no
/* QL:         move.l  ch.id(a6,a2.l),d0 actual id wants to be sent back */
    move.l ch.id(a6,a2.l),d0
/* QL:         bmi.s   err_no          negative id means it's closed */
    bmi.s err_no
/* QL:         move.l  d0,a0           and the id */
    move.l d0,a0
/* QL:         bra.s   ok_rts */
    bra.s ok_rts
/* QL: err_no */
err_no:
/* QL:         moveq   #err.no,d0 */
    moveq #err.no,d0
/* QL:         rts */
    rts 
/* QL:         vect4000 bp_chan,bp_chand,bp_chnew,bp_chnid */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl bp$chan
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chan,(bp_chan-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl bp$chand
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chand,(bp_chand-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl bp$chnew
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chnew,(bp_chnew-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl bp$chnid
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chnid,(bp_chnid-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
