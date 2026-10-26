/* Generated from original/M/mt/trap.asm */
/* QL: * Manager traps (#1) general entry point */
/* QL:         xdef    mt_trap */
.globl mt_trap
/* QL:         xref    ss_rte + lots of other "xref"'s, done by macro */
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
/* QL:         section mt_trap */
.section mt_trap,"ax"
/* QL: * d0 cr  control parameter / error flag */
/* QL: * d7   s branch offset */
/* QL: mt_trap */
mt_trap:
/* QL:         movem.l d7/a5-a6,-(sp)  save standard registers */
    movem.l d7/a5-a6,-(sp)
/* QL:         move.l  sp,d7 */
    move.l sp,d7
/* QL:         and.w   #$8000,d7 */
    and.w #0x8000,d7
/* QL:         move.l  d7,a6           do not assume there is only one screen */
    move.l d7,a6
/* QL:         move.l  sp,a5           mark stack, just for mm_mvjob */
    move.l sp,a5
/* QL: * There really ought to be a better way of doing this!!! */
/* QL: * The scenarios when a5 is needed are: */
/* QL: *       cjob from job 0 may push job 0 down */
/* QL: *       frjob and rjob from job 0 can let job 0 go up */
/* QL: *       alres and reres from job 0 can move job 0 */
/* QL: *       albas and rebas from job 0 or multibasics may make them move */
/* QL: * The trouble is that the stack depth when access to a6 is needed varies */
/* QL: * enormously. */
/* QL: * It might be conceivably better to make lots of the internal code use a5 */
/* QL: * instead of a6, so that a6 could be kept current. */
/* QL: * Alternatively, as most stuff has a use for the current job pointer, maybe a5 */
/* QL: * could be set to it and a6 could be put in its proper save area? */
/* QL:         moveq   #127,d7         ensure trap is positive byte only */
    moveq #127,d7
/* QL:         and.l   d7,d0 */
    and.l d7,d0
/* QL:         moveq   #(ent_tabl-ent_top)/2,d7 */
    moveq #((ent_tabl-ent_top)/2),d7
/* QL:         add.w   d0,d7 */
    add.w d0,d7
/* QL:         bcs.s   error           if action not in range */
    bcs.s error
/* QL:         add.w   d7,d7           d7 addresses words */
    add.w d7,d7
/* QL:         move.w  ent_top(pc,d7.w),d7 load entry offset to our junk data reg */
    move.w ent_top(pc,d7.w),d7
/* QL:         jmp     mt_trap(pc,d7.w) jump to it!! */
.word 0x4efb
.word 28672|((mt_trap-.)&255)
/* QL: error */
error:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: tb      macro */
/* QL: ent_tabl */
ent_tabl:
/* QL:  tb 00 inf   01 cjob  02 jinf  03 extop 04 rjob  05 frjob 06 free  07 trapv */
/* QL:         local   i */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_124:
.word ((mt_inf-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_132:
.word ((mt_cjob-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_140:
.word ((mt_jinf-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_148:
.word ((mt_extop-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_156:
.word ((mt_rjob-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_164:
.word ((mt_frjob-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_172:
.word ((mt_free-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_180:
.word ((mt_trapv-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tb 08 susjb 09 reljb 0a activ 0b prior 0c alloc 0d lnkfr 0e alres 0f reres */
/* QL:         local   i */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_191:
.word ((mt_susjb-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_199:
.word ((mt_reljb-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_207:
.word ((mt_activ-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_215:
.word ((mt_prior-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_223:
.word ((mt_alloc-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_231:
.word ((mt_lnkfr-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_239:
.word ((mt_alres-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_247:
.word ((mt_reres-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tb 10 dmode 11 ipcom 12 baud  13 rclck 14 sclck 15 aclck 16 albas 17 rebas */
/* QL:         local   i */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_258:
.word ((mt_dmode-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_266:
.word ((mt_ipcom-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_274:
.word ((mt_baud-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_282:
.word ((mt_rclck-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_290:
.word ((mt_sclck-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_298:
.word ((mt_aclck-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_306:
.word ((mt_albas-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_314:
.word ((mt_rebas-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tb 18 alchp 19 rechp 1a lxint 1b rxint 1c lpoll 1d rpoll 1e lschd 1f rschd */
/* QL:         local   i */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_325:
.word ((mt_alchp-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_333:
.word ((mt_rechp-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_341:
.word ((mt_lxint-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_349:
.word ((mt_rxint-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_357:
.word ((mt_lpoll-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_365:
.word ((mt_rpoll-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_373:
.word ((mt_lschd-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_381:
.word ((mt_rschd-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tb 20 liod  21 riod  22 ldd   23 rdd   24 cntry */
/* QL:         local   i */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_392:
.word ((mt_liod-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_400:
.word ((mt_riod-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_408:
.word ((mt_ldd-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_416:
.word ((mt_rdd-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+2 */
/* QL:         xref    mt_[.parm([i])] */
/* QL:         dc.w    mt_[.parm([i])]-mt_trap */
.balign 2,0
dc_anchor_424:
.word ((mt_cntry-mt_trap))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: ent_top */
ent_top:
/* QL:         end */
