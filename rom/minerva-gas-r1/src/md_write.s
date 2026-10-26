/* Generated from original/M/md/write.asm */
/* QL: * All microdrive write bits */
/* QL:         xdef    md_wblok,md_write */
.globl md_wblok,md_write
/* QL:         include 'win1_m_inc_delay' */
/* QL: ; delay for a given number of microseconds - destroys d0 */
/* QL:         nolist */
/* QL: delay   macro   us */
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
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section md_write */
.section md_write,"ax"
/* QL: * d0   s used by delay */
/* QL: * d1 c s counter of bytes to be read/written (call wblok only) */
/* QL: * d3   s checksum */
/* QL: * d4   s byte to be written */
/* QL: * d5   s inner loop counter */
/* QL: * d6   s bit number of control bit in cont register */
/* QL: * a0   s saved value of a1 */
/* QL: * a1 cr  buffer pointer */
/* QL: * a2   s pointer to transmit register */
/* QL: * a3 c   pointer to microdrive control register */
/* QL: * a4   s subroutine return address */
/* QL: tdoff   equ     pc_tdata-pc_mctrl */
.equ tdoff,(pc_tdata-pc_mctrl)
/* QL: md_write */
md_write:
/* QL:         move.b  #pc.erase,(a3)  erase on */
    move.b #(pc.erase&255),(a3)
/* QL:         delay   (3600-40)       wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #((((3600-40)*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.l  a1,a0           08  save buffer pointer */
    move.l a1,a0
/* QL:         lea     4(sp),a1        16  set pointer to header */
    lea 4(sp),a1
/* QL:         moveq   #2-1,d1         08  ... of two bytes */
    moveq #(2-1),d1
/* QL:         lea     wr_rec(pc),a4   16  return to write record */
    lea wr_rec(pc),a4
/* QL:         bra.s   wr_init         18  ... when init and written header */
    bra.s wr_init
/* QL: wr_rec */
wr_rec:
/* QL:         move.l  a0,a1           08  reset buffer pointer */
    move.l a0,a1
/* QL:         move.w  #$1ff,d1        16  ... record of 512 bytes */
    move.w #0x1ff,d1
/* QL:         moveq   #6-1,d5         08  preamble of 6+2 bytes */
    moveq #(6-1),d5
/* QL:         lea     end_wr(pc),a4   16  return to exit */
    lea end_wr(pc),a4
/* QL:         bra.s   wr_inpre        18  ... when record written */
    bra.s wr_inpre
/* QL: end_wr */
end_wr:
/* QL:         moveq   #pc.read,d4     write off / erase off */
    moveq #pc.read,d4
/* QL: exit */
exit:
/* QL:         delay   120             wait for bytes to go away */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL: qdbra maclab 21 to 309 step 2 us */
/* QL:  moveq #([us]*15-50)/36,d0 six byte sequence */
    moveq #(((120*15)-50)/36),d0
/* QL:  dbra d0,* */
    dbra d0,.
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.b  d4,(a3)         turn off */
    move.b d4,(a3)
/* QL:         rts */
    rts 
/* QL: md_wblok */
md_wblok:
/* QL:         lea     end_wb(pc),a4   16  return to end_wb */
    lea end_wb(pc),a4
/* QL:         bra.s   wr_init         18  ... when we have initialised and written */
    bra.s wr_init
/* QL: end_wb */
end_wb:
/* QL:         moveq   #pc.erase,d4    write off / erase on */
    moveq #pc.erase,d4
/* QL:         bra.s   exit            after delay */
    bra.s exit
/* QL: wr_init */
wr_init:
/* QL:         moveq   #pc.write,d0    08  enable write */
    moveq #pc.write,d0
/* QL:         move.b  d0,(a3)      12+08 */
    move.b d0,(a3)
/* QL:         move.b  d0,(a3)      12+08 */
    move.b d0,(a3)
/* QL:         moveq   #pc..txfl,d6    08  buffer full bit in microdrive read register */
    moveq #pc..txfl,d6
/* QL:         lea     tdoff(a3),a2    16  pointer to transmit register */
    lea tdoff(a3),a2
/* QL:         moveq   #9,d5           08  10 byte preamble */
    moveq #9,d5
/* QL: wr_inpre */
wr_inpre:
/* QL:         moveq   #0,d4           08  ... of zero */
    moveq #0,d4
/* QL: wr_pream */
wr_pream:
/* QL:         bsr.s   wbyte       102+72  write preamble bytes in a loop */
    bsr.s wbyte
/* QL:         subq.b  #1,d5           08 */
    subq.b #1,d5
/* QL:         bge.s   wr_pream     12/18 */
    bge.s wr_pream
/* QL:         moveq   #-1,d4          08  two bytes of ff */
    moveq #(-1),d4
/* QL:         bsr.s   wbyte       102+72 */
    bsr.s wbyte
/* QL:         bsr.s   wbyte       102+72 */
    bsr.s wbyte
/* QL:         move.w  #$0f0f,d3       16  initialise checksum */
    move.w #0x0f0f,d3
/* QL:         moveq   #0,d4           08  clear upper part of word */
    moveq #0,d4
/* QL: wr_loop */
wr_loop:
/* QL:         move.b  (a1)+,d4     12+08  fetch next byte */
    move.b (a1)+,d4
/* QL:         add.w   d4,d3           08  accumulate checksum */
    add.w d4,d3
/* QL:         bsr.s   wbyte       102+72  146-226 cycles 19.5-30.1 us since preamble */
    bsr.s wbyte
/* QL:         dbra    d1,wr_loop   26/18  loop is 140-220 cycles 18.7-29.3 us */
    dbra d1,wr_loop
/* QL:         move.w  d3,d4           08  write lsb first */
    move.w d3,d4
/* QL:         bsr.s   wbyte       102+72  136-208 cycles 18.1-27.7us since last write */
    bsr.s wbyte
/* QL:         lsr.w   #8,d4           26  now msb */
    lsr.w #8,d4
/* QL:         bsr.s   wbyte       102+72 */
    bsr.s wbyte
/* QL:         jmp     (a4)            16 */
    jmp (a4)
/* QL: * Write a byte */
/* QL: wbyte */
wbyte:
/* QL:         btst    d6,(a3)      12+08  is it ready for byte? */
    btst d6,(a3)
/* QL:         bne.s   wbyte        12/18 */
    bne.s wbyte
/* QL:         move.b  d4,(a2)      12(08) move byte to transmit register */
    move.b d4,(a2)
/* QL:         rts                  32+32 */
    rts 
/* QL: * Single byte write including bsr (34+32): 102-172 cycles 13.6-22.9 us */
/* QL: * Critical time is write checksum to first byte of record preamble */
/* QL: * In wbyte     32+32 */
/* QL: *  jmp (a4)    16 */
/* QL: * In wr_rec    66 */
/* QL: * In wr_rpet   42+32 */
/* QL: * In wbytes    36 */
/* QL: *     192+64=256 cycles 34.1 us */
/* QL:         vect4000 md_write */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl md$write
/* QL: [o]     equ     [h]-$4000 */
.equ md$write,(md_write-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
