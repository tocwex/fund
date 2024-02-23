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
  %^  render:tw  bowl  "modal: auth required"
  :~  ;div(id "modal-auth-required", class "p-2 border-2 border-black rounded-xl max-w-md")
        ;div(class "p-2 text-2xl min-w-[320px]")
          ; Authentication Required
        ==
        ;div(class "p-2")
          ; In order pledge future support—instead of directly sending funds now—you must authenticate with your Urbit ID. Need an urbit? Get one here.
        ==
        ;div(class "p-2")
          ; Already have an urbit? Click below to login using eAuth.
        ==
        ;div(id "auth-buttons", class "p-2 flex justify-end items-center gap-x-2")
          ;button(onclick "javascript:history.back()", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
            ; ← back
          ==
          ;button(onclick "location.href='/apps/fund/eauth/project-1'", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
            ; login with urbit ~
          ==
        ==
      ==
  ==
--