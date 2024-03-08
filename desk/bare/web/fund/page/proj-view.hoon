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
  =/  sat=stat:f  ~(stat pj:f pro)
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "{(trip title.pro)}"
  ;div(id "maincontent", class "mx-auto py-4 lg:px-4")
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
              ;div(class "text-sm font-light underline"): project worker
              ;div(class "items-center gap-x-2")
                ;div(class "mx-1 mb-2 text-lg font-mono text-nowrap")
                  {(scow %p p.lag)}
                ==
                ;+  ?.  =(our.bol p.lag)
                      ;a/"{(curl:fh p.lag)}"(class butt:claz:fh, target "_blank"): send message →
                    ;a/"{(aurl:fh (snoc pat %edit))}"(class butt:claz:fh): edit project →
              ==
            ==
            ;div(class "m-1 p-1 justify-normal items items-center gap-x-4")
              ;div(class "text-sm font-light underline"): escrow assessor
              ;div(class "items-center gap-x-2")
                ;div(class "mx-1 mb-2 text-lg font-mono text-nowrap")
                  {(scow %p p.assessment.pro)}
                ==
                ;+  ?.  =(our.bol p.assessment.pro)
                      ;a/"{(curl:fh p.assessment.pro)}"(class butt:claz:fh, target "_blank"): send message →
                    ;a/"{(aurl:fh (snoc pat %edit))}"(class butt:claz:fh): edit project →
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
          ;div(class "pl-2 text-3xl font-medium"): ${(mony:dump:fh cos)}
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
              ;button(class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                ; pledge only ~
              ==
              ;button(class "text-nowrap px-2 py-1 border-2 border-green-600 rounded-md text-white bg-green-600 hover:border-green-500 hover:bg-green-500 active:border-green-700 active:bg-green-700")
                ; send funds ✓
              ==
            ==
          ==
        ==
      ==
    ==
    ;div(class "px-4")
      ;div(class "text-3xl pt-2"): Contribution Tracker
      ;div(class "flex flex-col gap-2")
        ;div(class "flex justify-between")
          ;div(class "flex gap-2")
            ::  TODO: Need to fill in actual values here (only say
            ::  milestone `jin` is done if it has surpassed fulfilled
            ::  (pledged?) funding).
            ; Milestone Progress
            ;span(class "font-medium"): {<+(jin)>}/{<(lent milestones.pro)>}
          ==
          ;div(class "flex gap-2")
            ; Goal
            ;span(class "font-medium"): ${(mony:dump:fh cos)}
          ==
        ==
        ;+  (mula-ther:htmx:fh .0 ~(fill pj:f pro) ~(plej pj:f pro))
      ==
    ==
    ;div(class "px-4")
      ;div(class "text-3xl pt-2"): Milestone Overview
      ;*  =/  fiz=(list @rs)  ~(film pj:f pro)
          %+  turn  (enum:fx `(list mile:f)`milestones.pro)
          |=  [pin=@ mil=mile:f]
          ^-  manx
          ;div(class "my-4 p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap justify-between items-center gap-2")
              ;div(class "sm:text-nowrap text-2xl")
                ; Milestone {<+(pin)>}: {(trip title.mil)}
              ==
              ;+  (stat-pill:htmx:fh status.mil)
            ==
            ::  TODO: Fill in pledge amount based on project total
            ;+  (mula-ther:htmx:fh cost.mil (snag pin fiz) .0)
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
          =/  [wat=tape who=tape cas=tape]
            ?:  ?=(%plej -.mul)
              ["pledged" (scow %p ship.mul) "border-yellow-500 text-yellow-500"]
            :-  "fulfilled"  :_  "border-green-500 text-green-500"
            ?~(ship.mul "anonymous" (scow %p u.ship.mul))
          ;div(class "my-2 p-2 border-2 border-black flex items-center justify-between gap-x-2 rounded-md")
            ;div(class "flex flex-wrap sm:flex-nowrap sm:items-center gap-x-2")
              ;div(class "p-1 font-mono text-nowrap"): {who}
              ;div(class "p-1"): {(trip note.mul)}
            ==
            ;div(class "flex flex-wrap sm:flex-nowrap items-center")
              ;div(class "mx-auto p-1 font-semibold"): ${(mony:dump:fh cash.mul)}
              ;div(class "mx-auto p-1 flex")
                ;div(class "text-nowrap py-1 px-2 border-2 rounded-full font-medium {cas}"): {wat}
              ==
            ==
          ==
    ==
  ==
--
