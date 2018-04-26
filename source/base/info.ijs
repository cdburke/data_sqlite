NB. info

NB. =========================================================
NB.*sqlite_extversion v extension version as '1.01'
sqlite_extversion=: 3 : 0
try.
  ":0.01*sqlite3_extversion''
catch.
  '0.00'
end.
)

NB. =========================================================
NB.*sqlite_info v sqlite info
sqlite_info=: 3 : 0
v=. memr (sqlite3_libversion''),0 _1
s=. memr (sqlite3_sourceid''),0 _1
v;s
)
