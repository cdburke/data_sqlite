NB. meta

NB. =========================================================
sqlclose=: destroy
sqldebug=: 3 : 'Debug=: y'
sqlerror=: 3 : 'LastError'

NB. =========================================================
NB.*sqlcmd v execute sql script
NB. runs semicolon-separated SQL statements
sqlcmd=: 3 : 0
rc=. sqlite3_exec CH;y;0;0;,0
if. rc do. throw '' end.
)

NB. =========================================================
NB.*sqlcols v column names
sqlcols=: 3 : 0
1 pick sqlexec 'pragma table_info(',y,')'
)

NB. =========================================================
NB. copy a database, and open the copy
sqlcopy=: 3 : 0
'from to'=. fboxname each y
if. _1 -: (fread from) fwrite to do.
  throw 'unable to copy database' return.
end.
sqlopen to
)

NB. =========================================================
NB. create, overwriting any existing database
sqlcreate=: 3 : 0
db=. fboxname y
ndx=. (1{"1 DBS) i. db
if. ndx < #DBS do.
  loc=. ndx{2{"1 DBS
  sqlclose__loc''
end.
'' fwrite db
(db;'create') conew 'psqlite'
)

NB. =========================================================
sqlexist=: 3 : 0
sqlexec 'select count(*) from sqlite_master where type="table" and name="',y,'"'
)

NB. =========================================================
sqlmeta=: 3 : 0
sqlreads 'pragma table_info(',y,')'
)

NB. =========================================================
sqlname=: 3 : 0
((;c0 DBS) i. CH) pick c1 DBS
)

NB. =========================================================
sqlopen=: 3 : 0
ndx=. (c1 DBS) i. fboxname y
if. ndx < #DBS do.
  ndx{c2 DBS return.
end.
y conew 'psqlite'
)

NB. =========================================================
sqlreset=: 3 : 0
for_loc. (2{"1 DBS) intersect conl 1 do.
  sqlclose__loc''
end.
EMPTY
)

NB. =========================================================
sqlschema=: 3 : 0
cmd=. 'select sql from main.sqlite_master where name="',y,'" and type in ("table","view")'
0 pick sqlexec cmd
)

NB. =========================================================
sqlsize=: 3 : 0
{. sqlexec 'select count(*) from ',y
)

NB. =========================================================
NB. y is '' or a string to match names
sqltables=: 3 : 0
r=. sqlexec 'name from main.sqlite_master where type="table"'
r=. r #~ (<'sqlite_') ~: 7 {.each r
sort r #~ (1 e. y E. ]) &> r
)

NB. =========================================================
NB. y is '' or a string to match names
sqlviews=: 3 : 0
r=. sort sqlexec 'name from main.sqlite_master where type="view"'
r #~ (1 e. y E. ]) &> r
)
