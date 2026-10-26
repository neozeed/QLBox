/* Generated from original/M/pa/table.asm */
/* QL: * Absolute pointers to graph table and keyword table - nasty things! */
/* QL:         xdef    pa_table */
.globl pa_table
/* QL:         xref.l  pa_grtab,pa_kytab */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section pa_table */
.section pa_table,"ax"
/* QL: pa_table dc.l   pa_kytab,pa_grtab */
.balign 2,0
pa_table:
dc_anchor_14:
.long pa_kytab
.long pa_grtab
/* QL:         vect4000 pa_table */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl pa$table
/* QL: [o]     equ     [h]-$4000 */
.equ pa$table,(pa_table-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
