/* Generated from original/M/md/read.asm */
/* QL: * Microdrive read/verify facilities */
/* QL:         xdef    md_fsect,md_read,md_sectr,md_veril,md_verin */
.globl md_fsect,md_read,md_sectr,md_veril,md_verin
/* QL:         xref    md_endgp */
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
/* QL: * The nominal time for a single byte on a microdrive is 40us. In the read/ */
/* QL: * verify routines, we wish to cope with as wide a range of variation in tape */
/* QL: * drive speeds as we can. Two basic scenarios come up: a tape recorded on a */
/* QL: * slow drive being read back on a fast one, and visa versa. A nominal variation */
/* QL: * of 10% is documented, but as it works out, we can cope here with a variation */
/* QL: * in byte timings from 20us to 80us, i.e. a factor of two either way, which */
/* QL: * corresponds to worst case drives being 41% out of spec in opposing senses. */
/* QL:         section md_read */
.section md_read,"ax"
/* QL: * General register usage */
/* QL: * d0 timer / used by end_gp/delay etc */
/* QL: * d1 counter of bytes to be read/written / file nr read */
/* QL: * d2 sector to be found (fsect)          / block nr read */
/* QL: * d3 checksum */
/* QL: * d4 byte read / checksum compare */
/* QL: * d5 loop counter (fsect) */
/* QL: * d6 bit number for read flag in control register */
/* QL: * d7 sector number */
/* QL: * a0 read / verify entry point */
/* QL: * a1 pointer to data buffer */
/* QL: * a2 pointer to read register */
/* QL: * a3 pointer to microdrive control register */
/* QL: * a4 alternative pointer to read register */
/* QL: * a5 used by fsect only - address for sector header */
/* QL: * Find and read a specified sector header */
/* QL: * d2 -ip - sector to be found (lsb) */
/* QL: * d7 -  o- last sector number found in lsb, rest zero (not if return+0) */
/* QL: * a1 -  o- 14(a5), if all ok */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * a5 -ip - pointer to 14 byte buffer to read sector header into */
/* QL: * d0-d1/d3-d6/a2/a4 destroyed */
/* QL: * return+0 failed, return+2 ok */
/* QL: md_fsect */
md_fsect:
/* QL:         moveq   #0,d5           search up to 256 sectors for d2 */
    moveq #0,d5
/* QL: find_lop */
find_lop:
/* QL:         move.l  a5,a1           put header into (a5) */
    move.l a5,a1
/* QL:         bsr.s   md_sectr        get sector */
    bsr.s md_sectr
/* QL:         rts */
    rts 
/* QL:         bra.s   find_lop        bad sector look for another one */
    bra.s find_lop
/* QL:         cmp.b   d7,d2           found? */
    cmp.b d7,d2
/* QL:         beq.s   ret_ok */
    beq.s ret_ok
/* QL:         addq.b  #1,d5           try next sector */
    addq.b #1,d5
/* QL:         bcc.s   find_lop */
    bcc.s find_lop
/* QL:         rts                     can't find sector */
    rts 
/* QL: * Read next sector header */
/* QL: * d7 -  o- sector number in lsb, rest zero, only on good return */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 no gap found, return+2 bad sector, return+4 ok */
/* QL: md_sectr */
md_sectr:
/* QL:         jsr     md_endgp(pc)    wait for end of gap */
    jsr md_endgp(pc)
/* QL:         rts */
    rts 
/* QL:         addq.l  #2,(sp)         ... semi good return */
    addq.l #2,(sp)
/* QL:         moveq   #14-1,d1        sector header is 14 bytes */
    moveq #(14-1),d1
/* QL:         bsr.s   rblock          and read sector header */
    bsr.s rblock
/* QL:         bra.s   bad_sect */
    bra.s bad_sect
/* QL:         cmp.b   #$ff,-14(a1)    ... but is it a sector header? */
    cmp.b #(0xff&255),(-14)(a1)
/* QL:         bne.s   bad_sect */
    bne.s bad_sect
/* QL:         moveq   #0,d7 */
    moveq #0,d7
/* QL:         move.b  -14+1(a1),d7    get sector number */
    move.b ((-14)+1)(a1),d7
/* QL: ret_ok */
ret_ok:
/* QL:         addq.l  #2,(sp)         ... good return */
    addq.l #2,(sp)
/* QL: bad_sect */
bad_sect:
/* QL:         rts */
    rts 
/* QL: * Read/verify has two returns */
/* QL: * d1 -  o- file number in lsb, rest zero */
/* QL: * d2 -  o- record number in lsb, rest zero */
/* QL: * a1 -i o- 512 byte block data to read or verify, updated past end if ok */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a0/a2/a4 destroyed */
/* QL: * return+0 bad, return+2 ok */
/* QL: md_read */
md_read:
/* QL:         lea     rblock(pc),a0 */
    lea rblock(pc),a0
/* QL:         bra.s   read_ver */
    bra.s read_ver
/* QL: md_verin */
md_verin:
/* QL:         lea     vblock(pc),a0 */
    lea vblock(pc),a0
/* QL: read_ver */
read_ver:
/* QL:         jsr     md_endgp(pc)    wait for end of gap */
    jsr md_endgp(pc)
/* QL:         rts                     get out if we couldn't find one */
    rts 
/* QL:         move.l  a1,-(sp)        save block pointer */
    move.l a1,-(sp)
/* QL:         clr.w   -(sp)           clean block header on stack */
    clr.w -(sp)
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         moveq   #2-1,d1         block header is 2 bytes */
    moveq #(2-1),d1
/* QL:         bsr.s   rblock          and read block header */
    bsr.s rblock
/* QL:         bra.s   bad_blok        failed */
    bra.s bad_blok
/* QL:         move.b  #pc.read,d1     set up pll reset byte */
    move.b #(pc.read&255),d1
/* QL:         move.b  d1,(a3)         reset pll */
    move.b d1,(a3)
/* QL:         delay   25              wait for a zero to clock through */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL: qdbra maclab 21 to 309 step 2 us */
/* QL:  moveq #([us]*15-50)/36,d0 six byte sequence */
    moveq #(((25*15)-50)/36),d0
/* QL:  dbra d0,* */
    dbra d0,.
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.b  d1,(a3)         reset controller */
    move.b d1,(a3)
/* QL:         move.w  #512-1,d1       read 512 byte block */
    move.w #(512-1),d1
/* QL:         move.l  2(sp),a1        restore a1 */
    move.l 2(sp),a1
/* QL:         jsr     (a0)            read / verify */
    jsr (a0)
/* QL:         bra.s   bad_blok        failed - hmmm... why set d1/d2, as undef above */
    bra.s bad_blok
/* QL:         addq.l  #2,6(sp)        change over to a good return */
    addq.l #2,6(sp)
/* QL: bad_blok */
bad_blok:
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.b  1(sp),d2        funny motorola stack handling */
    move.b 1(sp),d2
/* QL:         move.b  (sp)+,d1 */
    move.b (sp)+,d1
/* QL:         addq.l  #4,sp           remove buffer address */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * d1 -i  - byte count less one */
/* QL: * a1 -i o- buffer address, updated past last byte */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 bad, return+2 ok */
/* QL: rblock */
rblock:
/* QL:         moveq   #0,d4           upper part of data word */
    moveq #0,d4
/* QL:         bra.s   rvcomm */
    bra.s rvcomm
/* QL: * Verify long block - has two returns */
/* QL: * a1 -i o- long (512+98) block data to be verified, if ok, updated past end */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0-d1/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 verify failed, return+2 ok */
/* QL: md_veril */
md_veril:
/* QL:         jsr     md_endgp(pc)    wait for end of gap */
    jsr md_endgp(pc)
/* QL:         rts                     gap not seen */
    rts 
/* QL:         move.w  #2+2+8+512+86-1,d1 long block used when formatting */
    move.w #(((((2+2)+8)+512)+86)-1),d1
/* QL:         bsr.s   vblock          verify it */
    bsr.s vblock
/* QL:         rts                     verification failed */
    rts 
/* QL: plustwo */
plustwo:
/* QL:         addq.l  #2,(sp)         good return */
    addq.l #2,(sp)
/* QL:         rts */
    rts 
/* QL: read_byt macro ; min 74, max 674 (d0=21-1, d0 * 30 in loop) */
/* QL: verif */
verif:
/* QL:         cmp.b   (a1)+,d4     12+contention compare byte */
    cmp.b (a1)+,d4
/* QL:         dbne    d1,rvloop 18/26 (or 20 = fall out on bad verify) */
    dbne d1,rvloop
/* QL:         bne.s   rvb_exit  18/12 give up if byte failed to verify */
    bne.s rvb_exit
/* QL: * Read checksum */
/* QL: * Time from last read or verify = 158 cycles 21.1 us max */
/* QL: * Time for the single loop = 126, so on average, 142 should be fine! */
/* QL: * Note d1 is equal to -1 */
/* QL: checksum */
checksum:
/* QL:         read_byt      ; (674)74 wait for next byte */
/* QL: wait[.l] */
wait2:
/* QL:         btst    d6,(a3)      12 * wait for bit set */
    btst d6,(a3)
/* QL:         dbne    d0,wait[.l] 18/20 loop/ne or 26 on timeout */
    dbne d0,wait2
/* QL:         beq.s   rvb_exit  18/12 get out now if we are too far off spec */
    beq.s rvb_exit
/* QL:         move.b  (a2),d4      12 * read byte, at least 44 cycles since flag set */
    move.b (a2),d4
/* QL:         exg     a2,a4        10 toggle read address */
    exg a4,a2
/* QL:         moveq   #21-1,d0      8 reset read timeout to one byte, half speed */
    moveq #(21-1),d0
/* QL:         ror.w   #8,d4        26 move byte round */
    ror.w #8,d4
/* QL:         addq.w  #1,d1         8 increment counter */
    addq.w #1,d1
/* QL:         beq.s   checksum  18/12 go for other byte */
    beq.s checksum
/* QL:         cmp.w   d4,d3           is checksum correct? */
    cmp.w d4,d3
/* QL:         beq.s   plustwo         yes, so go do return+2 */
    beq.s plustwo
/* QL: rvb_exit */
rvb_exit:
/* QL:         rts */
    rts 
/* QL: * d1 -i  - byte count less one */
/* QL: * a1 -i o- buffer address, updated past last byte */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 bad, return+2 ok */
/* QL: vblock */
vblock:
/* QL:         moveq   #1,d4           upper part of data word */
    moveq #1,d4
/* QL:         ror.l   #1,d4           put flag in msb for verify */
    ror.l #1,d4
/* QL: rvcomm */
rvcomm:
/* QL:         move.w  #$0f0f,d3       set up checksum register */
    move.w #0x0f0f,d3
/* QL:         moveq   #pc..rxrd,d6    check for read */
    moveq #pc..rxrd,d6
/* QL:         lea     pc_trak1-pc_mctrl(a3),a2 set up read addresses */
    lea (pc_trak1-pc_mctrl)(a3),a2
/* QL:         lea     pc_trak2-pc_mctrl(a3),a4 */
    lea (pc_trak2-pc_mctrl)(a3),a4
/* QL:         move.w  #257-1,d0       wait for up to 1 ms before giving up 1st byte */
    move.w #(257-1),d0
/* QL: rvloop */
rvloop:
/* QL:         read_byt      ; (674)74 get the next byte (7754 on very 1st byte) */
/* QL: wait[.l] */
wait3:
/* QL:         btst    d6,(a3)      12 * wait for bit set */
    btst d6,(a3)
/* QL:         dbne    d0,wait[.l] 18/20 loop/ne or 26 on timeout */
    dbne d0,wait3
/* QL:         beq.s   rvb_exit  18/12 get out now if we are too far off spec */
    beq.s rvb_exit
/* QL:         move.b  (a2),d4      12 * read byte, at least 44 cycles since flag set */
    move.b (a2),d4
/* QL:         exg     a2,a4        10 toggle read address */
    exg a4,a2
/* QL:         moveq   #21-1,d0      8 reset read timeout to one byte, half speed */
    moveq #(21-1),d0
/* QL:         add.w   d4,d3         8 add byte to checksum */
    add.w d4,d3
/* QL:         tst.l   d4            8 read or verify */
    tst.l d4
/* QL:         bmi.s   verif     18/12 branch out for verify, so loop ends match up */
    bmi.s verif
/* QL:         move.b  d4,(a1)+     12+contention store it */
    move.b d4,(a1)+
/* QL:         dbra    d1,rvloop 18/26 */
    dbra d1,rvloop
/* QL:         bra.s   checksum     18 */
    bra.s checksum
/* QL: * Read(verify) loop is >= 132(150) cycles. Bear in mind that the verify really */
/* QL: * must be occurring on the same hardware! It should be near perfect! */
/* QL: * In essense, we should be able to cope with a read data rate which is well */
/* QL: * over twice specification! (17.6us per byte). */
/* QL: * We also tolerate even greater factor slower data rates (97.6us per byte). */
/* QL: * These correspond to worst case drive speeds, in both senses, of over 50%. */
/* QL: * Actually, our worst case may crop up with a block header. If we just miss */
/* QL: * seeing the first data ready flag, and we must take the first checksum byte */
/* QL: * before the second comes up. (Or does buffering mean this is is no problem?) */
/* QL: * This will be 29(late)+132(data)+132(data)+158(1st checksum)=451 cycles, which */
/* QL: * must not exceed 3 byte periods. It is only just over 20us, still OK. */
/* QL:         vect4000 md_read,md_sectr,md_verin */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl md$read
/* QL: [o]     equ     [h]-$4000 */
.equ md$read,(md_read-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl md$sectr
/* QL: [o]     equ     [h]-$4000 */
.equ md$sectr,(md_sectr-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl md$verin
/* QL: [o]     equ     [h]-$4000 */
.equ md$verin,(md_verin-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
