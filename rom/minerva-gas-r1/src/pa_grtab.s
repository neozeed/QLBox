/* Generated from original/M/pa/grtab.asm */
/* QL: * Basic parsing tables */
/* QL:         xdef    pa_grtab,pa_kytab */
.globl pa_grtab,pa_kytab
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL: * An explanation: */
/* QL: * The syntax tables start with a header of the word offsets from the base */
/* QL: * address to the entry points for the individual graphs, numbered even, */
/* QL: * starting with 2, the main entry point for a basic line. */
/* QL: * Once into a graph, the tables are byte oriented. */
/* QL: * Generally, a byte pair is seen, with the first byte indicating the syntax */
/* QL: * element to be matched, and the second byte is the offset from itself to */
/* QL: * continue at, should the match succeed. */
/* QL: * If the match fails the parsing steps past the two bytes and goes on. */
/* QL: * If the match succeeds, the offset is used. */
/* QL: * There are two special case single bytes that control the process. */
/* QL: * One is used to mark a point at which a graph should remember to return as */
/* QL: * matched, as the further alternatives are an optional part of the syntax. */
/* QL: * The second special byte marks the end of a list of alternatives and the */
/* QL: * completion of the graph. If a possible exit has been seen, the return uses */
/* QL: * the saved positions at that point and returns as matched. Otherwise it fails. */
/* QL: * There is also a special case for the second byte of a byte pair. If this is */
/* QL: * zero (i.e. points to itself), it indicates that the graph is complete at this */
/* QL: * point and must immediately return as matched. */
/* QL: * Use of the "point of no return" system of backtracking has been discontinued, */
/* QL: * as it was an overreaction to the odd couple of instances that were awkward, */
/* QL: * and they are now handled by a couple of extra graphs. */
/* QL: * The "end of graph" is coded as *-* to show it's a sorta jump. */
/* QL: * The "end of possibilities" is coded as z, for brevity. */
/* QL: * The "possible exit" is coded as q, for quit. */
/* QL: gen macro */
/* QL: xxx macro */
/* QL: * We will use <length> to sort out the four overall types of entry: */
/* QL: *       ".b" coded atom, ".l" labeled graph, ".s" symbol and ".w" keyword. */
/* QL: graph macro */
/* QL:         section pa_grtab */
.section pa_grtab,"ax"
/* QL: pa_grtab */
pa_grtab:
/* QL: gnum    setnum  $80     graph numbers and entry points         */
/* QL: q       equ     [gnum] possible exit from graph = graph plus zero */
.equ q,128
/* QL: line    graph   basic line */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ line.l,130
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_52:
.word ((line_a-pa_grtab))&65535
/* QL: odc     graph   opening definition clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ odc.l,132
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_61:
.word ((odc_a-pa_grtab))&65535
/* QL: osl     graph   opening select clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ osl.l,134
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_70:
.word ((osl_a-pa_grtab))&65535
/* QL: oc      graph   opening clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ oc.l,136
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_79:
.word ((oc_a-pa_grtab))&65535
/* QL: ;ocif    graph   entry to opening if clause (no longer used) */
/* QL: ic      graph   intermediate clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ic.l,138
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_89:
.word ((ic_a-pa_grtab))&65535
/* QL: icon    graph   entry to intermediate on clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ icon.l,140
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_98:
.word ((icon_a-pa_grtab))&65535
/* QL: ec      graph   end clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ec.l,142
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_107:
.word ((ec_a-pa_grtab))&65535
/* QL: stat    graph   statement */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ stat.l,144
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_116:
.word ((stat_a-pa_grtab))&65535
/* QL: dplst   graph   definition parameter list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ dplst.l,146
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_125:
.word ((dplst_a-pa_grtab))&65535
/* QL: rnge    graph   range */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ rnge.l,148
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_134:
.word ((rnge_a-pa_grtab))&65535
/* QL: expr    graph   expression */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ expr.l,150
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_143:
.word ((expr_a-pa_grtab))&65535
/* QL: whcon   graph   condition (part-way thro' expression) */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ whcon.l,152
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_152:
.word ((whcon_a-pa_grtab))&65535
/* QL: da      graph   dimension array list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ da.l,154
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_161:
.word ((da_a-pa_grtab))&65535
/* QL: var     graph   variable */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ var.l,156
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_170:
.word ((var_a-pa_grtab))&65535
/* QL: splst   graph   separated parameter list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ splst.l,158
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_179:
.word ((splst_a-pa_grtab))&65535
/* QL: subs    graph   subscription list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ subs.l,160
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_188:
.word ((subs_a-pa_grtab))&65535
/* QL: lit     graph   literal */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ lit.l,162
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_197:
.word ((lit_a-pa_grtab))&65535
/* QL: ongo    graph   distinguish "ON name = expr" from "ON expr GO ..." */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ongo.l,164
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_206:
.word ((ongo_a-pa_grtab))&65535
/* QL: proc    graph   distinguish "name(expr) = expr" from "name splst" (mostly) */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ proc.l,166
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_215:
.word ((proc_a-pa_grtab))&65535
/* QL: ass     graph   distingish assignment statements as far as possible */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ass.l,168
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_224:
.word ((ass_a-pa_grtab))&65535
/* QL: tosub   graph   GO TO or GO SUB, to save a little space */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ tosub.l,170
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
dc_anchor_233:
.word ((tosub_a-pa_grtab))&65535
/* QL: gnum    setnum  $40     keyword numbers */
/* QL: END     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ end.w,66
/* QL: FOR     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ for.w,68
/* QL: IF      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ if.w,70
/* QL: REP     gen.w   ; REPeat */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ rep.w,72
/* QL: SEL     gen.w   ; SELect */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ sel.w,74
/* QL: WHEN    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ when.w,76
/* QL: DEF     gen.w   ; DEFine */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ def.w,78
/* QL: PROC    gen.w   ; PROCedure */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ proc.w,80
/* QL: FN      gen.w   ; FuNction */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ fn.w,82
/* QL: GO      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ go.w,84
/* QL: TO      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ to.w,86
/* QL: SUB     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ sub.w,88
/* QL:         xxx.w   ; extra WHEN, not parsed, needed by keyword check for WHENERRor */
/* QL: gnum setnum [gnum]+2 */
/* QL: ERR     gen.w   ; ERRor */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ err.w,92
/* QL:         xxx.w   ; spare keyword (currently IF, historically EOF then END) */
/* QL: gnum setnum [gnum]+2 */
/* QL:         xxx.w   ; spare keyword (currently IF, historically INPUT then ERRor) */
/* QL: gnum setnum [gnum]+2 */
/* QL: RESTORE gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ restore.w,98
/* QL: NEXT    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ next.w,100
/* QL: EXIT    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ exit.w,102
/* QL: ELSE    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ else.w,104
/* QL: ON      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ on.w,106
/* QL: RET     gen.w   RETurn */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ret.w,108
/* QL: REMAINDER gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ remainder.w,110
/* QL: DATA    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ data.w,112
/* QL: DIM     gen.w   DIMension */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ dim.w,114
/* QL: LOC     gen.w   LOCal */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ loc.w,116
/* QL: LET     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ let.w,118
/* QL: THEN    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ then.w,120
/* QL: STEP    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ step.w,122
/* QL: REM     gen.w   REMark */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ rem.w,124
/* QL: MIST    gen.w   MISTake (reading line from file) */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ mist.w,126
/* QL: gnum    setnum  $20     symbol numbers */
/* QL: equ     gen.s   equals '=' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ equ.s,34
/* QL: col     gen.s   colon ':' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ col.s,36
/* QL: hsh     gen.s   hash '#' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ hsh.s,38
/* QL: com     gen.s   comma ',' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ com.s,40
/* QL: obr     gen.s   open bracket '(' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ obr.s,42
/* QL: cbr     gen.s   close bracket')' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ cbr.s,44
/* QL: ocb     gen.s   open curly bracket '{' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ocb.s,46
/* QL: ccb     gen.s   close curly bracket '}' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ccb.s,48
/* QL: spc     gen.s   space */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ spc.s,50
/* QL: lf      gen.s   line feed */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ lf.s,52
/* QL: gnum    setnum  $00     coded atom numbers */
/* QL: z       equ     [gnum] - end of possibilities is coded atom zero */
.equ z,0
/* QL: name    gen.b   name */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ name.b,2
/* QL: val     gen.b   value */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ val.b,4
/* QL: num     xxx.b   number - code actually duplicates the above... s/l integers? */
/* QL: gnum setnum [gnum]+2 */
/* QL: sysv    xxx.b   system variable */
/* QL: gnum setnum [gnum]+2 */
/* QL: ops     gen.b   operation symbol */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ ops.b,10
/* QL: mons    gen.b   mon-operation symbol */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ mons.b,12
/* QL: sep     gen.b   separator */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ sep.b,14
/* QL: str     gen.b   string */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ str.b,16
/* QL: txt     gen.b   text */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ txt.b,18
/* QL: linum   gen.b   line number */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ linum.b,20
/* QL: * Line graph table */
/* QL: line_a dc.b linum.b,line_b-*-1 optional line number */
line_a:
dc_anchor_437:
.byte (linum.b)&255
.byte (((line_b-dc_anchor_437)-1))&255
/* QL: line_b dc.b  odc.l,line_d-*-1 */
line_b:
dc_anchor_442:
.byte (odc.l)&255
.byte (((line_d-dc_anchor_442)-1))&255
/* QL: ;line_b dc.b  odc.l,line_f-*-1 see below */
/* QL: line_c dc.b   IF.w,line_l-*-1,osl.l,line_j-*-3,oc.l,line_d-*-5 */
line_c:
dc_anchor_448:
.byte (if.w)&255
.byte (((line_l-dc_anchor_448)-1))&255
.byte (osl.l)&255
.byte (((line_j-dc_anchor_448)-3))&255
.byte (oc.l)&255
.byte (((line_d-dc_anchor_448)-5))&255
/* QL:        dc.b    ELSE.w,line_c-*-1,ic.l,line_d-*-3,ec.l,line_d-*-5 */
dc_anchor_456:
.byte (else.w)&255
.byte (((line_c-dc_anchor_456)-1))&255
.byte (ic.l)&255
.byte (((line_d-dc_anchor_456)-3))&255
.byte (ec.l)&255
.byte (((line_d-dc_anchor_456)-5))&255
/* QL:        dc.b     stat.l,line_d-*-1 */
dc_anchor_464:
.byte (stat.l)&255
.byte (((line_d-dc_anchor_464)-1))&255
/* QL: line_d dc.b      col.s,line_c-*-1 */
line_d:
dc_anchor_469:
.byte (col.s)&255
.byte (((line_c-dc_anchor_469)-1))&255
/* QL: line_e dc.b       lf.s,*-*,z */
line_e:
dc_anchor_474:
.byte (lf.s)&255
.byte ((dc_anchor_474-dc_anchor_474))&255
.byte (z)&255
/* QL: ;line_f dc.b equ.s,line_g-*-1,col.s,line_c-*-3,lf.s,*-*,z */
/* QL: ; replace above when single line functions are going to be implemented */
/* QL: ;line_g dc.b expr.l,line_e-*-1,z */
/* QL: line_h dc.b THEN.w,line_c-*-1 */
line_h:
dc_anchor_483:
.byte (then.w)&255
.byte (((line_c-dc_anchor_483)-1))&255
/* QL: line_i dc.b                   col.s,line_c-*-1,lf.s,*-*,z */
line_i:
dc_anchor_488:
.byte (col.s)&255
.byte (((line_c-dc_anchor_488)-1))&255
.byte (lf.s)&255
.byte ((dc_anchor_488-dc_anchor_488))&255
.byte (z)&255
/* QL: line_j dc.b lf.s,*-*,col.s,line_k-*-3 */
line_j:
dc_anchor_496:
.byte (lf.s)&255
.byte ((dc_anchor_496-dc_anchor_496))&255
.byte (col.s)&255
.byte (((line_k-dc_anchor_496)-3))&255
/* QL: line_k dc.b                           icon.l,line_c-*-1,z */
line_k:
dc_anchor_503:
.byte (icon.l)&255
.byte (((line_c-dc_anchor_503)-1))&255
.byte (z)&255
/* QL: line_l dc.b expr.l,line_h-*-1,z */
line_l:
dc_anchor_509:
.byte (expr.l)&255
.byte (((line_h-dc_anchor_509)-1))&255
.byte (z)&255
/* QL: * Opening definition clause graph table */
/* QL: odc_a dc.b DEF.w,odc_b-*-1,z */
odc_a:
dc_anchor_516:
.byte (def.w)&255
.byte (((odc_b-dc_anchor_516)-1))&255
.byte (z)&255
/* QL: odc_b dc.b PROC.w,odc_c-*-1,FN.w,odc_c-*-3,z */
odc_b:
dc_anchor_522:
.byte (proc.w)&255
.byte (((odc_c-dc_anchor_522)-1))&255
.byte (fn.w)&255
.byte (((odc_c-dc_anchor_522)-3))&255
.byte (z)&255
/* QL: odc_c dc.b name.b,odc_d-*-1,z */
odc_c:
dc_anchor_530:
.byte (name.b)&255
.byte (((odc_d-dc_anchor_530)-1))&255
.byte (z)&255
/* QL: odc_d dc.b q,dplst.l,*-*,z */
odc_d:
dc_anchor_536:
.byte (q)&255
.byte (dplst.l)&255
.byte ((dc_anchor_536-dc_anchor_536))&255
.byte (z)&255
/* QL: * Opening clause graph table */
/* QL: oc_a dc.b FOR.w,oc_b-*-1,REP.w,oc_d-*-3,WHEN.w,oc_f-*-5,z */
oc_a:
dc_anchor_544:
.byte (for.w)&255
.byte (((oc_b-dc_anchor_544)-1))&255
.byte (rep.w)&255
.byte (((oc_d-dc_anchor_544)-3))&255
.byte (when.w)&255
.byte (((oc_f-dc_anchor_544)-5))&255
.byte (z)&255
/* QL: oc_b dc.b name.b,oc_g-*-1,z */
oc_b:
dc_anchor_554:
.byte (name.b)&255
.byte (((oc_g-dc_anchor_554)-1))&255
.byte (z)&255
/* QL: ;oc_d dc.b name.b,*-*,z */
/* QL: oc_f dc.b ERR.w,*-*,name.b,oc_r-*-3,z */
oc_f:
dc_anchor_561:
.byte (err.w)&255
.byte ((dc_anchor_561-dc_anchor_561))&255
.byte (name.b)&255
.byte (((oc_r-dc_anchor_561)-3))&255
.byte (z)&255
/* QL: oc_g dc.b equ.s,oc_m-*-1,z */
oc_g:
dc_anchor_569:
.byte (equ.s)&255
.byte (((oc_m-dc_anchor_569)-1))&255
.byte (z)&255
/* QL: *oc_h dc.b q allowed WHEN ERRor <expr>{,<expr>} !!! */
/* QL: *oc_i dc.b     expr.l,oc_n-*-1,z */
/* QL: *oc_j dc.b hsh.s,oc_p-*-1,z oc_j/p/t were "#expr{,#expr}" - not used! */
/* QL: oc_m dc.b rnge.l,oc_s-*-1,z */
oc_m:
dc_anchor_578:
.byte (rnge.l)&255
.byte (((oc_s-dc_anchor_578)-1))&255
.byte (z)&255
/* QL: *oc_n dc.b q,com.s,oc_i-*-2,z */
/* QL: *oc_p dc.b expr.l,oc_u-*-1,z */
/* QL: oc_r dc.b q,whcon.l,*-*,z this starts at possible subscription/slicing */
oc_r:
dc_anchor_586:
.byte (q)&255
.byte (whcon.l)&255
.byte ((dc_anchor_586-dc_anchor_586))&255
.byte (z)&255
/* QL: oc_s dc.b STEP.w,oc_v-*-1 */
oc_s:
dc_anchor_593:
.byte (step.w)&255
.byte (((oc_v-dc_anchor_593)-1))&255
/* QL: oc_t dc.b                 q,com.s,oc_m-*-2,z */
oc_t:
dc_anchor_598:
.byte (q)&255
.byte (com.s)&255
.byte (((oc_m-dc_anchor_598)-2))&255
.byte (z)&255
/* QL: *oc_u dc.b q,com.s,oc_j-*-2,z */
/* QL: oc_v dc.b expr.l,oc_t-*-1,z */
oc_v:
dc_anchor_606:
.byte (expr.l)&255
.byte (((oc_t-dc_anchor_606)-1))&255
.byte (z)&255
/* QL: * Opening select clause */
/* QL: osl_a dc.b SEL.w,osl_b-*-1,z */
osl_a:
dc_anchor_613:
.byte (sel.w)&255
.byte (((osl_b-dc_anchor_613)-1))&255
.byte (z)&255
/* QL: osl_b dc.b ON.w,osl_c-*-1 */
osl_b:
dc_anchor_619:
.byte (on.w)&255
.byte (((osl_c-dc_anchor_619)-1))&255
/* QL: oc_d */
oc_d:
/* QL: ic_b */
ic_b:
/* QL: osl_c dc.b                name.b,*-*,z */
osl_c:
dc_anchor_628:
.byte (name.b)&255
.byte ((dc_anchor_628-dc_anchor_628))&255
.byte (z)&255
/* QL: * Intermediate clause graph table (now takes in the "ON expr GO ..." statement) */
/* QL: ic_a dc.b EXIT.w,ic_b-*-1,NEXT.w,ic_b-*-3,RET.w,ic_c-*-5,ON.w,ic_d-*-7 */
ic_a:
dc_anchor_635:
.byte (exit.w)&255
.byte (((ic_b-dc_anchor_635)-1))&255
.byte (next.w)&255
.byte (((ic_b-dc_anchor_635)-3))&255
.byte (ret.w)&255
.byte (((ic_c-dc_anchor_635)-5))&255
.byte (on.w)&255
.byte (((ic_d-dc_anchor_635)-7))&255
/* QL: icon_a dc.b                            equ.s,ic_e-*-1,z */
icon_a:
dc_anchor_646:
.byte (equ.s)&255
.byte (((ic_e-dc_anchor_646)-1))&255
.byte (z)&255
/* QL: ;ic_b dc.b name.b,*-*,z */
/* QL: ;ic_c dc.b q,expr.l,*-*,z */
/* QL: ic_d dc.b ongo.l,*-*,name.b,icon_a-*-3,z */
ic_d:
dc_anchor_654:
.byte (ongo.l)&255
.byte ((dc_anchor_654-dc_anchor_654))&255
.byte (name.b)&255
.byte (((icon_a-dc_anchor_654)-3))&255
.byte (z)&255
/* QL: ic_e dc.b REMAINDER.w,*-* */
ic_e:
dc_anchor_662:
.byte (remainder.w)&255
.byte ((dc_anchor_662-dc_anchor_662))&255
/* QL: ic_f dc.b                 rnge.l,ic_g-*-1,z */
ic_f:
dc_anchor_667:
.byte (rnge.l)&255
.byte (((ic_g-dc_anchor_667)-1))&255
.byte (z)&255
/* QL: ic_g dc.b com.s,ic_f-*-1,q,z */
ic_g:
dc_anchor_673:
.byte (com.s)&255
.byte (((ic_f-dc_anchor_673)-1))&255
.byte (q)&255
.byte (z)&255
/* QL: * End clause graph table */
/* QL: ec_a dc.b END.w,ec_b-*-1,z */
ec_a:
dc_anchor_681:
.byte (end.w)&255
.byte (((ec_b-dc_anchor_681)-1))&255
.byte (z)&255
/* QL: ec_b dc.b REP.w,ec_d-*-1,FOR.w,ec_d-*-3,IF.w,*-*,SEL.w,*-* */
ec_b:
dc_anchor_687:
.byte (rep.w)&255
.byte (((ec_d-dc_anchor_687)-1))&255
.byte (for.w)&255
.byte (((ec_d-dc_anchor_687)-3))&255
.byte (if.w)&255
.byte ((dc_anchor_687-dc_anchor_687))&255
.byte (sel.w)&255
.byte ((dc_anchor_687-dc_anchor_687))&255
/* QL:      dc.b                            WHEN.w,*-*,DEF.w,ec_c-*-3,z */
dc_anchor_697:
.byte (when.w)&255
.byte ((dc_anchor_697-dc_anchor_697))&255
.byte (def.w)&255
.byte (((ec_c-dc_anchor_697)-3))&255
.byte (z)&255
/* QL: ec_c dc.b q */
ec_c:
dc_anchor_705:
.byte (q)&255
/* QL: ec_d dc.b   name.b,*-*,z */
ec_d:
dc_anchor_709:
.byte (name.b)&255
.byte ((dc_anchor_709-dc_anchor_709))&255
.byte (z)&255
/* QL: * Proc call "name(expr)=expr sep" (to distinguish it from assignment) */
/* QL: proc_a dc.b obr.s,proc_b-*-1,z */
proc_a:
dc_anchor_716:
.byte (obr.s)&255
.byte (((proc_b-dc_anchor_716)-1))&255
.byte (z)&255
/* QL: proc_b dc.b expr.l,proc_c-*-1,z */
proc_b:
dc_anchor_722:
.byte (expr.l)&255
.byte (((proc_c-dc_anchor_722)-1))&255
.byte (z)&255
/* QL: proc_c dc.b cbr.s,proc_d-*-1,z */
proc_c:
dc_anchor_728:
.byte (cbr.s)&255
.byte (((proc_d-dc_anchor_728)-1))&255
.byte (z)&255
/* QL: proc_d dc.b ops.b,proc_e-*-1 */
proc_d:
dc_anchor_734:
.byte (ops.b)&255
.byte (((proc_e-dc_anchor_734)-1))&255
/* QL: proc_e dc.b expr.l,proc_f-*-1 */
proc_e:
dc_anchor_739:
.byte (expr.l)&255
.byte (((proc_f-dc_anchor_739)-1))&255
/* QL: proc_f dc.b sep.b,*-*,z */
proc_f:
dc_anchor_744:
.byte (sep.b)&255
.byte ((dc_anchor_744-dc_anchor_744))&255
.byte (z)&255
/* QL: * ON expr GO ... graph table (to distinguish it from ON var = expr) */
/* QL: ongo_a dc.b expr.l,ongo_l-*-1,z */
ongo_a:
dc_anchor_751:
.byte (expr.l)&255
.byte (((ongo_l-dc_anchor_751)-1))&255
.byte (z)&255
/* QL: ongo_l dc.b GO.w,ongo_m-*-1,z */
ongo_l:
dc_anchor_757:
.byte (go.w)&255
.byte (((ongo_m-dc_anchor_757)-1))&255
.byte (z)&255
/* QL: ongo_m dc.b tosub.l,ongo_p-*-1,z */
ongo_m:
dc_anchor_763:
.byte (tosub.l)&255
.byte (((ongo_p-dc_anchor_763)-1))&255
.byte (z)&255
/* QL: ongo_n dc.b expr.l,ongo_p-*-1,z */
ongo_n:
dc_anchor_769:
.byte (expr.l)&255
.byte (((ongo_p-dc_anchor_769)-1))&255
.byte (z)&255
/* QL: ongo_p dc.b com.s,ongo_n-*-1,q,z */
ongo_p:
dc_anchor_775:
.byte (com.s)&255
.byte (((ongo_n-dc_anchor_775)-1))&255
.byte (q)&255
.byte (z)&255
/* QL: * TO or SUB plus expr to save a couple of bytes */
/* QL: tosub_a dc.b TO.w,tosub_c-*-1,SUB.w,tosub_c-*-3,z */
tosub_a:
dc_anchor_783:
.byte (to.w)&255
.byte (((tosub_c-dc_anchor_783)-1))&255
.byte (sub.w)&255
.byte (((tosub_c-dc_anchor_783)-3))&255
.byte (z)&255
/* QL: *tosub_c dc.b expr.l,*-*,z */
/* QL: * Statement graph table */
/* QL: stat_a dc.b LOC.w,stat_v-*-1,DIM.w,stat_c-*-3,DATA.w,ongo_n-*-5 */
stat_a:
dc_anchor_793:
.byte (loc.w)&255
.byte (((stat_v-dc_anchor_793)-1))&255
.byte (dim.w)&255
.byte (((stat_c-dc_anchor_793)-3))&255
.byte (data.w)&255
.byte (((ongo_n-dc_anchor_793)-5))&255
/* QL:        dc.b  RESTORE.w,stat_b-*-1,REM.w,stat_h-*-3,MIST.w,stat_h-*-5 */
dc_anchor_801:
.byte (restore.w)&255
.byte (((stat_b-dc_anchor_801)-1))&255
.byte (rem.w)&255
.byte (((stat_h-dc_anchor_801)-3))&255
.byte (mist.w)&255
.byte (((stat_h-dc_anchor_801)-5))&255
/* QL:        dc.b   GO.w,tosub_a-*-1,LET.w,stat_p-*-3,name.b,stat_t-*-5,z */
dc_anchor_809:
.byte (go.w)&255
.byte (((tosub_a-dc_anchor_809)-1))&255
.byte (let.w)&255
.byte (((stat_p-dc_anchor_809)-3))&255
.byte (name.b)&255
.byte (((stat_t-dc_anchor_809)-5))&255
.byte (z)&255
/* QL: * Note: "name(expr)=expr" still has to be left to runtime! */
/* QL: ic_c */
ic_c:
/* QL: stat_b dc.b q */
stat_b:
dc_anchor_822:
.byte (q)&255
/* QL: rnge_c */
rnge_c:
/* QL: tosub_c */
tosub_c:
/* QL: stat_s dc.b   expr.l,*-*,z */
stat_s:
dc_anchor_830:
.byte (expr.l)&255
.byte ((dc_anchor_830-dc_anchor_830))&255
.byte (z)&255
/* QL: stat_c dc.b name.b,stat_d-*-1,z */
stat_c:
dc_anchor_836:
.byte (name.b)&255
.byte (((stat_d-dc_anchor_836)-1))&255
.byte (z)&255
/* QL: stat_d dc.b da.l,stat_e-*-1,z */
stat_d:
dc_anchor_842:
.byte (da.l)&255
.byte (((stat_e-dc_anchor_842)-1))&255
.byte (z)&255
/* QL: stat_e dc.b com.s,stat_c-*-1,q,z */
stat_e:
dc_anchor_848:
.byte (com.s)&255
.byte (((stat_c-dc_anchor_848)-1))&255
.byte (q)&255
.byte (z)&255
/* QL: stat_v dc.b name.b,stat_f-*-1,z */
stat_v:
dc_anchor_855:
.byte (name.b)&255
.byte (((stat_f-dc_anchor_855)-1))&255
.byte (z)&255
/* QL: stat_f dc.b da.l,stat_g-*-1 */
stat_f:
dc_anchor_861:
.byte (da.l)&255
.byte (((stat_g-dc_anchor_861)-1))&255
/* QL: stat_g dc.b                 com.s,stat_v-*-1,q,z */
stat_g:
dc_anchor_866:
.byte (com.s)&255
.byte (((stat_v-dc_anchor_866)-1))&255
.byte (q)&255
.byte (z)&255
/* QL: stat_h dc.b txt.b,*-*,z */
stat_h:
dc_anchor_873:
.byte (txt.b)&255
.byte ((dc_anchor_873-dc_anchor_873))&255
.byte (z)&255
/* QL: stat_p dc.b name.b,stat_q-*-1,z */
stat_p:
dc_anchor_879:
.byte (name.b)&255
.byte (((stat_q-dc_anchor_879)-1))&255
.byte (z)&255
/* QL: stat_q dc.b var.l,stat_r-*-1,z */
stat_q:
dc_anchor_885:
.byte (var.l)&255
.byte (((stat_r-dc_anchor_885)-1))&255
.byte (z)&255
/* QL: ass_b */
ass_b:
/* QL: stat_r dc.b equ.s,stat_s-*-1,z */
stat_r:
dc_anchor_893:
.byte (equ.s)&255
.byte (((stat_s-dc_anchor_893)-1))&255
.byte (z)&255
/* QL: stat_t dc.b proc.l,stat_u-*-1,ass.l,*-* */
stat_t:
dc_anchor_899:
.byte (proc.l)&255
.byte (((stat_u-dc_anchor_899)-1))&255
.byte (ass.l)&255
.byte ((dc_anchor_899-dc_anchor_899))&255
/* QL: stat_u dc.b                             splst.l,*-*,z */
stat_u:
dc_anchor_906:
.byte (splst.l)&255
.byte ((dc_anchor_906-dc_anchor_906))&255
.byte (z)&255
/* QL: * Assignment statement (with a chance of getting it wrong! "name(expr)=expr") */
/* QL: ass_a dc.b var.l,ass_b-*-1,z */
ass_a:
dc_anchor_913:
.byte (var.l)&255
.byte (((ass_b-dc_anchor_913)-1))&255
.byte (z)&255
/* QL: * Definition parameter list graph table */
/* QL: dplst_a dc.b obr.s,dplst_b-*-1,z */
dplst_a:
dc_anchor_920:
.byte (obr.s)&255
.byte (((dplst_b-dc_anchor_920)-1))&255
.byte (z)&255
/* QL: dplst_b dc.b name.b,dplst_c-*-1,obr.s,dplst_e-*-3,z */
dplst_b:
dc_anchor_926:
.byte (name.b)&255
.byte (((dplst_c-dc_anchor_926)-1))&255
.byte (obr.s)&255
.byte (((dplst_e-dc_anchor_926)-3))&255
.byte (z)&255
/* QL: * Wow! We can have DEFFN fred(a,b,(c,d))! */
/* QL: dplst_c dc.b com.s,dplst_b-*-1 */
dplst_c:
dc_anchor_935:
.byte (com.s)&255
.byte (((dplst_b-dc_anchor_935)-1))&255
/* QL: dplst_d dc.b                   cbr.s,*-*,z */
dplst_d:
dc_anchor_940:
.byte (cbr.s)&255
.byte ((dc_anchor_940-dc_anchor_940))&255
.byte (z)&255
/* QL: dplst_e dc.b name.b,dplst_f-*-1,z */
dplst_e:
dc_anchor_946:
.byte (name.b)&255
.byte (((dplst_f-dc_anchor_946)-1))&255
.byte (z)&255
/* QL: dplst_f dc.b com.s,dplst_e-*-1,cbr.s,dplst_d-*-3,z */
dplst_f:
dc_anchor_952:
.byte (com.s)&255
.byte (((dplst_e-dc_anchor_952)-1))&255
.byte (cbr.s)&255
.byte (((dplst_d-dc_anchor_952)-3))&255
.byte (z)&255
/* QL: * Range graph table */
/* QL: rnge_a dc.b expr.l,rnge_b-*-1,z */
rnge_a:
dc_anchor_961:
.byte (expr.l)&255
.byte (((rnge_b-dc_anchor_961)-1))&255
.byte (z)&255
/* QL: rnge_b dc.b TO.w,rnge_c-*-1,q,z */
rnge_b:
dc_anchor_967:
.byte (to.w)&255
.byte (((rnge_c-dc_anchor_967)-1))&255
.byte (q)&255
.byte (z)&255
/* QL: ;rnge_c dc.b expr.l,*-*,z */
/* QL: * Expression graph table - WHEN var condition graph starts at whcon_a */
/* QL: pa_expr */
pa_expr:
/* QL: expr_a dc.b val.b,expr_d-*-1,mons.b,expr_a-*-3 we may do multiple monadics */
expr_a:
dc_anchor_978:
.byte (val.b)&255
.byte (((expr_d-dc_anchor_978)-1))&255
.byte (mons.b)&255
.byte (((expr_a-dc_anchor_978)-3))&255
/* QL:        dc.b  obr.s,expr_b-*-1 */
dc_anchor_984:
.byte (obr.s)&255
.byte (((expr_b-dc_anchor_984)-1))&255
/* QL:        dc.b   str.b,expr_d-*-1,lit.l,expr_d-*-3,name.b,expr_h-*-5,z */
dc_anchor_988:
.byte (str.b)&255
.byte (((expr_d-dc_anchor_988)-1))&255
.byte (lit.l)&255
.byte (((expr_d-dc_anchor_988)-3))&255
.byte (name.b)&255
.byte (((expr_h-dc_anchor_988)-5))&255
.byte (z)&255
/* QL: expr_b dc.b expr.l,expr_g-*-1,z */
expr_b:
dc_anchor_998:
.byte (expr.l)&255
.byte (((expr_g-dc_anchor_998)-1))&255
.byte (z)&255
/* QL: whcon_a ; new entry point for WHEN var condition, allow subscription of var */
whcon_a:
/* QL: expr_d dc.b obr.s,expr_f-*-1,q,ops.b,expr_a-*-4,z */
expr_d:
dc_anchor_1006:
.byte (obr.s)&255
.byte (((expr_f-dc_anchor_1006)-1))&255
.byte (q)&255
.byte (ops.b)&255
.byte (((expr_a-dc_anchor_1006)-4))&255
.byte (z)&255
/* QL: expr_f dc.b subs.l,expr_g-*-1,z */
expr_f:
dc_anchor_1015:
.byte (subs.l)&255
.byte (((expr_g-dc_anchor_1015)-1))&255
.byte (z)&255
/* QL: expr_g dc.b cbr.s,expr_d-*-1,z */
expr_g:
dc_anchor_1021:
.byte (cbr.s)&255
.byte (((expr_d-dc_anchor_1021)-1))&255
.byte (z)&255
/* QL: expr_h dc.b obr.s,expr_i-*-1,q,ops.b,expr_a-*-4,z */
expr_h:
dc_anchor_1027:
.byte (obr.s)&255
.byte (((expr_i-dc_anchor_1027)-1))&255
.byte (q)&255
.byte (ops.b)&255
.byte (((expr_a-dc_anchor_1027)-4))&255
.byte (z)&255
/* QL: expr_i dc.b splst.l,expr_g-*-1,z */
expr_i:
dc_anchor_1036:
.byte (splst.l)&255
.byte (((expr_g-dc_anchor_1036)-1))&255
.byte (z)&255
/* QL: * Dimensioned array graph table (name already parsed) */
/* QL: da_a dc.b obr.s,da_c-*-1,z */
da_a:
dc_anchor_1043:
.byte (obr.s)&255
.byte (((da_c-dc_anchor_1043)-1))&255
.byte (z)&255
/* QL: da_c dc.b expr.l,da_d-*-1,z */
da_c:
dc_anchor_1049:
.byte (expr.l)&255
.byte (((da_d-dc_anchor_1049)-1))&255
.byte (z)&255
/* QL: da_d dc.b com.s,da_c-*-1,cbr.s,*-*,z */
da_d:
dc_anchor_1055:
.byte (com.s)&255
.byte (((da_c-dc_anchor_1055)-1))&255
.byte (cbr.s)&255
.byte ((dc_anchor_1055-dc_anchor_1055))&255
.byte (z)&255
/* QL: * Variable graph table (name already parsed) */
/* QL: var_a dc.b q,obr.s,var_b-*-2,z */
var_a:
dc_anchor_1064:
.byte (q)&255
.byte (obr.s)&255
.byte (((var_b-dc_anchor_1064)-2))&255
.byte (z)&255
/* QL: var_b dc.b subs.l,var_c-*-1,z n.b. this still allows a lot of bad constructs! */
var_b:
dc_anchor_1071:
.byte (subs.l)&255
.byte (((var_c-dc_anchor_1071)-1))&255
.byte (z)&255
/* QL: var_c dc.b cbr.s,var_a-*-1,z */
var_c:
dc_anchor_1077:
.byte (cbr.s)&255
.byte (((var_a-dc_anchor_1077)-1))&255
.byte (z)&255
/* QL: * Separated parameter list */
/* QL: splst_a dc.b q,sep.b,splst_a-*-2,hsh.s,splst_b-*-4 */
splst_a:
dc_anchor_1084:
.byte (q)&255
.byte (sep.b)&255
.byte (((splst_a-dc_anchor_1084)-2))&255
.byte (hsh.s)&255
.byte (((splst_b-dc_anchor_1084)-4))&255
/* QL: splst_b dc.b                                         expr.l,splst_c-*-1,z */
splst_b:
dc_anchor_1092:
.byte (expr.l)&255
.byte (((splst_c-dc_anchor_1092)-1))&255
.byte (z)&255
/* QL: splst_c dc.b sep.b,splst_a-*-1,q,z */
splst_c:
dc_anchor_1098:
.byte (sep.b)&255
.byte (((splst_a-dc_anchor_1098)-1))&255
.byte (q)&255
.byte (z)&255
/* QL: * Subscription parameter list (as good as we can manage...) */
/* QL: subs_0 dc.b q */
subs_0:
dc_anchor_1106:
.byte (q)&255
/* QL: subs_a dc.b   sep.b,subs_0-*-1 */
subs_a:
dc_anchor_1110:
.byte (sep.b)&255
.byte (((subs_0-dc_anchor_1110)-1))&255
/* QL: subs_b dc.b                      expr.l,subs_c-*-1,z */
subs_b:
dc_anchor_1115:
.byte (expr.l)&255
.byte (((subs_c-dc_anchor_1115)-1))&255
.byte (z)&255
/* QL: subs_c dc.b sep.b,subs_0-*-1,q,z */
subs_c:
dc_anchor_1121:
.byte (sep.b)&255
.byte (((subs_0-dc_anchor_1121)-1))&255
.byte (q)&255
.byte (z)&255
/* QL: * If we could insist on specific separators, we could do subscription properly! */
/* QL: * subscript list graph */
/* QL: *subs_a dc.b sube.l,subs_b-*-1,z */
/* QL: *subs_b dc.b q,comsep.b,subs_a-*-2,z */
/* QL: * subscript element graph */
/* QL: *sube_a dc.b septo.b,sube_c-*-1,expr.l,sube_b-*-3,z */
/* QL: *sube_b dc.b q,septo.b,sube_c-*-2,z */
/* QL: *sube_c dc.b q,expr.l,*-*,z */
/* QL: * Literal graph table */
/* QL: lit_a dc.b ocb.s,lit_b-*-1,z */
lit_a:
dc_anchor_1137:
.byte (ocb.s)&255
.byte (((lit_b-dc_anchor_1137)-1))&255
.byte (z)&255
/* QL: lit_b dc.b expr.l,lit_c-*-1,lit.l,lit_c-*-3,z */
lit_b:
dc_anchor_1143:
.byte (expr.l)&255
.byte (((lit_c-dc_anchor_1143)-1))&255
.byte (lit.l)&255
.byte (((lit_c-dc_anchor_1143)-3))&255
.byte (z)&255
/* QL: lit_c dc.b com.s,lit_b-*-1,ccb.s,*-*,z */
lit_c:
dc_anchor_1151:
.byte (com.s)&255
.byte (((lit_b-dc_anchor_1151)-1))&255
.byte (ccb.s)&255
.byte ((dc_anchor_1151-dc_anchor_1151))&255
.byte (z)&255
/* QL: tabset macro max */
/* QL: tab macro */
/* QL: tabend macro */
/* QL: * Keywords */
/* QL: pa_kytab tabset 31 ; Note we can ONLY have $1f keywords */
/* QL: [.lab] dc.b [max] */
pa_kytab:
dc_anchor_1164:
.byte (31)&255
/* QL: k setstr k[.l] */
/* QL: kno setnum 0 */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1171:
.byte ((k941-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1177:
.byte ((k942-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1183:
.byte ((k943-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1189:
.byte ((k944-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1195:
.byte ((k945-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1201:
.byte ((k946-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1207:
.byte ((k947-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1213:
.byte ((k948-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1219:
.byte ((k949-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1225:
.byte ((k9410-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1231:
.byte ((k9411-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1237:
.byte ((k9412-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1243:
.byte ((k9413-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1249:
.byte ((k9414-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1255:
.byte ((k9415-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1261:
.byte ((k9416-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1267:
.byte ((k9417-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1273:
.byte ((k9418-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1279:
.byte ((k9419-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1285:
.byte ((k9420-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1291:
.byte ((k9421-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1297:
.byte ((k9422-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1303:
.byte ((k9423-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1309:
.byte ((k9424-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1315:
.byte ((k9425-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1321:
.byte ((k9426-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1327:
.byte ((k9427-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1333:
.byte ((k9428-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1339:
.byte ((k9429-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1345:
.byte ((k9430-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
dc_anchor_1351:
.byte ((k9431-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: kno setnum 1 */
/* QL: kfoll setnum 0 */
/* QL:         tab     6 END FOR IF REPeat SELect WHEN 2 DEFine PROCedure FuNction */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k941:
dc_anchor_1373:
.byte (((3<<4)|6))&255
.byte 69,78,68
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k942:
dc_anchor_1387:
.byte (((3<<4)|0))&255
.byte 70,79,82
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k943:
dc_anchor_1401:
.byte (((2<<4)|0))&255
.byte 73,70
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k944:
dc_anchor_1415:
.byte (((6<<4)|0))&255
.byte 82,69,80,101,97,116
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k945:
dc_anchor_1429:
.byte (((6<<4)|0))&255
.byte 83,69,76,101,99,116
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k946:
dc_anchor_1443:
.byte (((4<<4)|0))&255
.byte 87,72,69,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k947:
dc_anchor_1464:
.byte (((6<<4)|2))&255
.byte 68,69,70,105,110,101
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k948:
dc_anchor_1478:
.byte (((9<<4)|0))&255
.byte 80,82,79,67,101,100,117,114,101
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k949:
dc_anchor_1492:
.byte (((8<<4)|0))&255
.byte 70,117,78,99,116,105,111,110
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL:         tab     2 GO TO SUB 1 WHEN ERRor GO GO */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9410:
dc_anchor_1519:
.byte (((2<<4)|2))&255
.byte 71,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9411:
dc_anchor_1533:
.byte (((2<<4)|0))&255
.byte 84,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9412:
dc_anchor_1547:
.byte (((3<<4)|0))&255
.byte 83,85,66
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9413:
dc_anchor_1568:
.byte (((4<<4)|1))&255
.byte 87,72,69,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9414:
dc_anchor_1582:
.byte (((5<<4)|0))&255
.byte 69,82,82,111,114
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9415:
dc_anchor_1596:
.byte (((2<<4)|0))&255
.byte 71,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9416:
dc_anchor_1610:
.byte (((2<<4)|0))&255
.byte 71,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL: * Next time we need keywords, replace the last pair above */
/* QL: * They used to be "END ERRor", and earlier "EOF INPUT"! */
/* QL: * Using "GO", which has already been parsed and rejected, saves 4 bytes. */
/* QL:         tab     RESTORE NEXT EXIT ELSE ON RETurn REMAINDER DATA DIM */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9417:
dc_anchor_1633:
.byte (((7<<4)|0))&255
.byte 82,69,83,84,79,82,69
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9418:
dc_anchor_1647:
.byte (((4<<4)|0))&255
.byte 78,69,88,84
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9419:
dc_anchor_1661:
.byte (((4<<4)|0))&255
.byte 69,88,73,84
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9420:
dc_anchor_1675:
.byte (((4<<4)|0))&255
.byte 69,76,83,69
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9421:
dc_anchor_1689:
.byte (((2<<4)|0))&255
.byte 79,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9422:
dc_anchor_1703:
.byte (((6<<4)|0))&255
.byte 82,69,84,117,114,110
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9423:
dc_anchor_1717:
.byte (((9<<4)|0))&255
.byte 82,69,77,65,73,78,68,69,82
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9424:
dc_anchor_1731:
.byte (((4<<4)|0))&255
.byte 68,65,84,65
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9425:
dc_anchor_1745:
.byte (((3<<4)|0))&255
.byte 68,73,77
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL:         tab     LOCal LET THEN STEP REMark MISTake */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9426:
dc_anchor_1765:
.byte (((5<<4)|0))&255
.byte 76,79,67,97,108
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9427:
dc_anchor_1779:
.byte (((3<<4)|0))&255
.byte 76,69,84
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9428:
dc_anchor_1793:
.byte (((4<<4)|0))&255
.byte 84,72,69,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9429:
dc_anchor_1807:
.byte (((4<<4)|0))&255
.byte 83,84,69,80
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9430:
dc_anchor_1821:
.byte (((6<<4)|0))&255
.byte 82,69,77,97,114,107
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
k9431:
dc_anchor_1835:
.byte (((7<<4)|0))&255
.byte 77,73,83,84,97,107,101
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL:         tabend */
/* QL: k[kno] ds.b 0 */
k32:
/* QL:         vect4000 pa_expr */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl pa$expr
/* QL: [o]     equ     [h]-$4000 */
.equ pa$expr,(pa_expr-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
