coclass 'psqlite'
CH=: i.0
DBS=: i.0 3
Debug=: 0
LastError=: ''
Timeout=: 60000
SQLITE_INTEGER=: 1
SQLITE_FLOAT=: 2
SQLITE_TEXT=: 3
SQLITE_BLOB=: 4
SQLITE_NULL_INTEGER=: <.-2^<:32*1+IF64
SQLITE_NULL_FLOAT=: __
SQLITE_NULL_TEXT=: 'NULL'
create=: 3 : 0
'file opt'=. 2 {. boxopen y
file=. 0 pick fboxname file
flags=. SQLITE_OPEN_FULLMUTEX,SQLITE_OPEN_WAL
if. (;:'nowal') e. ;:opt do.
  flags=. flags-.SQLITE_OPEN_WAL
end.
if. (;:'readonly') e. ;:opt do.
  flags=. flags,~SQLITE_OPEN_READONLY
else.
  flags=. flags,~SQLITE_OPEN_READWRITE
end.
opts=. SQLITE_OPEN_CREATE
flags=. +/flags,opts #~ (;:'create') e. ;:opt
handle=. ,_1
nul=. SQLITE_NULL_INTEGER;SQLITE_NULL_FLOAT;SQLITE_NULL_TEXT
if. SQLITE_OK ~: >@{. cdrc=. sqlite3_extopen file;handle;flags;nul,<<0 do.
  throw 'unable to open database' return.
end.
CH=: {.handle=. 2{::cdrc
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
round=: [ * [: <. 0.5 + %~
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
sel=. fixselect1 y
if. -. '.' e. sel do. return. end.
if. 'pragma' -: 6 {. sel do. return. end.
if. -. '"' e. sel do. return. end.
b=. (sel e. ' ,<>!=') > ~:/\sel='"'
t=. (1,b) <;.1 ' ',sel
m=. I. ('.' e. &> t) > '"' e.&> t
if. -. 1 e. m do. sel return. end.
dq=. {. , '"' , '"' ,~ }.
}. ; (dq each m{t) m} t
)
fixselect1=: 3 : 0
sel=. dltb y
hdr=. tolower 7 {. sel
if. (<hdr) e. 'pragma ';'select ' do. sel return. end.
if. 1 e. ' from ' E. sel do.
  'select ',sel return.
end.
'select * from ',sel
)
fixselectx=: 3 : 0
sel=. fixselect y
cls=. 0 pick splitselect sel
if. -. 1 e. (' rowid,' E. cls) +. ' rowid ' E. cls do.
  'select rowid,',dlb 6 }. sel
end.
)
getlastrows=: 3 : 0
'len tab where'=. y
rws=. sqlexec 'select rowid from ',tab,where
(-len <. #rws) {. rws
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
if. Debug do. sminfo LastError end.
throw.
)
xeach=: 1 : (':';'(u each x{y) x}y')
3 : 0''
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  if. IF64 < arch-:'arm64-v8a' do.
    arch=. 'armeabi-v7a'
  elseif. IF64 < arch-:'x86_64' do.
    arch=. 'x86'
  end.
  2!:0 'mkdir -p ', jpath'~bin/../libexec/',arch
  libsqlite=: (jpath'~bin/../libexec/',arch,'/libjsqlite3.so')
else.
  ext=. (('Darwin';'Linux') i. <UNAME) pick ;:'dylib so dll'
  libsqlite=: jpath '~addons/data/sqlite/lib/libjsqlite3',((-.IF64)#'_32'),'.',ext
end.
)
binreq=: 108
relreq=: 901
checklibrary=: 3 : 0
if. ((<UNAME) e.'Darwin';'Linux')>IF64+.IFRASPI do.
  sminfo 'Sqlite';'The data/sqlite addon is for J64 only.' return.
end.
if. -. fexist libsqlite do.
  getbinmsg 'The data/sqlite binary has not yet been installed.',LF2,'To install, ' return.
end.
extver=. 100 * 0 ". sqlite_extversion''
if. binreq = extver do. return. end.
if. binreq > extver do.
  getbinmsg 'The data/sqlite binary is out of date.',LF2,'To get the latest, ' return.
end.
sminfo 'Sqlite';'The data/sqlite addon is out of date. Please install the latest version.' return.
)
getbin=: 3 : 0
if. ((<UNAME) e.'Darwin';'Linux')>IF64+.IFRASPI do. return. end.
require 'pacman'
path=. 'http://www.jsoftware.com/download/sqlitebin/',(":relreq),'/'
arg=. HTTPCMD_jpacman_
tm=. TIMEOUT_jpacman_
dq=. dquote_jpacman_ f.
to=. libsqlite_psqlite_
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  if. IF64 < arch-:'arm64-v8a' do.
    arch=. 'armeabi-v7a'
  elseif. IF64 < arch-:'x86_64' do.
    arch=. 'x86'
  end.
  fm=. path,'android/libs/',z=. arch,'/libjsqlite3.so'
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
fm=. path,(IFRASPI#'raspberry/'),1 pick fpathname to
lg=. jpath '~temp/getbin.log'
cmd=. arg rplc '%O';(dquote to);'%L';(dquote lg);'%t';'3';'%T';(":tm);'%U';fm
res=. ''
fail=. 0
try.
  fail=. _1-: res=. shellcmd cmd
  2!:0 ::0:^:(UNAME-:'Linux') 'chmod 644 ', dquote to
catch. fail=. 1 end.
if. fail +. 0 >: fsize to do.
  if. _1-:msg=. freads lg do.
    if. (_1-:msg) +. 0=#msg=. res do. msg=. 'Unexpected error' end. end.
  ferase to,lg
  smoutput 'Connection failed: ',msg
else.
  ferase lg
  smoutput 'Sqlite binary installed.'
end.
)
getbinmsg=: 3 : 0
msg=. y,' run the getbin_psqlite_'''' line written to the session.'
smoutput '   getbin_psqlite_'''''
sminfo 'Sqlite';msg
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
sqlite3_free=: (lib, ' sqlite3_free > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_last_insert_rowid=: (lib, ' sqlite3_last_insert_rowid > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_libversion=: (lib, ' sqlite3_libversion > ',(IFWIN#'+'),' x' ) &cd
sqlite3_sourceid=: (lib, ' sqlite3_sourceid > ',(IFWIN#'+'),' x' ) &cd
sqlite3_extopen=: (lib, ' sqlite3_extopen ',(IFWIN#'+'),' i *c *x i x d *c *c' ) &cd
sqlite3_extversion=: (lib, ' sqlite3_extversion > ',(IFWIN#'+'),' x') &cd
sqlite3_exec_values=: (lib, ' sqlite3_exec_values > ',(IFWIN#'+'),' i x *c i i *i *i *c') &cd
sqlite3_free_values=: (lib, ' sqlite3_free_values > ',(IFWIN#'+'),' i *') &cd
sqlite3_read_values=: (lib, ' sqlite3_read_values ',(IFWIN#'+'),' i x *c *') &cd
sqlite3_select_values=: (lib, ' sqlite3_select_values ',(IFWIN#'+'),' i x *c * i *i *i *c') &cd
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
if. 0 -: args=. writeargs y do. 0 return. end.
'tab nms typ dat'=. args
sel=. }. (+:#nms) $ ',?'
sel=. 'insert into ',tab,' ',(listvalues nms),' values(',sel,')'
execparm sel;nms;typ;<dat
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
sqlcolinfo=: 3 : 0
sel=. 'select * from ',y,' limit 0'
'rc res'=. 0 3 { sqlite3_read_values CH;sel;,2
if. rc ~: SQLITE_DONE do. throw'' return. end.
'j typ nms len j cls'=. memr res, 0 6 4
names=. <;._2 memr nms,0,len
types=. memr typ,0,cls,4
sqlite3_free_values <res
names;types
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
sqlfkey=: 3 : 0
sqlreads 'pragma foreign_key_list(',y,')'
)
sqlindex=: 3 : 0
sqlreads 'pragma index_list(',y,')'
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
sqlparm=: 3 : 0
if. 2=#y do.
  'sel dat'=. y
  typ=. parmtype &> boxxopen dat
else.
  'sel typ dat'=. y
end.
typ=. ,typ
nms=. ('item',":) each i.#typ
'nms dat'=. parmargs nms;<dat
execparm sel;nms;typ;<dat
)
execparm=: 3 : 0
'sel nms typ dat'=. y
rws=. #0 pick dat
val=. typ fixparm each dat
if. (<0) e. val do.
  throw 'invalid data for',;' ' ,each nms #~ (<0)=val return.
end.
typval=. (#typ);typ;(#&>val);;val
if. 'select ' -: 7 {. sel do.
  readvalues sqlite3_select_values CH;sel;(,2);typval
else.
  rc=. sqlite3_exec_values CH;sel;rws;typval
  if. rc do. throw '' end.
end.
)
fixparm=: 4 : 0
if. (x=0) +. 1 < #$y do. 0 return. end.
t=. 3!:0 y
if. x=1 do.
  if. t e. 1 4 do. (2+IF64) (3!:4) y else. 0 end. return.
end.
if. x=2 do.
  if. t e. 1 4 8 do. 2 (3!:5) y else. 0 end. return.
end.
if. t ~: 32 do. 0 return. end.
if. 0 e. 2 = 3!:0 &> y do. 0 return. end.
if. x=3 do. ; y ,each {.a. else. (2 (3!:4) # &> y),;y end.
)
parmargs=: 3 : 0
'nms dat'=. y

nms=. ,each boxxopen nms

if. 0 e. $dat do. 0 return. end.
dat=. boxxopen dat
ndx=. I. 2=3!:0 &> dat
dat=. (<each ndx{dat) ndx} dat

rws=. {. len=. # &> dat
if. 0=rws do. 0 return. end.
if. 0 e. rws = len do.
  throw 'column data not of same length: ',":len return.
end.

nms;<dat
)
parmtype=: 3 : 0
t=. 3!:0 y
if. t e. 1 4 do. SQLITE_INTEGER
elseif. t=8 do. SQLITE_FLOAT
elseif. t e. 2 32 do. (({.a.) e. ;y) pick SQLITE_TEXT;SQLITE_BLOB
elseif. do. throw 'unsupported datatype: ',":t
end.
)
writeargs=: 3 : 0
'tab nms dat'=. y

if. 0=args=. parmargs nms;<dat do. 0 return. end.
'nms dat'=. args

'names types'=. sqlcolinfo tab

if. 0=#nms do.
  nms=. names
elseif. 0 e. nms e. names do.
  throw 'column not found:',; ' ' ,each nms -. names return.
end.
typ=. (names i. nms) { types

tab;nms;typ;<dat
)
sqlread=: 3 : 0
sel=. fixselect y
readvalues sqlite3_read_values CH;sel;,2
)
readvalues=: 3 : 0
'rc res'=. 0 3 { y
if. rc ~: SQLITE_DONE do. throw'' return. end.
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
    cnt=. memr p,SZI,rws,4
    pos=. SZI * rws+1
    dat=. memr p,pos,+/cnt
    if. 0=#dat do.
      val=. (#cnt)#<''
    else.
      if. 0 e. cnt do.
        msk=. 1 (0,+/\}:cnt-.0)} (#dat)$0
        val=. (cnt>0) #^:_1 msk <;.1 dat
      else.
        msk=. 1 (0,+/\}:cnt)} (#dat)$0
        val=. msk <;.1 dat
      end.
    end.
  end.
  data=. data,<val
end.
sqlite3_free_values <res
colnames;<data
)
sqlreadx=: 3 : 'sqlread fixselectx y'
sqlreads=: astable @ sqlread
sqlreadsx=: astable @ sqlreadx
sqldict=: 3 : 0
'cls dat'=. sqlread y
if. 1 = #>{.dat do.
  dat=. 0 pick each dat
end.
cls,.dat
)
sqlendsx=: 3 : 0
5 sqlendsx y
:
'cls dat'=. <"1 x sqlheadx y
ext=. 1{x sqltailx y
msk=. -. (0 pick ext) e. 0 pick dat
cls,:dat ,each msk&# each ext
)

sqlends=: }."1 @: sqlendsx
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
if. x-:0 do. sqlreads y return. end.
'frm tab whr ord'=. splitselect fixselect y
sqlreads frm,tab,' where rowid in ',listvalues getlastrows x;tab;whr
)
sqltailx=: 3 : 0
10 sqltailx y
:
if. x-:0 do. sqlreadx y return. end.
'frm tab whr ord'=. splitselect fixselect y
sqlreadsx frm,tab,' where rowid in ',listvalues getlastrows x;tab;whr
)
sqlite3do=: 3 : 0
'db cmd'=. y
db=. jpath db
cmd=. a: -.~ <;._2 cmd,LF
ndx=. I. '.' ~: {. &> cmd
f=. , ';' -. {:
cmd=. (f each ndx{cmd) ndx} cmd
cmd=. ; cmd ,each LF
cmd fwrites tmp=. jpath '~temp/sqlite3shell.cmd'
if. IFWIN do.
  r=. spawn_jtask_ 'sqlite3.exe "',(winpathsep db),'" < "',(winpathsep tmp),'"'
else.
  r=. 2!:0 '/usr/bin/sqlite3 "',db,'" < "',tmp,'"'
end.
r[ferase tmp
)
sqlite3=: 3 : 0
sqlite3do (sqlname'');y
)
sqlimportcsv=: 3 : 0
'table def sep csvfile'=. y
cmd=. (termLF def),'.separator "',sep,'"',LF,'.import "',csvfile,'" ',table
sqlite3 cmd
)
sqlupdate=: 3 : 0
'tab whr nms dat'=. y
if. 0 -: args=. writeargs tab;nms;<dat do. 0 return. end.
'tab nms typ dat'=. args
whr=. ('where ' #~ -.'where ' -: 6 {. whr),whr
set=. }:;nms ,each <'=?,'
sel=. 'update ',tab,' set ',set,' ',whr
execparm sel;nms;typ;<dat
)
sqlupsert=: 3 : 0
'tab keys nms dat'=. y
keys=. boxxopen keys
nms=. ,each boxxopen nms
if. 0=#keys do. throw 'upsert keys names not given' return. end.
if. #keys -. nms do. throw 'upsert keys names not in column names' return. end.

if. 0 -: args=. writeargs tab;nms;<dat do. 0 return. end.
'tab nms typ dat'=. args

sel=. ''
for_key. keys do.
  ndx=. nms i. key
  sel=. sel,' AND ',(>key),' in ',listvalues ~.ndx pick dat
end.
old=. sqlexec ('rowid,',commasep keys),' from ',tab,' where ',5 }.sel
row=. 0 pick old
if. 0=#row do. sqlinsert 0 2 3{y return. end.

old=. }.old
new=. (nms i. keys) { dat
ind=. old boxindexof new

msk=. ind=#row
if. 1 e. msk do.
  sqlinsert tab;nms;<msk&# each dat
  if. -. 0 e. msk do. return. end.
  ind=. (-.msk)#ind
  dat=. (-.msk)&# each dat
end.
row=. ind{row

old=. sqlexec 'rowid,',(commasep nms),' from ',tab,' where rowid in ',listvalues row
msk=. -. dat boxmember }.old
if. -. 1 e. msk do. 0 return. end.

row=. msk#row
dat=. msk&# each dat
cls=. #nms

cmd=. 'update ',tab,' set ', (}: ; nms ,each <'=?,'),' where rowid='
for_r. row do.
  execparm (cmd,":r);nms;typ;<r_index {each dat
end.
#row
)
checklibrary$0
cocurrent 'base'
