
load 'data/sqlite'

Note''
smoutput 'extension version: ',sqlite_extversion_psqlite_''
db=: sqlopen_psqlite_ '~addons/data/sqlite/db/sandp.db'
smoutput sqlreads__db 'p'
db=: sqlopen_psqlite_ '~addons/data/sqlite/db/chinook.db'
smoutput sqltables__db ''
smoutput sqltail__db 'tracks'
)
