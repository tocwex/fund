::  /web/fund/page/index/hoon: render base page for %fund
::
/-  f=fund
/+  rudder, s=server, fh=fund-http
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  ~
  |^  ;div(id "maincontent", class "flex flex-col py-2 gap-2 mx-auto lg:px-4")
        ;+  %^  dash-well  %funder
              "funding contributor"
            "fulfill your pledges and follow active projects"
        ;+  %^  dash-well  %worker
              "project worker"
            "create your own proposals, and manage your projects"
        ;+  %^  dash-well  %assessor
              "escrow assessor"
            "get paid as a trusted arbiter for community projects"
      ==
  ++  dash-well
    |=  [das=@tas tyt=tape sum=tape]
    ^-  manx
    ;div(class "p-2 pb-3 mx-auto border-2 border-black rounded-md max-w-[256px]")
      ;div(class "text-2xl text-center"): {tyt}
      ;div(class "flex flex-col gap-2")
        ;div(class "text-sm text-center"): {sum}
        ;div(class "mx-auto text-center")
          ;a/"{(aurl:fh /dashboard/[das])}"(class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
            ; view dashboard →
          ==
        ==
      ==
    ==
  --
--
