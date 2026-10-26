/* Generated from original/M/bf/date.asm */
/* QL: * Basic clock commands */
/* QL:         xdef    bf_date,bf_dates,bf_datez,bf_days,bp_adate,bp_sdate */
.globl bf_date,bf_dates,bf_datez,bf_days,bp_adate,bp_sdate
/* QL:         ; The bp routines should be in that section, but they're better here. */
/* QL:         ; bp_datez changed to bf_datez now in range for the ii_clock routine! */
/* QL:         xref    bf_fllin */
/* QL:         xref    bv_chri */
/* QL:         xref    ca_gtlin */
/* QL:         xref    cn_date,cn_day */
/* QL:         xref    ri_fllin */
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
/* QL: dot     equ     1961 */
.equ dot,1961
/* QL:         section bf_date */
.section bf_date,"ax"
/* QL: bf_date         ; -mt.aclck */
bf_date:
/* QL:         moveq   #-2-mt.aclck,d7 */
    moveq #((-2)-mt.aclck),d7
/* QL: bf_days         ; $83 */
bf_days:
/* QL:         addq.b  #2,d7 */
    addq.b #2,d7
/* QL: bf_dates        ; $81 */
bf_dates:
/* QL:         tas     d7 */
    tas d7
/* QL: bp_adate        ; $01 */
bp_adate:
/* QL:         addq.b  #mt.aclck-mt.sclck,d7 */
.word 20487|((((mt.aclck-mt.sclck))&7)<<9)
/* QL: bp_sdate        ; $00 */
bp_sdate:
/* QL:         bsr.s   bf_datex */
    bsr.s bf_datex
/* QL:         bne.s   rts0 */
    bne.s rts0
/* QL:         moveq   #mt.sclck,d0 */
    moveq #mt.sclck,d0
/* QL:         add.b   d7,d0 */
    add.b d7,d0
/* QL:         beq.s   bf_fllin        bf_date */
    beq.s bf_fllin
/* QL:         bpl.s   trap1           (bug in GC: bits 15..7 not ignored) */
    bpl.s trap1
/* QL:         move.w  d7,a2 */
    move.w d7,a2
/* QL:         move.w  $EC-$81(a2),a2  fetch cn_day/cb_date from vector table */
    move.w (0xec-0x81)(a2),a2
/* QL:         moveq   #t.str,d4       set return type */
    moveq #t.str,d4
/* QL:         jsr     (a2)            do conversion required */
    jsr (a2)
/* QL: putrip */
putrip:
/* QL:         move.l  a1,bv_rip(a6)   set stack pointer */
    move.l a1,bv_rip(a6)
/* QL:         rts */
    rts 
/* QL: * Number of days preceeding each month in a non-leap year, less one. */
/* QL: monoff  dc.w    -1,30,58,89,119,150,180,211,242,272,303,333 */
.balign 2,0
monoff:
dc_anchor_425:
.word ((-1))&65535
.word 30
.word 58
.word 89
.word 119
.word 150
.word 180
.word 211
.word 242
.word 272
.word 303
.word 333
/* QL: * Make this available for date function. */
/* QL: * It permits zero to four or six parameters and removes them from the ri stack. */
/* QL: * No parameters will read the clock. If parameters are given, they are seconds, */
/* QL: * minutes/second, hours/minutes/seconds, days/hours/minutes/seconds or */
/* QL: * a complete date specification of year/month/day/hours/minute/second. */
/* QL: * d1.l is the resultant seconds since the year dot. */
/* QL: * d0.l is a normal error code, or zero for success. */
/* QL: * d2-d4/d6/a0/a2 are all smashed. */
/* QL: * a1.l will be back to the original bv_rip value. */
/* QL: * A reasonable amount of spare space will have been allocated on the ri stack. */
/* QL: bf_datex */
bf_datex:
/* QL:         jsr     bv_chri(pc)     make sure of a reasonable amount of space */
    jsr bv_chri(pc)
/* QL:         jsr     ca_gtlin(pc)    get parameters as long integers */
    jsr ca_gtlin(pc)
/* QL:         bne.s   rts0            propagate any error */
    bne.s rts0
/* QL:         moveq   #mt.rclck,d0 */
    moveq #mt.rclck,d0
/* QL:         asl.w   #2,d3 */
    asl.w #2,d3
/* QL:         bne.s   parms */
    bne.s parms
/* QL: trap1 */
trap1:
/* QL:         trap    #1 */
    trap #1
/* QL: ok */
ok:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: tstrts */
tstrts:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: parms */
parms:
/* QL:         move.l  a1,d2 */
    move.l a1,d2
/* QL:         add.w   d3,a1 */
    add.w d3,a1
/* QL:         bsr.s   putrip          reset the stack */
    bsr.s putrip
/* QL:         move.l  0(a6,d2.l),d1   pick up first parameter */
    move.l 0(a6,d2.l),d1
/* QL:         subq.w  #2<<2,d3 */
    subq.w #(2<<2),d3
/* QL:         bcs.s   ok              one parameter: just seconds */
    bcs.s ok
/* QL:         beq.s   mul60add        two parameters: minutes/seconds */
    beq.s mul60add
/* QL:         subq.w  #2<<2,d3 */
    subq.w #(2<<2),d3
/* QL:         bcs.s   hms             three params: hours/minutes/seconds */
    bcs.s hms
/* QL:         beq.s   dhms            four params: days/hours/minutes/seconds */
    beq.s dhms
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         subq.w  #2<<2,d3 */
    subq.w #(2<<2),d3
/* QL:         bne.s   tstrts          if not 6 params then error */
    bne.s tstrts
/* QL: * Make this bit available to bootup i2c date copy */
/* QL: * d0 -  o- zero */
/* QL: * d1 -i o- input year, output seconds since dot */
/* QL: * d2 -  o- zero */
/* QL: * a1 -ip - pointer rel a6 to end of 20 bytes, 5 longs: mm,dd,hh,mm,ss */
/* QL: * a6 -ip - base for a1 */
/* QL: * d3/d4 and d6.lsb destroyed */
/* QL: bf_datez */
bf_datez:
/* QL:         moveq   #-16,d2 */
    moveq #(-16),d2
/* QL:         add.l   a1,d2           offset on stack to days */
    add.l a1,d2
/* QL:         move.b  d1,d6 */
    move.b d1,d6
/* QL:         sub.w   #dot,d1         (year-dot) */
    sub.w #dot,d1
/* QL:         move.w  d1,d4 */
    move.w d1,d4
/* QL:         move.w  #365,d0 */
    move.w #365,d0
/* QL:         bsr.s   muladd          ... * 365 + days ... */
    bsr.s muladd
/* QL:         lsr.w   #2,d4 */
    lsr.w #2,d4
/* QL:         add.w   d4,d1           ... + (year-dot) div 4 ... */
    add.w d4,d1
/* QL:         move.w  -18(a6,a1.l),d0 get month */
    move.w (-18)(a6,a1.l),d0
/* QL:         add.w   d0,d0 */
    add.w d0,d0
/* QL:         add.w   monoff-2(pc,d0.w),d1 ... + offset(month-1) ... */
    add.w (monoff-2)(pc,d0.w),d1
/* QL:         lsl.b   #8-2,d6         if it's a leap year */
    lsl.b #(8-2),d6
/* QL:         bne.s   dhms */
    bne.s dhms
/* QL:         subq.w  #3<<1,d0        and it's gone february */
    subq.w #(3<<1),d0
/* QL:         bcs.s   dhms */
    bcs.s dhms
/* QL:         addq.l  #1,d1           then ... + 1 ... (feb 29 not in offset table) */
    addq.l #1,d1
/* QL: dhms */
dhms:
/* QL:         moveq   #24,d0 */
    moveq #24,d0
/* QL:         bsr.s   muladd          ... * 24 + hrs ... */
    bsr.s muladd
/* QL: hms */
hms:
/* QL:         jsr     mul60add        ... * 60 + mins ... */
    jsr mul60add
/* QL: ms */
ms:
/* QL: *       bsr.s   mul60add        ... * 60 + secs */
/* QL: *       bra.s   ok */
/* QL: * Multiply and add subroutine */
/* QL: * Entry: */
/* QL: *       d0.w = w, 16 bit multiplier */
/* QL: *       d1.l = l, 32 bit multiplicand */
/* QL: *       d2.l = offset on ri stack to "p", the 32 bit addend */
/* QL: * Exit: */
/* QL: *       d0.l = 0 */
/* QL: *       d1.l = l*w+p */
/* QL: *       d2.l 4 added */
/* QL: *       d3.l smashed */
/* QL: mul60add */
mul60add:
/* QL:         moveq   #60,d0 */
    moveq #60,d0
/* QL: muladd */
muladd:
/* QL:         move.l  d1,d3 */
    move.l d1,d3
/* QL:         swap    d3 */
    swap d3
/* QL:         mulu    d0,d3 */
    mulu d0,d3
/* QL:         swap    d3              d3(msw) = l(msw) * w */
    swap d3
/* QL:         clr.w   d3              d3(lsw) = 0 */
    clr.w d3
/* QL:         mulu    d0,d1           d1 = l(lsw) * w */
    mulu d0,d1
/* QL:         add.l   d3,d1           d1 = l * w */
    add.l d3,d1
/* QL:         add.l   0(a6,d2.l),d1   add p */
    add.l 0(a6,d2.l),d1
/* QL:         addq.l  #4,d2           move on pointer */
    addq.l #4,d2
/* QL:         bra.s   ok */
    bra.s ok
/* QL:         end */
