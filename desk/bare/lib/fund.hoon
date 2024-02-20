/-  *fund
/+  leth=libeth
|%
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
    |=  [pro=proj bol=bowl:gall [sip=@p nam=@tas] jol=jolt]
    ^-  rock:proj
    =*  miz  `(list mile)`milestones.pro
    =/  sat=stat  (roll miz |=([n=mile a=stat] ?.(=(%born a) a status.n)))
    =>  |%
        ++  repl-mile  |=([i=@ m=mile] %_(pro milestones ;;((lest mile) (snap miz i m))))
        ++  repl-milz  |=(t=$-(mile mile) %_(pro milestones ;;((lest mile) (turn miz t))))
        --
    ?+    -.jol  pro
        %init-proj
      ?>  =(%born sat)
      %_  pro
        workers  (silt [our.bol]~)
      ==
    ::
        %edit-proj
      ?>  =(%born sat)
      %_  pro
        title       (fall nam.jol title.pro)
        summary     (fall sum.jol summary.pro)
        image       (hunt |=(^ %.y) pic.jol image.pro)
        workers     (fall woz.jol workers.pro)
        assessment  (fall ses.jol assessment.pro)
      ==
    ::
        %mula-proj
      ?<  =(%born sat)
      ?-    +<.jol
          %plej
        ::  TODO: Poke the host ship with the following messages:
        ::  - %chat: poke w/ message saying "you pledged! here's where
        ::    you can follow up"
        ::  - %fund: poke to subscribe to this board as pledger
        ::  TODO: Add verification logic that this pledge is actually
        ::  from the src.bowl ship (what do we do in the case of eAuth?
        ::  does an extra signature need to take place here?)
        %_(pro pledges [+>.jol pledges.pro])
      ::
          %cont
        ::  TODO: Add logic to split up a contribution between multiple
        ::  different milestones if it fills over the caps for
        ::  milestones in the middle of the project
        =-  %+  repl-mile  pin
            mil(contribs `(list cont)`[+>.jol contribs.mil])
        ^-  [pin=@ mil=mile]
        =<  +>  %^  spin  miz  `[? @ mile]`[| 0 *mile]
        =/  len  (lent milestones.pro)
        |=  [nex=mile dun=? pin=@ mile]
        :-  nex
        ?:  |(dun =(len +(pin)))  +<+
        =/  fil=@rs  (roll contribs.nex |=([n=cont a=@rs] (add:rs a cash.n)))
        ?:  (lth:rs fil cost.nex)  [& pin nex]
        [| +(pin) nex]
      ==
    ::
        %bump-proj
      ::  TODO: Place src.bowl permissions logic in here?
      =/  [pin=@ mil=mile]  [0 (snag 0 miz)]
      ?:  ?=(%born status.mil)
        ?>  ?=(%lock sat.jol)
        ?>  ?=(^ bil.jol)
        =.  contract.pro  bil.jol
        (repl-milz |=(m=mile m(status %lock)))
      =/  [pin=@ mil=mile]  ::  NOTE: Earliest active milestone (+ index)
        %+  snag  0
        %+  skim  `(list [@ mile])`=<(- (spin miz 0 |=([n=mile a=@] [[a n] +(a)])))
        |=([a=@ n=mile] ?=(?(%born %lock %work %sess) status.n))
      ?:  ?=(%lock status.mil)
        ?>  ?=(%work sat.jol)
        (repl-mile pin mil(status sat.jol))
      ?:  ?=(?(%work %sess) status.mil)
        ?:  ?=(?(%work %sess %done) sat.jol)
          (repl-mile pin mil(status sat.jol))
        ?:  ?=(%dead sat.jol)
          (repl-milz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
        !!  ::  ?(%work %sess %done %dead) => ?(%born %lock) is impossible
      !!  ::  ?(%done %dead) => status is impossible
    ::
        %init-mile
      ?>  =(%born sat)
      %_(pro milestones ;;((lest mile) (into miz mid.jol *mile)))
    ::
        %drop-mile
      ?>  =(%born sat)
      %_(pro milestones ;;((lest mile) (oust [mid.jol 1] miz)))
    ::
        %edit-mile
      ?>  =(%born sat)
      =/  mil=mile  (snag mid.jol miz)
      %+  repl-mile  mid.jol
      %_  mil
        title     (fall nam.jol title.mil)
        summary   (fall sum.jol summary.mil)
        image     (hunt |=(^ %.y) pic.jol image.mil)
        cost      (fall cos.jol cost.mil)
        estimate  (fall tim.jol estimate.mil)
      ==
    ==
  --
--
