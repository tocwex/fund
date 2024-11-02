::  /web/fund/page/prof-view/hoon: profile page for ship
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
  =/  mes=(map flag:f mete:meta:f)  ~(ours conn:meta:fd bol [meta-subs meta-pubs]:dat)
  =/  waz=(list addr:f)
    .^((list addr:f) %gx (en-beam [our.bol %fund da+now.bol] /prof/(scot %p sip)/adrz/noun))
  =/  was=(set addr:f)  (silt waz)
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
        ;ul
          ;*  %+  turn  ~(tap by sam)
              |=  [swa=swap:f amo=cash:f]
              ;li
                ;span(class "italic"): {(swap:enjs:ff:fh swa)}:
                ;span:  {(comp:enjs:ff:fh amo swa)}
              ==
        ==
      ==
    ++  prez-well
      |=  [tyt=tape pez=(list prej:proj:f)]
      ^-  manx
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
  :^  bol  ord  "{(ship:enjs:ff:fh sip)}'s profile"
  :+  fut=&  hed=&
  ;div(x-data ~)  ::  "prof_view"
    ::  NOTE: Using another trick to always push footer to the bottom
    ::  https://stackoverflow.com/a/59865099
    ;div(class "flex flex-col gap-2 px-2 py-2 sm:px-5 min-h-[100vh]")
      ;h1: {(ship:enjs:ff:fh sip)} User Profile
      ::  TODO: Move to 'stats' page
      ::  ;+  %+  prez-well:ui  "Worker Projects"
      ::      ~(val by ~(mine conn:proj:fd bol [proj-subs proj-pubs]:dat))
      ::  ;+  %+  prez-well:ui  "Oracle Projects"
      ::      %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
      ::      |=  [[flag:f nex=prej:proj:f] acc=(list prej:proj:f)]
      ::      ?.  =(sip p.assessment.nex)  acc  [nex acc]
      ::  ;+  %+  prez-well:ui  "All Projects"
      ::      ~(val by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
      ;div(class "flex flex-col gap-1 text-black")
        ;div(class "flex justify-start gap-2")
          ;+  (~(ship-logo ui:fh "h-32") sip bol)
          ;div(class "flex flex-col justify-between")
            ;div(class "flex flex-col justify-start items-start")
              ;div(class "inline-flex items-center gap-1")
                ;h3
                  ;+  (ship-tytl:ui:fh sip bol)
                ==
                ;+  (copy-butn:ui:fh (ship:enjs:ff:fh sip))
              ==
              ;div(class "inline-flex items-center gap-1")
                ;a/"https://network.urbit.org/{<sip>}"
                    =target  "_blank"
                    =class  "text-base sm:text-xl font-normal hover:text-link"
                  ; AZP: {<`@`sip>}
                ==
                ;+  (copy-butn:ui:fh (bloq:enjs:ff:fh `@`sip))
              ==
            ==
            ;div(class "inline-flex items-center gap-2 sm:gap-4")
              ;*  %-  turn  :_  |=(m=manx (~(hoal ma:fh m) 'adadad'))
                  ;:  welp
                        ?:  %.n  ~  ::  |(!=(our src):bol =(sip src.bol))  ~
                      :_  ~
                      ;a/"{(chat:enrl:ff:fh sip)}"(target "_blank")
                        ;img.fund-butn-icon@"{(aset:enrl:ff:fh %chat)}";
                      ==
                  ::
                      [(sink-butn:ui:fh sip (trip ship-url.pro))]~
                  ::
                        ?.  (star:fx sip)  ~
                      :_  ~
                      ;a/"{(prot:enrl:ff:fh sip)}/stats"(target "_blank")
                        ;img.fund-butn-icon@"{(aset:enrl:ff:fh %etherscan)}";
                      ==
                  ==
            ==
          ==
        ==
      ==
      ;h1-alt: Favorites
      ;+  %:  meta-stax:ui:fh  bol  %smol  'No favorites found.'
              %+  murn  ~(tap in favorites.pro)
              |=  lag=flag:f
              ?~(met=(~(get by mes) lag) ~ `[lag u.met])
          ==
      ;h1-alt: Attested Wallets
      ;+  ?~  waz  ;p.fund-warn: No wallets found.
          ;div(class "w-full overflow-x-auto overflow-y-hidden")
            ;table(class "w-full table-auto border-separate border-spacing-y-2 -mt-2")
              ;thead
                ;tr.text-sm.text-palette-contrast.underline
                  ;th.text-center: chain
                  ;th.text-center: link
                  ;th.text-left: wallet address
                ==
              ==
              ;tbody
                ;*  %+  turn  waz
                    |=  adr=addr:f
                    ^-  manx
                    ;tr.bg-palette-contrast
                      ;td.w-1.whitespace-nowrap.rounded-l-lg.py-4
                        ;+  (~(icon-logo ui:fh "mx-auto") %circ (aset:enrl:ff:fh %ethereum))
                      ==
                      ;td.w-1.whitespace-nowrap
                        ;a/"{(esat:enrl:ff:fh %addr adr 1)}"(target "_blank")
                          ;img.mx-auto.fund-butn-icon@"{(aset:enrl:ff:fh %etherscan)}";
                        ==
                      ==
                      ;td.rounded-r-lg: {(addr:enjs:ff:fh adr)}
                    ==
              ==
            ==
          ==
      ;h1-alt: Fund Contributions
      ;+  =/  txz=(list [flag:f prej:proj:f mula:f])
            =-  %+  sort  txz
                |=  [a=[flag:f prej:proj:f m=mula:f] b=[flag:f prej:proj:f m=mula:f]]
                (gth (tula:fk m.a) (tula:fk m.b))
            ^-  txz=(list [flag:f prej:proj:f mula:f])
            %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
            |=  [[lag=flag:f nex=prej:proj:f] acc=(list [flag:f prej:proj:f mula:f])]
            =-  (welp acc (turn muz |=(mul=mula:f [lag nex mul])))
            ^-  muz=(list mula:f)
            %+  skim  ~(mula pj:fj -.nex)
            |=  mul=mula:f
            =/  who=(unit @p)  ?-(-.mul %trib ship.mul, %plej `ship.mul, %pruf ~)
            =/  adr=(unit addr:f)  ?+(-.mul `from.when.mul %plej ~)
            ?|  ?&(?=(^ who) =(sip u.who))
                ?&  ?=(^ adr)
                    (~(has in was) u.adr)
                    ?!(&(?=(%pruf -.mul) ?=(%with note.mul)))
                ==
            ==
          ?~  txz  ;p.fund-warn: No transactions found.
          ;div(class "w-full overflow-x-auto overflow-y-hidden")
            ;table(class "w-full table-auto border-separate border-spacing-y-2 -mt-2")
              ;thead
                ;tr.text-sm.text-palette-contrast.underline
                  ;th.text-center: amount
                  ;th.text-center: status
                  ;th.text-center: project
                  ;th.text-center: worker
                  ;th.text-center: oracle
                  ;th.text-center: block
                  ;th.text-center: wallet
                  ;th.text-center: transaction
                  ;th.text-left: message
                ==
              ==
              ;tbody
                ;*  %+  turn  txz
                    |=  [lag=flag:f pre=prej:proj:f mul=mula:f]
                    ^-  manx
                    ;tr.bg-palette-contrast
                      ;td.italic.w-1.whitespace-nowrap.rounded-l-lg.py-4
                        ; {(swam:enjs:ff:fh cash.mul payment.pre)}
                      ==
                      ;td.w-1.px-2.whitespace-nowrap
                        ;+  (mula-pill:ui:fh %smol mul pre bol)
                      ==
                      ;td(class "font-semibold w-60 overflow-hidden")
                        ;span.line-clamp-1: {(trip title.pre)}
                      ==
                      ;td.w-1.px-4.whitespace-nowrap
                        ::  ;+  (ship-agis:ui:fh %medi p.lag bol)
                        ;+  (ship-agis:ui:fh %medi ~sampel-palnet bol)
                      ==
                      ;td.w-1.px-4.whitespace-nowrap
                        ::  ;+  (ship-agis:ui:fh %medi p.assessment.pre bol)
                        ;+  (ship-agis:ui:fh %medi ~midlev-mindyr bol)
                      ==
                      ;td.w-1.px-2.whitespace-nowrap.text-nowrap
                        ; {(bloq:enjs:ff:fh (tula:fk mul))}
                      ==
                      ;td.w-1.px-2.whitespace-nowrap.text-nowrap.text-center
                        ; {?+(-.mul (sadr:enjs:ff:fh from.when.mul) %plej "—")}
                      ==
                      ;td.w-1.px-2.whitespace-nowrap.text-nowrap.text-center
                        ; {?+(-.mul (sadr:enjs:ff:fh q.xact.when.mul) %plej "—")}
                      ==
                      ;td(class "w-60 overflow-hidden rounded-r-lg")
                        ;span.line-clamp-1: {(trip note.mul)}
                      ==
                    ==
              ==
            ==
          ==
    ==
  ==
--
::  VERSION: [1 4 5]
