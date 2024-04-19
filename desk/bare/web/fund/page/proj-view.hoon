::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  =/  rex=(map @t bean)  (malt ~[['act' &] ['sum' |] ['tok' |] ['msg' |] ['oas' |] ['oaa' |] ['sxb' |] ['sxa' |] ['swa' |] ['soa' |] ['ssa' |] ['mxb' |] ['mxa' |] ['mad' |] ['mis' |] ['mia' |] ['mit' |] ['des' |] ['dea' |] ['det' |] ['mib' |] ['mih' |] ['mii' |]])
  ?+  arz=(parz:fh bod rex)  p.arz  [%| *]
    =+  act=(~(got by p.arz) 'act')
    ::  FIXME: This check is actually a bit redundant b/c it's checked
    ::  again in `po-push:po-core` (see proj-edit.hoon for details).
    ?.  ?=(?(%bump-born %bump-prop %bump-lock %bump-work %bump-sess %bump-done %bump-dead %mula-plej %mula-trib %draw-done %draw-dead %wipe-casi %wipe-cade %wipe-resi %wipe-rede) act)
      (crip "bad act; expected (bump-*|mula), not {(trip act)}")
    ?~  pro=(~(get by (prez-ours:sss:f bol dat)) lag)
      (crip "bad act={<act>}; project doesn't exist: {<lag>}")
    =+  lin=(dec (lent milestones.u.pro))
    ;;  act-now:f  %-  turn  :_  |=(p=prod:f [lag p])  ^-  (list prod:f)
    ?-  act
      %bump-born  [%bump %born ~]~
      %bump-work  [%bump %work ~]~
      %bump-sess  [%bump %sess ~]~
      %wipe-cade  [%wipe (bloq:take:fh (~(got by p.arz) 'mii')) ~]~
      %wipe-rede  [%wipe lin ~]~
    ::
        %wipe-casi
      :_  ~  :+  %wipe  (bloq:take:fh (~(got by p.arz) 'mii'))
      :^    ~
          (sign:take:fh (~(got by p.arz) 'mis'))
        (addr:take:fh (~(got by p.arz) 'mia'))
      [%| (addr:take:fh (~(got by p.arz) 'mit'))]
    ::
        %wipe-resi
      :_  ~  :+  %wipe  lin
      :^    ~
          (sign:take:fh (~(got by p.arz) 'mis'))
        (addr:take:fh (~(got by p.arz) 'mia'))
      [%| (addr:take:fh (~(got by p.arz) 'mit'))]
    ::
        %bump-prop
      :_  ~  :+  %bump  %prop
      :-  ~  =+  oat=*oath:f  %_  oat
          sigm
        :*  (sign:take:fh (~(got by p.arz) 'oas'))
            (addr:take:fh (~(got by p.arz) 'oaa'))
            [%& (crip (~(oath pj:f -.u.pro) p.lag))]
        ==
      ==
    ::
        %bump-lock
      :_  ~  :+  %bump  %lock  :-  ~
      :*  :-  (bloq:take:fh (~(got by p.arz) 'sxb'))
            (addr:take:fh (~(got by p.arz) 'sxa'))
          sigm:(need contract.u.pro)
          (addr:take:fh (~(got by p.arz) 'swa'))
          (addr:take:fh (~(got by p.arz) 'soa'))
          (addr:take:fh (~(got by p.arz) 'ssa'))
      ==
    ::
        %bump-done
      :_  ~  :+  %bump  %done
      :-  ~  =+  oat=*oath:f  %_  oat
          sigm
        :*  (sign:take:fh (~(got by p.arz) 'mis'))
            (addr:take:fh (~(got by p.arz) 'mia'))
            [%| (addr:take:fh (~(got by p.arz) 'mit'))]
        ==
      ==
    ::
        %bump-dead
      :_  ~  :+  %bump  %dead
      :-  ~  =+  oat=*oath:f  %_  oat
          sigm
        :*  (sign:take:fh (~(got by p.arz) 'des'))
            (addr:take:fh (~(got by p.arz) 'dea'))
            [%| (addr:take:fh (~(got by p.arz) 'det'))]
        ==
      ==
    ::
        %draw-done
      :_  ~  :^  %draw
          (bloq:take:fh (~(got by p.arz) 'mii'))
        (bloq:take:fh (~(got by p.arz) 'mib'))
      (addr:take:fh (~(got by p.arz) 'mih'))
    ::
        %draw-dead
      :_  ~  :^  %draw
          lin
        (bloq:take:fh (~(got by p.arz) 'mib'))
      (addr:take:fh (~(got by p.arz) 'mih'))
    ::
        *  ::  mula-*
      =/  who=(unit @p)  ?.((auth:fh bol) ~ `src.bol)
      =/  wen=@ud  (bloq:take:fh (~(got by p.arz) 'mxb'))
      =/  sum=@rs  (mony:take:fh (~(got by p.arz) 'sum'))
      =/  msg=@t  (~(got by p.arz) 'msg')
      ?-  act
        %mula-plej  [%mula %plej (need who) sum wen msg]~
      ::
          %mula-trib
        :_  ~
        :*  %mula  %trib  who  sum
            :-  [wen (addr:take:fh (~(got by p.arz) 'mxa'))]
              (addr:take:fh (~(got by p.arz) 'mad'))
            msg
        ==
      ==
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  ?.  gud  [%code 500 txt]
  =/  [lag=flag:f pyp=@tas]  (poke:take:fh ?~(txt '' txt))
  [%next (crip (aurl:fh /next/(scot %p p.lag)/[q.lag]/[?:(=(%mula pyp) %mula %bump)])) '']
  ::  :+  %next  (crip (aurl:fh -:(durl:fh url.request.ord)))
  ::  ?~(txt 'invalid edit to project (see dojo for details)' txt)
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  ?~  pre=(~(get by (prez-ours:sss:f bol dat)) lag)  [%code 404 'project does not exist']
  =*  pro  -.u.pre
  =/  sat=stat:f  ~(stat pj:f pro)
  ::  NOTE: Gate non-`our` users to my ship's non-draft projects
  ?:  &(!=(our.bol src.bol) |(!=(our.bol p.lag) ?=(?(%born %prop) sat)))  [%auth url.request.ord]
  =/  roz=(set role:f)  (~(rols pj:f pro) p.lag src.bol)
  =+  [wok=(~(has in roz) %work) ora=(~(has in roz) %orac) tex==(~tocwex src.bol)]
  =+  [tym=|(wok ora) pyr=|(wok ora tex)]
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
          ; Goal
          ;span#proj-cost: ${(mony:dump:fh cost.pod)}
        ==
        ;+  (stat-pill:htmx:fh sat)
      ==
      ;div.hidden
        ;data#fund-safe-addr(value (addr:dump:fh ?~(contract.pro 0x0 safe.u.contract.pro)));
        ;data#fund-safe-bloq(value (bloq:dump:fh ?~(contract.pro 0 p.xact.u.contract.pro)));
        ;data#fund-safe-work(value (addr:dump:fh ?~(contract.pro 0x0 work.u.contract.pro)));
        ;data#fund-safe-orac(value (addr:dump:fh ?~(contract.pro 0x0 from.sigm.u.contract.pro)));
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
            ;+  ?:  !=(our.bol src.bol)  ;div;
                ?.  wok
                  ;a.fund-butn-link/"{(curl:fh p.lag)}"(target "_blank"): send message →
                ?:  ?=(?(%born %prop) sat)
                  ;a.fund-butn-link/"{(aurl:fh (snoc pat %edit))}": edit project →
                ?.  ?=(?(%done %dead) sat)
                  (prod-butn:htmx:fh %bump-dead %red "cancel project ✗" ~)
                ;div;
          ==
          ;div(class "flex flex-col justify-normal p-1 gap-0.5")
            ;div(class "text-sm font-light underline"): trusted oracle
            ;div(class "px-1 text-lg font-mono text-nowrap"): {(scow %p p.assessment.pro)}
            ;+  ?:  !=(our.bol src.bol)  ;div;
                ?:  &(wok ?=(?(%born %prop) sat))
                  ?:  &(!ora ?=(%born sat))
                    ;a.fund-butn-link/"{(curl:fh p.assessment.pro)}"(target "_blank"): send message →
                  ?:  ?=(%prop sat)
                    %-  prod-butn:htmx:fh  :^  %bump-lock  %green  "finalize escrow ✓"
                    ?:(?=(^ contract.pro) ~ "awaiting response from trusted oracle")
                  ;div;
                ?:  &(ora ?!(?=(?(%done %dead) sat)))
                  (prod-butn:htmx:fh %bump-dead %red "cancel project ✗" ~)
                ;div;
          ==
          ;div.hidden
            ;input#fund-dead-sign(name "des", type "text");
            ;input#fund-dead-addr(name "dea", type "text");
            ;input#fund-dead-text(name "det", type "text");
            ;input#fund-safe-xboq(name "sxb", type "text");
            ;input#fund-safe-xadr(name "sxa", type "text");
            ;input#fund-safe-wadr(name "swa", type "text");
            ;input#fund-safe-oadr(name "soa", type "text");
            ;input#fund-safe-sadr(name "ssa", type "text");
          ==
        ==
        ;div(class "my-1 mx-3 p-1 whitespace-normal sm:text-lg"): {(trip summary.pro)}
        ;*  ?:  ?=(?(%born %prop) sat)  ~
            :_  ~  :_  ; share 🔗
            :-  %button
            :~  [%id "fund-butn-share"]
                [%type "button"]
                [%title "copy url"]
                [%class "fund-butn-effect"]
                [%'@click' "copy(window.location.toString(), '#fund-butn-share')"]
            ==
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
                    ::  TODO: Only supporting USDC for the beta
                    ::  ;option(value "usdt"): USDT
                    ::  ;option(value "dai"): DAI
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
              ;div.hidden
                ;input#fund-mula-addr(name "mad", type "text");
                ;input#fund-mula-xboq(name "mxb", type "text");
                ;input#fund-mula-xadr(name "mxa", type "text");
              ==
            ==
          ?:  (~(has in roz) %orac)  ::  oracle acceptance form
            :_  ~
            ;form(method "post", autocomplete "off", class cas)
              ;div(class "p-2 text-3xl w-full"): Review Request
              ;div(class "gap-2")
                ;div(class "p-2")
                  ;span(class "font-mono font-medium"): {(scow %p p.lag)}
                  ;span:  has requested your services as an trusted oracle for this project.
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
              ;div.hidden
                ;data#fund-oath-proj(value (~(oath pj:f pro) p.lag));
                ;input#fund-oath-sign(name "oas", type "text");
                ;input#fund-oath-addr(name "oaa", type "text");
              ==
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
    ;div
      ;div(class "text-3xl pt-2"): Milestone Overview
      ;*  %+  turn  (enum:fx `(list mile:f)`milestones.pro)
          |=  [min=@ mil=mile:f]
          ^-  manx
          =/  oil=odit:f  (snag min moz)
          ;form(method "post", autocomplete "off", class "flex flex-col gap-y-2 my-4 p-2 lg:p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap justify-between items-center gap-2")
              ;div(class "sm:text-nowrap text-2xl"): Milestone {<+(min)>}: {(trip title.mil)}
              ;div(class "flex items-center gap-x-2")
                ;div(class "text-lg")
                  ; Goal
                  ;span#proj-cost: ${(mony:dump:fh cost.mil)}
                ==
                ;+  (stat-pill:htmx:fh status.mil)
              ==
            ==
            ;+  (odit-ther:htmx:fh oil)
            ; {(trip summary.mil)}
            ;div(class "flex flex-wrap items-center justify-end gap-2")
              ;*  =+  [cur==(min nin) las==(+(min) nin) dun=(lth min nin)]
                  ;:    welp
                      ?.  &(cur wok ?=(%lock status.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %bump-work %black "mark in-progress ~" ~)
                  ::
                      ?.  &(cur wok ?=(%work status.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %bump-sess %black "request review ~" ~)
                  ::
                      ?.  &(cur ora ?=(%sess status.mil))  ~
                    :~  ;a.fund-butn-link/"{(curl:fh p.lag)}"(target "_blank"): message worker →
                        (prod-butn:htmx:fh %bump-work %black "changes required ~" ~)
                        (prod-butn:htmx:fh %bump-done %green "approve ✓" ~)
                    ==
                  ::
                  ::
                      ?.  &(dun ora ?=(%done status.mil) ?=(~ withdrawal.mil))  ~
                    :~  ;a.fund-butn-link/"{(curl:fh p.lag)}"(target "_blank"): message worker →
                        (prod-butn:htmx:fh %wipe-casi %green "reapprove ✓" ~)
                    ==
                  ::
                      ?.  &(dun tym ?=(%done status.mil) ?=(^ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %wipe-cade %red "clear approval ✗" ~)
                  ::
                      ?.  &(dun wok ?=(%done status.mil) ?=(^ withdrawal.mil))  ~
                    :_  ~
                    %-  prod-butn:htmx:fh  :^  %draw-done  %green  "claim funds ✓"
                    ?~(xact.u.withdrawal.mil ~ "funds have already been claimed")
                  ::
                  ::
                      ?.  &(las pyr ?=(%dead status.mil) ?=(~ withdrawal.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %wipe-resi %green "sign refund ~" ~)
                  ::
                      ?.  &(las pyr ?=(%dead status.mil) ?=(^ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %wipe-rede %red "clear approval ✗" ~)
                  ::
                      ?.  &(las pyr ?=(%dead status.mil) ?=(^ withdrawal.mil))  ~
                    :_  ~
                    %-  prod-butn:htmx:fh  :^  %draw-dead  %green  "refund funds ✓"
                    ?~(xact.u.withdrawal.mil ~ "funds have already been refunded")
                  ==
            ==
            ;div.hidden
              ;data#fund-mile-cost(value (mony:dump:fh fill.oil));
              ;data#fund-mile-ocut(value (mony:dump:fh q.assessment.pro));
              ;data#fund-mile-awho(value (addr:dump:fh ?~(withdrawal.mil *@ux from.sigm.u.withdrawal.mil)));
              ;data#fund-mile-asig(value (sign:dump:fh ?~(withdrawal.mil *@ux sign.sigm.u.withdrawal.mil)));
              ;data#fund-mile-atak(value (mony:dump:fh ?~(withdrawal.mil *@rs cash.u.withdrawal.mil)));
              ;data#fund-mile-idex(value "{<min>}");
              ;input#fund-mile-sign(name "mis", type "text");
              ;input#fund-mile-addr(name "mia", type "text");
              ;input#fund-mile-text(name "mit", type "text");
              ;input#fund-mile-bloq(name "mib", type "text");
              ;input#fund-mile-hash(name "mih", type "text");
              ;input#fund-mile-amin(name "mii", type "text");
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
      import {
        txnGetURL, safeGetURL, safeGetBlock,
        safeSign, safeDeploy, safeDepositFunds,
        safeSignClaim, safeExecClaim, safeSignRefund, safeExecRefund,
      } from '/apps/fund/asset/safe.js';

      // FIXME: For sign/exec transactions, verify that:
      // - The user has some wallet connected
      // - The wallet is the appropriate one based on the transaction spec (e.g.
      //   either the worker, the oracle, or the tocwex wallet).
      // FIXME: Will small fractions cause problems with the signature and
      // exact matching extraction amounts?
      // TODO: Consider amending the "safeExec*" commands such that they submit
      // an appropriate %wipe-* command if they fail ()

      // NOTE: Actual form buttons:
      // - mula-trib: reads amount/token from form
      // All other buttons are MetaMask queries (with some input data) followed
      // by POST requests (these do not even need to be forms)

      document.querySelector("#prod-butn-bump-prop")?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeSign({
            projectContent: document.querySelector("#fund-oath-proj").value,
          }).then(([address, signature]) => {
            document.querySelector("#fund-oath-addr").value = address;
            document.querySelector("#fund-oath-sign").value = signature;
            event.target.form.requestSubmit(event.target);
          });
        }
      });
      document.querySelector("#prod-butn-bump-lock")?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeDeploy({
            oracleAddress: document.querySelector("#fund-safe-orac").value,
          }).then(([xblock, xhash, workerAddress, oracleAddress, safeAddress]) => {
            console.log(`safe creation successful; view at: ${safeGetURL(safeAddress)}`);
            document.querySelector("#fund-safe-xboq").value = xblock;
            document.querySelector("#fund-safe-xadr").value = xhash;
            document.querySelector("#fund-safe-wadr").value = workerAddress;
            document.querySelector("#fund-safe-oadr").value = oracleAddress;
            document.querySelector("#fund-safe-sadr").value = safeAddress;
            event.target.form.requestSubmit(event.target);
          });
        }
      });
      document.querySelector("#prod-butn-mula-plej")?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeGetBlock().then((block) => {
            document.querySelector("#fund-mula-xboq").value = block;
            event.target.form.requestSubmit(event.target);
          });
        }
      });
      document.querySelector("#prod-butn-mula-trib")?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeDepositFunds({
            fundAmount: event.target.form.querySelector("input[name=sum]").value,
            fundToken: event.target.form.querySelector("select[name=tok]").value,
            safeAddress: document.querySelector("#fund-safe-addr").value,
          }).then(([address, xblock, xhash]) => {
            console.log(`contribution successful; view at: ${txnGetURL(xhash)}`);
            document.querySelector("#fund-mula-addr").value = address;
            document.querySelector("#fund-mula-xboq").value = xblock;
            document.querySelector("#fund-mula-xadr").value = xhash;
            event.target.form.requestSubmit(event.target);
          });
        }
      });
      document.querySelector("#prod-butn-bump-done")?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeSignClaim({
            safeAddress: document.querySelector("#fund-safe-addr").value,
            workerAddress: document.querySelector("#fund-safe-work").value,
            fundAmount: event.target.form.querySelector("#fund-mile-cost").value,
            oracleCut: event.target.form.querySelector("#fund-mile-ocut").value,
          }).then(([address, signature, payload]) => {
            event.target.form.querySelector("#fund-mile-sign").value = signature;
            event.target.form.querySelector("#fund-mile-addr").value = address;
            event.target.form.querySelector("#fund-mile-text").value = payload;
            event.target.form.requestSubmit(event.target);
          });
        }
      });
      document.querySelectorAll("#prod-butn-draw-done")
      .forEach(button => button?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeExecClaim({
            safeAddress: document.querySelector("#fund-safe-addr").value,
            oracleAddress: document.querySelector("#fund-safe-orac").value,
            oracleSignature: event.target.form.querySelector("#fund-mile-asig").value,
            fundAmount: event.target.form.querySelector("#fund-mile-atak").value,
            oracleCut: event.target.form.querySelector("#fund-mile-ocut").value,
          }).then(([xblock, xhash]) => {
            console.log(`claim successful; view at: ${txnGetURL(xhash)}`);
            event.target.form.querySelector("#fund-mile-bloq").value = xblock;
            event.target.form.querySelector("#fund-mile-hash").value = xhash;
            event.target.form.querySelector("#fund-mile-amin").value =
              event.target.form.querySelector("#fund-mile-idex").value;
            event.target.form.requestSubmit(event.target);
          });
        }
      }));
      document.querySelectorAll("#prod-butn-bump-dead")
      .forEach(button => button?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeSignRefund({
            safeAddress: document.querySelector("#fund-safe-addr").value,
            safeInitBlock: document.querySelector("#fund-safe-bloq").value,
          }).then(([address, signature, payload]) => {
            document.querySelector("#fund-dead-sign").value = signature;
            document.querySelector("#fund-dead-addr").value = address;
            document.querySelector("#fund-dead-text").value = payload;
            event.target.form.requestSubmit(event.target);
          });
        }
      }));
      document.querySelector("#prod-butn-draw-dead")?.addEventListener("click", (event) => {
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeExecRefund({
            safeAddress: document.querySelector("#fund-safe-addr").value,
            safeInitBlock: document.querySelector("#fund-safe-bloq").value,
            oracleAddress: event.target.form.querySelector("#fund-mile-awho").value,
            oracleSignature: event.target.form.querySelector("#fund-mile-asig").value,
          }).then(([xblock, xhash]) => {
            console.log(`refund successful; view at: ${txnGetURL(xhash)}`);
            event.target.form.querySelector("#fund-mile-bloq").value = xblock;
            event.target.form.querySelector("#fund-mile-hash").value = xhash;
            event.target.form.requestSubmit(event.target);
          });
        }
      });
      document.querySelectorAll("#prod-butn-wipe-casi")
      .forEach(button => button?.addEventListener("click", (event) => {
        // wipe-casi: wipe to cl(aim) si(gn)
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeSignClaim({
            safeAddress: document.querySelector("#fund-safe-addr").value,
            workerAddress: document.querySelector("#fund-safe-work").value,
            fundAmount: event.target.form.querySelector("#fund-mile-cost").value,
            oracleCut: event.target.form.querySelector("#fund-mile-ocut").value,
          }).then(([address, signature, payload]) => {
            event.target.form.querySelector("#fund-mile-sign").value = signature;
            event.target.form.querySelector("#fund-mile-addr").value = address;
            event.target.form.querySelector("#fund-mile-text").value = payload;
            event.target.form.querySelector("#fund-mile-amin").value =
              event.target.form.querySelector("#fund-mile-idex").value;
            event.target.form.requestSubmit(event.target);
          });
        }
      }));
      document.querySelectorAll("#prod-butn-wipe-cade")
      .forEach(button => button?.addEventListener("click", (event) => {
        // wipe-cade: wipe to cl(aim) de(lete)
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          event.target.form.querySelector("#fund-mile-amin").value =
            event.target.form.querySelector("#fund-mile-idex").value;
          event.target.form.requestSubmit(event.target);
        }
      }));
      document.querySelector("#prod-butn-wipe-resi")?.addEventListener("click", (event) => {
        // wipe-resi: wipe to re(fund) si(gn)
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          safeSignRefund({
            safeAddress: document.querySelector("#fund-safe-addr").value,
            safeInitBlock: document.querySelector("#fund-safe-bloq").value,
          }).then(([address, signature, payload]) => {
            event.target.form.querySelector("#fund-mile-sign").value = signature;
            event.target.form.querySelector("#fund-mile-addr").value = address;
            event.target.form.querySelector("#fund-mile-text").value = payload;
            event.target.form.requestSubmit(event.target);
          });
        }
      });
      document.querySelector("#prod-butn-wipe-rede")?.addEventListener("click", (event) => {
        // wipe-rede: wipe to re(fund) de(lete)
        event.preventDefault();
        if (event.target.form.reportValidity()) {
          event.target.form.requestSubmit(event.target);
        }
      });
      '''
    ==
  ==
--
::  VERSION: [0 1 3]
