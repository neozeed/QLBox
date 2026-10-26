/* Flat 64 KiB ROM at address zero, retained as a symbol-bearing ELF. */
OUTPUT_ARCH(m68k)
ENTRY(xl0016a)
PHDRS { rom PT_LOAD FLAGS(5); }
SECTIONS
{
  . = 0;
  .rom : { *(.text) *(.rodata*) } :rom
  /DISCARD/ : { *(.comment) *(.note*) }
  ASSERT(SIZEOF(.rom) == 0x10000, "ROM must be exactly 64 KiB")
}

ASSERT(keyboard_table_end - l0b458 == 0x114, "Keyboard table size changed")
