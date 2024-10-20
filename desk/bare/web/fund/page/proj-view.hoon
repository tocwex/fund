::  /web/fund/page/proj-view/hoon: render base project page for %fund
::
/-  fd=fund-data
/+  f=fund-proj, fh=fund-http, fc=fund-chain, fa=fund-alien, fx=fund-xtra
/+  rudder, config
%-  :(corl dump:preface:fh init:preface:fh (proj:preface:fh &))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  =/  [lag=flag:f pro=prej:f]  (greb:proj:preface:fh hed)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    =+  lin=(dec (lent milestones.pro))
    =+  dif=(~(got by p.arz) %dif)
    ?:  ?=(%fave-proj dif)  [%prof our.bol %fave lag]
    =-  ?@(- - [%proj lag -])
    ^-  $@(@t prod:f)
    ?+    dif  (crip "bad dif; expected (bump-*|wipe-*|mula-*|(folo|fave)-proj), not {(trip dif)}")
      %bump-born  [%bump %born ~]
      %bump-work  [%bump %work ~]
      %bump-sess  [%bump %sess ~]
      %folo-proj  [%lure src.bol %fund]
      %wipe-rede  [%wipe lin ~]
    ::
        %wipe-cade
      ?+  arz=(parz:fh bod (sy ~[%mii]))  p.arz  [%| *]
        [%wipe (bloq:dejs:ff:fh (~(got by p.arz) %mii)) ~]
      ==
    ::
        %wipe-casi
      ?+  arz=(parz:fh bod (sy ~[%mii %mis %mia %mit %mie]))  p.arz  [%| *]
        =/  emt=bean  (bool:dejs:ff:fh (~(got by p.arz) %mie))
        :+  %wipe  (bloq:dejs:ff:fh (~(got by p.arz) %mii))
        :^    ~
            (sign:dejs:ff:fh (~(got by p.arz) %mis))
          (addr:dejs:ff:fh (~(got by p.arz) %mia))
        ?:  emt  [%& (~(got by p.arz) %mit)]
        [%| (addr:dejs:ff:fh (~(got by p.arz) %mit))]
      ==
    ::
        %wipe-resi
      ?+  arz=(parz:fh bod (sy ~[%des %dea %det %dee]))  p.arz  [%| *]
        =/  emt=bean  (bool:dejs:ff:fh (~(got by p.arz) %dee))
        :+  %wipe  lin
        :^    ~
            (sign:dejs:ff:fh (~(got by p.arz) %des))
          (addr:dejs:ff:fh (~(got by p.arz) %dea))
        ?:  emt  [%& (~(got by p.arz) %det)]
        [%| (addr:dejs:ff:fh (~(got by p.arz) %det))]
      ==
    ::
        %bump-prop
      ?+  arz=(parz:fh bod (sy ~[%oas %oaa]))  p.arz  [%| *]
        :+  %bump  %prop
        :-  ~  =+  oat=*oath:f  %_  oat
            sigm
          :*  (sign:dejs:ff:fh (~(got by p.arz) %oas))
              (addr:dejs:ff:fh (~(got by p.arz) %oaa))
              [%& (crip (~(oath pj:f -.pro) p.lag))]
          ==
        ==
      ==
    ::
        %bump-lock
      ?+  arz=(parz:fh bod (sy ~[%sxb %sxa %swa %soa %ssa]))  p.arz  [%| *]
        :+  %bump  %lock  :-  ~
        :*  :-  (bloq:dejs:ff:fh (~(got by p.arz) %sxb))
              (addr:dejs:ff:fh (~(got by p.arz) %sxa))
            sigm:(need contract.pro)
            (addr:dejs:ff:fh (~(got by p.arz) %swa))
            (addr:dejs:ff:fh (~(got by p.arz) %soa))
            (addr:dejs:ff:fh (~(got by p.arz) %ssa))
        ==
      ==
    ::
        %bump-done
      ?+  arz=(parz:fh bod (sy ~[%mis %mia %mit %mie]))  p.arz  [%| *]
        =/  emt=bean  (bool:dejs:ff:fh (~(got by p.arz) %mie))
        :+  %bump  %done
        :-  ~  =+  oat=*oath:f  %_  oat
            sigm
          :*  (sign:dejs:ff:fh (~(got by p.arz) %mis))
              (addr:dejs:ff:fh (~(got by p.arz) %mia))
              ?:  emt  [%& (~(got by p.arz) %mit)]
              [%| (addr:dejs:ff:fh (~(got by p.arz) %mit))]
          ==
        ==
      ==
    ::
        %bump-dead
      ?+  arz=(parz:fh bod (sy ~[%des %dea %det]))  p.arz  [%| *]
        =/  emt=bean  (bool:dejs:ff:fh (~(got by p.arz) %dee))
        :+  %bump  %dead
        :-  ~  =+  oat=*oath:f  %_  oat
            sigm
          :*  (sign:dejs:ff:fh (~(got by p.arz) %des))
              (addr:dejs:ff:fh (~(got by p.arz) %dea))
              ?:  emt  [%& (~(got by p.arz) %det)]
              [%| (addr:dejs:ff:fh (~(got by p.arz) %det))]
          ==
        ==
      ==
    ::
        %draw-done
      ?+  arz=(parz:fh bod (sy ~[%mii %mib %mih]))  p.arz  [%| *]
        :^  %draw
            (bloq:dejs:ff:fh (~(got by p.arz) %mii))
          (bloq:dejs:ff:fh (~(got by p.arz) %mib))
        (addr:dejs:ff:fh (~(got by p.arz) %mih))
      ==
    ::
        %draw-dead
      ?+  arz=(parz:fh bod (sy ~[%mib %mih]))  p.arz  [%| *]
        :^  %draw
            lin
          (bloq:dejs:ff:fh (~(got by p.arz) %mib))
        (addr:dejs:ff:fh (~(got by p.arz) %mih))
      ==
    ::
        ?(%mula-plej %mula-trib)
      ?+  arz=(parz:fh bod (sy ~[%mxb %sum %msg]))  p.arz  [%| *]
        =/  who=(unit @p)  ?.((auth:fh bol) ~ `src.bol)
        =/  wen=@ud  (bloq:dejs:ff:fh (~(got by p.arz) %mxb))
        =/  sum=cash:f  (comp:dejs:ff:fh (~(got by p.arz) %sum) payment.pro)
        =/  msg=@t  (~(got by p.arz) %msg)
        ?-  dif
          %mula-plej  [%mula %plej (need who) sum wen msg]
        ::
            %mula-trib
          ?+  arz=(parz:fh bod (sy ~[%mxa %mad]))  p.arz  [%| *]
            :*  %mula  %trib  who  sum
                :-  [wen (addr:dejs:ff:fh (~(got by p.arz) %mxa))]
                  (addr:dejs:ff:fh (~(got by p.arz) %mad))
                msg
            ==
          ==
        ==
      ==
    ::
        ?(%mula-blot %mula-view %mula-mine %mula-redo)
      ?+  arz=(parz:fh bod (sy ~[%mut %mui]))  p.arz  [%| *]
        =/  mut=@t  (~(got by p.arz) %mut)
        =/  mui=@t  (~(got by p.arz) %mui)
        =/  med=@   ?+(mut (addr:dejs:ff:fh mui) %plej (ship:dejs:ff:fh mui))
        =/  mid=@
          ?+    mut  0
            %plej  ?~(pej=(~(get by pledges.pro) `@p`med) 0 id.u.pej)
            %trib  ?~(teb=(~(get by contribs.pro) `addr:f`med) 0 id.u.teb)
          ==
        ?-    dif
            %mula-blot
          =-  [%blot mid ?:(sow %hide %show)]
          ^-  sow=?
          ?+    mut  !!
            %plej  show:(~(got by pledges.pro) `@p`med)
            %trib  show:(~(got by contribs.pro) `addr:f`med)
          ==
        ::
            %mula-view
          =-  [%view mid ?:(sly %stif %slyd)]
          ^-  sly=?
          ?.  ?=(%plej mut)  !!
          =+  pej=(~(got by pledges.pro) `@p`med)
          ?~(vyw=view.pej !! =(%slyd u.vyw))
        ::
            %mula-mine
          ?.  ?=(%pruf mut)  !!
          =/  who=(unit @p)  ?.((auth:fh bol) ~ `src.bol)
          =/  puf=pruf:f  (~(got by proofs.pro) `addr:f`med)
          [%mula %trib who cash.puf when.puf %$]
        ::
            %mula-redo
          =/  win=@ud  :(mul 4 60 2)  ::  4 blocks/sec * 60 sec/min * 2 mins
          =-  [%redo `(sub boq win) `(add boq win)]
          ^-  boq=bloq:f
          ?.  ?=(%trib mut)  !!
          =+  tib=(~(got by contribs.pro) `addr:f`med)
          p.xact.when.tib
        ==
      ==
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  =/  [dyp=@tas lag=flag:f pyp=@tas]  (gref:proj:preface:fh txt)
  ::  FIXME: This is a hack caused by the fact that %fave is a profile
  ::  action and profiles do not have an associted project
  =?  lag  ?=(%fave pyp)  (need (flag:derl:ff:fh url.request.ord))
  :-  %next  :_  ~
  %-  desc:enrl:ff:fh
  /next/(scot %p p.lag)/[q.lag]/[?+(pyp %bump %mula-trib %trib, %mula-plej %plej)]
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [lag=flag:f pre=prej:f]  (greb:proj:preface:fh arz)
  =*  pro  -.pre
  =/  sat=stat:f  ~(stat pj:f pro)
  ::  NOTE: Gate non-`our` users to my ship's proposed-or-after projects
  ?:  &(!=(our src):bol |(!=(our.bol p.lag) ?=(%born sat)))  [%auth url.request.ord]
  =/  pom=(map @p pref:prof:fd)  ~(ours conn:prof:fd bol [prof-subs prof-pubs]:dat)
  =/  pou=(unit pref:prof:fd)  (~(get by pom) our.bol)
  =/  pow=(unit pref:prof:fd)  (~(get by pom) p.lag)
  =/  roz=(set role:f)  (~(rols pj:f pro) p.lag src.bol)
  =+  wok=(~(has in roz) %work)
  =+  ora=(~(has in roz) %orac)
  =+  arb==(!<(@p (slot:config %point)) src.bol)
  =+  [tym=|(wok ora) pyr=|(wok ora arb)]
  =/  pod=odit:f  ~(odit pj:f pro)
  =/  moz=(list odit:f)  ~(odim pj:f pro)
  =/  muz=(list mula:f)  ~(mula pj:f pro)
  =/  [nin=@ mile:f]  ~(next pj:f pro)
  =/  sos=@t  'adadad'
  =/  ui
    |_  cas=tape
    ++  bare-form
      |=  fom=manx
      ^-  manx
      ;form(method "post", autocomplete "off", class cas)
        ;+  fom
      ==
    ++  tipi-form
      |=  [tyt=tape fom=marl]
      ^-  manx
      ;div
        ;button(class "fund-butn-de-m {cas}", x-init "initTippy($el)"): {tyt}
        ;div(class "hidden")
          ;form(method "post", autocomplete "off", class "flex flex-col gap-y-2 p-2")
            ;*  fom
          ==
        ==
      ==
    ++  dash-navi
      |=  top=bean
      ^-  manx
      =/  bas=tape  ?:(top ~ "w-full")
      =/  kas=tape
        ?.  top  "flex-col drip-shadow-lg gap-3 fund-foot p-3"
        "flex-row justify-between rounded-lg drop-shadow-lg p-2"
      ;div
          =class  "w-full flex bg-palette-contrast {kas} {cas}"
          =x-show  "$store.page.size {(trip ?:(top '=' '!'))}= 'desktop'"
        ;*  =-  ;:  welp
                      :_  ~
                    ;div(class "flex flex-row items-center {(trip ?:(top 'gap-2' 'justify-between'))}")
                      ;*  mix
                    ==
                ::
                      ?~  act  ~
                    :_  ~  u.act
                ==
            ^-  [act=(unit manx) mix=marl]
            :-  ?.  live.pre
                  :-  ~
                  =/  pur=tape  :(welp ?~(pow ~ (trip ship-url.u.pow)) (flat:enrl:ff:fh lag) "/okay")
                  =/  nur=tape  (dest:enrl:ff:fh /next/(scot %p p.lag)/[q.lag]/exit)
                  ;div  =class  "flex flex-row items-center"
                      =x-data  "\{ status: undefined }"
                      =x-init  "queryPage('{pur}').then(p => \{status = !!p;})"
                    ;+  %.  [%x-show "status == true"]~
                        %~  joat  ma:fh
                        (~(link-butn ui:fh bas) nur %| "reconnect 🔌" ~)
                    ;+  %.  [%x-show "status == undefined"]~
                        %~  joat  ma:fh
                        (~(link-butn ui:fh bas) nur %| "reconnect 🔌" "Checking host for project…")
                    ;+  %.  [%x-show "status == false"]~
                        %~  joat  ma:fh
                        (~(link-butn ui:fh bas) nur %| "error ✗" "Failed to reach host.")
                  ==
                ?:  &(ora ?=(%prop sat) ?=(~ contract.pro))
                  :-  ~
                  %+  ~(tipi-form ..$ bas)  "sign off ✔️"
                  :~  ;h1: Review Request
                      ;p
                        ;span(class "font-mono font-bold"): {(scow %p p.lag)}
                        ;span:  has requested your services as a trusted oracle for this project.
                      ==
                      ;p
                        ;span(class "font-mono font-bold"): {(scow %p p.lag)}
                        ;span:  is offering the following compensation for your services:
                      ==
                      ;code
                        ;span(class "font-bold"): {(cash:enjs:ff:fh q.assessment.pro 6)}%
                        ;span:  of each milestone payout upon completed assessment
                      ==
                      ;p
                        ; Accepting this review request means that you will have the
                        ; responsibility to review each project milestone and release
                        ; funds to the project worker upon successful completion.
                      ==
                      ;p
                        ; If you pinky promise to assess this project, click the button
                        ; below to confirm your particpation.
                      ==
                      ;div(class "flex justify-end gap-x-2")
                        ;+  (prod-butn:ui:fh %medi %action %bump-born "decline ~" ~ ~)
                        ;+  (prod-butn:ui:fh %medi %true %bump-prop "accept ✓" "acceptContract" ~)
                      ==
                  ==
                ?:  &(wok ?=(%prop sat))
                  :-  ~
                  %-  ~(bare-form ..$ ~)
                  %:  ~(prod-butn ui:fh bas)
                      %medi  %true  %bump-lock  "launch ✔️"  "finalizeContract"
                      ?:(?=(^ contract.pro) ~ "Awaiting response from trusted oracle.")
                  ==
                ?.  ?=(?(%born %done %dead) sat)
                  =/  nft=?  ?=(%enft -.payment.pro)
                  =+  pej=(~(get by pledges.pro) src.bol)
                  :-  ~
                  %+  ~(tipi-form ..$ bas)  "contribute 💸"
                  :~  ;h1.text-nowrap: {?~(pej "Contribute" "Fulfill Pledge")}
                      ;div(class "fund-form-group")
                        ;+  :_  ~  :-  %input
                            ;:  welp
                                [%name "sum"]~
                                [%type "number"]~
                                [%required ~]~
                                [%min ?+(-.payment.pro "0.01" %enft "1")]~
                                [%max "100000000"]~
                                [%step ?+(-.payment.pro "0.01" %enft "1")]~
                                [%placeholder "10"]~
                                [%class "p-1"]~  ::  FIXME: Needed to match <select> sibling
                                  ?~  pej  ~
                                :~  [%readonly ~]
                                    [%value (comp:enjs:ff:fh cash.u.pej payment.pro)]
                                ==
                                ::  FIXME: Remove this after multi-send NFTs are supported
                                  ?.  nft  ~
                                :~  [%readonly ~]
                                    [%value "1"]
                                ==
                            ==
                        ;label(for "sum"): amount
                      ==
                      ;div(class "fund-form-group")
                        ;+  :_  ?:  nft  ~
                                :_  ~
                                ;option
                                    =value  (trip symbol.payment.pro)
                                    =data-image  (aset:enrl:ff:fh symbol.payment.pro)
                                  ; {(trip name.payment.pro)}
                                ==
                            :-  %select
                            ;:  welp
                                [%id "proj-token"]~
                                [%name "tok"]~
                                ?.(nft ~ [%multiple ~]~)
                                ?~(pej ~ ?:(nft [%required ~]~ [%disabled ~]~))
                                ['@fund-wallet.window' "$el?.tomselect?.load && $el.tomselect.load()"]~
                                :_  ~  :-  %x-init
                                %-  zing  %+  join  "\0a"
                                ^-  (list tape)
                                :~  :(weld "const isNFT = " (bool:enjs:ff:fh nft) ";")
                                    :(weld "const maxItems = " (bloq:enjs:ff:fh ?~(pej 0 cash.u.pej)) ";")
                                    ^-  tape  ^~
                                    %+  rip  3
                                    '''
                                    if (typeof initTomSelect !== 'undefined') {
                                      if (!!$el?.tomselect) {
                                        $el?.tomselect?.load && $el.tomselect.load();
                                      } else {
                                        initTomSelect($el, {
                                          empty: isNFT,
                                          maxItems: !isNFT ? undefined : 1, // maxItems,
                                          load: !isNFT ? undefined : tsLoadNFTs($el),
                                        });
                                      }
                                    }
                                    '''
                                ==
                            ==
                        ;label(for "tok"): token
                      ==
                      ;div(class "fund-form-group")
                        ;input(name "msg", type "text", placeholder "awesome work!");
                        ;label(for "msg"): public message
                      ==
                      ;div(class "flex justify-end pt-2 gap-x-2")
                        ;+  %:  prod-butn:ui:fh
                                %medi  %action  %mula-plej  "pledge only ~"  "plejFunds"
                                ?.  &((auth:fh bol) (plan:fx src.bol))
                                  "Pledges only available to authenticated planets."
                                ?:  (~(has by pledges.pro) src.bol)
                                  "You must fulfill your outstanding pledge."
                                ~
                            ==
                        ;+  (prod-butn:ui:fh %medi %true %mula-trib "send funds ✓" "sendFunds" ~)
                  ==  ==
                ~
            ;:    welp
            ::  explain button  ::
              :~  %.  sos
                  %~  hoal  ma:fh
                  ;button(type "button", x-init "initTippy($el, \{hover: true})")
                    ;img.fund-butn-icon@"{(aset:enrl:ff:fh %help)}";
                  ==
                  ;div(class "hidden")
                    ;p
                      ;code: %fund
                      ;span:  allows funders to pledge and fulfill contributions,
                      ;span:  and trusted oracles to approve payouts to project workers.
                      ;span:  Here are a few things you should know:
                    ==
                    ;ul
                      ;li
                        ;span.font-bold: Pledges:
                        ;span:  Promises to a project worker to complete
                        ;span:  a fulfillment transaction at a later date, backed by
                        ;span:  your Urbit ID and personal reputation.
                      ==
                      ;li
                        ;span.font-bold: Contributions:
                        ;span:  Crypto transactions into an escrow
                        ;span:  contract, held either until a milestone is approved
                        ;span:  by the trusted oracle, or the project is canceled
                        ;span:  and crypto refunded to funders.
                      ==
                      ;li
                        ;span.font-bold: Payouts:
                        ;span:  Crypto withdrawals by project workers are
                        ;span:  only allowed once the trusted oracle reviews the
                        ;span:  milestone and provides an approval signature using
                        ;span:  their cryptographic keys.
                      ==
                    ==
                    ;p
                      ; To learn more,
                      ;a.text-link/"{(trip !<(@t (slot:config %meta-help)))}"(target "_blank")
                        ; read the docs.
                      ==
                    ==
                  ==
              ==
            ::  cancel button  ::
                ?.  &(tym ?=(?(%lock %work %sess) sat))  ~
              :_  ~
              %-  ~(bare-form ..$ ~)
              (prod-butn:ui:fh %medi %false %bump-dead "cancel ❌" "cancelContract" ~)
            ::  edit button  ::
                ?.  &(wok ?=(?(%born %prop) sat))  ~
              :_  ~
              %.  sos
              %~  hoal  ma:fh
              (edit-butn:ui:fh lag)
            ::  bookmark button  ::
              ?:  ?|  ?=(?(%born %prop) sat)
                      !(auth:fh bol)
                      =(our src):bol
                      (~(has in roz) %fund)
                  ==
                ~
              :_  ~
              %-  ~(bare-form ..$ "flex flex-row items-center")
              %.  sos
              %~  hoal  ma:fh
              ;button#prod-butn-folo-proj(type "submit", name "dif", value "folo-proj")
                ;img.fund-butn-icon@"{(aset:enrl:ff:fh %bookmark)}";
              ==
            ::  publicize button  ::
                ?:  ?|  !=(our src):bol
                        ?=(?(%born %prop) sat)
                        ?~  pow  &
                        ?.  |(wok (~(has in favorites.u.pow) lag))  &
                        ?~  pou  &
                        (~(has in favorites.u.pou) lag)
                    ==
                ~
              :~  %.  sos
                  %~  hoal  ma:fh
                  ;button(type "button", x-init "initTippy($el)")
                    ;img.fund-butn-icon@"{(aset:enrl:ff:fh %publicize)}";
                  ==
                  ;div(class "hidden")
                    ;form(method "post", class "flex flex-col gap-y-2 p-2")
                      ;h1: Publicize?
                      ;p
                        ; Currently your project is unlisted and can only be
                        ; discovered by its clearweb url. By choosing publicize,
                        ; it will be shared across the urbit network and discoverable
                        ; by anyone with the
                        ;code: %fund
                        ;span:  application.
                        ;span.font-bold: This action is irreversible, choose wisely.
                      ==
                      ;div(class "flex justify-end pt-2 gap-x-2")
                        ;+  (prod-butn:ui:fh %medi %true %fave-proj "publicize ✓" ~ ~)
                      ==
                    ==
                  ==
              ==
            ::  share button  ::
                ?:  |(?=(%born sat) ?=(~ pow))  ~
              :_  ~
              %.  sos
              %~  hoal  ma:fh
              (pink-butn:ui:fh lag (trip ship-url.u.pow))
            ::  contract link button  ::
                ?:  ?=(?(%born %prop) sat)  ~
              :_  ~
              %.  sos
              %~  hoal  ma:fh
              ;a/"{(esat:enrl:ff:fh %addr safe:(need contract.pro) chain.payment.pro)}"(target "_blank")
                ;img.fund-butn-icon@"{(aset:enrl:ff:fh %etherscan)}";
              ==
            ==
      ==
    --
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  (trip title.pro)
  :+  fut=&  hed=|
  ;div(x-data "proj_view")
    ;+  (head:ui:fh bol ord [(~(dash-navi ui ~) top=&)]~)
    ::  NOTE: Using another trick to always push footer to the bottom
    ::  https://stackoverflow.com/a/59865099
    ;div(class "flex flex-col gap-3 px-2 py-2 sm:px-5 min-h-[100vh]")
      ;h1(class "fund-title"): {(trip title.pro)}
      ;div.relative.w-full
        ;img.w-full@"{(trip ?^(image.pro u.image.pro (crip (~(ship-logo fa bol) p.lag))))}";
        ;div.absolute.top-4.right-4
          ;+  %+  ~(work-bump ui:fh "p-2 fund-card-fore")  sat
              ;span: {(swam:enjs:ff:fh cost.pod payment.pro)}
        ==
      ==
      ;div(class "flex flex-col gap-2")
        ;div(class "flex flex-row justify-between items-center")
          ;h1-alt: Funding Tracker
          ;div(class "flex flex-wrap gap-1 items-center")
            ;h6(class "inline-flex gap-1 leading-none tracking-widest")
              ;span(class "hidden sm:block"): Funded
              ;span: via
            ==
            ;+  %+  icon-stax:ui:fh  %circ
                :~  (aset:enrl:ff:fh symbol.payment.pro)
                    (aset:enrl:ff:fh tag:(~(got by xmap:fc) chain.payment.pro))
                ==
          ==
        ==
        ;+  (proj-ther:ui:fh pro big=&)
      ==
      ;div(class "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-8 gap-y-3")
        ;div(class "sm:col-span-1 lg:col-span-2 flex flex-col gap-3")
          ;div(class "flex flex-col gap-2")
            ;h1-alt: Project Overview
            ;+  (mark-well:ui:fh (trip summary.pro) %togl)
          ==
          ;div(class "flex flex-col gap-2")
            ;h1-alt: Milestone Details
            ;*  %+  turn  (enum:fx `(list mile:f)`milestones.pro)
                |=  [min=@ mil=mile:f]
                ^-  manx
                =/  oil=odit:f  (snag min moz)
                =/  oas=tape  ?:(?=(?(%done %dead) status.mil) "fund-card-back" "fund-card-fore")
                ;form  =id  "fund-mile-{<min>}"  =method  "post"
                    =x-data  "\{ mile_idex: {<min>} }"
                    =class  "{oas} flex flex-col gap-2 lg:(px-4 py-4)"
                  ;h6: Milestone {<+(min)>}
                  ;div(class "flex items-start justify-between flex-wrap lg:flex-nowrap")
                    ;h1(class "fund-title shrink"): {(trip title.mil)}
                    ;div  =x-init  "initTippy($el, \{hover: true, dir: 'bottom'})"
                        =class  "w-full lg:w-min flex flex-col gap-2 p-1 rounded-md hover:cursor-pointer"
                      ;+  %+  ~(work-bump ui:fh "w-full justify-between lg:w-min")  status.mil
                          ;span: {(swam:enjs:ff:fh cost.mil payment.pro)}
                      ;+  (mile-ther:ui:fh oil ~ big=|)
                    ==
                    ;div(class "hidden")
                      ;span.font-bold: {(swam:enjs:ff:fh fill.oil payment.pro)}
                      ;span:  contributed /
                      ;span.font-bold:  {(swam:enjs:ff:fh plej.oil payment.pro)}
                      ;span:  pledged
                    ==
                  ==
                  ;+  (mark-well:ui:fh (trip summary.mil) %togl)
                  ;*  =-  ?~  buz  ~
                          :_  ~
                          ;div(class "flex flex-wrap items-center justify-end gap-2")
                            ;*  buz
                          ==
                      ^-  buz=marl
                      =+  [cur==(min nin) las==(+(min) nin) dun=(lth min nin)]
                      ;:    welp
                          ?.  &(cur wok ?=(%lock status.mil))  ~
                        :_  ~  (prod-butn:ui:fh %medi %action %bump-work "mark in-progress ~" ~ ~)
                      ::
                          ?.  &(cur wok ?=(%work status.mil))  ~
                        :_  ~  (prod-butn:ui:fh %medi %action %bump-sess "request review ~" ~ ~)
                      ::
                          ?.  &(cur ora ?=(%sess status.mil))  ~
                        :~  ;a.fund-butn-de-m/"{(chat:enrl:ff:fh p.lag)}"(target "_blank"): message worker →
                            (prod-butn:ui:fh %medi %action %bump-work "changes required ~" ~ ~)
                            (prod-butn:ui:fh %medi %true %bump-done "approve ✓" "approveMilestone" ~)
                        ==
                      ::
                      ::
                          ?.  &(dun ora ?=(%done status.mil) ?=(~ withdrawal.mil))  ~
                        :~  ;a.fund-butn-de-m/"{(chat:enrl:ff:fh p.lag)}"(target "_blank"): message worker →
                            (prod-butn:ui:fh %medi %true %wipe-casi "reapprove ✓" "approveMilestone" ~)
                        ==
                      ::
                          ?.  &(dun tym ?=(%done status.mil) ?=(^ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))  ~
                        :_  ~  (prod-butn:ui:fh %medi %false %wipe-cade "clear approval ✗" "clearMilestone" ~)
                      ::
                          ?.  &(dun wok ?=(%done status.mil) ?=(^ withdrawal.mil))  ~
                        :_  ~
                        %:  prod-butn:ui:fh
                            %medi  %true  %draw-done  "claim funds ✓"  "claimMilestone"
                            ?^  xact.u.withdrawal.mil
                              ?:  ?&  !=(0x0 q.u.xact.u.withdrawal.mil)
                                      ?=(~ pruf.u.withdrawal.mil)
                                  ==
                                "Funds claimed but awaiting confirmation."
                              "Funds have already been fully claimed."
                            ::  NOTE: A `pruf` without an `xact` is an impossible case
                            ~
                        ==
                      ::
                      ::
                          ?.  &(las pyr ?=(%dead status.mil) ?=(~ withdrawal.mil))  ~
                        :_  ~  (prod-butn:ui:fh %medi %true %wipe-resi "sign refund ~" "cancelContract" ~)
                      ::
                          ?.  &(las pyr ?=(%dead status.mil) ?=(^ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))  ~
                        :_  ~  (prod-butn:ui:fh %medi %false %wipe-rede "clear approval ✗" "clearMilestone" ~)
                      ::
                          ?.  &(las pyr ?=(%dead status.mil) ?=(^ withdrawal.mil))  ~
                        :_  ~
                        %:  prod-butn:ui:fh
                            %medi  %true  %draw-dead  "refund funds ✓"  "refundContract"
                            ?^  xact.u.withdrawal.mil
                              ?:  ?&  !=(0x0 q.u.xact.u.withdrawal.mil)
                                      ?=(~ pruf.u.withdrawal.mil)
                                  ==
                                "Funds refunded but awaiting confirmation."
                              "Funds have already been fully refunded."
                            ::  NOTE: A `pruf` without an `xact` is an impossible case
                            ~
                        ==
                      ==
                ==
          ==
        ==
        ;div(class "col-span-1 flex flex-col gap-3")
          ;div(class "flex flex-col gap-2")
            ;h1-alt(class "sm:hidden"): Participants
            ;+  %:  ship-card:ui:fh
                    p.lag  bol  %work
                    chain.payment.pro  ?~(contract.pro 0x0 work.u.contract.pro)
                ==
            ;+  %:  ship-card:ui:fh
                    p.assessment.pro  bol  %orac
                    chain.payment.pro  ?~(contract.pro 0x0 from.sigm.u.contract.pro)
                ==
          ==
          ;div(class "flex flex-col gap-2")
            ;div(class "flex flex-row justify-between items-center")
              ;h1-alt: Funders
              ;div(class "flex flex-wrap items-center gap-1")
                ;*  =-  :~  (icon-stax:ui:fh %rect (scag 3 (turn ~(tap in siz) surt:enrl:ff:fh)))
                            ;h6: {<~(wyt in siz)>} total
                        ==
                    ^-  siz=(set @p)
                    %+  roll  muz
                    |=  [mul=mula:f siz=(set @p)]
                    =/  sip=(unit @p)  ?-(-.mul %plej `ship.mul, %trib ship.mul, %pruf ~)
                    ?~(sip siz (~(put in siz) u.sip))
              ==
            ==
            ;*  ?~  muz  :_  ~  ;p(class "fund-warn"): No contributors found.
                %+  turn  muz
                |=  mul=mula:f
                ^-  manx
                =/  myp=tape  (trip -.mul)
                =/  mas=tape  ?:(&(?=(%pruf -.mul) ?=(%with note.mul)) "fund-card-back" "fund-card-fore")
                =/  muf=tape  ?+(-.mul (addr:enjs:ff:fh from.when.mul) %plej ~)
                =/  mid=tape  ?+(-.mul (addr:enjs:ff:fh q.xact.when.mul) %plej (ship:enjs:ff:fh ship.mul))
                =/  mow=bean
                  ?-  -.mul
                    %plej  =<(show (~(got by pledges.pro) ship.mul))
                    %trib  =<(show (~(got by contribs.pro) q.xact.when.mul))
                    %pruf  &
                  ==
                ;div
                    =x-data  "\{ mula_type: '{myp}', mula_idex: '{mid}', mula_from: '{muf}' }"
                    =class   "flex flex-col gap-y-2 {mas}"
                  ;div(class "flex items-center justify-between")
                    ;div(class "shrink flex inline-flex items-center gap-2 overflow-hidden")
                      ;*  |^  ?-  -.mul
                                %plej  (ship-bump ship.mul)
                              ::
                                  ?(%trib %pruf)
                                ?^  ship.mul  (ship-bump u.ship.mul)
                                %+  addr-bump  from.when.mul
                                ?-(-.mul %trib (colt:enrl:ff:fh %black), %pruf (aset:enrl:ff:fh %link))
                              ==
                          ++  ship-bump
                            |=  sip=ship
                            ^-  marl
                            :-  (ship-logo:ui:fh sip bol)
                            :_  ~
                            %.  [(ship-tytl:ui:fh sip bol)]~
                            %~  rech  ma:fh
                            %-  ~(link-text ui:fh "fund-clip")
                            [wer=(chat:enrl:ff:fh sip) tab=& txt="~" diz=~]
                          ++  addr-bump
                            |=  [adr=addr:f lur=tape]
                            ^-  marl
                            :-  (icon-logo:ui:fh %rect lur)
                            :_  ~
                            %.  [%x-init "initENS($el, '{(addr:enjs:ff:fh adr)}')"]~
                            %~  joat  ma:fh
                            %:  ~(link-text ui:fh "fund-addr fund-clip")
                                wer=(esat:enrl:ff:fh %addr adr chain.payment.pro)
                                tab=&
                                txt=(sadr:enjs:ff:fh adr)
                                diz=~
                            ==
                          --
                    ==
                    ;div(class "flex inline-flex items-center gap-2")
                      ;+  =/  tur=tape
                            ?+(-.mul (esat:enrl:ff:fh %xact q.xact.when.mul chain.payment.pro) %plej ~)
                          =/  txt=tape  (swam:enjs:ff:fh cash.mul payment.pro)
                          (~(link-text ui:fh "font-serif") tur & txt ~)
                      ;+  =-  ;div(class kas): {tyt}
                          ^-  [tyt=tape kas=tape]
                          ?-    -.mul
                              %plej
                            =+  pej=(~(got by pledges.pro) ship.mul)
                            ?-  view.pej
                              ~          ["pledged" "fund-pill-bo-m"]
                              [~ %stif]  ["welched" "fund-pill-de-m"]
                              [~ %slyd]  ["forgiven" "fund-pill-de-m"]
                            ==
                          ::
                              %trib
                            =+  teb=-:(~(got by contribs.pro) q.xact.when.mul)
                            ?~  pruf.teb  ["attested" "fund-pill-lo-m"]
                            =-  ["{-}verified" "fund-pill-do-m"]
                            ?~  ship.teb  ~
                            =-  ?~(- ~ "✔ ")
                            .^  pro=(unit sigm:f)
                                %gx  (scot %p our.bol)  dap.bol  (scot %da now.bol)
                                /prof/(scot %p u.ship.teb)/addr/(scot %ux from.when.teb)/noun
                            ==
                          ::
                              %pruf
                            ?-  note.mul
                              %depo  ["deposited" "fund-pill-lo-m"]
                              %with  ["withdrawn" "fund-pill-de-m"]
                            ==
                          ==
                    ==
                  ==
                  ;div(class "flex flex-col gap-2")
                    ;+  =/  msg=@t
                          ?-  -.mul
                            %pruf  %$
                            %plej  note.mul
                          ::
                              %trib
                            =+  teb=-:(~(got by contribs.pro) q.xact.when.mul)
                            ?.(=(%$ note.teb) note.teb ?~(plej.teb %$ note.u.plej.teb))
                          ==
                        ?.  mow
                          ;p(class "fund-warn"): Message hidden by administrator.
                        ?:  =(%$ msg)
                          ;p(class "fund-warn"): No message included.
                        ;p(class "leading-normal tracking-wide"): {(trip msg)}
                  ==
                  ;*  =-  ?~  buz  ~
                          :_  ~
                          ;div(class "flex flex-row justify-end gap-2 items-center")
                            ;*  buz
                          ==
                      ^-  buz=marl
                      ;:    welp
                      ::  chain data claim button  ::
                          ?.  ?&  (auth:fh bol)
                                  ?=(%pruf -.mul)
                                  ?=(%depo note.mul)
                                  !?=(?(%done %dead) sat)
                              ==
                          ~
                        :_  ~
                        ;form  =method  "post"
                            =x-show  "($store.wallet.address ?? '').toLowerCase() == mula_from"
                          ;+  (prod-butn:ui:fh %medi %action %mula-mine "claim transaction ~" "editMula" ~)
                        ==
                      ::  pledge edit view button  ::
                          ?.  ?&  pyr
                                  ?=(%plej -.mul)
                                    =+  pej=(~(got by pledges.pro) ship.mul)
                                  ?=(^ view.pej)
                              ==
                          ~
                        :_  ~
                        ;form(method "post")
                          ;+  (prod-butn:ui:fh %medi %action %mula-view "toggle status ~" "editMula" ~)
                        ==
                      ::  attested redo button  ::
                          ?.  ?&  pyr
                                  ?=(%trib -.mul)
                                    =+  teb=(~(got by contribs.pro) q.xact.when.mul)
                                  ?=(~ pruf.teb)
                              ==
                            ~
                        :_  ~
                        ;form(method "post")
                          ;+  (prod-butn:ui:fh %medi %action %mula-redo "query chain ~" "editMula" ~)
                        ==
                      ::  mula blot button  ::
                          ?.  &(pyr !?=(%pruf -.mul))  ~
                        :_  ~
                        ;form(method "post")
                          ;+  (prod-butn:ui:fh %medi %action %mula-blot "toggle shown ~" "editMula" ~)
                        ==
                      ==
                ==
          ==
        ==
      ==
    ==
    ;+  (~(dash-navi ui ~) top=|)
    ;div.hidden
      ::  FIXME: We use inline HTML instead of inline JS in order to
      ::  circumvent the need for text escaping (e.g. ', ", and `).
      ;data#fund-proj-oath(value (~(oath pj:f pro) p.lag));
      ;data#fund-proj-bane(value (~(bail pj:f pro) 1 %done));
      ;data#fund-proj-baad(value (~(bail pj:f pro) 1 %dead));
      ::  FIXME: These fields are embedded on the page so that they can
      ::  be used to inform page metadata
      ;data#fund-meta-desc(value (trip summary.pro));
      ;data#fund-meta-flag(value (flag:enjs:ff:fh lag));
      ;*  ?~  image.pro  ~
          :_  ~  ;data#fund-meta-logo(value (trip u.image.pro));
    ==
    ;script
      ;+  ;/
      ::  FIXME: Hack to reduce build times and fix build stack overflows
      ::  on some ships
      %-  zing  %+  join  "\0a"
      ^-  (list tape)
      :~  "document.addEventListener('alpine:init', () => Alpine.data('proj_view', () => (\{"
          :(weld "safe_addr: '" (addr:enjs:ff:fh ?~(contract.pro 0x0 safe.u.contract.pro)) "',")
          :(weld "safe_bloq: " (bloq:enjs:ff:fh ?~(contract.pro 0 p.xact.u.contract.pro)) ",")
          :(weld "work_addr: '" (addr:enjs:ff:fh ?~(contract.pro 0x0 work.u.contract.pro)) "',")
          :(weld "orac_addr: '" (addr:enjs:ff:fh ?~(contract.pro 0x0 from.sigm.u.contract.pro)) "',")
          :(weld "swap_type: '" (trip -.payment.pro) "',")
          :(weld "swap_chain: " (bloq:enjs:ff:fh chain.payment.pro) ",")
          :(weld "swap_symbol: '" (trip symbol.payment.pro) "',")
          :(weld "swap_address: '" (trip addr.payment.pro) "',")
          :(weld "orac_cut: " (cash:enjs:ff:fh q.assessment.pro 6) ",")
          :(weld "mile_fill: [" (roll moz |=([n=odit:f a=tape] :(weld a (comp:enjs:ff:fh fill.n payment.pro) ","))) "],")
          :(weld "mile_whom: [" (roll `(list mile:f)`milestones.pro |=([n=mile:f a=tape] :(weld a "'" (addr:enjs:ff:fh ?~(withdrawal.n *@ux from.sigm.u.withdrawal.n)) "',"))) "],")
          :(weld "mile_sign: [" (roll `(list mile:f)`milestones.pro |=([n=mile:f a=tape] :(weld a "'" (sign:enjs:ff:fh ?~(withdrawal.n *@ux sign.sigm.u.withdrawal.n)) "',"))) "],")
          :(weld "mile_take: [" (roll `(list mile:f)`milestones.pro |=([n=mile:f a=tape] :(weld a (comp:enjs:ff:fh ?~(withdrawal.n *cash:f cash.u.withdrawal.n) payment.pro) ","))) "],")
          ^-  tape  ^~
          %+  rip  3
          '''
          init() {
            Alpine.store("project").update(this.swap_type, this.swap_symbol);
          },
          acceptContract(event) {
            this.sendForm(event, [], () => (
              this.safeSignDeploy({
                projectChain: this.swap_chain,
                projectContent: document.querySelector('#fund-proj-oath').value,
              }).then(([address, signature]) => ({
                oas: signature,
                oaa: address,
              }))
            ));
          },
          finalizeContract(event) {
            this.sendForm(event, [], () => (
              this.safeExecDeploy({
                projectChain: this.swap_chain,
                oracleAddress: this.orac_addr,
              }).then(([xblock, xhash, workerAddress, oracleAddress, safeAddress]) => {
                console.log(`safe creation successful; view at: ${this.safeGetURL(safeAddress)}`);
                return {
                  sxb: xblock,
                  sxa: xhash,
                  swa: workerAddress,
                  soa: oracleAddress,
                  ssa: safeAddress,
                };
              })
            ));
          },
          plejFunds(event) {
            this.sendForm(event, [], () => (
              this.safeGetBlock().then((block) => ({mxb: block}))
            ));
          },
          sendFunds(event) {
            this.sendForm(event, [], () => (
              this.safeExecDeposit({
                projectChain: this.swap_chain,
                safeAddress: this.safe_addr,
                fundAmount: event.target.form.querySelector('[name=sum]').value,
                fundToken: this.swap_symbol,
                fundTransfers: Array.from(
                  event.target.form.querySelector('[name=tok]').selectedOptions
                ).map(v => v.value),
              }).then(([address, xblock, xhash]) => {
                console.log(`contribution successful; view at: ${this.txnGetURL(xhash)}`);
                return {
                  mad: address,
                  mxb: xblock,
                  mxa: xhash,
                };
              })
            ));
          },
          approveMilestone(event) {
            this.sendForm(event, [() => this.checkWallet([this.orac_addr], 'oracle')], () => {
              if (this.mile_fill[this.mile_idex] === 0) {
                const payload = document.querySelector('#fund-proj-bane').value
                  .replace(/milestone \d+/, `milestone ${this.mile_idex + 1}`);
                return this.safeSignDeploy({
                  projectChain: this.swap_chain,
                  projectContent: payload,
                }).then(([address, signature]) => ({
                  mii: this.mile_idex,
                  mia: address,
                  mis: signature,
                  mit: payload,
                  mie: true,
                }));
              } else {
                return this.safeSignClaim({
                  projectChain: this.swap_chain,
                  safeAddress: this.safe_addr,
                  workerAddress: this.work_addr,
                  oracleCut: this.orac_cut,
                  fundAmount: this.mile_fill[this.mile_idex],
                  fundToken: this.swap_symbol,
                  safeInitBlock: this.safe_bloq,
                }).then(([address, signature, payload]) => ({
                  mii: this.mile_idex,
                  mia: address,
                  mis: signature,
                  mit: payload,
                  mie: false,
                }));
              }
            });
          },
          clearMilestone(event) {
            this.sendForm(event, [], () => (
              Promise.resolve({mii: this.mile_idex})
            ));
          },
          claimMilestone(event) {
            this.sendForm(event, [() => this.checkWallet([this.work_addr], 'worker')], () => {
              if (this.mile_take[this.mile_idex] === 0) {
                return this.safeGetBlock().then((block) => ({
                  mii: this.mile_idex,
                  mib: block,
                  mih: "0x0",
                }));
              } else {
                return this.safeExecClaim({
                  projectChain: this.swap_chain,
                  safeAddress: this.safe_addr,
                  fundAmount: this.mile_take[this.mile_idex],
                  fundToken: this.swap_symbol,
                  oracleSignature: this.mile_sign[this.mile_idex],
                  oracleAddress: this.orac_addr,
                  oracleCut: this.orac_cut,
                  safeInitBlock: this.safe_bloq,
                }).then(([xblock, xhash]) => {
                  console.log(`claim successful; view at: ${this.txnGetURL(xhash)}`);
                  return {
                    mii: this.mile_idex,
                    mib: xblock,
                    mih: xhash,
                  };
                });
              }
            });
          },
          cancelContract(event) {
            this.sendForm(event,
              [() => this.checkWallet([this.work_addr, this.orac_addr], 'worker/oracle')],
              () => {
                return this.safeGetBalance({
                  fundToken: this.swap_symbol,
                  safeAddress: this.safe_addr,
                }).then((balance) => {
                  if (balance === 0) {
                    const payload = document.querySelector('#fund-proj-baad').value;
                    return this.safeSignDeploy({
                      projectChain: this.swap_chain,
                      projectContent: payload,
                    }).then(([address, signature]) => ({
                      des: signature,
                      dea: address,
                      det: payload,
                      dee: true,
                    }));
                  } else {
                    return this.safeSignRefund({
                      projectChain: this.swap_chain,
                      fundToken: this.swap_symbol,
                      safeAddress: this.safe_addr,
                      safeInitBlock: this.safe_bloq,
                    }).then(([address, signature, payload]) => ({
                      des: signature,
                      dea: address,
                      det: payload,
                      dee: false,
                    }));
                  }
                });
              }
            );
          },
          refundContract(event) {
            this.sendForm(event,
              // FIXME: Should disallow the prior signer, i.e. `this.mile_whom[this.mile_idex]`
              [() => this.checkWallet([this.work_addr, this.orac_addr], 'worker/oracle')],
              () => {
                return this.safeGetBalance({
                  fundToken: this.swap_symbol,
                  safeAddress: this.safe_addr,
                }).then((balance) => {
                  if (balance === 0) {
                    return this.safeGetBlock().then((block) => ({
                      mib: block,
                      mih: "0x0",
                    }));
                  } else {
                    return this.safeExecRefund({
                      projectChain: this.swap_chain,
                      fundToken: this.swap_symbol,
                      safeAddress: this.safe_addr,
                      safeInitBlock: this.safe_bloq,
                      oracleAddress: this.mile_whom[this.mile_idex],
                      oracleSignature: this.mile_sign[this.mile_idex],
                    }).then(([xblock, xhash]) => {
                      console.log(`refund successful; view at: ${this.txnGetURL(xhash)}`);
                      return {
                        mib: xblock,
                        mih: xhash,
                      };
                    });
                  }
                });
              }
            );
          },
          editMula(event) {
            this.sendForm(event, [], () => (
              Promise.resolve({mut: this.mula_type, mui: this.mula_idex})
            ));
          },
          })));
          '''
      ==
    ==
  ==
--
::  VERSION: [1 4 5]
