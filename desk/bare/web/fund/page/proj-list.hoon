::  /web/fund/page/proj-list/hoon: render project listing page for %fund
::
/-  fd=fund-data, f=fund
/+  fp=fund-proj, fh=fund-http, fc=fund-chain, fx=fund-xtra
/+  rudder
%-  :(corl mine:preface:fh init:preface:fh)
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
+*  mes  ~(ours conn:meta:fd bol [meta-subs meta-pubs]:dat)
    pes  ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat)
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ?+      dif=(~(got by p.arz) %dif)
          (crip "bad dif; expected join, not {(trip dif)}")
        %join
      ?+  arz=(parz:fh bod (sy ~[%lag]))  p.arz  [%| *]
        =/  lag=flag:f  (flag:dejs:ff:fh (~(got by p.arz) %lag))
        :+  %proj  lag
        ::  FIXME: The %lure case doesn't actually do anything; it's
        ::  just a hack to differentiate the action type taken in the
        ::  `+final` step (%join is a real join; %lure is a no-op join)
        ?.((~(has by pes) lag) [%join ~] [%lure our.bol %fund])
      ==
    ==
  ==
++  final
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  =/  [dyp=@tas lag=flag:f pyp=@tas]  (poke:dejs:ff:fh ?~(txt '' txt))
  ?+  pyp  !!
    %join  [%next (desc:enrl:ff:fh /next/(scot %p p.lag)/[q.lag]/join) ~]
    %lure  [%next (flac:enrl:ff:fh lag) ~]
  ==
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  dyp=@tas  (rear (slag:derl:ff:fh url.request.ord))
  =/  lin=tape
    "{(burl:fh bol)}/apps/groups/groups/~tocwex/syndicate-public/channels/heap/~tocwex/bulletin-board"
  =/  [mez=(map flag:f mete:meta:f) pez=(map flag:f prej:proj:f)]
    ?+  dyp  !!
      %following  [~ pes]
      %discover  [mes ~]
    ::
        %action
      =-  [(- mes) (- pes)]
      |*  mep=(map flag:f *)
      ^+  mep
      ?:  =(~ mep)  *_mep
      %-  ~(rep by mep)
      |=  [kev=_?>(?=(^ mep) n.mep) acc=_mep]
      ^+  acc
      =/  pre=prej:proj:f  (~(got by pes) -.kev)
      =/  roz=(set role:f)  (~(rols pj:fp -.pre) our.bol our.bol)
      ?:(=(~ roz) acc (~(put by acc) kev))
    ==
  =/  ui
    |_  cas=tape
    ++  proj-card                              ::  summary card for a project
      |=  [lag=flag:f pre=prej:proj:f]
      ^-  manx
      ::  TODO: Replace the latter with a ship-generated sigil pair
      ::  (project worker and oracle with slightly different colors).
      =/  bak=tape
        ?^  image.pre  (trip u.image.pre)
        (surt:enrl:ff:fh p.lag)
      ;a/"{(flat:enrl:ff:fh lag)}"(class "flex flex-col gap-2 font-serif {cas}")
        ;div(class "aspect-video bg-cover bg-center rounded-md bg-[url('{bak}')]")
          ;div(class "flex flex-row flex-wrap justify-start items-center p-2 gap-2")
            ;div(class "bg-gray-100 rounded-md text-md p-1.5")
              ; {(mony:enjs:ff:fh ~(cost pj:fp -.pre) currency.pre)}
            ==
            ;div(class "bg-gray-100 rounded-md p-0.5")
              ;+  %+  ~(icon-stax ui:fh "h-8")  |
                  :~  (aset:enrl:ff:fh symbol.currency.pre)
                      (aset:enrl:ff:fh tag:(~(got by xmap:fc) chain.currency.pre))
                  ==
            ==
          ==
        ==
        ;div(class "w-full flex-1 flex flex-row gap-2 justify-between items-start")
          ;div(class "flex-1 min-w-0 text-lg"): {(trip title.pre)}
          ;div(class "bg-gray-100 rounded-lg p-0.5 line-clamp-2")
            ;+  %+  ~(icon-stax ui:fh "h-8")  &
                (turn ~[p.lag p.assessment.pre] surt:enrl:ff:fh)
          ==
        ==
      ==
    ++  meta-card                              ::  summary card for project metadata
      |=  [lag=flag:f met=mete:meta:f]
      ^-  manx
      ::  TODO: Replace the latter with a ship-generated sigil pair
      ::  (project worker and oracle with slightly different colors).
      =/  bak=tape
        ?^  image.met  (trip u.image.met)
        (surt:enrl:ff:fh worker.met)
      ::  TODO: Add data attributes to allow for FE sorting/filtering
      ;div  =x-on-click  "joinProject('{(flag:enjs:ff:fh lag)}')"
          =class  "flex flex-col gap-2 font-serif hover:cursor-pointer {cas}"
        ;div(class "aspect-square bg-cover bg-center rounded-md bg-[url('{bak}')]")
          ;div(class "flex flex-row flex-wrap justify-between items-center p-2")
            ;div(class "bg-gray-100 rounded-md text-xs p-1.5")
              ; {(mony:enjs:ff:fh cost.met currency.met)}
            ==
            ;div(class "bg-gray-100 rounded-md p-0.5 line-clamp-2")
              ;+  (icon-stax:ui:fh & (turn ~[worker.met oracle.met] surt:enrl:ff:fh))
            ==
          ==
        ==
        ;div(class "text-sm"): {(trip title.met)}
      ==
    ++  mota-card                              ::  summary card for project (metadata)
      |=  [lag=flag:f pre=prej:proj:f]
      ^-  manx
      %+  meta-card  lag
      :_  live.pre
      ::  FIXME: Duplicated from '/app/fund/hoon'
      :*  title=title.pre
          image=image.pre
          cost=~(cost pj:fp -.pre)
          currency=currency.pre
          launch=p:xact:(fall contract.pre *oath:f)
          worker=p.lag
          oracle=p.assessment.pre
      ==
    ++  mota-well                              ::  project (metadata) well (%action)
      |=  [kas=tape msg=tape ski=$-([flag:f prej:proj:f] ?)]
      ^-  manx
      ?~  maz=(turn (skim ~(tap by pez) ski) mota-card)
        ;p.fund-warn: {msg}
      ;div(class kas)
        ;*  maz
      ==
    --
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "{(trip dyp)} dashboard"
  ;div(x-data "proj_list")
    ;div(class "flex flex-col p-2 gap-2")
      ;div(class "flex justify-between")
        ;h1: {(trip dyp)}
        ;*  ?.  ?=(%action dyp)  ~
            :_  ~
            ;a.self-center.fund-butn-ac-m/"{(dest:enrl:ff:fh /create/project)}"
              ; new project +
            ==
      ==
      ;+  =/  cas=tape  "w-full grid gap-4 justify-center"
          =/  pas=tape  "{cas} grid-cols-1 sm:grid-cols-[repeat(auto-fit,minmax(auto,500px))]"
          =/  mas=tape  "{cas} grid-cols-2 sm:grid-cols-[repeat(auto-fit,minmax(auto,250px))]"
          =/  wax=manx
            ;p.fund-warn
              ; No projects found.
              ;span
                ; Check out the
                ;a.text-link/"{lin}": ~tocwex.syndicate %tlon group
                ;span:  to discover more projects.
              ==
            ==
          ?+    dyp  !!
              %following
            ?~  paz=(turn ~(tap by pez) proj-card:ui)  wax
            ;div(class pas)
              ;*  paz
            ==
          ::
              %discover
            ?~  maz=(turn ~(tap by mez) meta-card:ui)  wax
            ;div(class mas)
              ;*  maz
            ==
          ::
              %action
            =/  sas=tape  "grid gap-4 grid-rows-1 grid-flow-col overflow-x-auto"
            =/  sus=tape  "w-[200px] sm:w-[250px]"
            ;div(class "flex flex-col gap-4")
              ;div                               ::  $prez with %prop status
                ;h2: Service Requests
                ;+  %^  ~(mota-well ui sus)  sas  "No outstanding requests."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  ?=(%prop ~(stat pj:fp -.pre))
                        =(p.assessment.pre our.bol)
                    ==
              ==
              ;div                               ::  $prez with %sess status
                ;h2: Review Requests
                ;+  %^  ~(mota-well ui sus)  sas  "No projets pending review."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  ?=(%sess ~(stat pj:fp -.pre))
                        =(p.assessment.pre our.bol)
                    ==
              ==
              ;div                               ::  $prez with unfulfilled $plej
                ;h2: Outstanding Pledges
                ;+  %^  ~(mota-well ui sus)  sas  "No oustanding pledges."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  !?=(?(%born %prop %done %dead) ~(stat pj:fp -.pre))
                        (~(has by pledges.pre) our.bol)
                    ==
              ==
              ;div                               ::  worker|oracle done|dead $prez
                ;h2: Work Archive
                ;+  %^  mota-well:ui  mas  "No archived projects."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  ?=(?(%done %dead) ~(stat pj:fp -.pre))
                        (~(has in (sy ~[p.lag p.assessment.pre])) our.bol)
                    ==
              ==
            ==
          ==
    ==
    ;footer(class "fund-foot font-serif flex flex-col")
      ;div(class "w-full flex flex-col p-3 gap-3 bg-gray-100", x-show "tray_status.open")
        ;div(class "w-full flex-1 flex flex-row gap-4")
          ::  TODO: On enter, perform filter
          ;input.p-1(class "flex-1 min-w-0", type "text", placeholder "Search projects…");
          ;*  ?:  =(%action dyp)  ~
              %+  turn  `(list @tas)`~[%sort %filter]
              |=  mod=@tas
              ;button(type "button", x-on-click "toggleTray('{(trip mod)}')")
                ;*  %+  turn  `(list @tas)`~[%$ %off]
                    |=  sat=@tas
                    =/  ast=tape  ?:(=(%$ sat) (trip mod) "{(trip mod)}-{(trip sat)}")
                    ;img.w-8@"{(aset:enrl:ff:fh (crip ast))}"
                      =x-show  "showTrayButton('{(trip mod)}', '{(trip sat)}')";
              ==
        ==
        ;*  ?:  =(%action dyp)  ~
            :~  ;div(class "w-full flex flex-col gap-3", x-show "tray_status.mode == 'filter'")
                  ;div(class "flex flex-row justify-between items-center")
                    ;*  %+  turn
                          ^-  (list @tas)
                          %+  welp  ~[%coin %work %orac]
                          ?:(=(%discover dyp) ~[%undo] ~[%stat %undo])
                        |=  mod=@tas
                        ?:  ?=(%undo mod)
                          ;button(type "button", x-on-click "toggleFilter(undefined); wipeFilter()"): RESET
                        ;button(type "button", x-on-click "toggleFilter('{(trip mod)}')")
                          ;*  %+  turn  `(list @tas)`~[%$ %off]
                              |=  sat=@tas
                              =/  ast=tape  (welp "filter-" ?:(=(%$ sat) (trip mod) "{(trip mod)}-{(trip sat)}"))
                              ;img.w-8@"{(aset:enrl:ff:fh (crip ast))}"
                                =x-show  "showFilterButton('{(trip mod)}', '{(trip sat)}')";
                        ==
                  ==
                  ;div(x-show "filt_status.mode == 'coin'")
                    ;+  %:  ~(coin-selz ui:fh "flex flex-col gap-3")
                            ~
                            "filt_status.params.coin"  "updateFilter"
                        ==
                  ==
                  ;div(x-show "filt_status.mode == 'work'")
                    ;select#filt-worker.fund-tsel
                        =x-init  "useTomSelect($el, true)"
                        =x-model  "filt_status.params.work"
                        =x-on-change  "updateFilter"
                        =placeholder  "Select worker…"
                      ;*  =/  woz=(set @p)
                            %+  roll  `(list (set flag:f))`~[~(key by mez) ~(key by pez)]
                            |=  [nex=(set flag:f) acc=(set @p)]
                            (~(uni in acc) `(set @p)`(~(run in nex) head))
                          :-  ;option(value ""): No Worker
                          %+  turn  ~(tap in woz)
                          |=  wok=@p
                          ^-  manx
                          :_  ; {<wok>}
                          :-  %option
                          ;:  welp
                              [%value "{<wok>}"]~
                              [%data-image "https://azimuth.network/erc721/{(bloq:enjs:ff:fh `@`wok)}.svg"]~
                          ==
                    ==
                  ==
                  ;div(x-show "filt_status.mode == 'orac'")
                    ;select#filt-oracle.fund-tsel
                        =x-init  "useTomSelect($el, true)"
                        =x-model  "filt_status.params.orac"
                        =x-on-change  "updateFilter"
                      ;*  =/  orz=(set @p)
                            =-  (~(uni in (silt mel)) (silt pel))
                            ^-  [mel=(list @p) pel=(list @p)]
                            :-  (turn ~(val by mez) |=(m=mete:meta:f oracle.m))
                            (turn ~(val by pez) |=(p=prej:proj:f p.assessment.p))
                          :-  ;option(value ""): No Oracle
                          %+  turn  ~(tap in orz)
                          |=  ora=@p
                          ^-  manx
                          :_  ; {<ora>}
                          :-  %option
                          ;:  welp
                              [%value "{<ora>}"]~
                              [%data-image "https://azimuth.network/erc721/{(bloq:enjs:ff:fh `@`ora)}.svg"]~
                          ==
                    ==
                  ==
                  ;div(x-show "filt_status.mode == 'stat'")
                    ;select#filt-status.fund-tsel
                        =x-init  "useTomSelect($el, true)"
                        =x-model  "filt_status.params.stat"
                        =x-on-change  "updateFilter"
                      ;*  :-  ;option(value ""): No Status
                          %+  turn  `(list stat:f)`~[%born %prop %lock %work %sess %done %dead]
                          |=  sat=stat:f
                          ^-  manx
                          :_  ; {(stat:enjs:ff:fh sat)}
                          :-  %option
                          ;:  welp
                              [%value "{(trip sat)}"]~
                              ::  FIXME: Really want SVG w/ custom colors for this in paritcular.
                              ::  [%data-image ""]~  ::  TODO: Should be color of status
                          ==
                    ==
                  ==
                ==
                ;div  =class  "w-full flex-1 flex flex-row justify-between items-center"
                    =x-show  "tray_status.mode == 'sort'"
                  ;*  %+  turn  `(list @tas)`~[%time %cost %alph %pals %undo]
                      |=  mod=@tas
                      ?:  ?=(%undo mod)
                        ;button(type "button", x-on-click "updateSort(undefined)"): RESET
                      ;button(type "button", x-on-click "updateSort('{(trip mod)}')")
                        ;*  %+  turn  `(list @tas)`~[%asc %des %off]
                            |=  ord=@tas
                            =/  ast=tape  "sort-{(trip mod)}-{(trip ord)}"
                            ;img.w-8@"{(aset:enrl:ff:fh (crip ast))}"
                              =x-show  "showSortButton('{(trip mod)}', '{(trip ord)}')";
                      ==
            ==  ==
      ==
      ;div(class "w-full flex flex-row justify-center gap-2 py-3 bg-primary-300")  ::  bg-primary-400
        ;*  %+  turn  `(list @tas)`~[%following %discover %action %controls]
            |=  mod=@tas
            ^-  manx
            =+  [cas="px-4 py-3 rounded-md" cis="w-8"]
            =+  kas=?.(=(dyp mod) ~ "bg-gray-100")
            ?:  ?=(%controls mod)
              ;button  =type  "button"
                  =x-on-click  "toggleTray(undefined)"
                  =class  "{cas} border-l border-gray-250"
                ;img@"{(aset:enrl:ff:fh mod)}"(class cis);
              ==
            ;a/"{(dest:enrl:ff:fh /dashboard/[mod])}"(class "{cas} {kas}")
              ;img@"{(aset:enrl:ff:fh mod)}"(class cis);
            ==
      ==
    ==
    ;script
      ;+  ;/
      %-  zing  %+  join  "\0a"
      ^-  (list tape)
      :~  "document.addEventListener('alpine:init', () => Alpine.data('proj_list', () => (\{"
          "coin_chain: '',"
          "tray_status: \{mode: 'base', open: false},"  ::  FIXME: Revert to 'base'/'false' here
          "sort_status: \{mode: 'time', desc: true},"
          "filt_status: \{mode: 'coin', params: \{coin: '', work: '', orac: '', stat: ''}},"  ::  FIXME: Revert to 'undefined' here
          ^-  tape  ^~
          %+  rip  3
          '''
          toggleTray(mode) {
            if (mode === undefined) {
              this.tray_status.open = !this.tray_status.open;
            } else {
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
          },
          updateFilter() {
            console.log(this.filt_status.params);
            // TODO: Need to generate (map flag @ud) for "items being
            // displayed and their order"
            // TODO: How do we filter/order these elements?
          },
          wipeFilter() {
            // this.filt_status.params = Object.fromEntries(
            //   Object.keys(this.filt_status.params).map(key => ([key, '']))
            // );
            // FIXME: Invokes 'updateFilter' several times consecutively (for
            // each selector that gets updated)
            document.querySelectorAll(".fund-tsel").forEach(selElem => {
              selElem.tomselect?.addItem("");
            });
            // this.updateFilter();
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
          joinProject(flag) {
            this.sendFormData({
              dif: "join",
              lag: flag,
            });
          },
          })));
          '''
      ==
    ==
  ==
--
::  VERSION: [1 1 0]
