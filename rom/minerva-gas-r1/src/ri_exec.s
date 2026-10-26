/* Generated from original/M/ri/exec.asm */
/* QL: * Execute RI functions */
/* QL:         xdef    ri_abex,ri_abexb,ri_exec,ri_execb */
.globl ri_abex,ri_abexb,ri_exec,ri_execb
/* QL: * Various "xref"'s defined via macro */
/* QL:         include 'win1_m_inc_ri' */
/* QL: * arithmetic interpreter op codes */
/* QL:         nolist */
/* QL: ri.term equ     $00  0  end of block */
.equ ri.term,0x00
/* QL: ri.one  equ     $01 -6  constant one */
.equ ri.one,0x01
/* QL: ri.nint equ     $02 +4  nearest short integer */
.equ ri.nint,0x02
/* QL: ri.zero equ     $03 -6  constant zero */
.equ ri.zero,0x03
/* QL: ri.int  equ     $04 +4  truncate towards negative to give a short integer */
.equ ri.int,0x04
/* QL: ri.n    equ     $05 -6  plus a signed byte to push fp -128 to 127 */
.equ ri.n,0x05
/* QL: ri.nlint equ    $06 +2  nearest long integer */
.equ ri.nlint,0x06
/* QL: ri.k    equ     $07 -6  plus a byte, nibbles give mantissa and adjust exponent */
.equ ri.k,0x07
/* QL: ri.float equ    $08 -4  float a short integer */
.equ ri.float,0x08
/* QL: ri.flong equ    $09 -2  float a long integer */
.equ ri.flong,0x09
/* QL: ri.add  equ     $0a +6  nos - tos */
.equ ri.add,0x0a
/* QL: ri.sub  equ     $0c +6  nos + tos */
.equ ri.sub,0x0c
/* QL: ri.halve equ    $0d  0  tos / 2 */
.equ ri.halve,0x0d
/* QL: ri.mult  equ    $0e +6  nos * tos */
.equ ri.mult,0x0e
/* QL: ri.doubl equ    $0f  0  tos * 2 */
.equ ri.doubl,0x0f
/* QL: ri.div  equ     $10 +6  nos / tos */
.equ ri.div,0x10
/* QL: ri.recip equ    $11  0  1 / tos */
.equ ri.recip,0x11
/* QL: ri.abs  equ     $12  0  abs(tos) */
.equ ri.abs,0x12
/* QL: ri.roll equ     $13  0  (tos)b, c, a -> (tos)a, b, c (roll 3rd to top) */
.equ ri.roll,0x13
/* QL: ri.neg  equ     $14  0  -tos */
.equ ri.neg,0x14
/* QL: ri.over equ     $15 -6  nos */
.equ ri.over,0x15
/* QL: ri.dup  equ     $16 -6  tos */
.equ ri.dup,0x16
/* QL: ri.swap equ     $17  0  nos <--> tos */
.equ ri.swap,0x17
/* QL: ri.cos  equ     $18  0  cos(tos) */
.equ ri.cos,0x18
/* QL: ri.sin  equ     $1a  0  sin(tos) */
.equ ri.sin,0x1a
/* QL: ri.tan  equ     $1c  0  tan(tos) */
.equ ri.tan,0x1c
/* QL: ri.cot  equ     $1e  0  cot(tos) */
.equ ri.cot,0x1e
/* QL: ri.asin equ     $20  0  arcsin(tos) */
.equ ri.asin,0x20
/* QL: ri.acos equ     $22  0  arccos(tos) */
.equ ri.acos,0x22
/* QL: ri.atan equ     $24  0  arctan(tos) */
.equ ri.atan,0x24
/* QL: ri.arg  equ     $25 +6  arg(tos,nos) = a, solves tos/nos = k*cos(a)/k*sin(a) */
.equ ri.arg,0x25
/* QL: ri.acot equ     $26  0  arccot(tos) */
.equ ri.acot,0x26
/* QL: ri.mod  equ     $27 +6  sqrt(tos^2 + nos^2) */
.equ ri.mod,0x27
/* QL: ri.sqrt equ     $28  0  sqrt(tos) */
.equ ri.sqrt,0x28
/* QL: ri.squar equ    $29  0  tos * tos */
.equ ri.squar,0x29
/* QL: ri.ln   equ     $2a  0  ln(tos) */
.equ ri.ln,0x2a
/* QL: ri.log10 equ    $2c  0  log10(tos) */
.equ ri.log10,0x2c
/* QL: ri.exp  equ     $2e  0  e ^ tos */
.equ ri.exp,0x2e
/* QL: ri.power equ    $2f +2  nos ^ tos, where tos is a signed short integer */
.equ ri.power,0x2f
/* QL: ri.powfp equ    $30 +6  nos ^ tos */
.equ ri.powfp,0x30
/* QL: ri.maxop equ    $30 */
.equ ri.maxop,0x30
/* QL: ri.load equ     $00     load operand key */
.equ ri.load,0x00
/* QL: ri.store equ    $01     store operand key (sets bit 0) */
.equ ri.store,0x01
/* QL: * for use after ri.k */
/* QL: ri.pi180 equ    $56 */
.equ ri.pi180,0x56
/* QL: ri.loge equ     $69 */
.equ ri.loge,0x69
/* QL: ri.pi6  equ     $79 */
.equ ri.pi6,0x79
/* QL: ri.ln2  equ     $88-$100 */
.equ ri.ln2,(0x88-0x100)
/* QL: ri.sqrt3 equ    $98-$100 */
.equ ri.sqrt3,(0x98-0x100)
/* QL: ri.pi   equ     $a8-$100 */
.equ ri.pi,(0xa8-0x100)
/* QL: ri.pi2  equ     $a7-$100 */
.equ ri.pi2,(0xa7-0x100)
/* QL:         list */
/* QL:         section ri_exec */
.section ri_exec,"ax"
/* QL: tab     macro */
/* QL: exec_tab */
exec_tab:
/* QL:  tab e     one   nint  zero  int   n     nlint k     ;00-07 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_124:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_135:
.word ((ri_one-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_146:
.word ((ri_nint-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_157:
.word ((ri_zero-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_168:
.word ((ri_int-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_179:
.word ((ri_n-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_190:
.word ((ri_nlint-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_201:
.word ((ri_k-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab float flong add   cmp   sub   halve mult  doubl ;08-0f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_215:
.word ((ri_float-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_226:
.word ((ri_flong-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_237:
.word ((ri_add-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_248:
.word ((ri_cmp-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_259:
.word ((ri_sub-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_270:
.word ((ri_halve-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_281:
.word ((ri_mult-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_292:
.word ((ri_doubl-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab div   recip abs   roll  neg   over  dup   swap  ;10-17 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_306:
.word ((ri_div-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_317:
.word ((ri_recip-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_328:
.word ((ri_abs-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_339:
.word ((ri_roll-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_350:
.word ((ri_neg-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_361:
.word ((ri_over-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_372:
.word ((ri_dup-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_383:
.word ((ri_swap-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab cos   e     sin   e     tan   e     cot   e     ;18-1f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_397:
.word ((ri_cos-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_407:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_418:
.word ((ri_sin-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_428:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_439:
.word ((ri_tan-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_449:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_460:
.word ((ri_cot-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_470:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab asin  e     acos  e     atan  arg   acot  mod   ;20-27 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_484:
.word ((ri_asin-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_494:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_505:
.word ((ri_acos-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_515:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_526:
.word ((ri_atan-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_537:
.word ((ri_arg-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_548:
.word ((ri_acot-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_559:
.word ((ri_mod-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab sqrt  squar ln    e     log10 e     exp   power ;28-2f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_573:
.word ((ri_sqrt-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_584:
.word ((ri_squar-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_595:
.word ((ri_ln-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_605:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_616:
.word ((ri_log10-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_626:
.word ((ri_e-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_637:
.word ((ri_exp-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_648:
.word ((ri_power-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab powfp                                           ;30 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-ri_e */
.balign 2,0
dc_anchor_662:
.word ((ri_powfp-ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: * abex and abexb used to clear d2 on error. They don't now, as gw is sensible. */
/* QL: * d0 -i o- instruction code / error code */
/* QL: * a1 -i o- arithmetic stack pointer */
/* QL: * a3 -ip - pointer to instructions */
/* QL: * a4 -ip - base (high address) of arithmetic load/save area */
/* QL: reglist reg d1-d3/a0/a2-a3/a5 */
/* QL: ri_abex */
ri_abex:
/* QL:         move.l  a6,-(sp)        absolute a1 and a4 entry for exec */
    move.l a6,-(sp)
/* QL:         sub.l   a6,a6 */
    sub.l a6,a6
/* QL:         bsr.s   ri_exec */
    bsr.s ri_exec
/* QL:         bra.s   rst_a6 */
    bra.s rst_a6
/* QL: ri_abexb */
ri_abexb:
/* QL:         move.l  a6,-(sp)        absolute a1 and a4 entry for execb */
    move.l a6,-(sp)
/* QL:         sub.l   a6,a6 */
    sub.l a6,a6
/* QL:         bsr.s   ri_execb */
    bsr.s ri_execb
/* QL: rst_a6 */
rst_a6:
/* QL:         move.l (sp)+,a6 */
    move.l (sp)+,a6
/* QL:         rts */
    rts 
/* QL: ri_exec */
ri_exec:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a0/a2-a3/a5,-(sp)
/* QL:         or.w    #-256,d0        make it how we like it */
    or.w #(-256),d0
/* QL:         lea     exec_tab,a5     no operations to follow */
    lea exec_tab(pc),a5
/* QL:         bra.s   exec_do */
    bra.s exec_do
/* QL: ri_execb */
ri_execb:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a0/a2-a3/a5,-(sp)
/* QL:         move.l  a3,a5           set internal pointer to ops */
    move.l a3,a5
/* QL:         bra.s   exec_nxt        enter loop */
    bra.s exec_nxt
/* QL: * Non-command odd d0, store a float in the a4 area */
/* QL: store */
store:
/* QL:         move.w  0(a6,a1.l),0(a6,a4.l) store a floating point number */
    move.w 0(a6,a1.l),0(a6,a4.l)
/* QL:         move.l  2(a6,a1.l),2(a6,a4.l) */
    move.l 2(a6,a1.l),2(a6,a4.l)
/* QL:         addq.l  #6,a1           remove operand */
    addq.l #6,a1
/* QL:         bra.s   rst_a4 */
    bra.s rst_a4
/* QL: not_op */
not_op:
/* QL:         bclr    #0,d0           test bit 0 of operand */
    bclr #0,d0
/* QL:         add.w   d0,a4           move to source / destination */
    add.w d0,a4
/* QL:         bne.s   store           choose load or store on bit zero d0 */
    bne.s store
/* QL: * Non-command even d0, load a float from the a4 area */
/* QL:         subq.l  #6,a1           make room for operand */
    subq.l #6,a1
/* QL:         move.w  0(a6,a4.l),0(a6,a1.l) load a floating point number */
    move.w 0(a6,a4.l),0(a6,a1.l)
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL: rst_a4 */
rst_a4:
/* QL:         sub.w   d0,a4           restore a4 to base address */
    sub.w d0,a4
/* QL: exec_nxt */
exec_nxt:
/* QL:         moveq   #-256+(255),d0  ready for anything! */
    moveq #((-256)+255),d0
/* QL:         move.b  (a5)+,d0        fetch next instruction byte */
    move.b (a5)+,d0
/* QL: exec_do */
exec_do:
/* QL:         cmp.b   #ri.maxop,d0    is it an operator? */
    cmp.b #(ri.maxop&255),d0
/* QL:         bhi.s   not_op          no, load or save */
    bhi.s not_op
/* QL:         add.b   d0,d0 */
    add.b d0,d0
/* QL:         move.w  exec_tab+256(pc,d0.w),d0 get offset from table */
    move.w (exec_tab+256)(pc,d0.w),d0
/* QL:         jsr     ri_e(pc,d0.w)   go do it */
    jsr ri_e(pc,d0.w)
/* QL:         beq.s   exec_nxt        loop if no problem detected */
    beq.s exec_nxt
/* QL:         bra.s   exit_b          otherwise, we're finished */
    bra.s exit_b
/* QL: ri_e */
ri_e:
/* QL:         addq.l  #4,sp           scrap return address */
    addq.l #4,sp
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: exit_b */
exit_b:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d3/a0/a2-a3/a5
/* QL:         rts */
    rts 
/* QL:         end */
