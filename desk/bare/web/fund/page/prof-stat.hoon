::  /web/fund/page/prof-stat/hoon: oracle statistics page for ship
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fk=fund-core, fh=fund-http, fx=fund-xtra
/+  rudder
%-  :(corl dump:preface:fh init:preface:fh (prof:preface:fh &))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [sip=ship pro=pref:prof:f]  (greb:prof:preface:fh arz)
  ?.  |(=(our src):bol =(sip src.bol))
    [%auth url.request.ord]
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
      |=  [tyt=tape pez=(list prej:proj:f) red=$-(prej:proj:f cash:f)]
      ^-  manx
      =/  sam=(map swap:f cash:f)
        %+  roll  pez
        |=  [nex=prej:proj:f acc=(map swap:f cash:f)]
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
      |=  [tyt=tape pix=$-([flag:f prej:proj:f] ?)]
      ^-  manx
      =/  pez=(list prej:proj:f)
        %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
        |=([n=[flag:f prej:proj:f] a=(list prej:proj:f)] ?.((pix n) a [+.n a]))
      ;div
        ;h3: {tyt}
        ;ul
          ;+  %+  prez-stat  "Total Projects"
              (bloq:enjs:ff:fh (lent pez))
          ;+  %+  prez-stat  "Unique Donors"
              %-  bloq:enjs:ff:fh
              %~  wyt  in
              ^-  (set addr:f)
              %+  roll  pez
              |=  [nex=prej:proj:f acc=(set addr:f)]
              %-  ~(uni in acc)
              %-  silt
              %+  murn  ~(fula pj:fj -.nex)
              |=(m=mula:f ?.(?=(?(%trib %pruf) -.m) ~ `from.when.m))
          ;+  %+  prez-stat  "Unique Pledgers"
              %-  bloq:enjs:ff:fh
              %~  wyt  in
              ^-  (set @p)
              %+  roll  pez
              |=  [nex=prej:proj:f acc=(set @p)]
              %-  ~(uni in acc)
              %-  silt
              %+  murn  ~(pula pj:fj -.nex)
              |=(m=mula:f ?.(?=(%plej -.m) ~ `ship.m))
          ;+  %+  prez-stat  "Total Contributions"
              %-  bloq:enjs:ff:fh
              %+  roll  pez
              |=  [nex=prej:proj:f acc=@ud]
              (add acc (lent ~(fula pj:fj -.nex)))
          ;+  %+  prez-stat  "Total Pledges"
              %-  bloq:enjs:ff:fh
              %+  roll  pez
              |=  [nex=prej:proj:f acc=@ud]
              (add acc (lent ~(pula pj:fj -.nex)))
          ;+  (prez-swal "Amount Raised" pez |=(p=prej:proj:f ~(fill pj:fj -.p)))
          ;+  (prez-swal "Amount Claimed" pez |=(p=prej:proj:f ~(take pj:fj -.p)))
          ;+  (prez-swal "Amount Refunded" pez |=(p=prej:proj:f ~(give pj:fj -.p)))
          ;+  %^  prez-swal  "Amount Pledged"  pez
              |=  pre=prej:proj:f
              (roll (turn ~(pula pj:fj -.pre) |=(m=mula:f cash.m)) add)
          ;+  %^  prez-swal  "Outstanding Pledged"  pez
              |=  pre=prej:proj:f
              (roll (turn ~(val by pledges.pre) |=([p=plej:f *] cash.p)) add)
          ;+  %^  prez-swal  "Fulfilled Pledged"  pez
              |=  pre=prej:proj:f
              %-  roll  :_  add
              %+  turn  ~(val by contribs.pre)
              |=([t=treb:f *] ?~(plej.t 0 cash.u.plej.t))
          ;+  %^  prez-swal  "Welched Pledged"  pez
              |=  pre=prej:proj:f
              ?.  ?=(?(%done %dead) ~(stat pj:fj -.pre))  0
              %-  roll  :_  add
              %+  turn  ~(val by pledges.pre)
              |=  [pej=plej:f met=peta:fj]
              ?.(&(?=(^ view.met) ?=(%stif u.view.met)) 0 cash.pej)
          ;+  %^  prez-swal  "Forgiven Pledged"  pez
              |=  pre=prej:proj:f
              ?.  ?=(?(%done %dead) ~(stat pj:fj -.pre))  0
              %-  roll  :_  add
              %+  turn  ~(val by pledges.pre)
              |=  [pej=plej:f met=peta:fj]
              ?.(&(?=(^ view.met) ?=(%slyd u.view.met)) 0 cash.pej)
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
              |=  [nex=prej:proj:f acc=(list treb:f)]
              %+  welp  acc
              (murn ~(val by contribs.nex) |=([t=treb:f *] ?:(?=(~ plej.t) ~ `t)))
          ;+  %+  prez-stat  "Average Fulfillment Rate"
              =-  "{-}%"
              %-  real:enjs:ff:fh
              =-  (perc:fx fil tot)
              ^-  [tot=@ud fil=@ud]
              :-  (roll (turn pez |=(p=prej:proj:f (lent ~(pula pj:fj -.p)))) add)
              %-  roll  :_  add
              %+  turn  pez
              |=(p=prej:proj:f (lent (murn ~(val by contribs.p) |=([t=treb:f *] plej.t))))
        ==
      ==
    --
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "{(ship:enjs:ff:fh sip)}'s statistics"
  :+  fut=&  hed=&
  ;div(x-data ~)
    ::  NOTE: Using another trick to always push footer to the bottom
    ::  https://stackoverflow.com/a/59865099
    ;div(class "flex flex-col gap-2 px-2 py-2 sm:px-5 min-h-[100vh]")
      ;h1: {(ship:enjs:ff:fh sip)}'s Statistics ({(ship:enjs:ff:fh our.bol)}'s Lens)
      ;+  (prez-well:ui "Worker Projects" |=([f=flag:f *] =(sip p.f)))
      ;*  ?.  (star:fx sip)  ~
          [(prez-well:ui "Oracle Projects" |=([* p=prej:proj:f] =(sip p.assessment.p)))]~
      ;*  ?.  &(=(our src):bol =(sip src.bol))  ~
          [(prez-well:ui "All Projects" _&)]~
    ==
  ==
--
::  VERSION: [1 4 5]
