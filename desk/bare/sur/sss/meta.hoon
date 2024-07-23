/-  *fund-meta
/+  sss
|%
+|  %misc
++  flag
  |=  pat=path
  ^-  ^flag
  [`@p`(slav %p sip.pat) `@tas`(slav %tas nam.pat)]
++  conn
  |_  [bol=bowl:gall suz=_(mk-subs:sss lake path) puz=_(mk-pubs:sss lake path)]
  ++  subs                                     ::  $meta subscriptions
    =/  da  (da:sss lake path)
    (da suz bol -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
  ++  pubs                                     ::  $meta publications
    =/  du  (du:sss lake path)
    (du puz bol -:!>(*result:du))
  ++  mine                                     ::  local data only
    ^-  mytz
    %-  ~(rep by read:pubs)
    |=  [[k=path v=[(unit (set ship)) vers m=meta]] a=mytz]
    (~(put by a) (flag k) m.v &)
  ++  ours                                     ::  local and remote data
    ^-  mytz
    *mytz
    ::  %-  ~(uni by mine)
    ::  %-  ~(rep by read:subs)
    ::  |=  [[k=[ship dude:gall p=path] v=[s=? f=? vers m=meta]] a=mytz]
    ::  (~(put by a) (flag p.k) m.v &(!s.v !f.v))
  --

+|  %core
+$  vers  _%0
+$  path  [%fund %meta sip=@ nam=@ ~]
++  lake
  |%
  ++  name  %meta
  +$  rock  [vers meta]
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
    |=  [[vers met=meta] [vers bol=bowl:gall lag=^flag pod=prod]]
    ^-  rock
    :-  *vers
    ?+    -.pod  met
        %init
      ?~  met.pod  met
      u.met.pod
    ==
  --
--
