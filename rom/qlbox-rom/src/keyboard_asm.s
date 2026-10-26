.global l0b458, keyboard_table_end
| KEYBOARD_LAYOUT: 0 = UK (default), 1 = French AZERTY.
.ifndef KEYBOARD_LAYOUT
.equ KEYBOARD_LAYOUT, 0
.endif
.if KEYBOARD_LAYOUT == 0
.include "keyboard_uk.inc"
.elseif KEYBOARD_LAYOUT == 1
.include "keyboard_fr.inc"
.else
.error "KEYBOARD_LAYOUT must be 0 (UK) or 1 (French)"
.endif
keyboard_table_end:
