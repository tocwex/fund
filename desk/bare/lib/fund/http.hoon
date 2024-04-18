:: /lib/fund/http/hoon: http data and helper functions for %fund
::
/+  *fund, fx=fund-xtra
/+  rudder, tonic
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
      [?(%worker %oracle %funder) ~]      `[%page | %proj-list]
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
  ++  bloq                                       ::  1234.56... => "123456..."
    |=  boq=^bloq
    ^-  tape
    (a-co:co boq)
  ++  addr                                       ::  0xabcd.ef... => "0xabcdef..."
    |=  adr=^addr
    ^-  tape
    (weld "0x" ((x-co:co 40) adr))
  ++  sign                                       ::  0xabcd.ef... => "0xabcdef..."
    |=  sig=^sign
    ^-  tape
    (weld "0x" ((x-co:co 130) sig))
  ++  flag                                       ::  [~zod %nam] => "~zod/nam"
    |=  lag=^flag
    ^-  tape
    "{<p.lag>}/{(trip q.lag)}"
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
::  +take: parsing functions for text received in htmx elements
::
++  take
  |%
  ++  mony                                       ::  "12.34" => .1.2345e1
    |=  mon=@t
    ^-  @rs
    (rash mon royl-rs:so)
  ++  bloq                                       ::  "123456..." => 1234.56...
    |=  boq=@t
    ^-  ^bloq
    (rash boq dem)
  ++  addr                                       ::  "0xabcdef..." => 0xabcd.ef...
    |=  adr=@t
    ^-  ^addr
    (rash adr ;~(pfix (jest '0x') hex))
  ++  sign                                       ::  "0xabcdef..." => 0xabcd.ef...
    |=  sig=@t
    ^-  ^sign
    (rash sig ;~(pfix (jest '0x') hex))
  --
::
::  +htmx: html-related helper functions and data, including css, js, components
::
++  htmx
  |_  cas=tape
  ++  render                                     ::  render page w/ head/foot/styles/etc.
    |=  [bol=bowl:gall ord=order:rudder tyt=tape bod=manx]
    ^-  manx
    =+  go-base="https://fonts.googleapis.com"
    =+  sl-base="https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist"
    |^  ;html(hidden ~)  ::  NOTE: https://twind.dev/handbook/the-shim.html#prevent-fouc
          ;head
            ;meta(charset "UTF-8");
            ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
            ;title: {(weld "%fund - " ?~(tyt "home" tyt))}
            ;link/"{(aurl /asset/[~.tocwex.svg])}"(rel "icon", type "image/svg+xml");
            ;link/"{go-base}"(rel "preconnect");
            ;link/"https://fonts.gstatic.com"(rel "preconnect", crossorigin ~);
            ::  FIXME: Make this line legible somehow
            ;link/"{go-base}/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Roboto+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Noto+Emoji:wght@300..700&display=swap"(as "style", rel "stylesheet preload", crossorigin ~);
            ;link/"{(aurl /asset/[~.fund.css])}"(rel "stylesheet");
            ;link(rel "stylesheet", href "{sl-base}/themes/light.css");
            ;script(type "module", src "{sl-base}/shoelace-autoloader.js");
            ;script(src "/session.js");  ::  debug-only
            ;+  (inject:tonic q.byk.bol)  ::  debug-only
          ==
          ;body(class "font-serif max-w-screen-2xl min-h-screen mx-auto lg:px-4 {cas}")
            ;+  hair  ::  debug-only
            ;+  head
            ;+  bod
            ;+  foot
          ==
          ;script(type "module", src "{(aurl /asset/[~.boot.js])}");
        ==
    ++  hair
      ^-  manx
      ;div(class "flex justify-center w-full sticky top-0 bg-yellow-200 py-1 px-2 text-sm font-medium")
        ; ⚠ TESTNET (SEPOLIA) VERSION ⚠
      ==
    ++  head
      ^-  manx
      =/  [pat=(pole knot) *]  (durl url.request.ord)
      ;nav(class "flex justify-between items-center p-2 border-black border-b-2")
        ;+  ?:  ?=(?([%dashboard *] [%create %proj ~] [%project @ @ %edit ~]) pat)
              ;a.fund-butn-link/"{(aurl (snip `(list knot)`pat))}": ← back
            ;a.fund-tytl-link/"{(aurl /)}": %fund
        ;div(class "flex gap-x-2")
          ::  FIXME: Opening login page in a new tab because opening it
          ::  in the current tab causes issues with further redirects
          ::  (e.g. to the ship login page for eAuth)
          ;+  ?:  (auth bol)
                ;a.fund-butn-link/"/~/logout?redirect={(aurl pat)}": {<src.bol>}
              ;a.fund-butn-link/"/~/login?eauth&redirect={(aurl pat)}"(target "_blank"): login ~
          ;button#fund-butn-wallet.fund-butn-wallet: …loading…
        ==
      ==
    ++  foot
      ^-  manx
      ::  NOTE: CSS trick for pushing footer to page bottom
      ::  https://stackoverflow.com/a/71444859
      ;footer(class "sticky top-[100vh] justify-center border-t-2 p-2 border-black lg:flex lg:p-4 lg:flex-row-reverse lg:items-center lg:justify-between")
        ;div(class "flex justify-center grow gap-20 lg:gap-4 lg:grow-0 lg:justify-end")
          ;a/"https://tlon.network/lure/~tocwex/syndicate-public"(target "_blank")
            ;img@"{(aurl /asset/[~.urbit.svg])}";
          ==
          ;a/"https://x.com/tocwex"(target "_blank")
            ;img@"{(aurl /asset/[~.x.svg])}";
          ==
          ;a/"https://github.com/tocwex"(target "_blank")
            ;img@"{(aurl /asset/[~.github.svg])}";
          ==
        ==
        ;div(class "text-center text-xs pt-1 lg:pt-0 lg:text-base")
          ;div(class "flex justify-center items-center lg:justify-start hover:underline")
            ;a/"https://tocwexsyndicate.com"(target "_blank")
              ; crafted by ~tocwex.syndicate
            ==
          ==
        ==
      ==
    --
  ++  odit-ther                                  ::  funding thermometer element
    |=  odi=odit
    ^-  manx
    ::  TODO: Clean up the overage handling code in here.
    |^  =+  ovr=(need void:(filo odi))
        =+  udr=(sig:rs ovr)
        =?  ovr  !udr  (mul:rs .-1 ovr)
        =+  tot=`@rs`(add:rs cost.odi ?:(udr .0 ovr))
        =+  odz=`(list @rs)`~[?:(udr fill.odi cost.odi) plej.odi ovr]
        =+  naz=`(list tape)`~["funded" "pledged" ?:(udr "unfunded" "above goal")]
        =+  caz=`(list tape)`~["bg-green-500" "bg-yellow-500" ?:(udr "bg-gray-500" "bg-blue-500")]
        ::  FIXME: Funding percentage calculations aren't right when there
        ::  are overages (since we renormalize to overage amount).
        =+  cez=?:((equ:rs .0 tot) `(list @rs)`~[.0 .0 .100] (turn odz (rcen tot)))
        =+  dez=(iron (turn cez cend))
        ;div(class "fund-odit-ther {cas}")
          ;*  %+  murn  :(izip:fx odz naz caz cez dez)
              |=  [dol=@rs nam=tape kas=tape cen=@rs den=@ud]
              ^-  (unit manx)
              ?:  =(0 den)  ~
              :-  ~
              ;div(title "{(mony:dump cen)}% {nam}", class "fund-odit-sect w-[{<den>}%] {kas}")
                ; ${(mony:dump dol)}
              ==
        ==
    ++  rcen                                     ::  odit segment to percentage
      |=  tot=@rs
      |=  val=@rs
      ^-  @rs
      (mul:rs .100 (div:rs val tot))
    ++  cend                                     ::  odit percentage to decimal
      |=  val=@rs
      ^-  @ud
      ?:  (equ:rs val .0)  0
      ?:  (lth:rs val .1)  1
      (abs:si (need (~(toi rs %n) val)))
    ++  iron                                     ::  odit decimals ironed to sum 100
      |=  lis=(list @ud)
      ^-  (list @ud)
      =+  sum=(roll lis add)
      =+  dif=(dif:si (sun:si sum) --100)
      ?+  cmp=(cmp:si dif --0)  lis
          %-1   ::  sum < 100; give lacking to lowest value
        =-  (snap lis -(+ (add -> (abs:si dif))))
        %+  roll  (enum:fx lis)
        |:([n=[0 0] a=[0 200]] ?:(&(!=(0 +.n) (lth +.n +.a)) n a))
      ::
          %--1  ::  sum > 100; take excess from highest value
        =-  (snap lis -(+ (sub -> (abs:si dif))))
        %+  roll  (enum:fx lis)
        |:([n=[0 0] a=[0 1]] ?:((gth +.n +.a) n a))
      ==
    --
  ++  stat-pill                                  ::  status pill element
    |=  sat=stat
    ^-  manx
    =-  ;div(class "fund-pill {kas} {cas}"): {nam}
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
  ++  prod-butn                                  ::  prod/poke/action button
    |=  [pod=@tas clr=?(%red %black %green) txt=tape dis=tape]
    ^-  manx
    ::  TODO: Use on-click tooltips in order to allow disabled buttons
    ::  to perform error reporting on mobile
    :_  ; {txt}
    :-  %button
    %+  welp  ?~(dis ~ ~[[%disabled ~] [%title dis]])
    :~  [%id "prod-butn-{(trip pod)}"]
        [%type "submit"]
        [%name "act"]
        [%value (trip pod)]
        [%class "fund-butn-{(trip clr)} {cas}"]
    ==
  --
--
