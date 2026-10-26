# Modern GNU binutils; CROSS may be an absolute prefix.
CROSS ?= m68k-elf-
PYTHON ?= python3
.PHONY: all verify regenerate clean disassembly
all:
	CROSS="$(CROSS)" $(PYTHON) tools/build.py
verify: all
	$(PYTHON) tools/verify.py
	$(PYTHON) tools/check_assertions.py
regenerate:
	$(PYTHON) tools/convert.py
clean:
	rm -rf build
disassembly: all
	$(CROSS)objdump -d build/minerva.elf > build/minerva.disassembly.txt

.PHONY: qlbox
qlbox:
	CROSS="$(CROSS)" $(PYTHON) tools/build_qlbox.py
	cp build/minerva-qlbox.rom ../minerva-rom.bin
