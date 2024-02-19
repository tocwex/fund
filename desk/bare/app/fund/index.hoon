/-  f=fund
/+  rudder, tw=twind, s=server
^-  pag-now:f
|_  [=bowl:gall =order:rudder data=dat-now:f]
++  argue  ::  POST reply
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  ~
++  final  ::  POST render
  |=  [done=? =brief:rudder]
  ^-  reply:rudder
  [%auth '/']
++  build  ::  GET
  |=  [args=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  is-authed=bean
    =+  peers=.^((map ship ?(%alien %known)) /ax/(scot %p our.bowl)//(scot %da now.bowl)/peers)
    ?|  !=((clan:title src.bowl) %pawn)
        (~(has by peers) src.bowl)
    ==
  |^  [%page page]
  ++  page
    %^  render:tw  q.byk.bowl  "%fund"
    :~  ;nav(class "mx-4 mt-1.5 mb-2")
          ;ul(class "pb-2 pt-1 flex justify-between items-center border-black border-b-2")
            ;div(class "")
              ;div(class "mx-2 p-1.5 border-2 rounded-sm border-white ease-in-out hover:text-yellow-500 duration-300 font-medium")
                ;a(href "https://pollensyndicate.com")
                  ; %fund
                ==
              ==
            ==
            ;div(class "flex")
              ::  FIXME: Opening login page in a new tab because opening it
              ::  in the current tab causes issues with further redirects
              ::  (e.g. to the ship login page for eAuth)
              ;div(class "mx-2 p-1.5 border-2 border-white {?:(is-authed "" "ease-in-out hover:italic")}")
                ;+  ?.  is-authed
                    ;a(href "/~/login?redirect=/apps/fund", target "_blank"): login with urbit
                  ;p: logged in as {<src.bowl>}
              ==
              ;button(id "wallet-button", class "mx-2 p-1.5 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-sm");
            ==
          ==
        ==
        ;div(id "maincontent", class "mx-auto px-4")
          ;div(class "text-5xl")
            ; Title Placeholder Text
          ==
          ;div(class "flex")
            ;div(class "no-flex pr-16")
              ;div(class "")
                ;div(class "flex justify-between")
                  ;div(class "flex")
                    ;div(class "text-2xl")
                      ; Funding Goal:
                    ==
                    ;div(class "text-2xl font-medium")
                      ; $50,000
                    ==
                  ==
                  ;div(class "m-1 p-1")
                    ; Project Status:
                  ==
                  ;div(class "flex")
                    ;div(class "pr-2 underline text-gray-500 font-medium")
                      ; Proposed
                    ==
                    ;div(class "pr-2 underline text-orange-500 font-medium")
                      ; Launched
                    ==
                    ;div(class "pr-2 underline text-blue-500 font-medium")
                      ; In-progress
                    ==
                    ;div(class "pr-2 underline text-purple-500 font-medium")
                      ; In-review
                    ==
                    ;div(class "pr-2 underline text-green-500 font-medium")
                      ; Complete
                    ==
                  ==
                ==
                ;div(class "flex items-center");
                ;div(class "m-1 p-1 text-xl")
                  ; Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone.
                ==
              ==
              ;div(class "m-1 p-1 items-center flex")
                ;div(class "m-1 p-1 flex")
                  ;div(class "m-1 p-1 text-xl")
                    ; Worker:
                  ==
                  ;div(class "m-1 p-1 text-xl font-medium")
                    ; ~sidnym-ladrut
                  ==
                  ;button(class "mx-2 px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-sm")
                    ; message worker ->
                  ==
                ==
                ;div(class "m-1 p-1 flex")
                  ;div(class "m-1 p-1 text-xl")
                    ; Assessor:
                  ==
                  ;div(class "m-1 p-1 text-xl font-medium")
                    ; ~sarlev-sarsen
                  ==
                  ;button(class "mx-2 px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-sm")
                    ; message assessor ->
                  ==
                ==
              ==
            ==
            ;div(class "m-2 p-2 border-2 border-black rounded-xl")
              ;div(id "Contribute", class "m-1 px-2 text-3xl min-w-[320px]")
                ; Contribute
              ==
              ;div(class "")
                ;div(class "flex")
                  ;div(class "m-1 p-1")
                    ;div(class "m-1 pt-1 border-black font-light")
                      ; amount
                    ==
                    ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "$10,000");
                  ==
                  ;div(class "m-1 p-1")
                    ;div(class "m-1 pt-1 border-black font-light")
                      ; token
                    ==
                    ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "USDC");
                  ==
                ==
                ;div(class "m-1 p-1")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; contributor
                  ==
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "~lagrev-nocfep");
                ==
                ;div(class "m-1 p-1")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; message
                  ==
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "hello ~zod!");
                ==
                ;div(id "contribution-buttons", class "m-1 p-1 flex")
                  ;div(class "m-1 px-2 py-1 border-2 border-yellow-600 rounded-full text-white bg-yellow-600")
                    ; pledge only ->
                  ==
                  ;div(class "m-1 px-2 py-1 border-2 border-green-600 rounded-full text-white bg-green-600")
                    ; send funds ✓
                  ==
                ==
              ==
            ==
          ==
          ;div(class "")
            ;div(class "text-3xl")
              ; Contribution Tracker
            ==
            ;div(class "")
              ;div(class "flex justify-between")
                ;div(class "flex")
                  ;div(class "m-1 p-1")
                    ; Milestones Funded:
                  ==
                  ;div(class "m-1 p-1 font-medium")
                    ; N/M
                  ==
                ==
                ;div(class "flex")
                  ;div(class "m-1 p-1")
                    ; Goal:
                  ==
                  ;div(class "m-1 p-1 font-medium")
                    ; $XX,XXX
                  ==
                ==
              ==
              ;div(class "m-1 p-1 border-2 border-black text-xl")
                ; thermometer placeholder
              ==
              ;div(class "m-1 p-1 flex justify-between")
                ;div(class "m-1 p-1black")
                  ;span(class "underline font-medium")
                    ; $XX,XXX
                  ==
                  ; Paid
                ==
                ;div(class "m-1 p-1black")
                  ;span(class "underline font-medium")
                    ; $XX,XXX
                  ==
                  ; Fulfilled
                ==
                ;div(class "m-1 p-1black")
                  ;span(class "underline font-medium")
                    ; $XX,XXX
                  ==
                  ; Pledged
                ==
                ;div(class "m-1 p-1black")
                  ;span(class "underline font-medium")
                    ; $XX,XXX
                  ==
                  ; Unfunded
                ==
              ==
            ==
          ==
          ;div(class "")
            ;div(class "text-3xl")
              ; Milestone Overview
            ==
            ;div(class "m-1 p-2 border-2 border-black rounded-xl")
              ;div(class "")
                ;div(class "flex justify-between")
                  ;div(class "mx-1 mt-1 px-1")
                    ;div(class "flex")
                      ;div(class "text-2xl")
                        ; milestone title placeholder
                      ==
                      ;div(class "px-8 text-2xl font-light")
                        ; $XX,XXX
                      ==
                      ;div(class "flex items-center")
                        ;div(class "mx-1 px-1")
                          ; Date:
                        ==
                        ;div(class "mx-1 px-1")
                          ; January 1, 2024
                        ==
                      ==
                    ==
                    ;div(class "flex items-center")
                      ;div(class "py-1")
                        ; Work Status:
                      ==
                      ;div(class "flex items-center")
                        ;div(class "m-1 px-2 py-1 underline text-gray-500 font-medium")
                          ; proposed
                        ==
                        ;div(class "m-1 px-2 py-1 underline text-orange-500 font-medium")
                          ; locked
                        ==
                        ;div(class "m-1 px-2 py-1 underline text-blue-500 font-medium")
                          ; in-progress
                        ==
                        ;div(class "m-1 px-2 py-1 underline text-purple-500 font-medium")
                          ; in-review
                        ==
                        ;div(class "m-1 px-2 py-1 underline text-green-500 font-medium")
                          ; complete
                        ==
                      ==
                    ==
                  ==
                  ;div(class "")
                    ;div(class "hidden m-1 flex items-center")
                      ;div(class "mx-2 px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-sm")
                        ; message worker ->
                      ==
                      ;div(class "m-1 px-2 py-1 border-2 border-black bg-black text-white rounded-full")
                        ; changes required
                      ==
                      ;div(class "m-1 px-2 py-1 border-2 border-red-600 bg-red-600 text-white rounded-full")
                        ; reject ✗
                      ==
                      ;div(class "m-1 px-2 py-1 border-2 border-green-600 rounded-full text-white bg-green-600")
                        ; approve ✓
                      ==
                    ==
                    ;div(class "m-1 flex")
                      ;div(class "m-1 px-2 py-1 border-2 border-black bg-black text-white rounded-full")
                        ; mark in-progress
                      ==
                      ;div(class "m-1 px-2 py-1 border-2 border-black bg-black text-white rounded-full")
                        ; request review
                      ==
                      ;div(class "m-1 px-2 py-1 border-2 border-blue-700 bg-blue-700 text-white rounded-full")
                        ; withdrawal funds
                      ==
                      ;div(class "m-1 px-2 py-1 border-2 border-orange-700 bg-orange-700 text-white rounded-full")
                        ; refund contributors
                      ==
                    ==
                  ==
                ==
              ==
              ;div(class "flex justify-between")
                ;div(class "px-1 flex justify-between items-center")
                  ;div(class "px-1")
                    ; Funding Status:
                  ==
                  ;div(class "px-2")
                    ;span(class "underline")
                      ; $XX,XXX
                    ==
                    ; fulfilled
                  ==
                  ;div(class "px-2")
                    ;span(class "underline")
                      ; $XX,XXX
                    ==
                    ; pledged
                  ==
                  ;div(class "px-2")
                    ;span(class "underline")
                      ; $XX,XXX
                    ==
                    ; unfunded
                  ==
                ==
              ==
              ;div(class "m-1 p-1")
                ; Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone.
              ==
            ==
          ==
          ;div(class "")
            ;div(class "text-3xl")
              ; Proposal Funders
            ==
            ;div(class "m-1 p-2 border-2 border-black flex items-center justify-between")
              ;div(class "m-1 p-1")
                ; ~bidtex-sanrep
              ==
              ;div(class "m-1 p-1")
                ; contributors message, urbit side only not on-chain
              ==
              ;div(class "m-1 p-1")
                ; $XX,XXX
              ==
              ;div(class "m-1 p-1 flex")
                ;div(class "m-1 px-2 py-1 border-2 border-yellow-500 text-yellow-500 rounded-full")
                  ; pledged
                ==
                ;div(class "m-1 px-2 py-1 border-2 border-green-500 text-green-500 rounded-full")
                  ; funded
                ==
              ==
            ==
          ==
          ;div(class "border-b-2 border-black p-4")
            ; MODALS
          ==
          ;div(class "m-1 p-1 border-2 border-black")
            ; authenticate to pledge
          ==
          ;div(class "m-1 p-1 border-2 border-black")
            ; assessor reject milestone and refund
          ==
          ;div(class "m-1 p-1 border-2 border-black")
            ; confirm pledge
          ==
        ==
        ;footer(class "m-4")
          ;div(class "justify-center border-t-2 border-black pt-2 pb-1 lg:flex lg:flex-row-reverse lg:items-center lg:justify-between")
            ;div(class "flex justify-center grow lg:grow-0 lg:justify-end lg:p-2")
              ;div(class "px-10 lg:px-2")
                ;a(href "https://urbit.org/", target "_blank")
                  ;img(type "image/svg+xml", src "/apps/fund/assets/urbit-logo");
                ==
              ==
              ;div(class "px-10 lg:px-2")
                ;a(href "https://twitter.com/pollensyndicate", target "_blank")
                  ;img(type "image/svg+xml", src "/apps/fund/assets/x-logo");
                ==
              ==
              ;div(class "px-10 lg:px-2")
                ;a(href "https://github.com/pollen-syndicate", target "_blank")
                  ;img(type "image/svg+xml", src "/apps/fund/assets/github-logo");
                ==
              ==
            ==
            ;div(class "mb-0 mt-2 text-center text-xs lg:text-base lg:m-0 lg:p-1 lg:pb-2")
              ;div(class "justify-center flex flex-row items-center lg:justify-start lg:px-3")
                ; nurtured by ~pollen.syndicate
              ==
            ==
          ==
        ==
    ==
  --
--
