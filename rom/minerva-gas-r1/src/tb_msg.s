/* Generated from original/M/tb/msg.asm */
/* QL: * Default message tables */
/* QL:         xdef    tb_msg */
.globl tb_msg
/* QL: * This file holds all the error messages etc. which are language dependent. */
/* QL: * This is linked at the top of a ROM (in ROM based systems) to make language */
/* QL: * versions easier to implement. */
/* QL: msg     macro */
/* QL: lf      equ     10 */
.equ lf,10
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL: tb_msg */
tb_msg:
/* QL:         dc.w    $4afb */
.balign 2,0
dc_anchor_15:
.word 0x4afb
/* QL:         msg     {'not complete'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_20:
.word ((x1-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x1:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_29:
.word (((y1-dc_anchor_29)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_36:
.byte 110,111,116,32,99,111,109,112,108,101,116,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_42:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y1:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'invalid job'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_54:
.word ((x2-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x2:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_63:
.word (((y2-dc_anchor_63)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_70:
.byte 105,110,118,97,108,105,100,32,106,111,98
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_76:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y2:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'out of memory'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_88:
.word ((x3-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x3:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_97:
.word (((y3-dc_anchor_97)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_104:
.byte 111,117,116,32,111,102,32,109,101,109,111,114,121
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_110:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y3:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'out of range'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_122:
.word ((x4-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x4:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_131:
.word (((y4-dc_anchor_131)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_138:
.byte 111,117,116,32,111,102,32,114,97,110,103,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_144:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y4:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'buffer full'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_156:
.word ((x5-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x5:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_165:
.word (((y5-dc_anchor_165)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_172:
.byte 98,117,102,102,101,114,32,102,117,108,108
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_178:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y5:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'channel not open'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_190:
.word ((x6-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x6:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_199:
.word (((y6-dc_anchor_199)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_206:
.byte 99,104,97,110,110,101,108,32,110,111,116,32,111,112,101,110
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_212:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y6:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'not found'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_224:
.word ((x7-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x7:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_233:
.word (((y7-dc_anchor_233)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_240:
.byte 110,111,116,32,102,111,117,110,100
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_246:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y7:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'already exists'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_258:
.word ((x8-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x8:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_267:
.word (((y8-dc_anchor_267)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_274:
.byte 97,108,114,101,97,100,121,32,101,120,105,115,116,115
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_280:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y8:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'in use'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_292:
.word ((x9-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x9:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_301:
.word (((y9-dc_anchor_301)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_308:
.byte 105,110,32,117,115,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_314:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y9:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'end of file'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_326:
.word ((x10-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x10:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_335:
.word (((y10-dc_anchor_335)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_342:
.byte 101,110,100,32,111,102,32,102,105,108,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_348:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y10:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'drive full'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_360:
.word ((x11-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x11:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_369:
.word (((y11-dc_anchor_369)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_376:
.byte 100,114,105,118,101,32,102,117,108,108
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_382:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y11:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'bad name'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_394:
.word ((x12-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x12:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_403:
.word (((y12-dc_anchor_403)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_410:
.byte 98,97,100,32,110,97,109,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_416:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y12:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'Xmit error'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_428:
.word ((x13-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x13:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_437:
.word (((y13-dc_anchor_437)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_444:
.byte 88,109,105,116,32,101,114,114,111,114
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_450:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y13:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'format failed'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_462:
.word ((x14-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x14:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_471:
.word (((y14-dc_anchor_471)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_478:
.byte 102,111,114,109,97,116,32,102,97,105,108,101,100
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_484:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y14:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'bad parameter'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_496:
.word ((x15-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x15:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_505:
.word (((y15-dc_anchor_505)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_512:
.byte 98,97,100,32,112,97,114,97,109,101,116,101,114
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_518:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y15:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'bad or changed medium'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_530:
.word ((x16-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x16:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_539:
.word (((y16-dc_anchor_539)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_546:
.byte 98,97,100,32,111,114,32,99,104,97,110,103,101,100,32,109,101,100,105,117,109
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_552:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y16:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'error in expression'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_564:
.word ((x17-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x17:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_573:
.word (((y17-dc_anchor_573)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_580:
.byte 101,114,114,111,114,32,105,110,32,101,120,112,114,101,115,115,105,111,110
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_586:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y17:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'overflow'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_598:
.word ((x18-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x18:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_607:
.word (((y18-dc_anchor_607)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_614:
.byte 111,118,101,114,102,108,111,119
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_620:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y18:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'not implemented yet'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_632:
.word ((x19-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x19:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_641:
.word (((y19-dc_anchor_641)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_648:
.byte 110,111,116,32,105,109,112,108,101,109,101,110,116,101,100,32,121,101,116
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_654:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y19:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'read only'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_666:
.word ((x20-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x20:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_675:
.word (((y20-dc_anchor_675)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_682:
.byte 114,101,97,100,32,111,110,108,121
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_688:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y20:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'bad line'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_700:
.word ((x21-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x21:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_709:
.word (((y21-dc_anchor_709)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_716:
.byte 98,97,100,32,108,105,110,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_722:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y21:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'At line '} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_734:
.word ((x22-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x22:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_743:
.word (((y22-dc_anchor_743)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_750:
.byte 65,116,32,108,105,110,101,32
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y22:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {' sectors'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_762:
.word ((x23-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x23:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_771:
.word (((y23-dc_anchor_771)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_778:
.byte 32,115,101,99,116,111,114,115
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_784:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y23:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {' F1/F2 sets monitor/TV'},lf  {' F3/F4 for dual screen'},lf  {' 128K+SHIFT  dumb+CTRL'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_796:
.word ((x24-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x24:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_805:
.word (((y24-dc_anchor_805)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_812:
.byte 32,70,49,47,70,50,32,115,101,116,115,32,109,111,110,105,116,111,114,47,84,86
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_818:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_824:
.byte 32,70,51,47,70,52,32,102,111,114,32,100,117,97,108,32,115,99,114,101,101,110
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_830:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_836:
.byte 32,49,50,56,75,43,83,72,73,70,84,32,32,100,117,109,98,43,67,84,82,76
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y24:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'  The QView Mega Corporation!'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_848:
.word ((x25-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x25:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_857:
.word (((y25-dc_anchor_857)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_864:
.byte 32,127,32,84,104,101,32,81,86,105,101,119,32,77,101,103,97,32,67,111,114,112,111,114,97,116,105,111,110,33
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y25:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'during WHEN processing'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_876:
.word ((x26-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x26:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_885:
.word (((y26-dc_anchor_885)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_892:
.byte 100,117,114,105,110,103,32,87,72,69,78,32,112,114,111,99,101,115,115,105,110,103
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_898:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y26:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg     {'PROC/FN cleared'},lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_910:
.word ((x27-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x27:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
dc_anchor_919:
.word (((y27-dc_anchor_919)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_926:
.byte 80,82,79,67,47,70,78,32,99,108,101,97,114,101,100
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_932:
.byte (lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y27:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg.b   {'SunMonTueWedThuFriSat'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_944:
.word ((x28-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x28:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_956:
.byte 83,117,110,77,111,110,84,117,101,87,101,100,84,104,117,70,114,105,83,97,116
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y28:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         msg.b   {'JanFebMarAprMayJunJulAugSepOctNovDec'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
dc_anchor_968:
.word ((x29-tb_msg))&65535
/* QL:         section tb_txt */
.section tb_txt,"ax"
/* QL: x[.l] */
x29:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
dc_anchor_980:
.byte 74,97,110,70,101,98,77,97,114,65,112,114,77,97,121,74,117,110,74,117,108,65,117,103,83,101,112,79,99,116,78,111,118,68,101,99
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
y29:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
.section tb_msg,"ax"
/* QL:         end */
