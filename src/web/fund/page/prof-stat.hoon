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
  ?.  =(our src):bol
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
      |=  [tyt=tape sam=(map swap:f cash:f)]
      ^-  manx
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
      |=  [rul=(unit role:f) tyt=tape]
      ^-  manx
      =/  fun=bean  ?=([~ %fund] rul)
      =/  sup=(unit [@p (set addr:f)])
        ?.  fun  ~
        `[sip .^((set addr:f) (beag:fx bol /prof/(scot %p sip)/adrs))]
      =/  poz
        %~  .  pz:fj
        =+  pom=(~(run by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat)) head)
        ?~(rul pom (~(skim-role pz:fj pom) u.rul sip))
      ;div
        ;h3: {tyt}
        ;ul
          ;+  (prez-stat "Total Projects" (bloq:enjs:ff:fh ~(wyt by `proz:proj:f`+<:poz)))
          ;+  %-  prez-stat
              ?-  fun
                %&  ["Unique Workers" (bloq:enjs:ff:fh ~(wyt in uniq-work:poz))]
                %|  ["Unique Donors" (bloq:enjs:ff:fh ~(wyt in uniq-trib:poz))]
              ==
          ;+  %-  prez-stat
              ?-  fun
                %&  ["Unique Oracles" (bloq:enjs:ff:fh ~(wyt in uniq-orac:poz))]
                %|  ["Unique Pledgers" (bloq:enjs:ff:fh ~(wyt in uniq-plej:poz))]
              ==
          ;+  %+  prez-stat  "Total Contributions"
              (bloq:enjs:ff:fh (lent (full-trib:poz sup)))
          ;+  %+  prez-stat  "Total Pledges"
              (bloq:enjs:ff:fh (lent (full-plej:poz (bind sup head))))
          ;+  %-  prez-swal
              ?-  fun
                %&  ["Amount Raised" (roll-swap:poz |=(p=proj:proj:f ~(fill pj:fj p)))]
              ::
                  %|
                :-  "Amount Contributed"
                %-  roll-swap:poz
                |=(p=proj:proj:f (taly:fk (~(mula pj:fj p) (sy ~[%trib %pruf-open]) sup)))
              ==
          ;*  ?:  fun  ~
              :_  ~  (prez-swal "Amount Claimed" (roll-swap:poz |=(p=proj:proj:f ~(take pj:fj p))))
          ;*  ?:  fun  ~
              :_  ~  (prez-swal "Amount Refunded" (roll-swap:poz |=(p=proj:proj:f ~(give pj:fj p))))
          ;+  %+  prez-swal  "Amount Pledged"
              (roll-swap:poz |=(p=proj:proj:f (taly:fk (~(mula pj:fj p) [%plej ~ ~] sup))))
          ;+  %+  prez-swal  "Outstanding Pledged"
              (roll-swap:poz |=(p=proj:proj:f (taly:fk (~(mula pj:fj p) [%plej-open ~ ~] sup))))
          ;+  %+  prez-swal  "Fulfilled Pledged"
              (roll-swap:poz |=(p=proj:proj:f (taly:fk (~(mula pj:fj p) [%plej-trib ~ ~] sup))))
          ;+  %+  prez-swal  "Welched Pledged"
              (roll-swap:poz |=(p=proj:proj:f (taly:fk (~(mula pj:fj p) [%plej-stif ~ ~] sup))))
          ;+  %+  prez-swal  "Forgiven Pledged"
              (roll-swap:poz |=(p=proj:proj:f (taly:fk (~(mula pj:fj p) [%plej-slyd ~ ~] sup))))
          ;+  %+  prez-stat  "Average Fulfillment Lapse"
              ::  FIXME: This needs to be normalized (or, more
              ::  appropriately, separated out) by chain; currently
              ::  always assuming mainnet
              =-  ?~(val=(toi:rs -) "(unknown)" "{(span:enjs:ff:fh (droq:fk (abs:si u.val) 1))}")
              =-  (div:rs (sun:rs sum) (sun:rs con))
              ^-  [con=@ud sum=@ud]
              =-  :-  (lent tez)
                  %-  roll  :_  add
                  (turn tez |=(t=treb:f (sub p.xact.when.t ?~(plej.t 0 when.u.plej.t))))
              ^-  tez=(list treb:f)
              %-  full:poz
              |=  [* pro=proj:proj:f]
              %+  murn  (~(mula pj:fj pro) [%trib-plej ~ ~] sup)
              |=(m=mula:f ?.(?=(%trib -.m) ~ (bind (~(get by contribs.pro) q.xact.when.m) head)))
          ;+  %+  prez-stat  "Average Fulfillment Rate"
              =-  "{-}%"
              %-  real:enjs:ff:fh
              =-  (perc:fx (lent fil) (lent all))
              ^-  [all=(list mula:f) fil=(list mula:f)]
              :-  (full-plej:poz (bind sup head))
              (full:poz |=([* p=proj:proj:f] (~(mula pj:fj p) [%plej-trib ~ ~] sup)))
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
      ;p(class "text-yellow-500 border-yellow-500 border rounded-md p-3")
        ; Congratulations on finding our experimental profile pages!
        ; Please feel free
        ;a.text-link(target "_blank", href (chat:enrl:ff:fh ~tocwex)):  to DM ~tocwex
        ;span:  if you have feedback.
      ==
      ;div(class "flex flex-col")
        ;h1: {(ship:enjs:ff:fh sip)}'s Profile
        ;h2-alt: {(ship:enjs:ff:fh our.bol)}'s Lens
      ==
      ;+  (prez-well:ui `%fund "Funder Statistics")
      ;+  (prez-well:ui `%work "Worker Statistics")
      ;*  ?.  (star:fx sip)  ~
          :_  ~  (prez-well:ui `%orac "Oracle Statistics")
      ;*  ?.  &(=(our src):bol =(sip src.bol))  ~
          :_  ~  (prez-well:ui ~ "All Projects")
    ==
  ==
--
::  VERSION: [1 5 5]
