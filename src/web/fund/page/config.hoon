::  /web/fund/page/config/hoon: render config page for %fund
::
/-  fd=fund-data
/+  fh=fund-http, fx=fund-xtra
/+  rudder
%-  mine:preface:fh
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  =+  .^(vit=? (beag:fx bol /vita/enabled))
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ?+    dif=(~(got by p.arz) %dif)
        (crip "bad dif; expected vita-* or prof-sign, not {(trip dif)}")
      %vita-enable   [%fund %vita &]
      %vita-disable  [%fund %vita |]
      %vita-toggle   [%fund %vita !vit]
    ==
  ==
++  final
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  ?.  gud  [%code 500 txt]
  [%next (desc:enrl:ff:fh /) ~]
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "config"
  :+  fut=&  hed=|
  %^    hero-plaq:ui:fh
      ?.(init.dat "Thanks for installing %fund!" "Would you like to send usage data?")
    "Will you help us by sending usage information? You can change your decision at any time."
  :~  (prod-butn:ui:fh %md %true %vita-enable "yes ✓" ~ ~)
      (prod-butn:ui:fh %md %false %vita-disable "no ✗" ~ ~)
  ==
--
::  VERSION: [1 6 1]
