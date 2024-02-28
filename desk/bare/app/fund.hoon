/+  f=fund, *sss
/+  default-agent, rudder
/+  dbug, verb, tonic  ::  debug-only
/~  base-pagz  pag-now:f  /app/fund
/~  aset-pagz  pag-now:f  /app/fund/assets
/~  dash-pagz  pag-now:f  /app/fund/dashboards
::  TODO: Start remove
/~  mods-pagz  pag-now:f  /app/fund/modals
/~  pro1-pagz  pag-now:f  /app/fund/projects/project-1
/~  pro2-pagz  pag-now:f  /app/fund/projects/project-2
/~  pro3-pagz  pag-now:f  /app/fund/projects/project-3
/~  pro4-pagz  pag-now:f  /app/fund/projects/project-4
/~  pro5-pagz  pag-now:f  /app/fund/projects/project-5
/~  pro6-pagz  pag-now:f  /app/fund/projects/project-6
/~  pro7-pagz  pag-now:f  /app/fund/projects/project-7
/~  pro8-pagz  pag-now:f  /app/fund/projects/project-8
::  TODO: End remove
|%
+$  card  card:agent:gall
+$  state-now  [%0 dat-now:f]
++  my-pagz  ::  map of pages keyed by full web path
  ~+
  =/  paz=(list [page-map=paz-now:f path-prefix=tape])
    :~  [base-pagz ""]
        [aset-pagz "assets/"]
        [dash-pagz "dashboards/"]
        ::  TODO: Start remove
        [mods-pagz "modals/"]
        [pro1-pagz "projects/project-1/"]
        [pro2-pagz "projects/project-2/"]
        [pro3-pagz "projects/project-3/"]
        [pro4-pagz "projects/project-4/"]
        [pro5-pagz "projects/project-5/"]
        [pro6-pagz "projects/project-6/"]
        [pro7-pagz "projects/project-7/"]
        [pro8-pagz "projects/project-8/"]
        ::  TODO: End remove
    ==
  %+  roll  paz
  |=  [[nex=paz-now:f pre=tape] fin=paz-now:f]
  %-  ~(uni by fin)
  =<  -  %+  ~(rib by nex)  *paz-now:f
  |=  [[k=knot v=pag-now:f] a=paz-now:f]
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
  %+  verb  &  ::  debug-only
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
+*  da-proz  (proz-subs:sss:f bowl subs)
    du-proz  (proz-pubs:sss:f bowl pubs)
    my-prez  (prez-mine:sss:f bowl +.state)
    us-prez  (prez-ours:sss:f bowl +.state)
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
    =+  !<([=flag:f =prod:f] vase)
    =/  has=?  (~(has by us-prez) flag)
    =/  myn=?  =(our.bowl p.flag)
    ?:  ?=(%join-proj -.prod)
      ?>  &(!has !myn)
      po-abet:po-join:(po-abed:po-core flag)
    ?:  ?=(%exit-proj -.prod)
      ?>  &(has !myn)
      po-abet:po-exit:(po-abed:po-core flag)
    ?:  =(p.flag our.bowl)
      ?>  |(has ?=(%init-proj -.prod))
      po-abet:(po-push:(po-abed:po-core flag) prod)
    po-abet:(po-poxy:(po-abed:po-core flag) prod)
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
    =-  cor(cards (welp (flop caz) cards), +.state dat)
    ^-  [caz=(list card) dat=dat-now:f]
    %.  [bowl !<(order:rudder vase) +.state]
    %:  (steer:rudder dat-now:f act-now:f)
      my-pagz
    ::
      (point /apps/[dap.bowl] ~(key by my-pagz))
    ::
      (fours:rudder +.state)
    ::
      |=  act=act-now:f
      ^-  $@(brief:rudder [brief:rudder (list card) dat-now:f])
      ~&  act
      :-  ~  ::  message? TODO: Make this the path of the action
      :_  +.state
      ::  TODO: eager evaluate the cards?
      ^-  (list card)
      %+  turn  `(list poke:f)`act
      |=  [lag=flag:f pod=prod:f]
      :*  %pass   /[dap.bowl]/proj/(scot %p p.lag)/[q.lag]
          %agent  [p.lag dap.bowl]
          %poke   fund-poke+!>([lag pod])
      ==
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
      [%x %proj ship=@ name=@ ~]
    =/  ship=@p    (slav %p ship.path)
    =/  name=@tas  (slav %tas name.path)
    ``noun+!>((bind (~(get by us-prez) ship name) |=(=prej:f `proj:f`-.prej)))
  ::
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
      [%fund %proj ship=@ name=@ ~]
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
  ++  po-do-read  |=(=prod:f `bean`%.y)  ::  FIXME: Everything is public
  ++  po-do-writ
    |=  =prod:f
    ^-  bean
    ::  FIXME: Fairly intuitive yet hilariously obtuse
    =-  (gte have need)
    :-  ^-  have=perm:f
        ?:  =(p.flag src.bowl)  %boss
        ::  ?:  |((~(has in workers.proj) src.bowl) =(p.assessment.proj src.bowl))  %help
        %peon
    ^-  need=perm:f
    ?+  -.prod    %peon
      %init-proj  %boss
      %drop-proj  %boss
      %edit-proj  %help
      %bump-proj  %help
      %init-mile  %help
      %drop-mile  %help
      %edit-mile  %help
    ==
  ::
  ++  po-init
    po-core(cor (push (public:du-proz [po-du-path]~)))
  ++  po-join
    po-core(cor (pull (surf:da-proz po-da-path)))
  ++  po-exit
    po-core(cor (pull ~ (quit:da-proz po-da-path)), gone &)
  ::
  ++  po-poxy
    |=  =prod:f
    ^+  po-core
    =/  =dock  [p.flag dap.bowl]
    =/  =cage  fund-poke+!>([flag prod])
    po-core(cor (emit %pass po-area %agent dock %poke cage))
  ++  po-pull
    |=  res=into:da-proz
    ^+  po-core
    =/  =prod:f
      ?-  what.res
        %tomb  [%drop-proj ~]
        %wave  q.poke.wave.res
        %rock  [%init-proj ~]
      ==
    ?:  ?=(%drop-proj -.prod)  po-exit
    po-core(cor (pull (apply:da-proz res)))
  ++  po-push
    |=  =prod:f
    ^+  po-core
    ?>  (po-do-writ prod)
    ?:  ?=(%drop-proj -.prod)
      po-core(cor (push (kill:du-proz [po-du-path]~)), gone &)
    =.  proj  (proj-wash:sss:f proj bowl flag prod)
    =.  cor   (push (give:du-proz po-du-path bowl flag prod))
    po-core
  --
--
