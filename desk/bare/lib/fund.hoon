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
::  +pj: p(ro)j(ect) (library); helper door for $proj data
::
++  pj
  |_  proj
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
  ++  rols                                       ::  project $role(s) of user
    ::  FIXME: This function signature will be simplified once a project
    ::  is allowed to have different workers than its host
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
  ++  next                                       ::  next active milestone
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
            %lock  `(need oat.pod)
            %prop  `=+(o=?~(contract.pro *oath u.contract.pro) o(sigm sigm:(need oat.pod)))
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
          =/  mod=odit  (snag min ~(odim pj pro))
          (edit-mile min mil(status sat.pod, approval `[sigm.u.oat.pod fill.mod]))
        ?:  ?=(%dead sat.pod)
          (edit-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        ~|(bad-wash+mes !!)  ::  ?(%work %sess %done %dead) =X=> ?(%born %lock)
      ~|(bad-wash+mes !!)  ::  ?(%done %dead) =X=> status
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
    ==
  --
--
