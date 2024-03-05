::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder, s=server
^-  pag-now:f
::
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  ::  TODO: Gate users `!=(our.bol src.bol)` to only my projects?
  ?~  pre=(~(get by (prez-ours:sss:f bol dat)) lag)  [%code 404 '']
  =*  pro  -.u.pre
  =/  [jin=@ jil=mile:f]  ~(next-fill pj:f pro)
  =/  cos=@rs  ~(cost pj:f pro)
  =/  fil=@rs  ~(fill pj:f pro)
  =/  pej=@rs  ~(plej pj:f pro)
  =/  unf=@rs  =+(u=(sub:rs cos (add:rs fil pej)) ?:((gth:rs u .0) u .0))
  =/  sat=stat:f  ~(stat pj:f pro)
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "{(trip title.pro)}"
  ;div(id "maincontent", class "mx-auto lg:px-4")
    ;div(id "maincontent", class "mx-auto")
      ;div(class "flex flex-wrap items-center justify-between")
        ;div(class "px-4 text-4xl sm:text-5xl"): {(trip title.pro)}
        ;+  (stat-pill:htmx:fh sat)
      ==
      ;+  ?~  image.pro  ;div;
          ;img@"{(trip u.image.pro)}"(class "mx-auto w-full my-2 sm:px-4");
      ;div(class "lg:flex")
        ;div(class "no-flex sm:gap-x-10")
          ;div(class "")
            ;div(class "mx-auto flex px-4 justify-between sm:justify-normal sm:gap-x-16")
              ;div(class "my-1 py-1 justify-normal items items-center gap-x-4")
                ;div(class "text-sm font-light underline")
                  ; project worker
                ==
                ;div(class "items-center gap-x-2")
                  ;div(class "mx-1 text-lg font-mono text-nowrap")
                    ; {(trip (scot %p p.lag))}
                  ==
                  ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                    ; send message →
                  ==
                ==
              ==
              ;div(class "m-1 p-1 justify-normal items items-center gap-x-4")
                ;div(class "text-sm font-light underline")
                  ; escrow assessor
                ==
                ;div(class "items-center gap-x-2")
                  ;div(class "mx-1 text-lg font-mono text-nowrap")
                    ; {(trip (scot %p p.assessment.pro))}
                  ==
                  ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                    ; send message →
                  ==
                ==
              ==
            ==
            ;div(class "my-1 mx-3 p-1 whitespace-normal sm:text-lg")
              ; {(trip summary.pro)}
            ==
          ==
        ==
        ;div(class "m-2 p-2 justify-end bg-white rounded-lg")
          ;div(class "flex my-2")
            ;div(class "text-3xl text-nowrap"): Funding Goal:
            ;div(class "pl-2 text-3xl font-medium"): ${(r-co:co (rlys cos))}
          ==
          ;div(class "p-2 border-2 border-black rounded-xl")
            ;div(id "Contribute", class "p-2 text-3xl w-full"): Contribute
            ;div(class "")
              ;div(class "flex gap-2")
                ;div(class "p-2 w-full")
                  ;div(class "p-1 border-black font-light")
                    ; amount
                  ==
                  ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "$10,000");
                ==
                ;div(class "p-2")
                  ;div(class "p-1 border-black font-light")
                    ; token
                  ==
                  ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "USDC");
                ==
              ==
              ;div(class "p-2")
                ;div(class "p-1 border-black font-light")
                  ; contributor
                ==
                ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "~lagrev-nocfep");
              ==
              ;div(class "p-2")
                ;div(class "p-1 border-black font-light")
                  ; message
                ==
                ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "hello ~zod!");
              ==
              ;div(id "contribution-buttons", class "p-2 flex justify-end gap-x-2")
                ;button(onclick "location.href='/apps/fund/modals/modal-confirm-pledge-app'", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                  ; pledge only ~
                ==
                ;button(onclick "signMessage()", class "text-nowrap px-2 py-1 border-2 border-green-600 rounded-md text-white bg-green-600 hover:border-green-500 hover:bg-green-500 active:border-green-700 active:bg-green-700")
                  ; send funds ✓
                ==
              ==
            ==
          ==
        ==
      ==
      ;div(class "px-4")
        ;div(class "text-3xl pt-2"): Contribution Tracker
        ;div(class "")
          ;div(class "flex justify-between")
            ;div(class "flex")
              ::  TODO: Need to fill in actual values here (only say
              ::  milestone `jin` is done if it has surpassed fulfilled
              ::  (pledged?) funding).
              ;div(class "m-1 p-1"): Milestone Progress
              ;div(class "m-1 p-1 font-medium"): {<+(jin)>}/{<(lent milestones.pro)>}
            ==
            ;div(class "flex")
              ;div(class "m-1 p-1"): Goal
              ;div(class "m-1 p-1 font-medium"): ${(r-co:co (rlys cos))}
            ==
          ==
          ;div(class "m-1 p-1 border-2 border-black text-xl")
            ; thermometer placeholder
          ==
          ;div(class "m-1 p-1 flex justify-between")
            ;div(class "m-1 p-1black")
              ::  TODO: Need to calculate based on completed milestone sum
              ;span(class "underline font-medium"): ${(r-co:co (rlys .0))}
              ; Paid
            ==
            ;div(class "m-1 p-1black")
              ;span(class "underline font-medium"): ${(r-co:co (rlys fil))}
              ; Fulfilled
            ==
            ;div(class "m-1 p-1black")
              ;span(class "underline font-medium"): ${(r-co:co (rlys pej))}
              ; Pledged
            ==
            ;div(class "m-1 p-1black")
              ;span(class "underline font-medium"): ${(r-co:co (rlys unf))}
              ; Unfunded
            ==
          ==
        ==
      ==
      ;div(class "px-4")
        ;div(class "text-3xl pt-2"): Milestone Overview
        ;*  =/  fiz=(list @rs)  ~(film pj:f pro)
            %+  turn  (enum:fx `(list mile:f)`milestones.pro)
            |=  [pin=@ mil=mile:f]
            ^-  manx
            =/  fil=@rs  (snag pin fiz)
            ;div(class "my-4 p-4 border-2 border-black rounded-xl")
              ;div(class "flex flex-wrap justify-between items-center gap-2")
                ;div(class "sm:text-nowrap text-2xl")
                  ; Milestone {<+(pin)>}: {(trip title.mil)}
                ==
                ;+  (stat-pill:htmx:fh status.mil)
              ==
              ;div(class "flex flex-wrap justify-between items-center")
                ;div(class "px-2")
                  ;span(class "underline"): ${(r-co:co (rlys cost.mil))}
                  ; target
                ==
                ;div(class "px-2")
                  ;span(class "underline"): ${(r-co:co (rlys fil))}
                  ; fulfilled
                ==
                ::  TODO: Fill this in based on total pledges
                ;div(class "px-2")
                  ;span(class "underline"): ${(r-co:co (rlys .0))}
                  ; pledged
                ==
                ::  TODO: Fill this in based on total pledges
                ;div(class "px-2")
                  ;span(class "underline"): ${(r-co:co (rlys .0))}
                  ; unfunded
                ==
              ==
              ;div(class "pb-2"): {(trip summary.mil)}
            ==
      ==
      ;div(class "px-4")
        ;div(class "text-3xl pt-2"): Proposal Funders
        ;*  =/  pr-mula=(list mula:f)  ~(mula pj:f pro)
            ?~  pr-mula
              :~  ;div(class "italics mx-4 text-gray-600")
                    ; No contributors found.
              ==  ==
            %+  turn  pr-mula
            |=  mul=mula:f
            ^-  manx
            =/  [wat=@t who=@t cas=tape]
              ?:  ?=(%plej -.mul)
                ['pledged' (scot %p ship.mul) "border-yellow-500 text-yellow-500"]
              :-  'fulfilled'  :_  "border-green-500 text-green-500"
              ?~(ship.mul 'anonymous' (scot %p u.ship.mul))
            ;div(class "my-2 p-2 border-2 border-black flex items-center justify-between gap-x-2 rounded-md")
              ;div(class "flex flex-wrap sm:flex-nowrap sm:items-center gap-x-2")
                ;div(class "p-1 font-mono text-nowrap"): {(trip who)}
                ;div(class "p-1"): {(trip note.mul)}
              ==
              ;div(class "flex flex-wrap sm:flex-nowrap items-center")
                ;div(class "mx-auto p-1 font-semibold"): ${(r-co:co (rlys cash.mul))}
                ;div(class "mx-auto p-1 flex")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full font-medium {cas}")
                    ; {(trip wat)}
                  ==
                ==
              ==
            ==
      ==
    ==
  ==
--
