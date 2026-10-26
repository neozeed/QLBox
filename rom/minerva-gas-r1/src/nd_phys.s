/* Generated from original/M/nd/phys.asm */
/* QL: * Network physical layer */
/* QL:         xdef    nd_rpac,nd_spac */
.globl nd_rpac,nd_spac
/* QL:         xref    ss_rser,ss_wser */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
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
/* QL:         include 'win1_m_inc_net' */
/* QL: * net data block definition */
/* QL:         nolist */
/* QL:         offset  $18 (end of basic channel definition) */
/* QL: net_hedr ; network packet header */
.equ net_hedr,24
/* QL: net_dest ds.b   1       destination station number */
.equ net_dest,24
/* QL: net_self ds.b   1       own station number */
.equ net_self,25
/* QL: net_blkl ds.b   1       data block number (low byte) */
.equ net_blkl,26
/* QL: net_blkh ds.b   1       data block number (high byte) */
.equ net_blkh,27
/* QL: net_type ds.b   1       send blocks: 0=not eof 1=eof */
.equ net_type,28
/* QL: net_nbyt ds.b   1       number of bytes sent or received */
.equ net_nbyt,29
/* QL: net_dchk ds.b   1       data checksum */
.equ net_dchk,30
/* QL: net_hchk ds.b   1       header checksum */
.equ net_hchk,31
/* QL: net_data ds.b   255     data block */
.equ net_data,32
/* QL: net_rpnt ds.b   1       running pointer to data block */
.equ net_rpnt,287
/* QL: net_end ; length of data definition block */
.equ net_end,288
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
/* QL:         section nd_phys */
.section nd_phys,"ax"
/* QL: * d0 -  o- error code, and sr set */
/* QL: * a0 -ip - channel definition block */
/* QL: * a2 -  o- pointer transmit control register */
/* QL: * a3 -  o- pointer to microdrive/link register */
/* QL: * d1-d3/a1 destroyed */
/* QL: reglist reg     d5-d7 */
/* QL: * Calculate checksum */
/* QL: csumdata */
csumdata:
/* QL:         move.b  net_nbyt(a0),d1 get byte count */
    move.b net_nbyt(a0),d1
/* QL:         lea     net_data(a0),a1 address of data */
    lea net_data(a0),a1
/* QL: checksum */
checksum:
/* QL:         moveq   #0,d7           initialise checksum */
    moveq #0,d7
/* QL: chks_byt */
chks_byt:
/* QL:         add.b   (a1)+,d7        add byte to checksum */
    add.b (a1)+,d7
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         bne.s   chks_byt        next byte */
    bne.s chks_byt
/* QL:         rts */
    rts 
/* QL: * Set up on entry */
/* QL: entry */
entry:
/* QL:         move.l  (sp)+,a1        get return address off stack */
    move.l (sp)+,a1
/* QL:         lea     pc_mctrl,a3     set up pc register addresses */
    lea pc_mctrl,a3
/* QL:         lea     pc_tctrl-pc_mctrl(a3),a2 */
    lea (pc_tctrl-pc_mctrl)(a3),a2
/* QL:         moveq   #pc.netmd,d0    set up in network mode */
    moveq #pc.netmd,d0
/* QL:         moveq   #1<<pc..serb,d3 internally, we want d3 permanently zero */
    moveq #(1<<pc..serb),d3
/* QL:         and.b   sv_tmode(a6),d3 is it in actually in rs232 mode */
    and.b sv_tmode(a6),d3
/* QL:         bne.s   err_ne3         yes - leave this until serial o/p has cleared */
    bne.s err_ne3
/* QL:         jsr     ss_wser(pc)     wait for serial to complete */
    jsr ss_wser(pc)
/* QL:         move    sr,-(sp)        save interrupt status */
    move sr,-(sp)
/* QL:         or.w    #$0700,sr       disable interrupts */
    or.w #0x0700,sr
/* QL:         movem.l reglist,-(sp)   save registers */
    movem.l d5-d7,-(sp)
/* QL:         jsr     (a1)            call the return address */
    jsr (a1)
/* QL:         movem.l (sp)+,reglist   reload registers */
    movem.l (sp)+,d5-d7
/* QL:         jsr     ss_rser(pc)     return to serial mode */
    jsr ss_rser(pc)
/* QL:         move.w  (sp)+,sr        restore interrupt state */
    move.w (sp)+,sr
/* QL:         tst.l   d0              set condition codes */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * Send packet */
/* QL: nd_spac */
nd_spac:
/* QL:         bsr.s   entry           set up */
    bsr.s entry
/* QL:         bsr.s   csumdata        calculate data checksum */
    bsr.s csumdata
/* QL:         move.b  d7,net_dchk(a0) save it */
    move.b d7,net_dchk(a0)
/* QL:         moveq   #net_hchk-net_hedr,d1 sum bytes of header for checksum */
    moveq #(net_hchk-net_hedr),d1
/* QL:         lea     net_hedr(a0),a1 */
    lea net_hedr(a0),a1
/* QL:         bsr.s   checksum        calculate header checksum */
    bsr.s checksum
/* QL:         move.b  d7,(a1)         and save it in the next location */
    move.b d7,(a1)
/* QL:         subq.l  #net_hchk-net_hedr,a1 restore a1 to point to header */
.word 20873|((((net_hchk-net_hedr))&7)<<9)
/* QL: * Send a scout */
/* QL:         assert  net_hedr,net_self-1 */
/* original assertion: net_hedr,net_self-1 */
/* QL:         move.w  (a1),d6         get station number in lsb */
    move.w (a1),d6
/* QL:         not.b   d6              inverted */
    not.b d6
/* QL:         move.b  sv_tmode(a6),d2 get basic byte to send to xmit reg */
    move.b sv_tmode(a6),d2
/* QL:         moveq   #10-1,d1        send station number, 2*inactive: 10 bit */
    moveq #(10-1),d1
/* QL:         moveq   #115,d0 */
    moveq #115,d0
/* QL:         mulu    sv_rand(a6),d0 */
    mulu sv_rand(a6),d0
/* QL:         move.w  d0,sv_rand(a6)  set up random wait >3ms=536 loops */
    move.w d0,sv_rand(a6)
/* QL:         ext.w   d0              ... d0 becomes -128 to 127 */
    ext.w d0
/* QL:         add.w   #536+128-1,d0   ... now 536-1 to 891-1, 3 to 5.7 ms */
    add.w #((536+128)-1),d0
/* QL: ss_wait */
ss_wait:
/* QL:         btst    d3,(a3)         12 check if net is idle */
    btst d3,(a3)
/* QL:         bne.s   err_ne3         12 ... no it's not */
    bne.s err_ne3
/* QL:         dbra    d0,ss_wait   18/26 loop is 42-48 cycles 5.6 us min */
    dbra d0,ss_wait
/* QL: ss_bit */
ss_bit:
/* QL:         lsl.b   #1,d6           12 get next bit out of station number */
    lsl.b #1,d6
/* QL:         rol.b   #1,d2           12 */
    rol.b #1,d2
/* QL:         roxr.b  #1,d2           12 and put it in basic byte */
    roxr.b #1,d2
/* QL:         move.b  d2,(a2)         12 send next bit */
    move.b d2,(a2)
/* QL:         bmi.s   ss_activ     18/12 if output is active - cannot test */
    bmi.s ss_activ
/* QL:         moveq   #6-1,d0         08 test output 6 times */
    moveq #(6-1),d0
/* QL: ss_test */
ss_test:
/* QL:         btst    d3,(a3)         12 check if network is active */
    btst d3,(a3)
/* QL:         beq.s   ss_tdbra        18 funny test to make loop n*12 */
    beq.s ss_tdbra
/* QL: err_ne3 */
err_ne3:
/* QL:         bra.s   err_ne2         ... oops */
    bra.s err_ne2
/* QL: ss_tdbra */
ss_tdbra:
/* QL:         dbra    d0,ss_test   18/26 loop is 48 cycles long */
    dbra d0,ss_test
/* QL:         bra.s   ss_next         18 */
    bra.s ss_next
/* QL: ss_activ */
ss_activ:
/* QL:         moveq   #17-1,d0        08 wait a bit */
    moveq #(17-1),d0
/* QL:         dbra    d0,*           314 */
    dbra d0,.
/* QL: ss_next */
ss_next:
/* QL:         dbra    d1,ss_bit    18/26 bit loop is 402 cycles (active) 412 (test) */
    dbra d1,ss_bit
/* QL: * Scout sent ok */
/* QL:         moveq   #net_data-net_hedr,d1 send header first, bit 15 = header/data */
    moveq #(net_data-net_hedr),d1
/* QL:         bsr.s   output          send header */
    bsr.s output
/* QL:         tst.b   net_dest(a0)    are we doing a broadcast? */
    tst.b net_dest(a0)
/* QL:         beq.s   sp_bcst         yes - we don't want an ack */
    beq.s sp_bcst
/* QL: sp_block */
sp_block:
/* QL:         addq.b  #1,d1           read one byte response */
    addq.b #1,d1
/* QL:         lea     net_data-1(a0),a1 stuff it in end of header block */
    lea (net_data-1)(a0),a1
/* QL:         bsr.l   inpbyte         fetch byte (in both d2 and d7) */
    bsr.w inpbyte
/* QL: err_ne2 */
err_ne2:
/* QL:         bne.s   err_ne1 */
    bne.s err_ne1
/* QL:         subq.b  #1,d7           check if response was acknowledge */
    subq.b #1,d7
/* QL:         bne.s   err_ne1 */
    bne.s err_ne1
/* QL:         not.w   d1              was that the data? */
    not.w d1
/* QL:         bpl.s   inc_blk         yes - go update block count */
    bpl.s inc_blk
/* QL:         bsr.s   outpdata        send data */
    bsr.s outpdata
/* QL:         bra.s   sp_block        go back to get acknowledge */
    bra.s sp_block
/* QL: * Send header/data/acknowledge */
/* QL: * d1 -i o- lsb only: byte count / 0 */
/* QL: * d7 -  o- 0 */
/* QL: * d6 -i o- byte to be sent, bits 15..14 one / $(ffff)ff00 */
/* QL: * a1 -i o- data pointer / updated */
/* QL: * d3/a0/a2/a6 standard */
/* QL: outpdata */
outpdata:
/* QL:         move.b  net_nbyt(a0),d1 send all bytes of data block */
    move.b net_nbyt(a0),d1
/* QL: output */
output:
/* QL:         moveq   #-1,d6          08 preset top byte of word to ones */
    moveq #(-1),d6
/* QL: outb_byt */
outb_byt:
/* QL:         move.b  (a1)+,d6        12+ get next byte */
    move.b (a1)+,d6
/* QL: outpack */
outpack:
/* QL:         lsl.w   #1,d6           12 clear lsb for start flag */
    lsl.w #1,d6
/* QL:         rol.w   #2,d6           14 set two lsbs for leader/stop */
    rol.w #2,d6
/* QL:         moveq   #13,d7          08 13 bits - 2 leader, start, 8 data, 2 stop */
    moveq #13,d7
/* QL:         move.b  sv_tmode(a6),d0 20 set up basic byte to write to xmit reg */
    move.b sv_tmode(a6),d0
/* QL: outb_bit */
outb_bit:
/* QL:         asr.w   #1,d6           12 shift next bit out and bring a one in */
    asr.w #1,d6
/* QL:         addx.b  d0,d0           08 roll it into basic byte lsb */
    addx.b d0,d0
/* QL:         rol.b   #7,d0           24 roll back to bit 7 */
    rol.b #7,d0
/* QL:         move.b  d0,(a2)       12+1 send bit */
    move.b d0,(a2)
/* QL:         subq.w  #1,d7           08 decrement counter */
    subq.w #1,d7
/* QL:         bne.s   outb_bit     18/12 loop is 83 cycles long */
    bne.s outb_bit
/* QL:         subq.b  #1,d1           08 */
    subq.b #1,d1
/* QL:         bne.s   outb_byt     18/12 stop is 4 bits+ a bit */
    bne.s outb_byt
/* QL:         move.b  sv_tmode(a6),(a2) 16 deactivate net */
    move.b sv_tmode(a6),(a2)
/* QL:         rts */
    rts 
/* QL: * Final bits */
/* QL: sp_bcst */
sp_bcst:
/* QL:         delay   500             ; give receiver time to get to reading data */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #(((500*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         bsr.s   outpdata */
    bsr.s outpdata
/* QL:         delay   2000            ; give other end a chance to use the data */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #(((2000*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL: inc_blk */
inc_blk:
/* QL:         addq.b  #1,net_blkl(a0) increment block count */
    addq.b #1,net_blkl(a0)
/* QL:         bcc.s   okrts1 */
    bcc.s okrts1
/* QL:         addq.b  #1,net_blkh(a0) and upper byte */
    addq.b #1,net_blkh(a0)
/* QL: okrts1 */
okrts1:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Receive a packet from the net */
/* QL: nd_rpac */
nd_rpac:
/* QL:         bsr.s   rpac_nc         initially sets nothing read / not end of file */
    bsr.s rpac_nc
/* QL:         bsr.l   entry */
    bsr.w entry
/* QL: * Wait for a gap in transmission */
/* QL: rwait_gp */
rwait_gp:
/* QL:         move.w  #5859-1,d6      give up waiting after 5859*8.5=50ms of active! */
    move.w #(5859-1),d6
/* QL: rwait_2m */
rwait_2m:
/* QL:         move.w  #438-1,d0       16 wait for 438*6.4=2.8ms of solid no activity */
    move.w #(438-1),d0
/* QL: rwait_lp */
rwait_lp:
/* QL:         btst    d3,(a3)         12 is net active */
    btst d3,(a3)
/* QL:         beq.s   rwait_nx        18 no ... decrement gap time counter */
    beq.s rwait_nx
/* QL:         dbra    d6,rwait_2m  18/26 start waiting again, or timeout */
    dbra d6,rwait_2m
/* QL: err_ne1 */
err_ne1:
/* QL:         bra.s   err_nc0         exit if no suitable gap in transmission */
    bra.s err_nc0
/* QL: rwait_nx */
rwait_nx:
/* QL:         dbra    d0,rwait_lp  18/26 48 cycles / 6.4 us loop */
    dbra d0,rwait_lp
/* QL: * Wait for a scout */
/* QL:         move.w  #3125-1,d0      timeout = 3125*6.4=20ms */
    move.w #(3125-1),d0
/* QL: rwait_sc */
rwait_sc:
/* QL:         btst    d3,(a3)         12 wait for beginning of scout */
    btst d3,(a3)
/* QL:         bne.s   got_sc          18 drop out if beginning of scout */
    bne.s got_sc
/* QL:         dbra    d0,rwait_sc  18/26 */
    dbra d0,rwait_sc
/* QL:         bra.s   err_nc0         no scout in 20ms, so return nc */
    bra.s err_nc0
/* QL: * Got the scout - so wait until it has gone away */
/* QL: got_sc */
got_sc:
/* QL:         delay   530             ; wait for end of scout */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #(((530*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         moveq   #net_data-net_hedr,d1 read 8 bytes */
    moveq #(net_data-net_hedr),d1
/* QL:         bsr.s   inpdata         header to data, last byte (hchk) left in d2 */
    bsr.s inpdata
/* QL:         subq.l  #net_data-net_hedr,a1 backspace buffer pointer */
.word 20873|((((net_data-net_hedr))&7)<<9)
/* QL:         bne.s   rwait_gp        skip if it timed out */
    bne.s rwait_gp
/* QL:         assert  net_hchk,net_data-1 */
/* original assertion: net_hchk,net_data-1 */
/* QL:         sub.b   d2,d7           check checksum (checksum has been summed) */
    sub.b d2,d7
/* QL:         cmp.b   d2,d7 */
    cmp.b d2,d7
/* QL:         bne.s   rwait_gp */
    bne.s rwait_gp
/* QL: * We have seen a valid header, so we don't go back looking for a scout anymore */
/* QL: * since, if the packet isn't for us, we don't want to waste time here with the */
/* QL: * following data block. */
/* QL: * Now check if this packet is for me */
/* QL:         assert  net_hedr,net_dest,net_self-1 */
/* original assertion: net_hedr,net_dest,net_self-1 */
/* QL:         move.w  net_dest(a0),d7 fetch my own station numbers */
    move.w net_dest(a0),d7
/* QL:         ror.w   #8,d7           swap them over */
    ror.w #8,d7
/* QL:         cmp.w   (a1),d7         do source and dest cross match? */
    cmp.w (a1),d7
/* QL:         beq.s   chk_blk         yes - that's great */
    beq.s chk_blk
/* QL:         tst.b   d7              if destination (self) is zero - broadcast */
    tst.b d7
/* QL:         beq.s   chk_dest        yes - check if just destinations match */
    beq.s chk_dest
/* QL:         cmp.b   net_self(a0),d7 is it the 'receive from any' code? */
    cmp.b net_self(a0),d7
/* QL:         bne.s   err_nc0         no - return nc and ioss will try again later */
    bne.s err_nc0
/* QL: chk_dest */
chk_dest:
/* QL:         cmp.b   (a1),d7         do destinations match? */
    cmp.b (a1),d7
/* QL:         bne.s   err_nc0         no - return nc and ioss will try again later */
    bne.s err_nc0
/* QL: * Properly addressed to us, so check if this data block is the one required */
/* QL: chk_blk */
chk_blk:
/* QL:         bsr.s   goodhdr         go sort out valid header */
    bsr.s goodhdr
/* QL:         bne.s   rpac_nc */
    bne.s rpac_nc
/* QL:         cmp.b   net_dchk(a0),d7 check checksum */
    cmp.b net_dchk(a0),d7
/* QL:         bne.s   rpac_nc */
    bne.s rpac_nc
/* QL:         bsr.s   acknwldg        all ok - acknowledge */
    bsr.s acknwldg
/* QL:         tst.w   d5              check this was the right block */
    tst.w d5
/* QL:         beq.s   inc_blk */
    beq.s inc_blk
/* QL: rpac_nc */
rpac_nc:
/* QL:         assert  net_type,net_nbyt-1 */
/* original assertion: net_type,net_nbyt-1 */
/* QL:         clr.w   net_type(a0)    nothing read / not end of file */
    clr.w net_type(a0)
/* QL: err_nc0 */
err_nc0:
/* QL:         moveq   #err.nc,d0      not complete */
    moveq #err.nc,d0
/* QL:         rts */
    rts 
/* QL: * Send acknowledgement */
/* QL: acknwldg */
acknwldg:
/* QL:         moveq   #1,d1           write one byte */
    moveq #1,d1
/* QL:         move.w  #$ff01,d6       the acknowledge byte is a one */
    move.w #0xff01,d6
/* QL:         tst.b   net_dest(a0)    are we receiving a broadcast? */
    tst.b net_dest(a0)
/* QL:         bne.l   outpack         no - go do it */
    bne.w outpack
/* QL: rts9 */
rts9:
/* QL:         rts                     yes - don't bother acknowledging */
    rts 
/* QL: goodhdr */
goodhdr:
/* QL:         assert  net_hedr,net_blkl-2,net_blkh-3 */
/* original assertion: net_hedr,net_blkl-2,net_blkh-3 */
/* QL:         move.l  (a1),d5         fetch incoming block number to lsw */
    move.l (a1),d5
/* QL:         sub.w   net_blkl(a0),d5 and compare against required */
    sub.w net_blkl(a0),d5
/* QL:         bne.s   rblock          if not correct skip it (other missed ack) */
    bne.s rblock
/* QL:         assert  net_type,net_nbyt-1,net_dchk-2,net_hchk-3,net_data-4 */
/* original assertion: net_type,net_nbyt-1,net_dchk-2,net_hchk-3,net_data-4 */
/* QL:         move.l  net_type-net_hedr(a1),-(a1) copy flag, nbytes etc */
    move.l (net_type-net_hedr)(a1),-(a1)
/* QL: * If the acknowledges fail, or the data's bad, we'll have to clear this again */
/* QL: rblock */
rblock:
/* QL:         bsr.s   acknwldg        acknowledge header */
    bsr.s acknwldg
/* QL:         move.b  net_nbyt(a0),d1 set up number of bytes to read */
    move.b net_nbyt(a0),d1
/* QL: * Drop through to read the data bytes */
/* QL: * Read a block from the net and accumulate checksum */
/* QL: inpdata */
inpdata:
/* QL:         lea     net_data(a0),a1 put it in data block */
    lea net_data(a0),a1
/* QL: inpbyte */
inpbyte:
/* QL:         moveq   #0,d7           clear checksum */
    moveq #0,d7
/* QL:         move.w  #400,d0         wait for active up to 400*48 cycles 2.56 ms */
    move.w #400,d0
/* QL: i_wnext */
i_wnext:
/* QL:         dbra    d0,i_wait    18/26 loop 48 cycles */
    dbra d0,i_wait
/* QL:         bra.s   err_nc0            exit if timed out */
    bra.s err_nc0
/* QL: i_bytwt */
i_bytwt:
/* QL:         btst    d3,(a3)         12 wait for start bit */
    btst d3,(a3)
/* QL:         dbeq    d6,i_bytwt   18/26/20 loop is 30 cycles */
    dbeq d6,i_bytwt
/* QL:         bne.s   err_nc0         12 not complete if no start bit found */
    bne.s err_nc0
/* QL:         moveq   #8-1,d6         08 read 8 bits */
    moveq #(8-1),d6
/* QL:         moveq   #0,d0           08 one shot at validating stop bit / ok exit */
    moveq #0,d0
/* QL:         ror.b   #4,d3           18 delay */
    ror.b #4,d3
/* QL: i_bit */
i_bit:
/* QL:         ror.l   #8,d2           28 save bits so far at msb, and delay */
    ror.l #8,d2
/* QL:         move.b  (a3),d2         12 read bit (106..117 cycles since start bit) */
    move.b (a3),d2
/* QL:         rol.l   #7,d2           26 construct byte */
    rol.l #7,d2
/* QL:         dbra    d6,i_bit     18/26 loop is 84 cycles */
    dbra d6,i_bit
/* QL:         move.b  d2,(a1)+        12+ store byte */
    move.b d2,(a1)+
/* QL:         add.b   d2,d7           08 accumulate checksum */
    add.b d2,d7
/* QL:         subq.b  #1,d1           08 */
    subq.b #1,d1
/* QL:         beq.s   rts9            12 exit ok, all done */
    beq.s rts9
/* QL: * Now validate 1st (or 2nd) stop bit, 104 cycles after last test */
/* QL: i_wait */
i_wait:
/* QL:         btst    d3,(a3)         12 is net active yet */
    btst d3,(a3)
/* QL:         beq.s   i_wnext      18/12 funny test to make wait loop n*48 */
    beq.s i_wnext
/* QL:         moveq   #71-1,d6        08 give up after about 30*71 cycles (2 bytes) */
    moveq #(71-1),d6
/* QL:         bra.s   i_bytwt         18 */
    bra.s i_bytwt
/* QL:         end */
