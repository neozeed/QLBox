
|***************
|*
|*     SYS_MESS sys_mess
|*
|***************

.balign 2, 0 ; l0b71c:	.long 0x4afb003c
.balign 2, 0 ; 	.word 0x004c
.balign 2, 0 ; 	.word 0x005a
.balign 2, 0 ; 	.word 0x006a
.balign 2, 0 ; 	.word 0x007a
.balign 2, 0 ; 	.word 0x0088
.balign 2, 0 ; 	.word 0x009c
.balign 2, 0 ; 	.word 0x00a8
.balign 2, 0 ; 	.word 0x00ba
.balign 2, 0 ; 	.word 0x00c4
.balign 2, 0 ; 	.word 0x00d2
.balign 2, 0 ; 	.word 0x00e0
.balign 2, 0 ; 	.word 0x00ec
.balign 2, 0 ; 	.word 0x00fa
.balign 2, 0 ; 	.word 0x010a
.balign 2, 0 ; 	.word 0x011a
.balign 2, 0 ; 	.word 0x0132
.balign 2, 0 ; 	.word 0x0148
.balign 2, 0 ; 	.word 0x0154
.balign 2, 0 ; 	.word 0x0166
.balign 2, 0 ; 	.word 0x0172
.balign 2, 0 ; 	.word 0x017e
.balign 2, 0 ; 	.word 0x0188
.balign 2, 0 ; 	.word 0x0194
.balign 2, 0 ; 	.word 0x01ac
.balign 2, 0 ; 	.word 0x01cc
.balign 2, 0 ; 	.word 0x01e6
.balign 2, 0 ; 	.word 0x01f8
.balign 2, 0 ; 	.word 0x020e
.balign 2, 0 ; 	.word 0x000d
	.ascii "not complete"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x000c
	.ascii "invalid Job"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x000e
	.ascii "out of memory"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x000d
	.ascii "out of range"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x000c
	.ascii "buffer full"
	.byte 0x0a
.balign 2, 0 ; l0b7a4:	.word 0x0011
	.ascii "channel not open"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x000a
	.ascii "not found"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x000f
	.ascii "already exists"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x0007
	.ascii "in use"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x000c
	.ascii "end of file"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x000b
	.ascii "drive full"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x0009
	.ascii "bad name"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x000b
	.ascii "Xmit error"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x000e
	.ascii "format failed"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x000e
	.ascii "bad parameter"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x0016
	.ascii "bad or changed medium"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x0014
	.ascii "error in expression"
	.byte 0x0a
.balign 2, 0 ; l0b864:	.word 0x0009
	.ascii "overflow"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x0010
	.ascii "not implemented"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x000a
	.ascii "read only"
	.byte 0x0a
.balign 2, 0 ; 	.word 0x0009
	.ascii "bad line"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x0008
	.ascii "At line "
.balign 2, 0 ; 	.word 0x0009
	.ascii " sectors"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x0015
ob8b0:	.ascii "F1...monitor"
	.byte 0x0a
	.ascii "F2...TV"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x001e
|;       dc.b '  1983 Sinclair Research Ltd '
	.ifdef SNASM_REFERENCE_TEXT ; .ascii "   1983 Sinclair Research Ltd " ; .else ; .ascii " \177 2023 Sinclair Research Ltd " ; .endif | Optional reference banner; default preserves uploaded source.
.balign 2, 0 ; 	.word 0x0017
	.ascii "during WHEN processing"
.balign 2, 0 ; 	.word 0x0a00
.balign 2, 0 ; 	.word 0x0010
	.ascii "PROC/FN cleared"
	.byte 0x0a
ob914:	.ascii "SunMonTueWedThuFriSat"
	.byte 0x00
	.ascii "JanFebMarAprMayJunJulAugSepOctNovDez"

|***** END SYS_MESS  sys_mess
