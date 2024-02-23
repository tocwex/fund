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
  %^  render:tw  bowl  "Project 3 Work In-Progress"
  :~  ;div(id "maincontent", class "mx-auto lg:px-4")
        ;div(id "maincontent", class "mx-auto")
          ;div(class "px-4 text-4xl sm:text-5xl")
            ; Project 3 Work In-Progress
          ==
          ;div(class "px-4 flex items-center text-nowrap")
            ;div(class "my-1 py-1 text-xl")
              ; Project Status:
            ==
            ;div(class "flex text-nowrap px-2")
              ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-blue-500 text-blue-500 font-medium")
                ; in-progress
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
                        ; ~sarlev-sarsen
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
                        ; ~sampel-palnet
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
                  ; Contribute
                ==
                ;div(class "")
                  ;div(class "flex gap-2")
                    ;div(class "p-2 w-full")
                      ;div(class "p-1 border-black font-light")
                        ; amount
                      ==
                      ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "$10,000");
                    ==
                    ;div(class "p-2")
                      ;div(class "p-1 border-black font-light")
                        ; token
                      ==
                      ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "USDC");
                    ==
                  ==
                  ;div(class "p-2")
                    ;div(class "p-1 border-black font-light")
                      ; contributor
                    ==
                    ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "~lagrev-nocfep");
                  ==
                  ;div(class "p-2")
                    ;div(class "p-1 border-black font-light")
                      ; message
                    ==
                    ;input(class "p-2 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "hello ~zod!");
                  ==
                  ;div(id "contribution-buttons", class "p-2 flex justify-end gap-x-2")
                    ;button(onclick "location.href='/apps/fund/modals/modal-confirm-pledge-app'", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                      ; pledge only ~
                    ==
                    ;button(onclick "signMessage()", class "text-nowrap px-2 py-1 border-2 border-green-600 rounded-md text-white bg-green-600 hover:border-green-500 hover:bg-green-500 active:border-green-700 active:bg-green-700")
                      ; send funds ✓
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
                    ; 2/5
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
                    ; $20,000
                  ==
                  ; Paid
                ==
                ;div(class "m-1 p-1black")
                  ;span(class "underline font-medium")
                    ; $40,000
                  ==
                  ; Fulfilled
                ==
                ;div(class "m-1 p-1black")
                  ;span(class "underline font-medium")
                    ; $10,000
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
                    ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-green-500 text-green-500 font-medium")
                      ; completed
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
                    ; $20,000
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
              ;div(class "pt-2")
                ;div(class "flex items-center flex-wrap justify-end gap-x-2")
                  ;button(onclick "signMessage()", class "text-nowrap px-2 py-1 border-2 border-green-600 rounded-md text-white bg-green-600 hover:border-green-500 hover:bg-green-500 active:border-green-700 active:bg-green-700")
                    ; withdraw funds ✓
                  ==
                ==
              ==
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
                    ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-blue-500 text-blue-500 font-medium")
                      ; in-progress
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
                    ; $20,000
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
              ;div(class "pt-2")
                ;div(class "flex items-center flex-wrap justify-end gap-x-2")
                  ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                    ; request review ~
                  ==
                  ;button(onclick "location.href='/apps/fund/modals/modal-worker-cancel-project'", class "text-nowrap px-2 py-1 border-2 border-red-600 bg-red-600 text-white rounded-md hover:border-red-500 hover:bg-red-500 active:border-red-700 active:bg-red-700")
                    ; cancel work ✗
                  ==
                ==
              ==
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
                    ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-orange-500 text-orange-500 font-medium")
                      ; launched
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
                    ; $10,000
                  ==
                  ; pledged
                ==
                ;div(class "")
                  ;span(class "underline")
                    ; $10,000
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "")
                ; This stage is all about development. Our teams will be working to build robust, intuitive, and user-friendly solution. Regular stand-ups and sprint reviews will ensure that we stay on track and align our solutions with customer needs and industry trends. This stage is all about development. Our teams will be working to build robust, intuitive, and user-friendly solution. Regular stand-ups and sprint reviews will ensure that we stay on track and align our solutions with customer needs and industry trends.
              ==
              ;div(class "pt-2")
                ;div(class "flex items-center flex-wrap justify-end gap-x-2")
                  ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                    ; mark in-progress ~
                  ==
                ==
              ==
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
                    ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-orange-500 text-orange-500 font-medium")
                      ; launched
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
                    ; $20,000
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "")
                ; The fourth milestone marks the testing and refinement phase. Every part of the solution goes through rigorous testing to identify and rectify bugs or issues. We'll be refining our solution based on the test results and feedback collected to ensure top-notch quality. The fourth milestone marks the testing and refinement phase. Every part of the solution goes through rigorous testing to identify and rectify bugs or issues. We'll be refining our solution based on the test results and feedback collected to ensure top-notch quality.
              ==
              ;div(class "pt-2")
                ;div(class "flex items-center flex-wrap justify-end gap-x-2")
                  ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                    ; mark in-progress ~
                  ==
                ==
              ==
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
                    ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-orange-500 text-orange-500 font-medium")
                      ; launched
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
                    ; $20,000
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "")
                ; The final milestone involves deployment and evaluation. Our solution is rolled out to our customers. We aim to ensure that the project meets or exceeds the performance benchmarks as well as customer expectations. Continuous monitoring even post-deployment ensures mission success. The final milestone involves deployment and evaluation. Our solution is rolled out to our customers. We aim to ensure that the project meets or exceeds the performance benchmarks as well as customer expectations. Continuous monitoring even post-deployment ensures mission success.
              ==
              ;div(class "pt-2")
                ;div(class "flex items-center flex-wrap justify-end gap-x-2")
                  ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                    ; mark in-progress ~
                  ==
                ==
              ==
            ==
          ==
          ;div(class "px-4")
            ;div(class "text-3xl pt-2")
              ; Proposal Funders
            ==
            ;div(class "my-2 p-2 border-2 border-black flex items-center justify-between gap-x-2 rounded-md")
              ;div(class "flex flex-wrap sm:flex-nowrap sm:items-center gap-x-2")
                ;div(class "p-1 font-mono text-nowrap")
                  ; ~sampel-palnet
                ==
                ;div(class "p-1")
                  ; This is a message. It should be pretty short generally.
                ==
              ==
              ;div(class "flex flex-wrap sm:flex-nowrap items-center")
                ;div(class "mx-auto p-1 font-semibold")
                  ; $10,000
                ==
                ;div(class "mx-auto p-1 flex")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-yellow-500 text-yellow-500 font-medium")
                    ; pledged
                  ==
                ==
              ==
            ==
            ;div(class "my-2 p-2 border-2 border-black flex items-center justify-between gap-x-2 rounded-md")
              ;div(class "flex flex-wrap sm:flex-nowrap sm:items-center gap-x-2")
                ;div(class "p-1 font-mono text-nowrap")
                  ; ~sampel-palnet
                ==
                ;div(class "p-1")
                  ; This is a message. It should be pretty short generally.
                ==
              ==
              ;div(class "flex flex-wrap sm:flex-nowrap items-center")
                ;div(class "mx-auto p-1 font-semibold")
                  ; $10,000
                ==
                ;div(class "mx-auto p-1 flex")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-green-500 text-green-500 font-medium")
                    ; funded
                  ==
                ==
              ==
            ==
            ;div(class "my-2 p-2 border-2 border-black flex items-center justify-between gap-x-2 rounded-md")
              ;div(class "flex flex-wrap sm:flex-nowrap sm:items-center gap-x-2")
                ;div(class "p-1 font-mono text-nowrap")
                  ; ~sampel-palnet
                ==
                ;div(class "p-1")
                  ; This is a message. It should be pretty short generally.
                ==
              ==
              ;div(class "flex flex-wrap sm:flex-nowrap items-center")
                ;div(class "mx-auto p-1 font-semibold")
                  ; $30,000
                ==
                ;div(class "mx-auto p-1 flex")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-green-500 text-green-500 font-medium")
                    ; funded
                  ==
                ==
              ==
            ==
          ==
        ==
      ==
  ==
--
