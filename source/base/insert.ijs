NB. insert

NB. =========================================================
NB.*sqlinsert v insert
NB.-argument is a 3 element list:
NB.-  table name
NB.-  column names
NB.-  column data
NB.-i.e. tablename;(col1;col2;...);<dat1;dat2;...
NB.-returns record count inserted
sqlinsert=: 3 : 0
if. 0 -: args=. writeargs y do. 0 return. end.
'tab nms typ dat'=. args
sel=. }. (+:#nms) $ ',?'
sel=. 'insert into ',tab,' ',(listvalues nms),' values(',sel,')'
execparm sel;nms;typ;<dat
)

NB. =========================================================
NB. last rowid of insert
sqllastrowid=: 3 : 0
sqlite3_last_insert_rowid CH
)
