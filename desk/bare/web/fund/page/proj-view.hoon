::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder, config
%-  dump:preface:fh
%-  init:preface:fh  %-  (proj:preface:fh &)
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  =/  [lag=flag:f pro=prej:f]  (greb:proj:preface:fh hed)
  ?+  arz=(parz:fh bod (sy ~[%act]))  p.arz  [%| *]
    =+  lin=(dec (lent milestones.pro))
    =-  ?@(- - [lag -])
    ^-  $@(@t prod:f)
    ?+    act=(~(got by p.arz) %act)
        (crip "bad act; expected (bump-*|wipe-*|mula-*), not {(trip act)}")
      %bump-born  [%bump %born ~]
      %bump-work  [%bump %work ~]
      %bump-sess  [%bump %sess ~]
      %wipe-rede  [%wipe lin ~]
    ::
        %wipe-cade
      ?+  arz=(parz:fh bod (sy ~[%mii]))  p.arz  [%| *]
        [%wipe (bloq:dejs:format:fh (~(got by p.arz) %mii)) ~]
      ==
    ::
        %wipe-casi
      ?+  arz=(parz:fh bod (sy ~[%mii %mis %mia %mit]))  p.arz  [%| *]
        :+  %wipe  (bloq:dejs:format:fh (~(got by p.arz) %mii))
        :^    ~
            (sign:dejs:format:fh (~(got by p.arz) %mis))
          (addr:dejs:format:fh (~(got by p.arz) %mia))
        [%| (addr:dejs:format:fh (~(got by p.arz) %mit))]
      ==
    ::
        %wipe-resi
      ?+  arz=(parz:fh bod (sy ~[%des %dea %det]))  p.arz  [%| *]
        :+  %wipe  lin
        :^    ~
            (sign:dejs:format:fh (~(got by p.arz) %des))
          (addr:dejs:format:fh (~(got by p.arz) %dea))
        [%| (addr:dejs:format:fh (~(got by p.arz) %det))]
      ==
    ::
        %bump-prop
      ?+  arz=(parz:fh bod (sy ~[%oas %oaa]))  p.arz  [%| *]
        :+  %bump  %prop
        :-  ~  =+  oat=*oath:f  %_  oat
            sigm
          :*  (sign:dejs:format:fh (~(got by p.arz) %oas))
              (addr:dejs:format:fh (~(got by p.arz) %oaa))
              [%& (crip (~(oath pj:f -.pro) p.lag))]
          ==
        ==
      ==
    ::
        %bump-lock
      ?+  arz=(parz:fh bod (sy ~[%sxb %sxa %swa %soa %ssa]))  p.arz  [%| *]
        :+  %bump  %lock  :-  ~
        :*  :-  (bloq:dejs:format:fh (~(got by p.arz) %sxb))
              (addr:dejs:format:fh (~(got by p.arz) %sxa))
            sigm:(need contract.pro)
            (addr:dejs:format:fh (~(got by p.arz) %swa))
            (addr:dejs:format:fh (~(got by p.arz) %soa))
            (addr:dejs:format:fh (~(got by p.arz) %ssa))
        ==
      ==
    ::
        %bump-done
      ?+  arz=(parz:fh bod (sy ~[%mis %mia %mit]))  p.arz  [%| *]
        :+  %bump  %done
        :-  ~  =+  oat=*oath:f  %_  oat
            sigm
          :*  (sign:dejs:format:fh (~(got by p.arz) %mis))
              (addr:dejs:format:fh (~(got by p.arz) %mia))
              [%| (addr:dejs:format:fh (~(got by p.arz) %mit))]
          ==
        ==
      ==
    ::
        %bump-dead
      ?+  arz=(parz:fh bod (sy ~[%des %dea %det]))  p.arz  [%| *]
        :+  %bump  %dead
        :-  ~  =+  oat=*oath:f  %_  oat
            sigm
          :*  (sign:dejs:format:fh (~(got by p.arz) %des))
              (addr:dejs:format:fh (~(got by p.arz) %dea))
              [%| (addr:dejs:format:fh (~(got by p.arz) %det))]
          ==
        ==
      ==
    ::
        %draw-done
      ?+  arz=(parz:fh bod (sy ~[%mii %mib %mih]))  p.arz  [%| *]
        :^  %draw
            (bloq:dejs:format:fh (~(got by p.arz) %mii))
          (bloq:dejs:format:fh (~(got by p.arz) %mib))
        (addr:dejs:format:fh (~(got by p.arz) %mih))
      ==
    ::
        %draw-dead
      ?+  arz=(parz:fh bod (sy ~[%mib %mih]))  p.arz  [%| *]
        :^  %draw
            lin
          (bloq:dejs:format:fh (~(got by p.arz) %mib))
        (addr:dejs:format:fh (~(got by p.arz) %mih))
      ==
    ::
        ?(%mula-plej %mula-trib)
      ?+  arz=(parz:fh bod (sy ~[%mxb %sum %msg]))  p.arz  [%| *]
        =/  who=(unit @p)  ?.((auth:fh bol) ~ `src.bol)
        =/  wen=@ud  (bloq:dejs:format:fh (~(got by p.arz) %mxb))
        =/  sum=@rs  (mony:dejs:format:fh (~(got by p.arz) %sum))
        =/  msg=@t  (~(got by p.arz) %msg)
        ?-  act
          %mula-plej  [%mula %plej (need who) sum wen msg]
        ::
            %mula-trib
          ?+  arz=(parz:fh bod (sy ~[%mxa %mad]))  p.arz  [%| *]
            :*  %mula  %trib  who  sum
                :-  [wen (addr:dejs:format:fh (~(got by p.arz) %mxa))]
                  (addr:dejs:format:fh (~(got by p.arz) %mad))
                msg
            ==
          ==
        ==
      ==
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  =/  [lag=flag:f pyp=@tas]  (gref:proj:preface:fh txt)
  :-  %next  :_  ~
  (desc:enrl:format:fh /next/(scot %p p.lag)/[q.lag]/[?:(=(%mula pyp) %mula %bump)])
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  pat=(list knot)  (slag:derl:format:fh url.request.ord)
  =/  [lag=flag:f pre=prej:f]  (greb:proj:preface:fh arz)
  =*  pro  -.pre
  =/  sat=stat:f  ~(stat pj:f pro)
  ::  NOTE: Gate non-`our` users to my ship's non-draft projects
  ?:  &(!=(our src):bol |(!=(our.bol p.lag) ?=(?(%born %prop) sat)))  [%auth url.request.ord]
  =/  roz=(set role:f)  (~(rols pj:f pro) p.lag src.bol)
  =+  wok=(~(has in roz) %work)
  =+  ora=(~(has in roz) %orac)
  =+  arb==(!<(@p (slot:config %point)) src.bol)
  =+  [tym=|(wok ora) pyr=|(wok ora arb)]
  =/  pod=odit:f  ~(odit pj:f pro)
  =/  moz=(list odit:f)  ~(odim pj:f pro)
  =/  [nin=@ mile:f]  ~(next pj:f pro)
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  (trip title.pro)
  ;div#maincontent.p-2(x-data "proj_view")
    ;div(class "flex flex-wrap items-center justify-between")
      ;div(class "text-4xl sm:text-5xl"): {(trip title.pro)}
      ;div(class "flex items-center gap-x-2")
        ;div(class "text-2xl font-medium")
          ; Goal
          ;span: ${(mony:enjs:format:fh cost.pod)}
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
            ;+  ?:  !=(our.bol src.bol)  ;div;
                ?.  wok
                  ;a.fund-butn-link/"{(chat:enrl:format:fh p.lag)}"(target "_blank"): send message →
                ?:  ?=(?(%born %prop) sat)
                  ;a.fund-butn-link/"{(dest:enrl:format:fh (snoc pat %edit))}": edit project →
                ?.  ?=(?(%done %dead) sat)
                  (prod-butn:htmx:fh %bump-dead %red "cancel project ✗" "cancelContract" ~)
                ;div;
          ==
          ;div(class "flex flex-col justify-normal p-1 gap-0.5")
            ;div(class "text-sm font-light underline"): trusted oracle
            ;div(class "px-1 text-lg font-mono text-nowrap"): {(scow %p p.assessment.pro)}
            ;+  ?:  !=(our.bol src.bol)  ;div;
                ?:  &(wok ?=(%prop sat))
                  %:  prod-butn:htmx:fh
                      %bump-lock  %green  "finalize oracle ✓"  "finalizeContract"
                      ?:(?=(^ contract.pro) ~ "awaiting response from trusted oracle")
                  ==
                ?:  &(ora ?!(?=(?(%born %prop %done %dead) sat)))
                  (prod-butn:htmx:fh %bump-dead %red "cancel project ✗" "cancelContract" ~)
                ?:  !ora
                  ;a.fund-butn-link/"{(chat:enrl:format:fh p.assessment.pro)}"(target "_blank"): send message →
                ;div;
          ==
        ==
        ;div(class "fund-mark p-2 sm:text-lg", x-html "DOMPurify.sanitize(marked.parse(proj_desc))");
        ;*  ?:  ?=(?(%born %prop) sat)  ~
            :_  ~  (copy-butn:htmx:fh "share 🔗")
      ==
      ;*  ?:  ?=(?(%born %done %dead) sat)  ~
          =+  cas="m-2 p-2 border-2 border-black rounded-xl lg:w-1/4"
          ?.  ?=(%prop sat)  ::  contribute aside form
            :_  ~
            ;form(method "post", autocomplete "off", class cas)
              ;div(class "p-2 text-3xl w-full")
                ;+  ?~  pej=(~(get by pledges.pro) src.bol)
                      ;span: Contribute
                    ;span: Fulfill Pledge
              ==
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
                          ~[[%readonly ~] [%value (mony:enjs:format:fh cash.u.pej)]]
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
                ;label(for "msg"): public message
              ==
              ;div(class "p-2 flex justify-end gap-x-2")
                ;+  %:  prod-butn:htmx:fh
                        %mula-plej  %black  "pledge only ~"  "plejFunds"
                        ?.  &((auth:fh bol) (plan:fx src.bol))
                          "pledges only available to authenticated planets"
                        ?:  (~(has by pledges.pro) src.bol)
                          "you must fulfill your outstanding pledge"
                        ~
                    ==
                ;+  (prod-butn:htmx:fh %mula-trib %green "send funds ✓" "sendFunds" ~)
              ==
            ==
          ?:  &((~(has in roz) %orac) ?=(~ contract.pro))  ::  oracle acceptance form
            :_  ~
            ;form(method "post", class cas)
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
                  ;span(class "font-medium"): {(mony:enjs:format:fh q.assessment.pro)}%
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
                ;+  (prod-butn:htmx:fh %bump-born %black "decline ~" ~ ~)
                ;+  (prod-butn:htmx:fh %bump-prop %green "accept ✓" "acceptContract" ~)
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
            ;span(class "font-medium"): ${(mony:enjs:format:fh cost.pod)}
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
          ;form(method "post", class "flex flex-col gap-y-2 my-4 p-2 lg:p-4 border-2 border-black rounded-xl", x-data "\{ mile_idex: {<min>} }")
            ;div(class "flex flex-wrap justify-between items-center gap-2")
              ;div(class "sm:text-nowrap text-2xl"): Milestone {<+(min)>}: {(trip title.mil)}
              ;div(class "flex items-center gap-x-2")
                ;div(class "text-lg")
                  ; Goal
                  ;span: ${(mony:enjs:format:fh cost.mil)}
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
                    :_  ~  (prod-butn:htmx:fh %bump-work %black "mark in-progress ~" ~ ~)
                  ::
                      ?.  &(cur wok ?=(%work status.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %bump-sess %black "request review ~" ~ ~)
                  ::
                      ?.  &(cur ora ?=(%sess status.mil))  ~
                    :~  ;a.fund-butn-link/"{(chat:enrl:format:fh p.lag)}"(target "_blank"): message worker →
                        (prod-butn:htmx:fh %bump-work %black "changes required ~" ~ ~)
                        (prod-butn:htmx:fh %bump-done %green "approve ✓" "approveMilestone" ~)
                    ==
                  ::
                  ::
                      ?.  &(dun ora ?=(%done status.mil) ?=(~ withdrawal.mil))  ~
                    :~  ;a.fund-butn-link/"{(chat:enrl:format:fh p.lag)}"(target "_blank"): message worker →
                        (prod-butn:htmx:fh %wipe-casi %green "reapprove ✓" "approveMilestone" ~)
                    ==
                  ::
                      ?.  &(dun tym ?=(%done status.mil) ?=(^ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %wipe-cade %red "clear approval ✗" "clearMilestone" ~)
                  ::
                      ?.  &(dun wok ?=(%done status.mil) ?=(^ withdrawal.mil))  ~
                    :_  ~
                    %:  prod-butn:htmx:fh
                        %draw-done  %green  "claim funds ✓"  "claimMilestone"
                        ?~(xact.u.withdrawal.mil ~ "funds have already been claimed")
                    ==
                  ::
                  ::
                      ?.  &(las pyr ?=(%dead status.mil) ?=(~ withdrawal.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %wipe-resi %green "sign refund ~" "cancelContract" ~)
                  ::
                      ?.  &(las pyr ?=(%dead status.mil) ?=(^ withdrawal.mil) ?=(~ xact.u.withdrawal.mil))  ~
                    :_  ~  (prod-butn:htmx:fh %wipe-rede %red "clear approval ✗" "clearMilestone" ~)
                  ::
                      ?.  &(las pyr ?=(%dead status.mil) ?=(^ withdrawal.mil))  ~
                    :_  ~
                    %:  prod-butn:htmx:fh
                        %draw-dead  %green  "refund funds ✓"  "refundContract"
                        ?~(xact.u.withdrawal.mil ~ "funds have already been refunded")
                    ==
                  ==
            ==
          ==
    ==
    ;div
      ;div(class "text-3xl pt-2"): Project Funders
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
              ;div(class "mx-auto p-1 font-semibold"): ${(mony:enjs:format:fh cash.mul)}
              ;div(class "mx-auto p-1 flex")
                ;div(class "text-nowrap py-1 px-2 border-2 rounded-full font-medium {cas}"): {wut}
              ==
            ==
          ==
    ==
    ;script
      ;+  ;/
      """
      document.addEventListener('alpine:init', () => Alpine.data('proj_view', () => (\{
        proj_oath: `{(turn (~(oath pj:f pro) p.lag) |=(t=@tD ?.(=(t '`') t '\\`')))}`,
        proj_desc: `{(turn (trip summary.pro) |=(t=@tD ?.(=(t '`') t '\\`')))}`,
        safe_addr: '{(addr:enjs:format:fh ?~(contract.pro 0x0 safe.u.contract.pro))}',
        safe_bloq: {(bloq:enjs:format:fh ?~(contract.pro 0 p.xact.u.contract.pro))},
        work_addr: '{(addr:enjs:format:fh ?~(contract.pro 0x0 work.u.contract.pro))}',
        orac_addr: '{(addr:enjs:format:fh ?~(contract.pro 0x0 from.sigm.u.contract.pro))}',
        orac_cut: {(mony:enjs:format:fh q.assessment.pro)},
        mile_fill: [{(roll moz |=([n=odit:f a=tape] (weld a "{(mony:enjs:format:fh fill.n)},")))}],
        mile_whom: [{(roll `(list mile:f)`milestones.pro |=([n=mile:f a=tape] (weld a "{(addr:enjs:format:fh ?~(withdrawal.n *@ux from.sigm.u.withdrawal.n))},")))}],
        mile_sign: [{(roll `(list mile:f)`milestones.pro |=([n=mile:f a=tape] (weld a "'{(sign:enjs:format:fh ?~(withdrawal.n *@ux sign.sigm.u.withdrawal.n))}',")))}],
        mile_take: [{(roll `(list mile:f)`milestones.pro |=([n=mile:f a=tape] (weld a "{(mony:enjs:format:fh ?~(withdrawal.n *@rs cash.u.withdrawal.n))},")))}],
        acceptContract(event) \{
          this.sendForm(event, [], () => (
            this.safeSignDeploy(\{
              projectContent: this.proj_oath,
            }).then(([address, signature]) => (\{
              oas: signature,
              oaa: address,
            }))
          ));
        },
        finalizeContract(event) \{
          this.sendForm(event, [], () => (
            this.safeExecDeploy(\{
              oracleAddress: this.orac_addr,
            }).then(([xblock, xhash, workerAddress, oracleAddress, safeAddress]) => \{
              console.log(`safe creation successful; view at: $\{this.safeGetURL(safeAddress)}`);
              return \{
                sxb: xblock,
                sxa: xhash,
                swa: workerAddress,
                soa: oracleAddress,
                ssa: safeAddress,
              };
            })
          ));
        },
        plejFunds(event) \{
          this.sendForm(event, [], () => (
            this.safeGetBlock().then((block) => (\{mxb: block}))
          ));
        },
        sendFunds(event) \{
          this.sendForm(event, [], () => (
            this.safeExecDeposit(\{
              safeAddress: this.safe_addr,
              fundAmount: event.target.form.querySelector("[name=sum]").value,
              fundToken: event.target.form.querySelector("[name=tok]").value,
            }).then(([address, xblock, xhash]) => \{
              console.log(`contribution successful; view at: $\{this.txnGetURL(xhash)}`);
              return \{
                mad: address,
                mxb: xblock,
                mxa: xhash,
              };
            })
          ));
        },
        approveMilestone(event) \{
          this.sendForm(event, [() => this.checkWallet([this.orac_addr], "oracle")], () => (
            this.safeSignClaim(\{
              safeAddress: this.safe_addr,
              workerAddress: this.work_addr,
              oracleCut: this.orac_cut,
              fundAmount: this.mile_fill[this.mile_idex],
            }).then(([address, signature, payload]) => (\{
              mii: this.mile_idex,
              mia: address,
              mis: signature,
              mit: payload,
            }))
          ));
        },
        clearMilestone(event) \{
          this.sendForm(event, [], () => (
            Promise.resolve(\{mii: this.mile_idex})
          ));
        },
        claimMilestone(event) \{
          this.sendForm(event, [() => this.checkWallet([this.work_addr], "worker")], () => (
            this.safeExecClaim(\{
              safeAddress: this.safe_addr,
              fundAmount: this.mile_take[this.mile_idex],
              oracleSignature: this.mile_sign[this.mile_idex],
              oracleAddress: this.orac_addr,
              oracleCut: this.orac_cut,
            }).then(([xblock, xhash]) => \{
              console.log(`claim successful; view at: $\{this.txnGetURL(xhash)}`);
              return \{
                mii: this.mile_idex,
                mib: xblock,
                mih: xhash,
              };
            })
          ));
        },
        cancelContract(event) \{
          this.sendForm(event,
            [() => this.checkWallet([this.work_addr, this.orac_addr], "worker/oracle")],
            () => (
              this.safeSignRefund(\{
                safeAddress: this.safe_addr,
                safeInitBlock: this.safe_bloq,
              }).then(([address, signature, payload]) => (\{
                des: signature,
                dea: address,
                det: payload,
              }))
            )
          );
        },
        refundContract(event) \{
          this.sendForm(event,
            // FIXME: Should disallow the prior signer, i.e. `this.mile_whom[this.mile_idex]`
            [() => this.checkWallet([this.work_addr, this.orac_addr], "worker/oracle")],
            () => (
              this.safeExecRefund(\{
                safeAddress: this.safe_addr,
                safeInitBlock: this.safe_bloq,
                oracleAddress: this.mile_whom[this.mile_idex],
                oracleSignature: this.mile_sign[this.mile_idex],
              }).then(([xblock, xhash]) => \{
                console.log(`refund successful; view at: $\{this.txnGetURL(xhash)}`);
                return \{
                  mib: xblock,
                  mih: xhash,
                };
              })
            )
          );
        },
      })));
      """
    ==
  ==
--
::  VERSION: [0 2 1]
