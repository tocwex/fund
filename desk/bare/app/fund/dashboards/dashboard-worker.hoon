/+  f=fund
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
  |^  [%page page]
  ++  page
    =/  my-proz  ~(tap by proz.data)
    %^  render:tw  bowl  "%fund - dashboard - worker"
    :~  ;div(id "maincontent", class "mx-auto lg:px-4")
          ;+  %^  proz  "My Draft Proposals"  &
              (skim my-proz |=([* pro=proj:f] ?=(?(%born %prop) ~(stat pj:f pro))))
          ;+  %^  proz  "My Open Projects"  |
              (skim my-proz |=([* pro=proj:f] ?=(?(%lock %work %sess) ~(stat pj:f pro))))
          ;+  %^  proz  "My Project Archive"  |
              (skim my-proz |=([* pro=proj:f] ?=(?(%dead %done) ~(stat pj:f pro))))
    ==  ==
  ++  proz
    |=  [nam=tape new=bean poz=(list [flag:f proj:f])]
    ^-  manx
    ;div
      ;div(class "flex justify-between")
        ;div(class "text-3xl pt-2")
          ; {nam}
        ==
        ;+  ?.  new  ;div;
            ;div(class "px-4 self-center")
              ;button(onclick "location.href='/apps/fund/project-creation'", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                ; New Project +
              ==
            ==
      ==
      ;*  ?~  poz
              :~  ;div(class "italics mx-4 text-gray-600")
                    ; No projects found.
              ==  ==
          %+  turn  poz
          |=  [[sip=@p nam=@tas] pro=proj:f]
          ^-  manx
          =/  cos=@rs  ~(cost pj:f pro)
          =/  fil=@rs  ~(fill pj:f pro)
          =/  pej=@rs  ~(plej pj:f pro)
          =/  unf=@rs  =+(u=(sub:rs cos (add:rs fil pej)) ?:((gth:rs u .0) u .0))
          ;div(class "m-1 p-4 border-2 border-black rounded-xl")
            ;div(class "flex flex-wrap items-center justify-between")
              ;div(class "flex flex-wrap items-center")
                ;div(class "text-2xl pr-4")
                  ; {(trip title.pro)}
                ==
              ==
              ;+  (stat ~(stat pj:f pro))
            ==
            ;div(class "flex flex-wrap justify-between items-center")
              ;div(class "px-2")
                ;span(class "underline")
                  ; ${(r-co:co (rlys cos))}
                ==
                ; Target
              ==
              ;div(class "px-2")
                ;span(class "underline")
                  ; ${(r-co:co (rlys fil))}
                ==
                ; fulfilled
              ==
              ;div(class "px-2")
                ;span(class "underline")
                  ; ${(r-co:co (rlys pej))}
                ==
                ; pledged
              ==
              ;div(class "px-2")
                ;span(class "underline")
                  ; ${(r-co:co (rlys unf))}
                ==
                ; unfunded
              ==
            ==
            ;div(class "py-1")
              ; {(trip summary.pro)}
            ==
            ;div(class "")
              ;button(onclick "location.href='/apps/fund/projects/project-4/index'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                ; view project →
              ==
            ==
          ==
    ==
  ++  stat
    |=  sat=stat:f
    ^-  manx
    =-  ;div(class "flex mx-2 items-center")
          ;div(class "text-nowrap px-2 py-1 border-2 rounded-full font-medium {cas}")
            ; {nam}
          ==
        ==
    ^-  [nam=tape cas=tape]
    ?-    sat
      %born  ["draft" "text-gray-500 border-gray-500"]
      %prop  ["proposed" "text-gray-500 border-gray-500"]
      %lock  ["launched" "text-orange-500 border-orange-500"]
      %work  ["in-progress" "text-blue-500 border-blue-500"]
      %sess  ["in-review" "text-purple-500 border-purple-500"]
      %done  ["completed" "text-green-500 border-green-500"]
      %dead  ["canceled" "text-red-500 border-red-500"]
    ==
  --
--
