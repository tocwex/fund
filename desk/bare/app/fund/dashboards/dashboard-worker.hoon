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
  %^  render:tw  bowl  "%fund - dashboard - worker"
  :~  ;div(id "maincontent", class "mx-auto lg:px-4")
        ;div(class "")
          ;div(class "flex justify-between")
            ;div(class "text-3xl pt-2")
              ; My Draft Proposals
            ==
            ;div(class "px-4 self-center")
              ;button(onclick "location.href='/apps/fund/project-creation'", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                ; New Project +
              ==
            ==
          ==
          ;div(class "m-1 p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap items-center justify-between")
              ;div(class "flex flex-wrap items-center")
                ;div(class "text-2xl pr-4")
                  ; Project 4 Creation
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
              ;button(onclick "location.href='/apps/fund/projects/project-4/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                ; view project →
              ==
            ==
          ==
          ;div(class "text-3xl pt-2")
            ; My Open Projects
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
          ;div(class "text-3xl pt-2")
            ; My Project Archive
          ==
          ;div(class "italics mx-4 text-gray-600")
            ; No projects found.
          ==
        ==
      ==
  ==
--
