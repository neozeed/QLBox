#!/usr/bin/env python3
"""Manage QLBox metadata; payload files remain ordinary host files."""
import argparse, json, pathlib, struct
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('action',choices=['exec','data','info'])
p.add_argument('file',type=pathlib.Path)
p.add_argument('--data-space',type=lambda v:int(v,0),default=4096)
a=p.parse_args();f=a.file
if not f.is_file() or f.is_symlink():p.error('expected a regular payload file')
try:name=f.name.encode('ascii')
except UnicodeEncodeError:p.error('QL names must be ASCII')
if not 1<=len(name)<=36:p.error('QL names must be 1..36 bytes')
if not 0<=a.data_space<=0x7fffffff:p.error('invalid data-space size')
meta=f.parent/'.qlbox-meta'/(name.lower().hex()+'.hdr')
if meta.is_symlink() or meta.parent.is_symlink():p.error('metadata cannot be a symbolic link')
h=bytearray(meta.read_bytes()) if meta.exists() else bytearray(64)
if len(h)!=64:p.error('invalid existing metadata')
struct.pack_into('>I',h,0,f.stat().st_size)
struct.pack_into('>H',h,14,len(name));h[16:52]=name.ljust(36,b'\0')
source='metadata' if meta.exists() else 'default'
if a.action=='info' and not meta.exists() and f.stat().st_size>=8:
 with f.open('rb') as stream:
  stream.seek(-8,2);tail=stream.read(8)
 space=struct.unpack('>I',tail[4:])[0]
 if tail[:4]==b'XTcc' and space<=0x7fffffbf-f.stat().st_size:
  h[5]=1;struct.pack_into('>I',h,6,space);source='XTcc'
if a.action!='info':
 h[5]=int(a.action=='exec');struct.pack_into('>I',h,6,a.data_space if h[5] else 0)
 meta.parent.mkdir(exist_ok=True);meta.write_bytes(h)
print(json.dumps({'name':f.name,'length':f.stat().st_size,'type':h[5],
                  'data_space':struct.unpack_from('>I',h,6)[0], 'source':source if a.action=='info' else 'metadata'},indent=2))
