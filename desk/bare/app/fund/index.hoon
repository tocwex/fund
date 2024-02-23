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
  %^  render:tw  q.byk.bowl  "%fund"
  :~  ;div(class "flex-grow")
        ;nav(class "lg:mx-4 mt-1.5 mb-2")
          ;ul(class "py-2 flex justify-between border-black border-b-2")
            ;div(class "mx-2")
              ;div(class "text-xl border-2 rounded-sm border-white ease-in-out hover:text-yellow-500 duration-300 font-medium")
                ;a(href "/apps/fund/")
                  ; %fund
                ==
              ==
            ==
            ;div(class "flex gap-x-2 mx-2")
              ;button(id "connect-wallet", class "cursor-pointer text-nowrap px-2 py-1 border-2 duration-300 border-black bg-black text-white hover:text-black rounded-md hover:rounded-lg hover:bg-white hover:border-gray-800 active:bg-gray-800 active:border-black active:text-white");
            ==
          ==
        ==
        ;div(id "maincontent", class "mx-auto lg:px-4")
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
