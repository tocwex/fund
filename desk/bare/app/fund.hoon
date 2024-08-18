/-  f=fund, p=pals
/-  fd=fund-data, fd-1=fund-data-1, fd-0=fund-data-0
/+  fh=fund-http, fc=fund-chain, fj=fund-proj, fp=fund-prof
/+  config, default-agent, rudder, *sss
/+  dbug, verb, tonic, vita-client
/~  pagz  page:fd  /web/fund/page
|%
+$  card       card:agent:gall
+$  sign-gall  sign:agent:gall
+$  state-now  [%2 data:fd]
--
^-  agent:gall
=|  state-now
=*  state  -
=<  =-  ?.  !<(? (slot:config %debug))  -
        (verb & (agent:dbug (agent:tonic -)))
    %-  (agent:vita-client | !<(@p (slot:config %point)))
    |_  bol=bowl:gall
    +*  tis  .
        def  ~(. (default-agent tis |) bol)
        cor  ~(. +> [bol ~])
    ++  on-init   =^(caz state abet:init:cor [caz tis])
    ++  on-save   !>([state 0])  ::  NOTE: 0 is unused `epic` flag
    ++  on-load   |=(v=vase =^(caz state abet:(load:cor v) [caz tis]))
    ++  on-poke   |=([m=mark v=vase] =^(caz state abet:(poke:cor m v) [caz tis]))
    ++  on-watch  |=(p=path =^(caz state abet:(watch:cor p) [caz tis]))
    ++  on-peek   peek:cor
    ++  on-leave  on-leave:def
    ++  on-fail   on-fail:def
    ++  on-agent  |=([w=wire s=sign-gall] =^(caz state abet:(agent:cor w s) [caz tis]))
    ++  on-arvo   |=([w=wire s=sign-arvo] =^(caz state abet:(arvo:cor w s) [caz tis]))
    --
|_  [bol=bowl:gall caz=(list card)]
::
+*  pj-con  ~(. conn:proj:fd bol [proj-subs proj-pubs]:state)
    pj-suz  subs:pj-con
    pj-puz  pubs:pj-con
    pj-myn  mine:pj-con
    pj-our  ours:pj-con
    pf-con  ~(. conn:prof:fd bol [prof-subs prof-pubs]:state)
    pf-suz  subs:pf-con
    pf-puz  pubs:pf-con
    pf-myn  mine:pf-con
    pf-our  ours:pf-con
    me-con  ~(. conn:meta:fd bol [meta-subs meta-pubs]:state)
    me-suz  subs:me-con
    me-puz  pubs:me-con
    me-myn  mine:me-con
    me-our  ours:me-con
::
++  abet  [(flop caz) state]
++  cor   .
++  emit  |=(c=card cor(caz [c caz]))
++  emil  |=(c=(list card) cor(caz (welp (flop c) caz)))
++  give  |=(g=gift:agent:gall (emit %give g))
++  proj-pull  |=([c=(list card) s=_proj-subs] =.(proj-subs s (emil c)))
++  proj-push  |=([c=(list card) p=_proj-pubs] =.(proj-pubs p (emil c)))
++  meta-pull  |=([c=(list card) s=_meta-subs] =.(meta-subs s (emil c)))
++  meta-push  |=([c=(list card) p=_meta-pubs] =.(meta-pubs p (emil c)))
++  prof-pull  |=([c=(list card) s=_prof-subs] =.(prof-subs s (emil c)))
++  prof-push  |=([c=(list card) p=_prof-pubs] =.(prof-pubs p (emil c)))
::
++  init
  ^+  cor
  =.  cor  open-eyre:action
  =.  cor  renew-surl:action
  cor
::
++  load
  |=  vas=vase
  ^+  cor
  |^  =+  !<([sat=state-any @] vas)  ::  NOTE: @ is unused `epic` flag
      =-  =.(state.cor nat open)
      |-  ^-  nat=state-now
      ?-  -.sat
        %2  sat
        %1  $(sat (move-1-2 sat))
        %0  $(sat (move-0-1 sat))
      ==
  +$  state-any  $%(state-now state-1 state-0)
  +$  state-2    state-now
  +$  state-1    [%1 data:fd-1]
  +$  state-0    [%0 data:fd-0]
  ++  move-1-2
    |=  old=state-1
    ^-  state-2
    =+  new=*state-2  %_  new
      init       init.old
      proj-subs  subs.old
      proj-pubs  pubs.old
    ==
  ++  move-0-1
    |=  old=state-0
    ^-  state-1
    |^  [%1 init.old (sove subs.old) (pove pubs.old)]
    ++  urck  |=(old=vock:lake:proj:fd-0 `vock:lake:proj:fd-1`[%1 old])
    ++  uwve  |=(old=vave:lake:proj:fd-0 `vave:lake:proj:fd-1`[%1 old])
    +$  trok  ((mop aeon vock:lake:proj:fd-1) gte)
    +$  twav  ((mop aeon vave:lake:proj:fd-1) lte)
    ++  sove
      |=  old=_subs:*data:fd-0
      ^-  _subs:*data:fd-1
      ?:  =(~ +.old)  *_subs:*data:fd-1  ::  avoid invalid bunt in +rib:by gate
      =<  -  %+  ~(rib by +.old)  *_subs:*data:fd-1
      |=  [kev=_?>(?=([%0 ^] old) n.+.old) acc=_subs:*data:fd-1]
      :_  kev
      :-  -.acc  %+  ~(put by +.acc)  p.kev
      ?~  q.kev  q.kev
      `u.q.kev(rock (urck rock.u.q.kev))
    ++  pove
      |=  old=_pubs:*data:fd-0
      ^-  _pubs:*data:fd-1
      ?>  ?=(%1 -.old)
      ?:  =(~ +.old)  *_pubs:*data:fd-1  ::  avoid invalid bunt in +rib:by gate
      =<  -  %+  ~(rib by +.old)  *_pubs:*data:fd-1
      |=  [kev=_?>(?=([%1 ^] old) n.+.old) acc=_pubs:*data:fd-1]
      ?>  ?=(%1 -.acc)
      :_  kev
      :-  -.acc  %+  ~(put by +.acc)  p.kev
      =-  q.kev(tid -)
      ?@  tid.q.kev  tid.q.kev
      %=    tid.q.kev
          rok
        =<  -  %^  (dip:((on aeon vock:lake:proj:fd-0) gte) trok)
            rok.tid.q.kev
          *trok
        |=  [a=trok k=aeon v=vock:lake:proj:fd-0]
        [`v | (put:((on aeon vock:lake:proj:fd-1) gte) a k (urck v))]
      ::
          wav
        =<  -  %^  (dip:((on aeon vave:lake:proj:fd-0) lte) twav)
            wav.tid.q.kev
          *twav
        |=  [a=twav k=aeon v=vave:lake:proj:fd-0]
        [`v | (put:((on aeon vave:lake:proj:fd-1) lte) a k (uwve v))]
      ==
    --
  --
::
++  poke
  |=  [mar=mark vas=vase]
  ^+  cor
  ?+    mar  ~|(bad-poke+mar !!)
  ::  native pokes  ::
      %fund-poke
    =+  !<(pok=poke:f vas)
    ~?  !<(? (slot:config %debug))   pok
    ?-    -.pok
      %proj  pj-abet:(pj-push:(pj-abed:pj-core p.pok) q.pok)
      %meta  me-abet:(me-push:(me-abed:me-core p.pok) q.pok)
      %prof  pf-abet:(pf-push:(pf-abed:pf-core p.pok) q.pok)
    ::
        %fund
      %-  emit
      :*  %pass   /fund/vita
          %agent  [our.bol dap.bol]
          %poke   vita-client+!>([%set-enabled sat.pok])
      ==
    ==
  ::  sss pokes  ::
      %sss-on-rock
    ?-  msg=!<($%(from:pj-suz from:me-suz from:pf-suz) (fled vas))
      [[%fund *] *]  cor
    ==
  ::
      %sss-fake-on-rock
    ?-  msg=!<($%(from:pj-suz from:me-suz from:pf-suz) (fled vas))
      [[%fund %proj *] *]  (emil (handle-fake-on-rock:pj-suz msg))
      [[%fund %meta *] *]  (emil (handle-fake-on-rock:me-suz msg))
      [[%fund %prof *] *]  (emil (handle-fake-on-rock:pf-suz msg))
    ==
  ::
      %sss-to-pub
    ?-  msg=!<($%(into:pj-puz into:me-puz into:pf-puz) (fled vas))
      [[%fund %proj *] *]  (proj-push (apply:pj-puz msg))
      [[%fund %prof *] *]  (prof-push (apply:pf-puz msg))
    ::
        [[%fund %meta *] *]
      ::  NOTE: First-time subs to the meta for a project are often upgrading
      ::  ships for which the host/worker may be missing the profile
      =*  pro  pro:(pj-abed:pj-core (flag:meta:fd path.msg))
      =?  cor  (~(has in ~(whos pj:fj pro)) src.bol)
        (toggle-profs:action & (silt [src.bol]~))
      (meta-push (apply:me-puz msg))
    ==
  ::
      %sss-surf-fail
    =-  ~?(!<(? (slot:config %debug)) "%fund: failed to sub to {-}" cor)
    ?-  msg=!<($%(fail:pj-suz fail:me-suz fail:pf-suz) (fled vas))
      [[%fund %proj *] *]  "%proj {(flag:enjs:ff:fh (flag:proj:fd -.msg))}"
      [[%fund %meta *] *]  "%meta {(flag:enjs:ff:fh (flag:meta:fd -.msg))}"
      [[%fund %prof *] *]  "%prof {<(flag:prof:fd -.msg)>}"
    ==
  ::
      %sss-proj
    =/  res  !<(into:pj-suz (fled vas))
    pj-abet:(pj-pull:(pj-abed:pj-core (flag:proj:fd path.res)) res)
  ::
      %sss-meta
    =/  res  !<(into:me-suz (fled vas))
    me-abet:(me-pull:(me-abed:me-core (flag:meta:fd path.res)) res)
  ::
      %sss-prof
    =/  res  !<(into:pf-suz (fled vas))
    pf-abet:(pf-pull:(pf-abed:pf-core (flag:prof:fd path.res)) res)
  ::  http pokes  ::
      %handle-http-request
    =+  !<(ord=order:rudder vas)
    =/  vaz=(list card)
      ?:  |(!=(our src):bol ?=([%asset *] (slag:derl:ff:fh url.request.ord)))  ~
      [(active:vita-client bol)]~
    =-  cor(caz (welp (flop (welp kaz vaz)) caz), +.state dat)
    ^-  [kaz=(list card) dat=data:fd]
    %.  [bol ord +.state]
    %-  (steer:rudder data:fd diff:fd)
    :^  pagz  route:fh  (fours:rudder +.state)
    |=  dif=diff:fd
    ^-  $@(brief:rudder [brief:rudder (list card) data:fd])
    =-  ~?(!<(? (slot:config %debug)) bre [bre kaz dat])
    ^-  [bre=brief:rudder dat=data:fd kaz=(list card)]
    =/  aply
      |=  dif=diff:fd
      =+  kor=^^$(mar %fund-poke, vas !>(dif))
      [+.state.kor (scag (sub (lent caz.kor) (lent caz)) caz.kor)]
    :-  (crip (poke:enjs:ff:fh dif))
    ?+    -.dif  (aply dif)
        %proj
      ?:  |(?=(?(%join %exit %lure) -.q.dif) =(p.p.dif our.bol))  (aply dif)
      [+.state [(pj-mk-card:(pj-abed:pj-core p.dif) p.p.dif q.dif)]~]
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
      [%x %view ~]
    =+  flat=(cork flag:enjs:ff:fh crip)
    :^  ~  ~  %noun  !>
    :*  host=(~(run in ~(key by pj-myn)) flat)
        fave=(~(run in favorites:pro:(pf-abed:pf-core our.bol)) flat)
        meta=(~(run in ~(key by me-our)) flat)
        prof=(~(run in ~(key by pf-our)) (cury scot %p))
    ==
  ::
      [%u %proj sip=@ nam=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ``loob+!>((~(has by pj-our) sip nam))
  ::
      [%x %proj sip=@ nam=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ``noun+!>((bind (~(get by pj-our) sip nam) head))
  ::
      [%u %meta sip=@ nam=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ``loob+!>((~(has by me-our) sip nam))
  ::
      [%x %meta sip=@ nam=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ``noun+!>((bind (~(get by me-our) sip nam) head))
  ::
      [%u %prof sip=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    ``loob+!>((~(has by pf-our) sip))
  ::
      [%x %prof sip=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    ``noun+!>((bind (~(get by pf-our) sip) head))
  ::
      [%x %prof sip=@ %adrz ~]
    =/  sip=@p    (slav %p sip.pat)
    =+  waz=pf-pf-walz:(pf-abed:pf-core sip)
    ``noun+!>(~(tap in ~(key by waz)))
  ::
      [%x %prof sip=@ %addr adr=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    =/  adr=@ux   (slav %ux adr.pat)  ::  (addr:dejs:ff:fh adr.pat)
    =+  waz=pf-pf-walz:(pf-abed:pf-core sip)
    ``noun+!>((~(get by waz) adr))
  ==
::
++  agent
  |=  [pat=(pole knot) syn=sign-gall]
  ^+  cor
  ?+    pat  cor
  ::  sss responses  ::
    [~ %sss %on-rock @ @ @ %fund %proj @ @ ~]        (proj-pull ~ (chit:pj-suz |3:pat syn))
    [~ %sss %scry-request @ @ @ %fund %proj @ @ ~]   (proj-pull (tell:pj-suz |3:pat syn))
    [~ %sss %scry-response @ @ @ %fund %proj @ @ ~]  (proj-push (tell:pj-puz |3:pat syn))
    [~ %sss %on-rock @ @ @ %fund %meta @ @ ~]        (meta-pull ~ (chit:me-suz |3:pat syn))
    [~ %sss %scry-request @ @ @ %fund %meta @ @ ~]   (meta-pull (tell:me-suz |3:pat syn))
    [~ %sss %scry-response @ @ @ %fund %meta @ @ ~]  (meta-push (tell:me-puz |3:pat syn))
    [~ %sss %on-rock @ @ @ %fund %prof @ ~]          (prof-pull ~ (chit:pf-suz |3:pat syn))
    [~ %sss %scry-request @ @ @ %fund %prof @ ~]     (prof-pull (tell:pf-suz |3:pat syn))
    [~ %sss %scry-response @ @ @ %fund %prof @ ~]    (prof-push (tell:pf-puz |3:pat syn))
  ::  config responses  ::
      [%fund %vita ~]
    ?>  ?=(%poke-ack -.syn)
    ?~  p.syn  cor(init.state &)
    ((slog u.p.syn) cor)
  ::  pals responses  ::
      [%fund %pals ~]
    ?+    -.syn  cor
    ::  watch response  ::
        %watch-ack
      ?~  p.syn  cor
      ((slog u.p.syn) cor)
    ::  watch update response  ::
        %fact
      ?.  ?=(%pals-effect p.cage.syn)  cor
      =+  !<(pef=effect:p q.cage.syn)
      ?+  -.pef  cor
        %meet  (toggle-profs:action & (silt [ship.pef]~))
        %part  (toggle-profs:action | (silt [ship.pef]~))
      ==
    ==
  ::  proj responses  ::
      [%fund %proj sip=@ nam=@ pat=*]
    =/  sip=@p    (slav %p sip.pat)
    =/  nam=@tas  (slav %tas nam.pat)
    ?+    pat.pat  cor
    ::  proxy response  ::
        ~
      ?>  ?=(%poke-ack -.syn)
      ?~  p.syn  cor
      ((slog u.p.syn) cor)
    ::  scan response  ::
        [%scan typ=@ ~]
      ?>  =(our.bol sip)
      ?>  ?=(?(%with %depo) typ.pat.pat)
      ?+    -.syn  cor
      ::  init response  ::
          %poke-ack
        ?^  p.syn  ((slog u.p.syn) cor)
        %-  emit
        :*  %pass   pat
            %agent  [our.bol %fund-watcher]
            %watch  [%logs pat]
        ==
      ::  watch response  ::
          %watch-ack
        ?~  p.syn  cor
        ((slog u.p.syn) cor)
      ::  watch update response  ::
          %fact
        ?.  ?=(%fund-watcher-diff p.cage.syn)  cor
        =+  !<(dif=diff:fc q.cage.syn)
        ::  TODO: Handle the %disavow case properly
        =/  loz=loglist:fc  ?+(-.dif loglist.dif %disavow ~)
        ::  NOTE: We group by transaction for multisend cases (which
        ::  always occur for withdrawals), which pack multiple
        ::  transfers into one atomic transaction
        =/  xap=(map xact:f (list [addr:f cash:f]))
          %+  roll  loz
          |=  [nex=event-log:rpc:ethereum:fc acc=(map xact:f (list [addr:f cash:f]))]
          =/  act=xact:f  [block-number transaction-hash]:(need mined.nex)
          =/  who=addr:f  (snag ?-(typ.pat.pat %depo 1, %with 2) `(list @ux)`topics.nex)
          =/  cas=cash:f  `@ud`(addr:dejs:ff:fh data.nex)
          (~(put by acc) act [[who cas] (~(gut by acc) act ~)])
        =/  xaz=(list [xact:f cash:f (set addr:f)])
          %-  ~(rep by xap)
          |=  [[act=xact:f fez=(list [addr:f cash:f])] acc=(list [xact:f cash:f (set addr:f)])]
          :_  acc
          :-  act
          %+  roll  fez
          |=  [[nea=addr:f nec=cash:f] [acc=cash:f acs=(set addr:f)]]
          [(add nec acc) (~(put in acs) nea)]
        %-  emil
        %+  turn  xaz
        |=  [act=xact:f cas=cash:f adz=(set addr:f)]
        ^-  card
        =*  por  (pj-abed:pj-core sip nam)
        =-  (pj-mk-card:por sip [%mula %pruf zip cas [act adr] typ.pat.pat])
        ^-  [zip=(unit @p) adr=addr:f]
        ?-  typ.pat.pat
          %depo  [~ (head ~(tap in adz))]
          ::  FIXME: Assumes that all withdrawals (including refunds)
          ::  are prompted by the worker.
          %with  [~ work:(need contract:pro:por)]
          ::    %with
          ::  =/  wok=addr:f  work:(need contract:pro:por)
          ::  ?:((~(has in adz) wok) [`sip wok] [~ (head ~(tap in adz))])
        ==
      ==
    ==
  ==
::
++  arvo
  |=  [pat=(pole knot) syn=sign-arvo]
  ^+  cor
  ?+    pat  cor
      [%fund %prof %update ~]
    ?+    syn  cor
        [%behn %wake *]
      ?^  error.syn  ((slog u.error.syn) cor)
      ~?  !<(? (slot:config %debug))   "%fund: updating profile"
      renew-surl:action
    ==
  ==
::
++  open
  ^+  cor
  =/  old=?  !(~(has by pf-myn) our.bol)
  =.  cor  renew-surl:action
  =.  cor  watch-pals:action
  =?  cor  old  renew-projs:action
  cor
++  action
  |%
  ++  open-eyre                                  ::  open up HTTP %eyre channel
    ^+  cor
    %-  emit
    :*  %pass     /eyre/connect
        %arvo     %e
        %connect  `/apps/[dap.bol]  dap.bol
    ==
  ++  watch-pals                                 ::  watch %pals /targets endpoint
    ^+  cor
    ?:  (~(has by wex.bol) /fund/pals our.bol %pals)  cor
    %-  emit
    :*  %pass   /fund/pals
        %agent  [our.bol %pals]
        %watch  /targets
    ==
  ++  renew-surl                                 ::  update ship url
    ^+  cor
    =.  cor  pf-abet:(pf-push:(pf-abed:pf-core our.bol) [%surl (crip (burl:fh bol))])
    =/  wyr=path  /fund/prof/update
    =-  %-  emil
        ;:  welp
            (turn tyz |=([t=@da duct] [%pass wyr %arvo %b %rest t]))
            [%pass wyr %arvo %b %wait (add now.bol !<(@dr (slot:config %uprl-herz)))]~
        ==
    ^-  tyz=(list [@da duct])
    %+  skim  .^((list [@da duct]) %bx (en-beam [our.bol %$ da+now.bol] /debug/timers))
    |=  [tym=@da duc=duct]
    %+  lien  duc
    |=  pat=path
    ?&  ?=(^ (find wyr pat))
        ?=(^ (find /gall/use/fund pat))
    ==
  ++  renew-projs                                ::  invoke project level triggers
    ^+  cor
    =/  lis=(list flag:f)  ~(tap in ~(key by pj-our))
    |-
    ?~  lis  cor
    %=  $
      lis  t.lis
    ::
        cor
      ?.  =(p.i.lis our.bol)  pj-abet:(pj-abed:pj-core i.lis)
      pj-abet:(pj-push:(pj-abed:pj-core i.lis) [%redo ~])
    ==
  ++  toggle-profs                               ::  toggle profile follow status
    |=  [ahn=? siz=(set @p)]
    ^+  cor
    =/  lis=(list @p)  ~(tap in siz)
    |-
    ?~  lis  cor
    =/  pod=prod:prof:f  ?:(ahn [%join ~] [%exit ~])
    $(cor pf-abet:(pf-push:(pf-abed:pf-core i.lis) pod), lis t.lis)
  --
::
++  pj-core
  |_  [lag=flag:f pro=proj:proj:f gon=_|]
  ++  pj-core  .
  ++  pj-abet
    =.  pro  -:(~(gut by pj-our) lag *prej:proj:f)
    =?  pj-core  &(pj-is-myn !?=(?(%born %prop) ~(stat pj:fj pro)))
      (pj-me-push [%init pj-me-met])
    =?  pj-core  gon
      (pj-pf-push [%jilt lag])
    =?  cor  &(pj-is-myn !gon)
      (toggle-profs:action & ~(whos pj:fj pro))
    =?  pj-core  &(pj-is-myn gon)
      (pj-me-push [%drop ~])
    cor
  ++  pj-abed
    |=  lag=flag:f
    %=  pj-core
      lag  lag
      pro  -:(~(gut by pj-our) lag *prej:proj:f)
    ==
  ::
  ++  pj-is-myn  =(our.bol p.lag)
  ++  pj-is-new  !(~(has by pj-our) lag)
  ++  pj-pa-pub  [%fund %proj (scot %p p.lag) q.lag ~]
  ++  pj-pa-sub  [p.lag dap.bol %fund %proj (scot %p p.lag) q.lag ~]
  ++  pj-me-met
    ^-  meta:meta:f
    :*  title=title.pro
        image=image.pro
        cost=~(cost pj:fj pro)
        currency=currency.pro
        launch=p:xact:(fall contract.pro *oath:f)
        worker=p.lag
        oracle=p.assessment.pro
    ==
  ::
  ++  pj-pj-bloq
    ^-  @
    =/  pre=path  (en-beam [our.bol %fund-watcher da+now.bol] /)
    =/  pat=path  (welp pj-pa-pub /scan/depo)
    =+  .^(pap=(map path *) %gx (welp pre /dogs/configs/noun))
    ?.((~(has by pap) pat) 0 .^(@ %gx :(welp pre /block pat /atom)))
  ++  pj-pj-push
    |=  pod=prod:proj:f
    ^+  pj-core
    pj-core(cor (proj-push (give:pj-puz pj-pa-pub *vers:lake:proj:fd bol lag pod)))
  ++  pj-me-push
    |=  pod=prod:meta:f
    ^+  pj-core
    pj-core(cor me-abet:(me-push:(me-abed:me-core lag) pod))
  ++  pj-pf-push
    |=  pod=prod:prof:f
    ^+  pj-core
    pj-core(cor pf-abet:(pf-push:(pf-abed:pf-core our.bol) pod))
  ++  pj-mk-card
    |=  [who=@p pod=prod:proj:f]
    ^-  card
    :*  %pass   pj-pa-pub
        %agent  [who dap.bol]
        %poke   fund-poke+!>([%proj lag pod])
    ==
  ++  pj-mk-scan
    |=  oat=(unit oath:f)
    ^-  (list card)
    =+  oaf=(fall (clap oat contract.pro head) *oath:f)
    %-  zing
    %+  turn  (scan-cfgz:fc oaf currency.pro)
    |=  [suf=path cfg=config:fc]
    ^-  (list card)
    =/  pat=path  (welp pj-pa-pub suf)
    =+  car=[%pass pat %agent [our.bol %fund-watcher] act=~]
    ;:  welp
        ?.((~(has by wex.bol) pat our.bol %fund-watcher) ~ [car(act [%leave ~])]~)
        [car(act [%poke %fund-watcher-poke !>([%watch pat cfg])])]~
    ==
  ::
  ++  pj-do-read
    |=  pod=prod:proj:f
    ^-  bean
    ::  FIXME: Everything is public
    %.y
  ++  pj-do-writ
    |=  pod=prod:proj:f
    ^-  bean
    ::  FIXME: Fairly intuitive yet hilariously obtuse
    =-  (gte hav ned)
    :-  ^-  hav=perm:f
        ?:  =(p.lag src.bol)  %boss
        ::  FIXME: Including company point here is a hack for the Gnosis
        ::  Safe arch and should be removed in the future versions
        =+  pyr=(sy ~[p.assessment.pro !<(@p (slot:config %point))])
        ?:  (~(has in pyr) src.bol)  %peer
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
  ++  pj-pull
    |=  res=into:pj-suz
    ^+  pj-core
    ?<  pj-is-myn
    ?:  ?|  ?=(%tomb what.res)
            &(?=(%wave what.res) ?=(%exit -.q.pok.wave.res))
        ==
      pj-core(cor (proj-pull ~ (quit:pj-suz pj-pa-sub)), gon &)
    pj-core(cor (proj-pull (apply:pj-suz res)))
  ++  pj-push
    |=  pod=prod:proj:f
    ^+  pj-core
    =*  mes  `(mess:f prod:proj:f)`[src.bol pj-pa-pub pod]
    ?+    -.pod
    ::  proj prods ::
      ?.  pj-is-myn  pj-core(cor (emit (pj-mk-card p.lag pod)))
      ?>  ~|(bad-pj-push+mes (pj-do-writ pod))
      ?>  ~|(bad-pj-push+mes |(?=(?(%init %drop) -.pod) !pj-is-new))
      ?+    -.pod  (pj-pj-push pod)
          %init
        =?  cor  pj-is-new  (proj-push (public:pj-puz [pj-pa-pub]~))
        (pj-pj-push pod)
      ::
          %drop
        =?  cor  !pj-is-new  (proj-push (kill:pj-puz [pj-pa-pub]~))
        pj-core(gon &)
      ::
          %draw
        (pj-pj-push pod(p.dif pj-pj-bloq))
      ::
          %redo
        =?  cor  !?=(?(%born %prop) ~(stat pj:fj pro))  (emil (pj-mk-scan ~))
        (pj-pj-push pod)
      ::
          %mula
        ::  NOTE: The `+wash:lake` function cannot contain any scries,
        ::  so the `fund` app needs to filter incoming pokes with block
        ::  timings and adjust them to the local time
        ::  NOTE: Because the ship's latest block is used when
        ::  receiving a %mula, it can differ from the final `%pruf`'s
        ::  block number (there are no issues with this)
        ?-  +<.pod
            %pruf
          (pj-pj-push ?:(=(our src):bol pod pod(p.xact.when pj-pj-bloq)))
        ::
            %plej
          =.  pj-core  (pj-pj-push pod(when pj-pj-bloq))
          =-  pj-core(cor (emit -))
          (pj-mk-card ship.pod [%lure ship.pod %fund])
        ::
            %trib
          =.  pj-core  (pj-pj-push pod(p.xact.when pj-pj-bloq))
          ?~  ship.pod  pj-core
          =-  pj-core(cor (emit -))
          (pj-mk-card u.ship.pod [%lure u.ship.pod %fund])
        ==
      ::
          %bump
        =.  pj-core  (pj-pj-push pod)
        ?+    sat.pod  pj-core
            %prop
          =-  pj-core(cor (emit -))
          (pj-mk-card p.assessment.pro [%lure p.assessment.pro %orac])
        ::
            %lock
          =-  pj-core(cor (emil -))
          (pj-mk-scan oat.pod)
        ==
      ==
    ::  meta prods ::
        %lure
      ::  FIXME: For a more complete version, maintain a per-ship lure
      ::  list (like group invites from %tlon)
      ?:  =(our.bol who.pod)  $(pod [%join ~])
      ?<  ~|(bad-pj-push+mes pj-is-new)
      pj-core(cor (emit (pj-mk-card ?:(pj-is-myn who.pod p.lag) pod)))
    ::  meta prods ::
        ?(%join %exit)
      ::  FIXME: Re-add this contraint once an invite mechanism is
      ::  in place (see %lure clause above).
      ::  ?>  ~|(bad-meta+mes pj-is-src)
      ?:  pj-is-myn  pj-core
      ?-  -.pod
        %join  ?.(pj-is-new pj-core pj-core(cor (proj-pull (surf:pj-suz pj-pa-sub))))
        %exit  ?:(pj-is-new pj-core pj-core(cor (proj-pull ~ (quit:pj-suz pj-pa-sub)), gon &))
      ==
    ==
  --
::
++  me-core
  |_  [lag=flag:f met=meta:meta:f gon=_|]
  ++  me-core  .
  ++  me-abet  cor
  ++  me-abed
    |=  lag=flag:f
    %=  me-core
      lag  lag
      met  -:(~(gut by me-our) lag *mete:meta:f)
    ==
  ::
  ++  me-is-myn  =(our.bol p.lag)
  ++  me-is-new  !(~(has by me-our) lag)
  ++  me-pa-pub  [%fund %meta (scot %p p.lag) q.lag ~]
  ++  me-pa-sub  [p.lag dap.bol %fund %meta (scot %p p.lag) q.lag ~]
  ::
  ++  me-pull
    |=  res=into:me-suz
    ^+  me-core
    ?<  me-is-myn
    ?:  ?|  ?=(%tomb what.res)
            &(?=(%wave what.res) ?=(%exit -.q.pok.wave.res))
        ==
      me-core(cor (meta-pull ~ (quit:me-suz me-pa-sub)))
    me-core(cor (meta-pull (apply:me-suz res)))
  ++  me-push
    |=  pod=prod:meta:f
    ^+  me-core
    =*  mes  `(mess:f prod:meta:f)`[src.bol me-pa-pub pod]
    ?+    -.pod
    ::  meta prods ::
      ?>  ~|(bad-me-push+mes me-is-myn)
      ?-    -.pod
          %init
        =?  cor  me-is-new  (meta-push (public:me-puz [me-pa-pub]~))
        ::  NOTE: Only prompt a push if new information is being provided
        =?  cor  !=(met met.pod)
          (meta-push (give:me-puz me-pa-pub *vers:lake:meta:fd bol lag pod))
        me-core
      ::
          %drop
        =?  cor  !me-is-new  (meta-push (kill:me-puz [me-pa-pub]~))
        me-core
      ==
    ::  meta prods ::
        ?(%join %exit)
      ::  ?>  ~|(bad-meta+mes me-is-src)
      ?:  me-is-myn  me-core
      ?-  -.pod
        %join  ?.(me-is-new me-core me-core(cor (meta-pull (surf:me-suz me-pa-sub))))
        %exit  ?:(me-is-new me-core me-core(cor (meta-pull ~ (quit:me-suz me-pa-sub)), gon &))
      ==
    ==
  --
::
++  pf-core
  |_  [sip=@p pro=prof:prof:f lad=(map addr:f sigm:f) gon=_|]
  ++  pf-core  .
  ++  pf-abet
    ^+  cor
    =.  pro  -:(~(gut by pf-our) sip *pref:prof:f)
    =.  adrz-loql.state  (~(put by adrz-loql.state) sip lad)
    =/  old=(set flag:f)  (~(get ju p2f.meta-srcs.state) sip)
    ::  NOTE: We refresh everything here for a "level triggering" effect
    ::  that causes profile metadata subs to be refreshed when "favorites" change
    =.  meta-srcs.state
      :_  (~(del by p2f.meta-srcs.state) sip)
      =<  +  %^  spin  ~(tap in (~(get ju p2f.meta-srcs.state) sip))  f2p.meta-srcs.state
      |=([n=flag:f a=(jug flag:f @p)] [n (~(del ju a) n sip)])
    =?  meta-srcs.state  &(!gon |(pf-is-myn pf-is-pals))
      :_  (~(gas ju p2f.meta-srcs.state) (turn ~(tap in favorites.pro) (lead sip)))
      (~(gas ju f2p.meta-srcs.state) (turn ~(tap in favorites.pro) (late sip)))
    =/  new=(set flag:f)  (~(get ju p2f.meta-srcs.state) sip)
    =/  joz=(list flag:f)  ~(tap in new)  ::  FIXME: Join all to fix peer upgrades
    ::  =/  joz=(list flag:f)  ~(tap in (~(dif in new) old))
    =.  pf-core  |-(?~(joz pf-core $(pf-core (pf-me-push i.joz [%join ~]), joz t.joz)))
    =/  exz=(list flag:f)  ~(tap in (~(dif in old) new))
    =.  pf-core  |-(?~(exz pf-core $(pf-core (pf-me-push i.exz [%exit ~]), exz t.exz)))
    cor
  ::
  ++  pf-abed
    |=  sip=@p
    %=  pf-core
      sip  sip
      pro  -:(~(gut by pf-our) sip *pref:prof:f)
      lad  (~(gut by adrz-loql.state) sip *_lad)
    ==
  ::
  ++  pf-is-myn  =(our.bol sip)
  ++  pf-is-new  !(~(has by pf-our) sip)
  ++  pf-pa-pub  [%fund %prof (scot %p sip) ~]
  ++  pf-pa-sub  [sip dap.bol %fund %prof (scot %p sip) ~]
  ::
  ++  pf-pf-walz
    ^-  (map addr:f sigm:f)
    (~(uni by wallets.pro) lad)
  ++  pf-me-push
    |=  [lag=flag:f pod=prod:meta:f]
    ^+  pf-core
    pf-core(cor me-abet:(me-push:(me-abed:me-core lag) pod))
  ++  pf-is-pals
    ^-  bean
    =+  .^(dex=rock:tire:clay %cx (en-beam [our.bol %$ da+now.bol] /tire))
    ?~  dek=(~(get by dex) %pals)  |
    ?.  ?=(%live zest.u.dek)  |
    =+  .^(taz=(set ship) %gx (en-beam [our.bol %pals da+now.bol] /targets/noun))
    (~(has in taz) sip)
  ::
  ++  pf-pull
    |=  res=into:pf-suz
    ^+  pf-core
    ?<  pf-is-myn
    ?:  ?|  ?=(%tomb what.res)
            &(?=(%wave what.res) ?=(%exit -.q.pok.wave.res))
        ==
      pf-core(cor (prof-pull ~ (quit:pf-suz pf-pa-sub)), gon &)
    pf-core(cor (prof-pull (apply:pf-suz res)))
  ++  pf-push
    |=  pod=prod:prof:f
    ^+  pf-core
    =*  mes  `(mess:f prod:prof:f)`[src.bol pf-pa-pub pod]
    ?+    -.pod
    ::  prof prods ::
      ::  NOTE: Signs directed at a foreign ship are handled specially; we allow
      ::  these to be placed in a local cache
      ?:  &(?=(%sign -.pod) !pf-is-myn)
        ?>  (csig:pf:fp sip sig.pod)
        pf-core(lad (~(put by lad) from.sig.pod sig.pod))
      ?>  ~|(bad-pf-push+mes pf-is-myn)
      =?  cor  pf-is-new  (prof-push (public:pf-puz [pf-pa-pub]~))
      ::  NOTE: Only prompt a push if new information is being provided
      =-  =?  cor  new  (prof-push (give:pf-puz pf-pa-pub *vers:lake:prof:fd bol sip pod))
          pf-core
      ^-  new=?
      ?-  -.pod
        %sign  !(~(has by wallets.pro) from.sig.pod)
        %surl  !=(url.pod ship-url.pro)
        %fave  !(~(has in favorites.pro) lag.pod)
        %jilt  (~(has in favorites.pro) lag.pod)
      ==
    ::  meta prods ::
        ?(%join %exit)
      ::  FIXME: Re-add this contraint once an invite mechanism is
      ::  in place (see %lure clause above).
      ::  ?>  ~|(bad-meta+mes pf-is-src)
      ?:  pf-is-myn  pf-core
      ?-  -.pod
        %join  ?.(pf-is-new pf-core pf-core(cor (prof-pull (surf:pf-suz pf-pa-sub))))
        %exit  ?:(pf-is-new pf-core pf-core(cor (prof-pull ~ (quit:pf-suz pf-pa-sub)), gon &))
      ==
    ==
  --
--
