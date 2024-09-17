/-  *fund-proj-2
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
  ++  plej                                       ::  summed pledge amounts
    ^-  cash
    %-  ~(rep by pledges)
    |=([[k=@p v=[^plej peta]] a=cash] (add a cash.v))
  ++  fill                                       ::  project-wide cost fill
    ^-  cash
    |^  (add trib-cash pruf-cash)
    ++  trib-cash
      %-  ~(rep by contribs)
      |=([[k=addr v=[treb deta]] a=cash] (add a ?~(pruf.v 0 cash.u.pruf.v)))
    ++  pruf-cash
      %-  ~(rep by proofs)
      |=([[k=addr v=pruf] a=cash] (add a ?-(note.v %with 0, %depo cash.v)))
    --
  ++  take                                       ::  project-wide claimed funds
    ^-  cash
    %-  roll  :_  add
    %+  turn  miz
    |=  mil=mile
    ?.  ?&  ?=(%done status.mil)
            ?=(^ withdrawal.mil)
            ?=(^ xact.u.withdrawal.mil)
            |(=(0x0 q.u.xact.u.withdrawal.mil) ?=(^ pruf.u.withdrawal.mil))
        ==
      0
    cash.u.withdrawal.mil  ::  cash.u.pruf.u.withdrawal.mil
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
    ^-  (list ^mula)
    =-  (sort - |=([m=^mula n=^mula] (gth (tula:fc m) (tula:fc n))))
    ;:  welp
        (turn ~(val by contribs) |=([t=treb *] `^mula`[%trib -.t]))
        (turn ~(val by pledges) |=([p=^plej *] `^mula`[%plej p]))
        (turn ~(val by proofs) |=(p=pruf `^mula`[%pruf p]))
        (murn miz |=(m=mile `(unit ^mula)`?~(withdrawal.m ~ (bind pruf.u.withdrawal.m (lead %pruf)))))
    ==
  ++  bloq                                       ::  project-wide latest block
    ^-  ^bloq
    =/  mul=(list ^mula)  mula
    =/  moq=^bloq  ?~(mul 0 (tula:fc i.mul))
    =/  loq=^bloq  p:xact:(fall contract *^oath)
    (max loq moq)
  ++  next                                       ::  next active milestone
    ^-  [min=@ mil=mile]
    ::  NOTE: Provide index past last milestone when all are completed
    =-  ?^(- i.- [(lent miz) (rear miz)])
    %+  skip  (enum:fx miz)
    |=([@ n=mile] ?=(?(%done %dead) status.n))
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
--
