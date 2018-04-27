NB. build

S=: jpath '~Addons/data/sqlite/source/'
PA=: jpath '~Addons/data/sqlite/'
Pa=: jpath '~addons/data/sqlite/'

mkdir_j_ Pa,'db'
mkdir_j_ Pa,'lib'

dat=. readsourcex_jp_ S,'base'
dat=. dat,'checklibrary$0',LF
dat=. dat,'cocurrent ''base''',LF
dat fwritenew PA,'sqlite.ijs'

dat=. readsourcex_jp_ S,'zfns'
dat fwritenew PA,'sqlitez.ijs'

(PA,'sandp.ijs') fcopynew S,'base/sandp.ijs'

NB. =========================================================
f=. 3 : '(Pa,y) fcopynew PA,y'

f each cutopen 0 : 0
sandp.ijs
sqlite.ijs
sqlitez.ijs
db/chinook.db
db/sandp.db
lib/readme.txt
)
