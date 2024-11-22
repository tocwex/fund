::  /web/fund/page/prof-stat/hoon: project statistics page for ship
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fk=fund-core, fh=fund-http, fx=fund-xtra
/+  rudder
%-  :(corl dump:preface:fh init:preface:fh (prof:preface:fh |))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [sup=(unit @p) pru=(unit pref:prof:f)]  (grab:prof:preface:fh arz)
  ?.  ?=(^ sup)
    [%code 404 'invalid ship name']
  =*  sip  u.sup
  ::  =/  pro  (fall pru *pref:prof:f)
  ?.  |(=(our src):bol =(sip src.bol))
    [%auth url.request.ord]
  =+  .^(waz=(list addr:f) %gx (en-beam [our.bol %fund da+now.bol] /prof/(scot %p sip)/adrz/noun))
  =/  was=(set addr:f)  (silt waz)
  ::  TODO: Need a UI overhaul (based on input from ~litneb-maltyp)
  =/  ui
    |_  cas=tape
    ++  prez-stat
      |=  [tyt=tape val=tape]
      ^-  manx
      ;li
        ;span(class "font-semibold"): {tyt}:
        ;span:  {val}
      ==
    ++  prez-swal
      |=  [tyt=tape pez=(list [flag:f prej:proj:f]) red=$-(prej:proj:f cash:f)]
      ^-  manx
      =/  sam=(map swap:f cash:f)
        %+  roll  pez
        |=  [[flag:f nex=prej:proj:f] acc=(map swap:f cash:f)]
        =/  amo=cash:f  (red nex)
        ?:  =(0 amo)  acc
        %+  ~(put by acc)  payment.nex
        (add amo (~(gut by acc) payment.nex 0))
      ;li
        ;span(class "font-semibold"): {tyt}:
        ;+  ?:  =(~ sam)  ;span.italic:  None
            ;ul
              ;*  %+  turn  ~(tap by sam)
                  |=  [swa=swap:f amo=cash:f]
                  ;li
                    ;span.italic: {(swap:enjs:ff:fh swa)}:
                    ;span:  {(comp:enjs:ff:fh amo swa)}
                  ==
            ==
      ==
    ++  prez-well
      |=  [fun=? tyt=tape pix=$-([flag:f prej:proj:f] ?)]
      ^-  manx
      =/  pez=(list [flag:f prej:proj:f])
        %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
        |=([n=[flag:f prej:proj:f] a=(list [flag:f prej:proj:f])] ?.((pix n) a [n a]))
      ;div
        ;h3: {tyt}
        ;ul
          ;+  %+  prez-stat  "Total Projects"
              (bloq:enjs:ff:fh (lent pez))
          ;+  ?:  fun
                %+  prez-stat  "Unique Workers"
                %-  bloq:enjs:ff:fh
                %~  wyt  in
                ^-  (set @p)
                %+  roll  pez
                |=  [[nex=flag:f prej:proj:f] acc=(set @p)]
                (~(put in acc) p.nex)
              %+  prez-stat  "Unique Donors"
              %-  bloq:enjs:ff:fh
              %~  wyt  in
              ^-  (set addr:f)
              %+  roll  pez
              |=  [[flag:f nex=prej:proj:f] acc=(set addr:f)]
              %-  ~(uni in acc)
              %-  silt
              %+  murn  ~(fula pj:fj -.nex)
              |=(m=mula:f ?.(?=(?(%trib %pruf) -.m) ~ `from.when.m))
          ;+  ?:  fun
                %+  prez-stat  "Unique Oracles"
                %-  bloq:enjs:ff:fh
                %~  wyt  in
                ^-  (set @p)
                %+  roll  pez
                |=  [[flag:f nex=prej:proj:f] acc=(set @p)]
                (~(put in acc) p.assessment.nex)
              %+  prez-stat  "Unique Pledgers"
              %-  bloq:enjs:ff:fh
              %~  wyt  in
              ^-  (set @p)
              %+  roll  pez
              |=  [[flag:f nex=prej:proj:f] acc=(set @p)]
              %-  ~(uni in acc)
              %-  silt
              %+  murn  ~(pula pj:fj -.nex)
              |=(m=mula:f ?.(?=(%plej -.m) ~ `ship.m))
          ;+  %+  prez-stat  "Total Contributions"
              %-  bloq:enjs:ff:fh
              %+  roll  pez
              |=  [[flag:f nex=prej:proj:f] acc=@ud]
              %+  add  acc
              =/  ful=(list mula:f)  ~(fula pj:fj -.nex)
              %-  lent
              ?.  fun  ful
              %+  murn  ful
              |=  mul=mula:f
              ?.(&(?=(%trib -.mul) (~(has in was) from.when.mul)) ~ `mul)
          ;+  %+  prez-stat  "Total Pledges"
              %-  bloq:enjs:ff:fh
              %+  roll  pez
              |=  [[flag:f nex=prej:proj:f] acc=@ud]
              %+  add  acc
              =/  pul=(list mula:f)  ~(pula pj:fj -.nex)
              %-  lent
              ?.  fun  pul
              %+  murn  pul
              |=  mul=mula:f
              ?.(&(?=(%plej -.mul) =(sip ship.mul)) ~ `mul)
          ;+  ?.  fun  (prez-swal "Amount Raised" pez |=(p=prej:proj:f ~(fill pj:fj -.p)))
              %^  prez-swal  "Amount Contributed"  pez
              |=  pre=prej:proj:f
              %-  roll  :_  add
              %+  turn  ~(fula pj:fj -.pre)
              |=  mul=mula:f
              ?.  ?=(%trib -.mul)  0
              ?.((~(has in was) from.when.mul) 0 cash.mul)
          ;*  ?:  fun  ~
              :_  ~  (prez-swal "Amount Claimed" pez |=(p=prej:proj:f ~(take pj:fj -.p)))
          ;*  ?:  fun  ~
              :_  ~  (prez-swal "Amount Refunded" pez |=(p=prej:proj:f ~(give pj:fj -.p)))
          ;+  %^  prez-swal  "Amount Pledged"  pez
              |=  pre=prej:proj:f
              %-  roll  :_  add
              %+  turn  ~(pula pj:fj -.pre)
              |=  mul=mula:f
              ?.  fun  cash.mul
              ?.(&(?=(%plej -.mul) =(sip ship.mul)) 0 cash.mul)
          ;+  %^  prez-swal  "Outstanding Pledged"  pez
              |=  pre=prej:proj:f
              ?:  ?=(?(%done %dead) ~(stat pj:fj -.pre))  0
              ?:  fun  ?~(pej=(~(get by pledges.pre) sip) 0 cash.u.pej)
              (roll (turn ~(val by pledges.pre) |=([p=plej:f *] cash.p)) add)
          ;+  %^  prez-swal  "Fulfilled Pledged"  pez
              |=  pre=prej:proj:f
              %-  roll  :_  add
              %+  turn  ~(val by contribs.pre)
              |=  [teb=treb:f *]
              ?~  pej=plej.teb  0
              ?.  fun  cash.u.pej
              ?.(=(sip ship.u.pej) 0 cash.u.pej)
          ;+  %^  prez-swal  "Welched Pledged"  pez
              |=  pre=prej:proj:f
              ?.  ?=(?(%done %dead) ~(stat pj:fj -.pre))  0
              %-  roll  :_  add
              %+  turn  ~(val by pledges.pre)
              |=  [pej=plej:f met=peta:fj]
              ?.  &(?=(^ view.met) ?=(%stif u.view.met))  0
              ?.  fun  cash.pej
              ?.(=(sip ship.pej) 0 cash.pej)
          ;+  %^  prez-swal  "Forgiven Pledged"  pez
              |=  pre=prej:proj:f
              ?.  ?=(?(%done %dead) ~(stat pj:fj -.pre))  0
              %-  roll  :_  add
              %+  turn  ~(val by pledges.pre)
              |=  [pej=plej:f met=peta:fj]
              ?.  &(?=(^ view.met) ?=(%slyd u.view.met))  0
              ?.  fun  cash.pej
              ?.(=(sip ship.pej) 0 cash.pej)
          ;+  %+  prez-stat  "Average Fulfillment Lapse"
              =-  "{-} blocks"
              %-  real:enjs:ff:fh
              =-  (div:rs (sun:rs sum) (sun:rs con))
              ^-  [con=@ud sum=@ud]
              =-  :-  (lent tez)
                  %-  roll  :_  add
                  (turn tez |=(t=treb:f (sub p.xact.when.t ?~(plej.t 0 when.u.plej.t))))
              ^-  tez=(list treb:f)
              %+  roll  pez
              |=  [[flag:f nex=prej:proj:f] acc=(list treb:f)]
              %+  welp  acc
              %+  murn  ~(val by contribs.nex)
              |=  [teb=treb:f *]
              ?:(|(?=(~ plej.teb) &(fun !=(sip ship.u.plej.teb))) ~ `teb)
          ;+  %+  prez-stat  "Average Fulfillment Rate"
              =-  "{-}%"
              %-  real:enjs:ff:fh
              =-  (perc:fx fil tot)
              ^-  [tot=@ud fil=@ud]
              :-  %-  roll  :_  add
                  %+  turn  pez
                  |=  [lag=flag:f pre=prej:proj:f]
                  =/  pul=(list mula:f)  ~(pula pj:fj -.pre)
                  %-  lent
                  ?.  fun  pul
                  %+  murn  pul
                  |=  mul=mula:f
                  ?.(&(?=(%plej -.mul) =(sip ship.mul)) ~ `mul)
              %-  roll  :_  add
              %+  turn  pez
              |=  [lag=flag:f pre=prej:proj:f]
              %-  lent
              %+  murn  ~(val by contribs.pre)
              |=  [teb=treb:f *]
              ?:(|(?=(~ plej.teb) &(fun !=(sip ship.u.plej.teb))) ~ `u.plej.teb)
        ==
      ==
    --
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "{(ssip:enjs:ff:fh sip)}'s statistics"
  :+  fut=&  hed=&
  ;div(x-data ~)
    ;div(class "fund-main")
      ;a/"{(prot:enrl:ff:fh sip)}"(class "w-fit hover:text-link"): ← back
      ;div(class "flex flex-col")
        ;h1: {(ship:enjs:ff:fh sip)}'s Profile
        ;h2-alt: {(ship:enjs:ff:fh our.bol)}'s Lens
      ==
      ;+  %^  prez-well:ui  &  "Funder Statistics"
          |=([f=flag:f p=prej:proj:f] (~(has in (~(rols pj:fj -.p) -.f sip)) %fund))
      ;+  %^  prez-well:ui  |  "Worker Statistics"
          |=([f=flag:f p=prej:proj:f] (~(has in (~(rols pj:fj -.p) -.f sip)) %work))
      ;*  ?.  (star:fx sip)  ~
          :_  ~
          %^  prez-well:ui  |  "Oracle Statistics"
          |=([f=flag:f p=prej:proj:f] (~(has in (~(rols pj:fj -.p) -.f sip)) %orac))
      ;*  ?.  &(=(our src):bol =(sip src.bol))  ~
          [(prez-well:ui | "All Projects" _&)]~
    ==
  ==
--
::  VERSION: [1 4 5]
