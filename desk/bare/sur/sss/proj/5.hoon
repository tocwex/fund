/-  pold=sss-proj-4
/+  *fund-proj-2, fc=fund-core, config, sss
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
    %-  ~(rep by read:pubs)
    |=  [[k=path v=[(unit (set ship)) vers p=proj]] a=prez]
    (~(put by a) (flag k) p.v &)
  ++  ours                                     ::  local and remote data
    ^-  prez
    %-  ~(uni by mine)
    ^-  prez
    %-  ~(rep by read:subs)
    |=  [[k=[ship dude:gall p=path] v=[s=? f=? vers p=proj]] a=prez]
    (~(put by a) (flag p.k) p.v &(!s.v !f.v))
  --

+|  %core
+$  vers  _%5
+$  path  [%fund %proj sip=@ nam=@ ~]
++  lake
  =/  up
    |_  pro=proj:pold
    ++  proj
      ^-  ^proj
      :*  title=title.pro
          summary=summary.pro
          image=image.pro
          assessment=assessment.pro
      ::
            ^=  payment
          ?.  ?=(%enft -.payment.pro)  payment.pro
          :*  %enft
              chain=chain.payment.pro
              addr=addr.payment.pro
              name=name.payment.pro
              symbol=symbol.payment.pro
              ::  NOTE: Hardcoded so as not to create a dependency on the
              ::  /lib/fund/chain/hoon file
              uri=|=(i=@ud "https://azimuth.network/erc721/{<i>}.json")
              limits=(malt ~[[%size |=(=@t =(%star t))]])
          ==
      ::
          milestones=milestones.pro
          contract=contract.pro
          pledges=pledges.pro
          contribs=contribs.pro
          proofs=proofs.pro
      ==
    --
  |%
  ++  name  %proj
  +$  rock  [vers proj]
  +$  vock  $%(vock:lake:pold rock)
  +$  wave  [vers bol=bowl:gall pok=poke]
  +$  vave  $%(vave:lake:pold wave)
  ++  urck
    |=  voc=vock
    ^-  rock
    ?+  -.voc     $(voc (urck:lake:pold voc))
      vers        voc
      vers:pold   $(voc [*vers ~(proj up +.voc)])
    ==
  ++  uwve
    |=  vav=vave
    ^-  wave
    ?+  -.vav     $(vav (uwve:lake:pold vav))
      vers        vav
    ::
        vers:pold
      =-  $(vav [*vers -])
      ?+    +.vav      +.vav
        [* * %init *]  [bol.vav p.pok.vav %init ~(proj up pro.q.pok.vav)]
      ==
    ==
  ++  wash
    ::  TODO: Add useful error messages to all the various error cases
    |=  [[vers pro=proj] [vers bol=bowl:gall lag=^flag pod=prod]]
    ^-  rock
    =*  mes  `(mess prod)`[src.bol /fund/proj/(scot %p p.lag)/[q.lag] pod]
    =*  miz  `(list mile)`milestones.pro
    =>  |%
        ++  aver-work  |-(~|(bad-wash+mes ?>(=(our.bol src.bol) %.y)))
        ++  aver-orac  |-(~|(bad-wash+mes ?>(=(p.assessment.pro src.bol) %.y)))
        ++  edit-mile  |=([i=@ m=mile] %_(pro milestones ;;((lest mile) (snap miz i m))))
        ++  edit-milz  |=(t=$-(mile mile) %_(pro milestones ;;((lest mile) (turn miz t))))
        ++  good-sigm  |=([s=sigm w=(set addr)] &((~(has in w) from.s) (csig:fc s)))
        ++  orac-sigm  |=(s=sigm =+((need contract.pro) (good-sigm s (sy [orac.-]~))))
        ++  team-sigm  |=(s=sigm =+((need contract.pro) (good-sigm s (sy ~[orac.- work.-]))))
        ++  peer-sigm  |=(s=sigm =+((need contract.pro) (good-sigm s (sy ~[orac.- work.- !<(addr (slot:config %sign-addr))]))))
        ++  dead-milz
          |=  oat=oath
          ?>  (team-sigm sigm.oat)
          ?>  ?|  ?=([%| @ux] mesg.sigm.oat)
                  =((crip (~(bail pj pro) (dec (lent miz)) %dead)) +.mesg.sigm.oat)
              ==
          %_    pro
              milestones
            ;;  (lest mile)
            =+  niz=(turn miz |=(m=mile ?:(?=(%done status.m) m m(status %dead))))
            %+  snoc  (snip niz)
            =+  mil=(rear niz)
            mil(withdrawal `[~ sigm.oat (sub ~(fill pj pro) ~(take pj pro)) ~])
          ::
              pledges
            %-  ~(run by pledges.pro)
            |=([p=plej d=peta] [p d(view `%slyd)])
          ==
        --
    =/  sat=stat  ~(stat pj pro)
    :-  *vers
    ?+    -.pod  pro
        %init
      ?>  aver-work
      ?>  =(%born sat)
      ?>  =(%born ~(stat pj pro.pod))
      ::  NOTE: For now, stars and galaxies only
      ?>  (star:fx p.assessment.pro.pod)
      pro.pod
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
                ::  NOTE: Try all versions listed in simple type union `over`
                %~  has  in  %-  silt
                =-  (turn vez |=(v=@ (~(vath pj pro) our.bol ;;(over v))))
                ^-  vez=(list @)
                =/  typ=type  ~(repo ut -:!>(*over))
                ?>  ?=([%hint * %fork *] typ)
                (murn ~(tap in p.q.typ) |=(t=type ?>(?=([%atom *] t) q.t)))
            ?>  (csig:fc sig)
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
          ?>  ?|  ?=([%| @ux] mesg.sig)
                  =((crip (~(bail pj pro) min sat.pod)) +.mesg.sig)
              ==
          %_    pro
              milestones
            ;;  (lest mile)
            %^  snap  miz  min
            `mile`mil(status sat.pod, withdrawal `[~ sig fill.mod ~])
          ::
              pledges
            ?.  =((lent miz) +(min))  pledges.pro
            %-  ~(run by pledges.pro)
            |=([p=plej d=peta] [p d(view `%stif)])
          ==
        ?:  ?=(%dead sat.pod)
          (dead-milz (need oat.pod))
        ~|(bad-wash+mes !!)  ::  ?(%work %sess %done %dead) =X=> ?(%born %lock)
      ~|(bad-wash+mes !!)  ::  %dead =X=> status
    ::
        %mula
      ?<  ?=(?(%born %prop) sat)
      ?>  (gth cash.pod 0)
      ?-    +<.pod
          %pruf
        ::  TODO: When duplicate attestations come in, they currently
        ::  overwrite the existing data; this hasn't been an issue, but
        ::  it's unclear if this is the best behavior
        ?>  =(src our):bol
        ?-    note.pod
            %depo
          ?~  teb=(~(get by contribs.pro) q.xact.when.pod)
            %_(pro proofs (~(put by proofs.pro) q.xact.when.pod +>.pod))
          %_(pro contribs (~(put by contribs.pro) q.xact.when.pod u.teb(pruf `+>.pod)))
        ::
            %with
          =/  myz=(list (pair @ mile))
            %+  skim  +:(roll miz |=([n=mile a=[@ (list [@ mile])]] [+(-.a) [[-.a n] +.a]]))
            |=  [min=@ mil=mile]
            ?&  ?=(^ withdrawal.mil)
                ?=(^ xact.u.withdrawal.mil)
                =(q.u.xact.u.withdrawal.mil q.xact.when.pod)
            ==
          ?~  mil=`(unit (pair @ mile))`?~(myz ~ `i.myz)
            %_(pro proofs (~(put by proofs.pro) q.xact.when.pod +>.pod))
          ?>  ?=(^ withdrawal.q.u.mil)
          (edit-mile p.u.mil q.u.mil(withdrawal `u.withdrawal.q.u.mil(pruf `+>.pod)))
        ==
      ::
          ?(%plej %trib)
        ?<  ?=(?(%done %dead) sat)
        ::  FIXME: Very inefficient, but also very convenient!
        =/  nid=@ud
          .+  %+  max
            (~(rep by contribs.pro) |=([[k=addr v=[treb deta]] a=@ud] (max a id.v)))
          (~(rep by pledges.pro) |=([[k=ship v=[plej peta]] a=@ud] (max a id.v)))
        ?-    +<.pod
            %plej
          ::  NOTE: This is a sufficient check because we only allow the
          ::  host of a project to accept donations on the project's behalf
          ::  (so src.bol must always be the %plej attestor; no forwarding!)
          ?>  =(src.bol ship.pod)
          ?>  (plan:fx src.bol)
          ?<  (~(has by pledges.pro) ship.pod)
          %_(pro pledges (~(put by pledges.pro) ship.pod +>.pod ~ nid &))
        ::
            %trib
          =/  pej=(unit [plej peta])  ?~(ship.pod ~ (~(get by pledges.pro) u.ship.pod))
          =/  puf=(unit pruf)  (~(get by proofs.pro) q.xact.when.pod)
          ?>  |(?=(~ pej) &(=(src.bol ship.u.pej) =(cash.u.pej cash.pod)))
          %_    pro
              pledges
            ?~  pej  pledges.pro
            (~(del by pledges.pro) (need ship.pod))
          ::
              proofs
            ?~  puf  proofs.pro
            (~(del by proofs.pro) q.xact.when.u.puf)
          ::
              contribs
            %-  ~(put by contribs.pro)
            =-  [q.xact.when.pod - nid &]
            :*  trib=+>.pod
                plej=?~(pej ~ `-.u.pej)
                pruf=?~(puf ~ `u.puf)
            ==
          ==
        ==
      ==
    ::
        %draw
      =/  [min=@ mil=mile]  [min.pod (snag min.pod miz)]
      ?>  ?=(?(%dead %done) status.mil)
      ?>  |(?=(%done status.mil) =((lent miz) +(min)))
      ?>  &(?=(^ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))
      =/  puf=(unit pruf)  (~(get by proofs.pro) q.dif.pod)
      %_    pro
          milestones
        ;;  (lest mile)
        %^  snap  miz  min
        `mile`mil(withdrawal `u.withdrawal.mil(xact `dif.pod, pruf puf))
      ::
          proofs
        ?~  puf  proofs.pro
        (~(del by proofs.pro) q.dif.pod)
      ==
    ::
        %wipe
      =/  [min=@ mil=mile]  [min.pod (snag min.pod miz)]
      ?>  ?=(?(%dead %done) status.mil)
      ?>  |(?=(%done status.mil) =((lent miz) +(min)))
      ?>  |(?=(~ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))
      =/  mod=odit  (snag min ~(odim pj pro))
      ?~  sig.pod  (edit-mile min mil(withdrawal ~))
      ?>  (peer-sigm u.sig.pod)
      ?>  ?|  ?=([%| @ux] mesg.u.sig.pod)
              =((crip (~(bail pj pro) min status.mil)) +.mesg.u.sig.pod)
          ==
      =+  fil=?:(?=(%done status.mil) fill.mod (sub ~(fill pj pro) ~(take pj pro)))
      (edit-mile min mil(withdrawal `[~ u.sig.pod fil ~]))
    ::
        %redo
      %_    pro
        proofs    proofs:*proj
        contribs  (~(run by contribs.pro) |=([t=treb d=deta] [t(pruf ~) d]))
      ::
          milestones
        ;;  (lest mile)
        %+  turn  milestones.pro
        |=(m=mile m(withdrawal (bind withdrawal.m |=(w=with w(pruf ~)))))
      ==
    ==
  --
--
