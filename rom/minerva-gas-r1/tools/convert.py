#!/usr/bin/env python3
"""Translate the supplied Minerva 1.98 QL assembler source to GNU m68k GAS."""
import re,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]

def parts(s,space=False):
 out=[]; start=0; quote=None; depth=0
 for i,c in enumerate(s):
  if quote:
   if c==quote:quote=None
  elif c in "'\"":quote=c
  elif c in '({[':depth+=1
  elif c in ')}]':depth-=1
  elif depth==0 and (c==',' or space and c.isspace()):
   if s[start:i].strip():out.append(s[start:i].strip())
   start=i+1
 if s[start:].strip():out.append(s[start:].strip())
 return out

def parse(s):
 # Semicolon comments also immediately follow labels.
 q=None; depth=0; cut=len(s)
 for j,c in enumerate(s):
  if q:
   if c==q:q=None
  elif c in "'\"":q=c
  elif c=='{':depth+=1
  elif c=='}':depth-=1
  elif c==';' and depth==0:cut=j;break
 s=s[:cut]
 if not s.strip() or s.lstrip().startswith(('*',';')):return '','',''
 a=s.split(None,2)
 if s[0].isspace():
  a=s.strip().split(None,1);return '',a[0].lower(),a[1] if len(a)>1 else ''
 return a[0],a[1].lower() if len(a)>1 else '',a[2] if len(a)>2 else ''

def operand(s):
 # Original assembler terminates ordinary operands at first unquoted whitespace.
 out=''; q=None
 for c in s:
  if q:
   out+=c
   if c==q:q=None
  elif c in "'\"":q=c;out+=c
  elif c.isspace() or c==';':break
  else:out+=c
 return out

class Converter:
 def __init__(self):
  self.mac={};self.v={};self.count=0;self.out=[];self.reg={};self.offset=None;self.sections=[]
 def numeric(self,s):
  s=self.expr(self.expand(s).strip());s=re.sub(r'(?<![\w.])\$([\da-fA-F]+)',r'0x\1',s);s=re.sub(r'%([01]+)',r'0b\1',s)
  s=re.sub(r"'([^']*)'",lambda m:str(int.from_bytes(m[1].encode('latin1'),'big')),s)
  s=s.replace('!','|').replace('/','//')
  s=re.sub(r'\b0+(\d+)\b',r'\1',s)
  def sym(m):
   k=m[0];return str(self.v[k.lower()]) if k.lower() in self.v else k
  s=re.sub(r'(?<![\w])[a-zA-Z_][\w.$]*',sym,s)
  v=int(eval(s,{'__builtins__':{}},{})) & 0xffffffff
  return v-0x100000000 if v>=0x80000000 else v
 def val(self,s):
  s=s.strip()
  if s.startswith('{') and s.endswith('}'):return s[1:-1]
  if s.lower() in self.v:return str(self.v[s.lower()])
  if s.startswith('.'):
   m=re.fullmatch(r'\.(\w+)\((.*)\)',s)
   if m:
    f,a=m[1],parts(m[2]); x=self.val(a[0]) if a else ''
    if f=='parm':return self.params[self.numeric(a[0])-1] if 0<self.numeric(a[0])<=len(self.params) else ''
    if f=='len':return str(len(x))
    if f=='left':return x[:max(0,self.numeric(a[1]))]
    if f=='right':return x[-self.numeric(a[1]):] if self.numeric(a[1])>0 else ''
    if f=='instr':return str(x.find(self.val(a[1]))+1)
    if f=='ucase':return x.upper()
  return s
 def expand(self,s):
  for _ in range(100):
   n=re.sub(r'\[([^\[\]]*)\]',lambda m:self.val(m[1]),s)
   if n==s:return n
   s=n
  raise ValueError('recursive expansion '+s)
 def load(self,path):
  lines=path.read_text(encoding='latin1').splitlines();joined=[]
  for s in lines:
   if joined and joined[-1].rstrip().endswith('\\') and parse(joined[-1])[1] in ('assert','msg','b.w.def'):joined[-1]=joined[-1].rstrip()[:-1]+' '+s.strip()
   else:joined.append(s)
  self.run(joined)
 def run(self,lines):
  labels={parse(s)[0].lower():i for i,s in enumerate(lines) if parse(s)[1]=='maclab'};i=0;steps=0
  while i<len(lines):
   raw=lines[i];i+=1;steps+=1
   if raw.strip():self.out.append('/* QL: '+raw.replace('*/','* /')+' */')
   if steps>100000:raise ValueError('macro runaway')
   lab,op,arg=parse(raw)
   if op=='macro':
    body=[]
    while parse(lines[i])[1]!='endm':body.append(lines[i]);i+=1
    i+=1;self.mac[lab.lower()]=(parts(arg,True),body);continue
   s=self.expand(raw);lab,op,arg=parse(s)
   if op.startswith(';'):op='';arg=''
   if not op:
    if lab:self.emit(lab,'','')
    continue
   if op in ('maclab','local','list','nolist','page','end'):continue
   if op=='goto':i=labels[operand(arg).lower()];continue
   if op in ('ifnum','ifstr'):
    m=re.match(r'(.*?)\s+(<>|~=|>=|<=|=|>|<)\s+(.*?)\s+goto\s+(\S+)',arg,re.I)
    if not m:raise ValueError('condition '+s)
    a,cmp,b,target=m.groups()
    a,b=(self.numeric(a),self.numeric(b)) if op=='ifnum' else (self.val(a),self.val(b))
    ok={'=':a==b,'<>':a!=b,'~=':a!=b,'>':a>b,'<':a<b,'>=':a>=b,'<=':a<=b}[cmp]
    if ok:i=labels[target.lower()]
    continue
   if op in ('setnum','setstr'):
    self.v[lab.lower()]=self.numeric(operand(arg)) if op=='setnum' else self.val(arg.split(';')[0].strip());continue
   if op=='include':
    name=operand(arg).strip("'\"");p=ROOT/'original'/'M'/Path(*name.split('_')[2:]);self.load(p);continue
   base=op if op in self.mac else op.rsplit('.',1)[0] if '.' in op else op
   if base=='assert':
    if self.offset is not None:arg=re.sub(r'(?<![\w)])\*(?![\w(])',str(self.offset),arg)
    self.out.append('/* original assertion: '+arg+' */');continue
   if base in self.mac:
    formals,body=self.mac[base];args=[a[1:-1] if a.startswith('{') and a.endswith('}') else a for a in parts(arg,True)];old=self.v.copy();oldp=getattr(self,'params',[])
    self.params=args;self.count+=1
    # Macro variables are global unless explicitly declared local.
    locals_=['.lab','.ext','.l','.nparms']+formals
    for row in body:
     if parse(row)[1]=='local':locals_+=parts(parse(row)[2],True)
    self.v.update({'.lab':lab,'.ext':op[len(base)+1:].upper() if op!=base else '', '.l':str(self.count),'.nparms':len(args)})
    self.v.update({k.lower():args[j] if j<len(args) else '' for j,k in enumerate(formals)})
    self.run(body)
    for k in locals_:
     k=k.lower()
     if k in old:self.v[k]=old[k]
     else:self.v.pop(k,None)
    self.params=oldp;continue
   if op=='error':raise ValueError(s)
   self.emit(lab,op,arg)
 def expr(self,s):
  s=re.sub(r'(?<![\w.])\$([0-9a-fA-F]+)',r'0x\1',s)
  s=re.sub(r'%([01]+)',r'0b\1',s)
  s=re.sub(r"'((?:[^']|'')*)'",lambda m:str(int.from_bytes(m[1].replace("''", "'").encode('latin1'),'big')),s)
  s=re.sub(r'(?<![\w)])\*(?![\w(])', '.',s)
  s=s.replace('!','|')
  s=re.sub(r'(?<![\w.$])0+([0-9]+)(?![\w.$])',lambda m:str(int(m[0])),s)
  def arithmetic(x):
   if not re.search(r'[+*/&|<>^-]',x):return x
   tok=re.findall(r'0x[0-9a-fA-F]+|[\w.$]+|<<|>>|.',x);pos=0
   prec={'|':5,'^':5,'&':5,'+':4,'-':4,'*':6,'/':6,'<<':7,'>>':7}
   def get(p=0):
    nonlocal pos
    t=tok[pos];pos+=1
    if t in ('-','+','~'):a='('+t+get(8)+')'
    elif t=='(':
     a=get();assert tok[pos]==')';pos+=1
    else:a=t
    while pos<len(tok) and prec.get(tok[pos],-1)>=p:
     op=tok[pos];pos+=1;b=get(prec[op]+1);a='('+a+op+b+')'
    return a
   try:
    a=get()
    return a if pos==len(tok) else x
   except (IndexError,AssertionError):return x
  result=[]
  for a in parts(s):
   if a.startswith('#'):result.append('#'+arithmetic(a[1:]));continue
   m=re.match(r'(.*?)((?:\((?:[ad][0-7]|sp|pc)(?:,.*)?\))\+?)$',a,re.I)
   if m:result.append(arithmetic(m[1])+m[2] if m[1] and m[1]!='-' else a)
   elif re.fullmatch(r'(?:[ad][0-7]|sp)(?:[/-](?:[ad]?[0-7]|sp))*|sr|ccr|usp',a,re.I):result.append(a)
   elif a.endswith('.w') and a.startswith('('):result.append(arithmetic(a[:-2])+'.w')
   else:result.append(arithmetic(a))
  return ','.join(result)
 def emit(self,lab,op,arg):
  arg=operand(arg)
  if op in ('rts','rte','nop','reset'):arg=''
  if op.startswith('xref'):return
  if op=='xdef':self.out.append('.globl '+arg);return
  if op=='equ':
   if self.offset is not None:arg=re.sub(r'(?<![\w)])\*(?![\w(])',str(self.offset),arg)
   try:self.v[lab.lower()]=self.numeric(arg)
   except Exception:pass
   self.out.append('.equ '+lab+','+self.expr(arg));return
  if op=='reg':self.reg[lab]=arg;return
  if op=='offset':self.offset=self.numeric(arg);return
  if op=='section':
   self.offset=None;self.sections.append(arg);self.out.append('.section '+arg+',"ax"');return
  size={'b':1,'w':2,'l':4}
  if self.offset is not None:
   if lab:self.out.append('.equ '+lab+','+str(self.offset));self.v[lab.lower()]=self.offset
   if op.startswith('ds.'):self.offset+=self.numeric(arg)*size[op[-1]]
   elif op:raise ValueError('offset op '+op)
   return
  if op.startswith(('dc.','ds.','dcb.')) and op[-1] in 'wl':self.out.append('.balign 2,0')
  if lab:self.out.append(lab+':')
  if not op:return
  if op.startswith('dc.'):
   anchor='dc_anchor_'+str(len(self.out));self.out.append(anchor+':')
   for a in parts(arg):
    if not a.startswith("'"):a=re.sub(r'(?<![\w)])\*(?![\w(])',anchor,a)
    if a.startswith("'") and a.endswith("'"):
     data=a[1:-1].replace("''", "'").encode('latin1');self.out.append('.byte '+','.join(str(x) for x in data))
     if op[-1] in 'wl':self.out.append('.balign 2,0')
    else:self.out.append({ 'b':'.byte ','w':'.word ','l':'.long '}[op[-1]]+('('+self.expr(a)+')&65535' if op[-1]=='w' and '-' in a else '('+self.expr(a)+')&255' if op[-1]=='b' else self.expr(a)))
   return
  if op.startswith('ds.'):
   if arg=='0':return
   self.out.append('.space ('+self.expr(arg)+')*'+str(size[op[-1]])+',0');return
  if op.startswith('dcb.'):
   a=parts(arg);self.out.append('.space '+self.expr(a[0])+',255') if '*' in a[0] else self.out.extend(['.rept '+self.expr(a[0]),{1:'.byte ',2:'.word ',4:'.long '}[size[op[-1]]]+self.expr(a[1]),'.endr']);return
  if op.startswith('movem'):
   for k,v in self.reg.items():arg=re.sub(r'(?<![\w.])'+re.escape(k)+r'(?![\w.])',lambda m:v,arg)
  if re.match(r'^b\w+\.l$',op):op=op[:-1]+'w'
  if op=='exg.l':op='exg'
  if op=='exg':
   aa=parts(arg)
   # The QL assembler puts the second same-class register in bits 11..9.
   if len(aa)==2 and aa[0][0]==aa[1][0]=='a':arg=aa[1]+','+aa[0]
  if op.endswith('.b') and op.split('.')[0] in ('and','or','eor','cmp','move','add','sub') and arg.startswith('#'):
   aa=parts(arg)
   aa[0]='#(('+aa[0][1:]+')&255)';arg=','.join(aa)
  mm=re.fullmatch(r'(.*)\(pc,([ad])([0-7])\.([wl])\)',arg)
  if op=='jmp' and mm:
   disp,reg,n,width=mm.groups();ext=(32768 if reg=='a' else 0)+(int(n)<<12)+(2048 if width=='l' else 0)
   self.out.extend(['.word 0x4efb','.word '+str(ext)+'|(('+self.expr(disp)+'-.)&255)']);return
  if op in ('lea','pea'):
   aa=parts(arg)
   if aa and '(' not in aa[0] and not aa[0].startswith('#'):
    try:self.numeric(aa[0])
    except Exception:aa[0]=aa[0]+'(pc)'
    arg=','.join(aa)
  if op.startswith(('addq.','subq.')) and '-' in parts(arg)[0] or op=='addq.w' and arg.startswith('#boot_len,'):
   aa=parts(arg);ea=aa[1];mode=(int(ea[1]) if ea.startswith('d') else 8+int(ea[1]) if ea.startswith('a') else 23 if ea=='(sp)' else None)
   if mode is not None:
    code=0x5000+(0x100 if op.startswith('sub') else 0)+{'b':0,'w':64,'l':128}[op[-1]]+mode
    self.out.append('.word '+str(code)+'|((('+self.expr(aa[0][1:])+')&7)<<9)');return
  self.out.append('    '+op+' '+self.expr(arg))

def main():
 out=ROOT/'src';out.mkdir(exist_ok=True);order=[]
 for lib in (ROOT/'original/M/ROM/link').read_text().splitlines():
  group=lib.split('_')[2]
  for item in (ROOT/'original/M'/group/'cct').read_text().splitlines():
   if not item.strip():continue
   name=item.strip().split('_')[3];path=ROOT/'original/M'/group/(name+'.asm')
   c=Converter()
   try:c.load(path)
   except Exception as e:raise RuntimeError(str(path)+': '+str(e)) from e
   dest=f'{group}_{name}.s';(out/dest).write_text('/* Generated from '+str(path.relative_to(ROOT))+' */\n'+'\n'.join(x if x.startswith('/*') else x.lower() for x in c.out)+'\n');order.append((dest,c.sections))
 (ROOT/'order.json').write_text(json.dumps(order,indent=2))
 print('Converted',len(order),'modules')
if __name__=='__main__':main()
