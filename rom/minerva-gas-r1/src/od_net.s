/* Generated from original/M/od/net.asm */
/* QL: * Network driver */
/* QL:         xdef    od_net */
.globl od_net
/* QL:         xref    io_name,io_relio */
/* QL:         xref    mm_alchp,mm_rechp */
/* QL:         xref    nd_rpac,nd_spac */
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
/* QL:         include 'win1_m_inc_net' */
/* QL: * net data block definition */
/* QL:         nolist */
/* QL:         offset  $18 (end of basic channel definition) */
/* QL: net_hedr ; network packet header */
.equ net_hedr,24
/* QL: net_dest ds.b   1       destination station number */
.equ net_dest,24
/* QL: net_self ds.b   1       own station number */
.equ net_self,25
/* QL: net_blkl ds.b   1       data block number (low byte) */
.equ net_blkl,26
/* QL: net_blkh ds.b   1       data block number (high byte) */
.equ net_blkh,27
/* QL: net_type ds.b   1       send blocks: 0=not eof 1=eof */
.equ net_type,28
/* QL: net_nbyt ds.b   1       number of bytes sent or received */
.equ net_nbyt,29
/* QL: net_dchk ds.b   1       data checksum */
.equ net_dchk,30
/* QL: net_hchk ds.b   1       header checksum */
.equ net_hchk,31
/* QL: net_data ds.b   255     data block */
.equ net_data,32
/* QL: net_rpnt ds.b   1       running pointer to data block */
.equ net_rpnt,287
/* QL: net_end ; length of data definition block */
.equ net_end,288
/* QL:         list */
/* QL:         include 'win1_m_inc_sv' */
/* QL: * system variable definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sv_ident ds.w   1       identification word */
.equ sv_ident,0
/* QL:         ds.w    1       spare */
/* QL: sv_cheap ds.l   1       base of common heap area */
.equ sv_cheap,4
/* QL: sv_chpfr ds.l   1       first free space in common heap area */
.equ sv_chpfr,8
/* QL: sv_free ds.l    1       base of free area */
.equ sv_free,12
/* QL: sv_basic ds.l   1       base of basic area */
.equ sv_basic,16
/* QL: sv_trnsp ds.l   1       base of transient program area */
.equ sv_trnsp,20
/* QL: sv_trnfr ds.l   1       first free space in transient program area */
.equ sv_trnfr,24
/* QL: sv_respr ds.l   1       base of resident procedure area */
.equ sv_respr,28
/* QL: sv_ramt ds.l    1       top of ram (+1) */
.equ sv_ramt,32
/* QL:         ds.w    5       spare */
/* QL: sv_rand ds.w    1       random number */
.equ sv_rand,46
/* QL: sv_pollm ds.w   1       count of poll interupts missed */
.equ sv_pollm,48
/* QL: sv_tvmod ds.b   1       0 if not tv display */
.equ sv_tvmod,50
/* QL: sv_scrst ds.b   1       screen status (0 = active) */
.equ sv_scrst,51
/* QL: sv_mcsta ds.b   1       display mode of current job 0/8 mode4/mode8 */
.equ sv_mcsta,52
/* QL: sv_pcint ds.b   1       current value of pc interrupt register */
.equ sv_pcint,53
/* QL:         ds.b    1       spare */
/* QL: sv_netnr ds.b   1       network station number */
.equ sv_netnr,55
/* QL: sv_i2lst ds.l   1       pointer to list of interrupt 2 drivers */
.equ sv_i2lst,56
/* QL: sv_plist ds.l   1       pointer to list of polled tasks */
.equ sv_plist,60
/* QL: sv_shlst ds.l   1       pointer to list of scheduler tasks */
.equ sv_shlst,64
/* QL: sv_drlst ds.l   1       pointer to list of device drivers */
.equ sv_drlst,68
/* QL: sv_ddlst ds.l   1       pointer to list of directory device drivers */
.equ sv_ddlst,72
/* QL: sv_keyq ds.l    1       pointer to a keyboard queue */
.equ sv_keyq,76
/* QL: sv_trapv ds.l   1       pointer to the trap redirection table */
.equ sv_trapv,80
/* QL: * Pointers to the resource management tables */
/* QL: * The slave block tables have 8 byte entries, the others 4 byte entries */
/* QL: sv_btpnt ds.l   1       pointer to most recent slave block entry */
.equ sv_btpnt,84
/* QL: sv_btbas ds.l   1       pointer to base of slave block table */
.equ sv_btbas,88
/* QL: sv_bttop ds.l   1       pointer to top of slave block table */
.equ sv_bttop,92
/* QL: sv_jbtag ds.w   1       current value of job tag */
.equ sv_jbtag,96
/* QL: sv_jbmax ds.w   1       highest current job number */
.equ sv_jbmax,98
/* QL: sv_jbpnt ds.l   1       pointer to current job table entry */
.equ sv_jbpnt,100
/* QL: sv_jbbas ds.l   1       pointer to base of job table */
.equ sv_jbbas,104
/* QL: sv_jbtop ds.l   1       pointer to top of job table */
.equ sv_jbtop,108
/* QL: sv_chtag ds.w   1       current value of channel tag */
.equ sv_chtag,112
/* QL: sv_chmax ds.w   1       highest current channel number */
.equ sv_chmax,114
/* QL: sv_chpnt ds.l   1       pointer to last channel checked */
.equ sv_chpnt,116
/* QL: sv_chbas ds.l   1       pointer to base of channel table */
.equ sv_chbas,120
/* QL: sv_chtop ds.l   1       pointer to top of channel table, and extended sysvars */
.equ sv_chtop,124
/* QL: sv_frbl ds.l    1       interrupt level release memory linked list (sms2) */
.equ sv_frbl,128
/* QL:         ds.b    1       spare */
/* QL:         ds.b    1       set to $ff by ptrgen if this is a ql! */
/* QL:         ds.w    1       spare */
/* QL: sv_caps ds.b    1       caps lock 0=off $ff=on */
.equ sv_caps,136
/* QL:         ds.b    1       but people may overwrite as above was defined as w! */
/* QL: sv_arbuf ds.w   1       autorepeat buffer */
.equ sv_arbuf,138
/* QL: sv_ardel ds.w   1       autorepeat delay */
.equ sv_ardel,140
/* QL: sv_arfrq ds.w   1       autorepeat 1/freq */
.equ sv_arfrq,142
/* QL: sv_arcnt ds.w   1       autorepeat count */
.equ sv_arcnt,144
/* QL: sv_cqch ds.w    1       keyboard change queue character code (can be + alt!) */
.equ sv_cqch,146
/* QL: sv_wp   ds.w    1       microdrive write protect (1st byte) ipc p26 input */
.equ sv_wp,148
/* QL: sv_sound ds.w   1       sound status (only 1st byte used?) */
.equ sv_sound,150
/* QL: sv_ser1c ds.l   1       receive  channel 1 queue address */
.equ sv_ser1c,152
/* QL: sv_ser2c ds.l   1       receive  channel 2 queue address */
.equ sv_ser2c,156
/* QL: sv_tmode ds.b   1       ZX8302 transmit mode (includes last baud rate) */
.equ sv_tmode,160
/* QL:         ds.b    1       spare */
/* QL: sv_csub ds.l    1       subroutine to jump to on capslock (only reach + 32767!) */
.equ sv_csub,162
/* QL: sv_timo ds.w    1       timeout for switching transmit mode */
.equ sv_timo,166
/* QL: sv_timov ds.w   1       ser1/2 control bytes: 7=lost 6=frame 3=inhib 2..0=baud */
.equ sv_timov,168
/* QL: sv_fstat ds.w   1       flashing cursor count (silly if > about 16!) */
.equ sv_fstat,170
/* QL: sv_progd ds.l   1       to $60 byte extension, old progd string + qlib_use */
.equ sv_progd,172
/* QL: sv_datad ds.l   1       to data default string, this -$24 = new progd */
.equ sv_datad,176
/* QL: sv_destd ds.l   1       to dest default string, this is above + $24 */
.equ sv_destd,180
/* QL: sv_thing ds.l   1       thing list */
.equ sv_thing,184
/* QL:         ds.w    25      spare */
/* QL: sv_mdrun ds.b   1       which drive is running? */
.equ sv_mdrun,238
/* QL: sv_mdcnt ds.b   1       microdrive run-up run-down counter */
.equ sv_mdcnt,239
/* QL: sv_mddid ds.b   8       drive id*4 of each microdrive */
.equ sv_mddid,240
/* QL: sv_mdsta ds.b   8       status, 0 = no pending ops */
.equ sv_mdsta,248
/* QL: sv_fsdef ds.l   16      pointers to file system physical definition */
.equ sv_fsdef,256
/* QL: sv_fslst ds.l   1       pointer to list of file channel definitions */
.equ sv_fslst,320
/* QL: sv_tran ds.b    1       key translation off(0) or on(1) */
.equ sv_tran,324
/* QL: sv_ichar ds.b   1       compose char workspace */
.equ sv_ichar,325
/* QL: sv_trtab ds.l   1       pointer to key translation tables */
.equ sv_trtab,326
/* QL: sv_mgtab ds.l   1       pointer to message table */
.equ sv_mgtab,330
/* QL: daytab   equ    $1c     err. for names of days */
.equ daytab,0x1c
/* QL: montab   equ    $1d    err. names of months */
.equ montab,0x1d
/* QL:         ds.w    3 */
/* QL: sv_turb1 ds.l   1       used by turbo */
.equ sv_turb1,340
/* QL: sv_turb2 ds.l   1 */
.equ sv_turb2,344
/* QL: sv_turb3 ds.w   1       length of file name!!!! */
.equ sv_turb3,348
/* QL: sv_turb4 ds.b   32      actually uses up to 41 bytes for file name!!!!!! */
.equ sv_turb4,350
/* QL: * taskmaster uses $154 l*4 */
/* QL: sv_stacb ds.l   192     bottom of stack */
.equ sv_stacb,382
/* QL: sv_stact ; big stack - no check */
.equ sv_stact,1150
/* QL: sv_trapo equ 2*($28+2) offset of trap vector table from (sv_trapv) */
.equ sv_trapo,(2*(0x28+2))
/* QL: sv.ident equ $d254 green, red, blue and black, with flash bits */
.equ sv.ident,0xd254
/* QL: * device driver definitions (for the driver's own pseudo system vars) */
/* QL:         offset  0 */
/* QL: sv_lxint ds.l   1       link to next external interrupt service */
.equ sv_lxint,0
/* QL: sv_axint ds.l   1       address of external interrupt service */
.equ sv_axint,4
/* QL: sv_lpoll ds.l   1       link to next polling interrupt service */
.equ sv_lpoll,8
/* QL: sv_apoll ds.l   1       address of polling interrupt service */
.equ sv_apoll,12
/* QL: sv_lschd ds.l   1       link to next scheduler task */
.equ sv_lschd,16
/* QL: sv_aschd ds.l   1       address of scheduler task */
.equ sv_aschd,20
/* QL: sv_lio  ds.l    1       link to next io driver */
.equ sv_lio,24
/* QL: sv_aio  ds.l    1       address of input/output routine */
.equ sv_aio,28
/* QL: sv_aopen ds.l   1       address of channel open routine */
.equ sv_aopen,32
/* QL: sv_aclos ds.l   1       address of channel close routine */
.equ sv_aclos,36
/* QL:         list */
/* QL:         section od_net */
.section od_net,"ax"
/* QL: od_net */
od_net:
/* QL:         dc.w    io-* */
.balign 2,0
dc_anchor_296:
.word ((io-dc_anchor_296))&65535
/* QL:         dc.w    open-* */
.balign 2,0
dc_anchor_300:
.word ((open-dc_anchor_300))&65535
/* QL:         dc.w    close-* */
.balign 2,0
dc_anchor_304:
.word ((close-dc_anchor_304))&65535
/* QL: io */
io:
/* QL:         jsr     io_relio(pc) */
    jsr io_relio(pc)
/* QL:         dc.w    pend-* */
.balign 2,0
dc_anchor_312:
.word ((pend-dc_anchor_312))&65535
/* QL:         dc.w    fbyte-* */
.balign 2,0
dc_anchor_316:
.word ((fbyte-dc_anchor_316))&65535
/* QL:         dc.w    sbyte-* */
.balign 2,0
dc_anchor_320:
.word ((sbyte-dc_anchor_320))&65535
/* QL: open */
open:
/* QL:         subq.l  #4,sp           make room for parameters */
    subq.l #4,sp
/* QL:         move.l  sp,a3 */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     check name */
    jsr io_name(pc)
/* QL:         bra.s   opn_exit        not net */
    bra.s opn_exit
/* QL:         bra.s   opn_exit        bad parameters */
    bra.s opn_exit
/* QL:         bra.s   open_net        ok! */
    bra.s open_net
/* QL:         dc.w    3,'NET',2,2,'OI',' _',0 output or input, station  */
.balign 2,0
dc_anchor_338:
.word 3
.byte 78,69,84
.balign 2,0
.word 2
.word 2
.byte 79,73
.balign 2,0
.byte 32,95
.balign 2,0
.word 0
/* QL: open_net */
open_net:
/* QL:         assert  0,net_end&3 */
/* original assertion: 0,net_end&3 */
/* QL:         moveq   #(net_end+3)>>2,d1 */
    moveq #((net_end+3)>>2),d1
/* QL:         lsl.w   #2,d1 */
    lsl.w #2,d1
/* QL:         jsr     mm_alchp(pc)    set up channel definition block */
    jsr mm_alchp(pc)
/* QL:         bne.s   opn_exit        ... oops */
    bne.s opn_exit
/* QL:         move.b  3(sp),net_dest(a0) set destination */
    move.b 3(sp),net_dest(a0)
/* QL:         move.b  sv_netnr(a6),net_self(a0) set self */
    move.b sv_netnr(a6),net_self(a0)
/* QL:         subq.w  #2,(sp)         out -1 (or -2), in zero */
    subq.w #2,(sp)
/* QL:         move.b  1(sp),net_type(a0) set in or out */
    move.b 1(sp),net_type(a0)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: opn_exit */
opn_exit:
/* QL:         addq.l  #4,sp           remove parameters */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * Close a network channel */
/* QL: close */
close:
/* QL:         tst.b   net_type(a0)    is it an input or output channel */
    tst.b net_type(a0)
/* QL:         bge.s   release         ... input */
    bge.s release
/* QL:         move.b  #1,net_type(a0) ... output - set eof */
    move.b #(1&255),net_type(a0)
/* QL:         move.b  net_rpnt(a0),net_nbyt(a0) and number of bytes */
    move.b net_rpnt(a0),net_nbyt(a0)
/* QL: tst_mdv */
tst_mdv:
/* QL:         tst.b   sv_mdrun(a6)    is a microdrive running? */
    tst.b sv_mdrun(a6)
/* QL:         bne.s   tst_mdv         yes - wait */
    bne.s tst_mdv
/* QL:         move.w  #1400,d4        keep on trying for about 15 seconds */
    move.w #1400,d4
/* QL: cls_loop */
cls_loop:
/* QL:         jsr     nd_spac(pc)     send the packet */
    jsr nd_spac(pc)
/* QL:         dbeq    d4,cls_loop     and keep trying until gone */
    dbeq d4,cls_loop
/* QL: release */
release:
/* QL:         jmp     mm_rechp(pc) */
    jmp mm_rechp(pc)
/* QL: get_pak */
get_pak:
/* QL:         sf      net_rpnt(a0)    reset running pointer */
    sf net_rpnt(a0)
/* QL:         jsr     nd_rpac(pc)     and get next block */
    jsr nd_rpac(pc)
/* QL:         bne.s   exit */
    bne.s exit
/* QL: pend */
pend:
/* QL:         move.b  net_type(a0),d0 type should be read ok (0) or eof (1) */
    move.b net_type(a0),d0
/* QL:         blt.s   err_bp */
    blt.s err_bp
/* QL:         clr.w   d2              set running pointer */
    clr.w d2
/* QL:         move.b  net_rpnt(a0),d2 */
    move.b net_rpnt(a0),d2
/* QL:         move.b  net_data(a0,d2.w),d1 set next byte */
    move.b net_data(a0,d2.w),d1
/* QL:         sub.b   net_nbyt(a0),d2 check pointer against number of bytes */
    sub.b net_nbyt(a0),d2
/* QL:         bcs.s   exit_ok         ... buffer not empty */
    bcs.s exit_ok
/* QL:         tst.b   d0              buffer empty - is it eof? */
    tst.b d0
/* QL:         beq.s   get_pak         ... no - get a new buffer */
    beq.s get_pak
/* QL:         moveq   #err.ef,d0      ... yes - thats it */
    moveq #err.ef,d0
/* QL:         rts */
    rts 
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: * Fetch a byte from the network */
/* QL: fbyte */
fbyte:
/* QL:         bsr.s   pend            anything pending? */
    bsr.s pend
/* QL:         bne.s   exit            ... no */
    bne.s exit
/* QL:         addq.b  #1,net_rpnt(a0) update pointer */
    addq.b #1,net_rpnt(a0)
/* QL: exit_ok */
exit_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: exit */
exit:
/* QL:         rts */
    rts 
/* QL: * Send a byte to the network */
/* QL: sbyte */
sbyte:
/* QL:         tst.b   net_type(a0)    is it an output? */
    tst.b net_type(a0)
/* QL:         bge.s   err_bp          ... oh no it isn't */
    bge.s err_bp
/* QL:         moveq   #1,d2           next write to buffer position */
    moveq #1,d2
/* QL:         add.b   net_rpnt(a0),d2 */
    add.b net_rpnt(a0),d2
/* QL:         bcc.s   write           is in the buffer */
    bcc.s write
/* QL:         move.b  d1,-(sp) */
    move.b d1,-(sp)
/* QL:         assert  net_type,net_nbyt-1 */
/* original assertion: net_type,net_nbyt-1 */
/* QL:         move.w  #$00ff,net_type(a0) set type and number of bytes */
    move.w #0x00ff,net_type(a0)
/* QL:         jsr     nd_spac(pc)     send packet */
    jsr nd_spac(pc)
/* QL:         move.b  (sp)+,d1 */
    move.b (sp)+,d1
/* QL:         st      net_type(a0)    restore type to write */
    st net_type(a0)
/* QL:         tst.l   d0              did it go? */
    tst.l d0
/* QL:         bne.s   exit */
    bne.s exit
/* QL:         moveq   #1,d2           set next byte pointer */
    moveq #1,d2
/* QL: write */
write:
/* QL:         move.b  d1,net_data-1(a0,d2.w) set this byte */
    move.b d1,(net_data-1)(a0,d2.w)
/* QL:         move.b  d2,net_rpnt(a0) and pointer to next */
    move.b d2,net_rpnt(a0)
/* QL:         bra.s   exit_ok */
    bra.s exit_ok
/* QL:         end */
