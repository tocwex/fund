/-  *fund
/+  fx=fund-xtra, rudder
|%
::  +pj: p(ro)j(ect) (library); helper door for $proj data
::
++  pj
  |_  proj
  +*  milestonez  `(list mile)`milestones
  ++  stat  ::  project $stat (status of earliest active milestone)
    ^-  ^stat
    status:mil:next-stat
  ++  cost  ::  project funding cost (sum of milestone costs)
    ^-  @rs
    (roll (turn milestonez |=(n=mile cost.n)) add:rs)
  ++  plej  ::  project pledge amount
    ^-  @rs
    %+  roll  ~(val by pledges)
    |=([n=^plej a=@rs] (add:rs a cash.n))
  ++  fill  ::  project funding fill (sum of milestone fills)
    ^-  @rs
    (roll film add:rs)
  ++  film  ::  project funding per milestone fills
    ^-  (list @rs)
    %+  turn  milestonez
    |=  mil=mile
    %+  roll  contribs.mil
    |=([n=trib a=@rs] (add:rs a cash.n))
  ++  mula  ::  full list of project $mula ($plej list, $trib list)
    ^-  (list ^mula)
    %+  weld  (turn ~(val by pledges) |=(p=^plej `^mula`[%plej p]))
    %+  roll  milestonez
    |=  [mil=mile acc=(list ^mula)]
    %+  weld  acc
    (turn contribs.mil |=(t=trib `^mula`[%trib t]))
  ++  rols  ::  $role set for a given $ship
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
  ++  next-fill  ::  next milestone that hasn't reached goal
    ^-  [pin=@ mil=mile]
    =<  +>  %^  spin  milestonez  `[? @ mile]`[| 0 *mile]
    =/  len  (lent milestones)
    |=  [nex=mile dun=? pin=@ mile]
    :-  nex
    ?:  |(dun =(len +(pin)))  +<+
    =-  ?:((lth:rs - cost.nex) [& pin nex] [| +(pin) nex])
    (roll contribs.nex |=([n=trib a=@rs] (add:rs a cash.n)))
  ++  next-stat  ::  earliest active milestone
    ^-  [pin=@ mil=mile]
    =-  (fall - [0 i.milestones])
    ^-  (unit [@ mile])
    =-  ?~(- ~ (some i.-))
    %+  skim  (enum:fx milestonez)
    |=  [a=@ n=mile]
    ?=(?(%born %lock %work %sess) status.n)
  --
::
::  +ok: assert correctness of edit type on given $proj
::
::    ?>  ~(edit ok [our %test proj])
::
++  ok
  |_  [=flag proj]
  ++  edit
    |=  who=@p
    ~|  "%fund: {<who>} can't 'edit' for project {<flag>}"
    ?>  =(who p.flag)
    %.y
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
      =/  [pin=@ mil=mile]  ~(next-stat pj pro)
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
          (edit-mile pin mil(status sat.pod))
        ?:  ?=(%dead sat.pod)
          (edit-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        ~|(bad-wash+mes !!)  ::  %lock =X=> ?(%born %prop %sess %done)
      ?:  ?=(?(%work %sess) status.mil)
        ?:  ?=(?(%work %sess %done) sat.pod)
          ?>  |(?=(?(%work %sess) sat.pod) aver-sess)  ::  work/sess=>done:oracle
          ?>  |(?=(?(%work %done) sat.pod) aver-work)  ::  work/sess=>sess:worker
          (edit-mile pin mil(status sat.pod))
        ?:  ?=(%dead sat.pod)
          (edit-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        ~|(bad-wash+mes !!)  ::  ?(%work %sess %done %dead) =X=> ?(%born %lock)
      ~|(bad-wash+mes !!)  ::  ?(%done %dead) =X=> status
    ::
        %mula
      ?<  |(=(%born sat) =(%prop sat))
      ?-    +<.pod
          %plej
        ::  TODO: Add verification logic that this pledge is actually
        ::  from the src.bowl ship (what do we do in the case of eAuth?
        ::  does an extra signature need to take place here?)
        =/  pol=(unit plej)  (~(get by pledges.pro) ship.pod)
        ?>  ?=(@ pol)
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
        %+  edit-mile  pin.nex
        mil.nex(contribs `(list trib)`[+>.pod contribs.mil.nex])
      ==
    ==
  --
--
