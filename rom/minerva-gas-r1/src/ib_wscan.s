/* Generated from original/M/ib/wscan.asm */
/* QL: * Scan for when variable entries */
/* QL:         xdef    ib_ewret,ib_wscan,ib_wscnx,ib_wtest */
.globl ib_ewret,ib_wscan,ib_wscnx,ib_wtest
/* QL:         xref    bv_alvv,bv_frvv */
/* QL:         xref    ca_evalc */
/* QL:         xref    ib_golin,ib_gost,ib_nxnon,ib_stbas,ib_stnxi */
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
/* QL:         include 'win1_m_inc_wv' */
/* QL: * when variables */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: wv.row  ds.w    1       variable index */
.equ wv.row,0
/* QL: wv.wlno ds.w    1       WHEN var line */
.equ wv.wlno,2
/* QL: wv.wstm ds.b    1       WHEN var stmt */
.equ wv.wstm,4
/* QL: wv.ewstm ds.b   1       END WHEN stmt */
.equ wv.ewstm,5
/* QL: wv.ewlno ds.w   1       END WHEN line */
.equ wv.ewlno,6
/* QL: wv.rtlno ds.w   1       return line */
.equ wv.rtlno,8
/* QL: wv.rtstm ds.b   1       return stmt */
.equ wv.rtstm,10
/* QL: wv.rtinl ds.b   1       return inlin */
.equ wv.rtinl,11
/* QL: wv.rtind ds.w   1       return index */
.equ wv.rtind,12
/* QL: wv.inlin ds.b   1       inline WHEN */
.equ wv.inlin,14
/* QL: wv.spare ds.b   1 */
.equ wv.spare,15
/* QL: wv.len */
.equ wv.len,16
/* QL:         list */
/* QL: wvshft  equ     4 */
.equ wvshft,4
/* QL:         assert  1<<wvshft,wv.len */
/* original assertion: 1<<wvshft,wv.len */
/* QL:         section ib_wscan */
.section ib_wscan,"ax"
/* QL: * d0 -  o- 0 match found, -1 match not found (n/a if d3 0) */
/* QL: * d1 - l - number of wvtab entries left to look at */
/* QL: * d2 - l - no of active wv entries left to look at */
/* QL: * d3 -i  - +ve look for match on name row */
/* QL: *          -ve look for match on endwhen lno */
/* QL: *            0 look for an empty entry */
/* QL: * d4 -i  - name row, line number or irrelevent depending on d3 */
/* QL: * a2 -  o- entry in wv table */
/* QL: empty */
empty:
/* QL:         tst.b   d3              did we want an empty slot? */
    tst.b d3
/* QL:         bne.s   nx_add          no */
    bne.s nx_add
/* QL:         rts */
    rts 
/* QL: ewlno */
ewlno:
/* QL:         cmp.w   wv.ewlno(a6,a2.l),d4 does the endwhen lno match? */
    cmp.w wv.ewlno(a6,a2.l),d4
/* QL:         bne.s   ib_wscnx        no, try again */
    bne.s ib_wscnx
/* QL:         tst.w   wv.rtlno(a6,a2.l) yes, is it in use? */
    tst.w wv.rtlno(a6,a2.l)
/* QL:         blt.s   ib_wscnx        no, curses */
    blt.s ib_wscnx
/* QL: match */
match:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: no_match */
no_match:
/* QL:         moveq   #-1,d0 */
    moveq #(-1),d0
/* QL:         rts */
    rts 
/* QL: none_set */
none_set:
/* QL:         tst.b   d3              no entries, do we care? */
    tst.b d3
/* QL:         bne.s   no_match        no */
    bne.s no_match
/* QL:         tst.b   bv_wvbas(a6)    yes, are there any empty ones? */
    tst.b bv_wvbas(a6)
/* QL:         bmi.s   expand          no, better make some then */
    bmi.s expand
/* QL: get_base */
get_base:
/* QL:         move.l  bv_vvbas(a6),a2 base of vv area */
    move.l bv_vvbas(a6),a2
/* QL:         add.l   bv_wvbas(a6),a2 add offset to get base of wv table */
    add.l bv_wvbas(a6),a2
/* QL: get_count */
get_count:
/* QL:         moveq   #-wv.len-4,d1   take off size and length of 1st entry */
    moveq #((-wv.len)-4),d1
/* QL:         add.l   0(a6,a2.l),d1   size of table (not to be confused with */
    add.l 0(a6,a2.l),d1
/* QL:                 ;               the number of active when variable entries) */
/* QL:         lsr.l   #wvshft,d1      d1 is now suitable for a "dbra" */
    lsr.l #wvshft,d1
/* QL:         addq.l  #4,a2           position a2 at 1st entry */
    addq.l #4,a2
/* QL:         rts */
    rts 
/* QL: ib_wscan */
ib_wscan:
/* QL:         move.w  bv_wvnum(a6),d2 number of wv entries */
    move.w bv_wvnum(a6),d2
/* QL:         beq.s   none_set        none */
    beq.s none_set
/* QL:         bsr.s   get_base        get base of table */
    bsr.s get_base
/* QL: nx_chk */
nx_chk:
/* QL:         move.w  wv.row(a6,a2.l),d0 get next name row */
    move.w wv.row(a6,a2.l),d0
/* QL:         bmi.s   empty           it's empty */
    bmi.s empty
/* QL:         tst.b   d3              what are we looking for */
    tst.b d3
/* QL:         blt.s   ewlno           an endwhen line number */
    blt.s ewlno
/* QL:         beq.s   nx_add          an empty slot */
    beq.s nx_add
/* QL:         cmp.w   d0,d4           a name row, is it this one? */
    cmp.w d0,d4
/* QL:         beq.s   match           yes, good */
    beq.s match
/* QL: ib_wscnx */
ib_wscnx:
/* QL:         subq.w  #1,d2           decrement active wv entries left */
    subq.w #1,d2
/* QL:         beq.s   no_match        none left */
    beq.s no_match
/* QL: nx_add */
nx_add:
/* QL:         add.w   #wv.len,a2      move to next entry */
    add.w #wv.len,a2
/* QL:         dbra    d1,nx_chk       (if there is one, that is) */
    dbra d1,nx_chk
/* QL: expand */
expand:
/* QL:         moveq   #-1,d1          assume current table length is zero */
    moveq #(-1),d1
/* QL:         tst.b   bv_wvbas(a6)    is there a table here? */
    tst.b bv_wvbas(a6)
/* QL:         bmi.s   get_new         no, we'll make a new one */
    bmi.s get_new
/* QL:         bsr.s   get_base        find how many entries already exist */
    bsr.s get_base
/* QL: get_new */
get_new:
/* QL:         moveq   #20+1,d0        extend by 20 entries */
    moveq #(20+1),d0
/* QL:         add.l   d0,d1 */
    add.l d0,d1
/* QL:         lsl.l   #wvshft,d1 */
    lsl.l #wvshft,d1
/* QL:         addq.l  #4,d1           don't forget the length word */
    addq.l #4,d1
/* QL:         jsr     bv_alvv(pc)     get space for new table */
    jsr bv_alvv(pc)
/* QL:         move.l  d1,0(a6,a0.l)   store size of new table */
    move.l d1,0(a6,a0.l)
/* QL:         move.l  a0,-(sp)        save new table address */
    move.l a0,-(sp)
/* QL:         move.l  a0,a2 */
    move.l a0,a2
/* QL:         bsr.s   get_count       work out how many entries the new table has */
    bsr.s get_count
/* QL:         tst.b   bv_wvbas(a6) */
    tst.b bv_wvbas(a6)
/* QL:         bmi.s   nocopy          this is the first allocation, so no copy */
    bmi.s nocopy
/* QL:         subq.w  #1,d1           dbra for initialising new entries is ... */
    subq.w #1,d1
/* QL:         move.w  d1,-(sp)        ... (new table dbra - old table dbra - 1) */
    move.w d1,-(sp)
/* QL:         bsr.s   get_base        get the old table stuff */
    bsr.s get_base
/* QL:         sub.w   d1,(sp) */
    sub.w d1,(sp)
/* QL: copynxt */
copynxt:
/* QL:         moveq   #wv.len/4-1,d0 */
    moveq #((wv.len/4)-1),d0
/* QL: copy4 */
copy4:
/* QL:         move.l  0(a6,a2.l),4(a6,a0.l) copy the next long word */
    move.l 0(a6,a2.l),4(a6,a0.l)
/* QL: copent */
copent:
/* QL:         addq.l  #4,a2 */
    addq.l #4,a2
/* QL:         addq.l  #4,a0 */
    addq.l #4,a0
/* QL:         dbra    d0,copy4 */
    dbra d0,copy4
/* QL:         dbra    d1,copynxt */
    dbra d1,copynxt
/* QL:         move.w  (sp)+,d1        recover counter for clearing entries */
    move.w (sp)+,d1
/* QL:         lea     4(a0),a2        first entry to clear */
    lea 4(a0),a2
/* QL: nocopy */
nocopy:
/* QL:         moveq   #wv.len,d0 */
    moveq #wv.len,d0
/* QL:         move.l  a2,-(sp)        save first of new, free entries */
    move.l a2,-(sp)
/* QL: clear */
clear:
/* QL:         st      wv.row(a6,a2.l) empty entries are negative */
    st wv.row(a6,a2.l)
/* QL:         add.w   #wv.len,a2 */
    add.w #wv.len,a2
/* QL:         dbra    d1,clear */
    dbra d1,clear
/* QL:         move.l  bv_wvbas(a6),d1 get offset of old table */
    move.l bv_wvbas(a6),d1
/* QL:         blt.s   nofrvv          wasn't one */
    blt.s nofrvv
/* QL:         move.l  bv_vvbas(a6),a0 */
    move.l bv_vvbas(a6),a0
/* QL:         add.l   d1,a0           start of old table */
    add.l d1,a0
/* QL:         move.l  0(a6,a0.l),d1   length of old table */
    move.l 0(a6,a0.l),d1
/* QL:         jsr     bv_frvv(pc)     free it */
    jsr bv_frvv(pc)
/* QL: nofrvv */
nofrvv:
/* QL:         move.l  (sp)+,a2        first unset entry */
    move.l (sp)+,a2
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         sub.l   bv_vvbas(a6),d1 new offset */
    sub.l bv_vvbas(a6),d1
/* QL:         move.l  d1,bv_wvbas(a6) store it */
    move.l d1,bv_wvbas(a6)
/* QL:         rts */
    rts 
/* QL: * Tests if an assignment just made to the variable indicated by its */
/* QL: * name row (token value in program file) satisfies some of the current */
/* QL: * when variable conditions, and,if so, resets the parser to take  */
/* QL: * appropriate action. */
/* QL: * d0     o error return */
/* QL: * d4 i s   name row of variable just assigned to */
/* QL: * a4 i   o parser pointer to program file */
/* QL: * Note: apart from a4, any register may be smashed */
/* QL: ib_wtest */
ib_wtest:
/* QL:         moveq   #1,d3           look for it */
    moveq #1,d3
/* QL:         bsr     ib_wscan */
    bsr ib_wscan
/* QL:         bra.s   chk_cond */
    bra.s chk_cond
/* QL: nx_load */
nx_load:
/* QL:         movem.w (sp)+,d1-d2/d4 */
    movem.w (sp)+,d1-d2/d4
/* QL: nx_scan */
nx_scan:
/* QL:         moveq   #1,d3 */
    moveq #1,d3
/* QL:         bsr     ib_wscnx        look for another */
    bsr ib_wscnx
/* QL: chk_cond */
chk_cond:
/* QL:         bne.s   okrts           not found */
    bne.s okrts
/* QL:         tst.b   wv.rtlno(a6,a2.l) musn't be already in use */
    tst.b wv.rtlno(a6,a2.l)
/* QL:         bpl.s   nx_scan         it is */
    bpl.s nx_scan
/* QL:         move.w  bv_linum(a6),wv.rtlno(a6,a2.l) */
    move.w bv_linum(a6),wv.rtlno(a6,a2.l)
/* QL:         move.b  bv_stmnt(a6),wv.rtstm(a6,a2.l) */
    move.b bv_stmnt(a6),wv.rtstm(a6,a2.l)
/* QL:         move.b  bv_inlin(a6),wv.rtinl(a6,a2.l) */
    move.b bv_inlin(a6),wv.rtinl(a6,a2.l)
/* QL:         move.w  bv_index(a6),wv.rtind(a6,a2.l) */
    move.w bv_index(a6),wv.rtind(a6,a2.l)
/* QL:         movem.w d1-d2/d4,-(sp) */
    movem.w d1-d2/d4,-(sp)
/* QL:         assert  wv.wlno,wv.wstm-2 */
/* original assertion: wv.wlno,wv.wstm-2 */
/* QL:         move.l  wv.wlno(a6,a2.l),d4 get when line/statement number */
    move.l wv.wlno(a6,a2.l),d4
/* QL:         tst.b   bv_sing(a6)     is this a command line */
    tst.b bv_sing(a6)
/* QL:         beq.s   golin           no, ok */
    beq.s golin
/* QL:         jsr     ib_stbas(pc)    yes, find the top */
    jsr ib_stbas(pc)
/* QL: golin */
golin:
/* QL:         bsr.s   goto            go to it */
    bsr.s goto
/* QL:         bne.s   pop_6 */
    bne.s pop_6
/* QL:         jsr     ib_nxnon(pc)    get the when */
    jsr ib_nxnon(pc)
/* QL:         lea     2(a4),a0        skip it */
    lea 2(a4),a0
/* QL:         sub.l   bv_vvbas(a6),a2 */
    sub.l bv_vvbas(a6),a2
/* QL:         move.l  a2,-(sp) */
    move.l a2,-(sp)
/* QL:         jsr     ca_evalc(pc)    and evaluate the condition */
    jsr ca_evalc(pc)
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL:         add.l   bv_vvbas(a6),a2 restore wv entry */
    add.l bv_vvbas(a6),a2
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         ble.s   pop_6           failed */
    ble.s pop_6
/* QL:         addq.l  #2,bv_rip(a6) */
    addq.l #2,bv_rip(a6)
/* QL:         tst.w   0(a6,a1.l)      true or false? */
    tst.w 0(a6,a1.l)
/* QL:         bne.s   gotit           true! we've got work to do */
    bne.s gotit
/* QL:         bsr.s   ib_ewret        return to here */
    bsr.s ib_ewret
/* QL:         beq.s   nx_load */
    beq.s nx_load
/* QL: pop_6 */
pop_6:
/* QL:         addq.l  #6,sp */
    addq.l #6,sp
/* QL:         rts */
    rts 
/* QL: gotit */
gotit:
/* QL:         addq.l  #6,sp */
    addq.l #6,sp
/* QL:         move.b  wv.inlin(a6,a2.l),bv_inlin(a6) */
    move.b wv.inlin(a6,a2.l),bv_inlin(a6)
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: ib_ewret */
ib_ewret:
/* QL:         assert  wv.rtlno,wv.rtstm-2 */
/* original assertion: wv.rtlno,wv.rtstm-2 */
/* QL:         move.l  wv.rtlno(a6,a2.l),d4 return line/statement number */
    move.l wv.rtlno(a6,a2.l),d4
/* QL:         st      wv.rtlno(a6,a2.l) mark as no longer in use */
    st wv.rtlno(a6,a2.l)
/* QL:         move.b  wv.rtinl(a6,a2.l),bv_inlin(a6) */
    move.b wv.rtinl(a6,a2.l),bv_inlin(a6)
/* QL:         move.w  wv.rtind(a6,a2.l),bv_index(a6) */
    move.w wv.rtind(a6,a2.l),bv_index(a6)
/* QL: goto */
goto:
/* QL:         swap    d4              line number to lsw, save statement in msb */
    swap d4
/* QL:         tst.w   d4 */
    tst.w d4
/* QL:         seq     bv_sing(a6)     command line? */
    seq bv_sing(a6)
/* QL:         jsr     ib_golin(pc)    go to it */
    jsr ib_golin(pc)
/* QL:         bne.s   err_nf */
    bne.s err_nf
/* QL:         jsr     ib_stnxi(pc)    start it off */
    jsr ib_stnxi(pc)
/* QL:         rol.l   #8,d4           fetch out statement from msb */
    rol.l #8,d4
/* QL:         jmp     ib_gost(pc)     go to it */
    jmp ib_gost(pc)
/* QL: err_nf */
err_nf:
/* QL:         moveq   #err.nf,d0 */
    moveq #err.nf,d0
/* QL:         rts */
    rts 
/* QL:         end */
