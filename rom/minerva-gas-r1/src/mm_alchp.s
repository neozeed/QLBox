/* Generated from original/M/mm/alchp.asm */
/* QL: * Allocate space in common heap */
/* QL:         xdef    mm_alchp */
.globl mm_alchp
/* QL:         xref    mm_alloi,mm_albot,mm_clear,mm_lnkf0 */
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
/* QL:         section mm_alchp */
.section mm_alchp,"ax"
/* QL: * A version of alchp that preserves much more context. */
/* QL: * This saves doing it all the places it gets called from. (lwr) */
/* QL: * d0 -  o- return error (ok or "out of memory", ccr set) */
/* QL: * d1 -i o- space required (may be modified to be slightly increased) */
/* QL: * a0 -  o- pointer to space allocated (if found) */
/* QL: reglist reg     d1-d3/a1-a2     (d1 modded if allocation succeeds) */
/* QL: * Come here when the heap needs more space */
/* QL: new_free */
new_free:
/* QL:         add.l   (a0),a1         add length of last block to address */
    add.l (a0),a1
/* QL:         cmp.l   sv_free(a6),a1  is this equal to top of area */
    cmp.l sv_free(a6),a1
/* QL:         bne.s   lenok */
    bne.s lenok
/* QL:         sub.l   (a0),d1         reduce length required to be allocated */
    sub.l (a0),d1
/* QL: lenok */
lenok:
/* QL:         jsr     mm_albot(pc)    allocate from bottom of free area */
    jsr mm_albot(pc)
/* QL:         bne.s   exit            if out of memory, get out */
    bne.s exit
/* QL:         sub.l   d1,a0           set base of area allocated */
    sub.l d1,a0
/* QL:         lea     sv_chpfr(a6),a1 */
    lea sv_chpfr(a6),a1
/* QL:         jsr     mm_lnkf0(pc)    link in new space */
    jsr mm_lnkf0(pc)
/* QL:         movem.l (sp)+,reglist   restore length, rest so we can drop back in */
    movem.l (sp)+,d1-d3/a1-a2
/* QL: mm_alchp */
mm_alchp:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a1-a2,-(sp)
/* QL:         lea     sv_chpfr(a6),a0 get first link pointer */
    lea sv_chpfr(a6),a0
/* QL:         moveq   #16-1,d2        allocation multiple */
    moveq #(16-1),d2
/* QL:         moveq   #16,d0          don't leave scraps of 16, as they're useless */
    moveq #16,d0
/* QL:         jsr     mm_alloi(pc)    allocate some free space */
    jsr mm_alloi(pc)
/* QL:         bne.s   new_free        check if adequate space found */
    bne.s new_free
/* QL:         lea     sv_chpfr-hp_next(a6),a2 a1 might point to a new free space */
    lea (sv_chpfr-hp_next)(a6),a2
/* QL:         cmp.l   a1,a2           or it might point to the free space pointer */
    cmp.l a1,a2
/* QL:         beq.s   ownok */
    beq.s ownok
/* QL:         clr.l   hp_owner(a1)    it's a free space - owned by 0 */
    clr.l hp_owner(a1)
/* QL: ownok */
ownok:
/* QL:         move.l  d1,(sp)         tell caller what they actually got */
    move.l d1,(sp)
/* QL:         addq.l  #8,a0           skip the length, and 2nd already cleared */
    addq.l #8,a0
/* QL:         subq.l  #8,d1 */
    subq.l #8,d1
/* QL:         jsr     mm_clear(pc)    clear the area */
    jsr mm_clear(pc)
/* QL:         subq.l  #8,a0 */
    subq.l #8,a0
/* QL: exit */
exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d3/a1-a2
/* QL:         rts                     (status set) */
    rts 
/* QL:         end */
