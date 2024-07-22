::  /web/fund/page/proj-list/hoon: render project listing page for %fund
::
/-  sd=sss-data-proj
/+  f=fund-proj, fh=fund-http, fc=fund-chain, fx=fund-xtra
/+  rudder
%-  :(corl mine:preface:fh init:preface:fh)
^-  page:sd
|_  [bol=bowl:gall ord=order:rudder dat=data:sd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  dyp=@tas  (rear (slag:derl:ff:fh url.request.ord))
  ?:  &(=(%oracle dyp) !(star:fx src.bol))
    [%code 404 'oracle dashboard only available to stars and galaxies']
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "{(trip dyp)} dashboard"
  |^  ;div(class "flex flex-col p-2 gap-y-2 max-w-[640px] mx-auto")
        ;*  %-  turn  :_  prez-welz
            ^-  (list [tape welz-type (list [flag:f prej:f])])
            ?+    dyp  !!
                %worker
              =/  myn  ~(tap by ~(mine conn:proj:sd bol +.dat))
              :~  :+  "My Draft Proposals"  %anew
                    (skim myn |=([* p=proj:f *] ?=(?(%born %prop) ~(stat pj:f p))))
                  :+  "My Open Projects"  %none
                    (skim myn |=([* p=proj:f *] ?=(?(%lock %work %sess) ~(stat pj:f p))))
                  :+  "My Project Archive"  %none
                    (skim myn |=([* p=proj:f *] ?=(?(%dead %done) ~(stat pj:f p))))
              ==
            ::
                %oracle
              =/  orz
                %+  skim  ~(tap by ~(ours conn:proj:sd bol +.dat))
                |=  [[sip=@p *] pro=proj:f liv=?]
                (~(has in (~(rols pj:f pro) sip our.bol)) %orac)
              :~  :+  "Requests for My Services"  %none
                    (skim orz |=([* p=proj:f *] ?=(%prop ~(stat pj:f p))))
                  :+  "My Open Assessment Projects"  %none
                    (skim orz |=([* p=proj:f *] ?=(?(%lock %work %sess) ~(stat pj:f p))))
                  :+  "My Assessment Archive"  %none
                    (skim orz |=([* p=proj:f *] ?=(?(%dead %done) ~(stat pj:f p))))
              ==
            ::
                %funder
              =/  ouz  ~(tap by ~(ours conn:proj:sd bol +.dat))
              :~  :+  "My Open Pledges"  %none
                    (skim ouz |=([* p=proj:f *] (~(has by pledges.p) our.bol)))
                  :+  "Projects I Funded"  %find
                    %+  skim  ouz
                    |=  [* p=proj:f *]
                    %-  ~(rep by contribs.p)
                    |=([[k=addr:f v=[treb:f deta:f]] a=_|] |(a ?~(ship.v | =(our.bol u.ship.v))))
                  :+  "Projects I Bookmarked"  %find
                    %+  skip  ouz
                    |=  [[sip=@p *] pro=proj:f liv=?]
                    ?|  =(sip our.bol)
                        (~(has in (~(rols pj:f pro) sip our.bol)) %fund)
                    ==
                  ::  :+  "Projects from %pals"  %none
                  ::    *(list [flag:f prej:f])
              ==
            ==
      ==
  ++  prez-welz
    |=  [tyt=tape typ=welz-type pez=(list [flag:f prej:f])]
    ^-  manx
    ;div(class "flex flex-col gap-y-2")
      ;div(class "flex justify-between")
        ;h1: {tyt}
        ;*  ?.  ?=(%anew typ)  ~
            :_  ~
            ;a.self-center.fund-butn-ac-m/"{(dest:enrl:ff:fh /create/project)}"
              ; new project +
            ==
      ==
      ;div(class "w-full flex flex-col gap-4")
        ;*  ?~  pez
              :_  ~
              ;p.fund-warn
                ; No projects found.
                ;*  ?.  ?=(%find typ)  ~
                    :_  ~
                    ;span
                      ; Check out the
                      ;a.text-link/"{(burl:fh bol)}/apps/groups/groups/~tocwex/syndicate-public/channels/heap/~tocwex/bulletin-board": ~tocwex.syndicate %tlon group
                      ;span:  to discover more projects.
              ==    ==
            %+  turn  pez
            |=  [lag=flag:f pro=proj:f liv=?]
            ^-  manx
            ;div(class "w-full flex flex-col p-6 rounded-2xl border-2 border-secondary-500 gap-3")
              ;div(class "w-full flex flex-col gap-3")
                ;+  (proj-ther:ui:fh pro |)
                ;div(class "inline-flex self-stretch justify-start items-center gap-3")
                  ;h1: {(trip title.pro)}
                  ;+  (pink-butn:ui:fh bol lag)
                  ;*  ?.  &(=(p.lag our.bol) ?=(?(%born %prop) ~(stat pj:f pro)))  ~
                      :_  ~  (edit-butn:ui:fh lag)
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
                  ;img.h-12@"{(aset:enrl:ff:fh symbol.currency.pro)}";
                  ;div(class "flex flex-col justify-center items-start")
                    ;h1: {(mony:enjs:ff:fh ~(cost pj:f pro) currency.pro)}
                    ;h6(class "leading-none tracking-widest")
                      ; Deployed On {(caps:fx (trip tag:(~(got by xmap:fc) chain.currency.pro)))}
                    ==
                  ==
                ==
                ;a.fund-butn-de-m/"{(flat:enrl:ff:fh lag)}": view project →
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
  +$  welz-type  ?(%anew %find %none)
  --
--
::  VERSION: [1 1 0]
