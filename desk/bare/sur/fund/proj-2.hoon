/-  pj-1=fund-proj-1
/+  *fund-1, config, sss
|%
+|  %misc
++  flag
  |=  pat=path
  ^-  ^flag
  [`@p`(slav %p sip.pat) `@tas`(slav %tas nam.pat)]
++  conn
  |_  [bol=bowl:gall suz=_(mk-subs:sss lake path) puz=_(mk-pubs:sss lake path)]
  ++  subs                                     ::  $proj subscriptions
    =/  da  (da:sss lake path)
    (da suz bol -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
  ++  pubs                                     ::  $proj publications
    =/  du  (du:sss lake path)
    (du puz bol -:!>(*result:du))
  ++  mine                                     ::  local data only
    ^-  prez
    =<  -  %+  ~(rib by read:pubs)  *prez
    |=  [[k=path v=[(unit (set ship)) vers p=proj]] a=prez]
    [(~(put by a) (flag k) p.v &) k v]
  ++  ours                                     ::  local and remote data
    ^-  prez
    %-  ~(uni by mine)
    =<  -  %+  ~(rib by read:subs)  *prez
    |=  [[k=[ship dude:gall p=path] v=[s=? f=? vers p=proj]] a=prez]
    [(~(put by a) (flag p.k) p.v &(!s.v !f.v)) k v]
  --

+|  %core
+$  vers  _%2
+$  path  [%fund %proj sip=@ nam=@ ~]
++  lake
  =>  |%
      ++  cash-1-2  |=(r=@rs `@ud`?+(c=(rlys r) 0 [%d *] (mul a.c (pow 10 (abs:si (sum:si --6 e.c))))))
      ++  cash-2-1  |=(c=@ud `@rs`(ryls [%d & -6 c]))
      ++  plej-1-2  |=(p=plej:pj-1 `plej`[ship.p (cash-1-2 cash.p) when.p note.p])
      ++  trib-1-2  |=(t=trib:pj-1 `trib`[ship.t (cash-1-2 cash.t) when.t note.t])
      ++  mula-1-2  |=(m=mula:pj-1 `mula`?-(-.m %plej [-.m (plej-1-2 +.m)], %trib [-.m (trib-1-2 +.m)]))
      ++  proj-1-2
        |=  pro=proj:pj-1
        ^-  proj
        ::  FIXME: Get this information from a Urbit/Hoon-hosted map
        :*  currency=[1 0xa0b8.6991.c621.8b36.c1d1.9d4a.2e9e.b0ce.3606.eb48 %usdc %usdc 6]
            title=title.pro
            summary=summary.pro
            image=image.pro
            assessment=[p.assessment.pro (cash-1-2 q.assessment.pro)]
        ::
              ^=  milestones
            ;;  (lest mile)
            %+  turn  milestones.pro
            |=  mil=mile:pj-1
            ^-  mile
            :*  title=title.mil
                summary=summary.mil
                image=image.mil
                cost=(cash-1-2 cost.mil)
                status=status.mil
                withdrawal=(bind withdrawal.mil |=(w=with:pj-1 `with`[xact.w sigm.w (cash-1-2 cash.w)]))
            ==
        ::
              ^=  pledges
            =<  -  %+  ~(rib by pledges.pro)  *(map ship plej)
            |=  [[key=ship val=plej:pj-1] acc=(map ship plej)]
            [(~(put by acc) key (plej-1-2 val)) key val]
        ::
            contribs=(turn contribs.pro trib-1-2)
            contract=contract.pro
        ==
      ++  proj-2-1
        |=  pro=proj
        ^-  proj:pj-1
        ::  NOTE: We only need assessment/milestones in 2-to-1 case
        :*  title=title.pro
            summary=summary.pro
            image=image.pro
            assessment=[p.assessment.pro (cash-2-1 q.assessment.pro)]
        ::
              ^=  milestones
            ;;  (lest mile:pj-1)
            %+  turn  milestones.pro
            |=  mil=mile
            ^-  mile:pj-1
            :*  title=title.mil
                summary=summary.mil
                image=image.mil
                cost=(cash-2-1 cost.mil)
                status=status.mil
                withdrawal=~
            ==
        ::
            pledges=~
            contribs=~
            contract=~
        ==
      --
  |%
  ++  name  %proj
  +$  rock  [vers proj]
  +$  vock  $%(vock:lake:pj-1 rock)
  +$  wave  [vers bol=bowl:gall pok=poke]
  +$  vave  $%(vave:lake:pj-1 wave)
  ++  urck
    |=  voc=vock
    ^-  rock
    ?-  -.voc
      %2  voc
      %1  $(voc [%2 (proj-1-2 +.voc)])
    ==
  ++  uwve
    |=  vav=vave
    ^-  wave
    ?-  -.vav
      %2  vav
    ::
        %1
      =-  $(vav [%2 -])
      ?+    +.vav  +.vav
        [* * %init *]  [bol.vav p.pok.vav %init (bind pro.q.pok.vav proj-1-2)]
        [* * %mula *]  [bol.vav p.pok.vav %mula (mula-1-2 +.q.pok.vav)]
      ==
    ==
  ++  wash
    ::  TODO: Add useful error messages to all the various error cases
    |=  [[vers pro=proj] [vers bol=bowl:gall lag=^flag pod=prod]]
    ^-  rock
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
            mil(withdrawal `[~ sigm.oat (sub ~(fill pj pro) ~(take pj pro))])
          ==
        --
    =/  sat=stat  ~(stat pj pro)
    :-  *vers
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
            ?>  %.  (trip `@t`p.mesg.sig)
                %~  has  in
                %-  silt
                :~  (~(vath pj pro) our.bol %v1-1-0)
                    (~(vath pj pro) our.bol %v1-0-0)
                    (~(vath pj pro) our.bol %v0-4-0)
                    (~(oath pj:pj-1 (proj-2-1 pro)) our.bol)
                ==
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
      ?>  (gth cash.pod 0)
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
      (edit-mile min mil(withdrawal `u.withdrawal.mil(xact `dif.pod)))
    ::
        %wipe
      =/  [min=@ mil=mile]  [min.pod (snag min.pod miz)]
      ?>  ?=(?(%dead %done) status.mil)
      ?>  |(?=(%done status.mil) =((lent miz) +(min)))
      =/  mod=odit  (snag min ~(odim pj pro))
      ?~  sig.pod  (edit-mile min mil(withdrawal ~))
      ?>  (peer-sigm u.sig.pod)
      =+  fil=?:(?=(%done status.mil) fill.mod (sub ~(fill pj pro) ~(take pj pro)))
      (edit-mile min mil(withdrawal `[~ u.sig.pod fil]))
    ==
  --
--
