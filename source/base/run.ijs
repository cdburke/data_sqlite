
load 'data/sqlite'

Note''
smoutput 'extension version: ',sqlite_extversion_psqlite_''
db=: sqlopen_psqlite_ '~addons/data/sqlite/db/sandp.db'
smoutput sqlreads__db 'p'
)
