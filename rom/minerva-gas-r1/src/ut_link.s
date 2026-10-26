/* Generated from original/M/ut/link.asm */
/* QL: * Add/remove item in linked list */
/* QL:         xdef   ut_link,ut_unlnk */
.globl ut_link,ut_unlnk
/* QL:         section ut_link */
.section ut_link,"ax"
/* QL: * a0 cr  pointer to item to be added or removed */
/* QL: * a1 cr  pointer to start of linked list / pointer to previous item */
/* QL: ut_link */
ut_link:
/* QL:         move.l  (a1),(a0)       put pointer to next in this item */
    move.l (a1),(a0)
/* QL:         move.l  a0,(a1)         and link it in */
    move.l a0,(a1)
/* QL:         rts */
    rts 
/* QL: nxt_link */
nxt_link:
/* QL:         move.l  (a1),a1         get next link */
    move.l (a1),a1
/* QL: ut_unlnk */
ut_unlnk:
/* QL:         tst.l   (a1) */
    tst.l (a1)
/* QL:         beq.s   end_unlk        give up at end of list */
    beq.s end_unlk
/* QL:         cmp.l   (a1),a0 */
    cmp.l (a1),a0
/* QL:         bne.s   nxt_link        loop until we find pointer to item */
    bne.s nxt_link
/* QL:         move.l  (a0),(a1)       move link pointer back in list */
    move.l (a0),(a1)
/* QL: end_unlk */
end_unlk:
/* QL:         rts */
    rts 
/* QL:         end */
