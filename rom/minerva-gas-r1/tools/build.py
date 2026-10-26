#!/usr/bin/env python3
import os,json,re,subprocess
from pathlib import Path
R=Path(__file__).resolve().parents[1];os.chdir(R)
B=R/'build';B.mkdir(exist_ok=True)
sections={}
order=json.loads((R/'order.json').read_text())
for num,(name,_) in enumerate(order):
 lines=(R/'src'/name).read_text().splitlines();local=set()
 for line in lines:
  if line.endswith(':'):local.add(line[:-1])
  if line.startswith('.equ '):local.add(line[5:].split(',')[0])
 export=set()
 for line in lines:
  if line.startswith('.globl '):export.update(line[7:].split(','))
 local-=export; sec=None;pre=[]
 for line in lines:
  if line.startswith('.globl '):continue
  if line.startswith('.section '):
   sec=line.split()[1].split(',')[0];sections.setdefault(sec,[]);continue
  indent=line[:len(line)-len(line.lstrip())];head,sep,tail=line.lstrip().partition(' ') if not line.endswith(':') else ('','',line)
  head=indent+head
  line=head+sep+re.sub(r'(?<![\w.$])[A-Za-z_][\w.$]*',lambda m:f'M{num}_{m[0]}' if m[0] in local else m[0],tail)
  if sec:sections[sec].append(line)
  else:pre.append(line)
 # Constant definitions before each module's first section.
 if pre:sections.setdefault('__const',[]).extend(pre)
text=['.text']+sections.pop('__const',[])
for sec,lines in sections.items():text+=['.balign 2,0','/* section '+sec+' */']+lines
(B/'minerva.s').write_text('\n'.join(text)+'\n')
prefix=os.environ.get('CROSS','m68k-elf-')
def run(*args):subprocess.run(args,check=True)
run(prefix+'as','-m68000','--register-prefix-optional','--bitwise-or','-o',str(B/'minerva.o'),str(B/'minerva.s'))
run(prefix+'ld','-Ttext=0','-e','0x410','-Map',str(B/'minerva.map'),'-o',str(B/'minerva.elf'),str(B/'minerva.o'))
run(prefix+'objcopy','-O','binary',str(B/'minerva.elf'),str(B/'minerva.rom'))
with (B/'minerva.symbols').open('w') as f:subprocess.run([prefix+'nm','-n',str(B/'minerva.elf')],stdout=f,check=True)
print('ROM:',(B/'minerva.rom').stat().st_size,'bytes')
