
load 'data/sqlite'
sqlite_extversion_psqlite_''
sqlite_info_psqlite_''

NB. =========================================================
Note''
db=: sqlopen_psqlite_ '~addons/data/sqlite/db/sandp.db'
smoutput sqlreads__db 'p'
db=: sqlopen_psqlite_ '~addons/data/sqlite/db/chinook.db'
smoutput sqltables__db ''
smoutput sqltail__db 'tracks'
)

NB. =========================================================
NB. pragma examples
Note''
load 'data/sqlite/sqlitez'
dbopen '~addons/data/sqlite/db/sandp.db'
dbmeta 'p'
dbindex 'p'
dbmeta 'sp'
dbfkey 'sp'
)
