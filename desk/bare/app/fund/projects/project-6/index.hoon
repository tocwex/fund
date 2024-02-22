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
  :-  %page
  %^  render:tw  q.byk.bowl  "Project 6 Assessor Request"
  :~  ;div(class "flex-grow")
        ;nav(class "lg:mx-4 mt-1.5 mb-2")
          ;ul(class "py-2 flex justify-between border-black border-b-2")
            ;div(class "mx-2")
              ;button(onclick "javascript:history.back()", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                ; ← back
              ==
            ==
            ;div(class "flex gap-x-2 mx-2")
              ;button(id "connect-wallet", onclick "connect()", class "cursor-pointer text-nowrap px-2 py-1 border-2 duration-300 border-black bg-black text-white hover:text-black rounded-md hover:rounded-lg hover:bg-white hover:border-gray-800 active:bg-gray-800 active:border-black active:text-white")
                ; connect wallet
              ==
            ==
          ==
        ==
        ;div(id "maincontent", class "mx-auto lg:px-4")
          ;div(id "maincontent", class "mx-auto")
            ;div(class "px-4 text-4xl sm:text-5xl")
              ; Project 6 Assessor Request
            ==
            ;div(class "px-4 flex items-center text-nowrap")
              ;div(class "my-1 py-1 text-xl")
                ; Project Status:
              ==
              ;div(class "flex text-nowrap px-2")
                ;div(class "text-nowrap px-2 py-1 text-gray-500 border-2 border-gray-500 rounded-full font-medium")
                  ; proposed
                ==
              ==
            ==
            ;img(type "image/svg+xml", src "/apps/fund/assets/2024", alt "~syndicate", class "mx-auto w-full my-2 sm:px-4");
            ;div(class "lg:flex")
              ;div(class "no-flex sm:gap-x-10")
                ;div(class "")
                  ;div(class "mx-auto flex px-4 justify-between sm:justify-normal sm:gap-x-16")
                    ;div(class "my-1 py-1 justify-normal items items-center gap-x-4")
                      ;div(class "text-sm font-light underline")
                        ; project worker
                      ==
                      ;div(class "items-center gap-x-2")
                        ;div(class "mx-1 text-lg font-mono text-nowrap")
                          ; ~sampel-palnet
                        ==
                        ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                          ; send message →
                        ==
                      ==
                    ==
                    ;div(class "m-1 p-1 justify-normal items items-center gap-x-4")
                      ;div(class "text-sm font-light underline")
                        ; escrow assessor
                      ==
                      ;div(class "items-center gap-x-2")
                        ;div(class "mx-1 text-lg font-mono text-nowrap")
                          ; ~sarlev-sarsen
                        ==
                        ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                          ; send message →
                        ==
                      ==
                    ==
                  ==
                  ;div(class "my-1 mx-3 p-1 whitespace-normal sm:text-lg")
                    ; This is a project description. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone.
                  ==
                ==
              ==
              ;div(class "m-2 p-2 justify-end bg-white rounded-lg")
                ;div(class "flex my-2")
                  ;div(class "text-3xl text-nowrap")
                    ; Funding Goal:
                  ==
                  ;div(class "pl-2 text-3xl font-medium")
                    ; $100,000
                  ==
                ==
                ;div(class "p-2 border-2 border-black rounded-xl")
                  ;div(id "Contribute", class "p-2 text-3xl w-full")
                    ; Review Request
                  ==
                  ;div(class "")
                    ;div(class "gap-2")
                      ;div(class "p-2")
                        ;span(class "font-mono")
                          ; ~sampel-palnet
                        ==
                        ; has requested your services as an escrow assessor for the project Project 6 Assessor Request
                      ==
                      ;div(class "p-2")
                        ; For your services, is offering a fee of:
                      ==
                      ;div(class "m-2 p-2 font-mono bg-gray-300 text-black rounded-md")
                        ; $500 to be paid upon acceptance of the escrow assessor role
                      ==
                      ;div(class "p-2")
                        ; Accepting this review request means that you will have the responsibility to review each project milestone and release funds to the project worker upon successful completion.
                      ==
                      ;div(class "p-2")
                        ; If you pinky promise to fund this project, click the button below to confirm your particpation.
                      ==
                    ==
                    ;div(id "contribution-buttons", class "p-2 flex justify-end gap-x-2")
                      ;button(onclick "location.href='/apps/fund/index.html'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                        ; decline ~
                      ==
                      ;button(onclick "", class "text-nowrap px-2 py-1 border-2 border-green-600 rounded-md text-white bg-green-600 hover:border-green-500 hover:bg-green-500 active:border-green-700 active:bg-green-700")
                        ; accept ✓
                      ==
                    ==
                  ==
                ==
              ==
            ==
            ;div(class "px-4")
              ;div(class "text-3xl pt-2")
                ; Contribution Tracker
              ==
              ;div(class "")
                ;div(class "flex justify-between")
                  ;div(class "flex")
                    ;div(class "m-1 p-1")
                      ; Milestones Funded:
                    ==
                    ;div(class "m-1 p-1 font-medium")
                      ; 0/5
                    ==
                  ==
                  ;div(class "flex")
                    ;div(class "m-1 p-1")
                      ; Goal:
                    ==
                    ;div(class "m-1 p-1 font-medium")
                      ; $100,000
                    ==
                  ==
                ==
                ;div(class "m-1 p-1 border-2 border-black text-xl")
                  ; thermometer placeholder
                ==
                ;div(class "m-1 p-1 flex justify-between")
                  ;div(class "m-1 p-1black")
                    ;span(class "underline font-medium")
                      ; $0
                    ==
                    ; Paid
                  ==
                  ;div(class "m-1 p-1black")
                    ;span(class "underline font-medium")
                      ; $0
                    ==
                    ; Fulfilled
                  ==
                  ;div(class "m-1 p-1black")
                    ;span(class "underline font-medium")
                      ; $0
                    ==
                    ; Pledged
                  ==
                  ;div(class "m-1 p-1black")
                    ;span(class "underline font-medium")
                      ; $0
                    ==
                    ; Unfunded
                  ==
                ==
              ==
            ==
            ;div(class "px-4")
              ;div(class "text-3xl pt-2")
                ; Milestone Overview
              ==
              ;div(class "my-4 p-4 border-2 border-black rounded-xl")
                ;div(class "flex flex-wrap justify-between items-center gap-2")
                  ;div(class "sm:text-nowrap text-2xl")
                    ; Milestone 1: Initiation
                  ==
                  ;div(class "flex justify-between items-center gap-x-4 w-auto")
                    ;div(class "text-xl w-full")
                      ; 2024-01-31
                    ==
                    ;div(class "")
                      ;div(class "text-nowrap px-2 py-1 text-gray-500 border-2 border-gray-500 rounded-full font-medium")
                        ; proposed
                      ==
                    ==
                  ==
                ==
                ;div(class "py-2 grid grid-cols-2 justify-between items-center gap-2 sm:flex")
                  ;div(class "")
                    ;span(class "underline")
                      ; $20,000
                    ==
                    ; Target
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; fulfilled
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; pledged
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; unfunded
                  ==
                ==
                ;div(class "")
                  ; This marks the initiation of our project. We'll be conducting extensive market research and understanding our audience. Key priorities are stakeholder meetings, planning sessions and documenting insights. We'll also be identifying potential threats and opportunities associated with our project. This marks the initiation of our project. We'll be conducting extensive market research and understanding our audience. Key priorities are stakeholder meetings, planning sessions and documenting insights. We'll also be identifying potential threats and opportunities associated with our project.
                ==
                ;div(class "pt-2");
              ==
              ;div(class "my-4 p-4 border-2 border-black rounded-xl")
                ;div(class "flex flex-wrap justify-between items-center gap-2")
                  ;div(class "sm:text-nowrap text-2xl")
                    ; Milestone 2: Design
                  ==
                  ;div(class "flex justify-between items-center gap-x-4 w-auto")
                    ;div(class "text-xl w-full")
                      ; 2024-2-28
                    ==
                    ;div(class "")
                      ;div(class "text-nowrap px-2 py-1 text-gray-500 border-2 border-gray-500 rounded-full font-medium")
                        ; proposed
                      ==
                    ==
                  ==
                ==
                ;div(class "py-2 grid grid-cols-2 justify-between items-center gap-2 sm:flex")
                  ;div(class "")
                    ;span(class "underline")
                      ; $20,000
                    ==
                    ; Target
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; fulfilled
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; pledged
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; unfunded
                  ==
                ==
                ;div(class "")
                  ; Our second milestone moves into the design phase. Drawing from our preliminary research, we'll design prototypes and test their effectiveness. Fine-tuning these models ensure that we fulfill the needs of our targeted audience, while maximizing efficiency and productivity. Our second milestone moves into the design phase. Drawing from our preliminary research, we'll design prototypes and test their effectiveness. Fine-tuning these models ensure that we fulfill the needs of our targeted audience, while maximizing efficiency and productivity.
                ==
                ;div(class "pt-2");
              ==
              ;div(class "my-4 p-4 border-2 border-black rounded-xl")
                ;div(class "flex flex-wrap justify-between items-center gap-2")
                  ;div(class "sm:text-nowrap text-2xl")
                    ; Milestone 3: Development
                  ==
                  ;div(class "flex justify-between items-center gap-x-4 w-auto")
                    ;div(class "text-xl w-full")
                      ; 2024-03-31
                    ==
                    ;div(class "")
                      ;div(class "text-nowrap px-2 py-1 text-gray-500 border-2 border-gray-500 rounded-full font-medium")
                        ; proposed
                      ==
                    ==
                  ==
                ==
                ;div(class "py-2 grid grid-cols-2 justify-between items-center gap-2 sm:flex")
                  ;div(class "")
                    ;span(class "underline")
                      ; $20,000
                    ==
                    ; Target
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; fulfilled
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; pledged
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; unfunded
                  ==
                ==
                ;div(class "")
                  ; This stage is all about development. Our teams will be working to build robust, intuitive, and user-friendly solution. Regular stand-ups and sprint reviews will ensure that we stay on track and align our solutions with customer needs and industry trends. This stage is all about development. Our teams will be working to build robust, intuitive, and user-friendly solution. Regular stand-ups and sprint reviews will ensure that we stay on track and align our solutions with customer needs and industry trends.
                ==
                ;div(class "pt-2");
              ==
              ;div(class "my-4 p-4 border-2 border-black rounded-xl")
                ;div(class "flex flex-wrap justify-between items-center gap-2")
                  ;div(class "sm:text-nowrap text-2xl")
                    ; Milestone 4: Testing & QA
                  ==
                  ;div(class "flex justify-between items-center gap-x-4 w-auto")
                    ;div(class "text-xl w-full")
                      ; 2024-04-30
                    ==
                    ;div(class "")
                      ;div(class "text-nowrap px-2 py-1 text-gray-500 border-2 border-gray-500 rounded-full font-medium")
                        ; proposed
                      ==
                    ==
                  ==
                ==
                ;div(class "py-2 grid grid-cols-2 justify-between items-center gap-2 sm:flex")
                  ;div(class "")
                    ;span(class "underline")
                      ; $20,000
                    ==
                    ; Target
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; fulfilled
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; pledged
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; unfunded
                  ==
                ==
                ;div(class "")
                  ; The fourth milestone marks the testing and refinement phase. Every part of the solution goes through rigorous testing to identify and rectify bugs or issues. We'll be refining our solution based on the test results and feedback collected to ensure top-notch quality. The fourth milestone marks the testing and refinement phase. Every part of the solution goes through rigorous testing to identify and rectify bugs or issues. We'll be refining our solution based on the test results and feedback collected to ensure top-notch quality.
                ==
                ;div(class "pt-2");
              ==
              ;div(class "my-4 p-4 border-2 border-black rounded-xl")
                ;div(class "flex flex-wrap justify-between items-center gap-2")
                  ;div(class "sm:text-nowrap text-2xl")
                    ; Milestone 5: Deployment
                  ==
                  ;div(class "flex justify-between items-center gap-x-4 w-auto")
                    ;div(class "text-xl w-full")
                      ; 2024-05-31
                    ==
                    ;div(class "")
                      ;div(class "text-nowrap px-2 py-1 text-gray-500 border-2 border-gray-500 rounded-full font-medium")
                        ; proposed
                      ==
                    ==
                  ==
                ==
                ;div(class "py-2 grid grid-cols-2 justify-between items-center gap-2 sm:flex")
                  ;div(class "")
                    ;span(class "underline")
                      ; $20,000
                    ==
                    ; Target
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; fulfilled
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; pledged
                  ==
                  ;div(class "")
                    ;span(class "underline")
                      ; $0
                    ==
                    ; unfunded
                  ==
                ==
                ;div(class "")
                  ; The final milestone involves deployment and evaluation. Our solution is rolled out to our customers. We aim to ensure that the project meets or exceeds the performance benchmarks as well as customer expectations. Continuous monitoring even post-deployment ensures mission success. The final milestone involves deployment and evaluation. Our solution is rolled out to our customers. We aim to ensure that the project meets or exceeds the performance benchmarks as well as customer expectations. Continuous monitoring even post-deployment ensures mission success.
                ==
                ;div(class "pt-2");
              ==
            ==
            ;div(class "px-4")
              ;div(class "text-3xl pt-2")
                ; Proposal Funders
              ==
              ;div(class "italics mx-4 text-gray-600")
                ; No contributors found.
              ==
            ==
          ==
        ==
      ==
      ;footer(class "lg:mx-4")
        ;div(class "justify-center border-t-2 border-black pt-2 pb-1 lg:flex lg:flex-row-reverse lg:items-center lg:justify-between")
          ;div(class "flex justify-center grow lg:grow-0 lg:justify-end lg:p-2")
            ;div(class "px-10 lg:px-2")
              ;a(href "https://tlon.network/lure/~tocwex/syndicate-public", target "_blank")
                ;img(type "image/svg+xml", src "/apps/fund/assets/urbit-logo");
              ==
            ==
            ;div(class "px-10 lg:px-2")
              ;a(href "https://twitter.com/tocwex", target "_blank")
                ;img(type "image/svg+xml", src "/apps/fund/assets/x-logo");
              ==
            ==
            ;div(class "px-10 lg:px-2")
              ;a(href "https://github.com/tocwex", target "_blank")
                ;img(type "image/svg+xml", src "/apps/fund/assets/github-logo");
              ==
            ==
          ==
          ;div(class "mb-0 mt-2 text-center text-xs lg:text-base lg:m-0 lg:p-1 lg:pb-2")
            ;div(class "mb-2 lg:mb-0 justify-center flex flex-row items-center lg:justify-start lg:px-3 hover:underline")
              ;a(href "https://tocwexsyndicate.com", target "_blank")
                ; crafted by ~tocwex.syndicate
              ==
            ==
          ==
        ==
      ==
  ==
--