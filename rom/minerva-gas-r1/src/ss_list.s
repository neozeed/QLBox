/* Generated from original/M/ss/list.asm */
/* QL: * A table to help set up ram copies of all the linkage data. */
/* QL:         xdef    ss_list */
.globl ss_list
/* QL:         xref    ss_ext */
/* QL:         xref    ip_poll,ip_sched */
/* QL:         xref    sd_sched */
/* QL:         xref    io_sched */
/* QL:         xref    od_ser,od_pipe,od_con,od_net */
/* QL:         xref    dd_mdv */
/* QL: * It is read from the top, backwards, with a one terminating the list. */
/* QL: * All the address offset entries will be even. */
/* QL: * We use odd values to mark starting off of new bits of tables. */
/* QL: * A zero in the high byte is the end of the list. */
/* QL: * The lsb is one less than twice the number of words needing reloaction. */
/* QL: * An even msb and a one in the lsb means a single address, and this is used to */
/* QL: * set up the poll and scheduler lists. */
/* QL: * Otherwise, the address will point to the top of another table. */
/* QL: * If in this case the msb is even, 6 bytes are left zero and words are copied */
/* QL: * until a zero is reached. this is used for the dd and sx bits. */
/* QL: * The specified count of words are then relocated, allowing a special case of */
/* QL: * zero to generate a true zero. */
/* QL: * Each set is built with link words and the final such is pushed to the stack. */
/* QL: * a total of five linkage base words are stacked. */
/* QL: * This is all very custom stuff, and not ammenable to messing about with! */
/* QL: * the structures finish up built at base = sv_chtop(a6). */
/* QL:         section ss_list */
.section ss_list,"ax"
/* QL:         dc.b    0,1             address       will be set up with */
dc_anchor_28:
.byte (0)&255
.byte (1)&255
/* QL:         dc.w    ss_ext+24*2-*   base+$00: 00000000 + 11 addresses + 13 words */
.balign 2,0
dc_anchor_33:
.word (((ss_ext+(24*2))-dc_anchor_33))&65535
/* QL:         dc.b    2,11*2-1 */
dc_anchor_36:
.byte (2)&255
.byte (((11*2)-1))&255
/* QL:         dc.w    ip_poll-*       base+$50: 00000000 ip_poll */
.balign 2,0
dc_anchor_41:
.word ((ip_poll-dc_anchor_41))&65535
/* QL:         dc.b    2,1 */
dc_anchor_44:
.byte (2)&255
.byte (1)&255
/* QL:         dc.w    sd_sched-*                                  base+$60 sd_sched */
.balign 2,0
dc_anchor_49:
.word ((sd_sched-dc_anchor_49))&65535
/* QL:         dc.w    ip_sched-*      base+$60: base+$68 ip_sched */
.balign 2,0
dc_anchor_53:
.word ((ip_sched-dc_anchor_53))&65535
/* QL:         dc.w    io_sched-*                                  00000000 io_scan */
.balign 2,0
dc_anchor_57:
.word ((io_sched-dc_anchor_57))&65535
/* QL:         dc.b    2,1 */
dc_anchor_60:
.byte (2)&255
.byte (1)&255
/* QL:         dc.w    od_ser+3*2-*    base+$70: base+$80 od_serio od_serop od_sercl */
.balign 2,0
dc_anchor_65:
.word (((od_ser+(3*2))-dc_anchor_65))&65535
/* QL:         dc.w    od_pipe+3*2-*   base+$80: base+$90 io_serq  od_pipop od_pipcl */
.balign 2,0
dc_anchor_69:
.word (((od_pipe+(3*2))-dc_anchor_69))&65535
/* QL:         dc.w    od_con+3*2-*    base+$90: base+$a0 od_conio od_conop od_concl */
.balign 2,0
dc_anchor_73:
.word (((od_con+(3*2))-dc_anchor_73))&65535
/* QL:         dc.w    od_net+3*2-*    base+$a0: 00000000 od_netio od_netop od_netcl */
.balign 2,0
dc_anchor_77:
.word (((od_net+(3*2))-dc_anchor_77))&65535
/* QL:         dc.b    1,3*2-1 */
dc_anchor_80:
.byte (1)&255
.byte (((3*2)-1))&255
/* QL:         dc.w    dd_mdv+12*2-*   base+$b0: 00000000 dd_mdvio dd_mdvop dd_mdvcl */
.balign 2,0
dc_anchor_85:
.word (((dd_mdv+(12*2))-dc_anchor_85))&65535
/* QL: *                               base+$c0: md_slave 00000000 00000000 md_formt */
/* QL: *                               base+$d0: 0 md_end 0 3 m d  v 0 0000 00000000 */
/* QL: *                               base+$e0: end of system extension */
/* QL: ss_list */
ss_list:
/* QL:         end */
