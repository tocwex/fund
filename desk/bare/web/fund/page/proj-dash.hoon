::  /web/fund/page/proj-dash/hoon: render project dashboard page for %fund
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fh=fund-http, fc=fund-chain, fa=fund-alien, fx=fund-xtra
/+  rudder, config
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
      ?~  pre=(~(get by pes) -.kev)  acc
      =/  roz=(set role:f)  (~(rols pj:fj -.u.pre) our.bol our.bol)
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
          payment=payment.pre
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
    ++  base-card
      |=  $:  tyt=@t  pic=(unit @t)  xoc=tape
              pro=(unit [big=? wok=@p ora=@p cos=cash:f swa=swap:f hed=(unit manx)])
          ==
      ^-  manx
      =/  big=bean  ?~(pro | big.u.pro)
      =/  syz=@sd   ?:(big --0 -2)
      =/  asp=tape  ?:(big "aspect-video" "aspect-square")
      =/  url=tape
        ?^  pic  (trip u.pic)
        ?^  pro  (~(ship-logo fa bol) wok.u.pro)  ::  TODO: implement wok/ora double logo
        "https://placehold.co/24x24/lightgray/gray?text=?"
      ::  FIXME: This should really be 'button,' but that introduces problems with CSS
      ;div  =type  "button"
          =class  "flex flex-col gap-2 hover:cursor-pointer {cas}"
          =x-on-click  xoc
        ;div(class "font-serif bg-cover bg-center rounded-md bg-[url('{url}')] {asp}")
          ;*  ?~  pro  ~
              :_  ~
              ;div(class "flex flex-row flex-wrap justify-start items-center p-2 gap-2")
                ;div(class "bg-palette-background rounded-md text-{(size:enjs:ff:fh syz)} p-1.5")
                  ; {(swam:enjs:ff:fh cos.u.pro swa.u.pro)}
                ==
                ;div(class "bg-palette-background rounded-md p-0.5")
                  ;+  %+  ~(icon-stax ui:fh ?.(big ~ "h-8"))  %circ
                      :~  (aset:enrl:ff:fh symbol.swa.u.pro)
                          (aset:enrl:ff:fh tag:(~(got by xmap:fc) chain.swa.u.pro))
                      ==
                ==
              ==
        ==
        ;*  ?~  pro  ~
            ?~  hed.u.pro  ~
            :_  ~  u.hed.u.pro
        ;div(class "w-full flex-1 flex flex-row gap-2 justify-between items-start")
          ;div(class "font-semibold flex-1 min-w-0 line-clamp-2 text-{(size:enjs:ff:fh (sum:si --1 syz))}")
            ; {(trip tyt)}
          ==
          ;*  ?~  pro  ~
              :_  ~
              ;div(class "bg-white rounded-lg p-0.5")
                ;+  %+  icon-stax:ui:fh  %rect
                        (turn ~[wok.u.pro ora.u.pro] ~(ship-logo fa bol))
              ==
        ==
      ==
    ++  proj-card                              ::  summary card for a project
      |=  [lag=flag:f pre=prej:proj:f]
      ^-  manx
      %:  base-card
          tyt=title.pre
          pic=image.pre
          xoc="openHREF('{(flat:enrl:ff:fh lag)}')"
      ::
            ^=  pro
          :*  ~
              big=&
              wok=p.lag
              ora=p.assessment.pre
              cos=~(cost pj:fj -.pre)
              swa=payment.pre
              hed=`(proj-ther:ui:fh -.pre big=|)
          ==
      ==
    ++  meta-card                              ::  summary card for project metadata
      |=  [lag=flag:f met=mete:meta:f]
      ^-  manx
      %:  base-card
          tyt=title.met
          pic=image.met
          xoc="joinProject('{(flag:enjs:ff:fh lag)}')"
          pro=`[| worker.met oracle.met cost.met payment.met ~]
      ==
    ++  make-card                              ::  "create project" card
      ^-  manx
      %:  base-card
          tyt='Create New Project'
          pic=`'https://placehold.co/24x24/lightgray/gray?text=%2b'
          xoc="openHREF('{(dest:enrl:ff:fh /create/project)}')"
          pro=~
      ==
    ++  mota-well                              ::  project (metadata) well (%action)
      |=  [kas=tape msg=tape ski=$-([flag:f prej:proj:f] ?)]
      ^-  manx
      =/  maz=marl
        %+  turn  (skim pyz ski)
        |=([l=flag:f p=prej:proj:f] (meta-card l (proj-meta:ex l p)))
      =?  maz  ?=(~ msg)  [make-card maz]
      ?~  maz
        ;p.fund-warn: {msg}
      ;div(class kas)
        ;*  maz
      ==
    ++  dash-navi
      |=  top=bean
      ^-  manx
      =/  kas=tape
        ?.  top  "flex-col-reverse bg-white fund-foot p-3"
        "flex-col bg-palette-contrast rounded-lg drop-shadow-lg p-2"
      =/  syk=manx
        ;div(class "w-full flex-1 flex flex-row gap-4")
          ;div(class "w-full flex-1 flex flex-row gap-1")
            ;+  :_  ~  :-  %input
                :~  [%type "text"]
                    [%placeholder "Search projects…"]
                    [%class "p-1 flex-1 min-w-0"]
                    [%x-model "filt_status.params.text"]
                    [%'x-on:keyup.enter' "tray_status.open && submitQuery()"]
                ==
            ;button.fund-butn-ac-m(type "button", x-on-click "submitQuery")
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
                    ;img.w-6@"{(aset:enrl:ff:fh (crip ast))}"
                      =x-show  "showTrayButton('{(trip mod)}', '{(trip sat)}')";
              ==
        ==
      ;div
          =class  "w-full flex gap-3 {kas} {cas}"
          =x-show  "$store.page.size {(trip ?:(top '=' '!'))}= 'desktop'"
        ;div(class "w-full flex flex-row gap-2 {(trip ?:(top '' 'justify-center'))}")
          ;*  %+  turn  `(list @tas)`~[%following %discover %action %controls]
              |=  mod=@tas
              ^-  manx
              =+  [cas="px-3 py-2 rounded-md" cis=?:(top "w-6" "w-8")]
              =+  kas=?.(=(dyp mod) ~ "bg-palette-background")
              ?.  ?=(%controls mod)
                ;a/"{(dest:enrl:ff:fh /dashboard/[mod])}"(class "{cas} {kas}")
                  ;img@"{(aset:enrl:ff:fh mod)}"(class cis);
                ==
              ?:  top  syk
              ;button  =type  "button"
                  =x-on-click  "toggleTray(undefined)"
                  =class  "{cas} border-l border-gray-250"
                ;img@"{(aset:enrl:ff:fh mod)}"(class cis);
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
                            ^-  (list @tas)
                            %+  welp  ~[%swap %work %orac]
                            ?:(=(%discover dyp) ~[%undo] ~[%stat %undo])
                          |=  mod=@tas
                          ?:  ?=(%undo mod)
                            ;button(type "button", x-on-click "toggleFilter(undefined); wipeFilter()")
                              ; RESET
                            ==
                          ;button(type "button", x-on-click "toggleFilter('{(trip mod)}')")
                            ;*  %+  turn  `(list @tas)`~[%$ %off]
                                |=  sat=@tas
                                =/  ast=tape
                                  %+  welp  "filter-"
                                  ?:(=(%$ sat) (trip mod) "{(trip mod)}-{(trip sat)}")
                                ;img.w-6@"{(aset:enrl:ff:fh (crip ast))}"
                                  =x-show  "showFilterButton('{(trip mod)}', '{(trip sat)}')";
                          ==
                    ==
                    ;div(x-show "filt_status.mode == 'swap'")
                      ;+  %:  ~(swap-selz ui:fh "flex flex-row gap-2")
                              ?:(top 0 1)
                              &
                              swap.arg
                              "filt_status.params.swap"
                              ~
                          ==
                    ==
                    ;div(x-show "filt_status.mode == 'work'")
                      ;select#filt-worker(x-init sin, x-model "filt_status.params.work")
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
                      ;select#filt-oracle(x-init sin, x-model "filt_status.params.orac")
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
                      ;select#filt-status(x-init sin, x-model "filt_status.params.stat")
                        ;*  :-  ;option(value ""): Any Status
                            %+  turn  `(list stat:f)`~[%born %prop %lock %work %sess %done %dead]
                            |=  sat=stat:f
                            ^-  manx
                            ::  FIXME: This is so ugly, but there isn't any easy
                            ::  way to grab the color through a Tailwind class
                            =/  clr=tape
                              ?-  sat
                                %born  "a2a2a2"
                                %prop  "404040"
                                %lock  "5fb4bf"
                                %work  "3e72cc"
                                %sess  "1e3c71"
                                %done  "71a481"
                                %dead  "ff4d70"
                              ==
                            :_  ; {(stat:enjs:ff:fh sat)}
                            :-  %option
                            ;:  welp
                                [%value "{(trip sat)}"]~
                                [%data-image "https://placehold.co/24x24/{clr}/{clr}?text=\\n"]~
                                ?.(&(?=(^ stat.arg) =(u.stat.arg sat)) ~ [%selected ~]~)
                            ==
                      ==
                    ==
                  ==
                  ;div(class "flex-1 {kas}", x-show "tray_status.mode == 'sort'")
                    ;*  %+  turn  `(list @tas)`~[%time %pals %cost %alph %undo]
                        |=  mod=@tas
                        ?:  ?=(%undo mod)
                          ;button(type "button", x-on-click "updateSort(undefined)"): RESET
                        ;button(type "button", x-on-click "updateSort('{(trip mod)}')")
                          ;*  %+  turn  `(list @tas)`~[%asc %des %off]
                              |=  ord=@tas
                              =/  ast=tape  "sort-{(trip mod)}-{(trip ord)}"
                              ;img.w-6@"{(aset:enrl:ff:fh (crip ast))}"
                                =x-show  "showSortButton('{(trip mod)}', '{(trip ord)}')";
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
    ;div(class "flex flex-col p-2 gap-2 min-h-[100vh]")
      ;*  =/  cas=tape  "w-full grid gap-4 justify-center"
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
            :~  ;h1-alt: Following
                  ?~  paz=(turn pyz proj-card:ui)  wax
                ;div(class pas)
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
                  ?~  maz=(turn myz meta-card:ui)  wax
                ;div(class mas)
                  ;*  maz
                ==
            ==
          ::
              %action
            =/  sas=tape  "grid gap-4 grid-rows-1 grid-flow-col overflow-x-auto"
            =/  sus=tape  "w-[50vw] sm:w-[250px]"
            ?^  text.arg
              :_  ~
              %^  mota-well:ui  mas  "No projects found."
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
                    ;+  %^  ~(mota-well ui sus)  sas  ~
                        |=  [lag=flag:f pre=prej:proj:f]
                        ?&  ?!  ?=(?(%done %dead) ~(stat pj:fj -.pre))
                            =(our.bol p.lag)
                        ==
                  ==
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
                    ;+  %^  ~(mota-well ui sus)  sas  "No projects pending review."
                        |=  [lag=flag:f pre=prej:proj:f]
                        ?&  ?=(%sess ~(stat pj:fj -.pre))
                            =(p.assessment.pre our.bol)
                        ==
                  ==
                  ;div                               ::  $prez with unfulfilled $plej
                    ;h2: Outstanding Pledges
                    ;+  %^  ~(mota-well ui sus)  sas  "No outstanding pledges."
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
            this.openHREF(`${window.location.pathname}?${params}`);
          },
          })));
          '''
      ==
    ==
  ==
--
::  VERSION: [1 4 0]
