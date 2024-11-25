::  /web/fund/page/prof-graf/hoon: 'subjective reputation graph' page for ship
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fh=fund-http, fx=fund-xtra
/+  rudder
%-  :(corl dump:preface:fh init:preface:fh (prof:preface:fh &))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  pat=(pole knot)  (slag:derl:ff:fh url.request.ord)
  =/  [sip=@p pro=pref:prof:f]  (greb:prof:preface:fh arz)
  ?.  |(=(our src):bol =(sip src.bol))
    [%auth url.request.ord]
  ?+      pat
        [%code 404 'invalid graph url']
      [%profile sip=@ %graph rol=@ foc=@ ~]
    ?.  ?=(role:f rol.pat)
      [%code 404 'invalid graph role']
    ?.  ?=(?(%ship %proj) foc.pat)
      [%code 404 'invalid graph focus']
    =+  .^(waz=(list addr:f) %gx (en-beam [our.bol %fund da+now.bol] /prof/(scot %p sip)/adrz/noun))
    =/  was=(set addr:f)  (silt waz)
    =/  ui
      |_  cas=tape
      +*  kas  "rounded-lg aspect-square border-white border-2"
      +$  focu  $%([%ship @p] [%proj flag:f prej:proj:f])
      ++  focu-tile
        |=  foc=focu
        ^-  manx
        ?-  -.foc
          %ship  (ship-tile +.foc 1)
          %proj  (proj-tile +.foc)
        ==
      ++  ship-tile
        |=  [sip=@p syz=@ud]
        ^-  manx
        ;button  =type  "button"
            =x-on-click  "showTile('{(ship:enjs:ff:fh sip)}')"
            =class  "col-span-{<syz>} row-span-{<syz>}"
          ;+  (~(ship-logo ui:fh "h-full w-full {kas} {cas}") sip bol)
        ==
      ++  proj-tile
        |=  [lag=flag:f pre=prej:proj:f]
        ^-  manx
        ;button  =type  "button"
            =x-on-click  "showTile('{(flag:enjs:ff:fh lag)}')"
          ;img@"{(pogo:fh lag -.pre bol)}"(class "{kas} {cas}");
        ==
      ++  empt-tile
        |=  lvl=@ud
        ^-  manx
        =/  qas=tape  ?:(=(2 lvl) "bg-palette-contrast" "bg-palette-background")
        ;div(class "{qas} {kas} {cas}");
      ++  focu-prev
        |=  foc=focu
        ^-  manx
        =/  fid=tape
          ?:  ?=(%ship -.foc)  (ship:enjs:ff:fh +.foc)
          (flag:enjs:ff:fh +<.foc)
        =/  ros=role:f
          ?:  |(?=(%proj -.foc) =(sip +.foc))  rol.pat
          ?-(rol.pat %fund %work, %work %orac, %orac %work)
        ;div(id fid, class "flex flex-col gap-2")
          ;div(class "flex justify-between items-center")
            ;div(class "inline-flex gap-1 items-center")
              ;h3(class "leading-none")
                ;+  ;/  ?-    -.foc
                          %proj  "Project Summary"
                        ::
                            %ship
                          =-  "{-} Profile"
                          ?-(ros %fund "Funder", %work "Worker", %orac "Oracle")
                        ==
              ==
              ;button(type "button", x-init "initTippy($el, \{hover: true})")
                ;img.w-6.fund-butn-icon@"{(aset:enrl:ff:fh %help)}";
              ==
              ;div(class "hidden")
                ;+  ;/  ?-    -.foc
                            %proj
                          ^-  tape  ^~
                          %+  rip  3
                          '''
                          The project score is the percentage of funds
                          secured relative to the project goal.
                          '''
                        ::
                            %ship
                          ?-    ros
                              %fund
                            ^-  tape  ^~
                            %+  rip  3
                            '''
                            The funder score the ratio of realized
                            contributions to open pledges.
                            '''
                          ::
                              %work
                            ^-  tape  ^~
                            %+  rip  3
                            '''
                            The worker score is percentage of successful
                            payouts relative to total open milestone
                            goals.
                            '''
                          ::
                              %orac
                            ^-  tape  ^~
                            %+  rip  3
                            '''
                            The oracle score is the approval rate
                            relative to all reviewed and pending
                            milestones.
                            '''
                          ==
                        ==
              ==
            ==
            ;div(class "inline-flex gap-1 items-center")
              ;*  ?:  ?=(%proj -.foc)  ~
                  %-  turn  :_  hink:fh
                  %+  welp
                    ?.  &(=(our src):bol !=(+.foc src.bol))  ~
                    :_  ~
                    ;a/"{(chat:enrl:ff:fh sip)}"(target "_blank")
                      ;img.fund-butn-icon@"{(aset:enrl:ff:fh %chat)}";
                    ==
                  %+  turn  `(list role:f)`~[%fund %work %orac]
                  |=  rol=role:f
                  =/  rot=@t  (crip "filter-{(trip rol)}")
                  ::  TODO: This isn't the correct ship; need to use JS
                  ::  probably for that
                  ;a/"{(dest:enrl:ff:fh pat(sip (scot %p sip), rol rol))}"
                    ;img.fund-butn-icon@"{(aset:enrl:ff:fh rot)}";
                  ==
            ==
          ==
          ;+  %+  ~(mold-card ui:fh ~)  syz=%lg
              ?-    -.foc
                  %ship
                =*  sip  +.foc
                =/  poz=(list [flag:f prej:proj:f])
                  %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
                  |=  [[lag=flag:f pre=prej:proj:f] acc=(list [flag:f prej:proj:f])]
                  ?.((~(has in (~(rols pj:fj -.pre) p.lag sip)) ros) acc [[lag pre] acc])
                =/  sco=tape
                  %-  real:enjs:ff:fh
                  ?-    ros
                      %fund
                    ::  (amount for all contributions) / (amount for all open pledges)
                    %-  rato:fx
                    :_  %+  roll  poz
                        |=  [[* pre=prej:proj:f] acc=@ud]
                        %+  add  acc
                        ?~(pej=(~(get by pledges.pre) sip) 0 cash.u.pej)
                    %+  roll  poz
                    |=  [[* pre=prej:proj:f] acc=@ud]
                    %+  add  acc
                    %+  roll  ~(fula pj:fj -.pre)
                    |=  [mul=mula:f acc=@ud]
                    ?.(&(?=(%trib -.mul) (~(has in was) from.when.mul)) 0 cash.mul)
                  ::
                      %work
                    ::  (amount of successfully withdrawn funds) / (cost of all open milestones)
                    %-  rato:fx
                    :-  (roll poz |=([[* p=prej:proj:f] a=@] (add a ~(take pj:fj -.p))))
                    %+  roll  poz
                    |=  [[* pre=prej:proj:f] acc=@]
                    %+  add  acc
                    %+  roll  `(list mile:proj:f)`milestones.pre
                    |=  [mil=mile:proj:f acc=@]
                    %+  add  acc
                    ?:(?=(?(%done %dead) status.mil) 0 cost.mil)
                  ::
                      %orac
                    ::  (# approved milestones) / (# reviewed/pending milestones)
                    %-  perc:fx
                    :_  (roll poz |=([[* p=prej:proj:f] a=@] (add a (lent milestones.p))))
                    %+  roll  poz
                    |=  [[* pre=prej:proj:f] acc=@]
                    %+  add  acc
                    %-  lent
                    %+  skim  `(list mile:proj:f)`milestones.pre
                    |=(m=mile:proj:f =(%done status.m))
                  ==
                :-  pic=(~(ship-logo fa:fh bol) sip)
                :_  buz=~
                ^=  liz
                :~  [txt=(~(ship-tytl fa:fh bol) sip) lin=(prot:enrl:ff:fh sip) cop=(ship:enjs:ff:fh sip)]
                    [txt="Owner: {(sadr:enjs:ff:fh 0x0)}" lin=(esat:enrl:ff:fh %addr 0x0 1) cop=(addr:enjs:ff:fh 0x0)]
                    [txt="AZP: {<`@`sip>}" lin=(nurt:enrl:ff:fh sip) cop=(bloq:enjs:ff:fh `@`sip)]
                    [txt="Score: {sco}" lin=~ cop=sco]
                ==
              ::
                  %proj
                =*  lag  +<.foc
                =*  pre  +>.foc
                =/  sco=tape
                  %-  real:enjs:ff:fh
                  (perc:fx ~(take pj:fj -.pre) ~(cost pj:fj -.pre))
                :-  pic=(pogo:fh lag -.pre bol)
                :_  buz=~
                ^=  liz
                ;:  welp
                      :_  ~
                    :*  txt=(trip title.pre)
                        lin=(flat:enrl:ff:fh lag)
                        cop=(flat:enrl:ff:fh lag)
                    ==
                ::
                      %+  turn  `(list [@t @p])`~[['Worker' p.lag] ['Oracle' p.assessment.pre]]
                    |=  [tyt=@t sip=@p]
                    :*  txt="{(trip tyt)}: {(~(ship-tytl fa:fh bol) sip)}"
                        lin=(prot:enrl:ff:fh sip)
                        cop=(ship:enjs:ff:fh sip)
                    ==
                ::
                      :_  ~
                    :*  txt="Score: {sco}"
                    ::
                          ^=  lin
                        ?:  ?=(?(%born %prop) ~(stat pj:fj -.pre))  ~
                        (esat:enrl:ff:fh %addr safe:(need contract.pre) chain.payment.pre)
                    ::
                        cop=sco
                    ==
                ==
              ==
        ==
      ++  dash-navi
        |=  [top=bean fuz=(list focu)]
        ^-  manx
        =/  kas=tape
          ?:  top  "flex-col rounded-lg drop-shadow-lg px-4 py-2"
          "flex-col-reverse drip-shadow-lg rounded-t-[30px] fund-foot p-4"
        =/  xow=tape  "$store.page.size {(trip ?:(top '=' '!'))}= 'desktop'"
        =/  xop=tape  ?:(top "false" "tray_status.open")
        ;div
            =class  "w-full flex gap-3 bg-palette-contrast {kas} {cas}"
            =x-show  "{xow} || {xop}"
          ;div
              =class  "w-full flex flex-row items-center justify-around gap-2"
              =x-show  xow
            ;div(class "flex gap-2 w-1/2 sm:w-1/3")
              ;img.fund-butn-icon@"{(aset:enrl:ff:fh %role)}";
              ;select.w-full  =name  "rol"  =required  ~
                  =x-init  "initTomSelect($el, \{asButton: false})"
                  =x-model  "graf_role"
                  =x-on-change  "gotoGraph(graf_role, undefined)"
                ;*  %+  turn  `(list role:f)`~[%fund %work %orac]
                    |=  rol=role:f
                    ^-  manx
                    :_  ; {(role:enjs:ff:fh rol)}
                    :-  %option
                    ;:  welp
                        [%value (trip rol)]~
                        [%data-image (aset:enrl:ff:fh (crip "filter-{(trip rol)}"))]~
                        ?.(=(rol.pat rol) ~ [%selected ~]~)
                    ==
              ==
            ==
            ;div(class "flex gap-2 w-1/2 sm:w-1/3")
              ;img.fund-butn-icon@"{(aset:enrl:ff:fh %focus)}";
              ;select.w-full  =name  "foc"  =required  ~
                  =x-init   "initTomSelect($el, \{asButton: false})"
                  =x-model  "graf_focu"
                  =x-on-change  "gotoGraph(undefined, graf_focu)"
                ;*  %+  turn  `(list ?(%ship %proj))`~[%ship %proj]
                    |=  foc=?(%ship %proj)
                    ^-  manx
                    :_  ; {?-(foc %ship "ship", %proj "project")}
                    :-  %option
                    ;:  welp
                        [%value (trip foc)]~
                        [%data-image (aset:enrl:ff:fh foc)]~
                        ?.(=(foc.pat foc) ~ [%selected ~]~)
                    ==
              ==
            ==
          ==
          ;div(class "w-full", x-show xop, x-on-click-outside "tray_status.open = false")
            ;*  %+  turn  fuz
                |=  foc=focu
                %-  ~(riat ma:fh (focu-prev foc))
                [%x-show "tray_status.prof == $el.id"]~
          ==
        ==
      --
    ::  TODO: Apply some sort of relevance score and sorting to this list
    =/  poz=(list [flag:f prej:proj:f])
      %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
      |=  [[lag=flag:f pre=prej:proj:f] acc=(list [flag:f prej:proj:f])]
      =/  roz=(set role:f)  (~(rols pj:fj -.pre) p.lag sip)
      ?.((~(has in roz) rol.pat) acc [[lag pre] acc])
    =/  siz=(list @p)
      %~  tap  in
      %.  sip   %~  del  in
      %-  silt  %+  turn  poz
      |=([l=flag:f p=prej:proj:f] ?+(rol.pat p.l %work p.assessment.p))
    =/  fuz=(list focu:ui)
      ?-  foc.pat
        %ship  (turn siz (lead %ship))
        %proj  (turn poz (lead %proj))
      ==
    :-  %page
    %-  page:ui:fh
    :^  bol  ord  "{(ssip:enjs:ff:fh sip)}'s reputation"
    :+  fut=&  hed=|
    ;div(x-data "prof_graf")
      ;+  (head:ui:fh bol ord [(~(dash-navi ui ~) top=& fuz=[[%ship sip] fuz])]~)
      ;div(class "fund-main")
        ;div(class "flex flex-col")
          ;h1: {(ship:enjs:ff:fh sip)}'s Reputation Graph
          ;h2-alt: {(ship:enjs:ff:fh our.bol)}'s Lens
        ==
        ;div(class "grid grid-cols-7 gap-1 mx-auto max-w-[80vh]")
          ::  TODO: fill algorithm is just linear fill for now;
          ::  probably want "even distribution starting from center"
          ;*  %+  murn  (ozip:fx (gulf 0 (dec (mul 7 7))) fuz)
              |=  [pud=(unit @ud) fuc=(unit focu:ui)]
              ^-  (unit manx)
              ?~  pud  ~
              =*  pid  u.pud
              =/  [pix=@ud piy=@ud]  [(mod pid 7) (div pid 7)]
              =/  pil=@ud  (max (dist:fx pix 3) (dist:fx piy 3))
              ?:  (lte pil 1)  ?.(=(17 pid) ~ `(ship-tile:ui sip 3))
              ?~  fuc  `(empt-tile:ui pil)
              `(focu-tile:ui u.fuc)
        ==
      ==
      ;+  (~(dash-navi ui ~) top=| fuz=[[%ship sip] fuz])
      ;script
        ;+  ;/
        %-  zing  %+  join  "\0a"
        ^-  (list tape)
        :~  "document.addEventListener('alpine:init', () => Alpine.data('prof_graf', () => (\{"
            "tray_status: \{prof: undefined, open: false},"
            :(weld "graf_role: '" (trip rol.pat) "',")
            :(weld "graf_focu: '" (trip foc.pat) "',")
            ^-  tape  ^~
            %+  rip  3
            '''
            gotoGraph(role, focus) {
              const curUrl = window.location.toString();
              const newUrl = curUrl.replace(
                /\/([^\/]+)\/([^\/]+)$/,
                `/${role || '$1'}/${focus || '$2'}`,
              );
              this.openHREF(newUrl);
            },
            showTile(id) {
              this.tray_status.prof = id;
              this.tray_status.open = true;
            },
            })));
            '''
        ==
      ==
    ==
  ==
--
::  VERSION: [1 4 5]
