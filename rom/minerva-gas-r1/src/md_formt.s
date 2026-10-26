/* Generated from original/M/md/formt.asm */
/* QL: * Formats a microdrive medium */
/* QL:         xdef    md_formt */
.globl md_formt
/* QL:         xref    mm_alchp,mm_rechp */
/* QL:         xref    md_selec,md_desel,md_wblok,md_write,md_sectr,md_fsect,md_veril */
/* QL:         xref    ss_wser,ss_rser */
/* QL:         include 'win1_m_inc_delay' */
/* QL: ; delay for a given number of microseconds - destroys d0 */
/* QL:         nolist */
/* QL: delay   macro   us */
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
/* QL:         include 'win1_m_inc_hp' */
/* QL: * common heap header definition */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: hp_len  ds.l    1       length of definition block */
.equ hp_len,0
/* QL: hp_next ; pointer to next free space */
.equ hp_next,4
/* QL: hp_drivr ds.l   1       driver to free block when owner is deleted (-ch_close) */
.equ hp_drivr,4
/* QL: hp_owner ds.l   1       owner job (0 if free space) */
.equ hp_owner,8
/* QL: hp_rflag ds.l   1       address to be set when space released */
.equ hp_rflag,12
/* QL: hp_end */
.equ hp_end,16
/* QL: hp_close equ    12      offset of close entry point wrt driver add */
.equ hp_close,12
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
/* QL: dvl     equ     5               device length (mdvn_) */
.equ dvl,5
/* QL: nml     equ     10              medium name length */
.equ nml,10
/* QL: bdl     equ     512             block data length */
.equ bdl,512
/* QL: wdcs macro m,l,n */
/* QL: * Define workspace */
/* QL:         offset  0 */
/* QL: shbeg ; sector header */
.equ shbeg,0
/* QL:         ds.b    1       $ff */
/* QL: sno     ds.b    1       sector number */
.equ sno,1
/* QL:         ds.b    nml     medium name */
/* QL:         ds.b    2       randow number */
/* QL: shend */
.equ shend,14
/* QL: blbeg ; block */
.equ blbeg,14
/* QL:         ds.b    1       file number */
/* QL:         ds.b    1       block number */
/* QL:         ds.b    2       checksum */
/* QL: blpre   ds.b    6+2     preamble (6 zeroes and 2 $FF's) */
.equ blpre,18
/* QL: bldata  ds.b    bdl     block data */
.equ bldata,26
/* QL: blcs    ds.b    2       checksum (embedded in the long block we format with) */
.equ blcs,538
/* QL: bx      ds.b    84      extra bytes */
.equ bx,540
/* QL: blend */
.equ blend,624
/* QL: map     ds.b    bdl */
.equ map,624
/* QL:         ds.b    2       for simpler scan */
/* QL: wsend */
.equ wsend,1138
/* QL: * Sector types (recorded as file number) */
/* QL: st_map  equ     $f8     map file number */
.equ st_map,0xf8
/* QL: st_free equ     $fd     verifified ok twice */
.equ st_free,0xfd
/* QL: st_grot equ     $fe     failed one or other of the verifies */
.equ st_grot,0xfe
/* QL: st_bad  equ     $ff     not seen, or neighbour was not seen, on either verify */
.equ st_bad,0xff
/* QL: * We have a sum to do here... assume that we could actually have a full 256 */
/* QL: * sectors validly written to a tape. This will allow us to create 226 ($E2) */
/* QL: * files, needing 29 directory sectors plus the map sector. Note that this */
/* QL: * implies that the above "special" file numbers are fine. */
/* QL: * A nasty thought: The way the format is done, when sector zero is written, we */
/* QL: * don't even expect the next block to be OK, as it's probably cut in half, so */
/* QL: * our "neighbour" verify wouldn't work, even if we did it. */
/* QL: * We could be just on the splice, meaning that, of all the sectors that might */
/* QL: * be dodgy, the map sector is the only one we don't check very strongly! */
/* QL: * At the risk of offending someone's obscure idea of verification, it might be */
/* QL: * terribly sensible to format 127 to 0, then 254 to 128. As we fail the format */
/* QL: * if we get less than 200 blocks anyway, this'll be fine. We could even decide */
/* QL: * to reject the format should we see any of sectors 127 to 123, because that */
/* QL: * would imply the tape was running far too slow. We'd finish up with tapes that */
/* QL: * always had 200..250 sectors. */
/* QL:         section md_formt */
.section md_formt,"ax"
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- number of medium to format / number of sectors good */
/* QL: * d2 -i o- number of sectors found (includes dodgy ones...) */
/* QL: * a1 -i  - pointer to medium name */
/* QL: err_iu */
err_iu:
/* QL:         moveq   #err.iu,d0 */
    moveq #err.iu,d0
/* QL: anrts */
anrts:
/* QL:         rts */
    rts 
/* QL: md_formt */
md_formt:
/* QL:         tst.b   sv_mdrun(a6)    is any drive running? */
    tst.b sv_mdrun(a6)
/* QL:         bne.s   err_iu          yes - say in use */
    bne.s err_iu
/* QL:         move.l  d1,d7           save drive number */
    move.l d1,d7
/* QL:         move.l  a1,a4           save medium name */
    move.l a1,a4
/* QL:         moveq   #(hp_end+wsend+15)>>4,d1 */
    moveq #(((hp_end+wsend)+15)>>4),d1
/* QL:         asl.w   #4,d1           allocate workspace */
    asl.w #4,d1
/* QL:         jsr     mm_alchp(pc) */
    jsr mm_alchp(pc)
/* QL:         bne.s   anrts */
    bne.s anrts
/* QL:         lea     hp_end(a0),a5   set base of workspace proper */
    lea hp_end(a0),a5
/* QL: * Preset sector header */
/* QL: * We've gone back to writing sector 255, but we'll actually fail the format */
/* QL: * if we see it, or 254, after verify, as it means the tape's running too slow! */
/* QL:         move.l  a5,a0           set start of sector header */
    move.l a5,a0
/* QL:         subq.w  #1,(a0)+        flag ff, sector ff (use ff as format fail, lwr) */
    subq.w #1,(a0)+
/* QL:         moveq   #-dvl,d3 */
    moveq #(-dvl),d3
/* QL:         add.w   (a4)+,d3        get number of characters after mdvn_ */
    add.w (a4)+,d3
/* QL:         addq.l  #dvl,a4         skip past device part */
    addq.l #dvl,a4
/* QL:         moveq   #nml-1,d1       copy/pad name chars */
    moveq #(nml-1),d1
/* QL: put_name */
put_name:
/* QL:         moveq   #' ',d2         pad with blanks */
    moveq #32,d2
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         blt.s   put_char */
    blt.s put_char
/* QL:         move.b  (a4)+,d2        get character of name */
    move.b (a4)+,d2
/* QL: put_char */
put_char:
/* QL:         move.b  d2,(a0)+ */
    move.b d2,(a0)+
/* QL:         dbra    d1,put_name */
    dbra d1,put_name
/* QL:         move.w  sv_rand(a6),(a0)+ and random number */
    move.w sv_rand(a6),(a0)+
/* QL: * Preset format block */
/* QL:  wdcs st_free 0 1 */
/* QL: wd setnum [m]<<8![l] */
/* QL: cs setnum (([m])+([l]))*([n])+$f0f */
/* QL: cs setnum ([cs]&255)<<8![cs]>>8&255 */
/* QL:         move.l  #[wd]<<16![cs],(a0)+ empty / block 0 / checksum */
    move.l #((64768<<16)|16),(a0)+
/* QL:         addq.l  #bldata-blpre-2,a0 preamble mainly zeroes */
.word 20616|(((((bldata-blpre)-2))&7)<<9)
/* QL:         subq.w  #1,(a0)+        finishing with 2 bytes of ones for sync */
    subq.w #1,(a0)+
/* QL:         move.w  #(blend-bldata)/2-1,d1 fill data and extra bytes */
    move.w #(((blend-bldata)/2)-1),d1
/* QL:  wdcs $aa $55 bdl/2 */
/* QL: wd setnum [m]<<8![l] */
/* QL: cs setnum (([m])+([l]))*([n])+$f0f */
/* QL: cs setnum ([cs]&255)<<8![cs]>>8&255 */
/* QL: fil_mem */
fil_mem:
/* QL:         move.w  #[wd],(a0)+ */
    move.w #43605,(a0)+
/* QL:         dbra    d1,fil_mem */
    dbra d1,fil_mem
/* QL:         move.w  #[cs],blcs(a5) */
    move.w #14,blcs(a5)
/* QL: * Now start the format */
/* QL:         move.w  d7,d1           restore drive number */
    move.w d7,d1
/* QL:         lea     pc_mctrl,a3     set address of microdrive control register */
    lea pc_mctrl,a3
/* QL:         moveq   #pc.mdvmd,d0    set microdrive mode */
    moveq #pc.mdvmd,d0
/* QL:         jsr     ss_wser(pc)     and wait for RS232 to complete */
    jsr ss_wser(pc)
/* QL:         move    sr,-(sp)        save current interrupt level */
    move sr,-(sp)
/* QL:         or.w    #$0700,sr       disable interrupts */
    or.w #0x0700,sr
/* QL:         jsr     md_selec(pc)    select drive */
    jsr md_selec(pc)
/* QL:         delay   500000          wait half a second */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL:  ifnum [us] < 4177923 goto swap8 */
/* QL: swap8 maclab 0.229 to 4.162 step 0.033 seconds */
/* QL:  moveq #([us]*15+245720)/491520,d0 eight byte coarse sequence */
    moveq #(((500000*15)+245720)/491520),d0
/* QL:  swap d0 */
    swap d0
/* QL:  subq.l #8,d0 */
    subq.l #8,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.b  #pc.erase,(a3)  erase on */
    move.b #(pc.erase&255),(a3)
/* QL: write_lp */
write_lp:
/* QL:         move.l  a5,a1           08    reset pointer */
    move.l a5,a1
/* QL:         moveq   #shend-shbeg-1,d1 08  write sector header */
    moveq #((shend-shbeg)-1),d1
/* QL:         delay   (2840-85)       gap allows for jsr and final wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #((((2840-85)*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         jsr     md_wblok(pc) */
    jsr md_wblok(pc)
/* QL:         move.w  #blend-blbeg-1,d1 16 write specially long block */
    move.w #((blend-blbeg)-1),d1
/* QL:         delay   (2840-80)       gap allows for jsr and final wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #((((2840-80)*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         jsr     md_wblok(pc) */
    jsr md_wblok(pc)
/* QL:         subq.b  #1,sno-map(a1)  24+16 next sector number */
    subq.b #1,(sno-map)(a1)
/* QL:         bcc.s   write_lp        12/18 last sector is 0 */
    bcc.s write_lp
/* QL:         move.b  #pc.read,(a3)   erase off */
    move.b #(pc.read&255),(a3)
/* QL: * Now verify */
/* QL:         clr.l   -(sp)           clear counts of sectors */
    clr.l -(sp)
/* QL:         moveq   #-1,d5          two counts of 255 (reduced by one by lwr) */
    moveq #(-1),d5
/* QL: ver_loop */
ver_loop:
/* QL:         subq.b  #1,d5 */
    subq.b #1,d5
/* QL:         bcs.s   err_fmt1 */
    bcs.s err_fmt1
/* QL:         move.l  a5,a1 */
    move.l a5,a1
/* QL:         jsr     md_sectr(pc)    find sector */
    jsr md_sectr(pc)
/* QL: err_fmt1 */
err_fmt1:
/* QL:         bra.s   err_fmt2        no signal */
    bra.s err_fmt2
/* QL:         bra.s   ver_loop        not a sector header */
    bra.s ver_loop
/* QL:         jsr     md_veril(pc)    verify long block */
    jsr md_veril(pc)
/* QL:         bra.s   ver_loop        bad block */
    bra.s ver_loop
/* QL:         add.w   d7,d7           address of entry in map */
    add.w d7,d7
/* QL:         addq.b  #1,0(a1,d7.w)   check sector flag */
    addq.b #1,0(a1,d7.w)
/* QL:         blt.s   err_fmt2        horrid if we've already seen it twice! lwr */
    blt.s err_fmt2
/* QL:         subq.b  #2,0(a1,d7.w)   decrement sector flag */
    subq.b #2,0(a1,d7.w)
/* QL:         move.l  d7,d2           is this sector 0? (and clear msw of d2) */
    move.l d7,d2
/* QL:         bne.s   ver_loop        no - carry on */
    bne.s ver_loop
/* QL:         lsr.w   #8,d5           was this first time round? */
    lsr.w #8,d5
/* QL:         bne.s   ver_loop        once round again */
    bne.s ver_loop
/* QL: * All sectors verified up to twice - check the map (a1 is pointing at it) */
/* QL: * Blot out sectors on either side of a bad sector. Pretend 256 is bad (lwr) */
/* QL:         add.w   #bdl-4,a1       point to entries 254 and 255 of map */
    add.w #(bdl-4),a1
/* QL:         tst.l   (a1)+           did we see either of sectors 254 or 255? */
    tst.l (a1)+
/* QL:         bne.s   err_fmt2        if so, the tape's running disastrously slow! */
    bne.s err_fmt2
/* QL: chk_bad */
chk_bad:
/* QL:         swap    d7              roll the previous flag */
    swap d7
/* QL:         move.w  -(a1),d7        is this a bad sector? */
    move.w -(a1),d7
/* QL:         asr.w   #1,d7           remember it as $ffxx if it's ok, $00xx if bad */
    asr.w #1,d7
/* QL:         and.l   d7,(a1)         zap neigbours of un-seen sectors */
    and.l d7,(a1)
/* QL:         subq.b  #1,d5 */
    subq.b #1,d5
/* QL:         bne.s   chk_bad         test all sectors (note extra 2 bytes on map) */
    bne.s chk_bad
/* QL: * Now convert to proper flags and count them up */
/* QL: chk_loop */
chk_loop:
/* QL:         subq.b  #1,(a1)         make bad sector ff, dodgy fe, good fd */
    subq.b #1,(a1)
/* QL:         bcs.s   chk_end         bad */
    bcs.s chk_end
/* QL:         moveq   #1,d7 */
    moveq #1,d7
/* QL:         and.b   (a1),d7         which is it? (good:d1=1, dodgy:d1=0) */
    and.b (a1),d7
/* QL:         add.w   d7,(sp)         good, increment count of good sectors */
    add.w d7,(sp)
/* QL:         move.b  d5,d2           save highest sector number */
    move.b d5,d2
/* QL: chk_end */
chk_end:
/* QL:         addq.l  #2,a1           move to next entry in map */
    addq.l #2,a1
/* QL:         addq.b  #1,d5 */
    addq.b #1,d5
/* QL:         bne.s   chk_loop        beyond 255? */
    bne.s chk_loop
/* QL:         addq.l  #1,d2           total sectors = highest + 1 */
    addq.l #1,d2
/* QL:         add.l   d2,(sp)         we made sure msw was zero earlier */
    add.l d2,(sp)
/* QL:         cmp.w   #200,(sp)       how many good blocks? */
    cmp.w #200,(sp)
/* QL:         blt.s   err_fmt2        fail if less than 200 */
    blt.s err_fmt2
/* QL: * Check for number of good sectors = total number of sectors, as this implies */
/* QL: * the splice hasn't been seen! (Or by shear coincidence, was just after sector */
/* QL: * zero, which is just about the worst place it could be!) */
/* QL:         cmp.w   (sp),d2         check it */
    cmp.w (sp),d2
/* QL:         beq.s   err_fmt2        fail format if no bad 'uns */
    beq.s err_fmt2
/* QL: * Write map sector */
/* QL:         moveq   #st_free-256,d1 */
    moveq #(st_free-256),d1
/* QL:         lea     map(a5),a1      reset to start of map */
    lea map(a5),a1
/* QL:         cmp.b   (a1),d1         is sector zero good? */
    cmp.b (a1),d1
/* QL:         bne.s   err_fmt2        no - that's a disaster */
    bne.s err_fmt2
/* QL:         subq.b  #st_free-st_map,(a1) set sector zero to special file */
    subq.b #(st_free-st_map),(a1)
/* QL:         subq.b  #8,d2           leave a little bit of space before directory */
    subq.b #8,d2
/* QL:         add.w   d2,d2           address table in words */
    add.w d2,d2
/* QL: chk_free */
chk_free:
/* QL:         subq.w  #2,d2           down one */
    subq.w #2,d2
/* QL:         cmp.b   0(a1,d2.w),d1   vacant ? */
    cmp.b 0(a1,d2.w),d1
/* QL:         bne.s   chk_free */
    bne.s chk_free
/* QL:         clr.b   0(a1,d2.w)      set file 0 */
    clr.b 0(a1,d2.w)
/* QL:         move.w  d2,bdl-2(a1)    and say where it is (sector 255 slot) */
    move.w d2,(bdl-2)(a1)
/* QL:         lsl.w   #8-1,d2         tuck directory sector number into msb */
    lsl.w #(8-1),d2
/* QL: putit */
putit:
/* QL:         jsr     md_fsect(pc)    find the sector */
    jsr md_fsect(pc)
/* QL: err_fmt2 */
err_fmt2:
/* QL:         bra.s   err_fmt3 */
    bra.s err_fmt3
/* QL:         lea     map(a5),a1      reset to start of buffer */
    lea map(a5),a1
/* QL:         move.w  (a1),-(sp)      first word holds file/block (dir = 0/0) */
    move.w (a1),-(sp)
/* QL:         jsr     md_write(pc) */
    jsr md_write(pc)
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL:         moveq   #0,d7           good return */
    moveq #0,d7
/* QL:         lsr.w   #8,d2           have we written the directory yet? */
    lsr.w #8,d2
/* QL:         beq.s   desel           yes - all done */
    beq.s desel
/* QL: * Write empty directory */
/* QL: clr_dir */
clr_dir:
/* QL:         clr.l   -(a1)           clear directory (we should have time for this) */
    clr.l -(a1)
/* QL:         addq.b  #256*4/bdl,d7 */
    addq.b #((256*4)/bdl),d7
/* QL:         bne.s   clr_dir */
    bne.s clr_dir
/* QL:         moveq   #64,d1 */
    moveq #64,d1
/* QL:         move.l  d1,(a1)         set length */
    move.l d1,(a1)
/* QL:         bra.s   putit           write directory */
    bra.s putit
/* QL: err_fmt3 */
err_fmt3:
/* QL:         moveq   #err.ff,d7      format failed */
    moveq #err.ff,d7
/* QL: desel */
desel:
/* QL:         jsr     md_desel(pc)    deselect drive */
    jsr md_desel(pc)
/* QL:         lea     -hp_end(a5),a0  return space used */
    lea (-hp_end)(a5),a0
/* QL:         jsr     mm_rechp(pc) */
    jsr mm_rechp(pc)
/* QL:         jsr     ss_rser(pc)     re-enable rs232 */
    jsr ss_rser(pc)
/* QL:         movem.w (sp)+,d1-d2     get good/total sector counts */
    movem.w (sp)+,d1-d2
/* QL:         move    (sp)+,sr        reinstate interrupts */
    move (sp)+,sr
/* QL:         move.l  d7,d0           set error return */
    move.l d7,d0
/* QL:         rts */
    rts 
/* QL:         end */
