/* Generated from original/M/tb/kbenc.asm */
/* QL: * Convert IPC shifts and keyrows to character or special */
/* QL:         xdef    tb_kbenc */
.globl tb_kbenc
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
/* QL:         include 'win1_m_inc_sx' */
/* QL: * system variables extension */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sx_case ds.l    1       non-zero = user rtn on ctrl/alt/shift/enter (c/a/s/e?) */
.equ sx_case,0
/* QL: sx_itran ds.l   1       input tranlation routine */
.equ sx_itran,4
/* QL: sx_otran ds.l   1       output translation routine */
.equ sx_otran,8
/* QL: sx_driv ds.l    1       mm_rechp is memory management driver, close entry point */
.equ sx_driv,12
/* QL: sx_kbenc ds.l   1       keyboard encoder routine */
.equ sx_kbenc,16
/* QL: sx_ipcom ds.l   1       linked list to front end mt.ipcom calls */
.equ sx_ipcom,20
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL: sx_trn  ds.l    1       default i/o translation table address */
.equ sx_trn,32
/* QL: sx_msg  ds.l    1       default message table address */
.equ sx_msg,36
/* QL: sx_f0   ds.l    1       default primary font */
.equ sx_f0,40
/* QL: sx_f1   ds.l    1       default secondary font */
.equ sx_f1,44
/* QL: sx_dspm ds.b    1       real display mode settings (dual screen) */
.equ sx_dspm,48
/* QL: sx_toe  ds.b    1       turn off ehancements: */
.equ sx_toe,49
/* QL:                 ; bit 7 set, allow format + files open */
/* QL:                 ; bit 1 set, treat -ve mt.baud as error (non-hermes) */
/* QL: sx_event ds.b   1       events: bit 4 = ctrl/space, 5=+alt, 6=+shift, 7=+both */
.equ sx_event,50
/* QL: sx_fstat ds.b   1       cursor flash rate, size and colour rrrrsccc */
.equ sx_fstat,51
/* QL: sx_kbste ds.b   12      special key remap table */
.equ sx_kbste,52
/* QL: sx_qdos ds.l    1       returned by mt.inf, ver$(-2) */
.equ sx_qdos,64
/* QL: sx_basic ds.w   1+4/2   length prefixed string returned by ver$, ver$(0) */
.equ sx_basic,68
/* QL:         ds.w    2       spare/reserved */
/* QL:         ds.b    1       21kxs10w   21: ser21 data pend, k: key held, x: shift */
/* QL:                         ; change while key held, s: sound in progress, 1: 1, */
/* QL:                         ; 0: zero Hermes, old IPC showed ser being zapped, */
/* QL:                         ; w: p26 (write protect) (experimental byte!) */
/* QL:         ds.b    1       spare/reserved */
/* QL: * initial ram based linkages */
/* QL:         ds.l    2       0 ip_poll */
/* QL:         ds.l    6       base+$60 sd_sched base+$68 ip_sched 0 io_scan */
/* QL:         ds.l    4       base+$80 od_serio od_serop od_sercl */
/* QL: sx_pipb ds.l    4       base+$90 io_serq  od_pipop od_pipcl */
.equ sx_pipb,128
/* QL: sx_con  ds.l    4       base+$a0 od_conio od_conop od_concl */
.equ sx_con,144
/* QL:         ds.l    4       0 od_netio od_netop od_netcl */
/* QL:         ds.l    8       0 dd_mdvio dd_mdvop dd_mdvcl md_slave 0 0 md_formt */
/* QL:         ds.b    4+2+3   md_end 3 'mdv' */
/* QL:         ds.b    3       spare bit */
/* QL: sx_pipc ds.l    1       pipe driver link word */
.equ sx_pipc,220
/* QL: * end of system extension */
/* QL:         list */
/* QL:         section tb_kbenc */
.section tb_kbenc,"ax"
/* QL: * d1 -i o- 6 lsb are keyrow (5-3 column, 2-0 row), see below for output */
/* QL: * d2 -i  - 3 lsb SHIFT/CTRL/ALT */
/* QL: * a4 -ip - sysvar extension address */
/* QL: * a6 -ip - sysvar */
/* QL: * d0/d2 destroyed */
/* QL: * Direct return, CTRL in combination with one of space, TAB or ENTER: */
/* QL: * d1.w  0..11: bit 0 = ALT, bit 1 = SHIFT, bit 2 = TAB, bit 3 = ENTER */
/* QL: * Return + 2, normal characters: */
/* QL: * d1.w  msb 0 and lsb 8 bit char or ... */
/* QL: *       ... msb 8 bit char and lsb $ff if the ALT prefix ($ff) is required. */
/* QL: * Return + 4, ignore this (compose first char stored or compose aborted) */
/* QL: * d1.w  undefined */
/* QL: do_ste */
do_ste:
/* QL:         asr.b   #1,d1           take SHIFT back out */
    asr.b #1,d1
/* QL:         bcs.s   qal1            if no SHIFT, we have the keycode now */
    bcs.s qal1
/* QL:         move.b  stetab-252(pc,d1.w),d1 space, TAB and ENTER to unshifted */
    move.b (stetab-252)(pc,d1.w),d1
/* QL: qal1 */
qal1:
/* QL:         bra.s   qalt            go add in the ALT stuff */
    bra.s qalt
/* QL: special */
special:
/* QL:         bsr.s   roll            roll SHIFT into d1 lsb and lose sign */
    bsr.s roll
/* QL:         bpl.s   tryfx           still positive, try function keys */
    bpl.s tryfx
/* QL:         add.b   d2,d2           do we have CTRL on? */
    add.b d2,d2
/* QL:         bcc.s   do_ste          no - go do normal space/TAB/ENTER */
    bcc.s do_ste
/* QL:         addq.b  #8,d1           make d1 = 0..5, roll in ALT and direct return */
    addq.b #8,d1
/* QL: roll */
roll:
/* QL:         add.b   d2,d2           roll one bit from d2 ... */
    add.b d2,d2
/* QL:         addx.b  d1,d1           ... into d1 */
    addx.b d1,d1
/* QL:         rts */
    rts 
/* QL: tryfx */
tryfx:
/* QL:         bsr.s   roll            transfer CTRL into d1 lsb */
    bsr.s roll
/* QL:         bmi.s   qalt            that's the end for f1-f5 */
    bmi.s qalt
/* QL:         bsr.s   roll            transfer ALT into d1 lsb */
    bsr.s roll
/* QL:         bmi.s   simp1           the end for cursor keys and CAPSLOCK */
    bmi.s simp1
/* QL:         asr.b   #1,d1           oops - it's actually ESC we're doing */
    asr.b #1,d1
/* QL:         roxr.b  #1,d2           so put the ALT flag back into d2 */
    roxr.b #1,d2
/* QL:         move.b  esctab(pc,d1.w),d1 and get the right byte from the table */
    move.b esctab(pc,d1.w),d1
/* QL:         bra.s   qlck            go do capslock/ALT */
    bra.s qlck
/* QL: tb_kbenc */
tb_kbenc:
/* QL:         ror.w   #3,d2           tuck away sca bits */
    ror.w #3,d2
/* QL:         smi     d0              remember SHIFT setting */
    smi d0
/* QL:         move.b  sv_ichar(a6),d2 are we composing? */
    move.b sv_ichar(a6),d2
/* QL:         beq.s   noshf           no - carry on */
    beq.s noshf
/* QL:         sf      sv_ichar(a6)    drop the compose flag */
    sf sv_ichar(a6)
/* QL:         lsl.b   #7,d0           make 0 or $80 if SHIFT is on */
    lsl.b #7,d0
/* QL:         or.b    d0,d2           saved or this SHIFT will do for later */
    or.b d0,d2
/* QL:         asl.w   #3,d2           this junks SHIFT/CTRL/ALT */
    asl.w #3,d2
/* QL:         addq.b  #4,d2           and pretend SHIFT only is on */
    addq.b #4,d2
/* QL:         ror.w   #3,d2           tuck away sca = 100 */
    ror.w #3,d2
/* QL: noshf */
noshf:
/* QL:         ror.w   #8,d2           save compose in msb */
    ror.w #8,d2
/* QL:         and.w   #$3f,d1 */
    and.w #0x3f,d1
/* QL:         move.b  keytab(pc,d1.w),d1 */
    move.b keytab(pc,d1.w),d1
/* QL:         bmi.s   special */
    bmi.s special
/* QL:         add.b   d2,d2           was SHIFT on? */
    add.b d2,d2
/* QL:         bcc.s   nctrl           no - have a go at CTRL */
    bcc.s nctrl
/* QL:         bsr.s   toggle          form upper case letters and {|} */
    bsr.s toggle
/* QL:         cmp.b   #'`'-32,d1      was that the right thing to do? */
    cmp.b #((96-32)&255),d1
/* QL:         bhi.s   nctrl           yes - can look at CTRL now */
    bhi.s nctrl
/* QL:         bne.s   notilde         equality means is was a ` */
    bne.s notilde
/* QL:         asr.b   #3,d1           turn the $40 into $08 (v. sneaky) */
    asr.b #3,d1
/* QL: notilde */
notilde:
/* QL:         move.b  shftab(pc,d1.w),d1 */
    move.b shftab(pc,d1.w),d1
/* QL: nctrl */
nctrl:
/* QL:         add.b   d2,d2           was CTRL on? */
    add.b d2,d2
/* QL:         bcc.s   qlck            no - go sort out capslock/ALT */
    bcc.s qlck
/* QL:         sub.b   #$60,d1         try normal CTRL/char */
    sub.b #(0x60&255),d1
/* QL:         bpl.s   qalt            ok, go do ALT */
    bpl.s qalt
/* QL:         add.b   #$c0,d1         others wanted + $60 */
    add.b #(0xc0&255),d1
/* QL: qlck */
qlck:
/* QL:         tst.b   sv_caps(a6)     is capslock set */
    tst.b sv_caps(a6)
/* QL:         beq.s   qalt            no - skip this bit */
    beq.s qalt
/* QL:         moveq   #'z'+1,d0 */
    moveq #(122+1),d0
/* QL:         bsr.s   togq */
    bsr.s togq
/* QL:         moveq   #$8c-256,d0 */
    moveq #(0x8c-256),d0
/* QL:         bsr.s   togq */
    bsr.s togq
/* QL: qalt */
qalt:
/* QL:         not.b   d2              was ALT on? */
    not.b d2
/* QL: simp1 */
simp1:
/* QL:         bmi     simple          no - go finish off */
    bmi simple
/* QL:         rol.w   #8,d1           put char into msb */
    rol.w #8,d1
/* QL:         st      d1              put $ff into lsb */
    st d1
/* QL:         addq.l  #2,(sp)         make a normal + 2 return */
    addq.l #2,(sp)
/* QL:         rts */
    rts 
/* QL: togq */
togq:
/* QL:         cmp.b   d0,d1           compare high end of range */
    cmp.b d0,d1
/* QL:         bcc.s   togx            too big - no toggle */
    bcc.s togx
/* QL:         and.b   #$e1,d0         get low end of range */
    and.b #(0xe1&255),d0
/* QL:         cmp.b   d0,d1           compare low end of range */
    cmp.b d0,d1
/* QL:         bcs.s   togx            too small - no toggle */
    bcs.s togx
/* QL: toggle */
toggle:
/* QL:         eor.b   #32,d1          flip upper/lower case bit */
    eor.b #(32&255),d1
/* QL: togx */
togx:
/* QL:         rts */
    rts 
/* QL: * ESC with optional SHIFT/CTRL */
/* QL: esctab */
esctab:
/* QL:  dc.b $1b,$80,$7f,$1f {s/}{c/}ESC -> ESC  etc */
dc_anchor_439:
.byte (0x1b)&255
.byte (0x80)&255
.byte (0x7f)&255
.byte (0x1f)&255
/* QL: * Primary key translate... decrypt the keyrow and detect interesting keys. */
/* QL: * Simple keys sort of go direct to their proper unshifted ASCII code. */
/* QL: * Top bits are used to sort out special cases. */
/* QL: keytab equ *-3 first three not used       1   2   4   8  16  32  64  128 */
.equ keytab,(.-3)
/* QL:  dc.b             $78,$76,$2f,$6e,$2c 7               x   v   /   n   , */
dc_anchor_450:
.byte (0x78)&255
.byte (0x76)&255
.byte (0x2f)&255
.byte (0x6e)&255
.byte (0x2c)&255
/* QL:  dc.b $38,$32,$36,$71,$65,$30,$74,$75 6   8   2   6   q   e   0   t   u */
dc_anchor_457:
.byte (0x38)&255
.byte (0x32)&255
.byte (0x36)&255
.byte (0x71)&255
.byte (0x65)&255
.byte (0x30)&255
.byte (0x74)&255
.byte (0x75)&255
/* QL:  dc.b $39,$77,$69,$fd,$72,$2d,$79,$6f 5   9   w   i  TAB  r   -   y   o */
dc_anchor_467:
.byte (0x39)&255
.byte (0x77)&255
.byte (0x69)&255
.byte (0xfd)&255
.byte (0x72)&255
.byte (0x2d)&255
.byte (0x79)&255
.byte (0x6f)&255
/* QL:  dc.b $6c,$33,$68,$31,$61,$70,$64,$6a 4   l   3   h   1   a   p   d   j */
dc_anchor_477:
.byte (0x6c)&255
.byte (0x33)&255
.byte (0x68)&255
.byte (0x31)&255
.byte (0x61)&255
.byte (0x70)&255
.byte (0x64)&255
.byte (0x6a)&255
/* QL:  dc.b $5b,$9c,$6b,$73,$66,$3d,$67,$3b 3  \{/ cap  k   s   f   =   g   ; */
dc_anchor_487:
.byte (0x5b)&255
.byte (0x9c)&255
.byte (0x6b)&255
.byte (0x73)&255
.byte (0x66)&255
.byte (0x3d)&255
.byte (0x67)&255
.byte (0x3b)&255
/* QL:  dc.b $5d,$7a,$2e,$63,$62,$60,$6d,$27 2   ]   z   .   c   b   `   m   ' */
dc_anchor_497:
.byte (0x5d)&255
.byte (0x7a)&255
.byte (0x2e)&255
.byte (0x63)&255
.byte (0x62)&255
.byte (0x60)&255
.byte (0x6d)&255
.byte (0x27)&255
/* QL:  dc.b $fe,$98,$9a,$80,$99,$5c,$fc,$9b 1  ent <-- /|\ ESC -->  \  spc \|/ */
dc_anchor_507:
.byte (0xfe)&255
.byte (0x98)&255
.byte (0x9a)&255
.byte (0x80)&255
.byte (0x99)&255
.byte (0x5c)&255
.byte (0xfc)&255
.byte (0x9b)&255
/* QL:  dc.b $bd,$ba,$35,$bb,$bc,$be,$34,$37 0  f4  f1   5  f2  f3  f5   4   7 */
dc_anchor_517:
.byte (0xbd)&255
.byte (0xba)&255
.byte (0x35)&255
.byte (0xbb)&255
.byte (0xbc)&255
.byte (0xbe)&255
.byte (0x34)&255
.byte (0x37)&255
/* QL: * the results from the table give us: */
/* QL: * miscellany    $27..$3d                $27 to $3d -> need 2nd table if SHIFT */
/* QL: * a..z+         $5b..$7d                $5b to $7a -> eor $20 if SHIFT */
/* QL: * ESC           $80                     $80(c),$7f(s),$1f(cs) or $1b */
/* QL: * cursor keys   $98,$99,$9a,$9b         $c0,$c8,$d0,$d8 + SHIFT/CTRL/ALT */
/* QL: * CAPSLOCK      $9c                     $e0 + SHIFT/CTRL/ALT */
/* QL: * f1-f5         $ba,$bb,$bc,$bd,$be     $e8,$ec,$f0,$f4,$f8 + SHIFT/CTRL */
/* QL: * space         $fc                     $fc(s) or $20 \ */
/* QL: * TAB           $fd                     $fd(s) or $09  > leave CTRL in d2 lsb */
/* QL: * ENTER         $fe                     $fe(s) or $0a / */
/* QL: * Unshifted space, TAB and ENTER */
/* QL: stetab equ *+2  overlap with unused entries in shftab */
.equ stetab,(.+2)
/* QL: * Miscellany SHIFTed */
/* QL: shftab equ *-7 */
.equ shftab,(.-7)
/* QL:  dc.b $22 ' -> " */
dc_anchor_543:
.byte (0x22)&255
/* QL:  dc.b $7e ` -> ~ (sneaky translate) */
dc_anchor_546:
.byte (0x7e)&255
/* QL:  dc.b $20,$09,$0a (spare 3 bytes in mshift, reused for stetab) */
dc_anchor_549:
.byte (0x20)&255
.byte (0x09)&255
.byte (0x0a)&255
/* QL:  dc.b $3c,$5f,$3e,$3f ,-./ -> <_>? */
dc_anchor_554:
.byte (0x3c)&255
.byte (0x5f)&255
.byte (0x3e)&255
.byte (0x3f)&255
/* QL:  dc.b $29,$21,$40,$23,$24,$25,$5e,$26,$2a,$28 0123456789 -> )!@#$%^&*( */
dc_anchor_560:
.byte (0x29)&255
.byte (0x21)&255
.byte (0x40)&255
.byte (0x23)&255
.byte (0x24)&255
.byte (0x25)&255
.byte (0x5e)&255
.byte (0x26)&255
.byte (0x2a)&255
.byte (0x28)&255
/* QL:  ds.b 1 unused */
.space (1)*1,0
/* QL:  dc.b $3a ; -> : */
dc_anchor_574:
.byte (0x3a)&255
/* QL:  ds.b 1 unused */
.space (1)*1,0
/* QL:  dc.b $2b = -> + */
dc_anchor_579:
.byte (0x2b)&255
/* QL:  ds.w 0 */
.balign 2,0
/* QL: compose */
compose:
/* QL:         add.w   d2,d2           put SHIFT into bit 8 */
    add.w d2,d2
/* QL:         lsr.b   #1,d2           set toggle flag = 0 */
    lsr.b #1,d2
/* QL:         addq.l  #2,(sp)         return + 2 if ready, + 4 if scrap or first */
    addq.l #2,(sp)
/* QL:         moveq   #compfst-1,d0   table starts after lower case specials */
    moveq #(compfst-1),d0
/* QL:         subq.b  #1,d2           is it our second character? */
    subq.b #1,d2
/* QL:         beq.s   sing            no - go do the first char lookup */
    beq.s sing
/* QL:         addq.b  #1,d2 */
    addq.b #1,d2
/* QL:         asl.w   #8,d1           put this char into msb */
    asl.w #8,d1
/* QL:         move.b  d2,d1 */
    move.b d2,d1
/* QL: dual */
dual:
/* QL:         addq.b  #2,d0 */
    addq.b #2,d0
/* QL:         bmi.s   ret2 */
    bmi.s ret2
/* QL: chkswap */
chkswap:
/* QL:         rol.w   #8,d1 */
    rol.w #8,d1
/* QL:         cmp.w   comptab-1(pc,d0.w),d1 (n.b. d0 kept permanently odd) */
    cmp.w (comptab-1)(pc,d0.w),d1
/* QL:         beq.s   compok */
    beq.s compok
/* QL:         not.b   d2              alternate swapping chars each time */
    not.b d2
/* QL:         bmi.s   chkswap */
    bmi.s chkswap
/* QL:         bra.s   dual */
    bra.s dual
/* QL: sing */
sing:
/* QL:         addq.b  #1,d0 */
    addq.b #1,d0
/* QL:         bmi.s   ret2            no such char in compose table */
    bmi.s ret2
/* QL:         cmp.b   comptab(pc,d0.w),d1 */
    cmp.b comptab(pc,d0.w),d1
/* QL:         bne.s   sing */
    bne.s sing
/* QL:         tst.b   d1 */
    tst.b d1
/* QL:         bpl.s   savec1          non-print (+ESC) are single char compose */
    bpl.s savec1
/* QL: compok */
compok:
/* QL:         ror.b   #1,d0           we have (cleverly) arranged d0 to be odd */
    ror.b #1,d0
/* QL:         move.w  d0,d1           (also gets rid of junk in top of d1) */
    move.w d0,d1
/* QL:         lsr.w   #1,d2           was SHIFT on for this (or prev) key ... */
    lsr.w #1,d2
/* QL:         or.b    sv_caps(a6),d2  ... or is capslock on? */
    or.b sv_caps(a6),d2
/* QL:         bmi.s   ret0            yes - that's ok */
    bmi.s ret0
/* QL:         moveq   #$ac-256,d0     is it $a0 to $ab? */
    moveq #(0xac-256),d0
/* QL:         bra     togq            if so, this'll change it */
    bra togq
/* QL: savec1 */
savec1:
/* QL:         asr.w   #1,d2           get out the SHIFT we kept in top of d2 */
    asr.w #1,d2
/* QL:         or.b    d2,d1           incorporate this char */
    or.b d2,d1
/* QL:         move.b  d1,sv_ichar(a6) store it, then do an ignore return */
    move.b d1,sv_ichar(a6)
/* QL: ret2 */
ret2:
/* QL:         addq.l  #2,(sp) */
    addq.l #2,(sp)
/* QL: ret0 */
ret0:
/* QL:         rts */
    rts 
/* QL: simple */
simple:
/* QL:         asr.w   #8,d2           are we composing? */
    asr.w #8,d2
/* QL:         bne.s   compose         yes - go do it */
    bne.s compose
/* QL:         moveq   #12,d2          counter and offset */
    moveq #12,d2
/* QL: rdlp */
rdlp:
/* QL:         subq.b  #1,d2 */
    subq.b #1,d2
/* QL:         bcs.s   ret2            end of table, return normal */
    bcs.s ret2
/* QL:         cmp.b   sx_kbste(a4,d2.w),d1 */
    cmp.b sx_kbste(a4,d2.w),d1
/* QL:         bne.s   rdlp */
    bne.s rdlp
/* QL:         move.w  d2,d1           found a match, special return */
    move.w d2,d1
/* QL:         rts */
    rts 
/* QL: * The compose table is byte pairs, which will be matched either way round. */
/* QL: * All entries are the SHIFT'ed characters, as this is forced while composing. */
/* QL: * The twelve entries that have lower case versions are changed back provided */
/* QL: * that capslock is not on and the SHIFT key was not held on either keypress. */
/* QL: compfst equ     12*2    the first block (lower case) are not needed */
.equ compfst,(12*2)
/* QL: comptab equ     *-compfst */
.equ comptab,(.-compfst)
/* QL:         dc.w    'A?A|A^E:E|E^I:I?I|I^O?O|O^U?U|U^SSC!Y_||' */
.balign 2,0
dc_anchor_701:
.byte 65,63,65,124,65,94,69,58,69,124,69,94,73,58,73,63,73,124,73,94,79,63,79,124,79,94,85,63,85,124,85,94,83,83,67,33,89,95,124,124
.balign 2,0
/* QL:         dc.w    'A:A~AOE?O:O~O!U:C<N~AEOE' these may be "lower-case'ed" */
.balign 2,0
dc_anchor_706:
.byte 65,58,65,126,65,79,69,63,79,58,79,126,79,33,85,58,67,60,78,126,65,69,79,69
.balign 2,0
/* QL:         dc.w    'AADDTTLLMMPIPH!!??TMPPOX<<>>OO:_',-60,-52,-44,-36 */
.balign 2,0
dc_anchor_711:
.byte 65,65,68,68,84,84,76,76,77,77,80,73,80,72,33,33,63,63,84,77,80,80,79,88,60,60,62,62,79,79,58,95
.balign 2,0
.word ((-60))&65535
.word ((-52))&65535
.word ((-44))&65535
.word ((-36))&65535
/* QL: * N.B. Negative values in the above table (other than the convenient $ff, which */
/* QL: * never comes here) must be at odd addresses. They are single char compose. */
/* QL: * These are the space, TAB, ENTER, CAPSLOCK, ESC, function and cursor keys. */
/* QL: * Just the cursor keys are used at the moment (last 4 entries). */
/* QL: * Also, note that the following keys never occur in compose sequences: */
/* QL: *       space, TAB, ENTER, CAPSLOCK, ESC, function keys and "23457890=[]'" */
/* QL: * This makes them abort the compose immediately. Assigning one as the remapped */
/* QL: * compose key makes a lot of sense... though this will lose it's function on */
/* QL: * the keyboard. The neatest ones would be either open or close square bracket. */
/* QL: * one other candidate for the compose key is "`", which isn't used in basic. */
/* QL: * A word of warning... don't assign a 128-191 byte as the compose... you can */
/* QL: * get really stuck... */
/* QL:         end */
