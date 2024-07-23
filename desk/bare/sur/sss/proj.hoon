/-  pold=sss-proj-2
/+  *fund-proj, f=fund, config, sss
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
    *prez
    ::  %-  ~(uni by mine)
    ::  %-  ~(rep by read:subs)
    ::  |=  [[k=[ship dude:gall p=path] v=[s=? f=? vers p=proj]] a=prez]
    ::  (~(put by a) (flag p.k) p.v &(!s.v !f.v))
  --

+|  %core
+$  vers  _%3
+$  path  [%fund %proj sip=@ nam=@ ~]
++  lake
  =/  up
    |_  pro=proj:pold
    ::  NOTE: For convenience, v1.1.0- listed $WSTR currencies as having
    ::  6 decimals. v1.1.0 corrects this to 18 decimals, so all of
    ::  these cash values need to be readjusted.
    ++  cash  |=(c=cash:pold `^cash`?.(=(%wstr symbol.currency.pro) c (mul c (pow 10 12))))
    ++  plej  |=(p=plej:pold `^plej`p(cash (cash cash.p)))
    ++  trib  |=(t=trib:pold `^trib`t(cash (cash cash.t)))
    ++  proj
      ^-  ^proj
      :*  title=title.pro
          summary=summary.pro
          image=image.pro
          assessment=assessment.pro
      ::
            ^=  currency
          =-  currency.pro(name nam, symbol sym)
          ^-  [nam=@t sym=@t]
          ?+  [chain.currency.pro symbol.currency.pro]  ['USDC' 'USDC']
            [%1 %usdc]           ['USDC' 'USDC']
            [%1 %wstr]           ['WrappedStar' 'WSTR']
            [%11.155.111 %usdc]  ['%fund USDC' 'fundUSDC']
            [%11.155.111 %wstr]  ['%fund WSTR' 'fundWSTR']
          ==
      ::
            ^=  milestones
          ;;  (lest mile)
          %+  turn  milestones.pro
          |=  mil=mile:pold
          ^-  mile
          :*  title=title.mil
              summary=summary.mil
              image=image.mil
              cost=(cash cost.mil)
              status=status.mil
              withdrawal=(bind withdrawal.mil |=(w=with:pold `with`[xact.w sigm.w (cash cash.w) ~]))
          ==
      ::
          contract=contract.pro
      ::
            ^=  pledges
          =+  off=(lent contribs.pro)
          =<  -  %-  ~(rep by pledges.pro)
          |=  [[key=ship val=plej:pold] acc=[ma=(map ship [^plej peta]) id=@ud]]
          :_  +(id.acc)
          (~(put by ma.acc) key [(plej val) ~ (add off id.acc) &])
      ::
            ^=  contribs
          =<  -  %+  reel  contribs.pro
          |=  [nex=trib:pold acc=[ma=(map addr [treb deta]) id=@ud]]
          :_  +(id.acc)
          (~(put by ma.acc) q.xact.when.nex [[(trib nex) ~ ~] id.acc &])
      ::
          proofs=*(map addr pruf)
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
        [* * %init *]  [bol.vav p.pok.vav %init (bind pro.q.pok.vav |=(p=proj:pold ~(proj up p)))]
        ::  NOTE: %mula from v1.1.0- will just be underreported! There
        ::  should be no victims of this omission (on mainnet at least)
        ::  [* * %mula *]  ...
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
        ++  good-sigm  |=([s=sigm w=(set addr)] &((~(has in w) from.s) (csig:f s)))
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
            mil(withdrawal `[~ sigm.oat (sub ~(fill pj pro) ~(take pj pro)) ~])
          ==
        --
    =/  sat=stat  ~(stat pj pro)
    ::  TODO: unit of version tag; use this info to adjust old %mula for
    ::  WSTR projects
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
                %~  has  in  %-  silt
                :~  (~(vath pj pro) our.bol %v1-1-0)
                    (~(vath pj pro) our.bol %v1-0-0)
                    (~(vath pj pro) our.bol %v0-4-0)
                    (~(vath pj pro) our.bol %v0-0-0)
                ==
            ?>  (csig:f sig)
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
          (edit-mile min mil(status sat.pod, withdrawal `[~ sig fill.mod ~]))
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
      =+  fil=?:(?=(%done status.mil) fill.mod (sub ~(fill pj pro) ~(take pj pro)))
      (edit-mile min mil(withdrawal `[~ u.sig.pod fil ~]))
    ==
  --
--
