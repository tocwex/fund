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
  %^  render:tw  bowl  "modal: worker cancel project"
  :~  ;div(id "modal-worker-cancel-project", class "p-2 border-2 border-black rounded-xl max-w-md")
        ;div(class "p-2 text-2xl min-w-[320px]")
          ; Cancel Project
        ==
        ;div(class "p-2")
          ; Canceling this milestone will refund all contributions for this and future milestones, terminating this project. Funds claimed for milestones successfully completed will not be refunded.
        ==
        ;div(id "contribution-buttons", class "p-2 flex justify-end items-center gap-x-2")
          ;button(onclick "javascript:history.back()", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
            ; ← back
          ==
          ;button(onclick "location.href='/apps/fund/dashboards/dashboard-worker'", class "text-nowrap px-2 py-1 border-2 border-red-600 bg-red-600 text-white rounded-md hover:border-red-500 hover:bg-red-500 active:border-red-700 active:bg-red-700")
            ; cancel work ✗
          ==
        ==
      ==
  ==
--