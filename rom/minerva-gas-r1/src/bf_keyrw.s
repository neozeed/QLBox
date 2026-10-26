/* Generated from original/M/bf/keyrw.asm */
/* QL: * Basic KEYROW function */
/* QL:         xdef    bf_keyrw,bf_ipcom */
.globl bf_keyrw,bf_ipcom
/* QL:         xref    ca_gtin1 */
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
/* QL:         section bf_keyrw */
.section bf_keyrw,"ax"
/* QL: bf_keyrw */
bf_keyrw:
/* QL:         jsr     ca_gtin1(pc)    get integer params */
    jsr ca_gtin1(pc)
/* QL:         bne.s   rts0            propagate any error */
    bne.s rts0
/* QL:         move.w  #2,-(sp)        8 bit result */
    move.w #2,-(sp)
/* QL:         move.b  d1,(sp)         the parameter */
    move.b d1,(sp)
/* QL:         clr.l   -(sp)           4 bits long */
    clr.l -(sp)
/* QL:         move.w  #kbdr_cmd<<8!1,-(sp) read kbd matrix command + 1 param */
    move.w #((kbdr_cmd<<8)|1),-(sp)
/* QL: frame   equ     1+1+4+1+1 */
.equ frame,((((1+1)+4)+1)+1)
/* QL:         lea     keyrw,a2 */
    lea keyrw(pc),a2
/* QL:         moveq   #mt.extop,d0 */
    moveq #mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         addq.l  #frame,sp       release local stack space */
    addq.l #frame,sp
/* QL:         move.w  d1,0(a6,a1.l)   put result on arithmetic stack */
    move.w d1,0(a6,a1.l)
/* QL:         moveq   #3,d4           result type is integer */
    moveq #3,d4
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: keyrw */
keyrw:
/* QL:         move.l  d0,a2           system variables base address */
    move.l d0,a2
/* QL:         move.l  sv_keyq(a2),a2  get current keyboard queue */
    move.l sv_keyq(a2),a2
/* QL:         move.l  q_nxtout(a2),q_nextin(a2) remove all characters from queue */
    move.l q_nxtout(a2),q_nextin(a2)
/* QL: * Entry point to execute ipcom on user stack - called via mt.extop */
/* QL: bf_ipcom */
bf_ipcom:
/* QL:         moveq   #mt.ipcom,d0 */
    moveq #mt.ipcom,d0
/* QL:         move.l  usp,a3          command on user stack */
    move.l usp,a3
/* QL:         trap    #1 */
    trap #1
/* QL:         rte */
    rte 
/* QL:         end */
