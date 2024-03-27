::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder, s=server
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  =/  rex=(map @t bean)  (malt ~[['act' &] ['sum' |] ['tok' |] ['msg' |] ['oas' |] ['oaa' |]])
  ?+  arz=(parz:fh bod rex)  p.arz  [%| *]
    =+  act=(~(got by p.arz) 'act')
    ::  FIXME: This check is actually a bit redundant b/c it's checked
    ::  again in `po-push:po-core` (see proj-edit.hoon for details).
    ?.  ?=(?(%bump-born %bump-prop %bump-work %bump-sess %bump-done %bump-dead %mula-plej %mula-trib) act)
      (crip "bad act; expected (bump-*|mula), not {(trip act)}")
    ?~  pro=(~(get by (prez-ours:sss:f bol dat)) lag)
      (crip "bad act={<act>}; project doesn't exist: {<lag>}")
    ;;  act-now:f  %-  turn  :_  |=(p=prod:f [lag p])  ^-  (list prod:f)
    ?-  act
      %bump-born  [%bump %born ~]~
      %bump-work  [%bump %work ~]~
      %bump-sess  [%bump %sess ~]~
      %bump-dead  [%bump %dead ~]~
    ::
        %bump-done
      ::  TODO: fill in actual `oat` values based on passed POST
      ::  arguments (forwarded from MetaMask)
      [%bump %done `*oath:f]~
    ::
        %bump-prop
      :_  ~  :+  %bump  %prop
      :-  ~  =+  oat=*oath:f  %_  oat
          sigm
        :*  (rash (~(got by p.arz) 'oas') ;~(pfix (jest '0x') hex))
            (rash (~(got by p.arz) 'oaa') ;~(pfix (jest '0x') hex))
            (crip (~(oath pj:f -.u.pro) p.lag))
        ==
      ==
    ::
        *  ::  mula-*
      =/  who=(unit @p)  ?.((auth:fh bol) ~ `src.bol)
      =/  sum=@rs  (rash (~(got by p.arz) 'sum') royl-rs:so)
      =/  msg=@t  (~(got by p.arz) 'msg')
      ?-  act
        %mula-plej  [%mula %plej (need who) sum *bloq:f msg]~
        %mula-trib  [%mula %trib who sum *stub:f msg]~
      ==
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  ?.  gud  [%code 500 txt]
  ::  FIXME: This is a hack to force the page to reload. We can't just
  ::  call `+build` because edits are lazily evaluated via cards (this
  ::  is always true if `!=(our.bol src.bol)`)
  :+  %next  (crip (aurl:fh -:(durl:fh url.request.ord)))
  ?~(txt 'invalid edit to project (see dojo for details)' txt)
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  ?~  pre=(~(get by (prez-ours:sss:f bol dat)) lag)  [%code 404 '']
  =*  pro  -.u.pre
  =/  sat=stat:f  ~(stat pj:f pro)
  ::  NOTE: Gate non-`our` users to my ship's non-draft projects
  ?:  &(!=(our.bol src.bol) |(!=(our.bol p.lag) ?=(?(%born %prop) sat)))  [%auth url.request.ord]
  =/  roz=(set role:f)  (~(rols pj:f pro) p.lag src.bol)
  =/  pod=odit:f  ~(odit pj:f pro)
  =/  moz=(list odit:f)  ~(odim pj:f pro)
  =/  [nin=@ mile:f]  ~(next pj:f pro)
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "{(trip title.pro)}"
  ;div#maincontent(class "p-2")
    ;div(class "flex flex-wrap items-center justify-between")
      ;div(class "text-4xl sm:text-5xl"): {(trip title.pro)}
      ;div(class "flex items-center gap-x-2")
        ;div(class "text-2xl font-medium")
          ; Funding Goal:
          ;span#proj-cost: ${(mony:dump:fh cost.pod)}
        ==
        ;+  (stat-pill:htmx:fh sat)
      ==
    ==
    ::  ;*  ?:  |(?=(~ msg) gud.u.msg)  ~
    ::      :_  ~  ;div(class "text-red-500 text-center"): {(trip txt.u.msg)}
    ;*  ?~  image.pro  ~
        :_  ~  ;img@"{(trip u.image.pro)}"(class "w-full my-2");
    ;div(class "lg:flex lg:justify-between")
      ;div(class "lg:flex-1 sm:gap-x-10")
        ;form(method "post", class "flex justify-between mx-auto sm:justify-normal sm:gap-x-16")
          ;div(class "flex flex-col justify-normal p-1 gap-0.5")
            ;div(class "text-sm font-light underline"): project worker
            ;div(class "px-1 text-lg font-mono text-nowrap"): {(scow %p p.lag)}
            ;+  ?.  (~(has in roz) %work)
                  ;a.fund-butn-link/"{(curl:fh p.lag)}"(target "_blank"): send message →
                ?:  ?=(?(%born %prop) sat)
                  ;a.fund-butn-link/"{(aurl:fh (snoc pat %edit))}": edit project →
                ?.  ?=(?(%done %dead) sat)
                  (prod-butn:htmx:fh %bump-dead %red "cancel project ✗" ~)
                ;div;
          ==
          ;div(class "flex flex-col justify-normal p-1 gap-0.5")
            ;div(class "text-sm font-light underline"): escrow assessor
            ;div(class "px-1 text-lg font-mono text-nowrap"): {(scow %p p.assessment.pro)}
            ;+  ?.  (~(has in roz) %orac)
                  ;a.fund-butn-link/"{(curl:fh p.assessment.pro)}"(target "_blank"): send message →
                ?.  ?=(?(%born %prop %done %dead) sat)
                  (prod-butn:htmx:fh %bump-dead %red "cancel project ✗" ~)
                ;div;
          ==
        ==
        ;div(class "my-1 mx-3 p-1 whitespace-normal sm:text-lg"): {(trip summary.pro)}
      ==
      ;*  ?:  ?=(?(%born %done %dead) sat)  ~
          =+  cas="m-2 p-2 border-2 border-black rounded-xl lg:w-1/4"
          ?.  ?=(%prop sat)  ::  contribute aside form
            :_  ~
            ;form(method "post", autocomplete "off", class cas)
              ;div(class "p-2 text-3xl w-full"): Contribute
              ;div(class "flex gap-2")
                ;div(class "fund-form-group")
                  ;+  :_  ~  :-  %input
                      ;:  welp
                          [%name "sum"]~
                          [%type "number"]~
                          [%required ~]~
                          [%min "0.01"]~
                          [%max "100000000"]~
                          [%step "0.01"]~
                          [%placeholder "10"]~
                          [%class "p-2"]~
                          ?~  pej=(~(get by pledges.pro) src.bol)  ~
                          ~[[%readonly ~] [%value (mony:dump:fh cash.u.pej)]]
                      ==
                  ;label(for "sum"): amount ($)
                ==
                ;div(class "fund-form-group")
                  ;select.p-2(name "tok")
                    ;option(value "usdc"): USDC
                    ;option(value "usdt"): USDT
                    ;option(value "dai"): DAI
                  ==
                  ;label(for "tok"): token
                ==
              ==
              ;div(class "fund-form-group")
                ;input.p-2(name "msg", type "text", placeholder "awesome work!");
                ;label(for "msg"): message
              ==
              ;div(class "p-2 flex justify-end gap-x-2")
                ;+  %-  prod-butn:htmx:fh  :^  %mula-plej  %black  "pledge only ~"
                    ?.  (auth:fh bol)  "pledges only available to authenticated ships"
                    ?:  (~(has by pledges.pro) src.bol)  "you must fulfill your outstanding pledge"
                    ~
                ;+  (prod-butn:htmx:fh %mula-trib %green "send funds ✓" ~)
              ==
            ==
          ?:  (~(has in roz) %orac)  ::  oracle acceptance form
            :_  ~
            ;form(method "post", autocomplete "off", class cas)
              ;div(class "p-2 text-3xl w-full"): Review Request
              ;div(class "gap-2")
                ;div(class "p-2")
                  ;span(class "font-mono font-medium"): {(scow %p p.lag)}
                  ;span:  has requested your services as an escrow assessor for this project.
                ==
                ;div(class "p-2")
                  ;span(class "font-mono font-medium"): {(scow %p p.lag)}
                  ;span:  is offering the following compensation for your services:
                ==
                ;div(class "m-2 p-2 font-mono bg-gray-300 text-black rounded-md")
                  ;span(class "font-medium"): {(mony:dump:fh q.assessment.pro)}%
                  ;span:  of each milestone payout upon completed assessment
                ==
                ;div(class "p-2")
                  ; Accepting this review request means that you will have the
                  ; responsibility to review each project milestone and release
                  ; funds to the project worker upon successful completion.
                ==
                ;div(class "p-2")
                  ; If you pinky promise to assess this project, click the button
                  ; below to confirm your particpation.
                ==
              ==
              ;div(class "p-2 flex justify-end gap-x-2")
                ;+  (prod-butn:htmx:fh %bump-born %black "decline ~" ~)
                ;+  %-  prod-butn:htmx:fh  :^  %bump-prop  %green  "accept ✓"
                    ?~(contract.pro ~ "awaiting confirmation from project worker")
              ==
              ;data#fund-proj.hidden(value (~(oath pj:f pro) p.lag));
              ;input#fund-oath-sign.hidden(name "oas", type "text");
              ;input#fund-oath-addr.hidden(name "oaa", type "text");
            ==
          ~  ::  no aside form
    ==
    ;div
      ;div(class "text-3xl pt-2"): Contribution Tracker
      ;div(class "flex flex-col gap-2")
        ;div(class "flex justify-between")
          ;div(class "flex gap-2")
            ; Milestone Progress
            ;span(class "font-medium"): {<nin>}/{<(lent milestones.pro)>}
          ==
          ;div(class "flex gap-2")
            ; Goal
            ;span(class "font-medium"): ${(mony:dump:fh cost.pod)}
          ==
        ==
        ;+  (odit-ther:htmx:fh pod)
      ==
    ==
    ;form(method "post", autocomplete "off")
      ;div(class "text-3xl pt-2"): Milestone Overview
      ;*  %+  turn  (enum:fx `(list mile:f)`milestones.pro)
          |=  [min=@ mil=mile:f]
          ^-  manx
          ;div(class "my-4 p-2 lg:p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap justify-between items-center gap-2")
              ;div(class "sm:text-nowrap text-2xl"): Milestone {<+(min)>}: {(trip title.mil)}
              ;+  (stat-pill:htmx:fh status.mil)
            ==
            ;+  (odit-ther:htmx:fh (snag min moz))
            ; {(trip summary.mil)}
            ;div(class "flex flex-wrap items-center justify-end pt-2 gap-2")
              ;*  ;:  welp
                  ?.  &((lth min nin) (~(has in roz) %work))  ~
                ::  TODO: Make this button do something
                :_  ~  (prod-butn:htmx:fh %todo %green "withdraw funds ✓" ~)
              ::
                  ?.  &(=(min nin) (~(has in roz) %work) ?=(%lock sat))  ~
                :_  ~  (prod-butn:htmx:fh %bump-work %black "mark in-progress ~" ~)
              ::
                  ?.  &(=(min nin) (~(has in roz) %work) ?=(%work sat))  ~
                :_  ~  (prod-butn:htmx:fh %bump-sess %black "request review ~" ~)
              ::
                  ?.  &(=(min nin) (~(has in roz) %orac) ?=(%sess sat))  ~
                :~  ;a.fund-butn-link/"{(curl:fh p.lag)}"(target "_blank"): message worker →
                    (prod-butn:htmx:fh %bump-work %black "changes required ~" ~)
                    (prod-butn:htmx:fh %bump-done %green "approve ✓" ~)
                ==
              ==
            ==
          ==
    ==
    ;div
      ;div(class "text-3xl pt-2"): Proposal Funders
      ;*  =/  muz=(list mula:f)  ~(mula pj:f pro)
          ?~  muz
            :~  ;div(class "italics mx-4 text-gray-600")
                  ; No contributors found.
            ==  ==
          %+  turn  muz
          |=  mul=mula:f
          ^-  manx
          =/  [wut=tape who=tape cas=tape]
            ?:  ?=(%plej -.mul)
              ["pledged" (scow %p ship.mul) "border-yellow-500 text-yellow-500"]
            :-  "fulfilled"  :_  "border-green-500 text-green-500"
            ?~(ship.mul "anonymous" (scow %p u.ship.mul))
          ;div(class "my-2 p-2 border-2 border-black flex items-center justify-between gap-x-2 rounded-md")
            ;div(class "flex flex-wrap sm:flex-nowrap sm:items-center gap-x-2")
              ;div(class "p-1 font-mono text-nowrap"): {who}
              ;div(class "p-1"): {(trip note.mul)}
            ==
            ;div(class "flex flex-wrap sm:flex-nowrap items-center")
              ;div(class "mx-auto p-1 font-semibold"): ${(mony:dump:fh cash.mul)}
              ;div(class "mx-auto p-1 flex")
                ;div(class "text-nowrap py-1 px-2 border-2 rounded-full font-medium {cas}"): {wut}
              ==
            ==
          ==
    ==
    ;script(type "module")
      ;+  ;/  ^~  %-  trip
      '''
      import { safeSign } from '/apps/fund/asset/safe.js';
      const signButton = document.querySelector("#prod-butn-bump-prop");
      signButton?.addEventListener("click", (event) => {
        event.preventDefault();
        safeSign({
          projectContent: document.querySelector("#fund-proj").value,
        }).then(([address, signature]) => {
          document.querySelector("#fund-oath-addr").value = address;
          document.querySelector("#fund-oath-sign").value = signature;
          event.target.form.requestSubmit(event.target);
        });
      });
      '''
    ==
  ==
--
