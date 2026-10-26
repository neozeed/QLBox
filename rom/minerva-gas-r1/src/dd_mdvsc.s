/* Generated from original/M/dd/mdvsc.asm */
/* QL: * Microdrive scatter load */
/* QL:         xdef   dd_mdvsc */
.globl dd_mdvsc
/* QL:         xref   dd_mdvnb */
/* QL:         xref   md_read,md_sectr,md_slave */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
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
/* QL:         include 'win1_m_inc_fs' */
/* QL: * file system definitions */
/* QL:         nolist */
/* QL: fs.nmlen  equ    36     max length of file name */
.equ fs.nmlen,36
/* QL: fs.hdlen  equ    64     length of file system header */
.equ fs.hdlen,64
/* QL: * file system channel channel definition block */
/* QL:         offset  $18 ( = ch_end, end of standard channel header ) */
/* QL: fs_next ds.l    1       link to next file system channel */
.equ fs_next,24
/* QL: fs_acces ds.b   1       access mode */
.equ fs_acces,28
/* QL: fs_drive ds.b   1       drive id */
.equ fs_drive,29
/* QL: fs_filnr ds.w   1       file number */
.equ fs_filnr,30
/* QL: fs_nblok ds.w   1       block containing next byte */
.equ fs_nblok,32
/* QL: fs_nbyte ds.w   1       next byte in block */
.equ fs_nbyte,34
/* QL: fs_eblok ds.w   1       end of file (block) */
.equ fs_eblok,36
/* QL: fs_ebyte ds.w   1       end of file (byte in block) */
.equ fs_ebyte,38
/* QL: fs_cblok ds.l   1       pointer to table for current slave block */
.equ fs_cblok,40
/* QL: fs_updt ds.b    1       set if file is updated */
.equ fs_updt,44
/* QL:         ds.b    5       spare */
/* QL: fs_fname ds.w   1+fs.nmlen/2  length prefixed file name */
.equ fs_fname,50
/* QL: fs_spare ds.b   72 */
.equ fs_spare,88
/* QL: fs_end */
.equ fs_end,160
/* QL: * common part of a physical file system definition block */
/* QL:         offset  0 */
/* QL:         ds.b    $10 */
/* QL: fs_drivr ds.l   1       pointer to driver */
.equ fs_drivr,16
/* QL: fs_drivn ds.b   1       drive number */
.equ fs_drivn,20
/* QL:         ds.b    1 */
/* QL: fs_mname ds.w   1+10/2  length prefixed medium name */
.equ fs_mname,22
/* QL: fs_files ds.b   1       number of files open */
.equ fs_files,34
/* QL: * file system trap #3 codes */
/* QL: fs.check  equ    $40                check all pending operations */
.equ fs.check,0x40
/* QL: fs.flush  equ    $41                flush buffers */
.equ fs.flush,0x41
/* QL: fs.posab  equ    $42                position file pointer (absolute) */
.equ fs.posab,0x42
/* QL: fs.posre  equ    $43                position file pointer (relative) */
.equ fs.posre,0x43
/* QL: fs.mdinf  equ    $45                information about medium */
.equ fs.mdinf,0x45
/* QL: fs.heads  equ    $46                set file header */
.equ fs.heads,0x46
/* QL: fs.headr  equ    $47                read file header */
.equ fs.headr,0x47
/* QL: fs.load   equ    $48                load file */
.equ fs.load,0x48
/* QL: fs.save   equ    $49                save file */
.equ fs.save,0x49
/* QL: fs.renam  equ    $4a                rename file */
.equ fs.renam,0x4a
/* QL: fs.trunc  equ    $4b                truncate file */
.equ fs.trunc,0x4b
/* QL:         list */
/* QL:         include 'win1_m_inc_md' */
/* QL: * microdrive physical layer definition */
/* QL:         nolist */
/* QL:         offset  $10 */
/* QL: md_drivr ds.l   1       pointer to driver */
.equ md_drivr,16
/* QL: md_drivn ds.b   1       drive number */
.equ md_drivn,20
/* QL:         ds.b    1       spare */
/* QL: md_mname ds.w   1+10/2  length prefixed medium name and check number */
.equ md_mname,22
/* QL: md_files ds.b   1       number of files open */
.equ md_files,34
/* QL: md_estat ds.b   1       error status 0=ok -1=bad */
.equ md_estat,35
/* QL: md_fail ds.b    1       failure count */
.equ md_fail,36
/* QL:         ds.b    3       spare */
/* QL: md_map  ds.w    255     microdrive map (fe bad, fd vac, fc pending delete) */
.equ md_map,40
/* QL: md_lsect ds.w   1       last sector allocated. */
.equ md_lsect,550
/* QL: md_pendg ds.w   256     pending operations: 0 no, >0 slave block nr */
.equ md_pendg,552
/* QL:                                         ;   -1 write map, -2 verify map */
/* QL: md_end */
.equ md_end,1064
/* QL: * directory structure definitions */
/* QL:         offset  0 */
/* QL: md_delen ds.l   1       length */
.equ md_delen,0
/* QL: md_deacs ds.b   1       access key */
.equ md_deacs,4
/* QL: md_detyp ds.b   1       type */
.equ md_detyp,5
/* QL: md_deinf ds.l   2       information (data space first) */
.equ md_deinf,6
/* QL: md_denam ds.w   1+36/2  length prefixed file name */
.equ md_denam,14
/* QL: md_deupd ds.l   1       update date */
.equ md_deupd,52
/* QL:          ds.w   2       unit and version */
/* QL: md_debkd ds.l   1       backup date */
.equ md_debkd,60
/* QL: md_deend */
.equ md_deend,64
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
/* QL: maxfail equ     7               maximum full rotations before giving up */
.equ maxfail,7
/* QL: maplen  equ     256             one bit for every possible block number */
.equ maplen,256
/* QL: bitmap  equ     fs_spare        b*32 spare for bitmap */
.equ bitmap,fs_spare
/* QL: remain  equ     bitmap+maplen/8 b one less than blocks still needing read */
.equ remain,(bitmap+(maplen/8))
/* QL: lstblok equ     remain+1        b last occupied block number (0..255) */
.equ lstblok,(remain+1)
/* QL: lstbyte equ     lstblok+1       w size (1..512) of last block */
.equ lstbyte,(lstblok+1)
/* QL: hdrbuf  equ     lstbyte+2       b*14 buffer for sector header */
.equ hdrbuf,(lstbyte+2)
/* QL: blkbits equ     9 */
.equ blkbits,9
/* QL: blksize equ     1<<blkbits */
.equ blksize,(1<<blkbits)
/* QL: btbits  equ     3 */
.equ btbits,3
/* QL:         assert  1<<btbits,bt_end */
/* original assertion: 1<<btbits,bt_end */
/* QL:         section dd_mdvsc */
.section dd_mdvsc,"ax"
/* QL: * lwr's notes: */
/* QL: * This scatter load always reads the whole file, ignoring any current position */
/* QL: * and requested length, plus it crashes if the buffer address supplied is odd. */
/* QL: * Also, the caller has probably just read the header and therefore the first */
/* QL: * two blocks will usually already be available in slave blocks. It seems stupid */
/* QL: * that a load reads them twice! */
/* QL: * A better system all round would be for the normal serial io.fstrg to do any */
/* QL: * slave blocks that are already available, then using this to load the rest, */
/* QL: * the bulk of which would be direct reads to the user's buffer area, exceptions */
/* QL: * being any odd bytes in the first and last blocks. */
/* QL: * Finally, I wonder if anyone would notice if the supplied start/length were */
/* QL: * used, particularly as they are already used if the requested length is less */
/* QL: * than the magic number 4096 (actually, the size that requires about one */
/* QL: * revolution of the tape, given the standard interleave), when the i/o routine */
/* QL: * doesn't even come here! */
/* QL: * P.S. Wouldn't it be even nicer if the mdv stuff kept track of roughly which */
/* QL: * sector on the tape it was at? */
/* QL: * d0 -  o- error code */
/* QL: * d2 -i  - requested length (not used!) */
/* QL: * d6 -i  - drive id * 16 + 1<<bt..file */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i o- user buffer */
/* QL: * a2 -ip - physical definition */
/* QL: * d1-d7/a3-a5 destroyed */
/* QL: * Locally: */
/* QL: * d0-d4/d6 used by md routines */
/* QL: * d5 pointer to bit in file map */
/* QL: * d7 current block number / address rel to a1 */
/* QL: * a3 microdrive control register */
/* QL: * a4 slave block (set by dd_mdvnb) */
/* QL: * a5 file map etc. */
/* QL: reglist reg     a0-a2/a4 */
/* QL: dd_mdvsc */
dd_mdvsc:
/* QL:         jsr     dd_mdvnb(pc)    find a slave block */
    jsr dd_mdvnb(pc)
/* QL:         subq.l  #bt_end,sv_btpnt(a6) and free it straight after use */
    subq.l #bt_end,sv_btpnt(a6)
/* QL: * Note. The above causes scans for free blocks to find this block straight off. */
/* QL: * As memory allocation is not allowed when interrupted code in in supervisor */
/* QL: * mode, we'll not lose it. */
/* QL:         move.l  a4,d5           calculate address of slave block */
    move.l a4,d5
/* QL:         sub.l   sv_btbas(a6),d5 ... take away base of tables */
    sub.l sv_btbas(a6),d5
/* QL:         lsl.l   #blkbits-btbits,d5 divided by bt_end, multiplied by block size */
    lsl.l #(blkbits-btbits),d5
/* QL:         move.l  d5,a4 */
    move.l d5,a4
/* QL:         add.l   a6,a4           plus base of memory */
    add.l a6,a4
/* QL:         jsr     md_slave(pc)    start drive and d0 = err.nc */
    jsr md_slave(pc)
/* QL:         lea     pc_mctrl,a3 */
    lea pc_mctrl,a3
/* QL:         and.b   #$ff-pc.maskg,sv_pcint(a6) stop server killing drive */
    and.b #((0xff-pc.maskg)&255),sv_pcint(a6)
/* QL:         move.b  sv_pcint(a6),pc_intr-pc_mctrl(a3) */
    move.b sv_pcint(a6),(pc_intr-pc_mctrl)(a3)
/* QL: * We'll get on with sommat else for a moment ... */
/* QL:         assert  fs_eblok,fs_ebyte-2 */
/* original assertion: fs_eblok,fs_ebyte-2 */
/* QL:         move.l  fs_eblok(a0),d2 get last block/byte */
    move.l fs_eblok(a0),d2
/* QL:         assert  fs_nblok,fs_nbyte-2 */
/* original assertion: fs_nblok,fs_nbyte-2 */
/* QL:         move.l  d2,fs_nblok(a0) set current block/byte (always to eof) */
    move.l d2,fs_nblok(a0)
/* QL:         subq.l  #1,d2 */
    subq.l #1,d2
/* QL:         and.w   #blksize-1,d2 */
    and.w #(blksize-1),d2
/* QL:         addq.w  #1,d2           convert to: last active block / byte 1-blksize */
    addq.w #1,d2
/* QL:         assert  bitmap+maplen/8,remain,lstblok-1,lstbyte-2 */
/* original assertion: bitmap+maplen/8,remain,lstblok-1,lstbyte-2 */
/* QL:         lea     remain(a0),a5 */
    lea remain(a0),a5
/* QL:         move.l  d2,(a5) save it */
    move.l d2,(a5)
/* QL:         swap    d2              get last active block number */
    swap d2
/* QL:         move.b  d2,(a5)         put extra block counter */
    move.b d2,(a5)
/* QL:         moveq   #maplen/8/4-1,d5 */
    moveq #(((maplen/8)/4)-1),d5
/* QL: lop_fmap */
lop_fmap:
/* QL:         clr.l   -(a5)           clear bitmap of file map */
    clr.l -(a5)
/* QL:         dbra    d5,lop_fmap */
    dbra d5,lop_fmap
/* QL:         moveq   #7,d5 */
    moveq #7,d5
/* QL:         and.b   d2,d5           remember odd bits */
    and.b d2,d5
/* QL:         lsr.w   #3,d2           for every complete 8 blocks */
    lsr.w #3,d2
/* QL:         bra.s   smap_dbr */
    bra.s smap_dbr
/* QL: smap_lop */
smap_lop:
/* QL:         st      (a5)+           set bitmap bits for those blocks not yet read */
    st (a5)+
/* QL: smap_dbr */
smap_dbr:
/* QL:         dbra    d2,smap_lop */
    dbra d2,smap_lop
/* QL:         addq.b  #2,d2           make d2 = $ff01 */
    addq.b #2,d2
/* QL:         rol.w   d5,d2 */
    rol.w d5,d2
/* QL:         move.b  d2,(a5)         set bitmap bits for last 1..8 blocks of file */
    move.b d2,(a5)
/* QL: * Is the right drive running now? */
/* QL:         cmp.b   sv_mdrun(a6),d1 is the right drive running? */
    cmp.b sv_mdrun(a6),d1
/* QL:         bne     ena_gap         no - we'll have to wait */
    bne ena_gap
/* QL: * Now start reading all the blocks of the file */
/* QL:         movem.l reglist,-(sp) */
    movem.l a0-a2/a4,-(sp)
/* QL: * We have seen sector zero - see if we have a failure to read file */
/* QL: inc_fail */
inc_fail:
/* QL:         addq.b  #1,md_fail(a2) */
    addq.b #1,md_fail(a2)
/* QL:         cmp.b   #2+maxfail,md_fail(a2) full rotations to give up after */
    cmp.b #((2+maxfail)&255),md_fail(a2)
/* QL:         bge.s   err_fe */
    bge.s err_fe
/* QL: rep_enab */
rep_enab:
/* QL:         and.w   #$f8ff,sr       enable interrupts to allow in ext or poll */
    and.w #0xf8ff,sr
/* QL:         or.w    #$0700,sr       disable them again so i can have the whole ql */
    or.w #0x0700,sr
/* QL: rep_noen ; come here after actually reading a sector - no time for interrupts! */
rep_noen:
/* QL:         move.l  (sp),a0         restore a0 */
    move.l (sp),a0
/* QL:         lea     hdrbuf(a0),a1   put the sector header somewhere safe */
    lea hdrbuf(a0),a1
/* QL:         jsr     md_sectr(pc)    get sector header */
    jsr md_sectr(pc)
/* QL:         bra.s   err_fe          ... oops                ret+0 */
    bra.s err_fe
/* QL:         bra.s   rep_enab        ... not a header        ret+2 */
    bra.s rep_enab
/* QL:                                 ; good return           ret+4 */
/* QL:         movem.l (sp),reglist    restore the addresses */
    movem.l (sp),a0-a2/a4
/* QL:         move.w  d7,d5 */
    move.w d7,d5
/* QL:         beq.s   inc_fail        ok if not the sector 0 map */
    beq.s inc_fail
/* QL:         add.w   d5,d5 */
    add.w d5,d5
/* QL:         move.b  md_map(a2,d5.w),d0 get file number from sector map */
    move.b md_map(a2,d5.w),d0
/* QL:         cmp.b   fs_filnr+1(a0),d0 check it's the one we want */
    cmp.b (fs_filnr+1)(a0),d0
/* QL:         bne.s   rep_enab */
    bne.s rep_enab
/* QL:         move.b  md_map+1(a2,d5.w),d7 replace sector with the block number */
    move.b (md_map+1)(a2,d5.w),d7
/* QL:         moveq   #7,d5           convert it to point to the file map */
    moveq #7,d5
/* QL:         and.b   d7,d5 */
    and.b d7,d5
/* QL:         ror.l   #3,d7 */
    ror.l #3,d7
/* QL:         btst    d5,bitmap(a0,d7.w) do we need this block? */
    btst d5,bitmap(a0,d7.w)
/* QL:         beq.s   rep_enab */
    beq.s rep_enab
/* QL:         move.l  a4,a1           put sector read into slave block */
    move.l a4,a1
/* QL:         jsr     md_read(pc)     read it (a5 preserved, as it happens) */
    jsr md_read(pc)
/* QL: go_noen */
go_noen:
/* QL:         bra.s   rep_noen        get next sector quick!  ret+0 */
    bra.s rep_noen
/* QL:                                 ; good return           ret+2 */
/* QL:         movem.l (sp),reglist    restore addresses */
    movem.l (sp),a0-a2/a4
/* QL: * Maybe we should make a final check that d1=file/d2=block here? */
/* QL: * That would be just in case we had managed to hiccup past the record, or */
/* QL: * more importantly, the record had been erroneously recorded! E.g. the map was */
/* QL: * not the right one! (lwr) */
/* QL:         bclr    d5,bitmap(a0,d7.w) mark sector found */
    bclr d5,bitmap(a0,d7.w)
/* QL:         rol.l   #3,d7           restore block number */
    rol.l #3,d7
/* QL:         move.w  #blksize,d0     full block normally */
    move.w #blksize,d0
/* QL:         cmp.b   lstblok(a0),d7  is it the last file block? */
    cmp.b lstblok(a0),d7
/* QL:         bne.s   not_last        no - copy to end of it */
    bne.s not_last
/* QL:         move.w  lstbyte(a0),d0  get the number of bytes in last block */
    move.w lstbyte(a0),d0
/* QL: not_last */
not_last:
/* QL:         lsl.w   #blkbits-1,d7 */
    lsl.w #(blkbits-1),d7
/* QL:         add.l   d7,d7           is it the first file block? */
    add.l d7,d7
/* QL:         lea     -md_deend(a1,d7.l),a5 where to put data normally */
    lea (-md_deend)(a1,d7.l),a5
/* QL:         bne.s   not_frst */
    bne.s not_frst
/* QL:         moveq   #md_deend,d1    yes - move on past the file header */
    moveq #md_deend,d1
/* QL:         add.l   d1,a4 */
    add.l d1,a4
/* QL:         add.l   d1,a5 */
    add.l d1,a5
/* QL:         sub.w   d1,d0           copy fewer bytes */
    sub.w d1,d0
/* QL: not_frst */
not_frst:
/* QL:         ror.l   #2,d0           long words, and save odd byte count */
    ror.l #2,d0
/* QL:         bcc.s   unbf_dbr        carry means there is an odd word to do */
    bcc.s unbf_dbr
/* QL:         move.w  (a4)+,(a5)+     if so, do it */
    move.w (a4)+,(a5)+
/* QL:         bra.s   unbf_dbr */
    bra.s unbf_dbr
/* QL: err_fe */
err_fe:
/* QL:         moveq   #err.fe,d0      ... we've bombed out */
    moveq #err.fe,d0
/* QL:         bra.s   done */
    bra.s done
/* QL: unbf_lop */
unbf_lop:
/* QL:         move.l  (a4)+,(a5)+     move a long word */
    move.l (a4)+,(a5)+
/* QL: unbf_dbr */
unbf_dbr:
/* QL:         dbra    d0,unbf_lop */
    dbra d0,unbf_lop
/* QL:         add.l   d0,d0           see if there's an odd byte to go */
    add.l d0,d0
/* QL:         bpl.s   notabyte */
    bpl.s notabyte
/* QL:         move.b  (a4)+,(a5)+     if so, do it */
    move.b (a4)+,(a5)+
/* QL: notabyte */
notabyte:
/* QL:         subq.b  #1,remain(a0)   are there any more to do? */
    subq.b #1,remain(a0)
/* QL:         bcc.s   go_noen         not finished yet */
    bcc.s go_noen
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: done */
done:
/* QL:         movem.l (sp)+,reglist   remove addresses from stack */
    movem.l (sp)+,a0-a2/a4
/* QL:         sf      md_fail(a2)     clear failure flag */
    sf md_fail(a2)
/* QL:         move.l  fs_eblok(a0),d7 get pointer to end */
    move.l fs_eblok(a0),d7
/* QL:         move.l  d7,fs_nblok(a0) make it the current postion */
    move.l d7,fs_nblok(a0)
/* QL:         lsl.w   #16-blkbits,d7 */
    lsl.w #(16-blkbits),d7
/* QL:         lsr.l   #16-blkbits,d7 */
    lsr.l #(16-blkbits),d7
/* QL:         lea     -md_deend(a1,d7.l),a1 adjust caller's register properly */
    lea (-md_deend)(a1,d7.l),a1
/* QL: ena_gap */
ena_gap:
/* QL:         or.b    #pc.maskg,sv_pcint(a6) re-enable gaps to let server run down */
    or.b #(pc.maskg&255),sv_pcint(a6)
/* QL:         and.w   #$f8ff,sr       re-enable interrupts */
    and.w #0xf8ff,sr
/* QL:         rts */
    rts 
/* QL:         end */
