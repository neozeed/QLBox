/* Generated from original/M/mt/dmode.asm */
/* QL: * Read or set the display mode */
/* QL:         xdef    mt_dmode */
.globl mt_dmode
/* QL:         xref    ss_jobc,ss_noer */
/* QL:         xref    ip_dspm */
/* QL:         xref    sd_fresh */
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
/* QL:         include 'win1_m_inc_sx' */
/* QL: * system variables extension */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: sx_case ds.l    1       non-zero = user rtn on ctrl/alt/shift/enter (c/a/s/e?) */
.equ sx_case,0
/* QL: sx_itran ds.l   1       input tranlation routine */
.equ sx_itran,4
/* QL: sx_otran ds.l   1       output translation routine */
.equ sx_otran,8
/* QL: sx_driv ds.l    1       mm_rechp is memory management driver, close entry point */
.equ sx_driv,12
/* QL: sx_kbenc ds.l   1       keyboard encoder routine */
.equ sx_kbenc,16
/* QL: sx_ipcom ds.l   1       linked list to front end mt.ipcom calls */
.equ sx_ipcom,20
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL:         ds.l    1       spare/reserved (routine/table) */
/* QL: sx_trn  ds.l    1       default i/o translation table address */
.equ sx_trn,32
/* QL: sx_msg  ds.l    1       default message table address */
.equ sx_msg,36
/* QL: sx_f0   ds.l    1       default primary font */
.equ sx_f0,40
/* QL: sx_f1   ds.l    1       default secondary font */
.equ sx_f1,44
/* QL: sx_dspm ds.b    1       real display mode settings (dual screen) */
.equ sx_dspm,48
/* QL: sx_toe  ds.b    1       turn off ehancements: */
.equ sx_toe,49
/* QL:                 ; bit 7 set, allow format + files open */
/* QL:                 ; bit 1 set, treat -ve mt.baud as error (non-hermes) */
/* QL: sx_event ds.b   1       events: bit 4 = ctrl/space, 5=+alt, 6=+shift, 7=+both */
.equ sx_event,50
/* QL: sx_fstat ds.b   1       cursor flash rate, size and colour rrrrsccc */
.equ sx_fstat,51
/* QL: sx_kbste ds.b   12      special key remap table */
.equ sx_kbste,52
/* QL: sx_qdos ds.l    1       returned by mt.inf, ver$(-2) */
.equ sx_qdos,64
/* QL: sx_basic ds.w   1+4/2   length prefixed string returned by ver$, ver$(0) */
.equ sx_basic,68
/* QL:         ds.w    2       spare/reserved */
/* QL:         ds.b    1       21kxs10w   21: ser21 data pend, k: key held, x: shift */
/* QL:                         ; change while key held, s: sound in progress, 1: 1, */
/* QL:                         ; 0: zero Hermes, old IPC showed ser being zapped, */
/* QL:                         ; w: p26 (write protect) (experimental byte!) */
/* QL:         ds.b    1       spare/reserved */
/* QL: * initial ram based linkages */
/* QL:         ds.l    2       0 ip_poll */
/* QL:         ds.l    6       base+$60 sd_sched base+$68 ip_sched 0 io_scan */
/* QL:         ds.l    4       base+$80 od_serio od_serop od_sercl */
/* QL: sx_pipb ds.l    4       base+$90 io_serq  od_pipop od_pipcl */
.equ sx_pipb,128
/* QL: sx_con  ds.l    4       base+$a0 od_conio od_conop od_concl */
.equ sx_con,144
/* QL:         ds.l    4       0 od_netio od_netop od_netcl */
/* QL:         ds.l    8       0 dd_mdvio dd_mdvop dd_mdvcl md_slave 0 0 md_formt */
/* QL:         ds.b    4+2+3   md_end 3 'mdv' */
/* QL:         ds.b    3       spare bit */
/* QL: sx_pipc ds.l    1       pipe driver link word */
.equ sx_pipc,220
/* QL: * end of system extension */
/* QL:         list */
/* QL:         include 'win1_m_inc_ra' */
/* QL: * ram size definitions */
/* QL:         nolist */
/* QL: ra_bot  equ     $20000  bottom of ram */
.equ ra_bot,0x20000
/* QL: ra_min  equ     $20000  minimum ram size - 128 kbytes */
.equ ra_min,0x20000
/* QL: ra_ssize equ    $8000   screen size */
.equ ra_ssize,0x8000
/* QL:         list */
/* QL:         include 'win1_m_inc_mc' */
/* QL: * master chip registers */
/* QL:         nolist */
/* QL: mc_stat equ     $18063  status register address */
.equ mc_stat,0x18063
/* QL: *               bit     clear   set */
/* QL: mc..blnk equ    1       normal  blank   if set, the rest are irrelevant! */
.equ mc..blnk,1
/* QL: mc..m256 equ    3       512/4   256/8   pixels per line / colours per pixel */
.equ mc..m256,3
/* QL: mc..ntsc equ    6       PAL625  NTSC495 scan lines (512/384 displayed) */
.equ mc..ntsc,6
/* QL: mc..scrn equ    7       $20000  $28000  screen base address (scr0/scr1) */
.equ mc..scrn,7
/* QL:         list */
/* QL:         include 'win1_m_inc_jb' */
/* QL: * job header and save area definitions */
/* QL:         nolist */
/* QL:         offset  0 */
/* QL: jb_len  ds.l    1       length of job segment */
.equ jb_len,0
/* QL: jb_start ds.l   1       start address */
.equ jb_start,4
/* QL: jb_owner ds.l   1       owner of this job */
.equ jb_owner,8
/* QL: jb_hold ds.l    1       ptr to byte to be clr when job released */
.equ jb_hold,12
/* QL: jb_tag  ds.w    1       tag for this job */
.equ jb_tag,16
/* QL: jb_prior ds.b   1       current accumulated priority */
.equ jb_prior,18
/* QL: jb_princ ds.b   1       priority increment, if =0 job inactive */
.equ jb_princ,19
/* QL: jb_stat ds.w    1       job status: */
.equ jb_stat,20
/* QL: *               0 potentially active, >0 delay time (frames), <0 suspended */
/* QL: jb_rela6 ds.b   1       bit 7: next trap #2/3 is rel a6, bit 6: interpreter */
.equ jb_rela6,22
/* QL: jb_wflag ds.b   1       set if there is a job waiting on completion */
.equ jb_wflag,23
/* QL: jb_wjob ds.l    1       job id of waiting job */
.equ jb_wjob,24
/* QL: jb_trapv ds.l   1       pointer to trap redirection vectors */
.equ jb_trapv,28
/* QL: jb_d0   ds.l    8       saved d0-d7 */
.equ jb_d0,32
/* QL: jb_a0   ds.l    8       saved a0-a7 */
.equ jb_a0,64
/* QL: jb_sr   ds.w    1       saved sr */
.equ jb_sr,96
/* QL: jb_pc   ds.l    1       saved pc */
.equ jb_pc,98
/* QL:         ds.w    1       spare */
/* QL: jb_end */
.equ jb_end,104
/* QL:         list */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL: bs      equ     1<<mc..scrn */
.equ bs,(1<<mc..scrn)
/* QL: bm      equ     1<<mc..m256 */
.equ bm,(1<<mc..m256)
/* QL: bb      equ     1<<mc..blnk */
.equ bb,(1<<mc..blnk)
/* QL:         section mt_dmode */
.section mt_dmode,"ax"
/* QL: * This performs two disparate functions. The one sets either 256 or 512 */
/* QL: * pixel mode. The other tells any software that is interested whether a */
/* QL: * monitor or tv is in use. In the latter case, a distinction between a */
/* QL: * 525 line and 625 TV is made. The initialisation code will select the */
/* QL: * correct sort of TV. Selecting 525 lines on a European ROM may not */
/* QL: * produce useful results.  */
/* QL: * The enhanced set of options now available needs to operate on up to six bits */
/* QL: * of information. These are the 4/8 colour and visible states of each of two */
/* QL: * screens (4 bits), which screen is currently displayed and which screen is */
/* QL: * the current default for this job. They may all be read, en mass, but there */
/* QL: * is a need to be able to selectively set them, which means 12+ bits! */
/* QL: * In order to maintain compatibility, even with people who send the wrong */
/* QL: * parameters, the new options have bits 7/6 of d1.b differring. Also for */
/* QL: * compatibility, old style calls clear the msbs of d1.l even though it is */
/* QL: * contrary to the documentation. */
/* QL: * The primary needs are to be able to change the default screen and make it */
/* QL: * blank or visible. Being able to force which screen is on display is rather */
/* QL: * undesirable for too many programs to try doing simultaneously! */
/* QL: * With these in mind, we define the options available from d1 bits as follows: */
/* QL: *       0       visible/blank on other screen */
/* QL: *       1       visible/blank on default screen mc..blnk */
/* QL: *       2       mode4/mode8 on other screen */
/* QL: *       3       mode4/mode8 on default screen   mc..m256 */
/* QL: *       4       display scr0/scr1 */
/* QL: *       5       default scr0/scr1 (n.b. takes effect before all other options) */
/* QL: *       6       clear - use d1.w. set - use d1.b (same as d1.w msb all ones). */
/* QL: *       7       opposite to bit six, i.e. 7/6 = 0/1 or 1/0 always */
/* QL: *       8-15    ignored if bit 6 set. otherwise ... */
/* QL: *       8-13    associated with bits 0-5 (clear=toggle, set=absolute) */
/* QL: *       14      clear - force redraw of other screen */
/* QL: *       15      clear - force redraw of default screen */
/* QL: * If bits 6 and "x" + 8 are clear, use bit "x" to force absolute selection. */
/* QL: * Otherwise, toggle settings as per bit "x". ("x" = 0..5) */
/* QL: * If bits 6 and "x" are clear, invoke that screen redraw. ("x" = 14..15) */
/* QL: * The original -1/0/8 options are equivalent to $40 (or -128), $7780 and $7788. */
/* QL: * The "default screen" is initially inherited from the parent job. */
/* QL: * It is the screen on which newly opened con/scr channels will appear. */
/* QL: * It is also the screen affected/reported on by d1.b = 0/8/-1. */
/* QL: * A change to this takes effect before the rest of the above is looked at. */
/* QL: * It then remains changed for the job, until the job does another change to it. */
/* QL: * The "mode4/mode8" selection in this extended system does not operate the */
/* QL: * same as the basic d1.b = 0/8 options. It only changes the physical display */
/* QL: * mode. Redrawing of the windows is independant. It is also not forced by d2.b */
/* QL: * being positive, except on d1 = 0/8/-1 calls. */
/* QL: * The "displayed screen" is the one currently on display. */
/* QL: * The system variable "sv_mcsta" records the selection that is on display. */
/* QL: * A new system extension variable, "sx_dspm", records what is really going on. */
/* QL: * It holds the following bits: */
/* QL: *       bit     0       1 */
/* QL: *       0       visible blank   scr0 */
/* QL: *       1       visible blank   scr1            mc..blnk */
/* QL: *       2       mode4   mode8   scr0 */
/* QL: *       3       mode4   mode8   scr1            mc..m256 */
/* QL: *       4                       reserved */
/* QL: *       5                       reserved */
/* QL: *       6                       will always be zero */
/* QL: *       7       scr0    scr1    display         mc..scrn */
/* QL: * The least significant bit of the jb_rela6 variable in a jobs header is where */
/* QL: * its "default screen" is recorded. 0=scr0, 1=scr1. */
/* QL: * The returned value in d1.b for the extended calls is as follows: */
/* QL: *       bit     0       1 */
/* QL: *       0       visible blank   other */
/* QL: *       1       visible blank   default         mc..blnk */
/* QL: *       2       mode4   mode8   other */
/* QL: *       3       mode4   mode8   default         mc..m256 */
/* QL: *       4       scr0    scr1    display */
/* QL: *       5       scr0    scr1    default */
/* QL: *       6                       ??? */
/* QL: *       7       single  dual    available       mc..scrn */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- mode key (-1 read, 0 set 512, 8 set 256) */
/* QL: * d2 -i o- tv key   (-1 read, 0 set monitor, 1 set tv/625, 2 set tv/525) */
/* QL: * a6 -ip - base of system variables */
/* QL: reg_on1 reg    d1-d2            put on after lsb's are set */
/* QL: reglist reg    d1-d5/a0-a5      restore most registers (even a4 now!) */
/* QL: mt_dmode */
mt_dmode:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d5/a0-a5,-(sp)
/* QL:         jsr     ip_dspm(pc)     leaves a4 pointing at sysvar extension */
    jsr ip_dspm(pc)
/* QL:         movem.l (sp)+,reg_on1 */
    movem.l (sp)+,d1-d2
/* QL:         jsr     ss_jobc(pc)     find current job */
    jsr ss_jobc(pc)
/* QL:         move.w  d1,d3           working copy of d1.w */
    move.w d1,d3
/* QL:         moveq   #64,d0          this will give the new equivalent of -1 */
    moveq #64,d0
/* QL:         add.b   d1,d1           is it old style call? */
    add.b d1,d1
/* QL:         svs     d1              no - set mask as $ff ... */
    svs d1
/* QL:         bvs.s   d1new           ... and we are ready for next bit */
    bvs.s d1new
/* QL:         bcs.s   oldflag         carry means it was the -1 option */
    bcs.s oldflag
/* QL:         moveq   #bm,d0 */
    moveq #bm,d0
/* QL:         and.b   d3,d0           keep old 0/8 bit */
    and.b d3,d0
/* QL:         add.w   #(255-bs-bm)<<8+128,d0 make new equivalent */
    add.w #((((255-bs)-bm)<<8)+128),d0
/* QL: oldflag */
oldflag:
/* QL:         move.w  d0,d3           use prepared equivalent call */
    move.w d0,d3
/* QL:         moveq   #bm,d1          clear msbs, for compatibility */
    moveq #bm,d1
/* QL: ;       addq.b  #bm,d1          only want to return the m256 bit */
/* QL: d1new */
d1new:
/* QL:         moveq   #$3f,d4 */
    moveq #0x3f,d4
/* QL:         and.b   d3,d4           copy d1.b, but ensure 2 msb's are clear */
    and.b d3,d4
/* QL:         ror.w   #8,d3           fetch down d1.w (msb) */
    ror.w #8,d3
/* QL:         bmi.s   setdef          if d1.b was negative, "default" is ready */
    bmi.s setdef
/* QL:         st      d3              set all the d1.w (msb) */
    st d3
/* QL: setdef */
setdef:
/* QL: * In the following, the bits floating about are labelled as follows: */
/* QL: * d - dual screens available */
/* QL: * j - job default screen */
/* QL: * c - currently displayed screen */
/* QL: *       redraw  mode8   blank */
/* QL: *       s       m       b       - screen 1 */
/* QL: *       s       m       b       - screen 0 */
/* QL: *       r       l       a       - job default screen */
/* QL: *       r       l       a       - job other screen */
/* QL:         moveq   #-1-$70,d5      1111111110001111 */
    moveq #((-1)-0x70),d5
/* QL:         and.b   sx_dspm(a4),d5  11111111c000mmbb */
    and.b sx_dspm(a4),d5
/* QL:         bset    #0,jb_rela6(a3) test current job default screen and set scr1 */
    bset #0,jb_rela6(a3)
/* QL:         sne     d0              ????????jjjjjjjj remember old state */
    sne d0
/* QL:         and.b   d3,d0           keep "default" as per msb, then flip lsb... */
    and.b d3,d0
/* QL:         eor.b   d4,d0           ??????????j????? new default screen */
    eor.b d4,d0
/* QL:         lsl.b   #3,d0           ?????????????000 carry set if scr1 is right */
    lsl.b #3,d0
/* QL:         bcs.s   jbd1            if it was one, skip swaps and flag clearing */
    bcs.s jbd1
/* QL:         bclr    d0,jb_rela6(a3) job default screen is now scr0 */
    bclr d0,jb_rela6(a3)
/* QL:         bsr.s   munge           go swap bits */
    bsr.s munge
/* QL: jbd1 */
jbd1:
/* QL:         moveq   #5,d0           j bit no */
    moveq #5,d0
/* QL:         bset    d0,d3           keep new j */
    bset d0,d3
/* QL:         bclr    d0,d4           don't toggle new j */
    bclr d0,d4
/* QL:         add.w   d5,d5           111111jc000llaa0 */
    add.w d5,d5
/* QL:         asl.b   #3,d5           111111jcllaa0000 */
    asl.b #3,d5
/* QL:         asr.w   #4,d5           1111111111jcllaa */
    asr.w #4,d5
/* QL:         and.b   d3,d5           keep "default" as per msb, then flip lsb... */
    and.b d3,d5
/* QL:         eor.b   d4,d5           11111111rrjcllaa */
    eor.b d4,d5
/* QL:         moveq   #-64,d4         1111111111000000 */
    moveq #(-64),d4
/* QL:         or.b    d5,d4           1111111111jcllaa */
    or.b d5,d4
/* QL:         rol.w   #8,d4           11jcllaa11111111 */
    rol.w #8,d4
/* QL:         add.w   a6,d4           d1jcllaa11111111 */
    add.w a6,d4
/* QL:         ror.w   #8,d4           11111111d1jcllaa */
    ror.w #8,d4
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         blt.s   no_tvchg        jump if no tv change. */
    blt.s no_tvchg
/* QL:         move.b  d2,sv_tvmod(a6) set tv mode system variable */
    move.b d2,sv_tvmod(a6)
/* QL:         moveq   #$7f,d0         in case we want a redraw ... */
    moveq #0x7f,d0
/* QL:         or.b    d1,d0           ... new style call will set d0.b = $ff */
    or.b d1,d0
/* QL:         and.b   d0,d5           argh, if old and d2.b >= 0, must force redraw */
    and.b d0,d5
/* QL: no_tvchg */
no_tvchg:
/* QL:         and.b   d4,d1           use mask old/extended return value */
    and.b d4,d1
/* QL:         move.b  sv_tvmod(a6),d2 pick tv mode back up */
    move.b sv_tvmod(a6),d2
/* QL:         movem.l reg_on1,-(sp)   d1.b and d2.b are now ready for return */
    movem.l d1-d2,-(sp)
/* QL:         rol.b   #3,d5           11111111cllaarrj */
    rol.b #3,d5
/* QL:         asr.b   #1,d5           11111111ccllaarr */
    asr.b #1,d5
/* QL:         bcs.s   njd0            if j set, we have d5 right */
    bcs.s njd0
/* QL:         bsr.s   munge           11111110c0mmbbss */
    bsr.s munge
/* QL: njd0 */
njd0:
/* QL:         move.l  #ra_bot,a5 */
    move.l #ra_bot,a5
/* QL:         asr.b   #1,d5           1111111?cc?mmbbs */
    asr.b #1,d5
/* QL:         bsr.s   redraw          check/do redraw of screen 0 */
    bsr.s redraw
/* QL:         sub.w   #-ra_ssize,a5   point to base of second screen */
    sub.w #(-ra_ssize),a5
/* QL:         asr.b   #1,d5           ????????ccc?mmbb */
    asr.b #1,d5
/* QL:         btst    #mc..scrn,d4    are there really two screens? */
    btst #mc..scrn,d4
/* QL:         beq.s   rddone          no - then we're done */
    beq.s rddone
/* QL:         bsr.s   redraw          check/do redraw of screen 1 */
    bsr.s redraw
/* QL: rddone */
rddone:
/* QL:         moveq   #-1-$70,d0      1111111110001111 */
    moveq #((-1)-0x70),d0
/* QL:         and.b   d5,d0           ????????c000mmbb */
    and.b d5,d0
/* QL:         move.b  d0,sx_dspm(a4)  save new state */
    move.b d0,sx_dspm(a4)
/* QL:         bmi.s   isscr1 */
    bmi.s isscr1
/* QL:         add.b   d5,d5           ????????000mmbb0 */
    add.b d5,d5
/* QL: isscr1 */
isscr1:
/* QL:         bsr.s   setmc           set sv_mcsta */
    bsr.s setmc
/* QL:         move.b  d0,mc_stat      yipee! finally, we set the display hardware! */
    move.b d0,mc_stat
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d5/a0-a5
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: * This routine swaps bit pairs 5/4, 3/2 and 1/0 in d5. bits 8 and 6 are */
/* QL: * cleared and the rest (f-9 and 7) are copied unchanged. d0 is zapped. */
/* QL: * The comments show the original bit numbers, z=zero and w=one. */
/* QL: munge */
munge:
/* QL:         moveq   #$15,d0         zzzzzzzzzzzwzwzw */
    moveq #0x15,d0
/* QL:         and.b   d5,d0           zzzzzzzzzzz4z2z0 */
    and.b d5,d0
/* QL:         add.b   d0,d0           zzzzzzzzzz4z2z0z */
    add.b d0,d0
/* QL:         asr.b   #1,d5           fedcba9877654321 */
    asr.b #1,d5
/* QL:         and.w   #$fe95,d5       fdecba9z7zz5z3z1 */
    and.w #0xfe95,d5
/* QL:         or.b    d0,d5           fedcba9z7z452301 */
    or.b d0,d5
/* QL:         rts */
    rts 
/* QL: * check / redraw of a screen */
/* QL: redraw */
redraw:
/* QL:         bcs.s   ret             if inhibit flag was set, no redraw wanted */
    bcs.s ret
/* QL:         ; this bit is to see if it's nice to blank screen while redrawing */
/* QL:         ext.w   d5 */
    ext.w d5
/* QL:         add.w   a5,d5 */
    add.w a5,d5
/* QL:         bmi.s   noblnk          skip if not the visible screen */
    bmi.s noblnk
/* QL:         move.b  #bb,mc_stat */
    move.b #(bb&255),mc_stat
/* QL: noblnk */
noblnk:
/* QL:         ; end of that fringle. cost: 18 bytes */
/* QL:         bsr.s   setmc           set up for utilities being called */
    bsr.s setmc
/* QL:         jmp     sd_fresh(pc)    go do total redraw of a screen */
    jmp sd_fresh(pc)
/* QL: * This sets the hardware bits in sv_mcsta as needed by other routines */
/* QL: setmc */
setmc:
/* QL:         moveq   #bs+bm+bb-256,d0 */
    moveq #(((bs+bm)+bb)-256),d0
/* QL:         and.b   d5,d0 */
    and.b d5,d0
/* QL:         moveq   #1<<1,d1 */
    moveq #(1<<1),d1
/* QL:         and.b   sv_tvmod(a6),d1 treat tvmod bit 1 set as ntsc (2,3,6,7,...) */
    and.b sv_tvmod(a6),d1
/* QL:         lsl.b   #mc..ntsc-1,d1 */
    lsl.b #(mc..ntsc-1),d1
/* QL:         or.b    d1,d0 */
    or.b d1,d0
/* QL:         move.b  d0,sv_mcsta(a6) */
    move.b d0,sv_mcsta(a6)
/* QL: ret */
ret:
/* QL:         rts */
    rts 
/* QL:         end */
