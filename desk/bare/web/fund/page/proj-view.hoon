::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder, s=server
^-  pag-now:f
::
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  =/  rex=(map @t bean)  (malt ~[['act' &] ['sum' |] ['tok' |] ['who' |] ['msg' |]])
  ?+  arz=(parz:fh bod rex)  p.arz  [%| *]
    =+  act=(~(got by p.arz) 'act')
    ::  FIXME: This check is actually a bit redundant b/c it's checked
    ::  again in `po-push:po-core` (see proj-edit.hoon for details).
    ?.  ?=(?(%bump-born %bump-prop %bump-work %bump-sess %bump-done %bump-dead %mula-plej %mula-trib) act)
      (crip "bad act; expected (bump-*|mula), not {(trip act)}")
    ?.  (~(has by proz.dat) lag)
      (crip "bad act={<act>}; project doesn't exist: {<lag>}")
    ::  TODO: fill in actual `bil` values based on passed POST
    ::  arguments (forwarded from MetaMask)
    ;;  act-now:f  %-  turn  :_  |=(p=prod:f [lag p])  ^-  (list prod:f)
    ?-  act
      %bump-born  [%bump %born ~]~
      %bump-prop  [%bump %prop `*bill:f]~
      %bump-work  [%bump %work ~]~
      %bump-sess  [%bump %sess ~]~
      %bump-done  [%bump %done `*bill:f]~
      %bump-dead  [%bump %dead ~]~
    ::
        *  ::  mula-*
      =/  who=(unit @p)  (slaw %p (~(got by p.arz) 'who'))
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
  ?.  gud  [%code 422 txt]
  ::  Go back to the base project page
  [%next (crip (aurl:fh /dashboard/worker)) '']
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  ::  TODO: Gate users `!=(our.bol src.bol)` to only my projects?
  ?~  pre=(~(get by (prez-ours:sss:f bol dat)) lag)  [%code 404 '']
  =*  pro  -.u.pre
  =/  sat=stat:f  ~(stat pj:f pro)
  =/  roz=(set role:f)  (~(rols pj:f pro) p.lag src.bol)
  =/  [fin=@ mile:f]  ~(next-fill pj:f pro)
  =/  [sin=@ mile:f]  ~(next-stat pj:f pro)
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "{(trip title.pro)}"
  ;form#maincontent(method "post", autocomplete "off", class "p-2")
    ;div(class "flex flex-wrap items-center justify-between")
      ;div(class "text-4xl sm:text-5xl"): {(trip title.pro)}
      ;div(class "flex items-center gap-x-2")
        ;div(class "text-2xl font-medium")
          ; Funding Goal:
          ;span#proj-cost: ${(mony:dump:fh ~(cost pj:f pro))}
        ==
        ;+  (stat-pill:htmx:fh sat)
      ==
    ==
    ;*  ?~  image.pro  ~  :_  ~
        ;img@"{(trip u.image.pro)}"(class "w-full my-2");
    ;div(class "lg:flex lg:justify-between")
      ;div(class "lg:flex-1 sm:gap-x-10")
        ;div(class "flex justify-between mx-auto sm:justify-normal sm:gap-x-16")
          ;div(class "my-1 py-1 justify-normal items items-center gap-x-4")
            ;div(class "text-sm font-light underline"): project worker
            ;div(class "items-center gap-x-2")
              ;div(class "mx-1 mb-2 text-lg font-mono text-nowrap"): {(scow %p p.lag)}
              ;+  ?.  (~(has in roz) %work)
                    ;a.fund-butn-link/"{(curl:fh p.lag)}"(target "_blank"): send message →
                  ?:  ?=(?(%born %prop) sat)
                    ;a.fund-butn-link/"{(aurl:fh (snoc pat %edit))}": edit project →
                  ?.  ?=(?(%done %dead) sat)
                    (prod-butn:htmx:fh %bump-dead %red "cancel project ✗")
                  ;div;
            ==
          ==
          ;div(class "m-1 p-1 justify-normal items items-center gap-x-4")
            ;div(class "text-sm font-light underline"): escrow assessor
            ;div(class "items-center gap-x-2")
              ;div(class "mx-1 mb-2 text-lg font-mono text-nowrap"): {(scow %p p.assessment.pro)}
              ;+  ?.  (~(has in roz) %sess)
                    ;a.fund-butn-link/"{(curl:fh p.assessment.pro)}"(target "_blank"): send message →
                  ?.  ?=(?(%born %prop %done %dead) sat)
                    (prod-butn:htmx:fh %bump-dead %red "cancel project ✗")
                  ;div;
            ==
          ==
        ==
        ;div(class "my-1 mx-3 p-1 whitespace-normal sm:text-lg"): {(trip summary.pro)}
      ==
      ;*  ?:  ?=(?(%born %done %dead) sat)  ~  :_  ~
          ;div(class "m-2 p-2 border-2 border-black rounded-xl lg:w-1/4")
            ;+  ?-  sat
                %prop
              ;div
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
                  ;+  (prod-butn:htmx:fh %bump-born %black "decline ~")
                  ;+  (prod-butn:htmx:fh %bump-prop %green "accept ✓")
                ==
              ==
            ::
                *
              ;div
                ;div(class "p-2 text-3xl w-full"): Contribute
                ;div(class "flex gap-2")
                  ;div(class "fund-form-group")
                    ;label(for "sum"): amount ($)
                    ;input.p-2(name "sum", type "number", min ".01", step ".01", placeholder "5");
                  ==
                  ;div(class "fund-form-group")
                    ;label(for "tok"): token
                    ;select.p-2(name "tok")
                      ;option(value "usdc"): USDC
                      ;option(value "usdt"): USDT
                      ;option(value "dai"): DAI
                    ==
                  ==
                ==
                ;div(class "fund-form-group")
                  ;label(for "who"): contributor
                  ;+  :_  ~  :-  %input
                      ;:  welp
                          ?.((auth:fh bol) ~ ~[[%readonly ~] [%value (scow %p src.bol)]])
                          [%type "text"]~
                          [%name "who"]~
                          [%placeholder "~sampel-palnet"]~
                          [%class "p-2"]~
                      ==
                ==
                ;div(class "fund-form-group")
                  ;label(for "msg"): message
                  ;input.p-2(name "msg", type "text", placeholder "awesome work!");
                ==
                ;div(class "p-2 flex justify-end gap-x-2")
                  ;+  (prod-butn:htmx:fh %mula-plej %black "pledge only ~")
                  ;+  (prod-butn:htmx:fh %mula-trib %green "send funds ✓")
                ==
              ==
            ==
          ==
    ==
    ;div
      ;div(class "text-3xl pt-2"): Contribution Tracker
      ;div(class "flex flex-col gap-2")
        ;div(class "flex justify-between")
          ;div(class "flex gap-2")
            ::  TODO: Need to fill in actual values here (only say
            ::  milestone `fin` is done if it has surpassed fulfilled
            ::  (pledged?) funding).
            ; Milestone Progress
            ;span(class "font-medium"): ?/{<(lent milestones.pro)>}
          ==
          ;div(class "flex gap-2")
            ; Goal
            ;span(class "font-medium"): ${(mony:dump:fh ~(cost pj:f pro))}
          ==
        ==
        ;+  (mula-ther:htmx:fh .0 ~(fill pj:f pro) ~(plej pj:f pro))
      ==
    ==
    ;div
      ;div(class "text-3xl pt-2"): Milestone Overview
      ;*  =/  fiz=(list @rs)  ~(film pj:f pro)
          %+  turn  (enum:fx `(list mile:f)`milestones.pro)
          |=  [pin=@ mil=mile:f]
          ^-  manx
          ;div(class "my-4 p-2 lg:p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap justify-between items-center gap-2")
              ;div(class "sm:text-nowrap text-2xl"): Milestone {<+(pin)>}: {(trip title.mil)}
              ;+  (stat-pill:htmx:fh status.mil)
            ==
            ::  TODO: Fill in pledge amount based on project total
            ;+  (mula-ther:htmx:fh cost.mil (snag pin fiz) .0)
            ; {(trip summary.mil)}
            ;div(class "flex flex-wrap items-center justify-end pt-2 gap-2")
              ;*  ;:  welp
                  ?.  &(|((lth pin sin) =(%done sat)) (~(has in roz) %work))  ~
                ::  TODO: Make this button do something
                :_  ~  ;button.fund-butn-green: withdraw funds ✓
              ::
                  ?.  &(=(pin sin) (~(has in roz) %work) ?=(%lock sat))  ~
                :_  ~  (prod-butn:htmx:fh %bump-work %black "mark in-progress ~")
              ::
                  ?.  &(=(pin sin) (~(has in roz) %work) ?=(%work sat))  ~
                :_  ~  (prod-butn:htmx:fh %bump-sess %black "request review ~")
              ::
                  ?.  &(=(pin sin) (~(has in roz) %sess) ?=(%sess sat))  ~
                :~  ;a.fund-butn-link/"{(curl:fh p.lag)}": message worker →
                    (prod-butn:htmx:fh %bump-work %black "changes required ~")
                    (prod-butn:htmx:fh %bump-done %green "approve ✓")
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
          =/  [wat=tape who=tape cas=tape]
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
                ;div(class "text-nowrap py-1 px-2 border-2 rounded-full font-medium {cas}"): {wat}
              ==
            ==
          ==
    ==
  ==
--
