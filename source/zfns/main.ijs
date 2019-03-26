NB. sqlite zfns

load 'data/sqlite'

cocurrent 'z'

NB. =========================================================
NB. project database functions.
NB. these use global locDB, and are named
NB. dbxxx for sqlxxx
dbopen=: 3 : 'empty locDB_z_=: sqlopen_psqlite_ y'
dbcreate=: 3 : 'empty locDB_z_=: sqlcreate_psqlite_ y'
dbreset=: 3 : 'empty locDB_z_=: 0$sqlreset_psqlite_ y'

NB. =========================================================
dbclose=: 3 : 0
try. destroy__locDB 0 catch. end.
empty locDB_z_=: ''
)

NB. =========================================================
dbnextseq=: 3 : 0
1 + {.dbexec'seq from sqlite_sequence where name="',y,'"'
)

NB. =========================================================
dbstate=: 3 : 0
(,': ',":@dbsize) &> (y-:1) pick (dbtables'');<dbviews''
)

NB. =========================================================
NB. other db cover functions
NB. monadic:
sql3fns=. 3 : 0
'db',y,'_z_=:3 : ''sql',y,'__locDB y''',LF
)

0!:100 ; sql3fns each cutopen 0 : 0
cmd
cols
debug
dict
error
exec
execx
exist
fkey
importcsv
index
insert
keysum
lastrowid
meta
name
read
readm
readx
reads
readsx
schema
size
tables
update
upsert
views
)

NB. ---------------------------------------------------------
NB. dyadic:
sql3fns=. 3 : 0
'db',y,'_z_=:3 : (''sql',y,'__locDB y'';'':'';''x sql',y,'__locDB y'')',LF
)

0!:100 ; sql3fns each cutopen 0 : 0
ends
endsx
head
headx
rand
randx
tail
tailx
)

NB. ---------------------------------------------------------
NB. nouns
sql3nouns=. 'SQLITE_'&, each ;:'INTEGER FLOAT TEXT BLOB'
". &> sql3nouns ,each '_z_=: '&, each sql3nouns ,each <'_psqlite_'

NB. =========================================================
cocurrent 'base'
