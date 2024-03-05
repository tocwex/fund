::  /web/fund/page/proj-list/hoon: render base page for %fund
::
/+  f=fund, fh=fund-http
/+  rudder, s=server
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [pat=(pole knot) *]  (durl:fh url.request.ord)
  =/  dyp=@tas  (rear `(list knot)`pat)
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "{<dyp>} dashboard"
  |^  ?+    dyp  !!
          %worker
        =/  my-prez  ~(tap by (prez-mine:sss:f bol dat))
        ;div(id "maincontent", class "mx-auto lg:px-4")
          ;+  %^  prez-welz  "My Draft Proposals"  &
              %+  skim  my-prez
              |=([* pro=proj:f liv=?] ?=(?(%born %prop) ~(stat pj:f pro)))
          ;+  %^  prez-welz  "My Open Projects"  |
              %+  skim  my-prez
              |=([* pro=proj:f liv=?] ?=(?(%lock %work %sess) ~(stat pj:f pro)))
          ;+  %^  prez-welz  "My Project Archive"  |
              %+  skim  my-prez
              |=([* pro=proj:f liv=?] ?=(?(%dead %done) ~(stat pj:f pro)))
        ==
      ::
          %assessor
        =/  us-sess
          %+  skim  ~(tap by (prez-ours:sss:f bol dat))
          |=([* pro=proj:f liv=?] =(our.bol p.assessment.pro))
        ;div(id "maincontent", class "mx-auto lg:px-4")
          ;+  %^  prez-welz  "Requests for My Services"  |
              %+  skim  us-sess
              |=([* pro=proj:f liv=?] ?=(%prop ~(stat pj:f pro)))
          ;+  %^  prez-welz  "My Open Assessment Projects"  |
              %+  skim  us-sess
              |=([* pro=proj:f liv=?] ?=(?(%lock %work %sess) ~(stat pj:f pro)))
          ;+  %^  prez-welz  "My Assessment Archive"  |
              %+  skim  us-sess
              |=([* pro=proj:f liv=?] ?=(?(%dead %done) ~(stat pj:f pro)))
        ==
      ::
          %funder
        =/  us-prez  ~(tap by (prez-ours:sss:f bol dat))
        ;div(id "maincontent", class "mx-auto lg:px-4")
          ;+  %^  prez-welz  "My Open Pledges"  |
              %+  skim  us-prez
              |=  [[sip=@p *] pro=proj:f liv=?]
              ?&  &  ::  !=(our.bol sip)
                  (~(has by pledges.pro) our.bol)
              ==
          ;+  %^  prez-welz  "Projects I Funded"  |
              %+  skim  us-prez
              |=  [[sip=@p *] pro=proj:f liv=?]
              ?&  &  ::  !=(our.bol sip)
                  ::  =(%fund (~(gut by rolz.dat) our.bol %look))
                  %+  lien  `(list mile:f)`milestones.pro
                  |=  =mile:f
                  %+  lien  contribs.mile
                  |=(t=trib:f ?~(ship.t | =(our.bol u.ship.t)))
              ==
          ::  ;+  %^  prez-welz  "Projects from %pals"  |
          ::      *(list [flag:f prej:f])
        ==
      ==
  ++  prez-welz
    |=  [tyt=tape new=bean pez=(list [flag:f prej:f])]
    ^-  manx
    ;div
      ;div(class "flex justify-between")
        ;div(class "text-3xl pt-2"): {tyt}
        ;+  ?.  new  ;div;
            ;div(class "px-4 self-center")
              ;a/"{(aurl:fh /create/project)}"(class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                ; New Project +
              ==
            ==
      ==
      ;*  ?~  pez
            :~  ;div(class "italics mx-4 text-gray-600")
                  ; No projects found.
            ==  ==
          %+  turn  pez
          |=  [[sip=@p nam=@tas] pro=proj:f liv=?]
          ^-  manx
          =/  cos=@rs  ~(cost pj:f pro)
          =/  fil=@rs  ~(fill pj:f pro)
          =/  pej=@rs  ~(plej pj:f pro)
          =/  unf=@rs  =+(u=(sub:rs cos (add:rs fil pej)) ?:((gth:rs u .0) u .0))
          ;div(class "m-1 p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap items-center justify-between")
              ;div(class "flex flex-wrap items-center")
                ;div(class "text-2xl pr-4"): {(trip title.pro)}
              ==
              ;+  (stat-pill:htmx:fh ~(stat pj:f pro))
            ==
            ;div(class "flex flex-wrap justify-between items-center")
              ;div(class "px-2")
                ;span(class "underline"): ${(r-co:co (rlys cos))}
                ; target
              ==
              ;div(class "px-2")
                ;span(class "underline"): ${(r-co:co (rlys fil))}
                ; fulfilled
              ==
              ;div(class "px-2")
                ;span(class "underline"): ${(r-co:co (rlys pej))}
                ; pledged
              ==
              ;div(class "px-2")
                ;span(class "underline"): ${(r-co:co (rlys unf))}
                ; unfunded
              ==
            ==
            ;div(class "py-1"): {(trip summary.pro)}
            ;div(class "flex gap-x-4")
              ;a/"{(aurl:fh /project/(scot %p sip)/[nam])}"(class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                ; view project →
              ==
              ;*  ?.  =(our.bol sip)  ~
                :~  ;a/"{(aurl:fh /project/(scot %p sip)/[nam]/edit)}"(class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                      ; edit project →
                ==  ==
            ==
          ==
    ==
  --
--
