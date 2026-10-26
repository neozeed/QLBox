/* Generated from original/M/mm/lnkfr.asm */
/* QL: * Link in a free space */
/* QL:         xdef    mm_lnkf0,mm_lnkfr */
.globl mm_lnkf0,mm_lnkfr
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
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: * The free list is scanned to locate any immediately neighbours of the newly */
/* QL: * supplied space, and if possible, coalesce them with it. */
/* QL: * The returned values are used to decide on reducing the chp/trn areas. */
/* QL: * N.B. Due to a misinterpretation of how heaps should be managed, this was */
/* QL: * wandering down the free chain after the newly linked in block. Wrong! */
/* QL: * The whole point of the heap is to allow the linking in of additional space */
/* QL: * from outside of the original area. */
/* QL: * There is a flaw present in this, should the system heaps be so extended. */
/* QL: * how do we scan a heap? */
/* QL: * Job removal must do a scan of chp to de-allocate blocks owned by dying jobs. */
/* QL: * An idea: require such space to be set up specially, then introduced as a */
/* QL: * small piece which is up the top end, but length zero, so it will never be */
/* QL: * allocated, and finally free up the bulk of the area. */
/* QL: * We will prefer this latter area to have a size of the appropriate multiple, */
/* QL: * otherwise any odd bit will keep hanging about on the free list uselessly. */
/* QL: * E.g. for an extra area built in "len+10" bytes at address "addr": */
/* QL: * 1) set addr:len,0,0 and addr+len:-len */
/* QL: * 2) free zero bytes at addr+len+2 (if sysmon objects, we may need to alter) */
/* QL: * 3) free len bytes at addr */
/* QL: * The presence of zero length free areas on the free chain can be easily */
/* QL: * incorporated in the scan routine for the heap. The negative length preceeding */
/* QL: * such a free area is used to get to the base of the area, and also as a stop */
/* QL: * to recognise the end of the area. Note that the little free trailer will */
/* QL: * never be coalesced. Also note that we need the main area preset to look like */
/* QL: * it is in use and owned by job zero, as it must already be valid for a scan, */
/* QL: * should one occur between the two calls freeing the spaces. */
/* QL: * This still needs one more comment: we can now get a scenario where the base */
/* QL: * link for the free chain is not zero, but the area has top matching bottom. */
/* QL: * this will be important in the case of respr, when we will be able to have */
/* QL: * jobs running in the extra areas, but the trn itself will have its top and */
/* QL: * bottom matching, to show it as empty. */
/* QL: * One final thought... the trn area will work nicely as it is, but the chp does */
/* QL: * first fit, so extend that a.s.a.p... slaving will like it! */
/* QL:         section mm_lnkfr */
.section mm_lnkfr,"ax"
/* QL: * d1 -i o- length of new free space / length of final free space */
/* QL: * d2 -  o- offset stored in final free space, zero if end of free chain */
/* QL: * a0 -i o- address of new free space / offset a1-a2 at end */
/* QL: * a1 -i o- pointer to link / pointer to resultant free space */
/* QL: * a2 -  o- pointer to preceeding free space */
/* QL: mm_lnkf0 */
mm_lnkf0:
/* QL:         clr.l   hp_owner(a0)    for system heaps mark the owner 0 */
    clr.l hp_owner(a0)
/* QL: * Should we do something with the rflag as well? */
/* QL: * E.g. setting the top bit of rflag and using the rest for something nice! */
/* QL: mm_lnkfr */
mm_lnkfr:
/* QL:         subq.l  #hp_next,a1     fiddle the call pointer */
    subq.l #hp_next,a1
/* QL: * Loop through free space link pointers and link in new block */
/* QL: * a2 points to previous block, a1 to current block */
/* QL:         move.l  d3,-(sp)        we will preserve d3 here, to be friendly */
    move.l d3,-(sp)
/* QL:         sub.l   a2,a2           no previous pointer */
    sub.l a2,a2
/* QL: fr_loop */
fr_loop:
/* QL:         move.l  a2,d3           remember previous pointer */
    move.l a2,d3
/* QL:         move.l  a1,a2           get next link pointer */
    move.l a1,a2
/* QL:         move.l  hp_next(a1),d2 */
    move.l hp_next(a1),d2
/* QL:         beq.s   prelink         is it last link? */
    beq.s prelink
/* QL:         add.l   d2,a1           no - set address of next */
    add.l d2,a1
/* QL:         cmp.l   a0,a1           check if pointer past new space */
    cmp.l a0,a1
/* QL:         ble.s   fr_loop */
    ble.s fr_loop
/* QL: * < 2nd prior > ... < prior free > ... < new freed > ... < next free > ... */
/* QL: * d3:??/??          a2:??/d2           a0:??/??          a1:??/?? */
/* QL:         move.l  a1,d2 */
    move.l a1,d2
/* QL:         sub.l   a0,d2           make intended forward relative link to next */
    sub.l a0,d2
/* QL:         cmp.l   d1,d2           does next coalesce with the new block? */
    cmp.l d1,d2
/* QL:         bne.s   prelink */
    bne.s prelink
/* QL:         assert  0,hp_len,hp_next-4 */
/* original assertion: 0,hp_len,hp_next-4 */
/* QL:         add.l   (a1)+,d1        yes - extend length of freed block */
    add.l (a1)+,d1
/* QL:         add.l   (a1),d2         add relative offset to what we have so far */
    add.l (a1),d2
/* QL: * < 2nd prior > ... < prior free > ... < new freed > ... */
/* QL: * d3:??/??          a2:??/??           a0:??/??, d1=length, d2=offset to next */
/* QL: prelink */
prelink:
/* QL:         tst.l   d3              is there in fact a 2nd prior? */
    tst.l d3
/* QL:         beq.s   linkit          no - we were right at the start, so skip this */
    beq.s linkit
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         sub.l   a2,a1 */
    sub.l a2,a1
/* QL:         cmp.l   (a2),a1         does prior join up with free block? */
    cmp.l (a2),a1
/* QL:         bne.s   linkit */
    bne.s linkit
/* QL:         move.l  a2,a0           yes - let's shuffle ourselves down there */
    move.l a2,a0
/* QL:         move.l  d3,a2           move up 2nd prior to prior now */
    move.l d3,a2
/* QL:         add.l   a1,d1           increase length */
    add.l a1,d1
/* QL:         add.l   a1,d2           increase relative offset */
    add.l a1,d2
/* QL: * < prior free > ... < new freed > ... */
/* QL: * a2:??/??           a0:??/??, d1=length, d2=offset to next */
/* QL: linkit */
linkit:
/* QL:         move.l  (sp)+,d3        finished with d3 now */
    move.l (sp)+,d3
/* QL:         cmp.l   d1,d2           in all the machinations, is this the last free? */
    cmp.l d1,d2
/* QL:         bgt.s   setlnk          no, as the offset is beyond this block */
    bgt.s setlnk
/* QL: * Note: we don't need to check anything more complex than this. The value of d2 */
/* QL: * we get here with may indeed be an offset to a free block that we have */
/* QL: * coalesced, but that'll be fine. */
/* QL:         moveq   #0,d2           yes! make the offset a proper zero */
    moveq #0,d2
/* QL: setlnk */
setlnk:
/* QL:         movem.l d1-d2,(a0)      set new area's length and relative link */
    movem.l d1-d2,(a0)
/* QL:         move.l  a0,a1           want to return it in a1, for some reason... */
    move.l a0,a1
/* QL:         sub.l   a2,a0 */
    sub.l a2,a0
/* QL:         move.l  a0,hp_next(a2)  set prior free's link to the new free area */
    move.l a0,hp_next(a2)
/* QL: * Note: setting that one last ensures that the free chain has never been */
/* QL: * in a corrupt state during any of the proceedings. Also, the "movem" ensures */
/* QL: * similarly valid handling when we have coalesced with a preceeding space. In */
/* QL: * this particular case, the final move of a0 is actually redundant! */
/* QL: * < prior free > ... < new freed > ... */
/* QL: * a2:??/a0           a1:d1/d2 */
/* QL:         rts */
    rts 
/* QL:         end */
