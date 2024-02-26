/-  *fund
/+  leth=libeth, lhex=libhex
|%
::  +pj: p(ro)j(ect) (library); helper door for $proj data
::
++  pj
  |_  proj
  +*  milestonez  `(list mile)`milestones
  ++  stat  ::  project status (status fo earliest active milestone)
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
    %+  skim  (enum:lhex milestonez)
    |=  [a=@ n=mile]
    ?=(?(%born %lock %work %sess) status.n)
  --
::  +sss: structures/cores for peer-based synchronization (sss)
::
++  sss
  |%
  ::  +proj-flag: sss project path to project id flag
  ::
  ++  proj-flag
    |=  =path:proj
    ^-  flag
    [`@p`(slav %p ship.path) `@tas`(slav %tas name.path)]
  ::  +proj-lake: schema for peer-based project synchronization
  ::
  ++  proj-lake
    |%
    ++  name  %proj
    +$  rock  rock:proj
    +$  wave  wave:proj
    ++  wash  proj-wash
    --
  ::  +proj-wash: update function for project peer state deltas
  ::
  ++  proj-wash
    |=  [pro=proj bol=bowl:gall [sip=@p nam=@tas] pod=prod]
    ^-  rock:proj
    =*  miz  `(list mile)`milestones.pro
    =/  sat=stat  (roll miz |=([n=mile a=stat] ?.(=(%born a) a status.n)))
    =>  |%
        ++  edit-mile  |=([i=@ m=mile] %_(pro milestones ;;((lest mile) (snap miz i m))))
        ++  edit-milz  |=(t=$-(mile mile) %_(pro milestones ;;((lest mile) (turn miz t))))
        --
    ?+    -.pod  pro
        %init-proj
      ?>  =(%born sat)
      %_  pro
        ::  workers     (silt [our.bol]~)
        assessment  [our.bol .0]
      ==
    ::
        %edit-proj
      ?>  =(%born sat)
      %_  pro
        title       (fall nam.pod title.pro)
        summary     (fall sum.pod summary.pro)
        image       (hunt |=(^ %.y) pic.pod image.pro)
        ::  workers     (fall woz.pod workers.pro)
        assessment  (fall ses.pod assessment.pro)
      ==
    ::
        %mula-proj
      ?<  |(=(%born sat) =(%prop sat))
      ?-    +<.pod
          %plej
        ::  TODO: Poke the host ship with the following messages:
        ::  - %chat: poke w/ message saying "you pledged! here's where
        ::    you can follow up"
        ::  - %fund: poke to subscribe to this board as pledger
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
    ::
        %bump-proj
      ::  TODO: Place src.bowl permissions logic in here?
      =/  [pin=@ mil=mile]  [0 (snag 0 miz)]
      ?:  ?=(%born status.mil)
        ?>  ?=(%prop sat.pod)
        (edit-milz |=(m=mile m(status %prop)))
      ?:  ?=(%prop status.mil)
        ::  TODO: Restrict this action to worker and assessor
        ?>  ?|  &(?=(%born sat.pod) ?=(@ bil.pod))
                &(?=(%lock sat.pod) ?=(^ bil.pod))
            ==
        =.  contract.pro  bil.pod
        (edit-milz |=(m=mile m(status sat.pod)))
      =/  [pin=@ mil=mile]  ::  NOTE: Earliest active milestone (+ index)
        %+  snag  0
        %+  skim  `(list [@ mile])`=<(- (spin miz 0 |=([n=mile a=@] [[a n] +(a)])))
        |=([a=@ n=mile] ?=(?(%born %lock %work %sess) status.n))
      ?:  ?=(%lock status.mil)
        ?>  ?=(%work sat.pod)
        (edit-mile pin mil(status sat.pod))
      ?:  ?=(?(%work %sess) status.mil)
        ?:  ?=(?(%work %sess %done) sat.pod)
          (edit-mile pin mil(status sat.pod))
        ?:  ?=(%dead sat.pod)
          (edit-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        !!  ::  ?(%work %sess %done %dead) => ?(%born %lock) is impossible
      !!  ::  ?(%done %dead) => status is impossible
    ::
        %init-mile
      ?>  =(%born sat)
      %_(pro milestones ;;((lest mile) (into miz mid.pod *mile)))
    ::
        %drop-mile
      ?>  =(%born sat)
      %_(pro milestones ;;((lest mile) (oust [mid.pod 1] miz)))
    ::
        %edit-mile
      ?>  =(%born sat)
      =/  mil=mile  (snag mid.pod miz)
      %+  edit-mile  mid.pod
      %_  mil
        title    (fall nam.pod title.mil)
        summary  (fall sum.pod summary.mil)
        image    (hunt |=(^ %.y) pic.pod image.mil)
        cost     (fall cos.pod cost.mil)
        goal     (fall tim.pod goal.mil)
      ==
    ==
  --
--
