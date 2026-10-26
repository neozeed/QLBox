#!/usr/bin/env python3
"""Boot the unpatched ROM, type BASIC through IPC, and inspect guest-written RAM."""
import os, pathlib,subprocess,tempfile,sys,struct
root=pathlib.Path(__file__).resolve().parents[1]
exe=pathlib.Path(sys.argv[1]).resolve()
rom=pathlib.Path(os.environ.get('QLBOX_TEST_ROM',str(root/'build/minerva.rom')))
script=('PRINT "MINERVA GAS 1.98"\nPOKE 250000,6*7\n'
        '10 FOR I=1 TO 3\n20 POKE 250000+I,I*11\n30 END FOR I\n'
        '40 POKE 250004,99\nRUN\nBEEP 1000,20\n')
with tempfile.TemporaryDirectory() as d:
 p=pathlib.Path(d);(p/'test.bas').write_text(script)
 for boot,ram in [('f1',128),('f2',128),('f1',640),('f2',640)]:
  out=p/f'{boot}-{ram}.ram'
  run=subprocess.run([str(exe),'--headless','--rom',str(rom),'--mount',d,
   '--boot',boot,'--ram',str(ram),'--frames','3000','--type',str(p/'test.bas'),
   '--ram-dump',str(out)],capture_output=True,text=True,timeout=60)
  assert run.returncode==0,run.stderr
  mem=out.read_bytes()
  assert mem[250000:250005]==bytes([42,11,22,33,99]),(boot,ram,mem[250000:250005])
  assert struct.unpack_from('>I',mem,0x28020)[0]==0x20000+ram*1024
  print(f'PASS: Minerva F{boot[-1]}, {ram} KiB; arithmetic, loop, IPC typing, guest RAM marker.')
 # Reject oversized, undersized and unsupported images cleanly.
 for name,data in [('short',b'\0'*100),('large',rom.read_bytes()+b'\0'*65536),('unknown',b'\0'*48822)]:
  f=p/(name+'.rom');f.write_bytes(data)
  run=subprocess.run([str(exe),'--headless','--rom',str(f),'--mount',d,'--frames','1'],capture_output=True)
  assert run.returncode!=0,name
 print('PASS: ROM loader rejects invalid/unsupported images.')
