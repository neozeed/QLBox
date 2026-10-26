/* Generated from original/M/bp/beep.asm */
/* QL: * Basic beep command */
/* QL:         xdef    bp_beep */
.globl bp_beep
/* QL:         xref    bf_ipcom */
/* QL:         xref    bv_chrix */
/* QL:         xref    ca_gtint */
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
/* QL:         include 'win1_m_inc_ipcmd' */
/* QL: * ipcmd : IPC link commands */
/* QL:         nolist */
/* QL: * command nibbles sent to IPC: */
/* QL: *rset_cmd equ    0       resets the IPC software */
/* QL: stat_cmd equ    1       report input status */
.equ stat_cmd,1
/* QL: * returns a byte, the bits of which are: */
/* QL: ipc..kb equ     0       set if data available in keyboard buffer, or key held */
.equ ipc..kb,0
/* QL: ipc..so equ     1       set if sound is still being generated */
.equ ipc..so,1
/* QL: *               2       set if kbd shift setting has changed, with key held */
/* QL: *               3       set if key held down */
/* QL: ipc..s1 equ     4       set if input is pending from RS232 channel 1 */
.equ ipc..s1,4
/* QL: ipc..s2 equ     5       set if input is pending from RS232 channel 2 */
.equ ipc..s2,5
/* QL: ipc..wp equ     6       return state of p26, currently not connected */
.equ ipc..wp,6
/* QL: *               7       was set if serial transfer was being zapped, now zero */
/* QL: ops1_cmd equ    2       open RS232 channel 1 */
.equ ops1_cmd,2
/* QL: ops2_cmd equ    3       open RS232 channel 2 */
.equ ops2_cmd,3
/* QL: cls1_cmd equ    4       close RS232 channel 1 */
.equ cls1_cmd,4
/* QL: cls2_cmd equ    5       close RS232 channel 2 */
.equ cls2_cmd,5
/* QL: * These open/close RS232 channels, affecting handshaking. */
/* QL: rds1_cmd equ    6       read RS232 channel 1 */
.equ rds1_cmd,6
/* QL: rds2_cmd equ    7       read RS232 channel 2 */
.equ rds2_cmd,7
/* QL: * These return a byte with a count in the ls 6 bits of how many received */
/* QL: * serial channel bytes are to follow. The ms 2 bits contain status info... */
/* QL: * Silly, but the following implies that the IPC must never send more than... */
/* QL: sbsize  equ     25      minimmum space needed to receive whole IPC RS232 buffer */
.equ sbsize,25
/* QL: rdkb_cmd equ    8       read keyboard */
.equ rdkb_cmd,8
/* QL: * This returns one nibble, plus up to 7 nibble/byte pairs: */
/* QL: * first nibble, ms bit: set if final last keydef is still held */
/* QL: * first nibble, ls 3 bits: count of keydefs to follow. */
/* QL: * then, for each of the 0..7 keydefs: */
/* QL: * nibble, bits are 3210=lsca: lost keys (last set only), shift, ctrl and alt. */
/* QL: * byte, bits are 76543210=00colrow: column and row as keyrow table. */
/* QL: * There is a version of the IPC used on the thor that will also return keydef */
/* QL: * values for a keypad. This needs looking up. */
/* QL: kbdr_cmd equ    9       keyboard direct read */
.equ kbdr_cmd,9
/* QL: * kbdr_cmd requires one nibble which selects the row to be read. */
/* QL: * The top bit of this is ignored (at least on standard IPC's...). */
/* QL: * It responds with a byte whose bits indicate which of the up to eight keys on */
/* QL: * the specified row of the keyrow table are held down. */
/* QL: inso_cmd equ    10      initiate sound process */
.equ inso_cmd,10
/* QL: * This requires no less than 64 bits of data. it starts sound generation. */
/* QL: * Note that the 16 bit values below need to have their ls 8 bits sent first! */
/* QL: * 8 bits pitch 1 */
/* QL: * 8 bits pitch 2 */
/* QL: * 16 bits interval between steps */
/* QL: * 16 bits duration (0=forever) */
/* QL: * 4 bits signed step in pitch */
/* QL: * 4 bits wrap */
/* QL: * 4 bits randomness (none unless msb is set) */
/* QL: * 4 bits fuziness (none unless msb is set) */
/* QL: kiso_cmd equ    11      immediately stop sound generation */
.equ kiso_cmd,11
/* QL: *mdrs_cmd equ    12      microdrive reduced sensitivity */
/* QL: * This expects one nibble, of which only the lsb is significant. This was */
/* QL: * intended for allowing marginal tapes to be handled, but had a strange side */
/* QL: * effect of causing permanent level 2 interrupts! the QView capsled kit steals */
/* QL: * This bit of h/w (on leg of the chip) to drive the led. */
/* QL: * Hermes uses a parameter value of 9 to switch on its clever handling, when the */
/* QL: * reset command becomes an extended functionally command and the test command */
/* QL: * will return the complemented byte value. */
/* QL: baud_cmd equ    13      change baud rate */
.equ baud_cmd,13
/* QL: * This expects one nibble, of which the 3 lsbs select the baud rate for both */
/* QL: * serial channels. The msb is ignored. Values 7 down to zero correspond to baud */
/* QL: * rates 75/300/600/1200/2400/4800/9600/19200. */
/* QL: * The actual clock rate is supplied from the PC to the IPC, but this command is */
/* QL: * also needed in the IPC for timing out transfers! */
/* QL: *rand_cmd equ    14      random number generator, returns a sixteen bit number. */
/* QL: *test_cmd equ    15      test, expects a byte, which it then sends back. */
/* QL: * Communication with the IPC is done using the following bit serial protocol. */
/* QL: * Commands and data are sent msb first, by writing a byte containg %11x0 to */
/* QL: * location pc_ipcwr ($18023), where the "x" is one data bit. Bit 6 at location */
/* QL: * pc_ipcrd ($18020) is then examined, waiting for it to go zero to indicate */
/* QL: * that the bit has been received by the IPC. */
/* QL: * Receiving data from the IPC is done by writing %1110 to pc_ipcwr for each bit */
/* QL: * of the data, once again waiting for bit 6 at pc_ipcrd to go to zero, and */
/* QL: * then reading bit 7 there as the data bit. The data is received msb first. */
/* QL: * The reason behind effectively sending a one bit for each read is the way the */
/* QL: * hardware functions. There are only two wires between the PC and IPC to work */
/* QL: * with, and only one is bi-directional. Even this is limited, in that either */
/* QL: * end can force it to zero, but both ends must agree to make it a one. Hence */
/* QL: * when the PC is trying to read data from the IPC, it must be asserting a one */
/* QL: * in order to see whether the IPC is returning a one or zero bit. */
/* QL: * Note: pc_tdata ($18022) is where full 8 bit data bytes are sent for serial */
/* QL: * output, with the PC interrupting whenever it is ready for more. */
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
/* QL: * Syntax: BEEP{ duration,pitch{,pitch_2,grad_x,grad_y{,wrap{,fuzzy{,random}}}}} */
/* QL: *                 p3w     p0b     p1b    p2w     p4n    p5n   p7n    p6n */
/* QL: parmcnt equ     8               max no of parameters */
.equ parmcnt,8
/* QL:         section bp_beep */
.section bp_beep,"ax"
/* QL: bp_beep */
bp_beep:
/* QL:         st      -(sp)           set for no reply */
    st -(sp)
/* QL:         subq.l  #1+1+4,sp       no parms on kill, so length word can be garbage */
    subq.l #((1+1)+4),sp
/* QL:         move.w  #kiso_cmd<<8!0,(sp) kill sound, no parameter bytes */
    move.w #((kiso_cmd<<8)|0),(sp)
/* QL:         move.l  a3,d7 */
    move.l a3,d7
/* QL:         sub.l   a5,d7           - 8 * parameter count */
    sub.l a5,d7
/* QL:         beq.s   gotrap          none - kill any beeping */
    beq.s gotrap
/* QL:         moveq   #parmcnt*2,d1 */
    moveq #(parmcnt*2),d1
/* QL:         jsr     bv_chrix(pc)    make sure of adequate space on ri stack */
    jsr bv_chrix(pc)
/* QL:         asr.l   #3,d7           - parameter count */
    asr.l #3,d7
/* QL:         moveq   #err.bp,d0      set d0 for possible error return */
    moveq #err.bp,d0
/* QL:         addq.l  #parmcnt,d7     count of parameters being defaulted */
    addq.l #parmcnt,d7
/* QL:         bcc.s   exit            too many parameters is invalid */
    bcc.s exit
/* QL:         moveq   #%01001111,d2   reject 1, 3 or 4 parameters as invalid */
    moveq #0b01001111,d2
/* QL:         btst    d7,d2 */
    btst d7,d2
/* QL:         beq.s   exit            reject bad parameter count */
    beq.s exit
/* QL:         add.l   d7,d7 */
    add.l d7,d7
/* QL:         sub.l   d7,bv_rip(a6)   register space on stack for defaults */
    sub.l d7,bv_rip(a6)
/* QL:         jsr     ca_gtint(pc)    get non-defaulted parameters */
    jsr ca_gtint(pc)
/* QL:         bne.s   exit */
    bne.s exit
/* QL:         lea     parmcnt*2(a1),a0 end of parameter area */
    lea (parmcnt*2)(a1),a0
/* QL:         add.w   d3,a1 */
    add.w d3,a1
/* QL:         add.w   d3,a1           step over the non-defaulted parameters */
    add.w d3,a1
/* QL:         subq.b  #2,d3           were there just two parameters? */
    subq.b #2,d3
/* QL:         bne.s   chk_def         no - only pitch_2 defaults to pitch */
    bne.s chk_def
/* QL:         move.w  2-parmcnt*2(a6,a0.l),d1 pick up pitch */
    move.w (2-(parmcnt*2))(a6,a0.l),d1
/* QL: def_lp */
def_lp:
/* QL:         move.w  d1,0(a6,a1.l)   set default */
    move.w d1,0(a6,a1.l)
/* QL:         addq.l  #2,a1           step on */
    addq.l #2,a1
/* QL: chk_def */
chk_def:
/* QL:         moveq   #0,d1           rest default to zero */
    moveq #0,d1
/* QL:         cmp.l   a1,a0           any more to default? */
    cmp.l a1,a0
/* QL:         bne.s   def_lp          yes - keep going */
    bne.s def_lp
/* QL:         movem.w -parmcnt*2(a6,a0.l),d3-d6/a1-a4 pick them all up */
    movem.w ((-parmcnt)*2)(a6,a0.l),d3-d6/a1-a4
/* QL:         move.w  d3,d7           slot duration into order */
    move.w d3,d7
/* QL:         addq.b  #1,d4           pitch needs one added */
    addq.b #1,d4
/* QL:         addq.b  #1,d5           pitch_2 needs one added */
    addq.b #1,d5
/* QL:         ror.w   #8,d6           interval word needs bytes reversed */
    ror.w #8,d6
/* QL:         ror.w   #8,d7           duration word needs bytes reversed */
    ror.w #8,d7
/* QL:         exg     a3,a4           random and fuzzy need swapping over */
    exg a4,a3
/* QL:         addq.l  #1+1+4,sp       discard the kill command.b/count.b/length.l */
    addq.l #((1+1)+4),sp
/* QL:         movem.w d4-d7/a1-a4,-(sp) put on the beep init parameters */
    movem.w d4-d7/a1-a4,-(sp)
/* QL:         move.l  #%00010001000100011010101010011001,-(sp) put on the lengths */
    move.l #0b00010001000100011010101010011001,-(sp)
/* QL:                 ;  4 - 4 - 4 - 4 - 8 8 8 8 8 - 8 - */
/* QL:                 ;  fuz rnd wrp gry dur grx pt2 pt1 */
/* QL:         move.w  #inso_cmd<<8+parmcnt*2,-(sp) put on the command/count */
    move.w #((inso_cmd<<8)+(parmcnt*2)),-(sp)
/* QL: gotrap */
gotrap:
/* QL:         lea     bf_ipcom(pc),a2 execute command on stack in supervisor mode */
    lea bf_ipcom(pc),a2
/* QL:         moveq   #mt.extop,d0 */
    moveq #mt.extop,d0
/* QL:         trap    #1              protected against basic moving */
    trap #1
/* QL: exit */
exit:
/* QL:         assert  16,parmcnt*2 */
/* original assertion: 16,parmcnt*2 */
/* QL:         ; Note: parameter count was either zero or sixteen */
/* QL:         moveq   #-32+1+1+4+2,d1 */
    moveq #(((((-32)+1)+1)+4)+2),d1
/* QL:         or.w    (sp),d1         get 16/0 bit to form overall length less 32  */
    or.w (sp),d1
/* QL:         lea     32(sp,d1.w),sp  discard the entire command */
    lea 32(sp,d1.w),sp
/* QL:         rts */
    rts 
/* QL:         end */
