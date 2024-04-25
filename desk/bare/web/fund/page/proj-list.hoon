::  /web/fund/page/proj-list/hoon: render base page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder
%-  mine:preface:fh  %-  init:preface:fh
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  dyp=@tas  (rear (slag:derl:format:fh url.request.ord))
  ?:  &(=(%oracle dyp) !(star:fx src.bol))
    [%code 404 'oracle dashboard only available to stars and galaxies']
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "{(trip dyp)} dashboard"
  |^  ?+    dyp  !!
          %worker
        =/  my-prez  ~(tap by (prez-mine:sss:f bol dat))
        ;div#maincontent
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
          %oracle
        =/  us-sess
          %+  skim  ~(tap by (prez-ours:sss:f bol dat))
          |=  [[sip=@p *] pro=proj:f liv=?]
          (~(has in (~(rols pj:f pro) sip our.bol)) %orac)
        ;div#maincontent
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
        =/  us-fund
          %+  skim  ~(tap by (prez-ours:sss:f bol dat))
          |=  [[sip=@p *] pro=proj:f liv=?]
          (~(has in (~(rols pj:f pro) sip our.bol)) %fund)
        ;div#maincontent
          ;+  %^  prez-welz  "My Open Pledges"  |
              %+  skim  us-fund
              |=([* pro=proj:f liv=?] (~(has by pledges.pro) our.bol))
          ;+  %^  prez-welz  "Projects I Funded"  |
              %+  skim  us-fund
              |=([* pro=proj:f liv=?] (lien contribs.pro |=(t=trib:f ?~(ship.t | =(our.bol u.ship.t)))))
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
        ;*  ?.  new  ~
            :_  ~  ;a.self-center.fund-butn-black/"{(dest:enrl:format:fh /create/project)}": New Project +
      ==
      ;*  ?~  pez
            :~  ;div(class "italics mx-4 text-gray-600")
                  ; No projects found.
            ==  ==
          %+  turn  pez
          |=  [[sip=@p nam=@tas] pro=proj:f liv=?]
          ^-  manx
          ;div(class "flex flex-col gap-y-2 m-1 p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap items-center justify-between")
              ;div(class "text-2xl pr-4"): {(trip title.pro)}
              ;div(class "flex items-center gap-x-2")
                ;div(class "text-lg")
                  ; Goal
                  ;span#proj-cost: ${(mony:enjs:format:fh ~(cost pj:f pro))}
                ==
                ;+  (stat-pill:htmx:fh ~(stat pj:f pro))
              ==
            ==
            ;+  (odit-ther:htmx:fh ~(odit pj:f pro))
            ;div(class "py-1"): {(trip summary.pro)}
            ;div(class "flex gap-x-4")
              ;a.fund-butn-link/"{(dest:enrl:format:fh /project/(scot %p sip)/[nam])}": view project →
              ;*  ?.  &(=(sip our.bol) ?=(?(%born %prop) ~(stat pj:f pro)))  ~
                  :_  ~
                  ;a.fund-butn-link/"{(dest:enrl:format:fh /project/(scot %p sip)/[nam]/edit)}": edit project →
            ==
          ==
    ==
  --
--
::  VERSION: [0 1 3]
