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
  %^  render:tw  bowl  "%fund - dashboard - assessor"
  :~  ;div(id "maincontent", class "mx-auto lg:px-4")
        ;div(class "")
          ;div(class "text-3xl pt-2")
            ; Requests for My Services
          ==
          ;div(class "m-1 p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap items-center justify-between")
              ;div(class "flex flex-wrap items-center")
                ;div(class "text-2xl pr-4")
                  ; Project 6 Assessor Request
                ==
              ==
              ;div(class "flex mx-2 items-center")
                ;div(class "text-nowrap px-2 py-1 text-gray-500 border-2 border-gray-500 rounded-full font-medium")
                  ; proposed
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
              ;button(onclick "location.href='/apps/fund/projects/project-6/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                ; view project →
              ==
            ==
          ==
          ;div(class "text-3xl pt-2")
            ; My Open Assessment Projects
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
          ;div(class "text-3xl pt-2")
            ; My Assessment Archive
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
--
