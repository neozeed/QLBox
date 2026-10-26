/* Generated from original/M/mt/jinf.asm */
/* QL: * Information on, and deletion of, jobs */
/* QL:         xdef    mt_jinf,mt_rjob,mt_frjob,mt_close */
.globl mt_jinf,mt_rjob,mt_frjob,mt_close
/* QL:         xref    mm_retrn */
/* QL:         xref    ss_dljob,ss_joba,ss_jobx,ss_noer,ss_rte */
/* QL:         xref    io_jbchk */
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
/* QL:         include 'win1_m_inc_ch' */
/* QL: * channel definition block / driver headers */
/* QL:         nolist */
/* QL: * channel definition header for all channels */
/* QL:         offset  0 */
/* QL: ch_len  ds.l    1       length of definition block */
.equ ch_len,0
/* QL: ch_drivr ds.l   1       address of driver */
.equ ch_drivr,4
/* QL: ch_owner ds.l   1       owner job */
.equ ch_owner,8
/* QL: ch_rflag ds.l   1       address to be set when space released */
.equ ch_rflag,12
/* QL: ch_tag  ds.w    1       channel tag */
.equ ch_tag,16
/* QL: ch_stat ds.b    1       status: 0 ok, else waiting -1 a1 abs, $80 a1 rel a6 */
.equ ch_stat,18
/* QL: ch_actn ds.b    1       stored action for waiting job */
.equ ch_actn,19
/* QL: ch_jobwt ds.l   1       ID of job waiting on I/O */
.equ ch_jobwt,20
/* QL: ch_end */
.equ ch_end,24
/* QL: * extended channel definition for plain serial queues */
/* QL: ch_qin  ds.l    1       pointer to input queue (or zero) */
.equ ch_qin,24
/* QL: ch_qout ds.l    1       pointer to output queue (or zero) */
.equ ch_qout,28
/* QL: ch_qend */
.equ ch_qend,32
/* QL: * device driver header */
/* QL:         offset  0 */
/* QL: ch_next ds.l    1       pointer to next driver */
.equ ch_next,0
/* QL: ch_inout ds.l   1       entry for input and output */
.equ ch_inout,4
/* QL: ch_open ds.l    1       entry for open */
.equ ch_open,8
/* QL: ch_close ds.l   1       entry for close */
.equ ch_close,12
/* QL: * the following are for directory devices (file system) only: */
/* QL: ch_slave ds.l   1       entry for slaving blocks */
.equ ch_slave,16
/* QL: ch_renam ds.l   1       entry reserved for rename */
.equ ch_renam,20
/* QL:         ds.l    1 */
/* QL: ch_formt ds.l   1       entry for format medium */
.equ ch_formt,28
/* QL: ch_dflen ds.l   1       length of physical definition block */
.equ ch_dflen,32
/* QL: ch_drnam ds.w   1       length prefixed drive name */
.equ ch_drnam,36
/* QL:         list */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         section mt_jinf */
.section mt_jinf,"ax"
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- job id / job id of next job in tree */
/* QL: * d2 -i o- job number at top of tree / job id of owner of requested job */
/* QL: * d3 -  o- msb status (-1 suspended) and lsb priority */
/* QL: * a0 -  o- base address of code of requested job (i.e. job header + jb_end) */
/* QL: mt_jinf */
mt_jinf:
/* QL:         jsr     ss_jobx(pc)     does job exist?  (sets a0) */
    jsr ss_jobx(pc)
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         tst.w   jb_stat(a0)     is job suspended */
    tst.w jb_stat(a0)
/* QL:         beq.s   set_prio */
    beq.s set_prio
/* QL:         moveq   #-1,d3          yes - set suspended */
    moveq #(-1),d3
/* QL: set_prio */
set_prio:
/* QL:         move.b  jb_princ(a0),d3 set priority */
    move.b jb_princ(a0),d3
/* QL:         move.l  d2,d0           stop scanning at top of tree */
    move.l d2,d0
/* QL:         move.l  a0,-(sp)        save job base address */
    move.l a0,-(sp)
/* QL:         bsr.s   tree            ... and find next job */
    bsr.s tree
/* QL:         move.l  (sp)+,a0        restore base address of this job */
    move.l (sp)+,a0
/* QL:         move.l  jb_owner(a0),d2 ... find owner of this job */
    move.l jb_owner(a0),d2
/* QL:         lea     jb_end(a0),a0   ... and base address of job */
    lea jb_end(a0),a0
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: * Scans a tree of jobs - one each entry */
/* QL: * d0 -ip - job number at top of tree (d0.w) */
/* QL: * d1 -i o- current job id / next job id (0 = end of tree) */
/* QL: * d2 -  o- id of owner of next job */
/* QL: * a0 -  o- base address of next job */
/* QL: * a1 -  o- pointer to table entry for next job */
/* QL: up_tree */
up_tree:
/* QL:         moveq   #0,d1           next job is 0 */
    moveq #0,d1
/* QL:         cmp.w   d2,d0           are we already at top of tree? */
    cmp.w d2,d0
/* QL:         beq.s   rts0            yes - there are no more jobs in tree */
    beq.s rts0
/* QL:         move.w  d2,d1           find address of owner */
    move.w d2,d1
/* QL:         bsr.s   find_add */
    bsr.s find_add
/* QL:         beq.s   rts0            silly! someone gave an invalid job as top! */
    beq.s rts0
/* QL:         move.l  jb_owner(a0),d2 get owner of owner */
    move.l jb_owner(a0),d2
/* QL: next_job */
next_job:
/* QL:         addq.w  #1,d1           next job */
    addq.w #1,d1
/* QL:         cmp.w   sv_jbmax(a6),d1 is this beyond highest job number */
    cmp.w sv_jbmax(a6),d1
/* QL:         bgt.s   up_tree         yes - there are no daughter jobs */
    bgt.s up_tree
/* QL:         bsr.s   find_add        find address of job */
    bsr.s find_add
/* QL:         tst.b   (a1)            does it exist? */
    tst.b (a1)
/* QL:         blt.s   next_job        no try another */
    blt.s next_job
/* QL:         cmp.l   jb_owner(a0),d2 is this job owned by the right job */
    cmp.l jb_owner(a0),d2
/* QL:         bne.s   next_job        no - try another */
    bne.s next_job
/* QL:         swap    d1              save lsw */
    swap d1
/* QL:         move.w  jb_tag(a0),d1   fetch tag */
    move.w jb_tag(a0),d1
/* QL:         swap    d1              full job id */
    swap d1
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: tree */
tree:
/* QL:         move.l  d1,d2           look for job owned by this job */
    move.l d1,d2
/* QL:         moveq   #0,d1           start at beginning of table */
    moveq #0,d1
/* QL:         bra.s   next_job */
    bra.s next_job
/* QL: find_add */
find_add:
/* QL:         bsr.s   jbptr           go make up pointer */
    bsr.s jbptr
/* QL:         move.l  (a1),a0         this is base of job itself */
    move.l (a1),a0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i  - id of job to be removed */
/* QL: * d3 -i  - error code to send to any waiting jobs */
/* QL: * d2/a0-a3 destroyed */
/* QL: mt_rjob */
mt_rjob:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         move.l  d1,d0           set top of tree */
    move.l d1,d0
/* QL: * Check if any job in tree is active */
/* QL: chk_loop */
chk_loop:
/* QL:         tst.b   jb_princ(a0)    is job active */
    tst.b jb_princ(a0)
/* QL:         bne.s   jb_activ        yes - cannot delete */
    bne.s jb_activ
/* QL:         bsr.s   tree            find next job */
    bsr.s tree
/* QL:         tst.l   d1              is this end of tree */
    tst.l d1
/* QL:         bne.s   chk_loop        no - check this job */
    bne.s chk_loop
/* QL:         move.l  d0,d1           restore top of tree job */
    move.l d0,d1
/* QL: * Drop into force remove job */
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i  - id of job to be removed */
/* QL: * d3 -i  - error code to send to any waiting jobs */
/* QL: * d2/a0-a3 destroyed */
/* QL: mt_frjob */
mt_frjob:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         move.l  d1,d0           set top of tree */
    move.l d1,d0
/* QL:         bne.s   okdel           do not try to delete job 0 */
    bne.s okdel
/* QL:         cmp.l   sv_jbpnt(a6),a0 is this job 0 removing itself!!? */
    cmp.l sv_jbpnt(a6),a0
/* QL:         beq.s   help */
    beq.s help
/* QL: jb_activ */
jb_activ:
/* QL:         moveq   #err.nc,d0      job still active - not complete */
    moveq #err.nc,d0
/* QL: ssrte */
ssrte:
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: help */
help:
/* QL: * Job 0 has suicided, until we can think of something better... */
/* QL:         sf      jb_princ(a0)    make it go very quiet */
    sf jb_princ(a0)
/* QL:         bra.s   discard         discard whatever it was doing */
    bra.s discard
/* QL: del_elop */
del_elop:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL:         tst.l   (sp)+           check if this job is deleted */
    tst.l (sp)+
/* QL:         bpl.s   ssrte           no, that's ok */
    bpl.s ssrte
/* QL: discard */
discard:
/* QL:         add.w   #3*4+2+4,sp     discard stacked d7/a5-a6, sr and pc */
    add.w #(((3*4)+2)+4),sp
/* QL:         jmp     ss_dljob(pc)    yes, re-enter scheduler, job deleted */
    jmp ss_dljob(pc)
/* QL: jbptr */
jbptr:
/* QL:         move.w  d1,a1           find address of job entry */
    move.w d1,a1
/* QL:         add.w   a1,a1           job number *4 */
    add.w a1,a1
/* QL:         add.w   a1,a1 */
    add.w a1,a1
/* QL:         add.l   sv_jbbas(a6),a1 + base address */
    add.l sv_jbbas(a6),a1
/* QL:         rts */
    rts 
/* QL: okdel */
okdel:
/* QL:         bsr.s   jbptr           make up job pointer */
    bsr.s jbptr
/* QL: mrk_loop */
mrk_loop:
/* QL:         addq.b  #8,(a1)         mark job */
    addq.b #8,(a1)
/* QL:         bsr.s   tree            find next job */
    bsr.s tree
/* QL:         tst.w   d1              is this end of tree */
    tst.w d1
/* QL:         bne.s   mrk_loop        no - mark this job */
    bne.s mrk_loop
/* QL: * All jobs to be deleted have been marked with +ve in msb of table entry */
/* QL: * We get cleverer these days... first close all channels, in case any other */
/* QL: * jobs are waiting on a channel that goes with this set of jobs. */
/* QL:         assert  sv_chbas,sv_chtop-4 */
/* original assertion: sv_chbas,sv_chtop-4 */
/* QL:         movem.l sv_chbas(a6),a2-a3 */
    movem.l sv_chbas(a6),a2-a3
/* QL: chloop */
chloop:
/* QL:         move.l  -(a3),d0        get next channel pointer */
    move.l -(a3),d0
/* QL:         bmi.s   chnext          not in use, skip it */
    bmi.s chnext
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         move.w  ch_owner+2(a0),d1 fetch owner job number, then make pointer */
    move.w (ch_owner+2)(a0),d1
/* QL:         bsr.s   jbptr */
    bsr.s jbptr
/* QL:         tst.b   (a1) */
    tst.b (a1)
/* QL:         ble.s   chnext */
    ble.s chnext
/* QL:         bsr.s   mt_close        if one of ours, close the channel now */
    bsr.s mt_close
/* QL: chnext */
chnext:
/* QL:         cmp.l   a2,a3 */
    cmp.l a2,a3
/* QL:         bne.s   chloop          carry one through all the channel table */
    bne.s chloop
/* QL: * Close entries in common heap for all jobs being deleted. */
/* QL: * This used to be done on a per job basis, but it's quicker to do a single scan */
/* QL: * as there can be a lot of cases of released memory joining up. */
/* QL:         move.l  sv_cheap(a6),a2 start scanning through common heap */
    move.l sv_cheap(a6),a2
/* QL: chk_tbl */
chk_tbl:
/* QL:         move.w  hp_owner+2(a2),d0 */
    move.w (hp_owner+2)(a2),d0
/* QL:         cmp.w   sv_jbmax(a6),d0 a safety check, in case memory corrupted */
    cmp.w sv_jbmax(a6),d0
/* QL:         bhi.s   nxt_tbl */
    bhi.s nxt_tbl
/* QL:         lsl.w   #2,d0 */
    lsl.w #2,d0
/* QL:         beq.s   nxt_tbl         don't touch it if it's got job 0 as owner */
    beq.s nxt_tbl
/* QL:         move.l  sv_jbbas(a6),a0 */
    move.l sv_jbbas(a6),a0
/* QL:         add.w   d0,a0 */
    add.w d0,a0
/* QL:         tst.b   (a0)            are we removing this job? */
    tst.b (a0)
/* QL:         ble.s   nxt_tbl         no - don't think about it any more */
    ble.s nxt_tbl
/* QL:         move.l  a2,a0           put heap pointer in right register */
    move.l a2,a0
/* QL:         bsr.s   close           get rid of it */
    bsr.s close
/* QL:         cmp.l   sv_free(a6),a2  is it off end? */
    cmp.l sv_free(a6),a2
/* QL:         bcc.s   mem_ex          yes! memory must have been released to sb's! */
    bcc.s mem_ex
/* QL: nxt_tbl */
nxt_tbl:
/* QL:         assert  hp_len,0 */
/* original assertion: hp_len,0 */
/* QL:         add.l   (a2),a2         move to next item */
    add.l (a2),a2
/* QL:         cmp.l   sv_free(a6),a2  is it off end? */
    cmp.l sv_free(a6),a2
/* QL:         bcs.s   chk_tbl */
    bcs.s chk_tbl
/* QL: mem_ex */
mem_ex:
/* QL: * All common heap has been cleaned out, now see off the jobs themselves */
/* QL:         clr.l   -(sp)           set job number, msb set if current job deleted */
    clr.l -(sp)
/* QL: del_loop */
del_loop:
/* QL:         addq.l  #1,(sp)         next job */
    addq.l #1,(sp)
/* QL:         move.l  (sp),d1 */
    move.l (sp),d1
/* QL:         cmp.w   sv_jbmax(a6),d1 all done? */
    cmp.w sv_jbmax(a6),d1
/* QL:         bhi.s   del_elop */
    bhi.s del_elop
/* QL:         bsr.s   jbptr           make up the job pointer */
    bsr.s jbptr
/* QL:         tst.b   (a1)            is this job to be deleted? */
    tst.b (a1)
/* QL:         ble.s   del_loop        ... no */
    ble.s del_loop
/* QL: * this job is to be deleted */
/* QL:         cmp.l   sv_jbpnt(a6),a1 is this the current job */
    cmp.l sv_jbpnt(a6),a1
/* QL:         bne.s   notcur */
    bne.s notcur
/* QL:         tas     (sp)            set flag to say current job is deleted */
    tas (sp)
/* QL: notcur */
notcur:
/* QL:         sf      (a1)            remove the mark so address is valid */
    sf (a1)
/* QL:         move.l  (a1),a2         get address of header */
    move.l (a1),a2
/* QL:         st      (a1)            mark it deleted now */
    st (a1)
/* QL: * Release any waiting jobs */
/* QL:         tst.b   jb_wflag(a2)    is a job waiting? */
    tst.b jb_wflag(a2)
/* QL:         beq.s   del_tbl */
    beq.s del_tbl
/* QL:         move.l  jb_wjob(a2),d1  get job id */
    move.l jb_wjob(a2),d1
/* QL:         jsr     ss_joba(pc)     find job address */
    jsr ss_joba(pc)
/* QL:         bne.s   del_tbl         oops - it's gone away!! */
    bne.s del_tbl
/* QL:         cmp.w   #-2,jb_stat(a0) is this waiting on job completion? */
    cmp.w #(-2),jb_stat(a0)
/* QL:         bne.s   del_tbl */
    bne.s del_tbl
/* QL:         clr.w   jb_stat(a0)     release job */
    clr.w jb_stat(a0)
/* QL:         move.l  d3,jb_d0(a0)    set error return */
    move.l d3,jb_d0(a0)
/* QL: del_tbl */
del_tbl:
/* QL: * Finally, release job space */
/* QL:         move.l  a2,a0 */
    move.l a2,a0
/* QL:         move.l  d3,-(sp) */
    move.l d3,-(sp)
/* QL:         jsr     mm_retrn(pc) */
    jsr mm_retrn(pc)
/* QL:         move.l  (sp)+,d3 */
    move.l (sp)+,d3
/* QL:         bra.s   del_loop        next job */
    bra.s del_loop
/* QL: * a0 -i  - area in common heap to be "closed" */
/* QL: * d0/a1 destroyed (a1 could be saved...) */
/* QL: clreg   reg     d1-d7/a2-a6     all registers can be smashed by close */
/* QL: mt_close */
mt_close:
/* QL:         tst.b   ch_stat(a0)     is anyone waiting on this channel? */
    tst.b ch_stat(a0)
/* QL:         beq.s   close           nope, just scrap it */
    beq.s close
/* QL:         jsr     io_jbchk(pc)    check if job is still around */
    jsr io_jbchk(pc)
/* QL:         bne.s   close           nope, forget about it */
    bne.s close
/* QL:         moveq   #err.no,d0 */
    moveq #err.no,d0
/* QL:         move.l  d0,jb_d0(a1)    tell job the channel is no longer open */
    move.l d0,jb_d0(a1)
/* QL:         clr.w   jb_stat(a1)     job is no longer waiting */
    clr.w jb_stat(a1)
/* QL: close */
close:
/* QL:         movem.l clreg,-(sp)     save registers */
    movem.l d1-d7/a2-a6,-(sp)
/* QL:         assert  0,hp_drivr-4,hp_owner-8,hp_rflag-12 */
/* original assertion: 0,hp_drivr-4,hp_owner-8,hp_rflag-12 */
/* QL:         lea     hp_rflag(a0),a1 */
    lea hp_rflag(a0),a1
/* QL:         move.l  (a1),d0         check release flag address */
    move.l (a1),d0
/* QL:         beq.s   cls_tbl */
    beq.s cls_tbl
/* QL:         move.l  d0,a3 */
    move.l d0,a3
/* QL:         st      (a3)            flag this entry gone */
    st (a3)
/* QL:         clr.l   (a1)            clean out the release flag now! */
    clr.l (a1)
/* QL: cls_tbl */
cls_tbl:
/* QL:         clr.l   -(a1)           discard the owner now! */
    clr.l -(a1)
/* QL:         move.l  -(a1),a1        fetch address of driver for this item */
    move.l -(a1),a1
/* QL:         lea     -sv_lio(a1),a3  set base of driver definition block */
    lea (-sv_lio)(a1),a3
/* QL:         move.l  hp_close(a1),a1 close item */
    move.l hp_close(a1),a1
/* QL:         jsr     (a1) */
    jsr (a1)
/* QL:         movem.l (sp)+,clreg     restore registers */
    movem.l (sp)+,d1-d7/a2-a6
/* QL:         rts */
    rts 
/* QL:         end */
