:: /lib/fund/alien/hoon: foreign/external interface helper functions for %fund
::
/-  cn=contacts, se=settings
/+  ff=fund-form
|_  bol=bowl:gall
::
::  |util: alien utility functions
::
+|  %util
::
::  +live: is given agent installed and running?
::
++  live
  |=  dap=@tas
  ^-  bean
  .^(bean %gu (en-beam [our.bol dap da+now.bol] /[%$]))
::
::  |chain: all %chain-watcher ffis
::
+|  %chain
::
::  +chain-bloq: %chain-watcher path block number
::
++  chain-bloq
  |=  pat=path  ~+
  ^-  @
  =/  pre=path  (en-beam [our.bol %chain-watcher da+now.bol] /)
  ?.  .^(? %gu (snoc pre %$))  0
  =+  .^(pam=(map path *) %gx (welp pre /dogs/configs/noun))
  ?.  (~(has by pam) pat)  0
  .^(@ %gx :(welp pre /block pat /atom))
::
::  |tlon: all %tlon ffis
::
+|  %tlon
::
::  +contacts-rolo: %contacts app "rolodex" data (ship/info map)
::
++  contacts-rolo
  ~+
  ^-  rolodex:cn
  =/  pre=path  (en-beam [our.bol %contacts da+now.bol] /)
  ?.  .^(? %gu (snoc pre %$))  *rolodex:cn
  ::  FIXME: This will break if %contacts data model changes, but the
  ::  code below doesn't work on live ships for some reason
  ::  =+  .^(non=rolodex:cn %gx (weld pre /all/noun))
  ::  (fall ((soft rolodex:cn) non) *rolodex:cn)
  .^(rolodex:cn %gx (weld pre /all/noun))
::
::  +contacts-ship: %contacts app ship data (index into "rolodex")
::
++  contacts-ship
  |=  sip=@p  ~+
  ^-  (unit contact:cn)
  =/  rol=rolodex:cn  contacts-rolo
  ?~  con=(~(get by rol) sip)   ~
  ?@  for.u.con                 ~
  ?@  con.for.u.con             ~
  `con.for.u.con
::
::  +settings-calm: %settings app "calm engine" data (key/value map)
::
++  settings-calm
  ~+
  ^-  bucket:se
  =/  pre=path  (en-beam [our.bol %settings da+now.bol] /)
  ?.  .^(? %gu (snoc pre %$))  *bucket:se
  ?.  .^(? %gx (weld pre /has-bucket/landscape/'calmEngine'/noun))  *bucket:se
  =+  .^(dat=data:se %gx (weld pre /bucket/landscape/'calmEngine'/noun))
  ::  FIXME: This will break if %settings data model changes, but the
  ::  code below doesn't work on live ships for some reason
  ::  =+  .^(non=noun %gx (weld pre /bucket/landscape/'calmEngine'/noun))
  ::  =/  dat=data:se  (fall ((soft data:se) non) [%bucket *bucket:se])
  ?.(?=(%bucket -.dat) *bucket:se bucket.dat)
::
::  +ship-tytl: ship title, derived from %settings and %contacts
::
++  ship-tytl
  |=  sip=@p  ~+
  ^-  tape
  =/  dis=val:se  (~(gut by settings-calm) 'disableNicknames' [%b |])
  =/  def=tape  "{<sip>}"
  ?:  &(?=(%b -.dis) p.dis)    def
  ?~  con=(contacts-ship sip)  def
  ?:  =(%$ nickname.u.con)     def
  (trip nickname.u.con)
::
::  +ship-logo: ship logo (as url), derived from %settings and %contacts
::
++  ship-logo
  |=  sip=@p  ~+
  ^-  tape
  =/  dia=val:se  (~(gut by settings-calm) 'disableAvatars' [%b |])
  =/  dir=val:se  (~(gut by settings-calm) 'disableRemoteContent' [%b |])
  =/  def=tape  (surt:enrl:ff sip)
  ?:  &(?=(%b -.dia) p.dia)    def
  ?:  &(?=(%b -.dir) p.dir)    def
  ?~  con=(contacts-ship sip)  def
  ?~  avatar.u.con             def
  ?:  =(%$ u.avatar.u.con)     def
  (trip u.avatar.u.con)
::
::  |pals: all %pals ffis
::
+|  %pals
::
::  +pals-pals: set of all our pals (targets), derived from %pals
::
++  pals-pals
  ~+
  ^-  (set @p)
  =/  pre=path  (en-beam [our.bol %pals da+now.bol] /)
  ?.  .^(? %gu (snoc pre %$))  *(set @p)
  .^((set @p) %gx (weld pre /targets/noun))
::
::  +ship-pals: ship is pal?, derived from %pals
::
++  ship-pals
  |=  sip=@p  ~+
  ^-  bean
  (~(has in pals-pals) sip)
--
