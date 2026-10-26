/* Generated from original/M/md/serve.asm */
/* QL: * Microdrive gap interrupt server */
/* QL:         xdef    md_serve */
.globl md_serve
/* QL:         xref    md_desel,md_read,md_sectr,md_selec,md_verin,md_write */
/* QL:         xref    ss_rser */
/* QL:         xref    ut_err,ut_write */
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
/* QL: blkbits equ     9 */
.equ blkbits,9
/* QL: btbits  equ     3 */
.equ btbits,3
/* QL:         assert  1<<btbits,bt_end */
/* original assertion: 1<<btbits,bt_end */
/* QL: med.len equ     10      bytes in medium name */
.equ med.len,10
/* QL: maxfail equ     7 */
.equ maxfail,7
/* QL: maxdriv equ     8 */
.equ maxdriv,8
/* QL: maxsec  equ     256 */
.equ maxsec,256
/* QL: runup   equ     6 */
.equ runup,6
/* QL: rundown equ     7 */
.equ rundown,7
/* QL: mapfile equ     $80     (hm... documentation suggests this is $f8!) */
.equ mapfile,0x80
/* QL: * Stack layout: */
/* QL:         offset  4 */
/* QL: * Buffer for sector header */
/* QL:         ds.b    2       flag and sector number */
/* QL: hdr_mnm ds.b    med.len medium name */
.equ hdr_mnm,6
/* QL:         ds.b    2       random number */
/* QL: mr.len  equ     *-hdr_mnm */
.equ mr.len,(18-hdr_mnm)
/* QL: * End of sector header  */
/* QL:         ds.b    1       one byte of wasted space (junk) */
/* QL: sav_drv ds.b    1       saved drive id * 16 + 1<<bt.file */
.equ sav_drv,19
/* QL: sav_btp ds.l    1       saved slave block table entry address */
.equ sav_btp,20
/* QL: sav_pdf ds.l    1       saved physical definition address */
.equ sav_pdf,24
/* QL:         section md_serve */
.section md_serve,"ax"
/* QL: * Report on bad on changed medium */
/* QL: err_fe */
err_fe:
/* QL:         lea     md_mname(a5),a1 */
    lea md_mname(a5),a1
/* QL:         tst.b   (a1)            is there a name to write */
    tst.b (a1)
/* QL:         beq.s   err_exit */
    beq.s err_exit
/* QL:         sub.l   a0,a0           write message to channel 0 */
    sub.l a0,a0
/* QL:         moveq   #med.len,d2 */
    moveq #med.len,d2
/* QL:         jsr     ut_write(pc)    medium name */
    jsr ut_write(pc)
/* QL:         moveq   #err.fe,d0 */
    moveq #err.fe,d0
/* QL:         jsr     ut_err(pc)      error message */
    jsr ut_err(pc)
/* QL: err_exit */
err_exit:
/* QL:         bsr.s   clear           clear out all existing slave blocks */
    bsr.s clear
/* QL:         st      md_estat(a5)    set error flag */
    st md_estat(a5)
/* QL:         bra.l   desel */
    bra.w desel
/* QL: * Clear out the slave blocks and pending operations for a drive */
/* QL: * d1/a1 destroyed */
/* QL: clear */
clear:
/* QL:         move.l  sv_btbas(a6),a1 start at base of slave block tables */
    move.l sv_btbas(a6),a1
/* QL: bt_clear */
bt_clear:
/* QL:         moveq   #-16+1<<bt..file,d1 set up mask for drive id */
    moveq #((-16)+(1<<bt..file)),d1
/* QL:         assert  0,bt_stat */
/* original assertion: 0,bt_stat */
/* QL:         and.b   (a1),d1         get drive id*16 and file flag bit */
    and.b (a1),d1
/* QL:         cmp.b   sav_drv+4(sp),d1 is it this drive? */
    cmp.b (sav_drv+4)(sp),d1
/* QL:         bne.s   bt_next */
    bne.s bt_next
/* QL:         move.b  #bt.empty,(a1)  .. yes clear it */
    move.b #(bt.empty&255),(a1)
/* QL: bt_next */
bt_next:
/* QL:         addq.l  #bt_end,a1      next slave block */
    addq.l #bt_end,a1
/* QL:         cmp.l   sv_bttop(a6),a1 ... is the last ? */
    cmp.l sv_bttop(a6),a1
/* QL:         bne.s   bt_clear */
    bne.s bt_clear
/* QL:         lea     md_pendg(a5),a1 now clear out all pending operations */
    lea md_pendg(a5),a1
/* QL:         moveq   #maxsec*2/4-1,d1 */
    moveq #(((maxsec*2)/4)-1),d1
/* QL: pend_clr */
pend_clr:
/* QL:         clr.l   (a1)+ */
    clr.l (a1)+
/* QL:         dbra    d1,pend_clr */
    dbra d1,pend_clr
/* QL:         rts */
    rts 
/* QL: * Serve a microdrive gap interrupt */
/* QL: * Stack frame data has been set up for us. */
/* QL: * d0-d7/a0-a5 destroyed */
/* QL: md_serve */
md_serve:
/* QL:         move.b  sv_mdcnt(a6),d2 get run-up / run-down count */
    move.b sv_mdcnt(a6),d2
/* QL:         bge.s   ok_up */
    bge.s ok_up
/* QL:         addq.b  #1,d2           run up a bit */
    addq.b #1,d2
/* QL: ok_up */
ok_up:
/* QL:         jsr     md_sectr(pc)    get sector header */
    jsr md_sectr(pc)
/* QL: err_msg */
err_msg:
/* QL:         bra.s   err_fe          ret+0 unreadable */
    bra.s err_fe
/* QL:         rts                     ret+2 not a sector header */
    rts 
/* QL:                         ;       ret+4 ok */
/* QL:         assert  0,mr.len&3 */
/* original assertion: 0,mr.len&3 */
/* QL:         moveq   #mr.len/4-1,d0 check the last bytes of the sector */
    moveq #((mr.len/4)-1),d0
/* QL:         lea     md_mname+mr.len(a5),a2 against the stored name */
    lea (md_mname+mr.len)(a5),a2
/* QL: chk_med */
chk_med:
/* QL:         move.l  -(a2),d1 */
    move.l -(a2),d1
/* QL:         cmp.l   -(a1),d1 */
    cmp.l -(a1),d1
/* QL:         dbne    d0,chk_med */
    dbne d0,chk_med
/* QL:         beq.s   same_med */
    beq.s same_med
/* QL: * New medium in drive */
/* QL:         tst.b   md_estat(a5)    a new medium is in - am I expecting it */
    tst.b md_estat(a5)
/* QL:         ble.s   err_msg         no - a problem */
    ble.s err_msg
/* QL:         tst.b   md_files(a5)    are there any files open? */
    tst.b md_files(a5)
/* QL:         bne.s   err_msg         yes - a disaster! */
    bne.s err_msg
/* QL:         tst.b   d7              is it sector 0 ? */
    tst.b d7
/* QL:         bne.s   anrts */
    bne.s anrts
/* QL:         lea     md_map(a5),a1   yes, read it in */
    lea md_map(a5),a1
/* QL:         bsr.s   go_read         doesn't return if no good */
    bsr.s go_read
/* QL:         bsr.s   clear           clear out all existing slave blocks */
    bsr.s clear
/* QL:         movem.l hdr_mnm(sp),d0-d2 pick up medium name and random number */
    movem.l hdr_mnm(sp),d0-d2
/* QL:         movem.l d0-d2,md_mname(a5) put it all into physdef block */
    movem.l d0-d2,md_mname(a5)
/* QL: set_fnd */
set_fnd:
/* QL:         sf      md_estat(a5)    set medium name and map found */
    sf md_estat(a5)
/* QL:         rts */
    rts 
/* QL: same_med */
same_med:
/* QL:         tst.b   md_estat(a5)    medium is the same, was server checking it? */
    tst.b md_estat(a5)
/* QL:         bgt.s   set_fnd         yes, set medium found */
    bgt.s set_fnd
/* QL:         add.w   d7,d7           set pointer to pending list */
    add.w d7,d7
/* QL:         bne.s   not_map */
    bne.s not_map
/* QL:         addq.b  #1,md_fail(a5)  this is the map - update fail count */
    addq.b #1,md_fail(a5)
/* QL:         cmp.b   #1+maxfail,md_fail(a5) */
    cmp.b #((1+maxfail)&255),md_fail(a5)
/* QL:         bgt.s   err_msg */
    bgt.s err_msg
/* QL: not_map */
not_map:
/* QL:         add.w   d7,a5 */
    add.w d7,a5
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.w  md_pendg(a5),d1 get pending op */
    move.w md_pendg(a5),d1
/* QL:         beq.l   run_down */
    beq.w run_down
/* QL:         tst.b   d2              was drive running down? */
    tst.b d2
/* QL:         ble.s   ok_cnt */
    ble.s ok_cnt
/* QL:         sf      d2              yes, clear it */
    sf d2
/* QL: ok_cnt */
ok_cnt:
/* QL:         move.b  d2,sv_mdcnt(a6) reset run_up run_down */
    move.b d2,sv_mdcnt(a6)
/* QL: * bug! patched by super GC - was addq.b */
/* QL:         addq.w  #2,d1           check for the two special cases (-1/-2) */
    addq.w #2,d1
/* QL:         bcc.s   normal          it's not a special operation */
    bcc.s normal
/* QL:         lea     md_map(a5),a1   set base address of map */
    lea md_map(a5),a1
/* QL:         beq.s   ver_map         was -2 for verify, so go do it */
    beq.s ver_map
/* QL:         tst.b   d2              is it still running up? */
    tst.b d2
/* QL:         bmi.s   anrts */
    bmi.s anrts
/* QL:         move.w  #mapfile<<8+0,-(sp) map file, block 0 */
    move.w #((mapfile<<8)+0),-(sp)
/* QL:         jsr     md_write(pc) */
    jsr md_write(pc)
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL:         moveq   #-2,d1          now verify */
    moveq #(-2),d1
/* QL:         bra.s   set_spc */
    bra.s set_spc
/* QL: go_read */
go_read:
/* QL:         jsr     md_read(pc) */
    jsr md_read(pc)
/* QL:         addq.l  #4,sp           ret+0, bad, and drop return address */
    addq.l #4,sp
/* QL: anrts */
anrts:
/* QL:         rts                     ret+2, ok */
    rts 
/* QL: ver_map */
ver_map:
/* QL:         jsr     md_verin(pc)    verify */
    jsr md_verin(pc)
/* QL:         bra.s   bad_map         ret+0 bad */
    bra.s bad_map
/* QL:                         ;       ret+2 ok */
/* QL:         moveq   #0,d1           ok no more special ops */
    moveq #0,d1
/* QL:         bra.s   set_spc */
    bra.s set_spc
/* QL: bad_map */
bad_map:
/* QL:         moveq   #-1,d1          write it again */
    moveq #(-1),d1
/* QL: set_spc */
set_spc:
/* QL:         move.w  d1,md_pendg(a5) set special op */
    move.w d1,md_pendg(a5)
/* QL:         rts */
    rts 
/* QL: normal */
normal:
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         lsl.l   #btbits,d1      convert to slave block pointer */
    lsl.l #btbits,d1
/* QL:         move.l  sv_btbas(a6),a4 */
    move.l sv_btbas(a6),a4
/* QL: * bug corected by super GC - was add.w! */
/* QL:         add.l   d1,a4 */
    add.l d1,a4
/* QL:         move.l  a4,sav_btp(sp)  and save it */
    move.l a4,sav_btp(sp)
/* QL:         lsl.l   #blkbits-btbits,d1 set address of buffer */
    lsl.l #(blkbits-btbits),d1
/* QL:         lea     0(a6,d1.l),a1   now we have buffer pointer */
    lea 0(a6,d1.l),a1
/* QL:         move.b  (a4),d1 */
    move.b (a4),d1
/* QL:         assert  bt..accs,bt..wreq-1 */
/* original assertion: bt..accs,bt..wreq-1 */
/* QL:         lsl.b   #8-bt..wreq,d1 */
    lsl.b #(8-bt..wreq),d1
/* QL:         bcs.s   write           write required */
    bcs.s write
/* QL:         bmi.s   verify          verify required */
    bmi.s verify
/* QL:         bsr.s   go_read         doesn't return if no good */
    bsr.s go_read
/* QL:         bra.s   read_ok */
    bra.s read_ok
/* QL: verify */
verify:
/* QL:         jsr     md_verin(pc) */
    jsr md_verin(pc)
/* QL:         bra.s   bad_veri        ret+0 bad */
    bra.s bad_veri
/* QL:                         ;       ret+2 ok */
/* QL: read_ok */
read_ok:
/* QL:         clr.w   md_pendg(a5)    clear pending op */
    clr.w md_pendg(a5)
/* QL:         move.l  sav_pdf(sp),a1 */
    move.l sav_pdf(sp),a1
/* QL:         sf      md_fail(a1)     successful - clear fail flag */
    sf md_fail(a1)
/* QL:         moveq   #bt.true,d0     true copy */
    moveq #bt.true,d0
/* QL:         bra.s   set_stat */
    bra.s set_stat
/* QL: bad_veri */
bad_veri:
/* QL:         moveq   #bt.updt,d0     verify failed - write again */
    moveq #bt.updt,d0
/* QL:         bra.s   set_stat */
    bra.s set_stat
/* QL: write */
write:
/* QL:         tst.b   d2              is drive still running up */
    tst.b d2
/* QL:         bmi.s   anrts */
    bmi.s anrts
/* QL:         move.w  md_map(a5),-(sp) put file / block on stack */
    move.w md_map(a5),-(sp)
/* QL:         jsr     md_write(pc) */
    jsr md_write(pc)
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL:         moveq   #bt.aver,d0     now verify */
    moveq #bt.aver,d0
/* QL: set_stat */
set_stat:
/* QL:         movem.l sav_drv-3(sp),d6/a4 restore drive*16+1 and slave block pointer */
    movem.l (sav_drv-3)(sp),d6/a4
/* QL:         or.b    d0,d6           add the status */
    or.b d0,d6
/* QL:         move.b  d6,(a4) */
    move.b d6,(a4)
/* QL:         moveq   #rundown-2,d2   check for run_down after one sector */
    moveq #(rundown-2),d2
/* QL: * Not a pending operation - check whether to run down */
/* QL: run_down */
run_down:
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         bmi.s   set_cnt         still running up */
    bmi.s set_cnt
/* QL:         addq.b  #1,d2 */
    addq.b #1,d2
/* QL:         cmp.b   #1+rundown,d2   do not check every time */
    cmp.b #((1+rundown)&255),d2
/* QL:         blt.s   set_cnt */
    blt.s set_cnt
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         moveq   #256-maxsec,d0  check all sectors */
    moveq #(256-maxsec),d0
/* QL:         move.l  sav_pdf(sp),a5 */
    move.l sav_pdf(sp),a5
/* QL:         lea     md_pendg(a5),a5 */
    lea md_pendg(a5),a5
/* QL: chk_pend */
chk_pend:
/* QL:         tst.w   (a5)+           pending op here? */
    tst.w (a5)+
/* QL:         bne.s   set_cnt         yes, go do it */
    bne.s set_cnt
/* QL:         addq.b  #1,d0 */
    addq.b #1,d0
/* QL:         bne.s   chk_pend */
    bne.s chk_pend
/* QL: desel */
desel:
/* QL:         jsr     md_desel(pc)    deselect this drive */
    jsr md_desel(pc)
/* QL:         lea     sv_mdsta(a6),a5 */
    lea sv_mdsta(a6),a5
/* QL:         moveq   #maxdriv+1,d1   look to see if another drive is waiting */
    moveq #(maxdriv+1),d1
/* QL: look_next */
look_next:
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         move.b  d1,sv_mdrun(a6) say which drive is running */
    move.b d1,sv_mdrun(a6)
/* QL:         beq.s   quiet */
    beq.s quiet
/* QL:         tst.b   -1(a5,d1.w) */
    tst.b (-1)(a5,d1.w)
/* QL:         beq.s   look_next */
    beq.s look_next
/* QL:         jsr     md_selec(pc)    select it */
    jsr md_selec(pc)
/* QL:         moveq   #-runup,d2      run up */
    moveq #(-runup),d2
/* QL: set_cnt */
set_cnt:
/* QL:         move.b  d2,sv_mdcnt(a6) reset run_up run_down */
    move.b d2,sv_mdcnt(a6)
/* QL:         rts */
    rts 
/* QL: quiet */
quiet:
/* QL:         and.b   #$ff-pc.maskg,sv_pcint(a6) mask the gap interrupt */
    and.b #((0xff-pc.maskg)&255),sv_pcint(a6)
/* QL:         jmp     ss_rser(pc)     and re-enable serial output */
    jmp ss_rser(pc)
/* QL:         end */
