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
+*  da-poz  (proz-subs:sss:f bol subs)
    du-poz  (proz-pubs:sss:f bol pubs)
    my-pez  (prez-mine:sss:f bol +.state)
    us-pez  (prez-ours:sss:f bol +.state)
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
    po-abet:(po-push:(po-abed:po-core lag) pod)
  ::  sss pokes  ::
      %sss-on-rock
    ?-  msg=!<(from:da-poz (fled vas))
      [[%fund *] *]  cor
    ==
  ::
      %sss-fake-on-rock
    ?-  msg=!<(from:da-poz (fled vas))
      [[%fund *] *]  (emil (handle-fake-on-rock:da-poz msg))
    ==
  ::
      %sss-to-pub
    ?-  msg=!<(into:du-poz (fled vas))
      [[%fund *] *]  (push (apply:du-poz msg))
    ==
  ::
      %sss-proj
    =/  res  !<(into:da-poz (fled vas))
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
    ~&  >>  (turn act |=([f=flag:f p=prod:f] "{(flag:dump:h f)} : {<-.p>}"))
    =-  [bre kaz dat]
    ^-  [bre=brief:rudder dat=dat-now:f kaz=(list card)]
    :*  ~                              ::  TODO: Make this the redirect path
        +.state                        ::  TODO: eager evaluate the cards?
        (turn act |=([f=flag:f p=prod:f] (po-mk-car:(po-abed:po-core f) p.f p)))
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
    ``noun+!>((bind (~(get by us-pez) sip nam) |=(p=prej:f `proj:f`-.p)))
  ::
      [%u %proj sip=@ nam=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ``loob+!>((~(has by us-pez) sip nam))
  ==
::
++  agent
  |=  [pat=(pole knot) syn=sign:agent:gall]
  ^+  cor
  ?+    pat  cor
  :: sss responses ::
      [~ %sss %on-rock @ @ @ %fund %proj @ @ ~]
    (pull ~ (chit:da-poz |3:pat syn))
  ::
      [~ %sss %scry-request @ @ @ %fund %proj @ @ ~]
    (pull (tell:da-poz |3:pat syn))
  ::
      [~ %sss %scry-response @ @ @ %fund %proj @ @ ~]
    (push (tell:du-poz |3:pat syn))
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
    ?.  po-is-myn  cor
    %_  cor
      proz  ?:(gon (~(del by proz) lag) (~(put by proz) lag pro))
    ==
  ++  po-abed
    |=  lag=flag:f
    %=  po-core
      lag  lag
      pro  -:(~(gut by us-pez) lag *prej:f)
    ==
  ::
  ++  po-is-myn  =(our.bol p.lag)
  ++  po-is-src  =(our.bol src.bol)
  ++  po-is-new  !(~(has by us-pez) lag)
  ++  po-pj-pat  `path`/fund/proj/(scot %p p.lag)/[q.lag]
  ++  po-du-pat  [%fund %proj (scot %p p.lag) q.lag ~]
  ++  po-da-pat  [p.lag dap.bol %fund %proj (scot %p p.lag) q.lag ~]
  ::
  ++  po-mk-car
    |=  [for=@p pod=prod:f]
    ^-  card
    :*  %pass   po-pj-pat
        %agent  [for dap.bol]
        %poke   fund-poke+!>([lag pod])
    ==
  ++  po-do-read
    |=  pod=prod:f
    ^-  bean
    ::  FIXME: Everything is public
    %.y
  ++  po-do-writ
    |=  pod=prod:f
    ^-  bean
    ::  FIXME: Fairly intuitive yet hilariously obtuse
    =-  (gte hav ned)
    :-  ^-  hav=perm:f
        ?:  =(p.lag src.bol)  %boss
        ::  FIXME: Including ~tocwex here is a hack for the Gnosis Safe arch
        ::  and should be removed in the next version
        ?:  |(=(p.assessment.pro src.bol) =(~tocwex src.bol))  %peer
        %peon
    ^-  ned=perm:f
    ?+  -.pod    %peon
      %init  %boss
      %drop  %boss
      %draw  %peer
      %wipe  %peer
      %bump  %peer
    ==
  ::
  ++  po-pull
    |=  res=into:da-poz
    ^+  po-core
    ?<  po-is-myn
    =/  pod=prod:f
      ?-  what.res
        %rock  [%init ~]
        %tomb  [%exit ~]
        %wave  q.poke.wave.res
      ==
    ?:  ?=(%exit -.pod)
      po-core(cor (pull ~ (quit:da-poz po-da-pat)), gon &)
    po-core(cor (pull (apply:da-poz res)))
  ++  po-push
    |=  pod=prod:f
    ^+  po-core
    =*  mes  `mess:f`[src.bol lag pod]
    ?<  ~|(bad-push+mes =(%$ q.lag))
    |^  ?+    -.pod
        ::  proj prods ::
          ?.  po-is-myn  po-core(cor (emit (po-mk-car p.lag pod)))
          ?>  ~|(bad-push+mes (po-do-writ pod))
          ?-    -.pod
              %init
            =?  cor  po-is-new  (push (public:du-poz [po-du-pat]~))
            (wash ~)
          ::
              %drop
            =?  cor  !po-is-new  (push (kill:du-poz [po-du-pat]~))
            po-core(gon &)
          ::
              ?(%bump %mula %draw %wipe)
            ?<  ~|(bad-push+mes po-is-new)
            =-  (wash -)
            ?-    -.pod
                ?(%draw %wipe)
              ~
            ::
                %bump
              =+  ses=p.assessment.pro
              ?+  sat.pod  ~
                %prop  [(po-mk-car ses [%lure ses %orac])]~
                ::  TODO: If this was sent by the user, also send cards to
                ::  close the project path to the retracted oracle
                %born  ?:(=(our.bol ses) ~ ~)
              ==
            ::
                %mula
              ::  TODO: Add hark notifications and follow-up reminders for
              ::  pledges
              ?-  +<.pod
                %plej  [(po-mk-car ship.pod [%lure ship.pod %fund])]~
                %trib  ?~(ship.pod ~ [(po-mk-car u.ship.pod [%lure u.ship.pod %fund])]~)
              ==
            ==
          ==
        ::  meta prods ::
            %lure
          ::  FIXME: For a more complete version, maintain a per-ship lure
          ::  list (like group invites from %tlon)
          ?:  =(our.bol who.pod)  $(pod [%join ~])
          ?<  ~|(bad-push+mes po-is-new)
          po-core(cor (emit (po-mk-car ?:(po-is-myn who.pod p.lag) pod)))
        ::  meta prods ::
            ?(%join %exit)
          ::  FIXME: Re-add this contraint once an invite mechanism is
          ::  in place (see %lure clause above).
          ::  ?>  ~|(bad-meta+mes po-is-src)
          ?:  po-is-myn  po-core
          ?-    -.pod
              %join
            ?.  po-is-new  po-core
            po-core(cor (pull (surf:da-poz po-da-pat)))
          ::
              %exit
            ?:  po-is-new  po-core
            po-core(cor (pull ~ (quit:da-poz po-da-pat)), gon &)
          ==
        ==
    ++  wash
      |=  caz=(list card)
      =.  pro  (proj-wash:sss:f pro bol lag pod)
      =.  cor  (push (give:du-poz po-du-pat bol lag pod))
      =.  cor  (emil caz)
      po-core
    --
  --
--
