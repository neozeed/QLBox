/* Generated from original/M/bp/read.asm */
/* QL: * Read data value, allowing arrays */
/* QL:         xdef    bp_read,bp_arset,bp_arind,bp_arnxt,bp_arend,bp_rdchk */
.globl bp_read,bp_arset,bp_arind,bp_arnxt,bp_arend,bp_rdchk
/* QL:         xref    bp_data,bp_let */
/* QL:         xref    bv_alvvz,bv_frvv */
/* QL:         xref    ca_eval */
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         offset  0 */
/* QL: d_vvptr ds.l    1       descriptor values vv offset */
.equ d_vvptr,0
/* QL: d_dims  ds.w    1       n = descriptor number of dimensions (0..8191) */
.equ d_dims,4
/* QL: d_max   ds.w    1       max index value (0..32767) \ * n for real descriptor */
.equ d_max,6
/* QL: d_step  ds.w    0       step value (1..32767)      / */
.equ d_step,8
/* QL: d_oldvv ds.l    1       saved descriptor vv offset */
.equ d_oldvv,8
/* QL: d_index ds.w    1       current index * n, last entry unused by (sub-)strings */
.equ d_index,12
/* QL: * Note: we know d_dims < 8191, 'cos a tokenised line had to set it up! */
/* QL: * Check whether object described in name table (a6,a3.l) can be input/read. */
/* QL: * The things which can be read into are: */
/* QL: *       00x1 00x2 00x3  unassiged variables */
/* QL: *       02x1 02x2 02x3  simple variables */
/* QL: *  03x0 03x1            substring and string array */
/* QL: *       06x1 06x2 06x3  repeat variables */
/* QL: *       07x1 07x2 07x3  for variables */
/* QL: * Substring and string arrays (03x0 and 03x1) are ok if singly dimensioned. */
/* QL: * Other arrays are rejected with err.ni in d0. */
/* QL: * The rest are rejected with err.bn in d0. */
/* QL:         section bp_read */
.section bp_read,"ax"
/* QL: * d0 -  o- error return (ccr set) */
/* QL: * a3 -ip - pointer to name table entry tested (a6 rel.) */
/* QL: bp_rdchk */
bp_rdchk:
/* QL:         move.b  0(a6,a3.l),d0   get usage byte */
    move.b 0(a6,a3.l),d0
/* QL:         beq.s   unass           zero, so check for blank space */
    beq.s unass
/* QL:         ror.b   #2,d0           bit 1 set implies type 2,3,6,7 - all ok */
    ror.b #2,d0
/* QL:         bpl.s   err_bn          types not allowed... */
    bpl.s err_bn
/* QL:         cmp.b   #t.arr<<6,d0    is it an array? */
    cmp.b #((t.arr<<6)&255),d0
/* QL:         bne.s   okrts           not an array, so it's ok */
    bne.s okrts
/* QL:         btst    #1,1(a6,a3.l)   check second byte */
    btst #1,1(a6,a3.l)
/* QL:         bne.s   err_ni          fp or integer, so no go... */
    bne.s err_ni
/* QL:         move.l  4(a6,a3.l),d0   we have a (sub-)string array */
    move.l 4(a6,a3.l),d0
/* QL:         add.l   bv_vvbas(a6),d0 */
    add.l bv_vvbas(a6),d0
/* QL:         cmp.w   #1,d_dims(a6,d0.l)   so is it only one dimensioned? */
    cmp.w #1,d_dims(a6,d0.l)
/* QL:         beq.s   okrts           yes, so allowed */
    beq.s okrts
/* QL: err_ni */
err_ni:
/* QL:         moveq   #err.ni,d0 */
    moveq #err.ni,d0
/* QL:         rts */
    rts 
/* QL: unass */
unass:
/* QL:         moveq   #3,d0 */
    moveq #3,d0
/* QL:         and.b   1(a6,a3.l),d0   is entry completely blank? */
    and.b 1(a6,a3.l),d0
/* QL:         bne.s   okrts           no, so must be unassigned - ok */
    bne.s okrts
/* QL: err_bn */
err_bn:
/* QL:         moveq   #err.bn,d0 */
    moveq #err.bn,d0
/* QL:         rts */
    rts 
/* QL: * d0 error code */
/* QL: * d6 -1 while no array block is allocated, otherwise vv offset to it */
/* QL: * d7 counter*8 of remaining args */
/* QL: * a3 nt pointer to argument being read */
/* QL: bp_read */
bp_read:
/* QL:         move.l  a5,d7 */
    move.l a5,d7
/* QL:         sub.l   a3,d7           counter */
    sub.l a3,d7
/* QL:         bra.s   nx_arg */
    bra.s nx_arg
/* QL: go_arg */
go_arg:
/* QL:         bsr.s   bp_arset        set up in case array needs handling */
    bsr.s bp_arset
/* QL:         bsr.s   bp_rdchk        check that we can read into it (now) */
    bsr.s bp_rdchk
/* QL:         bne.s   arend */
    bne.s arend
/* QL: nx_ind */
nx_ind:
/* QL:         jsr     bp_data(pc)     get the next data item */
    jsr bp_data(pc)
/* QL:         bne.s   arend */
    bne.s arend
/* QL:         addq.b  #1,bv_daitm(a6) good, so move on next time */
    addq.b #1,bv_daitm(a6)
/* QL:         bsr.l   bp_arind        set nt entry for array element */
    bsr.w bp_arind
/* QL:         move.b  1(a6,a3.l),d0   what are we reading */
    move.b 1(a6,a3.l),d0
/* QL:         sub.l   bv_ntbas(a6),a3 */
    sub.l bv_ntbas(a6),a3
/* QL:         move.l  a3,-(sp) */
    move.l a3,-(sp)
/* QL:         jsr     ca_eval(pc)     read expression */
    jsr ca_eval(pc)
/* QL:         move.l  (sp)+,a3 */
    move.l (sp)+,a3
/* QL:         add.l   bv_ntbas(a6),a3 */
    add.l bv_ntbas(a6),a3
/* QL:         ble.s   arend           evaluation error */
    ble.s arend
/* QL:         jsr     bp_let(pc)      do the assignment */
    jsr bp_let(pc)
/* QL:         bsr.s   bp_arnxt        step array elements */
    bsr.s bp_arnxt
/* QL:         bgt.s   nx_ind          more elements, so carry on */
    bgt.s nx_ind
/* QL: arend */
arend:
/* QL:         bsr.s   bp_arend        discard any array index block */
    bsr.s bp_arend
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         subq.l  #8,d7 */
    subq.l #8,d7
/* QL: nx_arg */
nx_arg:
/* QL:         bne.s   go_arg */
    bne.s go_arg
/* QL: okrts */
okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * Arrays (other than singly dimensioned (sub-)string ones) are handled by */
/* QL: * allocating a temporary vv structure. A dummy singly dimensioned array */
/* QL: * descriptor is constructed here, followed by the original descriptor offset, */
/* QL: * and thereafter words contain the current indices. */
/* QL: * The step size in the dummy descriptor is not relevent. */
/* QL: * For strings and substrings, the vv offset to this structure, and hence to the */
/* QL: * dummy descriptor replaces the vv pointer in the nt entry. */
/* QL: * For integer and fp arrays, the nt entry is modified to suggest that a simple */
/* QL: * variable is being accessed, and its vv pointer tracks through the array. */
/* QL: * Constructing the dummy descriptor for int/fp is somewhat redundant, but */
/* QL: * simplifies the code rather a lot! */
/* QL: * Start up for possible elements of an array (N.B. VV allocation may be done) */
/* QL: * d0 -i o- unchanged if no array set up, or set to zero */
/* QL: * d6 -  o- -1 or array index block vv offset (ccr set) */
/* QL: * a3 -ip - nt pointer to argument under examination */
/* QL: * d0-d3/a1 destroyed */
/* QL: bp_arset */
bp_arset:
/* QL:         cmp.b   #t.arr,0(a6,a3.l) are we about to operate on an array? */
    cmp.b #(t.arr&255),0(a6,a3.l)
/* QL:         bne.s   simple          no - so just do a simple argument */
    bne.s simple
/* QL:         move.l  4(a6,a3.l),d3   get vv offset to array descriptor */
    move.l 4(a6,a3.l),d3
/* QL:         add.l   bv_vvbas(a6),d3 make pointer to descriptor */
    add.l bv_vvbas(a6),d3
/* QL:         bsr.s   tsttype         check for (sub-)string */
    bsr.s tsttype
/* QL:         bcs.s   intfp           int/fp must always be done  */
    bcs.s intfp
/* QL:         cmp.w   #1,d_dims(a6,d3.l) check dimensionality */
    cmp.w #1,d_dims(a6,d3.l)
/* QL:         bne.s   array           single dimension, i.e.(sub-)string, we can do */
    bne.s array
/* QL: simple */
simple:
/* QL:         moveq   #-1,d6          we haven't set up an array struct */
    moveq #(-1),d6
/* QL:         rts */
    rts 
/* QL: * Step to next of possible elements of an array */
/* QL: * ccr-  o- lt or mi: not array, eq: end array, gt: still going */
/* QL: * d0 -i o- unchanged if not an array, set to zero at end or 2*indices left */
/* QL: * d6 -  o- -1 or array index block vv offset */
/* QL: * a3 -ip - nt pointer to argument under examination */
/* QL: * d1-d3 destroyed */
/* QL: bp_arnxt */
bp_arnxt:
/* QL:         bsr.s   pickup          are we doing an array? */
    bsr.s pickup
/* QL:         bmi.s   rts5            no - just say we've finished */
    bmi.s rts5
/* QL:         add.l   d1,d2           point past counter for index */
    add.l d1,d2
/* QL:         add.l   d1,d3 */
    add.l d1,d3
/* QL:         add.l   d1,d3           point at max for index */
    add.l d1,d3
/* QL:         bsr.s   tsttype         check type */
    bsr.s tsttype
/* QL:         bcc.s   dec_str         skip back one subscript for (sub-)strings */
    bcc.s dec_str
/* QL: cn_inc */
cn_inc:
/* QL:         move.w  d_max-4(a6,d3.l),d0 get max for this dimension */
    move.w (d_max-4)(a6,d3.l),d0
/* QL:         addq.w  #1,d_index-2(a6,d2.l) update count */
    addq.w #1,(d_index-2)(a6,d2.l)
/* QL:         cmp.w   d_index-2(a6,d2.l),d0 has current count gone past max? */
    cmp.w (d_index-2)(a6,d2.l),d0
/* QL:         bcc.s   nxt_ex          no - do this one */
    bcc.s nxt_ex
/* QL:         clr.w   d_index-2(a6,d2.l) reset count to zero */
    clr.w (d_index-2)(a6,d2.l)
/* QL: dec_str */
dec_str:
/* QL:         subq.l  #4,d3 */
    subq.l #4,d3
/* QL:         subq.l  #2,d2 */
    subq.l #2,d2
/* QL:         subq.w  #2,d1           count off this index */
    subq.w #2,d1
/* QL:         bne.s   cn_inc          and try again (if not dropping off the front) */
    bne.s cn_inc
/* QL: nxt_ex */
nxt_ex:
/* QL:         move.l  d1,d0           set ccr and d0.l=0 at end */
    move.l d1,d0
/* QL: rts5 */
rts5:
/* QL:         rts */
    rts 
/* QL: * Finished with array index block */
/* QL: * d0 -ip - error code, ccr set */
/* QL: * d6 -ip - -1 or array index block vv offset */
/* QL: * d1-d3/a1 destroyed */
/* QL: bp_arend */
bp_arend:
/* QL:         bsr.s   pickup */
    bsr.s pickup
/* QL:         bpl.s   frvv */
    bpl.s frvv
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: intfp */
intfp:
/* QL:         subq.b  #t.arr-t.var,0(a6,a3.l) convert int/fp from array to simple var */
    subq.b #(t.arr-t.var),0(a6,a3.l)
/* QL: array */
array:
/* QL:         bsr.s   cn_len */
    bsr.s cn_len
/* QL:         sub.l   bv_ntbas(a6),a3 */
    sub.l bv_ntbas(a6),a3
/* QL:         lea     bv_alvvz(pc),a1 */
    lea bv_alvvz(pc),a1
/* QL:         bsr.s   callit */
    bsr.s callit
/* QL:         add.l   bv_ntbas(a6),a3 */
    add.l bv_ntbas(a6),a3
/* QL:         move.l  4(a6,a3.l),d_oldvv(a6,d2.l) save original descriptor offset */
    move.l 4(a6,a3.l),d_oldvv(a6,d2.l)
/* QL:         addq.w  #1,d_dims(a6,d2.l) dimensionality set to one (rdchk needs it) */
    addq.w #1,d_dims(a6,d2.l)
/* QL:         move.l  d2,d6 */
    move.l d2,d6
/* QL:         sub.l   bv_vvbas(a6),d6 */
    sub.l bv_vvbas(a6),d6
/* QL:         move.l  d6,4(a6,a3.l)   replace vv offset to go to our dummy descriptor */
    move.l d6,4(a6,a3.l)
/* QL:         rts */
    rts 
/* QL: tsttype */
tsttype:
/* QL:         move.b  1(a6,a3.l),d0 */
    move.b 1(a6,a3.l),d0
/* QL:         rol.b   #7,d0           check type */
    rol.b #7,d0
/* QL:         rts */
    rts 
/* QL: pickup */
pickup:
/* QL:         move.l  d6,d2 */
    move.l d6,d2
/* QL:         bmi.s   rts7 */
    bmi.s rts7
/* QL:         move.l  bv_vvbas(a6),d3 */
    move.l bv_vvbas(a6),d3
/* QL:         add.l   d3,d2           point at out index block */
    add.l d3,d2
/* QL:         add.l   d_oldvv(a6,d2.l),d3 point at original descriptor */
    add.l d_oldvv(a6,d2.l),d3
/* QL: cn_len */
cn_len:
/* QL:         moveq   #2,d1           in words (last unused for (sub-)strings) */
    moveq #2,d1
/* QL:         mulu    d_dims(a6,d3.l),d1 no of dimensions */
    mulu d_dims(a6,d3.l),d1
/* QL: rts7 */
rts7:
/* QL:         rts */
    rts 
/* QL: frvv */
frvv:
/* QL:         move.l  d_oldvv(a6,d2.l),4(a6,a3.l) restore original vv ptr into nt */
    move.l d_oldvv(a6,d2.l),4(a6,a3.l)
/* QL:         move.b  #t.arr,0(a6,a3.l)   restore array type (for int/fp) */
    move.b #(t.arr&255),0(a6,a3.l)
/* QL:         lea     bv_frvv(pc),a1  preserves d0.l and sets ccr from it */
    lea bv_frvv(pc),a1
/* QL: callit */
callit:
/* QL:         exg     a0,d2           swap a0 with d2 */
    exg a0,d2
/* QL:         add.w   #d_index,d1     include dummy 1-dim desc and old descr pointer */
    add.w #d_index,d1
/* QL:         jsr     (a1)            (note we can get away with add.w, as d1<16384) */
    jsr (a1)
/* QL:         exg     a0,d2           restore a0 */
    exg a0,d2
/* QL:         rts */
    rts 
/* QL: * Index possible elements of an array */
/* QL: * d6 -  o- -1 or array index block vv offset */
/* QL: * a3 -ip - nt pointer to argument under examination */
/* QL: * d0-d3/a1 destroyed */
/* QL: bp_arind */
bp_arind:
/* QL:         bsr.s   pickup */
    bsr.s pickup
/* QL:         bmi.s   rts9 */
    bmi.s rts9
/* QL: * Calculate position of next element in array */
/* QL:         sub.l   a1,a1           element offset zero */
    sub.l a1,a1
/* QL:         add.l   d1,d3 */
    add.l d1,d3
/* QL:         add.l   d1,d3           temporarily shift descriptor pointer by 4*n */
    add.l d1,d3
/* QL:         move.w  d_max-4(a6,d3.l),d_max(a6,d2.l) copy last max for (sub-)strings */
    move.w (d_max-4)(a6,d3.l),d_max(a6,d2.l)
/* QL:         add.l   d1,d2           temporarily shift counter pointer by 2*n */
    add.l d1,d2
/* QL: nx_dim */
nx_dim:
/* QL:         subq.l  #2,d2           move counter pointer back */
    subq.l #2,d2
/* QL:         move.w  d_index(a6,d2.l),d0 get count of index */
    move.w d_index(a6,d2.l),d0
/* QL:         subq.l  #4,d3           move descriptor pointer back */
    subq.l #4,d3
/* QL:         mulu    d_step(a6,d3.l),d0 multiplier */
    mulu d_step(a6,d3.l),d0
/* QL:         add.l   d0,a1           move element offset on for this dimension */
    add.l d0,a1
/* QL:         subq.w  #2,d1           move back one dimension */
    subq.w #2,d1
/* QL:         bne.s   nx_dim          drop out when d6/d3 are back to start */
    bne.s nx_dim
/* QL:         move.l  d_vvptr(a6,d3.l),d1 get vv offset to indexed value */
    move.l d_vvptr(a6,d3.l),d1
/* QL:         bsr.s   tsttype         check type */
    bsr.s tsttype
/* QL:         bcc.s   add_ok          (sub-)strings are ready to have dummy set up */
    bcc.s add_ok
/* QL:         add.l   a1,a1           x 2 does for integers */
    add.l a1,a1
/* QL:         bmi.s   bendptr         so they're ready here */
    bmi.s bendptr
/* QL:         add.l   a1,d1 */
    add.l a1,d1
/* QL:         add.l   a1,a1           x 6 for f.p. */
    add.l a1,a1
/* QL: bendptr */
bendptr:
/* QL:         moveq   #4-d_vvptr,d2 */
    moveq #(4-d_vvptr),d2
/* QL:         add.l   a3,d2           bend pointer appropriatly at nt entry */
    add.l a3,d2
/* QL: add_ok */
add_ok:
/* QL:         add.l   d1,a1           form vv offset to indexed value */
    add.l d1,a1
/* QL:         move.l  a1,d_vvptr(a6,d2.l) set offset in dummy descriptor or nt entry */
    move.l a1,d_vvptr(a6,d2.l)
/* QL: rts9 */
rts9:
/* QL:         rts */
    rts 
/* QL:         end */
