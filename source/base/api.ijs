NB. api

NB. CAPI3REF: Result Codes
SQLITE_OK=: 0            NB. Successful result
SQLITE_DONE=: 101        NB. sqlite3_step() has finished executing

NB. CAPI3REF: Flags For File Open Operations
SQLITE_OPEN_READONLY=: 16b00000001
SQLITE_OPEN_READWRITE=: 16b00000002
SQLITE_OPEN_CREATE=: 16b00000004
SQLITE_OPEN_NOMUTEX=: 16b00008000
SQLITE_OPEN_FULLMUTEX=: 16b00010000
SQLITE_OPEN_SHAREDCACHE=: 16b00020000
SQLITE_OPEN_PRIVATECACHE=: 16b00040000
SQLITE_OPEN_WAL=: 16b00080000

NB. =========================================================
NB. standard sqlite:
lib=. '"',libsqlite,'"'
sqlite3_busy_timeout=: (lib, ' sqlite3_busy_timeout > ',(IFWIN#'+'),' i x i' ) &cd
sqlite3_close=: (lib, ' sqlite3_close > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_errcode=: (lib, ' sqlite3_errcode > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_errmsg=: (lib, ' sqlite3_errmsg > ',(IFWIN#'+'),' x x' ) &cd
sqlite3_exec=: (lib, ' sqlite3_exec > ',(IFWIN#'+'),' i x *c x x *x' ) &cd
sqlite3_extended_result_codes=: (lib, ' sqlite3_extended_result_codes > ',(IFWIN#'+'),' i x i' ) &cd
sqlite3_free=: (lib, ' sqlite3_free > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_last_insert_rowid=: (lib, ' sqlite3_last_insert_rowid > ',(IFWIN#'+'),' i x' ) &cd
sqlite3_libversion=: (lib, ' sqlite3_libversion > ',(IFWIN#'+'),' x' ) &cd
sqlite3_sourceid=: (lib, ' sqlite3_sourceid > ',(IFWIN#'+'),' x' ) &cd

NB. =========================================================
NB. sqlite extensions:
sqlite3_extopen=: (lib, ' sqlite3_extopen ',(IFWIN#'+'),' i *c *x i x d *c *c' ) &cd
sqlite3_extversion=: (lib, ' sqlite3_extversion > ',(IFWIN#'+'),' x') &cd
sqlite3_exec_values=: (lib, ' sqlite3_exec_values > ',(IFWIN#'+'),' i x *c i i *i *i *c') &cd
sqlite3_free_values=: (lib, ' sqlite3_free_values > ',(IFWIN#'+'),' i *') &cd
sqlite3_read_values=: (lib, ' sqlite3_read_values ',(IFWIN#'+'),' i x *c *') &cd
sqlite3_select_values=: (lib, ' sqlite3_select_values ',(IFWIN#'+'),' i x *c * i *i *i *c') &cd
