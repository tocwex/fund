::  /web/fund/page/index/hoon: render base page for %fund
::
/-  fd=fund-data
/+  f=fund-proj, fh=fund-http, fx=fund-xtra
/+  rudder
%-  :(corl mine:preface:fh init:preface:fh)
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  ~
  |^  ;div(class "flex flex-col py-2 gap-2 mx-auto max-w-[256px]")
        ;+  %^  dash-well  %funder
              "project funder"
            "fulfill your pledges and follow active projects"
        ;+  %^  dash-well  %worker
              "project worker"
            "create your own proposals, and manage your projects"
        ;*  ?.  (star:fx src.bol)  ~
            :_  ~  %^  dash-well  %oracle
              "trusted oracle"
            "get paid as a trusted arbiter for community projects"
        ;div(class "flex flex-row justify-between")
          ;+  %-  ~(link-butn ui:fh "fund-butn-de-s")
              ["{(burl:fh bol)}/apps/landscape/" & "explore urbit" ~]
          ;+  %-  ~(link-butn ui:fh "fund-butn-de-s")
              :_  [& "view %fund chat" ~]
              "{(burl:fh bol)}/apps/groups/groups/~tocwex/syndicate-public"
        ==
      ==
  ++  dash-well
    |=  [das=@tas tyt=tape sum=tape]
    ^-  manx
    ;div(class "p-2 pb-3 border-2 border-black rounded-md")
      ;h2(class "text-2xl text-center"): {tyt}
      ;div(class "flex flex-col gap-2")
        ;div(class "text-sm text-center"): {sum}
        ;div(class "mx-auto text-center")
          ;a.fund-butn-de-m/"{(dest:enrl:ff:fh /dashboard/[das])}": view dashboard
        ==
      ==
    ==
  --
--
::  VERSION: [1 2 1]
