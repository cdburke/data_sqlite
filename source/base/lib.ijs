NB. lib version

NB. =========================================================
NB. library:
3 : 0''
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  libsqlite=: (jpath'~bin/../libexec/android-libs/',arch,'/libjsqlite3.so')
else.
  ext=. (('Darwin';'Linux') i. <UNAME) pick ;:'dylib so dll'
  libsqlite=: jpath '~addons/data/sqlite/lib/libjsqlite3',((-.IF64)#'_32'),'.',ext
end.
)

NB. =========================================================
NB. minimum required binary version:
libreq=: '1.04'

NB. =========================================================
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

NB. =========================================================
NB. get sqlite binary
NB. uses routines from pacman
getbin=: 3 : 0
if. ((<UNAME) e.'Darwin';'Linux')>IF64+.IFRASPI do. return. end.
require 'pacman'
path=. 'http://www.jsoftware.com/download/sqlitebin/',(":100 * 0 ". libreq),'/'
arg=. HTTPCMD_jpacman_
tm=. TIMEOUT_jpacman_
dq=. dquote_jpacman_ f.
to=. libsqlite_psqlite_
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
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
