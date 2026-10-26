/* Generated from original/M/cs/color.asm */
/* QL: * Set up color mask */
/* QL:         xdef    cs_color,cs_plain */
.globl cs_color,cs_plain
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
/* QL:         section cs_color */
.section cs_color,"ax"
/* QL: * d1 c p colour number */
/* QL: * d2   p scratch */
/* QL: * a1 c p pointer to two word colour pattern */
/* QL: * a6 i p system variables */
/* QL: reglist reg     d1-d2 */
/* QL: cs_color */
cs_color:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d2,-(sp)
/* QL:         bsr.s   cs_plain        convert d1 3 bits to colour */
    bsr.s cs_plain
/* QL:         move.w  d2,(a1)         save the plain colour (even) */
    move.w d2,(a1)
/* QL:         move.w  d2,2(a1)        save the plain colour (odd) */
    move.w d2,2(a1)
/* QL: * Now for the stipple */
/* QL:         lsr.b   #3,d1           shift down the rest of the byte */
    lsr.b #3,d1
/* QL:         beq.s   exit            are there any bits set ? */
    beq.s exit
/* QL:         bsr.s   cs_plain */
    bsr.s cs_plain
/* QL:         lsr.b   #4,d1           stipple flags: ms in d1, ls in carry */
    lsr.b #4,d1
/* QL:         bcc.s   vertical        check for horizontal component */
    bcc.s vertical
/* QL:         beq.s   eorexit         purely horizontal, go eor odd (01 done) */
    beq.s eorexit
/* QL:         eor.w   d2,2(a1)        create horizontal part for 11 stipple */
    eor.w d2,2(a1)
/* QL: vertical */
vertical:
/* QL:         btst    #3,sv_mcsta(a6) check screen mode */
    btst #3,sv_mcsta(a6)
/* QL:         bne.s   m256_msk */
    bne.s m256_msk
/* QL:         and.w   #$5555,d2       mask out alternate pixels in 512 */
    and.w #0x5555,d2
/* QL: eor_vert */
eor_vert:
/* QL:         eor.w   d2,(a1)         in even lines */
    eor.w d2,(a1)
/* QL:         ;       we have 00 10 and 11 left... just need to test msb */
/* QL:         tst.b   d1              is it single dot stipple ? */
    tst.b d1
/* QL:         beq.s   exit */
    beq.s exit
/* QL: eorexit */
eorexit:
/* QL:         eor.w   d2,2(a1)        and modify odd lines */
    eor.w d2,2(a1)
/* QL: exit */
exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d2
/* QL:         rts */
    rts 
/* QL: m256_msk */
m256_msk:
/* QL:         and.w   #$3333,d2       mask out alternate pixels in 256 */
    and.w #0x3333,d2
/* QL:         bra.s   eor_vert */
    bra.s eor_vert
/* QL: * d1 c p colour number in 3 lsb's */
/* QL: * d2   o color mask (.w) for mode and 3 lsb's of d1 */
/* QL: * a6 i p system variables */
/* QL: cs_plain */
cs_plain:
/* QL:         btst    #3,sv_mcsta(a6) check mode */
    btst #3,sv_mcsta(a6)
/* QL:         bne.s   m256_col */
    bne.s m256_col
/* QL:         moveq   #6,d2           ignoring lsb (blue) */
    moveq #6,d2
/* QL:         and.b   d1,d2 */
    and.b d1,d2
/* QL:         move.w  col512(pc,d2.w),d2 */
    move.w col512(pc,d2.w),d2
/* QL:         rts */
    rts 
/* QL: col512 */
col512:
/* QL:         dc.w    $0000,$00ff,$ff00,$ffff */
.balign 2,0
dc_anchor_281:
.word 0x0000
.word 0x00ff
.word 0xff00
.word 0xffff
/* QL: m256_col */
m256_col:
/* QL:         moveq   #7,d2 */
    moveq #7,d2
/* QL:         and.b   d1,d2 */
    and.b d1,d2
/* QL:         add.b   d2,d2 */
    add.b d2,d2
/* QL:         move.w  col256(pc,d2.w),d2 */
    move.w col256(pc,d2.w),d2
/* QL:         rts */
    rts 
/* QL: col256 */
col256:
/* QL:         dc.w    $0000,$0055,$00aa,$00ff,$aa00,$aa55,$aaaa,$aaff */
.balign 2,0
dc_anchor_302:
.word 0x0000
.word 0x0055
.word 0x00aa
.word 0x00ff
.word 0xaa00
.word 0xaa55
.word 0xaaaa
.word 0xaaff
/* QL:         end */
