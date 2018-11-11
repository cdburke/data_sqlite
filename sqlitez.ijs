load 'data/sqlite'

cocurrent 'z'
dbopen=: 3 : 'empty locDB_z_=: sqlopen_psqlite_ y'
dbcreate=: 3 : 'empty locDB_z_=: sqlcreate_psqlite_ y'
dbreset=: 3 : 'empty locDB_z_=: 0$sqlreset_psqlite_ y'
dbclose=: 3 : 0
try. destroy__locDB 0 catch. end.
empty locDB_z_=: ''
)
dbnextseq=: 3 : 0
1 + {.dbexec'seq from sqlite_sequence where name="',y,'"'
)
dbstate=: 3 : 0
(,': ',":@dbsize) &> (y-:1) pick (dbtables'');<dbviews''
)
f=. 3 : 0
'db',y,'_z_=:3 : ''sql',y,'__locDB y''',LF
)

0!:100 ; f each cutopen 0 : 0
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
f=. 3 : 0
'db',y,'_z_=:3 : (''sql',y,'__locDB y'';'':'';''x sql',y,'__locDB y'')',LF
)

0!:100 ; f each cutopen 0 : 0
ends
endsx
head
headx
rand
randx
tail
tailx
)
a=. 'SQLITE_'&, each ;:'INTEGER FLOAT TEXT BLOB'
". &> a ,each '_z_=: '&, each a ,each <'_psqlite_'
cocurrent 'base'
