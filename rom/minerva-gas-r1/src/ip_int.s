/* Generated from original/M/ip/int.asm */
/* QL: * IPC interrupt routine */
/* QL:         xdef    ip_ipcr,ip_poll,ip_sched,ip_txqo */
.globl ip_ipcr,ip_poll,ip_sched,ip_txqo
/* QL:         xdef    ip_adcmd,ip_rdwr,ip_setad */
.globl ip_adcmd,ip_rdwr,ip_setad
/* QL:         xref    ip_kbend,ip_kbrd */
/* QL:         xref    io_qin,io_qout,io_qtest */
/* QL:         xref    mm_rechp */
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         section ip_int */
.section ip_int,"ax"
/* QL: * Check out the IPC as one of the routines on the frame interrupt polling list. */
/* QL: * d0-d2/d4-d7/a0-a3 destroyed. */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: ip_poll */
ip_poll:
/* QL:         move    sr,-(sp) */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        disable interrupts */
    or.w #0x700,sr
/* QL:         bsr.s   ip_ipcr */
    bsr.s ip_ipcr
/* QL:         move    (sp)+,sr        n.b. rte is no good on a 68020 */
    move (sp)+,sr
/* QL:         rts */
    rts 
/* QL: * This maintains the sound and wp flags, keyboard and serial port input. */
/* QL: * It is called on either frame or interface interrupts. */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: * a0 -  o- pc_ipcrd */
/* QL: * a1 -  o- pc_ipcwr */
/* QL: * d0-d2/d4-d7/a2-a3 destroyed. */
/* QL: ip_ipcr */
ip_ipcr:
/* QL:         moveq   #stat_cmd-32*3,d1 status command + read a byte (2 nibbles) */
    moveq #(stat_cmd-(32*3)),d1
/* QL:         bsr.s   ip_adcmd        set a0-a1, ask for status and receive status */
    bsr.s ip_adcmd
/* QL:                 ;               1?w21??sk------- */
/* QL:         exg     d1,d7           save it */
    exg d1,d7
/* QL:         assert  0,ipc..kb */
/* original assertion: 0,ipc..kb */
/* QL:         ; bit 7 is the last bit fetched, and the n flag will be set by it */
/* QL: * Also see if there is input pending on the keyboard */
/* QL:         bpl.s   nokbd           don't bother if not */
    bpl.s nokbd
/* QL:         move.l  sv_keyq(a6),d0  fetch ptr to current keyboard queue */
    move.l sv_keyq(a6),d0
/* QL:         beq.s   nokbd           no queue, don't bother reading the IPC */
    beq.s nokbd
/* QL:         move.l  d0,a2 */
    move.l d0,a2
/* QL:         moveq   #rdkb_cmd-32*2,d1 read kbd command + read one nibble */
    moveq #(rdkb_cmd-(32*2)),d1
/* QL:         bsr.s   ip_cmd          give it */
    bsr.s ip_cmd
/* QL:         ror.w   #7,d1 */
    ror.w #7,d1
/* QL:         move.b  d1,d5           save it for "held" flag in bit 4 */
    move.b d1,d5
/* QL:         moveq   #7,d4 */
    moveq #7,d4
/* QL:         and.b   d1,d4           extract number of keystrokes */
    and.b d1,d4
/* QL:         bra.s   char1           enter at bottom of loop */
    bra.s char1
/* QL: rdch */
rdch:
/* QL:         moveq   #-2*3,d1        read 3 nibbles */
    moveq #((-2)*3),d1
/* QL:         bsr.s   ip_rdwr         read the shift/ctrl/alt nibble and key number */
    bsr.s ip_rdwr
/* QL:         lsr.l   #7,d1           key number byte in d1 */
    lsr.l #7,d1
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         lsr.w   #8,d2           shift/ctrl/alt in d2 */
    lsr.w #8,d2
/* QL:         jsr     ip_kbrd(pc)     go process it */
    jsr ip_kbrd(pc)
/* QL: char1 */
char1:
/* QL:         dbra    d4,rdch         and again if there are more characters */
    dbra d4,rdch
/* QL:         jsr     ip_kbend(pc)    go finish off autorepeat setting */
    jsr ip_kbend(pc)
/* QL: nokbd */
nokbd:
/* QL: * update the sound process finished system variable */
/* QL:         rol.w   #9+ipc..kb-ipc..so,d7 */
    rol.w #((9+ipc..kb)-ipc..so),d7
/* QL:                 ;               1?w21??s carry=s */
/* QL:         scs     sv_sound(a6)    set to ones if running, else zero */
    scs sv_sound(a6)
/* QL:                 ;               1?w21??s */
/* QL:         rol.b   #8+ipc..so-ipc..wp,d7 */
    rol.b #((8+ipc..so)-ipc..wp),d7
/* QL:                 ;               21??s1?w carry=w, sign=ser2 */
/* QL:         scc     sv_wp(a6)       set the write protect flag, IPC P26 input */
    scc sv_wp(a6)
/* QL:         move.l  sv_chtop(a6),a3 get extension address */
    move.l sv_chtop(a6),a3
/* QL:         move.b  d7,$4e(a3)      experimental 21??s1?w */
    move.b d7,0x4e(a3)
/* QL: * now see if there is input pending on the rs232 channels */
/* QL:         assert  ipc..s2,ipc..wp-1 */
/* original assertion: ipc..s2,ipc..wp-1 */
/* QL:         bpl.s   noser2 */
    bpl.s noser2
/* QL:         moveq   #rds2_cmd-3*32,d5 read serial 2 + read a byte (2 nibbles) */
    moveq #(rds2_cmd-(3*32)),d5
/* QL:         move.l  sv_ser2c(a6),d0 fetch queue pointer */
    move.l sv_ser2c(a6),d0
/* QL:         bsr.s   rdser           get the input (maybe) */
    bsr.s rdser
/* QL: noser2 */
noser2:
/* QL:         assert  ipc..s1,ipc..s2-1 */
/* original assertion: ipc..s1,ipc..s2-1 */
/* QL:                 ;               21??01?w */
/* QL:         add.b   d7,d7           check for ser1 and state of wp */
    add.b d7,d7
/* QL:                 ;               1??01?w0 sign=ser1 */
/* QL:         bpl.s   noser1 */
    bpl.s noser1
/* QL:         moveq   #rds1_cmd-3*32,d5 read serial 1 + read a byte (2 nibbles) */
    moveq #(rds1_cmd-(3*32)),d5
/* QL:         move.l  sv_ser1c(a6),d0 */
    move.l sv_ser1c(a6),d0
/* QL:         bsr.s   rdser           get the input (maybe) */
    bsr.s rdser
/* QL: noser1 */
noser1:
/* QL:         rts */
    rts 
/* QL: * set up addresses for the IPC read and write routines */
/* QL: * a0 -  o- pc_ipcrd, IPC read address */
/* QL: * a1 -  o- pc_ipcwr, IPC write address */
/* QL: ip_setad */
ip_setad:
/* QL:         lea     pc_ipcwr,a1     write address */
    lea pc_ipcwr,a1
/* QL:         lea     pc_ipcrd-pc_ipcwr(a1),a0 read address */
    lea (pc_ipcrd-pc_ipcwr)(a1),a0
/* QL:         rts */
    rts 
/* QL: * IPC combined command and read routine */
/* QL: * The input value contains up to 6 command nibbles and a count. */
/* QL: * Three entries points are provided, the first of which (ip_adcmd) calls */
/* QL: * ip_setad to set up a0-a1 before dropping into the second (ip_cmd) which just */
/* QL: * rolls the 4 lsbs around to the top to provided the initial command nibble. */
/* QL: * The final entry (ip_rdwr) is then dropped into. */
/* QL: * Bits 31..8 are then the command/data nibbles, with all ones (15) used for */
/* QL: * pure reading, and they are sent starting with the nibble in bits 31..28. */
/* QL: * Bits 7..4 are ignored, but for convenience they will probably be set to ones. */
/* QL: * Bits 3..1 may be -1..-6(7..2), giving the negated total nibble count (1..6). */
/* QL: * Bit 0 is ignored. */
/* QL: * If the above seems complicated, it is simple to use, with typical calls: */
/* QL: * To send an initial command nibble: "moveq #xxx_cmd-32,d1;jsr ip_adcmd". */
/* QL: * Another command & read "n" nibbles "moveq #xxx_cmd-32*(1+n),d1;jsr ip_cmd" */
/* QL: * To just read "n" nibbles "moveq #-2*n,d1;jsr ip_rdwr". */
/* QL: * The returned value will provide up to six nibbles in bits 30..7, the one in */
/* QL: * bits 14..7 being the last, or only, such nibble. X and bits 31 down will in */
/* QL: * fact be the bits after the last bit that was sent, if that's of any use! */
/* QL: * The remaining bits 6..0 are as read from pc_ipcrd along with the final bit. */
/* QL: * The final bit will set the ccr n flag. */
/* QL: * The reasoning behind combining the read and write functions like this is that */
/* QL: * the IPC takes a little time to process each bit, enough to set up a new write */
/* QL: * value without impairing the overall speed. The code here is arranged to make */
/* QL: * the actual handshake with the IPC turn round bits as rapidly as they can be */
/* QL: * read, with just one instruction more than if they were merely being written. */
/* QL: * By allowing up to six nibbles to be involved in each transfer, we are able, */
/* QL: * for example, to read the serial input three bytes at at time. */
/* QL: * d1 -i o- nibble count and commands / read nibbles in 30..7 (ccr for 7..0) */
/* QL: * a0 -ip - pc_ipcrd */
/* QL: * a1 -ip - pc_ipcwr */
/* QL: * d0/d6 destroyed (d0.l=12+2*<last bit sent>, d6.l=$ffff0001) */
/* QL: ip_adcmd */
ip_adcmd:
/* QL:         bsr.s   ip_setad        set up addresses */
    bsr.s ip_setad
/* QL: ip_cmd */
ip_cmd:
/* QL:         ror.l   #4,d1           roll command to top nibble */
    ror.l #4,d1
/* QL: ip_rdwr */
ip_rdwr:
/* QL:         add.l   d1,d1           note lsb now zero */
    add.l d1,d1
/* QL:         moveq   #%1100>>2,d0    forming write byte for first bit */
    moveq #(0b1100>>2),d0
/* QL:         roxl.b  #2,d0 */
    roxl.b #2,d0
/* QL:         move.b  d0,(a1)         send it now, to get the IPC under way */
    move.b d0,(a1)
/* QL:         moveq   #-2-7*4,d6      %1111ccc10, ccc = -ve total nibble count */
    moveq #((-2)-(7*4)),d6
/* QL:         or.b    d1,d6           form -ve count now, before waiting for the IPC */
    or.b d1,d6
/* QL: iploop */
iploop:
/* QL:         add.l   d1,d1           roll up the read bit */
    add.l d1,d1
/* QL:         moveq   #%1100>>2,d0    forming write byte for next bit */
    moveq #(0b1100>>2),d0
/* QL:         roxl.b  #2,d0 */
    roxl.b #2,d0
/* QL: ipwait1 */
ipwait1:
/* QL:         btst    #6,(a0)         has the previous bit been used by the IPC yet? */
    btst #6,(a0)
/* QL:         bne.s   ipwait1         no, wait for it */
    bne.s ipwait1
/* QL:         move.b  (a0),d1         get data bit in bit 7 */
    move.b (a0),d1
/* QL:         move.b  d0,(a1)         we are ready instantly to send next write byte */
    move.b d0,(a1)
/* QL:         addq.w  #1,d6           (pity, but 2 extra cycles for addq.l) */
    addq.w #1,d6
/* QL:         ble.s   iploop          go start preparing next write byte */
    ble.s iploop
/* QL:         add.l   d1,d1           roll up the penultimate bit */
    add.l d1,d1
/* QL: ipwait2 */
ipwait2:
/* QL:         btst    #6,(a0)         has final bit been processed by the IPC? */
    btst #6,(a0)
/* QL:         bne.s   ipwait2         no - wait for it */
    bne.s ipwait2
/* QL:         move.b  (a0),d1         get final data bit in bit 7, plus rest of stuff */
    move.b (a0),d1
/* QL:         rts */
    rts 
/* QL: * This routine gets a stream of bytes from the serial input channel of the IPC */
/* QL: * and shoves them into the appropriate queue. */
/* QL: * ccr-i  - z set if d0.l=0 */
/* QL: * d0 -i  - serial channel queue address */
/* QL: * d5 -ip - IPC serial read command for this channel */
/* QL: * a0 -ip - pc_ipcrd */
/* QL: * a1 -ip - pc_ipcwr */
/* QL: * a2 -  o- serial channel queue address */
/* QL: * d1-d2/d4/d6/a3 destroyed */
/* QL: rdser */
rdser:
/* QL:         beq.s   rts0            no queue, so leave data in IPC */
    beq.s rts0
/* QL:         move.l  d0,a2           set up serial channel */
    move.l d0,a2
/* QL:         bsr.s   qtest           see how much room in queue */
    bsr.s qtest
/* QL:         cmp.w   #sbsize,d2      is it enough for a full IPC buffer? */
    cmp.w #sbsize,d2
/* QL:         blt.s   rts0            can't guarantee we can read it all, so leave it */
    blt.s rts0
/* QL:         move.l  d5,d1           restore the appropriate IPC command */
    move.l d5,d1
/* QL:         bsr.s   ip_cmd          send it, read number of bytes to be transferred */
    bsr.s ip_cmd
/* QL:         ror.w   #7,d1 */
    ror.w #7,d1
/* QL:         lea     sv_timov-rds1_cmd+3*32(a6),a3 base serial control byte address */
    lea ((sv_timov-rds1_cmd)+(3*32))(a6),a3
/* QL:         assert  rds1_cmd,rds2_cmd-1 */
/* original assertion: rds1_cmd,rds2_cmd-1 */
/* QL:         add.w   d5,a3 */
    add.w d5,a3
/* QL:         moveq   #-32,d4 */
    moveq #(-32),d4
/* QL:         and.b   d1,d4 */
    and.b d1,d4
/* QL:         or.b    d4,(a3)         accumulate lost data/frame error/?? flags */
    or.b d4,(a3)
/* QL:         eor.b   d1,d4           keep the byte count (0..31(23)) */
    eor.b d1,d4
/* QL:         bra.s   rsent           enter loop */
    bra.s rsent
/* QL: rdsch */
rdsch:
/* QL:         moveq   #-2*6,d1        three bytes (6 nibbles) */
    moveq #((-2)*6),d1
/* QL:         bsr.s   ip_rdwr         read them in */
    bsr.s ip_rdwr
/* QL:         add.l   d1,d1           put them in msbs */
    add.l d1,d1
/* QL:         bsr.s   qnext           stuff first */
    bsr.s qnext
/* QL:         bsr.s   qnext           stuff second */
    bsr.s qnext
/* QL:         bsr.s   qnext           stuff third */
    bsr.s qnext
/* QL: rsent */
rsent:
/* QL:         subq.b  #3,d4 */
    subq.b #3,d4
/* QL:         bge.s   rdsch           loop around */
    bge.s rdsch
/* QL:         addq.b  #3,d4 */
    addq.b #3,d4
/* QL:         beq.s   rts0            finished if multiple of 3 */
    beq.s rts0
/* QL: rsone */
rsone:
/* QL:         moveq   #-2*2,d1        one byte (2 nibbles) */
    moveq #((-2)*2),d1
/* QL:         bsr.s   ip_rdwr */
    bsr.s ip_rdwr
/* QL:         ror.w   #7,d1 */
    ror.w #7,d1
/* QL:         bsr.s   qin */
    bsr.s qin
/* QL:         subq.b  #1,d4 */
    subq.b #1,d4
/* QL:         bne.s   rsone */
    bne.s rsone
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: qnext */
qnext:
/* QL:         rol.l   #8,d1 */
    rol.l #8,d1
/* QL: qin */
qin:
/* QL:         jmp     io_qin(pc) */
    jmp io_qin(pc)
/* QL: * Scheduler list routine for handling serial output */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: * d0-d2/d4-d6/a0-a5 destroyed. */
/* QL: ip_sched */
ip_sched:
/* QL:         sf      d4              say this is from scheduler loop */
    sf d4
/* QL:         move    sr,-(sp) */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        disable interrupts */
    or.w #0x700,sr
/* QL:         bsr.s   ip_txqo         go send any rs232 */
    bsr.s ip_txqo
/* QL:         move    (sp)+,sr        n.b. rte is no good on a 68020 */
    move (sp)+,sr
/* QL:         rts                     back to calling code */
    rts 
/* QL: qtest */
qtest:
/* QL:         jmp     io_qtest(pc) */
    jmp io_qtest(pc)
/* QL: * This is called either via ip_sched, or on rs232 transmit interrupts. */
/* QL: * It will swap queues when nothing can be done on the one it is looking at, */
/* QL: * and, as a new enhancement, it will only change over if there is something to */
/* QL: * be sent by the other channel. */
/* QL: * It takes a byte out of the transmit queue (if there is one) and sends it */
/* QL: * over the serial channel. */
/* QL: * If this has been called from the scheduler, memory is released if the */
/* QL: * transmit queue is closed and both queues for a port are empty. */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: * d4 -ip - lsb $ff = interrupt, 0 = scheduler */
/* QL: * d0-d2/d5-d6/a0-a5 destroyed. */
/* QL: ip_txqo */
ip_txqo:
/* QL:         lea     pc_mctrl,a1     set up control register address */
    lea pc_mctrl,a1
/* QL:         btst    #pc..txfl,(a1)  is transmit buffer full? */
    btst #pc..txfl,(a1)
/* QL:         bne.s   rts0            yes - don't bother even think about sending */
    bne.s rts0
/* QL:         lea     sv_tmode(a6),a4 set address of transmit mode system variable */
    lea sv_tmode(a6),a4
/* QL:         moveq   #0,d5           set msb zero, so we know what we're doing */
    moveq #0,d5
/* QL:         move.b  (a4),d5         get transmit mode */
    move.b (a4),d5
/* QL:         assert  pc..sern,pc..serb-1 */
/* original assertion: pc..sern,pc..serb-1 */
/* QL:         lsl.b   #8-pc..serb,d5  are we set to rs232 mode? */
    lsl.b #(8-pc..serb),d5
/* QL:         bcs.s   rts0            no - don't try to transmit */
    bcs.s rts0
/* QL:         assert  pc..dtr1,pc..cts2-1 */
/* original assertion: pc..dtr1,pc..cts2-1 */
/* QL:         spl     d5              find out which port is in use */
    spl d5
/* QL: other1 */
other1:
/* QL:         move.b  d5,d6 */
    move.b d5,d6
/* QL:         lea     sv_ser1c(a6),a5 address of ser1 receive queue */
    lea sv_ser1c(a6),a5
/* QL:         bne.s   serset */
    bne.s serset
/* QL:         addq.l  #sv_ser2c-sv_ser1c,a5 ser2 queue */
.word 20621|((((sv_ser2c-sv_ser1c))&7)<<9)
/* QL: serset */
serset:
/* QL:         move.l  (a5),d1         is there a queue for this port? */
    move.l (a5),d1
/* QL:         beq.s   q_change        there isn't one, try the other next time */
    beq.s q_change
/* QL:         move.l  d1,a0           this is the receive queue */
    move.l d1,a0
/* QL:         lea     ser_txq-ser_rxq(a0),a2 this is the transmit queue */
    lea (ser_txq-ser_rxq)(a0),a2
/* QL:         bsr.s   qtest           have a look at the queue now, to delay h/s test */
    bsr.s qtest
/* QL:         beq.s   chk_hs          byte ready, so go start thinking */
    beq.s chk_hs
/* QL: q_err */
q_err:
/* QL:         addq.l  #-err.nc,d0 */
.word 20608|((((-err.nc))&7)<<9)
/* QL:         bpl.s   q_change        if not eof, go try to change port */
    bpl.s q_change
/* QL:         tst.b   d4              check if this is a scheduler loop call */
    tst.b d4
/* QL:         bne.s   q_change        no - can't do eof as it releases memory */
    bne.s q_change
/* QL:         move.l  a0,a2 */
    move.l a0,a2
/* QL:         bsr.s   qtest           have a look at the receive queue */
    bsr.s qtest
/* QL:         beq.s   q_change        don't release if there's input data pending */
    beq.s q_change
/* QL:         clr.l   (a5)            clear queue pointer */
    clr.l (a5)
/* QL:         sub.w   #ser_rxq,a0 */
    sub.w #ser_rxq,a0
/* QL:         jmp     mm_rechp(pc)    get rid of the channel */
    jmp mm_rechp(pc)
/* QL: chk_hs */
chk_hs:
/* QL:         tst.b   ser_txhs+1-ser_txq(a2) are we checking handshakes? */
    tst.b ((ser_txhs+1)-ser_txq)(a2)
/* QL:         beq.s   txready         no - go straight for a byte */
    beq.s txready
/* QL:         addq.b  #pc..cts2,d6    get handshake bit number */
    addq.b #pc..cts2,d6
/* QL:         btst    d6,(a1)         how is the handshake line? */
    btst d6,(a1)
/* QL:         beq.s   txready         ready - we'll go send this, or switch ports */
    beq.s txready
/* QL: q_change */
q_change:
/* QL:         not.l   d5              have we looked at the other one yet? */
    not.l d5
/* QL:         bmi.s   other1          no - so go see if that might be worth doing */
    bmi.s other1
/* QL: * We drop out here when there was nothing we could do with either port. */
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: * Everything ok, so let's send the byte qtest gave us, or switch channels */
/* QL: txready */
txready:
/* QL:         lea     sv_timov(a6),a3 set a convenient pointer */
    lea sv_timov(a6),a3
/* QL:         tst.l   d5              are we looking at the current port? */
    tst.l d5
/* QL:         bpl.s   do_send         yes, so we really can send it */
    bpl.s do_send
/* QL: * Check for timeout before changing port */
/* QL: * ZX8302 should only be told change the port when all bytes sent to the current */
/* QL: * port must have certainly been transmitted, or they'll go to the wrong port! */
/* QL:         assert  sv_timo,sv_timov-2 */
/* original assertion: sv_timo,sv_timov-2 */
/* QL:         sub.w   d3,-(a3)        decrement timeout */
    sub.w d3,-(a3)
/* QL:         bge.s   rts1            still not down far enough */
    bge.s rts1
/* QL:         clr.w   (a3)+           clear timeout, as top byte is set */
    clr.w (a3)+
/* QL:         eor.b   #1<<pc..sern,(a4) change port in the system variable */
    eor.b #((1<<pc..sern)&255),(a4)
/* QL: do_send */
do_send:
/* QL:         ext.w   d5 */
    ext.w d5
/* QL:         moveq   #pc.bmask,d0    we want just the baud rate */
    moveq #pc.bmask,d0
/* QL:         and.b   1(a3,d5.w),d0   we hold ser1/ser2 control bytes here now */
    and.b 1(a3,d5.w),d0
/* QL:         and.b   #-1-pc.bmask,(a4) lose baud rate in the system variable */
    and.b #(((-1)-pc.bmask)&255),(a4)
/* QL:         or.b    d0,(a4)         insert correct baud rate in the system variable */
    or.b d0,(a4)
/* QL:         move.b  (a4),pc_tctrl-pc_mctrl(a1) set the zx8302 */
    move.b (a4),(pc_tctrl-pc_mctrl)(a1)
/* QL:         assert  sv_timo,sv_timov-2 */
/* original assertion: sv_timo,sv_timov-2 */
/* QL:         move.b  timov(pc,d0.w),-(a3) use table to set timeout */
    move.b timov(pc,d0.w),-(a3)
/* QL:         move.b  d1,pc_tdata-pc_mctrl(a1) send byte now, as late at possible */
    move.b d1,(pc_tdata-pc_mctrl)(a1)
/* QL:         jmp     io_qout(pc)     discard the byte we have sent */
    jmp io_qout(pc)
/* QL: * We know that we will not be here unless the transmit buffer was empty. */
/* QL: * We know this occurs 1/2 bit before the start, 8 data and 2 stop bits begin. */
/* QL: * Therefore we need only make sure that 11.5 bit times expire before we can */
/* QL: * change ports. */
/* QL: * We cannot count the first clock tick, because it may come instantly. */
/* QL: * At 60Hz tick rate, 11.5 bits at 75 baud require 60*11.5/75 = 9.2 ticks. */
/* QL: timov   dc.b    1,1,1,1,1,2,3,10 */
timov:
dc_anchor_1082:
.byte (1)&255
.byte (1)&255
.byte (1)&255
.byte (1)&255
.byte (1)&255
.byte (2)&255
.byte (3)&255
.byte (10)&255
/* QL:         end */
