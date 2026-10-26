/* Generated from original/M/dd/mdv.asm */
/* QL: * Directory device block setup for mdv */
/* QL:         xdef    dd_mdv */
.globl dd_mdv
/* QL:         xref    dd_mdvcl,dd_mdvio,dd_mdvop */
/* QL:         xref    md_formt,md_slave */
/* QL:         include 'win1_m_inc_md' */
/* QL: * microdrive physical layer definition */
/* QL:         nolist */
/* QL:         offset  $10 */
/* QL: md_drivr ds.l   1       pointer to driver */
.equ md_drivr,16
/* QL: md_drivn ds.b   1       drive number */
.equ md_drivn,20
/* QL:         ds.b    1       spare */
/* QL: md_mname ds.w   1+10/2  length prefixed medium name and check number */
.equ md_mname,22
/* QL: md_files ds.b   1       number of files open */
.equ md_files,34
/* QL: md_estat ds.b   1       error status 0=ok -1=bad */
.equ md_estat,35
/* QL: md_fail ds.b    1       failure count */
.equ md_fail,36
/* QL:         ds.b    3       spare */
/* QL: md_map  ds.w    255     microdrive map (fe bad, fd vac, fc pending delete) */
.equ md_map,40
/* QL: md_lsect ds.w   1       last sector allocated. */
.equ md_lsect,550
/* QL: md_pendg ds.w   256     pending operations: 0 no, >0 slave block nr */
.equ md_pendg,552
/* QL:                                         ;   -1 write map, -2 verify map */
/* QL: md_end */
.equ md_end,1064
/* QL: * directory structure definitions */
/* QL:         offset  0 */
/* QL: md_delen ds.l   1       length */
.equ md_delen,0
/* QL: md_deacs ds.b   1       access key */
.equ md_deacs,4
/* QL: md_detyp ds.b   1       type */
.equ md_detyp,5
/* QL: md_deinf ds.l   2       information (data space first) */
.equ md_deinf,6
/* QL: md_denam ds.w   1+36/2  length prefixed file name */
.equ md_denam,14
/* QL: md_deupd ds.l   1       update date */
.equ md_deupd,52
/* QL:          ds.w   2       unit and version */
/* QL: md_debkd ds.l   1       backup date */
.equ md_debkd,60
/* QL: md_deend */
.equ md_deend,64
/* QL:         list */
/* QL:         section dd_mdv */
.section dd_mdv,"ax"
/* QL: dd_mdv */
dd_mdv:
/* QL:         dc.w    dd_mdvio-* */
.balign 2,0
dc_anchor_58:
.word ((dd_mdvio-dc_anchor_58))&65535
/* QL:         dc.w    dd_mdvop-* */
.balign 2,0
dc_anchor_62:
.word ((dd_mdvop-dc_anchor_62))&65535
/* QL:         dc.w    dd_mdvcl-* */
.balign 2,0
dc_anchor_66:
.word ((dd_mdvcl-dc_anchor_66))&65535
/* QL:         dc.w    md_slave-* */
.balign 2,0
dc_anchor_70:
.word ((md_slave-dc_anchor_70))&65535
/* QL:         dc.w    0 */
.balign 2,0
dc_anchor_74:
.word 0
/* QL:         dc.w    0 */
.balign 2,0
dc_anchor_78:
.word 0
/* QL:         dc.w    md_formt-* */
.balign 2,0
dc_anchor_82:
.word ((md_formt-dc_anchor_82))&65535
/* QL:         dc.l    md_end          length of definition block */
.balign 2,0
dc_anchor_86:
.long md_end
/* QL:         dc.w    3,'MDV'         microdrive device name */
.balign 2,0
dc_anchor_90:
.word 3
.byte 77,68,86
.balign 2,0
/* QL:         end */
