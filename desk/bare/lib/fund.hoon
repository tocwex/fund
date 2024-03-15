/-  *fund
/+  fx=fund-xtra, rudder
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
::  +film: the fill of a $mile, or the total sum of its contributions
::
++  film
  |=  mil=mile
  ^-  @rs
  (roll (turn contribs.mil |=(t=trib cash.t)) add:rs)
::
::  +pj: p(ro)j(ect) (library); helper door for $proj data
::
++  pj
  |_  proj
  +*  milestonez  `(list mile)`milestones
  ++  stat                                       ::  project-wide status
    ^-  ^stat
    status:mil:next-stat
  ++  cost                                       ::  summed milestone costs
    ^-  @rs
    (roll (turn milestonez |=(n=mile cost.n)) add:rs)
  ++  plej                                       ::  summed pledge amounts
    ^-  @rs
    %+  roll  ~(val by pledges)
    |=([n=^plej a=@rs] (add:rs a cash.n))
  ++  fill                                       ::  project-wide cost fill
    ^-  @rs
    (roll (turn milestonez film) add:rs)
  ++  odit                                       ::  project-wide audit
    ^-  ^odit
    (filo [cost fill plej ~])
  ++  odim                                       ::  per-milestone audit
    ^-  (list ^odit)
    =/  [pre=@rs fin=@ mile]  [plej next-fill]
    %+  turn  (enum:fx milestonez)
    |=  [min=@ mil=mile]
    =+  mio=(filo [cost.mil (film mil) .0 ~])
    ?:  |((lth min fin) (lte:rs pre .0))  mio
    ::  FIXME: There are some cases related to the final milestone that
    ::  aren't properly being accounted for here
    ::  TODO: There is some smarter way to do this math
    =.  plej.mio  ?:((lte:rs pre (need void.mio)) pre (sub:rs pre (need void.mio)))
    =.  pre  (sub:rs pre plej.mio)
    (filo mio(void ~))
  ++  mula                                       ::  project-wide $mula list
    ^-  (list ^mula)
    %+  weld  (turn ~(val by pledges) |=(p=^plej `^mula`[%plej p]))
    %+  roll  milestonez
    |=  [mil=mile acc=(list ^mula)]
    %+  weld  acc
    (turn contribs.mil |=(t=trib `^mula`[%trib t]))
  ++  rols                                       ::  project $role(s) of user
    ::  FIXME: This function signature will be simplified once a project
    ::  is allowed to have different workers than its host
    |=  [wox=@p who=@p]
    ^-  (set role)
    %-  silt
    ;:  welp
        ?.(=(wox who) ~ [%work]~)
        ?.(=(p.assessment who) ~ [%sess]~)
        ?.  ?|  (~(has by pledges) who)
                (lien milestonez |=(m=mile (lien contribs.m |=(t=trib ?~(ship.t | =(u.ship.t who))))))
            ==
          ~
        [%fund]~
    ==
  ++  next-fill                                  ::  next milestone to fill
    ^-  [min=@ mil=mile]
    ::  TODO: If we end up signing bucket extraction transactions, then
    ::  we'll need to stop at %done cases that haven't reached their
    ::  cost limit if they've been unclaimed by the worker
    ::
    ::  NOTE: Provide index of last milestone when all filled
    =-  ?^(- i.- [(dec (lent milestonez)) (rear milestonez)])
    %+  skip  (enum:fx milestonez)
    |=([@ n=mile] |(?=(?(%done %dead) status.n) (lte:rs cost.n (film n))))
  ++  next-stat                                  ::  next active milestone
    ^-  [min=@ mil=mile]
    ::  NOTE: Provide index past last milestone when all are completed
    =-  ?^(- i.- [(lent milestonez) (rear milestonez)])
    %+  skip  (enum:fx milestonez)
    |=([@ n=mile] ?=(?(%done %dead) status.n))
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
    ?+    -.pod  pro
        %init
      ?>  aver-work
      ?>  =(%born sat)
      ?~  pro.pod  pro
      ?>  =(%born ~(stat pj u.pro.pod))
      u.pro.pod
    ::
        %bump
      =/  [min=@ mil=mile]  ~(next-stat pj pro)
      ?:  ?=(%born status.mil)
        ?>  &(?=(%prop sat.pod) ?=(@ bil.pod))
        ?>  aver-work  ::  born=>prop:worker
        (edit-milz |=(m=mile m(status %prop)))
      ?:  ?=(%prop status.mil)
        ?>  ?|  &(?=(%born sat.pod) ?=(@ bil.pod))
                &(?=(?(%prop %lock) sat.pod) ?=(^ bil.pod))
            ==
        ?>  |(?=(?(%born %prop) sat.pod) aver-work)  ::  prop=>lock:worker
        ?>  |(?=(?(%born %lock) sat.pod) aver-sess)  ::  prop=>prop:oracle
        =.  contract.pro  bil.pod
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
          ?>  ?=(^ bil.pod)
          (edit-mile min mil(status sat.pod, contract bil.pod))
        ?:  ?=(%dead sat.pod)
          (edit-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        ~|(bad-wash+mes !!)  ::  ?(%work %sess %done %dead) =X=> ?(%born %lock)
      ~|(bad-wash+mes !!)  ::  ?(%done %dead) =X=> status
    ::
        %mula
      ?<  |(=(%born sat) =(%prop sat))
      ?-    +<.pod
          %plej
        ::  NOTE: This is a sufficient check because we only allow the
        ::  host of a project to accept donations on the projects behalf
        ::  (so src.bol must always be the %plej attestor; no forwarding!)
        ?>  =(src.bol ship.pod)
        ?<  (~(has by pledges.pro) ship.pod)
        %_(pro pledges (~(put by pledges.pro) ship.pod +>.pod))
      ::
          %trib
        ::  TODO: Add logic to split up a contribution between multiple
        ::  different milestones if it fills over the caps for
        ::  milestones in the middle of the project
        =/  nex  ~(next-fill pj pro)
        =/  pol=(unit plej)  ?~(ship.pod ~ (~(get by pledges.pro) (need ship.pod)))
        =?  pledges.pro  ?=(^ pol)
          ::  TODO: Is this okay or should we require direct equality?
          ?>  (equ:rs cash.u.pol cash.pod)
          (~(del by pledges.pro) (need ship.pod))
        %+  edit-mile  min.nex
        mil.nex(contribs `(list trib)`[+>.pod contribs.mil.nex])
      ==
    ==
  --
--
