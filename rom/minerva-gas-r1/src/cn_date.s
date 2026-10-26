/* Generated from original/M/cn/date.asm */
/* QL: * Time and date (as string) */
/* QL:         xdef    cn_date,cn_day */
.globl cn_date,cn_day
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
/* QL:         include 'win1_m_inc_mt' */
/* QL: * manager trap #1 codes */
/* QL:         nolist */
/* QL: mt.inf  equ     $00     get system information */
.equ mt.inf,0x00
/* QL: mt.cjob equ     $01     create a job */
.equ mt.cjob,0x01
/* QL: mt.jinf equ     $02     get information on job */
.equ mt.jinf,0x02
/* QL: mt.extop equ    $03     convert called routine to supervisor, rte at end */
.equ mt.extop,0x03
/* QL: mt.rjob equ     $04     remove a job */
.equ mt.rjob,0x04
/* QL: mt.frjob equ    $05     force remove a job */
.equ mt.frjob,0x05
/* QL: mt.free equ     $06     find out how much free space there is */
.equ mt.free,0x06
/* QL: mt.trapv equ    $07     set pointer to trap redirection vectors */
.equ mt.trapv,0x07
/* QL: mt.susjb equ    $08     suspend a job */
.equ mt.susjb,0x08
/* QL: mt.reljb equ    $09     release a job */
.equ mt.reljb,0x09
/* QL: mt.activ equ    $0a     activate a job */
.equ mt.activ,0x0a
/* QL: mt.prior equ    $0b     set a job priority */
.equ mt.prior,0x0b
/* QL: mt.alloc equ    $0c     allocate a bit of a heap */
.equ mt.alloc,0x0c
/* QL: mt.lnkfr equ    $0d     release a bit of a heap */
.equ mt.lnkfr,0x0d
/* QL: mt.alres equ    $0e     allocate resident procedure area */
.equ mt.alres,0x0e
/* QL: mt.reres equ    $0f     release resident procedure area */
.equ mt.reres,0x0f
/* QL: mt.dmode equ    $10     set display mode */
.equ mt.dmode,0x10
/* QL: mt.ipcom equ    $11     send IPC command */
.equ mt.ipcom,0x11
/* QL: mt.baud equ     $12     set baud rate */
.equ mt.baud,0x12
/* QL: mt.rclck equ    $13     read clock */
.equ mt.rclck,0x13
/* QL: mt.sclck equ    $14     set clock */
.equ mt.sclck,0x14
/* QL: mt.aclck equ    $15     adjust clock */
.equ mt.aclck,0x15
/* QL: mt.albas equ    $16     allocate basic area */
.equ mt.albas,0x16
/* QL: mt.rebas equ    $17     release basic area */
.equ mt.rebas,0x17
/* QL: mt.alchp equ    $18     allocate space in common heap */
.equ mt.alchp,0x18
/* QL: mt.rechp equ    $19     release space in common heap */
.equ mt.rechp,0x19
/* QL: mt.lxint equ    $1a     link in external interrupt handler */
.equ mt.lxint,0x1a
/* QL: mt.rxint equ    $1b     remove external interrupt handler */
.equ mt.rxint,0x1b
/* QL: mt.lpoll equ    $1c     link in polled task */
.equ mt.lpoll,0x1c
/* QL: mt.rpoll equ    $1d     remove polled task */
.equ mt.rpoll,0x1d
/* QL: mt.lschd equ    $1e     link in scheduler task */
.equ mt.lschd,0x1e
/* QL: mt.rschd equ    $1f     remove scheduler task */
.equ mt.rschd,0x1f
/* QL: mt.liod equ     $20     link in I/O driver */
.equ mt.liod,0x20
/* QL: mt.riod equ     $21     remove I/O driver */
.equ mt.riod,0x21
/* QL: mt.ldd  equ     $22     link in directory driver */
.equ mt.ldd,0x22
/* QL: mt.rdd  equ     $23     remove directory driver */
.equ mt.rdd,0x23
/* QL: mt.cntry equ    $24     set translate/error tables */
.equ mt.cntry,0x24
/* QL:         list */
/* QL:         section cn_date */
.section cn_date,"ax"
/* QL: * d0 -  o- zero, CCR set (no errors possible) */
/* QL: * d1 -ip - date (numeric) */
/* QL: * a1 -i o- pointer to ri stack */
/* QL: dot     equ     1961    (n.b. dot+3 is a leap year) */
.equ dot,1961
/* QL: reg_list reg    d1-d5/a0 */
/* QL: * String writing subroutines */
/* QL: wHHMM */
whhmm:
/* QL:         swap    d2 */
    swap d2
/* QL:         moveq   #':',d1         colon first */
    moveq #58,d1
/* QL:         bsr.s   wX */
    bsr.s wx
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL: w99 */
w99:
/* QL:         pea     wlast */
    pea wlast(pc)
/* QL: wdigit */
wdigit:
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         divu    #10,d1 */
    divu #10,d1
/* QL:         swap    d1 */
    swap d1
/* QL: wlast */
wlast:
/* QL:         add.b   #'0',d1 */
    add.b #(48&255),d1
/* QL:         bsr.s   wX */
    bsr.s wx
/* QL:         swap    d1 */
    swap d1
/* QL:         rts */
    rts 
/* QL: wS */
ws:
/* QL:         moveq   #' ',d1         write a space */
    moveq #32,d1
/* QL: wX */
wx:
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  d1,0(a6,a1.l) */
    move.b d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: wAAAS */
waaas:
/* QL:         moveq   #mt.inf,d0 */
    moveq #mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  sv_mgtab(a0),a0 */
    move.l sv_mgtab(a0),a0
/* QL:         add.w   0(a0,d3.w),a0 */
    add.w 0(a0,d3.w),a0
/* QL:         moveq   #3,d0 */
    moveq #3,d0
/* QL:         mulu    d0,d4 */
    mulu d0,d4
/* QL:         lea     3(a0,d4.w),a0 */
    lea 3(a0,d4.w),a0
/* QL:         moveq   #' ',d1         space after 3 chars */
    moveq #32,d1
/* QL: loop */
loop:
/* QL:         bsr.s   wX */
    bsr.s wx
/* QL:         move.b  -(a0),d1        copy 3 chars into string */
    move.b -(a0),d1
/* QL:         dbra    d0,loop         four chars in all */
    dbra d0,loop
/* QL:         rts */
    rts 
/* QL: cn_date */
cn_date:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d1-d5/a0,-(sp)
/* QL:         bsr.s   calend          reduce to components */
    bsr.s calend
/* QL:         swap    d1 */
    swap d1
/* QL:         bsr.s   w99             write secs into string */
    bsr.s w99
/* QL:         bsr.s   wHHMM           write mins into string with a colon */
    bsr.s whhmm
/* QL:         bsr.s   wHHMM           write hours into string with a colon */
    bsr.s whhmm
/* QL:         bsr.s   wS              write space */
    bsr.s ws
/* QL:         move.w  d3,d1 */
    move.w d3,d1
/* QL:         bsr.s   w99             write day in month */
    bsr.s w99
/* QL:         moveq   #montab*2,d3 */
    moveq #(montab*2),d3
/* QL:         bsr.s   wAAAS           get month into string with a space */
    bsr.s waaas
/* QL:         bsr.s   wS              write space */
    bsr.s ws
/* QL:         move.w  d5,d1 */
    move.w d5,d1
/* QL:         bsr.s   wdigit */
    bsr.s wdigit
/* QL:         bsr.s   wdigit */
    bsr.s wdigit
/* QL:         bsr.s   w99             write the year */
    bsr.s w99
/* QL:         moveq   #20,d1          total chars */
    moveq #20,d1
/* QL: exit_ok */
exit_ok:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d1,0(a6,a1.l)   set string length */
    move.w d1,0(a6,a1.l)
/* QL:         movem.l (sp)+,reg_list */
    movem.l (sp)+,d1-d5/a0
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: cn_day */
cn_day:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d1-d5/a0,-(sp)
/* QL:         bsr.s   calend */
    bsr.s calend
/* QL:         swap    d4 */
    swap d4
/* QL:         moveq   #daytab*2,d3 */
    moveq #(daytab*2),d3
/* QL:         bsr.s   wAAAS           move day into string and pad with a space */
    bsr.s waaas
/* QL:         moveq   #3,d1           string length excludes the trailing space */
    moveq #3,d1
/* QL:         bra.s   exit_ok */
    bra.s exit_ok
/* QL: * Calendar subroutine */
/* QL: * Call with d1.l = time in seconds since 00:00:00 on 1st jan in year dot */
/* QL: * Returns with: */
/* QL: * d0 = 7 */
/* QL: * d1.msw = second */
/* QL: * d2.msw = minute */
/* QL: * d2.lsw = hour */
/* QL: * d3.lsw = day of month (1..31) */
/* QL: * d4.msw = day of week (0..6) */
/* QL: * d4.lsw = month (0..11) */
/* QL: * d5.lsw = year.w */
/* QL: calend */
calend:
/* QL:         lsr.l   #1,d1           adjust so we can divide properly (X preserved) */
    lsr.l #1,d1
/* QL:         divu    #12*60*60,d1    d1.lsw = days since dot, d1.msw*2+X=sec in day */
    divu #((12*60)*60),d1
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.w  d1,d3           d3 = days since dot */
    move.w d1,d3
/* QL:         clr.w   d1 */
    clr.w d1
/* QL:         swap    d1 */
    swap d1
/* QL:         addx.l  d1,d1           d1 = second in day */
    addx.l d1,d1
/* QL:         moveq   #60,d0 */
    moveq #60,d0
/* QL:         divu    d0,d1           d1.msw = second */
    divu d0,d1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         divu    d0,d2           d2.msw = minute, d2.lsw = hour */
    divu d0,d2
/* QL:         move.l  d3,d4           duplicate days since dot */
    move.l d3,d4
/* QL:         divu    #7,d4           d4.msw = day of week */
    divu #7,d4
/* QL:         divu    #3*365+366,d3   d3.msw fyp days, d3.lsw = fyps since t0 */
    divu #((3*365)+366),d3
/* QL:         move.w  d3,d5           d5.lsw = sets of four years since dot */
    move.w d3,d5
/* QL:         clr.w   d3 */
    clr.w d3
/* QL:         swap    d3              d3 = day of four year period */
    swap d3
/* QL:         divu    #365,d3         d3.msw = day of year, d3.lsw = year of fyp */
    divu #365,d3
/* QL:         moveq   #31+28,d0       d0 = jan+feb (non-leap) */
    moveq #(31+28),d0
/* QL:         subq.w  #3,d3           check for year in period >= 3 */
    subq.w #3,d3
/* QL:         blt.s   notleap */
    blt.s notleap
/* QL:         beq.s   not4th          if it's the final odd day 0 / year 4 */
    beq.s not4th
/* QL:         move.l  #365<<16,d3     make it right */
    move.l #(365<<16),d3
/* QL: not4th */
not4th:
/* QL:         moveq   #31+29,d0       d0 = jan+feb(leap) */
    moveq #(31+29),d0
/* QL: notleap */
notleap:
/* QL:         asl.w   #2,d5 */
    asl.w #2,d5
/* QL:         add.w   d3,d5 */
    add.w d3,d5
/* QL:         add.w   #dot+3,d5       d5.lsw = year */
    add.w #(dot+3),d5
/* QL:         clr.w   d3 */
    clr.w d3
/* QL:         swap    d3              d1 = day in year */
    swap d3
/* QL:         sub.w   d0,d3 */
    sub.w d0,d3
/* QL:         blt.s   notjf           if day >= jan+feb (month >= march) then */
    blt.s notjf
/* QL:         moveq   #31+30,d0       make feb look like a 30 day month */
    moveq #(31+30),d0
/* QL: notjf */
notjf:
/* QL:         add.w   d0,d3 */
    add.w d0,d3
/* QL: * Pattern now goes like: 31,30,31,30,31,30,31,31,30,31,30,31 */
/* QL:         moveq   #7,d0           d0 = months in cycle */
    moveq #7,d0
/* QL:         mulu    d0,d3 */
    mulu d0,d3
/* QL:         addq.w  #3,d3 */
    addq.w #3,d3
/* QL:         divu    #7*30+4,d3      d3 = (day * d0 + d0 div 2) / (days in cycle) */
    divu #((7*30)+4),d3
/* QL:         move.w  d3,d4           d4.msw = day of week, d4.lsw = month in year */
    move.w d3,d4
/* QL:         clr.w   d3 */
    clr.w d3
/* QL:         swap    d3 */
    swap d3
/* QL:         divu    d0,d3           day in month = remainder div d0 */
    divu d0,d3
/* QL:         addq.w  #1,d3           plus one */
    addq.w #1,d3
/* QL:         rts */
    rts 
/* QL:         end */
