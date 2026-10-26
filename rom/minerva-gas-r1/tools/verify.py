#!/usr/bin/env python3
"""Strict, independent comparison against the supplied unmodified ROM oracle."""
from pathlib import Path
import hashlib
R=Path(__file__).resolve().parents[1]
a=(R/'reference/min198.rom').read_bytes()
b=(R/'build/minerva.rom').read_bytes()
expected='aafbd3b0b2bf60d2cdeb139a355d552908b041ab021a1ff1b0be5547d9bcf2a2'
assert hashlib.sha256(a).hexdigest()==expected,'Reference changed'
assert len(a)==len(b)==48822,(len(a),len(b))
diffs=[i for i,(x,y) in enumerate(zip(a,b)) if x!=y]
assert not diffs, f'{len(diffs)} mismatched bytes; first at {diffs[0]:#x}'
assert int.from_bytes(b[4:8],'big')==0x410
print('PASS: all 48,822 bytes match the supplied Minerva 1.98 ROM.')
print('SHA-256:',hashlib.sha256(b).hexdigest())
