/+  f=fund, h=fund-http, *sss
/+  default-agent, rudder
/+  dbug, verb, tonic  ::  debug-only
/~  pagz  pag-now:f  /web/fund/page
|%
+$  card  card:agent:gall
+$  state-now  [%0 dat-now:f]
--
^-  agent:gall
=|  state-now
=*  state  -
=<
  %+  verb  &  ::  debug-only
  %-  agent:dbug  ::  debug-only
  %-  agent:tonic  ::  debug-only
  |_  bol=bowl:gall
  +*  tis  .
      def  ~(. (default-agent tis |) bol)
      cor  ~(. +> [bol ~])
  ++  on-init
    ^-  (quip card _tis)
    =^(caz state abet:init:cor [caz tis])
  ++  on-save  !>([state epic-now:f])
  ++  on-load
    |=  vas=vase
    ^-  (quip card _tis)
    =^(caz state abet:(load:cor vas) [caz tis])
  ++  on-poke
    |=  [mar=mark vas=vase]
    ^-  (quip card _tis)
    =^(caz state abet:(poke:cor mar vas) [caz tis])
  ++  on-watch
    |=  pat=path
    ^-  (quip card _tis)
    =^(caz state abet:(watch:cor pat) [caz tis])
  ++  on-peek   peek:cor
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  ++  on-agent
    |=  [wyr=wire syn=sign:agent:gall]
    ^-  (quip card _tis)
    =^(caz state abet:(agent:cor wyr syn) [caz tis])
  ++  on-arvo
    |=  [wyr=wire syn=sign-arvo]
    ^-  (quip card _tis)
    =^(caz state abet:(arvo:cor wyr syn) [caz tis])
  --
|_  [bol=bowl:gall caz=(list card)]
::
+*  da-proz  (proz-subs:sss:f bol subs)
    du-proz  (proz-pubs:sss:f bol pubs)
    my-prez  (prez-mine:sss:f bol +.state)
    us-prez  (prez-ours:sss:f bol +.state)
::
++  abet  [(flop caz) state]
++  cor   .
++  emit  |=(c=card cor(caz [c caz]))
++  emil  |=(c=(list card) cor(caz (welp (flop c) caz)))
++  give  |=(g=gift:agent:gall (emit %give g))
++  pull  |=([c=(list card) s=_subs] =.(subs s (emil c)))
++  push  |=([c=(list card) p=_pubs] =.(pubs p (emil c)))
::
++  init
  ^+  cor
  %-  emit
  :*  %pass  /eyre/connect  %arvo  %e
      %connect  `/apps/[dap.bol]  dap.bol
  ==
::
++  load
  |=  vas=vase
  ^+  cor
  %=    cor
      state
    |^  =+  !<([sat=state-any epi=epic:f] vas)
        ?-  -.sat
          %0  sat
        ==
    +$  state-any  $%(state-now)
    ::  +$  state-0  ...
    --
  ==
::
++  poke
  |=  [mar=mark vas=vase]
  ^+  cor
  ?+    mar  ~|(bad-poke+mar !!)
  ::  native pokes  ::
      %fund-poke
    =+  !<([lag=flag:f pod=prod:f] vas)
    =/  myn=?  =(our.bol p.lag)        ::  is my project?
    =/  has=?  (~(has by us-prez) lag)  ::  is project downloaded?
    ?:  ?=(%join -.pod)
      ?>  &(!has !myn)
      po-abet:po-join:(po-abed:po-core lag)
    ?:  ?=(%exit -.pod)
      ?>  &(has !myn)
      po-abet:po-exit:(po-abed:po-core lag)
    ::  ?:  ?=(%lure -.pod)
    ::    ?>  has
    ::    po-abet:(po-poxy:(po-abed:po-core lag) pod)
    ?:  myn
      ?>  |(has ?=(%init -.pod))
      po-abet:(po-push:(po-abed:po-core lag) pod)
    po-abet:(po-poxy:(po-abed:po-core lag) pod)
  ::  sss pokes  ::
      %sss-on-rock
    ?-  msg=!<(from:da-proz (fled vas))
      [[%fund *] *]  cor
    ==
  ::
      %sss-fake-on-rock
    ?-  msg=!<(from:da-proz (fled vas))
      [[%fund *] *]  (emil (handle-fake-on-rock:da-proz msg))
    ==
  ::
      %sss-to-pub
    ?-  msg=!<(into:du-proz (fled vas))
      [[%fund *] *]  (push (apply:du-proz msg))
    ==
  ::
      %sss-proj
    =/  res  !<(into:da-proz (fled vas))
    po-abet:(po-pull:(po-abed:po-core (proj-flag:sss:f path.res)) res)
  ::  http pokes  ::
      %handle-http-request
    =-  cor(caz (welp (flop kaz) caz), +.state dat)
    ^-  [kaz=(list card) dat=dat-now:f]
    %.  [bol !<(order:rudder vas) +.state]
    %-  (steer:rudder dat-now:f act-now:f)
    :^  pagz  route:h  (fours:rudder +.state)
    |=  act=act-now:f
    ^-  $@(brief:rudder [brief:rudder (list card) dat-now:f])
    ~&  >  (turn `(list poke:f)`act |=(p=poke:f -.q.p))
    :-  ~  ::  message? TODO: Make this the path of the action
    :_  +.state
    ::  TODO: eager evaluate the cards?
    ^-  (list card)
    %+  turn  `(list poke:f)`act
    |=  [lag=flag:f pod=prod:f]
    :*  %pass   /[dap.bol]/proj/(scot %p p.lag)/[q.lag]
        %agent  [p.lag dap.bol]
        %poke   fund-poke+!>([lag pod])
    ==
  ==
::
++  watch
  |=  pat=(pole knot)
  ^+  cor
  ?+    pat  ~|(bad-watch+pat !!)
      [%http-response *]
    cor
  ==
::
++  peek
  |=  pat=(pole knot)
  ^-  (unit (unit cage))
  ?+    pat  [~ ~]
      [%x %proj sip=@ nam=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ``noun+!>((bind (~(get by us-prez) sip nam) |=(p=prej:f `proj:f`-.p)))
  ::
      [%u %proj sip=@ nam=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ``loob+!>((~(has by us-prez) sip nam))
  ==
::
++  agent
  |=  [pat=(pole knot) syn=sign:agent:gall]
  ^+  cor
  ?+    pat  cor
  :: sss responses ::
      [~ %sss %on-rock @ @ @ %fund %proj @ @ ~]
    (pull ~ (chit:da-proz |3:pat syn))
  ::
      [~ %sss %scry-request @ @ @ %fund %proj @ @ ~]
    (pull (tell:da-proz |3:pat syn))
  ::
      [~ %sss %scry-response @ @ @ %fund %proj @ @ ~]
    (push (tell:du-proz |3:pat syn))
  :: proxy response ::
      [%fund %proj sip=@ nam=@ ~]
    ?>  ?=(%poke-ack -.syn)
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ?~  p.syn  cor
    %-  (slog u.p.syn)
    cor
  ==
::
++  arvo
  |=  [pat=(pole knot) syn=sign-arvo]
  ^+  cor
  cor
::
++  po-core
  |_  [lag=flag:f pro=proj:f gon=_|]
  ++  po-core  .
  ++  po-abet
    ?.  =(p.lag our.bol)
      cor
    %_    cor
        proz
      ?:(gon (~(del by proz) lag) (~(put by proz) lag pro))
    ==
  ++  po-abed
    |=  lag=flag:f
    %=  po-core
      lag  lag
      pro  -:(~(gut by us-prez) lag *prej:f)
    ==
  ::
  ++  po-area     `path`/[dap.bol]/proj/(scot %p p.lag)/[q.lag]
  ++  po-up-area  |=(p=path `(list path)`[(welp po-area p)]~)
  ++  po-du-path  [%fund %proj (scot %p p.lag) q.lag ~]
  ++  po-da-path  [p.lag dap.bol %fund %proj (scot %p p.lag) q.lag ~]
  ++  po-do-read  |=(p=prod:f `bean`%.y)  ::  FIXME: Everything is public
  ++  po-do-writ
    |=  pod=prod:f
    ^-  bean
    ::  FIXME: Fairly intuitive yet hilariously obtuse
    =-  (gte have need)
    :-  ^-  have=perm:f
        ?:  =(p.lag src.bol)  %boss
        ?:  =(p.assessment.pro src.bol)  %help
        %peon
    ^-  need=perm:f
    ?+  -.pod    %peon
      %init  %boss
      %drop  %boss
      %join  %boss
      %exit  %boss
      %bump  %help
    ==
  ::
  ++  po-init
    ?>  (po-do-writ [%init `pro])
    po-core(cor (push (public:du-proz [po-du-path]~)))
  ++  po-join
    ?>  (po-do-writ [%join ~])
    po-core(cor (pull (surf:da-proz po-da-path)))
  ++  po-exit
    ?>  (po-do-writ [%exit ~])
    po-core(cor (pull ~ (quit:da-proz po-da-path)), gon &)
  ::
  ++  po-poxy
    |=  pod=prod:f
    ^+  po-core
    =/  =dock  [p.lag dap.bol]
    =/  =cage  fund-poke+!>([lag pod])
    po-core(cor (emit %pass po-area %agent dock %poke cage))
  ++  po-pull
    |=  res=into:da-proz
    ^+  po-core
    =/  pod=prod:f
      ?-  what.res
        %tomb  [%drop ~]
        %wave  q.poke.wave.res
        %rock  [%init ~]
      ==
    ?:  ?=(%drop -.pod)  po-exit
    po-core(cor (pull (apply:da-proz res)))
  ++  po-push
    |=  pod=prod:f
    ^+  po-core
    ?>  (po-do-writ pod)
    ?:  ?=(%drop -.pod)
      po-core(cor (push (kill:du-proz [po-du-path]~)), gon &)
    =.  pro  (proj-wash:sss:f pro bol lag pod)
    =.  cor  (push (give:du-proz po-du-path bol lag pod))
    po-core
  --
--
