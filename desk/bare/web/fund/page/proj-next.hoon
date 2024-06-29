::  /web/fund/page/proj-next/hoon: project redirect page for %fund
::
/-  fd=fund-data
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder, config
%-  :(corl dump:preface:fh init:preface:fh (proj:preface:fh &))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  =/  [lag=flag:f *]  (greb:proj:preface:fh hed)
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ?+    dif=(~(got by p.arz) %dif)
        (crip "bad dif; expected bump-prop, not {(trip dif)}")
      %bump-prop  [lag %bump %prop ~]
    ==
  ==
++  final
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  =/  [lag=flag:f *]  (gref:proj:preface:fh txt)
  [%next (flac:enrl:format:fh lag) ~]
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  pat=(pole knot)  (slag:derl:format:fh url.request.ord)
  =/  [lag=flag:f pro=prej:f]  (greb:proj:preface:fh arz)
  =/  aut=?(%clear %eauth %admin)
    ?.((auth:fh bol) %clear ?:(=(our src):bol %admin %eauth))
  =/  roz=(list role:f)
    (sort ~(tap in (~(rols pj:f -.pro) p.lag src.bol)) gth)
  :-  %page
  %-  html:ui:fh
  :^  bol  ord  (trip title.pro)
  ?+  pat  !!  [%next sip=@ nam=@ typ=@ ~]
    =/  syt
      :*  hep=(trip !<(@t (slot:config %meta-help)))
          hos=(trip !<(@t (slot:config %meta-host)))
          pro=(dest:enrl:format:fh pat(- %project, +>+ ~))
      ==
    =/  btn
      :*  hep=(link-butn:ui:fh hep.syt %& "what is %fund?" ~)
          pro=(link-butn:ui:fh pro.syt %| "view project" ~)
          ^=  das  |=  rol=role:f
          =+  roc=(role:enjs:format:fh rol)
          =+  rul=(dest:enrl:format:fh /dashboard/[(crip roc)])
          (link-butn:ui:fh rul %| "{roc} dashboard" ~)
      ==
    ?+    typ.pat  !!
        %bump
      %^  hero-plaq:ui:fh  "Your project action has been submitted."  ~
      [pro.btn (turn (skip roz |=(r=role:f =(%fund r))) das.btn)]
    ::
        %edit
      %^  hero-plaq:ui:fh  "Your changes have been saved!"  ~
      :~  (prod-butn:ui:fh %bump-prop %true "request oracle ✓" ~ ~)
          =+  (dest:enrl:format:fh pat(- %project))
            (link-butn:ui:fh - %| "continue editing" ~)
          pro.btn
      ==
    ::
        %mula
      %+  hero-plaq:ui:fh  "Thank you for your contribution!"
      ?-  aut
          %admin
        :-  ~
        ;:  welp
            ?.(=(our.bol p.lag) ~ [(copy-butn:ui:fh bol lag "share project")]~)
            [pro.btn]~
            [(das.btn %fund)]~
        ==
      ::
          %eauth
        :-  ~
        :~  (copy-butn:ui:fh bol lag "share project")
            pro.btn
            hep.btn
            (link-butn:ui:fh "{hep.syt}/#installing-fund" %& "download %fund" ~)
        ==
      ::
          %clear
        :-  """
            If you would like to make direct connections with the worker that you
            are funding, or other contributors to the project, click 'get urbit' below.
            """
        :~  (copy-butn:ui:fh bol lag "share project")
            pro.btn
            hep.btn
            (link-butn:ui:fh hos.syt %& "get urbit" ~)
        ==
      ==
    ==
  ==
--
::  VERSION: [0 4 1]
