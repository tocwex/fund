:: /lib/fund/http/hoon: http data and helper functions for %fund
::
/-  fd=fund-data
/+  *fund, format=fund-form, fx=fund-xtra
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
::    xlass => :class
::
++  alix
  |=  man=manx
  ^-  manx
  %-  ~(apply-attrs mu man)
  |=  [man=mane tap=tape]
  :_  tap
  ?^  man  man
  ?:  =(%xlass man)  ':class'
  ?:  =(%x-on- (dis %x-on- man))
    =+  pre=[3 (met 3 %x-on-)]
    (con 'x-on:' (lsh pre (rsh pre man)))
  man
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
    |=  pag=page:fd
    ^-  page:fd
    |_  [bol=bowl:gall ord=order:rudder dat=data:fd]
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
    |=  pag=page:fd
    ^-  page:fd
    |_  [bol=bowl:gall ord=order:rudder dat=data:fd]
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
    |=  pag=page:fd
    ^-  page:fd
    |_  [bol=bowl:gall ord=order:rudder dat=data:fd]
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
      |=  pag=page:fd
      ^-  page:fd
      |_  [bol=bowl:gall ord=order:rudder dat=data:fd]
      +*  tis  ~(. pag bol ord dat)
      ::  FIXME: Should probably make these hacky argument names more unique
      ++  argue
        |=  [hed=header-list:http bod=(unit octs)]
        =/  lag=(unit flag)  (flag:derl:format url.request.ord)
        =/  pro=(unit prej)  ?~(lag ~ (~(get by ~(ours conn:proj:fd bol +.dat)) u.lag))
        ?:  &(req ?=(~ pro))  'project does not exist'
        (argue:tis [[%flag (jam lag)] [%proj (jam pro)] hed] bod)
      ++  final
        |=  [gud=? txt=brief:rudder]
        ?.  gud  [%code 500 txt]
        (final:tis gud (jam (poke:dejs:format ?~(txt '' txt))))
      ++  build
        |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
        =/  lag=(unit flag)  (flag:derl:format url.request.ord)
        =/  pro=(unit prej)  ?~(lag ~ (~(get by ~(ours conn:proj:fd bol +.dat)) u.lag))
        ?:  &(req ?=(~ pro))  [%code 404 'project does not exist']
        (build:tis [[%flag (jam lag)] [%proj (jam pro)] arz] msg)
      --
    --
  ++  pass                                       ::  no effect (placeholder)
    |=  pag=page:fd
    ^-  page:fd
    |_  [bol=bowl:gall ord=order:rudder dat=data:fd]
    +*  tis  ~(. pag bol ord dat)
    ++  argue  |=([hed=header-list:http bod=(unit octs)] (argue:tis hed bod))
    ++  final  |=([gud=? txt=brief:rudder] (final:tis gud txt))
    ++  build  |=([arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])] (build:tis arz msg))
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
    =-  (alix -)
    |^  ;html(class "!block", style "display: none;")  ::  NOTE: https://twind.style/installation
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
            ;link/"https://fonts.googleapis.com"(rel "preconnect");
            ;link/"https://fonts.gstatic.com"(rel "preconnect", crossorigin ~);
            ::  FIXME: Make this line legible somehow
            ;link/"https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Inter:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Ubuntu+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Noto+Emoji:wght@300..700&display=swap"(as "style", rel "stylesheet preload", crossorigin ~);
            ;link/"{(dest:enrl:format /asset/[~.fund.css])}"(rel "stylesheet");
            ;*  ?.  !<(bean (slot:config %debug))  ~
                :~  ;script(src "/session.js");
                    (inject:tonic q.byk.bol)
                ==
            ;script(type "module", src "{(dest:enrl:format /asset/[~.boot.js])}");
          ==
          ;body
              =class   "font-sans max-w-screen-2xl min-h-screen mx-auto bg-primary-500 lg:px-4 {cas}"
              =x-data  "fund"
            ;*  ?.(!<(bean (slot:config %debug)) ~ [hair]~)
            ;+  head
            ;+  bod
            ;+  foot
          ==
        ==
    ++  hair
      ^-  manx
      ;div(class "flex justify-center w-full sticky top-0 bg-primary-600 py-1 text-sm")
        ; ⚠ DEBUG ENABLED ⚠
      ==
    ++  head
      ^-  manx
      =/  url=@t  url.request.ord
      =/  pat=(pole knot)  (slag:derl:format url)
      ;nav(class "flex justify-between items-center p-2 border-black border-b-2")
        ;+  ?:  ?=(?([%dashboard *] [%create %proj ~] [%project @ @ %edit ~]) pat)
              ;a.fund-butn-de-m/"{(dest:enrl:format (snip `(list knot)`pat))}": ← back
            ;h4.fund-tytl-link/"{(dest:enrl:format /)}": %fund
        ;div(class "flex gap-x-2")
          ::  FIXME: Opening login page in a new tab because opening it
          ::  in the current tab causes issues with turbojs in-place loading
          ;*  ?.  =(our src):bol  ~
              :_  ~  ;a.fund-butn-de-m/"{(dest:enrl:format /config)}": ⚙️
          ;+  ?:  (auth bol)
                ?:  =(our src):bol
                  ;button.fund-butn-de-m(disabled ~): {<src.bol>}
                ;a.fund-butn-de-m/"/~/logout?redirect={(trip url)}": {<src.bol>}
              ;a.fund-butn-de-m/"/~/login?eauth&redirect={(trip url)}"(target "_blank"): login ~
          ;button#fund-butn-wallet.fund-butn-co-m: …loading…
        ==
      ==
    ++  foot
      ^-  manx
      ::  NOTE: CSS trick for pushing footer to page bottom
      ::  https://stackoverflow.com/a/71444859
      ;footer(class "sticky top-[100vh] justify-center border-t-2 p-2 border-black lg:flex lg:p-4 lg:items-center lg:justify-between")
        ;div(class "text-center text-xs pt-1 lg:pt-0 lg:text-base")
          ;div(class "flex justify-center items-center lg:justify-start hover:underline")
            ;a/"https://tocwexsyndicate.com"(target "_blank"): crafted by ~tocwex.syndicate
          ==
        ==
        ;div(class "flex justify-center grow gap-20 lg:gap-4 lg:grow-0 lg:justify-end")
          ;a/"https://github.com/tocwex"(target "_blank")
            ;img@"{(dest:enrl:format /asset/[~.github.svg])}";
          ==
          ;a/"https://tlon.network/lure/~tocwex/syndicate-public"(target "_blank")
            ;img@"{(dest:enrl:format /asset/[~.urbit.svg])}";
          ==
          ;a/"https://x.com/tocwex"(target "_blank")
            ;img@"{(dest:enrl:format /asset/[~.x.svg])}";
          ==
          ;a/"https://tocwexsyndicate.com"(target "_blank")
            ;img@"{(dest:enrl:format /asset/[~.globe.svg])}";
          ==
        ==
      ==
    --
  ++  hero-plaq                                  ::  full-page notification w/ buttons
    |=  [tyt=@t txt=(unit @t) buz=marl]
    ^-  manx
    ;form#maincontent(method "post", class "p-2 h-[80vh] {cas}")
      ;div(class "flex flex-col h-full flex-wrap justify-center items-center text-center gap-10")
        ;div(class "text-4xl sm:text-5xl"): {(trip tyt)}
        ;*  ?~  txt  ~
            :_  ~  ;div(class "text-xl sm:text-2xl"): {(trip u.txt)}
        ;div(class "flex gap-2")
          ;*  buz
        ==
      ==
    ==
  ++  odit-ther                                  ::  funding thermometer element
    |=  odi=odit
    ^-  manx
    ::  TODO: Clean up the overage handling code in here.
    |^  =+  [udr ovr]=(need void:(filo odi))
        =+  tot=(add cost.odi ?:(udr 0 ovr))
        =/  caz=(list cash)
          ?:  udr  ~[fill.odi plej.odi ovr]
          =+  [fre=fill.odi pre=plej.odi]
          =+  fos=cost.odi
          =+  fil=?:((lte fre fos) fre fos)
          =+  pos=(sub fos fil)
          =+  pej=?:((lte pre pos) pre pos)
          ~[fil pej ovr]
        =+  naz=`(list tape)`~["funded" "pledged" ?:(udr "unfunded" "above goal")]
        =+  kaz=`(list tape)`~["bg-green-500" "bg-yellow-500" ?:(udr "bg-gray-500" "bg-blue-500")]
        ::  FIXME: Funding percentage calculations aren't right when there
        ::  are overages (since we renormalize to overage amount).
        =/  cez=(list @rs)  ?:(=(0 tot) ~[.0 .0 .100] (turn caz (cury rcen tot)))
        =+  dez=(iron (turn cez cend))
        ;div(class "fund-odit-ther {cas}")
          ;*  %+  murn  :(izip:fx caz naz kaz cez dez)
              |=  [cas=cash nam=tape kas=tape cen=@rs den=@ud]
              ^-  (unit manx)
              ?:  =(0 den)  ~
              :-  ~
              ;div(title "{(real:enjs:format cen)}% {nam}", class "fund-odit-sect w-[{<den>}%] {kas}")
                ; ${(cash:enjs:format cas)}
              ==
        ==
    ++  rcen                                     ::  odit segment to percentage
      |=  [tot=cash val=cash]
      ^-  @rs
      (mul:rs .100 (div:rs (sun:rs val) (sun:rs tot)))
    ++  cend                                     ::  odit percentage to decimal
      |=  val=@rs
      ^-  @ud
      ?:  (equ:rs val .0)  0
      ?:  (lte:rs val .1)  1
      (abs:si (need (toi:rs val)))
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
  ++  mark-well                                  ::  markdown (github) well
    |=  [txt=tape big=bean]
    ^-  manx
    =+  kas=?:(big "" "line-clamp-5")
    ;zero-md(class "w-full {kas} {cas}", xlass "cmd()", no-shadow ~)
      ;template
        ;link/"{(dest:enrl:format /asset/[~.mark.css])}"(rel "stylesheet");
      ==
      ;script(type "text/markdown"): {txt}
    ==
  ++  udon-well                                  ::  udon (hoon-markdown) well
    |=  [txt=tape big=bean]
    ^-  manx
    |^  (post udon)
    ++  udon                                     ::  generate udon from text
      ^-  manx
      ::  FIXME: Figure out how to get 'line-clamp' to override 'flex'
      ::  display CSS to allow for line breaks in previews
      =+  kas=?:(big "flex flex-col gap-3" "line-clamp-5")
      =-  -(a.g [[%class "{kas} {cas}"] a.g])
      ^-  manx
      ?-  udo=(mule |.(!<(manx (slap !>(~) (ream (crip ";>\0a{txt}\0a"))))))
        [%& *]  +.udo
        [%| *]  ;p: {txt}
      ==
    ++  post                                     ::  apply attribute post-processing
      |=  man=manx
      ^-  manx
      =-  %-  ~(apply-elem mu -)
          |=([n=mane t=mart] [n ?+(n t %a [[%class "fund-link"] t])])
      %-  ~(post-apply-nodes mu man)
      |=  [[man=mane mat=mart] mal=marl]
      ?+    man  [[man mat] mal]
          %pre                                   ::  pre: add inner code block
        :-  [man [[%class "min-w-full inline-block"] mat]]
        [[%code [%class "block py-2 px-3"]~] mal]~
      ::
          %img                                   ::  img: shrink to a if !big
        ?:  big  [[man mat] mal]
        =/  src=(unit [mane tape])  (find:fx mat |=([m=mane tape] =(%src m)))
        =/  alt=(unit [mane tape])  (find:fx mat |=([m=mane tape] =(%alt m)))
        :-  [%a ?~(src mat [[%href +.u.src] mat])]
        :_  mal
        ;span: {?^(alt +.u.alt ?^(src +.u.src (dest:enrl:format /)))}
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
  ++  cheq-swix                                  ::  checkbox switch <o->
    |=  nam=@tas
    ^-  manx
    ;label(class "cursor-pointer {cas}")
      ;input(name (trip nam), type "checkbox", class "sr-only peer");
      ;div(class "relative w-8 h-4 bg-primary-500 border-2 border-secondary-500 rounded-full peer-checked:after:translate-x-[175%] after:content-[''] after:absolute after:top-[1px] after:bg-secondary-450 peer-checked:after:bg-primary-500 after:rounded-full after:h-2.5 after:w-2.5 after:transition-transform peer-checked:bg-secondary-450");
    ==
  ++  copy-butn                                  ::  copy project link button
    |=  txt=tape
    ^-  manx
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
        [%class "fund-butn-de-m {cas}"]~
    ==
  ++  prod-butn                                  ::  prod/poke/action button
    |=  [pod=@tas typ=?(%action %true %false) txt=tape xon=tape diz=tape]
    ^-  manx
    =/  tip=@tas  (dis typ (dec (bex 16)))
    ::  TODO: Use on-click tooltips in order to allow disabled buttons
    ::  to perform error reporting on mobile
    :_  ; {txt}
    :-  %button
    ;:  welp
        ?~(diz ~ ~[[%disabled ~] [%title diz]])
        ?~(xon ~ ~[[%x-data ~] [%x-on-click xon]])
        [%id "prod-butn-{(trip pod)}"]~
        [%type "submit"]~
        [%name "dif"]~
        [%value (trip pod)]~
        [%class "fund-butn-{(trip tip)}-m {cas}"]~
    ==
  --
--
