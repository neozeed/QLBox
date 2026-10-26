/* Generated from original/M/bp/let.asm */
/* QL: * Do let assignments from RI to VV */
/* QL:         xdef    bp_let,bp_alvv */
.globl bp_let,bp_alvv
/* QL:         xref    bv_alvv,bv_frvv,bv_uplet */
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
/* QL:         section bp_let */
.section bp_let,"ax"
/* QL: * d0 -  o- 0 (this routine doesn't believe in errors!) */
/* QL: * d5 -ip - low limit, if assigning to a substring of a simple string variable */
/* QL: * d6 -ip - high limit, ditto */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * a2 -ip - VV area, if assigning to a substring of a simple string variable */
/* QL: * a3 -ip - pointer to NT entry */
/* QL: * d1-d2 destroyed */
/* QL: reg_let reg     d4/a0/a3-a5 */
/* QL: bp_let */
bp_let:
/* QL:         movem.l reg_let,-(sp) */
    movem.l d4/a0/a3-a5,-(sp)
/* QL:         moveq   #15,d0 */
    moveq #15,d0
/* QL:         and.b   1(a6,a3.l),d0   mask seps */
    and.b 1(a6,a3.l),d0
/* QL:         tst.b   bv_uproc(a6)    is there a user trace procedure? */
    tst.b bv_uproc(a6)
/* QL:         bpl.s   noup */
    bpl.s noup
/* QL:         jsr     bv_uplet(pc)    yes - go see to it */
    jsr bv_uplet(pc)
/* QL: noup */
noup:
/* QL:         bsr.s   main */
    bsr.s main
/* QL:         add.l   d1,a1 */
    add.l d1,a1
/* QL:         move.l  a1,bv_rip(a6) */
    move.l a1,bv_rip(a6)
/* QL:         movem.l (sp)+,reg_let */
    movem.l (sp)+,d4/a0/a3-a5
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Assign a floating point to var or array */
/* QL: let_fp */
let_fp:
/* QL:         moveq   #6,d1           entry should be 6 bytes long */
    moveq #6,d1
/* QL:         bsr.s   ch_off          get the space */
    bsr.s ch_off
/* QL:         move.l  2(a6,a1.l),2(a6,a0.l) copy mantissa */
    move.l 2(a6,a1.l),2(a6,a0.l)
/* QL:         bra.s   int_fp */
    bra.s int_fp
/* QL: main */
main:
/* QL:         moveq   #2,d1           2 bytes needed for integer, and clear msw */
    moveq #2,d1
/* QL:         subq.b  #t.fp,d0 */
    subq.b #t.fp,d0
/* QL:         bmi.s   let_str         assign to a string of some sort */
    bmi.s let_str
/* QL:         beq.s   let_fp          assign to floating point */
    beq.s let_fp
/* QL:         bsr.s   ch_off          check it has a value pointer */
    bsr.s ch_off
/* QL: int_fp */
int_fp:
/* QL:         move.w  0(a6,a1.l),0(a6,a0.l) put 1st word into VV area */
    move.w 0(a6,a1.l),0(a6,a0.l)
/* QL: ch_type */
ch_type:
/* QL:         moveq   #t.var,d0 */
    moveq #t.var,d0
/* QL:         cmp.b   0(a6,a3.l),d0   look at variable type */
    cmp.b 0(a6,a3.l),d0
/* QL:         ble.s   rts0            vt already set */
    ble.s rts0
/* QL:         move.b  d0,0(a6,a3.l)   set variable type to simple var */
    move.b d0,0(a6,a3.l)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: ch_off */
ch_off:
/* QL:         move.l  4(a6,a3.l),d4   current offset on VV table */
    move.l 4(a6,a3.l),d4
/* QL:         bpl.s   get_pos         ..it's all right */
    bpl.s get_pos
/* QL: * d0 -  o- 0 */
/* QL: * d1 -ip - space required from VV area */
/* QL: * d4 -  o- VV offset of new space */
/* QL: * a0 -  o- rel a6 address of new space */
/* QL: * a1 -  o- RI stack pointer (a bonus!) */
/* QL: * a3 -ip - NT entry to receive space */
/* QL: bp_alvv */
bp_alvv:
/* QL:         jsr     bv_alvv(pc)     get the required space & set a1=bv_rip(a6) */
    jsr bv_alvv(pc)
/* QL:         move.l  a0,d4 */
    move.l a0,d4
/* QL:         sub.l   bv_vvbas(a6),d4 get the offset */
    sub.l bv_vvbas(a6),d4
/* QL:         move.l  d4,4(a6,a3.l)   and fill it in */
    move.l d4,4(a6,a3.l)
/* QL:         rts */
    rts 
/* QL: cht_get */
cht_get:
/* QL:         bsr.s   ch_type */
    bsr.s ch_type
/* QL: * Get positions of assignee & assignor */
/* QL: * a0 -  o- VV position of destination string */
/* QL: * a1 -  o- RI pointer of source string */
/* QL: * d4 -i  - offset of array values on VV */
/* QL: get_pos */
get_pos:
/* QL:         move.l  bv_vvbas(a6),a0 */
    move.l bv_vvbas(a6),a0
/* QL:         add.l   d4,a0 */
    add.l d4,a0
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         rts */
    rts 
/* QL: * Assign a string to something */
/* QL: let_str */
let_str:
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL: * We rather assume that the given string length is sensible! */
/* QL:         move.w  0(a6,a1.l),d1   length of string to be assigned */
    move.w 0(a6,a1.l),d1
/* QL:         cmp.b   #t.arr,0(a6,a3.l) is this an array? */
    cmp.b #(t.arr&255),0(a6,a3.l)
/* QL:         bne.s   str_var         no - go for string varible */
    bne.s str_var
/* QL:         move.l  4(a6,a3.l),a0   get descriptor offset */
    move.l 4(a6,a3.l),a0
/* QL:         add.l   bv_vvbas(a6),a0 */
    add.l bv_vvbas(a6),a0
/* QL:         move.w  6(a6,a0.l),d2   max length to replace */
    move.w 6(a6,a0.l),d2
/* QL:         move.l  0(a6,a0.l),d4   where to start replacement */
    move.l 0(a6,a0.l),d4
/* QL:         bsr.s   set_par         get max copy and blank fill */
    bsr.s set_par
/* QL:         bsr.s   get_pos         get source and destination bases */
    bsr.s get_pos
/* QL:         addq.b  #t.fp,d0 */
    addq.b #t.fp,d0
/* QL:         beq.s   str_ret         no length if a substring of a string array */
    beq.s str_ret
/* QL: * There was a strange anomaly here... for some reason there was an extra */
/* QL: * comparison of the copy length with the source length... it did nothing, but */
/* QL: * it looked as if it was meant to compare against the current length of the */
/* QL: * destination, then cause it to only expand in length. Wierd! */
/* QL: * Another thing it could have been an attempt at acheiving may have been to */
/* QL: * only blank fill to the extent of old length, which might make some sense, if */
/* QL: * string arrays were initially set to blanks... unfortunately, we now come up */
/* QL: * against compatability again. It would speed things up no end if we could */
/* QL: * scrap the blank filling, but I guess we're stuck with it! */
/* QL:         bra.s   put_len         go duplicate copy length */
    bra.s put_len
/* QL: str_norm */
str_norm:
/* QL:         addq.l  #1,d1 */
    addq.l #1,d1
/* QL:         bclr    #0,d1           round up assign length to even */
    bclr #0,d1
/* QL:         move.w  0(a6,a0.l),d0   get length of current string */
    move.w 0(a6,a0.l),d0
/* QL:         addq.l  #1,d0 */
    addq.l #1,d0
/* QL:         bclr    #0,d0           rounded up to even */
    bclr #0,d0
/* QL:         move.l  d0,d2 */
    move.l d0,d2
/* QL:         eor.l   d1,d0           any chance that old & new space is the same? */
    eor.l d1,d0
/* QL:         lsr.l   #3,d0           (we know VV space is in multiples of eight) */
    lsr.l #3,d0
/* QL:         beq.s   fill_str        VV space is right mult of 8, so leave it */
    beq.s fill_str
/* QL:         addq.l  #2,d2           total amount to free, a0 already set */
    addq.l #2,d2
/* QL:         exg     d2,d1           save d1, and set amount to release */
    exg d2,d1
/* QL:         jsr     bv_frvv(pc) */
    jsr bv_frvv(pc)
/* QL:         move.l  d2,d1           restore d1 */
    move.l d2,d1
/* QL: crt_str */
crt_str:
/* QL:         addq.l  #2,d1           entry must be length of string + 2 */
    addq.l #2,d1
/* QL:         bsr.s   bp_alvv         allocation will round up any odd byte */
    bsr.s bp_alvv
/* QL: fill_str */
fill_str:
/* QL:         bsr.s   cht_get         check out variable type and get a0,a1 */
    bsr.s cht_get
/* QL:         moveq   #0,d2           nothing to blankfill on a0 */
    moveq #0,d2
/* QL:         move.w  0(a6,a1.l),d1   get source length again */
    move.w 0(a6,a1.l),d1
/* QL: put_len */
put_len:
/* QL:         move.w  d1,0(a6,a0.l)   set destination length */
    move.w d1,0(a6,a0.l)
/* QL: str_len */
str_len:
/* QL:         addq.l  #2,a0           pos to start replacing at */
    addq.l #2,a0
/* QL: str_ret */
str_ret:
/* QL:         move.w  0(a6,a1.l),d0   get length (we know msw is zero) */
    move.w 0(a6,a1.l),d0
/* QL:         addq.l  #2,a1           move a1 past length word */
    addq.l #2,a1
/* QL:         add.l   a1,d0           set to end of text */
    add.l a1,d0
/* QL:         bra.s   s_copy          do the copy */
    bra.s s_copy
/* QL: * Check copy length fits into space */
/* QL: * d1 -i o- new chars available / number to copy from RI stack to VV area */
/* QL: * d2 -i o- space available / amount of VV area to blankfill after copy */
/* QL: set_par */
set_par:
/* QL:         sub.w   d1,d2           will new chars fit into old space? */
    sub.w d1,d2
/* QL:         bhi.s   rts1            yes - fine */
    bhi.s rts1
/* QL:         add.w   d2,d1           set amount to copy */
    add.w d2,d1
/* QL:         moveq   #0,d2           and blank fill nothing */
    moveq #0,d2
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: str_var */
str_var:
/* QL:         addq.b  #t.fp,d0        string or sub-string */
    addq.b #t.fp,d0
/* QL:         beq.s   let_sst         ..substring (only allowed direct from let) */
    beq.s let_sst
/* QL:         move.l  4(a6,a3.l),d4   current offset on VV */
    move.l 4(a6,a3.l),d4
/* QL:         blt.s   crt_str         ..isn't one, have to make one */
    blt.s crt_str
/* QL:         move.l  bv_vvbas(a6),a0 */
    move.l bv_vvbas(a6),a0
/* QL:         add.l   d4,a0 */
    add.l d4,a0
/* QL: * This is it! We must not screw up rep/for string variable, which has max len */
/* QL: * of 4 chars. If assigning to such, truncate anything longer than four chars. */
/* QL: * An alternative would be to scrap their rep/for status... */
/* QL: * While we're doing this, we can get the spinoff of quick assigns to others. */
/* QL:         assert  0,t.var-2,t.arr-3,t.rep-6,t.for-7 */
/* original assertion: 0,t.var-2,t.arr-3,t.rep-6,t.for-7 */
/* QL:         moveq   #4,d0 */
    moveq #4,d0
/* QL:         cmp.b   0(a6,a3.l),d0   is this string a rep/for index? */
    cmp.b 0(a6,a3.l),d0
/* QL:         bgt.s   str_norm        no - go do normal strings */
    bgt.s str_norm
/* QL:         cmp.w   d1,d0           what's the source string length then? */
    cmp.w d1,d0
/* QL:         bcs.s   truncit         bother... longer than four */
    bcs.s truncit
/* QL:         move.w  d1,d0           use short strings as they come */
    move.w d1,d0
/* QL: truncit */
truncit:
/* QL:         move.w  d0,0(a6,a0.l)   set variable length */
    move.w d0,0(a6,a0.l)
/* QL:         move.l  2(a6,a1.l),2(a6,a0.l) copy 4 bytes regardless */
    move.l 2(a6,a1.l),2(a6,a0.l)
/* QL:         addq.l  #3,d1 */
    addq.l #3,d1
/* QL:         bclr    #0,d1           round up for the space to release on RI stack */
    bclr #0,d1
/* QL:         rts */
    rts 
/* QL: * Assign a string to a substring of a string variable */
/* QL: let_sst */
let_sst:
/* QL:         addq.b  #t.str,1(a6,a3.l) reset type to string (it was zero before) */
    addq.b #t.str,1(a6,a3.l)
/* QL:         move.w  d5,a0 */
    move.w d5,a0
/* QL:         subq.l  #1,a0           offset to first char to replace */
    subq.l #1,a0
/* QL:         move.w  d6,d2 */
    move.w d6,d2
/* QL:         sub.w   a0,d2           destination space available */
    sub.w a0,d2
/* QL:         add.l   a2,a0 */
    add.l a2,a0
/* QL:         bsr.s   set_par         gives d1,d2 */
    bsr.s set_par
/* QL:         bra.s   str_len         go copy after stepping past length */
    bra.s str_len
/* QL: * Copy string characters */
/* QL: * d0 -  i- offset to end of text of RI stack string */
/* QL: * d1 -i o- no of chars to copy from RI stack to VV area / addend for a1 */
/* QL: * d2 -i  - no of chars on VV area to blank fill */
/* QL: * a0 -i o- VV pos to copy to */
/* QL: * a1 -i o- RI pointer to source string, string removed except for d1 */
/* QL: copy_lp */
copy_lp:
/* QL:         move.b  0(a6,a1.l),0(a6,a0.l) copy a character */
    move.b 0(a6,a1.l),0(a6,a0.l)
/* QL:         addq.l  #1,a0           step VV */
    addq.l #1,a0
/* QL:         addq.l  #1,a1           step RI */
    addq.l #1,a1
/* QL: s_copy */
s_copy:
/* QL:         dbra    d1,copy_lp */
    dbra d1,copy_lp
/* QL:         moveq   #' ',d1 */
    moveq #32,d1
/* QL:         bra.s   b_fill */
    bra.s b_fill
/* QL: fill_lp */
fill_lp:
/* QL:         move.b  d1,0(a6,a0.l)   blank one character */
    move.b d1,0(a6,a0.l)
/* QL:         addq.l  #1,a0           step VV */
    addq.l #1,a0
/* QL: b_fill */
b_fill:
/* QL:         dbra    d2,fill_lp */
    dbra d2,fill_lp
/* QL:         move.l  d0,a1           replace with end of text */
    move.l d0,a1
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         and.b   d0,d1           chars (0/1) left before end of string */
    and.b d0,d1
/* QL:         rts */
    rts 
/* QL:         end */
