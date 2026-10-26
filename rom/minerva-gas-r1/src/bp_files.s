/* Generated from original/M/bp/files.asm */
/* QL: * General routines for file load/save etc. */
/* QL:         xdef    bp_close,bp_copy,bp_copyn,bp_delee,bp_dir,bp_exec,bp_execw */
.globl bp_close,bp_copy,bp_copyn,bp_delee,bp_dir,bp_exec,bp_execw
/* QL:         xdef    bp_formt,bp_fopin,bp_lbyts,bp_open,bp_openn,bp_openw */
.globl bp_formt,bp_fopin,bp_lbyts,bp_open,bp_openn,bp_openw
/* QL:         xdef    bp_save,bp_sbyts,bp_sexec */
.globl bp_save,bp_sbyts,bp_sexec
/* QL:         xref    bp_chan,bp_chnew,bp_chnid,bp_listd,bp_rdchk */
/* QL:         xref    ca_etos,ca_gtlin,ca_putss */
/* QL:         xref    cn_itod */
/* QL:         xref    mm_mrtoa */
/* QL:         xref    ut_err */
/* QL:         include 'win1_m_inc_assert' */
/* QL: * Improved assert - accepts comparison operators */
/* QL:         nolist */
/* QL: assert macro */
/* QL:         list */
/* QL:         include 'win1_m_inc_bv' */
/* QL: * pointers to basic variable lists and stacks */
/* QL:          nolist */
/* QL:         offset  0 */
/* QL: bv_start ; start of area and pointers */
.equ bv_start,0
/* QL: bv_bfbas ds.l   1       buffer base */
.equ bv_bfbas,0
/* QL: bv_bfp  ds.l    1       buffer running pointer */
.equ bv_bfp,4
/* QL: bv_tkbas ds.l   1       token list */
.equ bv_tkbas,8
/* QL: bv_tkp  ds.l    1 */
.equ bv_tkp,12
/* QL: bv_pfbas ds.l   1       program file */
.equ bv_pfbas,16
/* QL: bv_pfp  ds.l    1 */
.equ bv_pfp,20
/* QL: bv_ntbas ds.l   1       name table */
.equ bv_ntbas,24
/* QL: bv_ntp  ds.l    1 */
.equ bv_ntp,28
/* QL: bv_nlbas ds.l   1       name list */
.equ bv_nlbas,32
/* QL: bv_nlp  ds.l    1 */
.equ bv_nlp,36
/* QL: bv_vvbas ds.l   1       variable values */
.equ bv_vvbas,40
/* QL: bv_vvp  ds.l    1 */
.equ bv_vvp,44
/* QL: bv_chbas ds.l   1       channel table */
.equ bv_chbas,48
/* QL: bv_chp  ds.l    1 */
.equ bv_chp,52
/* QL: bv_rtbas ds.l   1       return table */
.equ bv_rtbas,56
/* QL: bv_rtp  ds.l    1 */
.equ bv_rtp,60
/* QL: bv_lnbas ds.l   1       line number table */
.equ bv_lnbas,64
/* QL: bv_lnp  ds.l    1 */
.equ bv_lnp,68
/* QL: bv_chang ; change of direction marker */
.equ bv_chang,72
/* QL: bv_btp  ds.l    1       backtrack stack during parsing */
.equ bv_btp,72
/* QL: bv_btbas ds.l   1 */
.equ bv_btbas,76
/* QL: bv_tgp  ds.l    1       temporary graph stack during parsing */
.equ bv_tgp,80
/* QL: bv_tgbas ds.l   1 */
.equ bv_tgbas,84
/* QL: bv_rip  ds.l    1       arithmetic stack */
.equ bv_rip,88
/* QL: bv_ribas ds.l   1 */
.equ bv_ribas,92
/* QL: bv_ssp  ds.l    1       system stack (real one!) */
.equ bv_ssp,96
/* QL: bv_ssbas ds.l   1 */
.equ bv_ssbas,100
/* QL: bv_endpt equ *-4 last of pointers */
.equ bv_endpt,(104-4)
/* QL: bv_linum ds.w   1       current line number */
.equ bv_linum,104
/* QL: bv_lengt ds.w   1       current length */
.equ bv_lengt,106
/* QL: bv_stmnt ds.b   1       current statement on line */
.equ bv_stmnt,108
/* QL: bv_cont ds.b    1       continue ($80) or stop (0) processing */
.equ bv_cont,109
/* QL: bv_inlin ds.b   1       in-line clause (1=loop or $ff=other) or not (0) */
.equ bv_inlin,110
/* QL: bv_sing ds.b    1       single line execution on ($ff) or off (0) */
.equ bv_sing,111
/* QL: bv_index ds.w   1       name tab row of last inline loop index read */
.equ bv_index,112
/* QL: bv_vvfre ds.l   1       first free space in vvtable */
.equ bv_vvfre,114
/* QL: bv_sssav ds.l   1       saved sp for out of memory to go back to */
.equ bv_sssav,118
/* QL:         ds.w    1       spare */
/* QL: bv_uproc ds.l   1       if sign set, rest is address of user trace procedure */
.equ bv_uproc,124
/* QL: bv_rand ds.l    1       random number */
.equ bv_rand,128
/* QL: bv_comch ds.l   1       command channel */
.equ bv_comch,132
/* QL: bv_nxlin ds.w   1       which line number to start after */
.equ bv_nxlin,136
/* QL: bv_nxstm ds.b   1       which statement to start after */
.equ bv_nxstm,138
/* QL: bv_comln ds.b   1       command line save ($ff) or not (0) */
.equ bv_comln,139
/* QL: bv_stopn ds.w   1       which stop number set */
.equ bv_stopn,140
/* QL: bv_edit ds.b    1       program has been edited ($ff) or not (0) */
.equ bv_edit,142
/* QL: bv_brk  ds.b    1       there has been a break (0) or not ($80) */
.equ bv_brk,143
/* QL: bv_unrvl ds.b   1       need to unravel ($ff) or not (0) */
.equ bv_unrvl,144
/* QL: bv_cnstm ds.b   1       statement to continue from */
.equ bv_cnstm,145
/* QL: bv_cnlno ds.w   1       line to continue from */
.equ bv_cnlno,146
/* QL: bv_dalno ds.w   1       current data line number */
.equ bv_dalno,148
/* QL: bv_dastm ds.b   1       current data statement number */
.equ bv_dastm,150
/* QL: bv_daitm ds.b   1       next data item to read */
.equ bv_daitm,151
/* QL: bv_cnind ds.w   1       inline loop index to continue with */
.equ bv_cnind,152
/* QL: bv_cninl ds.b   1       inline loop flag for continue */
.equ bv_cninl,154
/* QL: bv_lsany ds.b   1       whether checking list ($ff) or not (0) */
.equ bv_lsany,155
/* QL: bv_lsbef ds.w   1       invisible top line */
.equ bv_lsbef,156
/* QL: bv_lsbas ds.w   1       bottom line in window */
.equ bv_lsbas,158
/* QL: bv_lsaft ds.w   1       invisible bottom line */
.equ bv_lsaft,160
/* QL: bv_lenln ds.w   1       length of window line */
.equ bv_lenln,162
/* QL: bv_maxln ds.w   1       max number of window lines */
.equ bv_maxln,164
/* QL: * Note. the 2 following words will be overwritten on changing lenln and maxln: */
/* QL: bv_totln ds.w   1       number of window lines so far */
.equ bv_totln,166
/* QL:         ds.w    1       spare, but see above */
/* QL: bv_auto ds.b    1       whether auto/edit on ($ff) or off (0) */
.equ bv_auto,170
/* QL: bv_print ds.b   1       print from prtok ($ff) or leave in buffer (0) */
.equ bv_print,171
/* QL: bv_edlin ds.w   1       line number to edit next */
.equ bv_edlin,172
/* QL: bv_edinc ds.w   1       increment on auto edit range (+ve) or not auto (0) */
.equ bv_edinc,174
/* QL:         ds.l    1       bv_tkpos position of a4 in tklist on entry to proc */
/* QL:         ds.l    1       bv_ptemp temporary pointer for go_proc */
/* QL: bv_undo ds.b    1       undo rt stack immediately then redo procedure */
.equ bv_undo,184
/* QL: bv_arrow ds.b   1       up ($ff), down (1) or no (0) arrow on last line read */
.equ bv_arrow,185
/* QL: bv_lsfil ds.w   1       fill window when relisting at least to here */
.equ bv_lsfil,186
/* QL: bv_wrlno ds.w   1       when error line number */
.equ bv_wrlno,188
/* QL: bv_wrstm ds.b   1       statement */
.equ bv_wrstm,190
/* QL: bv_wrinl ds.b   1       inline ($ff) or not (0) */
.equ bv_wrinl,191
/* QL: bv_wherr ds.b   1       processing ($80) or not (0) */
.equ bv_wherr,192
/* QL: bv_erstm ds.b   1       last error statement (new, wa spare, we hope) */
.equ bv_erstm,193
/* QL: bv_error ds.l   1       last error number */
.equ bv_error,194
/* QL: bv_erlin ds.w   1       last error line */
.equ bv_erlin,198
/* QL: bv_wvnum ds.w   1       number of watched variables */
.equ bv_wvnum,200
/* QL: bv_wvbas ds.l   1       base of wv area wrt vvbas */
.equ bv_wvbas,202
/* QL:         ds.w    1       bv_lblen now spare, was used by fastload? */
/* QL:         ds.l    1       bv_lbuff now spare, ditto */
/* QL: bv_toe  ds.b    1       turn off enhancements: bit 7 int toks (was bv_filst) */
.equ bv_toe,212
/* QL:         ds.b    11      spare */
/* QL: bv_alchp ds.l   1       TK2 linked common heap allocations */
.equ bv_alchp,224
/* QL:         ds.l    2       spare */
/* QL: bv_qlibx ds.l   1       Qliberator stuff */
.equ bv_qlibx,236
/* QL:         ds.l    2       spare */
/* QL: bv_qliby ds.l   1       qliberator again! */
.equ bv_qliby,248
/* QL:         ds.l    1       spare */
/* QL: bv_end ; top of bv area */
.equ bv_end,256
/* QL:          list */
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
/* QL:         include 'win1_m_inc_io' */
/* QL: * basic I/O keys */
/* QL:         nolist */
/* QL: * trap #2 d0 codes */
/* QL: io.open equ     1       open channel */
.equ io.open,1
/* QL: io.close equ    2       close channel */
.equ io.close,2
/* QL: io.formt equ    3       format medium */
.equ io.formt,3
/* QL: io.delet equ    4       delete file */
.equ io.delet,4
/* QL: * trap #2 d3 codes */
/* QL: io.old  equ     0       open old (exclusive) file or device */
.equ io.old,0
/* QL: io.share equ    1       open shared (old) file */
.equ io.share,1
/* QL: io.new  equ     2       open new (exclusive) file */
.equ io.new,2
/* QL: io.overw equ    3       open overwrite (or open new) file */
.equ io.overw,3
/* QL: io.dir  equ     4       open directory */
.equ io.dir,4
/* QL: * trap #3 d0 codes */
/* QL: io.pend equ     0       check for pending input */
.equ io.pend,0
/* QL: io.fbyte equ    1       fetch a byte */
.equ io.fbyte,1
/* QL: io.fline equ    2       fetch a line of bytes */
.equ io.fline,2
/* QL: io.fstrg equ    3       fetch a string of bytes */
.equ io.fstrg,3
/* QL: io.edlin equ    4       edit a line */
.equ io.edlin,4
/* QL: io.sbyte equ    5       send a byte */
.equ io.sbyte,5
/* QL: io.sstrg equ    7       send a string of bytes */
.equ io.sstrg,7
/* QL:         list */
/* QL:         include 'win1_m_inc_fs' */
/* QL: * file system definitions */
/* QL:         nolist */
/* QL: fs.nmlen  equ    36     max length of file name */
.equ fs.nmlen,36
/* QL: fs.hdlen  equ    64     length of file system header */
.equ fs.hdlen,64
/* QL: * file system channel channel definition block */
/* QL:         offset  $18 ( = ch_end, end of standard channel header ) */
/* QL: fs_next ds.l    1       link to next file system channel */
.equ fs_next,24
/* QL: fs_acces ds.b   1       access mode */
.equ fs_acces,28
/* QL: fs_drive ds.b   1       drive id */
.equ fs_drive,29
/* QL: fs_filnr ds.w   1       file number */
.equ fs_filnr,30
/* QL: fs_nblok ds.w   1       block containing next byte */
.equ fs_nblok,32
/* QL: fs_nbyte ds.w   1       next byte in block */
.equ fs_nbyte,34
/* QL: fs_eblok ds.w   1       end of file (block) */
.equ fs_eblok,36
/* QL: fs_ebyte ds.w   1       end of file (byte in block) */
.equ fs_ebyte,38
/* QL: fs_cblok ds.l   1       pointer to table for current slave block */
.equ fs_cblok,40
/* QL: fs_updt ds.b    1       set if file is updated */
.equ fs_updt,44
/* QL:         ds.b    5       spare */
/* QL: fs_fname ds.w   1+fs.nmlen/2  length prefixed file name */
.equ fs_fname,50
/* QL: fs_spare ds.b   72 */
.equ fs_spare,88
/* QL: fs_end */
.equ fs_end,160
/* QL: * common part of a physical file system definition block */
/* QL:         offset  0 */
/* QL:         ds.b    $10 */
/* QL: fs_drivr ds.l   1       pointer to driver */
.equ fs_drivr,16
/* QL: fs_drivn ds.b   1       drive number */
.equ fs_drivn,20
/* QL:         ds.b    1 */
/* QL: fs_mname ds.w   1+10/2  length prefixed medium name */
.equ fs_mname,22
/* QL: fs_files ds.b   1       number of files open */
.equ fs_files,34
/* QL: * file system trap #3 codes */
/* QL: fs.check  equ    $40                check all pending operations */
.equ fs.check,0x40
/* QL: fs.flush  equ    $41                flush buffers */
.equ fs.flush,0x41
/* QL: fs.posab  equ    $42                position file pointer (absolute) */
.equ fs.posab,0x42
/* QL: fs.posre  equ    $43                position file pointer (relative) */
.equ fs.posre,0x43
/* QL: fs.mdinf  equ    $45                information about medium */
.equ fs.mdinf,0x45
/* QL: fs.heads  equ    $46                set file header */
.equ fs.heads,0x46
/* QL: fs.headr  equ    $47                read file header */
.equ fs.headr,0x47
/* QL: fs.load   equ    $48                load file */
.equ fs.load,0x48
/* QL: fs.save   equ    $49                save file */
.equ fs.save,0x49
/* QL: fs.renam  equ    $4a                rename file */
.equ fs.renam,0x4a
/* QL: fs.trunc  equ    $4b                truncate file */
.equ fs.trunc,0x4b
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
/* QL:         include 'win1_m_inc_nt' */
/* QL: * name table types */
/* QL:         nolist */
/* QL: * First byte */
/* QL: t.unset equ     0       unset (null if 2nd byte zero) */
.equ t.unset,0
/* QL: t.intern equ    1       internal value held on ri stack */
.equ t.intern,1
/* QL: t.var   equ     2       simple variable */
.equ t.var,2
/* QL: t.arr   equ     3       array (substring if 2nd byte zero) */
.equ t.arr,3
/* QL: t.bpr   equ     4       basic procedure */
.equ t.bpr,4
/* QL: t.bfn   equ     5       basic function */
.equ t.bfn,5
/* QL: t.rep   equ     6       repeat loop index */
.equ t.rep,6
/* QL: t.for   equ     7       for loop index */
.equ t.for,7
/* QL: t.mcp   equ     8       machine code procedure */
.equ t.mcp,8
/* QL: t.mcf   equ     9       machine code function */
.equ t.mcf,9
/* QL: * Second byte */
/* QL: t.str   equ     1       2 byte positive string length + char {+ pad} */
.equ t.str,1
/* QL: t.fp    equ     2       6 byte floating point */
.equ t.fp,2
/* QL: t.int   equ     3       2 byte signed integer */
.equ t.int,3
/* QL: t.log   equ     4       2 byte 0=false 1=true (internal only) */
.equ t.log,4
/* QL: * Second word is name pointer. This is either the offset into the name list, or */
/* QL: * may be -1 if no name is applicable. */
/* QL: * Second longword is the value pointer. Generally this is an offset into the */
/* QL: * variable values area, or -1 to indicate an unset entry. */
/* QL: * For t.mcp/t.mcf this is the absolute entry point. */
/* QL: * For t.bpr/t.bfn the msw is the define line number. */
/* QL:  list */
/* QL:         include 'win1_m_inc_vect4000' */
/* QL: * Macro for defining vector entry points that are offset by $4000 */
/* QL:         nolist */
/* QL: vect4000 macro */
/* QL:         list */
/* QL:         section bp_files */
.section bp_files,"ax"
/* QL: * Load and start program */
/* QL: * EXEC{_W}<filename>{,#<chan>}...{;<parameter string>} */
/* QL: bp_execw */
bp_execw:
/* QL:         moveq   #-1,d7          wait on activation */
    moveq #(-1),d7
/* QL: bp_exec */
bp_exec:
/* QL:         moveq   #$70,d1 */
    moveq #0x70,d1
/* QL:         and.b   -7(a6,a5.l),d1 */
    and.b (-7)(a6,a5.l),d1
/* QL:         bne.s   err_bpne        mustn't have any trailing delimiter */
    bne.s err_bpne
/* QL:         tst.b   1(a6,a3.l) */
    tst.b 1(a6,a3.l)
/* QL:         bmi.s   err_bpne        mustn't have hash before 1st parameter */
    bmi.s err_bpne
/* QL:         addq.l  #8,a3           forget filename for a while */
    addq.l #8,a3
/* QL:         moveq   #$50,d5         mask for last param and flag no string */
    moveq #0x50,d5
/* QL:         moveq   #0,d6           extra data space needed for parameters */
    moveq #0,d6
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         blt.s   err_bpne        must have at least one parameter */
    blt.s err_bpne
/* QL:         move.l  a3,a0 */
    move.l a3,a0
/* QL:         beq.s   chnent */
    beq.s chnent
/* QL:         tst.b   -7(a6,a5.l) */
    tst.b (-7)(a6,a5.l)
/* QL:         bmi.s   chnent          no hash allowed on string */
    bmi.s chnent
/* QL:         and.b   -15(a6,a5.l),d5 delimiter before last param a ';'? (no nulls) */
    and.b (-15)(a6,a5.l),d5
/* QL:         bne.s   chnent          no, so no string */
    bne.s chnent
/* QL:         subq.l  #8,a5           string will be put waiting on stack */
    subq.l #8,a5
/* QL:         move.l  a5,a3 */
    move.l a5,a3
/* QL:         bsr.l   bp_fnamx */
    bsr.w bp_fnamx
/* QL:         bne.s   rts9            ouch! string didn't work out! */
    bne.s rts9
/* QL:         move.w  0(a6,a1.l),d6 */
    move.w 0(a6,a1.l),d6
/* QL:         addq.l  #1,d6 */
    addq.l #1,d6
/* QL:         bclr    d0,d6           round up string length */
    bclr d0,d6
/* QL:         move.l  a0,a3 */
    move.l a0,a3
/* QL:         bra.s   chnent */
    bra.s chnent
/* QL: * N.B. As we have already verified that the last delimiter is not a comma... */
/* QL: chnloop */
chnloop:
/* QL:         moveq   #$60,d0         won't find a null delimiter, they don't happen */
    moveq #0x60,d0
/* QL:         and.b   -7(a6,a0.l),d0  must be a comma ($10) before the #<channel> */
    and.b (-7)(a6,a0.l),d0
/* QL:         bne.s   err_bpne */
    bne.s err_bpne
/* QL:         addq.l  #4,d6           increase extra data space required */
    addq.l #4,d6
/* QL:         addq.l  #8,a0           move to next param */
    addq.l #8,a0
/* QL: chnent */
chnent:
/* QL:         tst.b   1(a6,a0.l)      check for hash before parameter */
    tst.b 1(a6,a0.l)
/* QL:         bmi.s   chnloop */
    bmi.s chnloop
/* QL:         cmp.l   a0,a5           we should have done all the parameters by now */
    cmp.l a0,a5
/* QL: err_bpne */
err_bpne:
/* QL:         bne.l   err_bp */
    bne.w err_bp
/* QL:         jsr     ca_gtlin(pc)    get them all as long ints (keeps bv_rip nice) */
    jsr ca_gtlin(pc)
/* QL:         move.w  d3,a4           save channel count */
    move.w d3,a4
/* QL:         beq.s   cvtent */
    beq.s cvtent
/* QL: rts9 */
rts9:
/* QL:         rts */
    rts 
/* QL: cvtloop */
cvtloop:
/* QL: *       tst.w   0(a6,a1.l)      (lets no be too pedantic here) */
/* QL: *       bne.s   err_bpne */
/* QL:         move.w  2(a6,a1.l),d1 */
    move.w 2(a6,a1.l),d1
/* QL:         jsr     bp_chnid(pc)    convert them all to channel ids */
    jsr bp_chnid(pc)
/* QL:         bne.s   rts9 */
    bne.s rts9
/* QL:         move.l  a0,0(a6,a1.l) */
    move.l a0,0(a6,a1.l)
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL: cvtent */
cvtent:
/* QL:         dbra    d3,cvtloop */
    dbra d3,cvtloop
/* QL:         subq.l  #8,a3           stack data ready, go back to first param */
    subq.l #8,a3
/* QL:         bsr.s   wantload        open read only and get header (d2=length) */
    bsr.s wantload
/* QL:         bne.s   rts9 */
    bne.s rts9
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         subq.b  #1,md_detyp(a6,a1.l) is it an executable file? */
    subq.b #1,md_detyp(a6,a1.l)
/* QL:         bne.s   close_l */
    bne.s close_l
/* QL:         moveq   #mt.cjob,d0     yes, create job */
    moveq #mt.cjob,d0
/* QL:         moveq   #-1,d1          we are the parent */
    moveq #(-1),d1
/* QL:         move.l  md_deinf(a6,a1.l),d3 get length of data space */
    move.l md_deinf(a6,a1.l),d3
/* QL:         add.l   d6,d3           add our extra parameters length */
    add.l d6,d3
/* QL:         move.l  a0,a3           save chan */
    move.l a0,a3
/* QL:         bsr.s   trap1z          (a1=0, start at beginning) */
    bsr.s trap1z
/* QL:         move.l  a0,a1           base address in a1 for load */
    move.l a0,a1
/* QL:         exg     a0,a3           put back chan, save job base */
    exg a3,a0
/* QL:         bne.s   close_l */
    bne.s close_l
/* QL:         move.l  d1,a2           save job id */
    move.l d1,a2
/* QL:         bsr.s   doload          and load file */
    bsr.s doload
/* QL:         bne.s   rjob            did read fail? */
    bne.s rjob
/* QL:         sub.l   d6,jb_a0+7*4-jb_end(a3) adjust the stack pointer */
    sub.l d6,((jb_a0+(7*4))-jb_end)(a3)
/* QL:         move.l  jb_a0+7*4-jb_end(a3),a0 get the stack pointer */
    move.l ((jb_a0+(7*4))-jb_end)(a3),a0
/* QL:         move.w  a4,(a0)+        store channel count */
    move.w a4,(a0)+
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         bne.s   lenok           if no string, zero string len already on stack */
    bne.s lenok
/* QL:         addq.l  #2,d6           include string length word in amount to move */
    addq.l #2,d6
/* QL: lenok */
lenok:
/* QL:         move.l  bv_rip(a6),a1 */
    move.l bv_rip(a6),a1
/* QL:         move.w  0(a6,a1.l),d5   we have to skip the device/file name */
    move.w 0(a6,a1.l),d5
/* QL:         addq.l  #3,d5 */
    addq.l #3,d5
/* QL:         bclr    d0,d5 */
    bclr d0,d5
/* QL:         add.l   d5,a1 */
    add.l d5,a1
/* QL:         move.l  d6,d1 */
    move.l d6,d1
/* QL:         jsr     mm_mrtoa(pc)    copy all our info into job's stack */
    jsr mm_mrtoa(pc)
/* QL:         moveq   #mt.activ,d0    activate job */
    moveq #mt.activ,d0
/* QL:         move.l  a2,d1           reload job id */
    move.l a2,d1
/* QL:         moveq   #32,d2          priority */
    moveq #32,d2
/* QL:         move.w  d7,d3           set timeout (0 for exec, -1 for exec_w) */
    move.w d7,d3
/* QL:         bsr.s   trap1           any errors? */
    bsr.s trap1
/* QL:         bne.s   rjob            yes, remove job */
    bne.s rjob
/* QL:         tst.w   d7              did we wait? */
    tst.w d7
/* QL:         bne.s   rts0            yes, done */
    bne.s rts0
/* QL:         moveq   #mt.susjb,d0    suspend job */
    moveq #mt.susjb,d0
/* QL:         moveq   #-1,d1          myself */
    moveq #(-1),d1
/* QL:         moveq   #50/2,d3        wait half a sec to give new job a chance */
    moveq #(50/2),d3
/* QL: trap1z */
trap1z:
/* QL:         sub.l   a1,a1           clear flag address */
    sub.l a1,a1
/* QL: trap1 */
trap1:
/* QL:         trap    #1 */
    trap #1
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: rts0 */
rts0:
/* QL:         rts */
    rts 
/* QL: rjob */
rjob:
/* QL:         move.l  d0,d4 */
    move.l d0,d4
/* QL:         moveq   #mt.rjob,d0     could not load or activate */
    moveq #mt.rjob,d0
/* QL:         move.l  a2,d1           ... remove the job */
    move.l a2,d1
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  d4,d0           restore error key */
    move.l d4,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d2 -  o- file size */
/* QL: * a0 -  o- channel id */
/* QL: * a3 -i o- start of parameters, eight added */
/* QL: * a5 -ip - end of parameters */
/* QL: * d1/d3-d4/a1 destroyed */
/* QL: wantload */
wantload:
/* QL:         bsr.l   bp_fopin        open file for loading */
    bsr.w bp_fopin
/* QL:         bne.s   rts1 */
    bne.s rts1
/* QL:         bsr.s   gethdr          get header and put length in d2 */
    bsr.s gethdr
/* QL: close_l */
close_l:
/* QL:         bne.s   close_s */
    bne.s close_s
/* QL: rts1 */
rts1:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d2 -  o- file size */
/* QL: * a0 -i  - channel id */
/* QL: * d1/d3/a1 destroyed */
/* QL: gethdr */
gethdr:
/* QL:         moveq   #fs.headr,d0    fetch the header */
    moveq #fs.headr,d0
/* QL:         moveq   #md_denam,d2 */
    moveq #md_denam,d2
/* QL:         bsr.l   trp3b           into the buffer */
    bsr.w trp3b
/* QL:         move.l  bv_bfbas(a6),a1 */
    move.l bv_bfbas(a6),a1
/* QL:         move.l  md_delen(a6,a1.l),d2 get file length */
    move.l md_delen(a6,a1.l),d2
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * load bytes: LBYTES<filename>,<address> */
/* QL: bp_lbyts */
bp_lbyts:
/* QL:         moveq   #1,d5           just one parameter wanted */
    moveq #1,d5
/* QL:         bsr.s   gtlin           get start address */
    bsr.s gtlin
/* QL:         bsr.s   wantload        (d2=length) */
    bsr.s wantload
/* QL:         move.l  (sp)+,a1        get start address */
    move.l (sp)+,a1
/* QL:         bne.s   rts1 */
    bne.s rts1
/* QL: doload */
doload:
/* QL:         moveq   #fs.load,d0 */
    moveq #fs.load,d0
/* QL:         bsr.l   trap3 */
    bsr.w trap3
/* QL: close_s */
close_s:
/* QL:         bra.s   close */
    bra.s close
/* QL: * Get long integers after 1st parameter */
/* QL: * If no error is reported, d1 is also returned on the top of the stack */
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- 2nd parameter (verified as even) */
/* QL: * d2 -  o- 3rd parameter (default 0) */
/* QL: * d5 -i  - maximum number of parameters required */
/* QL: * d7 -i o- default 6th parameter / 6th parameter */
/* QL: * a0 -  o- 4th parameter (default 0) */
/* QL: * a2 -  o- 5th parameter (default 0) */
/* QL: * a3 -ip - start of parameters */
/* QL: * a5 -i o- end of parameters (output as 8(a3)) */
/* QL: * d3-d4/d6/a4 destroyed */
/* QL: gtlin */
gtlin:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         addq.l  #8,a3           step past 1st parameter */
    addq.l #8,a3
/* QL:         cmp.l   a5,a3 */
    cmp.l a5,a3
/* QL:         bge.s   err_bp1         minimum two parameters */
    bge.s err_bp1
/* QL:         jsr     ca_gtlin(pc)    get arguments */
    jsr ca_gtlin(pc)
/* QL:         bne.s   rts1 */
    bne.s rts1
/* QL:         cmp.l   d3,d5 */
    cmp.l d3,d5
/* QL:         bcs.s   err_bp1 */
    bcs.s err_bp1
/* QL:         lsl.l   #2,d3 */
    lsl.l #2,d3
/* QL:         add.l   d3,bv_rip(a6) */
    add.l d3,bv_rip(a6)
/* QL:         movem.l 0(a6,a1.l),d1-d2/a0/a2/a5 start{,length{,data{,xtra{,type}}}} */
    movem.l 0(a6,a1.l),d1-d2/a0/a2/a5
/* QL:         lsr.l   #1,d3 */
    lsr.l #1,d3
/* QL:         jmp     zaparg-5*2(pc,d3.w) */
.word 0x4efb
.word 12288|(((zaparg-(5*2))-.)&255)
/* QL:         moveq   #0,d2           start,0,0,0,d7 */
    moveq #0,d2
/* QL:         sub.l   a0,a0           start,length,0,0,d7 */
    sub.l a0,a0
/* QL:         sub.l   a2,a2           start,length,data,0,d7 */
    sub.l a2,a2
/* QL:         move.w  d7,a5           start,length,data,xtra,d7 */
    move.w d7,a5
/* QL: zaparg                         ;start,length,data,xtra,type */
zaparg:
/* QL:         move.w  a5,d7 */
    move.w a5,d7
/* QL:         btst    d0,d1 */
    btst d0,d1
/* QL:         bne.s   err_bp1 */
    bne.s err_bp1
/* QL:         move.l  a3,a5 */
    move.l a3,a5
/* QL:         subq.l  #8,a3           return to 1st parameter */
    subq.l #8,a3
/* QL:         move.l  d1,-(sp) */
    move.l d1,-(sp)
/* QL:         jmp     (a4) */
    jmp (a4)
/* QL: err_bp1 */
err_bp1:
/* QL:         bra.s   err_bp */
    bra.s err_bp
/* QL: * Save executable code or bytes: */
/* QL: * SEXEC|SBYTES<filename>,<address>{,<length>{,<data>{,<extra>{,<acc/type>}}}} */
/* QL: bp_sexec */
bp_sexec:
/* QL:         moveq   #1,d7           file type 1 */
    moveq #1,d7
/* QL: bp_sbyts */
bp_sbyts:
/* QL:         moveq   #5,d5           at most five arguments */
    moveq #5,d5
/* QL:         bsr.s   gtlin           get arguments */
    bsr.s gtlin
/* QL:         move.l  bv_bfbas(a6),a1 */
    move.l bv_bfbas(a6),a1
/* QL:         assert  md_delen,md_deacs-4,md_detyp-5,md_deinf-6 */
/* original assertion: md_delen,md_deacs-4,md_detyp-5,md_deinf-6 */
/* QL:         movem.l d7/a0/a2,md_delen+2(a6,a1.l) access,type,data,xtra */
    movem.l d7/a0/a2,(md_delen+2)(a6,a1.l)
/* QL:         move.l  d2,md_delen(a6,a1.l) length */
    move.l d2,md_delen(a6,a1.l)
/* QL:         blt.s   bp_pop          don't allow silly lengths (sexec<10 is silly!) */
    blt.s bp_pop
/* QL:         bsr.s   fopnew */
    bsr.s fopnew
/* QL:         bne.l   poprts */
    bne.w poprts
/* QL:         moveq   #fs.heads,d0    set header */
    moveq #fs.heads,d0
/* QL:         bsr.s   trp3b */
    bsr.s trp3b
/* QL:         move.l  (sp)+,a1 */
    move.l (sp)+,a1
/* QL:         bne.s   close */
    bne.s close
/* QL:         moveq   #fs.save,d0     save file in toto */
    moveq #fs.save,d0
/* QL:         bsr.s   trap3 */
    bsr.s trap3
/* QL:         bra.s   close           close the file */
    bra.s close
/* QL: * File delete: DELETE<filename> */
/* QL: bp_delee */
bp_delee:
/* QL:         bsr.s   bp_fname */
    bsr.s bp_fname
/* QL:         bne.s   rts2            couldn't get filename parameter */
    bne.s rts2
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         bne.s   err_bp          wasn't just one parameter */
    bne.s err_bp
/* QL:         moveq   #io.delet,d0 */
    moveq #io.delet,d0
/* QL:         bra.s   trp2me */
    bra.s trp2me
/* QL: * Saves current basic program in ASCII: SAVE<filename>{,<start>{to<end>}} */
/* QL: bp_save */
bp_save:
/* QL:         bsr.s   fopnew          save on a new file only */
    bsr.s fopnew
/* QL:         bne.s   rts2 */
    bne.s rts2
/* QL:         jsr     bp_listd(pc)    and continue just as list */
    jsr bp_listd(pc)
/* QL: close */
close:
/* QL:         move.l  d0,d4           save error flag */
    move.l d0,d4
/* QL: close_n */
close_n:
/* QL:         moveq   #io.close,d0    and close file */
    moveq #io.close,d0
/* QL:         trap    #2 */
    trap #2
/* QL:         move.l  d4,d0 */
    move.l d4,d0
/* QL: rts2 */
rts2:
/* QL:         rts */
    rts 
/* QL: fopnew */
fopnew:
/* QL:         moveq   #io.new,d4 */
    moveq #io.new,d4
/* QL:         bra.s   fopen */
    bra.s fopen
/* QL: bp_pop */
bp_pop:
/* QL:         addq.l  #4,sp           remove return address */
    addq.l #4,sp
/* QL: err_bp */
err_bp:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL:         rts */
    rts 
/* QL: trp3b */
trp3b:
/* QL:         move.l  bv_bfbas(a6),a1 use basic buffer */
    move.l bv_bfbas(a6),a1
/* QL: trp3r */
trp3r:
/* QL:         trap    #4              next trap is relative a1 */
    trap #4
/* QL: trap3 */
trap3:
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         trap    #3 */
    trap #3
/* QL:         bra.s   tstrts3 */
    bra.s tstrts3
/* QL: * Get a file name */
/* QL: * d0 -  o- error code */
/* QL: * a1 -  o- ri pointer to file name string (if d0=0) */
/* QL: * a3 -i o- name table entry to look at (update by 8 if a3<a5) */
/* QL: * a5 -ip - top of name table entries (if <= a3, bad param, skipped by fnamx) */
/* QL: bp_fname */
bp_fname:
/* QL:         cmp.l   a5,a3           is there a name */
    cmp.l a5,a3
/* QL:         bge.s   bp_pop          nope, that's silly */
    bge.s bp_pop
/* QL: bp_fnamx */
bp_fnamx:
/* QL:         movem.l d1-d2/a4-a5,-(sp) */
    movem.l d1-d2/a4-a5,-(sp)
/* QL:         jsr     bp_rdchk(pc)    could it be given a value? */
    jsr bp_rdchk(pc)
/* QL:         movem.w 0(a6,a3.l),d0-d2 grab name table bits */
    movem.w 0(a6,a3.l),d0-d2
/* QL:         addq.l  #8,a3           update a3 now */
    addq.l #8,a3
/* QL:         bne.s   fnam_nam        can't assign, so we certainly need its name */
    bne.s fnam_nam
/* QL:         asl.w   #7,d0           is it unset? (it's never -1 in msb) */
    asl.w #7,d0
/* QL:         bvc.s   fnam_nam        yes, unset variable, so use its name */
    bvc.s fnam_nam
/* QL:         lsl.w   #16-7-2,d0      is it a (sub)string? (bit 2 should have been 0) */
    lsl.w #((16-7)-2),d0
/* QL:         or.w    d2,d0           and does it truly have a value? */
    or.w d2,d0
/* QL:         bmi.s   fnam_nam        fp/int or no value offset, so we use its name */
    bmi.s fnam_nam
/* QL:         move.l  a3,a5           copy to a5 for ca_etos */
    move.l a3,a5
/* QL:         jsr     ca_etos(pc)     force string value onto ri stack */
    jsr ca_etos(pc)
/* QL:         bra.s   fnam_pop        done */
    bra.s fnam_pop
/* QL: fnam_nam */
fnam_nam:
/* QL:         moveq   #err.bn,d0 */
    moveq #err.bn,d0
/* QL:         asl.l   #3,d1           make offset to original nt entry */
    asl.l #3,d1
/* QL:         bmi.s   fnam_pop        user boobed - nt ref was negative */
    bmi.s fnam_pop
/* QL:         add.l   bv_ntbas(a6),d1 original nt entry */
    add.l bv_ntbas(a6),d1
/* QL:         move.l  bv_nlbas(a6),a4 name list base */
    move.l bv_nlbas(a6),a4
/* QL:         add.w   2(a6,d1.l),a4   point at name */
    add.w 2(a6,d1.l),a4
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.b  0(a6,a4.l),d1   no of chars in name (byte!) */
    move.b 0(a6,a4.l),d1
/* QL:         addq.l  #1,a4           beg of chars for ca_putss */
    addq.l #1,a4
/* QL:         jsr     ca_putss(pc)    put the variable's name on the ri stack */
    jsr ca_putss(pc)
/* QL: fnam_pop */
fnam_pop:
/* QL:         movem.l (sp)+,d1-d2/a4-a5 */
    movem.l (sp)+,d1-d2/a4-a5
/* QL:         rts */
    rts 
/* QL: * Open a file */
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- own job id */
/* QL: * d4 -ip - open type (set to io.share at bp_fopin) */
/* QL: * a0 -  o- channel id */
/* QL: * a3 -i o- start of parameters (8 added) */
/* QL: * a5 -ip - end of parameters */
/* QL: * d3/a1 destroyed */
/* QL: bp_fopin */
bp_fopin:
/* QL:         moveq   #io.share,d4    open read only file */
    moveq #io.share,d4
/* QL: fopen */
fopen:
/* QL:         bsr.s   bp_fname */
    bsr.s bp_fname
/* QL:         bne.s   rts3 */
    bne.s rts3
/* QL:         move.l  d4,d3           put open key in correct register */
    move.l d4,d3
/* QL: trp_open */
trp_open:
/* QL:         moveq   #io.open,d0     open channel */
    moveq #io.open,d0
/* QL: trp2me */
trp2me:
/* QL:         moveq   #-1,d1          for this job */
    moveq #(-1),d1
/* QL: trp2r */
trp2r:
/* QL:         move.l  a1,a0 */
    move.l a1,a0
/* QL:         trap    #4              a0 relative to a6 */
    trap #4
/* QL:         trap    #2 */
    trap #2
/* QL: tstrts3 */
tstrts3:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: rts3 */
rts3:
/* QL:         rts */
    rts 
/* QL: * Check for optional #chan followed by filename */
/* QL: * Skips return address on any error, leaving just d0 set to error code */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- #chan number */
/* QL: * d5 -  o- #chan channel id (default #1) */
/* QL: * a1 -  o- ri stack pointer to filename string */
/* QL: * a2 -  o- pointer to #chan block */
/* QL: * a3 -i o- start of parameters (16 added) */
/* QL: * a5 -ip - end of parameters */
/* QL: ch_fname */
ch_fname:
/* QL:         jsr     bp_chan(pc)     get channel */
    jsr bp_chan(pc)
/* QL:         bne.s   poprts */
    bne.s poprts
/* QL:         move.l  a0,d5           save id */
    move.l a0,d5
/* QL:         bsr.s   bp_fname        get file name */
    bsr.s bp_fname
/* QL:         bne.s   poprts */
    bne.s poprts
/* QL:         cmp.l   a5,a3           that should have been the last parameter */
    cmp.l a5,a3
/* QL:         beq.s   rts3 */
    beq.s rts3
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: poprts */
poprts:
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * Directory listing: DIR{#<chan>,}<filename> */
/* QL: bp_dir */
bp_dir:
/* QL:         bsr.s   ch_fname        get optional #n and file name */
    bsr.s ch_fname
/* QL:         moveq   #io.dir,d3      open with directory key */
    moveq #io.dir,d3
/* QL:         bsr.s   trp_open */
    bsr.s trp_open
/* QL:         bne.s   rts3 */
    bne.s rts3
/* QL:         move.l  a0,a5           save directory channel */
    move.l a0,a5
/* QL:         moveq   #fs.mdinf,d0    get information about the medium... */
    moveq #fs.mdinf,d0
/* QL:         bsr.l   trp3b           ... into the basic buffer */
    bsr.w trp3b
/* QL: closene */
closene:
/* QL:         bne.l   close */
    bne.w close
/* QL:         move.l  d1,-(sp)        save the sector counts */
    move.l d1,-(sp)
/* QL:         move.l  bv_bfbas(a6),a1 write out the medium name */
    move.l bv_bfbas(a6),a1
/* QL:         moveq   #10,d2 */
    moveq #10,d2
/* QL:         bsr.s   w_s_nl */
    bsr.s w_s_nl
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         moveq   #0,d4           preset the saved error flag */
    moveq #0,d4
/* QL:         bsr.s   sector          write the sector counts */
    bsr.s sector
/* QL: dir_loop */
dir_loop:
/* QL:         move.l  a5,a0 */
    move.l a5,a0
/* QL:         bne.s   closene */
    bne.s closene
/* QL:         tst.b   bv_brk(a6)      is there a break? */
    tst.b bv_brk(a6)
/* QL:         bpl.l   close           yes - get out now (leaving break set) */
    bpl.w close
/* QL:         moveq   #io.fstrg,d0    now fetch the directory entries */
    moveq #io.fstrg,d0
/* QL:         moveq   #md_deend,d2 */
    moveq #md_deend,d2
/* QL:         bsr.l   trp3b           into the basic buffer */
    bsr.w trp3b
/* QL:         bne.l   close_n */
    bne.w close_n
/* QL:         tst.l   md_delen-md_deend(a6,a1.l) */
    tst.l (md_delen-md_deend)(a6,a1.l)
/* QL:         beq.s   dir_loop        ignore zero length files */
    beq.s dir_loop
/* QL:         move.w  md_denam-md_deend(a6,a1.l),d2  set the character count */
    move.w (md_denam-md_deend)(a6,a1.l),d2
/* QL:         lea     md_denam+2-md_deend(a1),a1 go to the start of the name */
    lea ((md_denam+2)-md_deend)(a1),a1
/* QL:         bsr.s   w_s_nl          write out with newline */
    bsr.s w_s_nl
/* QL:         bra.s   dir_loop */
    bra.s dir_loop
/* QL: * Format medium: FORMAT{#<chan>,}<filename> */
/* QL: bp_formt */
bp_formt:
/* QL:         bsr.s   ch_fname        get optional #n and file name... */
    bsr.s ch_fname
/* QL:         moveq   #io.formt,d0    ... and format */
    moveq #io.formt,d0
/* QL:         bsr.s   trp2r */
    bsr.s trp2r
/* QL:         bne.s   rts4 */
    bne.s rts4
/* QL:         swap    d1 */
    swap d1
/* QL:         move.w  d2,d1           set up like md.inf */
    move.w d2,d1
/* QL: sector */
sector:
/* QL:         move.l  bv_bfbas(a6),a1 */
    move.l bv_bfbas(a6),a1
/* QL:         move.l  d1,0(a6,a1.l) */
    move.l d1,0(a6,a1.l)
/* QL:         lea     4(a1),a0 */
    lea 4(a1),a0
/* QL:         jsr     cn_itod(pc)     convert first one */
    jsr cn_itod(pc)
/* QL:         move.b  #'/',0(a6,a0.l) */
    move.b #(47&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         jsr     cn_itod(pc)     convert second one */
    jsr cn_itod(pc)
/* QL:         bsr.s   w_strg          write them both out */
    bsr.s w_strg
/* QL:         moveq   #err.sc,d0 */
    moveq #err.sc,d0
/* QL:         jsr     ut_err(pc)      now write ' sectors' */
    jsr ut_err(pc)
/* QL:         moveq   #0,d0           ensure a correct return */
    moveq #0,d0
/* QL: rts4 */
rts4:
/* QL:         rts */
    rts 
/* QL: w_s_nl */
w_s_nl:
/* QL:         lea     1(a1,d2.w),a0 */
    lea 1(a1,d2.w),a0
/* QL:         move.b  #10,-1(a6,a0.l) tack a newline on the end of the string */
    move.b #(10&255),(-1)(a6,a0.l)
/* QL: w_strg */
w_strg:
/* QL:         move.w  a0,d2 */
    move.w a0,d2
/* QL:         sub.w   a1,d2 */
    sub.w a1,d2
/* QL:         moveq   #io.sstrg,d0    write string */
    moveq #io.sstrg,d0
/* QL:         move.l  d5,a0           output channel */
    move.l d5,a0
/* QL: trp3r1 */
trp3r1:
/* QL:         bra.l   trp3r */
    bra.w trp3r
/* QL: * Copy file to file (with or without header): COPY{_N}<fromfile>,<tofile> */
/* QL: bp_copyn */
bp_copyn:
/* QL:         moveq   #-1,d7          set length unknown */
    moveq #(-1),d7
/* QL: bp_copy */
bp_copy:
/* QL:         bsr.l   bp_fopin        set source... */
    bsr.w bp_fopin
/* QL:         bne.s   rts4 */
    bne.s rts4
/* QL:         move.l  a0,d5 */
    move.l a0,d5
/* QL:         bsr.l   fopnew          ... and destination */
    bsr.w fopnew
/* QL:         bne.s   close_1 */
    bne.s close_1
/* QL:         subq.l  #1,d7           was header required (d7.l now -1 or -2) */
    subq.l #1,d7
/* QL:         bcc.s   copy_lop        if it went to -2, we're not doing the header */
    bcc.s copy_lop
/* QL:         exg     a0,d5 */
    exg a0,d5
/* QL:         bsr.l   gethdr          read header into buffer (d2=length) */
    bsr.w gethdr
/* QL:         exg     a0,d5 */
    exg a0,d5
/* QL:         bne.s   copy_lop        if no header from this device, carry on */
    bne.s copy_lop
/* QL:         move.l  d2,d7           set length of file... */
    move.l d2,d7
/* QL:         moveq   #fs.heads,d0    ... and set header */
    moveq #fs.heads,d0
/* QL:         bsr.s   trp3r1 */
    bsr.s trp3r1
/* QL: copy_lop */
copy_lop:
/* QL:         move.l  bv_bfbas(a6),a1 set buffer base address */
    move.l bv_bfbas(a6),a1
/* QL:         move.l  bv_bfbas+8(a6),d2 use next base as top of area */
    move.l (bv_bfbas+8)(a6),d2
/* QL:         sub.l   a1,d2           buffer length (*** we assume this is < 65536!) */
    sub.l a1,d2
/* QL:         exg     a0,d5           get the right file id */
    exg a0,d5
/* QL:         cmp.l   d7,d2           is buffer greater than remaining number */
    cmp.l d7,d2
/* QL:         bls.s   copy_try */
    bls.s copy_try
/* QL:         tst.l   d7              is file length known (and greater than 0) */
    tst.l d7
/* QL:         ble.s   copy_try */
    ble.s copy_try
/* QL:         move.l  d7,d2           just fetch the remaining number of bytes */
    move.l d7,d2
/* QL: copy_try */
copy_try:
/* QL:         tst.b   bv_brk(a6)      is there a break? */
    tst.b bv_brk(a6)
/* QL:         bpl.s   close_2         yes - get out now (leaving break set) */
    bpl.s close_2
/* QL:         moveq   #io.fstrg,d0    fetch as many bytes as possible */
    moveq #io.fstrg,d0
/* QL:         moveq   #err.nc-err.ef,d3 don't hang about long (was 5, now 9) */
    moveq #(err.nc-err.ef),d3
/* QL:         trap    #4 */
    trap #4
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  d0,d2 */
    move.l d0,d2
/* QL:         beq.s   copy_w          no problems, go write it out */
    beq.s copy_w
/* QL:         addq.l  #-err.nc,d2 */
.word 20610|((((-err.nc))&7)<<9)
/* QL:         beq.s   copy_w          not complete, go write it out */
    beq.s copy_w
/* QL:         add.l   d3,d2 */
    add.l d3,d2
/* QL:         bne.s   close_2         if not eof, bad error */
    bne.s close_2
/* QL:         moveq   #0,d0           we expected eof eventually */
    moveq #0,d0
/* QL:         tst.w   d1              if eof and no bytes read, we've finished */
    tst.w d1
/* QL:         beq.s   close_2 */
    beq.s close_2
/* QL: copy_w */
copy_w:
/* QL:         moveq   #io.sstrg,d0    write as much as we have read */
    moveq #io.sstrg,d0
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         exg     a0,d5 */
    exg a0,d5
/* QL:         bsr.l   trp3b */
    bsr.w trp3b
/* QL:         bne.s   close_2 */
    bne.s close_2
/* QL:         sub.l   d2,d7           how many left (top end of d2 is be 0) */
    sub.l d2,d7
/* QL:         bne.s   copy_lop        if any bytes left, fetch them */
    bne.s copy_lop
/* QL: close_2 */
close_2:
/* QL:         bsr.s   close_b         close one file... */
    bsr.s close_b
/* QL: close_1 */
close_1:
/* QL:         exg     a0,d5           ... and the other */
    exg a0,d5
/* QL: close_b */
close_b:
/* QL:         bra.l   close */
    bra.w close
/* QL: * Close channels: CLOSE{#<chan>{,#<chan>}...} */
/* QL: * No parameters = close all channels above #2 */
/* QL: bp_close */
bp_close:
/* QL:         moveq   #3,d1           ready to close #3 and above */
    moveq #3,d1
/* QL:         cmp.l   a3,a5           are there any parameters at all? */
    cmp.l a3,a5
/* QL:         beq.s   clall           no, so close #3 and all above */
    beq.s clall
/* QL: cllist */
cllist:
/* QL:         bsr.s   opclose         close a channel from the list */
    bsr.s opclose
/* QL:         bne.s   rts5            any problem (other than not open) is bad */
    bne.s rts5
/* QL:         cmp.l   a3,a5           check if any more parameters left */
    cmp.l a3,a5
/* QL:         bne.s   cllist          carry on to end of list */
    bne.s cllist
/* QL:         rts */
    rts 
/* QL: clthis */
clthis:
/* QL:         bsr.s   clblot          wipe out id in slot and close the channel */
    bsr.s clblot
/* QL: clnext */
clnext:
/* QL:         addq.l  #1,d1 */
    addq.l #1,d1
/* QL: clall */
clall:
/* QL:         jsr     bp_chnid(pc)    check this # channel */
    jsr bp_chnid(pc)
/* QL:         beq.s   clthis          a real, open slot, so close it */
    beq.s clthis
/* QL:         subx.l  d0,d0           is there actually a closed slot here? */
    subx.l d0,d0
/* QL:         bmi.s   clnext          yes, keep going */
    bmi.s clnext
/* QL:         rts */
    rts 
/* QL: opclose */
opclose:
/* QL:         cmp.l   a3,a5           check for at least one parameter */
    cmp.l a3,a5
/* QL:         ble.s   err_bp2 */
    ble.s err_bp2
/* QL:         tst.b   1(a6,a3.l)      must be preceeded by a hash */
    tst.b 1(a6,a3.l)
/* QL:         bpl.s   err_bp2 */
    bpl.s err_bp2
/* QL:         jsr     bp_chan(pc)     read the channel no & see if it's there */
    jsr bp_chan(pc)
/* QL:         bne.s   chn_err         wrong number or channel not open */
    bne.s chn_err
/* QL: clblot */
clblot:
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         move.l  d2,0(a6,a2.l)   blot out the ch id in the list */
    move.l d2,0(a6,a2.l)
/* QL:         bra.s   close_b         and close it in reality */
    bra.s close_b
/* QL: err_bp2 */
err_bp2:
/* QL:         moveq   #err.bp,d0 */
    moveq #err.bp,d0
/* QL: chn_err */
chn_err:
/* QL:         addq.l  #-err.no,d0     channel not open is ok */
.word 20608|((((-err.no))&7)<<9)
/* QL:         beq.s   rts5 */
    beq.s rts5
/* QL:         subq.l  #-err.no,d0 */
.word 20864|((((-err.no))&7)<<9)
/* QL: rts5 */
rts5:
/* QL:         rts */
    rts 
/* QL: * Open a channel: OPEN|OPEN_IN|OPEN_NEW#<chan>,<filename>{,<opentype>} */
/* QL: bp_openw */
bp_openw:
/* QL:         moveq   #io.new-io.share,d7 */
    moveq #(io.new-io.share),d7
/* QL: bp_openn */
bp_openn:
/* QL:         addq.b  #io.share,d7 */
    addq.b #io.share,d7
/* QL: bp_open */
bp_open:
/* QL:         assert  0,io.old */
/* original assertion: 0,io.old */
/* QL:         bsr.s   opclose         run a check on the channel */
    bsr.s opclose
/* QL:         bne.s   rts5 */
    bne.s rts5
/* QL:         move.l  d7,d4           save open type */
    move.l d7,d4
/* QL:         move.l  d1,d7           save #chan */
    move.l d1,d7
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         cmp.l   a5,a3 */
    cmp.l a5,a3
/* QL:         beq.s   opnorm          normally just one parameter will be given */
    beq.s opnorm
/* QL:         jsr     ca_gtlin(pc)    if another is present, take it as open code */
    jsr ca_gtlin(pc)
/* QL:         bne.s   rts5 */
    bne.s rts5
/* QL:         move.l  0(a6,a1.l),d4 */
    move.l 0(a6,a1.l),d4
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL: opnorm */
opnorm:
/* QL:         subq.l  #8,a3 */
    subq.l #8,a3
/* QL:         bsr.l   fopen */
    bsr.w fopen
/* QL:         bne.s   rts5 */
    bne.s rts5
/* QL:         move.l  d7,d1           restore #chan */
    move.l d7,d1
/* QL:         jmp     bp_chnew(pc) */
    jmp bp_chnew(pc)
/* QL:         vect4000 bp_fname */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
.globl bp$fname
/* QL: [o]     equ     [h]-$4000 */
.equ bp$fname,(bp_fname-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
