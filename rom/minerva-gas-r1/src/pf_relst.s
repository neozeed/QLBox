/* Generated from original/M/pf/relst.asm */
/* QL: * Relist part of a file during edit */
/* QL:         xref    bp_liste,bp_listf */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section pf_relst */
.section pf_relst,"ax"
/* QL: * This is merely a small dummy only to provide for the vector entry points, and */
/* QL: * is not used by the rest of the system at all. */
/* QL: * Note. The bp_liste vector was a pain, so changed it to pf_liste and moved the */
/* QL: * (apparently!) unused bp_lista and bp_lists code here. Cost: 1 word. */
/* QL:         moveq   #0,d4           old (unused?) bp_liste */
    moveq #0,d4
/* QL:         move.w  #$7fff,d6       old (unused?) bp_lists */
    move.w #0x7fff,d6
/* QL: pf_liste */
pf_liste:
/* QL:         jmp     bp_liste(pc)    go to the proper code */
    jmp bp_liste(pc)
/* QL:         jmp     bp_listf(pc)    arghhhh!!!! TK2's ed jumps in here! */
    jmp bp_listf(pc)
/* QL: * When TK2's ed comes in, a4 has already been made to point at the length */
/* QL: * change word of the line it wants listed into the basic buffer. */
/* QL: * d4 and d6 both contain that line's number. */
/* QL: * d7 and bv_print(a6) are both zero. */
/* QL: * By giving ourselves a new entry point to the bp routine, we can skip into the */
/* QL: * listing code at a more auspicious point, rather than messing about trying to */
/* QL: * set up things that are already established. */
/* QL:         vect4000 pf_liste */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl pf$liste
/* QL: [o]     equ     [h]-$4000 */
.equ pf$liste,(pf_liste-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
