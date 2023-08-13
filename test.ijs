NB. some tests from wiki pages https://code.jsoftware.com/wiki/Addons/data/sqlite

load 'data/sqlite'
sqlite_info_psqlite_''

db=: sqlopen_psqlite_ '~addons/data/sqlite/db/sandp.db'

sqltables__db''

sqlmeta__db 's'

sqlread__db 'select * from s'
sqlreads__db 'select * from s'
sqlreads__db 's'
sqlreads__db 's where status=30 order by city'
sqlreads__db 'sid,sum(qty),max(qty) from sp group by sid'

db=: sqlcopy_psqlite_ '~addons/data/sqlite/db/sandp.db';'~temp/sandp.db'
cls=: ;:'sid name status city'
dat=: ('s6';'s7');('brown';'eaton');40 10;<'rome';'madrid'
sqlinsert__db 's';cls;<dat
5 sqltail__db 's'         NB. last 5 records
sqlupdate__db 'p';'weight=12';('name';'city');<'hammer';'vienna'
sqlhead__db 'p where weight=12'
sqlupdate__db 'p';'weight=12';(,<'name');<,<'hammer'

dat=: ('s5';'s8');('adams';'scott');50 60;<'lisbon';'berlin'
sqlupsert__db 's';'sid';cls;<dat
5 sqltail__db 's'
