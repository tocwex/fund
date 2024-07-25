/-  f=fund
/-  fd=fund-data, fd-1=fund-data-1, fd-0=fund-data-0
/+  fh=fund-http, fc=fund-chain
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
=<  =-  ?.  !<(bean (slot:config %debug))  -
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
::
++  abet  [(flop caz) state]
++  cor   .
++  emit  |=(c=card cor(caz [c caz]))
++  emil  |=(c=(list card) cor(caz (welp (flop c) caz)))
++  give  |=(g=gift:agent:gall (emit %give g))
++  proj-pull  |=([c=(list card) s=_proj-subs] =.(proj-subs s (emil c)))
++  proj-push  |=([c=(list card) p=_proj-pubs] =.(proj-pubs p (emil c)))
++  prof-pull  |=([c=(list card) s=_prof-subs] =.(prof-subs s (emil c)))
++  prof-push  |=([c=(list card) p=_prof-pubs] =.(prof-pubs p (emil c)))
::
++  init
  ^+  cor
  =.  cor  open-eyre:action
  =.  cor  update-prof:action
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
    ::  TODO: Populate profile and meta here...!
    ::  For profile, get the latest local URL and
    ::  For metadata, take all projects and extract profile data, using
    ::  the same flag as existing
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
    ~?  !<(bean (slot:config %debug))   pok
    ?+    -.pok  cor
        %fund
      %-  emit
      :*  %pass   /fund/vita
          %agent  [our.bol dap.bol]
          %poke   vita-client+!>([%set-enabled sat.pok])
      ==
    ::
        %proj
      =/  [lag=flag:f pod=prod:proj:f]  +.pok
      pj-abet:(pj-push:(pj-abed:pj-core lag) pod)
    ::
        %prof
      =/  [sip=@p pod=prod:prof:f]  +.pok
      pf-abet:(pf-push:(pf-abed:pf-core sip) pod)
    ==
  ::  sss pokes  ::
      %sss-on-rock
    ?-  msg=!<($%(from:pj-suz from:pf-suz) (fled vas))
      [[%fund *] *]  cor
    ==
  ::
      %sss-fake-on-rock
    ?-  msg=!<($%(from:pj-suz from:pf-suz) (fled vas))
      [[%fund %proj *] *]  (emil (handle-fake-on-rock:pj-suz msg))
      [[%fund %prof *] *]  (emil (handle-fake-on-rock:pf-suz msg))
    ==
  ::
      %sss-to-pub
    ?-  msg=!<($%(into:pj-puz into:pf-puz) (fled vas))
      [[%fund %proj *] *]  (proj-push (apply:pj-puz msg))
      [[%fund %prof *] *]  (prof-push (apply:pf-puz msg))
    ==
  ::
      %sss-proj
    =/  res  !<(into:pj-suz (fled vas))
    pj-abet:(pj-pull:(pj-abed:pj-core (flag:proj:fd path.res)) res)
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
    =-  ~?(!<(bean (slot:config %debug)) bre [bre kaz dat])
    ^-  [bre=brief:rudder dat=data:fd kaz=(list card)]
    :-  (crip (poke:enjs:ff:fh dif))
    =+  sip=?+(-.dif p.p.dif %fund our.bol, %prof p.dif)
    ?:  =(sip our.bol)
      =+  kor=^$(mar %fund-poke, vas !>(dif))
      [+.state.kor (scag (sub (lent caz.kor) (lent caz)) caz.kor)]
    :-  +.state
    ?+  -.dif  ~
      %proj    [(pj-mk-car:(pj-abed:pj-core p.dif) p.p.dif q.dif)]~
      ::  NOTE: Since the only cross-ship $prof pokes are %join and
      ::  %exit, we always direct the cards back at this ship
      %prof    [(pf-mk-car:(pf-abed:pf-core p.dif) our.bol q.dif)]~
      ::  %meta
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
      [%u %prof sip=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    ``loob+!>((~(has by pf-our) sip))
  ::
      [%x %prof sip=@ ~]
    =/  sip=@p    (slav %p sip.pat)
    ``noun+!>((bind (~(get by pf-our) sip) head))
  ::
      [%x %prof sip=@ adr=@ ~]  ::  %u-esque %x endpoint for HTTP API
    =/  sip=@p    (slav %p sip.pat)
    =/  adr=@ux   (addr:dejs:ff:fh adr.pat)
    =+  pre=(~(gut by pf-our) sip *pref:prof:f)
    ``loob+!>((~(has by wallets.pre) adr))
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
    [~ %sss %on-rock @ @ @ %fund %prof @ ~]          (prof-pull ~ (chit:pf-suz |3:pat syn))
    [~ %sss %scry-request @ @ @ %fund %prof @ ~]     (prof-pull (tell:pf-suz |3:pat syn))
    [~ %sss %scry-response @ @ @ %fund %prof @ ~]    (prof-push (tell:pf-puz |3:pat syn))
  ::  config responses  ::
      [%fund %vita ~]
    ?>  ?=(%poke-ack -.syn)
    ?~  p.syn  cor(init.state &)
    ((slog u.p.syn) cor)
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
        =-  (pj-mk-car:por sip [%mula %pruf ship=zip cash=cas when=[act adr] note=typ.pat.pat])
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
      ~?  !<(bean (slot:config %debug))   "%fund: updating profile"
      update-prof:action
    ==
  ==
::
++  open
  ^+  cor
  ::  TODO: Populate metadata for local projects publication here
  ::        (and also %pals projects, or %prof 'favorites'?)
  ::  TODO: Grab metadata from %pals here (using %prof data?)
  =.  cor  update-prof:action
  =.  cor  watch-profs:action
  =.  cor  watch-projs:action
  cor
++  action
  |%
  ++  update-prof
    ^+  cor
    =.  cor  pf-abet:(pf-push:(pf-abed:pf-core our.bol) [%surl (crip (burl:fh bol))])
    =/  wyr=path  /fund/prof/update
    =-  %-  emil
        ;:  welp
            (turn tyz |=([t=@da duct] [%pass wyr %arvo %b %rest t]))
            [%pass wyr %arvo %b %wait (add now.bol !<(@dr (slot:config %uprl-herz)))]~
        ==
    ^-  tyz=(list [@da duct])
    %+  skim  .^((list [@da duct]) %bx /(scot %p our.bol)//(scot %da now.bol)/debug/timers)
    |=  [tym=@da duc=duct]
    %+  lien  duc
    |=  pat=path
    ?&  ?=(^ (find wyr pat))
        ?=(^ (find /gall/use/fund pat))
    ==
  ++  open-eyre
    ^+  cor
    %-  emit
    :*  %pass     /eyre/connect
        %arvo     %e
        %connect  `/apps/[dap.bol]  dap.bol
    ==
  ++  watch-profs
    ^+  cor
    =-  |-
        ?~  siz  cor
        =.  cor  pf-abet:(pf-push:(pf-abed:pf-core i.siz) [%join ~])
        $(siz t.siz)
    ^-  siz=(list @p)
    %~  tap  in
    ^-  (set @p)
    %-  ~(rep by pj-myn)
    |=  [[flag:f pro=proj:proj:f lyv=?] acc=(set @p)]
    %-  ~(uni in acc)
    %-  silt
    ^-  (list @p)
    ;:  welp
        [p.assessment.pro]~
        (turn ~(val by pledges.pro) |=([p=plej:f *] ship.p))
        (murn ~(val by contribs.pro) |=([t=treb:f *] ship.t))
    ==
  ++  watch-projs
    ^+  cor
    =/  poz=(map flag:f proj:proj:f)             ::  post-%lock projects
      %-  ~(rep by pj-myn)
      |=  [[lag=flag:f pre=prej:proj:f] acc=(map flag:f proj:proj:f)]
      ?:(?=(?(%born %prop) status.i.milestones.pre) acc (~(put by acc) lag -.pre))
    =/  liz=(set flag:f)                         ::  live %fund-watcher flags
      %-  ~(rep by wex.bol)
      |=  [[[wire sip=@p dek=@tas] [ack=? pat=(pole knot)]] acc=(set flag:f)]
      ?.  ?&  =(sip our.bol)
              =(dek %fund-watcher)
              ack
              ?=([%logs %fund %proj sip=@ nam=@ %scan ?(%with %depo) ~] pat)
          ==
        acc
      (~(put in acc) (slav %p sip.pat) (slav %tas nam.pat))
    =/  waz=(set flag:f)  (~(dif in ~(key by poz)) liz)
    %-  emil  %-  zing
    %+  turn  ~(tap in waz)
    |=  lag=flag:f
    ^-  (list card)
    =/  pro=proj:proj:f  (~(got by poz) lag)
    %+  turn  (scan-cfgz:fc (need contract.pro) currency.pro)
    |=  [pat=path cfg=config:fc]
    =/  pax=path  (welp /fund/proj/(scot %p p.lag)/[q.lag] pat)
    ^-  card
    :*  %pass   pax
        %agent  [our.bol %fund-watcher]
        %poke   fund-watcher-poke+!>([%watch pax cfg])
    ==
  --
::
++  pj-core
  |_  [lag=flag:f pro=proj:proj:f]
  ++  pj-core  .
  ++  pj-abet  cor
  ++  pj-abed
    |=  lag=flag:f
    %=  pj-core
      lag  lag
      pro  -:(~(gut by pj-our) lag *prej:proj:f)
    ==
  ::
  ++  pj-is-myn  =(our.bol p.lag)
  ++  pj-is-src  =(our.bol src.bol)
  ++  pj-is-new  !(~(has by pj-our) lag)
  ++  pj-pu-pat  [%fund %proj (scot %p p.lag) q.lag ~]
  ++  pj-su-pat  [p.lag dap.bol %fund %proj (scot %p p.lag) q.lag ~]
  ::
  ++  pj-pj-boq
    =/  pre=path  /(scot %p our.bol)/fund-watcher/(scot %da now.bol)
    =/  pat=path  (welp pj-pu-pat /scan/depo)
    =+  .^(pap=(map path *) %gx (welp pre /dogs/configs/noun))
    ?.((~(has by pap) pat) 0 .^(@ %gx :(welp pre /block pat /atom)))
  ++  pj-mk-car
    |=  [who=@p pod=prod:proj:f]
    ^-  card
    :*  %pass   pj-pu-pat
        %agent  [who dap.bol]
        %poke   fund-poke+!>([%proj lag pod])
    ==
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
      pj-core(cor (proj-pull ~ (quit:pj-suz pj-su-pat)))
    pj-core(cor (proj-pull (apply:pj-suz res)))
  ++  pj-push
    |=  pod=prod:proj:f
    ^+  pj-core
    =*  mes  `(mess:f prod:proj:f)`[src.bol pj-pu-pat pod]
    =/  wash
      |=  [pod=prod:proj:f caz=(list card)]
      =.  cor  (proj-push (give:pj-puz pj-pu-pat *vers:lake:proj:fd bol lag pod))
      =.  cor  (emil caz)
      pj-core
    ?+    -.pod
    ::  proj prods ::
      ?.  pj-is-myn  pj-core(cor (emit (pj-mk-car p.lag pod)))
      ?>  ~|(bad-pj-push+mes (pj-do-writ pod))
      ?-    -.pod
          %init
        =?  cor  pj-is-new  (proj-push (public:pj-puz [pj-pu-pat]~))
        (wash pod ~)
      ::
          %drop
        =?  cor  !pj-is-new  (proj-push (kill:pj-puz [pj-pu-pat]~))
        pj-core
      ::
          ?(%bump %mula %blot %draw %wipe)
        ?<  ~|(bad-pj-push+mes pj-is-new)
        =-  (wash nod caz)
        ^-  [nod=prod:proj:f caz=(list card)]
        ?+    -.pod  [pod ~]
            %bump
          =+  ses=p.assessment.pro
          :-  pod
          ?+  sat.pod  ~
            ::  TODO: If this was sent by the user, also send cards to
            ::  close the project path to the retracted oracle
            %born  ?:(=(our.bol ses) ~ ~)
            %prop  [(pj-mk-car ses [%lure ses %orac])]~
          ::
              %lock
            ?~  oat.pod  ~
            %+  turn  (scan-cfgz:fc u.oat.pod currency.pro)
            |=  [pat=path cfg=config:fc]
            =/  pax=path  (welp pj-pu-pat pat)
            ^-  card
            :*  %pass   pax
                %agent  [our.bol %fund-watcher]
                %poke   fund-watcher-poke+!>([%watch pax cfg])
            ==
          ==
        ::
            %mula
          ::  NOTE: The `+wash:lake` function cannot contain any scries,
          ::  so the `fund` app needs to filter incoming pokes with block
          ::  timings and adjust them to the local time (for remote ships)
          ::  NOTE: Because the ship's latest block is used when
          ::  receiving a %mula, it can differ from the final `%pruf`'s
          ::  block number (there are no issues with this)
          ::  TODO: Add hark notifications and follow-up reminders for pledges
          ?-  +<.pod
            %pruf  [?:(pj-is-src pod pod(p.xact.when pj-pj-boq)) ~]
            %plej  [pod(when pj-pj-boq) [(pj-mk-car ship.pod [%lure ship.pod %fund])]~]
          ::
              %trib
            :-  pod(p.xact.when pj-pj-boq)
            ?~(ship.pod ~ [(pj-mk-car u.ship.pod [%lure u.ship.pod %fund])]~)
          ==
        ::
            %draw
          [pod(p.dif pj-pj-boq) ~]
        ==
      ==
    ::  meta prods ::
        %lure
      ::  FIXME: For a more complete version, maintain a per-ship lure
      ::  list (like group invites from %tlon)
      ?:  =(our.bol who.pod)  $(pod [%join ~])
      ?<  ~|(bad-pj-push+mes pj-is-new)
      pj-core(cor (emit (pj-mk-car ?:(pj-is-myn who.pod p.lag) pod)))
    ::  meta prods ::
        ?(%join %exit)
      ::  FIXME: Re-add this contraint once an invite mechanism is
      ::  in place (see %lure clause above).
      ::  ?>  ~|(bad-meta+mes pj-is-src)
      ?:  pj-is-myn  pj-core
      ?-    -.pod
          %join
        ?.  pj-is-new  pj-core
        pj-core(cor (proj-pull (surf:pj-suz pj-su-pat)))
      ::
          %exit
        ?:  pj-is-new  pj-core
        pj-core(cor (proj-pull ~ (quit:pj-suz pj-su-pat)))
      ==
    ==
  --
++  pf-core
  |_  [sip=@p pro=prof:prof:f]
  ++  pf-core  .
  ++  pf-abet  cor
  ++  pf-abed
    |=  sip=@p
    %=  pf-core
      sip  sip
      pro  -:(~(gut by pf-our) sip *pref:prof:f)
    ==
  ::
  ++  pf-is-myn  =(our.bol sip)
  ++  pf-is-src  =(our.bol src.bol)
  ++  pf-is-new  !(~(has by pf-our) sip)
  ++  pf-pu-pat  [%fund %prof (scot %p sip) ~]
  ++  pf-su-pat  [sip dap.bol %fund %prof (scot %p sip) ~]
  ::
  ++  pf-mk-car
    |=  [who=@p pod=prod:prof:f]
    ^-  card
    :*  %pass   pf-pu-pat
        %agent  [who dap.bol]
        %poke   fund-poke+!>([%prof sip pod])
    ==
  ::
  ++  pf-pull
    |=  res=into:pf-suz
    ^+  pf-core
    ?<  pf-is-myn
    ?:  ?|  ?=(%tomb what.res)
            &(?=(%wave what.res) ?=(%exit -.q.pok.wave.res))
        ==
      pf-core(cor (prof-pull ~ (quit:pf-suz pf-su-pat)))
    pf-core(cor (prof-pull (apply:pf-suz res)))
  ++  pf-push
    |=  pod=prod:prof:f
    ^+  pf-core
    =*  mes  `(mess:f prod:prof:f)`[src.bol pf-pu-pat pod]
    ?+    -.pod
    ::  prof prods ::
      ?>  ~|(bad-pf-push+mes pf-is-myn)
      =?  cor  pf-is-new  (prof-push (public:pf-puz [pf-pu-pat]~))
      pf-core(cor (prof-push (give:pf-puz pf-pu-pat *vers:lake:prof:fd bol sip pod)))
    ::  meta prods ::
        ?(%join %exit)
      ::  FIXME: Re-add this contraint once an invite mechanism is
      ::  in place (see %lure clause above).
      ::  ?>  ~|(bad-meta+mes pf-is-src)
      ?:  pf-is-myn  pf-core
      ?-    -.pod
          %join
        ?.  pf-is-new  pf-core
        pf-core(cor (prof-pull (surf:pf-suz pf-su-pat)))
      ::
          %exit
        ?:  pf-is-new  pf-core
        pf-core(cor (prof-pull ~ (quit:pf-suz pf-su-pat)))
      ==
    ==
  --
--
