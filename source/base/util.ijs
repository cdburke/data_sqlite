NB. util

NB.*c0 v get column 0 from matrix (same for c1,c2)
0 0$".'p<c>q<=:>,q<&{"1>' 8!:2 ,.~i.3

boxindexof=: i.&>~@[ i.&|: i.&>
boxmember=: i.&>~ e.&|: i.&>~@]

col=: ,.@:>each :($:@([ {.each ]))
commasep=: }.@;@:((',' , ":)each)
intersect=: e. # [
isboxed=: 0 < L.
ischar=: 2=3!:0
isfloat=: 8=3!:0
round=: [ * [: <. 0.5 + %~
samesize=: 1 = #@~.@:(#&>)
strlen=: ;#
termLF=: , (0 < #) # LF -. {:

NB. =========================================================
astable=: 3 : 0
'cls dat'=. y
cls,:col dat
)

NB. =========================================================
connadd=: 3 : 0
empty DBS_psqlite_=: DBS,y
)

NB. =========================================================
conndel=: 3 : 0
ndx=. (;c0 DBS) i. CH
if. ndx<#DBS do.
  DBS_psqlite_=: (<<<ndx) { DBS
end.
EMPTY
)

NB. =========================================================
NB.*cutat v cut and format matrix y at x columns
NB.-Cut and format matrix y at x columns
NB.-Useful for displaying a wide matrix
NB.-example:
NB.+   7 cutat smreads 'Series where InputParm1="123"'
cutat=: 4 : 0
cls=. {:$y
rem=. x|cls
dat=. |: (-x) <\"1 y
}. ; ([:<@:,LF,.":@:>) "1 dat
)

NB. =========================================================
NB.*fixcol v fix columns for write
NB.-fix columns for write
NB.-expects boxed character list or character matrix or numeric list
fixcol=: 3 : 0
if. isboxed y do.
  ,dquote each ": each y
elseif. ischar y do.
  ,dquote each dtb each <"1 y
elseif. do.
  ,8!:0 y
end.
)

NB. =========================================================
NB. fix select, quoting dotted names if necessary
fixselect=: 3 : 0
sel=. fixselect1 y
if. -. '.' e. sel do. return. end.
if. 'pragma' -: 6 {. sel do. return. end.
if. -. '"' e. sel do. return. end.
b=. (sel e. ' ,<>!=') > ~:/\sel='"'
t=. (1,b) <;.1 ' ',sel
m=. I. ('.' e. &> t) > '"' e.&> t
if. -. 1 e. m do. sel return. end.
dq=. {. , '"' , '"' ,~ }.
}. ; (dq each m{t) m} t
)

NB. =========================================================
fixselect1=: 3 : 0
sel=. dltb y
hdr=. tolower 7 {. sel
if. (<hdr) e. 'pragma ';'select ' do. sel return. end.
if. 1 e. ' from ' E. sel do.
  'select ',sel return.
end.
'select * from ',sel
)

NB. =========================================================
fixselectx=: 3 : 0
sel=. fixselect y
cls=. 0 pick splitselect sel
if. -. 1 e. (' rowid,' E. cls) +. ' rowid ' E. cls do.
  'select rowid,',dlb 6 }. sel
end.
)

NB. =========================================================
getlastrows=: 3 : 0
'len tab where'=. y
rws=. sqlexec 'select rowid from ',tab,where
(-len <. #rws) {. rws
)

NB. =========================================================
NB. return boxed lists into a boxed matrix
list2mat=: 3 : 0
|: > (I. 0 = L. &> y) <"0 xeach y
)

NB. =========================================================
NB.*listvalues v format items into a list for where statements
listvalues=: 3 : 0
if. ischar y do.
  y=. dtb each <"1 y
end.
if. isboxed y do.
  r=. commasep '"' ,each y ,each '"'
else.
  r=. '-' (I. r='_')} r=. commasep y
end.
'(',r,')'
)

NB. =========================================================
shellcmd=: 3 : 0
if. IFUNIX do.
  hostcmd_j_ y
else.
  spawn_jtask_ y
end.
)

NB. =========================================================
NB.*splitselect v split select statement
NB.-split select statement into\
NB.-from;table;where;orderby
splitselect=: 3 : 0
n=. 6 + 1 i.~ ' from ' E. y
f=. dlb n{.y
y=. deb n}.y
n=. y i. ' '
t=. n{.y
y=. n }.y
n=. 1 i.~ ' order by ' E. y
w=. n{.y
s=. n}.y
f;t;w;s
)

NB. =========================================================
NB. throw
NB. assigns LastError then calls throw.
NB. if argument is empty, reads the sqlite3 error message
throw=: 3 : 0
if. #y do.
  LastError=: y
else.
  s=. sqlite3_errcode CH
  if. p=. sqlite3_errmsg CH do.
    msg=. memr p, 0 _1
  else.
    msg=. ''
  end.
  LastError=: 'sqlite rc=',(":s),' ',msg
end.
if. Debug do. sminfo LastError end.
throw.
)

NB. =========================================================
NB.*xeach a apply function to indexed items of boxed list
NB.-Apply function to indexed items of boxed list
NB.-syntax:
NB.+  indices myfn xeach data
xeach=: 1 : (':';'(u each x{y) x}y')
