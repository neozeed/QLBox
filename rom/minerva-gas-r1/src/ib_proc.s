/* Generated from original/M/ib/proc.asm */
/* QL: * Deal with machine code procedure */
/* QL:         xdef    ib_proc */
.globl ib_proc
/* QL:         xref    ca_carg,ca_garg */
/* QL:         xref    ib_cheos,ib_unret */
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
/* QL:         section ib_proc */
.section ib_proc,"ax"
/* QL: * d0 -  o- error code */
/* QL: * d2 -  o- error code */
/* QL: * a1 -  o- bv_rip */
/* QL: * a2 -i  - name table entry */
/* QL: * a4 -i o- program pointer to next token after proc name, updated to eos */
/* QL: * d1/d3-d6/a0/a3/a5 destroyed */
/* QL: ib_proc */
ib_proc:
/* QL:         move.l  4(a6,a2.l),d5   just want absolute address of procedure */
    move.l 4(a6,a2.l),d5
/* QL: nextgo */
nextgo:
/* QL:         sf      bv_undo(a6)     turn undo off */
    sf bv_undo(a6)
/* QL:         move.l  a4,a0           put prog pointer in a0 */
    move.l a4,a0
/* QL:         assert  bv_ntbas,bv_ntp-4 */
/* original assertion: bv_ntbas,bv_ntp-4 */
/* QL:         movem.l bv_ntbas(a6),d6/a3 */
    movem.l bv_ntbas(a6),d6/a3
/* QL:         sub.l   d6,a3           offset of base of args */
    sub.l d6,a3
/* QL:         sub.l   a4,d6           program pointer offset, in case of redo */
    sub.l a4,d6
/* QL:         jsr     ca_garg(pc)     get the arguments (only touches d0-d1/a0-a1/a5) */
    jsr ca_garg(pc)
/* QL:         move.l  bv_ntbas(a6),a4 may have moved */
    move.l bv_ntbas(a6),a4
/* QL:         bne.s   carg            wrong */
    bne.s carg
/* QL:         jsr     ib_cheos(pc)    check that d1 is an end of statement */
    jsr ib_cheos(pc)
/* QL:         bne.s   err_bp */
    bne.s err_bp
/* QL:         sub.l   a4,a5           top of args offset */
    sub.l a4,a5
/* QL:         sub.l   a4,a0           program offset */
    sub.l a4,a0
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         sub.l   bv_ribas(a6),a1 ri offset */
    sub.l bv_ribas(a6),a1
/* QL:         movem.l d5-d7/a0-a1/a3/a5,-(sp) don't want to lose our place, do we? */
    movem.l d5-d7/a0-a1/a3/a5,-(sp)
/* QL:         moveq   #0,d7           absolute guarantee of zero in d7 */
    moveq #0,d7
/* QL:         add.l   a4,a3 */
    add.l a4,a3
/* QL:         add.l   a4,a5 */
    add.l a4,a5
/* QL:         assert  bv_linum,bv_lengt-2 */
/* original assertion: bv_linum,bv_lengt-2 */
/* QL:         move.l  bv_linum(a6),-(sp) */
    move.l bv_linum(a6),-(sp)
/* QL:         move.b  bv_stmnt(a6),-(sp) */
    move.b bv_stmnt(a6),-(sp)
/* QL:         assert  bv_inlin,bv_sing-1,bv_index-2 */
/* original assertion: bv_inlin,bv_sing-1,bv_index-2 */
/* QL:         move.l  bv_inlin(a6),-(sp) */
    move.l bv_inlin(a6),-(sp)
/* QL:         move.l  d5,a2 */
    move.l d5,a2
/* QL:         jsr     (a2)            do the relevent mc proc */
    jsr (a2)
/* QL: * The stack looks like this to the called code: */
/* QL: *       $00 l return address */
/* QL: *       $04 b bv_inlin */
/* QL: *       $05 b bv_sing */
/* QL: *       $06 w bv_index */
/* QL: *       $08 b bv_stmnt */
/* QL: *       $09 b junk */
/* QL: *       $0a w bv_linum */
/* QL: *       $0c w bv_lengt */
/* QL: *       $0e l (d5) m/c code address, in case of a redo */
/* QL: *       $12 l (d6) prog offset from bv_ntbas, before garg, for redo (positive) */
/* QL: *       $16 l (d7) data register (always zero, wasting space on here!) */
/* QL: *       $1a l (a0) current program offset down from bv_ntbas (negative) */
/* QL: *       $1e l (a1) ri stack offset down from bv_ribas (negative) */
/* QL: *       $22 l (a3-ntbas) offset to top of args up from bv_ntbas */
/* QL: *       $26 l (a5-ntbas) offset to bottom of args up from bv_ntbas */
/* QL: * I have stopped saving d5-d6 in to get space for undo stuff, swapped the */
/* QL: * current prog offset with the ri offset and changed registers on the call. */
/* QL: * Previously, a0 had a copy of nt_bas and a4 was the current prog offset. */
/* QL: * With luck, no one will have expected particular register values, other than */
/* QL: * d0/d7/a3/a5, and no further exploration up the stack! */
/* QL: * N.B. Beware! Qload and Qlrun zero out the two arg ptrs above by referencing */
/* QL: * them as $22(sp) and $26(sp). Qload also expects msw d6 zero!!!! (lwr) */
/* QL:         move.l  (sp)+,bv_inlin(a6) */
    move.l (sp)+,bv_inlin(a6)
/* QL:         move.b  (sp)+,bv_stmnt(a6) */
    move.b (sp)+,bv_stmnt(a6)
/* QL:         move.l  (sp)+,bv_linum(a6) */
    move.l (sp)+,bv_linum(a6)
/* QL:         movem.l (sp)+,d5-d7/a0-a1/a3/a5 now then, where were we? */
    movem.l (sp)+,d5-d7/a0-a1/a3/a5
/* QL:         add.l   bv_ribas(a6),a1 */
    add.l bv_ribas(a6),a1
/* QL:         move.l  a1,bv_rip(a6)   restore ri pointer */
    move.l a1,bv_rip(a6)
/* QL:         move.l  bv_ntbas(a6),a4 */
    move.l bv_ntbas(a6),a4
/* QL:         add.l   a4,a0           restore position in program */
    add.l a4,a0
/* QL:         add.l   a4,a5           top of args on nt */
    add.l a4,a5
/* QL:         bsr.s   carg */
    bsr.s carg
/* QL:         tst.b   bv_undo(a6)     um, must we undo the return stack first? */
    tst.b bv_undo(a6)
/* QL:         bne.s   redo            yes, go see to it */
    bne.s redo
/* QL:         rts */
    rts 
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: carg */
carg:
/* QL:         sub.l   a4,d6           prog pointer for redo (negated) */
    sub.l a4,d6
/* QL:         add.l   a4,a3           bottom of args on nt */
    add.l a4,a3
/* QL:         move.l  a0,a4           prog pointer back into correct register */
    move.l a0,a4
/* QL:         jmp     ca_carg(pc)     clear out the arguments */
    jmp ca_carg(pc)
/* QL: redo */
redo:
/* QL:         neg.l   d6              un-negate saved program pointer */
    neg.l d6
/* QL:         move.l  d6,a4           put back the saved program pointer */
    move.l d6,a4
/* QL:         move.l  a4,-(sp)           \ */
    move.l a4,-(sp)
/* QL:         move.l  d5,-(sp)            \ */
    move.l d5,-(sp)
/* QL:         move.l  bv_linum(a6),-(sp)   > save full current context */
    move.l bv_linum(a6),-(sp)
/* QL:         move.b  bv_stmnt(a6),-(sp)  / */
    move.b bv_stmnt(a6),-(sp)
/* QL:         move.l  bv_inlin(a6),-(sp) / */
    move.l bv_inlin(a6),-(sp)
/* QL:         moveq   #7*4+2,d1       tell unret how deep the stack is */
    moveq #((7*4)+2),d1
/* QL:         jsr     ib_unret(pc)    go unravel everything */
    jsr ib_unret(pc)
/* QL:         move.l  (sp)+,bv_inlin(a6) */
    move.l (sp)+,bv_inlin(a6)
/* QL:         move.b  (sp)+,bv_stmnt(a6) */
    move.b (sp)+,bv_stmnt(a6)
/* QL:         move.l  (sp)+,bv_linum(a6) */
    move.l (sp)+,bv_linum(a6)
/* QL:         move.l  (sp)+,d5 */
    move.l (sp)+,d5
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         bra.l   nextgo */
    bra.w nextgo
/* QL:         end */
