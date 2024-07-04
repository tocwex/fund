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
  %-  page:ui:fh
  :^  bol  ord  "{(trip dyp)} dashboard"
  |^  ;div(class "flex flex-col p-2 gap-y-2 max-w-[640px] mx-auto")
        ;*  %-  turn  :_  prez-welz
            ?+    dyp  !!
                %worker
              =/  myn  ~(tap by ~(mine conn:proj:fd bol +.dat))
              :~  :+  "My Draft Proposals"  &
                    (skim myn |=([* p=proj:f *] ?=(?(%born %prop) ~(stat pj:f p))))
                  :+  "My Open Projects"  |
                    (skim myn |=([* p=proj:f *] ?=(?(%lock %work %sess) ~(stat pj:f p))))
                  :+  "My Project Archive"  |
                    (skim myn |=([* p=proj:f *] ?=(?(%dead %done) ~(stat pj:f p))))
              ==
            ::
                %oracle
              =/  orz
                %+  skim  ~(tap by ~(ours conn:proj:fd bol +.dat))
                |=  [[sip=@p *] pro=proj:f liv=?]
                (~(has in (~(rols pj:f pro) sip our.bol)) %orac)
              :~  :+  "Requests for My Services"  |
                    (skim orz |=([* p=proj:f *] ?=(%prop ~(stat pj:f p))))
                  :+  "My Open Assessment Projects"  |
                    (skim orz |=([* p=proj:f *] ?=(?(%lock %work %sess) ~(stat pj:f p))))
                  :+  "My Assessment Archive"  |
                    (skim orz |=([* p=proj:f *] ?=(?(%dead %done) ~(stat pj:f p))))
              ==
            ::
                %funder
              =/  fuz
                %+  skim  ~(tap by ~(ours conn:proj:fd bol +.dat))
                |=  [[sip=@p *] pro=proj:f liv=?]
                (~(has in (~(rols pj:f pro) sip our.bol)) %fund)
              :~  :+  "My Open Pledges"  |
                    (skim fuz |=([* p=proj:f *] (~(has by pledges.p) our.bol)))
                  :+  "Projects I Funded"  |
                    %+  skim  fuz
                    |=([* p=proj:f *] (lien contribs.p |=(t=trib:f ?~(ship.t | =(our.bol u.ship.t)))))
                  ::  :+  "Projects from %pals"  |
                  ::    *(list [flag:f prej:f])
              ==
            ==
      ==
  ++  prez-welz
    |=  [tyt=tape new=bean pez=(list [flag:f prej:f])]
    ^-  manx
    ;div(class "flex flex-col gap-y-2")
      ;div(class "flex justify-between")
        ;h1: {tyt}
        ;*  ?.  new  ~
            :_  ~  ;a.self-center.fund-butn-ac-m/"{(dest:enrl:format:fh /create/project)}": new project +
      ==
      ;div(class "w-full flex flex-col gap-4")
        ;*  ?~  pez  :_  ~  ;p(class "fund-warn"): No projects found.
            %+  turn  pez
            |=  [lag=flag:f pro=proj:f liv=?]
            ^-  manx
            ;div(class "w-full flex flex-col p-6 rounded-2xl border-2 border-secondary-500 gap-3")
              ;div(class "w-full flex flex-col gap-3")
                ;+  (proj-ther:ui:fh pro |)
                ;div(class "inline-flex self-stretch justify-start items-center gap-3")
                  ;h1: {(trip title.pro)}
                  ;+  (pink-butn:ui:fh bol lag)
                  ;+  (edit-butn:ui:fh lag)
                ==
                ;*  ?~  image.pro  ~
                    :_  ~
                    ;img@"{(trip u.image.pro)}"(class "max-w-full max-h-[40vh] mx-auto");
                ;div(class "flex flex-col gap-1 self-stretch")
                  ;div(class "flex flex-row gap-6 pl-3")
                    ;+  (ship-bump "Project Worker" p.lag)
                    ;+  (ship-bump "Trusted Oracle" p.assessment.pro)
                  ==
                  ;+  (mark-well:ui:fh (trip summary.pro) %ters)
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
                ;a.fund-butn-de-m/"{(flat:enrl:format:fh lag)}": view project →
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
