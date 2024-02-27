/-  f=fund
/+  rudder, tw=twind, s=server
^-  pag-now:f
|_  [=bowl:gall =order:rudder data=dat-now:f]
++  argue  ::  POST reply
  |=  [head=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  =/  arz=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
  ?~  nam=(~(get by arz) 'nam')  ~
  =+  sum=(~(get by arz) 'sum')
  =+  pic=(~(get by arz) 'pic')
  ::  TODO: Parse assessment information into [who mun]
  ::  =+  ses=(~(get by arz) 'ses')
  ::  TODO: How will we pass milestone information?
  ::  =+  miz=(~(get by arz) 'miz')
  ;;  act-now:f
  ::  TODO: Termify arbitrary project title
  ::  => lowercase all characters
  ::  => replace all whitespace with - character
  ::  => replace all non-ascii characters with 0s or -s
  ?>  ((sane %tas) (need nam))
  %-  turn  :_  |=(p=prod:f `poke:f`[[our.bowl `@tas`(need nam)] p])
  ::  TODO: Only run `%init-proj` if it doesn't already exist
  ::  =/  my-proz  ~(tap by proz.data)
  ^-  (list prod:f)
  :~  [%init-proj ~]
      [%edit-proj nam sum pic ~]
  ==
++  final  ::  POST render
  |=  [done=? =brief:rudder]
  ^-  reply:rudder
  (build ~ `[& 'hey'])
  ::  [%auth '/']
++  build  ::  GET
  |=  [args=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %page
  %^  render:tw  bowl  "%fund - project creation"
  :~  ;div(id "maincontent", class "mx-auto lg:px-4")
        ;form(method "post")
          ;div(class "")
            ;div(class "m-1 pt-2 text-3xl w-full")
              ; Project Overview
            ==
            ;div(class "")
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
                ;input(type "text", name "sum", class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "Write a worthy description of your project");
              ==
              ;div(class "flex w-full")
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; amount
                  ==
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "$10,000");
                ==
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; token
                  ==
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "USDC");
                ==
                ;div(class "m-1 p-1 w-full")
                  ;div(class "m-1 pt-1 border-black font-light")
                    ; project status
                  ==
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "draft");
                ==
              ==
            ==
          ==
          ;div(class "")
            ;div(class "flex justify-between")
              ;div(class "text-3xl pt-2")
                ; Milestones
              ==
              ;div(class "px-4 self-center")
                ;button(onclick "location.href='/apps/fund/project-creation'", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                  ; New Milestone +
                ==
              ==
            ==
            ;div(class "mx-2")
              ;div(class "my-2 p-2 border-2 border-black rounded-xl")
                ;div(class "m-1 px-2 text-3xl w-full")
                  ; Milestone #N
                ==
                ;div(class "")
                  ;div(class "flex")
                    ;div(class "m-1 p-1 w-full")
                      ;div(class "m-1 pt-1 border-black font-light")
                        ; milestone
                        ;title;
                      ==
                      ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "Give your milestone a title");
                    ==
                    ;div(class "m-1 p-1 w-full")
                      ;div(class "m-1 pt-1 border-black font-light")
                        ; Milestone Status
                      ==
                      ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "draft");
                    ==
                  ==
                  ;div(class "flex")
                    ;div(class "m-1 p-1 w-full")
                      ;div(class "m-1 pt-1 border-black font-light")
                        ; date
                      ==
                      ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "MM/DD/YYYY");
                    ==
                    ;div(class "m-1 p-1 w-full")
                      ;div(class "m-1 pt-1 border-black font-light")
                        ; amount
                      ==
                      ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "$10,000");
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
              ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                ; New Milestone +
              ==
            ==
          ==
          ;div(class "")
            ;div(class "m-1 pt-2 text-3xl w-full")
              ; Escrow Assessor
            ==
            ;div(class "")
              ;div(class "m-1 p-1 w-full")
                ;div(class "m-1 pt-1 border-black font-light")
                  ; escrow assessor
                ==
                ;div(class "flex justify-between")
                  ;input(class "m-1 p-1 border-2 border-gray-200 bg-gray-200 placeholder-gray-400 rounded-md w-full", placeholder "~tocwex");
                  ;div(class "px-4 self-center w-full")
                    ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
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
                      ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
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
              ;div(class "")
                ;div(class "m-1 pt-2 text-3xl w-full")
                  ; Confirm & Launch
                ==
                ;div(class "")
                  ; Please review your proposal in detail and ensure your assessor is in mutual agreement on expectations for review of work and release of funds.
                ==
                ;div(class "flex w-full justify-center mx-auto")
                  ;button(type "submit", name "save", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
                    ; save draft ~
                  ==
                  ;button(onclick "location.href=''", class "text-nowrap px-2 py-1 border-2 border-red-600 bg-red-600 text-white rounded-md hover:border-red-500 hover:bg-red-500 active:border-red-700 active:bg-red-700")
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
  ==
--
