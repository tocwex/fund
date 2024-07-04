::  /web/fund/page/config/hoon: render config page for %fund
::
/-  fd=fund-data
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder
%-  mine:preface:fh
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ?+    dif=(~(got by p.arz) %dif)
        (crip "bad dif; expected vita-*, not {(trip dif)}")
      ::  FIXME: This is a hack to support pokes that edit app-global
      ::  (as opposed to project-specific) information
      %vita-enable   [[our.bol %$] %join ~]
      %vita-disable  [[our.bol %$] %exit ~]
    ==
  ==
++  final
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  ?.  gud  [%code 500 txt]
  [%next (desc:enrl:format:fh /) ~]
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  "config"
  %^    hero-plaq:ui:fh
      ?.(init.dat "Thanks for installing %fund!" "Update your preferences?")
    "Will you help us by sending usage information? You can change your decision at any time."
  ;=  ;+  (prod-butn:ui:fh %vita-enable %true "yes ✓" ~ ~)
      ;+  (prod-butn:ui:fh %vita-disable %false "no ✗" ~ ~)
  ==
--
::  VERSION: [0 4 1]
