/* Generated from original/M/ss/init.asm */
/* QL: * System initialisation after RAM test */
/* QL:         xdef    ss_init */
.globl ss_init
/* QL:         xref    mt_cj0 */
/* QL:         xref    md_desel */
/* QL:         xref    sb_start */
/* QL:         xref    ss_jtag,ss_list,ss_rj0 */
/* QL: *****        xref.l res_code */
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
/* QL:         include 'win1_m_inc_bt' */
/* QL: * memory block table definitions */
/* QL:         nolist */
/* QL: * memory block table entries */
/* QL:         offset  0 */
/* QL: bt_stat ds.b    1       drive id / status byte - see below */
.equ bt_stat,0
/* QL: bt_prior ds.b   1       block priority */
.equ bt_prior,1
/* QL: bt_sectr ds.w   1       sector number (microdrive*2) */
.equ bt_sectr,2
/* QL: bt_filnr ds.w   1       file number (microdrive)   } logical */
.equ bt_filnr,4
/* QL: bt_block ds.w   1       block number (microdrive)  } location */
.equ bt_block,6
/* QL: bt_end */
.equ bt_end,8
/* QL: * bits of status codes */
/* QL: bt..file equ    0       set if a file block */
.equ bt..file,0
/* QL: bt..accs equ    1       set if contents may be accessed */
.equ bt..accs,1
/* QL: bt..wreq equ    2       set if block required to be written */
.equ bt..wreq,2
/* QL: bt..rdvr equ    3       set if block required to be read / verified */
.equ bt..rdvr,3
/* QL: * The most significant 4 bits of the status byte contain the pointer to the */
/* QL: * physical device block sv_fsdef, the least significant are the status codes: */
/* QL: bt.unav equ     0                       unavailable to file system */
.equ bt.unav,0
/* QL: bt.empty equ    1<<bt..file             empty */
.equ bt.empty,(1<<bt..file)
/* QL: bt.rreq equ     bt.empty!1<<bt..rdvr    required to be read */
.equ bt.rreq,(bt.empty|(1<<bt..rdvr))
/* QL: bt.true equ     bt.empty!1<<bt..accs    true representation of file */
.equ bt.true,(bt.empty|(1<<bt..accs))
/* QL: bt.aver equ     bt.true!1<<bt..rdvr     awaiting verify */
.equ bt.aver,(bt.true|(1<<bt..rdvr))
/* QL: bt.updt equ     bt.true!1<<bt..wreq     updated */
.equ bt.updt,(bt.true|(1<<bt..wreq))
/* QL: * status code masks */
/* QL: bt.actn equ     1<<bt..rdvr!1<<bt..wreq check for read or write request */
.equ bt.actn,((1<<bt..rdvr)|(1<<bt..wreq))
/* QL: bt.inuse equ    bt.actn!1<<bt..accs     check if a file block in use */
.equ bt.inuse,(bt.actn|(1<<bt..accs))
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
/* QL:         include 'win1_m_inc_pc' */
/* QL: * PC peripheral chip (zx8302 ic23) registers */
/* QL:         nolist */
/* QL: * The peripheral chip is selected by addresses in the range $18000 to $1bfff. */
/* QL: * The hardware does not decode bits 13-7 and 4-2 of addresses, so the following */
/* QL: * are actually the minimum addresses that perform the given functions. */
/* QL: * On some older ql's, bit 6 is also not decoded, but later m/c's distinguish */
/* QL: * the mc_stat register by decoding it as having bit 6 set. */
/* QL: * It could be unwise to assume that bits 13-7 can be anything but zero. */
/* QL: * It would be novel to redefine the $1800x versions by adding $1c, thus making */
/* QL: * the whole set more conveniently addressable. */
/* QL: * read addresses */
/* QL: pc_clock equ    $18000  real time clock in seconds (long word) */
.equ pc_clock,0x18000
/* QL: pc_ipcrd equ    $18020  IPC read address */
.equ pc_ipcrd,0x18020
/* QL: pc_intr equ     $18021  bits 4..0 set as pending level 2 interrupts */
.equ pc_intr,0x18021
/* QL: pc_trak1 equ    $18022  microdrive read track1 */
.equ pc_trak1,0x18022
/* QL: pc_trak2 equ    $18023  microdrive read track2 */
.equ pc_trak2,0x18023
/* QL: * write addresses */
/* QL: *pc_clc0 equ    $18000  writing anything here resets the clock */
/* QL: *pc_clc1 equ    $18001  clock selected bytes of time */
/* QL: pc_tctrl equ    $18002  transmit control */
.equ pc_tctrl,0x18002
/* QL: pc_ipcwr equ    $18003  IPC write address */
.equ pc_ipcwr,0x18003
/* QL: pc_mctrl equ    $18020  microdrive/link control register */
.equ pc_mctrl,0x18020
/* QL: *pc_intr equ    $18021  7..5 masks and 4..0 to clear interrupt */
/* QL: pc_tdata equ    $18022  transmit register */
.equ pc_tdata,0x18022
/* QL: *mc_stat equ    $18023  on some ql's this controls the video display. */
/* QL: *************** pc_clock function: */
/* QL: * Reading the longword at pc_clock gets the current time. */
/* QL: * Writing anything to pc_clock resets the clock to zero. */
/* QL: * Bytes written to pc_clock+1 increment selected bytes of the current time as */
/* QL: * follows: a zero in bit 4 will increment the msb (to be read back from */
/* QL: * pc_clock) and subsequently a zero in bits 3, 2 and 1 will increment the bytes */
/* QL: * of lesser significance. Bits 7-5 and 0 are not significant. */
/* QL: * Clock setting, etc, could be speeded up by writing combinations of zero bits, */
/* QL: * but there is strange management of carries which make it far too awkward. */
/* QL: * As soon as the sign bit of a byte is set, the next more significant byte can */
/* QL: * no longer be incremented directly, only by propagation of carry. */
/* QL: * On a crash, there is a chance that there may be rubbish written to memory, */
/* QL: * and, what with the lack of decode as well, the clock often gets messed up. */
/* QL: * It gets reset to one of $0w0x0y0z, where w/x/y/z are small, typically 0. */
/* QL: *************** pc_tctrl transmit control register values */
/* QL: * The values set in bits 4..3 of the transmit control register select the */
/* QL: * device to which data written to pc_tdata applies. */
/* QL: * At boot, zero is written here. A zero was also written to pc_tdata, but this */
/* QL: * has been removed. It had the effect of sending a spurious null to the ser1 */
/* QL: * port, which should not have been done. */
/* QL: pc..diro equ    7       direct output (e.g. to network) */
.equ pc..diro,7
/* QL: *   ?    equ    6       0 */
/* QL: *   ?    equ    5       0 */
/* QL: pc..serb equ    4       0=serial io */
.equ pc..serb,4
/* QL: pc..sern equ    3       serial port number */
.equ pc..sern,3
/* QL: *baud2  equ     2       \ */
/* QL: *baud1  equ     1        > three bit baud rate */
/* QL: *baud0  equ     0       / */
/* QL: pc.bmask equ    %00000111       baud rate mask */
.equ pc.bmask,0b00000111
/* QL: pc.notmd equ    %11100111       all bits except mode control */
.equ pc.notmd,0b11100111
/* QL: pc.mdvmd equ    %00010000       microdrive mode */
.equ pc.mdvmd,0b00010000
/* QL: pc.netmd equ    %00011000       network mode */
.equ pc.netmd,0b00011000
/* QL: *************** pc_ipcwr is used to send serial commands and data to IPC. */
/* QL: * The pattern %000011x0 is written here (with x always 1 when serial data is */
/* QL: * supposed to be being fetched), then bit 6 of pc_ipcrd is examined, waiting */
/* QL: * for it to go to zero, indicating that the data bit has been received by the */
/* QL: * IPC and/or that a return bit is ready in bit 7 of pc_ipcrd. */
/* QL: * Nibbles and bytes are sent most significant bit first. */
/* QL: * The sound control function has two 16 bit parameters and, in uncharacteristic */
/* QL: * fashion, these need their least significant byte to be sent first. */
/* QL: * At boot time, %00000001 is written here. at a guess, one of bits 0, 2 or 4 is */
/* QL: * used as a flag "data bit awaiting transmission". */
/* QL: * Note that the PC and the IPC are only connected by two wires, comctl and */
/* QL: * comdata, and the protocol on these is pretty obscure! */
/* QL: *   ?   equ     7       0 */
/* QL: *   ?   equ     6       0 */
/* QL: *   ?   equ     5       0 */
/* QL: *   ?   equ     4       0 */
/* QL: *   ?   equ     3       1 */
/* QL: *   ?   equ     2       1 */
/* QL: *   ?   equ     1       data bit for IPC (comctl/wr  */
/* QL: *   ?   equ     0       0 */
/* QL: *************** pc_ipcrd and pc_mctrl read. */
/* QL: * This returns miscellaneous data bits appertaining to the IPC link, serial */
/* QL: * output control, microdrives and the network. */
/* QL: *   ?   equ     7       data bit from IPC */
/* QL: *   ?   equ     6       set when bit 7 is OK and IPC is ready to receive */
/* QL: pc..cts2 equ    5       CTS on port 2 (set if ser2 transmit held up) */
.equ pc..cts2,5
/* QL: pc..dtr1 equ    4       DTR on port 1 (set if ser1 transmit held up) */
.equ pc..dtr1,4
/* QL: pc..gap  equ    3       gap: set normally, or gap is present on running mdv */
.equ pc..gap,3
/* QL: pc..rxrd equ    2       microdrive read buffer ready */
.equ pc..rxrd,2
/* QL: pc..txfl equ    1       xmit buffer full (mdv or ser) */
.equ pc..txfl,1
/* QL: *   ?    equ    0       network input bit. 1 if active. (netin) */
/* QL: *************** pc_mctrl microdrive control write register */
/* QL: * Selecting a drive is done by clocking a bit along the chain of drives. */
/* QL: * pc..sel is set on the first byte sent and clear on as many more as are */
/* QL: * needed to get to the right drive number. */
/* QL: * Clocking through eight bytes with pc..sel clear selects "mdv9_", or rather, */
/* QL: * as the ql only permits "mdv1_" to "mdv8_", deselects all. */
/* QL: * Anyone who connects more than six external drives will get a shock when the */
/* QL: * seventh one keeps getting selected! */
/* QL: * The clocking is done by pc..sclk transitioning from set to clear, and the */
/* QL: * hardware is expected to be able to manage with one transition each 25us. */
/* QL: * At boot, %0110 was written here, immediately followed by deselecting. */
/* QL: * now just the deselection is done. */
/* QL: *  ?    equ     7 */
/* QL: *  ?    equ     6 */
/* QL: *  ?    equ     5 */
/* QL: *  ?    equ     4 */
/* QL: pc..eras equ    3       microdrive erase */
.equ pc..eras,3
/* QL: pc..writ equ    2       microdrive write */
.equ pc..writ,2
/* QL: pc..sclk equ    1       microdrive select clock bit */
.equ pc..sclk,1
/* QL: pc..sel equ     0       microdrive select bit */
.equ pc..sel,0
/* QL: pc.read equ     1<<pc..sclk             read (or idle) microdrive */
.equ pc.read,(1<<pc..sclk)
/* QL: pc.selec equ    pc.read!1<<pc..sel      select bit set */
.equ pc.selec,(pc.read|(1<<pc..sel))
/* QL: pc.desel equ    pc.read                 select bit not set */
.equ pc.desel,pc.read
/* QL: pc.erase equ    pc.read!1<<pc..eras     erase on / write off */
.equ pc.erase,(pc.read|(1<<pc..eras))
/* QL: pc.write equ    pc.erase!1<<pc..writ    erase and write */
.equ pc.write,(pc.erase|(1<<pc..writ))
/* QL: *************** pc_intr is read to supply the current set of pending */
/* QL: * interrupts, and is written to clear them and/or enable some of them. */
/* QL: * sv_intr holds the current setting and is managed carefully, on a bit basis. */
/* QL: * The three msbs must be set to enable their corresponding interrupts. */
/* QL: * On read, bit 7 is the baud rate clock, pulsing up and down once per bit. */
/* QL: * Bit 6 is normally set, but is clear while an mdv is running. dunno why... */
/* QL: * Bit 5 is the lsb of 1/65536ths of a second, i.e. straight x2 crystal. */
/* QL: * The five lsbs are set on read to indicate which interrupts are pending and */
/* QL: * writing a set bit will clear such an interrupt once it has been serviced. */
/* QL: * At boot, $1f is written here twice, then $c0 is put in sv_intr to start off */
/* QL: * with transmit and IPC interrupts enabled. */
/* QL: * The second write of $1f, one gathers, is because a bug in the h/w sometmes */
/* QL: * causes the first one to fail. */
/* QL: * The IPC interface interrupt deserves a mention. It was useless, and was */
/* QL: * ignored on Minerva until v1.94. Then Hermes finally got it right, and uses it */
/* QL: * to signal serial input buffer data ready (every 8 bytes). */
/* QL: * It actually also happens whenever data transfer goes on between the CPU and */
/* QL: * the IPC, which could be a problem for people who do not use mt.ipcom, but */
/* QL: * all internal routines clear this interrupt before returning. */
/* QL: pc.maskt equ    1<<7    transmit mask register */
.equ pc.maskt,(1<<7)
/* QL: pc.maski equ    1<<6    interface mask register */
.equ pc.maski,(1<<6)
/* QL: pc.maskg equ    1<<5    gap mask register */
.equ pc.maskg,(1<<5)
/* QL: pc.intre equ    1<<4    external interrupt register */
.equ pc.intre,(1<<4)
/* QL: pc.intrf equ    1<<3    frame interrupt register */
.equ pc.intrf,(1<<3)
/* QL: pc.intrt equ    1<<2    transmit interrupt register */
.equ pc.intrt,(1<<2)
/* QL: pc.intri equ    1<<1    interface interrupt register */
.equ pc.intri,(1<<1)
/* QL: pc.intrg equ    1<<0    gap interrupt register */
.equ pc.intrg,(1<<0)
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: * Define sizes of table entries, etc */
/* QL: jtb     equ     2       bits per job table entry */
.equ jtb,2
/* QL: ctb     equ     jtb     bits per channel table entry */
.equ ctb,jtb
/* QL: xtb     equ     4       bits per combined job/channel table entry */
.equ xtb,4
/* QL: cpj     equ     (1<<xtb-1<<jtb)>>ctb approximate channels per job (3) */
.equ cpj,(((1<<xtb)-(1<<jtb))>>ctb)
/* QL: sbb     equ     9       bits per slave block */
.equ sbb,9
/* QL: sbl     equ     1<<sbb  size of a slave block */
.equ sbl,(1<<sbb)
/* QL: btb     equ     3       bits per slave block table entry */
.equ btb,3
/* QL:         assert  bt_end,1<<btb */
/* original assertion: bt_end,1<<btb */
/* QL: bas_allc equ 2*sbl initial basic allocation (jb_end + bv_end + some + ssmin) */
.equ bas_allc,(2*sbl)
/* QL: res_code equ 0*sbl permanent fixed respr allocation */
.equ res_code,(0*sbl)
/* QL:         section ss_init */
.section ss_init,"ax"
/* QL: * A routine to initialise bt, jb and ch tables */
/* QL: set_tab */
set_tab:
/* QL:         addq.l  #8,a0           for job/chan tables, move over top+tag+max */
    addq.l #8,a0
/* QL: set_tabb */
set_tabb:
/* QL:         move.l  d3,(a0)+        set current table pointer */
    move.l d3,(a0)+
/* QL:         move.l  d3,(a0)+        ... and bottom */
    move.l d3,(a0)+
/* QL:         add.l   d0,d3           add length */
    add.l d0,d3
/* QL:         move.l  d3,(a0)         and put in top */
    move.l d3,(a0)
/* QL:         rts */
    rts 
/* QL: * Initialise system */
/* QL: * d5 -i  - reset type (only lsb used) */
/* QL: * a5 -i  - top of available ram */
/* QL: * a7 -i  - top of system stack */
/* QL: * Once all the system variables, etc., have been set up, job 0 is be set up and */
/* QL: * activated. This routine then drops out to go user mode in job 0. */
/* QL: ss_init */
ss_init:
/* QL:         lea     non020,a3       what our return address on a 68008 should be */
    lea non020(pc),a3
/* QL:         moveq   #mt.inf,d0      this trap is up and working enough to set a6 */
    moveq #mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL: * Now, have a quick look to see if we're on a 68020. This is not much of method */
/* QL: * for doing this, but at least it'll work, until we can decide on a proper trap */
/* QL: * method that'll allow us to determine what processor we're on. */
/* QL: non020 */
non020:
/* QL:         cmp.l   -4(sp),a3       check the return address on the stack */
    cmp.l (-4)(sp),a3
/* QL:         beq.s   not020          like 68008, i guess we're an ordinary machine */
    beq.s not020
/* QL:         moveq   #1,d0           bit 0 = cache on */
    moveq #1,d0
/* QL:         dc.l    $4e7b0002       move d0,cr2... or some such */
.balign 2,0
dc_anchor_632:
.long 0x4e7b0002
/* QL: not020 */
not020:
/* QL:         move.l  a0,a6           set up pointer to system variables */
    move.l a0,a6
/* QL: wipesv */
wipesv:
/* QL:         clr.l   (a0)+           ensure sv area is clean */
    clr.l (a0)+
/* QL:         cmp.l   a0,a7 */
    cmp.l a0,a7
/* QL:         bgt.s   wipesv */
    bgt.s wipesv
/* QL: * Initialise the hardware (maybe this should be moved to earlier on?) */
/* QL:         lea     pc_intr,a3 */
    lea pc_intr,a3
/* QL:         assert  pc_tctrl,pc_ipcwr-1 */
/* original assertion: pc_tctrl,pc_ipcwr-1 */
/* QL:         move.w  #1,pc_tctrl-pc_intr(a3) set transmit mode and reset link */
    move.w #1,(pc_tctrl-pc_intr)(a3)
/* QL: s.mctrl equ     1<<pc..writ!1<<pc..sclk init pc_mctrl (why the write bit? lwr) */
.equ s.mctrl,((1<<pc..writ)|(1<<pc..sclk))
/* QL: s.intr  equ     pc.intre!pc.intrf!pc.intrt!pc.intri!pc.intrg clear interrupts */
.equ s.intr,((((pc.intre|pc.intrf)|pc.intrt)|pc.intri)|pc.intrg)
/* QL:         assert  pc_mctrl,pc_intr-1 */
/* original assertion: pc_mctrl,pc_intr-1 */
/* QL:         move.w  #s.mctrl<<8!s.intr,d0 */
    move.w #((s.mctrl<<8)|s.intr),d0
/* QL:         move.b  d0,(a3)+        clear any interrupts */
    move.b d0,(a3)+
/* QL: * That used to send a null to pc_tdata (& maybe mc_ctrl=0), surely silly! */
/* QL: * Maybe this was in fact meant to give a break condition... need to check out! */
/* QL: * Even hermes doesn't yet notice a break on the line, though it could... */
/* QL:         move.w  d0,-(a3)        a3=mctrl, init mctrl and re-clear interrupts */
    move.w d0,-(a3)
/* QL:         move.b  #pc.maskt!pc.maski,sv_pcint(a6)  set mask for no gap */
    move.b #((pc.maskt|pc.maski)&255),sv_pcint(a6)
/* QL: * The IPC interrupt was useless. The IPC code did not implement its use for  */
/* QL: * signalling serial buffer full, as was intended. Up to 1.93, Minerva was */
/* QL: * totally ignoring it. now we have Hermes, it's back in 'cos the code works, */
/* QL: * signalling every eighth byte of serial input to keep us on our toes. */
/* QL:         jsr     md_desel(pc)            deselect microdrives */
    jsr md_desel(pc)
/* QL: * Now set up the resource tables and their pointers. */
/* QL: * We only assume that the size of memory available is a multiple of 512 bytes. */
/* QL:         move.l  a7,d3           start of tables is just above stack */
    move.l a7,d3
/* QL:         lea     sv_btpnt(a6),a0 start filling at bt pointers */
    lea sv_btpnt(a6),a0
/* QL:         move.l  a5,d0           slave blocks extend to top of ram */
    move.l a5,d0
/* QL:         sub.l   a6,d0           ... from base of system variables */
    sub.l a6,d0
/* QL:         lsr.l   #sbb-btb,d0     slave block table size */
    lsr.l #(sbb-btb),d0
/* QL:         bsr.s   set_tabb */
    bsr.s set_tabb
/* QL:         lsr.l   #1,d0           add half the space of slave blocks to */
    lsr.l #1,d0
/* QL:         add.l   d0,sv_btpnt(a6) the initial pointer (a bit of a fudge...) */
    add.l d0,sv_btpnt(a6)
/* QL:         move.l  d3,a3           save top of bt, bot of jt = the job 0 pointer */
    move.l d3,a3
/* QL:         lsr.l   #11+btb-sbb-1,d0 allow one job per 2k (2^11) of memory ... */
    lsr.l #(((11+btb)-sbb)-1),d0
/* QL:         addq.l  #8,d0           plus a bonus complement of eight */
    addq.l #8,d0
/* QL:         moveq   #120,d1         maximum number of jobs */
    moveq #120,d1
/* QL:         cmp.l   d1,d0 */
    cmp.l d1,d0
/* QL:         bls.s   set_jtab */
    bls.s set_jtab
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL: set_jtab */
set_jtab:
/* QL:         lsl.w   #jtb,d0 */
    lsl.w #jtb,d0
/* QL:         bsr.s   set_tab */
    bsr.s set_tab
/* QL:         mulu    #cpj,d0         channels per job (but we will steal some...) */
    mulu #cpj,d0
/* QL:         bsr.s   set_tab */
    bsr.s set_tab
/* QL:         subq.l  #1,d3           we must finish on a 512 byte boundary... */
    subq.l #1,d3
/* QL:         or.w    #sbl-1,d3       ... so add a few channels to make certain */
    or.w #(sbl-1),d3
/* QL:         addq.l  #1,d3           (awkward to get this right in any other way) */
    addq.l #1,d3
/* QL:         move.l  d3,a4           set the top of the system vars */
    move.l d3,a4
/* QL:         move.l  d3,sv_cheap(a6) set start of common heap */
    move.l d3,sv_cheap(a6)
/* QL:         move.l  d3,sv_free(a6)  set start of free memory (end of common heap) */
    move.l d3,sv_free(a6)
/* QL:         sub.l   a6,d3           take away base of system vars */
    sub.l a6,d3
/* QL:         lsr.l   #sbb-btb,d3     and divide to give the amount of bt entries */
    lsr.l #(sbb-btb),d3
/* QL:         add.l   a7,d3           permanently occupied at base of table */
    add.l a7,d3
/* QL: * Holding onto d3/d5/a0/a3/a5-a6 and modifying a4/a7... */
/* QL: * ... we steal some channels so we can build ram versions of the linkage data */
/* QL: * Note: d1 is currently 120, i.e. the msw is zero */
/* QL:         lea     ss_list(pc),a2  clever table... see source for structure */
    lea ss_list(pc),a2
/* QL:         moveq   #7-1,d0         first is the mdv count, and make msw zero */
    moveq #(7-1),d0
/* QL:         bra.s   getlen          jump in to get things going */
    bra.s getlen
/* QL: lp_link */
lp_link:
/* QL:         move.b  d1,d0           is this sx/od/dd now? */
    move.b d1,d0
/* QL:         beq.s   storeit         no, the direct address is all we want */
    beq.s storeit
/* QL:         move.l  d4,a1           it's an indirect pointer */
    move.l d4,a1
/* QL:         add.b   d0,d0           is there any copying to do? */
    add.b d0,d0
/* QL:         bcs.s   lp_addr         if not sx/mdv, no extra bits */
    bcs.s lp_addr
/* QL:         clr.l   -(a4)           (must clear, as we have not zeroed this area) */
    clr.l -(a4)
/* QL:         clr.w   -(a4)           3 words reserved at end of sx/mdv entries */
    clr.w -(a4)
/* QL: lp_copy */
lp_copy:
/* QL:         move.w  -(a1),-(a4)     copy the top bit of the sx/mdv entries ... */
    move.w -(a1),-(a4)
/* QL:         bne.s   lp_copy         ... until we hit a zero */
    bne.s lp_copy
/* QL: lp_addr */
lp_addr:
/* QL:         move.w  -(a1),d4        get lsw (msw is zero) */
    move.w -(a1),d4
/* QL:         beq.s   storeit         allow for zeroes in mdv list */
    beq.s storeit
/* QL:         add.w   a1,d4           add offset, ensuring < 32k */
    add.w a1,d4
/* QL: storeit */
storeit:
/* QL:         move.l  d4,-(a4)        store relocated address */
    move.l d4,-(a4)
/* QL:         subq.b  #2,d0 */
    subq.b #2,d0
/* QL:         bpl.s   lp_addr         do all entries */
    bpl.s lp_addr
/* QL:         move.l  d2,-(a4)        set linkage word */
    move.l d2,-(a4)
/* QL:         move.l  a4,d2           next linkage */
    move.l a4,d2
/* QL: nxt_ptr */
nxt_ptr:
/* QL:         move.w  -(a2),d0        get next pointer */
    move.w -(a2),d0
/* QL:         move.l  a2,d4           clears msw for us */
    move.l a2,d4
/* QL:         add.w   d0,d4           this is the absolute address, maybe */
    add.w d0,d4
/* QL:         lsr.w   #1,d0           was the thing we picked up odd? */
    lsr.w #1,d0
/* QL:         bcc.s   lp_link         loop till we hit an odd one */
    bcc.s lp_link
/* QL:         move.l  d2,-(sp)        save linkage start */
    move.l d2,-(sp)
/* QL: getlen */
getlen:
/* QL:         moveq   #0,d2           final link is zero */
    moveq #0,d2
/* QL:         move.w  d0,d1           put count byte into register */
    move.w d0,d1
/* QL:         bne.s   nxt_ptr         carry on building if not zero */
    bne.s nxt_ptr
/* QL: * We actually end up here with d0, d1 and d2 zero. */
/* QL: * The stack now holds 5 longwords ready to set linkage pointers, the last one */
/* QL: * not important here, though it was just used to set up the sysvars extension. */
/* QL: * We've now stolen the top of the channel table, so say so... */
/* QL:         move.l  a4,(a0)         modify sv_chtop(a6) to point at linkages */
    move.l a4,(a0)
/* QL: fil_jbch */
fil_jbch:
/* QL:         assert  jtb,ctb */
/* original assertion: jtb,ctb */
/* QL:         subq.l  #1<<jtb,a4 */
    subq.l #(1<<jtb),a4
/* QL:         st      (a4)            fill job and channel tables with -1 msb */
    st (a4)
/* QL:         cmp.l   a4,a3           down to job 0 */
    cmp.l a4,a3
/* QL:         bne.s   fil_jbch */
    bne.s fil_jbch
/* QL:         moveq   #(res_code+bas_allc)>>(sbb-btb),d1 */
    moveq #((res_code+bas_allc)>>(sbb-btb)),d1
/* QL:         sub.w   d1,a3           take off initial alloc */
    sub.w d1,a3
/* QL: clrtop */
clrtop:
/* QL:         clr.l   -(a4)           wipe area for basic and resident section */
    clr.l -(a4)
/* QL:         cmp.l   a4,a3 */
    cmp.l a4,a3
/* QL:         bne.s   clrtop */
    bne.s clrtop
/* QL:         moveq   #1,d2 */
    moveq #1,d2
/* QL: fill_bt */
fill_bt:
/* QL:         assert  bt_stat,0 */
/* original assertion: bt_stat,0 */
/* QL:         subq.l  #bt_end,a4 */
    subq.l #bt_end,a4
/* QL:         move.b  d2,(a4)         fill status byte with 1 for free slave blocks */
    move.b d2,(a4)
/* QL:         cmp.l   a4,d3 */
    cmp.l a4,d3
/* QL:         bne.s   fill_bt */
    bne.s fill_bt
/* QL: * Now fill in miscellaneous bits of the system variable area */
/* QL:         movem.l (sp)+,d3/a0-a3 grab the linkage pointers (d3 is not used) */
    movem.l (sp)+,d3/a0-a3
/* QL:         assert  sv_plist,sv_shlst-4,sv_drlst-8,sv_ddlst-12 */
/* original assertion: sv_plist,sv_shlst-4,sv_drlst-8,sv_ddlst-12 */
/* QL:         movem.l a0-a3,sv_plist(a6) set the pointers */
    movem.l a0-a3,sv_plist(a6)
/* QL: clrbot */
clrbot:
/* QL:         clr.l   -(a4)           wipe area for permanent tables */
    clr.l -(a4)
/* QL:         cmp.l   a4,a7 */
    cmp.l a4,a7
/* QL:         bne.s   clrbot */
    bne.s clrbot
/* QL:         addq.b  #1,sv_netnr(a6) set net station number to 1 */
    addq.b #1,sv_netnr(a6)
/* QL:         assert  sv_ardel,sv_arfrq-2 */
/* original assertion: sv_ardel,sv_arfrq-2 */
/* QL:         move.l  #30<<16+2,sv_ardel(a6) auto repeat delay = 600 ms */
    move.l #((30<<16)+2),sv_ardel(a6)
/* QL:         ;                 sv_arfrq 1/auto repeat frequency = 40ms */
/* QL:         addq.b  #3,sv_cqch+1(a6) initially, old ctrl/c to change queues */
    addq.b #3,(sv_cqch+1)(a6)
/* QL:         move.w  #sv.ident,sv_ident(a6) ident (tacky way sv's were to be found) */
    move.w #sv.ident,sv_ident(a6)
/* QL: ;        move.l  a5,sv_ramt(a6)  set real top of ram */
/* QL:         assert  res_code,0 */
/* original assertion: res_code,0 */
/* QL: ;       lea     -res_code(a5),a0 find top of working ram */
/* QL: ;       moveq   #bas_allc>>(sbb-btb),d1 */
/* QL:         asl.l   #sbb-btb,d1 */
    asl.l #(sbb-btb),d1
/* QL:         move.l  a5,a0           find top of working ram */
    move.l a5,a0
/* QL:         assert  sv_respr,sv_ramt-4 */
/* original assertion: sv_respr,sv_ramt-4 */
/* QL: ;        move.l  a0,sv_respr(a6) store as base of resident area */
/* QL:         movem.l a0/a5,sv_respr(a6) store as base of resident area an top of ram */
    movem.l a0/a5,sv_respr(a6)
/* QL:         move.l  a0,sv_trnsp(a6) & transient base & it's basic's top */
    move.l a0,sv_trnsp(a6)
/* QL:         sub.w   d1,a0           leave initial basic allocation */
    sub.w d1,a0
/* QL:         move.l  a0,sv_basic(a6) and this is basic job defn block */
    move.l a0,sv_basic(a6)
/* QL:         lea     jb_end(a0),a1 */
    lea jb_end(a0),a1
/* QL: clrbas */
clrbas:
/* QL:         clr.l   -(a1)           wipe job 0 header */
    clr.l -(a1)
/* QL:         cmp.l   a1,a0 */
    cmp.l a1,a0
/* QL:         blt.s   clrbas */
    blt.s clrbas
/* QL:         jsr     ss_jtag(pc)     make the tag tick, and a3 = job 0 jobtab ptr */
    jsr ss_jtag(pc)
/* QL:         lea     sb_start(pc),a1 */
    lea sb_start(pc),a1
/* QL:         ; a0 = header, a1 = start, a3 = jobtab ptr, d1 = overall size, so ... */
/* QL:         jsr     mt_cj0(pc)      set up the job 0 header */
    jsr mt_cj0(pc)
/* QL:         move.b  d5,-(a3)        tacky, but set lsb of saved a4 to reset flags */
    move.b d5,-(a3)
/* QL:         move.b  #32,jb_princ-jb_end(a0) activate job 0 */
    move.b #(32&255),(jb_princ-jb_end)(a0)
/* QL:         moveq   #mt.cntry,d0 */
    moveq #mt.cntry,d0
/* QL:         moveq   #0,d1           translation off */
    moveq #0,d1
/* QL: *       moveq   #1,d2           default messages (still 1 from above) */
/* QL:         trap    #1 */
    trap #1
/* QL:         move.w  #9600,d1        set rs232 9600 baud */
    move.w #9600,d1
/* QL:         moveq   #mt.baud,d0 */
    moveq #mt.baud,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         jmp     ss_rj0(pc)      this will start up basic */
    jmp ss_rj0(pc)
/* QL:         end */
