::  /web/fund/page/redirect/hoon: redirect page for %fund
::
/+  f=fund, fh=fund-http, fx=fund-xtra
/+  rudder
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  =/  [pat=(list knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  =/  rex=(map @t bean)  (malt ~[['act' &]])
  ?+  arz=(parz:fh bod rex)  p.arz  [%| *]
    =+  act=(~(got by p.arz) 'act')
    ?.  ?=(%bump-prop act)
      (crip "bad act; expected (bump-*), not {(trip act)}")
    ?~  pro=(~(get by (prez-ours:sss:f bol dat)) lag)
      (crip "bad act={<act>}; project doesn't exist: {<lag>}")
    ;;  act-now:f  %-  turn  :_  |=(p=prod:f [lag p])  ^-  (list prod:f)
    ?-  act
      %bump-prop  [%bump %prop ~]~
    ==
  ==
++  final
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  ?.  gud  [%code 422 txt]
  =/  [lag=flag:f pyp=@tas]  (poke:take:fh ?~(txt '' txt))
  [%next (crip (aurl:fh /project/(scot %p p.lag)/[q.lag])) '']
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [pat=(pole knot) *]  (durl:fh url.request.ord)
  =/  lag=flag:f  [(slav %p (snag 1 pat)) (slav %tas (snag 2 pat))]
  =/  aut=?(%clear %eauth %admin)
    ?.  (auth:fh bol)   %clear
    ?:  =(our src):bol  %admin
    %eauth
  =/  roz=(list role:f)
    %-  sort  :_  gth
    ?~  pro=(~(get by (prez-ours:sss:f bol dat)) lag)  ~
    ~(tap in (~(rols pj:f -.u.pro) p.lag src.bol))
  :-  %page
  %-  render:htmx:fh
  :^  bol  ord  ~
  |^  ?+  pat  !!  [%next sip=@ nam=@ typ=@ ~]
        ?+    typ.pat  !!
            %edit
          %+  next-page
            'Your changes have been saved!'
          :~  (prod-butn:htmx:fh %bump-prop %green "request escrow ✓" ~)
              (link-butn:htmx:fh (aurl:fh pat(- %project)) %| "continue editing" ~)
              (link-butn:htmx:fh (aurl:fh /) %| "return home" ~)
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
            (link-butn:htmx:fh (aurl:fh pat(- %project, +>+ ~)) %| "view project" ~)
          ?-    aut
              %admin
            :~  (link-butn:htmx:fh (aurl:fh /dashboard/funder) %| "funder dashboard" ~)
            ==
          ::
              %eauth
            ::  FIXME: Need a real link to download %fund
            :~  what-butn
                (link-butn:htmx:fh "https://tocwexsyndicate.com" %& "download %fund" ~)
            ==
          ::
              %clear
              ::  TODO: Change to "get urbit" link via Red Horizon
            :~  what-butn
                (link-butn:htmx:fh "https://tlon.network/lure/~tocwex/syndicate-public" %& "get urbit" ~)
            ==
          ==
        ::
            %bump
          %+  next-page
            'Your project action has been submitted.'
          :-  (link-butn:htmx:fh (aurl:fh pat(- %project, +>+ ~)) %| "view project" ~)
          %+  turn  (skip roz |=(r=role:f =(%fund r)))
          |=  rol=role:f
          =+  roc=(crip (welp (trip rol) ?:(=(%orac rol) "le" "er")))
          (link-butn:htmx:fh (aurl:fh /dashboard/[roc]) %| "{(trip roc)} dashboard" ~)
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
