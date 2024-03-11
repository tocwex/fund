::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fx=fund-xtra, fh=fund-http
/+  rudder, s=server
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
+*  pflag  (furl:fh url.request.ord)
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
        ?(%bump-born %bump-prop %bump-lock %dead %drop)
      ?.  (~(has by proz.dat) lag)
        (crip "bad act={<act>}; project doesn't exist: {<lag>}")
      ;;  act-now:f  %-  turn  :_  |=(p=prod:f [lag p])  ^-  (list prod:f)
      ?-  act
        %dead  [%bump %dead ~]~
        %drop  [%drop ~]~
      ::
          *
        ::  TODO: fill in actual `bil` values based on passed POST
        ::  arguments (forwarded from MetaMask)
        =+  bil=*bill:f
        ?+  sat=;;(stat:f (rsh [3 5] act))  !!
          %born  [%bump %born ~]~                               ::  worker retract/oracle reject
          %lock  [%bump %lock `bil]~                            ::  worker finalize
          %prop  [%bump %prop ?:(=(p.lag our.bol) ~ `bil)]~     ::  worker request/oracle accept
        ==
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
  =/  pru=(unit prej:f)  ?~(pflag ~ (~(get by (prez-ours:sss:f bol dat)) (need pflag)))
  =/  sat=stat:f  ?~(pru %born ~(stat pj:f -.u.pru))
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "project edit"
  ;div(id "maincontent", class "mx-auto lg:px-4")
    ;form(method "post", autocomplete "off")
      ;+  :-  [%fieldset ?:(=(%born sat) ~ ['disabled' ~]~)]
      :~  ;div
            ;div(class "flex flex-wrap items-center justify-between")
              ;div(class "m-1 pt-2 text-3xl"): Project Overview
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
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; project title
                  ==
                  ;input(type "text", name "nam", value "{(trip ?~(pru '' title.u.pru))}", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "My Awesome Project");
                ==
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; project image
                  ==
                  ;input(type "text", name "pic", value "{(trip (fall ?~(pru ~ image.u.pru) ''))}", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "https://example.com/example.png");
                ==
              ==
              ;div(class "m-1 p-1")
                ;div(class "m-1 pt-1 border-black font-light")
                  ; project description
                ==
                ;div(class "grow-wrap")
                  ;textarea(name "sum", rows "3", value "{(trip ?~(pru '' summary.u.pru))}", oninput "this.parentNode.dataset.replicatedValue = this.value", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "Write a worthy description of your project")
                    ; {(trip ?~(pru '' summary.u.pru))}
                  ==
                ==
              ==
            ==
          ==
          ;div
            ;div(class "text-3xl pt-2"): Milestones
            ;div(id "mile-welz", class "mx-2")
              ;*  %+  turn  (enum:fx `(list mile:f)`?~(pru *(lest mile:f) milestones.u.pru))
                  |=  [pin=@ mil=mile:f]
                  ^-  manx
                  ;div(id "mile-well", class "my-2 p-2 border-2 border-black rounded-xl")
                    ;div(class "flex flex-wrap items-center justify-between")
                      ;div(id "mile-head", class "m-1 px-2 text-3xl"): Milestone #{<+(pin)>}
                      ;+  (stat-pill:htmx:fh status.mil)
                    ==
                    ;div
                      ;div(class "flex")
                        ;div(class "m-1 p-1 w-full")
                          ;div(class "m-1 pt-1 border-black font-light")
                            ; milestone title
                          ==
                          ;input(id "mile-name", type "text", name "m{<pin>}n", value "{(trip title.mil)}", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "Give your milestone a title");
                        ==
                        ;div(class "m-1 p-1 w-full")
                          ;div(class "m-1 pt-1 border-black font-light")
                            ; milestone cost ($)
                          ==
                          ;input(id "mile-cost", type "number", name "m{<pin>}c", onchange "updateTotal()", value "{?:(=(0 cost.mil) *tape (mony:dump:fh cost.mil))}", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "0");
                        ==
                      ==
                      ;div(class "m-1 p-1")
                        ;div(class "m-1 pt-1 border-black font-light")
                          ; milestone description
                        ==
                        ;div(class "grow-wrap")
                          ;textarea(id "mile-summ", name "m{<pin>}s", rows "3", value "{(trip summary.mil)}", oninput "this.parentNode.dataset.replicatedValue = this.value", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "describe your milestone in detail, such that both project funders and your assessor can understand the work you are doing—and everyone can reasonably agree when it is completed.")
                            ; {(trip summary.mil)}
                          ==
                        ==
                      ==
                    ==
                  ==
            ==
            ;div(class "flex justify-center mx-auto")
              ;button(id "mile-button", type "button", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                ; New Milestone +
              ==
            ==
          ==
          ;div
            ;div(class "m-1 pt-2 text-3xl w-full")
              ; Escrow Assessor
            ==
            ;div(class "flex")
              ;div(class "m-1 p-1 w-full")
                ;div(class "m-1 pt-1 border-black font-light")
                  ; escrow assessor
                ==
                ;div(class "flex justify-between")
                  ;input(type "text", name "sea", value "{(trip ?~(pru '' (scot %p p.assessment.u.pru)))}", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "{(scow %p our.bol)}");
                ==
              ==
              ;div(class "m-1 p-1 w-full flex items-end")
                ;div(class "mr-1 pr-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; assessor fee offer (%)
                  ==
                  ;div(class "flex")
                    ;input(type "number", name "seo", min "0", max "100", step "0.01", value "{?~(pru *tape (mony:dump:fh q.assessment.u.pru))}", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full disabled:border-gray-400 disabled:bg-gray-400", placeholder "0");
                  ==
                ==
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
          ::  TODO: Implement/refactor flow for assessment acceptance
          ::  (should be on `proj-view` page ultimately instead).
          ::
          ::  ?.  =(our.bol p.assessment.pro)
          |^  ?+  sat  ~[dead-butt drop-butt]
                %dead  ~[drop-butt]
                %born  (weld ?~(pru ~ ~[crow-butt]) ~[init-butt drop-butt])
                ::  TODO: Exclude 'finalize' button if we have no contract
                ::  ?:(|(?=(~ pru) ?=(~ contract.u.pru)) ~ ~[fini-butt])
                %prop  (weld ~[fini-butt] ~[croc-butt drop-butt])
              ==
          ::
          ++  init-butt  (blaq-butt "init" "save draft ~")
          ++  crow-butt  (gren-butt "bump-prop" "request escrow ✓")
          ++  croc-butt  (blaq-butt "bump-born" "cancel escrow ~")
          ++  fini-butt  (gren-butt "bump-lock" "finalize escrow ✓")
          ++  dead-butt  (rhed-butt "dead" "discontinue project ✗")
          ++  drop-butt
            =+  obj=?:(?=(?(%born %prop) sat) "draft" "project")
            (rhed-butt "drop" "delete {obj} ✗")
          ::
          ++  rhed-butt  (cury butt-base "bg-red-600 hover:bg-red-500")
          ++  gren-butt  (cury butt-base "bg-green-600 hover:bg-green-500")
          ++  blaq-butt  (cury butt-base "bg-black hover:bg-gray-800")
          ::
          ++  butt-base
            |=  [cas=tape act=tape txt=tape]
            ^-  manx
            ;button  =type  "submit"  =name  "act"  =value  act
              =class  "text-nowrap px-2 py-1 text-white rounded-md {cas}"
              ; {txt}
            ==
          --
        ==
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
      document.querySelector("#mile-button").addEventListener("click", (event) => {
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
