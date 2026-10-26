#!/usr/bin/env python3
"""Recover a raw executable and QLBox metadata from a Job2Bas DATA wrapper."""
import argparse, pathlib, re, struct
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('source',type=pathlib.Path)
p.add_argument('output',type=pathlib.Path)
a=p.parse_args()
values=[]
for line in a.source.read_text(encoding='ascii').splitlines():
    m=re.fullmatch(r'\s*\d+\s+DATA\s+(.*?)(?:\s*:\s*REM.*)?\s*',line,re.I)
    if m: values.extend(v.strip() for v in m.group(1).split(','))
try:
    words,odd=map(int,values[:2])
    original=values[2]
    if len(original)<2 or original[0] not in "'\"" or original[-1]!=original[0]:
        raise ValueError('missing quoted original filename')
    space=int(values[3])
    numbers=list(map(int,values[4:]))
    if words<0 or odd not in (0,1) or len(numbers)!=words+odd:
        raise ValueError('DATA count does not match declared payload size')
    if not 4<=space<=0x7fffffff: raise ValueError('invalid data-space requirement')
    if any(not -32768<=v<=65535 for v in numbers[:words]):
        raise ValueError('word outside 16-bit range')
    if odd and not 0<=numbers[-1]<=255: raise ValueError('invalid odd byte')
    data=b''.join(struct.pack('>H',v&65535) for v in numbers[:words])+bytes(numbers[words:])
    name=a.output.name.encode('ascii')
    if not 1<=len(name)<=36: raise ValueError('output name must be 1..36 ASCII bytes')
except (IndexError,ValueError,UnicodeError) as e:
    p.error(str(e))
header=bytearray(64)
struct.pack_into('>I',header,0,len(data));header[5]=1
struct.pack_into('>I',header,6,space)
struct.pack_into('>H',header,14,len(name));header[16:16+len(name)]=name
metadata=a.output.parent/'.qlbox-meta'/(name.lower().hex()+'.hdr')
if a.output.is_symlink() or metadata.is_symlink() or metadata.parent.is_symlink():
    p.error('output and metadata must not be symbolic links')
a.output.parent.mkdir(parents=True,exist_ok=True)
metadata.parent.mkdir(exist_ok=True)
a.output.write_bytes(data);metadata.write_bytes(header)
print(f'{a.output}: {len(data)} bytes, type 1, data space {space}; original {original}')
