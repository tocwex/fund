::  /web/fund/page/prof-view/hoon: profile page for ship
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fk=fund-core, fh=fund-http, fc=fund-chain, fz=fund-alien, fx=fund-xtra
/+  rudder
%-  :(corl dump:preface:fh init:preface:fh (prof:preface:fh |))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [sup=(unit @p) pru=(unit pref:prof:f)]  (grab:prof:preface:fh arz)
  ?.  ?=(^ sup)
    [%code 404 'invalid ship name']
  =*  sip  u.sup
  =/  aut=?(%clear %eauth %mauth %admin)
    ?.((auth:fh bol) %clear ?:(=(our src):bol %admin ?:(=(sip src.bol) %mauth %eauth)))
  ?.  ?=(%admin aut)
    [%auth url.request.ord]
  =/  mes=(map flag:f mete:meta:f)  ~(ours conn:meta:fd bol [meta-subs meta-pubs]:dat)
  =+  .^(waz=(list addr:f) (beag:fx bol /prof/(scot %p sip)/adrz))
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "{(ssip:enjs:ff:fh sip)}'s profile"
  :+  fut=&  hed=&
  ;div(x-data "prof_view")
    ;div(class "fund-main")
      ;p(class "text-yellow-500 border-yellow-500 border rounded-md p-3")
        ; Congratulations on finding our experimental profile pages!
        ; Please feel free
        ;a.text-link(target "_blank", href (chat:enrl:ff:fh ~tocwex)):  to DM ~tocwex
        ;span:  if you have feedback.
      ==
      ;div(class "flex flex-col")
        ;h1: {(ship:enjs:ff:fh sip)}'s Profile
        ;h2-alt: {(ship:enjs:ff:fh our.bol)}'s Lens
      ==
      ;+  %^  ~(mold-card ui:fh ~)  syz=%lg  pic=(~(ship-logo fz bol) sip)
          :-  ^=  liz
              :~  [txt=(~(ship-tytl fz bol) sip) lin=(prot:enrl:ff:fh sip) cop=(ship:enjs:ff:fh sip) xin=~]
                  [txt="AZP: {<`@`sip>}" lin=(nurt:enrl:ff:fh sip) cop=(bloq:enjs:ff:fh `@`sip) xin=~]
              ==
          ^=  buz
          ;:  welp
                ?.  &(=(%admin aut) !=(sip src.bol))  ~
              :_  ~
              ;a/"{(chat:enrl:ff:fh sip)}"(target "_blank")
                ;img.fund-butn-icon@"{(aset:enrl:ff:fh %chat)}";
              ==
          ::
                ?:  ?=(~ pru)  ~
              :_  ~
              (sher-butn:ui:fh "{(trip ship-url.u.pru)}{(prot:enrl:ff:fh sip)}")
          ::
                ?.  =(%admin aut)  ~  ::  ?=(?(%mauth %admin) aut)  ~
              ::  FIXME: Replace these icons with final counterparts
              %+  turn  `(list [@tas @tas])`~[[%statistics %graph] [%graph %discover]]
              |=  [loc=@tas ast=@tas]
              ;a/"{(prot:enrl:ff:fh sip)}/{(trip loc)}"
                ;img.fund-butn-icon@"{(aset:enrl:ff:fh ast)}";
              ==
          ::
                ~
          ==
      ;h1-alt: Favorites
      ;+  %:  meta-mosa:ui:fh  bol  %sm  'No favorites found.'
              %+  murn  ~(tap in ?:(?=(~ pru) *(set flag:f) favorites.u.pru))
              |=  lag=flag:f
              ?~(met=(~(get by mes) lag) ~ `[lag u.met])
          ==
      ;h1-alt: Attested Wallets
      ;+  ?~  waz  ;p.fund-warn: No wallets found.
          ?.  =(%admin aut)  ;p.fund-warn: Unavailable to external users.
          ;div(class "w-full overflow-x-auto overflow-y-hidden")
            ;table(class "w-full table-auto border-separate border-spacing-y-2 -mt-2")
              ;thead
                ;tr.text-sm.text-palette-contrast.underline
                  ;th.text-center: chain
                  ;th.text-left: wallet address
                ==
              ==
              ;tbody
                ;*  %+  turn  (sort waz lth)
                    |=  adr=addr:f
                    ^-  manx
                    ;tr.bg-palette-contrast
                      ;td.w-12.whitespace-nowrap.rounded-l-lg.py-4
                        ;+  (~(icon-logo ui:fh "mx-auto") %circ (aset:enrl:ff:fh %ethereum))
                      ==
                      ;td.rounded-r-lg.font-mono
                        ;div.flex.items-center.gap-1
                          ;*  =/  tad=tape  (addr:enjs:ff:fh adr)
                              :~  (link-text:ui:fh (esat:enrl:ff:fh %addr adr 1) & tad ~)
                                  (copy-butn:ui:fh tad)
                              ==
                        ==
                      ==
                    ==
              ==
            ==
          ==
      ;h1-alt: Fund Contributions
      ;+  =/  txz=(list [flag:f prej:proj:f mula:f])
            =-  %+  sort  txz
                =+  salv=|=([p=prej:proj:f m=mula:f] (daoq:fk (tula:fk m) chain.payment.p))
                |=([[* a=[prej:proj:f mula:f]] [* b=[prej:proj:f mula:f]]] (gth (salv a) (salv b)))
            ^-  txz=(list [flag:f prej:proj:f mula:f])
            %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
            |=  [[lag=flag:f nex=prej:proj:f] acc=(list [flag:f prej:proj:f mula:f])]
            =-  (welp acc (turn muz |=(mul=mula:f [lag nex mul])))
            ^-  muz=(list mula:f)
            (~(mula pj:fj -.nex) (sy ~[%pruf-open %plej-open %plej-stif %plej-slyd %trib]) `[sip (silt waz)])
          ?~  txz  ;p.fund-warn: No transactions found.
          ?.  =(%admin aut)  ;p.fund-warn: Unavailable to external users.
          ;div(class "w-full overflow-x-auto overflow-y-hidden")
            ;table(class "w-full table-auto border-separate border-spacing-y-2 -mt-2")
              ;thead
                ;tr.text-sm.text-palette-contrast.underline
                  ;th.text-center: amount
                  ;th.text-center: status
                  ;th.text-center: project
                  ;th.text-center: worker
                  ;th.text-center: oracle
                  ;th.text-center: block
                  ;th.text-center: wallet
                  ;th.text-center: transaction
                  ;th.text-left: message
                ==
              ==
              ;tbody
                ;*  %+  turn  txz
                    |=  [lag=flag:f pre=prej:proj:f mul=mula:f]
                    ^-  manx
                    ;tr.bg-palette-contrast
                      ;td.italic.w-1.whitespace-nowrap.rounded-l-lg.py-4
                        ; {(swam:enjs:ff:fh cash.mul payment.pre)}
                      ==
                      ;td.w-1.px-2.whitespace-nowrap
                        ;+  (mula-pill:ui:fh %sm mul pre bol)
                      ==
                      ;td.w-60.overflow-hidden
                        ;+  (~(link-text ui:fh "line-clamp-1") (flat:enrl:ff:fh lag) | (trip title.pre) ~)
                      ==
                      ;td.w-1.px-6.whitespace-nowrap
                        ;+  (ship-agis:ui:fh %md p.lag bol)
                      ==
                      ;td.w-1.px-6.whitespace-nowrap
                        ;+  (ship-agis:ui:fh %md p.assessment.pre bol)
                      ==
                      ;td.w-1.px-6.whitespace-nowrap.text-nowrap.font-mono
                        ;div.flex.items-center.gap-2
                          ::  ; {(date:enjs:ff:fh (daoq:fk (tula:fk mul) chain.payment.pre))}
                          ;*  :~    %+  icon-logo:ui:fh  %circ
                                  (aset:enrl:ff:fh tag:(~(got by xmap:fc) chain.payment.pre))
                              ::
                                  ;span: {(bloq:enjs:ff:fh (tula:fk mul))}
                              ==
                        ==
                      ==
                      ;td.w-1.px-2.whitespace-nowrap.text-nowrap.text-center.font-mono
                        ;+  ?-    -.mul
                                %plej
                              ;span: —
                            ::
                                ?(%trib %pruf)
                              ;div.flex.items-center.gap-1
                                ;*  :~  %:  link-text:ui:fh
                                            wer=(esat:enrl:ff:fh %addr from.when.mul chain.payment.pre)
                                            tab=&
                                            txt=(sadr:enjs:ff:fh from.when.mul)
                                            diz=~
                                        ==
                                        (copy-butn:ui:fh (addr:enjs:ff:fh from.when.mul))
                                    ==
                              ==
                            ==
                      ==
                      ;td.w-1.px-2.whitespace-nowrap.text-nowrap.text-center.font-mono
                        ;+  ?-    -.mul
                                %plej
                              ;span: —
                            ::
                                ?(%trib %pruf)
                              ;div.flex.items-center.gap-1
                                ;*  :~  %:  link-text:ui:fh
                                            wer=(esat:enrl:ff:fh %xact q.xact.when.mul chain.payment.pre)
                                            tab=&
                                            txt=(sadr:enjs:ff:fh q.xact.when.mul)
                                            diz=~
                                        ==
                                        (copy-butn:ui:fh (addr:enjs:ff:fh q.xact.when.mul))
                                    ==
                              ==
                            ==
                      ==
                      ;td(class "w-60 overflow-hidden rounded-r-lg")
                        ;span.line-clamp-1: {(trip note.mul)}
                      ==
                    ==
              ==
            ==
          ==
    ==
    ;script
      ;+  ;/
      ::  FIXME: Hack to reduce build times and fix build stack overflows
      ::  on some ships
      %-  zing  %+  join  "\0a"
      ^-  (list tape)
      :~  "document.addEventListener('alpine:init', () => Alpine.data('prof_view', () => (\{"
          ^-  tape  ^~
          %+  rip  3
          '''
          init() {
            // console.log('hello world');
          },
          })));
          '''
      ==
    ==
  ==
--
::  VERSION: [1 6 4]
