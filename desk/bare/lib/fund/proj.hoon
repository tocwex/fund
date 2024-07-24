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
            ?=(^ pruf.u.withdrawal.mil)
        ==
      0
    cash.u.pruf.u.withdrawal.mil
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
    =+  dun=&(?=(?(%done %dead) status.mil) ?=(^ withdrawal.mil) ?=(^ pruf.u.withdrawal.mil))
    =+  end==(min lin)
    =+  fos=(sun:si ?.(dun cost.mil cash:(need pruf:(need withdrawal.mil))))
    =+  fil=?:(|(end =(-1 (cmp:si fre fos))) fre fos)
    =+  pos=?.(dun (dif:si fos fil) --0)
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
  ++  next                                       ::  next active milestone
    ^-  [min=@ mil=mile]
    ::  NOTE: Provide index past last milestone when all are completed
    =-  ?^(- i.- [(lent miz) (rear miz)])
    %+  skip  (enum:fx miz)
    |=([@ n=mile] ?=(?(%done %dead) status.n))
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
              "oracle: {<p.assessment>} (for {(cash-enjs q.assessment 6)}%)"
              (coin-enjs currency)
              "summary: {(trip summary)}"
          ==
        %+  turn  (enum:fx miz)
        |=  [min=@ mil=mile]
        ^-  tape
        %-  zing  %+  join  "\0a\09"
        ^-  (list tape)
        :~  "milestone #{<+(min)>}:"
            "title: {(trip title.mil)}"
            "cost: {(cash-enjs cost.mil decimals.currency)}"
            "summary: {(trip summary.mil)}"
        ==
    ++  cash-enjs
      |=  [cas=cash dex=@ud]
      ^-  tape
      ?+  ver    (cash:enjs:ff cas dex)
          %v0-0-0
        (r-co:co [%d & (pro:si -1 (sun:si dex)) cas])
      ::
          %v0-4-0
        =+  cax=(drg:fl (sun:fl cas))
        ?>  ?=(%d -.cax)
        (flot:fx cax(e (dif:si e.cax (sun:si dex))) ~)
      ==
    ++  coin-enjs
      |=  con=coin
      ^-  tape
      ?:  ?=(%v0-0-0 ver)  ~
      =-  "currency: {-} ({(addr:enjs:ff addr.con)}) on eth chain {(bloq:enjs:ff chain.con)}"
      ?+    ver  (coin:enjs:ff con)
          ?(%v1-0-0 %v0-4-0)
        ::  NOTE: These should be the only coin possibilities for
        ::  v0.4.0 and v1.0.0 contracts
        ?+  symbol.con  "usdc"
          %'USDC'       "usdc"
          %'WSTR'       "wstr"
          %'fundUSDC'   "usdc"
          %'fundWSTR'   "wstr"
        ==
      ==
    --
  --
--
