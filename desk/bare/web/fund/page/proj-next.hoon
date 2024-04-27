::  /web/fund/page/proj-next/hoon: project redirect page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder, config
%-  dump:preface:fh
%-  init:preface:fh  %-  (proj:preface:fh &)
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  =/  [lag=flag:f *]  (greb:proj:preface:fh hed)
  ?+  arz=(parz:fh bod (sy ~[%act]))  p.arz  [%| *]
    ?+    act=(~(got by p.arz) %act)
        (crip "bad act; expected bump-prop, not {(trip act)}")
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
  %-  render:htmx:fh
  :^  bol  ord  (trip title.pro)
  |^  ?+  pat  !!  [%next sip=@ nam=@ typ=@ ~]
        =/  syt
          :*  hep=(trip !<(@t (slot:config %site-help)))
              hos=(trip !<(@t (slot:config %site-host)))
              pro=(dest:enrl:format:fh pat(- %project, +>+ ~))
          ==
        =/  btn
          :*  hep=(link-butn:htmx:fh hep.syt %& "what is %fund?" ~)
              pro=(link-butn:htmx:fh pro.syt %| "view project" ~)
              ^=  das  |=  rol=role:f
              =+  roc=(role:enjs:format:fh rol)
              =+  rul=(dest:enrl:format:fh /dashboard/[(crip roc)])
              (link-butn:htmx:fh rul %| "{roc} dashboard" ~)
          ==
        ?+    typ.pat  !!
            %bump
          %+  next-page  'Your project action has been submitted.'
          [pro.btn (turn (skip roz |=(r=role:f =(%fund r))) das.btn)]
        ::
            %edit
          %+  next-page  'Your changes have been saved!'
          :~  (prod-butn:htmx:fh %bump-prop %green "request escrow ✓" ~)
              =+  (dest:enrl:format:fh pat(- %project))
                (link-butn:htmx:fh - %| "continue editing" ~)
              pro.btn
          ==
        ::
            %mula
          %+  next-page  'Thank you for your contribution!'
          %+  welp  ~[(copy-butn:htmx:fh "share project") pro.btn]
          ?-  aut
            %admin  ~[(das.btn %fund)]
          ::
              %eauth
            :~  hep.btn
                (link-butn:htmx:fh "{hep.syt}/#installing-fund" %& "download %fund" ~)
            ==
          ::
              %clear
            :~  hep.btn
                (link-butn:htmx:fh hos.syt %& "get urbit" ~)
            ==
          ==
        ==
      ==
  ++  next-page
    |=  [tyt=@t buz=marl]
    ^-  manx
    ;form#maincontent(method "post", autocomplete "off", class "p-2 h-[80vh]")
      ;div(class "flex flex-col h-full flex-wrap justify-center items-center text-center gap-10")
        ;div(class "text-4xl sm:text-5xl"): {(trip tyt)}
        ;div(class "flex gap-2")
          ;*  buz
        ==
      ==
    ==
  --
--
