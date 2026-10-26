/* Generated from original/M/ut/cstr.asm */
/* QL: * Compares strings */
/* QL:         xdef    ut_istr,ut_cstr,ut_csstr */
.globl ut_istr,ut_cstr,ut_csstr
/* QL:         xref    pa_alfnm */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section ut_cstr */
.section ut_cstr,"ax"
/* QL: * Type is passed as the two lsb's of d0: */
/* QL: * Bit 0 is set for case insensitive */
/* QL: * Bit 1 is set to process embedded numbers (some digits and an optional point) */
/* QL: * ut_istr */
/* QL: * d0 -i o- return 0 always (ccr set) */
/* QL: * d1 -  o- zero if not found, or index where found */
/* QL: * a0 -ip - string to search for, prefixed by length */
/* QL: * a1 -ip - string to look in, prefixed by length */
/* QL: * d2-d3 destroyed */
/* QL: * ut_cstr */
/* QL: * d0 -i o- return -1 if (a0)<(a1), 0 for equality, or +ve (ccr set) */
/* QL: * a0 -ip - string to search for, prefixed by length */
/* QL: * a1 -ip - string to look in, prefixed by length */
/* QL: * ut_csstr */
/* QL: * d0 -i o- return -1 if (a0)<(a1), 0 for equality, or +ve (ccr set) */
/* QL: * d2 -ip - length of string at a0 */
/* QL: * a0 -ip - string to search for */
/* QL: * a1 -ip - string to look in, prefixed by length */
/* QL: * Characters are converted to one of the following patterns: */
/* QL: * 00000000 00000000 - end of string */
/* QL: * 00000000 00110nnn - digit, as it came in */
/* QL: * 1000000c c1ccccck - letter, original case bit forced on, k=1 for lowercase */
/* QL: * 1000000c c1ccccc1 - letter, original case bit forced on, case insensitive */
/* QL: * 1111111x xxxxxxxx - other character, more high bits set by adding $ff00-'.'. */
/* QL: * Order is unsigned. */
/* QL: * Note that digits are recognised by being words greater than zero. */
/* QL: * Note that decimal point is semi-recognised by the lsb being zero, as it */
/* QL: * happens, the code sorts out the difference between it and end of string. */
/* QL: * General register usage: */
/* QL: * d0   type in bit 1..0 / 1 or -1 inside / return as -1, 0 or 1 (.l) + ccr */
/* QL: * d1.w processed character from main string */
/* QL: * d2   working register */
/* QL: * d3.w processed character from other string */
/* QL: * d4.w mask sets char to standard case, maybe preserving case distinction */
/* QL: * d5   odd useful short-term constants */
/* QL: * d6   save end of searched string */
/* QL: * a0   pointer to main string */
/* QL: * a1   pointer to other string */
/* QL: * a2   end of main string */
/* QL: * a3   end of other string */
/* QL: * a4   address of comparison state-routine */
/* QL: * a5   points to get_char throughout */
/* QL: * a6   base address of strings */
/* QL: * a0 -i o- points to char (a6,a0.l) and always incremented */
/* QL: * a2 -ip - end-of-string */
/* QL: * d1 -  o- set to character with shift and translate */
/* QL: * d4 -ip - mask for setting bits in letter codes */
/* QL: * d2.l destroyed */
/* QL: get_char */
get_char:
/* QL:         moveq   #0,d1           char value for string end (sorted first) */
    moveq #0,d1
/* QL:         cmp.l   a2,a0           off end of string? */
    cmp.l a2,a0
/* QL:         bge.s   get_done        yes, then return the special value */
    bge.s get_done
/* QL:         jsr     pa_alfnm(pc)    find mode of 1st char into d2 */
    jsr pa_alfnm(pc)
/* QL:         ; d1.l has character    d1: 00000000 cccccccc */
/* QL:         ; d2.l has mode, 0=digit, 1=uppercase, 2=other, 3=lowercase */
/* QL:         ; ccr: z for digit, c for alpha */
/* QL:         bcs.s   get_alpha       go do bits for alpha */
    bcs.s get_alpha
/* QL:         beq.s   get_done        digits are left as they come (+ve, >0) */
    beq.s get_done
/* QL:         add.w   #$ff00-'.',d1   d1: 1111111x xxxxxxxx */
    add.w #(0xff00-46),d1
/* QL: get_done */
get_done:
/* QL:         addq.l  #1,a0           point to next character in/past string */
    addq.l #1,a0
/* QL:         rts                     (above ensures we can backtrack easily) */
    rts 
/* QL: get_alpha */
get_alpha:
/* QL:         asr.b   #2,d2           put case (0=upper, 1=lower) into x */
    asr.b #2,d2
/* QL:         addx.w  d1,d1           d1: 0000000c ccccccck  */
    addx.w d1,d1
/* QL:         or.w    d4,d1           d1: 1000000c c1ccccck */
    or.w d4,d1
/* QL:         bra.s   get_done        k is clear iff case sensitive and u/c */
    bra.s get_done
/* QL: istrsave reg    d4-d6/a0-a5 */
/* QL: istrkeep reg    d1-d2/a0-a2/a4 */
/* QL: ut_istr */
ut_istr:
/* QL:         move.l  a1,d1           set starting position */
    move.l a1,d1
/* QL:         movem.l istrsave,-(sp) */
    movem.l d4-d6/a0-a5,-(sp)
/* QL:         and.b   #1,d0           meaningless to try embedded numeric */
    and.b #(1&255),d0
/* QL:         bsr.s   set_all */
    bsr.s set_all
/* QL:         move.l  a3,d6           hold onto end addr of real longer string */
    move.l a3,d6
/* QL: istr_lp */
istr_lp:
/* QL:         lea     0(a1,d2.w),a3   set string of same length as (a0) */
    lea 0(a1,d2.w),a3
/* QL:         cmp.l   d6,a3           string off end? */
    cmp.l d6,a3
/* QL:         bgt.s   not_sstr */
    bgt.s not_sstr
/* QL:         movem.l istrkeep,-(sp)  save registers we need to preserve */
    movem.l d1-d2/a0-a2/a4,-(sp)
/* QL:         bsr.s   str_comp        check substring */
    bsr.s str_comp
/* QL:         movem.l (sp)+,istrkeep  reload regs */
    movem.l (sp)+,d1-d2/a0-a2/a4
/* QL:         addq.l  #1,a1           move on to next slice */
    addq.l #1,a1
/* QL:         bne.s   istr_lp */
    bne.s istr_lp
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL: not_sstr */
not_sstr:
/* QL:         movem.l (sp)+,istrsave */
    movem.l (sp)+,d4-d6/a0-a5
/* QL:         sub.l   a1,d1 */
    sub.l a1,d1
/* QL:         moveq   #0,d0           always say no error */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * N.B. Qliberator fudges about so it can use the internal version of compare */
/* QL: * string, which doesn't require the string lengths on the front of the strings, */
/* QL: * but expects registers to have been set up. Changing "set_all" has caused some */
/* QL: * hassle, as has moving the marked code below. As a warning, all the code lines */
/* QL: * that are critical are marked with ";!" */
/* QL: set_all */
set_all:
/* QL:         move.w  0(a6,a0.l),d2   get character count */
    move.w 0(a6,a0.l),d2
/* QL:         addq.l  #2,a0           point to first char of main (look for) string */
    addq.l #2,a0
/* QL: set_2nd */
set_2nd:
/* QL:         lea     0(a0,d2.w),a2   set end pointer */
    lea 0(a0,d2.w),a2
/* QL:         move.w  0(a6,a1.l),a3   get character count */
    move.w 0(a6,a1.l),a3
/* QL:         addq.l  #2,a1           point to first char of other (look in) string */
    addq.l #2,a1
/* QL:         add.l   a1,a3           set end pointer */
    add.l a1,a3
/* QL: set_some ; the above has been done for us by Qlib ;! */
set_some:
/* QL:         move.w  #$8020,d4       letter bit and blank out case */
    move.w #0x8020,d4
/* QL:         asr.b   #1,d0           ignore case to x */
    asr.b #1,d0
/* QL:         addx.b  d4,d4           put it in ls bit of word */
    addx.b d4,d4
/* QL:         lea     get_char,a5      frequently used routine */
    lea get_char(pc),a5
/* QL:         asr.b   #1,d0           move special to x, ignore case flag to bit 8 */
    asr.b #1,d0
/* QL:         lea     c_norm,a4       for modes 0 and 1 */
    lea c_norm(pc),a4
/* QL:         bcc.s   set_done */
    bcc.s set_done
/* QL: set_spec */
set_spec:
/* QL:         lea     c_spec,a4       for modes 2 and 3 */
    lea c_spec(pc),a4
/* QL:         moveq   #9,d5           used to check for digits */
    moveq #9,d5
/* QL: set_done */
set_done:
/* QL:         rts */
    rts 
/* QL: * The routines are organised as a finite-state machine, with the state in a4. */
/* QL: * The actions to take depend on the state, and the characters encountered. */
/* QL: * notation is as follows: */
/* QL:         ; Characters: */
/* QL:         ; d - digit 0..9 */
/* QL:         ; . - the character '.' */
/* QL:         ; f - a digit, or '.' followed by a digit */
/* QL:         ; x - any non-digit character (including '.') */
/* QL:         ; ? - any character */
/* QL:         ; Actions: */
/* QL:         ; lex   - exit if unequal, or if both chars are eos. else absorb both */
/* QL:         ; >             - exit 'greater than' */
/* QL:         ; <             - exit 'less than' */
/* QL:         ; absorb        - advance string pointer */
/* QL:         ; absorb both   - advance both string pointers */
/* QL:         ; enter         - change to appropriate state */
/* QL: * Qlib: cstrsave must avoid the set of registers d1-d6/a0-a5 (MG+ ROM) ;! */
/* QL: * Much simpler entry fudging and no need to restrict our code so much. ;! */
/* QL: * Qlib checks the word at ut_istr for the MG-type movem instruction. ;! */
/* QL: qlib_comp ;! */
qlib_comp:
/* QL:         move.l  d4,d0 */
    move.l d4,d0
/* QL:         rol.l   #1,d0           put type code back into d0 bits 1..0 */
    rol.l #1,d0
/* QL:         bra.s   qlib_c1 */
    bra.s qlib_c1
/* QL: cstrsave reg    d1-d5/a0-a5     never make this d1-d6/a0-a5 ;! */
/* QL: ut_cstr ;! */
ut_cstr:
/* QL:         assert  $06 ut_cstr-qlib_comp ; for Qlib ;! */
/* original assertion: $06 ut_cstr-qlib_comp */
/* QL:         movem.l cstrsave,-(sp) ; see above for this instrn and Qlib ;! */
    movem.l d1-d5/a0-a5,-(sp)
/* QL:         bsr.s   set_all */
    bsr.s set_all
/* QL: strcom */
strcom:
/* QL:         bsr.s   str_comp */
    bsr.s str_comp
/* QL:         movem.l (sp)+,cstrsave */
    movem.l (sp)+,d1-d5/a0-a5
/* QL:         rts */
    rts 
/* QL: * New entry point: */
/* QL: * Same as ut_cstr, except that a0 points at chars and d2 has length */
/* QL: ut_csstr */
ut_csstr:
/* QL:         assert  $06 ut_cstr-qlib_comp ; for Qlib ;! */
/* original assertion: $06 ut_cstr-qlib_comp */
/* QL:         movem.l cstrsave,-(sp) ; see above for this instrn and Qlib ;! */
    movem.l d1-d5/a0-a5,-(sp)
/* QL:         bsr.s   set_2nd */
    bsr.s set_2nd
/* QL:         bra.s   strcom */
    bra.s strcom
/* QL: qlib_c1 */
qlib_c1:
/* QL:         bsr.s   set_some        Qlib already has a0-a3 ready */
    bsr.s set_some
/* QL: str_comp */
str_comp:
/* QL:         moveq   #1,d0           start up with exit code 1 for str(a0) > str(a1) */
    moveq #1,d0
/* QL:         bra.s   norm_loop */
    bra.s norm_loop
/* QL:         ; Last bit of fraction handling before we get started at the top level */
/* QL:         ; Trim off any trailing zeroes, but exit if a non-zero digit is seen */
/* QL: c_tzero */
c_tzero:
/* QL:         jsr     (a5)            absorb the '0' */
    jsr (a5)
/* QL: c_trail */
c_trail:
/* QL:         cmp.w   d5,d1           is main char '0'? */
    cmp.w d5,d1
/* QL:         beq.s   c_tzero         yes - strip trailing zeroes */
    beq.s c_tzero
/* QL:         tst.w   d1              is main char now some other digit? */
    tst.w d1
/* QL:         bgt.s   exit            yes - so main string is greater */
    bgt.s exit
/* QL:         bsr.s   set_spec        reset mode to special */
    bsr.s set_spec
/* QL:         ; Special: (type 2 and 3 comparisons, initial condition) */
/* QL:         ;       f       f       - enter digit mode e */
/* QL:         ;       ?       ?       - lex */
/* QL:         ; Numerical comparison is the special case: both strings should be */
/* QL:         ; figures to provoke this. Once numerical mode is entered, life is */
/* QL:         ; a bit simpler. */
/* QL: c_spec */
c_spec:
/* QL:         tst.w   d1              main char a digit? */
    tst.w d1
/* QL:         bgt.s   spec_1_is_digit branch if so */
    bgt.s spec_1_is_digit
/* QL:         tst.b   d1              no - does it look like a decimal point? */
    tst.b d1
/* QL:         bne.s   c_norm          no - no numerical comparison */
    bne.s c_norm
/* QL:         moveq   #-'0',d2 */
    moveq #(-48),d2
/* QL:         add.b   0(a6,a0.l),d2   look at next char */
    add.b 0(a6,a0.l),d2
/* QL:         cmp.b   d5,d2 */
    cmp.b d5,d2
/* QL:         bhi.s   c_norm          branch if not a digit */
    bhi.s c_norm
/* QL:         cmp.l   a2,a0           if the decimal point was the last of string... */
    cmp.l a2,a0
/* QL:         bge.s   c_norm          ... or it wasn't really one, carry on as usual */
    bge.s c_norm
/* QL: spec_1_is_digit */
spec_1_is_digit:
/* QL:         tst.w   d3              other char a digit? */
    tst.w d3
/* QL:         bgt.s   spec_num_mode   yes - numerical mode */
    bgt.s spec_num_mode
/* QL:         tst.b   d3              no - does it look like a decimal point? */
    tst.b d3
/* QL:         bne.s   c_norm          jump if not */
    bne.s c_norm
/* QL:         moveq   #-'0',d2 */
    moveq #(-48),d2
/* QL:         add.b   0(a6,a1.l),d2   look at next char */
    add.b 0(a6,a1.l),d2
/* QL:         cmp.b   d5,d2 */
    cmp.b d5,d2
/* QL:         bhi.s   c_norm          branch if not a digit */
    bhi.s c_norm
/* QL:         cmp.l   a3,a1           if the decimal point was the last of string... */
    cmp.l a3,a1
/* QL:         blt.s   spec_num_mode   ... or it wasn't really one, carry on as usual */
    blt.s spec_num_mode
/* QL:         ; Normal: (type 0 and 1 comparisons) */
/* QL:         ;       ?       ?       - lex */
/* QL: c_norm */
c_norm:
/* QL:         cmp.w   d3,d1           test characters */
    cmp.w d3,d1
/* QL:         bne.s   exit_ne         leave if strings different */
    bne.s exit_ne
/* QL:         tst.w   d1              end of both strings? */
    tst.w d1
/* QL:         beq.s   exit_eq         yes - equal! */
    beq.s exit_eq
/* QL: norm_loop */
norm_loop:
/* QL:         jsr     (a5)            get one string's data */
    jsr (a5)
/* QL: sw_a5_a4 */
sw_a5_a4:
/* QL:         pea     (a4)            finish by going off to current state */
    pea (a4)
/* QL:         pea     (a5)            return via get_char */
    pea (a5)
/* QL: swapall */
swapall:
/* QL:         exg     a1,a0           swap everything over */
    exg a0,a1
/* QL:         exg     a3,a2 */
    exg a2,a3
/* QL:         exg     d1,d3 */
    exg d1,d3
/* QL:         neg.w   d0              reverse result type */
    neg.w d0
/* QL:         rts */
    rts 
/* QL: c_1notd */
c_1notd:
/* QL:         tst.w   d3              is second char a digit? */
    tst.w d3
/* QL:         bgt.s   exit_lt         yes - must be less */
    bgt.s exit_lt
/* QL:         lea     c_point,a4      state change to point mode */
    lea c_point(pc),a4
/* QL:         tst.b   d1              does main char look like a decimal point? */
    tst.b d1
/* QL:         bne.s   c_dp_2          no - don't absorb it */
    bne.s c_dp_2
/* QL:         jsr     (a5)            absorb the decimal point on the main string */
    jsr (a5)
/* QL: c_dp_2 */
c_dp_2:
/* QL:         tst.b   d3              does other char look like a decimal point? */
    tst.b d3
/* QL:         beq.s   sw_a5_a4        yes - go swap, absorb, then state (c_point) */
    beq.s sw_a5_a4
/* QL:         ; Point mode: */
/* QL:         ;       d       d       - lex */
/* QL:         ;       ?       0       - absorb 0 */
/* QL:         ;       0       ?       - absorb 0 */
/* QL:         ;       ?       ?       - enter special */
/* QL: c_point */
c_point:
/* QL:         tst.w   d3              is second char a digit? */
    tst.w d3
/* QL:         ble.s   c_trail         no - go strip any zeroes left on main string */
    ble.s c_trail
/* QL:         tst.w   d1              are both the chars digits? */
    tst.w d1
/* QL:         bgt.s   c_norm          yes, so use standard comparison */
    bgt.s c_norm
/* QL:         bsr.s   swapall         swap strings */
    bsr.s swapall
/* QL:         bra.s   c_trail         no - go strip any zeroes left on other string */
    bra.s c_trail
/* QL: * Exits - finalise setting of d0 and condition codes */
/* QL: exit_eq */
exit_eq:
/* QL:         clr.w   d0 */
    clr.w d0
/* QL: exit_ne */
exit_ne:
/* QL:         bcc.s   exit */
    bcc.s exit
/* QL: exit_lt */
exit_lt:
/* QL:         neg.w   d0 */
    neg.w d0
/* QL: exit */
exit:
/* QL:         ext.l   d0              get ccr right */
    ext.l d0
/* QL:         rts */
    rts 
/* QL:         ; At this point, we know that both strings have contained numbers */
/* QL:         ; and we have not passed a decimal point on either string. */
/* QL:         ;       0?      ?       - absorb 0 */
/* QL:         ;       ?       0?      - absorb 0 */
/* QL: spec_num_mode */
spec_num_mode:
/* QL:         moveq   #'0',d5 */
    moveq #48,d5
/* QL:         bsr.s   leadzero        strip leading-zeroes */
    bsr.s leadzero
/* QL:         bsr.s   swapall         ... on both strings */
    bsr.s swapall
/* QL:         bsr.s   leadzero */
    bsr.s leadzero
/* QL:         ; The strings now do not have leading zeros at all */
/* QL:         lea     c_dig_eq,a4 */
    lea c_dig_eq(pc),a4
/* QL:         ; Digit mode equal: */
/* QL:         ;       d       d       - enter digit g/l on lex order. absorb both */
/* QL:         ;       d       x       - > */
/* QL:         ;       x       d       - < */
/* QL:         ;       .       .       - absorb both '.'; enter point mode */
/* QL:         ;       .       x       - absorb '.' - enter point mode */
/* QL:         ;       x       .       - absorb '.' - enter point mode */
/* QL:         ;       x       x       - enter special */
/* QL: c_dig_eq */
c_dig_eq:
/* QL:         tst.w   d1              is main char a digit? */
    tst.w d1
/* QL:         ble.s   c_1notd         no - go see about second char */
    ble.s c_1notd
/* QL:         tst.w   d3              is other char a digit? */
    tst.w d3
/* QL:         ble.s   exit            no - must be greater */
    ble.s exit
/* QL:         cmp.w   d3,d1           test the two digits */
    cmp.w d3,d1
/* QL:         beq.s   norm_loop       if the digits were equal, go round again */
    beq.s norm_loop
/* QL:         lea     c_dig_ne,a4     enter digits not equal state */
    lea c_dig_ne(pc),a4
/* QL:         bcs.s   c_dig_l         if less than, skip first swap */
    bcs.s c_dig_l
/* QL:         ; Digit mode not equal: */
/* QL:         ;       d       d       - absorb both */
/* QL:         ;       x       ?       - < */
/* QL:         ;       d       x       - > */
/* QL: c_dig_ne */
c_dig_ne:
/* QL:         bsr.s   swapall         need to keep strings the same way round here */
    bsr.s swapall
/* QL: c_dig_l */
c_dig_l:
/* QL:         tst.w   d1              is the main char a digit? */
    tst.w d1
/* QL:         ble.s   exit_lt         no, so other is higher */
    ble.s exit_lt
/* QL:         tst.w   d3              are both the characters digits? */
    tst.w d3
/* QL:         bgt.s   norm_loop       yes, so absorb them and continue */
    bgt.s norm_loop
/* QL:         bra.s   exit            no, main string is higher */
    bra.s exit
/* QL: * This routine strips out leading zeros from a number. */
/* QL: * At entry the string pointers always refer to a bona fide number. */
/* QL: * At exit, there are no leading zeros on the string, which may leave nothing of */
/* QL: * the number, but this is OK. */
/* QL:         ;       0?      ?       - absorb 0 */
/* QL: leaddrop */
leaddrop:
/* QL:         jsr     (a5)            absorb the zero */
    jsr (a5)
/* QL: leadzero */
leadzero:
/* QL:         cmp.w   d5,d1           is first char (or subsequent digit) a '0'? */
    cmp.w d5,d1
/* QL:         beq.s   leaddrop        yes, keep dropping them */
    beq.s leaddrop
/* QL:         rts */
    rts 
/* QL:         vect4000 ut_istr */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl ut$istr
/* QL: [o]     equ     [h]-$4000 */
.equ ut$istr,(ut_istr-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
