::  /web/fund/page/proj-list/hoon: render project listing page for %fund
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fh=fund-http, fc=fund-chain, fx=fund-xtra
/+  rudder
%-  :(corl mine:preface:fh init:preface:fh)
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ?+      dif=(~(got by p.arz) %dif)
          (crip "bad dif; expected join, not {(trip dif)}")
        %join
      ?+  arz=(parz:fh bod (sy ~[%lag]))  p.arz  [%| *]
        =/  pes=(map flag:f prej:proj:f)  ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat)
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
  =/  arm=(map @t @t)  (~(gas by *(map @t @t)) arz)
  =/  arg
    :*  sort=`@t`(~(gut by arm) %sort %time)
        desc=`?`(bool:dejs:ff:fh (~(gut by arm) %desc %true))
        filt=`@t`(~(gut by arm) %filt %coin)
        text=`(unit @t)`(~(get by arm) %text)
        work=`(unit @p)`(bind (~(get by arm) %work) ship:dejs:ff:fh)
        orac=`(unit @p)`(bind (~(get by arm) %orac) ship:dejs:ff:fh)
        stat=`(unit stat:f)`(bind (~(get by arm) %stat) |=(=@t ;;(stat:f t)))
    ::
          ^=  coin  ^-  (unit coin:f)
        ::  FIXME: This only works if all built-in coins have different
        ::  symbols; this will need to be fixed when %fund supports e.g.
        ::  USDC on an L2
        ?~  sym=(~(get by arm) %coin)  ~
        ?~  con=(find:fx clis:fc |=(c=coin:f =(u.sym symbol.c)))  ~
        `u.con
    ==
  =/  mes=(map flag:f mete:meta:f)  ~(ours conn:meta:fd bol [meta-subs meta-pubs]:dat)
  =/  pes=(map flag:f prej:proj:f)  ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat)
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
      =/  roz=(set role:f)  (~(rols pj:fj -.pre) our.bol our.bol)
      ?:(=(~ roz) acc (~(put by acc) kev))
    ==
  =/  ex
    |%
    +$  mexa  [status=stat:f mete:meta:f]
    ++  proj-meta
      |=  [lag=flag:f pre=prej:proj:f]
      ^-  mete:meta:f
      :_  live.pre
      ::  FIXME: Duplicated from '/app/fund/hoon'
      :*  title=title.pre
          image=image.pre
          cost=~(cost pj:fj -.pre)
          currency=currency.pre
          launch=p:xact:(fall contract.pre *oath:f)
          worker=p.lag
          oracle=p.assessment.pre
      ==
    ++  proj-mexa
      |=  [lag=flag:f pre=prej:proj:f]
      ^-  mexa
      =+  met=(proj-meta lag pre)
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
        ?&  ?~(text.arg & ?=(^ (find (trip u.text.arg) (trip title.mex))))
            ?~(coin.arg & =(currency.mex u.coin.arg))
            ?~(work.arg & =(worker.mex u.work.arg))
            ?~(orac.arg & =(oracle.mex u.orac.arg))
            ?~(stat.arg & =(status.mex u.stat.arg))
        ==
    |=  [[laa=flag:f mea=mexa:ex] [lab=flag:f meb=mexa:ex]]
    ^-  bean
    ?+  sort.arg  !!
      %time  (?:(desc.arg gth lth) launch.mea launch.meb)
      %cost  (?:(desc.arg gth lth) cost.mea cost.meb)
      %alph  ?:(desc.arg (aor title.meb title.mea) (aor title.mea title.meb))
    ::
        %pals
      %+  ?:(desc.arg gth lth)
        ~(wyt in (~(get ju f2p.meta-srcs.dat) laa))
      ~(wyt in (~(get ju f2p.meta-srcs.dat) lab))
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
              ; {(mony:enjs:ff:fh ~(cost pj:fj -.pre) currency.pre)}
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
    ++  mota-well                              ::  project (metadata) well (%action)
      |=  [kas=tape msg=tape ski=$-([flag:f prej:proj:f] ?)]
      ^-  manx
      ?~  maz=(turn (skim pyz ski) |=([l=flag:f p=prej:proj:f] (meta-card l (proj-meta:ex l p))))
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
                ;a.text-link/"{(burl:fh bol)}/apps/groups/groups/~tocwex/syndicate-public/channels/heap/~tocwex/bulletin-board": ~tocwex.syndicate %tlon group
                ;span:  to discover more projects.
              ==
            ==
          ?+    dyp  !!
              %following
            ?~  paz=(turn pyz proj-card:ui)  wax
            ;div(class pas)
              ;*  paz
            ==
          ::
              %discover
            ?~  maz=(turn myz meta-card:ui)  wax
            ;div(class mas)
              ;*  maz
            ==
          ::
              %action
            =/  sas=tape  "grid gap-4 grid-rows-1 grid-flow-col overflow-x-auto"
            =/  sus=tape  "w-[50vw] sm:w-[250px]"
            ;div(class "flex flex-col gap-4")
              ;div                               ::  $prez with %prop status
                ;h2: Service Requests
                ;+  %^  ~(mota-well ui sus)  sas  "No outstanding requests."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  ?=(%prop ~(stat pj:fj -.pre))
                        =(p.assessment.pre our.bol)
                    ==
              ==
              ;div                               ::  $prez with %sess status
                ;h2: Review Requests
                ;+  %^  ~(mota-well ui sus)  sas  "No projets pending review."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  ?=(%sess ~(stat pj:fj -.pre))
                        =(p.assessment.pre our.bol)
                    ==
              ==
              ;div                               ::  $prez with unfulfilled $plej
                ;h2: Outstanding Pledges
                ;+  %^  ~(mota-well ui sus)  sas  "No oustanding pledges."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  !?=(?(%born %prop %done %dead) ~(stat pj:fj -.pre))
                        (~(has by pledges.pre) our.bol)
                    ==
              ==
              ;div                               ::  worker|oracle done|dead $prez
                ;h2: Work Archive
                ;+  %^  mota-well:ui  mas  "No archived projects."
                    |=  [lag=flag:f pre=prej:proj:f]
                    ?&  ?=(?(%done %dead) ~(stat pj:fj -.pre))
                        (~(has in (sy ~[p.lag p.assessment.pre])) our.bol)
                    ==
              ==
            ==
          ==
    ==
    ;footer(class "fund-foot font-serif flex flex-col")
      ;div(class "w-full flex flex-col p-3 gap-3 bg-gray-100 rounded-t-md", x-show "tray_status.open")
        ;div(class "w-full flex-1 flex flex-row gap-4")
          ;div(class "w-full flex-1 flex flex-row gap-1")
            ;input.p-1.flex-1.min-w-0  =type  "text"
              =placeholder  "Search projects"
              =x-model  "filt_status.params.text";
            ;button.fund-butn-de-m(type "button", x-on-click "submitQuery")
              ;img@"{(aset:enrl:ff:fh %search)}";
            ==
          ==
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
                              =/  ast=tape
                                %+  welp  "filter-"
                                ?:(=(%$ sat) (trip mod) "{(trip mod)}-{(trip sat)}")
                              ;img.w-8@"{(aset:enrl:ff:fh (crip ast))}"
                                =x-show  "showFilterButton('{(trip mod)}', '{(trip sat)}')";
                        ==
                  ==
                  ;div(x-show "filt_status.mode == 'coin'")
                    ;+  %:  ~(coin-selz ui:fh "flex flex-row")
                            &
                            coin.arg
                            "filt_status.params.coin"
                            "updateFilter"
                        ==
                  ==
                  ;div(x-show "filt_status.mode == 'work'")
                    ;select#filt-worker.fund-tsel
                        =x-init  "useTomSelect($el, true)"
                        =x-model  "filt_status.params.work"
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
                              ?.(&(?=(^ work.arg) =(u.work.arg wok)) ~ [%selected ~]~)
                          ==
                    ==
                  ==
                  ;div(x-show "filt_status.mode == 'orac'")
                    ;select#filt-oracle.fund-tsel
                        =x-init  "useTomSelect($el, true)"
                        =x-model  "filt_status.params.orac"
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
                              ?.(&(?=(^ orac.arg) =(u.orac.arg ora)) ~ [%selected ~]~)
                          ==
                    ==
                  ==
                  ;div(x-show "filt_status.mode == 'stat'")
                    ;select#filt-status.fund-tsel
                        =x-init  "useTomSelect($el, true)"
                        =x-model  "filt_status.params.stat"
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
                              ?.(&(?=(^ stat.arg) =(u.stat.arg sat)) ~ [%selected ~]~)
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
          "tray_status: \{mode: 'base', open: false},"
          :(weld "sort_status: \{mode: '" (trip sort.arg) "', desc: " (bool:enjs:ff:fh desc.arg) "},")
          :(weld "filt_status: \{mode: '" (trip (~(gut by arm) %filt %coin)) "', params: \{text: '" (trip (~(gut by arm) %text %$)) "', coin: '" (trip (~(gut by arm) %coin %$)) "', work: '" (trip (~(gut by arm) %work %$)) "', orac: '" (trip (~(gut by arm) %orac %$)) "', stat: '" (trip (~(gut by arm) %stat %$)) "'}},")
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
            // FIXME: Should probably remove this; only used for debugging
            // console.log(this.filt_status.params);
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
          joinProject(flag) {
            this.sendFormData({
              dif: "join",
              lag: flag,
            });
          },
          submitQuery() {
            const params = new URLSearchParams({
              ...((this.filt_status.mode === "coin" || this.filt_status.mode === undefined)
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
            this.openHREF(`${window.location.pathname}?${params}`);
          },
          })));
          '''
      ==
    ==
  ==
--
::  VERSION: [1 1 0]
