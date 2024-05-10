:: /lib/fund/http/hoon: http data and helper functions for %fund
::
/+  *fund, fx=fund-xtra
/+  config, mu=manx-utils, rudder, tonic
|%
::
::  +auth: is `src.bowl` in the given bowl an authenticated user?
::
++  auth
  |=  bol=bowl:gall  ~+
  ^-  bean
  =+  peers=.^((map ship *) /ax/(scot %p our.bol)//(scot %da now.bol)/peers)
  ?|  !=(%pawn (clan:title src.bol))
      (~(has by peers) src.bol)
  ==
::
::  +alix: al(pine-)i(fy) (man)x (search/replace non-@tas alpine tags)
::
::    x-on-* => x-on:*
::
++  alix
  |=  man=manx
  ^-  manx
  %-  ~(apply-attrs mu man)
  |=  [man=mane tap=tape]
  :_  tap
  ?^  man  man
  ?.  =('x-on-' (dis 'x-on-' man))  man
  =+  pre=[3 (met 3 'x-on-')]
  (con 'x-on:' (lsh pre (rsh pre man)))
::
::  +parz: parse POST request parameters considering required arguments
::
::    ?+  arz=(parz:http bod (sy ~[%req ...]))  p.arz  [%| *]
::      ::  ... process `arz` here ...
::    ==
::
++  parz
  ::  TODO: Update this function to be capable of accepting and applying
  ::  coercion functions to the required arguments (e.g. this must be a
  ::  @t that can be parsed as an ethereum address @ux)
  |=  [bod=(unit octs) rex=(set @t)]
  ^-  (each @t (map @t @t))
  ?~  bod  &+'no http request body provided'
  =/  hav=(map @t @t)  (frisk:rudder q.u.bod)
  =/  mis=(set @t)  (~(dif in rex) ~(key by hav))
  ?:  =(0 ~(wyt in mis))  |+hav
  &+(crip "missing required arguments: {<mis>}")
::
::  +route: rudder-related transformer of url ($trail) into (potential)
::  page id ($place)
::
++  route
  ^-  route:rudder
  |=  tyl=trail:rudder
  ^-  (unit place:rudder)
  =/  syt=(list @t)  site.tyl
  =/  pat=(pole knot)  (need (decap:rudder /apps/fund syt))
  ?:  ?=([%$ *] (flop pat))                      `[%away (snip syt)]
  ?+  pat                                        ~
    ~                                            `[%page | %index]
    [%asset *]                                   `[%page | %asset]
    [%config ~]                                  `[%page | %config]
    [%dashboard suf=*]    ?+  suf.pat            ~
      ~                                          `[%away (snip syt)]
      [?(%worker %oracle %funder) ~]             `[%page | %proj-list]
    ==
    [%create suf=*]       ?+  suf.pat            ~
      ~                                          `[%away (snip syt)]
      [%project ~]                               `[%page | %proj-edit]
    ==
    [%next @ @ @ ~]                              `[%page | %proj-next]
    [%project @ @ suf=*]  ?+  suf.pat            ~
      ~                                          `[%page | %proj-view]
      [%edit ~]                                  `[%page | %proj-edit]
    ==
  ==
::
::  +preface: rudder page trandformers (primarily for pre-render checks)
::
++  preface
  |%
  ++  dump                                       ::  print input data
    |=  pag=pag-now
    ^-  pag-now
    |_  [bol=bowl:gall ord=order:rudder dat=dat-now]
    +*  tis  ~(. pag bol ord dat)
        dum  !<(bean (slot:config %debug))
        url  (spud (slag:derl:format url.request.ord))
    ++  argue
      |=  [hed=header-list:http bod=(unit octs)]
      ~?  dum  ">> POST @ {url} : arz({<?~(bod ~ (frisk:rudder q.u.bod))>})"
      (argue:tis hed bod)
    ++  final
      |=  [gud=? txt=brief:rudder]
      ~?  dum  ">> PUT @ {url} : gud({<gud>}), txt({(trip ?~(txt '~' txt))})"
      (final:tis gud txt)
    ++  build
      |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
      ~?  dum  ">> GET @ {url} : arz({<arz>})"
      (build:tis arz msg)
    --
  ++  init                                       ::  initialization checks
    |=  pag=pag-now
    ^-  pag-now
    |_  [bol=bowl:gall ord=order:rudder dat=dat-now]
    +*  tis  ~(. pag bol ord dat)
    ++  argue
      |=  [hed=header-list:http bod=(unit octs)]
      ?.(init.dat 'must initialize config before app use' (argue:tis hed bod))
    ++  final
      |=  [gud=? txt=brief:rudder]
      ?.(init.dat [%next (desc:enrl:format /config) ~] (final:tis gud txt))
    ++  build
      |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
      ?.(init.dat [%next (desc:enrl:format /config) ~] (build:tis arz msg))
    --
  ++  mine                                       ::  `our`-restricted checks
    |=  pag=pag-now
    ^-  pag-now
    |_  [bol=bowl:gall ord=order:rudder dat=dat-now]
    +*  tis  ~(. pag bol ord dat)
        myn  =(our src):bol
    ++  argue
      |=  [hed=header-list:http bod=(unit octs)]
      ?.(myn 'unauthorized POST request' (argue:tis hed bod))
    ++  final
      |=  [gud=? txt=brief:rudder]
      ?.(myn [%auth url.request.ord] (final:tis gud txt))
    ++  build
      |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
      ?.(myn [%auth url.request.ord] (build:tis arz msg))
    --
  ++  proj                                       ::  project checks
    =<  core
    |%
    ++  grab
      |=  arz=(pole [@t @t])
      ^-  [(unit flag) (unit prej)]
      ?+    arz  [~ ~]
          [[%flag lag=@] [%proj pro=@] *]
        [;;((unit flag) (cue lag.arz)) ;;((unit prej) (cue pro.arz))]
      ==
    ++  greb
      |=  arz=(pole [@t @t])
      ^-  [flag prej]
      =+  g=(grab arz)
      [(need -.g) (need +.g)]
    ++  gref
      |=  txt=brief:rudder
      ^-  [flag @tas]
      ;;([flag @tas] (cue txt))
    ++  core
      |=  req=_|
      |=  pag=pag-now
      ^-  pag-now
      |_  [bol=bowl:gall ord=order:rudder dat=dat-now]
      +*  tis  ~(. pag bol ord dat)
      ::  FIXME: Should probably make these hacky argument names more unique
      ++  argue
        |=  [hed=header-list:http bod=(unit octs)]
        =/  lag=(unit flag)  (flag:derl:format url.request.ord)
        =/  pro=(unit prej)  ?~(lag ~ (~(get by (prez-ours:sss bol dat)) u.lag))
        ?:  &(req ?=(~ pro))  'project does not exist'
        (argue:tis [[%flag (jam lag)] [%proj (jam pro)] hed] bod)
      ++  final
        |=  [gud=? txt=brief:rudder]
        ?.  gud  [%code 500 txt]
        (final:tis gud (jam (poke:dejs:format ?~(txt '' txt))))
      ++  build
        |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
        =/  lag=(unit flag)  (flag:derl:format url.request.ord)
        =/  pro=(unit prej)  ?~(lag ~ (~(get by (prez-ours:sss bol dat)) u.lag))
        ?:  &(req ?=(~ pro))  [%code 404 'project does not exist']
        (build:tis [[%flag (jam lag)] [%proj (jam pro)] arz] msg)
      --
    --
  ++  pass                                       ::  no effect (placeholder)
    |=  pag=pag-now
    ^-  pag-now
    |_  [bol=bowl:gall ord=order:rudder dat=dat-now]
    +*  tis  ~(. pag bol ord dat)
    ++  argue  |=([hed=header-list:http bod=(unit octs)] (argue:tis hed bod))
    ++  final  |=([gud=? txt=brief:rudder] (final:tis gud txt))
    ++  build  |=([arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])] (build:tis arz msg))
    --
  --
::
::  +format: formatting functions between htmx/js-compatible tapes and nouns
::
++  format
  |%
  +|  %url
  ++  derl                                       ::  rl-path => noun
    |%
    ++  slag                                     ::  (url path) suffix
      |=  cor=cord  ~+
      ^-  path
      =/  [pre=tape suf=tape]  (chop:fx (trip cor) '?')
      (need (decap:rudder /apps/fund (stab (crip pre))))
    ++  flag                                     ::  (url path) (project) flag
      |=  cor=cord  ~+
      ^-  (unit ^flag)
      ?+  pat=`(pole knot)`(slag cor)  ~
        [@ sip=@ nam=@ *]  (both (slaw %p sip.pat) (slaw %tas nam.pat))
      ==
    --
  ++  enrl                                       ::  noun => rl-path
    |%
    ++  dest                                     ::  des(k) t(ape) (url path)
      |=  pat=path  ~+
      ^-  tape
      (spud [%apps %fund pat])
    ++  desc                                     ::  des(k) c(ord) (url path)
      |=  pat=path  ~+
      ^-  cord
      (spat [%apps %fund pat])
    ++  chat                                     ::  cha(t) t(ape) (url path)
      |=  sip=@p  ~+
      ^-  tape
      (spud /apps/groups/dm/(scot %p sip))
    ++  chac                                     ::  cha(t) c(ord) (url path)
      |=  sip=@p  ~+
      ^-  cord
      (spat /apps/groups/dm/(scot %p sip))
    ++  flat                                     ::  fla(g) t(ape) (url path)
      |=  lag=flag  ~+
      ^-  tape
      (dest /project/(scot %p p.lag)/[q.lag])
    ++  flac                                     ::  fla(g) c(ord) (url path)
      |=  lag=flag  ~+
      ^-  cord
      (desc /project/(scot %p p.lag)/[q.lag])
    --

  +|  %js
  ++  dejs                                       ::  js-tape => noun
    |%
    ++  mony                                     ::  "12.34" => .1.2345e1
      |=  mon=@t
      ^-  @rs
      (rash mon royl-rs:so)
    ++  bloq                                     ::  "123456..." => 1234.56...
      |=  boq=@t
      ^-  ^bloq
      (rash boq dem)
    ++  addr                                     ::  "0xabcdef..." => 0xabcd.ef...
      |=  adr=@t
      ^-  ^addr
      (rash adr ;~(pfix (jest '0x') hex))
    ++  sign                                     ::  "0xabcdef..." => 0xabcd.ef...
      |=  sig=@t
      ^-  ^sign
      (rash sig ;~(pfix (jest '0x') hex))
    ++  flag                                     ::  "~zod/nam" => [~zod %nam]
      |=  lag=@t
      ^-  ^flag
      (rash lag ;~((glue fas) ;~(pfix sig fed:ag) sym))
    ++  poke                                     ::  "~zod/nam:typ" => [p=[~zod %nam] q=%typ]
      |=  pok=@t
      ^-  (pair ^flag @tas)
      (rash pok ;~((glue col) ;~((glue fas) ;~(pfix sig fed:ag) sym) sym))
    --
  ++  enjs                                       ::  noun => js-tape
    |%
    ++  mony                                     ::  .1.2345e1 => "12.34"
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
    ++  bloq                                     ::  1234.56... => "123456..."
      |=  boq=^bloq
      ^-  tape
      (a-co:co boq)
    ++  addr                                     ::  0xabcd.ef... => "0xabcdef..."
      |=  adr=^addr
      ^-  tape
      ['0' 'x' ((x-co:co 40) adr)]
    ++  sign                                     ::  0xabcd.ef... => "0xabcdef..."
      |=  sig=^sign
      ^-  tape
      ['0' 'x' ((x-co:co 130) sig)]
    ++  flag                                     ::  [~zod %nam] => "~zod/nam"
      |=  lag=^flag
      ^-  tape
      "{<p.lag>}/{(trip q.lag)}"
    ++  poke                                     ::  [[~zod %nam] %type ...] => "~zod/name:type"
      |=  pok=^poke
      ^-  tape
      "{(flag p.pok)}:{(trip -.q.pok)}{?.(?=(%bump -.q.pok) ~ ['-' (trip +<.q.pok)])}"
    ++  role                                     ::  %orac => "oracle"
      |=  rol=^role
      ^-  tape
      ?-  rol
        %work  "worker"
        %orac  "oracle"
        %fund  "funder"
      ==
    ++  mula                                     ::  [%plej ...] => "pledged"
      |=  mul=^mula
      ^-  tape
      ?-  -.mul
        %plej  "pledged"
        %trib  "fulfilled"
      ==
    ++  stat                                     ::  %born => "draft"
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
    |^  =-  (alix -)
        ;html(hidden ~)  ::  NOTE: https://twind.dev/handbook/the-shim.html#prevent-fouc
          ;head
            ;meta(charset "UTF-8");
            ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
            ::  OpenGraph Meta Tags
            ;meta(property "og:type", content "website");
            ;meta(property "og:title", content (trip !<(@t (slot:config %meta-tytl))));
            ;meta(property "og:description", content (trip !<(@t (slot:config %meta-desc))));
            ;meta(property "og:url", content (trip !<(@t (slot:config %site-corp))));
            ;meta(property "og:image", content (trip !<(@t (slot:config %meta-logo))));
            ::  Twitter/X Meta Tags
            ;meta(name "twitter:card", content "summary_large_image");
            ;meta(property "twitter:domain", content (trip !<(@t (slot:config %site-base))));
            ;meta(property "twitter:url", content (trip !<(@t (slot:config %site-corp))));
            ;meta(name "twitter:title", content (trip !<(@t (slot:config %meta-tytl))));
            ;meta(name "twitter:description", content (trip !<(@t (slot:config %meta-desc))));
            ;meta(name "twitter:image", content (trip !<(@t (slot:config %meta-logo))));
            ::  Website Meta Data/Libraries
            ;title: {(weld "%fund - " ?~(tyt "home" tyt))}
            ;link/"{(dest:enrl:format /asset/[~.tocwex.svg])}"(rel "icon", type "image/svg+xml");
            ;link/"{go-base}"(rel "preconnect");
            ;link/"https://fonts.gstatic.com"(rel "preconnect", crossorigin ~);
            ::  FIXME: Make this line legible somehow
            ;link/"{go-base}/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Roboto+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Noto+Emoji:wght@300..700&display=swap"(as "style", rel "stylesheet preload", crossorigin ~);
            ;link/"{(dest:enrl:format /asset/[~.fund.css])}"(rel "stylesheet");
            ;*  ?.  !<(bean (slot:config %debug))  ~
                :~  ;script(src "/session.js");
                    (inject:tonic q.byk.bol)
                ==
            ;script(type "module", src "{(dest:enrl:format /asset/[~.boot.js])}");
          ==
          ;body(class "font-serif max-w-screen-2xl min-h-screen mx-auto lg:px-4 {cas}", x-data "fund")
            ;*  ?.(!<(bean (slot:config %debug)) ~ [hair]~)
            ;+  head
            ;+  bod
            ;+  foot
          ==
        ==
    ++  hair
      ^-  manx
      =+  !<(can=@tas (slot:config %chain))
      =+  cat=?:(=(%mainnet can) "mainnet" "testnet ({(cuss (trip can))})")
      ;div(class "flex justify-center w-full sticky top-0 bg-yellow-200 py-1 px-2 text-sm font-medium")
        ; ⚠ {(cuss cat)} VERSION ⚠
      ==
    ++  head
      ^-  manx
      =/  url=@t  url.request.ord
      =/  pat=(pole knot)  (slag:derl:format url)
      ;nav(class "flex justify-between items-center p-2 border-black border-b-2")
        ;+  ?:  ?=(?([%dashboard *] [%create %proj ~] [%project @ @ %edit ~]) pat)
              ;a.fund-butn-link/"{(dest:enrl:format (snip `(list knot)`pat))}": ← back
            ;a.fund-tytl-link/"{(dest:enrl:format /)}": %fund
        ;div(class "flex gap-x-2")
          ::  FIXME: Opening login page in a new tab because opening it
          ::  in the current tab causes issues with turbojs in-place loading
          ;*  ?.  =(our src):bol  ~
              :~  ;a.w-8.h-8/"{(dest:enrl:format /config)}"
                    ;img@"{(dest:enrl:format /asset/[~.gear.svg])}";
              ==  ==
          ;+  ?:  (auth bol)
                ?:  =(our src):bol
                  ;div.fund-butn-base: {<src.bol>}
                ;a.fund-butn-link/"/~/logout?redirect={(trip url)}": {<src.bol>}
              ;a.fund-butn-link/"/~/login?eauth&redirect={(trip url)}"(target "_blank"): login ~
          ;button#fund-butn-wallet.fund-butn-effect: …loading…
        ==
      ==
    ++  foot
      ^-  manx
      ::  NOTE: CSS trick for pushing footer to page bottom
      ::  https://stackoverflow.com/a/71444859
      ;footer(class "sticky top-[100vh] justify-center border-t-2 p-2 border-black lg:flex lg:p-4 lg:flex-row-reverse lg:items-center lg:justify-between")
        ;div(class "flex justify-center grow gap-20 lg:gap-4 lg:grow-0 lg:justify-end")
          ;a/"https://tlon.network/lure/~tocwex/syndicate-public"(target "_blank")
            ;img@"{(dest:enrl:format /asset/[~.urbit.svg])}";
          ==
          ;a/"https://x.com/tocwex"(target "_blank")
            ;img@"{(dest:enrl:format /asset/[~.x.svg])}";
          ==
          ;a/"https://github.com/tocwex"(target "_blank")
            ;img@"{(dest:enrl:format /asset/[~.github.svg])}";
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
        =/  odz=(list @rs)
          ?:  udr  ~[fill.odi plej.odi ovr]
          =+  [fre=fill.odi pre=plej.odi]
          =+  fos=cost.odi
          =+  fil=?:((lte:rs fre fos) fre fos)
          =+  pos=(sub:rs fos fil)
          =+  pej=?:((lte:rs pre pos) pre pos)
          ~[fil pej ovr]
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
              ;div(title "{(mony:enjs:format cen)}% {nam}", class "fund-odit-sect w-[{<den>}%] {kas}")
                ; ${(mony:enjs:format dol)}
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
    =-  [(stat:enjs:format sat) "text-{-} border-{-}"]
    ?-  sat
      ?(%born %prop)  "gray-500"
      %lock  "orange-500"
      %work  "blue-500"
      %sess  "purple-500"
      %done  "green-500"
      %dead  "red-500"
    ==
  ++  copy-butn                                  ::  copy project link button
    |=  [txt=tape]
    :_  ; {txt}
    :-  %button
    :~  [%type "button"]
        [%title "copy url"]
        [%class "fund-butn-effect {cas}"]
        [%x-data ~]
        [%x-on-click "copyPURL(); swapText($el, 'copied ✔️');"]
    ==
  ++  link-butn                                  ::  hyperlink/redirect button
    |=  [wer=tape tab=bean txt=tape dis=tape]
    ^-  manx
    :_  ; {txt}
    :-  %a
    ;:  welp
        ?~(dis ~ ~[[%disabled ~] [%title dis]])
        ?.(tab ~ ~[[%target "_blank"]])
        [%href wer]~
        [%class "fund-butn-link {cas}"]~
    ==
  ++  prod-butn                                  ::  prod/poke/action button
    |=  [pod=@tas clr=?(%red %black %green) txt=tape xon=tape dis=tape]
    ^-  manx
    ::  TODO: Use on-click tooltips in order to allow disabled buttons
    ::  to perform error reporting on mobile
    :_  ; {txt}
    :-  %button
    ;:  welp
        ?~(dis ~ ~[[%disabled ~] [%title dis]])
        ?~(xon ~ ~[[%x-data ~] [%x-on-click xon]])
        [%id "prod-butn-{(trip pod)}"]~
        [%type "submit"]~
        [%name "act"]~
        [%value (trip pod)]~
        [%class "fund-butn-{(trip clr)} {cas}"]~
    ==
  --
--
