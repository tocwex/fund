::  /web/fund/page/ship/hoon: `src.bol` ship information page (used internally)
::
/-  fd=fund-data
/+  f=fund-core, fh=fund-http, fp=fund-prof
/+  rudder
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ?+    dif=(~(got by p.arz) %dif)  (crip "bad dif; expected prof-sign, not {(trip dif)}")
        %prof-sign
      ?+  arz=(parz:fh bod (sy ~[%pos %poa]))  p.arz  [%| *]
        =+  pos=(sign:dejs:ff:fh (~(got by p.arz) %pos))
        =+  poa=(addr:dejs:ff:fh (~(got by p.arz) %poa))
        [%prof src.bol %sign pos poa [%& (crip (oath:pf:fp src.bol poa))]]
      ==
    ==
  ==
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %page
  ;html
    ;head;
    ;body
      ;p: For internal use only.
      ;data#ship(value "{<src.bol>}");
      ;+  =-  ;data#wallets(value wap);
          ^-  wap=tape
          ?~  waz=(~(get by ~(ours conn:prof:fd bol [prof-subs prof-pubs]:dat)) src.bol)  ~
          %-  zing  %+  join  " "
          ^-  (list tape)
          (turn ~(tap in ~(key by wallets.u.waz)) addr:enjs:ff:fh)
    ==
  ==
--
::  VERSION: [1 1 0]
