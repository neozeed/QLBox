
|*****************
|*
|* JS_KEYBOARD_ASM keyboard_asm
|*
|*****************
l0b458:
|* Tastaturdekodierung - incl. L0B56B

.balign 2, 0 ; 	.long 0x000c008a, 0x004b00c9, 0x01080112

|* the first bytes are displacements for key, shift key, ctrl_key
|* ctrl-shift key, cursor, special keys
|* the first 4 sequences start each with $03,$3F
|* if you want to split: Take care for even adresses or use
|* only dc.b
|* THE LAST SEQUENCE IS ONLY IN SOME MG-VERSIONS
|* THEY ALLOW YOU TO PRESS ACCENTS ~ ABOVE THE LETTER OR EVEN
|* THE TREMA - IF ADDED THEM FOR COMPLETENESS - BUT UNLESS YOU REMOVE
|* THE LEADING ASTERIX THEY WILL NOT BE ASSEMBLED

.balign 2, 0 ; 	.long 0x033f7876
.balign 2, 0 ; 	.long 0x886e2e38, 0x32366165, 0x30747539, 0x7a690972
.balign 2, 0 ; 	.long 0x2d796f6c, 0x33683171, 0x70646a83, 0xe06b7366
.balign 2, 0 ; 	.long 0x3d676d90, 0x773b6362, 0xff2c8d0a, 0xc0d01bc8
.balign 2, 0 ; 	.long 0x9a20d8f4, 0xe835ecf0, 0xf8343703, 0x3f58563f
.balign 2, 0 ; 	.long 0x4e3e2a22, 0x27414529, 0x5455285a, 0x49fd525f
.balign 2, 0 ; 	.long 0x594f4c23, 0x48215150, 0x444a5ce4, 0x4b53462b
.balign 2, 0 ; 	.long 0x474db657, 0x3a4342ff, 0x3c2ffec4, 0xd47fcc60
.balign 2, 0 ; 	.long 0xfcdcf6ea, 0x25eef2fa, 0x2426033f, 0x1816bf0e
.balign 2, 0 ; 	.long 0x8e7c9d40, 0x01054d14, 0x155b1abb, 0x09127b19
.balign 2, 0 ; 	.long 0x0f0c9308, 0x91111004, 0x0abce20b, 0x13067d07
.balign 2, 0 ; 	.long 0x0dbd179b, 0x03025e8c, 0x870ac2d2, 0x00ca7e00
.balign 2, 0 ; 	.long 0xdaf5e997, 0xedf1f994, 0xba033fb8, 0x999fae9e
.balign 2, 0 ; 	.long 0x8aa0bea1, 0xa589b4b5, 0x9298a9fd, 0xb2bfb9af
.balign 2, 0 ; 	.long 0xac91a881, 0xb1b0a4aa, 0x96e6abb3, 0xa68ba7ad
.balign 2, 0 ; 	.long 0x1db795a3, 0xa3a21e9c, 0x82fec6d6, 0x1fce1c00
.balign 2, 0 ; 	.long 0xf7eb85ef, 0xf3fb8486, 0x21e031c0, 0x32d034c8
.balign 2, 0 ; 	.word 0x37d8
.balign 2, 0 ; 	.word 0x0000

|* IF YOU WANT TO INTEGRATE THE FOLLOWING CODE:
|* YOU MUST REMOVE THE LAST ZERO-WORD

|* DC.L $2D05618E
|* DC.L $65916995
|* DC.L $6F98759B
|* DC.L $310841A0
|* DC.L $4FA455A7
|* DC.L $6180658F
|* DC.L $69926F84
|* DC.L $758700FF

|* LAST BYTE ($FF) PROBABLY HAST OB CONVERT TO $00 !!!!

|****** End KEYBOARD_ASM keyboard_asm
