::  /web/fund/page/proj-edit/hoon: render project edit page for %fund
::
/-  fd=fund-data
/+  f=fund-proj, fh=fund-http, fc=fund-chain, fx=fund-xtra
/+  rudder, config
%-  :(corl dump:preface:fh mine:preface:fh init:preface:fh (proj:preface:fh |))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  =>  |%
      ++  trim                                 ::  remove trailing whitespace and \r
        |=  cor=@t
        ^-  @t
        %-  crip  %-  flop
        %-  skip  :_  |=(c=@t =('\0d' c))
        %+  scan  (flop (trip cor))
        ;~(pfix (star (mask " \0a\0d\09")) (star next))
      ++  pars                                 ::  parse real number
        |=  [cor=@t swa=swap:f]
        ^-  (unit cash:f)
        ?-  val=(mule |.((comp:dejs:ff:fh cor swa)))
          [%| *]  ~
          [%& *]  `+.val
        ==
      --
  =/  [lau=(unit flag:f) pru=(unit prej:f)]  (grab:proj:preface:fh hed)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ::  FIXME: Go to next available name if this path is already taken
    ::  by another project (add random number suffix)
    =/  lag=flag:f  ?^(lau u.lau [our.bol (asci:fx (~(got by p.arz) %nam))])
    =-  ?@(- - [%proj lag -])
    ^-  $@(@t prod:f)
    ?+    dif=(~(got by p.arz) %dif)
        (crip "bad dif; expected (init|drop|bump-*), not {(trip dif)}")
      %drop       [%drop ~]
      %bump-born  ?~(pru 'project does not exist' [%bump %born ~])
    ::
        %init
      ?+  arz=(parz:fh bod (sy ~[%nam %sum %pic %can %tok %sea %seo %m0n %m0s %m0c]))  p.arz  [%| *]
        :-  %init
        =/  swa=swap:f
          %+  ~(got by smap:fc)
            (bloq:dejs:ff:fh (~(got by p.arz) %can))
          (~(got by p.arz) %tok)
        =+  pro=*proj:f  %_  pro
          title      (~(got by p.arz) %nam)
          summary    (trim (~(got by p.arz) %sum))
          payment    swa
        ::
            assessment
          :-  (fall (slaw %p (~(got by p.arz) %sea)) !<(@p (slot:config %point)))
          %+  fall  (pars (~(got by p.arz) %seo) [%coin 1 0x0 '' '' 6])
          ?-(-.swa %coin 1.000.000, %enft 0, %chip 0)
        ::
            image
          =+  pic=(~(got by p.arz) %pic)
          ?~((rush pic auri:de-purl:html) ~ `pic)
        ::
            milestones
          ;;  (lest mile:f)
          =/  ind=@              0
          =/  miz=(list mile:f)  ~
          |-  ::  while m<i>n is a valid argument, add [m<i>n m<i>s m<i>c] to list
          ?~  nam=(~(get by p.arz) (crip "m{<ind>}n"))  (flop miz)
          =-  $(ind +(ind), miz [- miz])
          =+  mil=*mile:f  %_  mil
            title    u.nam
            summary  (trim (~(gut by p.arz) (crip "m{<ind>}s") ''))
            cost     (fall (pars (~(gut by p.arz) (crip "m{<ind>}c") '') swa) 0)
          ==
        ==
      ==
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  =/  [dyp=@tas lag=flag:f pyp=@tas]  (gref:proj:preface:fh txt)
  ?:  =(%drop pyp)  [%next (desc:enrl:ff:fh /dashboard/worker) ~]
  [%next (desc:enrl:ff:fh /next/(scot %p p.lag)/[q.lag]/edit) ~]
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [lau=(unit flag:f) pru=(unit prej:f)]  (grab:proj:preface:fh arz)
  =/  sat=stat:f  ?~(pru %born ~(stat pj:f -.u.pru))
  ?:  &(?=(^ lau) ?=(~ pru))
    [%code 404 'project does not exist']
  ?.  |(?=(~ pru) ?=(?(%born %prop) sat))
    [%next (flac:enrl:ff:fh (need lau)) 'project cannot be edited after locking']
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "project edit"
  :+  fut=&  hed=&
  ;form  =x-data  "proj_edit"
      =method  "post"
      =autocomplete  "off"
      =class  "flex flex-col gap-2 px-2 py-2 sm:px-5"
    ;+  :-  [%fieldset [%class "flex flex-col gap-2"] ?:(=(%born sat) ~ [%disabled ~]~)]
        :~  ;div(class "flex flex-col gap-2")
              ;*  ?~  lau  ~
                  :_  ~  ;a/"{(flat:enrl:ff:fh u.lau)}"(class "w-fit hover:text-link"): ← back
              ;+  %^  work-tytl:ui:fh  "Project Overview"  sat
                  ;span(x-text "proj_cost");
              ;div
                ;div(class "grid grid-cols-1 sm:grid-cols-2")
                  ;div(class "fund-form-group col-span-1")
                    ;input.p-1  =name  "nam"  =type  "text"  =required  ~
                      =placeholder  "My Awesome Project"
                      =value  (trip ?~(pru '' title.u.pru));
                    ;label(for "nam"): Project Name
                  ==
                  ;div(class "fund-form-group col-span-1")
                    ;input.p-1  =name  "pic"  =type  "url"
                      =placeholder  "https://example.com/example.png"
                      =value  (trip (fall ?~(pru ~ image.u.pru) ''));
                    ;label(for "pic")
                      ; Header Image URL
                      ;span.text-xs: (Default: Urbit Sigil)
                    ==
                  ==
                ==
                ;+  %:  ~(swap-selz ui:fh "grid grid-cols-1 sm:grid-cols-2")
                        0
                        |
                        `?~(pru *swap:f payment.u.pru)
                        "proj_stok"
                        "updateProj"
                    ==
                ;div(class "fund-form-group")
                  ;div(class "grow-wrap")
                    ;textarea.p-1  =name  "sum"  =rows  "3"
                      =placeholder  "Describe your project in detail. Plaintext and markdown inputs both supported."
                      =value  (trip ?~(pru '' summary.u.pru))
                      =x-on-input  "updateTextarea"
                      ; {(trip ?~(pru '' summary.u.pru))}
                    ==
                  ==
                  ;label(for "sum"): Project Description
                ==
              ==
            ==
            ;div(class "flex flex-col gap-2")
              ;h1: Milestones
              ;div#milz-well(class "flex flex-col gap-4")
                ;*  =+  pay=?~(pru (~(got by smap:fc) %ethereum 'USDC') payment.u.pru)
                    %+  turn  (enum:fx `(list mile:f)`?~(pru *(lest mile:f) milestones.u.pru))
                    |=  [min=@ mil=mile:f]
                    ^-  manx
                    ;div(id "mile-{<min>}", class "fund-card-fore rounded-xl px-4 py-4")
                      ;div(class "flex flex-wrap items-center justify-between")
                        ;h6: Milestone {<+(min)>}
                        ;+  ?:  ?=(%born status.mil)
                              ::  FIXME: Using the X SVG causes a weird pop-in effect
                              ::  for new milestones, so we just use raw text for now
                              ;button(class "font-light", type "button", x-on-click "deleteMile"): ✖
                            (stat-pill:ui:fh %medi status.mil)
                      ==
                      ;div(class "grid grid-cols-1 sm:grid-cols-2")
                        ;div(class "fund-form-group col-span-1")
                          ;input.p-1  =name  "m{<min>}n"  =type  "text"
                            =placeholder  "Give your milestone a title"
                            =value  (trip title.mil);
                          ;label(for "m{<min>}n"): Title
                        ==
                        ;div(class "fund-form-group col-span-1")
                          ;input.p-1  =name  "m{<min>}c"  =type  "number"
                            =min  "0"  =max  "100000000"
                            =placeholder  "0"
                            =value  ?:(=(0 cost.mil) "" (comp:enjs:ff:fh cost.mil pay))
                            =x-bind-step  "proj_stok.includes('AZP') ? 1 : 0.01"
                            =x-on-change  "updateMile";
                          ;label(for "m{<min>}c")
                            ; Amount
                            ;span(x-text "'(' + (proj_stok.includes('AZP') ? '@' : '$') + proj_stok + ')'");
                          ==
                        ==
                      ==
                      ;div(class "fund-form-group")
                        ;div(class "grow-wrap")
                          ;textarea.p-1  =name  "m{<min>}s"  =rows  "3"
                            =placeholder  "Describe your milestone in detail. Plaintext and markdown inputs both supported."
                            =value  (trip summary.mil)
                            =x-on-input  "updateTextarea"
                            ; {(trip summary.mil)}
                          ==
                        ==
                        ;label(for "m{<min>}s"): Milestone Description
                      ==
                    ==
              ==
              ;div.flex.justify-center.mx-auto
                ;button.fund-butn-ac-m(type "button", x-on-click "appendMile"): add milestone +
              ==
            ==
            ;div(class "flex flex-col gap-2")
              ;h1: Trusted Oracle
              ;p
                ; Choose a service provider who will assess work completion
                ; and settle disputes. The fee percentage is paid to the
                ; oracle as a cut of the completed milestone upon withdrawal
                ; of funds.
              ==
              ;div(class "grid grid-cols-1 sm:grid-cols-2")
                ;div(class "fund-form-group col-span-1")
                  ;select#proj-oracle  =name  "sea"
                      =x-init  "initTomSelect($el, \{empty: true, create: tsCreateOracle($el)})"
                    ;*  =+  ses=?~(pru !<(@p (slot:config %point)) p.assessment.u.pru)
                        =+  dad=(sein:title our.bol now.bol our.bol)
                        %+  turn  [ses !<(@p (slot:config %point)) dad !<((list @p) (slot:config %feat-oraz))]
                        |=  ora=@p
                        ^-  manx
                        :_  ; {<ora>}
                        :-  %option
                        ;:  welp
                            [%value "{<ora>}"]~
                            [%data-image (surt:enrl:ff:fh ora)]~
                            ?.(=(ses ora) ~ [%selected ~]~)
                        ==
                  ==
                  ;label(for "sea"): Trusted Oracle
                ==
                ;div(class "fund-form-group col-span-1")
                  ;input.p-1  =name  "seo"  =type  "number"
                    =min  "0"  =max  "100"  =step  "0.01"
                    =x-bind-placeholder  "proj_stok.includes('AZP') ? '0%' : '1%'"
                    =x-bind-readonly  "proj_stok.includes('AZP')"
                    =value  ?~(pru "" (cash:enjs:ff:fh q.assessment.u.pru 6));
                  ;label(for "seo"): Fee Offer (%)
                ==
              ==
            ==
        ==
    ;div(class "flex flex-col gap-2")
      ;h1: Confirm & Launch
      ;p
        ; Please review your proposal in detail and ensure
        ; your trusted oracle is in mutual agreement on expectations
        ; for review of work and release of funds.
      ==
      ;p
        ;span: Please note there is a
        ;span(class "font-semibold"):  1% protocol fee
        ;span:  on all successfully completed milestone withdrawals.
        ;span:  Neither refund transactions nor NFT-denominated campaigns
        ;span:  incur any fees.
      ==
      ;div(class "flex w-full justify-center gap-x-2 mx-auto")
        ;*  |^  ?+  sat  !!  ::  ~[dead-butn drop-butn]
                  %born  ~[init-butn drop-butn]
                  %prop  ~[croc-butn drop-butn]
                ==
            ++  init-butn  (prod-butn:ui:fh %medi %action %init "save draft ~" ~ ~)
            ++  croc-butn  (prod-butn:ui:fh %medi %action %bump-born "retract proposal ~" ~ ~)
            ++  drop-butn
              =+  obj=?:(?=(?(%born %prop) sat) "draft" "project")
              (prod-butn:ui:fh %medi %false %drop "delete {obj} ✗" ~ ~)
            ::  ++  dead-butn
            ::    %:  prod-butn:ui:fh
            ::        %medi  %false  %dead  "discontinue project ✗"  ~
            ::        ?.(?=(%dead sat) ~ "Project has already been discontinued.")
            ::    ==
            --
      ==
    ==
    ;script
      ;+  ;/
      ::  FIXME: Hack to reduce build times and fix build stack overflows
      ::  on some ships
      %-  zing  %+  join  "\0a"
      ^-  (list tape)
      :~  "document.addEventListener('alpine:init', () => Alpine.data('proj_edit', () => (\{"
          :(weld "proj_scan: '" (bloq:enjs:ff:fh ?~(pru id:(snag 0 xlis:fc) chain.payment.u.pru)) "',")
          :(weld "proj_stok: '" ?~(pru "USDC" (trip symbol.payment.u.pru)) "',")
          :(weld "mile_cost: [" (roll `(list mile:f)`?~(pru *(lest mile:f) milestones.u.pru) |=([n=mile:f a=tape] :(weld a (comp:enjs:ff:fh cost.n ?~(pru (~(got by smap:fc) %ethereum 'USDC') payment.u.pru)) ","))) "],")
          ^-  tape  ^~
          %+  rip  3
          '''
          init() {
            this.updateProj();
            document.querySelectorAll('textarea').forEach(elem => (
              this.updateTextarea({target: elem})
            ));
          },
          updateProj() {
            const isNFT = this.proj_stok.includes('AZP');
            const amount = this.mile_cost.reduce((a, n) => a + n, 0).toFixed(isNFT ? 0 : 2);
            this.proj_cost = (this.proj_stok.includes('USDC'))
              ? `\$${amount}`
              : `${amount} ${isNFT ? '@' : '$'}${this.proj_stok}`
          },
          updateTextarea(event) {
            event.target.parentNode.dataset.replicatedValue = event.target.value;
          },
          updateMile(event) {
            const min = Number(event.target.getAttribute('name')[1]);
            const mav = Number(event.target.value);
            this.mile_cost[min] = (Number.isNaN(mav) ? 0 : mav);
            this.updateProj();
          },
          appendMile(event) {
            const wellDiv = document.querySelector('#milz-well');
            const wellClone = document.querySelector('#mile-0').cloneNode(true);
            const wellIndex = this.mile_cost.length;
            wellClone.setAttribute('id', `mile-${wellIndex}`);
            wellClone.querySelector('h6').innerHTML = `Milestone ${wellIndex + 1}`;
            ['m0n', 'm0c', 'm0s'].forEach(fieldName => {
              const fieldElem = wellClone.querySelector(`[name=${fieldName}]`);
              fieldElem.setAttribute('name', `m${wellIndex}${fieldName.at(2)}`);
              fieldElem.value = '';
              fieldElem.innerHTML = '';
            });
            wellDiv.appendChild(wellClone);
            this.mile_cost = this.mile_cost.concat([0]);
          },
          deleteMile(event) {
            var mileElem = event.target.parentElement;
            while (mileElem !== undefined && !/mile-\d+/.test(mileElem.id)) {
              mileElem = mileElem.parentElement;
            }
            const mileId = mileElem.id.match(/\d+/)[0];

            const wellDiv = document.querySelector('#milz-well');
            const wellMilz = Array.from(wellDiv.children);
            if (wellMilz.length > 1) {
              wellMilz.splice(mileId, 1);
              this.mile_cost.splice(mileId, 1);
              wellDiv.removeChild(mileElem);

              wellMilz.forEach((mileElem, mileIndex) => {
                const oldId = mileElem.id.match(/\d+/)[0];
                mileElem.setAttribute('id', `mile-${mileIndex}`);
                mileElem.querySelector('h6').innerHTML = `Milestone ${mileIndex + 1}`;
                [`m${oldId}n`, `m${oldId}c`, `m${oldId}s`].forEach(fieldName => {
                  const fieldElem = mileElem.querySelector(`[name=${fieldName}]`);
                  fieldElem.setAttribute('name', `m${mileIndex}${fieldName.at(2)}`);
                });
              });
            }

            this.updateProj();
          },
          })));
          '''
      ==
    ==
  ==
--
::  VERSION: [1 4 3]
