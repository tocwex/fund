::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fx=fund-xtra, fh=fund-http
/+  rudder, s=server
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
+*  pflag  (furl:fh url.request.ord)
    mdesc  "Describe your milestone in detail, such that both project funders and your assessor can understand the work you are doing—and everyone can reasonably agree when it is completed."
    pregx  (trip '(~(([a-z]{3})|([a-z]{6}(-[a-z]{6}){0,3})|([a-z]{6}(-[a-z]{6}){3})--([a-z]{6}(-[a-z]{6}){3})))?')
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  ::  FIXME: This whole function assumes a maximum of 10 milestones for
  ::  the sake of convenience. To fix this:
  ::  - Change `parz:fh` to allow regex arguments, e.g. ['m\dn' |]
  ::  - Generalize logic to handle arbitrary min/max arg specs based on
  ::    the range on continuous valid POST parameters
  ::  FIXME: There are a lot of silent errors embedded in this function,
  ::  which should either be made explicit or at least come with a
  ::  warning (e.g. "unable to parse 'ses' values; bad @p given...")
  =/  rex=(map @t bean)  %-  malt
    %+  weld  ~[['act' &] ['nam' |] ['sum' |] ['pic' |] ['sea' |] ['seo' |]]
    %+  roll  (gulf 0 9)
    |=  [ind=@ acc=(list [@t bean])]
    %+  weld  acc
    (turn ~['n' 's' 'c'] |=(suf=@t [(crip "m{<ind>}{(trip suf)}") |]))
  ?+  arz=(parz:fh bod rex)  p.arz  [%| *]
    =/  lag=flag:f
      ?^  pflag  (need pflag)
      ::  FIXME: Go to next available name if this path is already taken
      ::  by another project (add random number suffix)
      [our.bol (asci:fx (~(got by p.arz) 'nam'))]
    =/  ses=(unit sess:f)  %+  both
      (slaw %p (~(gut by p.arz) 'sea' (scot %p our.bol)))
      (rush (~(gut by p.arz) 'seo' '0') royl-rs:so)
    ?+      act=(~(got by p.arz) 'act')
          (crip "bad act; expected (init|bump-*|dead|drop), not {(trip act)}")
        %drop
      ;;(act-now:f [lag %drop ~]~)
    ::
        ?(%dead %bump-born %bump-prop %bump-lock)
      ::  FIXME: This check is actually a bit redundant b/c it's checked
      ::  again in `po-push:po-core`, but we keep it here b/c:
      ::  - `act`s are forwarded cards, which means they're evaluated
      ::    after a successful POST request
      ::  - Even if not all `act`s were forwarded cards, we'd need to
      ::    use poke responses and watch wires when forwarding pokes to
      ::    a remote ship (e.g. assessor poking project on worker ship)
      ::  NOTE: Use `proz.dat` instead of `prez-ours...` because only
      ::  the owner should be able to submit edits to the ship
      ?.  (~(has by proz.dat) lag)
        (crip "bad act={<act>}; project doesn't exist: {<lag>}")
      ;;  act-now:f  %-  turn  :_  |=(p=prod:f [lag p])  ^-  (list prod:f)
      ?:  ?=(%dead act)  [%bump %dead ~]~
      ::  TODO: fill in actual `oat` values based on passed POST
      ::  arguments (forwarded from MetaMask)
      ::  TODO: when moving to %prop, we should also %init so that the
      ::  most recent form changes are saved when the user attempts to
      ::  send a request
      =+  oat=*oath:f
      ?+  sat=;;(stat:f (rsh [3 5] act))  !!
        %born  [%bump %born ~]~              ::  worker retract/oracle reject
        %prop  [%bump %prop ~]~              ::  worker request
        %lock  [%bump %lock `oat]~           ::  worker finalize
      ==
    ::
        %init
      =-  ;;(act-now:f [lag %init `-]~)
      =+  pro=*proj:f  %_  pro
        title       (~(got by p.arz) 'nam')
        summary     (~(gut by p.arz) 'sum' '')
        assessment  (fall ses [our.bol .0])
      ::
          image
        =+  pic=(~(gut by p.arz) 'pic' '')
        ?~((rush pic auri:de-purl:html) ~ `pic)
      ::
          milestones
        ;;  (lest mile:f)
        %+  murn  (gulf 0 9)
        |=  ind=@
        ?~  nam=(~(get by p.arz) (crip "m{<ind>}n"))  ~
        :-  ~  =+  mil=*mile:f  %_  mil
          title    u.nam
          summary  (~(gut by p.arz) (crip "m{<ind>}s") '')
          cost     (fall (rush (~(gut by p.arz) (crip "m{<ind>}c") '') royl-rs:so) .0)
        ==
      ==
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  ::  TODO: Redirect to the actual project page page when it's ready
  ::  (given that we forward cards, how do we determine this? perhaps we
  ::  need to eargerly apply these cards?)
  ::  TODO: Need to properly redirect based on the kind of action
  ::  performed; going to the worker dashboard is fine when we delete a
  ::  project
  ?.  gud  [%code 422 txt]
  [%next (crip (aurl:fh /dashboard/worker)) '']
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  ::  NOTE: Only the ship owner can access non-project pages
  ?.  =(our.bol src.bol)  [%auth url.request.ord]
  ::  TODO Redirect to base page if this project exists and is in a
  ::  post-%lock status
  =/  pru=(unit prej:f)  ?~(pflag ~ (~(get by (prez-ours:sss:f bol dat)) (need pflag)))
  =/  sat=stat:f  ?~(pru %born ~(stat pj:f -.u.pru))
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "project edit"
  ;form#maincontent(method "post", autocomplete "off", class "p-2")
    ;+  :-  [%fieldset ?:(=(%born sat) ~ [%disabled ~]~)]
    :~  ;div
          ;div(class "flex flex-wrap items-center justify-between")
            ;div(class "text-3xl"): Project Overview
            ;div(class "flex items-center gap-x-2")
              ;div(class "text-xl")
                ; Funding Goal:
                ;span(id "proj-cost"): ${(mony:dump:fh ?~(pru .0 ~(cost pj:f -.u.pru)))}
              ==
              ;+  (stat-pill:htmx:fh sat)
            ==
          ==
          ;div
            ;div(class "flex")
              ;div(class "fund-form-group")
                ;input.p-1  =name  "nam"  =type  "text"  =required  ~
                  =placeholder  "My Awesome Project"
                  =value  (trip ?~(pru '' title.u.pru));
                ;label(for "nam"): project title
              ==
              ;div(class "fund-form-group")
                ;input.p-1  =name  "pic"  =type  "url"
                  =placeholder  "https://example.com/example.png"
                  =value  (trip (fall ?~(pru ~ image.u.pru) ''));
                ;label(for "pic"): project image
              ==
            ==
            ;div(class "fund-form-group")
              ;div(class "grow-wrap")
                ;textarea.p-1  =name  "sum"  =rows  "3"
                  =placeholder  "Write a worthy description of your project"
                  =value  (trip ?~(pru '' summary.u.pru))
                  ::  FIXME: Ghastly, but needed for auto-grow trick (see fund.css)
                  =oninput  "this.parentNode.dataset.replicatedValue = this.value"
                  ; {(trip ?~(pru '' summary.u.pru))}
                ==
              ==
              ;label(for "sum"): project description
            ==
          ==
        ==
        ;div
          ;div(class "text-3xl pt-2"): Milestones
          ;div(id "mile-welz", class "mx-2")
            ;*  %+  turn  (enum:fx `(list mile:f)`?~(pru *(lest mile:f) milestones.u.pru))
                |=  [min=@ mil=mile:f]
                ^-  manx
                ;div(id "mile-well", class "my-2 p-4 border-2 border-black rounded-xl")
                  ;div(class "flex flex-wrap items-center justify-between")
                    ;div(id "mile-head", class "text-3xl"): Milestone #{<+(min)>}
                    ;+  (stat-pill:htmx:fh status.mil)
                  ==
                  ;div
                    ;div(class "flex")
                      ;div(class "fund-form-group")
                        ;input#mile-name.p-1  =name  "m{<min>}n"  =type  "text"
                          =placeholder  "Give your milestone a title"
                          =value  (trip title.mil);
                        ;label(for "m{<min>}n"): milestone title
                      ==
                      ;div(class "fund-form-group")
                        ;input#mile-cost.p-1  =name  "m{<min>}c"  =type  "number"
                          =placeholder  "0"
                          =value  ?:(=(0 cost.mil) "" (mony:dump:fh cost.mil))
                          =onchange  "updateTotal()";
                        ;label(for "m{<min>}c"): milestone cost ($)
                      ==
                    ==
                    ;div(class "fund-form-group")
                      ;div(class "grow-wrap")
                        ;textarea#mile-summ.p-1  =name  "m{<min>}s"  =rows  "3"
                          =placeholder  mdesc
                          =value  (trip summary.mil)
                          ::  FIXME: Ghastly, but needed for auto-grow trick (see fund.css)
                          =oninput  "this.parentNode.dataset.replicatedValue = this.value"
                          ; {(trip summary.mil)}
                        ==
                      ==
                      ;label(for "m{<min>}s"): milestone description
                    ==
                  ==
                ==
          ==
          ;div(class "flex justify-center mx-auto")
            ;button#mile-butn(class "fund-butn-black"): New Milestone +
          ==
        ==
        ;div
          ;div(class "m-1 pt-2 text-3xl w-full"): Escrow Assessor
          ;div(class "flex")
            ;div(class "fund-form-group")
              ;input.p-1  =name  "sea"  =type  "text"
                =pattern  pregx
                =placeholder  (scow %p our.bol)
                =value  (trip ?~(pru '' (scot %p p.assessment.u.pru)));
              ;label(for "sea"): escrow assessor
            ==
            ;div(class "fund-form-group")
              ;input.p-1  =name  "seo"  =type  "number"
                =min  "0"  =max  "100"  =step  "0.01"
                =placeholder  "0"
                =value  ?~(pru "" (mony:dump:fh q.assessment.u.pru));
              ;label(for "seo"): assessor fee offer (%)
            ==
          ==
        ==
    ==
    ;div(class "flex flex-col gap-y-2 m-1")
      ;div(class "text-3xl w-full"): Confirm & Launch
      ; Please review your proposal in detail and ensure
      ; your assessor is in mutual agreement on expectations
      ; for review of work and release of funds.
      ;div(class "flex w-full justify-center gap-x-2 mx-auto")
        ;*
        |^  ?+  sat  ~[dead-butn drop-butn]
              %born  (murn ~[?~(pru ~ `crow-butn) `init-butn `drop-butn] same)
              %prop  ~[fini-butn croc-butn drop-butn]
            ==
        ++  init-butn  (prod-butn:htmx:fh %init %black "save draft ~" ~)
        ++  crow-butn  (prod-butn:htmx:fh %bump-prop %green "request escrow ✓" ~)
        ++  croc-butn  (prod-butn:htmx:fh %bump-born %black "cancel escrow ~" ~)
        ++  fini-butn
          %-  prod-butn:htmx:fh  :^  %bump-lock  %green  "finalize escrow ✓"
          ?:(&(?=(^ pru) ?=(^ contract.u.pru)) ~ "awaiting response from escrow assessor")
        ++  dead-butn
          %-  prod-butn:htmx:fh  :^   %dead  %red  "discontinue project ✗"
          ?.(?=(%dead sat) ~ "project has already been discontinued")
        ++  drop-butn
          =+  obj=?:(?=(?(%born %prop) sat) "draft" "project")
          (prod-butn:htmx:fh %drop %red "delete {obj} ✗" ~)
        --
      ==
    ==
    ;script
      ;+  ;/  ^~  %-  trip
      '''
      const updateTotal = (event) => {
        const costDivs = document.querySelectorAll("#mile-cost");
        const totalAmount = Array.from(costDivs).reduce((a, n) => a + parseInt(n.value), 0);
        document.querySelector("#proj-cost").innerText = `\$${totalAmount}`;
      };
      '''
    ==
    ;script(type "module")
      ;+  ;/  ^~  %-  trip
      '''
      document.querySelector("#mile-butn").addEventListener("click", (event) => {
        const wellDiv = document.querySelector("#mile-welz");
        const wellClone = document.querySelector("#mile-well").cloneNode(true);
        const wellIndex = wellDiv.childElementCount;
        wellClone.querySelector("#mile-head").innerHTML = `Milestone #${wellIndex + 1}`;
        ["name", "cost", "summ"].forEach(fieldName => {
          const fieldElem = wellClone.querySelector(`#mile-${fieldName}`);
          fieldElem.setAttribute("name", `m${wellIndex}${fieldName.at(0)}`);
          fieldElem.value = "";
        });
        wellDiv.appendChild(wellClone);
      });
      document.querySelectorAll("textarea").forEach(textarea => {
        textarea.parentNode.dataset.replicatedValue = textarea.value;
      });
      '''
    ==
  ==
--
