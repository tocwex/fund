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
  ::  TODO: What are the redirect scenarios?
  ::  - Init/edit project:
  ::    - Text: Your changes have been saved.
  ::    - Buttons:
  ::      - Request Escrow (Prod action)
  ::      - Continue Editing (Link @ /project/(scot %p our)/[name]/edit)
  ::      - Go Home (Link @ /)
  ::  - Pledge/contribute funds:
  ::    - Text: Thank you for your {pledge/contribution}!
  ::    - Buttons:
  ::      - Return to project page (Link @ /project/(scot %p our)/[name]
  ::      - (If no auth) Learn more about %fund
  ::  - Accept/decline escrow
  ::    - Text: Thanks for your submission!
  ::    - Buttons:
  ::      - Return to project page (Link @ project)
  ::      - Return to home page (Link @ /)
  ::  - Finalize escrow
  ::    - Text: Your project has been created at {eth address}!
  ::    - Buttons:
  ::      - Return to project page (Link @ project)
  ::      - Return to home page (Link @ /)
  ::  - All on-page prods:
  ::    - Text: This project has been advanced to stage {state}!
  ::      - Return to project page (Link @ project)
  ::      - Return to home page (Link @ /)
  ::  - :
  ::    - Text: Thank you for your {pledge/contribution}!
  ::    - Buttons:
  ::      -
  =/  [pat=(pole knot) *]  (durl:fh url.request.ord)
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
          ;:  welp
              [(link-butn:htmx:fh (aurl:fh pat(- %project, +>+ ~)) %| "view project" ~)]~
              ?:((auth:fh bol) ~ [(link-butn:htmx:fh "https://tocwexsyndicate.com" %& "what's %fund?" ~)]~)
              [(link-butn:htmx:fh (aurl:fh /) %| "return home" ~)]~
          ==
        ::
            %bump
          %+  next-page
            'Your project action has been submitted.'
          :~  (link-butn:htmx:fh (aurl:fh pat(- %project, +>+ ~)) %| "view project" ~)
              (link-butn:htmx:fh (aurl:fh /) %| "return home" ~)
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
