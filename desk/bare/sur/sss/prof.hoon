/+  *fund-prof
/+  sss
|%
+|  %misc
++  flag
  |=  pat=path
  ^-  @p
  `@p`(slav %p sip.pat)
++  conn
  |_  [bol=bowl:gall suz=_(mk-subs:sss lake path) puz=_(mk-pubs:sss lake path)]
  ++  subs                                     ::  $prof subscriptions
    =/  da  (da:sss lake path)
    (da suz bol -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
  ++  pubs                                     ::  $prof publications
    =/  du  (du:sss lake path)
    (du puz bol -:!>(*result:du))
  ++  mine                                     ::  local data only
    ^-  prez
    %-  ~(rep by read:pubs)
    |=  [[k=path v=[(unit (set ship)) vers p=prof]] a=prez]
    (~(put by a) (flag k) p.v &)
  ++  ours                                     ::  local and remote data
    ^-  prez
    %-  ~(uni by mine)
    ^-  prez
    %-  ~(rep by read:subs)
    |=  [[k=[ship dude:gall p=path] v=[s=? f=? vers p=prof]] a=prez]
    (~(put by a) (flag p.k) p.v &(!s.v !f.v))
  --

+|  %core
+$  vers  _%0
+$  path  [%fund %prof sip=@ ~]
++  lake
  |%
  ++  name  %prof
  +$  rock  [vers prof]
  +$  vock  rock
  +$  wave  [vers bol=bowl:gall pok=poke]
  +$  vave  wave
  ++  urck
    |=  voc=vock
    ^-  rock
    voc
  ++  uwve
    |=  vav=vave
    ^-  wave
    vav
  ++  wash
    |=  [[vers pro=prof] [vers bol=bowl:gall sip=@p pod=prod]]
    ^-  rock
    :-  *vers
    ?+    -.pod  pro
      %surl  %_(pro ship-url url.pod)
      %fave  %_(pro favorites (~(put in favorites.pro) lag.pod))
      %jilt  %_(pro favorites (~(del in favorites.pro) lag.pod))
    ::
        %sign
      ?>  (csig:pf sip sig.pod)
      %_(pro wallets (~(put by wallets.pro) from.sig.pod sig.pod))
    ==
  --
--
