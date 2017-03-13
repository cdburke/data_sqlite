coclass 'psqlite'
CH=: i.0
DBS=: i.0 3
Debug=: 0
LastError=: ''
Timeout=: 60000
create=: 3 : 0
'file opt'=. 2 {. boxopen y
file=. 0 pick fboxname file
flags=. SQLITE_OPEN_READWRITE,SQLITE_OPEN_FULLMUTEX,SQLITE_OPEN_WAL
opts=. SQLITE_OPEN_CREATE
flags=. +/flags,opts #~ (;:'create') e. ;:opt
handle=. ,_1
if. SQLITE_OK ~: sqlite3_open_v2 file;handle;flags;<<0 do.
  throw 'unable to open database' return.
end.
CH=: {.handle
sqlite3_extended_result_codes CH, 1
sqlite3_busy_timeout CH, Timeout
connadd CH;file;coname''
)
destroy=: 3 : 0
sqlite3_close CH
conndel CH
codestroy''
)
0 0$".'p<c>q<=:>,q<&{"1>' 8!:2 ,.~i.3

boxindexof=: i.&>~@[ i.&|: i.&>
boxmember=: i.&>~ e.&|: i.&>~@]

col=: ,.@:>each :($:@([ {.each ]))
commasep=: }.@;@:((',' , ":)each)
intersect=: e. # [
isboxed=: 0 < L.
ischar=: 2=3!:0
isfloat=: 8=3!:0
samesize=: 1 = #@~.@:(#&>)
strlen=: ;#
termLF=: , (0 < #) # LF -. {:
astable=: 3 : 0
'cls dat'=. y
cls,:col dat
)
connadd=: 3 : 0
empty DBS_psqlite_=: DBS,y
)
conndel=: 3 : 0
ndx=. (;c0 DBS) i. CH
if. ndx<#DBS do.
  DBS_psqlite_=: (<<<ndx) { DBS
end.
EMPTY
)
cutat=: 4 : 0
cls=. {:$y
rem=. x|cls
dat=. |: (-x) <\"1 y
}. ; ([:<@:,LF,.":@:>) "1 dat
)
fixcol=: 3 : 0
if. isboxed y do.
  ,dquote each ": each y
elseif. ischar y do.
  ,dquote each dtb each <"1 y
elseif. do.
  ,8!:0 y
end.
)
fixselect=: 3 : 0
hdr=. tolower 7 {. y
if. (<hdr) e. 'pragma ';'select ' do. y return. end.
if. 1 e. ' from ' E. y do.
  'select ',y return.
end.
'select * from ',y
)
fixselectx=: 3 : 0
sel=. fixselect y
cls=. 0 pick splitselect sel
if. -. 1 e. (' rowid,' E. cls) +. ' rowid ' E. cls do.
  'select rowid,',dlb 6 }. sel
end.
)
list2mat=: 3 : 0
|: > (I. 0 = L. &> y) <"0 xeach y
)
listvalues=: 3 : 0
if. ischar y do.
  y=. dtb each <"1 y
end.
if. isboxed y do.
  r=. commasep '"' ,each y ,each '"'
else.
  r=. '-' (I. r='_')} r=. commasep y
end.
'(',r,')'
)
prepare=: 3 : 0
stmt=. ,_1
tail=. ,_1
if. SQLITE_OK = rc=. sqlite3_prepare_v2 CH;(strlen y),stmt;tail do.
  if. tail e. 0 _1 do.
    rc;({.stmt);''
  else.
    rc;({.stmt);memr tail,0 _1
  end.
else.
  rc;_1;''
end.
)
shellcmd=: 3 : 0
if. IFUNIX do.
  hostcmd_j_ y
else.
  spawn_jtask_ y
end.
)
splitselect=: 3 : 0
n=. 6 + 1 i.~ ' from ' E. y
f=. dlb n{.y
y=. deb n}.y
n=. y i. ' '
t=. n{.y
y=. n }.y
n=. 1 i.~ ' order by ' E. y
w=. n{.y
s=. n}.y
f;t;w;s
)
throw=: 3 : 0
if. #y do.
  LastError=: y
else.
  s=. sqlite3_errcode CH
  if. p=. sqlite3_errmsg CH do.
    msg=. memr p, 0 _1
  else.
    msg=. ''
  end.
  LastError=: 'sqlite rc=',(":s),' ',msg
end.
if. Debug do. wdinfo LastError end.
throw.
)
xeach=: 1 : (':';'(u each x{y) x}y')
3 : 0''
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  libsqlite=: (jpath'~bin/../libexec/android-libs/',arch,'/libjsqlite3.so')
else.
  ext=. (('Darwin';'Linux') i. <UNAME) pick ;:'dylib so dll'
  libsqlite=: jpath '~addons/data/sqlite/lib/libjsqlite3',((-.IF64+.IFRASPI)#'_32'),'.',ext
end.
)
libreq=: '1.01'
checklibrary=: 3 : 0
if. ((<UNAME) e.'Darwin';'Linux')>IF64+.IFRASPI do.
  sminfo 'Sqlite';'The data/sqlite addon is for J64 only.' return.
end.
fix=. 100 * 0 ". ]
if. -. fexist libsqlite do.
  msg=. 'The sqlite binary has not yet been installed.',LF2,'To install, '
elseif. (fix libreq) > fix sqlite_extversion'' do.
  msg=. 'The sqlite binary is out of date.',LF2,'To get the latest, '
elseif. do. EMPTY return. end.
msg=. msg,' run the getbin_psqlite_'''' line written to the session.'
smoutput '   getbin_psqlite_'''''
sminfo 'Sqlite';msg
)
getbin=: 3 : 0
if. ((<UNAME) e.'Darwin';'Linux')>IF64+.IFRASPI do. return. end.
require 'pacman'
arg=. HTTPCMD_jpacman_
tm=. TIMEOUT_jpacman_
dq=. dquote_jpacman_ f.
to=. libsqlite_psqlite_
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  fm=. 'http://www.jsoftware.com/download/sqlite/android/libs/',z=. arch,'/libjsqlite3.so'
  'res p'=. httpget_jpacman_ fm
  if. res do.
    smoutput 'Connection failed: ',z return.
  end.
  (<to) 1!:2~ 1!:1 <p
  2!:0 ::0: 'chmod 644 ', dquote to
  1!:55 ::0: <p
  smoutput 'Sqlite binary installed.'
  return.
end.
fm=. 'http://www.jsoftware.com/download/sqlite/',(IFRASPI#'raspberry/'),1 pick fpathname to
lg=. jpath '~temp/getbin.log'
cmd=. arg rplc '%O';(dquote to);'%L';(dquote lg);'%t';'3';'%T';(":tm);'%U';fm
res=. ''
fail=. 0
try.
  res=. shellcmd cmd
  2!:0 ::0:^:(UNAME-:'Linux') 'chmod 644 ', dquote to
catch. fail=. 1 end.
if. fail +. 0 >: fsize to do.
  if. _1-:msg=. freads lg do.
    if. 0=#msg=. res do. msg=. 'Unexpected error' end. end.
  ferase to,lg
  smoutput 'Connection failed: ',msg
else.
  ferase lg
  smoutput 'Sqlite binary installed.'
end.
)
SQLITE_OK=: 0
SQLITE_DONE=: 101
SQLITE_OPEN_READONLY=: 16b00000001
SQLITE_OPEN_READWRITE=: 16b00000002
SQLITE_OPEN_CREATE=: 16b00000004
SQLITE_OPEN_NOMUTEX=: 16b00008000
SQLITE_OPEN_FULLMUTEX=: 16b00010000
SQLITE_OPEN_SHAREDCACHE=: 16b00020000
SQLITE_OPEN_PRIVATECACHE=: 16b00040000
SQLITE_OPEN_WAL=: 16b00080000
lib=. '"',libsqlite,'"'
sqlite3_busy_timeout=: (lib, ' sqlite3_busy_timeout > ',(IFWIN#'+'),' i x i' ) &cd
sqlite3_close=: (lib, ' sqlite3_close > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_errcode=: (lib, ' sqlite3_errcode > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_errmsg=: (lib, ' sqlite3_errmsg > ',(IFWIN#'+'),' x x' ) &cd
sqlite3_exec=: (lib, ' sqlite3_exec > ',(IFWIN#'+'),' i x *c x x *x' ) &cd
sqlite3_extended_result_codes=: (lib, ' sqlite3_extended_result_codes > ',(IFWIN#'+'),' i x i' ) &cd
sqlite3_finalize=: (lib, ' sqlite3_finalize > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_free=: (lib, ' sqlite3_free > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_last_insert_rowid=: (lib, ' sqlite3_last_insert_rowid > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_libversion=: (lib, ' sqlite3_libversion > ',(IFWIN#'+'),' x' ) &cd
sqlite3_open_v2=: (lib, ' sqlite3_open_v2 > ',(IFWIN#'+'),' i *c *x i *c' ) &cd
sqlite3_prepare_v2=: (lib, ' sqlite3_prepare_v2 > ',(IFWIN#'+'),' i x *c i *x *x' ) &cd
sqlite3_sourceid=: (lib, ' sqlite3_sourceid > ',(IFWIN#'+'),' x' ) &cd
sqlite3_extversion=: (lib, ' sqlite3_extversion > ',(IFWIN#'+'),' x') &cd
sqlite3_free_values=: (lib, ' sqlite3_free_values > ',(IFWIN#'+'),' i *') &cd
sqlite3_read_values=: (lib, ' sqlite3_read_values ',(IFWIN#'+'),' i x *') &cd
sqlite_extversion=: 3 : 0
try.
  ":0.01*sqlite3_extversion''
catch.
  '0.00'
end.
)
sqlite_info=: 3 : 0
v=. memr (sqlite3_libversion''),0 _1
s=. memr (sqlite3_sourceid''),0 _1
v;s
)
sqlinsert=: 3 : 0
'tab nms dat'=. y
if. 0 e. $dat do. 0 return. end.
if. 0 e. $nms do. nms=. sqlcols tab end.
nms=. boxopen nms
if. 1=#nms do.
  if. 2=L. dat do. dat=. 0 pick dat end.
  val=. ,. fixcol dat
else.
  dat=. fixcol each dat
  if. 1 < # ~. # &> dat do.
    throw 'data columns not same size: ',":# &> dat
  end.
  val=. |:> dat
end.
sep=. '(',(<:#nms)#','
val=. ' values ',}: ;,(sep ,each "1 val),.<'),'
cmd=. 'insert into ',tab,' ',listvalues nms
sqlcmd cmd,val
)
sqllastrowid=: 3 : 0
sqlite3_last_insert_rowid CH
)
sqlclose=: destroy
sqldebug=: 3 : 'Debug=: y'
sqlerror=: 3 : 'LastError'
sqlcmd=: 3 : 0
rc=. sqlite3_exec CH;y;0;0;,0
if. rc do. throw '' end.
)
sqlcols=: 3 : 0
1 pick sqlexec 'pragma table_info(',y,')'
)
sqlcopy=: 3 : 0
'from to'=. fboxname each y
if. _1 -: (fread from) fwrite to do.
  throw 'unable to copy database' return.
end.
sqlopen to
)
sqlcreate=: 3 : 0
db=. fboxname y
ndx=. (1{"1 DBS) i. db
if. ndx < #DBS do.
  loc=. ndx{2{"1 DBS
  sqlclose__loc''
end.
'' fwrite db
(db;'create') conew 'psqlite'
)
sqlexist=: 3 : 0
sqlexec 'select count(*) from sqlite_master where type="table" and name="',y,'"'
)
sqlmeta=: 3 : 0
sqlreads 'pragma table_info(',y,')'
)
sqlname=: 3 : 0
((;c0 DBS) i. CH) pick c1 DBS
)
sqlopen=: 3 : 0
ndx=. (c1 DBS) i. fboxname y
if. ndx < #DBS do.
  ndx{c2 DBS return.
end.
y conew 'psqlite'
)
sqlreset=: 3 : 0
for_loc. (2{"1 DBS) intersect conl 1 do.
  sqlclose__loc''
end.
EMPTY
)
sqlschema=: 3 : 0
cmd=. 'select sql from main.sqlite_master where name="',y,'" and type in ("table","view")'
0 pick sqlexec cmd
)
sqlsize=: 3 : 0
{. sqlexec 'select count(*) from ',y
)
sqltables=: 3 : 0
r=. sqlexec 'name from main.sqlite_master where type="table"'
r=. r #~ (<'sqlite_') ~: 7 {.each r
sort r #~ (1 e. y E. ]) &> r
)
sqlviews=: 3 : 0
r=. sort sqlexec 'name from main.sqlite_master where type="view"'
r #~ (1 e. y E. ]) &> r
)
sqlread=: 3 : 0
sel=. fixselect dltb y
'rc sh tail'=. prepare sel
if. rc do. throw '' return. end.
'rc j res'=. sqlite3_read_values sh;,2
assert. rc = SQLITE_DONE
SZI=. IF64{4 8
'buf typ nms len rws cls'=. memr res, 0 6 4
colnames=. <;._2 memr nms,0,len
pointers=. memr buf,0,cls,4
types=. memr typ,0,cls,4
data=. ''
for_p. pointers do.
  select. p_index{types
  case. 1 do.
    val=. memr p,0,rws,4
  case. 2 do.
    val=. memr p,0,rws,8
  case. 3 do.
    len=. memr p, 0 1 4
    val=. <;._2 memr p,SZI,len-SZI
  case. 4 do.
    len=. memr p, 0 1 4
    cnt=. memr p,SZI,rws,4
    pos=. SZI * rws+1
    dat=. memr p,pos,len-pos
    msk=. 1 (0,+/\}:cnt)} (#dat)$0
    val=. msk <;.1 dat
  end.
  data=. data,<val
end.
sqlite3_finalize <sh
sqlite3_free_values <res
colnames;<data
)
sqlreadx=: 3 : 'sqlread fixselectx dltb y'
sqlreads=: astable @ sqlread
sqlreadsx=: astable @ sqlreadx
sqldict=: 3 : 0
'cls dat'=. sqlread y
if. 1 = #>{.dat do.
  dat=. 0 pick each dat
end.
cls,.dat
)
sqlexec=: 3 : 0
r=. 1 pick sqlread y
if. 1=#r do.
  0 pick r
end.
)
sqlexecx=: 3 : 0
r=. 1 pick sqlreadx y
if. 1=#r do.
  0 pick r
end.
)
sqlhead=: 3 : 0
10 sqlhead y
:
if. x<0 do.
  (|x) sqltail y
else.
  sqlreads y,(x>0)#' limit ',":x
end.
)
sqlheadx=: 3 : 0
10 sqlheadx y
:
if. x<0 do.
  (|x) sqltailx y
else.
  sqlreadsx y,(x>0)#' limit ',":x
end.
)
sqlkeysum=: 3 : 0
'tab key sum'=. y
key=. commasep boxxopen key
sum=. commasep (<'sum(') ,each (boxxopen sum) ,each ')'
sqlread 'select ',key,',',sum,' from ',tab,' group by ',key, ' order by ',key
)
sqlrand=: 3 : 0
10 sqlrand y
:
id=. dbexec 'rowid from ',y
if. x<#id do.
  id=. sort id {~ x ? #id
end.
sqlreads y,' where rowid in ',listvalues id
)
sqlrandx=: 3 : 0
10 sqlrandx y
:
id=. dbexec 'rowid from ',y
if. x<#id do.
  id=. sort id {~ x ? #id
end.
sqlreadsx y,' where rowid in ',listvalues id
)
sqlreadm=: 3 : 0
'cls dat'=. sqlread y
cls;<list2mat dat
)
sqltail=: 3 : 0
10 sqltail y
:
bgn=. 0 >. (sqlsize y) - x
sqlreads y, (x>0) # ' limit ',(":bgn),',',":x
)
sqltailx=: 3 : 0
10 sqltailx y
:
bgn=. 0 >. (sqlsize y) - x
sqlreadsx y, (x>0) # ' limit ',(":bgn),',',":x
)
sqlite3=: 3 : 0
y fwrites tmp=. }:hostcmd_j_ 'mktemp'
if. IFWIN do.
  r=. spawn_jtask_ 'sqlite3.exe "',(winpathsep sqlname''),'" < "',(winpathsep tmp),'"'
else.
  r=. 2!:0 '/usr/bin/sqlite3 "',(sqlname''),'" < "',tmp,'"'
end.
r[ferase tmp
)
sqlimportcsv=: 3 : 0
'table def sep csvfile'=. y
cmd=. (termLF def),'.separator "',sep,'"',LF,'.import "',csvfile,'" ',table
sqlite3 cmd
)
sqlupsert=: 3 : 0
'tab keys cols dat'=. y
keys=. boxopen keys
cols=. boxopen cols

if. 0 e. $dat do. 0 return. end.
if. 0=#keys do. throw 'upsert keys names not given' return. end.
if. #keys -. cols do. throw 'upsert keys names not in column names' return. end.
if. 1=#cols do.
  if. ischar dat do.
    dat=. <dtb each <"1 dat
  else.
    dat=. boxopen dat
  end.
end.

sel=. ''
for_key. keys do.
  ndx=. cols i. key
  sel=. sel,' AND ',(>key),' in ',listvalues ~.ndx pick dat
end.
old=. sqlexec ('rowid,',commasep keys),' from ',tab,' where ',5 }.sel
row=. 0 pick old
if. 0=#row do. sqlinsert 0 2 3{y return. end.

old=. }.old
new=. (cols i. keys) { dat
ind=. old boxindexof new

msk=. ind=#row
if. 1 e. msk do.
  sqlinsert tab;cols;<msk&# each dat
  if. -. 0 e. msk do. return. end.
  ind=. (-.msk)#ind
  dat=. (-.msk)&# each dat
end.
row=. ind{row

old=. sqlexec 'rowid,',(commasep cols),' from ',tab,' where rowid in ',listvalues row
msk=. -. dat boxmember }.old
if. -. 1 e. msk do. 0 return. end.

row=. msk#row
dat=. msk&# each dat
dat=. |: fixcol &> dat

cmd=. <@}.@;"1 (',' ,each cols ,each '=') ,each "1 dat
cmd=. ('update ',tab,' set ')&, each cmd
cmd=. ;cmd ,each (' where rowid=', ';',~ ":) each row
sqlcmd 'begin;',cmd,'commit;'
)
checklibrary$0
cocurrent 'base'
