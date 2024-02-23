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
  %^  render:tw  bowl  "modal: confirm pledge eauth"
  :~  ;div(id "modal-confirm-pledge-eauth", class "p-2 border-2 border-black rounded-xl max-w-md")
        ;div(class "p-2 text-2xl min-w-[320px]")
          ; Confirm Pledge
        ==
        ;div(class "p-2")
          ; Pledging support for this project implies that prior to milestone completion, you will make a stablecoin contribution to the fund or suffer eternal shame and likely some reputational damage.
        ==
        ;div(class "p-2")
          ; For your convenience, you can download the %fund app to track and fulfill past commitments.
        ==
        ;div(class "m-2 p-2 font-mono bg-grey-300 text-black rounded-md")
          ; |install ~pollen %fund
        ==
        ;div(class "p-2")
          ; You can also return to this page and login to satisfy your pledge without downloading the app.
        ==
        ;div(class "p-2")
          ; If you pinky promise to fund this project, click the button below to confirm your pledge.
        ==
        ;div(class "p-2 flex justify-end items-center gap-x-2")
          ;button(onclick "javascript:history.back()", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
            ; ← back
          ==
          ;button(onclick "location.href='/apps/fund/eauth/project-1'", class "text-nowrap px-2 py-1 border-2 border-black bg-black text-white rounded-md hover:bg-gray-800 hover:border-gray-800 active:bg-white active:border-black active:text-black")
            ; confirm pledge ✓
          ==
        ==
      ==
  ==
--