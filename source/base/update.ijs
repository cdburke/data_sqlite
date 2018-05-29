NB. update

NB. =========================================================
NB.*sqlupdate v update
NB.-argument is a 4 element list:
NB.-  table name
NB.-  where statement
NB.-  column names
NB.-  column data
NB.-i.e. tablename;where;(col1;col2;...);<dat1;dat2;...
sqlupdate=: 3 : 0
'tab whr nms dat'=. y
if. 0 -: args=. writeargs tab;nms;<dat do. 0 return. end.
'tab nms typ dat'=. args
whr=. ('where ' #~ -.'where ' -: 6 {. whr),whr
set=. }:;nms ,each <'=?,'
sel=. 'update ',tab,' set ',set,' ',whr
execparm sel;nms;typ;<dat
)
