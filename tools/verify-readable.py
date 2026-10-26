#!/usr/bin/env python3
"""Audit a documented R20 tree against an untouched R20 directory.

This is a source-equivalence check, not a substitute for compiling and tests.
C tokens exclude comments/whitespace but retain strings, operators and numbers.
Preprocessor directive boundaries and backslash continuations are checked too.
"""
import hashlib
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
TOKEN = re.compile(
    r'/\*[\s\S]*?\*/|//[^\n]*|'
    r'(?:u8|[LuU])?"(?:\\[\s\S]|[^"\\])*"|'
    r"(?:[LuU])?'(?:\\[\s\S]|[^'\\])*'|"
    r'[A-Za-z_][A-Za-z_0-9]*|'
    r'(?:\.?[0-9])(?:[A-Za-z_0-9.]|[eEpP][+-])*|'
    r'>>=|<<=|\.\.\.|##|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||'
    r'\+=|-=|\*=|/=|%=|&=|\^=|\|=|[^\s]'
)
FUNCTION = re.compile(
    r'^(?!typedef\b)([A-Za-z_][\w* \t]*?)\b(\w+)\s*\([^;{}]*\)\s*\{', re.M
)


def tokens(source):
    """Return non-comment C token spellings, retaining literal contents."""
    return [m.group() for m in TOKEN.finditer(source)
            if not m.group().startswith(('/*', '//'))]


def directives(source):
    """Retain logical preprocessor lines; line breaks can terminate macros."""
    source = source.replace('\\\n', '')
    source = re.sub(r'/\*[\s\S]*?\*/', ' ', source)
    return [tokens(line) for line in source.splitlines()
            if line.lstrip().startswith('#')]


def digest(path):
    """Hash file bytes to protect inherited and generated material."""
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    """Check every baseline file, permitting only documented source/doc edits."""
    if len(sys.argv) != 2:
        raise SystemExit('usage: python3 tools/verify-readable.py ORIGINAL_R20')
    baseline = pathlib.Path(sys.argv[1]).resolve()
    count = functions = protected = 0
    for old in sorted(baseline.rglob('*')):
        if not old.is_file() or '__pycache__' in old.parts:
            continue
        rel = old.relative_to(baseline)
        new = ROOT / rel
        assert new.is_file(), f'missing: {rel}'
        if digest(old) == digest(new):
            protected += 1
            # Still audit comment coverage for every handwritten runtime file.
        editable = ((rel.parts[0] == 'src' and old.suffix in ('.c', '.h')
                     and old.name not in ('builtin_files.h', 'rom_symbols.h'))
                    or rel.as_posix() == 'tools/qlimage.c')
        if editable:
            a, b = old.read_text(), new.read_text()
            assert tokens(a) == tokens(b), f'C token difference: {rel}'
            assert directives(a) == directives(b), f'directive difference: {rel}'
            count += 1
            if old.suffix == '.c':
                for match in FUNCTION.finditer(b):
                    name = match.group(2)
                    before = b[:match.start()].rstrip()
                    assert before.endswith('*/'), f'no function comment: {rel}:{name}'
                    comment = before[before.rfind('/**'):]
                    assert '\n * ' + name + '\n' in comment, f'wrong comment: {rel}:{name}'
                    functions += 1
        elif rel.as_posix() == 'rom/qlbox-rom/src/host_driver.s':
            def assembly(path):
                return [line.split('|', 1)[0].strip() for line in path.read_text().splitlines()
                        if line.split('|', 1)[0].strip()]
            assert assembly(old) == assembly(new), 'assembly instruction/data difference'
        elif old.suffix in ('.md', '.txt'):
            # Human documentation may change; vendor/ROM text is protected below.
            if rel.parts[0] in ('vendor', 'rom', 'samples', 'util'):
                assert digest(old) == digest(new), f'inherited text difference: {rel}'
        else:
            assert digest(old) == digest(new), f'protected file difference: {rel}'
    print(f'PASS: {count} C source/header files token-identical; '
          f'{functions} functions documented; bridge assembly unchanged; '
          f'{protected} baseline files byte-identical')


if __name__ == '__main__':
    main()
