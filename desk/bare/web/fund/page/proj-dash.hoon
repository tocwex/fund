::  /web/fund/page/proj-dash/hoon: render project dashboard page for %fund
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fy=fund, fh=fund-http, fc=fund-chain, fa=fund-alien, fx=fund-xtra
/+  rudder, config
%-  :(corl mine:preface:fh init:preface:fh)
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  dyp=@tas  (rear (slag:derl:ff:fh url.request.ord))
  =/  arm=(map @t @t)  (~(gas by *(map @t @t)) arz)
  =/  arg
    :*  sort=`@t`(~(gut by arm) %sort %time)
        desc=`?`(bool:dejs:ff:fh (~(gut by arm) %desc %true))
        filt=`@t`(~(gut by arm) %filt %swap)
        text=`(unit @t)`(~(get by arm) %text)
        work=`(unit @p)`(bind (~(get by arm) %work) ship:dejs:ff:fh)
        orac=`(unit @p)`(bind (~(get by arm) %orac) ship:dejs:ff:fh)
        stat=`(unit stat:f)`(bind (~(get by arm) %stat) |=(=@t ;;(stat:f t)))
    ::
          ^=  swap  ^-  (unit swap:f)
        ::  FIXME: This only works if all built-in coins have different
        ::  symbols; this will need to be fixed when %fund supports e.g.
        ::  USDC on an L2
        ?~  sym=(~(get by arm) %swap)  ~
        ?~  swa=(find:fx slis:fc |=(b=swap:f =(u.sym symbol.b)))  ~
        `u.swa
    ==
  =/  mes=(map flag:f mete:meta:f)  ~(ours conn:meta:fd bol [meta-subs meta-pubs]:dat)
  =/  pes=(map flag:f prej:proj:f)  ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat)
  =/  sos=tape  "?stroke=%23adadad"  ::  palette-system
  =/  soc=tape  "?stroke=%23dbdbdb"  ::  palette-contrast
  =/  [mez=(map flag:f mete:meta:f) pez=(map flag:f prej:proj:f)]
    ?+  dyp  !!
      %following  [~ pes]
      %discover   [mes ~]
    ::
        %action
      =-  [(- mes) (- pes)]
      |*  mep=(map flag:f *)
      ^+  mep
      ?:  =(~ mep)  *_mep
      %-  ~(rep by mep)
      |=  [kev=_?>(?=(^ mep) n.mep) acc=_mep]
      ^+  acc
      ?~  pre=(~(get by pes) -.kev)  acc
      =/  roz=(set role:f)  (~(rols pj:fj -.u.pre) our.bol our.bol)
      ?:(=(~ roz) acc (~(put by acc) kev))
    ==
  =/  ex
    |%
    +$  mexa  [status=stat:f mete:meta:f]
    ++  proj-mexa
      |=  [lag=flag:f pre=prej:proj:f]
      ^-  mexa
      =+  met=(prej-mete:fy lag pre)
      [~(stat pj:fj -.pre) `mete:meta:f`met(launch ~(bloq pj:fj -.pre))]
    ++  meta-mexa
      |=  [lag=flag:f met=mete:meta:f]
      ^-  mexa
      [%born met]
    --
  =/  [myz=(list [flag:f mete:meta:f]) pyz=(list [flag:f prej:proj:f])]
    =/  mym=(map flag:f mexa:ex)
      %-  ~(rep by mez)
      |=([n=[flag:f mete:meta:f] a=(map flag:f mexa:ex)] (~(put by a) -.n (meta-mexa:ex n)))
    =/  pym=(map flag:f mexa:ex)
      %-  ~(rep by pez)
      |=([n=[flag:f prej:proj:f] a=(map flag:f mexa:ex)] (~(put by a) -.n (proj-mexa:ex n)))
    =-  :*  (turn (- mym) |=([n=flag:f mexa:ex] [n (~(got by mez) n)]))
            (turn (- pym) |=([n=flag:f mexa:ex] [n (~(got by pez) n)]))
        ==
    |=  aym=(map flag:f mexa:ex)
    ^-  (list [flag:f mexa:ex])
    =-  (sort (skim ~(tap by aym) ski) cmp)
    ^-  [ski=$-([flag:f mexa:ex] ?) cmp=$-([[flag:f mexa:ex] [flag:f mexa:ex]] ?)]
    :-  |=  [lag=flag:f mex=mexa:ex]
        ^-  bean
        ?&  ?~(text.arg & ?=(^ (find (cass (trip u.text.arg)) (cass (trip title.mex)))))
            ?~(swap.arg & =(payment.mex u.swap.arg))
            ?~(work.arg & =(worker.mex u.work.arg))
            ?~(orac.arg & =(oracle.mex u.orac.arg))
            ?~(stat.arg & =(status.mex u.stat.arg))
        ==
    |=  [[laa=flag:f mea=mexa:ex] [lab=flag:f meb=mexa:ex]]
    ^-  bean
    ?+  sort.arg  !!
      %time  (?:(desc.arg gth lth) launch.mea launch.meb)
    ::
        %alph
      =+  tea=(cass (trip title.mea))
      =+  teb=(cass (trip title.meb))
      ?:(desc.arg (aor teb tea) (aor tea teb))
    ::
        %cost
      ::  NOTE: Need to normalize currencies based on per-coin decimal counts
      =+  dea=?+(-.payment.mea 0 %coin decimals.payment.mea)
      =+  deb=?+(-.payment.meb 0 %coin decimals.payment.meb)
      =+  mad=(max dea deb)
      %+  ?:(desc.arg gth lth)
        (mul cost.mea (pow 10 (sub mad dea)))
      (mul cost.meb (pow 10 (sub mad deb)))
    ::
        %pals
      %+  ?:(desc.arg gth lth)
        ~(wyt in (~(get ju f2p.meta-srcs.dat) laa))
      ~(wyt in (~(get ju f2p.meta-srcs.dat) lab))
    ==
  =/  ui
    |_  cas=tape
    ++  meta-stax
      |=  [syz=?(%smol %medi %lorj) emt=$@(@t manx) ski=$-([flag:f prej:proj:f] ?)]
      ^-  manx
      %:  ~(meta-stax ui:fh cas)  bol  syz  emt
          %+  turn  (skim pyz ski)
          |=([l=flag:f p=prej:proj:f] [l (prej-mete:fy l p)])
      ==
    ++  dash-navi
      |=  top=bean
      ^-  manx
      =/  kas=tape
        ?.  top  "flex-col-reverse drip-shadow-lg fund-foot p-4"
        "flex-col rounded-lg drop-shadow-lg px-4 py-2"
      =/  syk=manx
        ;div(class "w-full flex-1 flex flex-row gap-3")
          ;div(class "relative w-full flex-1 flex flex-row gap-1")
            ;input  =type  "text"
              =class  "py-1 pl-4 pr-10 flex-1 min-w-0"
              =placeholder  "Search projects…"
              :: =x-ref  "fund_search"
              =x-model  "filt_status.params.text"
              =x-on-keyup-enter  "submitQuery";
            ::  NOTE: CSS trick from https://stackoverflow.com/a/28456704
            ;button  =type  "button"
                =class  "p-0.5 absolute right-3 top-[50%] translate-y-[-50%]"
                =x-on-click  "submitQuery"
              ;img@"{(aset:enrl:ff:fh %search)}{soc}";
              :: ;img@"{(aset:enrl:ff:fh %close)}"(x-show "$focus.focused() == $refs.fund_search");
            ==
          ==
          ;*  ?:  =(%action dyp)  ~
              %+  turn  `(list @tas)`~[%sort %filter]
              |=  mod=@tas
              ;button  =type  "button"
                  =class  "p-1"
                  =x-data  "\{ hover: false }"
                  =x-on-mouseenter  "hover = true"
                  =x-on-mouseleave  "hover = false"
                  =x-on-click  "toggleTray('{(trip mod)}')"
                ;*  %+  turn  `(list @tas)`~[%$ %off]
                    |=  sat=@tas
                    =/  ext=tape  ?:(=(%$ sat) ~ sos)
                    =/  sow=tape  ?.(=(%$ sat) "&& !hover" "|| hover")
                    ;img.w-6@"{(aset:enrl:ff:fh mod)}{ext}"
                      =x-show  "showTrayButton('{(trip mod)}', '{(trip sat)}'){sow}";
              ==
        ==
      ;div
          =class  "w-full flex gap-3 bg-palette-contrast {kas} {cas}"
          =x-show  "$store.page.size {(trip ?:(top '=' '!'))}= 'desktop'"
        ;div(class "w-full flex items-center gap-6 lg:gap-4 {(trip ?:(top '' 'justify-center'))}")
          ;*  %+  turn  `(list @tas)`~[%following %discover %action %controls]
              |=  mod=@tas
              ^-  manx
              =/  cas=tape  "rounded-md {(trip ?:(top 'p-1' 'p-2'))}"
              =/  cis=tape  ?:(top "w-6" "w-8")
              =/  deb=tape  (bool:enjs:ff:fh =(dyp mod))
              ?.  ?=(%controls mod)
                ;a  =href  (dest:enrl:ff:fh /dashboard/[mod])
                    =class  cas
                    =x-data  "\{ hover: {deb} }"
                    =x-on-mouseenter  "hover = true"
                    =x-on-mouseleave  "hover = {deb}"
                  ;img@"{(aset:enrl:ff:fh mod)}{sos}"(class cis, x-show "!hover");
                  ;img@"{(aset:enrl:ff:fh mod)}"(class cis, x-show "hover");
                ==
              ?:  top  syk
              ;div(class "flex items-center border-l-2 pl-6 lg:pl-4")
                ;button  =type  "button"
                    =class  "{cas} border-palette-background"
                    =x-on-click  "toggleTray(undefined)"
                    =x-data  "\{ hover: false }"
                    =x-on-mouseenter  "hover = true"
                    =x-on-mouseleave  "hover = false"
                  ;img@"{(aset:enrl:ff:fh mod)}{sos}"(class cis, x-show "!(tray_status.open || hover)");
                  ;img@"{(aset:enrl:ff:fh mod)}"(class cis, x-show "tray_status.open || hover");
                ==
              ==
        ==
        ;div  =class  "w-full flex flex-col gap-3"
            =x-show  ?:(top "tray_status.mode != 'base'" "tray_status.open")
          ;*  ?:(top ~ [syk]~)
          ;*  ?:  =(%action dyp)  ~
              =/  sin=tape  "initTomSelect($el, \{empty: true, forceUp: {(trip ?.(top 'true' 'false'))}})"
              =/  kas=tape  "w-full flex flex-row justify-between items-center"
              :~  ;div(class "w-full flex flex-col gap-3", x-show "tray_status.mode == 'filter'")
                    ;div(class kas)
                      ;*  %+  turn
                            ^-  (list [@tas tape])
                            ;:  welp
                              [%swap "funding"]~
                              [%work "worker"]~
                              [%orac "oracle"]~
                              ?:(=(%discover dyp) ~ [%stat "status"]~)
                              [%undo "RESET"]~
                            ==
                          |=  [mod=@tas txt=tape]
                          =/  hyd=tape  "showFilterButton('{(trip mod)}', 'off')"
                          ?:  ?=(%undo mod)
                            ;button(type "button", x-on-click "toggleFilter(undefined);wipeFilter()"): {txt}
                          ;button  =type  "button"
                              =class  "flex flex-row gap-2"
                              =x-on-click  "toggleFilter('{(trip mod)}')"
                            ;*  %+  turn  `(list @tas)`~[%$ %off]
                                |=  sat=@tas
                                =/  ast=tape  "filter-{(trip mod)}"
                                =/  ext=tape  ?:(=(%$ sat) ~ sos)
                                ;img.w-6@"{(aset:enrl:ff:fh (crip ast))}{ext}"
                                  =x-show  "showFilterButton('{(trip mod)}', '{(trip sat)}')";
                            ;div  =class  "hidden lg:block"
                                =xlass  "`text-palette-$\{{hyd} ? 'system' : 'primary'}`"
                              ; {txt}
                            ==
                          ==
                    ==
                    ;div(x-show "filt_status.mode == 'swap'")
                      ;+  %:  ~(swap-selz ui:fh "flex flex-row gap-2")
                              ?:(top 0 1)
                              &
                              swap.arg
                              "filt_status.params.swap"
                              "submitQuery"
                          ==
                    ==
                    ;div(x-show "filt_status.mode == 'work'")
                      ;select  =x-init  sin
                          =x-model  "filt_status.params.work"
                          =x-on-change  "submitQuery"
                        ;*  =/  woz=(set @p)
                              %+  roll  `(list (set flag:f))`~[~(key by mez) ~(key by pez)]
                              |=  [nex=(set flag:f) acc=(set @p)]
                              (~(uni in acc) `(set @p)`(~(run in nex) head))
                            :-  ;option(value ""): Any Worker
                            %+  turn  ~(tap in woz)
                            |=  wok=@p
                            ^-  manx
                            :_  ; {<wok>}
                            :-  %option
                            ;:  welp
                                [%value "{<wok>}"]~
                                [%data-image (~(ship-logo fa bol) wok)]~
                                ?.(&(?=(^ work.arg) =(u.work.arg wok)) ~ [%selected ~]~)
                            ==
                      ==
                    ==
                    ;div(x-show "filt_status.mode == 'orac'")
                      ;select  =x-init  sin
                          =x-model  "filt_status.params.orac"
                          =x-on-change  "submitQuery"
                        ;*  =/  orz=(set @p)
                              =-  (~(uni in (silt mel)) (silt pel))
                              ^-  [mel=(list @p) pel=(list @p)]
                              :-  (turn ~(val by mez) |=(m=mete:meta:f oracle.m))
                              (turn ~(val by pez) |=(p=prej:proj:f p.assessment.p))
                            :-  ;option(value ""): Any Oracle
                            %+  turn  ~(tap in orz)
                            |=  ora=@p
                            ^-  manx
                            :_  ; {<ora>}
                            :-  %option
                            ;:  welp
                                [%value "{<ora>}"]~
                                [%data-image (~(ship-logo fa bol) ora)]~
                                ?.(&(?=(^ orac.arg) =(u.orac.arg ora)) ~ [%selected ~]~)
                            ==
                      ==
                    ==
                    ;div(x-show "filt_status.mode == 'stat'")
                      ;select  =x-init  sin
                          =x-model  "filt_status.params.stat"
                          =x-on-change  "submitQuery"
                        ;*  :-  ;option(value ""): Any Status
                            %+  turn  `(list stat:f)`~[%born %prop %lock %work %sess %done %dead]
                            |=  sat=stat:f
                            ^-  manx
                            ::  FIXME: This is so ugly, but there isn't any easy
                            ::  way to grab the color through a Tailwind class
                            =/  [txt=tape bak=tape bor=tape das=tape]
                              ?-  sat
                                %born  ["1e1e1e" "efefef" "efefef" ~]
                                %prop  ["1e1e1e" "efefef" "efefef" ~]
                                %lock  ["1e1e1e" "dbdbdb" "2f2f2f" ~]
                                %work  ["1e1e1e" "dbdbdb" "2f2f2f" ~]
                                %sess  ["1e1e1e" "dbdbdb" "2f2f2f" ~]
                                %done  ["efefef" "2f2f2f" "2f2f2f" ~]
                                %dead  ["1e1e1e" "efefef" "dbdbdb" "2+2"]
                              ==
                            =/  ext=tape  "?text=%23{txt}&stroke=%23{bak}&outline=%23{bor}&dash={das}"
                            :_  ; {(stat:enjs:ff:fh sat)}
                            :-  %option
                            ;:  welp
                                [%value (trip sat)]~
                                [%data-image "{(aset:enrl:ff:fh %stat)}{ext}"]~
                                ?.(&(?=(^ stat.arg) =(u.stat.arg sat)) ~ [%selected ~]~)
                            ==
                      ==
                    ==
                  ==
                  ;div(class "flex-1 {kas}", x-show "tray_status.mode == 'sort'")
                    ;*  %+  turn
                          ^-  (list [@tas tape])
                          :~  [%time "update time"]
                              [%pals "pal count"]
                              [%cost "total cost"]
                              [%alph "alphabetical"]
                              [%undo "RESET"]
                          ==
                        |=  [mod=@tas txt=tape]
                        =/  hyd=tape  "showSortButton('{(trip mod)}', 'off')"
                        ?:  ?=(%undo mod)
                          ;button(type "button", x-on-click "updateSort(undefined)"): {txt}
                        ;button  =type  "button"
                            =class  "flex flex-row gap-2"
                            =x-on-click  "updateSort('{(trip mod)}')"
                          ;*  %+  turn  `(list @tas)`~[%asc %des %off]
                              |=  ord=@tas
                              =/  ast=tape
                                =?  ord  =(%off ord)  ?.(=(%alph mod) %des %asc)
                                "sort-{(trip mod)}-{(trip ord)}"
                              =/  ext=tape  ?.(=(%off ord) ~ sos)
                              ;img.w-6@"{(aset:enrl:ff:fh (crip ast))}{ext}"
                                =x-show  "showSortButton('{(trip mod)}', '{(trip ord)}')";
                          ;div  =class  "hidden lg:block"
                              =xlass  "`text-palette-$\{{hyd} ? 'system' : 'primary'}`"
                            ; {txt}
                          ==
                        ==
              ==  ==
        ==
      ==
    --
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "{(trip dyp)} dashboard"
  :+  fut=&  hed=|
  ;div(x-data "proj_dash")
    ;+  (head:ui:fh bol ord [(~(dash-navi ui ~) top=&)]~)
    ::  NOTE: Using another trick to always push footer to the bottom
    ::  https://stackoverflow.com/a/59865099
    ;div(class "flex flex-col gap-2 px-2 py-2 sm:px-5 min-h-[100vh]")
      ;*  =/  wax=manx
            ;p.fund-warn
              ; No projects found.
              ;span
                ; Check out the
                ;a.text-link/"{(burl:fh bol)}/apps/groups/groups/~tocwex/syndicate-public/channels/heap/~tocwex/bulletin-board": ~tocwex.syndicate %tlon group
                ;span:  to discover more projects.
              ==
            ==
          ?+    dyp  !!
              %following
            :~  ;h1-alt: Following
                  ?~  paz=(turn pyz (cury proj-card:ui:fh bol))  wax
                ;div(class "w-full grid gap-4 grid-cols-1 sm:grid-cols-[repeat(auto-fit,minmax(auto,500px))] justify-center")
                  ;*  paz
                ==
            ==
          ::
              %discover
            =/  hel=tape  (trip !<(@t (slot:config %meta-help)))
            :~  ;div(class "flex flex-row gap-2 justify-start items-center")
                  ;h1-alt: Discover
                  ;button(type "button", x-init "initTippy($el, \{hover: true})")
                    ;img.fund-butn-icon@"{(aset:enrl:ff:fh %help)}";
                  ==
                  ;div(class "hidden")
                    ;p
                      ; Discovery of new projects depends on the %pals
                      ; network. Projects are publicized to your %pals, and
                      ; they can optionally republicize them to their %pals.
                      ; Tell your friends and see who can discover the
                      ; largest project collection!
                    ==
                    ;a.text-link/"{hel}/project-discovery"(target "_blank")
                      ; Read the docs to learn more.
                    ==
                  ==
                ==
                (meta-stax:ui:fh bol %lorj wax myz)
            ==
          ::
              %action
            =/  sax=manx
              ;p.fund-warn
                ; To serve as a %fund oracle service provider, please
                ;a.text-link  =target  "_blank"
                    =href  "{(trip !<(@t (slot:config %meta-help)))}/user-guides/trusted-oracles-wip#why-do-we-only-support-stars-as-escrow-providers"
                  ;  acquire a Star-level Urbit ID.
                ==
              ==
            ?^  text.arg
              :_  ~
              %^  meta-stax:ui  %lorj  'No projects found.'
              |=  [lag=flag:f pre=prej:proj:f]
              ?|  ?&  ?=(?(%prop %sess) ~(stat pj:fj -.pre))
                      =(p.assessment.pre our.bol)
                  ==
                  ?&  !?=(?(%born %prop %done %dead) ~(stat pj:fj -.pre))
                      (~(has by pledges.pre) our.bol)
                  ==
                  ?&  ?=(?(%done %dead) ~(stat pj:fj -.pre))
                      (~(has in (sy ~[p.lag p.assessment.pre])) our.bol)
                  ==
              ==
            :~  ;h1-alt: My Actions
                ;div(class "flex flex-col gap-4")
                  ;div                               ::  my $prez
                    ;h2: My Open Projects
                    ;+  =-  %-  ~(lech ma:fh div)
                            :_  ~
                            %^  ~(link-card ui:fh "w-[50vw] sm:w-[250px]")  bol  "%2b"
                            (dest:enrl:ff:fh /create/project)
                        ^-  div=manx
                        %^  meta-stax:ui  %smol  %$
                        |=  [lag=flag:f pre=prej:proj:f]
                        ?&  =(our.bol p.lag)
                            ?!  ?=(?(%done %dead) ~(stat pj:fj -.pre))
                        ==
                  ==
                  ;div                               ::  $prez with %prop status
                    ;h2: Service Requests
                    ;+  %^  meta-stax:ui  %smol
                          ?.((star:fx our.bol) sax 'No outstanding requests.')
                        |=  [lag=flag:f pre=prej:proj:f]
                        ?&  ?=(%prop ~(stat pj:fj -.pre))
                            =(p.assessment.pre our.bol)
                            ?=(~ contract.pre)
                        ==
                  ==
                  ;div                               ::  $prez with %sess status
                    ;h2: Review Requests
                    ;+  %^  meta-stax:ui  %smol
                          ?.((star:fx our.bol) sax 'No outstanding requests.')
                        |=  [lag=flag:f pre=prej:proj:f]
                        ?&  ?=(%sess ~(stat pj:fj -.pre))
                            =(p.assessment.pre our.bol)
                        ==
                  ==
                  ;div                               ::  $prez with unfulfilled $plej
                    ;h2: Outstanding Pledges
                    ;+  %^  meta-stax:ui  %smol  'No outstanding pledges.'
                        |=  [lag=flag:f pre=prej:proj:f]
                        ?&  !?=(?(%born %prop %done %dead) ~(stat pj:fj -.pre))
                            (~(has by pledges.pre) our.bol)
                        ==
                  ==
                  ;div                               ::  worker|oracle done|dead $prez
                    ;h2: Work Archive
                    ;+  %^  meta-stax:ui  %medi  'No archived projects.'
                        |=  [lag=flag:f pre=prej:proj:f]
                        ?&  ?=(?(%done %dead) ~(stat pj:fj -.pre))
                            (~(has in (sy ~[p.lag p.assessment.pre])) our.bol)
                        ==
                  ==
                ==
            ==
          ==
    ==
    ;+  (~(dash-navi ui ~) top=|)
    ;script
      ;+  ;/
      %-  zing  %+  join  "\0a"
      ^-  (list tape)
      :~  "document.addEventListener('alpine:init', () => Alpine.data('proj_dash', () => (\{"
          "tray_status: \{mode: 'base', open: false},"
          :(weld "sort_status: \{mode: '" (trip sort.arg) "', desc: " (bool:enjs:ff:fh desc.arg) "},")
          :(weld "filt_status: \{mode: '" (trip (~(gut by arm) %filt %swap)) "', params: \{text: '" (trip (~(gut by arm) %text %$)) "', swap: '" (trip (~(gut by arm) %swap %$)) "', work: '" (trip (~(gut by arm) %work %$)) "', orac: '" (trip (~(gut by arm) %orac %$)) "', stat: '" (trip (~(gut by arm) %stat %$)) "'}},")
          ^-  tape  ^~
          %+  rip  3
          '''
          toggleTray(mode) {
            if (mode === undefined) {
              this.tray_status.open = !this.tray_status.open;
            } else {
              this.tray_status.open = true;
              this.tray_status.mode = (this.tray_status.mode === mode) ? "base" : mode;
            }
          },
          toggleFilter(mode) {
            this.filt_status.mode = mode ? mode : undefined;
          },
          updateSort(mode) {
            if (mode === undefined) {
              this.sort_status.mode = 'time';
              this.sort_status.desc = true;
            } else {
              if (this.sort_status.mode === mode) {
                this.sort_status.desc = !this.sort_status.desc;
              } else {
                this.sort_status.mode = mode;
                this.sort_status.desc = mode !== "alph";
              }
            }
            this.submitQuery();
          },
          wipeFilter() {
            // NOTE: Changing the selected entries automatically updates the
            // Alpinejs data model
            document.querySelectorAll(".fund-tsel").forEach(selElem => {
              selElem.tomselect?.addItem("");
            });
            // this.filt_status.params = Object.fromEntries(
            //   Object.keys(this.filt_status.params).map(key => ([key, '']))
            // );
          },
          showTrayButton(mode, stat) {
            if (this.tray_status.mode === mode) {
              return stat === "";
            } else {
              return stat === "off";
            }
          },
          showSortButton(mode, desc) {
            if (this.sort_status.mode !== mode) {
              return (desc === "off");
            } else if (desc === "off") {
              return false;
            } else {
              return this.sort_status.desc === (desc === "des");
            }
          },
          showFilterButton(mode, stat) {
            if (this.filt_status.mode !== mode) {
              return (stat === "off");
            } else {
              return (stat === "");
            }
          },
          submitQuery() {
            const oldParams = new URL(document.location.toString()).searchParams;
            if (oldParams.size === 0) {
              oldParams.set("desc", "true");
            }
            const newParams = new URLSearchParams({
              ...((this.filt_status.mode === "swap" || this.filt_status.mode === undefined)
                ? {}
                : {filt: this.filt_status.mode}
              ),
              ...((this.sort_status.mode === "time") ? {} : {sort: this.sort_status.mode}),
              desc: this.sort_status.desc,
              ...(Object.fromEntries(Object.entries(this.filt_status.params).filter(
                ([key, value]) => value !== ""
              ))),
              // TODO: Include chain number when symbols are not unique
            });

            if (
              [...oldParams.entries()].sort().toString() !==
              [...newParams.entries()].sort().toString()
            ) {
              this.openHREF(`${window.location.pathname}?${newParams}`);
            }
          },
          })));
          '''
      ==
    ==
  ==
--
::  VERSION: [1 4 5]
