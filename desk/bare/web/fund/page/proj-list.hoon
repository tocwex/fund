::  /web/fund/page/proj-list/hoon: render project listing page for %fund
::
/-  fd=fund-data
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder
%-  :(corl mine:preface:fh init:preface:fh)
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  dyp=@tas  (rear (slag:derl:format:fh url.request.ord))
  ?:  &(=(%oracle dyp) !(star:fx src.bol))
    [%code 404 'oracle dashboard only available to stars and galaxies']
  :-  %page
  %-  html:ui:fh
  :^  bol  ord  "{(trip dyp)} dashboard"
  |^  ?+    dyp  !!
          %worker
        =/  my-prez  ~(tap by ~(mine conn:proj:fd bol +.dat))
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
          %+  skim  ~(tap by ~(ours conn:proj:fd bol +.dat))
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
          %+  skim  ~(tap by ~(ours conn:proj:fd bol +.dat))
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
      ;div(class "flex justify-between pb-2")
        ;h1.pt-2: {tyt}
        ;*  ?.  new  ~
            :_  ~  ;a.self-center.fund-butn-ac-m/"{(dest:enrl:format:fh /create/project)}": new project +
      ==
      ;div(class "w-full flex flex-col gap-4")
        ;*  ?~  pez  :_  ~  ;div(class "italics mx-4 text-gray-600"): No projects found.
            %+  turn  pez
            |=  [[sip=@p nam=@tas] pro=proj:f liv=?]
            ^-  manx
            =+  url=(dest:enrl:format:fh /project/(scot %p sip)/[nam])
            ;div(class "w-full flex flex-col p-6 rounded-2xl border-2 border-secondary-500 gap-3")
              ;div(class "w-full flex flex-col gap-3")
                ;+  (odit-ther:ui:fh ~(odit pj:f pro))
                ;div(class "inline-flex self-stretch justify-start items-center gap-3")
                  ;h1: {(trip title.pro)}
                  ;+  (copy-butn:ui:fh bol [sip nam] "🔗")
                  ;*  ?.  &(=(sip our.bol) ?=(?(%born %prop) ~(stat pj:f pro)))  ~
                      :_  ~  ;a.fund-butn-de-m/"{url}/edit": ✏️
                ==
                ;div(class "flex flex-col gap-1 self-stretch")
                  ;div(class "flex flex-row gap-6 pl-3")
                    ;+  (ship-bump "Project Worker" sip)
                    ;+  (ship-bump "Trusted Oracle" p.assessment.pro)
                  ==
                  ;+  (mark-well:ui:fh (trip summary.pro) |)
                ==
              ==
              ;div(class "inline-flex justify-between items-end self-stretch pl-3")
                ;div(class "flex flex-row gap-2 item-center")
                  ;img.h-12@"{(aset:enrl:format:fh name.currency.pro)}";
                  ::  FIXME: Need a Hoon-based solution for associating chain
                  ::  IDs with human-readable names
                  ;div(class "flex flex-col justify-center items-start")
                    ;h1: {(cash:enjs:format:fh ~(cost pj:f pro))} ${(cuss (trip name.currency.pro))}
                    ;h6(class "leading-none tracking-widest")
                      ; Deployed On {?:(=(1 chain.currency.pro) "Mainnet" "Sepolia")}
                    ==
                  ==
                ==
                ;a.fund-butn-de-m/"{url}": view project →
              ==
            ==
      ==
    ==
  ++  ship-bump
    |=  [tyt=tape sip=@p]
    ^-  manx
    ;div(class "flex flex-col justify-center gap-1")
      ;h6(class "leading-none tracking-widest"): {tyt}
      ;div(class "inline-flex items-center gap-2")
        ;+  (~(ship-icon ui:fh "h-8") sip)
        ;h5(class "font-semibold leading-tight tracking-tight"): {<sip>}
      ==
    ==
  --
--
::  VERSION: [0 4 1]
