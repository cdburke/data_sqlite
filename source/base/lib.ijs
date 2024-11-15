NB. lib version

NB. =========================================================
NB. library:
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
  ext=. (('Darwin';'Win') i. <UNAME) pick ;:'dylib dll so'
  libsqlite=: jpath '~addons/data/sqlite/lib/libjsqlite3',((-.IF64)#'_32'),'.',ext
  if. IFWIN*.'arm64'-:9!:56'cpu' do. libsqlite=: jpath '~addons/data/sqlite/lib/libjsqlite3_arm64','.',ext end.
end.
)

NB. =========================================================
NB. required versions:
binreq=: 109 NB. binary
relreq=: 901 NB. J release

NB. =========================================================
checklibrary=: 3 : 0
if. ((<UNAME) e.'Darwin';'Linux';'FreeBSD';'OpenBSD')>IF64+.IFRASPI do.
  sminfo 'Sqlite';'The data/sqlite addon is for J64 only.' return.
end.
if. -. fexist libsqlite do. getbinmsg 0 return. end.
extver=. 100 * 0 ". sqlite_extversion''
if. binreq = extver do. return. end.
if. binreq > extver do. getbinmsg 1 return. end.
sminfo 'Sqlite';'The data/sqlite addon is out of date. Please install the latest version.' return.
)

NB. =========================================================
NB. get sqlite binary
NB. uses routines from pacman
getbin=: 3 : 0
if. ((<UNAME) e.'Darwin';'Linux';'FreeBSD';'OpenBSD')>IF64+.IFRASPI do. return. end.
if. BinInstalled do. cdf'' end.
require 'pacman'
path=. 'http://www.jsoftware.com/download/sqlitebin/',(":relreq),'/'
if. (<UNAME) e. 'FreeBSD';'OpenBSD' do.
  path=. path, (tolower UNAME),(('arm64'-:9!:56'cpu')#'/arm64'),'/'
end.
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
  2!:0 ::0:^:((<UNAME)e.'Linux';'FreeBSD';'OpenBSD') 'chmod 644 ', dquote to
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

NB. =========================================================
getbinmsg=: 3 : 0
run=. 'run the getbin_psqlite_'''' line written to the session.'
if. y do.
  msg=. 'The data/sqlite binary is out of date.'
  msg=. msg,LF2,'To get the latest, ',run
  msg=. msg,LF2,'Afterwards, please restart J.'
else.
  msg=. 'The data/sqlite binary has not yet been installed.',LF2,'To install, ',run
end.
NB.
NB. msg=. y,' run the getbin_psqlite_'''' line written to the session.',LF2
NB. msg=. msg,'If you are updating the binary, You may need to restart J to get the new binary.'
BinInstalled=: y
smoutput '   getbin_psqlite_'''''
sminfo 'Sqlite';msg
)
