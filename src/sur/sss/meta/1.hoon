/-  *fund-meta
/-  mold=sss-meta-0
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
    %-  ~(uni by mine)
    ^-  mytz
    %-  ~(rep by read:subs)
    |=  [[k=[ship dude:gall p=path] v=[s=? f=? vers m=meta]] a=mytz]
    (~(put by a) (flag p.k) m.v &(!s.v !f.v))
  --

+|  %core
+$  vers  [_%1 _%1]
+$  path  [%fund %meta sip=@ nam=@ ~]
++  lake
  =/  up
    |_  met=meta:mold
    ++  meta
      ^-  ^meta
      :*  title=title.met
          image=image.met
          cost=cost.met
          payment=[%coin currency.met]
          launch=launch.met
          worker=worker.met
          oracle=oracle.met
      ==
    --
  |%
  ++  name  %meta
  +$  rock  [vers meta]
  +$  vock  $%(vock:lake:mold rock)
  +$  wave  [vers bol=bowl:gall pok=poke]
  +$  vave  $%(vave:lake:mold wave)
  ++  urck
    |=  voc=vock
    ^-  rock
    ?-  -.voc
      vers        voc
      vers:mold   $(voc [*vers ~(meta up +.voc)])
    ==
  ++  uwve
    |=  vav=vave
    ^-  wave
    ?-  -.vav
      vers        vav
    ::
        vers:mold
      =-  $(vav [*vers -])
      ?+    +.vav      +.vav
        [* * %init *]  [bol.vav p.pok.vav %init ~(meta up met.q.pok.vav)]
      ==
    ==
  ++  wash
    |=  [[vers met=meta] [vers bol=bowl:gall lag=^flag pod=prod]]
    ^-  rock
    :-  *vers
    ?+    -.pod  met
        %init
      met.pod
    ==
  --
--
