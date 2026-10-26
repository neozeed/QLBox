/* Generated from original/M/tb/otrn.asm */
/* QL: * Standard output translation routine */
/* QL:         xdef    tb_otrn */
.globl tb_otrn
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
/* QL:         include 'win1_m_inc_vect' */
/* QL: * vect user vectors */
/* QL:         nolist */
/* QL: addr setnum $c0 */
/* QL: vec macro */
/* QL: * utility vectors - words */
/* QL: s vec.w 0 mm alchp 0 mm rechp 0 ut windw 0 ut con   ;  $c0 -  $c6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.alchp,192
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.rechp,194
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.windw,196
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.con,198
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 ut scr   0 ut err0  0 ut err   0 ut mint  ;  $c8 -  $ce */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.scr,200
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.err0,202
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.err,204
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.mint,206
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 ut mtext 0 ut link  0 ut unlnk k .. 0     ;  $d0 -  $d6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.mtext,208
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.link,210
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.unlnk,212
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 mm alloc 0 mm lnkfr 0 io qset  0 io qtest ;  $d8 -  $de */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.alloc,216
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.lnkfr,218
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qset,220
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qtest,222
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 io qin   0 io qout  0 io qeof  0 ut cstr  ;  $e0 -  $e6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qin,224
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qout,226
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qeof,228
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.cstr,230
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 io serq  0 io serio 0 cn date  0 cn day   ;  $e8 -  $ee */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.serq,232
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.serio,234
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.date,236
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.day,238
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn ftod  0 cn itod  0 cn itobb 0 cn itobw ;  $f0 -  $f6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.ftod,240
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itod,242
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itobb,244
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itobw,246
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn itobl 0 cn itohb 0 cn itohw 0 cn itohl ;  $f8 -  $fe */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itobl,248
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itohb,250
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itohw,252
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.itohl,254
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn dtof  0 cn dtoi  0 cn btoib 0 cn btoiw ; $100 - $106 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.dtof,256
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.dtoi,258
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.btoib,260
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.btoiw,262
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 cn btoil 0 cn htoib 0 cn htoiw 0 cn htoil ; $108 - $10e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.btoil,264
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.htoib,266
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.htoiw,268
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ cn.htoil,270
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 bp init  0 ca gtint 0 ca gtfp  0 ca gtstr ; $110 - $116 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.init,272
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtint,274
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtfp,276
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtstr,278
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 ca gtlin 0 bv chrix 0 ri exec  0 ri execb ; $118 - $11e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.gtlin,280
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bv.chrix,282
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ri.exec,284
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ri.execb,286
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 0 bp let   0 io name  4 md read  4 md write ; $120 - $126 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.let,288
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.name,290
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.read,292
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.write,294
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 md verin 4 md sectr 4 pa graph 4 pa table ; $128 - $12e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.verin,296
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.sectr,298
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.graph,300
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.table,302
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 pa expr  4 pa strip 4 pa mist  4 ed nwlin ; $130 - $136 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.expr,304
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.strip,306
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.mist,308
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ed.nwlin,310
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ed liste 4 pa ini   4 ut istr  4 go new   ; $138 - $13e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ed.liste,312
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ pa.ini,314
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ut.istr,316
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ go.new,318
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 bp chan  4 bp chand 4 bp chnid 4 bp chnew ; $140 - $146 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chan,320
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chand,322
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chnid,324
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.chnew,326
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 bp fname 4 ca cnvrt 4 ca opexe 4 ca eval  ; $148 - $14e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ bp.fname,328
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.cnvrt,330
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.opexe,332
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ca.eval,334
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ip kbrd  4 ip kbend 4 sb start k .. -1    ; $150 - $156 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ip.kbrd,336
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ip.kbend,338
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ sb.start,340
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 mm move  4 mm mrtoa 4 mm mator 4 mm mrtor ; $158 - $15e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.move,344
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.mrtoa,346
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.mator,348
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.mrtor,350
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ss wser  4 ss rser  4 md selec 4 md desel ; $160 - $166 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ss.wser,352
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ss.rser,354
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.selec,356
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ md.desel,358
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 mm clear 4 mm clrr  4 io qsetl k .. -1    ; $168 - $16e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.clear,360
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ mm.clrr,362
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ io.qsetl,364
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w 4 ii raw   4 ii drive k .. -1    k .. -1    ; $170 - $176 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ii.raw,368
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: [.parm([i]-1)].[.parm([i])] equ [addr] */
.equ ii.drive,370
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+3 */
/* QL:  ifstr [.parm([i]-2)] = k goto nxt */
/* QL: nxt maclab */
/* QL: addr setnum [addr]+2 */
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL:         list */
/* QL:         section tb_otrn */
.section tb_otrn,"ax"
/* QL: * sx_otrn: output translation routine: */
/* QL: * d1 -i o- byte after cr/lf/cz action / byte to be parity processed */
/* QL: * a0 -ip - base of serial channel definition */
/* QL: * a2 -i  - base of serial output queue */
/* QL: * d0/d2-d3/a1/a3 destroyed. */
/* QL: * If the value in d1 is not to be sent, an appropriate value should be set in */
/* QL: * d0 (err.nc normally) and the return address skipped. */
/* QL: * A one-to-many translation must verify that the queue has space, by calling */
/* QL: * io_qtest through the vector at $de, and if there is insufficient space, */
/* QL: * set err.nc in d0 and skip the return address. */
/* QL: * If the space is ok, the return address should be "jsr"ed to for all but the */
/* QL: * last byte, leaving that to go as normal. */
/* QL: * Only one-to-none, one-to-one and one-to-many conversions are convenient. */
/* QL: * If the return address mentioned above is used, it requires the following: */
/* QL: * d0 -  o- 0 (or error - queue full (err.nc) - should never happen!) */
/* QL: * d1 -i o- byte to put in queue (output with parity actioned) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * d2/a3 destroyed */
/* QL: tb_otrn */
tb_otrn:
/* QL:         move.l  sv_trtab(a6),a1 get translation table */
    move.l sv_trtab(a6),a1
/* QL:         move.w  2(a1),d2 */
    move.w 2(a1),d2
/* QL:         beq.s   rts0            no table, so get out */
    beq.s rts0
/* QL:         add.w   d2,a1 */
    add.w d2,a1
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.b  d1,d3           save d1, and ensure offset is a byte */
    move.b d1,d3
/* QL:         beq.s   rts0            send nul directly */
    beq.s rts0
/* QL:         move.b  0(a1,d3.w),d1   get the table entry */
    move.b 0(a1,d3.w),d1
/* QL:         bne.s   rts0            if trans_tab(char) <> 0, send it */
    bne.s rts0
/* QL:         move.l  sv_trtab(a6),a1 get sequence table */
    move.l sv_trtab(a6),a1
/* QL:         move.w  4(a1),d2 */
    move.w 4(a1),d2
/* QL:         beq.s   ok_fin          no sequence table, so drop it */
    beq.s ok_fin
/* QL:         add.w   d2,a1 */
    add.w d2,a1
/* QL:         move.w  io.qtest,a3 */
    move.w io.qtest,a3
/* QL:         jsr     (a3)            check space in queue */
    jsr (a3)
/* QL:         moveq   #err.nc,d0      ready to tell caller we can't do this yet */
    moveq #err.nc,d0
/* QL:         subq.w  #3,d2           is there room in queue */
    subq.w #3,d2
/* QL:         bcs.s   drop            no, go back with error */
    bcs.s drop
/* QL:         move.b  (a1)+,d0        get count (no of sequences) */
    move.b (a1)+,d0
/* QL:         bra.s   lent */
    bra.s lent
/* QL: loop */
loop:
/* QL:         addq.l  #3,a1           push on pointer */
    addq.l #3,a1
/* QL:         subq.b  #1,d0           decrement count */
    subq.b #1,d0
/* QL: lent */
lent:
/* QL:         beq.s   ok_fin          while count # 0 */
    beq.s ok_fin
/* QL:         cmp.b   (a1)+,d3        if char <> table entry */
    cmp.b (a1)+,d3
/* QL:         bne.s   loop            then continue loop */
    bne.s loop
/* QL:         moveq   #3-1,d3 */
    moveq #(3-1),d3
/* QL: send_3 */
send_3:
/* QL:         move.b  (a1)+,d1        get a byte */
    move.b (a1)+,d1
/* QL:         move.l  (sp),a3 */
    move.l (sp),a3
/* QL:         jsr     (a3)            call return address */
    jsr (a3)
/* QL:         dbra    d3,send_3 */
    dbra d3,send_3
/* QL: ok_fin */
ok_fin:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: drop */
drop:
/* QL:         addq.l  #4,sp           discard return address */
    addq.l #4,sp
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL:         end */
