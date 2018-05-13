NB. upsert

NB. =========================================================
NB.*sqlupsert v upsert
NB.-updates any existing records on keys, and inserts any new records.
NB.-ignores any records that are the same as before
NB.-argument is a 4 element list:
NB.-  table name
NB.-  key names
NB.-  data column names (must include key names)
NB.-  data columns
NB.-i.e. tablename;(key1;key2;...);(col1;col2;...);<dat1;dat2;...
NB.-where column data is the same as sqlinsert
sqlupsert=: 3 : 0
'tab keys nms dat'=. y
keys=. boxxopen keys
nms=. ,each boxxopen nms
if. 0=#keys do. throw 'upsert keys names not given' return. end.
if. #keys -. nms do. throw 'upsert keys names not in column names' return. end.

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

sel=. ''
for_key. keys do.
  ndx=. nms i. key
  sel=. sel,' AND ',(>key),' in ',listvalues ~.ndx pick dat
end.
old=. sqlexec ('rowid,',commasep keys),' from ',tab,' where ',5 }.sel
row=. 0 pick old
if. 0=#row do. sqlinsert 0 2 3{y return. end.

old=. }.old
new=. (nms i. keys) { dat
ind=. old boxindexof new

msk=. ind=#row
if. 1 e. msk do.
  sqlinsert tab;nms;<msk&# each dat
  if. -. 0 e. msk do. return. end.
  ind=. (-.msk)#ind
  dat=. (-.msk)&# each dat
end.
row=. ind{row

old=. sqlexec 'rowid,',(commasep nms),' from ',tab,' where rowid in ',listvalues row
msk=. -. dat boxmember }.old
if. -. 1 e. msk do. 0 return. end.

row=. msk#row
dat=. msk&# each dat
cls=. #nms

cmd=. 'update ',tab,' set ', (}: ; nms ,each <'=?,'),' where rowid='
sqlcmd 'begin;'
for_r. row do.
  write (cmd,":r);nms;typ;<r_index {each dat
end.
sqlcmd 'commit;'
#row
)
