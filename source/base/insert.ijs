NB. insert

NB. =========================================================
NB.*sqlinsert v insert
NB.-argument is a 3 element list:
NB.-  table name
NB.-  column names
NB.-  column data
NB.-i.e. tablename;(col1;col2;...);<dat1;dat2;...
NB.-where column data is one of:
NB.-  numeric list
NB.-  character matrix (list treated as 1-row matrix)
NB.-  boxed character list
NB.-this good for relatively small inserts
sqlinsert=: 3 : 0
'tab nms dat'=. y
if. 0 e. $dat do. 0 return. end.
if. 0 e. $nms do. nms=. sqlcols tab end.
nms=. boxopen nms
if. 1=#nms do.
  if. 2=L. dat do. dat=. 0 pick dat end.
  val=. ,. fixcol dat
else.
  dat=. fixcol each dat
  if. 1 < # ~. # &> dat do.
    throw 'data columns not same size: ',":# &> dat
  end.
  val=. |:> dat
end.
sep=. '(',(<:#nms)#','
val=. ' values ',}: ;,(sep ,each "1 val),.<'),'
cmd=. 'insert into ',tab,' ',listvalues nms
sqlcmd cmd,val
)

NB. =========================================================
NB. last rowid of insert
sqllastrowid=: 3 : 0
sqlite3_last_insert_rowid CH
)
