/* Generated from original/M/mt/alloc.asm */
/* QL: * Manager trap entries to the memory management system */
/* QL:         xdef    mt_alloc,mt_lnkfr,mt_alchp,mt_rechp */
.globl mt_alloc,mt_lnkfr,mt_alchp,mt_rechp
/* QL:         xdef    mt_alres,mt_reres,mt_albas,mt_rebas */
.globl mt_alres,mt_reres,mt_albas,mt_rebas
/* QL:         xref    mm_alloc,mm_lnkfr,mm_alchp,mm_rechp */
/* QL:         xref    mm_altrn,mm_retrn,mm_mdbas,mm_whtrn,mm_gotrn,mm_mvjob */
/* QL:         xref    ss_jobx,ss_noer,ss_rte */
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
/* QL:         include 'win1_m_inc_mt' */
/* QL: * manager trap #1 codes */
/* QL:         nolist */
/* QL: mt.inf  equ     $00     get system information */
.equ mt.inf,0x00
/* QL: mt.cjob equ     $01     create a job */
.equ mt.cjob,0x01
/* QL: mt.jinf equ     $02     get information on job */
.equ mt.jinf,0x02
/* QL: mt.extop equ    $03     convert called routine to supervisor, rte at end */
.equ mt.extop,0x03
/* QL: mt.rjob equ     $04     remove a job */
.equ mt.rjob,0x04
/* QL: mt.frjob equ    $05     force remove a job */
.equ mt.frjob,0x05
/* QL: mt.free equ     $06     find out how much free space there is */
.equ mt.free,0x06
/* QL: mt.trapv equ    $07     set pointer to trap redirection vectors */
.equ mt.trapv,0x07
/* QL: mt.susjb equ    $08     suspend a job */
.equ mt.susjb,0x08
/* QL: mt.reljb equ    $09     release a job */
.equ mt.reljb,0x09
/* QL: mt.activ equ    $0a     activate a job */
.equ mt.activ,0x0a
/* QL: mt.prior equ    $0b     set a job priority */
.equ mt.prior,0x0b
/* QL: mt.alloc equ    $0c     allocate a bit of a heap */
.equ mt.alloc,0x0c
/* QL: mt.lnkfr equ    $0d     release a bit of a heap */
.equ mt.lnkfr,0x0d
/* QL: mt.alres equ    $0e     allocate resident procedure area */
.equ mt.alres,0x0e
/* QL: mt.reres equ    $0f     release resident procedure area */
.equ mt.reres,0x0f
/* QL: mt.dmode equ    $10     set display mode */
.equ mt.dmode,0x10
/* QL: mt.ipcom equ    $11     send IPC command */
.equ mt.ipcom,0x11
/* QL: mt.baud equ     $12     set baud rate */
.equ mt.baud,0x12
/* QL: mt.rclck equ    $13     read clock */
.equ mt.rclck,0x13
/* QL: mt.sclck equ    $14     set clock */
.equ mt.sclck,0x14
/* QL: mt.aclck equ    $15     adjust clock */
.equ mt.aclck,0x15
/* QL: mt.albas equ    $16     allocate basic area */
.equ mt.albas,0x16
/* QL: mt.rebas equ    $17     release basic area */
.equ mt.rebas,0x17
/* QL: mt.alchp equ    $18     allocate space in common heap */
.equ mt.alchp,0x18
/* QL: mt.rechp equ    $19     release space in common heap */
.equ mt.rechp,0x19
/* QL: mt.lxint equ    $1a     link in external interrupt handler */
.equ mt.lxint,0x1a
/* QL: mt.rxint equ    $1b     remove external interrupt handler */
.equ mt.rxint,0x1b
/* QL: mt.lpoll equ    $1c     link in polled task */
.equ mt.lpoll,0x1c
/* QL: mt.rpoll equ    $1d     remove polled task */
.equ mt.rpoll,0x1d
/* QL: mt.lschd equ    $1e     link in scheduler task */
.equ mt.lschd,0x1e
/* QL: mt.rschd equ    $1f     remove scheduler task */
.equ mt.rschd,0x1f
/* QL: mt.liod equ     $20     link in I/O driver */
.equ mt.liod,0x20
/* QL: mt.riod equ     $21     remove I/O driver */
.equ mt.riod,0x21
/* QL: mt.ldd  equ     $22     link in directory driver */
.equ mt.ldd,0x22
/* QL: mt.rdd  equ     $23     remove directory driver */
.equ mt.rdd,0x23
/* QL: mt.cntry equ    $24     set translate/error tables */
.equ mt.cntry,0x24
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
/* QL:         include 'win1_m_inc_jb' */
/* QL: * job header and save area definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: jb_len  ds.l    1       length of job segment */
.equ jb_len,0
/* QL: jb_start ds.l   1       start address */
.equ jb_start,4
/* QL: jb_owner ds.l   1       owner of this job */
.equ jb_owner,8
/* QL: jb_hold ds.l    1       ptr to byte to be clr when job released */
.equ jb_hold,12
/* QL: jb_tag  ds.w    1       tag for this job */
.equ jb_tag,16
/* QL: jb_prior ds.b   1       current accumulated priority */
.equ jb_prior,18
/* QL: jb_princ ds.b   1       priority increment, if =0 job inactive */
.equ jb_princ,19
/* QL: jb_stat ds.w    1       job status: */
.equ jb_stat,20
/* QL: *               0 potentially active, >0 delay time (frames), <0 suspended */
/* QL: jb_rela6 ds.b   1       bit 7: next trap #2/3 is rel a6, bit 6: interpreter */
.equ jb_rela6,22
/* QL: jb_wflag ds.b   1       set if there is a job waiting on completion */
.equ jb_wflag,23
/* QL: jb_wjob ds.l    1       job id of waiting job */
.equ jb_wjob,24
/* QL: jb_trapv ds.l   1       pointer to trap redirection vectors */
.equ jb_trapv,28
/* QL: jb_d0   ds.l    8       saved d0-d7 */
.equ jb_d0,32
/* QL: jb_a0   ds.l    8       saved a0-a7 */
.equ jb_a0,64
/* QL: jb_sr   ds.w    1       saved sr */
.equ jb_sr,96
/* QL: jb_pc   ds.l    1       saved pc */
.equ jb_pc,98
/* QL:         ds.w    1       spare */
/* QL: jb_end */
.equ jb_end,104
/* QL:         list */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: bv..int equ     6       jb_rela6 flag that tells us if it's an interpreter */
.equ bv..int,6
/* QL:         section mt_alloc */
.section mt_alloc,"ax"
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- space to be allocated / actual space allocated */
/* QL: * a0 -i o- rel a6 pointer to free space pointer / rel a6 base of area allocated */
/* QL: * a6 -ip - base address */
/* QL: * d2-d3/a1-a2 destroyed */
/* QL: mt_alloc */
mt_alloc:
/* QL:         add.l   8(sp),a0        make a0 absolute */
    add.l 8(sp),a0
/* QL:         jsr     mm_alloc(pc) */
    jsr mm_alloc(pc)
/* QL:         sub.l   8(sp),a0        make a0 relative */
    sub.l 8(sp),a0
/* QL:         bra.s   rte1 */
    bra.s rte1
/* QL: * d1 -i  - length of space to be freed */
/* QL: * a0 -i  - rel a6 base of new area to be freed */
/* QL: * a1 -i  - rel a6 pointer to pointer to free space */
/* QL: * a6 -ip - base address */
/* QL: * d2/a2-a2 destroyed */
/* QL: mt_lnkfr */
mt_lnkfr:
/* QL:         add.l   8(sp),a0        make a0 absolute */
    add.l 8(sp),a0
/* QL:         add.l   8(sp),a1        make a1 absolute */
    add.l 8(sp),a1
/* QL:         jsr     mm_lnkfr(pc) */
    jsr mm_lnkfr(pc)
/* QL: rte1 */
rte1:
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- bytes required / bytes allocated */
/* QL: * d2 -i  - owner job id (-1 for self) */
/* QL: * a0 -  o- address of area allocated, after the heap header */
/* QL: dropres */
dropres:
/* QL:         jsr     mm_retrn(pc)    give back failed job 0 respr */
    jsr mm_retrn(pc)
/* QL:         move.l  d7,d1           restore size */
    move.l d7,d1
/* QL: mychp */
mychp:
/* QL:         moveq   #-1,d2          allocate to self */
    moveq #(-1),d2
/* QL: mt_alchp */
mt_alchp:
/* QL:         moveq   #err.bp,d0      could we be in for a shock? */
    moveq #err.bp,d0
/* QL:         move.l  d1,d7           save requested length */
    move.l d1,d7
/* QL:         bmi.s   rte1            if negative, this is silly! */
    bmi.s rte1
/* QL:         bne.s   sensible */
    bne.s sensible
/* QL:         moveq   #8,d7           zero's pretty lunatic too... make it minimum */
    moveq #8,d7
/* QL: sensible */
sensible:
/* QL:         move.l  d2,d1           put job number in expected hole */
    move.l d2,d1
/* QL:         jsr     ss_jobx(pc)     does job exist? */
    jsr ss_jobx(pc)
/* QL:         exg     d1,d7           get back length and save job number for later */
    exg d1,d7
/* QL:         moveq   #hp_end,d2      include space for heap header */
    moveq #hp_end,d2
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL:         jsr     mm_alchp(pc)    allocate space */
    jsr mm_alchp(pc)
/* QL:         bne.s   rte1 */
    bne.s rte1
/* QL:         addq.l  #hp_drivr,a0 */
    addq.l #hp_drivr,a0
/* QL:         move.l  sv_chtop(a6),(a0)+ set 'driver' (mm_rechp ptr is at this + $c) */
    move.l sv_chtop(a6),(a0)+
/* QL:         assert  hp_drivr,hp_owner-4 */
/* original assertion: hp_drivr,hp_owner-4 */
/* QL:         move.l  d7,(a0)         set owner (flag address already cleared) */
    move.l d7,(a0)
/* QL:         addq.l  #hp_end-hp_owner,a0 move past heap header header */
.word 20616|((((hp_end-hp_owner))&7)<<9)
/* QL:         bra.s   noer */
    bra.s noer
/* QL: * d0 -  o- 0 */
/* QL: * a0 -i  - base of area to be freed, after heap header */
/* QL: mt_rechp */
mt_rechp:
/* QL:         lea     -hp_end(a0),a0  backspace pointer to true start of entry */
    lea (-hp_end)(a0),a0
/* QL:         jsr     mm_rechp(pc) */
    jsr mm_rechp(pc)
/* QL:         bra.s   noer */
    bra.s noer
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- number of bytes required, rounded up to a multiple of 16 */
/* QL: * a0 -  o- base address of area allocated */
/* QL: * d2-d3/a1-a3 destroyed (except when d1 is zero) */
/* QL: mt_alres */
mt_alres:
/* QL:         move.l  sv_respr(a6),a0 */
    move.l sv_respr(a6),a0
/* QL:         move.l  d1,d7           any space to be allocated? */
    move.l d1,d7
/* QL:         ble.s   noer            no, just tell caller where respr starts */
    ble.s noer
/* QL:         bsr.s   basptr */
    bsr.s basptr
/* QL:         cmp.l   sv_jbbas(a6),a3 who's actually asking for the memory? */
    cmp.l sv_jbbas(a6),a3
/* QL:         bne.s   mychp           if not job 0, get the space from the chp */
    bne.s mychp
/* QL:         jsr     mm_altrn(pc)    allocate area, temporarily in transient area */
    jsr mm_altrn(pc)
/* QL:         bne.s   rte2            no space - too bad */
    bne.s rte2
/* QL:         move.l  sv_respr(a6),a1 */
    move.l sv_respr(a6),a1
/* QL:         sub.l   d1,a1 */
    sub.l d1,a1
/* QL:         cmp.l   a0,a1           have we got the space right at the top? */
    cmp.l a0,a1
/* QL:         bgt.s   dropres         no - throw it away, then try chp */
    bgt.s dropres
/* QL:         bne.s   noer            if even higher, assume extra memory linked in! */
    bne.s noer
/* QL:         move.l  a0,sv_respr(a6) set bottom of resident proc area */
    move.l a0,sv_respr(a6)
/* QL: noer */
noer:
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: * N.B. This functional mt.reres version always succeeds! I can't think of any */
/* QL: * reason why it should fail. If the transient area is empty, sb moves up to */
/* QL: * the top of memory. If the transient area is not empty, extra space goes to */
/* QL: * it. If any extensions are present, the system crashes... but we knew that! */
/* QL: * As previous incarnations never worked, I suspect it might be an idea to */
/* QL: * allow the caller to specify (in d1.l) how much to release. */
/* QL: * d0 -  o- 0 */
/* QL: * d1-d3/a0-a3 destroyed */
/* QL: mt_reres */
mt_reres:
/* QL:         assert  sv_respr,sv_ramt-4 */
/* original assertion: sv_respr,sv_ramt-4 */
/* QL:         movem.l sv_respr(a6),a0-a1 */
    movem.l sv_respr(a6),a0-a1
/* QL:         move.l  a1,d7 */
    move.l a1,d7
/* QL:         sub.l   a0,d7           size of resident area */
    sub.l a0,d7
/* QL:         beq.s   noer            if nothing there, forget it! */
    beq.s noer
/* QL:         move.l  a1,sv_respr(a6) junk resident area */
    move.l a1,sv_respr(a6)
/* QL:         move.l  d7,(a0)         make resident area look like a transient slot */
    move.l d7,(a0)
/* QL: retrn */
retrn:
/* QL:         jsr     mm_retrn(pc)    return space to transient area */
    jsr mm_retrn(pc)
/* QL: endreb */
endreb:
/* QL:         move.l  d7,d1 */
    move.l d7,d1
/* QL:         bra.s   noer */
    bra.s noer
/* QL: * The criterion applied for the albas/rebas calls has to be a bit finicky. */
/* QL: * The "grabber" technique for limiting the amount of memory taken up by a job */
/* QL: * involves the pretty dirty trick of allocating the space to job zero, letting */
/* QL: * the job get under way, then releasing the space. */
/* QL: * Unhappily, all the slave blocks get cleaned out in the process! */
/* QL: * There is, unfortunately, no other way to acheive the desired effect, as the */
/* QL: * job may acquire its space from both the common heap and the transient area, */
/* QL: * and job 0 is the only area that can shuffle about to accomodate both. */
/* QL: * ccr-  o- non-zero iff caller is a multibasic job */
/* QL: * a1 -  o- job table entry address of current job */
/* QL: * a2 -  o- header address of current job */
/* QL: basptr */
basptr:
/* QL:         move.l  sv_jbpnt(a6),a3 get current job entry pointer */
    move.l sv_jbpnt(a6),a3
/* QL:         move.l  (a3),a1         get current job's header address */
    move.l (a3),a1
/* QL:         cmp.l   sv_jbbas(a6),a3 is this really job 0? */
    cmp.l sv_jbbas(a6),a3
/* QL:         beq.s   rts0            yes - return ccr = z */
    beq.s rts0
/* QL:         btst    #bv..int,jb_rela6(a1) only multibasic tasks return non-zero ccr */
    btst #bv..int,jb_rela6(a1)
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: * d1 -i o- space to be taken off top of interpreter job / actual space removed */
/* QL: * a6 -i o- base address */
/* QL: * a7 -i o- user stack pointer */
/* QL: * d0/d2-d3/a0-a3 destroyed */
/* QL: mt_rebas */
mt_rebas:
/* QL:         move.l  d1,d7           hold on to space being released */
    move.l d1,d7
/* QL:         beq.s   rte2            do nothing if space released is zero */
    beq.s rte2
/* QL:         bsr.s   basptr */
    bsr.s basptr
/* QL:         bne.s   rebas           caller is a multibasic task - go handle it */
    bne.s rebas
/* QL:         lea     sv_trnsp(a6),a2 */
    lea sv_trnsp(a6),a2
/* QL:         move.l  (a2),a0 */
    move.l (a2),a0
/* QL:         sub.l   d1,a0           new top of job 0 */
    sub.l d1,a0
/* QL:         move.l  d1,(a0)         make tail end look like an in-use trn bit */
    move.l d1,(a0)
/* QL:         move.l  a0,(a2)         now trn moves down */
    move.l a0,(a2)
/* QL: retrn1 */
retrn1:
/* QL:         bra.s   retrn           release the spare bit (it might coalesce) */
    bra.s retrn
/* QL: rebas */
rebas:
/* QL:         move.l  a1,a0 */
    move.l a1,a0
/* QL:         add.l   (a1),a0         current top of job */
    add.l (a1),a0
/* QL:         sub.l   d1,a0           new top of job */
    sub.l d1,a0
/* QL:         move.l  d1,(a0)         make tail end look like an in-use trn bit */
    move.l d1,(a0)
/* QL:         sub.l   d1,(a1)         now we're shorter */
    sub.l d1,(a1)
/* QL:         jsr     mm_retrn(pc)    release it */
    jsr mm_retrn(pc)
/* QL:         bsr.s   basptr */
    bsr.s basptr
/* QL:         move.l  (a1),d1         get our new length */
    move.l (a1),d1
/* QL:         jsr     mm_whtrn(pc)    is there somewhere else we could go? */
    jsr mm_whtrn(pc)
/* QL:         beq.s   endreb          no - leave that as it is */
    beq.s endreb
/* QL:         jsr     mm_gotrn(pc)    yes - take it */
    jsr mm_gotrn(pc)
/* QL:         bra.s   moveme          go move there */
    bra.s moveme
/* QL: * d1 -i o- space to be added to top of interpreter job / actual space added */
/* QL: * a6 -i o- base address */
/* QL: * a7 -i o- user stack pointer */
/* QL: * d0/d2-d3/a0-a3 destroyed */
/* QL: mt_albas */
mt_albas:
/* QL:         bsr.s   basptr */
    bsr.s basptr
/* QL:         bne.s   albas           caller is a multibasic task - go handle it */
    bne.s albas
/* QL:         jsr     mm_mdbas(pc)    move down job 0 */
    jsr mm_mdbas(pc)
/* QL: rte2 */
rte2:
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: * rats. our attempt to expand the current job's area didn't work! */
/* QL: givein */
givein:
/* QL:         move.l  d1,d7           remember the extra required */
    move.l d1,d7
/* QL:         add.l   (a1),d1         add old length to extra required */
    add.l (a1),d1
/* QL:         jsr     mm_altrn(pc) */
    jsr mm_altrn(pc)
/* QL:         bne.s   rte2            ouch! no memory */
    bne.s rte2
/* QL: moveme */
moveme:
/* QL:         bsr.s   basptr */
    bsr.s basptr
/* QL:         move.l  (a1),d1         fetch old length */
    move.l (a1),d1
/* QL:         move.l  (a0),d3         we want to patch back in the new length */
    move.l (a0),d3
/* QL:         jsr     mm_mvjob(pc)    move the job */
    jsr mm_mvjob(pc)
/* QL:         move.l  d3,(a0)         put correct length back */
    move.l d3,(a0)
/* QL:         move.l  a1,a0           release old position */
    move.l a1,a0
/* QL:         bra.s   retrn1 */
    bra.s retrn1
/* QL: * We look here for preceeding and following free areas that we can incorporate. */
/* QL: * The simpler techniques were fairly awful. */
/* QL: * It will be clever to shuffle other basics to make space! */
/* QL: * We have to round up d1 same as altrn would... */
/* QL: * This should all be proper routines in the mm library. */
/* QL: albas */
albas:
/* QL:         subq.l  #1,d1 */
    subq.l #1,d1
/* QL:         or.b    #16-1,d1 */
    or.b #((16-1)&255),d1
/* QL:         addq.l  #1,d1 */
    addq.l #1,d1
/* QL:         ble.s   rte2            get out if silly request */
    ble.s rte2
/* QL:         move.l  (a1),d0 */
    move.l (a1),d0
/* QL:         add.l   a1,d0           top edge of current area */
    add.l a1,d0
/* QL:         moveq   #0,d2           start by showing no following spare space */
    moveq #0,d2
/* QL:         lea     sv_trnfr-hp_next(a6),a0 */
    lea (sv_trnfr-hp_next)(a6),a0
/* QL:         sub.l   a2,a2           remember not to count trnfr as a free space! */
    sub.l a2,a2
/* QL: scntrn */
scntrn:
/* QL:         move.l  a2,d7 */
    move.l a2,d7
/* QL:         move.l  a0,a2 */
    move.l a0,a2
/* QL:         move.l  hp_next(a0),d3 */
    move.l hp_next(a0),d3
/* QL:         beq.s   scnex           end of free list, so no space above us */
    beq.s scnex
/* QL:         add.l   d3,a0 */
    add.l d3,a0
/* QL:         cmp.l   d0,a0 */
    cmp.l d0,a0
/* QL:         bcs.s   scntrn          carry on until we reach our top edge */
    bcs.s scntrn
/* QL:         bne.s   scnex */
    bne.s scnex
/* QL:         move.l  (a0),d2         if exactly on top edge, remember size as useful */
    move.l (a0),d2
/* QL: scnex */
scnex:
/* QL: * We've found any free transient space around us. */
/* QL:         sub.l   d1,d2           how does the space above look? */
    sub.l d1,d2
/* QL:         beq.s   stealit         exact fit - go take the whole space above */
    beq.s stealit
/* QL:         bpl.s   split           more than enough room above - take some */
    bpl.s split
/* QL:         move.l  d7,d3           do we have a preceeding space? */
    move.l d7,d3
/* QL:         beq.s   givein          no - can't fit job in same patch */
    beq.s givein
/* QL:         move.l  (a2),d3         size of preceeding piece */
    move.l (a2),d3
/* QL:         add.l   a2,d3           end of preceeding bit */
    add.l a2,d3
/* QL:         cmp.l   d3,a1           is it the immediately preceeding area? */
    cmp.l d3,a1
/* QL:         bne.s   givein          no - once again, this patch is too small */
    bne.s givein
/* QL:         sub.l   a2,d3           ok, so keep this length */
    sub.l a2,d3
/* QL:         add.l   d2,d3           count off how much more we needed */
    add.l d2,d3
/* QL:         bmi.s   givein          still not enough, so give up completely */
    bmi.s givein
/* QL: * With space before, and maybe the space after, we have enough room. */
/* QL:         add.l   d1,d2           put back size of space above */
    add.l d1,d2
/* QL:         beq.s   joined          if there was a useful space above ... */
    beq.s joined
/* QL:         bsr.s   unlink          ... unlink free space at a0 pointed to from a2 */
    bsr.s unlink
/* QL: joined */
joined:
/* QL:         move.l  a2,a0           now point at preceeding free space */
    move.l a2,a0
/* QL:         move.l  d3,(a0)         put leftover length, do we have an exact fit? */
    move.l d3,(a0)
/* QL:         bne.s   prevset         no - that's done */
    bne.s prevset
/* QL:         move.l  d7,a2           we have to go back one more to unlink this */
    move.l d7,a2
/* QL:         bsr.s   unlink          unlink free space at a0 pointed to from a2 */
    bsr.s unlink
/* QL: prevset */
prevset:
/* QL:         add.l   d3,a0           new position */
    add.l d3,a0
/* QL:         move.l  d1,d3           we want this back */
    move.l d1,d3
/* QL:         move.l  (a1),d1         current size */
    move.l (a1),d1
/* QL:         jsr     mm_mvjob(pc)    move the job to its new position */
    jsr mm_mvjob(pc)
/* QL:         bra.s   doneit          that's all folks! */
    bra.s doneit
/* QL: unlink */
unlink:
/* QL:         move.l  hp_next(a0),d2  get forward link */
    move.l hp_next(a0),d2
/* QL:         beq.s   putit           if there's nothing beyond, just say that */
    beq.s putit
/* QL:         add.l   a0,d2 */
    add.l a0,d2
/* QL:         sub.l   a2,d2 */
    sub.l a2,d2
/* QL: putit */
putit:
/* QL:         move.l  d2,hp_next(a2) */
    move.l d2,hp_next(a2)
/* QL:         rts */
    rts 
/* QL: * We need to split the area, 'cos it's bigger than we want... */
/* QL: * Note that we avoid moving ourselves about the place if we don't have to. */
/* QL: split */
split:
/* QL:         move.l  hp_next(a0),d0  get forward link */
    move.l hp_next(a0),d0
/* QL:         beq.s   nosub           if it's zero, leave it */
    beq.s nosub
/* QL:         sub.l   d1,d0           otherwise we get closer, so want a shorter link */
    sub.l d1,d0
/* QL: nosub */
nosub:
/* QL:         add.l   d1,a0           this is where the remainder goes */
    add.l d1,a0
/* QL:         move.l  d2,(a0)+        set it's length */
    move.l d2,(a0)+
/* QL:         move.l  d0,(a0)+        set it's link */
    move.l d0,(a0)+
/* QL:         clr.l   (a0)            and make it owned by job 0 */
    clr.l (a0)
/* QL:         add.l   d1,hp_next(a2)  finally, move prior link forward */
    add.l d1,hp_next(a2)
/* QL:         bra.s   samepos */
    bra.s samepos
/* QL: * By amazing coincidence, the space was just the size we wanted. take it! */
/* QL: stealit */
stealit:
/* QL:         bsr.s   unlink          unlink free space at a0 pointed to from a2 */
    bsr.s unlink
/* QL: samepos */
samepos:
/* QL:         move.l  a1,a0           we haven't actually moved... */
    move.l a1,a0
/* QL: doneit */
doneit:
/* QL:         add.l   d1,(a0)         say we've got bigger */
    add.l d1,(a0)
/* QL:         jmp     ss_noer(pc)     done! */
    jmp ss_noer(pc)
/* QL:         end */
