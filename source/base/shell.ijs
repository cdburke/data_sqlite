NB. shell commands
NB.
NB. For example, these enable programmatic use of dot commands
NB. db = database filename
NB. cmd = any sequence of sqlite3 shell commands

NB. =========================================================
NB.*shell commands
sqlite3do=: 3 : 0
'db cmd'=. y
db=. jpath db
cmd=. a: -.~ <;._2 cmd,LF
ndx=. I. '.' ~: {. &> cmd
f=. , ';' -. {:
cmd=. (f each ndx{cmd) ndx} cmd
cmd=. ; cmd ,each LF
cmd fwrites tmp=. jpath '~temp/sqlite3shell.cmd'
if. IFWIN do.
  r=. spawn_jtask_ 'sqlite3.exe "',(winpathsep db),'" < "',(winpathsep tmp),'"'
else.
  r=. 2!:0 '/usr/bin/sqlite3 "',db,'" < "',tmp,'"'
end.
r[ferase tmp
)

NB. =========================================================
sqlite3=: 3 : 0
sqlite3do (sqlname'');y
)

NB. =========================================================
NB.*import csv file v import csv file
NB.-import csv file
NB.-
NB.-syntax:
NB.+   sqlimportcsv table;def;sep;csvfile
NB.-where:
NB.-  table      - table name
NB.-  def        - create table definition, or empty if exists
NB.-  sep        - separator, e.g. ,  or \t
NB.-  csvfile    - csv file name
NB.-example:
NB.+  def=. 'create table test (id text,name text,weight int,city text);'
NB.+  csv=. jpath '~temp/data.csv'
NB.+  sqlimportcsv__db 'test';def;',';csv
sqlimportcsv=: 3 : 0
'table def sep csvfile'=. y
cmd=. (termLF def),'.separator "',sep,'"',LF,'.import "',csvfile,'" ',table
sqlite3 cmd
)
