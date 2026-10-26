/* Generated from original/M/io/queue.asm */
/* QL: * Set/test/in/out/eof queues */
/* QL:         xdef    io_qset,io_qsetl,io_qtest,io_qin,io_qout,io_qeof */
.globl io_qset,io_qsetl,io_qtest,io_qin,io_qout,io_qeof
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
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
/* QL:         include 'win1_m_inc_q' */
/* QL: * io queue header definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: q_eoff ; end of file flag (msbit) */
.equ q_eoff,0
/* QL: q_nextq ds.l    1       link to next queue */
.equ q_nextq,0
/* QL: q_end   ds.l    1       pointer to end of queue */
.equ q_end,4
/* QL: q_nextin ds.l   1       pointer to next location to put byte in */
.equ q_nextin,8
/* QL: q_nxtout ds.l   1       pointer to next location to take byte from */
.equ q_nxtout,12
/* QL: q_queue ; start of queue */
.equ q_queue,16
/* QL:         list */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         assert  0,q_eoff,q_nextq,q_end-4,q_nextin-8,q_nxtout-12,q_queue-16 */
/* original assertion: 0,q_eoff,q_nextq,q_end-4,q_nextin-8,q_nxtout-12,q_queue-16 */
/* QL:         section io_queue */
.section io_queue,"ax"
/* QL: * As a general idea, the code here tries to work efficiently when data is being */
/* QL: * accessed in a queue that is partially full. I.e. it should cope with high */
/* QL: * volume traffic of qin/qout calls as its forte. */
/* QL: * Set up a queue */
/* QL: * d1 -ip - length of queue (max. bytes in queue + 1, d1.w = 1..32767, we hope!) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qset */
io_qset:
/* QL:         move.l  d1,-(sp) */
    move.l d1,-(sp)
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         bsr.s   io_qsetl */
    bsr.s io_qsetl
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         rts */
    rts 
/* QL: * As above, but d1.l is used to set long queues! */
/* QL: io_qsetl */
io_qsetl:
/* QL:         lea     q_queue(a2,d1.l),a3 set pointer to end of queue */
    lea q_queue(a2,d1.l),a3
/* QL:         clr.l   (a2)+           clear eoff and nextq */
    clr.l (a2)+
/* QL:         move.l  a3,(a2)+        set end */
    move.l a3,(a2)+
/* QL:         sub.l   d1,a3           start the queue in an arbitrary place = bottom */
    sub.l d1,a3
/* QL:         move.l  a3,(a2)         set nextin */
    move.l a3,(a2)
/* QL:         move.l  a3,-(a3)        and nxtout */
    move.l a3,-(a3)
/* QL:         subq.w  #q_nextin,a2    restore queue pointer */
    subq.w #q_nextin,a2
/* QL:         rts */
    rts 
/* QL: * Test status of a queue */
/* QL: * d0 -  o- error flag - 0, queue empty (nc) or eof */
/* QL: * d1 -  o- next byte in queue (all but d1.b preserved) */
/* QL: * d2 -  o- spare space in queue (bits 31..15 always zero) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qtest */
io_qtest:
/* QL:         movem.l q_nextin(a2),d2/a3 get pointer to next bytes in/out */
    movem.l q_nextin(a2),d2/a3
/* QL:         move.b  (a3),d1         show caller next byte */
    move.b (a3),d1
/* QL:         sub.l   a3,d2           set difference between in and out */
    sub.l a3,d2
/* QL:         blt.s   set_spar        negative: wrapped, so just complement this */
    blt.s set_spar
/* QL:         bgt.s   set_wrap        positive: must take off the wrap length */
    bgt.s set_wrap
/* QL:         bsr.s   set_wrap        zero: queue empty, but we must still set space */
    bsr.s set_wrap
/* QL: say_why */
say_why:
/* QL:         moveq   #err.ef,d0      end of file */
    moveq #err.ef,d0
/* QL:         tst.b   (a2)            is it eof? */
    tst.b (a2)
/* QL:         bmi.s   rts0            yep - ccr is ok for that */
    bmi.s rts0
/* QL: err_nc */
err_nc:
/* QL:         moveq   #err.nc,d0      not complete */
    moveq #err.nc,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: set_wrap */
set_wrap:
/* QL:         moveq   #-q_queue,d0 */
    moveq #(-q_queue),d0
/* QL:         sub.l   a2,d0 */
    sub.l a2,d0
/* QL:         add.l   q_end(a2),d0    this is the overall queue area */
    add.l q_end(a2),d0
/* QL:         sub.l   d0,d2           so this'll be the free space, when complemented */
    sub.l d0,d2
/* QL: set_spar */
set_spar:
/* QL:         not.l   d2              zero will mean no spare space in queue */
    not.l d2
/* QL:         move.w  #32767,a3       we must return a positive word */
    move.w #32767,a3
/* QL:         cmp.l   a3,d2 */
    cmp.l a3,d2
/* QL:         bls.s   say_ok */
    bls.s say_ok
/* QL:         move.l  a3,d2           if the queue is oversize, return a max value */
    move.l a3,d2
/* QL: say_ok */
say_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Put bytes into a queue */
/* QL: * d0 -  o- error flag - queue full */
/* QL: * d1 -ip - byte to put in queue (discarded with no error if eof set) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qin */
io_qin:
/* QL:         tst.b   (a2)            is it eof? (eoff) */
    tst.b (a2)
/* QL:         bmi.s   say_ok          ... yes - throw it away (!!!) */
    bmi.s say_ok
/* QL:         move.l  q_nextin(a2),a3 get pointer to end of queue */
    move.l q_nextin(a2),a3
/* QL:         move.b  d1,(a3)+        put byte regardless (there's alway a gap) */
    move.b d1,(a3)+
/* QL:         cmp.l   q_end(a2),a3    is next pointer off end of queue */
    cmp.l q_end(a2),a3
/* QL:         blt.s   chk_next */
    blt.s chk_next
/* QL:         lea     q_queue(a2),a3  next is start of queue */
    lea q_queue(a2),a3
/* QL: chk_next */
chk_next:
/* QL:         cmp.l   q_nxtout(a2),a3 is queue full */
    cmp.l q_nxtout(a2),a3
/* QL:         beq.s   err_nc */
    beq.s err_nc
/* QL:         move.l  a3,q_nextin(a2) save pointer to next in queue */
    move.l a3,q_nextin(a2)
/* QL:         bra.s   say_ok */
    bra.s say_ok
/* QL: * Fetch bytes out of a queue */
/* QL: * d0 -  o- error flag - queue empty, and possibly at eof */
/* QL: * d1 -  o- byte from queue */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qout */
io_qout:
/* QL:         move.l  q_nxtout(a2),a3 get pointer to next byte */
    move.l q_nxtout(a2),a3
/* QL:         cmp.l   q_nextin(a2),a3 is there anything in queue */
    cmp.l q_nextin(a2),a3
/* QL:         beq.s   say_why         no - go tell caller nc/eof */
    beq.s say_why
/* QL:         move.b  (a3)+,d1        fetch byte */
    move.b (a3)+,d1
/* QL:         cmp.l   q_end(a2),a3    is next pointer off end of queue */
    cmp.l q_end(a2),a3
/* QL:         blt.s   save_out */
    blt.s save_out
/* QL:         lea     q_queue(a2),a3  next is start of queue */
    lea q_queue(a2),a3
/* QL: save_out */
save_out:
/* QL:         move.l  a3,q_nxtout(a2) save pointer to next in queue */
    move.l a3,q_nxtout(a2)
/* QL:         bra.s   say_ok */
    bra.s say_ok
/* QL: * Set end of file on a queue */
/* QL: * a2 -ip - pointer to queue */
/* QL: io_qeof */
io_qeof:
/* QL:         tas     (a2)            flag in msbit (eoff) */
    tas (a2)
/* QL:         rts */
    rts 
/* QL:         vect4000 io_qsetl */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl io$qsetl
/* QL: [o]     equ     [h]-$4000 */
.equ io$qsetl,(io_qsetl-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
