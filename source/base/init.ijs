NB. init

coclass 'psqlite'

NB. =========================================================
CH=: i.0
DBS=: i.0 3  NB. handle;file;loc
Debug=: 0
LastError=: ''
Timeout=: 60000

NB. =========================================================
NB. create v
NB. argument is filename [;options]
NB. where options include: create
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
if. SQLITE_OK ~: >@{. cdrc=. sqlite3_open_v2 file;handle;flags;<<0 do.
  throw 'unable to open database' return.
end.
CH=: {.handle=. 2{::cdrc
sqlite3_extended_result_codes CH, 1
sqlite3_busy_timeout CH, Timeout
connadd CH;file;coname''
)

NB. =========================================================
destroy=: 3 : 0
sqlite3_close CH
conndel CH
codestroy''
)
