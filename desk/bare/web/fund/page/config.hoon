::  /web/fund/page/config/hoon: render config page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder
%-  mine:preface:fh
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  ?+  arz=(parz:fh bod (sy ~[%act]))  p.arz  [%| *]
    ?+    act=(~(got by p.arz) %act)
        (crip "bad act; expected vita-*, not {(trip act)}")
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
  %-  render:htmx:fh
  :^  bol  ord  "config"
  ;form#maincontent(method "post", autocomplete "off", class "p-2 h-[80vh]")
    ;div(class "flex flex-col h-full flex-wrap justify-center items-center text-center gap-6")
      ;div(class "text-4xl sm:text-5xl")
        ;+  ?.  init.dat
            ;span: Thanks for installing %fund!
          ;span: Update your preferences?
      ==
      ;div(class "text-xl sm:text-2xl"): Will you help us by sending usage information?
      ;div(class "text-xl sm:text-2xl"): You can change your decision at any time.
      ;div(class "flex gap-2")
        ;+  (prod-butn:htmx:fh %vita-enable %green "yes ✓" ~)
        ;+  (prod-butn:htmx:fh %vita-disable %red "no ✗" ~)
      ==
    ==
  ==
--
::  VERSION: [0 1 2]
