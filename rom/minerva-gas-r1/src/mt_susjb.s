/* Generated from original/M/mt/susjb.asm */
/* QL: * Set priority, activate, suspend or release a job */
/* QL:         xdef    mt_susjb,mt_reljb,mt_activ,mt_prior */
.globl mt_susjb,mt_reljb,mt_activ,mt_prior
/* QL:         xref    ss_jobx,ss_jobc,ss_reshd */
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
/* QL:         section mt_susjb */
.section mt_susjb,"ax"
/* QL: * d0 -  o- error return */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * d2 -ip - new priority */
/* QL: * a0 -  o- base address of job */
/* QL: * a6 -ip - base address of system variables */
/* QL: mt_prior */
mt_prior:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         move.b  d2,jb_princ(a0) set new priority */
    move.b d2,jb_princ(a0)
/* QL:         bne.s   exit_ok         is priority zero */
    bne.s exit_ok
/* QL:         sf      jb_prior(a0)    ... yes - kill it */
    sf jb_prior(a0)
/* QL:         bra.s   exit_ok */
    bra.s exit_ok
/* QL: * d0 -  o- error return */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * d2 -ip - new priority */
/* QL: * d3 -ip - timeout (anything but zero is wait for completion) */
/* QL: * a0 -  o- base address of job */
/* QL: * a6 -ip - base address of system variables */
/* QL: * a3 destroyed iff d3 <> 0 */
/* QL: mt_activ */
mt_activ:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         moveq   #err.nc,d0 */
    moveq #err.nc,d0
/* QL:         tst.b   jb_princ(a0)    is job active? */
    tst.b jb_princ(a0)
/* QL:         bne.s   re_sched        yes - can't do it twice! */
    bne.s re_sched
/* QL:         move.b  d2,jb_princ(a0) */
    move.b d2,jb_princ(a0)
/* QL:         move.l  jb_start(a0),d7 do it have the facilty to be activated? */
    move.l jb_start(a0),d7
/* QL:         ble.s   re_sched        no - don't do anything silly! */
    ble.s re_sched
/* QL:         move.l  d7,jb_pc(a0)    set start address in saved pc */
    move.l d7,jb_pc(a0)
/* QL:         tst.w   d3              is it wait on completion? */
    tst.w d3
/* QL:         beq.s   exit_ok         ... no - just reschedule */
    beq.s exit_ok
/* QL:         st      jb_wflag(a0)    set job waiting flag */
    st jb_wflag(a0)
/* QL:         jsr     ss_jobc(pc)     get current job id and address */
    jsr ss_jobc(pc)
/* QL:         move.l  d0,jb_wjob(a0)  ... and set id of waiting job */
    move.l d0,jb_wjob(a0)
/* QL:         move.w  #-2,jb_stat(a3) ... then timeout */
    move.w #(-2),jb_stat(a3)
/* QL: * note - when suspended jobs can be reactivated we could set d0 to err.nc here */
/* QL: exit_ok */
exit_ok:
/* QL:         moveq   #0,d0           set no error */
    moveq #0,d0
/* QL: re_sched */
re_sched:
/* QL:         jmp     ss_reshd(pc)    ... and re-schedule */
    jmp ss_reshd(pc)
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * d3 -ip - timeout */
/* QL: * a0 -  o- address of job header */
/* QL: * a1 -ip - zero or address of hold flag byte */
/* QL: * a6 -ip - base address of system variables */
/* QL: mt_susjb */
mt_susjb:
/* QL:         jsr     ss_jobx(pc)     check job number */
    jsr ss_jobx(pc)
/* QL:         move.w  d3,jb_stat(a0)  suspend */
    move.w d3,jb_stat(a0)
/* QL:         move.l  a1,jb_hold(a0)  and set hold */
    move.l a1,jb_hold(a0)
/* QL:         bra.s   exit_ok         no error */
    bra.s exit_ok
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * a0 -  o- address of job header */
/* QL: * a6 -ip - base address of system variables */
/* QL: mt_reljb */
mt_reljb:
/* QL:         jsr     ss_jobx(pc)     check job number */
    jsr ss_jobx(pc)
/* QL:         tst.w   jb_stat(a0)     is it suspended? */
    tst.w jb_stat(a0)
/* QL:         beq.s   exit_ok */
    beq.s exit_ok
/* QL:         clr.w   jb_stat(a0)     release it */
    clr.w jb_stat(a0)
/* QL:         move.l  jb_hold(a0),d0  and check if hold flag exists */
    move.l jb_hold(a0),d0
/* QL:         beq.s   exit_ok */
    beq.s exit_ok
/* QL:         exg     d0,a0 */
    exg d0,a0
/* QL:         sf      (a0)            clear hold flag byte */
    sf (a0)
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         bra.s   exit_ok */
    bra.s exit_ok
/* QL:         end */
