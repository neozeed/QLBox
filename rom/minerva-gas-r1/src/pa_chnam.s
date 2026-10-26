/* Generated from original/M/pa/chnam.asm */
/* QL: * Check name for entry in table */
/* QL:         xdef    pa_chnam,pa_chunr */
.globl pa_chnam,pa_chunr
/* QL:         xref    pa_kywrd */
/* QL:         xref    bv_chnlx,bv_vtype */
/* QL:         xref    ca_oldnt */
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
/* QL:         include 'win1_m_inc_mt' */
/* QL: * manager trap #1 codes */
/* QL:         nolist */
/* QL: mt.inf  equ     $00     get system information */
.equ mt.inf,0x00
/* QL: mt.cjob equ     $01     create a job */
.equ mt.cjob,0x01
/* QL: mt.jinf equ     $02     get information on job */
.equ mt.jinf,0x02
/* QL: mt.extop equ    $03     convert called routine to supervisor, rte at end */
.equ mt.extop,0x03
/* QL: mt.rjob equ     $04     remove a job */
.equ mt.rjob,0x04
/* QL: mt.frjob equ    $05     force remove a job */
.equ mt.frjob,0x05
/* QL: mt.free equ     $06     find out how much free space there is */
.equ mt.free,0x06
/* QL: mt.trapv equ    $07     set pointer to trap redirection vectors */
.equ mt.trapv,0x07
/* QL: mt.susjb equ    $08     suspend a job */
.equ mt.susjb,0x08
/* QL: mt.reljb equ    $09     release a job */
.equ mt.reljb,0x09
/* QL: mt.activ equ    $0a     activate a job */
.equ mt.activ,0x0a
/* QL: mt.prior equ    $0b     set a job priority */
.equ mt.prior,0x0b
/* QL: mt.alloc equ    $0c     allocate a bit of a heap */
.equ mt.alloc,0x0c
/* QL: mt.lnkfr equ    $0d     release a bit of a heap */
.equ mt.lnkfr,0x0d
/* QL: mt.alres equ    $0e     allocate resident procedure area */
.equ mt.alres,0x0e
/* QL: mt.reres equ    $0f     release resident procedure area */
.equ mt.reres,0x0f
/* QL: mt.dmode equ    $10     set display mode */
.equ mt.dmode,0x10
/* QL: mt.ipcom equ    $11     send IPC command */
.equ mt.ipcom,0x11
/* QL: mt.baud equ     $12     set baud rate */
.equ mt.baud,0x12
/* QL: mt.rclck equ    $13     read clock */
.equ mt.rclck,0x13
/* QL: mt.sclck equ    $14     set clock */
.equ mt.sclck,0x14
/* QL: mt.aclck equ    $15     adjust clock */
.equ mt.aclck,0x15
/* QL: mt.albas equ    $16     allocate basic area */
.equ mt.albas,0x16
/* QL: mt.rebas equ    $17     release basic area */
.equ mt.rebas,0x17
/* QL: mt.alchp equ    $18     allocate space in common heap */
.equ mt.alchp,0x18
/* QL: mt.rechp equ    $19     release space in common heap */
.equ mt.rechp,0x19
/* QL: mt.lxint equ    $1a     link in external interrupt handler */
.equ mt.lxint,0x1a
/* QL: mt.rxint equ    $1b     remove external interrupt handler */
.equ mt.rxint,0x1b
/* QL: mt.lpoll equ    $1c     link in polled task */
.equ mt.lpoll,0x1c
/* QL: mt.rpoll equ    $1d     remove polled task */
.equ mt.rpoll,0x1d
/* QL: mt.lschd equ    $1e     link in scheduler task */
.equ mt.lschd,0x1e
/* QL: mt.rschd equ    $1f     remove scheduler task */
.equ mt.rschd,0x1f
/* QL: mt.liod equ     $20     link in I/O driver */
.equ mt.liod,0x20
/* QL: mt.riod equ     $21     remove I/O driver */
.equ mt.riod,0x21
/* QL: mt.ldd  equ     $22     link in directory driver */
.equ mt.ldd,0x22
/* QL: mt.rdd  equ     $23     remove directory driver */
.equ mt.rdd,0x23
/* QL: mt.cntry equ    $24     set translate/error tables */
.equ mt.cntry,0x24
/* QL:         list */
/* QL:         section pa_chnam */
.section pa_chnam,"ax"
/* QL: * Note. The scan of the name table has been changed about, hopefully saving a */
/* QL: * considerable amount of time during load's. */
/* QL: * The basic technique being to try to match the length byte and the first */
/* QL: * character before even checking that there is a real, named, entry. */
/* QL: * d5 -i o- length of name in buffer (msb's clear) / no of name in table */
/* QL: * a2 -i o- pointer to keyword table / pointer to name table */
/* QL: * a3 -i  - pointer to start of buffered name to check for (rel a6) */
/* QL: * a6 -ip - area on which bv pointers are indexed */
/* QL: * d0-d3/d6/a0-a1 destroyed */
/* QL: regon   reg     d4/d7/a2-a3/a5 */
/* QL: regoff  reg     d4/d7/a0/a3/a5 */
/* QL: pa_chnam */
pa_chnam:
/* QL:         movem.l regon,-(sp)     save a few regs for later (a2->a0 below) */
    movem.l d4/d7/a2-a3/a5,-(sp)
/* QL:         lea     scanner,a2 */
    lea scanner(pc),a2
/* QL:         moveq   #mt.extop,d0    increment non-sheduling mode */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         movem.l (sp)+,regoff    put kytab in a0 for now */
    movem.l (sp)+,d4/d7/a0/a3/a5
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         beq.s   found           goody! we have found the match */
    beq.s found
/* QL:         move.l  a0,a2           set beginning of keyword table */
    move.l a0,a2
/* QL:         moveq   #0,d6           must start at zero, as remark follows remainder */
    moveq #0,d6
/* QL: kyloop */
kyloop:
/* QL:         addq.b  #1,d6 */
    addq.b #1,d6
/* QL:         cmp.b   (a2),d6         check against all keywords and pairs thereof */
    cmp.b (a2),d6
/* QL:         bgt.s   newnam */
    bgt.s newnam
/* QL:         move.l  a3,a0           set buffer start */
    move.l a3,a0
/* QL:         jsr     pa_kywrd(pc) */
    jsr pa_kywrd(pc)
/* QL:         bra.s   kyloop          no match */
    bra.s kyloop
/* QL:         rts                     illegal name, better tell user */
    rts 
/* QL: * Name not in table or keywords. Add it to table in first free slot */
/* QL: newnam */
newnam:
/* QL:         moveq   #4+8+12,d0      total stack depth at this point */
    moveq #((4+8)+12),d0
/* QL:         bsr.s   pa_chunr        check in case we're in an unravel */
    bsr.s pa_chunr
/* QL:         move.l  d5,d1 */
    move.l d5,d1
/* QL:         addq.l  #1,d1           space required is nchars plus one */
    addq.l #1,d1
/* QL:         jsr     bv_chnlx(pc)    check space in namelist */
    jsr bv_chnlx(pc)
/* QL:         exg     a2,a5 */
    exg a5,a2
/* QL:         jsr     ca_oldnt(pc)    get a spare/new name table entry built for us */
    jsr ca_oldnt(pc)
/* QL:         exg     a2,a5 */
    exg a5,a2
/* QL:         subq.l  #8,a2 */
    subq.l #8,a2
/* QL:         assert  bv_nlbas,bv_nlp-4 */
/* original assertion: bv_nlbas,bv_nlp-4 */
/* QL:         movem.l bv_nlbas(a6),d2/a0 */
    movem.l bv_nlbas(a6),d2/a0
/* QL:         neg.w   d2 */
    neg.w d2
/* QL:         add.w   a0,d2 */
    add.w a0,d2
/* QL:         move.b  d5,0(a6,a0.l)   put name length into namelist entry */
    move.b d5,0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL: addchar */
addchar:
/* QL:         move.b  0(a6,a3.l),0(a6,a0.l) put buffer char into namelist */
    move.b 0(a6,a3.l),0(a6,a0.l)
/* QL:         addq.l  #1,a3 */
    addq.l #1,a3
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.b  #1,d5           one char gone */
    subq.b #1,d5
/* QL:         bne.s   addchar */
    bne.s addchar
/* QL:         move.w  d2,2(a6,a2.l)   put namelist offset into nametable entry */
    move.w d2,2(a6,a2.l)
/* QL:         move.l  a0,bv_nlp(a6)   update running namelist pointer */
    move.l a0,bv_nlp(a6)
/* QL:         jsr     bv_vtype(pc)    set up usage and variable type */
    jsr bv_vtype(pc)
/* QL: * Send back entry number in name table */
/* QL: found */
found:
/* QL:         move.l  a2,d5           get position in name table */
    move.l a2,d5
/* QL:         sub.l   bv_ntbas(a6),d5 */
    sub.l bv_ntbas(a6),d5
/* QL:         lsr.l   #3,d5           ..gives 0,1,2,3...etc */
    lsr.l #3,d5
/* QL:         addq.l  #2,(sp)         good exit */
    addq.l #2,(sp)
/* QL:         rts */
    rts 
/* QL: * Return to unvr if we are stuck in an unravel. */
/* QL: * d0 -i o- depth of stack to get back to unvr if we're stuck */
/* QL: pa_chunr */
pa_chunr:
/* QL:         tst.b   bv_unrvl(a6)    is nt is stuck in an unravel? */
    tst.b bv_unrvl(a6)
/* QL:         beq.s   rts0            no - that's ok */
    beq.s rts0
/* QL:         add.l   d0,sp           lose stacked data and returns */
    add.l d0,sp
/* QL:         moveq   #1,d0           set codition codes postive for unvr */
    moveq #1,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: scanner */
scanner:
/* QL:         assert  bv_ntbas,bv_ntp-4,bv_nlbas-8 */
/* original assertion: bv_ntbas,bv_ntp-4,bv_nlbas-8 */
/* QL:         movem.l bv_ntbas(a6),d0/d6/a5 */
    movem.l bv_ntbas(a6),d0/d6/a5
/* QL:         sub.l   d0,d6           nl size */
    sub.l d0,d6
/* QL:         lsr.l   #3,d6           nl count */
    lsr.l #3,d6
/* QL:         lea     2-8(a6,d0.l),a2 absolute nt base for first nl offset */
    lea (2-8)(a6,d0.l),a2
/* QL:         add.l   a6,a5           absolute nl base */
    add.l a6,a5
/* QL:         add.l   a6,a3           make buffer absolute */
    add.l a6,a3
/* QL:         move.b  (a3)+,d7        get first byte out just the once */
    move.b (a3)+,d7
/* QL:         moveq   #1,d1           just to improve spare entry test */
    moveq #1,d1
/* QL:         moveq   #-1-32,d3       mask to clear lower-case bit, ccr non-z */
    moveq #((-1)-32),d3
/* QL:         bra.s   nment */
    bra.s nment
/* QL: nmloop */
nmloop:
/* QL:         addq.l  #8,a2 */
    addq.l #8,a2
/* QL:         move.w  (a2),a0 */
    move.w (a2),a0
/* QL:         add.l   a5,a0 */
    add.l a5,a0
/* QL:         cmp.b   (a0)+,d5        match name length first, even if it's silly */
    cmp.b (a0)+,d5
/* QL:         dbeq    d6,nmloop       gets through bulk of nt as quick as we can */
    dbeq d6,nmloop
/* QL:         bne.s   nmexit */
    bne.s nmexit
/* QL:         move.b  (a0)+,d0 */
    move.b (a0)+,d0
/* QL:         eor.b   d7,d0 */
    eor.b d7,d0
/* QL:         and.b   d3,d0           does first char match? */
    and.b d3,d0
/* QL:         dbeq    d6,nmloop       no, we're still whizzing along fast */
    dbeq d6,nmloop
/* QL:         bne.s   nmexit */
    bne.s nmexit
/* QL: * Now it's time to settle into the rest of the tests. */
/* QL: * We have got past to this point quickly, and we now know the length is the */
/* QL: * same and the first byte is also matched. */
/* QL: * We skipped testing for spare/unnamed entries until now to make the scan fast! */
/* QL: * Assuming we will actually normally find a match, and the incidence of unnamed */
/* QL: * entries is low until we get to the top of the table, we should be doing quite */
/* QL: * a bit better on speed at this point. */
/* QL: * The name offset in duff cases will always be zero (spare) or -1 (unnamed), */
/* QL: * so we shouldn't have any problems using it. */
/* QL: * On a typical load, with not many extensions, 30% of the time was spent here! */
/* QL: * A further gain might be made by "cacheing" the most recent four, or maybe a */
/* QL: * few more, matched nt entry numbers, but this could get a bit complex, for */
/* QL: * what should now be a small gain in overall speed. */
/* QL:         tst.b   (a2)            did this entry have a real nl offset? */
    tst.b (a2)
/* QL:         bmi.s   nment           negative offset, we wasted a tiny bit of time */
    bmi.s nment
/* QL:         cmp.l   -2(a2),d1       is it an annoying "spare" entry? */
    cmp.l (-2)(a2),d1
/* QL:         bhi.s   nment           unset sub-string, no less! (nb ccr not z!) */
    bhi.s nment
/* QL:         move.l  a3,a1           copy buffer pointer */
    move.l a3,a1
/* QL:         move.w  d5,d4           set length */
    move.w d5,d4
/* QL:         subq.w  #1,d4           we've done one character */
    subq.w #1,d4
/* QL:         beq.s   nmfnd           wow! it was just one char, so we're done */
    beq.s nmfnd
/* QL:         subq.w  #1,d4           less one to compensate for dbne */
    subq.w #1,d4
/* QL: nmchr */
nmchr:
/* QL:         move.b  (a1)+,d2        get buffer char */
    move.b (a1)+,d2
/* QL:         move.b  (a0)+,d0        get table char */
    move.b (a0)+,d0
/* QL:         eor.b   d2,d0           look at differences */
    eor.b d2,d0
/* QL:         and.b   d3,d0           clear lc bit */
    and.b d3,d0
/* QL:         dbne    d4,nmchr        loop round and try again if matched and more */
    dbne d4,nmchr
/* QL: nment */
nment:
/* QL:         dbeq    d6,nmloop       drop out if full match or none left */
    dbeq d6,nmloop
/* QL: nmfnd */
nmfnd:
/* QL:         subq.l  #2,a2           back to base of matched entry */
    subq.l #2,a2
/* QL:         sub.l   a6,a2           make nt pointer relative */
    sub.l a6,a2
/* QL: nmexit */
nmexit:
/* QL:         sne     d6 */
    sne d6
/* QL:         rte */
    rte 
/* QL:         end */
