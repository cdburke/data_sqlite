NB. read

NB. =========================================================
NB. read as pair: column names ; column data
NB. with column data in lists
sqlread=: 3 : 0
sel=. fixselect y
readvalues sqlite3_read_values CH;sel;,2
)

NB. =========================================================
readvalues=: 3 : 0
'rc res'=. 0 3 { y
if. rc ~: SQLITE_DONE do. throw'' return. end.
SZI=. IF64{4 8
'buf typ nms len rws cls'=. memr res, 0 6 4
colnames=. <;._2 memr nms,0,len
pointers=. memr buf,0,cls,4
types=. memr typ,0,cls,4
data=. ''
NB. types: 1 int 2 float 3 text 4 blob
for_p. pointers do.
  select. p_index{types
  case. 1 do.
    val=. memr p,0,rws,4
  case. 2 do.
    val=. memr p,0,rws,8
  case. 3 do.
    len=. memr p, 0 1 4
    val=. <;._2 memr p,SZI,len-SZI
  case. 4 do.
    cnt=. memr p,SZI,rws,4
    pos=. SZI * rws+1
    dat=. memr p,pos,+/cnt
    if. 0=#dat do.
      val=. (#cnt)#<''
    else.
      if. 0 e. cnt do.
        msk=. 1 (0,+/\}:cnt-.0)} (#dat)$0
        val=. (cnt>0) #^:_1 msk <;.1 dat
      else.
        msk=. 1 (0,+/\}:cnt)} (#dat)$0
        val=. msk <;.1 dat
      end.
    end.
  end.
  data=. data,<val
end.
sqlite3_free_values <res
colnames;<data
)

NB. =========================================================
sqlreadx=: 3 : 'sqlread fixselectx y'
sqlreads=: astable @ sqlread
sqlreadsx=: astable @ sqlreadx

NB. =========================================================
sqldict=: 3 : 0
'cls dat'=. sqlread y
if. 1 = #>{.dat do.
  dat=. 0 pick each dat
end.
cls,.dat
)

NB. =========================================================
sqlendsx=: 3 : 0
5 sqlendsx y
:
'cls dat'=. <"1 x sqlheadx y
ext=. 1{x sqltailx y
msk=. -. (0 pick ext) e. 0 pick dat
cls,:dat ,each msk&# each ext
)

sqlends=: }."1 @: sqlendsx

NB. =========================================================
sqlexec=: 3 : 0
r=. 1 pick sqlread y
if. 1=#r do.
  0 pick r
end.
)

NB. =========================================================
sqlexecx=: 3 : 0
r=. 1 pick sqlreadx y
if. 1=#r do.
  0 pick r
end.
)

NB. =========================================================
sqlhead=: 3 : 0
10 sqlhead y
:
if. x<0 do.
  (|x) sqltail y
else.
  sqlreads y,(x>0)#' limit ',":x
end.
)

NB. =========================================================
sqlheadx=: 3 : 0
10 sqlheadx y
:
if. x<0 do.
  (|x) sqltailx y
else.
  sqlreadsx y,(x>0)#' limit ',":x
end.
)

NB. =========================================================
NB.*sqlkeysum v sqlread with sum on key columns
sqlkeysum=: 3 : 0
'tab key sum'=. y
key=. commasep boxxopen key
sum=. commasep (<'sum(') ,each (boxxopen sum) ,each ')'
sqlread 'select ',key,',',sum,' from ',tab,' group by ',key, ' order by ',key
)

NB. =========================================================
sqlrand=: 3 : 0
10 sqlrand y
:
id=. dbexec 'rowid from ',y
if. x<#id do.
  id=. sort id {~ x ? #id
end.
sqlreads y,' where rowid in ',listvalues id
)

NB. =========================================================
sqlrandx=: 3 : 0
10 sqlrandx y
:
id=. dbexec 'rowid from ',y
if. x<#id do.
  id=. sort id {~ x ? #id
end.
sqlreadsx y,' where rowid in ',listvalues id
)

NB. =========================================================
sqlreadm=: 3 : 0
'cls dat'=. sqlread y
cls;<list2mat dat
)

NB. =========================================================
NB.*sqltail v read tail of file
sqltail=: 3 : 0
10 sqltail y
:
if. x-:0 do. sqlreads y return. end.
'frm tab whr ord'=. splitselect fixselect y
sqlreads frm,tab,' where rowid in ',listvalues getlastrows x;tab;whr
)

NB. =========================================================
NB.*sqltailx v read tail of file
sqltailx=: 3 : 0
10 sqltailx y
:
if. x-:0 do. sqlreadx y return. end.
'frm tab whr ord'=. splitselect fixselect y
sqlreadsx frm,tab,' where rowid in ',listvalues getlastrows x;tab;whr
)
