/* Generated from original/M/cs/area.asm */
/* QL: * Performs area operations */
/* QL:         xdef    cs_fill,cs_over,cs_pan,cs_recol,cs_scrol */
.globl cs_fill,cs_over,cs_pan,cs_recol,cs_scrol
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
/* QL: reg_list reg    d0-d7/a0-a6 */
/* QL:         offset  0 ; positions on stack */
/* QL:         ds.l    3 */
/* QL: spd3    ds.l    1 */
.equ spd3,12
/* QL: spd4    ds.l    1 */
.equ spd4,16
/* QL:         section cs_area */
.section cs_area,"ax"
/* QL: * d0 c p x origin */
/* QL: * d1 c p y origin */
/* QL: * d2 c p width */
/* QL: * d3 c p height */
/* QL: * d4 c p distance to scroll or pan */
/* QL: * a1 c p pointer to colour masks */
/* QL: * Internal register usage */
/* QL: * d0-d2   scratch */
/* QL: * d3      width in long words -1 (=a5/4) */
/* QL: * d4      left hand edge mask */
/* QL: * d5      right hand edge mask */
/* QL: * d6      one stipple row colour */
/* QL: * d7      the other stipple row colour */
/* QL: * a0      channel definition block (i hope! lwr) */
/* QL: * a1      origin of area / running pointer to destination */
/* QL: * a2      end of area */
/* QL: * a3      increment between lines */
/* QL: * a4      running pointer to source */
/* QL: * a5      width -4 (=d3*4) */
/* QL: * a6      address of operation routine */
/* QL: * Set up the colour masks in d6/d7 */
/* QL: set_colm */
set_colm:
/* QL:         move.l  (a1),d6         get even lines in upper, odd in lower word */
    move.l (a1),d6
/* QL:         move.w  d6,d7 */
    move.w d6,d7
/* QL:         swap    d7 */
    swap d7
/* QL:         move.w  d6,d7           put odd lines in both halves of d7 */
    move.w d6,d7
/* QL:         move.w  (a1),d6         put even lines in both halves of d6 */
    move.w (a1),d6
/* QL:         btst    #0,d1 */
    btst #0,d1
/* QL:         bne.s   set_addr */
    bne.s set_addr
/* QL:         exg     d6,d7           if even nline - swap them over */
    exg d6,d7
/* QL: * Set up all the registers for addressing an area */
/* QL: set_addr */
set_addr:
/* QL:         add.w   d0,d2           find rhs */
    add.w d0,d2
/* QL:         move.w  sd_linel(a0),a3 get line length */
    move.w sd_linel(a0),a3
/* QL:         move.w  a3,d5 */
    move.w a3,d5
/* QL:         mulu    d5,d1           set y address offset */
    mulu d5,d1
/* QL:         move.l  sd_scrb(a0),a1  + base of screen */
    move.l sd_scrb(a0),a1
/* QL:         add.l   d1,a1 */
    add.l d1,a1
/* QL:         mulu    d5,d3           find end of screen */
    mulu d5,d3
/* QL:         move.l  d3,a2 */
    move.l d3,a2
/* QL:         move.w  d2,d3 */
    move.w d2,d3
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         asr.w   #4,d3           rhs rounded down to long words */
    asr.w #4,d3
/* QL:         move.w  d0,d4 */
    move.w d0,d4
/* QL:         lsr.w   #4,d4           x origin in longwords */
    lsr.w #4,d4
/* QL:         sub.w   d4,d3           length less one */
    sub.w d4,d3
/* QL:         move.w  d3,a5 */
    move.w d3,a5
/* QL:         add.w   a5,a5 */
    add.w a5,a5
/* QL:         add.w   a5,a5           set length less one longword in bytes */
    add.w a5,a5
/* QL:         lsl.w   #2,d4           x origin in bytes */
    lsl.w #2,d4
/* QL:         add.w   d4,a1           add to base */
    add.w d4,a1
/* QL:         add.l   a1,a2           and add base to offset of lower edge */
    add.l a1,a2
/* QL:         bsr.s   mask            calc rhs mask */
    bsr.s mask
/* QL:         move.w  d0,d2           next will be lhs mask */
    move.w d0,d2
/* QL:         neg.w   d5 */
    neg.w d5
/* QL:         move.w  d5,d0           keep a copy of negated linel for scroll */
    move.w d5,d0
/* QL:         move.l  d4,d5           set rhs mask */
    move.l d4,d5
/* QL:         not.l   d5              invert rhs mask */
    not.l d5
/* QL:         bne.s   mask            if not all outside, go set lhs */
    bne.s mask
/* QL:         moveq   #-1,d5          make rhs all ones */
    moveq #(-1),d5
/* QL: mask */
mask:
/* QL:         moveq   #-1,d4          fill mask */
    moveq #(-1),d4
/* QL:         and.w   #15,d2          use least significant 4 bits of position */
    and.w #15,d2
/* QL:         lsr.w   d2,d4           shift to form mask ffab */
    lsr.w d2,d4
/* QL:         move.w  d4,d2           save ab */
    move.w d4,d2
/* QL:         lsl.l   #8,d4           mask -> fab0 */
    lsl.l #8,d4
/* QL:         move.w  d2,d4           -> faab */
    move.w d2,d4
/* QL:         lsl.l   #8,d4           -> aab0 */
    lsl.l #8,d4
/* QL:         move.b  d2,d4           -> aabb */
    move.b d2,d4
/* QL:         rts */
    rts 
/* QL: cs_over */
cs_over:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   set_colm        set up colour masks and pointers */
    bsr.s set_colm
/* QL:         lea     over_op,a6      set up over operation address */
    lea over_op(pc),a6
/* QL:         tst.w   d3              longword count minus one */
    tst.w d3
/* QL:         bne.s   area_c_1        more than one - OK */
    bne.s area_c_1
/* QL:         and.l   d5,d4           just one - superimpose lhs and rhs masks */
    and.l d5,d4
/* QL:         bra.s   area_c_1 */
    bra.s area_c_1
/* QL: set_cm_1 */
set_cm_1:
/* QL:         bra.s   set_colm */
    bra.s set_colm
/* QL: cs_recol */
cs_recol:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         move.l  a1,a4           save pointer to remap */
    move.l a1,a4
/* QL:         bsr.s   set_addr        set scan pointers etc. */
    bsr.s set_addr
/* QL:         add.w   d3,d3           remap operates on words */
    add.w d3,d3
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL:         btst    #3,sv_mcsta(a6) check display mode */
    btst #3,sv_mcsta(a6)
/* QL:         lea     rmap4_op,a6     set 4 colour mode */
    lea rmap4_op(pc),a6
/* QL:         beq.s   area_c_1 */
    beq.s area_c_1
/* QL:         lea     rmap8_op,a6     set 8 colour mode */
    lea rmap8_op(pc),a6
/* QL: area_c_1 */
area_c_1:
/* QL:         bra.s   area_com */
    bra.s area_com
/* QL: cs_scrol */
cs_scrol:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   set_cm_1        set up colour masks and pointers */
    bsr.s set_cm_1
/* QL:         move.w  spd4+2(sp),d2   get displacement */
    move.w (spd4+2)(sp),d2
/* QL:         muls    d0,d2           scale up by negated line length */
    muls d0,d2
/* QL:         bgt.s   up              scroll pixels down? */
    bgt.s up
/* QL:         exg     a2,a1           operate the other way */
    exg a1,a2
/* QL:         move.w  d0,a3           use negated line length */
    move.w d0,a3
/* QL:         add.l   a3,a1           adjust where we write */
    add.l a3,a1
/* QL:         add.l   a3,a2 */
    add.l a3,a2
/* QL:         btst    #0,spd3+3(sp)   ensure that colour masks are right way */
    btst #0,(spd3+3)(sp)
/* QL:         bne.s   set_dn          odd height is ok */
    bne.s set_dn
/* QL:         exg     d6,d7 */
    exg d6,d7
/* QL: set_dn */
set_dn:
/* QL:         lea     0(a1,d2.l),a4   set source address */
    lea 0(a1,d2.l),a4
/* QL:         cmp.l   a4,a2 */
    cmp.l a4,a2
/* QL:         bra.s   scroll */
    bra.s scroll
/* QL: up */
up:
/* QL:         lea     0(a1,d2.l),a4   set source address */
    lea 0(a1,d2.l),a4
/* QL:         cmp.l   a2,a4 */
    cmp.l a2,a4
/* QL: scroll */
scroll:
/* QL:         bge.s   fill            no area left */
    bge.s fill
/* QL:         lea     scrol_op,a6     set scroll operation address */
    lea scrol_op(pc),a6
/* QL:         sub.l   d2,a2           reduced area */
    sub.l d2,a2
/* QL:         bsr     area_op */
    bsr area_op
/* QL:         add.l   d2,a2           restore end address */
    add.l d2,a2
/* QL:         bra.s   fill            and fill rest of area */
    bra.s fill
/* QL: cs_fill */
cs_fill:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   set_cm_1        set up colour masks */
    bsr.s set_cm_1
/* QL: fill */
fill:
/* QL:         lea     fill_op,a6      set up fill operation address */
    lea fill_op(pc),a6
/* QL:         bra.s   area_com */
    bra.s area_com
/* QL: cs_pan */
cs_pan:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   set_cm_1        set up colour masks and pointers */
    bsr.s set_cm_1
/* QL:         swap    d3              save width counter in msw */
    swap d3
/* QL:         move.w  #-16,d3         mask for setting shift length */
    move.w #(-16),d3
/* QL:         move.w  #4,a0           pointers go up, maybe */
    move.w #4,a0
/* QL:         move.w  spd4+2(sp),d2   get displacement */
    move.w (spd4+2)(sp),d2
/* QL:         bpl.s   right */
    bpl.s right
/* QL:         neg.w   d2 */
    neg.w d2
/* QL:         or.w    d2,d3           (-displacement) mod 16 - 16 */
    or.w d2,d3
/* QL:         neg.w   d3              16 - (-displacement) mod 16 */
    neg.w d3
/* QL:         swap    d3              shift to msw */
    swap d3
/* QL:         lsr.w   #4,d2           and horizontal offset in d2 */
    lsr.w #4,d2
/* QL:         cmp.w   d2,d3           is there anything left to pan? */
    cmp.w d2,d3
/* QL:         bcs.s   fill            just clear it */
    bcs.s fill
/* QL:         sub.w   d2,d3           else reduce length */
    sub.w d2,d3
/* QL: pan_go */
pan_go:
/* QL:         lsl.w   #2,d2           back to byte count */
    lsl.w #2,d2
/* QL:         lea     0(a1,d2.w),a4   set the source */
    lea 0(a1,d2.w),a4
/* QL:         addq.w  #1,d3           adjust long word count */
    addq.w #1,d3
/* QL:         lea     pan_op,a6 */
    lea pan_op(pc),a6
/* QL: area_com */
area_com:
/* QL:         bsr.s   area_op */
    bsr.s area_op
/* QL:         movem.l (sp)+,reg_list  restore all registers */
    movem.l (sp)+,d0-d7/a0-a6
/* QL: area_rts */
area_rts:
/* QL:         rts */
    rts 
/* QL: right */
right:
/* QL:         or.w    d2,d3           displacement mod 16 - 16 */
    or.w d2,d3
/* QL:         and.w   #$1f,d3         16 + displacement mod 16 */
    and.w #0x1f,d3
/* QL:         swap    d3              in msw of d3 */
    swap d3
/* QL:         lsr.w   #4,d2           find the long word shift */
    lsr.w #4,d2
/* QL:         cmp.w   d2,d3           anything left to pan? */
    cmp.w d2,d3
/* QL:         bcs.s   fill            just clear it */
    bcs.s fill
/* QL:         sub.w   d2,d3           else reduce the length */
    sub.w d2,d3
/* QL:         exg     a5,d0           negate the length */
    exg a5,d0
/* QL:         neg.l   d0 */
    neg.l d0
/* QL:         exg     d0,a5 */
    exg d0,a5
/* QL:         exg     d4,d5           swap the masks */
    exg d4,d5
/* QL:         subq.w  #8,a0           go backwards */
    subq.w #8,a0
/* QL:         sub.w   a5,a1           from other end */
    sub.w a5,a1
/* QL:         sub.w   a5,a2 */
    sub.w a5,a2
/* QL:         neg.w   d2              negate shift count */
    neg.w d2
/* QL:         bra.s   pan_go */
    bra.s pan_go
/* QL: * Now for the general area operation */
/* QL: op_retrn */
op_retrn:
/* QL:         subq.l  #4,a1           backspace to end of line */
    subq.l #4,a1
/* QL: op_retx */
op_retx:
/* QL:         move.l  (a1),d0         get the long word written */
    move.l (a1),d0
/* QL:         and.l   d5,d0           mask it */
    and.l d5,d0
/* QL:         move.l  d5,d1           move mask */
    move.l d5,d1
/* QL:         not.l   d1              negate */
    not.l d1
/* QL:         and.l   (sp)+,d1        mask old contents */
    and.l (sp)+,d1
/* QL:         or.l    d1,d0           combine the bits */
    or.l d1,d0
/* QL:         move.l  d0,(a1)         and put edge back */
    move.l d0,(a1)
/* QL: * Now restore left hand edge (can save 6 bytes if following code is subroutine) */
/* QL:         sub.l   a5,a1           goto left hand edge */
    sub.l a5,a1
/* QL:         move.l  (a1),d0         get the long word written */
    move.l (a1),d0
/* QL:         and.l   d4,d0           mask it */
    and.l d4,d0
/* QL:         move.l  d4,d1           get the mask */
    move.l d4,d1
/* QL:         not.l   d1 */
    not.l d1
/* QL:         and.l   (sp)+,d1        negate mask with old contents */
    and.l (sp)+,d1
/* QL:         or.l    d1,d0           combine the bits */
    or.l d1,d0
/* QL:         move.l  d0,(a1)         and put edge back */
    move.l d0,(a1)
/* QL:         add.l   a3,a1           move to next line */
    add.l a3,a1
/* QL: area_op */
area_op:
/* QL:         cmp.l   a2,a1           is it end? */
    cmp.l a2,a1
/* QL:         beq.s   area_rts */
    beq.s area_rts
/* QL:         move.w  d3,d0           set loop count */
    move.w d3,d0
/* QL:         bmi.s   area_rts        oops */
    bmi.s area_rts
/* QL:         exg     d6,d7           next line is next colour */
    exg d6,d7
/* QL:         move.l  (a1),-(sp)      save left hand edge */
    move.l (a1),-(sp)
/* QL:         move.l  0(a1,a5.w),-(sp) save right hand edge */
    move.l 0(a1,a5.w),-(sp)
/* QL:         jmp     (a6)            do line operation */
    jmp (a6)
/* QL: fill_op */
fill_op:
/* QL:         move.l  d6,(a1)+        put in colour */
    move.l d6,(a1)+
/* QL:         dbra    d0,fill_op      until end of op */
    dbra d0,fill_op
/* QL:         bra.s   op_retrn */
    bra.s op_retrn
/* QL: * Over is treated specially to stop the cursor flickering so much the first and */
/* QL: * last dword are masked before xoring-in. */
/* QL: * This frig is not nearly so simple for the other operations! */
/* QL: over_op */
over_op:
/* QL:         move.l  d4,d1           do first dword always */
    move.l d4,d1
/* QL:         and.l   d6,d1           d1 has exor colour masked with start-window */
    and.l d6,d1
/* QL:         eor.l   d1,(a1)+ */
    eor.l d1,(a1)+
/* QL:         subq.w  #1,d0           if only one dword, that's it */
    subq.w #1,d0
/* QL:         bmi.s   op_retrn */
    bmi.s op_retrn
/* QL:         bra.s   over_skip */
    bra.s over_skip
/* QL: over_loop */
over_loop:
/* QL:         eor.l   d6,(a1)+        xor in dwords 2 to n-1 if required */
    eor.l d6,(a1)+
/* QL: over_skip */
over_skip:
/* QL:         dbra    d0,over_loop */
    dbra d0,over_loop
/* QL:         move.l  d5,d1           do last dword if required */
    move.l d5,d1
/* QL:         and.l   d6,d1           mask in start/end mask to colour change word */
    and.l d6,d1
/* QL:         eor.l   d1,(a1)+ */
    eor.l d1,(a1)+
/* QL:         bra.s   op_retrn */
    bra.s op_retrn
/* QL: scrol_op */
scrol_op:
/* QL:         lea     0(a1,d2.l),a4   set source address */
    lea 0(a1,d2.l),a4
/* QL:         addq.w  #1,d0           put it back to a simple count */
    addq.w #1,d0
/* QL:         moveq   #3,d1           speed up by widening loop to 16 bytes at a go */
    moveq #3,d1
/* QL:         and.b   d0,d1           pick off two lsb's */
    and.b d0,d1
/* QL:         neg.w   d1              negate them */
    neg.w d1
/* QL:         add.w   d1,d1           and double for entry point to loop */
    add.w d1,d1
/* QL:         lsr.w   #2,d0           divide count by four */
    lsr.w #2,d0
/* QL:         jmp     scrol_lp+8(pc,d1.w) enter loop at neat place */
.word 0x4efb
.word 4096|(((scrol_lp+8)-.)&255)
/* QL: scrol_lp */
scrol_lp:
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         dbra    d0,scrol_lp     until end of op */
    dbra d0,scrol_lp
/* QL: op_ret_1 */
op_ret_1:
/* QL:         bra.s   op_retrn */
    bra.s op_retrn
/* QL: rmap8_op */
rmap8_op:
/* QL:         move.b  (a1),d6         fetch green and flash bits */
    move.b (a1),d6
/* QL:         move.b  1(a1),d7        red/blue byte */
    move.b 1(a1),d7
/* QL:         lsl.w   #8,d7           in bits 15..8 */
    lsl.w #8,d7
/* QL:         swap    d0              save loop count in top of d0 */
    swap d0
/* QL:         move.w  #4-1,d0         pixels per word */
    move.w #(4-1),d0
/* QL:         moveq   #7,d1           mask for colour index */
    moveq #7,d1
/* QL: pix8_lop */
pix8_lop:
/* QL:         moveq   #0,d2           clear working register */
    moveq #0,d2
/* QL:         move.b  d6,d2           get green/flash */
    move.b d6,d2
/* QL:         roxr.b  #2,d2           green bit to extend */
    roxr.b #2,d2
/* QL:         move.w  d7,d2           red/blue to d2 bits 9,8 */
    move.w d7,d2
/* QL:         ror.w   #2,d2           bits 7,6 */
    ror.w #2,d2
/* QL:         roxl.b  #3,d2           grb to d2 bits 2,1,0 */
    roxl.b #3,d2
/* QL:         and.w   d1,d2           mask to 0..7 */
    and.w d1,d2
/* QL:         move.b  0(a4,d2.w),d7   get new colour */
    move.b 0(a4,d2.w),d7
/* QL:         ror.w   #2,d7           shift round red/blue */
    ror.w #2,d7
/* QL:         ror.b   #1,d6           preserve flash bit */
    ror.b #1,d6
/* QL:         roxr.b  #1,d7           green bit into extend */
    roxr.b #1,d7
/* QL:         roxr.b  #1,d6           set new green */
    roxr.b #1,d6
/* QL:         dbra    d0,pix8_lop     take next pixel */
    dbra d0,pix8_lop
/* QL:         swap    d0              get back outer loop count to d0.w */
    swap d0
/* QL:         lsr.w   #8,d7           get green/red into correct word */
    lsr.w #8,d7
/* QL:         move.b  d6,(a1)+        put word back */
    move.b d6,(a1)+
/* QL:         move.b  d7,(a1)+ */
    move.b d7,(a1)+
/* QL:         dbra    d0,rmap8_op     next word */
    dbra d0,rmap8_op
/* QL:         bra.s   op_ret_1 */
    bra.s op_ret_1
/* QL: rmap4_op */
rmap4_op:
/* QL:         move.b  (a1),d6         fetch word */
    move.b (a1),d6
/* QL:         move.b  1(a1),d7 */
    move.b 1(a1),d7
/* QL:         moveq   #8-1,d1         pixels per word */
    moveq #(8-1),d1
/* QL: pix4_lop */
pix4_lop:
/* QL:         moveq   #0,d2           clear working register */
    moveq #0,d2
/* QL:         roxr.b  #1,d6           green bit */
    roxr.b #1,d6
/* QL:         addx.b  d2,d2           rotated into d2 */
    addx.b d2,d2
/* QL:         roxr.b  #1,d7 */
    roxr.b #1,d7
/* QL:         roxl.b  #2,d2           gr0 in bits 2,1,0 */
    roxl.b #2,d2
/* QL:         move.b  0(a4,d2.w),d2   get new colour */
    move.b 0(a4,d2.w),d2
/* QL:         add.b   d7,d7           shift d7 left again by one */
    add.b d7,d7
/* QL:         roxr.b  #2,d2           red */
    roxr.b #2,d2
/* QL:         roxr.b  #1,d7           into red */
    roxr.b #1,d7
/* QL:         add.b   d6,d6           shift d6 left again by one */
    add.b d6,d6
/* QL:         roxr.b  #1,d2           green */
    roxr.b #1,d2
/* QL:         roxr.b  #1,d6           into green */
    roxr.b #1,d6
/* QL:         dbra    d1,pix4_lop     take next pixel */
    dbra d1,pix4_lop
/* QL:         move.b  d6,(a1)+        put word back */
    move.b d6,(a1)+
/* QL:         move.b  d7,(a1)+ */
    move.b d7,(a1)+
/* QL:         dbra    d0,rmap4_op     next word */
    dbra d0,rmap4_op
/* QL:         bra.s   op_ret_1 */
    bra.s op_ret_1
/* QL: pan_op */
pan_op:
/* QL:         movem.l d6/a4-a5,-(sp)  save colour, source and width */
    movem.l d6/a4-a5,-(sp)
/* QL:         add.l   a1,a5           set pointer to rhs */
    add.l a1,a5
/* QL:         move.l  (a5),d2         overwrite rhs with background */
    move.l (a5),d2
/* QL:         and.l   d5,d2           mask in */
    and.l d5,d2
/* QL:         move.l  d5,d1           this area */
    move.l d5,d1
/* QL:         not.l   d1 */
    not.l d1
/* QL:         and.l   d6,d1           mask in colour outside */
    and.l d6,d1
/* QL:         or.l    d1,d2 */
    or.l d1,d2
/* QL:         move.l  d2,(a5) */
    move.l d2,(a5)
/* QL:         add.l   a0,a5           move a5 on to form end check */
    add.l a0,a5
/* QL:         swap    d3              get shift */
    swap d3
/* QL:         movep.w 0(a4),d1        get the first long word's worth */
    movep.w 0(a4),d1
/* QL:         movep.w 1(a4),d2 */
    movep.w 1(a4),d2
/* QL:         bra.s   pan_elop */
    bra.s pan_elop
/* QL: pan_last */
pan_last:
/* QL:         move.l  sp,a4           get last long word off stack */
    move.l sp,a4
/* QL: pan_loop */
pan_loop:
/* QL:         swap    d1              move existing contents of green */
    swap d1
/* QL:         swap    d2              and red/blue up */
    swap d2
/* QL:         movep.w 0(a4),d1        fetch new long word */
    movep.w 0(a4),d1
/* QL:         movep.w 1(a4),d2 */
    movep.w 1(a4),d2
/* QL:         move.l  d1,d6           move green to a convenient register */
    move.l d1,d6
/* QL:         ror.l   d3,d6           rotate */
    ror.l d3,d6
/* QL:         movep.w d6,0(a1)        and save it */
    movep.w d6,0(a1)
/* QL:         move.l  d2,d6           now again for red/blue */
    move.l d2,d6
/* QL:         ror.l   d3,d6 */
    ror.l d3,d6
/* QL:         movep.w d6,1(a1) */
    movep.w d6,1(a1)
/* QL:         add.l   a0,a1           move destination on */
    add.l a0,a1
/* QL: pan_elop */
pan_elop:
/* QL:         add.l   a0,a4           move source on */
    add.l a0,a4
/* QL:         subq.w  #1,d0           decrement counter */
    subq.w #1,d0
/* QL:         bgt.s   pan_loop */
    bgt.s pan_loop
/* QL:         beq.s   pan_last */
    beq.s pan_last
/* QL:         movem.l (sp)+,d6/a4     restore colour and source pointer */
    movem.l (sp)+,d6/a4
/* QL:         swap    d3              restore loop count */
    swap d3
/* QL:         bra.s   pan_efil */
    bra.s pan_efil
/* QL: pan_fill */
pan_fill:
/* QL:         move.l  d6,(a1)         fill with colour */
    move.l d6,(a1)
/* QL:         add.l   a0,a1 */
    add.l a0,a1
/* QL: pan_efil */
pan_efil:
/* QL:         cmp.l   a1,a5           end? */
    cmp.l a1,a5
/* QL:         bne.s   pan_fill */
    bne.s pan_fill
/* QL:         move.l  (sp)+,a5        restore width */
    move.l (sp)+,a5
/* QL:         add.l   a3,a4           move destination to next line */
    add.l a3,a4
/* QL:         sub.l   a0,a1           adjust running pointer */
    sub.l a0,a1
/* QL:         bra     op_retx */
    bra op_retx
/* QL:         end */
