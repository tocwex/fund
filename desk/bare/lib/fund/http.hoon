:: /lib/fund/http/hoon: http data and helper functions for %fund
::
/+  *fund, fx=fund-xtra
/+  rudder, tonic
/*  boot-js  %js   /web/fund/boot/js
/*  fund-cs  %css  /web/fund/fund/css
|%
::
::  +route: rudder-related transformer of url ($trail) into (potential)
::  page id ($place)
::
++  route
  ^-  route:rudder
  |=  =trail:rudder
  ^-  (unit place:rudder)
  =/  syt=(list @t)  site.trail
  =/  pat=(pole knot)  (need (decap:rudder /apps/fund syt))
  ?:  ?=([%$ *] (flop pat))               `[%away (snip syt)]
  ?+  pat                                 ~
    ~                                     `[%page | %index]
    [%asset *]                            `[%page | %asset]
    [%dashboard suf=*]    ?+  suf.pat     ~
      ~                                   `[%away (snip syt)]
      [?(%worker %funder %assessor) ~]    `[%page | %proj-list]
    ==
    [%create suf=*]       ?+  suf.pat     ~
      ~                                   `[%away (snip syt)]
      [%project ~]                        `[%page | %proj-edit]
    ==
    ::  TODO: Verify valid @p and @tas flag here to keep excessive error
    ::  handling from the `proj-edit.hoon` page
    [%project @ @ suf=*]  ?+  suf.pat     ~
      ~                                   `[%page | %proj-view]
      [%edit ~]                           `[%page | %proj-edit]
    ==
  ==
::
::  +parz: parse POST request parameters considering required arguments
::
::    =+  rex=(malt ~[['required' &] ['optional' |] ...])
::    ?+  arz=(pargs:web:f body rex)  p.arz  [%| *]
::      ::  ... process `arz` here ...
::    ==
::
++  parz
  |=  [bod=(unit octs) rex=(map @t bean)]
  ^-  (each @t (map @t @t))
  ?~  bod  &+'no http request body provided'
  =/  hav=(map @t @t)  (frisk:rudder q.u.bod)
  =-  ?:  =(0 ~(wyt in mis))  |+arz
      &+(crip "missing required arguments: {<mis>}")
  ^-  [mis=(set @t) arz=(map @t @t)]
  =<  -  %+  ~(rib by rex)  [*(set @t) *(map @t @t)]
  |=  [[arg=@t req=bean] mis=(set @t) arz=(map @t @t)]
  :_  [arg req]
  =/  nex=(unit @t)  (~(get by hav) arg)
  :_  ?~(nex arz (~(put by arz) arg u.nex))
  ?.(&(req =(~ nex)) mis (~(put in mis) arg))
::
::  +aurl: a(pp) url - produce a path relative to the site's base url
::
++  aurl
  |=  pat=path  ~+
  ^-  tape
  (spud (weld /apps/fund pat))
::
::  +curl: c(hat) url - produce a path to a chat window with a ship
::
++  curl
  |=  sip=@p  ~+
  ^-  tape
  (spud /apps/groups/dm/(scot %p sip))
::
::  +durl: d(ecode) url - extracts path and query arguments from raw url
::
++  durl
  |=  cor=cord  ~+
  ^-  [=path query=(map @t @t)]
  =/  [pre=tape suf=tape]  (chop:fx (trip cor) '?')
  :-  (need (decap:rudder /apps/fund (stab (crip pre))))
  ?:(=(~ suf) ~ (frisk:rudder (crip suf)))
::
::  +furl: f(lag) url - extracts the ship path from the url (if it exists)
::
++  furl
  |=  cor=cord  ~+
  ^-  (unit flag)
  =/  [pat=(pole knot) *]  (durl cor)
  ?+  pat  ~
    [%project sip=@ nam=@ *]  (both (slaw %p sip.pat) (slaw %tas nam.pat))
  ==
::
::  +auth: is `src.bowl` in the given bowl an authenticated user?
::
++  auth
  |=  bol=bowl:gall  ~+
  ^-  bean
  =+  peers=.^((map ship *) /ax/(scot %p our.bol)//(scot %da now.bol)/peers)
  ?|  !=((clan:title src.bol) %pawn)
      (~(has by peers) src.bol)
  ==
::
::  +dump: printer functions for text embedded in htmx elements
::
++  dump
  |%
  ++  mony                                       ::  .1.2345e1 => "12.34"
    |=  mon=@rs
    ^-  tape
    ?+    mun=(rlys mon)  "?"
        [%d *]
      ::  TODO: Need to round off everything past two digits after the decimal
      ::  TODO: Need to pad with at least two zeroes after the decimal place
      ::  TODO: Need to insert commas after every three digits before decimal place
      =/  rep=tape  ?:(s.mun "" "-")
      =/  f  ((d-co:co 1) a.mun)
      =^  e  e.mun
        =/  e=@s  (sun:si (lent f))
        =/  sci  :(sum:si e.mun e -1)
        [(sum:si sci --1) --0]
      (weld rep (ed-co:co e f))
    ==
  ++  flag                                       ::  [~zod %nam] => "~zod/nam"
    |=  lag=^flag
    ^-  tape
    :(weld (scow %p p.lag) "/" (trip q.lag))
  ++  mula                                       ::  [%plej ...] => "pledged"
    |=  mul=^mula
    ^-  tape
    ?-  -.mul
      %plej  "pledged"
      %trib  "fulfilled"
    ==
  ++  stat                                       ::  %born => "draft"
    |=  sat=^stat
    ^-  tape
    ?-  sat
      %born  "draft"
      %prop  "proposed"
      %lock  "launched"
      %work  "in-progress"
      %sess  "in-review"
      %done  "completed"
      %dead  "canceled"
    ==
  --
::
::  +claz: poor man's twind class evaluation via @apply
::
++  claz
  |%
  ++  butt                                       ::  button
    """
    text-nowrap px-2 py-1 border-2 duration-300 border-black rounded-md
    hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400
    active:bg-yellow-500 active:border-yellow-500
    """
  --
::
::  +htmx: html-related helper functions and data, including css, js, components
::
++  htmx
  |_  cas=tape
  ++  render
    |=  [bol=bowl:gall ord=order:rudder tyt=tape bod=manx]
    ^-  manx
    =+  go-base="https://fonts.googleapis.com"
    =+  sl-base="https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist"
    |^  ;html
          ;head
            ;meta(charset "UTF-8");
            ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
            ;title: {(weld "%fund - " ?~(tyt "home" tyt))}
            ;link/"{(aurl /asset/[~.tocwex.svg])}"(rel "icon", type "image/svg+xml");
            ;link/"{go-base}"(rel "preconnect");
            ;link/"https://fonts.gstatic.com"(rel "preconnect", crossorigin ~);
            ::  FIXME: Make this line legible somehow
            ;link/"{go-base}/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Noto+Emoji:wght@300..700&display=swap"(as "style", rel "stylesheet preload", crossorigin ~);
            ::  NOTE: We have a local script that sets '.block' to hide elements so
            ::  that the document is hidden before 'twind' loads and applies styles
            ::  to the document (which will override '.block' to do the opposite).
            ;style: {".block \{ display: none; }"}
            ;style: {^~((trip fund-cs))}
            ;link(rel "stylesheet", href "{sl-base}/themes/light.css");
            ;script(type "module", src "{sl-base}/shoelace-autoloader.js");
            ;script(src "/session.js");  ::  debug-only
            ;+  (inject:tonic q.byk.bol)  ::  debug-only
          ==
          ;body(class "text-base font-serif block max-w-screen-2xl {cas}")
            ;+  head
            ;+  bod
            ;+  foot
          ==
          ;+  ;script(type "module"): {^~((trip boot-js))}
        ==
    ++  head
      ^-  manx
      =/  [pat=(pole knot) *]  (durl url.request.ord)
      ;nav
        ;div(class "flex justify-between p-2 lg:px-4 border-black border-b-2")
          ;+  ?-    pat
                  ?([%dashboard *] [%create %proj ~] [%project @ @ %edit ~])
                ;a/"{(aurl (snip `(list knot)`pat))}"(class "text-nowrap px-2 py-1 border-2 duration-300 border-black hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 rounded-md active:bg-yellow-500 active:border-yellow-500")
                  ; ← back
                ==
              ::
                  *
                ;a/"{(aurl /)}"(class "flex items-center gap-x-2 text-xl border-2 rounded-sm border-white ease-in-out hover:text-yellow-500 duration-300 font-medium")
                  ; %fund
                ==
              ==
          ;div(class "flex gap-x-2")
            ::  FIXME: Opening login page in a new tab because opening it
            ::  in the current tab causes issues with further redirects
            ::  (e.g. to the ship login page for eAuth)
            ;button(id "login-urbit", class "text-nowrap px-2 py-1 border-2 border-black rounded-md duration-300 hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 active:bg-yellow-500 active:border-yellow-500")
              ;+  ?:  (auth bol)
                    ;a/"/~/logout?redirect={(aurl pat)}": {<src.bol>}
                  ;a/"/~/login?redirect={(aurl pat)}"(target "_blank"): login ~
            ==
            ;button(id "connect-wallet", class "cursor-pointer text-nowrap px-2 py-1 border-2 duration-300 border-black bg-black text-white hover:text-black rounded-md hover:rounded-lg hover:bg-white hover:border-gray-800 active:bg-gray-800 active:border-black active:text-white")
              ; …loading…
            ==
          ==
        ==
      ==
    ++  foot
      ^-  manx
      ;footer
        ;div(class "justify-center border-t-2 p-2 lg:px-4 border-black lg:flex lg:flex-row-reverse lg:items-center lg:justify-between")
          ;div(class "flex justify-center grow lg:grow-0 lg:justify-end lg:p-2")
            ;div(class "px-10 lg:px-2")
              ;a/"https://tlon.network/lure/~tocwex/syndicate-public"(target "_blank")
                ;img@"{(aurl /asset/[~.urbit.svg])}";
              ==
            ==
            ;div(class "px-10 lg:px-2")
              ;a/"https://twitter.com/tocwex"(target "_blank")
                ;img@"{(aurl /asset/[~.x.svg])}";
              ==
            ==
            ;div(class "px-10 lg:px-2")
              ;a/"https://github.com/tocwex"(target "_blank")
                ;img@"{(aurl /asset/[~.github.svg])}";
              ==
            ==
          ==
          ;div(class "mb-0 mt-2 text-center text-xs lg:text-base lg:m-0 lg:p-1 lg:pb-2")
            ;div(class "mb-2 lg:mb-0 justify-center flex flex-row items-center lg:justify-start lg:px-3 hover:underline")
              ;a/"https://tocwexsyndicate.com"(target "_blank")
                ; crafted by ~tocwex.syndicate
              ==
            ==
          ==
        ==
      ==
    --
  ++  mula-ther
    |=  [cos=@rs fil=@rs pej=@rs]
    ^-  manx
    =/  unf=@rs  =+(u=(sub:rs cos (add:rs fil pej)) ?:((gth:rs u .0) u .0))
    ::  TODO: Switch out for 'paid' in the case of a project?
    ::  TODO: Do we even need to keep the 'goal' value for a project?
    ;div(class "flex flex-wrap justify-between items-center {cas}")
      ;div(class "flex gap-x-1")
        ;span(class "underline"): ${(mony:dump cos)}
        ; target
      ==
      ;div(class "flex gap-x-1")
        ;span(class "underline"): ${(mony:dump fil)}
        ; fulfilled
      ==
      ;div(class "flex gap-x-1")
        ;span(class "underline"): ${(mony:dump pej)}
        ; pledged
      ==
      ;div(class "flex gap-x-1")
        ;span(class "underline"): ${(mony:dump unf)}
        ; unfunded
      ==
    ==
  ++  stat-pill
    |=  sat=stat
    ^-  manx
    =-  ;div(class "text-nowrap px-2 py-1 border-2 rounded-full {cas} {kas}"): {nam}
    ^-  [nam=tape kas=tape]
    =-  [(stat:dump sat) "text-{-} border-{-}"]
    ?-  sat
      ?(%born %prop)  "gray-500"
      %lock  "orange-500"
      %work  "blue-500"
      %sess  "purple-500"
      %done  "green-500"
      %dead  "red-500"
    ==
  --
--
