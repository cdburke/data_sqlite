NB. parm

NB. =========================================================
NB.*sqlparm v execute sql parameterized sql script
sqlparm=: 3 : 0
'sel typ dat'=. y
nms=. ('item',":) each i.#typ
'nms dat'=. parmargs nms;<dat
execparm sel;nms;typ;<dat
)

NB. =========================================================
NB.*execparm v execute parameterized query
execparm=: 3 : 0
'sel nms typ dat'=. y
rws=. #0 pick dat
val=. typ fixparm each dat
if. (<0) e. val do.
  throw 'invalid data for',;' ' ,each nms #~ (<0)=val return.
end.
'rc sh tail'=. prepare sel
if. rc do. throw '' return. end.
sqlite3_exec_values sh;rws;(#typ);typ;(#&>val);;val
sqlite3_finalize <sh
rws
)

NB. =========================================================
NB.*fixparm v fix data for parm exec
NB. fix data for write
fixparm=: 4 : 0
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

NB. =========================================================
NB.*parmargs v utility to check parameterized query arguments
NB.-check arguments to parameterized query
NB.-return nms;<dat
NB.-or 0 on fail
parmargs=: 3 : 0
'nms dat'=. y

nms=. ,each boxxopen nms
if. 0=#nms do. 0 return. end.

if. 0 e. $dat do. 0 return. end.
dat=. boxxopen dat
ndx=. I. 2=3!:0 &> dat
dat=. (<each ndx{dat) ndx} dat

rws=. {. len=. # &> dat
if. 0=rws do. 0 return. end.
if. 0 e. rws = len do.
  throw 'column data not of same length: ',":len return.
end.

nms;<dat
)

NB. =========================================================
NB.*parmargs v utility to check write query arguments
NB.-return tab;nms;typ;<dat
NB.-or 0 on fail
writeargs=: 3 : 0
'tab nms dat'=. y

if. 0=args=. parmargs nms;<dat do. 0 return. end.
'nms dat'=. args

'names types'=. sqlcolinfo tab
if. 0 e. nms e. names do.
  throw 'column not found:',; ' ' ,each nms -. names return.
end.
typ=. (names i. nms) { types

tab;nms;typ;<dat
)