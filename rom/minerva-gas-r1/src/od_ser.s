/* Generated from original/M/od/ser.asm */
/* QL: * Serial port driver */
/* QL:         xdef    od_ser */
.globl od_ser
/* QL:         xref    io_name,io_qin,io_qout,io_qset,io_qtest,io_relio */
/* QL:         xref    mm_alchp */
/* QL:         xref    ip_adcmd */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
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
/* QL:         include 'win1_m_inc_ser' */
/* QL: * serial i/o definitions */
/* QL:         nolist */
/* QL: ser_rxql equ    81      length of receive buffer (odd!) */
.equ ser_rxql,81
/* QL: ser_txql equ    81      length of transmit buffer (odd!) */
.equ ser_txql,81
/* QL: * channel definition block */
/* QL:         offset  $18 (end of basic channel definition) */
/* QL: ser_chno ds.w   1       channel number (1 or 2) */
.equ ser_chno,24
/* QL: ser_par ds.w    1       parity requirement */
.equ ser_par,26
/* QL: ser_txhs ds.w   1       transmit handshake flag */
.equ ser_txhs,28
/* QL: ser_prot ds.w   1       protocol, +ve cr/lf, 0 ctrlz, -ve raw */
.equ ser_prot,30
/* QL: ser_rxq ds.b    q_queue+ser_rxql+1      receive queue */
.equ ser_rxq,32
/* QL: ser_txq ds.b    q_queue+ser_txql+1      transmit queue header */
.equ ser_txq,130
/* QL: ser_end ; total memory required */
.equ ser_end,228
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
/* QL: * Notes by lwr: */
/* QL: * This has all been shuffled about quite a bit, in an attempt to get toward */
/* QL: * properly functioning serial channels. The current version still suffers from */
/* QL: * some problems. */
/* QL: * The main problem is that handshaking can only be actioned at the stage of */
/* QL: * actually sending bytes to the IPC. Swapping between 'seri' and 'serh' opens */
/* QL: * will not get this right. However, this seems to be the least of evils, as one */
/* QL: * will usually be changing the harware plugged into the port in these cases. */
/* QL: * All other handling is done here, including making the close do generation of */
/* QL: * ctrl/z if required. */
/* QL: * The serial queues now contain only raw data to/from the serial ports. */
/* QL: * The action of "serc" is now treated as an exchange of cr/lf values. */
/* QL: * The I/O translation routines now occur between parity/handshake and protocol */
/* QL: * (cr<-->lf and ctrl/z) handling. */
/* QL: * The only user translation that is difficult/impossible at the moment is the */
/* QL: * one-to-many conversion of data coming from the serial queue. */
/* QL: * The current sequence of operation goes like this: */
/* QL: * sbyte/close -> lf/cr/cz -> user -> parity_gen -> queue -> handshake -> ipc */
/* QL: * ipc(handshake) -> queue -> parity_check -> user -> cr/lf/cz -> fbyte */
/* QL:         section od_ser */
.section od_ser,"ax"
/* QL: * The rules for the user routines  */
/* QL: od_ser */
od_ser:
/* QL:         dc.w    io-* */
.balign 2,0
dc_anchor_495:
.word ((io-dc_anchor_495))&65535
/* QL:         dc.w    open-* */
.balign 2,0
dc_anchor_499:
.word ((open-dc_anchor_499))&65535
/* QL:         dc.w    close-* */
.balign 2,0
dc_anchor_503:
.word ((close-dc_anchor_503))&65535
/* QL: io */
io:
/* QL:         jsr     io_relio(pc)    use standard relative serial i/o */
    jsr io_relio(pc)
/* QL:         dc.w    pend-* */
.balign 2,0
dc_anchor_511:
.word ((pend-dc_anchor_511))&65535
/* QL:         dc.w    fbyte-* */
.balign 2,0
dc_anchor_515:
.word ((fbyte-dc_anchor_515))&65535
/* QL:         dc.w    sbyte-* */
.balign 2,0
dc_anchor_519:
.word ((sbyte-dc_anchor_519))&65535
/* QL: * Open a serial i/o channel. */
/* QL: * The name is structured as "ser{1|2}{o|e|m|s}{i|h}{r|z|c} */
/* QL: *       port number (1 or 2, default 1) */
/* QL: *       parity (0=8 bit, 1=odd, 2=even, 3=mark, 4=space) */
/* QL: *       use/ignore transmit handshake signals (0=ignore, other(default)=use) */
/* QL: *       protocol >0 <cr/lf>, 0=ctrlz, <0=raw (default raw) */
/* QL: open */
open:
/* QL:         subq.l  #2*4,sp         make room for parameters */
    subq.l #(2*4),sp
/* QL:         move.l  sp,a3           point a3 to them */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     decode the name */
    jsr io_name(pc)
/* QL:         bra.s   opn_pop         not ser */
    bra.s opn_pop
/* QL:         bra.s   opn_pop         bad parameter */
    bra.s opn_pop
/* QL:         bra.s   opn_ser         ok */
    bra.s opn_ser
/* QL:         dc.w    3,'SER',4,-1,1,4,'OEMS',2,'IH',3,'RZC' */
.balign 2,0
dc_anchor_543:
.word 3
.byte 83,69,82
.balign 2,0
.word 4
.word ((-1))&65535
.word 1
.word 4
.byte 79,69,77,83
.balign 2,0
.word 2
.byte 73,72
.balign 2,0
.word 3
.byte 82,90,67
.balign 2,0
/* QL: opn_pop */
opn_pop:
/* QL:         addq.l  #2*4,sp         discard parameter area */
    addq.l #(2*4),sp
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: opn_ser */
opn_ser:
/* QL:         movem.w (sp)+,d4-d7     get parameters */
    movem.w (sp)+,d4-d7
/* QL:         subq.w  #1,d6           adjust handshake */
    subq.w #1,d6
/* QL:         subq.w  #2,d7           adjust protocol */
    subq.w #2,d7
/* QL:         moveq   #err.nf,d0 */
    moveq #err.nf,d0
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         lea     sv_ser1c(a6),a5 set address of ser1 queue pointer */
    lea sv_ser1c(a6),a5
/* QL:         subq.w  #1,d1 */
    subq.w #1,d1
/* QL:         beq.s   chk_inus */
    beq.s chk_inus
/* QL:         addq.l  #sv_ser2c-sv_ser1c,a5 change to ser2 queue pointer */
.word 20621|((((sv_ser2c-sv_ser1c))&7)<<9)
/* QL:         subq.w  #1,d1 */
    subq.w #1,d1
/* QL:         bne.s   rts0            only support ser1 or ser2 */
    bne.s rts0
/* QL: chk_inus */
chk_inus:
/* QL:         move    sr,-(sp)        save interrupt status */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        disable interrupts to enable reopen */
    or.w #0x700,sr
/* QL:         move.l  (a5),d0         is a serial channel already allocated */
    move.l (a5),d0
/* QL:         beq.s   alloc           no - go allocate it */
    beq.s alloc
/* QL:         move.l  d0,a2           start of receive queue */
    move.l d0,a2
/* QL:         lea     -ser_rxq(a2),a0 start of definition */
    lea (-ser_rxq)(a2),a0
/* QL:         moveq   #err.iu,d0 */
    moveq #err.iu,d0
/* QL:         assert  0,q_eoff,q_nextq */
/* original assertion: 0,q_eoff,q_nextq */
/* QL:         bclr    #7,ser_txq(a0)  was transmit eofed? (but it isn't now) */
    bclr #7,ser_txq(a0)
/* QL:         beq.s   popsr           no - that's no good, someone's got it open! */
    beq.s popsr
/* QL: *        clr.l   (a2)            clear q_eoff (and q_nextq?) for receive queue */
/* QL: * N.B. We'll leave the receive queue pointers alone, as there may well be */
/* QL: * input buffered up there waiting for us. (lwr) */
/* QL:         bra.s   set_parms */
    bra.s set_parms
/* QL: * Allocate definition block and set up queues */
/* QL: alloc */
alloc:
/* QL:         move.w  #ser_end,d1     number of bytes needed (n.b. d1 msw is zero) */
    move.w #ser_end,d1
/* QL:         jsr     mm_alchp(pc)    allocate space */
    jsr mm_alchp(pc)
/* QL:         bne.s   popsr           sorry... */
    bne.s popsr
/* QL:         lea     ser_txq(a0),a2  set start of transmit queue */
    lea ser_txq(a0),a2
/* QL:         moveq   #ser_txql,d1    set queue length */
    moveq #ser_txql,d1
/* QL:         jsr     io_qset(pc)     set up the transmit queue */
    jsr io_qset(pc)
/* QL:         lea     ser_rxq(a0),a2  set start of receive queue */
    lea ser_rxq(a0),a2
/* QL:         assert  ser_rxql,ser_txql */
/* original assertion: ser_rxql,ser_txql */
/* QL:         jsr     io_qset(pc)     set up the receive queue */
    jsr io_qset(pc)
/* QL:         move.l  a2,(a5)         tell physical layer where new receive queue is */
    move.l a2,(a5)
/* QL: * Store the parameters */
/* QL: set_parms */
set_parms:
/* QL:         assert  ser_chno,ser_par-2,ser_txhs-4,ser_prot-6 */
/* original assertion: ser_chno,ser_par-2,ser_txhs-4,ser_prot-6 */
/* QL:         movem.w d4-d7,ser_chno(a0) put them all */
    movem.w d4-d7,ser_chno(a0)
/* QL:         moveq   #ops1_cmd-1-32,d1 */
    moveq #((ops1_cmd-1)-32),d1
/* QL: * Tell the IPC what's going on */
/* QL: do_com */
do_com:
/* QL:         assert  ops1_cmd,ops2_cmd-1 */
/* original assertion: ops1_cmd,ops2_cmd-1 */
/* QL:         assert  cls1_cmd,cls2_cmd-1 */
/* original assertion: cls1_cmd,cls2_cmd-1 */
/* QL:         add.w   ser_chno(a0),d1 */
    add.w ser_chno(a0),d1
/* QL:         move.l  a0,a2           save channel base */
    move.l a0,a2
/* QL:         move.l  d6,d2           just for close, adhere to rule: d6 preserved */
    move.l d6,d2
/* QL:         jsr     ip_adcmd(pc)    do ipc command */
    jsr ip_adcmd(pc)
/* QL:         move.l  d2,d6 */
    move.l d2,d6
/* QL:         move.l  a2,a0           restore channel base */
    move.l a2,a0
/* QL:         moveq   #0,d0           set return code */
    moveq #0,d0
/* QL: popsr */
popsr:
/* QL:         move    (sp)+,sr        n.b. rte is no good on a 68020, etc */
    move (sp)+,sr
/* QL:         rts */
    rts 
/* QL: * Close a serial channel. */
/* QL: * The channel structure is not discarded here, as there may be further data */
/* QL: * pending in the transmit queue. This deserves more thought! (lwr) */
/* QL: close */
close:
/* QL:         tst.b   ser_prot+1(a0)  is it ctrl/z or crlf protocol? */
    tst.b (ser_prot+1)(a0)
/* QL:         bmi.s   cl_czok         nope - no ctrl/z needed */
    bmi.s cl_czok
/* QL: cl_czlp */
cl_czlp:
/* QL:         moveq   #'z'&31,d1      we need to put ctrl/z onto the queue */
    moveq #(122&31),d1
/* QL:         bsr.s   sbyte           try to put out the ctrl/z */
    bsr.s sbyte
/* QL:         addq.l  #-err.nc,d0     is it not complete? */
.word 20608|((((-err.nc))&7)<<9)
/* QL:         beq.s   cl_czlp         hopefully, we will eventually get there! */
    beq.s cl_czlp
/* QL: * The above loop is not wildly satisfactory, as it can be held up indefinately */
/* QL: * by a "serh" channel with the handshake holding off output permanently. */
/* QL: * The original technique relied on outputting the ctrl/z when the IPC had */
/* QL: * emptied the queue, but this was prone to the syndrome of changing */
/* QL: * protocols before the code had actioned the protocol. E.g. sending a series */
/* QL: * of small ctrl/z files, then changing to "serr" would not send any ctrl/z's! */
/* QL: * An alternative scheme to avoid the handshake problems suffers from the same */
/* QL: * flaw as the above. This would be to use a special byte in the output queue */
/* QL: * as an "escape" character. A preferred value would be a zero byte. The output */
/* QL: * would then double up single nulls when they were real, say, and restore them */
/* QL: * in the input routine. Other byte values after a null would be used to pass */
/* QL: * open/close parameters down. */
/* QL: cl_czok */
cl_czok:
/* QL:         move    sr,-(sp) */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        be cautious - make sure no mishaps! (lwr) */
    or.w #0x700,sr
/* QL:         tas     ser_txq+q_eoff(a0) ok, so we know how to set end of file! */
    tas (ser_txq+q_eoff)(a0)
/* QL: *        lea     ser_txq(a0),a2  set end of file */
/* QL: *        jsr     io_qeof(pc)     mark queue as end of file */
/* QL:         moveq   #cls1_cmd-1-32,d1 */
    moveq #((cls1_cmd-1)-32),d1
/* QL:         bra.s   do_com */
    bra.s do_com
/* QL: * Come here to test if the serial port has input pending */
/* QL: pend */
pend:
/* QL:         lea     ser_rxq(a0),a2  get queue address */
    lea ser_rxq(a0),a2
/* QL:         jmp     io_qtest(pc)    see if queue is empty */
    jmp io_qtest(pc)
/* QL: * Read a character from a serial port. */
/* QL: * The code that stuffed the bytes into the queue is in the ipc routines. */
/* QL: * This routine takes a byte out of the specified queue, and checks any parity. */
/* QL: * An optional user routine may then be used to convert the byte. This can */
/* QL: * discard unwanted bytes by setting d0=err.nc and skipping its return address. */
/* QL: * Many-to-one conversions may be acheived by retaining context. One-to-many */
/* QL: * conversions are currently difficult/impossible! */
/* QL: * The cr/lf and ctrl/z requirement are actioned last. */
/* QL: fbyte */
fbyte:
/* QL:         lea     ser_rxq(a0),a2  get address of queue */
    lea ser_rxq(a0),a2
/* QL:         jsr     io_qout(pc)     take out a byte */
    jsr io_qout(pc)
/* QL:         bne.s   rts1            there isn't one... */
    bne.s rts1
/* QL:         move.b  ser_par+1(a0),d2 get parity requirements */
    move.b (ser_par+1)(a0),d2
/* QL:         beq.s   rx_pok          no parity required - go check next bit */
    beq.s rx_pok
/* QL:         subq.b  #2,d2           odd=-1 even=0 mark=1 space=2 */
    subq.b #2,d2
/* QL:         bhi.s   rx_plus         mark/space - go check it */
    bhi.s rx_plus
/* QL:         moveq   #127,d0         don't include the top bit */
    moveq #127,d0
/* QL:         and.b   d1,d0 */
    and.b d1,d0
/* QL: rx_shft */
rx_shft:
/* QL:         eor.b   d0,d2           flip lsb of parity reg for one bit */
    eor.b d0,d2
/* QL:         lsr.b   #1,d0           shift next bit */
    lsr.b #1,d0
/* QL:         bne.s   rx_shft         loop until all non-zero bits done */
    bne.s rx_shft
/* QL: rx_plus */
rx_plus:
/* QL:         lsl.b   #7,d2           move type bit to msb */
    lsl.b #7,d2
/* QL:         eor.b   d2,d1           flip top bit of data byte */
    eor.b d2,d1
/* QL:         bmi.s   err_te          now set - go report error */
    bmi.s err_te
/* QL: rx_pok */
rx_pok:
/* QL:         moveq   #sx_itran,d2    appropriate translation routine offset */
    moveq #sx_itran,d2
/* QL:         bsr.s   extrn           go see about it */
    bsr.s extrn
/* QL:         tst.b   ser_prot+1(a0)  is it ctrl/z or cr/lf protocol? */
    tst.b (ser_prot+1)(a0)
/* QL:         blt.s   ok_rts          no - we're finished */
    blt.s ok_rts
/* QL:         beq.s   rx_cz           zero, just do ctrl/z check */
    beq.s rx_cz
/* QL:         bsr.s   cr_proto        handle cr/lf exchange */
    bsr.s cr_proto
/* QL: rx_cz */
rx_cz:
/* QL:         moveq   #err.ef,d0 */
    moveq #err.ef,d0
/* QL:         cmp.b   #'z'&31,d1      is it ctrl/z? */
    cmp.b #((122&31)&255),d1
/* QL:         beq.s   rts1 */
    beq.s rts1
/* QL: ok_rts */
ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: cr_proto */
cr_proto:
/* QL:         moveq   #13,d0 */
    moveq #13,d0
/* QL:         sub.b   d1,d0           is it cr? */
    sub.b d1,d0
/* QL:         beq.s   rx_cr           yes, flip it */
    beq.s rx_cr
/* QL:         subq.b  #13-10,d0       is it lf? */
.word 20736|((((13-10))&7)<<9)
/* QL:         bne.s   rts1            no, return now */
    bne.s rts1
/* QL:         addq.b  #2*3,d1 */
    addq.b #(2*3),d1
/* QL: rx_cr */
rx_cr:
/* QL:         subq.b  #3,d1           cr <--> lf */
    subq.b #3,d1
/* QL:         rts */
    rts 
/* QL: err_te */
err_te:
/* QL:         moveq   #err.te,d0      transmission error (and -ve for proto return) */
    moveq #err.te,d0
/* QL:         rts */
    rts 
/* QL: * sx_itrn: input translation routine: */
/* QL: * d1 -i o- byte after parity action / byte to be cr/lf/cz processed */
/* QL: * a0 -ip - base of serial channel definition */
/* QL: * a2 -i  - base of serial input queue */
/* QL: * d0/d2-d3/a1/a3 destroyed. */
/* QL: * d1 should be used to supply bytes to the caller. */
/* QL: * Skipping the return address and setting d0 to err.nc will cause the input */
/* QL: * byte to be discarded. (d1 may be destroyed). */
/* QL: * Only one-to-none and one-to-one conversions are convenient. */
/* QL: * sx_otrn: output translation routine: */
/* QL: * d1 -i o- byte after cr/lf/cz action / byte to be parity processed */
/* QL: * a0 -ip - base of serial channel definition */
/* QL: * a2 -i  - base of serial output queue */
/* QL: * d0/d2-d3/a1/a3 destroyed. */
/* QL: * If the value in d1 is not to be sent, an appropriate value should be set in */
/* QL: * d0 (err.nc normally) and the return address skipped. */
/* QL: * A one-to-many translation must verify that the queue has space, by calling */
/* QL: * io_qtest through the vector at $de, and if there is insufficient space, */
/* QL: * set err.nc in d0 and skip the return address. */
/* QL: * If the space is ok, the return address should be "jsr"ed to for all but the */
/* QL: * last byte, leaving that to go as normal. */
/* QL: * Only one-to-none, one-to-one and one-to-many conversions are convenient. */
/* QL: * If the return address mentioned above is used, it requires the following: */
/* QL: * d0 -  o- 0 (or error - queue full (err.nc) - should never happen!) */
/* QL: * d1 -i o- byte to put in queue (output with parity actioned) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * d2/a3 destroyed */
/* QL: extrn */
extrn:
/* QL:         tst.b   sv_tran(a6)     check if translation wanted */
    tst.b sv_tran(a6)
/* QL:         beq.s   rts1            no, leave it alone */
    beq.s rts1
/* QL:         move.l  sv_chtop(a6),a3 dig into system extension */
    move.l sv_chtop(a6),a3
/* QL:         move.l  0(a3,d2.l),a3   come out with current translate routine addr */
    move.l 0(a3,d2.l),a3
/* QL:         jmp     (a3)            call via vector */
    jmp (a3)
/* QL: * Write a character to a serial port. */
/* QL: * This actions lf<->cr conversions first. */
/* QL: * An optional user routine may then handle the character. */
/* QL: * The byte is then stuffed in the output queue with appropriate parity. */
/* QL: sbyte */
sbyte:
/* QL:         lea     ser_txq(a0),a2  transmit queue address */
    lea ser_txq(a0),a2
/* QL:         tst.b   ser_prot+1(a0)  is it ctrl/z or cr/lf protocol? */
    tst.b (ser_prot+1)(a0)
/* QL:         ble.s   tx_nop          no - we're finished */
    ble.s tx_nop
/* QL:         bsr.s   cr_proto        handle cr/lf exchange */
    bsr.s cr_proto
/* QL: tx_nop */
tx_nop:
/* QL:         moveq   #sx_otran,d2    the appropriate user routine slot */
    moveq #sx_otran,d2
/* QL:         bsr.s   extrn           go do translate, if enabled */
    bsr.s extrn
/* QL: * N.B. The remainder of this section may be "jsr"ed to by the user routine. */
/* QL:         move.b  ser_par+1(a0),d2 get parity requirements */
    move.b (ser_par+1)(a0),d2
/* QL:         beq.s   tx_pok          no parity, send it as is */
    beq.s tx_pok
/* QL:         add.b   d1,d1           lose current msb of byte */
    add.b d1,d1
/* QL:         lsl.b   #6,d2           odd=$40, even=$80, mark=$c0, space=$00 */
    lsl.b #6,d2
/* QL:         add.b   d2,d2           odd/mark=$80, even/space=$00 */
    add.b d2,d2
/* QL:         bvc.s   tx_par          mark/space - go put in the top bit */
    bvc.s tx_par
/* QL:         move.b  d1,d0           make copy of remaining 7 bits of byte */
    move.b d1,d0
/* QL: tx_shft */
tx_shft:
/* QL:         eor.b   d0,d2           flip msb of parity reg for one bit */
    eor.b d0,d2
/* QL:         add.b   d0,d0           shift up next bit */
    add.b d0,d0
/* QL:         bne.s   tx_shft         loop until all non-zero bits done */
    bne.s tx_shft
/* QL: tx_par */
tx_par:
/* QL:         add.b   d2,d2           move parity bit into x */
    add.b d2,d2
/* QL:         roxr.b  #1,d1           put it into the byte */
    roxr.b #1,d1
/* QL: tx_pok */
tx_pok:
/* QL:         jmp     io_qin(pc)      stuff byte into queue */
    jmp io_qin(pc)
/* QL:         end */
