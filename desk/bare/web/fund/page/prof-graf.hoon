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
    =/  ui
      |_  cas=tape
      +*  kas  "rounded-lg aspect-square border-white border-2 sm:border-4"
      ++  ship-tile
        |=  [sip=@p syz=@ud]
        ^-  manx
        ;a/"{(prot:enrl:ff:fh sip)}"(class "col-span-{<syz>} row-span-{<syz>}")
          ;+  (~(ship-logo ui:fh "h-full {kas} {cas}") sip bol)
        ==
      ++  proj-tile
        |=  [lag=flag:f pre=prej:proj:f]
        ^-  manx
        =/  irl=tape  ?^(image.pre (trip u.image.pre) (~(ship-logo fa:fh bol) p.lag))
        ;a/"{(flat:enrl:ff:fh lag)}"
          ;img@"{irl}"(class "{kas} {cas}");
        ==
      ++  empt-tile
        |=  lvl=@ud
        ^-  manx
        =/  qas=tape  ?:(=(2 lvl) "bg-palette-contrast" "bg-palette-background")
        ;div(class "{qas} {kas} {cas}");
      ++  ship-prev
        |=  sip=@p
        ^-  manx
        %^  ~(mold-card ui:fh ~)  syz=%lg  pic=(~(ship-logo fa:fh bol) sip)
        :-  ^=  liz
            :~  [txt=(~(ship-tytl fa:fh bol) sip) lin=(prot:enrl:ff:fh sip) cop=(ship:enjs:ff:fh sip)]
                [txt="Owner: {(sadr:enjs:ff:fh 0x0)}" lin=(esat:enrl:ff:fh %addr 0x0 1) cop=(addr:enjs:ff:fh 0x0)]
                [txt="AZP: {<`@`sip>}" lin=(nurt:enrl:ff:fh sip) cop=(bloq:enjs:ff:fh `@`sip)]
            ==
        ^=  buz
        ;:  welp
              ?.  &(=(our src):bol !=(sip src.bol))  ~
            :_  ~
            ;a/"{(chat:enrl:ff:fh sip)}"(target "_blank")
              ;img.fund-butn-icon@"{(aset:enrl:ff:fh %chat)}";
            ==
        ::
              ?.  |(=(our src):bol =(sip src.bol))  ~
            ::  FIXME: Replace these icons with final counterparts
            :_  ~
            ;a/"{(dest:enrl:ff:fh pat(sip (scot %p sip)))}"
              ;img.fund-butn-icon@"{(aset:enrl:ff:fh %search)}";
            ==
        ==
      ++  proj-prev
        |=  [lag=flag:f pre=prej:proj:f]
        ^-  manx
        %^  ~(mold-card ui:fh ~)  syz=%lg  pic=(pogo:fh lag -.pre bol)
        :_  buz=~
        ^=  liz
        ;:  welp
            [txt=(trip title.pre) lin=(flat:enrl:ff:fh lag) cop=(flag:enjs:ff:fh lag)]~
        ::
              %+  turn  `(list [@t @p])`~[['Worker' p.lag] ['Oracle' p.assessment.pre]]
            |=  [tyt=@t sip=@p]
            :*  txt="{(trip tyt)}: {(~(ship-tytl fa:fh bol) sip)}"
                lin=(prot:enrl:ff:fh sip)
                cop=(ship:enjs:ff:fh sip)
            ==
        ::
              :_  ~
            :*  txt="Amount: {(swam:enjs:ff:fh ~(cost pj:fj -.pre) payment.pre)}"
            ::
                  ^=  lin
                ?:  ?=(?(%born %prop) ~(stat pj:fj -.pre))  ~
                (esat:enrl:ff:fh %addr safe:(need contract.pre) chain.payment.pre)
            ::
                cop=(comp:enjs:ff:fh ~(cost pj:fj -.pre) payment.pre)
            ==
        ==
      ++  dash-navi
        |=  poz=(list [flag:f prej:proj:f])
        ^-  manx
        =/  kas=tape  "flex-col-reverse drip-shadow-lg fund-foot p-4"
        ;div
          ;+  (ship-prev sip)
          ;*  ?~  poz  ~
              [(proj-prev i.poz)]~
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
    =/  itz=(list $%([%ship @p] [%proj flag:f prej:proj:f]))
      ?-  foc.pat
        %ship  (turn siz (lead %ship))
        %proj  (turn poz (lead %proj))
      ==
    :-  %page
    %-  page:ui:fh
    :^  bol  ord  "{(ssip:enjs:ff:fh sip)}'s reputation"
    :+  fut=&  hed=&
    ;div(x-data "prof_graf")
      ::  NOTE: Using another trick to always push footer to the bottom
      ::  https://stackoverflow.com/a/59865099
      ;div(class "flex flex-col gap-2 px-2 py-2 sm:px-5 min-h-[100vh]")
        ;div(class "flex flex-col")
          ;h1: {(ship:enjs:ff:fh sip)}'s Reputation Graph
          ;h2-alt: {(ship:enjs:ff:fh our.bol)}'s Lens
        ==
        ;div(class "grid grid-cols-7 gap-1 sm:gap-4")
          ::  TODO: fill algorithm is just linear fill for now;
          ::  probably want "even distribution starting from center"
          ;*  %+  murn  (ozip:fx (gulf 0 (dec (mul 7 7))) itz)
              |=  [pud=(unit @ud) itu=(unit $%([%ship @p] [%proj flag:f prej:proj:f]))]
              ^-  (unit manx)
              ?~  pud  ~
              =*  pid  u.pud
              =/  [pix=@ud piy=@ud]  [(mod pid 7) (div pid 7)]
              =/  pil=@ud  (max (dist:fx pix 3) (dist:fx piy 3))
              ?:  (lte pil 1)  ?.(=(17 pid) ~ `(ship-tile:ui sip 3))
              ?~  itu  `(empt-tile:ui pil)
              =*  ite  u.itu
              ?-  -.ite
                %ship  `(ship-tile:ui +.ite 1)
                %proj  `(proj-tile:ui +.ite)
              ==
        ==
      ==
      ::  ;+  (~(dash-navi ui ~) poz=poz)
      ;script
        ;+  ;/
        %-  zing  %+  join  "\0a"
        ^-  (list tape)
        :~  "document.addEventListener('alpine:init', () => Alpine.data('prof_graf', () => (\{"
            "tray_status: \{prof: undefined, open: false},"
            "})));"
        ==
      ==
    ==
  ==
--
::  VERSION: [1 4 5]
