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
  %^  render:tw  q.byk.bowl  "%fund - dashboard - funder"
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
          ;div(class "")
            ;div(class "text-3xl pt-2")
              ; My Open Pledges
            ==
            ;div(class "m-1 p-4 border-2 border-black rounded-xl")
              ;div(class "flex flex-wrap items-center justify-between")
                ;div(class "flex flex-wrap items-center")
                  ;div(class "text-2xl pr-4")
                    ; Project 1 about a pledge
                  ==
                ==
                ;div(class "flex mx-2 items-center")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-purple-500 text-purple-500 font-medium")
                    ; in-review
                  ==
                ==
              ==
              ;div(class "flex flex-wrap justify-between items-center")
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $100,000
                  ==
                  ; Target
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $40,000
                  ==
                  ; fulfilled
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $10,000
                  ==
                  ; pledged
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $50,000
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "py-1")
                ; This is an ambitious project that transforms a conceptual idea into a ground-breaking solution. We start with a comprehensive understanding of the market and our potential audience, a procedure sustained by rigorous research and meetings. Translating research into innovative designs, we create prototypes that serve as tangible responses to the problem statement. This stage is a symphony of creative thought, iterative improvement, and user-centric design. The heart of the project lies in its development and testing stages, where theoretical designs are converted into a functional product. Rigour, critical analysis, and collaboration guide our teams as they architect the solution. Moving forward, we dive into rigorous testing and refinement to ensure top-tier deliverability. The final leg of the project sees the solution deployed, evaluated, and fine-tuned for prime performance, ensuring it meets user needs and surpasses expectations. Our journey completes with a polished product set to make a remarkable industry impact.
              ==
              ;div(class "")
                ;button(onclick "location.href='/apps/fund/projects/project-1/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; view project →
                ==
              ==
            ==
            ;div(class "text-3xl pt-2")
              ; Projects I Funded
            ==
            ;div(class "m-1 p-4 border-2 border-black rounded-xl")
              ;div(class "flex flex-wrap items-center justify-between")
                ;div(class "flex flex-wrap items-center")
                  ;div(class "text-2xl pr-4")
                    ; Project 2 contribution fulfilled
                  ==
                ==
                ;div(class "flex mx-2 items-center")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-purple-500 text-purple-500 font-medium")
                    ; in-review
                  ==
                ==
              ==
              ;div(class "flex flex-wrap justify-between items-center")
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $100,000
                  ==
                  ; Target
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $40,000
                  ==
                  ; fulfilled
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $10,000
                  ==
                  ; pledged
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $50,000
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "py-1")
                ; This is an ambitious project that transforms a conceptual idea into a ground-breaking solution. We start with a comprehensive understanding of the market and our potential audience, a procedure sustained by rigorous research and meetings. Translating research into innovative designs, we create prototypes that serve as tangible responses to the problem statement. This stage is a symphony of creative thought, iterative improvement, and user-centric design. The heart of the project lies in its development and testing stages, where theoretical designs are converted into a functional product. Rigour, critical analysis, and collaboration guide our teams as they architect the solution. Moving forward, we dive into rigorous testing and refinement to ensure top-tier deliverability. The final leg of the project sees the solution deployed, evaluated, and fine-tuned for prime performance, ensuring it meets user needs and surpasses expectations. Our journey completes with a polished product set to make a remarkable industry impact.
              ==
              ;div(class "")
                ;button(onclick "location.href='/apps/fund/projects/project-2/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; view project →
                ==
              ==
            ==
            ;div(class "text-3xl pt-2")
              ; Projects from %pals
            ==
            ;div(class "m-1 p-4 border-2 border-black rounded-xl")
              ;div(class "flex flex-wrap items-center justify-between")
                ;div(class "flex flex-wrap items-center")
                  ;div(class "text-2xl pr-4")
                    ; Project 3 Work In-Progress
                  ==
                ==
                ;div(class "flex mx-2 items-center")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-blue-500 text-blue-500 font-medium")
                    ; in-progress
                  ==
                ==
              ==
              ;div(class "flex flex-wrap justify-between items-center")
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $100,000
                  ==
                  ; Target
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $40,000
                  ==
                  ; fulfilled
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $10,000
                  ==
                  ; pledged
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $0
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "py-1")
                ; This is a project description. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone.
              ==
              ;div(class "")
                ;button(onclick "location.href='/apps/fund/projects/project-3/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; view project →
                ==
              ==
            ==
            ;div(class "m-1 p-4 border-2 border-black rounded-xl")
              ;div(class "flex flex-wrap items-center justify-between")
                ;div(class "flex flex-wrap items-center")
                  ;div(class "text-2xl pr-4")
                    ; Project 5 Assessor Review
                  ==
                ==
                ;div(class "flex mx-2 items-center")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-purple-500 text-purple-500 font-medium")
                    ; in-review
                  ==
                ==
              ==
              ;div(class "flex flex-wrap justify-between items-center")
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $100,000
                  ==
                  ; Target
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $60,000
                  ==
                  ; fulfilled
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $10,000
                  ==
                  ; pledged
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $0
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "py-1")
                ; This is a project description. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone.
              ==
              ;div(class "")
                ;button(onclick "location.href='/apps/fund/projects/project-5/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; view project →
                ==
              ==
            ==
            ;div(class "m-1 p-4 border-2 border-black rounded-xl")
              ;div(class "flex flex-wrap items-center justify-between")
                ;div(class "flex flex-wrap items-center")
                  ;div(class "text-2xl pr-4")
                    ; Project 7 fully completed
                  ==
                ==
                ;div(class "flex mx-2 items-center")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-green-500 text-green-500 font-medium")
                    ; completed
                  ==
                ==
              ==
              ;div(class "flex flex-wrap justify-between items-center")
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $100,000
                  ==
                  ; Target
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $100,000
                  ==
                  ; fulfilled
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $0
                  ==
                  ; pledged
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $0
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "py-1")
                ; This is a project description. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone.
              ==
              ;div(class "")
                ;button(onclick "location.href='/apps/fund/projects/project-7/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; view project →
                ==
              ==
            ==
            ;div(class "m-1 p-4 border-2 border-black rounded-xl")
              ;div(class "flex flex-wrap items-center justify-between")
                ;div(class "flex flex-wrap items-center")
                  ;div(class "text-2xl pr-4")
                    ; Project 8 project canceled
                  ==
                ==
                ;div(class "flex mx-2 items-center")
                  ;div(class "text-nowrap py-1 px-2 border-2 rounded-full border-red-500 text-red-500 font-medium")
                    ; canceled
                  ==
                ==
              ==
              ;div(class "flex flex-wrap justify-between items-center")
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $100,000
                  ==
                  ; Target
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $0
                  ==
                  ; fulfilled
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $0
                  ==
                  ; pledged
                ==
                ;div(class "px-2")
                  ;span(class "underline")
                    ; $0
                  ==
                  ; unfunded
                ==
              ==
              ;div(class "py-1")
                ; This is a project description. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone. Bacon ipsum dolor amet shoulder bresaola, frankfurter brisket bacon hamburger tenderloin. Leberkas salami turkey, pork chop boudin tri-tip shankle cow biltong beef ribs ribeye. Pork belly kevin kielbasa, corned beef chicken bresaola sausage tail. Sirloin salami turducken, ham hock biltong filet mignon chicken pork t-bone.
              ==
              ;div(class "")
                ;button(onclick "location.href='/apps/fund/projects/project-8/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; view project →
                ==
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