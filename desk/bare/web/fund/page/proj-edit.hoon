::  /web/fund/page/proj-edit/hoon: render project edit page for %fund
::
/-  fd=fund-data
/+  f=fund, fx=fund-xtra, fh=fund-http
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
        |=  cor=@t
        ^-  (unit cash:f)
        ?-  val=(mule |.((cash:dejs:format:fh cor)))
          [%| *]  ~
          [%& *]  `+.val
        ==
      --
  =/  [lau=(unit flag:f) pru=(unit prej:f)]  (grab:proj:preface:fh hed)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ::  FIXME: Go to next available name if this path is already taken
    ::  by another project (add random number suffix)
    =/  lag=flag:f  ?^(lau u.lau [our.bol (asci:fx (~(got by p.arz) %nam))])
    =-  ?@(- - [lag -])
    ^-  $@(@t prod:f)
    ?+    dif=(~(got by p.arz) %dif)
        (crip "bad dif; expected (init|drop|bump-*), not {(trip dif)}")
      %drop       [%drop ~]
      %bump-born  ?~(pru 'project does not exist' [%bump %born ~])
    ::
        %init
      ?+  arz=(parz:fh bod (sy ~[%nam %sum %pic %toc %toa %ton %tod %sea %seo %m0n %m0s %m0c]))  p.arz  [%| *]
        :+  %init  ~
        =+  pro=*proj:f  %_  pro
          title       (~(got by p.arz) %nam)
          summary     (trim (~(got by p.arz) %sum))
        ::
            assessment
          :-  (fall (slaw %p (~(got by p.arz) %sea)) !<(@p (slot:config %point)))
          (fall (pars (~(got by p.arz) %seo)) 1.000.000)
        ::
            image
          =+  pic=(~(got by p.arz) %pic)
          ?~((rush pic auri:de-purl:html) ~ `pic)
        ::
            currency
          :*  chain=(bloq:dejs:format:fh (~(got by p.arz) %toc))
              addr=(addr:dejs:format:fh (~(got by p.arz) %toa))
              name=(~(got by p.arz) %ton)
              symbol=(~(got by p.arz) %ton)
              decimals=(bloq:dejs:format:fh (~(got by p.arz) %tod))
          ==
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
            cost     (fall (pars (~(gut by p.arz) (crip "m{<ind>}c") '')) 0)
          ==
        ==
      ==
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  =/  [lag=flag:f pyp=@tas]  (gref:proj:preface:fh txt)
  ?:  =(%drop pyp)  [%next (desc:enrl:format:fh /dashboard/worker) ~]
  [%next (desc:enrl:format:fh /next/(scot %p p.lag)/[q.lag]/edit) ~]
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [lau=(unit flag:f) pru=(unit prej:f)]  (grab:proj:preface:fh arz)
  =/  sat=stat:f  ?~(pru %born ~(stat pj:f -.u.pru))
  ?:  &(?=(^ lau) ?=(~ pru))
    [%code 404 'project does not exist']
  ?.  |(?=(~ pru) ?=(?(%born %prop) sat))
    [%next (flac:enrl:format:fh (need lau)) 'project cannot be edited after locking']
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "project edit"
  ;form.p-2(method "post", autocomplete "off", x-data "proj_edit")
    ;+  :-  [%fieldset ?:(=(%born sat) ~ [%disabled ~]~)]
    :~  ;div
          ;+  %^  work-tytl:ui:fh  "Project Overview"  sat
              ;span(x-text "proj_cost");
          ;div
            ;div(class "flex")
              ;div(class "fund-form-group")
                ;input.p-1  =name  "nam"  =type  "text"  =required  ~
                  =placeholder  "My Awesome Project"
                  =value  (trip ?~(pru '' title.u.pru));
                ;label(for "nam"): Project Name
              ==
              ;div(class "fund-form-group")
                ;input.p-1  =name  "pic"  =type  "url"
                  =placeholder  "https://example.com/example.png"
                  =value  (trip (fall ?~(pru ~ image.u.pru) ''));
                ;label(for "pic"): Header Image URL
              ==
            ==
            ;div(class "flex")
              ;div(class "fund-form-group")
                ;select#proj-chain.fund-tsel(name "net", required ~)
                  ::  FIXME: Including the network IDs here is a hack, but
                  ::  this should be fixed by moving chain stuff to the BE
                  ;*  =+  can=chain:?~(pru *coin:f currency.u.pru)
                      %+  turn  ~[["mainnet" 1] ["sepolia" 11.155.111]]
                      |=  [net=tape nid=@ud]
                      ^-  manx
                      :_  ; {(caps:fx net)}
                      :-  %option
                      ;:  welp
                          [%value net]~
                          [%data-image (aset:enrl:format:fh (crip net))]~
                          ?.(=(can nid) ~ [%selected ~]~)
                      ==
                ==
                ;label(for "net"): Blockchain
              ==
              ;div(class "fund-form-group")
                ;select#proj-token.fund-tsel(name "tok", required ~)
                  ;*  =+  sym=(trip symbol:?~(pru *coin:f currency.u.pru))
                      %+  turn  ~["usdc" "wstr"]  ::  "usdt" "dai"
                      |=  tok=tape
                      ^-  manx
                      :_  ; {(cuss tok)}
                      :-  %option
                      ;:  welp
                          [%value tok]~
                          [%data-image (aset:enrl:format:fh (crip tok))]~
                          ?.(=(sym tok) ~ [%selected ~]~)
                      ==
                ==
                ;label(for "tok"): Token
              ==
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
        ;div
          ;h1.pt-2: Milestones
          ;div#milz-well.mx-2
            ;*  %+  turn  (enum:fx `(list mile:f)`?~(pru *(lest mile:f) milestones.u.pru))
                |=  [min=@ mil=mile:f]
                ^-  manx
                ;div(id "mile-{<min>}", class "my-2 p-4 border-2 border-secondary-500 rounded-xl")
                  ;div(class "flex flex-wrap items-center justify-between")
                    ;h6(class "text-tertiary-500 underline"): Milestone {<+(min)>}
                    ;+  ?:  ?=(%born status.mil)
                          ::  FIXME: Using the X SVG causes a weird pop-in effect
                          ::  for new milestones, so we just use raw text for now
                          ;button(class "font-light", type "button", x-on-click "deleteMile"): ❌
                        (stat-pill:ui:fh status.mil)
                  ==
                  ;div(class "flex")
                    ;div(class "fund-form-group")
                      ;input.p-1  =name  "m{<min>}n"  =type  "text"
                        =placeholder  "Give your milestone a title"
                        =value  (trip title.mil);
                      ;label(for "m{<min>}n"): Title
                    ==
                    ;div(class "fund-form-group")
                      ;input.p-1  =name  "m{<min>}c"  =type  "number"
                        =min  "0"  =max  "100000000"  =step  "0.01"
                        =placeholder  "0"
                        =value  ?:(=(0 cost.mil) "" (cash:enjs:format:fh cost.mil))
                        =x-on-change  "updateMile";
                      ;label(for "m{<min>}c"): Amount
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
        ;div
          ;h1.pt-2: Trusted Oracle
          ;p.pt-2
            ; Choose a service provider who will assess work completion
            ; and settle disputes. The fee percentage is paid to the
            ; oracle as a cut of the completed milestone upon withdrawal
            ; of funds.
          ==
          ;div(class "flex")
            ;div(class "fund-form-group")
              ;select#proj-oracle.fund-tsel(name "sea")
                ;*  =+  ses=?~(pru !<(@p (slot:config %point)) p.assessment.u.pru)
                    =+  dad=(sein:title our.bol now.bol our.bol)
                    ::  FIXME: These options are hard-coded from the
                    ::  ~tocwex.syndicate group's oracle directory
                    %+  turn  ~[!<(@p (slot:config %point)) dad ~roswet ~nisfeb ~hosdys ~ridlyd ~darlur]
                    |=  ora=@p
                    ^-  manx
                    :_  ; {<ora>}
                    :-  %option
                    ;:  welp
                        [%value "{<ora>}"]~
                        [%data-image "https://azimuth.network/erc721/{(bloq:enjs:format:fh `@`ora)}.svg"]~
                        ?.(=(ses ora) ~ [%selected ~]~)
                    ==
              ==
              ;label(for "sea"): Trusted Oracle
            ==
            ;div(class "fund-form-group")
              ;input.p-1  =name  "seo"  =type  "number"
                =min  "0"  =max  "100"  =step  "0.01"
                =placeholder  "1%"
                =value  ?~(pru "" (cash:enjs:format:fh q.assessment.u.pru));
              ;label(for "seo"): Fee Offer (%)
            ==
          ==
        ==
    ==
    ;div(class "flex flex-col gap-y-2 m-1")
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
        ;span:  Refund transactions do not incur any fees.
      ==
      ;div(class "flex w-full justify-center gap-x-2 mx-auto")
        ;*  |^  ?+  sat  !!  ::  ~[dead-butn drop-butn]
                  %born  ~[init-butn drop-butn]
                  %prop  ~[croc-butn drop-butn]
                ==
            ++  init-butn  (prod-butn:ui:fh %init %action "save draft ~" "saveProj" ~)
            ++  croc-butn  (prod-butn:ui:fh %bump-born %action "retract proposal ~" ~ ~)
            ++  drop-butn
              =+  obj=?:(?=(?(%born %prop) sat) "draft" "project")
              (prod-butn:ui:fh %drop %false "delete {obj} ✗" ~ ~)
            ::  ++  dead-butn
            ::    %:  prod-butn:ui:fh
            ::        %dead  %false  "discontinue project ✗"  ~
            ::        ?.(?=(%dead sat) ~ "project has already been discontinued")
            ::    ==
            --
      ==
    ==
    ;script
      ;+  ;/
      """
      document.addEventListener('alpine:init', () => Alpine.data('proj_edit', () => (\{
        proj_born: {?:(=(%born sat) "true" "false")},
        proj_cost: 0,
        mile_cost: [{(roll `(list mile:f)`?~(pru *(lest mile:f) milestones.u.pru) |=([n=mile:f a=tape] (weld a "{(cash:enjs:format:fh cost.n)},")))}],
        init() \{
          this.updateProj();
          document.querySelectorAll('textarea').forEach(elem => (
            this.updateTextarea(\{target: elem})
          ));
        },
        updateProj() \{
          this.proj_cost = `\\$$\{this.mile_cost.reduce((a, n) => a + n, 0).toFixed(2)}`;
        },
        saveProj(event) \{
          const chain = event.target.form.querySelector('[name=net]').value.toUpperCase();
          const token = event.target.form.querySelector('[name=tok]').value.toUpperCase();
          this.sendForm(event, [], () => Promise.resolve(\{
            toc: this.NETWORK.ID[chain],
            toa: this.CONTRACT[token].ADDRESS[chain],
            ton: token.toLowerCase(),
            tod: this.CONTRACT[token].DECIMALS,
          }));
        },
        updateTextarea(event) \{
          event.target.parentNode.dataset.replicatedValue = event.target.value;
        },
        updateMile(event) \{
          const min = Number(event.target.getAttribute('name')[1]);
          const mav = Number(event.target.value);
          this.mile_cost[min] = (Number.isNaN(mav) ? 0 : mav);
          this.updateProj();
        },
        appendMile(event) \{
          const wellDiv = document.querySelector('#milz-well');
          const wellClone = document.querySelector('#mile-0').cloneNode(true);
          const wellIndex = this.mile_cost.length;
          wellClone.setAttribute('id', `mile-$\{wellIndex}`);
          wellClone.querySelector('h6').innerHTML = `Milestone $\{wellIndex + 1}`;
          ['m0n', 'm0c', 'm0s'].forEach(fieldName => \{
            const fieldElem = wellClone.querySelector(`[name=$\{fieldName}]`);
            fieldElem.setAttribute('name', `m$\{wellIndex}$\{fieldName.at(2)}`);
            fieldElem.value = '';
            fieldElem.innerHTML = '';
          });
          wellDiv.appendChild(wellClone);
          this.mile_cost = this.mile_cost.concat([0]);
        },
        deleteMile(event) \{
          var mileElem = event.target.parentElement;
          while (mileElem !== undefined && !/mile-\\d+/.test(mileElem.id)) \{
            mileElem = mileElem.parentElement;
          }
          const mileId = mileElem.id.match(/\\d+/)[0];

          const wellDiv = document.querySelector('#milz-well');
          const wellMilz = Array.from(wellDiv.children);
          if (wellMilz.length > 1) \{
            wellMilz.splice(mileId, 1);
            this.mile_cost.splice(mileId, 1);
            wellDiv.removeChild(mileElem);

            wellMilz.forEach((mileElem, mileIndex) => \{
              const oldId = mileElem.id.match(/\\d+/)[0];
              mileElem.setAttribute('id', `mile-$\{mileIndex}`);
              mileElem.querySelector('h6').innerHTML = `Milestone $\{mileIndex + 1}`;
              [`m$\{oldId}n`, `m$\{oldId}c`, `m$\{oldId}s`].forEach(fieldName => \{
                const fieldElem = mileElem.querySelector(`[name=$\{fieldName}]`);
                fieldElem.setAttribute('name', `m$\{mileIndex}$\{fieldName.at(2)}`);
              });
            });
          }

          this.updateProj();
        },
      })));
      """
    ==
  ==
--
::  VERSION: [0 4 1]
