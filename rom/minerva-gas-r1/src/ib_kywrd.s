/* Generated from original/M/ib/kywrd.asm */
/* QL: * Execute a keyword line */
/* QL:         xdef    ib_kywrd */
.globl ib_kywrd
/* QL: * All "xref"'s from macro */
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
/* QL: h setstr { ib_rts ib_errnf ib_errbl } */
/* QL: gotab   macro */
/* QL:         section ib_kywrd */
.section ib_kywrd,"ax"
/* QL: kyentry */
kyentry:
/* QL:         gotab         end   for   if    rep   sel   when  def */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_78:
.word ((ib_end-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_89:
.word ((ib_for-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_100:
.word ((ib_if-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_111:
.word ((ib_rep-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_122:
.word ((ib_sel-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_133:
.word ((ib_when-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_144:
.word ((ib_def-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         gotab   errnf errnf goto  errnf errnf errnf errnf errnf */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_156:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_166:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_177:
.word ((ib_goto-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_187:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_197:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_207:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_217:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_227:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         gotab   errnf restr next  exit  else  on    ret   errnf */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_239:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_250:
.word ((ib_restr-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_261:
.word ((ib_next-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_272:
.word ((ib_exit-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_283:
.word ((ib_else-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_294:
.word ((ib_on-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_305:
.word ((ib_ret-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_315:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         gotab   rts   dim   errbl name  errnf errnf rts   errbl */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_327:
.word ((ib_rts-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_338:
.word ((ib_dim-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_348:
.word ((ib_errbl-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_359:
.word ((ib_name-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_369:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_379:
.word ((ib_errnf-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_389:
.word ((ib_rts-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-ib_rts */
.balign 2,0
dc_anchor_399:
.word ((ib_errbl-ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: ib_kywrd */
ib_kywrd:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.b  1(a6,a4.l),d0   read key number */
    move.b 1(a6,a4.l),d0
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL:         add.b   d0,d0           entries in words */
    add.b d0,d0
/* QL:         move.w  kyentry-2(pc,d0.w),d0 get code offset */
    move.w (kyentry-2)(pc,d0.w),d0
/* QL:         jmp     ib_rts(pc,d0.w) note: if we go to ib_rts, d0=0 */
.word 0x4efb
.word 0|((ib_rts-.)&255)
/* QL: ib_errnf */
ib_errnf:
/* QL:         moveq   #err.nf,d0 */
    moveq #err.nf,d0
/* QL:         rts */
    rts 
/* QL: ib_errbl */
ib_errbl:
/* QL:         moveq   #err.bl,d0 */
    moveq #err.bl,d0
/* QL: ib_rts */
ib_rts:
/* QL:         rts */
    rts 
/* QL:         end */
