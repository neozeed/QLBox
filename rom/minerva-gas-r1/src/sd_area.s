/* Generated from original/M/sd/area.asm */
/* QL: * Process an area of the screen (clear, scroll and pan) */
/* QL:         xdef    sd_clear,sd_clrxx,sd_pan,sd_recol,sd_scrol */
.globl sd_clear,sd_clrxx,sd_pan,sd_recol,sd_scrol
/* QL:         xref    sd_home */
/* QL:         xref    cs_fill,cs_pan,cs_recol,cs_scrol */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
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
/* QL:         include 'win1_m_inc_sd' */
/* QL: * window data block definition */
/* QL:         nolist */
/* QL:         offset  $18 (end of basic channel definition) */
/* QL: sd_xmin ds.w    1       window left pixel, exclusive of border */
.equ sd_xmin,24
/* QL: sd_ymin ds.w    1       ditto top pixel */
.equ sd_ymin,26
/* QL: sd_xsize ds.w   1       window width, exclusive of border */
.equ sd_xsize,28
/* QL: sd_ysize ds.w   1       ditto height */
.equ sd_ysize,30
/* QL: sd_borwd ds.w   1       border height, border width is double this */
.equ sd_borwd,32
/* QL: sd_xpos ds.w    1       cursor position relative to left pixel above */
.equ sd_xpos,34
/* QL: sd_ypos ds.w    1       ditto top pixel */
.equ sd_ypos,36
/* QL: sd_xinc ds.w    1       cursor pixel width */
.equ sd_xinc,38
/* QL: sd_yinc ds.w    1       cursor pixel height */
.equ sd_yinc,40
/* QL: * note: the x values above should be even when in mode 8. */
/* QL: sd_font ds.l    2       font addresses, primary first. def char in secondary */
.equ sd_font,42
/* QL: sd_scrb ds.l    1       base address of screen */
.equ sd_scrb,50
/* QL: sd_pmask ds.l   1       paper colour mask */
.equ sd_pmask,54
/* QL: sd_smask ds.l   1       strip colour mask */
.equ sd_smask,58
/* QL: sd_imask ds.l   1       ink colour mask */
.equ sd_imask,62
/* QL: sd_cattr ds.b   1       character attributes (see below for bits) */
.equ sd_cattr,66
/* QL: sd_curf ds.b    1       cursor flag (0 suppressed, >0 visible, <0 invisible) */
.equ sd_curf,67
/* QL: sd_pcolr ds.b   1       paper colour byte */
.equ sd_pcolr,68
/* QL: sd_scolr ds.b   1       strip colour byte */
.equ sd_scolr,69
/* QL: sd_icolr ds.b   1       ink colour byte */
.equ sd_icolr,70
/* QL: sd_bcolr ds.b   1       border colour byte */
.equ sd_bcolr,71
/* QL: sd_nlsta ds.b   1       new line status (0 none, >0 implicit, <0 explicit) */
.equ sd_nlsta,72
/* QL: sd_fmod ds.b    1       fill mode (0 off, 1 on) */
.equ sd_fmod,73
/* QL: sd_yorg ds.w    3       graphics window origin (added to y coords) (float) */
.equ sd_yorg,74
/* QL: sd_xorg ds.w    3       ditto for x */
.equ sd_xorg,80
/* QL: sd_scal ds.w    3       graphics scale factor (from bottom row to top row) */
.equ sd_scal,86
/* QL: sd_fbuf ds.l    1       pointer to alchp'ed fill buffer, 0 if none */
.equ sd_fbuf,92
/* QL: sd_fuse ds.l    1       pointer to user defined fill vectors, not used */
.equ sd_fuse,96
/* QL: sd_linel ds.w   1       line length in bytes */
.equ sd_linel,100
/* QL: sd_flags ds.b   1       cleared by 1st time entry to driver (edlin needs this) */
.equ sd_flags,102
/* QL:         ds.b    1       spare */
/* QL: sd_end */
.equ sd_end,104
/* QL: * character attribute flag bits for sd_cattr */
/* QL: sd..ulin equ    0       underline (row 9, or the lowest row, is all ink) */
.equ sd..ulin,0
/* QL: sd..flsh equ    1       flash (ignored in mode 4) */
.equ sd..flsh,1
/* QL: sd..trns equ    2       transparent background (only character area is touched) */
.equ sd..trns,2
/* QL: sd..xor equ     3       xor characters/graphics (char/pixel colour xor'ed in) */
.equ sd..xor,3
/* QL: sd..dbht equ    4       double height (chars spread in y) */
.equ sd..dbht,4
/* QL: sd..exwd equ    5       extended width (8 bits used from char font entries) */
.equ sd..exwd,5
/* QL: sd..dbwd equ    6       double width (chars spread in x, mode 8 sets this) */
.equ sd..dbwd,6
/* QL: sd..gchr equ    7       graphics positioned chars (offscreen ignored until nl) */
.equ sd..gchr,7
/* QL: * screen entry parameter definition */
/* QL: sd.extop equ    $09     external operation (a2) */
.equ sd.extop,0x09
/* QL: sd.pxenq equ    $0a     pixel based size / position enquiry */
.equ sd.pxenq,0x0a
/* QL: sd.chenq equ    $0b     character based size / position enquiry */
.equ sd.chenq,0x0b
/* QL: sd.bordr equ    $0c     define window border */
.equ sd.bordr,0x0c
/* QL: sd.wdef equ     $0d     define window */
.equ sd.wdef,0x0d
/* QL: sd.cure equ     $0e     enable cursor */
.equ sd.cure,0x0e
/* QL: sd.curs equ     $0f     suppress cursor */
.equ sd.curs,0x0f
/* QL: sd.pos  equ     $10     absolute position */
.equ sd.pos,0x10
/* QL: sd.tab  equ     $11     tab (horizontal position) */
.equ sd.tab,0x11
/* QL: sd.nl   equ     $12     newline */
.equ sd.nl,0x12
/* QL: sd.pcol equ     $13     previous column */
.equ sd.pcol,0x13
/* QL: sd.ncol equ     $14     next column */
.equ sd.ncol,0x14
/* QL: sd.prow equ     $15     previous row */
.equ sd.prow,0x15
/* QL: sd.nrow equ     $16     next row */
.equ sd.nrow,0x16
/* QL: sd.pixp equ     $17     set pixel position */
.equ sd.pixp,0x17
/* QL: sd.scrol equ    $18     scroll whole window */
.equ sd.scrol,0x18
/* QL: sd.scrtp equ    $19     scroll top of window */
.equ sd.scrtp,0x19
/* QL: sd.scrbt equ    $1a     scroll bottom of window */
.equ sd.scrbt,0x1a
/* QL: sd.pan  equ     $1b     pan window */
.equ sd.pan,0x1b
/* QL: * ?     equ     $1c */
/* QL: * ?     equ     $1d */
/* QL: sd.panln equ    $1e     pan cursor line */
.equ sd.panln,0x1e
/* QL: sd.panrt equ    $1f     pan rhs of cursor line */
.equ sd.panrt,0x1f
/* QL: sd.clear equ    $20     clear whole window */
.equ sd.clear,0x20
/* QL: sd.clrtp equ    $21     clear top of window */
.equ sd.clrtp,0x21
/* QL: sd.clrbt equ    $22     clear bottom of window */
.equ sd.clrbt,0x22
/* QL: sd.clrln equ    $23     clear cursor line */
.equ sd.clrln,0x23
/* QL: sd.clrrt equ    $24     clear to right of cursor */
.equ sd.clrrt,0x24
/* QL: sd.fount equ    $25     set fount addresses */
.equ sd.fount,0x25
/* QL: sd.recol equ    $26     recolour a window */
.equ sd.recol,0x26
/* QL: sd.setpa equ    $27     set paper colour */
.equ sd.setpa,0x27
/* QL: sd.setst equ    $28     set strip colour */
.equ sd.setst,0x28
/* QL: sd.setin equ    $29     set ink colour */
.equ sd.setin,0x29
/* QL: sd.setfl equ    $2a     set flash on/off */
.equ sd.setfl,0x2a
/* QL: sd.setul equ    $2b     set underline on/off */
.equ sd.setul,0x2b
/* QL: sd.setmd equ    $2c     set write mode */
.equ sd.setmd,0x2c
/* QL: sd.setsz equ    $2d     set character size */
.equ sd.setsz,0x2d
/* QL: sd.fill equ     $2e     fill block */
.equ sd.fill,0x2e
/* QL: sd.donl equ     $2f     do pending newline */
.equ sd.donl,0x2f
/* QL: sd.point equ    $30     set point in window */
.equ sd.point,0x30
/* QL: sd.line equ     $31     draw line */
.equ sd.line,0x31
/* QL: sd.arc  equ     $32     draw arc */
.equ sd.arc,0x32
/* QL: sd.elips equ    $33     draw ellipse */
.equ sd.elips,0x33
/* QL: sd.scale equ    $34     set graphics scale */
.equ sd.scale,0x34
/* QL: sd.flood equ    $35     set fill mode/vectors */
.equ sd.flood,0x35
/* QL: sd.gcur equ     $36     set text cursor using graphics coords */
.equ sd.gcur,0x36
/* QL: * $6c..$74 $76..$77 $7a..$7f (at least) are used by the pointer interface */
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
/* QL:         section sd_area */
.section sd_area,"ax"
/* QL: * d0 -i o- area key / 0(no error) */
/* QL: * d1 -i  - distance to pan/scroll (sd.panxx, sd.scroll and sd.scrxx only) */
/* QL: * a0 -ip - channel definition block */
/* QL: * a1 -i  - recolour map address (sd.recol only) */
/* QL: * d1-d3/a1-a2 destroyed */
/* QL: regon   reg     d0-d1/d5-d7/a0-a1 */
/* QL: regoff  reg     d4-d7/a0-a1 */
/* QL: sd_recol */
sd_recol:
/* QL:         moveq   #0,d0           recolour whole window only */
    moveq #0,d0
/* QL:         lea     cs_recol(pc),a2 set cs entry point for recolour */
    lea cs_recol(pc),a2
/* QL:         bra.s   go_coset        a1 has recolour table already */
    bra.s go_coset
/* QL: sd_clear */
sd_clear:
/* QL:         jsr     sd_home(pc)     reset cursor for full clear, d0.l = 0 on return */
    jsr sd_home(pc)
/* QL: sd_clrxx */
sd_clrxx:
/* QL:         assert  0,sd.clrtp&7-1,sd.clrbt&7-2,sd.clrln&7-3,sd.clrrt&7-4 */
/* original assertion: 0,sd.clrtp&7-1,sd.clrbt&7-2,sd.clrln&7-3,sd.clrrt&7-4 */
/* QL:         lea     cs_fill(pc),a2  set cs entry point for area fill */
    lea cs_fill(pc),a2
/* QL:         bra.s   go_area */
    bra.s go_area
/* QL: sd_scrol */
sd_scrol:
/* QL:         assert  0,sd.scrol&7,sd.scrtp&7-1,sd.scrbt&7-2 */
/* original assertion: 0,sd.scrol&7,sd.scrtp&7-1,sd.scrbt&7-2 */
/* QL:         lea     cs_scrol(pc),a2 set cs entry point for scroll */
    lea cs_scrol(pc),a2
/* QL:         bra.s   go_area */
    bra.s go_area
/* QL: sd_pan */
sd_pan:
/* QL:         assert  3,sd.pan&7,sd.panln&7-3,sd.panrt&7-4 */
/* original assertion: 3,sd.pan&7,sd.panln&7-3,sd.panrt&7-4 */
/* QL:         subq.b  #3,d0 */
    subq.b #3,d0
/* QL:         lea     cs_pan(pc),a2   set cs entry point for pan */
    lea cs_pan(pc),a2
/* QL:         btst    #mc..m256,sv_mcsta(a6) is it low res mode */
    btst #mc..m256,sv_mcsta(a6)
/* QL:         beq.s   go_area         pan even distances only */
    beq.s go_area
/* QL:         bclr    #0,d1           pan even distances only */
    bclr #0,d1
/* QL: * Now set up the parameters for different types of area ops */
/* QL: * 0 full area */
/* QL: * 1 top of window */
/* QL: * 2 bottom of window */
/* QL: * 3 cursor line */
/* QL: * 4 right of cursor line */
/* QL: * 5 cursor only (for prettier io.edlin - new call!) */
/* QL: go_area */
go_area:
/* QL:         lea     sd_pmask(a0),a1 fill with paper colour */
    lea sd_pmask(a0),a1
/* QL: go_coset */
go_coset:
/* QL:         move.l  d4,-(sp)        save d4 */
    move.l d4,-(sp)
/* QL:         movem.l regon,-(sp)     save distance and temp registers */
    movem.l d0-d1/d5-d7/a0-a1,-(sp)
/* QL:         ;       d0         d1         d2         d3 */
/* QL:         assert  sd_xmin    sd_ymin-2  sd_xsize-4 sd_ysize-6  sd_xpos-10 sd_ypos-12 sd_xinc-14 sd_yinc-16 */
/* original assertion: sd_xmin    sd_ymin-2  sd_xsize-4 sd_ysize-6  sd_xpos-10 sd_ypos-12 sd_xinc-14 sd_yinc-16 */
/* QL:         ;       d6         d7         a0         a1 */
/* QL:         movem.w sd_xmin(a0),d0-d4/d6-d7/a0-a1 get all window parameters */
    movem.w sd_xmin(a0),d0-d4/d6-d7/a0-a1
/* QL:         moveq   #7,d4           extract key ... */
    moveq #7,d4
/* QL:         and.l   (sp)+,d4        ... out of the way */
    and.l (sp)+,d4
/* QL:         beq.s   end_all         key 0 - we've done it */
    beq.s end_all
/* QL:         subq.b  #2,d4 */
    subq.b #2,d4
/* QL:         beq.s   set_2 */
    beq.s set_2
/* QL:         bpl.s   set_345 */
    bpl.s set_345
/* QL:         cmp.w   d7,d3           check ypos against ysize */
    cmp.w d7,d3
/* QL:         ble.s   end_all         if cursor position is below screen, do whole */
    ble.s end_all
/* QL:         move.w  d7,d3           key 1 - only operate down to cursor */
    move.w d7,d3
/* QL:         bmi.s   end_zap         if cursor is above screen, do nothing */
    bmi.s end_zap
/* QL:         bra.s   end_all */
    bra.s end_all
/* QL: set_2 */
set_2:
/* QL:         add.w   a1,d7           calculate incremented ypos */
    add.w a1,d7
/* QL:         bmi.s   end_all         if negative, do whole window */
    bmi.s end_all
/* QL:         sub.l   d7,d3           key 2 - go down to bottom */
    sub.l d7,d3
/* QL:         bls.s   end_zap         if below window, do nothing */
    bls.s end_zap
/* QL:         bra.s   end_ypos */
    bra.s end_ypos
/* QL: * Check that bottom of area is not below bottom of window */
/* QL: * OK if ypos + yinc <= ysize, i.e. ysize - ypos - yinc <= 0 */
/* QL: set_345 */
set_345:
/* QL:         sub.l   a1,d3 */
    sub.l a1,d3
/* QL:         blo.s   end_zap         do nothing if yinc > ysize */
    blo.s end_zap
/* QL:         cmp.l   d7,d3 */
    cmp.l d7,d3
/* QL:         blo.s   end_zap         do nothing if cursor start off screen */
    blo.s end_zap
/* QL:         move.w  a1,d3           we do yinc for key > 2, if all ok */
    move.w a1,d3
/* QL:         subq.b  #2,d4 */
    subq.b #2,d4
/* QL:         bmi.s   end_ypos        key 3 - we've done it */
    bmi.s end_ypos
/* QL:         sub.w   d6,d2           do xsize - xpos */
    sub.w d6,d2
/* QL:         bls.s   end_zap         do nothing if cursor off left/right of screen */
    bls.s end_zap
/* QL:         add.w   d6,d0           start at xmin+xpos */
    add.w d6,d0
/* QL:         tst.b   d4 */
    tst.b d4
/* QL:         beq.s   end_ypos        key 4 - we're ready */
    beq.s end_ypos
/* QL:         exg     a0,d2           key 5 - only operate on cursor */
    exg a0,d2
/* QL:         cmp.w   a0,d2 */
    cmp.w a0,d2
/* QL:         bls.s   end_ypos */
    bls.s end_ypos
/* QL: end_zap */
end_zap:
/* QL:         lea     rts0,a2         lose routine, we're skipping any action */
    lea rts0(pc),a2
/* QL: end_ypos */
end_ypos:
/* QL:         add.w   d7,d1           start at ymin+ypos */
    add.w d7,d1
/* QL: end_all */
end_all:
/* QL:         movem.l (sp)+,regoff    restore distance and temp registers */
    movem.l (sp)+,d4-d7/a0-a1
/* QL:         jsr     (a2)            do it */
    jsr (a2)
/* QL: exit */
exit:
/* QL:         move.l  (sp)+,d4        reload d4 */
    move.l (sp)+,d4
/* QL:         moveq   #0,d0           register no error, ever */
    moveq #0,d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL:         end */
