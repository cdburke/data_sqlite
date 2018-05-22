NB. build sandp database

load 'data/sqlite'

NB. =========================================================
NB. build sandp database, returning locale
NB. argument is file name, default ~temp/sandp.db
buildsandp=: 3 : 0

NB. create database:
db=. sqlcreate_psqlite_ y,(0=#y)#'~temp/sandp.db'

NB. create tables:
sqlcmd__db 'create table s (sid text primary key, name text, status int, city text)'
sqlcmd__db 'create table p (pid text primary key, name text, color text, weight int, city text)'
cmd=. 'create table sp (sid text, pid text, qty int, '
sqlcmd__db cmd,'foreign key(sid) references s(sid), foreign key(pid) references p(pid))'

NB. populate tables:
cls=. ;:'sid name status city'
dat=. (('s',":)each 1+i.5);(;:'smith jones blake clark adams');20 10 30 20 30
dat=. dat,<0 1 1 0 2{;:'london paris athens'
sqlinsert__db 's';cls;<dat

cls=. ;:'pid name color weight city'
dat=. (('p',":)each 1+i.6);(;:'nut bolt screw screw cam cog');<0 1 2 0 2 0{;:'red green blue'
dat=. dat,12 17 17 14 12 19;<0 1 2 0 1 0{;:'london paris rome'
sqlinsert__db 'p';cls;<dat

cls=. ;:'sid pid qty'
dat=. (('s',":) each 1 1 1 1 4 1 2 2 3 4 4 4);<('p',":) each 1 2 3 4 5 6 1 2 2 2 4 5
dat=. dat,<300 200 400 200 100 100 300 400 200 200 300 400
sqlinsert__db 'sp';cls;<dat

db
)
