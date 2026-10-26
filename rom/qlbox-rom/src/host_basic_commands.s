| Extended copy of stock table. Original remains in place to preserve ROM layout.

|*************************
|*
|* BASIC_COMMANDS   basic_commands
|*
|*************************

lbasic:
.balign 2, 0 ; l06e22:	.word 0x0052
|* Original procedures plus SHUTDOWN
 .word host_shutdown-.
 .byte 8
 .ascii "SHUTDOWN"
 .balign 2,0

.balign 2, 0 ; 	.word lprint-. | * $0884 = ADRESSE
	.byte 0x05
	.ascii "PRINT"
.balign 2, 0 ; 	.word lrun-. | *$0F78 * = ADRESSE
	.byte 0x03
	.ascii "RUN"
.balign 2, 0 ; 	.word lstop-. | *$0FD8 * = ADRESSE 
	.byte 0x04
	.ascii "STOP"
.balign 2, 0 ; 	.word linput-. | *$5000  
	.byte 0x05
	.ascii "INPUT"
.balign 2, 0 ; 	.word lwindow-. | *$113C 
	.byte 0x06
	.ascii "WINDOW"
	.byte 0x00
.balign 2, 0 ; 	.word lborder-. | *$1158 * = ADRESSE 
	.byte 0x06
	.ascii "BORDER"
	.byte 0x00
.balign 2, 0 ; 	.word link-. | *$0774 
	.byte 0x03
	.ascii "INK"
.balign 2, 0 ; 	.word lstrip-. | *$0772 
	.byte 0x05
	.ascii "STRIP"
.balign 2, 0 ; 	.word lpaper-. | *$076E 
	.byte 0x05
	.ascii "PAPER"
.balign 2, 0 ; 	.word lblock-. | *$1120 
	.byte 0x05
	.ascii "BLOCK"
.balign 2, 0 ; 	.word lpan-. | *$0780 
	.byte 0x03
	.ascii "PAN"
.balign 2, 0 ; 	.word lscroll-. | *$077E 
	.byte 0x06
	.ascii "SCROLL"
	.byte 0x00
.balign 2, 0 ; 	.word lcsize-. | * $F81E 
	.byte 0x05
	.ascii "CSIZE"
.balign 2, 0 ; 	.word lflash-. | * $FD20 
	.byte 0x05
	.ascii "FLASH"
.balign 2, 0 ; 	.word lunder-. | * $FD12 
	.byte 0x05
	.ascii "UNDER"
.balign 2, 0 ; 	.word lover-. | *  $FD26 
	.byte 0x04
	.ascii "OVER"
	.byte 0x00
.balign 2, 0 ; 	.word lcursor-. | *  $F822 
	.byte 0x06
	.ascii "CURSOR"
	.byte 0x00
.balign 2, 0 ; 	.word lat-. | *  $F826 
	.byte 0x02
	.ascii "AT"
	.byte 0x00
.balign 2, 0 ; 	.word lscale-. | *  $FD42 
	.byte 0x05
	.ascii "SCALE"
.balign 2, 0 ; 	.word lpoint-. | *  $FD4C 
	.byte 0x05
	.ascii "POINT"
.balign 2, 0 ; 	.word lline-. | *  $FD56 
	.byte 0x04
	.ascii "LINE"
	.byte 0x00
.balign 2, 0 ; 	.word lellips-. | *  $FD66 
	.byte 0x07
	.ascii "ELLIPSE"
.balign 2, 0 ; 	.word lcircle-. | *  $FD5C 
	.byte 0x06
	.ascii "CIRCLE"
	.byte 0x00
.balign 2, 0 ; 	.word larc-. | *  $FDA2 
	.byte 0x03
	.ascii "ARC"
.balign 2, 0 ; 	.word lpointr-. | *  $FD26 
	.byte 0x07
	.ascii "POINT_R"
.balign 2, 0 ; 	.word lturn-. | *  $0FA8 
	.byte 0x04
	.ascii "TURN"
	.byte 0x00
.balign 2, 0 ; 	.word lturnto-. | *  $0F98  
	.byte 0x06
	.ascii "TURNTO"
	.byte 0x00
.balign 2, 0 ; 	.word lpenup-. | *  $0FD0 
	.byte 0x05
	.ascii "PENUP"
.balign 2, 0 ; 	.word lpendown-. | *  $0FCC 
	.byte 0x07
	.ascii "PENDOWN"
.balign 2, 0 ; 	.word lmove-. | *  $0FD0 
	.byte 0x04
	.ascii "MOVE"
	.byte 0x00
.balign 2, 0 ; 	.word llist-. | *  $0564 
	.byte 0x04
	.ascii "LIST"
	.byte 0x00
.balign 2, 0 ; 	.word lopen-. | *  $FC24 
	.byte 0x04
	.ascii "OPEN"
	.byte 0x00
.balign 2, 0 ; 	.word lclose-. | *  $FBFA 
	.byte 0x05
	.ascii "CLOSE"
.balign 2, 0 ; 	.word lformat-. | *  $FB40 
	.byte 0x06
	.ascii "FORMAT"
	.byte 0x00
.balign 2, 0 ; 	.word lcopy-. | *  $FB50 
	.byte 0x04
	.ascii "COPY"
	.byte 0x00
.balign 2, 0 ; 	.word lcopyn-. | *  $FB4C 
	.byte 0x06
	.ascii "COPY_N"
	.byte 0x00
.balign 2, 0 ; 	.word ldelete-. | *  $FA96 
	.byte 0x06
	.ascii "DELETE"
	.byte 0x00
.balign 2, 0 ; 	.word ldir-. | *  $FA92
	.byte 0x03
	.ascii "DIR"
.balign 2, 0 ; 	.word lexec-. | *  $F92C
	.byte 0x04
	.ascii "EXEC"
	.byte 0x00
.balign 2, 0 ; 	.word lexecw-. | *  $F928  
	.byte 0x06
	.ascii "EXEC_W"
	.byte 0x00
.balign 2, 0 ; 	.word llbytes-. | *  $F994 
	.byte 0x06
	.ascii "LBYTES"
	.byte 0x00
.balign 2, 0 ; 	.word lsexec-. | *  $F9C0 
	.byte 0x05
	.ascii "SEXEC"
.balign 2, 0 ; 	.word lsbytes-. | *  $F9BC 
	.byte 0x06
	.ascii "SBYTES"
	.byte 0x00
.balign 2, 0 ; 	.word lsave-. | *  $FBDE 
	.byte 0x04
	.ascii "SAVE"
	.byte 0x00
.balign 2, 0 ; 	.word lmerge-. | *  $0E34 
	.byte 0x05
	.ascii "MERGE"
.balign 2, 0 ; 	.word lmrun-. | *  $0E36 
	.byte 0x04
	.ascii "MRUN"
	.byte 0x00
.balign 2, 0 ; 	.word lload-. | *  $0E4E 
	.byte 0x04
	.ascii "LOAD"
	.byte 0x00
.balign 2, 0 ; 	.word llrun-. | *  $0E4C 
	.byte 0x04
	.ascii "LRUN"
	.byte 0x00
.balign 2, 0 ; 	.word lnew-. | *  $0E50 
	.byte 0x03
	.ascii "NEW"
.balign 2, 0 ; 	.word lclear-. | *  $0DDC 
	.byte 0x05
	.ascii "CLEAR"
.balign 2, 0 ; 	.word lopenin-. | *  $FB88 
	.byte 0x07
	.ascii "OPEN_IN"
.balign 2, 0 ; 	.word lopennew-. | *  $FB82 
	.byte 0x08
	.ascii "OPEN_NEW"
	.byte 0x00
.balign 2, 0 ; 	.word lcls-. | *  $0616 
	.byte 0x03
	.ascii "CLS"
.balign 2, 0 ; 	.word lcall-. | *  $F5EA
	.byte 0x04
	.ascii "CALL"
	.byte 0x00
.balign 2, 0 ; 	.word lrecol-. | *  $0AE4
	.byte 0x05
	.ascii "RECOL"
.balign 2, 0 ; 	.word lrandomise-. | *  $09A8
	.byte 0x09
	.ascii "RANDOMISE"
.balign 2, 0 ; 	.word lpause-. | *  $064C 
	.byte 0x05
	.ascii "PAUSE"
.balign 2, 0 ; 	.word lpoke-. | *  $0668
	.byte 0x04
	.ascii "POKE"
	.byte 0x00
.balign 2, 0 ; 	.word lpokew-. | *  $0668
	.byte 0x06
	.ascii "POKE_W"
	.byte 0x00
.balign 2, 0 ; 	.word lpokel-. | *  $0664 
	.byte 0x06
	.ascii "POKE_L"
	.byte 0x00
.balign 2, 0 ; 	.word lbaud-. | *  $F4C2
	.byte 0x04
	.ascii "BAUD"
	.byte 0x00
.balign 2, 0 ; 	.word lbeep-. | *  $F4F6
	.byte 0x04
	.ascii "BEEP"
	.byte 0x00
.balign 2, 0 ; 	.word lcontinue-. | *  $0E20
	.byte 0x08
	.ascii "CONTINUE"
	.byte 0x00
.balign 2, 0 ; 	.word lretry-. | *  $0E0A 
	.byte 0x05
	.ascii "RETRY"
.balign 2, 0 ; 	.word lread-. | *  $F81A 
	.byte 0x04
	.ascii "READ"
	.byte 0x00
.balign 2, 0 ; 	.word lnet-. | *  $0562 
	.byte 0x03
	.ascii "NET"
.balign 2, 0 ; 	.word lmode-. | *  $053E 
	.byte 0x04
	.ascii "MODE"
	.byte 0x00
.balign 2, 0 ; 	.word lrenum-. | *  $0ACA 
	.byte 0x05
	.ascii "RENUM"
.balign 2, 0 ; 	.word ldline-. | *  $0400 
	.byte 0x05
	.ascii "DLINE"
.balign 2, 0 ; 	.word lsdate-. | *  $F732
	.byte 0x05
	.ascii "SDATE"
.balign 2, 0 ; 	.word ladate-. | *  $F716 
	.byte 0x05
	.ascii "ADATE"
.balign 2, 0 ; 	.word lliner-. | *  $FBA4
	.byte 0x06
	.ascii "LINE_R"
	.byte 0x00
.balign 2, 0 ; 	.word lellipsr-. | *  $FBB2
	.byte 0x09
	.ascii "ELLIPSE_R"
.balign 2, 0 ; 	.word lcircler-. | *  $FBA6
	.byte 0x08
	.ascii "CIRCLE_R"
	.byte 0x00
.balign 2, 0 ; 	.word larcr-. | *  $FBEA 
	.byte 0x05
	.ascii "ARC_R"
.balign 2, 0 ; 	.word lauto-. | *  $0A56
	.byte 0x04
	.ascii "AUTO"
	.byte 0x00
.balign 2, 0 ; 	.word ledit-. | *  $0A4A
	.byte 0x04
	.ascii "EDIT"
	.byte 0x00
.balign 2, 0 ; 	.word lfill-. | *  $FAD4 
	.byte 0x04
	.ascii "FILL"
	.byte 0x00
.balign 2, 0 ; 	.word lwidth-. | *  $0EAC
	.byte 0x05
	.ascii "WIDTH"
.balign 2, 0 ; 	.word lreport-. | *  $0CB4 
	.byte 0x06
	.ascii "REPORT"
	.byte 0x00
.balign 2, 0 ; 	.word ltra-. | *  $0D8A 
	.byte 0x03
	.ascii "TRA"
.balign 2, 0 ; 	.word 0x0000 | * END COMMANDS
.balign 2, 0 ; 	.word 0x003a | * $3A FUNCTIONS
.balign 2, 0 ; 	.word lacos-. | *  $0F7C  
	.byte 0x04
	.ascii "ACOS"
	.byte 0x00
.balign 2, 0 ; 	.word lacot-. | *  $0F7A
	.byte 0x04
	.ascii "ACOT"
	.byte 0x00
.balign 2, 0 ; 	.word lasin-. | *  $0F78
	.byte 0x04
	.ascii "ASIN"
	.byte 0x00
.balign 2, 0 ; 	.word latan-. | *  $0F76
	.byte 0x04
	.ascii "ATAN"
	.byte 0x00
.balign 2, 0 ; 	.word lcos-. | *  $0F74
	.byte 0x03
	.ascii "COS"
.balign 2, 0 ; 	.word lcot-. | *  $0F74
	.byte 0x03
	.ascii "COT"
.balign 2, 0 ; 	.word lexp-. | *  $0F74
	.byte 0x03
	.ascii "EXP"
.balign 2, 0 ; 	.word lln-. | *  $0F74
	.byte 0x02
	.ascii "LN"
	.byte 0x00
.balign 2, 0 ; 	.word llog10-. | *  $0F74
	.byte 0x05
	.ascii "LOG10"
.balign 2, 0 ; 	.word lsin-. | *  $0F72
	.byte 0x03
	.ascii "SIN"
.balign 2, 0 ; 	.word lsqrt-. | *  $0F72
	.byte 0x04
	.ascii "SQRT"
	.byte 0x00
.balign 2, 0 ; 	.word ltan-. | *  $0F70 
	.byte 0x03
	.ascii "TAN"
.balign 2, 0 ; 	.word ldeg-. | *  $0F70 
	.byte 0x03
	.ascii "DEG"
.balign 2, 0 ; 	.word lrad-. | *  $0F70 
	.byte 0x03
	.ascii "RAD"
.balign 2, 0 ; 	.word lrnd-. | *  $0FB2
	.byte 0x03
	.ascii "RND"
.balign 2, 0 ; 	.word lint-. | *  $1016 
	.byte 0x03
	.ascii "INT"
.balign 2, 0 ; 	.word labs-. | *  $0F7E
	.byte 0x03
	.ascii "ABS"
.balign 2, 0 ; 	.word lpi-. | *  $0FF8
	.byte 0x02
	.ascii "PI"
	.byte 0x00
.balign 2, 0 ; 	.word lpeek-. | *  $101C
	.byte 0x04
	.ascii "PEEK"
	.byte 0x00
.balign 2, 0 ; 	.word lpeekw-. | *  $101C
	.byte 0x06
	.ascii "PEEK_W"
	.byte 0x00
.balign 2, 0 ; 	.word lpeekl-. | *  $101C 
	.byte 0x06
	.ascii "PEEK_L"
	.byte 0x00
.balign 2, 0 ; 	.word lrespr-. | *  $1036
	.byte 0x05
	.ascii "RESPR"
.balign 2, 0 ; 	.word leof-. | *  $1054 
	.byte 0x03
	.ascii "EOF"
.balign 2, 0 ; 	.word linkeys-. | *  $1094 
	.byte 0x06
	.ascii "INKEY$"
	.byte 0x00
.balign 2, 0 ; 	.word lchrs-. | *  $10E2
	.byte 0x04
	.ascii "CHR$"
	.byte 0x00
.balign 2, 0 ; 	.word lcode-. | *  $1152 
	.byte 0x04
	.ascii "CODE"
	.byte 0x00
.balign 2, 0 ; 	.word lkeyrow-. | *  $11DA 
	.byte 0x06
	.ascii "KEYROW"
	.byte 0x00
.balign 2, 0 ; 	.word lbeeping-. | *  $101A 
	.byte 0x07
	.ascii "BEEPING"
.balign 2, 0 ; 	.word llen-. | *  $1120
	.byte 0x03
	.ascii "LEN"
.balign 2, 0 ; 	.word ldimn-. | *  $1158 
	.byte 0x04
	.ascii "DIMN"
	.byte 0x00
.balign 2, 0 ; 	.word ldays-. | *  $1204 
	.byte 0x04
	.ascii "DAY$"
	.byte 0x00
.balign 2, 0 ; 	.word ldate-. | *  $1198
	.byte 0x04
	.ascii "DATE"
	.byte 0x00
.balign 2, 0 ; 	.word ldates-. | *  $11EE 
	.byte 0x05
	.ascii "DATE$"
.balign 2, 0 ; 	.word lfills-. | *  $10AA 
	.byte 0x05
	.ascii "FILL$"
.balign 2, 0 ; 	.word lvers-. | *  $101C 
	.byte 0x04
	.ascii "VER$"
	.byte 0x00
.balign 2, 0 ; 	.word lerrnc-. | *  $1232 
	.byte 0x06
	.ascii "ERR_NC"
	.byte 0x00
.balign 2, 0 ; 	.word lerrnj-. | *  $1226
	.byte 0x06
	.ascii "ERR_NJ"
	.byte 0x00
.balign 2, 0 ; 	.word lerrom-. | *  $121A
	.byte 0x06
	.ascii "ERR_OM"
	.byte 0x00
.balign 2, 0 ; 	.word lerror-. | *  $120E 
	.byte 0x06
	.ascii "ERR_OR"
	.byte 0x00
.balign 2, 0 ; 	.word lerrbo-. | *  $1202
	.byte 0x06
	.ascii "ERR_BO"
	.byte 0x00
.balign 2, 0 ; 	.word lerrno-. | *  $11F6
	.byte 0x06
	.ascii "ERR_NO"
	.byte 0x00
.balign 2, 0 ; 	.word lerrnf-. | *  $11EA
	.byte 0x06
	.ascii "ERR_NF"
	.byte 0x00
.balign 2, 0 ; 	.word lerrex-. | *  $11DE 
	.byte 0x06
	.ascii "ERR_EX"
	.byte 0x00
.balign 2, 0 ; 	.word lerriu-. | *  $11D2 
	.byte 0x06
	.ascii "ERR_IU"
	.byte 0x00
.balign 2, 0 ; 	.word lerref-. | *  $11C6
	.byte 0x06
	.ascii "ERR_EF"
	.byte 0x00
.balign 2, 0 ; 	.word lerrdf-. | *  $11BA
	.byte 0x06
	.ascii "ERR_DF"
	.byte 0x00
.balign 2, 0 ; 	.word lerrbn-. | *  $11AE
	.byte 0x06
	.ascii "ERR_BN"
	.byte 0x00
.balign 2, 0 ; 	.word lerrte-. | *  $11A2
	.byte 0x06
	.ascii "ERR_TE"
	.byte 0x00
.balign 2, 0 ; 	.word lerrff-. | *  $1196
	.byte 0x06
	.ascii "ERR_FF"
	.byte 0x00
.balign 2, 0 ; 	.word lerrbp-. | *  $118A 
	.byte 0x06
	.ascii "ERR_BP"
	.byte 0x00
.balign 2, 0 ; 	.word lerrfe-. | *  $117E 
	.byte 0x06
	.ascii "ERR_FE"
	.byte 0x00
.balign 2, 0 ; 	.word lerrxp-. | *  $1172
	.byte 0x06
	.ascii "ERR_XP"
	.byte 0x00
.balign 2, 0 ; 	.word lerrov-. | *  $1166
	.byte 0x06
	.ascii "ERR_OV"
	.byte 0x00
.balign 2, 0 ; 	.word lerrni-. | *  $115A 
	.byte 0x06
	.ascii "ERR_NI"
	.byte 0x00
.balign 2, 0 ; 	.word lerrro-. | *  $114E 
	.byte 0x06
	.ascii "ERR_RO"
	.byte 0x00
.balign 2, 0 ; 	.word lerrbl-. | *  $1142  * = ADRESSE
	.byte 0x06
	.ascii "ERR_BL"
	.byte 0x00
.balign 2, 0 ; 	.word lernum-. | *  $11AA * = ADRESSE
	.byte 0x05
	.ascii "ERNUM"
.balign 2, 0 ; 	.word lerlin-. | *  $11B0 * = ADRESSE
	.byte 0x05
	.ascii "ERLIN"
.balign 2, 0 ; 	.word 0x0000

|****** END BASIC_COMMANDS basic_commands
