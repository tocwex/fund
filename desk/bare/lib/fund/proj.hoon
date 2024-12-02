/-  *fund-proj
/+  fc=fund-core, ff=fund-form, fx=fund-xtra
|%
::
::  +pj: p(ro)j(ect) (library); helper door for $proj data
::
++  pj
  |_  proj
  ::  FIXME: All the `wox=@p` function signatures will be simplified
  ::  once a project stores/supports multiple different workers
  +*  miz  `(list mile)`milestones
  ++  stat                                       ::  project-wide status
    ^-  ^stat
    status:mil:next
  ++  cost                                       ::  summed milestone costs
    ^-  cash
    (roll (turn miz |=(n=mile cost.n)) add)
  ++  plej                                       ::  project-wide open pledge amount
    ^-  cash
    %-  ~(rep by pledges)
    |=([[k=@p v=[^plej peta]] a=cash] (add a cash.v))
  ++  fill                                       ::  project-wide cost fill
    ^-  cash
    (roll (turn (mula (sy ~[%trib %pruf-open]) ~) |=(m=^mula cash.m)) add)
  ++  take                                       ::  project-wide claimed funds
    ^-  cash
    %-  roll  :_  add
    %+  turn  prec
    |=([@ m=mile] ?.(?&(?=(%done status.m) ?=(^ withdrawal.m)) 0 cash.u.withdrawal.m))
  ++  give                                       ::  project-wide refunded funds
    ^-  cash
    %-  roll  :_  add
    %+  turn  prec
    |=([@ m=mile] ?.(?&(?=(%dead status.m) ?=(^ withdrawal.m)) 0 cash.u.withdrawal.m))
  ++  odit                                       ::  project-wide audit
    ^-  ^odit
    (filo:fc [cost fill plej ~])
  ++  odim                                       ::  per-milestone audit
    ^-  (list ^odit)
    =/  lin=@  (dec (lent miz))
    ::  NOTE: Use @sd values since the last milestone can have an overage,
    ::  which produces negative fill values (reconciled in `+filo`)
    =<  -  %^  spin  miz  [0 (sun:si fill) (sun:si plej)]
    |=  [mil=mile min=@ fre=@sd pre=@sd]
    =/  [dun=? amo=@ud]
      ?+  status.mil  [| cost.mil]
        %dead  [& ?~(withdrawal.mil 0 cash.u.withdrawal.mil)]
      ::
          %done
        ?~  withdrawal.mil  [| cost.mil]
        :_  cash.u.withdrawal.mil
        |(=(0x0 +:(fall xact.u.withdrawal.mil [0 0x1])) ?=(^ pruf.u.withdrawal.mil))
      ==
    =+  end==(min lin)
    =+  fos=(sun:si amo)
    =+  fil=?:(|(end =(-1 (cmp:si fre fos))) fre fos)
    =+  pos=?:(dun --0 (dif:si fos fil))
    =+  pej=?:(|(end =(-1 (cmp:si pre pos))) pre pos)
    [(filo:fc [cost.mil (abs:si fil) (abs:si pej) ~]) +(min) (dif:si fre fil) (dif:si pre pej)]
  ++  mula                                       ::  project-wide $mula list
    |=  [mys=(set mype) who=(unit [sip=@p was=(set addr)])]
    ^-  (list ^mula)
    |^  %-  sort  %-  skim
        %~  tap  in  %-  silt
        `(list ^mula)`(mulz mys)
    ++  sort
      |=  muz=(list ^mula)
      ^-  (list ^mula)
      (^sort muz |=([a=^mula b=^mula] (gth (tula:fc a) (tula:fc b))))
    ++  skim
      |=  muz=(list ^mula)
      ^-  (list ^mula)
      ?~  who  muz
      %+  ^skim  muz
      |=  mul=^mula
      =/  udr=(unit addr)  ?+(-.mul `from.when.mul %plej ~)
      =/  sup=(unit @p)    ?-(-.mul %trib ship.mul, %plej `ship.mul, %pruf ~)
      ?|  &(?=(^ sup) =(u.sup sip.u.who))
          &(?=(^ udr) (~(has in was.u.who) u.udr))
      ==
    ++  mulz
      |=  myz=(set mype)
      ^-  (list ^mula)
      ?+    myz  (zing (turn ~(tap in `(set mype)`myz) |=(m=mype (mulz m ~ ~))))
          ~
        ~
      ::
          [@ ~ ~]
        ?-  -.myz
          %mula  (mulz (sy ~[%pruf %plej %trib]))
          %pruf  (mulz (sy ~[%pruf-open %pruf-trib %pruf-with]))
          %plej  (welp (turn ~(val by pledges) |=([p=^plej *] [%plej p])) (mulz %plej-trib ~ ~))
          ::  (mulz (sy ~[%plej-open %plej-trib %plej-stif %plej-slyd]))
          %trib  (turn ~(val by contribs) |=([t=treb *] `^mula`[%trib -.t]))
        ::
        ::
          %pruf-open  (turn ~(val by proofs) (lead %pruf))
          %pruf-trib  (murn ~(val by contribs) |=([t=treb *] (bind pruf.t (lead %pruf))))
          %pruf-with  (murn miz |=(m=mile ?~(withdrawal.m ~ (bind pruf.u.withdrawal.m (lead %pruf)))))
        ::
        ::
          %plej-open  (murn ~(val by pledges) |=([p=^plej m=peta] ?.(?=(~ view.m) ~ `[%plej p])))
          %plej-trib  (murn ~(val by contribs) |=([t=treb *] (bind plej.t (lead %plej))))
        ::
            %plej-stif
          %+  murn  ~(val by pledges)
          |=([p=^plej m=peta] ?.(&(?=(^ view.m) ?=(%stif u.view.m)) ~ `[%plej p]))
        ::
            %plej-slyd
          %+  murn  ~(val by pledges)
          |=([p=^plej m=peta] ?.(&(?=(^ view.m) ?=(%slyd u.view.m)) ~ `[%plej p]))
        ::
        ::
          %trib-open  (murn ~(val by contribs) |=([t=treb *] ?^(pruf.t ~ `[%trib -.t])))
          %trib-pruf  (murn ~(val by contribs) |=([t=treb *] ?~(pruf.t ~ `[%trib -.t])))
          %trib-plej  (murn ~(val by contribs) |=([t=treb *] ?~(plej.t ~ `[%trib -.t])))
        ==
      ==
    --
  ++  fula                                       ::  project-wide "filled" $mula list
    ^-  (list ^mula)
    (mula (sy ~[%trib %pruf-open]) ~)
  ++  pula                                       ::  project-wide "pledged" $mula list
    ^-  (list ^mula)
    (mula [%plej ~ ~] ~)
  ++  bloq                                       ::  project-wide latest block
    ^-  ^bloq
    =/  mul=(list ^mula)  (mula [%mula ~ ~] ~)
    =/  moq=^bloq  ?~(mul 0 (tula:fc i.mul))
    =/  loq=^bloq  p:xact:(fall contract *^oath)
    (max loq moq)
  ++  next                                       ::  next active milestone
    ^-  [min=@ mil=mile]
    ::  NOTE: Provide index past last milestone when all are completed
    =-  ?^(- i.- [(lent miz) (rear miz)])
    %+  skip  (enum:fx miz)
    |=([@ n=mile] ?=(?(%done %dead) status.n))
  ++  prev                                       ::  all inactive milestones
    ^-  (list [min=@ mil=mile])
    %+  skim  (enum:fx miz)
    |=([@ n=mile] ?=(?(%done %dead) status.n))
  ++  prec                                       ::  all claimed inactive milestones
    ^-  (list [min=@ mil=mile])
    %+  skim  prev
    |=  [@ mil=mile]
    ?&  ?=(^ withdrawal.mil)
        ?=(^ xact.u.withdrawal.mil)
        |(=(0x0 q.u.xact.u.withdrawal.mil) ?=(^ pruf.u.withdrawal.mil))
    ==
  ++  whos                                       ::  all ships involved in the project
    ^-  (set @p)
    %-  silt
    ^-  (list @p)
    ;:  welp
        [p.assessment]~
        (turn ~(val by pledges) |=([p=^plej *] ship.p))
        (murn ~(val by contribs) |=([t=treb *] ship.t))
    ==
  ++  rols                                       ::  project $role(s) of user
    |=  [wox=@p who=@p]
    ^-  (set role)
    %-  silt
    ;:  welp
        ?.(=(wox who) ~ [%work]~)
        ?.(=(p.assessment who) ~ [%orac]~)
        ?.  ?|  (~(has by pledges) who)
                %-  ~(rep by contribs)
                |=([[k=addr v=[treb deta]] a=_|] |(a ?~(ship.v | =(u.ship.v who))))
            ==
          ~
        [%fund]~
    ==
  ++  oath                                       ::  text of assessment contract
    |=  wox=@p
    ^-  tape
    %*($ vath wox wox)
  ++  vath                                       ::  versioned text of assessment contract
    |=  [wox=@p ver=over]
    ^-  tape
    |^  =-  "I, {<ses>}, hereby agree to assess the following project proposed by {<wox>}:\0a\0a{txt}"
        ^-  [ses=@p txt=tape]
        :-  p.assessment
        %-  zing  %+  join  "\0a"
        %-  skip  :_  |=(t=tape =(~ t))
        %+  weld
          ^-  (list tape)
          :~  "title: {(trip title)}"
              "oracle: {<p.assessment>} (for {(comp-enjs q.assessment [%chip %0 %0x0 '' '' 6])}%)"
              (swap-enjs payment)
              "summary: {(trip summary)}"
          ==
        %+  turn  (enum:fx miz)
        |=  [min=@ mil=mile]
        ^-  tape
        %-  zing  %+  join  "\0a\09"
        ^-  (list tape)
        :~  "milestone #{<+(min)>}:"
            "title: {(trip title.mil)}"
            "cost: {(comp-enjs cost.mil payment)}"
            "summary: {(trip summary.mil)}"
        ==
    ++  comp-enjs
      |=  [amo=cash swa=swap]
      ^-  tape
      =/  dex=@ud  ?+(-.swa 0 %coin decimals.swa)
      ?+  ver  (comp:enjs:ff amo swa)
          %v0-0-0
        (r-co:co [%d & (pro:si -1 (sun:si dex)) amo])
      ::
          %v0-4-0
        =+  cax=(drg:fl (sun:fl amo))
        ?>  ?=(%d -.cax)
        (flot:fx cax(e (dif:si e.cax (sun:si dex))) ~)
      ==
    ++  swap-enjs
      |=  swa=swap
      ^-  tape
      ?:  ?=(%v0-0-0 ver)  ~
      =-  "{tyt}: {pay}{adr} {med}"
      ^-  [tyt=tape adr=tape med=tape pay=tape]
      :*  tyt=?+(ver "payment" ?(%v1-1-0 %v1-0-0 %v0-4-0) "currency")
          adr=?+(-.swa " ({(addr:enjs:ff addr.swa)})" %chip ~)
          med=?+(-.swa "on eth chain {(bloq:enjs:ff chain.swa)}" %chip "out of band")
      ::
            ^=  pay
          ?+    ver  (swap:enjs:ff swa)
              ?(%v1-0-0 %v0-4-0)
            ?+  symbol.swa  "usdc"
              %'USDC'       "usdc"
              %'WSTR'       "wstr"
              %'fundUSDC'   "usdc"
              %'fundWSTR'   "wstr"
            ==
          ==
      ==
    --
  ++  bail                                       ::  text of bail statement (no payout)
    |=  [min=@ byp=?(%done %dead)]
    ^-  tape
    =-  "I, {ses}, decree {tag}project with safe {saf} {end} with no payout."
    :*  ses=(trip (scot %p p.assessment))
        tag=?-(byp %done "milestone {<+(min)>} of ", %dead ~)
        saf=(addr:enjs:ff safe:(fall contract *^oath))
        end=?-(byp %done "completed", %dead "canceled")
    ==
  --
::
::  +pz: p(rojects) (library); helper door for $proz data (statistics, filters)
::
++  pz
  |_  poz=proz
  ++  skim                                       ::  projects filtered by predicate
    |=  ski=$-([flag proj] ?)
    ^-  proz
    %-  ~(rep by poz)
    |=  [nex=[flag proj] acc=proz]
    ?.((ski nex) acc (~(put by acc) nex))
  ++  skim-role                                  ::  projects filtered by role for ship
    |=  [rol=role sip=@p]
    ^-  proz
    (skim |=([f=flag p=proj] (~(has in (~(rols pj p) p.f sip)) rol)))
  ++  roll                                       ::  reduce all projects by reduction
    |*  rol=$-([flag proj] *)
    ^-  _$:rol
    (^roll ~(tap by poz) rol)
  ++  roll-swap                                  ::  reduce all projects by swap
    |=  p2c=$-(proj cash)
    ^-  (map swap cash)
    %-  ~(rep by poz)
    |=  [[lag=flag pro=proj] acc=(map swap cash)]
    =/  amo=cash  (p2c pro)
    ?:  =(0 amo)  acc
    %+  ~(put by acc)  payment.pro
    (add amo (~(gut by acc) payment.pro 0))
  ::
  ++  uniq                                       ::  unique content for all projects
    |*  piq=$-([flag proj] (list))
    %-  silt
    ^-  _$:piq
    (zing (turn ~(tap by poz) piq))
  ++  uniq-work                                  ::  unique workers for all projects
    ^-  (set @p)
    (~(uniq pz poz) |=([f=flag *] `(list @p)`[p.f]~))
  ++  uniq-orac                                  ::  unique oracles for all projects
    ^-  (set @p)
    (~(uniq pz poz) |=([* p=proj] `(list @p)`[p.assessment.p]~))
  ++  uniq-trib                                  ::  unique contributors for all projects
    ^-  (set addr)
    %-  ~(uniq pz poz)
    |=  [* pro=proj]
    ^-  (list addr)
    %+  murn  (~(mula pj pro) (sy ~[%pruf %trib]) ~)
    |=(m=mula ?.(?=(?(%trib %pruf) -.m) ~ `from.when.m))
  ++  uniq-plej                                  ::  unique pledgers for all projects
    ^-  (set @p)
    %-  ~(uniq pz poz)
    |=  [* pro=proj]
    ^-  (list @p)
    %+  murn  (~(mula pj pro) [%plej ~ ~] ~)
    |=(m=mula ?.(?=(%plej -.m) ~ `ship.m))
  ::
  ++  full                                       ::  non-unique content for all projects
    |*  piq=$-([flag proj] (list))
    ^-  _$:piq
    (zing (turn ~(tap by poz) piq))
  ++  full-mile                                  ::  all milestones (maybe status)
    |=  sut=(set stat)
    ^-  (list mile)
    %-  full
    |=  [* pro=proj]
    (^skim `(list mile)`milestones.pro |=(m=mile |(=(~ sut) (~(has in sut) status.m))))
  ++  full-trib                                  ::  all contributions for all projects (maybe ship)
    |=  sup=(unit [sip=@p was=(set addr)])
    ^-  (list mula)
    (full |=([* p=proj] (~(mula pj p) (sy ~[%trib %pruf-open]) sup)))
  ++  full-plej                                  ::  all pledges for all projects (maybe ship)
    |=  sup=(unit @p)
    ^-  (list mula)
    (full |=([* p=proj] (~(mula pj p) [%plej ~ ~] (bind sup (late *(set addr))))))
  --
--
