NB. shell commands
NB.
NB. For example, these enable programmatic use of dot commands

NB. =========================================================
NB.*shell command
NB. cmd = any sequence of sqlite3 shell commands
sqlite3=: 3 : 0
y fwrites tmp=. }:hostcmd_j_ 'mktemp'
if. IFWIN do.
  r=. spawn_jtask_ 'sqlite3.exe "',(winpathsep sqlname''),'" < "',(winpathsep tmp),'"'
else.
  r=. 2!:0 '/usr/bin/sqlite3 "',(sqlname''),'" < "',tmp,'"'
end.
r[ferase tmp
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
