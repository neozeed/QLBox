/* Generated from original/M/ib/stop.asm */
/* QL: * Deal with things that stop basic program execution */
/* QL:         xdef    ib_stop,ib_clvv */
.globl ib_stop,ib_clvv
/* QL:         xref    ib_unret,ib_npass,ib_error,ib_pserr,ib_whzap */
/* QL:         xref    bp_lszap */
/* QL:         xref    bv_clear,bv_names,bv_vtype */
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
/* QL:         include 'win1_m_inc_rt' */
/* QL: * return stack pointers */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: rt.svba ds.l    1       base of args */
.equ rt.svba,0
/* QL: rt.svbl ds.l    1       base of locals */
.equ rt.svbl,4
/* QL: rt.svtl ds.l    1       top of locals */
.equ rt.svtl,8
/* QL: rt.svdfl ds.w   1       def line number */
.equ rt.svdfl,12
/* QL: rt.svfnt ds.b   1       function type */
.equ rt.svfnt,14
/* QL: rt.svswp ds.b   1       args swapped ($ff) or not (0) */
.equ rt.svswp,15
/* QL: rt.lenpr ; length of pr/fn bits */
.equ rt.lenpr,16
/* QL: * add rt.lenpr to next four if total wanted from base */
/* QL:         offset  0 */
/* QL: rt.svrtt ds.b   1       return type - 0 gosub, 1 proc, other fn */
.equ rt.svrtt,0
/* QL: rt.svstm ds.b   1       statement to return to */
.equ rt.svstm,1
/* QL: rt.svlno ds.w   1       line number to return to */
.equ rt.svlno,2
/* QL: rt.svsta ds.l   1       status flags - inlin, sing, index */
.equ rt.svsta,4
/* QL: rt.lentl equ    *+rt.lenpr total length */
.equ rt.lentl,(8+rt.lenpr)
/* QL: * restoring wants offsets working downwards */
/* QL: rt.rsba equ     rt.lentl-rt.svba */
.equ rt.rsba,(rt.lentl-rt.svba)
/* QL: rt.rsbl equ     rt.lentl-rt.svbl */
.equ rt.rsbl,(rt.lentl-rt.svbl)
/* QL: rt.rstl equ     rt.lentl-rt.svtl */
.equ rt.rstl,(rt.lentl-rt.svtl)
/* QL: rt.rsdfl equ    rt.lentl-rt.svdfl */
.equ rt.rsdfl,(rt.lentl-rt.svdfl)
/* QL: rt.rsfnt equ    rt.lentl-rt.svfnt */
.equ rt.rsfnt,(rt.lentl-rt.svfnt)
/* QL: rt.rsswp equ    rt.lentl-rt.svswp */
.equ rt.rsswp,(rt.lentl-rt.svswp)
/* QL: rt.rsrtt equ    rt.lentl-rt.lenpr-rt.svrtt */
.equ rt.rsrtt,((rt.lentl-rt.lenpr)-rt.svrtt)
/* QL: rt.rsstm equ    rt.lentl-rt.lenpr-rt.svstm */
.equ rt.rsstm,((rt.lentl-rt.lenpr)-rt.svstm)
/* QL: rt.rslno equ    rt.lentl-rt.lenpr-rt.svlno */
.equ rt.rslno,((rt.lentl-rt.lenpr)-rt.svlno)
/* QL: rt.rssta equ    rt.lentl-rt.lenpr-rt.svsta */
.equ rt.rssta,((rt.lentl-rt.lenpr)-rt.svsta)
/* QL:         list */
/* QL:         include 'win1_m_inc_stop' */
/* QL: * superbasic stop numbers */
/* QL:         nolist */
/* QL: s.clear equ     0 */
.equ s.clear,0
/* QL: s.new   equ     2 */
.equ s.new,2
/* QL: s.stop  equ     4 */
.equ s.stop,4
/* QL: s.run   equ     6 */
.equ s.run,6
/* QL: s.lrun  equ     8 */
.equ s.lrun,8
/* QL: s.load  equ     10 */
.equ s.load,10
/* QL: s.mrun  equ     12 */
.equ s.mrun,12
/* QL: s.merge equ     14 */
.equ s.merge,14
/* QL: s.retry equ     16 */
.equ s.retry,16
/* QL: s.outm  equ     18 */
.equ s.outm,18
/* QL:         list */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section ib_stop */
.section ib_stop,"ax"
/* QL: stop_tab macro */
/* QL:  stop_tab clear new stop run lrun load mrun merge retry outm */
/* QL: stop_tab */
stop_tab:
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.clear 1*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_468:
.word ((s_clear-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.new 2*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_477:
.word ((s_new-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.stop 3*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_486:
.word ((s_stop-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.run 4*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_495:
.word ((s_run-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.lrun 5*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_504:
.word ((s_lrun-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.load 6*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_513:
.word ((s_load-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.mrun 7*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_522:
.word ((s_mrun-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.merge 8*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_531:
.word ((s_merge-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.retry 9*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_540:
.word ((s_retry-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: s.outm 10*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
dc_anchor_549:
.word ((s_outm-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: * Use stop number to do real work for commands which stop program execution. */
/* QL: ib_stop */
ib_stop:
/* QL:         move.w  bv_stopn(a6),d1 read the stop number */
    move.w bv_stopn(a6),d1
/* QL:         move.w  stop_tab(pc,d1.w),d1 get the offset to go to */
    move.w stop_tab(pc,d1.w),d1
/* QL:         jmp     ib_stop(pc,d1.w) and go to it */
.word 0x4efb
.word 4096|((ib_stop-.)&255)
/* QL: s_outm */
s_outm:
/* QL:         jsr     ib_error(pc)    write the 'out of memory' message then clear */
    jsr ib_error(pc)
/* QL:         move.l  bv_rtp(a6),a0   get top of return stack */
    move.l bv_rtp(a6),a0
/* QL:         sf      bv_auto(a6) */
    sf bv_auto(a6)
/* QL: nx_rt */
nx_rt:
/* QL:         cmp.l   bv_rtbas(a6),a0 bottom of return stack yet ? */
    cmp.l bv_rtbas(a6),a0
/* QL:         ble.s   clear_1 */
    ble.s clear_1
/* QL:         move.b  -rt.rsrtt(a6,a0.l),d0 look at type */
    move.b (-rt.rsrtt)(a6,a0.l),d0
/* QL:         beq.s   gsub            GOSUB */
    beq.s gsub
/* QL:         assert  rt.rsba,rt.rstl+8 */
/* original assertion: rt.rsba,rt.rstl+8 */
/* QL:         movem.l -rt.rsba(a6,a0.l),d0-d2 offset of base of args and top locals */
    movem.l (-rt.rsba)(a6,a0.l),d0-d2
/* QL:         sub.l   d0,d2           this is how many there are */
    sub.l d0,d2
/* QL:         add.l   bv_ntbas(a6),d0 plus base of table */
    add.l bv_ntbas(a6),d0
/* QL:         bra.s   rt_ent */
    bra.s rt_ent
/* QL: rt_loop */
rt_loop:
/* QL:         clr.l   0(a6,d0.l)      wipe the entry as spare */
    clr.l 0(a6,d0.l)
/* QL:         addq.l  #8,d0 */
    addq.l #8,d0
/* QL: rt_ent */
rt_ent:
/* QL:         subq.l  #8,d2 */
    subq.l #8,d2
/* QL:         bcc.s   rt_loop */
    bcc.s rt_loop
/* QL:         sub.w   #rt.lenpr,a0 */
    sub.w #rt.lenpr,a0
/* QL: gsub */
gsub:
/* QL:         subq.l  #rt.lentl-rt.lenpr,a0 */
.word 20872|((((rt.lentl-rt.lenpr))&7)<<9)
/* QL:         bra.s   nx_rt */
    bra.s nx_rt
/* QL: nt_clear */
nt_clear:
/* QL:         clr.l   0(a6,a2.l)      hopefully, we might be able to reuse this entry */
    clr.l 0(a6,a2.l)
/* QL: *       clr.l   4(a6,a2.l)      no need to clear VV pointer */
/* QL: nt_next */
nt_next:
/* QL:         addq.l  #8,a2           move to next row */
    addq.l #8,a2
/* QL: nt_ent */
nt_ent:
/* QL:         cmp.l   bv_ntp(a6),a2   finished? */
    cmp.l bv_ntp(a6),a2
/* QL:         beq.s   nt_done */
    beq.s nt_done
/* QL: nt_loop */
nt_loop:
/* QL:         move.b  0(a6,a2.l),d0   what type is this name? */
    move.b 0(a6,a2.l),d0
/* QL:         subq.b  #t.mcp,d0 */
    subq.b #t.mcp,d0
/* QL:         bcc.s   nt_keep         always keep m/c proc/fn */
    bcc.s nt_keep
/* QL:         addq.b  #t.mcp-t.intern,d0 */
.word 20480|((((t.mcp-t.intern))&7)<<9)
/* QL:         beq.s   nt_clear        always discard internal */
    beq.s nt_clear
/* QL:         tst.w   2(a6,a2.l)      look at namelist offset */
    tst.w 2(a6,a2.l)
/* QL:         ble.s   nt_clear        if not +ve, then this is not required */
    ble.s nt_clear
/* QL: * N.B. We know that "PRINT" is the name with NL offset 0, and it's an m/c proc */
/* QL: * Also, we'll drop basic PROC/FN's, as npass will reset them properly later */
/* QL:         jsr     bv_vtype(pc)    make it unset with proper type */
    jsr bv_vtype(pc)
/* QL:         moveq   #-1,d0 */
    moveq #(-1),d0
/* QL:         move.l  d0,4(a6,a2.l)   set no value */
    move.l d0,4(a6,a2.l)
/* QL: nt_keep */
nt_keep:
/* QL:         move.l  a2,a0           remember the highest active NT entry */
    move.l a2,a0
/* QL:         bra.s   nt_next */
    bra.s nt_next
/* QL: s_clear */
s_clear:
/* QL:         bsr.s   qunrv2 */
    bsr.s qunrv2
/* QL: clear_1 */
clear_1:
/* QL:         bsr.s   ib_clvv         clear variables and reset data */
    bsr.s ib_clvv
/* QL:         jsr     bv_clear(pc)    return RT and VV space to system */
    jsr bv_clear(pc)
/* QL:         st      bv_edit(a6)     force an npass after this */
    st bv_edit(a6)
/* QL:         move.l  bv_ntbas(a6),a2 start at bottom of name table */
    move.l bv_ntbas(a6),a2
/* QL:         bra.s   nt_ent */
    bra.s nt_ent
/* QL: nt_done */
nt_done:
/* QL:         addq.l  #8,a0 */
    addq.l #8,a0
/* QL:         move.l  a0,bv_ntp(a6)   keep just the last active NT entry */
    move.l a0,bv_ntp(a6)
/* QL: s_run */
s_run:
/* QL:         move.w  bv_nxlin(a6),-(sp) just for DEF as last line of file! */
    move.w bv_nxlin(a6),-(sp)
/* QL:         move.w  bv_stopn(a6),-(sp) */
    move.w bv_stopn(a6),-(sp)
/* QL:         moveq   #2+2+2*4,d1     select stack depth */
    moveq #((2+2)+(2*4)),d1
/* QL:         bsr.s   qunrvl */
    bsr.s qunrvl
/* QL:         move.w  (sp)+,bv_stopn(a6) */
    move.w (sp)+,bv_stopn(a6)
/* QL:         move.w  (sp)+,bv_nxlin(a6) */
    move.w (sp)+,bv_nxlin(a6)
/* QL:         jsr     ib_npass(pc)    where to run from already set */
    jsr ib_npass(pc)
/* QL:         bra.s   end_seq */
    bra.s end_seq
/* QL: s_stop */
s_stop:
/* QL:         tst.b   bv_wherr(a6)    are we doing a WHEN? */
    tst.b bv_wherr(a6)
/* QL:         sf      bv_wherr(a6) */
    sf bv_wherr(a6)
/* QL:         bne.s   end_seq         yes, don't change continue status then */
    bne.s end_seq
/* QL:         jsr     ib_pserr(pc)    set continuation status but no errmess */
    jsr ib_pserr(pc)
/* QL:         bra.s   ok_rts */
    bra.s ok_rts
/* QL: qunrv2 */
qunrv2:
/* QL:         moveq   #2*4,d1         select stack depth */
    moveq #(2*4),d1
/* QL: qunrvl */
qunrvl:
/* QL:         tst.b   bv_unrvl(a6)    do we need to unravel first? */
    tst.b bv_unrvl(a6)
/* QL:         beq.s   rts0            no */
    beq.s rts0
/* QL:         jmp     ib_unret(pc) */
    jmp ib_unret(pc)
/* QL: * A common routine to initialise things hit at least by CLEAR. */
/* QL: * d0 -  o- 0 */
/* QL: ib_clvv */
ib_clvv:
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         assert  bv_dalno,bv_dastm-2,bv_daitm-3 */
/* original assertion: bv_dalno,bv_dastm-2,bv_daitm-3 */
/* QL:         move.l  d0,bv_dalno(a6) clear data line number & statement, but item=1 */
    move.l d0,bv_dalno(a6)
/* QL:         jsr     ib_whzap(pc)    kill when variable handling */
    jsr ib_whzap(pc)
/* QL:         move.l  bv_vvbas(a6),bv_vvp(a6) delete the VV area */
    move.l bv_vvbas(a6),bv_vvp(a6)
/* QL:         clr.l   bv_vvfre(a6)    drop VV free list */
    clr.l bv_vvfre(a6)
/* QL:         move.l  bv_rtbas(a6),bv_rtp(a6) delete the return stack */
    move.l bv_rtbas(a6),bv_rtp(a6)
/* QL:         moveq   #bv_btp-bv_ribas,d0 */
    moveq #(bv_btp-bv_ribas),d0
/* QL: ri_set */
ri_set:
/* QL:         move.l  bv_ribas(a6),bv_ribas(a6,d0.w) delete RI, TG and BT stacks */
    move.l bv_ribas(a6),bv_ribas(a6,d0.w)
/* QL:         addq.l  #4,d0           move up to next pointer */
    addq.l #4,d0
/* QL:         bne.s   ri_set          until change in direction */
    bne.s ri_set
/* QL:         sf      bv_unrvl(a6)    no unravel now */
    sf bv_unrvl(a6)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: s_mrun */
s_mrun:
/* QL: s_merge */
s_merge:
/* QL:         bsr.s   qunrv2 */
    bsr.s qunrv2
/* QL: end_seq */
end_seq:
/* QL:         move.b  bv_sing(a6),bv_comln(a6) save on return if single line */
    move.b bv_sing(a6),bv_comln(a6)
/* QL: ok_rts */
ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: ib_new */
ib_new:
/* QL: s_lrun */
s_lrun:
/* QL: s_load */
s_load:
/* QL: s_new */
s_new:
/* QL: * N.B. Qload,Qlrun search from $a000 for next two instns to find this entry  */
/* QL:         move.l  bv_chp(a6),a3 */
    move.l bv_chp(a6),a3
/* QL:         move.l  bv_chbas(a6),a2 */
    move.l bv_chbas(a6),a2
/* QL:         add.w   #ch.lench*3,a2  channels 0, 1 and 2 */
    add.w #(ch.lench*3),a2
/* QL:         moveq   #bv_lnp-bv_chp,d0 kill off LN/RT as well */
    moveq #(bv_lnp-bv_chp),d0
/* QL: chzap */
chzap:
/* QL:         move.l  a2,bv_chp(a6,d0.w) */
    move.l a2,bv_chp(a6,d0.w)
/* QL:         subq.w  #4,d0 */
    subq.w #4,d0
/* QL:         bcc.s   chzap */
    bcc.s chzap
/* QL:         bra.s   ch_next */
    bra.s ch_next
/* QL: s_retry */
s_retry:
/* QL: *       clr.w   bv_stopn(a6)    set to zero for return  $$$ why ? $$$ */
/* QL:         move.w  bv_cnlno(a6),bv_nxlin(a6) copy line number to continue after */
    move.w bv_cnlno(a6),bv_nxlin(a6)
/* QL:         move.b  bv_cnstm(a6),bv_nxstm(a6) copy statement to continue after */
    move.b bv_cnstm(a6),bv_nxstm(a6)
/* QL:         move.w  #-1,bv_cnlno(a6) and reset the continue linum for next time */
    move.w #(-1),bv_cnlno(a6)
/* QL:         move.b  bv_cninl(a6),bv_inlin(a6) copy old inline flag */
    move.b bv_cninl(a6),bv_inlin(a6)
/* QL:         move.w  bv_cnind(a6),bv_index(a6) copy old index variable */
    move.w bv_cnind(a6),bv_index(a6)
/* QL: retry_1 */
retry_1:
/* QL:         sf      bv_comln(a6)    don't save */
    sf bv_comln(a6)
/* QL:         bra.s   ok_rts */
    bra.s ok_rts
/* QL: ch_loop */
ch_loop:
/* QL:         move.l  0(a6,a2.l),d0   read channel id */
    move.l 0(a6,a2.l),d0
/* QL:         blt.s   ch_add          it's closed already */
    blt.s ch_add
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         moveq   #io.close,d0 */
    moveq #io.close,d0
/* QL:         trap    #2              close it */
    trap #2
/* QL: ch_add */
ch_add:
/* QL:         add.w   #ch.lench,a2    move to next channel block */
    add.w #ch.lench,a2
/* QL: ch_next */
ch_next:
/* QL:         cmp.l   a3,a2           any channels left? */
    cmp.l a3,a2
/* QL:         blt.s   ch_loop */
    blt.s ch_loop
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         moveq   #mt.dmode,d0    find the current display mode */
    moveq #mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         moveq   #mt.dmode,d0    and reset it to clear attributes */
    moveq #mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         jsr     bp_lszap(pc)    wipe out list info */
    jsr bp_lszap(pc)
/* QL:         bsr.l   ib_clvv         clear the VV table and reset data */
    bsr.w ib_clvv
/* QL:         tas     d0              set d0.l to 128, minimal BF size */
    tas d0
/* QL:         add.l   (a6),d0 */
    add.l (a6),d0
/* QL:         moveq   #bv_pfp,d1 */
    moveq #bv_pfp,d1
/* QL: zappf */
zappf:
/* QL:         move.l  d0,0(a6,d1.w)   zap TK and PF */
    move.l d0,0(a6,d1.w)
/* QL:         subq.w  #4,d1 */
    subq.w #4,d1
/* QL:         bne.s   zappf */
    bne.s zappf
/* QL:         jsr     bv_names(pc)    clear all but mcprocs, mcfns */
    jsr bv_names(pc)
/* QL:         bra.s   retry_1         never do rest of command line (names gone) */
    bra.s retry_1
/* QL:         vect4000 ib_new */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl ib$new
/* QL: [o]     equ     [h]-$4000 */
.equ ib$new,(ib_new-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
