/* Generated from original/M/mm/alloc.asm */
/* QL: * Allocate space in a heap */
/* QL:         xdef    mm_alloc,mm_alloi */
.globl mm_alloc,mm_alloi
/* QL:         xref    mm_scafr */
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
/* QL:         section mm_alloc */
.section mm_alloc,"ax"
/* QL: * Space is taken from the first adequate available space and if it is not an */
/* QL: * exact fit, the early part is used and the later is left as free. */
/* QL: * If all is well, the first longword of the allocated area will be set to its */
/* QL: * overall length, and the second longword will be set to zero. */
/* QL: * d0 -  o- error code (ccr set) */
/* QL: * d1 -i o- space required, rounded up to allocation multiple */
/* QL: * a0 -i o- pointer to pointer to free space / pointer to space allocated */
/* QL: * d2-d3/a1-a2 destroyed */
/* QL: mm_alloc */
mm_alloc:
/* QL:         moveq   #8-1,d2         allocation multiple */
    moveq #(8-1),d2
/* QL:         moveq   #8-1,d0         exit at first adequate space, scraps >= 8 */
    moveq #(8-1),d0
/* QL: * d0 -i    minimum size for left over bits of memory */
/* QL: *       o- error code (ccr set) */
/* QL: * d1 -i o- space required, rounded up to allocation multiple */
/* QL: * d2 -i  - allocation multiple less one. */
/* QL: * a0 -i o- pointer to pointer to free space / pointer to space allocated */
/* QL: * d3/a1-a2 destroyed */
/* QL: mm_alloi */
mm_alloi:
/* QL:         jsr     mm_scafr(pc)    scan for free space */
    jsr mm_scafr(pc)
/* QL:         beq.s   err_om          didn't find an adequate space */
    beq.s err_om
/* QL:         sub.l   d1,d3           find what's going spare */
    sub.l d1,d3
/* QL:         beq.s   re_link         exact fit is perfect */
    beq.s re_link
/* QL:         cmp.l   d0,d3           is what's left over big enough for us? */
    cmp.l d0,d3
/* QL:         bgt.s   split           yes, so we split it up */
    bgt.s split
/* QL:         add.l   d3,d1           not enough left over to make sense, so extend */
    add.l d3,d1
/* QL:         bra.s   re_link         go eat the whole thing */
    bra.s re_link
/* QL: split */
split:
/* QL:         add.l   d1,hp_next(a1)  move link */
    add.l d1,hp_next(a1)
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         add.l   d1,a1           find address of new free space */
    add.l d1,a1
/* QL:         move.l  d3,hp_len(a1)   record its new length */
    move.l d3,hp_len(a1)
/* QL: re_link */
re_link:
/* QL:         move.l  hp_next(a0),d2  find address of next free space */
    move.l hp_next(a0),d2
/* QL:         beq.s   set_next        is it last link? */
    beq.s set_next
/* QL:         add.l   a0,d2 */
    add.l a0,d2
/* QL:         sub.l   a1,d2           no - make it relative */
    sub.l a1,d2
/* QL: set_next */
set_next:
/* QL:         move.l  d2,hp_next(a1)  reform free chain to skip allocated block */
    move.l d2,hp_next(a1)
/* QL:         clr.l   hp_next(a0)     being friendly, clear second word now */
    clr.l hp_next(a0)
/* QL:         move.l  d1,hp_len(a0)   put length allocated */
    move.l d1,hp_len(a0)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: err_om */
err_om:
/* QL:         moveq   #err.om,d0      not enough space found */
    moveq #err.om,d0
/* QL:         rts */
    rts 
/* QL:         end */
