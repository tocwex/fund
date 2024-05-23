/-  *fund
/+  fx=fund-xtra, tx=naive-transactions, config
|%
::
::  +filo: fill in an $odit by calculating `=need` (if required)
::
++  filo
  |=  odi=odit
  ^-  odit
  %_    odi
      void
    ?^  void.odi  void.odi
    `(sub:rl cost.odi (add:rl fill.odi plej.odi))
  ==
::
::  +tula: t(ime) associated with a $(m)ula (measured by block height)
::
++  tula
  |=  mul=mula
  ^-  bloq
  ?-  -.mul
    %plej  when.mul
    %trib  p.xact.when.mul
  ==
::
::  +csig: c(heck) (Ethereum EIP-191) sig(nature)
::
++  csig
  |=  sig=sigm
  ^-  bean
  =-  ?~(- | =(u.- from.sig))
  ^-  (unit @ux)
  =/  dat=tape  =+(t=(trip `@t`p.mesg.sig) ?-(-.mesg.sig %& t, %| (flop t)))
  =/  msg=tape  "\19Ethereum Signed Message:\0a{(a-co:co (met 3 p.mesg.sig))}{dat}"
  ::  FIXME: Should use +crip instead of +rep, but can't due to a bug in
  ::  +crip dealing with tapes containing \00 entries; see:
  ::  https://github.com/urbit/urbit/pull/6818
  =/  syg=octs  (as-octs:mimes:html (rep 3 msg))
  (verify-sig:tx sign.sig syg)
::
::  +rl: r(ea)l (library); helper core for $real data
::
++  rl
  =>  |%
      ++  dun  |=(a=fn `real`?>(?=(%f -.a) a))
      --
  |%
  ++  add  |:([a=[%f *? --0 0] b=[%f *? --0 0]] (dun (ead:fl a b)))
  ++  sub  |:([a=[%f *? --0 0] b=[%f *? --0 0]] (dun (ead:fl a (neg b))))
  ++  neg  |=(a=fn (dun ?-(-.a %f a(s !s.a), %i a(s !s.a), %n a)))
  ++  mul  (corl dun emu:fl)
  ++  div  (corl dun div:fl)
  ++  toi  (corl need toi:fl)
  ++  lth  (corl need lth:fl)
  ++  lte  (corl need lte:fl)
  ++  gth  (corl need gth:fl)
  ++  gte  (corl need gte:fl)
  ++  equ  (corl need equ:fl)
  ++  val
    |%
    ++  zer  [%f *? --0 0]
    ++  one  [%f *? -112 5.192.296.858.534.827.628.530.496.329.220.096]
    ++  hun  [%f *? -106 8.112.963.841.460.668.169.578.900.514.406.400]
    --
  --
::
::  +pj: p(ro)j(ect) (library); helper door for $proj data
::
++  pj
  |_  proj
  ::  FIXME: All the `wox=@p` function signatures will be simplified
  ::  once a project stores/supports multiple different workers
  +*  milestonez  `(list mile)`milestones
  ++  stat                                       ::  project-wide status
    ^-  ^stat
    status:mil:next
  ++  cost                                       ::  summed milestone costs
    ^-  real
    (roll (turn milestonez |=(n=mile cost.n)) add:rl)
  ++  plej                                       ::  summed pledge amounts
    ^-  real
    %+  roll  ~(val by pledges)
    |=([n=^plej a=real] (add:rl a cash.n))
  ++  fill                                       ::  project-wide cost fill
    ^-  real
    (roll (turn contribs |=(t=trib cash.t)) add:rl)
  ++  take                                       ::  project-wide claimed funds
    ^-  real
    %-  roll  :_  add:rl
    %-  turn  :_  |=(n=mile cost.n)
    %+  skim  milestonez
    |=(n=mile &(?=(%done status.n) ?=(^ withdrawal.n) ?=(^ xact.u.withdrawal.n)))
  ++  odit                                       ::  project-wide audit
    ^-  ^odit
    (filo [cost fill plej ~])
  ++  odim                                       ::  per-milestone audit
    ^-  (list ^odit)
    =/  lin=@  (dec (lent milestonez))
    =<  -  %^  spin  milestonez  [0 fill plej]
    |=  [mil=mile min=@ fre=real pre=real]
    =+  dun=&(?=(?(%done %dead) status.mil) ?=(^ withdrawal.mil))
    =+  end==(min lin)
    =+  fos=?:(!dun cost.mil cash:(need withdrawal.mil))
    =+  fil=?:(|(end (lte:rl fre fos)) fre fos)
    =+  pos=?:(!dun (sub:rl fos fil) [%f %.y --0 0])
    =+  pej=?:(|(end (lte:rl pre pos)) pre pos)
    [(filo [cost.mil fil pej ~]) +(min) (sub:rl fre fil) (sub:rl pre pej)]
  ++  mula                                       ::  project-wide $mula list
    ^-  (list ^mula)
    =-  (sort - |=([m=^mula n=^mula] (gth (tula m) (tula n))))
    %+  welp  (turn contribs |=(t=trib `^mula`[%trib t]))
    (turn ~(val by pledges) |=(p=^plej `^mula`[%plej p]))
  ++  next                                       ::  next active milestone
    ^-  [min=@ mil=mile]
    ::  NOTE: Provide index past last milestone when all are completed
    =-  ?^(- i.- [(lent milestonez) (rear milestonez)])
    %+  skip  (enum:fx milestonez)
    |=([@ n=mile] ?=(?(%done %dead) status.n))
  ++  rols                                       ::  project $role(s) of user
    |=  [wox=@p who=@p]
    ^-  (set role)
    %-  silt
    ;:  welp
        ?.(=(wox who) ~ [%work]~)
        ?.(=(p.assessment who) ~ [%orac]~)
        ?.  ?|  (~(has by pledges) who)
                (lien contribs |=(t=trib ?~(ship.t | =(u.ship.t who))))
            ==
          ~
        [%fund]~
    ==
  ++  oath                                       ::  text of assessment contract
    |=  wox=@p
    ^-  tape
    =-  "I, {<p.assessment>}, hereby agree to assess the following project proposed by {<wox>}:\0a\0a{-}"
    %-  roll  :_  |=([n=tape a=tape] ?~(a n :(welp a "\0a" n)))
    %+  weld
      ^-  (list tape)
      :~  "title: {(trip title)}"
          "oracle: {<p.assessment>} (for {(r-co:co (drg:fl q.assessment))}%)"
          "summary: {(trip summary)}"
      ==
    %+  turn  (enum:fx milestonez)
    |=  [min=@ mil=mile]
    ^-  tape
    %-  roll  :_  |=([n=tape a=tape] ?~(a n :(welp a "\0a\09" n)))
    ^-  (list tape)
    :~  "milestone #{<+(min)>}:"
        "title: {(trip title.mil)}"
        "cost: {(r-co:co (drg:fl cost.mil))}"
        "summary: {(trip summary.mil)}"
    ==
  --
::
::  +sss: structures/cores for peer-based synchronization (sss)
::
++  sss
  |%
  ::  +proj-flag: sss project path to project id flag
  ::
  ++  proj-flag
    |=  pat=path:proj
    ^-  flag
    [`@p`(slav %p sip.pat) `@tas`(slav %tas nam.pat)]
  ::
  ::  +proj-lake: schema for peer-based project synchronization
  ::
  ++  proj-lake
    |%
    ++  name  %proj
    +$  rock  rock:proj
    +$  wave  wave:proj
    ++  wash  proj-wash
    --
  ::
  ::  +proz-subs: state of sss-managed subscriptions
  ::
  ++  proz-subs
    |=  [bol=bowl:gall suz=_(mk-subs:^sss *lake:proj path:proj)]
    =/  da  (da:^sss proj-lake path:proj)
    (da suz bol -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
  ::
  ::  +proz-pubs: state of sss-managed publications
  ::
  ++  proz-pubs
    |=  [bol=bowl:gall puz=_(mk-pubs:^sss *lake:proj path:proj)]
    =/  du  (du:^sss proj-lake path:proj)
    (du puz bol -:!>(*result:du))
  ::
  ::  +prez-mine: the local-hosted $prez ($proz w/ peer connection data)
  ::
  ++  prez-mine
    |=  [bol=bowl:gall dat=dat-now]
    ^-  prez
    %-  ~(run by proz.dat)
    |=(p=proj `prej`[p &])
  ::
  ::  +prez-ours: local and remote $prez ($proz w/ peer connection data)
  ::
  ++  prez-ours
    |=  [bol=bowl:gall dat=dat-now]
    ^-  prez
    %-  ~(uni by (prez-mine bol dat))
    =<  -  %+  ~(rib by read:(proz-subs bol subs.dat))  *prez
    |=  [[k=[ship dude:gall p=path:proj] v=[s=? f=? p=proj]] a=prez]
    [(~(put by a) (proj-flag p.k) p.v &(!s.v !f.v)) k v]
  ::
  ::  +proj-wash: update function for project peer state deltas
  ::
  ++  proj-wash
    ::  TODO: Add useful error messages to all the various error cases
    |=  [pro=proj bol=bowl:gall lag=flag pod=prod]
    ^-  rock:proj
    =*  mes  `mess`[src.bol lag pod]
    =*  miz  `(list mile)`milestones.pro
    =>  |%
        ++  aver-work  |-(~|(bad-wash+mes ?>(=(our.bol src.bol) %.y)))
        ++  aver-orac  |-(~|(bad-wash+mes ?>(=(p.assessment.pro src.bol) %.y)))
        ++  edit-mile  |=([i=@ m=mile] %_(pro milestones ;;((lest mile) (snap miz i m))))
        ++  edit-milz  |=(t=$-(mile mile) %_(pro milestones ;;((lest mile) (turn miz t))))
        ++  good-sigm  |=([s=sigm w=(set addr)] &((~(has in w) from.s) (csig s)))
        ++  orac-sigm  |=(s=sigm =+((need contract.pro) (good-sigm s (sy [orac.-]~))))
        ++  team-sigm  |=(s=sigm =+((need contract.pro) (good-sigm s (sy ~[orac.- work.-]))))
        ++  peer-sigm  |=(s=sigm =+((need contract.pro) (good-sigm s (sy ~[orac.- work.- !<(addr (slot:config %sign-addr))]))))
        ++  dead-milz
          |=  oat=oath
          ?>  (team-sigm sigm.oat)
          %_    pro
              milestones
            ;;  (lest mile)
            =+  niz=(turn miz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
            %+  snoc  (snip niz)
            =+  mil=(rear niz)
            mil(withdrawal `[~ sigm.oat (sub:rl ~(fill pj pro) ~(take pj pro))])
          ==
        --
    =/  sat=stat  ~(stat pj pro)
    ?+    -.pod  pro
        %init
      ?>  aver-work
      ?>  =(%born sat)
      ?~  pro.pod  pro
      ?>  =(%born ~(stat pj u.pro.pod))
      ::  NOTE: For now, stars and galaxies only
      ?>  (star:fx p.assessment.u.pro.pod)
      u.pro.pod
    ::
        %bump
      =/  [min=@ mil=mile]  ~(next pj pro)
      ?:  ?=(%born status.mil)
        ?>  &(?=(%prop sat.pod) ?=(~ oat.pod))
        ?>  aver-work  ::  born=>prop:worker
        (edit-milz |=(m=mile m(status %prop)))
      ?:  ?=(%prop status.mil)
        ?>  ?|  &(?=(%born sat.pod) ?=(~ oat.pod))
                &(?=(?(%prop %lock) sat.pod) ?=(^ oat.pod))
            ==
        ?>  |(?=(?(%born %prop) sat.pod) aver-work)  ::  prop=>lock:worker
        ?>  |(?=(?(%born %lock) sat.pod) aver-orac)  ::  prop=>prop:oracle
        ?>  |(?=(?(%prop %lock) sat.pod) ?=(~ contract.pro) aver-work)  ::  prop=>born:worker(post-orac-accept)
        =.  contract.pro
          ?+  sat.pod  !!
              %born
            ~
          ::
              %prop
            =+  sig=sigm:(need oat.pod)
            ?>  =((trip `@t`p.mesg.sig) (~(oath pj pro) our.bol))
            ?>  (csig sig)
            =+(o=*oath `o(sigm sig))
          ::
              %lock
            =+  our-oat=(need contract.pro)
            =+  pod-oat=(need oat.pod)
            ?>  =(sigm.our-oat sigm.pod-oat)
            ?>  =(orac.pod-oat from.sigm.pod-oat)
            `pod-oat
          ==
        (edit-milz |=(m=mile m(status sat.pod)))
      ?:  ?=(%lock status.mil)
        ?:  ?=(%work sat.pod)
          ?>  aver-work  ::  lock=>work:worker
          (edit-mile min mil(status sat.pod))
        ?:  ?=(%dead sat.pod)
          (dead-milz (need oat.pod))
        ~|(bad-wash+mes !!)  ::  %lock =X=> ?(%born %prop %sess %done)
      ?:  ?=(?(%work %sess) status.mil)
        ?:  ?=(%work sat.pod)
          ?>  aver-orac  ::  work/sess=>work:oracle
          (edit-mile min mil(status sat.pod))
        ?:  ?=(%sess sat.pod)
          ?>  aver-work  ::  work/sess=>sess:worker
          (edit-mile min mil(status sat.pod))
        ?:  ?=(%done sat.pod)
          ?>  aver-orac  ::  work/sess=>done:oracle
          =/  sig=sigm  sigm:(need oat.pod)
          =/  mod=odit  (snag min ~(odim pj pro))
          ?>  (orac-sigm sig)
          (edit-mile min mil(status sat.pod, withdrawal `[~ sig fill.mod]))
        ?:  ?=(%dead sat.pod)
          (dead-milz (need oat.pod))
        ~|(bad-wash+mes !!)  ::  ?(%work %sess %done %dead) =X=> ?(%born %lock)
      ~|(bad-wash+mes !!)  ::  %dead =X=> status
    ::
        %mula
      ?<  ?=(?(%born %prop %done %dead) sat)
      ?>  (gth:rl cash.pod *real)
      ?-    +<.pod
          %plej
        ::  NOTE: This is a sufficient check because we only allow the
        ::  host of a project to accept donations on the project's behalf
        ::  (so src.bol must always be the %plej attestor; no forwarding!)
        ::  NOTE: Reinstate this check once POST requests directly apply
        ::  cards locally instead of forwarding them
        ?>  =(src.bol ship.pod)
        ?>  (plan:fx src.bol)
        ?<  (~(has by pledges.pro) ship.pod)
        %_(pro pledges (~(put by pledges.pro) ship.pod +>.pod))
      ::
          %trib
        =/  pol=(unit plej)  ?~(ship.pod ~ (~(get by pledges.pro) (need ship.pod)))
        ?>  |(?=(~ pol) =(cash.u.pol cash.pod))
        %_    pro
            pledges
          ?~  pol  pledges.pro
          (~(del by pledges.pro) (need ship.pod))
        ::
            contribs
          :_  contribs.pro
          %=  +>.pod  note
            ?.  =('' note.pod)  note.pod
            (fall (bind pol |=(p=plej note.p)) '')
          ==
        ==
      ==
    ::
        %draw
      =/  [min=@ mil=mile]  [min.pod (snag min.pod miz)]
      ?>  ?=(?(%dead %done) status.mil)
      ?>  |(?=(%done status.mil) =((lent miz) +(min)))
      ?>  ?=(^ withdrawal.mil)
      (edit-mile min mil(withdrawal `u.withdrawal.mil(xact `act.pod)))
    ::
        %wipe
      =/  [min=@ mil=mile]  [min.pod (snag min.pod miz)]
      ?>  ?=(?(%dead %done) status.mil)
      ?>  |(?=(%done status.mil) =((lent miz) +(min)))
      =/  mod=odit  (snag min ~(odim pj pro))
      ?~  sig.pod  (edit-mile min mil(withdrawal ~))
      ?>  (peer-sigm u.sig.pod)
      =+  fil=?:(?=(%done status.mil) fill.mod (sub:rl ~(fill pj pro) ~(take pj pro)))
      (edit-mile min mil(withdrawal `[~ u.sig.pod fil]))
    ==
  --
--
