:: /lib/fund/http/hoon: http data and helper functions for %fund
::
/+  f=fund, fx=fund-xtra
/+  rudder, tonic
/*  boot-js  %js  /web/fund/boot/js
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
    [%project @ @ suf=*]  ?+  suf.pat     ~
      ~                                   `[%page | %proj-view]
      [%edit ~]                           `[%page | %proj-edit]
    ==
  ==
::
::  +pargs: parse POST request parameters, considering required arguments
::
::    =+  rex=(malt ~[['required' &] ['optional' |] ...])
::    ?+  arz=(pargs:web:f body rex)  p.arz  [%| *]
::      ::  ... process `arz` here ...
::    ==
::
++  pargs
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
::  +durl: d(ecode) url - extracts path and query arguments from raw url
::
++  durl
  |=  cor=cord  ~+
  ^-  [=path query=(map @t @t)]
  =/  [pre=tape suf=tape]  (chop:lhex:fx (trip cor) '?')
  :-  (need (decap:rudder /apps/fund (stab (crip pre))))
  ?:(=(~ suf) ~ (frisk:rudder (crip suf)))
::
::  +aurl: a(pp) url - produce a path relative to the site's base url
::
++  aurl
  |=  pat=path  ~+
  ^-  tape
  (spud (weld /apps/fund pat))
::
::  +authed: is `src.bowl` in the given bowl an authenticated user?
::
++  authed
  |=  bol=bowl:gall  ~+
  ^-  bean
  =+  peers=.^((map ship *) /ax/(scot %p our.bol)//(scot %da now.bol)/peers)
  ?|  !=((clan:title src.bol) %pawn)
      (~(has by peers) src.bol)
  ==
::
::  +htmx: html-related helper functions and data, including css, js, components
::
++  htmx
  |%
  ++  style  |=(bol=bowl:gall (read-file:larv:fx bol /web/fund/style/css))
  ++  render
    |=  [bol=bowl:gall ord=order:rudder tyt=tape bod=manx]
    ^-  manx
    =+  go-base="https://fonts.googleapis.com"
    =+  sl-base="https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist"
    ;html
      ;head
        ;meta(charset "UTF-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
        ::  TODO: Auto-add '%fund' to the front, and '%fund - ' if 'tyt'
        ::  is non-empty
        ;title: {tyt}
        ;link/"{(aurl /asset/[~.tocwex.svg])}"(rel "icon", type "image/svg+xml");
        ;link/"{go-base}"(rel "preconnect");
        ;link/"https://fonts.gstatic.com"(rel "preconnect", crossorigin ~);
        ::  FIXME: Make this line legible somehow
        ;link/"{go-base}/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Noto+Emoji:wght@300..700&display=swap"(as "style", rel "stylesheet preload", crossorigin ~);
        ;link(rel "stylesheet", href "{sl-base}/themes/light.css");
        ;script(type "module", src "{sl-base}/shoelace-autoloader.js");
        ;script(src "/session.js");  ::  debug-only
        ;+  (inject:tonic q.byk.bol)  ::  debug-only
      ==
      ;body(class "text-base font-serif", style "visibility: hidden;")
        ;+  (header bol ord)
        ;+  bod
        ;+  (footer bol ord)
      ==
      ;+  ;script(type "module"): {^~((trip boot-js))}
      ::  ;+  %:  mx
      ::        %body
      ::        'max-w-screen-2xl mx-auto text-base font-serif'
      ::        ~[[%x-data "twind"] [%style "visibility: hidden;"]]
      ::        :(welp head body foot)
      ::      ==
    ==
  ++  header
    |=  [bol=bowl:gall ord=order:rudder]
    ^-  manx
    =/  [pat=(pole knot) *]  (durl url.request.ord)
    ;nav(class "lg:mx-4 mt-1.5 mb-2")
      ;ul(class "py-2 flex justify-between border-black border-b-2")
        ;div(class "mx-2")
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
        ==
        ;div(class "flex gap-x-2 mx-2")
          ::  FIXME: Opening login page in a new tab because opening it
          ::  in the current tab causes issues with further redirects
          ::  (e.g. to the ship login page for eAuth)
          ;button(id "login-urbit", class "text-nowrap px-2 py-1 border-2 border-black rounded-md {?:((authed bol) "" "duration-300 hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 active:bg-yellow-500 active:border-yellow-500")}")
            ;+  ?:  (authed bol)
                  ;p: {<src.bol>}
                ;a/"/~/login?redirect={(aurl pat)}"(target "_blank")
                  ; urbit login
                ==
          ==
          ;button(id "connect-wallet", class "cursor-pointer text-nowrap px-2 py-1 border-2 duration-300 border-black bg-black text-white hover:text-black rounded-md hover:rounded-lg hover:bg-white hover:border-gray-800 active:bg-gray-800 active:border-black active:text-white")
            ; connect 💰
          ==
        ==
      ==
    ==
  ++  footer
    |=  [bol=bowl:gall ord=order:rudder]
    ^-  manx
    ;footer(class "lg:mx-4")
      ;div(class "justify-center border-t-2 border-black pt-2 pb-1 lg:flex lg:flex-row-reverse lg:items-center lg:justify-between")
        ;div(class "flex justify-center grow lg:grow-0 lg:justify-end lg:p-2")
          ;div(class "px-10 lg:px-2")
            ;a(href "https://tlon.network/lure/~tocwex/syndicate-public", target "_blank")
              ;img@"{(aurl /asset/[~.urbit.svg])}";
            ==
          ==
          ;div(class "px-10 lg:px-2")
            ;a(href "https://twitter.com/tocwex", target "_blank")
              ;img@"{(aurl /asset/[~.x.svg])}";
            ==
          ==
          ;div(class "px-10 lg:px-2")
            ;a(href "https://github.com/tocwex", target "_blank")
              ;img@"{(aurl /asset/[~.github.svg])}";
            ==
          ==
        ==
        ;div(class "mb-0 mt-2 text-center text-xs lg:text-base lg:m-0 lg:p-1 lg:pb-2")
          ;div(class "mb-2 lg:mb-0 justify-center flex flex-row items-center lg:justify-start lg:px-3 hover:underline")
            ;a(href "https://tocwexsyndicate.com", target "_blank")
              ; crafted by ~tocwex.syndicate
            ==
          ==
        ==
      ==
    ==
  ++  stat-pill
    |=  sat=stat:f
    ^-  manx
    =-  ;div(class "flex mx-2 items-center")
          ;div(class "text-nowrap px-2 py-1 border-2 rounded-full font-medium {cas}")
            ; {nam}
          ==
        ==
    ^-  [nam=tape cas=tape]
    ?-    sat
      %born  ["draft" "text-gray-500 border-gray-500"]
      %prop  ["proposed" "text-gray-500 border-gray-500"]
      %lock  ["launched" "text-orange-500 border-orange-500"]
      %work  ["in-progress" "text-blue-500 border-blue-500"]
      %sess  ["in-review" "text-purple-500 border-purple-500"]
      %done  ["completed" "text-green-500 border-green-500"]
      %dead  ["canceled" "text-red-500 border-red-500"]
    ==
  --
--
