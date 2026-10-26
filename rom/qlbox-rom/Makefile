CROSS ?= m68k-linux-gnu-
.PHONY: all
all: build/qlbox.bin build/qlbox.symbols
build/qlbox.o: $(wildcard src/*.s src/*.inc)
	mkdir -p build
	$(CROSS)as -m68000 --register-prefix-optional --pcrel -I src -o $@ src/system_asm.s
build/qlbox.elf: build/qlbox.o rom.ld
	$(CROSS)ld -T rom.ld -Map build/qlbox.map -o $@ $<
build/qlbox.bin: build/qlbox.elf
	$(CROSS)objcopy -O binary $< $@
build/qlbox.symbols: build/qlbox.elf
	$(CROSS)nm -n $< > $@
