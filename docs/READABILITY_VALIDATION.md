# R20 documented-source validation

This edition preserves the R20 runtime implementation. It adds source
formatting, explanatory comments, a function index and contributor documents.
No identifiers, APIs, configuration defaults or guest-visible features changed.

## Source equivalence

`python3 tools/verify-readable.py ../qlbox-r20` passes:

- 20 handwritten C source/header files have identical non-comment tokens and
  preprocessor directive token sequences.
- All 152 functions in runtime C and the image tool have individual comments.
- The host-driver assembly has identical instruction/data lines after comments
  and blank lines are removed.
- 580 original files are byte-identical, including distributed executables,
  generated utility data, vendor source and preserved historical material.

Long string literals remain unsplit so the token comparison is literal, not
merely a claim about concatenated string equivalence. The checker is deliberately
small and specific to this C source tree; it is not a general C semantics proof.

## Builds and execution

- Rebuilt Linux desktop, headless runner, qlrun and qlimage match the R20
  executable bytes exactly using the same compiler/options.
- Reassembled the annotated guest bridge with the existing GNU m68k build;
  the resulting ROM matches the original R20 ROM exactly.
- Full `make test` passed on the formatted/commented implementation.
- SDL keyboard/input and mouse-capture policy tests passed. The latter mocks
  the desktop grab call and is not a physical macOS/Windows mouse test.
- Existing Win32/Win64 binaries are retained byte-for-byte. This pass does not
  claim a new Windows or macOS runtime test.

The ROM assembler emits the existing odd-boundary label warnings in inherited
JS source; the output-byte comparison passes. Build products whose diagnostic
paths or assertion line numbers can differ are retained from the original
package after testing, keeping this a source-documentation distribution.

## Rebuilt output hashes

| File | SHA-256, equal to original R20 |
|---|---|
| `qlbox` | `a9800c383a58af0fb734c517271a3090698a36e013fcd54397c139b050433b05` |
| `qlbox-headless` | `5e927fc0c50bc130b0721ef4ca1b2f5fe47901bf886c1fda818efe7f0fe7e1a1` |
| `qlrun` | `5e927fc0c50bc130b0721ef4ca1b2f5fe47901bf886c1fda818efe7f0fe7e1a1` |
| `qlimage` | `66014c050c08d925b8953756d6dbe1e279ceadd37d78316212e3d17d5e5cec47` |
| `rom/qlbox-rom/build/qlbox.bin` | `0cac697d4615060807556cb3c6288d0cbb3c56f9ff473e2bf42445b93ac1481b` |

To repeat the checks, build with the same toolchain and flags as the original
R20, run the test targets described in README.md and compare outputs before
replacing any baseline. SHA256SUMS.txt continues to describe the unchanged
packaged binaries and ROM/utility payloads.
