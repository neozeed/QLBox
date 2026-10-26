#!/usr/bin/env python3
"""Evaluate the original assembler's assertions against the generated symbol map."""
import re
from pathlib import Path
from convert import Converter,parts
R=Path(__file__).resolve().parents[1]
c=Converter()
for line in (R/'build/minerva.symbols').read_text().splitlines():
 a=line.split()
 if len(a)==3:
  v=int(a[0],16);c.v[a[2].lower()]=v-0x100000000 if v>=0x80000000 else v
count=0
for line in (R/'build/minerva.s').read_text().splitlines():
 if not line.startswith('/* original assertion: '):continue
 text=line[len('/* original assertion: '):-3]
 args=parts(text,True);i=0
 while i+1<len(args):
  j=i+1;op='='
  if args[j] in ('=','<>','~=','>','<','>=','<='):op=args[j];j+=1
  a,b=c.numeric(args[i]),c.numeric(args[j])
  good={'=':a==b,'<>':a!=b,'~=':a!=b,'>':a>b,'<':a<b,'>=':a>=b,'<=':a<=b}[op]
  assert good,(text,a,op,b)
  count+=1;i=j
print(f'PASS: {count} original source assertion comparisons against the generated symbols.')
