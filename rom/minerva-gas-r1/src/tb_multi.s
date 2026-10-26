/* Generated from original/M/tb/multi.asm */
/* QL: * MultiBasic executeable serial image (for pipep device) */
/* QL:         xdef    tb_multi,tb_multx */
.globl tb_multi,tb_multx
/* QL: ut.con  equ     $c6     open a console */
.equ ut.con,0xc6
/* QL: cn.itod equ     $f2     convert integer to decimal string */
.equ cn.itod,0xf2
/* QL: sb.start equ    $154    vectored entrypoint to start up an interpreter */
.equ sb.start,0x154
/* QL: mt.inf  equ     0       get system information */
.equ mt.inf,0
/* QL: mt.frjob equ    5       force remove a job */
.equ mt.frjob,5
/* QL: io.open equ     1       open trap #2 code */
.equ io.open,1
/* QL: io.share equ    1       shared input */
.equ io.share,1
/* QL: sv_progd equ    $ac     prog_use default prefix */
.equ sv_progd,0xac
/* QL: file    equ     '>'     delimiter at end of command file name */
.equ file,62
/* QL: rom     equ     '!'     marker at end of string for forcing original rom names */
.equ rom,33
/* QL: tables  equ     $18     we'll have our tables at this offset */
.equ tables,0x18
/* QL: area    equ     $d00    we can go with just 384, but this is more sensible! */
.equ area,0xd00
/* QL: * With a bit of luck: */
/* QL: * Use qx or ex to pass channels and/or command string. */
/* QL: * If the last character of the command string is the "ROM" marker, it is */
/* QL: * removed from the string and the interpretter will start up with only the */
/* QL: * original ROM names, instead of inherited names.  */
/* QL: * The remaining command string is then scanned for the "file" marker, and if */
/* QL: * it's got it, the first part is opened as an input command channel, and the */
/* QL: * rest is shuffled down. */
/* QL: * The command string, what's left of it, becomes CMD$ in the interpreted basic. */
/* QL: * Channels passed: */
/* QL: *       none:   If no file marker in the comman string, a standard set of */
/* QL: *               windows is opened for #0, #1 and #2. */
/* QL: *       one:    Slotted in as both #0 and #1 */
/* QL: *       two:    Become #0 and #1 */
/* QL: *       more:   First two become #0 and #1, #2 is missed out, and the rest go */
/* QL: *               in as channels #3 onward. */
/* QL: * E.g. a filter to change replace strings in a file: */
/* QL: *       AUTO */
/* QL: *       i%='/'INSTR CMD$:a$='':if i%:a$=CMD$(i%+1to):CMD$=CMD$(to i%-1) */
/* QL: *       l%=LEN(CMD$) */
/* QL: *       REP lp1 */
/* QL: *        IF EOF(#0):EXIT lp1 */
/* QL: *        INPUT#3;i$:IF l% */
/* QL: *         REP lp2:i%=CMD$INSTR i$:IF i%: ... */
/* QL: *               ... PRINT i$(to i%-1);a$;:i$=i$(i%+l%to):ELSE EXIT lp2 */
/* QL: *         ENDIF:PRINT i$:ENDREP lp1 */
/* QL: * With the above as "subs" and this program as "multi", both in the program */
/* QL: * default directory, use: */
/* QL: *       EX multi,infile,outfile;'subs>fred/jim' */
/* QL: * Then all occurrances of "fred" in the source file "infile" will be replaced, */
/* QL: * creating the new file in "outfile", where these files are in the default data */
/* QL: * directory. */
/* QL: * A further tweak is permitted: we may even tell the new interpreter to use a */
/* QL: * specified set of m/c names by giving it a positive value in register a1. */
/* QL: * This option is just a bit wierd and we don't support it at the moment. */
/* QL: * We have to be able to find the tables in an interpretted job, other than job */
/* QL: * zero, so we've invented a system: */
/* QL: *       Word two must have the offset of the tables in it. */
/* QL: * Note: MultiBasics cannot be re-activated, the vector entry sorts this out. */
/* QL: * If no channels or command string at all are passed in, we do a default case */
/* QL: * which is marginally more friendly than always getting the default windows. */
/* QL: * We construct a single window in one of several screen positions dependant on */
/* QL: * the job number. This is made to become both channels #0 and #1. */
/* QL: * The windows are small, but just about give you enough to work with. */
/* QL: * They are such that they do not overlap one another, and they all fit inside */
/* QL: * the TV default channel #1/#2 area; convenient for an unexpanded m/c. */
/* QL: * We let them have an extra pixel row and column versus the exact character */
/* QL: * grid, as this means normal characters do not ever touch the borders. */
/* QL: * With the above constraints, 2*n windows are what we go for; two across, and n */
/* QL: * down the screen. */
/* QL: n       equ     3               windows down the screen (1..15 will work) */
.equ n,3
/* QL: * the way thing go, changing n to 1, 2, 3, 4, 6, 8 and 15 windows will give 19, */
/* QL: * 9, 6, 4, 3, 2 and one lines for each window respectively. */
/* QL: * Notes on "hotkey"'ing programs.... */
/* QL: * When a program is hotkey'ed, what happens is that the program code is stored */
/* QL: * in a RESPR or common heap area, then when it is required to execute, an */
/* QL: * appropriate area is acquired in the transient area, a long jump to the start */
/* QL: * of the program code is stored taking 6 bytes. This is followed by the job */
/* QL: * name, prefixed by its length, and possible a padding byte to get on an even */
/* QL: * boundary. The remaining transient area is a data area as demanded by the job. */
/* QL: * This code is then initiated in a standard fashion, so that a6 will be a */
/* QL: * pointer to long jump and a4/a5 are the offsets to the bottom/top of the data */
/* QL: * area. The program counter starts at a6, but then immediately jumps off into */
/* QL: * the code stored in the common heap or resident area. */
/* QL: * This code here is very careful not to confuse the meaning of a6 and pc, */
/* QL: * which will differ for shared code as above. */
/* QL: * One warning... to avoid getting really terribly clever, and to make the */
/* QL: * offset from job start to a6 into a neat $80, this code is rather locked into */
/* QL: * not having too long a start job name. Don't use the very clever Qpac2 idea of */
/* QL: * supplying a new job name, unless it's less than 12 chars long! */
/* QL: * You can patch the inbuilt job name to anything between 0 and 4 characters. */
/* QL:         section tb_multi */
.section tb_multi,"ax"
/* QL:         ds.b    1               padding */
.space (1)*1,0
/* QL: tb_multi */
tb_multi:
/* QL:         dc.b    -1              serial channel $ff prefix */
dc_anchor_106:
.byte ((-1))&255
/* QL:         dc.l    tb_multx-multi  length of code */
.balign 2,0
dc_anchor_110:
.long (tb_multx-multi)
/* QL:         dc.b    0               access code (unused) */
dc_anchor_113:
.byte (0)&255
/* QL:         dc.b    1               executeable */
dc_anchor_116:
.byte (1)&255
/* QL:         dc.l    base+area-tb_multx data space */
.balign 2,0
dc_anchor_120:
.long ((base+area)-tb_multx)
/* QL:         dc.l    0               extra */
.balign 2,0
dc_anchor_124:
.long 0
/* QL: multi */
multi:
/* QL:         moveq   #mt.inf,d0      get our job number */
    moveq #mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         bra.s   base            go start setting up */
    bra.s base
/* QL:         dc.w    $4afb,nmex-name */
.balign 2,0
dc_anchor_136:
.word 0x4afb
.word ((nmex-name))&65535
/* QL: name */
name:
/* QL:         dc.b    'SB.' we append our job number to this */
dc_anchor_142:
.byte 83,66,46
/* QL: nmex    ds.b    0 */
nmex:
/* QL:         ds.w    0 */
.balign 2,0
/* QL: base */
base:
/* QL:         move.l  sv_progd(a0),a3 we may like to use the prog_use prefix */
    move.l sv_progd(a0),a3
/* QL:         moveq   #0,d6 */
    moveq #0,d6
/* QL:         move.w  d1,d6           we'll use this in case we default setup */
    move.w d1,d6
/* QL:         divu    #2*n,d6         job mod possible default windows */
    divu #(2*n),d6
/* QL:         swap    d6 */
    swap d6
/* QL:         move.w  #name-multi,a0 */
    move.w #(name-multi),a0
/* QL:         add.w   -2(a6,a0.l),a0 */
    add.w (-2)(a6,a0.l),a0
/* QL:         move.w  #tables-2,a1    we will overwrite our code */
    move.w #(tables-2),a1
/* QL:         move.w  cn.itod,a2 */
    move.w cn.itod,a2
/* QL:         move.w  d1,0(a6,a1.l) */
    move.w d1,0(a6,a1.l)
/* QL: * NB. This had better be >= multi+tables now! */
/* QL:         jsr     (a2)            extend job name with job number */
    jsr (a2)
/* QL:         add.w   d1,name-2-multi(a6) a little used fact: d1 returns char count! */
    add.w d1,((name-2)-multi)(a6)
/* QL:         move.l  a1,(a6)         put table offset at start of job + 2 */
    move.l a1,(a6)
/* QL:         add.l   a1,a6           push on past base of our transient area */
    add.l a1,a6
/* QL:         sub.l   a1,a5           discount it from the data area */
    sub.l a1,a5
/* QL:         tst.l   (sp)            have we been given anything at all? */
    tst.l (sp)
/* QL:         bne.s   useit           yes - they've got TK2 or somesuch */
    bne.s useit
/* QL: * Zilch being passed in, so let's be nice, and give them some defaults */
/* QL:         moveq   #32,d1 */
    moveq #32,d1
/* QL:         lsr.w   #1,d6 */
    lsr.w #1,d6
/* QL:         bcc.s   xset */
    bcc.s xset
/* QL:         lsl.w   #3,d1 32<<3=256 x position 32(even)/256(odd) */
    lsl.w #3,d1
/* QL: xset */
xset:
/* QL: h       equ     (200/n-3)/10*10+3 height of windows, including border */
.equ h,(((((200/n)-3)/10)*10)+3)
/* QL: g       equ     (202-h*n)/(n+1) gaps between windows */
.equ g,((202-(h*n))/(n+1))
/* QL:         mulu    #h+g,d6 */
    mulu #(h+g),d6
/* QL:         add.w   #16+(200-h*n-g*(n-1))/2,d6 top window y position */
    add.w #(16+(((200-(h*n))-(g*(n-1)))/2)),d6
/* QL:         move.w  d6,(sp)         set y */
    move.w d6,(sp)
/* QL:         move.w  d1,-(sp)        set x */
    move.w d1,-(sp)
/* QL:         move.l  #222<<16!h,-(sp) set width and height */
    move.l #((222<<16)|h),-(sp)
/* QL:         move.l  #$ff010207,-(sp) set border colour/width, paper and ink */
    move.l #0xff010207,-(sp)
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         move.w  ut.con,a2 */
    move.w ut.con,a2
/* QL:         jsr     (a2) */
    jsr (a2)
/* QL:         bne.s   err */
    bne.s err
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL:         move.l  a0,(sp) */
    move.l a0,(sp)
/* QL:         move.w  #1,-(sp) */
    move.w #1,-(sp)
/* QL:         bra.s   nochan */
    bra.s nochan
/* QL: useit */
useit:
/* QL:         move.l  sp,a4 */
    move.l sp,a4
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         move.w  (a4)+,d4        pick up channel count */
    move.w (a4)+,d4
/* QL:         lsl.l   #2,d4 */
    lsl.l #2,d4
/* QL:         add.l   d4,a4           move on past them */
    add.l d4,a4
/* QL:         move.l  a4,a2           remember start of command string */
    move.l a4,a2
/* QL:         move.w  (a4)+,d4        get command string length */
    move.w (a4)+,d4
/* QL:         cmp.b   #rom,-1(a4,d4.w) are we being asked not to do rom names? */
    cmp.b #(rom&255),(-1)(a4,d4.w)
/* QL:         seq     d5 */
    seq d5
/* QL:         ext.w   d5 */
    ext.w d5
/* QL:         add.w   d5,d4           no - set a zero */
    add.w d5,d4
/* QL:         move.w  d4,(a2)         yes - lose the byte and leave a minus one */
    move.w d4,(a2)
/* QL: sclp */
sclp:
/* QL:         subq.w  #1,d4 */
    subq.w #1,d4
/* QL:         bcs.s   nochan          didn't find our file marker */
    bcs.s nochan
/* QL:         cmp.b   #file,(a4)+     is this our file marker? */
    cmp.b #(file&255),(a4)+
/* QL:         bne.s   sclp            no - keep looking */
    bne.s sclp
/* QL: * File marker found, d4 has remaining string length */
/* QL:         sub.w   d4,(a2)         the filename length plus the file marker */
    sub.w d4,(a2)
/* QL:         subq.w  #1,(a2)         so this is the filename length */
    subq.w #1,(a2)
/* QL:         move.l  a2,a0           set filename start */
    move.l a2,a0
/* QL:         bsr.s   open            try to open plain name */
    bsr.s open
/* QL:         beq.s   gotit           if ok, go use it */
    beq.s gotit
/* QL:         move.l  a6,a0           fill it in down where out tables will go */
    move.l a6,a0
/* QL:         moveq   #127,d2         silly upper limit on file name */
    moveq #127,d2
/* QL:         move.w  d2,(a0)+        first put in the limit value */
    move.w d2,(a0)+
/* QL:         bsr.s   concat          start with the default prefix */
    bsr.s concat
/* QL: * Upper limit on file name is really (*-base-2), but that's more than 127! */
/* QL:         move.l  a2,a3 */
    move.l a2,a3
/* QL:         bsr.s   concat          then add the plain name */
    bsr.s concat
/* QL:         move.l  a6,a0 */
    move.l a6,a0
/* QL:         sub.w   d2,(a0)         this is now the concatenated name length */
    sub.w d2,(a0)
/* QL:         bsr.s   open            try to open prefixed name */
    bsr.s open
/* QL:         bne.s   err             no good, so we'll have to die! */
    bne.s err
/* QL: gotit */
gotit:
/* QL:         move.w  d4,(a2)+        cut string length back to what's left */
    move.w d4,(a2)+
/* QL: shlp */
shlp:
/* QL:         subq.b  #1,d4 */
    subq.b #1,d4
/* QL:         bcs.s   basic */
    bcs.s basic
/* QL:         move.b  (a4)+,(a2)+     copy remaining command string down */
    move.b (a4)+,(a2)+
/* QL:         bra.s   shlp */
    bra.s shlp
/* QL: nochan */
nochan:
/* QL:         sub.l   a0,a0           no command channel */
    sub.l a0,a0
/* QL: basic */
basic:
/* QL:         move.w  d5,a1           set inherit(0) or rom(-ve) names */
    move.w d5,a1
/* QL:         move.w  sb.start,a2     get entry vector */
    move.w sb.start,a2
/* QL:         jmp     $4000(a2)       a0/a5-a7 are set, so run off to basic! */
    jmp 0x4000(a2)
/* QL: open */
open:
/* QL:         moveq   #-1,d1          we'll own it */
    moveq #(-1),d1
/* QL:         moveq   #io.open,d0 */
    moveq #io.open,d0
/* QL:         moveq   #io.share,d3 */
    moveq #io.share,d3
/* QL:         trap    #2 */
    trap #2
/* QL:         move.l  d0,d3           was the file opened ok? */
    move.l d0,d3
/* QL:         rts */
    rts 
/* QL: concat */
concat:
/* QL:         move.w  (a3)+,d0        get length */
    move.w (a3)+,d0
/* QL:         sub.w   d0,d2 */
    sub.w d0,d2
/* QL:         bge.s   ccent */
    bge.s ccent
/* QL: err */
err:
/* QL:         moveq   #-1,d1          ourself */
    moveq #(-1),d1
/* QL:         moveq   #mt.frjob,d0    force remove job */
    moveq #mt.frjob,d0
/* QL:         trap    #1 */
    trap #1
/* QL: pcopy */
pcopy:
/* QL:         move.b  (a3)+,(a0)+ */
    move.b (a3)+,(a0)+
/* QL: ccent */
ccent:
/* QL:         dbra    d0,pcopy */
    dbra d0,pcopy
/* QL:         rts */
    rts 
/* QL: tb_multx */
tb_multx:
/* QL:         end */
