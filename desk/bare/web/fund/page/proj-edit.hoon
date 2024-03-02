::  /web/fund/page/proj-view/hoon: render base page for %fund
::
/+  f=fund, fx=fund-xtra, fh=fund-http
/+  rudder, s=server
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  ::  POST reply
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  ::  TODO: Parse assessment information into [who cut]
  ::  TODO: How will we pass milestone information?
  =+  rex=(malt ~[['nam' &] ['sum' |] ['pic' |] ['miz' |] ['ses' |]])
  ?+  arz=(parz:fh bod rex)  p.arz  [%| *]
    =/  lag=flag:f  [our.bol (asci:fx (~(got by p.arz) 'nam'))]
    ?:  (~(has by proz.dat) lag)  (crip "project already exists: {<lag>}")
    ;;  act-now:f
    %-  turn  :_  |=(p=prod:f `poke:f`[lag p])
    ^-  (list prod:f)
    :~  [%init-proj ~]
        [%edit-proj (~(get by p.arz) 'nam') (~(get by p.arz) 'sum') (~(get by p.arz) 'pic') ~]
    ==
  ==
++  final  ::  POST render
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  ::  TODO: Redirect to the actual project page page when it's ready
  ::  (given that we forward cards, how do we determine this? perhaps we
  ::  need to eargerly apply these cards?)
  ?.  gud  [%code 422 txt]
  [%next (crip (aurl:fh /dashboard/worker)) '']
++  build  ::  GET
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  ::  TODO: Need to inspect path and pre-populate forms if a project exists
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  "project edit"
  ;div(id "maincontent", class "mx-auto lg:px-4")
    ;form(method "post", autocomplete "off")
      ;div
        ;div(class "m-1 pt-2 text-3xl w-full"): Project Overview
        ;div
          ;div(class "m-1 p-1")
            ;div(class "m-1 pt-1 border-black font-light")
              ; project title
            ==
            ;input(type "text", name "nam", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "My Awesome Project");
          ==
          ;div(class "m-1 p-1")
            ;div(class "m-1 pt-1 border-black font-light")
              ; project description
            ==
            ;textarea(name "sum", rows "3", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "Write a worthy description of your project");
          ==
          ;div(class "flex w-full")
            ;div(class "m-1 p-1 w-full")
              ;div(class "m-1 pt-1 border-black font-light")
                ; amount
              ==
              ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "$10,000", disabled "");
            ==
            ;div(class "m-1 p-1 w-full")
              ;div(class "m-1 pt-1 border-black font-light")
                ; project status
              ==
              ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "draft", disabled "");
            ==
          ==
        ==
      ==
      ;div
        ;div(class "flex justify-between")
          ;div(class "text-3xl pt-2")
            ; Milestones
          ==
          ;div(class "px-4 self-center")
            ;button(class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
              ; New Milestone +
            ==
          ==
        ==
        ;div(class "mx-2")
          ;div(class "my-2 p-2 border-2 border-black rounded-xl")
            ;div(class "m-1 px-2 text-3xl w-full")
              ; Milestone #1
            ==
            ;div
              ;div(class "flex")
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; milestone title
                  ==
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "Give your milestone a title");
                ==
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; milestone status
                  ==
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "draft");
                ==
              ==
              ;div(class "flex")
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; delivery estimate
                  ==
                  ;input(type "date", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "MM/DD/YYYY");
                ==
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; amount (USD)
                  ==
                  ;input(type "number", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "10000");
                ==
              ==
              ;div(class "m-1 p-1")
                ;div(class "m-1 pt-1 border-black font-light")
                  ; milestone description
                ==
                ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "describe your milestone in detail, such that both project funders and your assessor can understand the work you are doing—and everyone can reasonably agree when it is completed.");
              ==
            ==
          ==
        ==
        ;div(class "flex justify-center mx-auto")
          ;button(class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
            ; New Milestone +
          ==
        ==
      ==
      ;div
        ;div(class "m-1 pt-2 text-3xl w-full")
          ; Escrow Assessor
        ==
        ;div
          ;div(class "m-1 p-1 w-full")
            ;div(class "m-1 pt-1 border-black font-light")
              ; escrow assessor
            ==
            ;div(class "flex justify-between")
              ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "~tocwex");
              ;div(class "px-4 self-center w-full")
                ;button(class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; send message →
                ==
              ==
            ==
          ==
          ;div(class "m-1 p-1 w-full flex items-end")
            ;div(class "mr-1 pr-1 w-full")
              ;div(class "m-1 pt-1 border-black font-light")
                ; assessor fee offer
              ==
              ;div(class "flex")
                ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "$500");
                ;div(class "px-4 self-center w-full flex")
                  ;button(class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                    ; send request ~
                  ==
                  ;div(class "flex")
                    ;div(class "m-1 pt-1 border-black font-light text-nowrap")
                      ; request status
                    ==
                    ;div(class "justify-center items-center")
                      ;div(class "py-1 px-2 border-2 rounded-full border-red-500 text-red-500 font-medium")
                        ; not sent
                      ==
                    ==
                  ==
                ==
              ==
            ==
          ==
          ;div
            ;div(class "m-1 pt-2 text-3xl w-full")
              ; Confirm & Launch
            ==
            ; Please review your proposal in detail and ensure your assessor
              is in mutual agreement on expectations for review of work and
              release of funds.
            ;div(class "flex w-full justify-center mx-auto")
              ;button(type "submit", name "save", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                ; save draft ~
              ==
              ;button(class "text-nowrap px-2 py-1 border-2 border-red-600 bg-red-600 text-white rounded-md hover:border-red-500 hover:bg-red-500 active:border-red-700 active:bg-red-700")
                ; delete draft ✗
              ==
              ;button(onclick "signMessage()", class "text-nowrap px-2 py-1 border-2 border-green-600 rounded-md text-white bg-green-600 hover:border-green-500 hover:bg-green-500 active:border-green-700 active:bg-green-700")
                ; finalize escrow ✓
              ==
            ==
          ==
        ==
      ==
    ==
  ==
--
