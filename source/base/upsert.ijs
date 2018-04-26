NB. upsert

NB. =========================================================
NB.*sqlupsert v upsert
NB.-updates any existing records on keys, and inserts any new records.
NB.-ignores any records that are the same as before
NB.-argument is a 4 element list:
NB.-  table name
NB.-  key names
NB.-  data column names (must include keys names)
NB.-  data columns
NB.-i.e. tablename;(key1;key2;...);(col1;col2;...);<dat1;dat2;...
NB.-where column data is the same as sqlinsert
sqlupsert=: 3 : 0
'tab keys cols dat'=. y
keys=. boxopen keys
cols=. boxopen cols

if. 0 e. $dat do. 0 return. end.
if. 0=#keys do. throw 'upsert keys names not given' return. end.
if. #keys -. cols do. throw 'upsert keys names not in column names' return. end.
if. 1=#cols do.
  if. ischar dat do.
    dat=. <dtb each <"1 dat
  else.
    dat=. boxopen dat
  end.
end.

sel=. ''
for_key. keys do.
  ndx=. cols i. key
  sel=. sel,' AND ',(>key),' in ',listvalues ~.ndx pick dat
end.
old=. sqlexec ('rowid,',commasep keys),' from ',tab,' where ',5 }.sel
row=. 0 pick old
if. 0=#row do. sqlinsert 0 2 3{y return. end.

old=. }.old
new=. (cols i. keys) { dat
ind=. old boxindexof new

msk=. ind=#row
if. 1 e. msk do.
  sqlinsert tab;cols;<msk&# each dat
  if. -. 0 e. msk do. return. end.
  ind=. (-.msk)#ind
  dat=. (-.msk)&# each dat
end.
row=. ind{row

old=. sqlexec 'rowid,',(commasep cols),' from ',tab,' where rowid in ',listvalues row
msk=. -. dat boxmember }.old
if. -. 1 e. msk do. 0 return. end.

row=. msk#row
dat=. msk&# each dat
dat=. |: fixcol &> dat

cmd=. <@}.@;"1 (',' ,each cols ,each '=') ,each "1 dat
cmd=. ('update ',tab,' set ')&, each cmd
cmd=. ;cmd ,each (' where rowid=', ';',~ ":) each row
sqlcmd 'begin;',cmd,'commit;'
)
