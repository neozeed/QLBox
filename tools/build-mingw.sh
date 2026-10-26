#!/bin/sh
# Usage: SDL2_ROOT=/path/to/SDL2-2.30.0 sh tools/build-mingw.sh
# Needs both MinGW-w64 cross compilers on PATH; run from the project root.
set -eu
: "${SDL2_ROOT:?Set SDL2_ROOT to the unpacked SDL2 MinGW development package}"
for arch in x86_64 i686; do
    case "$arch" in x86_64) dest=bin/win64;; i686) dest=bin/win32;; esac
    triple="$arch-w64-mingw32"
    sdk="$SDL2_ROOT/$triple"
    mkdir -p "$dest"
    "$triple-gcc" -O2 -Isrc -Ivendor/musashi -I"$sdk/include/SDL2" \
        -DQLBOX_SDL src/debugger.c src/main.c src/sdl_input.c src/mouse.c src/qsound.c src/beeper.c src/terminal.c src/hostfs.c src/imagefs.c src/ql.c \
        vendor/musashi/m68kcpu.c vendor/musashi/m68kops.c \
        vendor/musashi/softfloat/softfloat.c \
        -o "$dest/qlbox.exe" -L"$sdk/lib" -lSDL2 -static-libgcc -lws2_32 -lm
    "$triple-gcc" -O2 -Isrc -Ivendor/musashi \
        src/debugger.c src/main.c src/mouse.c src/qsound.c src/beeper.c src/terminal.c src/hostfs.c src/imagefs.c src/ql.c \
        vendor/musashi/m68kcpu.c vendor/musashi/m68kops.c \
        vendor/musashi/softfloat/softfloat.c \
        -o "$dest/qlrun.exe" -static-libgcc -lws2_32 -lm
    "$triple-gcc" -O2 -Isrc tools/qlimage.c src/imagefs.c -o "$dest/qlimage.exe" -static-libgcc
    cp "$sdk/bin/SDL2.dll" "$dest/"
done
