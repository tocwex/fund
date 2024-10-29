::  /web/fund/page/prof-view/hoon: profile page for ship
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fh=fund-http
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
  =/  ui
    |_  cas=tape
    ++  prez-well
      |=  [tyt=tape pez=(list prej:proj:f)]
      ^-  manx
      ;div
        ;h3: {tyt}
        ;ul
          ;li
            ;span(class "font-semibold"): Unique Donors:
            ;+  =-  ;span:  {(bloq:enjs:ff:fh don)}
                ^-  don=@ud
                %~  wyt  in
                ^-  (set addr:f)
                %+  roll  pez
                |=  [nex=prej:proj:f acc=(set addr:f)]
                %-  ~(uni in acc)
                %-  silt
                %+  murn  ~(rula pj:fj -.nex)
                |=(m=mula:f ?.(?=(?(%trib %pruf) -.m) ~ `from.when.m))
          ==
          ;li
            ;span(class "font-semibold"): Total Contributions:
            ;+  =-  ;span:  {(bloq:enjs:ff:fh con)}
                ^-  con=@ud
                %+  roll  pez
                |=  [nex=prej:proj:f acc=@ud]
                (add acc (lent ~(rula pj:fj -.nex)))
          ==
          ;li
            ;span(class "font-semibold"): Amount Raised:
            ;ul
              ;*  =-  %+  turn  ~(tap by raz)
                      |=  [swa=swap:f amo=cash:f]
                      ;li
                        ;span(class "italic"): {(swap:enjs:ff:fh swa)}:
                        ;span:  {(comp:enjs:ff:fh amo swa)}
                      ==
                  ^-  raz=(map swap:f cash:f)
                  %+  roll  pez
                  |=  [nex=prej:proj:f acc=(map swap:f cash:f)]
                  =/  amo=cash:f  ~(fill pj:fj -.nex)
                  ?:  =(0 amo)  acc
                  %+  ~(put by acc)  payment.nex
                  (add amo (~(gut by acc) payment.nex 0))
            ==
          ==
          ;li
            ;span(class "font-semibold"): Amount Claimed:
            ;ul
              ;*  =-  %+  turn  ~(tap by caz)
                      |=  [swa=swap:f amo=cash:f]
                      ;li
                        ;span(class "italic"): {(swap:enjs:ff:fh swa)}:
                        ;span:  {(comp:enjs:ff:fh amo swa)}
                      ==
                  ^-  caz=(map swap:f cash:f)
                  %+  roll  pez
                  |=  [nex=prej:proj:f acc=(map swap:f cash:f)]
                  =/  amo=cash:f  ~(take pj:fj -.nex)
                  ?:  =(0 amo)  acc
                  %+  ~(put by acc)  payment.nex
                  (add amo (~(gut by acc) payment.nex 0))
            ==
          ==
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
      ;h1-alt: {(ship:enjs:ff:fh sip)} User Profile
      ;+  %+  prez-well:ui  "Worker Projects"
          ~(val by ~(mine conn:proj:fd bol [proj-subs proj-pubs]:dat))
      ;+  %+  prez-well:ui  "Oracle Projects"
          %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
          |=  [[flag:f nex=prej:proj:f] acc=(list prej:proj:f)]
          ?.  =(sip p.assessment.nex)  acc  [nex acc]
    ==
  ==
--
::  VERSION: [1 4 5]
