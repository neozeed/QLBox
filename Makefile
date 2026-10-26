ifeq ($(OS),Windows_NT)
SOCKET_LIBS = -lws2_32
endif
CC ?= cc
ifneq (,$(findstring mingw,$(shell $(CC) -dumpmachine)))
SOCKET_LIBS = -lws2_32
WINDOWS_CONSOLE_LDFLAGS = -mconsole
else ifeq ($(OS),Windows_NT)
WINDOWS_CONSOLE_LDFLAGS = -mconsole
else
THREAD_LIBS = -pthread
endif
CFLAGS ?= -O2
CPPFLAGS += -Isrc -Ivendor/musashi
CORE = src/modem.c src/debugger.c src/mouse.c src/qsound.c src/beeper.c src/terminal.c src/hostfs.c src/imagefs.c src/ql.c vendor/musashi/m68kcpu.c vendor/musashi/m68kops.c vendor/musashi/softfloat/softfloat.c
SDL_CFLAGS ?= $(shell sdl2-config --cflags)
SDL_LIBS ?= $(shell sdl2-config --libs)
.PHONY: all headless clean test modem-test
all: qlbox qlrun qlimage
qlbox: src/sdl_input.c src/main.c src/modem.h src/builtin_files.h src/ql.h src/beeper.h src/hostfs.h src/terminal.h src/rom_symbols.h $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SDL_CFLAGS) -DQLBOX_SDL src/main.c src/sdl_input.c $(CORE) -o $@ $(SDL_LIBS) $(SOCKET_LIBS) $(THREAD_LIBS) -lm $(WINDOWS_CONSOLE_LDFLAGS)
headless: qlbox-headless qlrun qlimage
qlbox-headless: src/main.c src/modem.h src/builtin_files.h src/ql.h src/beeper.h src/hostfs.h src/terminal.h src/rom_symbols.h $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) src/main.c $(CORE) -o $@ $(SOCKET_LIBS) $(THREAD_LIBS) -lm
test: modem-test qlbox-timing-test qlbox-qsound-test qlbox-headless qlbox-hostfs-test qlbox-beeper-test qlbox-image-test qlimage
	./qlbox-timing-test
	python3 tests/timing_config.py ./qlbox-headless
	python3 tests/exit.py ./qlbox-headless
	python3 tests/smoke.py ./qlbox-headless
	python3 tests/storage.py ./qlbox-headless
	python3 tests/runner.py ./qlbox-headless
	python3 tests/unzip.py ./qlbox-headless
	python3 tests/zip.py ./qlbox-headless
	python3 tests/backend.py ./qlbox-hostfs-test
	./qlbox-beeper-test
	./qlbox-qsound-test
	python3 tests/qsound_config.py ./qlbox-headless
	python3 tests/qsound_rom.py ./qlbox-headless
	python3 tests/multijob.py ./qlbox-headless
	python3 tests/util_drive.py ./qlbox-headless
	python3 tests/xtcc.py ./qlbox-headless
	python3 tests/mount_config.py ./qlbox-headless
	python3 tests/debugger.py ./qlbox-headless
	python3 tests/microdrive.py ./qlbox-headless ./qlimage ./qlbox-image-test
	python3 tests/images.py ./qlbox-headless ./qlbox-image-test
	python3 tests/image_extract.py ./qlimage ./qlbox-headless
	$(CC) -std=gnu89 -D__QDOS__ -Itests/sarien-stubs -Isamples/sarienQL-fixed/include tests/sarien_keys_test.c -o qlbox-sarien-keys-test
	./qlbox-sarien-keys-test
clean:
	rm -f qlbox qlbox-headless qlbox-input-test qlbox-hostfs-test qlbox-beeper-test qlbox-image-test qlrun qlimage

test-sdl: tests/sdl_input_test.c src/sdl_input.c src/ql.h $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SDL_CFLAGS) tests/sdl_input_test.c src/sdl_input.c $(CORE) -o qlbox-input-test $(SDL_LIBS) $(SOCKET_LIBS) $(THREAD_LIBS) -lm $(WINDOWS_CONSOLE_LDFLAGS)
	./qlbox-input-test

qlbox-hostfs-test: tests/hostfs_test.c src/hostfs.c src/imagefs.c src/builtin_files.h src/hostfs.h src/ql.h
	$(CC) $(CFLAGS) -Isrc tests/hostfs_test.c src/hostfs.c src/imagefs.c -o $@

qlrun: qlbox-headless
	cp qlbox-headless qlrun

qlbox-beeper-test: tests/beeper_test.c src/mouse.c src/qsound.c src/beeper.c src/beeper.h $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) tests/beeper_test.c $(CORE) -o $@ $(SOCKET_LIBS) $(THREAD_LIBS) -lm

qlimage: tools/qlimage.c src/imagefs.c src/imagefs.h
	$(CC) $(CFLAGS) -Isrc tools/qlimage.c src/imagefs.c -o $@

qlbox-image-test: tests/image_backend_test.c src/hostfs.c src/imagefs.c src/imagefs.h src/hostfs.h src/ql.h
	$(CC) $(CFLAGS) -Isrc tests/image_backend_test.c src/hostfs.c src/imagefs.c -o $@

mouse-test: tests/mouse_test.c src/sdl_input.c $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SDL_CFLAGS) tests/mouse_test.c src/sdl_input.c $(CORE) -o qlbox-mouse-test $(SDL_LIBS) $(SOCKET_LIBS) $(THREAD_LIBS) -lm $(WINDOWS_CONSOLE_LDFLAGS)
	./qlbox-mouse-test

qlbox-qsound-test: tests/qsound_test.c src/qsound.h src/ql.h $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) tests/qsound_test.c $(CORE) -o $@ $(SOCKET_LIBS) $(THREAD_LIBS) -lm

qlbox-qsound-demo: tests/qsound_demo.c src/qsound.h src/ql.h $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) tests/qsound_demo.c $(CORE) -o $@ $(SOCKET_LIBS) $(THREAD_LIBS) -lm

qlbox-timing-test: tests/timing_test.c src/ql.h $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) tests/timing_test.c $(CORE) -o $@ $(SOCKET_LIBS) $(THREAD_LIBS) -lm

mouse-capture-test: tests/mouse_capture_test.c src/sdl_input.c $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SDL_CFLAGS) tests/mouse_capture_test.c src/sdl_input.c $(CORE) -o qlbox-mouse-capture-test $(SDL_LIBS) $(SOCKET_LIBS) $(THREAD_LIBS) -lm $(WINDOWS_CONSOLE_LDFLAGS)
	./qlbox-mouse-capture-test

# Local loopback tests plus a real QDOS serial job; no public BBS is dialed.
qlbox-modem-test: tests/modem_harness.c src/modem.c src/modem.h src/ql.h
	$(CC) $(CFLAGS) $(CPPFLAGS) tests/modem_harness.c src/modem.c -o $@ $(SOCKET_LIBS) $(THREAD_LIBS)
qlbox-modem-bridge-test: tests/modem_bridge_test.c src/modem.c src/modem.h src/ql.h
	$(CC) $(CFLAGS) $(CPPFLAGS) tests/modem_bridge_test.c src/modem.c -o $@ $(SOCKET_LIBS) $(THREAD_LIBS)
modem-test: qlbox-modem-test qlbox-modem-bridge-test qlbox-headless
	./qlbox-modem-bridge-test
	python3 tests/modem.py ./qlbox-modem-test
	python3 tests/modem_guest.py ./qlbox-headless

# Optional UI check; requires user-supplied QLTerm and a local server.
qlbox-qlterm-modem-test: tests/qlterm_modem.c $(CORE)
	$(CC) $(CFLAGS) $(CPPFLAGS) tests/qlterm_modem.c $(CORE) -o $@ $(SOCKET_LIBS) $(THREAD_LIBS) -lm
