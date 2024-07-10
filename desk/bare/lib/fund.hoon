/-  *fund
/+  format=fund-form, format-0=fund-form-0, fx=fund-xtra, tx=naive-transactions
|%
::
::  +filo: fill in an $odit by calculating `void` (if required)
::
++  filo
  |=  odi=odit
  ^-  odit
  %_    odi
      void
    ?^  void.odi  void.odi
    =+  fil=(add fill.odi plej.odi)
    `[(gth cost.odi fil) (sub (max cost.odi fil) (min cost.odi fil))]
  ==
::
::  +tula: t(ime) associated with a $(m)ula (measured by block height)
::
++  tula
  |=  mul=mula
  ^-  bloq
  ?-  -.mul
    %plej  when.mul
    %trib  p.xact.when.mul
  ==
::
::  +csig: c(heck) (Ethereum EIP-191) sig(nature)
::
++  csig
  |=  sig=sigm
  ^-  bean
  =-  ?~(- | =(u.- from.sig))
  ^-  (unit @ux)
  =/  dat=tape  =+(t=(trip `@t`p.mesg.sig) ?-(-.mesg.sig %& t, %| (flop t)))
  =/  msg=tape  "\19Ethereum Signed Message:\0a{(a-co:co (met 3 p.mesg.sig))}{dat}"
  ::  FIXME: Should use +crip instead of +rep, but can't due to a bug in
  ::  +crip dealing with tapes containing \00 entries; see:
  ::  https://github.com/urbit/urbit/pull/6818
  =/  syg=octs  (as-octs:mimes:html (rep 3 msg))
  (verify-sig:tx sign.sig syg)
::
::  +pj: p(ro)j(ect) (library); helper door for $proj data
::
++  pj
  |_  proj
  ::  FIXME: All the `wox=@p` function signatures will be simplified
  ::  once a project stores/supports multiple different workers
  +*  milestonez  `(list mile)`milestones
  ++  stat                                       ::  project-wide status
    ^-  ^stat
    status:mil:next
  ++  cost                                       ::  summed milestone costs
    ^-  cash
    (roll (turn milestonez |=(n=mile cost.n)) add)
  ++  plej                                       ::  summed pledge amounts
    ^-  cash
    %+  roll  ~(val by pledges)
    |=([n=^plej a=cash] (add a cash.n))
  ++  fill                                       ::  project-wide cost fill
    ^-  cash
    (roll (turn contribs |=(t=trib cash.t)) add)
  ++  take                                       ::  project-wide claimed funds
    ^-  cash
    %-  roll  :_  add
    %+  turn  milestonez
    |=  mil=mile
    ?.  ?&  ?=(%done status.mil)
            ?=(^ withdrawal.mil)
            ?=(^ xact.u.withdrawal.mil)
        ==
      0
    cash.u.withdrawal.mil
  ++  odit                                       ::  project-wide audit
    ^-  ^odit
    (filo [cost fill plej ~])
  ++  odim                                       ::  per-milestone audit
    ^-  (list ^odit)
    =/  lin=@  (dec (lent milestonez))
    ::  NOTE: Use @sd values since the last milestone can have an overage,
    ::  which produces negative fill values (reconciled in `+filo`)
    =<  -  %^  spin  milestonez  [0 (sun:si fill) (sun:si plej)]
    |=  [mil=mile min=@ fre=@sd pre=@sd]
    =+  dun=&(?=(?(%done %dead) status.mil) ?=(^ withdrawal.mil))
    =+  end==(min lin)
    =+  fos=(sun:si ?:(!dun cost.mil cash:(need withdrawal.mil)))
    =+  fil=?:(|(end =(-1 (cmp:si fre fos))) fre fos)
    =+  pos=?:(!dun (dif:si fos fil) --0)
    =+  pej=?:(|(end =(-1 (cmp:si pre pos))) pre pos)
    [(filo [cost.mil (abs:si fil) (abs:si pej) ~]) +(min) (dif:si fre fil) (dif:si pre pej)]
  ++  mula                                       ::  project-wide $mula list
    ^-  (list ^mula)
    =-  (sort - |=([m=^mula n=^mula] (gth (tula m) (tula n))))
    %+  welp  (turn contribs |=(t=trib `^mula`[%trib t]))
    (turn ~(val by pledges) |=(p=^plej `^mula`[%plej p]))
  ++  next                                       ::  next active milestone
    ^-  [min=@ mil=mile]
    ::  NOTE: Provide index past last milestone when all are completed
    =-  ?^(- i.- [(lent milestonez) (rear milestonez)])
    %+  skip  (enum:fx milestonez)
    |=([@ n=mile] ?=(?(%done %dead) status.n))
  ++  rols                                       ::  project $role(s) of user
    |=  [wox=@p who=@p]
    ^-  (set role)
    %-  silt
    ;:  welp
        ?.(=(wox who) ~ [%work]~)
        ?.(=(p.assessment who) ~ [%orac]~)
        ?.  ?|  (~(has by pledges) who)
                (lien contribs |=(t=trib ?~(ship.t | =(u.ship.t who))))
            ==
          ~
        [%fund]~
    ==
  ++  oath                                       ::  text of assessment contract
    |=  wox=@p
    ^-  tape
    %*($ vath wox wox)
  ++  vath                                       ::  versioned text of assessment contract
    |=  [wox=@p ver=?(%v0-4-0 %v1-0-0)]
    ^-  tape
    ::  TODO: For version 1.1, need to manipulate currency values (use
    ::  symbol for both name and symbol, and make it all lowercase)
    =+  cash-enjs=?+(ver cash:enjs:format %v0-4-0 cash:enjs:format-0)
    =-  "I, {<p.assessment>}, hereby agree to assess the following project proposed by {<wox>}:\0a\0a{-}"
    %-  roll  :_  |=([n=tape a=tape] ?~(a n :(welp a "\0a" n)))
    %+  weld
      ^-  (list tape)
      :~  "title: {(trip title)}"
          "oracle: {<p.assessment>} (for {(cash-enjs q.assessment)}%)"
          "currency: {(trip name.currency)} ({(addr:enjs:format addr.currency)}) on eth chain {(bloq:enjs:format chain.currency)}"
          "summary: {(trip summary)}"
      ==
    %+  turn  (enum:fx milestonez)
    |=  [min=@ mil=mile]
    ^-  tape
    %-  roll  :_  |=([n=tape a=tape] ?~(a n :(welp a "\0a\09" n)))
    ^-  (list tape)
    :~  "milestone #{<+(min)>}:"
        "title: {(trip title.mil)}"
        "cost: {(cash-enjs cost.mil)}"
        "summary: {(trip summary.mil)}"
    ==
  --
--
