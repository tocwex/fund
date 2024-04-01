/-  *fund
/+  fx=fund-xtra, tx=naive-transactions
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
    `(sub:rs cost.odi (add:rs fill.odi plej.odi))
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
  =/  syg=octs  (as-octs:mimes:html (crip msg))
  (verify-sig:tx sign.sig syg)
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
    ^-  @rs
    (roll (turn milestonez |=(n=mile cost.n)) add:rs)
  ++  plej                                       ::  summed pledge amounts
    ^-  @rs
    %+  roll  ~(val by pledges)
    |=([n=^plej a=@rs] (add:rs a cash.n))
  ++  fill                                       ::  project-wide cost fill
    ^-  @rs
    (roll (turn contribs |=(t=trib cash.t)) add:rs)
  ++  odit                                       ::  project-wide audit
    ^-  ^odit
    (filo [cost fill plej ~])
  ++  odim                                       ::  per-milestone audit
    ^-  (list ^odit)
    =/  lin=@  (dec (lent milestonez))
    =<  -  %^  spin  milestonez  [0 fill plej]
    |=  [mil=mile min=@ fre=@rs pre=@rs]
    =+  fos=?~(approval.mil cost.mil q.u.approval.mil)
    =+  fil=?:(|(=(min lin) (lte:rs fre fos)) fre fos)
    =+  pos=?~(approval.mil (sub:rs fos fil) .0)
    =+  pej=?:(|(=(min lin) (lte:rs pre pos)) pre pos)
    [(filo [cost.mil fil pej ~]) +(min) (sub:rs fre fil) (sub:rs pre pej)]
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
    =-  ;:  welp
            "I, {<p.assessment>}, hereby agree to assess the following project "
            "proposed by {<wox>}:\0a\0a{-}"
        ==
    %-  roll  :_  |=([n=tape a=tape] ?~(a n :(welp a "\0a" n)))
    %+  weld
      ^-  (list tape)
      :~  "title: {(trip title)}"
          "oracle: {<p.assessment>} (for {(r-co:co (rlys q.assessment))}%)"
          "summary: {(trip summary)}"
      ==
    %+  turn  (enum:fx milestonez)
    |=  [min=@ mil=mile]
    ^-  tape
    %-  roll  :_  |=([n=tape a=tape] ?~(a n :(welp a "\0a\09" n)))
    ^-  (list tape)
    :~  "milestone #{<+(min)>}:"
        "title: {(trip title.mil)}"
        "cost: {(r-co:co (rlys cost.mil))}"
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
        ++  edit-mile  |=([i=@ m=mile] %_(pro milestones ;;((lest mile) (snap miz i m))))
        ++  edit-milz  |=(t=$-(mile mile) %_(pro milestones ;;((lest mile) (turn miz t))))
        ++  aver-work  |-(~|(bad-wash+mes ?>(=(our.bol src.bol) %.y)))
        ++  aver-sess  |-(~|(bad-wash+mes ?>(=(p.assessment.pro src.bol) %.y)))
        --
    =/  sat=stat  ~(stat pj pro)
    ::  TODO: Properly verify transaction content for oath-related
    ::  operations (e.g. is this actually a withdrawal from this safe?)
    ?+    -.pod  pro
        %init
      ?>  aver-work
      ?>  =(%born sat)
      ?~  pro.pod  pro
      ?>  =(%born ~(stat pj u.pro.pod))
      u.pro.pod
    ::
        %bump
      =/  [min=@ mil=mile]  ~(next pj pro)
      ?:  ?=(%born status.mil)
        ?>  &(?=(%prop sat.pod) ?=(@ oat.pod))
        ?>  aver-work  ::  born=>prop:worker
        (edit-milz |=(m=mile m(status %prop)))
      ?:  ?=(%prop status.mil)
        ?>  ?|  &(?=(%born sat.pod) ?=(@ oat.pod))
                &(?=(?(%prop %lock) sat.pod) ?=(^ oat.pod))
            ==
        ?>  |(?=(?(%born %prop) sat.pod) aver-work)  ::  prop=>lock:worker
        ?>  |(?=(?(%born %lock) sat.pod) aver-sess)  ::  prop=>prop:oracle
        =.  contract.pro
          ?+  sat.pod  !!
            %born  ~
          ::
              %prop
            =+  sig=sigm:(need oat.pod)
            ::  TODO: Add proper error notifications here
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
          (edit-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        ~|(bad-wash+mes !!)  ::  %lock =X=> ?(%born %prop %sess %done)
      ?:  ?=(?(%work %sess) status.mil)
        ?:  ?=(%work sat.pod)
          ?>  aver-sess  ::  work/sess=>work:oracle
          (edit-mile min mil(status sat.pod))
        ?:  ?=(%sess sat.pod)
          ?>  aver-work  ::  work/sess=>sess:worker
          (edit-mile min mil(status sat.pod))
        ?:  ?=(%done sat.pod)
          ?>  aver-sess  ::  work/sess=>done:oracle
          ?>  ?=(^ oat.pod)
          ?>  =(orac:(need contract.pro) from.sigm.u.oat.pod)
          ::  TODO: Verify that this is a real signature for extracting
          ::  funds from the associated safe (how do we construct this
          ::  Urbit side?)
          ?>  (csig sigm.u.oat.pod)
          =/  mod=odit  (snag min ~(odim pj pro))
          (edit-mile min mil(status sat.pod, approval `[sigm.u.oat.pod fill.mod]))
        ?:  ?=(%dead sat.pod)
          (edit-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        ~|(bad-wash+mes !!)  ::  ?(%work %sess %done %dead) =X=> ?(%born %lock)
      ~|(bad-wash+mes !!)  ::  %dead =X=> status
    ::
        %mula
      ?<  ?=(?(%born %prop %done %dead) sat)
      ?>  (gth:rs cash.pod .0)
      ?-    +<.pod
          %plej
        ::  NOTE: This is a sufficient check because we only allow the
        ::  host of a project to accept donations on the project's behalf
        ::  (so src.bol must always be the %plej attestor; no forwarding!)
        ::  NOTE: Reinstate this check once POST requests directly apply
        ::  cards locally instead of forwarding them
        ::  ?>  =(src.bol ship.pod)
        ?<  (~(has by pledges.pro) ship.pod)
        %_(pro pledges (~(put by pledges.pro) ship.pod +>.pod))
      ::
          %trib
        =/  pol=(unit plej)  ?~(ship.pod ~ (~(get by pledges.pro) (need ship.pod)))
        ::  TODO: Is this okay or should we require direct equality?
        ?>  |(?=(~ pol) (equ:rs cash.u.pol cash.pod))
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
        %take
      =/  [min=@ mil=mile]  [min.pod (snag min.pod miz)]
      ?>  ?=(%done status.mil)
      ?>  ?=(^ approval.mil)
      (edit-mile min mil(withdrawal `act.pod))
    ==
  --
--
