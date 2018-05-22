NB. write

NB. =========================================================
NB.*write v write utility
write=: 3 : 0
'sel nms typ dat'=. y
rws=. #0 pick dat
val=. typ fixwrite each dat
if. (<0) e. val do.
  throw 'invalid data for',;' ' ,each nms #~ (<0)=val return.
end.
'rc sh tail'=. prepare sel
if. rc do. throw '' return. end.
sqlite3_write_values sh;rws;(#typ);typ;(#&>val);;val
sqlite3_finalize <sh
rws
)

NB. =========================================================
NB.*writeargs v write utility to check arguments
NB.-check arguments to insert/update/upsert
NB.-return tab;nms;typ;<dat
NB.-or 0 on fail
writeargs=: 3 : 0
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
tab;typ;nms;<dat
)

NB. =========================================================
NB.*fixwrite v fix data for write
NB. fix data for write
fixwrite=: 4 : 0
if. (x=0) +. 1 < #$y do. 0 return. end.
t=. 3!:0 y
if. x=1 do.
  if. t e. 1 4 do. (2+IF64) (3!:4) y else. 0 end. return.
end.
if. x=2 do.
  if. t e. 1 4 8 do. 2 (3!:5) y else. 0 end. return.
end.
if. t ~: 32 do. 0 return. end.
if. 0 e. 2 = 3!:0 &> y do. 0 return. end.
if. x=3 do. ; y ,each {.a. else. (2 (3!:4) # &> y),;y end.
)
