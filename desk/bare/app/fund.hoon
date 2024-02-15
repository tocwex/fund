/+  f=fund, *sss
/+  default-agent, rudder
/+  dbug, tonic  ::  debug-only
/~  base-pagz  (page:rudder dat-now:f act-now:f)  /app/fund
/~  aset-pagz  (page:rudder dat-now:f act-now:f)  /app/fund/assets
|%
+$  card  card:agent:gall
+$  state-now  [%0 dat-now:f]
+$  page  (page:rudder dat-now:f act-now:f)
+$  pagz  (map knot page)
++  my-pagz  ::  map of pages keyed by full web path
  ~+
  =/  paz=(list [page-map=pagz path-prefix=tape])
    :~  [base-pagz ""]
        [aset-pagz "assets/"]
    ==
  %+  roll  paz
  |=  [[nex=pagz pre=tape] fin=pagz]
  %-  ~(uni by fin)
  =<  +  %+  ~(rib by nex)  *pagz
  |=  [[k=knot v=page] a=pagz]
  [(~(put by a) (crip (welp pre (trip k))) v) k v]
++  point  ::  web address router considering full web path
  =,  rudder
  |=  [base=(lest @t) have=(set @tas)]
  ^-  route
  |=  trail
  ^-  (unit place)
  ?~  site=(decap base site)  ~
  ?-  spat=(roll u.site |=([n=@t a=@t] ?:(=(a '') n (crip :(welp (trip a) "/" (trip n))))))
    %$  `[%page | %index]
    @   ?:((~(has in have) spat) `[%page | spat] ~)
  ==
--
^-  agent:gall
=|  state-now
=*  state  -
=<
  %-  agent:dbug  ::  debug-only
  %-  agent:tonic  ::  debug-only
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this |) bowl)
      cor   ~(. +> [bowl ~])
  ++  on-init
    ^-  (quip card _this)
    =^(cards state abet:init:cor [cards this])
  ++  on-save  !>([state epic-now:f])
  ++  on-load
    |=  =vase
    ^-  (quip card _this)
    =^(cards state abet:(load:cor vase) [cards this])
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    =^(cards state abet:(poke:cor mark vase) [cards this])
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    =^(cards state abet:(watch:cor path) [cards this])
  ++  on-peek   peek:cor
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card _this)
    =^(cards state abet:(agent:cor wire sign) [cards this])
  ++  on-arvo
    |=  [=wire sign=sign-arvo]
    ^-  (quip card _this)
    =^(cards state abet:(arvo:cor wire sign) [cards this])
  --
|_  [=bowl:gall cards=(list card)]
::
+*  da-proz  =/  da  (da proj-lake:sss:f path:proj:f)
             (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    du-proz  =/  du  (du proj-lake:sss:f path:proj:f)
             (du pubs bowl -:!>(*result:du))
::
++  abet  [(flop cards) state]
++  cor   .
++  emit  |=(=card cor(cards [card cards]))
++  emil  |=(caz=(list card) cor(cards (welp (flop caz) cards)))
++  give  |=(=gift:agent:gall (emit %give gift))
++  pull  |=([caz=(list card) sub=_subs] =.(subs sub (emil caz)))
++  push  |=([caz=(list card) pub=_pubs] =.(pubs pub (emil caz)))
::
++  init
  ^+  cor
  %-  emit
  :*  %pass  /eyre/connect  %arvo  %e
      %connect  `/apps/[dap.bowl]  dap.bowl
  ==
::
++  load
  |=  =vase
  ^+  cor
  %=    cor
      state
    |^  =+  !<([sat=state-any pic=epic:f] vase)
        ?-  -.sat
          %0  sat
        ==
    +$  state-any  $%(state-now)
    ::  +$  state-0  ...
    --
  ==
::
++  poke
  |=  [=mark =vase]
  ^+  cor
  ?+    mark  ~|(bad-poke/mark !!)
  ::  native pokes  ::
      %fund-poke
    =+  !<([=flag:f =jolt:f] vase)
    cor
    ::  ?>  (~(has by us-prez) flag)
    ::  =/  proj-core  (po-abed:po-core flag)
    ::  ?:  =(p.flag our.bowl)
    ::    po-abet:(po-push:proj-core jolt)
    ::  po-abet:(po-proxy:proj-core jolt)
  ::  sss pokes  ::
      %sss-on-rock
    ?-  msg=!<(from:da-proz (fled vase))
      [[%fund *] *]  cor
    ==
  ::
      %sss-fake-on-rock
    ?-  msg=!<(from:da-proz (fled vase))
      [[%fund *] *]  (emil (handle-fake-on-rock:da-proz msg))
    ==
  ::
      %sss-to-pub
    ?-  msg=!<(into:du-proz (fled vase))
      [[%fund *] *]  (push (apply:du-proz msg))
    ==
  ::
      %sss-proj
    =/  res  !<(into:da-proz (fled vase))
    po-abet:(po-pull:(po-abed:po-core (proj-flag:sss:f path.res)) res)
  ::  http pokes  ::
      %handle-http-request
    =-  =.  cor  (emil -.render)
        cor(+.state +.render)
    ^=  render
    %.  [bowl !<(order:rudder vase) +.state]
    %:  (steer:rudder dat-now:f act-now:f)
      my-pagz
      (point /apps/[dap.bowl] ~(key by my-pagz))
      (fours:rudder +.state)
      |=(act=act-now:f ~)
    ==
  ==
::
++  watch
  |=  path=(pole knot)
  ^+  cor
  ?+    path  ~|(bad-watch-path/path !!)
      [%http-response *]
    cor
  ==
::
++  peek
  |=  path=(pole knot)
  ^-  (unit (unit cage))
  ?+    path  [~ ~]
      [%u %proj ship=@ name=@ ~]
    =/  ship=@p    (slav %p ship.path)
    =/  name=@tas  (slav %tas name.path)
    ``loob+!>((~(has by us-prez) ship name))
  ==
::
++  agent
  |=  [path=(pole knot) =sign:agent:gall]
  ^+  cor
  ?+    path  cor
  :: sss responses ::
      [~ %sss %on-rock @ @ @ %fund %proj @ @ ~]
    (pull ~ (chit:da-proz |3:path sign))
  ::
      [~ %sss %scry-request @ @ @ %fund %proj @ @ ~]
    (pull (tell:da-proz |3:path sign))
  ::
      [~ %sss %scry-response @ @ @ %fund %proj @ @ ~]
    (push (tell:du-proz |3:path sign))
  :: proxy response ::
      [%fund ship=@ name=@ ~]
    ?>  ?=(%poke-ack -.sign)
    =/  ship=@p    (slav %p ship.path)
    =/  name=@tas  (slav %tas name.path)
    ?~  p.sign  cor
    %-  (slog u.p.sign)
    cor
  ==
::
++  arvo
  |=  [path=(pole knot) sign=sign-arvo]
  ^+  cor
  cor
::
++  my-prez
  ^-  prez:f
  %-  ~(run by proz)
  |=(=proj:f `prej:f`[proj &])
::
++  us-prez
  ^-  prez:f
  %-  ~(uni by my-prez)
  =<  -
  %+  ~(rib by read:da-proz)  *prez:f
  |=  [[k=[ship dude p=path:proj:f] v=[s=? f=? p=proj:f]] a=prez:f]
  :_  [k v]
  (~(put by a) (proj-flag:sss:f p.k) p.v |(s.v f.v))
::
++  po-core
  |_  [=flag:f =proj:f gone=_|]
  ++  po-core  .
  ++  po-abet
    ?.  =(p.flag our.bowl)
      cor
    %_    cor
        proz
      ?:(gone (~(del by proz) flag) (~(put by proz) flag proj))
    ==
  ++  po-abed
    |=  =flag:f
    %=  po-core
      flag  flag
      proj  -:(~(gut by us-prez) flag *prej:f)
    ==
  ::
  ++  po-area     `path`/[dap.bowl]/proj/(scot %p p.flag)/[q.flag]
  ++  po-up-area  |=(p=path `(list path)`[(welp po-area p)]~)
  ++  po-du-path  [%fund %proj (scot %p p.flag) q.flag ~]
  ++  po-da-path  [p.flag dap.bowl %fund %proj (scot %p p.flag) q.flag ~]
  ::
  ++  po-init
    po-core(cor (push (public:du-proz [po-du-path]~)))
  ++  po-join
    po-core(cor (pull (surf:da-proz po-da-path)))
  ++  po-leave
    po-core(cor (pull ~ (quit:da-proz po-da-path)), gone &)
  ::
  ++  po-proxy
    |=  =jolt:f
    ^+  po-core
    =/  =dock  [p.flag dap.bowl]
    =/  =cage  fund-action+!>([flag jolt])
    =.  cor  (emit %pass po-area %agent dock %poke cage)
    po-core
  ++  po-pull
    |=  res=into:da-proz
    ^+  po-core
    =/  =jolt:f
      ?-  what.res
        %tomb  [%drop ~]
        %wave  q.poke.wave.res
        %rock  [%init ~]
      ==
    ?:  ?=(%drop -.jolt)
      po-leave
    =.  cor  (pull (apply:da-proz res))
    po-core
  ++  po-push
    |=  =jolt:f
    ^+  po-core
    ?:  ?=(%drop -.jolt)
      =.  cor  (push (kill:du-proz [po-du-path]~))
      po-core(gone &)
    =.  proj  (proj-wash:sss:f proj bowl flag jolt)
    =.  cor   (push (give:du-proz po-du-path bowl flag jolt))
    po-core
  --
--
