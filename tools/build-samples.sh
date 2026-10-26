#!/bin/sh
# GNU m68k binutils; run from the project root.
set -eu
cross=${CROSS:-m68k-linux-gnu-}
tmp=${TMPDIR:-/tmp}/qlbox-samples-$$
mkdir -p "$tmp"
trap 'rm -r "$tmp"' EXIT HUP INT TERM
build() {
 "$cross"as -m68000 --register-prefix-optional "$@" -o "$tmp/job.o" "$source"
 "$cross"ld -Ttext=0 -e _start -o "$tmp/job.elf" "$tmp/job.o"
 "$cross"objcopy -O binary "$tmp/job.elf" "$dest"
}
source=tests/job.s dest=host/HELLO_EXE
build
source=tests/job.s dest=tests/fixtures/JOB_EXE
build --defsym TEST_MARKER=1
source=tests/cli_job.s dest=tests/fixtures/CLI_EXE
build
source=tests/heap_job.s dest=tests/fixtures/HEAP_EXE
build
python3 tools/qlfile.py exec host/HELLO_EXE --data-space 4096

cp tests/fixtures/CLI_EXE host/ECHO_EXE
python3 tools/qlfile.py exec host/ECHO_EXE --data-space 4096

source=tests/multijob.s dest=tests/fixtures/WORKER1_EXE
build --defsym WORKER=1
source=tests/multijob.s dest=tests/fixtures/WORKER2_EXE
build --defsym WORKER=2
