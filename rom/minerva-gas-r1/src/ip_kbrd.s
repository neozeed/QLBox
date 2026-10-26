/* Generated from original/M/ip/kbrd.asm */
/* QL: * IPC keyboard reader */
/* QL:         xdef    ip_dspm,ip_kbend,ip_kbrd */
.globl ip_dspm,ip_kbend,ip_kbrd
/* QL:         xref    io_qin,io_qtest */
/* QL:         xref    sd_cure */
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
/* QL:         include 'win1_m_inc_ch' */
/* QL: * channel definition block / driver headers */
/* QL:         nolist */
/* QL: * channel definition header for all channels */
/* QL:         offset  0 */
/* QL: ch_len  ds.l    1       length of definition block */
.equ ch_len,0
/* QL: ch_drivr ds.l   1       address of driver */
.equ ch_drivr,4
/* QL: ch_owner ds.l   1       owner job */
.equ ch_owner,8
/* QL: ch_rflag ds.l   1       address to be set when space released */
.equ ch_rflag,12
/* QL: ch_tag  ds.w    1       channel tag */
.equ ch_tag,16
/* QL: ch_stat ds.b    1       status: 0 ok, else waiting -1 a1 abs, $80 a1 rel a6 */
.equ ch_stat,18
/* QL: ch_actn ds.b    1       stored action for waiting job */
.equ ch_actn,19
/* QL: ch_jobwt ds.l   1       ID of job waiting on I/O */
.equ ch_jobwt,20
/* QL: ch_end */
.equ ch_end,24
/* QL: * extended channel definition for plain serial queues */
/* QL: ch_qin  ds.l    1       pointer to input queue (or zero) */
.equ ch_qin,24
/* QL: ch_qout ds.l    1       pointer to output queue (or zero) */
.equ ch_qout,28
/* QL: ch_qend */
.equ ch_qend,32
/* QL: * device driver header */
/* QL:         offset  0 */
/* QL: ch_next ds.l    1       pointer to next driver */
.equ ch_next,0
/* QL: ch_inout ds.l   1       entry for input and output */
.equ ch_inout,4
/* QL: ch_open ds.l    1       entry for open */
.equ ch_open,8
/* QL: ch_close ds.l   1       entry for close */
.equ ch_close,12
/* QL: * the following are for directory devices (file system) only: */
/* QL: ch_slave ds.l   1       entry for slaving blocks */
.equ ch_slave,16
/* QL: ch_renam ds.l   1       entry reserved for rename */
.equ ch_renam,20
/* QL:         ds.l    1 */
/* QL: ch_formt ds.l   1       entry for format medium */
.equ ch_formt,28
/* QL: ch_dflen ds.l   1       length of physical definition block */
.equ ch_dflen,32
/* QL: ch_drnam ds.w   1       length prefixed drive name */
.equ ch_drnam,36
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
/* QL:         include 'win1_m_inc_jb' */
/* QL: * job header and save area definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: jb_len  ds.l    1       length of job segment */
.equ jb_len,0
/* QL: jb_start ds.l   1       start address */
.equ jb_start,4
/* QL: jb_owner ds.l   1       owner of this job */
.equ jb_owner,8
/* QL: jb_hold ds.l    1       ptr to byte to be clr when job released */
.equ jb_hold,12
/* QL: jb_tag  ds.w    1       tag for this job */
.equ jb_tag,16
/* QL: jb_prior ds.b   1       current accumulated priority */
.equ jb_prior,18
/* QL: jb_princ ds.b   1       priority increment, if =0 job inactive */
.equ jb_princ,19
/* QL: jb_stat ds.w    1       job status: */
.equ jb_stat,20
/* QL: *               0 potentially active, >0 delay time (frames), <0 suspended */
/* QL: jb_rela6 ds.b   1       bit 7: next trap #2/3 is rel a6, bit 6: interpreter */
.equ jb_rela6,22
/* QL: jb_wflag ds.b   1       set if there is a job waiting on completion */
.equ jb_wflag,23
/* QL: jb_wjob ds.l    1       job id of waiting job */
.equ jb_wjob,24
/* QL: jb_trapv ds.l   1       pointer to trap redirection vectors */
.equ jb_trapv,28
/* QL: jb_d0   ds.l    8       saved d0-d7 */
.equ jb_d0,32
/* QL: jb_a0   ds.l    8       saved a0-a7 */
.equ jb_a0,64
/* QL: jb_sr   ds.w    1       saved sr */
.equ jb_sr,96
/* QL: jb_pc   ds.l    1       saved pc */
.equ jb_pc,98
/* QL:         ds.w    1       spare */
/* QL: jb_end */
.equ jb_end,104
/* QL:         list */
/* QL:         include 'win1_m_inc_mc' */
/* QL: * master chip registers */
/* QL:         nolist */
/* QL: mc_stat equ     $18063  status register address */
.equ mc_stat,0x18063
/* QL: *               bit     clear   set */
/* QL: mc..blnk equ    1       normal  blank   if set, the rest are irrelevant! */
.equ mc..blnk,1
/* QL: mc..m256 equ    3       512/4   256/8   pixels per line / colours per pixel */
.equ mc..m256,3
/* QL: mc..ntsc equ    6       PAL625  NTSC495 scan lines (512/384 displayed) */
.equ mc..ntsc,6
/* QL: mc..scrn equ    7       $20000  $28000  screen base address (scr0/scr1) */
.equ mc..scrn,7
/* QL:         list */
/* QL:         include 'win1_m_inc_q' */
/* QL: * io queue header definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: q_eoff ; end of file flag (msbit) */
.equ q_eoff,0
/* QL: q_nextq ds.l    1       link to next queue */
.equ q_nextq,0
/* QL: q_end   ds.l    1       pointer to end of queue */
.equ q_end,4
/* QL: q_nextin ds.l   1       pointer to next location to put byte in */
.equ q_nextin,8
/* QL: q_nxtout ds.l   1       pointer to next location to take byte from */
.equ q_nxtout,12
/* QL: q_queue ; start of queue */
.equ q_queue,16
/* QL:         list */
/* QL:         include 'win1_m_inc_sd' */
/* QL: * window data block definition */
/* QL:         nolist */
/* QL:         offset  $18 (end of basic channel definition) */
/* QL: sd_xmin ds.w    1       window left pixel, exclusive of border */
.equ sd_xmin,24
/* QL: sd_ymin ds.w    1       ditto top pixel */
.equ sd_ymin,26
/* QL: sd_xsize ds.w   1       window width, exclusive of border */
.equ sd_xsize,28
/* QL: sd_ysize ds.w   1       ditto height */
.equ sd_ysize,30
/* QL: sd_borwd ds.w   1       border height, border width is double this */
.equ sd_borwd,32
/* QL: sd_xpos ds.w    1       cursor position relative to left pixel above */
.equ sd_xpos,34
/* QL: sd_ypos ds.w    1       ditto top pixel */
.equ sd_ypos,36
/* QL: sd_xinc ds.w    1       cursor pixel width */
.equ sd_xinc,38
/* QL: sd_yinc ds.w    1       cursor pixel height */
.equ sd_yinc,40
/* QL: * note: the x values above should be even when in mode 8. */
/* QL: sd_font ds.l    2       font addresses, primary first. def char in secondary */
.equ sd_font,42
/* QL: sd_scrb ds.l    1       base address of screen */
.equ sd_scrb,50
/* QL: sd_pmask ds.l   1       paper colour mask */
.equ sd_pmask,54
/* QL: sd_smask ds.l   1       strip colour mask */
.equ sd_smask,58
/* QL: sd_imask ds.l   1       ink colour mask */
.equ sd_imask,62
/* QL: sd_cattr ds.b   1       character attributes (see below for bits) */
.equ sd_cattr,66
/* QL: sd_curf ds.b    1       cursor flag (0 suppressed, >0 visible, <0 invisible) */
.equ sd_curf,67
/* QL: sd_pcolr ds.b   1       paper colour byte */
.equ sd_pcolr,68
/* QL: sd_scolr ds.b   1       strip colour byte */
.equ sd_scolr,69
/* QL: sd_icolr ds.b   1       ink colour byte */
.equ sd_icolr,70
/* QL: sd_bcolr ds.b   1       border colour byte */
.equ sd_bcolr,71
/* QL: sd_nlsta ds.b   1       new line status (0 none, >0 implicit, <0 explicit) */
.equ sd_nlsta,72
/* QL: sd_fmod ds.b    1       fill mode (0 off, 1 on) */
.equ sd_fmod,73
/* QL: sd_yorg ds.w    3       graphics window origin (added to y coords) (float) */
.equ sd_yorg,74
/* QL: sd_xorg ds.w    3       ditto for x */
.equ sd_xorg,80
/* QL: sd_scal ds.w    3       graphics scale factor (from bottom row to top row) */
.equ sd_scal,86
/* QL: sd_fbuf ds.l    1       pointer to alchp'ed fill buffer, 0 if none */
.equ sd_fbuf,92
/* QL: sd_fuse ds.l    1       pointer to user defined fill vectors, not used */
.equ sd_fuse,96
/* QL: sd_linel ds.w   1       line length in bytes */
.equ sd_linel,100
/* QL: sd_flags ds.b   1       cleared by 1st time entry to driver (edlin needs this) */
.equ sd_flags,102
/* QL:         ds.b    1       spare */
/* QL: sd_end */
.equ sd_end,104
/* QL: * character attribute flag bits for sd_cattr */
/* QL: sd..ulin equ    0       underline (row 9, or the lowest row, is all ink) */
.equ sd..ulin,0
/* QL: sd..flsh equ    1       flash (ignored in mode 4) */
.equ sd..flsh,1
/* QL: sd..trns equ    2       transparent background (only character area is touched) */
.equ sd..trns,2
/* QL: sd..xor equ     3       xor characters/graphics (char/pixel colour xor'ed in) */
.equ sd..xor,3
/* QL: sd..dbht equ    4       double height (chars spread in y) */
.equ sd..dbht,4
/* QL: sd..exwd equ    5       extended width (8 bits used from char font entries) */
.equ sd..exwd,5
/* QL: sd..dbwd equ    6       double width (chars spread in x, mode 8 sets this) */
.equ sd..dbwd,6
/* QL: sd..gchr equ    7       graphics positioned chars (offscreen ignored until nl) */
.equ sd..gchr,7
/* QL: * screen entry parameter definition */
/* QL: sd.extop equ    $09     external operation (a2) */
.equ sd.extop,0x09
/* QL: sd.pxenq equ    $0a     pixel based size / position enquiry */
.equ sd.pxenq,0x0a
/* QL: sd.chenq equ    $0b     character based size / position enquiry */
.equ sd.chenq,0x0b
/* QL: sd.bordr equ    $0c     define window border */
.equ sd.bordr,0x0c
/* QL: sd.wdef equ     $0d     define window */
.equ sd.wdef,0x0d
/* QL: sd.cure equ     $0e     enable cursor */
.equ sd.cure,0x0e
/* QL: sd.curs equ     $0f     suppress cursor */
.equ sd.curs,0x0f
/* QL: sd.pos  equ     $10     absolute position */
.equ sd.pos,0x10
/* QL: sd.tab  equ     $11     tab (horizontal position) */
.equ sd.tab,0x11
/* QL: sd.nl   equ     $12     newline */
.equ sd.nl,0x12
/* QL: sd.pcol equ     $13     previous column */
.equ sd.pcol,0x13
/* QL: sd.ncol equ     $14     next column */
.equ sd.ncol,0x14
/* QL: sd.prow equ     $15     previous row */
.equ sd.prow,0x15
/* QL: sd.nrow equ     $16     next row */
.equ sd.nrow,0x16
/* QL: sd.pixp equ     $17     set pixel position */
.equ sd.pixp,0x17
/* QL: sd.scrol equ    $18     scroll whole window */
.equ sd.scrol,0x18
/* QL: sd.scrtp equ    $19     scroll top of window */
.equ sd.scrtp,0x19
/* QL: sd.scrbt equ    $1a     scroll bottom of window */
.equ sd.scrbt,0x1a
/* QL: sd.pan  equ     $1b     pan window */
.equ sd.pan,0x1b
/* QL: * ?     equ     $1c */
/* QL: * ?     equ     $1d */
/* QL: sd.panln equ    $1e     pan cursor line */
.equ sd.panln,0x1e
/* QL: sd.panrt equ    $1f     pan rhs of cursor line */
.equ sd.panrt,0x1f
/* QL: sd.clear equ    $20     clear whole window */
.equ sd.clear,0x20
/* QL: sd.clrtp equ    $21     clear top of window */
.equ sd.clrtp,0x21
/* QL: sd.clrbt equ    $22     clear bottom of window */
.equ sd.clrbt,0x22
/* QL: sd.clrln equ    $23     clear cursor line */
.equ sd.clrln,0x23
/* QL: sd.clrrt equ    $24     clear to right of cursor */
.equ sd.clrrt,0x24
/* QL: sd.fount equ    $25     set fount addresses */
.equ sd.fount,0x25
/* QL: sd.recol equ    $26     recolour a window */
.equ sd.recol,0x26
/* QL: sd.setpa equ    $27     set paper colour */
.equ sd.setpa,0x27
/* QL: sd.setst equ    $28     set strip colour */
.equ sd.setst,0x28
/* QL: sd.setin equ    $29     set ink colour */
.equ sd.setin,0x29
/* QL: sd.setfl equ    $2a     set flash on/off */
.equ sd.setfl,0x2a
/* QL: sd.setul equ    $2b     set underline on/off */
.equ sd.setul,0x2b
/* QL: sd.setmd equ    $2c     set write mode */
.equ sd.setmd,0x2c
/* QL: sd.setsz equ    $2d     set character size */
.equ sd.setsz,0x2d
/* QL: sd.fill equ     $2e     fill block */
.equ sd.fill,0x2e
/* QL: sd.donl equ     $2f     do pending newline */
.equ sd.donl,0x2f
/* QL: sd.point equ    $30     set point in window */
.equ sd.point,0x30
/* QL: sd.line equ     $31     draw line */
.equ sd.line,0x31
/* QL: sd.arc  equ     $32     draw arc */
.equ sd.arc,0x32
/* QL: sd.elips equ    $33     draw ellipse */
.equ sd.elips,0x33
/* QL: sd.scale equ    $34     set graphics scale */
.equ sd.scale,0x34
/* QL: sd.flood equ    $35     set fill mode/vectors */
.equ sd.flood,0x35
/* QL: sd.gcur equ     $36     set text cursor using graphics coords */
.equ sd.gcur,0x36
/* QL: * $6c..$74 $76..$77 $7a..$7f (at least) are used by the pointer interface */
/* QL:         list */
/* QL:         include 'win1_m_inc_sv' */
/* QL: * system variable definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sv_ident ds.w   1       identification word */
.equ sv_ident,0
/* QL:         ds.w    1       spare */
/* QL: sv_cheap ds.l   1       base of common heap area */
.equ sv_cheap,4
/* QL: sv_chpfr ds.l   1       first free space in common heap area */
.equ sv_chpfr,8
/* QL: sv_free ds.l    1       base of free area */
.equ sv_free,12
/* QL: sv_basic ds.l   1       base of basic area */
.equ sv_basic,16
/* QL: sv_trnsp ds.l   1       base of transient program area */
.equ sv_trnsp,20
/* QL: sv_trnfr ds.l   1       first free space in transient program area */
.equ sv_trnfr,24
/* QL: sv_respr ds.l   1       base of resident procedure area */
.equ sv_respr,28
/* QL: sv_ramt ds.l    1       top of ram (+1) */
.equ sv_ramt,32
/* QL:         ds.w    5       spare */
/* QL: sv_rand ds.w    1       random number */
.equ sv_rand,46
/* QL: sv_pollm ds.w   1       count of poll interupts missed */
.equ sv_pollm,48
/* QL: sv_tvmod ds.b   1       0 if not tv display */
.equ sv_tvmod,50
/* QL: sv_scrst ds.b   1       screen status (0 = active) */
.equ sv_scrst,51
/* QL: sv_mcsta ds.b   1       display mode of current job 0/8 mode4/mode8 */
.equ sv_mcsta,52
/* QL: sv_pcint ds.b   1       current value of pc interrupt register */
.equ sv_pcint,53
/* QL:         ds.b    1       spare */
/* QL: sv_netnr ds.b   1       network station number */
.equ sv_netnr,55
/* QL: sv_i2lst ds.l   1       pointer to list of interrupt 2 drivers */
.equ sv_i2lst,56
/* QL: sv_plist ds.l   1       pointer to list of polled tasks */
.equ sv_plist,60
/* QL: sv_shlst ds.l   1       pointer to list of scheduler tasks */
.equ sv_shlst,64
/* QL: sv_drlst ds.l   1       pointer to list of device drivers */
.equ sv_drlst,68
/* QL: sv_ddlst ds.l   1       pointer to list of directory device drivers */
.equ sv_ddlst,72
/* QL: sv_keyq ds.l    1       pointer to a keyboard queue */
.equ sv_keyq,76
/* QL: sv_trapv ds.l   1       pointer to the trap redirection table */
.equ sv_trapv,80
/* QL: * Pointers to the resource management tables */
/* QL: * The slave block tables have 8 byte entries, the others 4 byte entries */
/* QL: sv_btpnt ds.l   1       pointer to most recent slave block entry */
.equ sv_btpnt,84
/* QL: sv_btbas ds.l   1       pointer to base of slave block table */
.equ sv_btbas,88
/* QL: sv_bttop ds.l   1       pointer to top of slave block table */
.equ sv_bttop,92
/* QL: sv_jbtag ds.w   1       current value of job tag */
.equ sv_jbtag,96
/* QL: sv_jbmax ds.w   1       highest current job number */
.equ sv_jbmax,98
/* QL: sv_jbpnt ds.l   1       pointer to current job table entry */
.equ sv_jbpnt,100
/* QL: sv_jbbas ds.l   1       pointer to base of job table */
.equ sv_jbbas,104
/* QL: sv_jbtop ds.l   1       pointer to top of job table */
.equ sv_jbtop,108
/* QL: sv_chtag ds.w   1       current value of channel tag */
.equ sv_chtag,112
/* QL: sv_chmax ds.w   1       highest current channel number */
.equ sv_chmax,114
/* QL: sv_chpnt ds.l   1       pointer to last channel checked */
.equ sv_chpnt,116
/* QL: sv_chbas ds.l   1       pointer to base of channel table */
.equ sv_chbas,120
/* QL: sv_chtop ds.l   1       pointer to top of channel table, and extended sysvars */
.equ sv_chtop,124
/* QL: sv_frbl ds.l    1       interrupt level release memory linked list (sms2) */
.equ sv_frbl,128
/* QL:         ds.b    1       spare */
/* QL:         ds.b    1       set to $ff by ptrgen if this is a ql! */
/* QL:         ds.w    1       spare */
/* QL: sv_caps ds.b    1       caps lock 0=off $ff=on */
.equ sv_caps,136
/* QL:         ds.b    1       but people may overwrite as above was defined as w! */
/* QL: sv_arbuf ds.w   1       autorepeat buffer */
.equ sv_arbuf,138
/* QL: sv_ardel ds.w   1       autorepeat delay */
.equ sv_ardel,140
/* QL: sv_arfrq ds.w   1       autorepeat 1/freq */
.equ sv_arfrq,142
/* QL: sv_arcnt ds.w   1       autorepeat count */
.equ sv_arcnt,144
/* QL: sv_cqch ds.w    1       keyboard change queue character code (can be + alt!) */
.equ sv_cqch,146
/* QL: sv_wp   ds.w    1       microdrive write protect (1st byte) ipc p26 input */
.equ sv_wp,148
/* QL: sv_sound ds.w   1       sound status (only 1st byte used?) */
.equ sv_sound,150
/* QL: sv_ser1c ds.l   1       receive  channel 1 queue address */
.equ sv_ser1c,152
/* QL: sv_ser2c ds.l   1       receive  channel 2 queue address */
.equ sv_ser2c,156
/* QL: sv_tmode ds.b   1       ZX8302 transmit mode (includes last baud rate) */
.equ sv_tmode,160
/* QL:         ds.b    1       spare */
/* QL: sv_csub ds.l    1       subroutine to jump to on capslock (only reach + 32767!) */
.equ sv_csub,162
/* QL: sv_timo ds.w    1       timeout for switching transmit mode */
.equ sv_timo,166
/* QL: sv_timov ds.w   1       ser1/2 control bytes: 7=lost 6=frame 3=inhib 2..0=baud */
.equ sv_timov,168
/* QL: sv_fstat ds.w   1       flashing cursor count (silly if > about 16!) */
.equ sv_fstat,170
/* QL: sv_progd ds.l   1       to $60 byte extension, old progd string + qlib_use */
.equ sv_progd,172
/* QL: sv_datad ds.l   1       to data default string, this -$24 = new progd */
.equ sv_datad,176
/* QL: sv_destd ds.l   1       to dest default string, this is above + $24 */
.equ sv_destd,180
/* QL: sv_thing ds.l   1       thing list */
.equ sv_thing,184
/* QL:         ds.w    25      spare */
/* QL: sv_mdrun ds.b   1       which drive is running? */
.equ sv_mdrun,238
/* QL: sv_mdcnt ds.b   1       microdrive run-up run-down counter */
.equ sv_mdcnt,239
/* QL: sv_mddid ds.b   8       drive id*4 of each microdrive */
.equ sv_mddid,240
/* QL: sv_mdsta ds.b   8       status, 0 = no pending ops */
.equ sv_mdsta,248
/* QL: sv_fsdef ds.l   16      pointers to file system physical definition */
.equ sv_fsdef,256
/* QL: sv_fslst ds.l   1       pointer to list of file channel definitions */
.equ sv_fslst,320
/* QL: sv_tran ds.b    1       key translation off(0) or on(1) */
.equ sv_tran,324
/* QL: sv_ichar ds.b   1       compose char workspace */
.equ sv_ichar,325
/* QL: sv_trtab ds.l   1       pointer to key translation tables */
.equ sv_trtab,326
/* QL: sv_mgtab ds.l   1       pointer to message table */
.equ sv_mgtab,330
/* QL: daytab   equ    $1c     err. for names of days */
.equ daytab,0x1c
/* QL: montab   equ    $1d    err. names of months */
.equ montab,0x1d
/* QL:         ds.w    3 */
/* QL: sv_turb1 ds.l   1       used by turbo */
.equ sv_turb1,340
/* QL: sv_turb2 ds.l   1 */
.equ sv_turb2,344
/* QL: sv_turb3 ds.w   1       length of file name!!!! */
.equ sv_turb3,348
/* QL: sv_turb4 ds.b   32      actually uses up to 41 bytes for file name!!!!!! */
.equ sv_turb4,350
/* QL: * taskmaster uses $154 l*4 */
/* QL: sv_stacb ds.l   192     bottom of stack */
.equ sv_stacb,382
/* QL: sv_stact ; big stack - no check */
.equ sv_stact,1150
/* QL: sv_trapo equ 2*($28+2) offset of trap vector table from (sv_trapv) */
.equ sv_trapo,(2*(0x28+2))
/* QL: sv.ident equ $d254 green, red, blue and black, with flash bits */
.equ sv.ident,0xd254
/* QL: * device driver definitions (for the driver's own pseudo system vars) */
/* QL:         offset  0 */
/* QL: sv_lxint ds.l   1       link to next external interrupt service */
.equ sv_lxint,0
/* QL: sv_axint ds.l   1       address of external interrupt service */
.equ sv_axint,4
/* QL: sv_lpoll ds.l   1       link to next polling interrupt service */
.equ sv_lpoll,8
/* QL: sv_apoll ds.l   1       address of polling interrupt service */
.equ sv_apoll,12
/* QL: sv_lschd ds.l   1       link to next scheduler task */
.equ sv_lschd,16
/* QL: sv_aschd ds.l   1       address of scheduler task */
.equ sv_aschd,20
/* QL: sv_lio  ds.l    1       link to next io driver */
.equ sv_lio,24
/* QL: sv_aio  ds.l    1       address of input/output routine */
.equ sv_aio,28
/* QL: sv_aopen ds.l   1       address of channel open routine */
.equ sv_aopen,32
/* QL: sv_aclos ds.l   1       address of channel close routine */
.equ sv_aclos,36
/* QL:         list */
/* QL:         include 'win1_m_inc_sx' */
/* QL: * system variables extension */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sx_case ds.l    1       non-zero = user rtn on ctrl/alt/shift/enter (c/a/s/e?) */
.equ sx_case,0
/* QL: sx_itran ds.l   1       input tranlation routine */
.equ sx_itran,4
/* QL: sx_otran ds.l   1       output translation routine */
.equ sx_otran,8
/* QL: sx_driv ds.l    1       mm_rechp is memory management driver, close entry point */
.equ sx_driv,12
/* QL: sx_kbenc ds.l   1       keyboard encoder routine */
.equ sx_kbenc,16
/* QL: sx_ipcom ds.l   1       linked list to front end mt.ipcom calls */
.equ sx_ipcom,20
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL: sx_trn  ds.l    1       default i/o translation table address */
.equ sx_trn,32
/* QL: sx_msg  ds.l    1       default message table address */
.equ sx_msg,36
/* QL: sx_f0   ds.l    1       default primary font */
.equ sx_f0,40
/* QL: sx_f1   ds.l    1       default secondary font */
.equ sx_f1,44
/* QL: sx_dspm ds.b    1       real display mode settings (dual screen) */
.equ sx_dspm,48
/* QL: sx_toe  ds.b    1       turn off ehancements: */
.equ sx_toe,49
/* QL:                 ; bit 7 set, allow format + files open */
/* QL:                 ; bit 1 set, treat -ve mt.baud as error (non-hermes) */
/* QL: sx_event ds.b   1       events: bit 4 = ctrl/space, 5=+alt, 6=+shift, 7=+both */
.equ sx_event,50
/* QL: sx_fstat ds.b   1       cursor flash rate, size and colour rrrrsccc */
.equ sx_fstat,51
/* QL: sx_kbste ds.b   12      special key remap table */
.equ sx_kbste,52
/* QL: sx_qdos ds.l    1       returned by mt.inf, ver$(-2) */
.equ sx_qdos,64
/* QL: sx_basic ds.w   1+4/2   length prefixed string returned by ver$, ver$(0) */
.equ sx_basic,68
/* QL:         ds.w    2       spare/reserved */
/* QL:         ds.b    1       21kxs10w   21: ser21 data pend, k: key held, x: shift */
/* QL:                         ; change while key held, s: sound in progress, 1: 1, */
/* QL:                         ; 0: zero Hermes, old IPC showed ser being zapped, */
/* QL:                         ; w: p26 (write protect) (experimental byte!) */
/* QL:         ds.b    1       spare/reserved */
/* QL: * initial ram based linkages */
/* QL:         ds.l    2       0 ip_poll */
/* QL:         ds.l    6       base+$60 sd_sched base+$68 ip_sched 0 io_scan */
/* QL:         ds.l    4       base+$80 od_serio od_serop od_sercl */
/* QL: sx_pipb ds.l    4       base+$90 io_serq  od_pipop od_pipcl */
.equ sx_pipb,128
/* QL: sx_con  ds.l    4       base+$a0 od_conio od_conop od_concl */
.equ sx_con,144
/* QL:         ds.l    4       0 od_netio od_netop od_netcl */
/* QL:         ds.l    8       0 dd_mdvio dd_mdvop dd_mdvcl md_slave 0 0 md_formt */
/* QL:         ds.b    4+2+3   md_end 3 'mdv' */
/* QL:         ds.b    3       spare bit */
/* QL: sx_pipc ds.l    1       pipe driver link word */
.equ sx_pipc,220
/* QL: * end of system extension */
/* QL:         list */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section ip_kbrd */
.section ip_kbrd,"ax"
/* QL: * Main keyboard read routine. Can be called by replacement keyboard code. */
/* QL: * d1 -i  - keyrow data in 6 lsb */
/* QL: * d2 -i  - ctrl/shift/alt in 3 lsb */
/* QL: * a2 -ip - current keyboard queue address */
/* QL: * d0/d6/a0-a1/a3-a4 destroyed */
/* QL: ip_kbrd */
ip_kbrd:
/* QL:         clr.w   sv_arbuf(a6)    get rid of previous auto repeat */
    clr.w sv_arbuf(a6)
/* QL:         move.l  sv_chtop(a6),a4 get sysvar extension */
    move.l sv_chtop(a6),a4
/* QL:         move.l  sx_kbenc(a4),a3 get encoder address */
    move.l sx_kbenc(a4),a3
/* QL:         jsr     (a3)            call encoder via vector table */
    jsr (a3)
/* QL:         bra.s   special         special processing return */
    bra.s special
/* QL:         bra.s   kb_inch         put it into the queue */
    bra.s kb_inch
/* QL:         rts                     ignore char return */
    rts 
/* QL: * Routine to finish off keyboard read and handle auto-repeat. */
/* QL: * d3 -ip - number of polls missed */
/* QL: * d5 -i  - bit 4 set if last key is held down */
/* QL: * a2 -ip - current keyboard queue */
/* QL: * d0-d2/a3 destroyed */
/* QL: ip_kbend */
ip_kbend:
/* QL:         asr.b   #4,d5           see if the key is still held down */
    asr.b #4,d5
/* QL:         bcc.s   autorld         if not, reload the counter and get out */
    bcc.s autorld
/* QL:         sub.w   d3,sv_arcnt(a6) step counter by the number of polls */
    sub.w d3,sv_arcnt(a6)
/* QL:         bgt.s   rts0            if it hasn't timed out yet */
    bgt.s rts0
/* QL:         jsr     io_qtest(pc)    is the queue empty? */
    jsr io_qtest(pc)
/* QL:         beq.s   shortd          no, so don't allow autorepeat */
    beq.s shortd
/* QL:         move.w  sv_arbuf(a6),d1 retrieve char to be repeated */
    move.w sv_arbuf(a6),d1
/* QL:         beq.s   shortd          nothing */
    beq.s shortd
/* QL:         bsr.s   kb_inch         put it into the queue */
    bsr.s kb_inch
/* QL: shortd */
shortd:
/* QL:         move.w  sv_arfrq(a6),sv_arcnt(a6) reload with the shorter delay */
    move.w sv_arfrq(a6),sv_arcnt(a6)
/* QL:         rts */
    rts 
/* QL: * Special processing routines */
/* QL: spent   macro   t */
/* QL: sptab */
sptab:
/* QL: *                       ctrl/space              event 4 = break job 0 */
/* QL: *                       ctrl/alt/space          event 5 = break multi */
/* QL: *                       shift/ctrl/space        event 6 = user event 0 */
/* QL: *                       shift/ctrl/alt/space    event 7 = user event 1 */
/* QL:         spent   ctlt    ctrl/tab                alternate screen */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_922:
.byte (((ctlt-spend)&0x7fffffff))&255
/* QL:         spent   frez    ctrl/alt/tab            toggle display freeze */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_926:
.byte (((frez-spend)&0x7fffffff))&255
/* QL:         spent   rts0    shift/ctrl/tab          reserve... easy to key! */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_930:
.byte (((rts0-spend)&0x7fffffff))&255
/* QL:         spent   soft    shift/ctrl/alt/tab      soft reset */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_934:
.byte (((soft-spend)&0x7fffffff))&255
/* QL:         spent   comp    ctrl/enter              compose */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_938:
.byte (((comp-spend)&0x7fffffff))&255
/* QL:         spent   ctlc    ctrl/alt/enter          cursor to next queue */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_942:
.byte (((ctlc-spend)&0x7fffffff))&255
/* QL:         spent   caps    shift/ctrl/enter        caps lock */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_946:
.byte (((caps-spend)&0x7fffffff))&255
/* QL:         spent   user    shift/ctrl/alt/enter    call user subroutine */
/* QL: [.lab]  dc.b    (([t])-spend)&$7fffffff */
dc_anchor_950:
.byte (((user-spend)&0x7fffffff))&255
/* QL: special */
special:
/* QL:         subq.b  #4,d1 */
    subq.b #4,d1
/* QL:         bpl.s   usetab */
    bpl.s usetab
/* QL:         bchg    d1,sx_event(a4) */
    bchg d1,sx_event(a4)
/* QL:         rts */
    rts 
/* QL: usetab */
usetab:
/* QL:         move.b  sptab(pc,d1.w),d1 */
    move.b sptab(pc,d1.w),d1
/* QL:         jmp     spend(pc,d1.w) */
.word 0x4efb
.word 4096|((spend-.)&255)
/* QL: * Put a char in the queue */
/* QL: kb_inch */
kb_inch:
/* QL:         cmp.w   sv_cqch(a6),d1 */
    cmp.w sv_cqch(a6),d1
/* QL:         beq.s   ctlc */
    beq.s ctlc
/* QL:         sf      sv_scrst(a6)    unfreeze screen */
    sf sv_scrst(a6)
/* QL:         move.w  d1,sv_arbuf(a6) store char in the autorepeat buffer */
    move.w d1,sv_arbuf(a6)
/* QL:         cmp.b   #255,d1         is it a two-byte code? */
    cmp.b #(255&255),d1
/* QL:         bne.s   in1 */
    bne.s in1
/* QL:         jsr     io_qtest(pc)    how many bytes are left? (nb only d1.b zapped) */
    jsr io_qtest(pc)
/* QL:         subq.w  #2,d2           are they enough? */
    subq.w #2,d2
/* QL:         blt.s   autorld         no, don't put the character in */
    blt.s autorld
/* QL:         st      d1              reset the alt code */
    st d1
/* QL:         bsr.s   in1             put the escape in the queue */
    bsr.s in1
/* QL:         lsr.w   #8,d1           get the second code */
    lsr.w #8,d1
/* QL: in1 */
in1:
/* QL:         jsr     io_qin(pc)      put it in the queue and return */
    jsr io_qin(pc)
/* QL: autorld */
autorld:
/* QL:         move.w  sv_ardel(a6),sv_arcnt(a6) reload the auto-rept counter */
    move.w sv_ardel(a6),sv_arcnt(a6)
/* QL:         rts */
    rts 
/* QL: frez */
frez:
/* QL:         not.b   sv_scrst(a6)    toggle freeze flag */
    not.b sv_scrst(a6)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: caps */
caps:
/* QL:         not.b   sv_caps(a6)     toggle caps lock flag byte */
    not.b sv_caps(a6)
/* QL:         lea     sv_csub(a6),a4  get capslock user routine address */
    lea sv_csub(a6),a4
/* QL: isprog */
isprog:
/* QL:         tst.l   (a4)            is there some code there? */
    tst.l (a4)
/* QL:         beq.s   rts0            no - not a good idea to call it... */
    beq.s rts0
/* QL:         jmp     (a4)            yes, call it and get out */
    jmp (a4)
/* QL: * N.B. changed above to use a4 instead of a5, which wasn't saved! */
/* QL: comp */
comp:
/* QL:         addq.b  #1,sv_ichar(a6) set compose start */
    addq.b #1,sv_ichar(a6)
/* QL:         rts */
    rts 
/* QL: user */
user:
/* QL: spend   equ     user-31 */
.equ spend,(user-31)
/* QL:         assert  0,sx_case */
/* original assertion: 0,sx_case */
/* QL:         move.l  (a4),d0         get user code routine address */
    move.l (a4),d0
/* QL:         bpl.s   rts0            no flag (bit 31), so no call */
    bpl.s rts0
/* QL:         bclr    d1,d0           don't let msb propagate into pc */
    bclr d1,d0
/* QL:         move.l  d0,a4           if it was set up the way we want (negative) ... */
    move.l d0,a4
/* QL:         bra.s   isprog          ... check there's some code before calling it */
    bra.s isprog
/* QL: ctlt */
ctlt:
/* QL:         bsr.s   ip_dspm         ensure sx_dspm is up to date */
    bsr.s ip_dspm
/* QL:         bchg    #7,sx_dspm(a4)  toggle displayed screen */
    bchg #7,sx_dspm(a4)
/* QL:         move.b  sx_dspm(a4),d0  pick up new value */
    move.b sx_dspm(a4),d0
/* QL:         bmi.s   ctlt1           top bit set, use screen 1 */
    bmi.s ctlt1
/* QL:         add.b   d0,d0           shift for screen 0 */
    add.b d0,d0
/* QL: ctlt1 */
ctlt1:
/* QL:         and.b   #1<<mc..blnk+1<<mc..m256+1<<mc..scrn,d0 */
    and.b #((((1<<mc..blnk)+(1<<mc..m256))+(1<<mc..scrn))&255),d0
/* QL:         move.b  d0,mc_stat      set hardware only */
    move.b d0,mc_stat
/* QL:         rts */
    rts 
/* QL: soft */
soft:
/* QL:         moveq   #9,d1 */
    moveq #9,d1
/* QL:         jmp     390             soft reset, quick */
    jmp 390
/* QL: ctlc */
ctlc:
/* QL:         move.l  a0,-(sp)        save a0 */
    move.l a0,-(sp)
/* QL:         lea     -sd_end(a2),a0  find start of io definition block */
    lea (-sd_end)(a2),a0
/* QL:         tst.b   sd_curf(a0)     should cursor in old wdw be visible? */
    tst.b sd_curf(a0)
/* QL:         bge.s   switch_q */
    bge.s switch_q
/* QL:         jsr     sd_cure(pc)     ensure cursor in old window is visible */
    jsr sd_cure(pc)
/* QL:         lea     sd_end(a0),a2   restore a2 */
    lea sd_end(a0),a2
/* QL: switch_q */
switch_q:
/* QL:         assert  q_nextq,0 */
/* original assertion: q_nextq,0 */
/* QL:         move.l  (a2),a2         switch to next queue */
    move.l (a2),a2
/* QL:         cmp.l   sv_keyq(a6),a2  is this the original queue? */
    cmp.l sv_keyq(a6),a2
/* QL:         beq.s   end_swit */
    beq.s end_swit
/* QL:         tst.b   sd_curf-sd_end(a2) is this cursor active? */
    tst.b (sd_curf-sd_end)(a2)
/* QL:         beq.s   switch_q        no... */
    beq.s switch_q
/* QL:         move.l  a2,sv_keyq(a6)  set new key queue pointer */
    move.l a2,sv_keyq(a6)
/* QL:         clr.w   sv_fstat(a6)    reset cursor flash cycle */
    clr.w sv_fstat(a6)
/* QL: end_swit */
end_swit:
/* QL:         move.l  sd_scrb-sd_end(a2),d1 have a look at the screen base here */
    move.l (sd_scrb-sd_end)(a2),d1
/* QL:         add.w   d1,d1           does it end with $0000 or $8000? */
    add.w d1,d1
/* QL:         bne.s   offscr          no - forget it */
    bne.s offscr
/* QL:         roxr.b  #1,d1 */
    roxr.b #1,d1
/* QL:         add.b   sv_mcsta(a6),d1 are we already on the indicated screen? */
    add.b sv_mcsta(a6),d1
/* QL:         bpl.s   offscr          yes - forget it */
    bpl.s offscr
/* QL:         swap    d1 */
    swap d1
/* QL:         subq.b  #2,d1           is it $xx020000 or $xx028000? */
    subq.b #2,d1
/* QL:         bne.s   offscr          no - forget it */
    bne.s offscr
/* QL:         bsr.s   ctlt            switch over to that screen */
    bsr.s ctlt
/* QL:         move.b  d0,sv_mcsta(a6) and say that's what we're on */
    move.b d0,sv_mcsta(a6)
/* QL: offscr */
offscr:
/* QL:         move.l  (sp)+,a0        restore a0 */
    move.l (sp)+,a0
/* QL:         rts */
    rts 
/* QL: * A routine to copy sv_mcsta bits into sx_dspm in case someone poked it! */
/* QL: * a4 -  o- sysvar extension base */
/* QL: * d0-d1 destroyed */
/* QL: ip_dspm */
ip_dspm:
/* QL:         moveq   #1<<mc..blnk+1<<mc..m256,d1 */
    moveq #((1<<mc..blnk)+(1<<mc..m256)),d1
/* QL:         move.b  sv_mcsta(a6),d0 */
    move.b sv_mcsta(a6),d0
/* QL:         bmi.s   setscr1 */
    bmi.s setscr1
/* QL:         lsr.b   #1,d0 */
    lsr.b #1,d0
/* QL:         moveq   #(1<<mc..blnk+1<<mc..m256)>>1,d1 */
    moveq #(((1<<mc..blnk)+(1<<mc..m256))>>1),d1
/* QL: setscr1 */
setscr1:
/* QL:         and.b   d1,d0 */
    and.b d1,d0
/* QL:         not.b   d1 */
    not.b d1
/* QL:         move.l  sv_chtop(a6),a4 get sysvar extension */
    move.l sv_chtop(a6),a4
/* QL:         and.b   d1,sx_dspm(a4) */
    and.b d1,sx_dspm(a4)
/* QL:         or.b    d0,sx_dspm(a4) */
    or.b d0,sx_dspm(a4)
/* QL:         rts */
    rts 
/* QL:         vect4000 ip_kbend,ip_kbrd */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl ip$kbend
/* QL: [o]     equ     [h]-$4000 */
.equ ip$kbend,(ip_kbend-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl ip$kbrd
/* QL: [o]     equ     [h]-$4000 */
.equ ip$kbrd,(ip_kbrd-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
