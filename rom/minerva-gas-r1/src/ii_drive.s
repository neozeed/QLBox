/* Generated from original/M/ii/drive.asm */
/* QL: * Inter-integrated circuit (IIC or I squared C) bus driver */
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
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL: * Timing requirements for the I2C bus: */
/* QL: * f SCL (100khz = 75 cycles) must not be exceeded. */
/* QL: * t buf (4.7us + max 1us < 43 cycles) is fine, as we'll be between controls. */
/* QL: * t hd;sta (4.0us + max 300ns < 33 cycles) is similar. */
/* QL: * t low (SCL) (4.7us + max 300ns < 38 cycles) is one main constraint. */
/* QL: * t high (SCL) (4.0us + max 1us < 38 cycles) is the other main constraint. */
/* QL: * t su;sta (4.7us + max 1us < 43 cycles) is "between controls", so it's easy. */
/* QL: * t hd;dat we will assume zero, as we're not into cbus compatibility (yet?). */
/* QL: * t su;dat (250ns < 2 cycles) means we can use ".w" instructions! */
/* QL: * t su;sto (4.7us + max 1us < 43 cycles) we can cope with. */
/* QL: * Our waveform for SCL should come out as 38/38 cycles, to get it all right. */
/* QL: * We will work on the basis of using no write accesses to RAM, so we can use */
/* QL: * this code during boot up. */
/* QL: * While addressing a device, we will check that we are seeing on SDAin what we */
/* QL: * are sending on SDAout, and return err.ff if there is a mismatch, i.e. the */
/* QL: * board isn't an I2C Minerva. */
/* QL: * If the acknowledge for a device fails we report err.nf which on boot up will */
/* QL: * just mean the battery backed up RAM and clock is not fitted. */
/* QL: * The first thing on boot up will be to waggle SDA and SCL about with an */
/* QL: * "initialise" sequence, just in case the machine has been rebooted in the */
/* QL: * midst of a read sequence. */
/* QL: * The RAM/clock chip is device $a0 giving a good chance of recognising old */
/* QL: * Minerva boards, as we will be expecting to see a mix of ones and zeros on */
/* QL: * SDAin as we address it. */
/* QL: * We will try to make the interface pretty clever, but not too clever. */
/* QL: * Wequencing will be done by bytes from a read only "control" buffer. */
/* QL: * The device address will be held in a register, but a control will enable */
/* QL: * this to be replaced from the control buffer. */
/* QL: * The crux of the matter comes when we are asked to do multi-byte transfers to */
/* QL: * or from a RAM buffer. This part of the code is the only part that must be */
/* QL: * able to run as close to the maximum clock rate as we can manage. All other */
/* QL: * actions can limp along as slow as is convenient. */
/* QL: * It will be possible to carry out a sequence containing multiple reads and/or */
/* QL: * writes in an uninterruptable fashion. The prime one needed at present being */
/* QL: * to suspend the clock by writing to location 0, reading back locations and */
/* QL: * then releasing the clock to count again. Although this could be done by */
/* QL: * several calls, we will allow for it to be done in a single call, saving us */
/* QL: * some time when time is in fact a little important: we would like to be able */
/* QL: * to use the 1/100th second timing information with some accuracy. */
/* QL: * Write sequences will have the option of sending data bytes from either the */
/* QL: * data buffer or the control buffer. When reading, the bytes will go to either */
/* QL: * the data buffer or be rolled into a register. */
/* QL: * The control buffer will be organised as a series of individual bytes: */
/* QL: * Parameter build byte: */
/* QL: * */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |  */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |  0  |        seven parameter data bits        | */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: * */
/* QL: * The contents of the parameter byte are shifted left seven bits, and this byte */
/* QL: * is "or"'ed into it. A contiguous sequence of five of these can be used to set */
/* QL: * up a full 32 bits of parameter. Only two uses of this are currently made. */
/* QL: * A single byte is used before a special command which is to copy it to the */
/* QL: * device group register, So we can change devices during a sequence. The other */
/* QL: * usage is to set up the byte count for a normal i/o command. This will only */
/* QL: * make use of a 16-bit count, and may need anything from zero to three of these */
/* QL: * parameter build bytes. The parameter register is always cleared to zero after */
/* QL: * each of the normal I/O and special byte types has been processed. */
/* QL: * Normal input/output byte: */
/* QL: * */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |  */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |  1  |  0  |  s  |  r  |  b  |  p  |  a  |  0  | */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: * */
/* QL: * The bits of this byte are essentially handled from left to right, to allow */
/* QL: * the most typical i/o sequence to be handled in its entirety. */
/* QL: * */
/* QL: * s = 0: no START required */
/* QL: * s = 1: send START and device */
/* QL: * r = 0: write mode, or r = 1: read mode */
/* QL: * b = 0: if r=0, write from control, or r=1 read to register */
/* QL: * b = 1: write/read uses data buffer */
/* QL: * p = 1: send STOP sequence */
/* QL: * a = 1: send acknowledge on last read (r=1) byte */
/* QL: * */
/* QL: * r=0 and a=1 is invalid, as is r=1, p=1 and a=1. Also bit 0 must be clear. If */
/* QL: * these conditions are not met, an err.bp is reported after processing all but */
/* QL: * the p bit. */
/* QL: * */
/* QL: * The parameter value specifies the exact byte count for a write sequence, but */
/* QL: * on a read (r=1) sequence, it counts only those bytes to be acknowledged. If */
/* QL: * r=1 and a=0, the final byte with standard non-acknowledge is extra. */
/* QL: * Write sequence data byte: */
/* QL: * */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |  */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |                   data byte                   | */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: * */
/* QL: * If a normal I/O byte requests writes from this control buffer, it will be */
/* QL: * immediately followed by the appropriate number of data bytes to be written. */
/* QL: * Special I/O and control byte: */
/* QL: * */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |  */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: *       |  1  |  1  |  g  |  v  |  d  |  c  |  1  |  q  | */
/* QL: *       +-----+-----+-----+-----+-----+-----+-----+-----+ */
/* QL: * */
/* QL: * Once again, the bits are handled from left to right, and these control all */
/* QL: * the exceptional cases we wish to cope with. Note that the SDA and SCL setting */
/* QL: * will occur simultaneously, hence to be valid, only one should differ from its */
/* QL: * currently known state. If v=0, the state will always be both ones before they */
/* QL: * are applied, so the combination of v, d and s all zero is always invalid. */
/* QL: * */
/* QL: * g = 0: set device group addresses as 2 * current parameter value */
/* QL: * g = 1: assume device group is already in its register */
/* QL: * v = 0: kill bus (assume nothing about bus, ensure in standard free state) */
/* QL: * v = 1: assume the bus is valid, whatever state it is in */
/* QL: * d = d: set SDA  */
/* QL: * c = c: set SCL */
/* QL: * q = quit */
/* QL: * */
/* QL: * Note that bit 1 is reserved and must be set, or an err.bp is reported after */
/* QL: * precessing the g and v bits, but before setting the d/c combination */
/* QL: * */
/* QL: * The control buffer must finish up with a special command that has its quit */
/* QL: * (lsb) set. Normally this will be all ones, but where the bus is not being */
/* QL: * released between calls a value of $fb, keeping SDA high and SCL low, will be */
/* QL: * typical. */
/* QL: * The general rules for the bus go as follows: */
/* QL: * Before a START+device, SDA should be high. */
/* QL: * After a START+device, SDA will be high and SCL will be low. */
/* QL: * For a read/write, SDA high and SCL low are required and are left the same. */
/* QL: * Before a STOP, SCL low is expected and both SDA and SCL will be left high. */
/* QL: * Before an initialise, SDA and SCL are irrelevant, after, they are high. */
/* QL: * When using the "special" command, only one of SDA and SCL should be changed */
/* QL: * at one time. When it includes an initialise, both should not be sent low. */
/* QL: * When errors are returned, the rules are modified. */
/* QL: * An err.ff means that the bus did not seem to be responding to the device */
/* QL: * address correctly. This should mean it's an old Minerva board. */
/* QL: * An err.nf just means that the addressed I2C device is not present. A STOP */
/* QL: * sequence will have been sent to leave SDA and SCL high. */
/* QL: * An err.te means a write sequence failed to get its acknowledge on a byte, */
/* QL: * and a STOP will have been issued to leave SDA and SCL high. */
/* QL: * An err.bp means the control buffer had a duff command in it. A normal I/O */
/* QL: * sequence will not have had any STOP sent and a special will have left SDA and */
/* QL: * SCL unchanged unless an initialise was done, when both will be high. */
/* QL: * The call sequence for this code should be in supervisor mode with interrupts */
/* QL: * turned off for maximum speed. If speed is not a constraint, it may not only */
/* QL: * be called with interrpts on, and even in user mode, but, as it preserves a6, */
/* QL: * it may then even be called direct from superbasic. */
/* QL: * The "front end" entry saves more registers, on the assumption that there is */
/* QL: * a valid stack available. Eight bytes further in is the entry point that zaps */
/* QL: * loads more registers, and so on, but requires no stack. */
/* QL: * Registers are expected as follows: */
/* QL: * d0 returns (with ccr) any error code, zero for success. */
/* QL: * d1 if read to register, bytes roll in here, lsb is last. otherwise untouched. */
/* QL: * d2 0 or maybe device and/or maybe (msb's) of first parameter (see below) */
/* QL: * d3 on exit, the control buffer address, updated to wherever we got to. */
/* QL: * d4 destroyed. */
/* QL: * d5 lsb only destroyed. */
/* QL: * d6 lsb only destroyed. */
/* QL: * d7 untouched. */
/* QL: * a0 the return address. */
/* QL: * a1 data buffer address. if used, it will be updated, otherwise untouched. */
/* QL: * a3 on entry, the control buffer address */
/* QL: * a2-a5 these are set here to the four byte addresses of the interface. */
/* QL: * a6 untouched. */
/* QL: * a7 untouched. */
/* QL: * The device and/or part or all of the initial parameter may be passed in d2. */
/* QL: * An initial device should be in bits 22-16, and the initial parameter may be */
/* QL: * in bits 15-0, or partially in bits 8-0 or bits 1-0. */
/* QL: * If the command byte sequence sets the device, bits 31-16 will be copied from */
/* QL: * the current value of the parameter (bits 15-0), then it will be zeroed, as it */
/* QL: * will be after any normal I/O sequence. */
/* QL: * The parameter value (bits 15-0) is rolled left 7 bits as each new parameter */
/* QL: * setting byte (positive) is encountered, to include it. */
/* QL: * On exit, bits 31-16 will be as one might expect, containing whatever was */
/* QL: * there to start with, or the copied parameter value if the device was set. */
/* QL: * Bits 15-0 will be the final value of the parameter, at whatever point the */
/* QL: * sequence was terminated. Typically, after a succesful transfer of data, it */
/* QL: * will be zero. */
/* QL: * The instructions marked with (***) bolow are slightly suspect. They squeeze */
/* QL: * out an extra 2 cycles by needing a compare long, but this may well come */
/* QL: * after the read of the second byte, as it is involved with extending word to */
/* QL: * long for address register comparisons. It's only 1.5 cycles (4%) out so we */
/* QL: * will see if we can get away with it. The alternative is to make it read the */
/* QL: * two bytes in separate instructions which will put us 6.5 cycles over, and */
/* QL: * break up the, so far, pure uniformity of bit access rate. */
/* QL:         section ii_drive */
.section ii_drive,"ax"
/* QL: * Front end for somewhat less destructive access. Preserves d3-d6, a0/a2/a4-a5. */
/* QL: drv_end */
drv_end:
/* QL:         move.l  d3,a3 */
    move.l d3,a3
/* QL:         movem.l (sp)+,d3-d6/a0/a2/a4-a5 */
    movem.l (sp)+,d3-d6/a0/a2/a4-a5
/* QL:         rts */
    rts 
/* QL: ii_drive */
ii_drive:
/* QL:         movem.l d3-d6/a0/a2/a4-a5,-(sp) */
    movem.l d3-d6/a0/a2/a4-a5,-(sp)
/* QL:         lea     drv_end,a0 */
    lea drv_end(pc),a0
/* QL: * Entry point needing no RAM at all */
/* QL: ii_raw */
ii_raw:
/* QL:         move.l  a3,d3 */
    move.l a3,d3
/* QL:         lea     $bfdc,a4 */
    lea 0xbfdc,a4
/* QL:         lea     1(a4),a5 */
    lea 1(a4),a5
/* QL:         lea     2(a4),a2 */
    lea 2(a4),a2
/* QL:         lea     3(a4),a3 */
    lea 3(a4),a3
/* QL:         cmp.l   #'gold',$4000a  hopefully, a magic test for the gold card */
    cmp.l #1735355492,0x4000a
/* QL:         bne.s   new_cmd         if not a gc, we're operating ok */
    bne.s new_cmd
/* QL: err_ff */
err_ff:
/* QL:         moveq   #err.ff,d0      say that the I2C is not working */
    moveq #err.ff,d0
/* QL:         jmp     (a0)            go home */
    jmp (a0)
/* QL: parm */
parm:
/* QL:         lsl.w   #7,d2           shift any existing parameter data up */
    lsl.w #7,d2
/* QL:         or.b    d5,d2           put in next seven bits */
    or.b d5,d2
/* QL: new_cmd */
new_cmd:
/* QL:         exg     a1,d3 */
    exg a1,d3
/* QL:         move.b  (a1)+,d5        get next command byte */
    move.b (a1)+,d5
/* QL:         exg     a1,d3 */
    exg a1,d3
/* QL:         bpl.s   parm            if msb is clear, rest is 7 bits of parameter */
    bpl.s parm
/* QL:         asl.b   #2,d5           check next two bits, 6=special, 5=normal */
    asl.b #2,d5
/* QL:         bcs.l   special         11xxxxxx - go do special command sequence */
    bcs.w special
/* QL:         bpl.s   started         100xxxxx - no START sequence wanted */
    bpl.s started
/* QL: * 101xxxxx - send START sequence plus device */
/* QL:         tst.b   (a3)         12 SDA high, assure that SCL is high */
    tst.b (a3)
/* QL:         rol.b   #3,d5        16 waste time */
    rol.b #3,d5
/* QL:         ror.b   #3,d5        16 waste time */
    ror.b #3,d5
/* QL:         tst.b   (a5)         12 SCL high, set SDA low for START */
    tst.b (a5)
/* QL:         move.b  d5,d6         8 take a copy of command to get w/r bit */
    move.b d5,d6
/* QL:         asl.b   #2,d6        14 put w/r = 0/1 into x */
    asl.b #2,d6
/* QL:         move.l  d2,d0         8 copy device */
    move.l d2,d0
/* QL:         swap    d0            8 get device number bits 7-1 */
    swap d0
/* QL:         tst.b   (a4)         12 SDA low, set SCL low */
    tst.b (a4)
/* QL:         tas     d0            8 set top bit for clever code */
    tas d0
/* QL:         addx.b  d0,d0         8 roll r/w into register, one to x */
    addx.b d0,d0
/* QL:         addx.b  d0,d0         8 roll first bit (bit 7) to x as d, one to lsb */
    addx.b d0,d0
/* QL: devlp */
devlp:
/* QL:         clr.w   d4            8 clear our data offset register */
    clr.w d4
/* QL:         roxl.b  #2,d4        14 set 0 for SDA low, 2 for SDA high */
    roxl.b #2,d4
/* QL:         tst.w   0(a4,d4.w)   22 SCL low, set SDA data, then SCL high */
    tst.w 0(a4,d4.w)
/* QL:         move.b  1(a4,d4.w),d6 22 SDA data, SCL high, verify data */
    move.b 1(a4,d4.w),d6
/* QL:         tst.b   0(a4,d4.w)   22 SDA data, set SCL low */
    tst.b 0(a4,d4.w)
/* QL:         bchg    d4,d6        12 toggle lsb if we were try to send a zero bit */
    bchg d4,d6
/* QL:         asr.b   #1,d6        12 peel out that bit */
    asr.b #1,d6
/* QL:         bcc.s   err_ff   12 b18 if it's not set now, we have a problem!  */
    bcc.s err_ff
/* QL:         add.b   d0,d0         8 fetch out next data bit */
    add.b d0,d0
/* QL:         bne.s   devlp    12 b18 if this isn't our marker one going out, loop */
    bne.s devlp
/* QL:         tst.w   (a2)         20 SCL low, set SDA high, then SCL high */
    tst.w (a2)
/* QL:         moveq   #1,d0         8 mask for lsb */
    moveq #1,d0
/* QL:         and.b   (a3),d0      12 sample SDAin */
    and.b (a3),d0
/* QL:         beq.s   devok    12 b18 if we have an acknowledge, all is ok */
    beq.s devok
/* QL:         moveq   #err.nf,d0      say we didn't find the device */
    moveq #err.nf,d0
/* QL: stopit */
stopit:
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         tst.b   (a4)         12 SCL low, set SDA low */
    tst.b (a4)
/* QL:         rol.b   #8,d0        26 waste some time */
    rol.b #8,d0
/* QL:         tst.b   (a5)         12 SDA low, set SCL high */
    tst.b (a5)
/* QL:         rol.b   #8,d0        26 waste some time */
    rol.b #8,d0
/* QL:         nop                   8 waste even more time (3 cycles to many) */
    nop 
/* QL:         tst.b   (a3)         12 SCL high, set SDA high: STOP */
    tst.b (a3)
/* QL:         tst.l   d0              make sure ccr is set */
    tst.l d0
/* QL:         jmp     (a0)            go home */
    jmp (a0)
/* QL: devok */
devok:
/* QL:         tst.b   (a2)         12 SDA is high, set SCL low */
    tst.b (a2)
/* QL: started */
started:
/* QL:         asl.b   #2,d5        14 roll out r/w and buffer to msb */
    asl.b #2,d5
/* QL:         bcs.l   reader   12 b18 go do read sequence */
    bcs.w reader
/* QL:         bmi.s   writer   12 b18 if write from control buffer, we're ready */
    bmi.s writer
/* QL:         exg     a1,d3         8 use data buffer instead of command buffer */
    exg a1,d3
/* QL:         bra.s   writer      b18 go start writing */
    bra.s writer
/* QL: noack */
noack:
/* QL:         moveq   #err.te,d0      transmission error */
    moveq #err.te,d0
/* QL:         add.b   d5,d5           did we swap control/data buffers */
    add.b d5,d5
/* QL:         bcs.s   stopit          no, go set the ack error */
    bcs.s stopit
/* QL:         exg     a1,d3           put back control and data pointers */
    exg a1,d3
/* QL:         bra.s   stopit          go send a STOP */
    bra.s stopit
/* QL: wbllp */
wbllp:
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         tst.b   (a4)         12 SDA is low, put SCL low */
    tst.b (a4)
/* QL:         add.b   d6,d6         8 check next bit */
    add.b d6,d6
/* QL:         bpl.s   wblow    12 b18 if writing zero, we're ready */
    bpl.s wblow
/* QL:         cmp.w   (a2),a2      18 SCL is low, set SDA high, set SCL high (***) */
    cmp.w (a2),a2
/* QL:         dbra    d4,wbhlp 26 b18 if more bits, go see about them */
    dbra d4,wbhlp
/* QL:         tst.b   (a2)         12 SDA is high, put SCL low */
    tst.b (a2)
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         bra.s   chkack      b18 go check acknowledge */
    bra.s chkack
/* QL: wbhigh */
wbhigh:
/* QL:         tst.b   (a3)         12 SDA is high, set SCL high */
    tst.b (a3)
/* QL:         dbra    d4,wbhlp 26 b18 if more bits, go see about them */
    dbra d4,wbhlp
/* QL:         tst.b   (a2)         12 SDA is high, put SCL low */
    tst.b (a2)
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         bra.s   chkack      b18 go check acknowledge */
    bra.s chkack
/* QL: wbhlp */
wbhlp:
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         tst.b   (a2)         12 SDA is high, put SCL low */
    tst.b (a2)
/* QL:         add.b   d6,d6         8 check next bit */
    add.b d6,d6
/* QL:         bmi.s   wbhigh   12 b18 if writing one, we're ready */
    bmi.s wbhigh
/* QL:         cmp.w   (a4),a4      18 SCL is low, set SDA low, set SCL high (***) */
    cmp.w (a4),a4
/* QL:         tst.b   (a5)         12 SDA is low, set SCL high */
    tst.b (a5)
/* QL:         dbra    d4,wbllp 26 b18 if more bits, go see about them */
    dbra d4,wbllp
/* QL:         tst.b   (a4)         12 SDA is low, set SCL low */
    tst.b (a4)
/* QL:         tst.b   (a2)         12 SCL is low, set SDA high */
    tst.b (a2)
/* QL:         asl.l   #1,d0        14 waste cycles to get timing right */
    asl.l #1,d0
/* QL: chkack */
chkack:
/* QL:         move.b  (a3),d0      12 set SCL high and sample at the same time */
    move.b (a3),d0
/* QL:         asr.l   #1,d0        14 check if the ack was there (squeeze 2 cycles) */
    asr.l #1,d0
/* QL:         bcs.s   noack    12 b18 argh! go zap this transfer */
    bcs.s noack
/* QL:         tst.b   (a2)         12 so, all is ok, drop SCL */
    tst.b (a2)
/* QL: writer */
writer:
/* QL:         dbra    d2,wbyte 26 b18 see if we've got any more to do */
    dbra d2,wbyte
/* QL:         bra.s   wrdone */
    bra.s wrdone
/* QL: wbyte */
wbyte:
/* QL:         moveq   #8-1,d4       8 set for another 8 bits */
    moveq #(8-1),d4
/* QL:         move.b  (a1)+,d6     12 get the next byte */
    move.b (a1)+,d6
/* QL:         bmi.s   wbhigh      b18 if it has msb set, we're ready */
    bmi.s wbhigh
/* QL:         tst.b   (a4)         12 SCL is low, set SDA low */
    tst.b (a4)
/* QL: wblow */
wblow:
/* QL:         tst.b   (a5)         12 SDA is low, set SCL high */
    tst.b (a5)
/* QL:         dbra    d4,wbllp 26 b18 if more bits, go see about them */
    dbra d4,wbllp
/* QL:         tst.b   (a4)         12 SDA is low, set SCL low */
    tst.b (a4)
/* QL:         tst.b   (a2)         12 SCL is low, set SDA high */
    tst.b (a2)
/* QL:         asl.l   #1,d0        14 waste cycles to get timing right */
    asl.l #1,d0
/* QL:         move.b  (a3),d0      12 set SCL high and sample at the same time */
    move.b (a3),d0
/* QL:         asr.l   #1,d0        14 check if the ack was there (squeeze 2 cycles) */
    asr.l #1,d0
/* QL:         bcs.s   noack    12 b18 argh! go zap this transfer */
    bcs.s noack
/* QL:         tst.b   (a2)         12 so, all is ok, drop SCL */
    tst.b (a2)
/* QL:         dbra    d2,wbyte 26 b18 see if we've got any more to do */
    dbra d2,wbyte
/* QL: wrdone */
wrdone:
/* QL:         add.b   d5,d5           did we swap control/data buffers */
    add.b d5,d5
/* QL:         bcs.s   chkstop         no, skip swap */
    bcs.s chkstop
/* QL:         exg     a1,d3           put back control and data pointers */
    exg a1,d3
/* QL: chkstop */
chkstop:
/* QL:         add.b   d5,d5         8 do we want to send a STOP */
    add.b d5,d5
/* QL:         bne.s   err_bp   12 b18 object to spare bit(s) set */
    bne.s err_bp
/* QL:         bcc.s   clrparm  12 b18 nope, leave SDA high and get next command */
    bcc.s clrparm
/* QL:         tst.b   (a4)         12 send SDA low */
    tst.b (a4)
/* QL:         rol.b   #8,d0        26 waste some time */
    rol.b #8,d0
/* QL:         tst.b   (a5)         12 send SCL high */
    tst.b (a5)
/* QL:         moveq   #7,d0         8 */
    moveq #7,d0
/* QL:         lsr.b   d0,d0        24 waste some time (about 1 cycle too much) */
    lsr.b d0,d0
/* QL:         tst.b   (a3)         12 send SDA high for STOP */
    tst.b (a3)
/* QL: clrparm */
clrparm:
/* QL:         clr.w   d2              reset parameter */
    clr.w d2
/* QL:         bra.l   new_cmd         go get next command */
    bra.w new_cmd
/* QL: * Read sequence */
/* QL: rdlp */
rdlp:
/* QL:         move.b  (a3),d6      12 SDA high, set SCL high and sample SDAin */
    move.b (a3),d6
/* QL:         asl.b   #1,d6        12 juggle to get timing right */
    asl.b #1,d6
/* QL:         asr.b   #2,d6        14 get SDAin to x */
    asr.b #2,d6
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         addx.b  d0,d0         8 roll SDAin into register */
    addx.b d0,d0
/* QL:         bcc.s   rdlp     12 b18 if not at marker yet, loop */
    bcc.s rdlp
/* QL:         cmp.w   (a4),a4      18 SCL low, set SDA low, set SCL high (***) */
    cmp.w (a4),a4
/* QL:         tst.b   d5            8 check if we are reading to register */
    tst.b d5
/* QL:         bpl.s   rreg     12 b18 if so, we can afford to be slower, max 4 byte! */
    bpl.s rreg
/* QL:         move.b  d0,(a1)+    >12 store this byte (6+ cycles slow) */
    move.b d0,(a1)+
/* QL: rrent */
rrent:
/* QL:         tst.b   (a4)         12 SDA low, set SCL low */
    tst.b (a4)
/* QL:         tst.b   (a2)         12 SCL low, set SDA high */
    tst.b (a2)
/* QL: reader */
reader:
/* QL:         moveq   #1,d0         8 set marker bit */
    moveq #1,d0
/* QL:         dbra    d2,rdlp  26 b18 */
    dbra d2,rdlp
/* QL:         bclr    #5,d5        22 check acknowledge bit */
    bclr #5,d5
/* QL:         bne.s   acklast  12 b18 final byte acknowledged, STOP not permitted */
    bne.s acklast
/* QL: rnlp */
rnlp:
/* QL:         move.b  (a3),d6      12 SDA high, set SCL high and sample SDAin */
    move.b (a3),d6
/* QL:         asl.b   #1,d6        12 juggle to get timing right */
    asl.b #1,d6
/* QL:         asr.b   #2,d6        14 get SDAin to x */
    asr.b #2,d6
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         addx.b  d0,d0         8 roll SDAin into register */
    addx.b d0,d0
/* QL:         bcc.s   rnlp     12 b18 if not at marker yet, loop */
    bcc.s rnlp
/* QL:         nop                   8 lose 2 too many cycles */
    nop 
/* QL:         tst.b   (a3)         12 SDA high, set SCL high for no ack */
    tst.b (a3)
/* QL:         add.b   d5,d5         8 check if we are reading to register */
    add.b d5,d5
/* QL:         bcc.s   rnreg    12 b18 if so, go roll it in */
    bcc.s rnreg
/* QL:         move.b  d0,(a1)+    >12 store this byte */
    move.b d0,(a1)+
/* QL: rnrent */
rnrent:
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         bra.s   chkstop     b18 go check for STOP required */
    bra.s chkstop
/* QL: acklast */
acklast:
/* QL:         add.b   d5,d5           clear off the buffer bit when last byte ack'ed */
    add.b d5,d5
/* QL:         beq.s   clrparm         should be all zero now */
    beq.s clrparm
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         jmp     (a0) */
    jmp (a0)
/* QL: rreg */
rreg:
/* QL:         rol.l   #8,d1 */
    rol.l #8,d1
/* QL:         move.b  d0,d1 */
    move.b d0,d1
/* QL:         bra.s   rrent */
    bra.s rrent
/* QL: rnreg */
rnreg:
/* QL:         rol.l   #8,d1 */
    rol.l #8,d1
/* QL:         move.b  d0,d1 */
    move.b d0,d1
/* QL:         bra.s   rnrent */
    bra.s rnrent
/* QL: *       |  1  |  1  |  g  |  v  |  d  |  c  |  1  |  q  | */
/* QL: special */
special:
/* QL:         bmi.s   grpok           skip if g (group) bit is already set */
    bmi.s grpok
/* QL:         swap    d2              set device group data */
    swap d2
/* QL:         clr.w   d2              zero the parameter value */
    clr.w d2
/* QL: grpok */
grpok:
/* QL:         moveq   #11,d0          clear msb's and shift count */
    moveq #11,d0
/* QL:         asl.b   #2,d5           check v bit */
    asl.b #2,d5
/* QL:         bcs.s   verok           skip if v (validate) bit is set */
    bcs.s verok
/* QL:         st      d6              we have all ones, and x=0 */
    st d6
/* QL: verlp */
verlp:
/* QL:         tst.b   (a2)         12 SDA high after 1st, set SCL low */
    tst.b (a2)
/* QL:         ror.b   #8,d6        26 */
    ror.b #8,d6
/* QL:         tst.b   (a3)         12 SDA high, set SCL high = nak */
    tst.b (a3)
/* QL:         rol.b   d0,d6        32 */
    rol.b d0,d6
/* QL:         tst.b   (a5)         12 SCL high, set SDA low = START */
    tst.b (a5)
/* QL:         ror.b   d0,d6        32 */
    ror.b d0,d6
/* QL:         tst.b   (a3)         12 SCL high, set SDA high = STOP */
    tst.b (a3)
/* QL:         roxl.b  #2,d6        14 */
    roxl.b #2,d6
/* QL:         bcs.s   verlp    12 b18 wait for x back at start (exec code 9 times) */
    bcs.s verlp
/* QL: verok */
verok:
/* QL:         move.b  d5,d0 */
    move.b d5,d0
/* QL:         lsr.b   #6,d0           put d/c bits into register */
    lsr.b #6,d0
/* QL:         bcc.s   err_bp          object to spare bit zero */
    bcc.s err_bp
/* QL:         tst.b   0(a4,d0.w)      set SDA/SCL as requested */
    tst.b 0(a4,d0.w)
/* QL:         lsl.b   #4,d5 */
    lsl.b #4,d5
/* QL:         bcc.l   new_cmd */
    bcc.w new_cmd
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         jmp     (a0)            return ok */
    jmp (a0)
/* QL:         vect4000 ii_drive,ii_raw */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl ii$drive
/* QL: [o]     equ     [h]-$4000 */
.equ ii$drive,(ii_drive-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl ii$raw
/* QL: [o]     equ     [h]-$4000 */
.equ ii$raw,(ii_raw-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
