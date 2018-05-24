NB. init

coclass 'psqlite'

NB. =========================================================
CH=: i.0
DBS=: i.0 3  NB. handle;file;loc
Debug=: 0
LastError=: ''
Timeout=: 60000

NB. datatypes for parameterized commands:
SQLITE_INTEGER=: 1
SQLITE_FLOAT=: 2
SQLITE_TEXT=: 3
SQLITE_BLOB=: 4

NB. default nulls for read/write (text same as blob):
SQLITE_NULL_INTEGER=: <.-2^<:32*1+IF64
SQLITE_NULL_FLOAT=: __
SQLITE_NULL_TEXT=: 'NULL'

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
nul=. SQLITE_NULL_INTEGER;SQLITE_NULL_FLOAT;SQLITE_NULL_TEXT
if. SQLITE_OK ~: >@{. cdrc=. sqlite3_extopen file;handle;flags;nul,<<0 do.
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
