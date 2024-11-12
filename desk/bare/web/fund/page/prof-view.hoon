::  /web/fund/page/prof-view/hoon: profile page for ship
::
/-  fd=fund-data, f=fund
/+  fj=fund-proj, fk=fund-core, fh=fund-http, fx=fund-xtra
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
  ?:  ?=(%clear aut)
    [%auth url.request.ord]
  =/  mes=(map flag:f mete:meta:f)  ~(ours conn:meta:fd bol [meta-subs meta-pubs]:dat)
  =/  waz=(list addr:f)
    .^((list addr:f) %gx (en-beam [our.bol %fund da+now.bol] /prof/(scot %p sip)/adrz/noun))
  =/  was=(set addr:f)  (silt waz)
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "{(ship:enjs:ff:fh sip)}'s profile"
  :+  fut=&  hed=&
  ;div(x-data ~)
    ::  NOTE: Using another trick to always push footer to the bottom
    ::  https://stackoverflow.com/a/59865099
    ;div(class "flex flex-col gap-2 px-2 py-2 sm:px-5 min-h-[100vh]")
      ;h1: {(ship:enjs:ff:fh sip)}'s Profile ({(ship:enjs:ff:fh our.bol)}'s Lens)
      ;div(class "flex flex-col gap-1 text-black")
        ;div(class "flex justify-start gap-2")
          ;+  (~(ship-logo ui:fh "h-32") sip bol)
          ;div(class "flex flex-col justify-between")
            ;div(class "flex flex-col justify-start items-start")
              ;div(class "inline-flex items-center gap-1")
                ;h3
                  ;+  (ship-tytl:ui:fh sip bol)
                ==
                ;+  (copy-butn:ui:fh (ship:enjs:ff:fh sip))
              ==
              ;div(class "inline-flex items-center gap-1")
                ;a/"https://network.urbit.org/{<sip>}"
                    =target  "_blank"
                    =class  "text-base sm:text-xl font-normal hover:text-link"
                  ; AZP: {<`@`sip>}
                ==
                ;+  (copy-butn:ui:fh (bloq:enjs:ff:fh `@`sip))
              ==
            ==
            ;div(class "inline-flex items-center gap-2")
              ;*  %-  turn  :_  |=(m=manx (~(hoal ma:fh m) 'adadad'))
                  ;:  welp
                        ?:  |(!=(our src):bol =(sip src.bol))  ~
                      :_  ~
                      ;a/"{(chat:enrl:ff:fh sip)}"(target "_blank")
                        ;img.fund-butn-icon@"{(aset:enrl:ff:fh %chat)}";
                      ==
                  ::
                        ?:  ?=(~ pru)  ~
                      :_  ~
                      (sink-butn:ui:fh sip (trip ship-url.u.pru))
                  ::
                        ?.  ?=(?(%mauth %admin) aut)  ~
                      :_  ~
                      ;a/"{(prot:enrl:ff:fh sip)}/statistics"
                        ;img.fund-butn-icon@"{(aset:enrl:ff:fh %etherscan)}";
                      ==
                  ==
            ==
          ==
        ==
      ==
      ;h1-alt: Favorites
      ;+  %:  meta-stax:ui:fh  bol  %smol  'No favorites found.'
              %+  murn  ~(tap in ?:(?=(~ pru) *(set flag:f) favorites.u.pru))
              |=  lag=flag:f
              ?~(met=(~(get by mes) lag) ~ `[lag u.met])
          ==
      ;h1-alt: Attested Wallets
      ;+  ?~  waz  ;p.fund-warn: No wallets found.
          ?.  ?=(?(%mauth %admin) aut)  ;p.fund-warn: Unavailable to external users.
          ;div(class "w-full overflow-x-auto overflow-y-hidden")
            ;table(class "w-full table-auto border-separate border-spacing-y-2 -mt-2")
              ;thead
                ;tr.text-sm.text-palette-contrast.underline
                  ;th.text-center: chain
                  ;th.text-left: wallet address
                ==
              ==
              ;tbody
                ;*  %+  turn  waz
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
                |=  [a=[flag:f prej:proj:f m=mula:f] b=[flag:f prej:proj:f m=mula:f]]
                (gth (tula:fk m.a) (tula:fk m.b))
            ^-  txz=(list [flag:f prej:proj:f mula:f])
            %-  ~(rep by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat))
            |=  [[lag=flag:f nex=prej:proj:f] acc=(list [flag:f prej:proj:f mula:f])]
            =-  (welp acc (turn muz |=(mul=mula:f [lag nex mul])))
            ^-  muz=(list mula:f)
            %+  skim  ~(mula pj:fj -.nex)
            |=  mul=mula:f
            =/  who=(unit @p)  ?-(-.mul %trib ship.mul, %plej `ship.mul, %pruf ~)
            =/  adr=(unit addr:f)  ?+(-.mul `from.when.mul %plej ~)
            ?|  ?&(?=(^ who) =(sip u.who))
                ?&  ?=(^ adr)
                    (~(has in was) u.adr)
                    ?!(&(?=(%pruf -.mul) ?=(%with note.mul)))
                ==
            ==
          ?~  txz  ;p.fund-warn: No transactions found.
          ?.  ?=(?(%mauth %admin) aut)  ;p.fund-warn: Unavailable to external users.
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
                        ;+  (mula-pill:ui:fh %smol mul pre bol)
                      ==
                      ;td.w-60.overflow-hidden
                        ;+  (~(link-text ui:fh "line-clamp-1") (flat:enrl:ff:fh lag) | (trip title.pre) ~)
                      ==
                      ;td.w-1.px-6.whitespace-nowrap
                        ;+  (ship-agis:ui:fh %medi p.lag bol)
                      ==
                      ;td.w-1.px-6.whitespace-nowrap
                        ;+  (ship-agis:ui:fh %medi p.assessment.pre bol)
                      ==
                      ;td.w-1.px-2.whitespace-nowrap.text-nowrap.font-mono
                        ; {(bloq:enjs:ff:fh (tula:fk mul))}
                        ::  ; {(date:enjs:ff:fh (tloq:fk (tula:fk mul) chain.payment.pre))}
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
  ==
--
::  VERSION: [1 4 5]
