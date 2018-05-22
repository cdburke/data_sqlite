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
'tab nms dat'=. y
nms=. ,each boxxopen nms
cls=. #nms
if. 0=cls do. 0 return. end.

if. 0 e. $dat do. 0 return. end.
dat=. boxxopen dat
ndx=. I. 2=3!:0 &> dat
dat=. (<each ndx{dat) ndx} dat

rws=. {. len=. # &> dat
if. 0=rws do. 0 return. end.
if. 0 e. rws = len do.
  throw 'column data not of same length: ',":len return.
end.

'names types'=. sqlcolinfo tab
if. 0 e. nms e. names do.
  throw 'column not found:',; ' ' ,each nms -. names return.
end.
typ=. (names i. nms) { types

sel=. }. (+:cls) $ ',?'
sqlcmd 'begin;'
sel=. 'insert into ',tab,' ',(listvalues nms),' values(',sel,')'
r=. write sel;nms;typ;<dat
sqlcmd 'commit;'
r
)

NB. =========================================================
NB. last rowid of insert
sqllastrowid=: 3 : 0
sqlite3_last_insert_rowid CH
)
