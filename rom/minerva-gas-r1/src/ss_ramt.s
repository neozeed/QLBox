/* Generated from original/M/ss/ramt.asm */
/* QL: * RAM test at boot up */
/* QL:         xdef    ss_ramt */
.globl ss_ramt
/* QL:         xref    ss_init */
/* QL:         xref    tb_hex */
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: ii.raw  equ     $170    use vector to get to i2c code */
.equ ii.raw,0x170
/* QL: magic   equ     $5c     where we get a magic, odd longword to check with a5 */
.equ magic,0x5c
/* QL: scr1    equ     $20000  first screen address */
.equ scr1,0x20000
/* QL: scr2    equ     $28000  dual screen address */
.equ scr2,0x28000
/* QL: i_sp    equ     $28480  base value for ssp */
.equ i_sp,0x28480
/* QL: m16k    equ     $4000   memory resolution we are prepared to handle */
.equ m16k,0x4000
/* QL: ranpat  equ     8191    prime < 32k/4 is top of mem pattern to use */
.equ ranpat,8191
/* QL: * This allows for software reset (many flavours) as well as initial power up. */
/* QL: * This routine exits with the top of ram, as a multiple of 16384, in a5. */
/* QL: * The test starts with a short delay (150ms) to allow any external devices to */
/* QL: * settle down... */
/* QL: * The test then checks the size of the expansion ram (if present) and tests */
/* QL: * that ram is ok and contiguous from scr1 upwards. */
/* QL: * The test algorithm is to go once round the whole of memory writing and */
/* QL: * checking all ones and a random pattern generated by copying rom into the ram. */
/* QL: * The current clock seconds determines the start of the random pattern. */
/* QL: * A pair of short (150ms) delays is used to encourage refresh failure. */
/* QL: * the random pattern is rechecked without re-writing to detect addressing and */
/* QL: * refresh problems. A zero check is left to the end of the second time */
/* QL: * round, to complete with memory all zero, except for the logo. */
/* QL: * If the test fails, the failure mode is indicated by writing the pattern that */
/* QL: * was being checked, the value read and the address where the problem occured. */
/* QL: * these longwords are written in big, friendly(sic) hex. */
/* QL: * The power up entry point is ss_ramt, but this is also entered after the */
/* QL: * "reset" instruction is executed (as the hardware is not quite proper!). */
/* QL: * The software reset is acheived by jumping to location 390 with d1.l set as */
/* QL: * the type of reset required. */
/* QL: * A magic number is then put into a5.l prior to causing a reset. */
/* QL: * If the magic number is not present when ss_ramt is reached, a standard */
/* QL: * "press the button" reset is forced. */
/* QL: * The value in d1.l is used to decide what sort of restart is required: */
/* QL: *       bit(s)  value   meaning */
/* QL: *       0       0       do the full memory test */
/* QL: *               1       skip the memory test for a quick reset */
/* QL: *       1       0       scan rom slots */
/* QL: *               1       skip the rom slots, unexpand the m/c */
/* QL: *       2       0       normal establishment of memory size */
/* QL: *               1       take the upper memory limit below as gospel! */
/* QL: *       3       0       monitor mode */
/* QL: *               1       tv mode */
/* QL: *       4       0       wait for f1-f4 selection */
/* QL: *               1       skip the f1-f4 selection */
/* QL: *       5-6     0..3    extend supervisor stack by 0K, 8K, 16K or 24K  */
/* QL: *       7       0       set single screen */
/* QL: *               1       set dual screens */
/* QL: *       8-13    0..63   extra blocks of 64k between last screen and system vars */
/* QL: *       14-31           upper limit on memory (0 = no limit) */
/* QL: * (Note that the top bits of d1 are unlikely to ever make sense as memory!) */
/* QL: * The value in d1.l is passed on to ss_init in d5.l. */
/* QL: * One can use the reset direct from superbasic. */
/* QL: * E.g. to quick reset and have dual screens in tv mode, use "call 390,153". */
/* QL: sls     equ     7       bit shift for screen line */
.equ sls,7
/* QL: sl      equ     1<<sls  bytes per screen line */
.equ sl,(1<<sls)
/* QL:         section ss_ramt */
.section ss_ramt,"ax"
/* QL: * The logo is stored as a word (or rather, two bytes) flagging which bytes are */
/* QL: * changing from the row above. This always has bit 1 set, enabling it to double */
/* QL: * up as the loop count of 14 bytes per row as it is shifted left.  */
/* QL: logo */
logo:
/* QL:  dc.b $60,$02,$08,$02 */
dc_anchor_275:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x08)&255
.byte (0x02)&255
/* QL:  dc.b $60,$02,$1c,$07 */
dc_anchor_281:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x1c)&255
.byte (0x07)&255
/* QL:  dc.b $60,$02,$3e,$0f */
dc_anchor_287:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x3e)&255
.byte (0x0f)&255
/* QL:  dc.b $10,$02,$80 */
dc_anchor_293:
.byte (0x10)&255
.byte (0x02)&255
.byte (0x80)&255
/* QL:  dc.b $60,$02,$7f,$1f */
dc_anchor_298:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x7f)&255
.byte (0x1f)&255
/* QL:  dc.b $1f,$fa,$8f,$ff,$f1,$ff,$ff,$ff,$ff,$ff,$ff,$c0 */
dc_anchor_304:
.byte (0x1f)&255
.byte (0xfa)&255
.byte (0x8f)&255
.byte (0xff)&255
.byte (0xf1)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xc0)&255
/* QL:  dc.b $74,$0a,$ff,$bf,$cf,$f3,$e0 */
dc_anchor_318:
.byte (0x74)&255
.byte (0x0a)&255
.byte (0xff)&255
.byte (0xbf)&255
.byte (0xcf)&255
.byte (0xf3)&255
.byte (0xe0)&255
/* QL:  dc.b $14,$02,$c7,$e3 */
dc_anchor_327:
.byte (0x14)&255
.byte (0x02)&255
.byte (0xc7)&255
.byte (0xe3)&255
/* QL:  dc.b $ff,$fa,$01,$f3,$fd,$c0,$00,$00,$00,$00,$00,$00,$00,$00,$00 */
dc_anchor_333:
.byte (0xff)&255
.byte (0xfa)&255
.byte (0x01)&255
.byte (0xf3)&255
.byte (0xfd)&255
.byte (0xc0)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
/* QL:  dc.b $20,$02,$f9 */
dc_anchor_350:
.byte (0x20)&255
.byte (0x02)&255
.byte (0xf9)&255
/* QL:  dc.b $ff,$fa,$03,$e1,$f1,$e1,$ff,$81,$f8,$7f,$f0,$ff,$18,$07,$f8 */
dc_anchor_355:
.byte (0xff)&255
.byte (0xfa)&255
.byte (0x03)&255
.byte (0xe1)&255
.byte (0xf1)&255
.byte (0xe1)&255
.byte (0xff)&255
.byte (0x81)&255
.byte (0xf8)&255
.byte (0x7f)&255
.byte (0xf0)&255
.byte (0xff)&255
.byte (0x18)&255
.byte (0x07)&255
.byte (0xf8)&255
/* QL:  dc.b $07,$ba,$c3,$fc,$ff,$f9,$38,$0f,$fc */
dc_anchor_372:
.byte (0x07)&255
.byte (0xba)&255
.byte (0xc3)&255
.byte (0xfc)&255
.byte (0xff)&255
.byte (0xf9)&255
.byte (0x38)&255
.byte (0x0f)&255
.byte (0xfc)&255
/* QL:  dc.b $f4,$ba,$07,$c0,$e0,$e0,$c7,$fb,$3c,$1f,$fe */
dc_anchor_383:
.byte (0xf4)&255
.byte (0xba)&255
.byte (0x07)&255
.byte (0xc0)&255
.byte (0xe0)&255
.byte (0xe0)&255
.byte (0xc7)&255
.byte (0xfb)&255
.byte (0x3c)&255
.byte (0x1f)&255
.byte (0xfe)&255
/* QL:  dc.b $3b,$da,$40,$f0,$03,$9e,$f1,$f3,$c0,$1e,$1e */
dc_anchor_396:
.byte (0x3b)&255
.byte (0xda)&255
.byte (0x40)&255
.byte (0xf0)&255
.byte (0x03)&255
.byte (0x9e)&255
.byte (0xf1)&255
.byte (0xf3)&255
.byte (0xc0)&255
.byte (0x1e)&255
.byte (0x1e)&255
/* QL:  dc.b $e7,$fa,$0f,$80,$00,$8f,$1e,$7b,$c7,$80,$1c,$1c,$0f */
dc_anchor_409:
.byte (0xe7)&255
.byte (0xfa)&255
.byte (0x0f)&255
.byte (0x80)&255
.byte (0x00)&255
.byte (0x8f)&255
.byte (0x1e)&255
.byte (0x7b)&255
.byte (0xc7)&255
.byte (0x80)&255
.byte (0x1c)&255
.byte (0x1c)&255
.byte (0x0f)&255
/* QL:  dc.b $1b,$8a,$70,$07,$0e,$7f,$87,$1f */
dc_anchor_424:
.byte (0x1b)&255
.byte (0x8a)&255
.byte (0x70)&255
.byte (0x07)&255
.byte (0x0e)&255
.byte (0x7f)&255
.byte (0x87)&255
.byte (0x1f)&255
/* QL:  dc.b $d5,$fe,$1f,$00,$78,$8e,$3f,$0f,$00,$1e,$3c,$3f,$80 */
dc_anchor_434:
.byte (0xd5)&255
.byte (0xfe)&255
.byte (0x1f)&255
.byte (0x00)&255
.byte (0x78)&255
.byte (0x8e)&255
.byte (0x3f)&255
.byte (0x0f)&255
.byte (0x00)&255
.byte (0x1e)&255
.byte (0x3c)&255
.byte (0x3f)&255
.byte (0x80)&255
/* QL:  dc.b $07,$0a,$1e,$0f,$3c,$7f */
dc_anchor_449:
.byte (0x07)&255
.byte (0x0a)&255
.byte (0x1e)&255
.byte (0x0f)&255
.byte (0x3c)&255
.byte (0x7f)&255
/* QL:  dc.b $98,$be,$3e,$38,$0f,$1e,$0e,$38,$7b,$c0 */
dc_anchor_457:
.byte (0x98)&255
.byte (0xbe)&255
.byte (0x3e)&255
.byte (0x38)&255
.byte (0x0f)&255
.byte (0x1e)&255
.byte (0x0e)&255
.byte (0x38)&255
.byte (0x7b)&255
.byte (0xc0)&255
/* QL:  dc.b $17,$3a,$3c,$3c,$07,$1e,$0f,$78,$f1 */
dc_anchor_469:
.byte (0x17)&255
.byte (0x3a)&255
.byte (0x3c)&255
.byte (0x3c)&255
.byte (0x07)&255
.byte (0x1e)&255
.byte (0x0f)&255
.byte (0x78)&255
.byte (0xf1)&255
/* QL:  dc.b $88,$96,$7c,$0e,$3c,$79,$e0 */
dc_anchor_480:
.byte (0x88)&255
.byte (0x96)&255
.byte (0x7c)&255
.byte (0x0e)&255
.byte (0x3c)&255
.byte (0x79)&255
.byte (0xe0)&255
/* QL:  dc.b $1d,$be,$1c,$1e,$38,$8f,$38,$07,$73,$ff,$f0 */
dc_anchor_489:
.byte (0x1d)&255
.byte (0xbe)&255
.byte (0x1c)&255
.byte (0x1e)&255
.byte (0x38)&255
.byte (0x8f)&255
.byte (0x38)&255
.byte (0x07)&255
.byte (0x73)&255
.byte (0xff)&255
.byte (0xf0)&255
/* QL:  dc.b $94,$92,$f8,$1e,$78,$f8,$f3 */
dc_anchor_502:
.byte (0x94)&255
.byte (0x92)&255
.byte (0xf8)&255
.byte (0x1e)&255
.byte (0x78)&255
.byte (0xf8)&255
.byte (0xf3)&255
/* QL:  dc.b $0b,$96,$1c,$03,$83,$e0,$f1,$e0 */
dc_anchor_511:
.byte (0x0b)&255
.byte (0x96)&255
.byte (0x1c)&255
.byte (0x03)&255
.byte (0x83)&255
.byte (0xe0)&255
.byte (0xf1)&255
.byte (0xe0)&255
/* QL:  dc.b $97,$be,$f0,$0e,$f0,$00,$00,$00,$03,$e0,$00,$00 */
dc_anchor_521:
.byte (0x97)&255
.byte (0xbe)&255
.byte (0xf0)&255
.byte (0x0e)&255
.byte (0xf0)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x03)&255
.byte (0xe0)&255
.byte (0x00)&255
.byte (0x00)&255
/* QL:  dc.b $88,$02,$70,$00 */
dc_anchor_535:
.byte (0x88)&255
.byte (0x02)&255
.byte (0x70)&255
.byte (0x00)&255
/* QL:  dc.b $94,$02,$00,$0f,$e0 */
dc_anchor_541:
.byte (0x94)&255
.byte (0x02)&255
.byte (0x00)&255
.byte (0x0f)&255
.byte (0xe0)&255
/* QL:  dc.b $04,$02,$00 */
dc_anchor_548:
.byte (0x04)&255
.byte (0x02)&255
.byte (0x00)&255
/* QL:  dc.b $10,$32,$07,$01,$c0 */
dc_anchor_553:
.byte (0x10)&255
.byte (0x32)&255
.byte (0x07)&255
.byte (0x01)&255
.byte (0xc0)&255
/* QL:  dc.b $0f,$fe,$8f,$ff,$ff,$ff,$ff,$ff,$f9,$cf,$ff,$fc */
dc_anchor_560:
.byte (0x0f)&255
.byte (0xfe)&255
.byte (0x8f)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xf9)&255
.byte (0xcf)&255
.byte (0xff)&255
.byte (0xfc)&255
/* QL:  dc.b $00,$36,$fc,$9f,$fe */
dc_anchor_574:
.byte (0x00)&255
.byte (0x36)&255
.byte (0xfc)&255
.byte (0x9f)&255
.byte (0xfe)&255
/* QL:  dc.b $ff,$00           terminate with a mask word with a zero lsb */
dc_anchor_581:
.byte (0xff)&255
.byte (0x00)&255
/* QL:  ds.w 0 allign to word boundary */
.balign 2,0
/* QL: l_len   equ     14*8 number of pixels per row */
.equ l_len,(14*8)
/* QL: l_row   equ     32 number of rows  */
.equ l_row,32
/* QL: l_h     equ     50 allow height to match copyright message window */
.equ l_h,50
/* QL: l_w     equ     (l_h*l_len+l_row/2)/l_row pad width up proportionate to height */
.equ l_w,(((l_h*l_len)+(l_row/2))/l_row)
/* QL: l_x     equ     (512+448)/2-l_w */
.equ l_x,(((512+448)/2)-l_w)
/* QL: l_y     equ     256-l_h */
.equ l_y,(256-l_h)
/* QL: l_off   equ     (l_x*2+l_w-l_len+8)/(8*2)*2 offset to first byte in line */
.equ l_off,((((((l_x*2)+l_w)-l_len)+8)/(8*2))*2)
/* QL: l_1st   equ     l_y+(l_h-l_row+1)/2 first display line */
.equ l_1st,(l_y+(((l_h-l_row)+1)/2))
/* QL: nextword */
nextword:
/* QL:         move.l  -(a1),d2        fetch a random longword from rom */
    move.l -(a1),d2
/* QL:         jmp     (a2)            go do appropriate bit */
    jmp (a2)
/* QL: l_loop */
l_loop:
/* QL:         move.b  (a3)+,-1(a0)    if carry was set, we patch in our new byte */
    move.b (a3)+,(-1)(a0)
/* QL: l_copy */
l_copy:
/* QL:         move.w  -sl(a0),(a0)+   repeat word from row above */
    move.w (-sl)(a0),(a0)+
/* QL:         add.w   d7,d7           check our mask */
    add.w d7,d7
/* QL:         bcc.s   l_copy          if carry clear, we have no new byte for here */
    bcc.s l_copy
/* QL:         bne.s   l_loop          if it's zero, we just overshot, but so what! */
    bne.s l_loop
/* QL: do_2nd */
do_2nd:
/* QL:         btst    d0,d5           is this a quick reset? */
    btst d0,d5
/* QL:         beq.s   chk_rnd         no, keep checking randoms */
    beq.s chk_rnd
/* QL:         move.l  d0,(a4)+        just wipe memory for quick reset */
    move.l d0,(a4)+
/* QL: * Come here on second pass, until we've got past the logo */
/* QL: do_logo */
do_logo:
/* QL:         move.l  a4,d3 */
    move.l a4,d3
/* QL:         cmp.w   #(l_1st+1)<<sls,d3 at the logo line + 1 yet? */
    cmp.w #((l_1st+1)<<sls),d3
/* QL:         bcs.s   do_2nd          no, carry on */
    bcs.s do_2nd
/* QL:         assert  7,sls */
/* original assertion: 7,sls */
/* QL:         add.b   d3,d3           are we at the start of a line */
    add.b d3,d3
/* QL:         bne.s   do_2nd          no, continue 2nd pass */
    bne.s do_2nd
/* QL:         lea     l_off-sl(a4),a0 pointer to left hand edge above */
    lea (l_off-sl)(a4),a0
/* QL:         move.b  (a3)+,d7 */
    move.b (a3)+,d7
/* QL:         asl.w   #8,d7           pick up the mask word (not on a word bdry!) */
    asl.w #8,d7
/* QL:         move.b  (a3)+,d7        (note - d7.b=0 also marks end of 2nd pass) */
    move.b (a3)+,d7
/* QL:         bne.s   l_copy          all real mask words have bit 1 set */
    bne.s l_copy
/* QL:         btst    d0,d5           is this a quick reset? */
    btst d0,d5
/* QL:         bne.l   qfin            yes, just go tidy last few bits */
    bne.w qfin
/* QL:         lea     chk_rnd,a2      change to full 2nd pass */
    lea chk_rnd(pc),a2
/* QL: chk_rnd */
chk_rnd:
/* QL:         cmp.l   (a4),d2         check the random word */
    cmp.l (a4),d2
/* QL:         bne.s   bad_rand        if it fails */
    bne.s bad_rand
/* QL:         move.l  d0,(a4)         write zeroes to ram */
    move.l d0,(a4)
/* QL:         tst.l   (a4)+           check them */
    tst.l (a4)+
/* QL:         dbne    d6,nextword     loop */
    dbne d6,nextword
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         bra.s   chk_fail */
    bra.s chk_fail
/* QL: do_1st */
do_1st:
/* QL: * First time round, write ones, read ones, write random and check */
/* QL:         move.l  d7,(a4)         write ones to ram */
    move.l d7,(a4)
/* QL:         cmp.l   (a4),d7         check them */
    cmp.l (a4),d7
/* QL:         bne.s   hangup */
    bne.s hangup
/* QL:         move.l  d2,(a4)         write it to ram */
    move.l d2,(a4)
/* QL:         cmp.l   (a4)+,d2        check it */
    cmp.l (a4)+,d2
/* QL:         dbne    d6,nextword     loop */
    dbne d6,nextword
/* QL:         move.l  d2,a0 */
    move.l d2,a0
/* QL: chk_fail */
chk_fail:
/* QL:         lea     ranpat*4,a1     ready for next block */
    lea (ranpat*4),a1
/* QL:         beq.l   nextlump        keep going until a fail */
    beq.w nextlump
/* QL:         subq.l  #4,a4           back up to failed location */
    subq.l #4,a4
/* QL:         move.l  a0,d2           now d2 is test value that failed */
    move.l a0,d2
/* QL: bad_rand */
bad_rand:
/* QL:         move.l  d2,d7           now d7 is test value that failed */
    move.l d2,d7
/* QL: * fail locations: indicate failure by screen writing */
/* QL: hangup */
hangup:
/* QL:         move.l  (a4),d6         pick up failing longword */
    move.l (a4),d6
/* QL:         moveq   #8<<3+4,d5      set d5 for full, single tv screen reset & count */
    moveq #((8<<3)+4),d5
/* QL:         lea     scr1-scr2+128*32+64-8*6(a6),a1 start of first display line */
    lea ((((scr1-scr2)+(128*32))+64)-(8*6))(a6),a1
/* QL: sh_word */
sh_word:
/* QL:         moveq   #7*4,d3         7 lines each repeated 4 times */
    moveq #(7*4),d3
/* QL: sh_line */
sh_line:
/* QL:         moveq   #-32/4,d2       hex digits per longword */
    moveq #((-32)/4),d2
/* QL: sh_byte */
sh_byte:
/* QL:         lea     tb_hex-$4000+6,a0 base of small hex digits */
    lea ((tb_hex-0x4000)+6)(pc),a0
/* QL:         rol.l   #4,d7           roll next digit to lsb's */
    rol.l #4,d7
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   d7,d1 */
    and.b d7,d1
/* QL:         moveq   #9*4,d0         (also 6*6) */
    moveq #(9*4),d0
/* QL:         mulu    d0,d1 */
    mulu d0,d1
/* QL:         sub.w   d3,d1 */
    sub.w d3,d1
/* QL:         asr.w   #2,d1 */
    asr.w #2,d1
/* QL:         add.w   d1,a0           pick out row of char */
    add.w d1,a0
/* QL:         move.b  $4000(a0),d1 */
    move.b 0x4000(a0),d1
/* QL: sh_bit */
sh_bit:
/* QL:         cmp.b   #6*4,d3 */
    cmp.b #((6*4)&255),d3
/* QL:         bcc.s   bltop */
    bcc.s bltop
/* QL:         add.b   d1,d1 */
    add.b d1,d1
/* QL: bltop */
bltop:
/* QL:         scs     (a1)+ */
    scs (a1)+
/* QL:         scs     (a1)+ */
    scs (a1)+
/* QL:         subq.b  #6,d0 */
    subq.b #6,d0
/* QL:         bne.s   sh_bit */
    bne.s sh_bit
/* QL:         addq.w  #1,d2           count down digits (nb saving msw=-1) */
    addq.w #1,d2
/* QL:         bne.s   sh_byte */
    bne.s sh_byte
/* QL:         lea     128-2*8*6(a1),a1 */
    lea (128-((2*8)*6))(a1),a1
/* QL:         subq.b  #1,d3           count rows */
    subq.b #1,d3
/* QL:         bne.s   sh_line */
    bne.s sh_line
/* QL:         move.l  d6,d7           after bad data, do expected data */
    move.l d6,d7
/* QL:         move.l  a4,d6           finally do failing address */
    move.l a4,d6
/* QL:         asr.l   #1,d5 */
    asr.l #1,d5
/* QL:         bcc.s   sh_word */
    bcc.s sh_word
/* QL:         lea     pc_clock+3,a0 */
    lea (pc_clock+3),a0
/* QL:         moveq   #15,d0          hang on for 1/4 minute (gold card compat.) */
    moveq #15,d0
/* QL:         add.b   (a0),d0 */
    add.b (a0),d0
/* QL: waste */
waste:
/* QL:         cmp.b   (a0),d0 */
    cmp.b (a0),d0
/* QL:         bne.s   waste */
    bne.s waste
/* QL:         bra.s   retry */
    bra.s retry
/* QL: * Start of ram test: come here at power on and after "reset" instruction */
/* QL: ss_ramt */
ss_ramt:
/* QL:         cmp.l   magic,a5        check for magic number in a5 */
    cmp.l magic,a5
/* QL:         beq.s   d1set           if it's there, d1 is valid (we hope!) */
    beq.s d1set
/* QL:         moveq   #-1,d7 */
    moveq #(-1),d7
/* QL:         dbra    d7,*            waste some time in case of glitch */
    dbra d7,.
/* QL:         lea     iicmd,a3        load command sequence address */
    lea iicmd(pc),a3
/* QL:         lea     iiret,a0        load return address */
    lea iiret(pc),a0
/* QL:         move.w  ii.raw,a5       use vector to get to i2c code */
    move.w ii.raw,a5
/* QL:         jmp     $4000(a5)       jump to i2c raw entry point address */
    jmp 0x4000(a5)
/* QL: iiret */
iiret:
/* QL:         beq.s   d1set */
    beq.s d1set
/* QL:         moveq   #8,d1           full reset, default tv mode single screen */
    moveq #8,d1
/* QL: d1set */
d1set:
/* QL:         move.l  d1,d5           set d5 for later and passing on to ss_init */
    move.l d1,d5
/* QL:         and.w   #-m16k,d1       the top address we're being asked to use */
    and.w #(-m16k),d1
/* QL:         move.l  d1,a4           upper limit to check ram to */
    move.l d1,a4
/* QL: retry */
retry:
/* QL:         move.l  #i_sp,sp        ignore original sp and set proper one */
    move.l #i_sp,sp
/* QL:         lea     scr2-i_sp(sp),a6 keep a useful address in a6 */
    lea (scr2-i_sp)(sp),a6
/* QL: ;        if      ntsc */
/* QL: ;        move.b  #64,mc_stat     set 512 pixel mode, 60hz */
/* QL: ;        else */
/* QL:         sf      mc_stat         set 512 pixel mode, display screen 0 */
    sf mc_stat
/* QL: ;        endif */
/* QL:         moveq   #-1,d7          set flag for first time round, and ones test */
    moveq #(-1),d7
/* QL:         move.l  a4,a5           copy upper limit */
    move.l a4,a5
/* QL:         btst    #2,d5           is this a forced limit? */
    btst #2,d5
/* QL:         bne.s   res_a5          yes, go use it, whatever it is! */
    bne.s res_a5
/* QL:         move.l  a6,a5           start address for checking */
    move.l a6,a5
/* QL:         move.w  #m16k,a0        16k increment */
    move.w #m16k,a0
/* QL:         sub.l   a0,a4           pop a bit off limit, so it will compare nice */
    sub.l a0,a4
/* QL:         bra.s   find_ext */
    bra.s find_ext
/* QL: next_add */
next_add:
/* QL:         move.l  a5,(a5)         set address to self */
    move.l a5,(a5)
/* QL:         move.l  a6,a1           start at bottom */
    move.l a6,a1
/* QL: smash */
smash:
/* QL:         cmp.l   (a1),a1         check all test words are intact */
    cmp.l (a1),a1
/* QL:         bne.s   res_a5          if not, stop here */
    bne.s res_a5
/* QL:         cmp.l   a1,a5 */
    cmp.l a1,a5
/* QL:         add.l   a0,a1 */
    add.l a0,a1
/* QL:         bne.s   smash */
    bne.s smash
/* QL:         add.l   a0,a5           bump up available ram by 16k */
    add.l a0,a5
/* QL: find_ext */
find_ext:
/* QL:         cmp.l   a5,a4           are we up to requested/bad memory yet? */
    cmp.l a5,a4
/* QL:         bcc.s   next_add        no, try for more */
    bcc.s next_add
/* QL: res_a5 */
res_a5:
/* QL:         moveq   #64,d1          (just in case clock bits are zero) */
    moveq #64,d1
/* QL:         or.w    pc_clock+2,d1 */
    or.w (pc_clock+2),d1
/* QL:         lsl.w   #3,d1           2048 possible random starts */
    lsl.w #3,d1
/* QL:         lsr.w   #1,d1 */
    lsr.w #1,d1
/* QL:         moveq   #0,d0           permanently zero */
    moveq #0,d0
/* QL:         btst    d0,d5           check if quick reset */
    btst d0,d5
/* QL:         bne.s   onepass         if quick, only do 2nd pass */
    bne.s onepass
/* QL:         lea     do_1st,a2       set jump address for first pass */
    lea do_1st(pc),a2
/* QL: nextpass */
nextpass:
/* QL:         lea     scr1-scr2(a6),a4 beginning of ram to be tested */
    lea (scr1-scr2)(a6),a4
/* QL:         move.w  d1,a1           randomised start on entry to pass */
    move.w d1,a1
/* QL: nextlump */
nextlump:
/* QL:         add.l   a4,a1           offset by high place in rom for random pattern */
    add.l a4,a1
/* QL:         cmp.l   a1,a5           will this go beyond top of ram? */
    cmp.l a1,a5
/* QL:         bcc.s   ranok           no, use full count */
    bcc.s ranok
/* QL:         move.l  a5,a1           yes, drop back a bit */
    move.l a5,a1
/* QL: ranok */
ranok:
/* QL:         sub.l   a4,a1           this is top of pattern now */
    sub.l a4,a1
/* QL:         move.w  a1,d6 */
    move.w a1,d6
/* QL:         lsr.w   #2,d6           this is the longword counter */
    lsr.w #2,d6
/* QL:         dbra    d6,nextword     if not at end, do next longword */
    dbra d6,nextword
/* QL:         dbra    d6,*            give refresh 150ms to fall over */
    dbra d6,.
/* QL:         dbra    d6,*            another 150ms at a different memory address */
    dbra d6,.
/* QL: onepass */
onepass:
/* QL:         lea     do_logo,a2      at begining of second pass, logo checks on */
    lea do_logo(pc),a2
/* QL:         lea     logo,a3         set pointer to logo */
    lea logo(pc),a3
/* QL:         lsl.w   #8,d7           is this the second pass? */
    lsl.w #8,d7
/* QL:         bne.s   nextpass        no, so go for 2nd pass */
    bne.s nextpass
/* QL: gogogo */
gogogo:
/* QL:         move.w  #$3fe0,d0       nine bits we will adjust ssp with */
    move.w #0x3fe0,d0
/* QL:         and.w   d5,d0           pick them out of reset longword */
    and.w d5,d0
/* QL:         lsl.l   #8,d0           move them up to their right place */
    lsl.l #8,d0
/* QL:         add.l   d0,sp           set system stack pointer */
    add.l d0,sp
/* QL:         jmp     ss_init(pc)     and jump into system initialisation */
    jmp ss_init(pc)
/* QL: qfin */
qfin:
/* QL:         move.l  d0,(a4)+        clean out last bit of screen after logo */
    move.l d0,(a4)+
/* QL:         move.w  a4,d3 */
    move.w a4,d3
/* QL:         bne.s   qfin */
    bne.s qfin
/* QL:         bra.s   gogogo */
    bra.s gogogo
/* QL: iicmd */
iicmd:
/* QL:         dc.b    %11001110       trash device, send initialise */
dc_anchor_967:
.byte (0b11001110)&255
/* QL:         dc.b    $a0/2,%11011110 set device */
dc_anchor_970:
.byte ((0xa0/2))&255
.byte (0b11011110)&255
/* QL:         dc.b    1,%10100000,20  START/write address byte */
dc_anchor_974:
.byte (1)&255
.byte (0b10100000)&255
.byte (20)&255
/* QL:         dc.b    4-1,%10110000   START/read d1 four bytes, NAK last */
dc_anchor_979:
.byte ((4-1))&255
.byte (0b10110000)&255
/* QL:         dc.b    3,%10100100,22,0,8 start/write address, kill lsw boot, STOP */
dc_anchor_983:
.byte (3)&255
.byte (0b10100100)&255
.byte (22)&255
.byte (0)&255
.byte (8)&255
/* QL:         dc.b    $ff             terminate sequence */
dc_anchor_990:
.byte (0xff)&255
/* QL:         end */
