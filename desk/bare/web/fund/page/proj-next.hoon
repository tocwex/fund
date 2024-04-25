::  /web/fund/page/proj-next/hoon: project redirect page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder
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
  :^  bol  ord  ~
  |^  ?+  pat  !!  [%next sip=@ nam=@ typ=@ ~]
        ?+    typ.pat  !!
            %edit
          %+  next-page
            'Your changes have been saved!'
          :~  (prod-butn:htmx:fh %bump-prop %green "request escrow ✓" ~)
              (link-butn:htmx:fh (dest:enrl:format:fh pat(- %project)) %| "continue editing" ~)
              (link-butn:htmx:fh (dest:enrl:format:fh /) %| "return home" ~)
          ==
        ::
            %mula
          %+  next-page
            'Thank you for your contribution!'
          =/  what-butn
            (link-butn:htmx:fh "https://tocwexsyndicate.com" %& "what is %fund?" ~)
          ::  TODO: Refactor/share w/ `proj-view.hoon` source code
          =/  share-butn
            :_  ; share project
            :-  %button
            :~  [%id "fund-butn-share"]
                [%type "button"]
                [%title "copy url"]
                [%class "fund-butn-effect"]
                [%'@click' "copy(window.location.toString().replace(/\\/next\\/([^\\/]+)\\/([^\\/]+)\\/mula/, '/project/$1/$2'), '#fund-butn-share')"]
            ==
          :+  share-butn
            (link-butn:htmx:fh (dest:enrl:format:fh pat(- %project, +>+ ~)) %| "view project" ~)
          ?-    aut
              %admin
            :~  (link-butn:htmx:fh (dest:enrl:format:fh /dashboard/funder) %| "funder dashboard" ~)
            ==
          ::
              %eauth
            ::  FIXME: Need a real link to download %fund
            :~  what-butn
                (link-butn:htmx:fh "https://tocwexsyndicate.com" %& "download %fund" ~)
            ==
          ::
              %clear
            :~  what-butn
                (link-butn:htmx:fh "https://redhorizon.com/join/217ddb05-07f1-4897-8c6a-d6ef76da7380" %& "get urbit" ~)
            ==
          ==
        ::
            %bump
          %+  next-page
            'Your project action has been submitted.'
          :-  (link-butn:htmx:fh (dest:enrl:format:fh pat(- %project, +>+ ~)) %| "view project" ~)
          %+  turn  (skip roz |=(r=role:f =(%fund r)))
          |=  rol=role:f
          =+  roc=(crip (welp (trip rol) ?:(=(%orac rol) "le" "er")))
          (link-butn:htmx:fh (dest:enrl:format:fh /dashboard/[roc]) %| "{(trip roc)} dashboard" ~)
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
