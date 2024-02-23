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
  %^  render:tw  bowl  "%fund"
  :~  ;div(id "maincontent", class "mx-auto lg:px-4")
        ;div(id "maincontent", class "mx-auto px-4")
          ;div(class "p-2 my-2 mx-auto border-2 border-black rounded-md max-w-[256px]")
            ;div(class "text-2xl text-center")
              ; funding contributor
            ==
            ;div(class "text-sm text-center py-1")
              ; fulfill your pledges and follow active projects
            ==
            ;div(class "mx-auto")
              ;div(class "text-center")
                ;button(onclick "location.href='/apps/fund/dashboards/dashboard-funder'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; view dashboard →
                ==
              ==
            ==
          ==
          ;div(class "p-2 my-2 mx-auto border-2 border-black rounded-md max-w-[256px]")
            ;div(class "text-2xl text-center")
              ; project worker
            ==
            ;div(class "text-sm text-center py-1")
              ; create your own proposals, and manage your projects
            ==
            ;div(class "text-center")
              ;button(onclick "location.href='/apps/fund/dashboards/dashboard-worker'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                ; view dashboard →
              ==
            ==
          ==
          ;div(class "p-2 my-2 mx-auto border-2 border-black rounded-md max-w-[256px]")
            ;div(class "text-2xl text-center")
              ; escrow assessor
            ==
            ;div(class "text-sm text-center py-1")
              ; get paid as a trusted arbiter for community projects
            ==
            ;div(class "text-center")
              ;button(onclick "location.href='/apps/fund/dashboards/dashboard-assessor'", class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                ; view dashboard →
              ==
            ==
          ==
        ==
      ==
  ==
--
