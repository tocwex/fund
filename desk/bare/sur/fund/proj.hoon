/+  *fund, config, sss
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
+$  vers  _%1
+$  path  [%fund %proj sip=@ nam=@ ~]
++  lake
  |%
  ++  name  %proj
  +$  rock  [vers proj]
  +$  vock
    $%  rock
    ==
  +$  wave  [vers =bowl:gall =poke]
  +$  vave
    $%  wave
    ==
  ++  urck
    |=  voc=vock
    ^-  rock
    ?-  -.voc
      %1  voc
    ==
  ++  uwve
    |=  vav=vave
    ^-  wave
    ?-  -.vav
      %1  vav
    ==
  ++  wash
    ::  TODO: Add useful error messages to all the various error cases
    |=  [[vers pro=proj] vers bol=bowl:gall lag=^flag pod=prod]
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
            mil(withdrawal `[~ sigm.oat (sub:rs ~(fill pj pro) ~(take pj pro))])
          ==
        --
    =/  sat=stat  ~(stat pj pro)
    :-  %1
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
      ?>  (gth:rs cash.pod .0)
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
      =+  fil=?:(?=(%done status.mil) fill.mod (sub:rs ~(fill pj pro) ~(take pj pro)))
      (edit-mile min mil(withdrawal `[~ u.sig.pod fil]))
    ==
  --
--
