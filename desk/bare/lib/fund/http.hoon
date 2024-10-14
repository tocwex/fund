:: /lib/fund/http/hoon: http data and helper functions for %fund
::
/-  fd=fund-data
/+  *fund-proj, fk=fund-core, ff=fund-form, fc=fund-chain, fa=fund-alien, fx=fund-xtra
/+  config, mu=manx-utils, rudder, tonic
|%
::
::  +auth: is `src.bowl` in the given bowl an authenticated user?
::
++  auth
  |=  bol=bowl:gall  ~+
  ^-  bean
  =+  peers=.^((map ship *) %ax (en-beam [our.bol %$ da+now.bol] /peers))
  ?|  !=(%pawn (clan:title src.bol))
      (~(has by peers) src.bol)
  ==
::
::  +burl: b(ase) url (full url path to this ship, eauth or local)
::
++  burl
  |=  bol=bowl:gall  ~+
  ^-  tape
  =+  erl=.^((unit @t) %ex (en-beam [our.bol %$ da+now.bol] /eauth/url))
  ?^  erl  (scaj:fx (lent "/~/eauth") (trip u.erl))
  (head:en-purl:html .^(hart:eyre %e (en-beam [our.bol %host da+now.bol] /)))
::
::  +alix: al(pine-)i(fy) (man)x (search/replace non-@tas alpine tags)
::
++  alix
  |=  man=manx
  ^-  manx
  %-  ~(apply-attrs mu man)
  |=  [man=mane tap=tape]
  :_  tap
  ?^  man  man
  |^  (srep (prep man))
  ++  prep                                       ::  prefix replce
    |=  cor=@t
    =-  =<  +  %^  spin  rez  cor
        |=  [[pre=@tas rep=@t] acc=@tas]
        ^-  [[@tas @t] @tas]
        :-  [pre rep]
        ?.  =(pre (dis pre cor))  acc
        =/  lep=[b=@ l=@]  [3 (met 3 pre)]
        (con rep (lsh lep (rsh lep acc)))
    ^-  rez=(list [@tas @t])
    :~  [%xlass ':class']
        [%xtyle ':style']
        [%x-on- 'x-on:']
        [%x-bind- 'x-bind:']
    ==
  ++  srep                                       ::  suffix replace
    |=  cor=@t
    =-  =<  +  %^  spin  rez  cor
        |=  [[suf=@tas rep=@t] acc=@tas]
        ^-  [[@tas @t] @tas]
        :-  [suf rep]
        =/  les=[b=@ l=@]  [3 (met 3 suf)]
        =/  lec=[b=@ l=@]  [3 (met 3 cor)]
        ?:  (lth l.lec l.les)  acc
        =/  lep=[b=@ l=@]  [3 (sub l.lec l.les)]
        ?.  =(suf (dis suf (rsh lep cor)))  acc
        (cat 3 (cut 3 [0 l.lep] acc) rep)
    ^-  rez=(list [@tas @t])
    :~  [%'-enter' '.enter']
        [%'-outside' '.outside']
    ==
  --
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
    ~                                            `[%away (welp syt /dashboard/following)]
    [%asset *]                                   `[%page | %asset]
    [%ship ~]                                    `[%page | %ship]
    [%config ~]                                  `[%page | %config]
    [%dashboard suf=*]    ?+  suf.pat            ~
      ~                                          `[%away (snip syt)]
      [?(%following %discover %action) ~]        `[%page | %proj-dash]
    ==
    [%create suf=*]       ?+  suf.pat            ~
      ~                                          `[%away (snip syt)]
      [%project ~]                               `[%page | %proj-edit]
    ==
    [%next @ @ @ ~]                              `[%page | %proj-next]
    [%project @ @ suf=*]  ?+  suf.pat            ~
      ~                                          `[%page | %proj-view]
      [%okay ~]                                  `[%page | %proj-okay]
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
        url  (spud (slag:derl:ff url.request.ord))
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
      ?.(init.dat [%next (desc:enrl:ff /config) ~] (final:tis gud txt))
    ++  build
      |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
      ?.(init.dat [%next (desc:enrl:ff /config) ~] (build:tis arz msg))
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
      ^-  [@tas flag @tas]
      ;;([@tas flag @tas] (cue txt))
    ++  core
      |=  req=_|
      |=  pag=page:fd
      ^-  page:fd
      |_  [bol=bowl:gall ord=order:rudder dat=data:fd]
      +*  tis  ~(. pag bol ord dat)
      ::  FIXME: Should probably make these hacky argument names more unique
      ++  argue
        |=  [hed=header-list:http bod=(unit octs)]
        =/  lag=(unit flag)  (flag:derl:ff url.request.ord)
        =/  pro=(unit prej)
          ?~(lag ~ (~(get by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat)) u.lag))
        ?:  &(req ?=(~ pro))  'project does not exist'
        (argue:tis [[%flag (jam lag)] [%proj (jam pro)] hed] bod)
      ++  final
        |=  [gud=? txt=brief:rudder]
        ?.  gud  [%code 500 txt]
        (final:tis gud (jam (poke:dejs:ff ?~(txt '' txt))))
      ++  build
        |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
        =/  lag=(unit flag)  (flag:derl:ff url.request.ord)
        =/  pro=(unit prej)
          ?~(lag ~ (~(get by ~(ours conn:proj:fd bol [proj-subs proj-pubs]:dat)) u.lag))
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
::  +ma: manx-related manipulation functions
::
++  ma
  |_  man=manx
  ++  joat                                     ::  join node attributes
    |=  mar=mart
    ^-  manx
    %_(man a.g (welp a.g.man mar))
  ++  suat                                     ::  substitude node attributes
    |=  mar=mart
    ^-  manx
    %_(man a.g mar)
  ++  joch                                     ::  join node children
    |=  mar=marl
    ^-  manx
    %_(man c (welp c.man mar))
  ++  such                                     ::  substitute node children
    |=  mar=marl
    ^-  manx
    %_(man c mar)
  --
::
::  +ui: ui-related rendering functions
::
++  ui
  |_  cas=tape
  ++  page                                     ::  render page w/ head/foot/styles/etc.
    |=  [bol=bowl:gall ord=order:rudder tyt=tape fut=bean hed=bean bod=manx]
    ^-  manx
    =.  tyt  (weld "%fund - " ?~(tyt "home" tyt))
    =+  ape=(trip !<(@t (slot:config %meta-aset)))
    %-  alix
    |^  ;html(class "!block", style "display: none;")  ::  NOTE: https://twind.style/installation
          ;head
            ;meta(charset "UTF-8");
            ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
            ;*  meta
            ;title: {tyt}
            ;link/"{(dest:enrl:ff /asset/[~.tocwex.svg])}"(rel "icon", type "image/svg+xml");
            ;link/"https://fonts.googleapis.com"(rel "preconnect");
            ;link/"https://fonts.gstatic.com"(rel "preconnect", crossorigin ~);
            ;link  =as  "style"  =rel  "stylesheet preload"  =crossorigin  ~
              =href  "https://fonts.googleapis.com/css2?family=Ubuntu+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900";
            ;link  =as  "style"  =rel  "stylesheet preload"  =crossorigin  ~
              =href  "https://fonts.googleapis.com/css2?family=Noto+Emoji:wght@300..700&display=swap";
            ;link  =as  "style"  =rel  "stylesheet preload"  =crossorigin  ~
              =href  "{ape}/f1719727743303x447523347489316540/Chaney%20Wide.css";
            ;link  =as  "style"  =rel  "stylesheet preload"  =crossorigin  ~
              =href  "{ape}/f1719608058163x825753518615514200/Safiro%20Medium.css";
            ;link/"{(dest:enrl:ff /asset/[~.fund.css])}"(rel "stylesheet");
            ;*  ?.  !<(bean (slot:config %debug))  ~
                :~  ;script(src "/session.js");
                    (inject:tonic q.byk.bol)
                ==
            ;script(type "module", src "{(dest:enrl:ff /asset/[~.boot.js])}");
          ==
          ;body(class "fund-body {cas}", x-data "fund")
            ;*  ?.(hed ~ [(head bol ord ~)]~)
            ;+  bod
            ;*  ?.(fut ~ [(foot bol ord ~)]~)
          ==
        ==
    ++  meta
      ^-  marl
      ::  TODO: Remove these unused lines that could be used to check if
      ::  this is actually a %proj-view page
      ::  =/  loc=place:rudder  (need (route -:(purse:rudder url.request.ord)))
      ::  =/  vue=bean          &(?=(%page -.loc) =(%proj-view nom.loc))
      =/  mep=(map @t @t)
        %-  ~(pre-fold mu bod)
        |=  [[man=mane mat=mart] dat=(map @t @t)]
        ?.  ?=(%data man)  dat
        ?~  mid=(find:fx mat |=([m=mane tape] =(%id m)))  dat
        ?~  mal=(find:fx mat |=([m=mane tape] =(%value m)))  dat
        ?.  =("fund-meta-" (scag (lent "fund-meta-") v.u.mid))  dat
        (~(put by dat) (crip (slag (lent "fund-meta-") v.u.mid)) (crip v.u.mal))
      =/  des=tape  (scag 160 (trip (~(gut by mep) %desc !<(@t (slot:config %meta-desc)))))
      =/  pic=tape  (trip (~(gut by mep) %logo !<(@t (slot:config %meta-logo))))
      =/  url=tape
        ?~  lag=(~(get by mep) %flag)  (trip !<(@t (slot:config %meta-site)))
        "{(burl bol)}/apps/fund/project/{(trip u.lag)}"
      =/  dom=tape
        =+  sin=(bind (find "//" url) (cury add (lent "//")))
        =+  ein=(bind (find ".com" url) (cury add (lent ".com")))
        ?:  |(?=(~ sin) ?=(~ ein))  url
        (swag [u.sin (sub u.ein u.sin)] url)
      ;=  ::  OpenGraph Meta Tags
          ;meta(property "og:type", content "website");
          ;meta(property "og:title", content tyt);
          ;meta(property "og:description", content des);
          ;meta(property "og:url", content url);
          ;meta(property "og:image", content pic);
          ::  Twitter/X Meta Tags
          ;meta(name "twitter:card", content "summary_large_image");
          ;meta(name "twitter:title", content tyt);
          ;meta(name "twitter:description", content des);
          ;meta(property "twitter:url", content url);
          ;meta(name "twitter:image", content pic);
          ;meta(property "twitter:domain", content dom);
      ==
    --
  ++  head                                     ::  document top matter
    |=  [bol=bowl:gall ord=order:rudder hed=marl]
    ^-  manx
    =/  url=@t  url.request.ord
    =/  pat=(pole knot)  (slag:derl:ff url)
    =/  bag=tape  "rounded-lg sm:p-2 p-1"
    =/  sag=tape  "bg-palette-contrast drop-shadow-lg"
    =/  bas=tape  "fund-butn-de-m w-full text-center"
    =/  xom=tape  "($store.page.size == 'mobile')"
    =/  xow=tape  "!({xom} && open)"  ::  x-show for non-wallet
    ::  FIXME: Spacing on heights here for 'overflow-visible' are ugly and hacky
    ;nav#fund-head
        =x-data  "\{ open: false }"
        =class  "fund-head w-full flex overflow-visible gap-1 h-12 py-2 sm:(h-[4.25rem] px-2 gap-4)"
      ;a/"{?:(=(our src):bol (dest:enrl:ff /) (trip !<(@t (slot:config %meta-site))))}"
          =class  "shrink-0 sm:(h-12 px-3) h-10 bg-palette-background {sag} {bag}"
          =x-show  xow
          =x-data  "\{ hover: false }"
          =x-on-mouseenter  "hover = true"
          =x-on-mouseleave  "hover = false"
        ;img.h-full@"{(aset:enrl:ff %fund)}"(x-show "!hover");
        ;img.h-full@"{(aset:enrl:ff %fund-off)}"(x-show "hover");
      ==
      ;div(class "shrink w-full min-w-0 z-50", x-show xow)
        ;div(class "w-full")
          ;*  ?^  hed  hed
              :_  ~  ;div(class "hidden lg:(block h-12 rounded-lg {sag})");
        ==
      ==
      ;div(class "shrink-0", xlass "!{xow} && 'w-full'")
        ;div(class "shrink-0 flex flex-col gap-2 {sag} {bag}")
          ;button  =type  "button"
              =class  "shrink-0 flex inline-flex justify-between items-center gap-2"
              =x-on-click  "open = ! open"
              =x-on-click-outside  "open = false"
            ;div(class "inline-flex items-center gap-2 rounded-md")
              ;+  (~(ship-logo ..$ "h-8") src.bol bol)
              ;span(x-show "(!{xom} || !{xow})")
                ; {?.((auth bol) "login ~" (ssip:enjs:ff src.bol))}
              ==
            ==
            ;div(class "shrink-0 fund-butn-de-m", x-text "$store.wallet.status");
          ==
          ;div(class "flex flex-col gap-2", x-show "open")
            ;div  ::  current wallet section
              ;div(class "flex flex-col gap-2", x-show "!$store.wallet.connected")
                ;button(type "button", x-on-click "toggleWallet", class bas): choose wallet 💲
              ==
              ;div(class "flex flex-col gap-2", x-show "$store.wallet.connected")
                ;div(class "rounded-md bg-palette-background py-1 px-2")
                  ;div(class "flex justify-between")
                    ;span.text-palette-secondary: Wallet
                    ;span: MetaMask
                  ==
                  ;div(class "flex justify-between")
                    ;span.text-palette-secondary: Balance
                    ;span(x-text "$store.wallet.balance");
                  ==
                  ::  TODO: Add per-project currency balance here (need
                  ::  separate ERC20/721 accounting logic)
                  ::  ;div  =class  "flex justify-between"
                  ::      =x-on-show  "!!$store.project.assets?.[$store.wallet.address]"
                  ::    ;span.text-gray-300: Project
                  ::    ;span(x-text "$store.project.balance");
                  ::  ==
                ==
                ::  ;button(type "button", x-on-click "switchChain", class bas): switch chain
                ::  ;button(type "button", x-on-click "switchWallet", class bas): switch wallet
                ;button(type "button", x-on-click "toggleWallet", class bas): disconnect ✗
              ==
            ==
            ;hr;  ::  known wallets section
            ;div
              ;div(class "flex flex-col gap-2")
                ;h5.text-center.underline: Verified Wallets
                ;div(class "flex flex-col items-end rounded-md bg-palette-background py-1 px-2")
                  ;*  =+  .^  adz=(list addr)  %gx
                              %+  en-beam  [our.bol dap.bol da+now.bol]
                              /prof/(scot %p src.bol)/adrz/noun
                          ==
                      ?~  adz  :_  ~  ;span.text-gray-300: (none available)
                      %+  turn  adz
                      |=  adr=addr
                      ^-  manx
                      ;span(class "fund-addr", x-init "initENS($el, '{(addr:enjs:ff adr)}')");
                ==
              ==
            ==
            ;*  ?.  =(our src):bol  ~
                :~  ;hr;
                    ;a/"{(dest:enrl:ff /config)}"(class bas): config ⚙️
                ==
            ;hr;  ::  login/logout section
            ;+  =-  ;a/"/~/{pre}redirect={(trip url)}"(class bas, target tgt): {txt}
                ^-  [pre=tape tgt=tape txt=tape]
                ?.((auth bol) ["login?eauth&" "_blank" "login ~"] ["logout?" "_self" "logout ↩️"])
          ==
        ==
      ==
    ==
  ++  foot                                     ::  document bottom matter
    |=  [bol=bowl:gall ord=order:rudder fut=marl]
    ^-  manx
    ::  NOTE: CSS trick for pushing footer to page bottom
    ::  https://stackoverflow.com/a/71444859
    ::  To hide on smaller devices: hidden lg:block
    ;footer#fund-foot
        =class  "top-[100vh] justify-center p-2 lg:flex lg:items-center lg:justify-between"
      ;div(class "text-center text-xs pt-1 lg:pt-0 lg:text-base")
        ;div(class "flex justify-center items-center lg:justify-start hover:underline")
          ;a/"https://tocwexsyndicate.com"(target "_blank"): crafted by ~tocwex.syndicate
        ==
      ==
      ;+  ;div(class "flex grow")
            ;*  fut
          ==
      ;div(class "flex justify-center grow gap-10 lg:gap-1 lg:grow-0 lg:justify-end")
        ;*  ?.  !<(bean (slot:config %debug))  ~
            :_  ~
            ;div(class "flex items-center")
              ;button(type "button", x-init "initTippy($el, \{hover: true})")
                ;img.fund-butn-icon@"{(aset:enrl:ff %help)}";
              ==
              ;div(class "hidden")
                ;h4.text-center: ⚠ DEBUG ENABLED ⚠
                ;p.text-2xs.whitespace-pre-wrap: {enjs:config}
              ==
            ==
        ;a/"https://x.com/tocwex"(target "_blank")
          ;img.fund-butn-icon@"{(aset:enrl:ff %x)}";
        ==
        ;a/"https://github.com/tocwex"(target "_blank")
          ;img.fund-butn-icon@"{(aset:enrl:ff %github)}";
        ==
        ;a/"https://tocwexsyndicate.com"(target "_blank")
          ;img.fund-butn-icon@"{(aset:enrl:ff %globe)}";
        ==
        ;a/"{(trip !<(@t (slot:config %meta-tlon)))}"(target "_blank")
          ;img.fund-butn-icon@"{(aset:enrl:ff %urbit)}";
        ==
      ==
    ==
  ++  ship-card                                  ::  summary card for user ship
    |=  [sip=@p bol=bowl:gall rol=role cid=@ud adr=addr]
    ^-  manx
    =/  [tyt=tape lin=tape nun=tape hep=tape]
      ?+    rol  [~ ~ ~ ~]
          %work
        :*  tyt="Project Worker"
            lin="user-guides/project-workers"
            nun="no payment address set"
              ^=  hep
            ^-  tape  ^~
            %+  rip  3
            '''
            The project worker is the identity which does the work defined in
            the project overview and milestones. When a milestone is completed
            and approved by the trusted oracle, the project worker receives the
            listed payout for that milestone.
            '''
        ==
      ::
          %orac
        :*  tyt="Trusted Oracle"
            lin="user-guides/trusted-oracles"
            nun="no approval keys set"
              ^=  hep
            ^-  tape  ^~
            %+  rip  3
            '''
            The role of the trusted oracle is to assess completion of the scope
            of work. When a milestone review is requested, the oracle can chose
            to mark it as complete by providing a cryptographically signed
            message, allowing the worker to withdraw funds.
            '''
        ==
      ==
    ;div(class "fund-card-fore flex flex-col gap-1 text-black")
      ;div(class "inline-flex gap-1 items-center")
        ;h6(class "leading-none"): {tyt}
        ;button(type "button", x-init "initTippy($el, \{hover: true})")
          ;img.w-6.fund-butn-icon@"{(aset:enrl:ff %help)}";
        ==
        ;div(class "hidden")
          ;p: {hep}
          ;p
            ; To learn more,
            ;a.text-link/"{(trip !<(@t (slot:config %meta-help)))}/{lin}"(target "_blank")
              ; read the docs.
            ==
          ==
        ==
      ==
      ;div(class "inline-flex self-stretch justify-start items-center gap-2")
        ;+  (~(ship-logo ..$ "h-20") sip bol)
        ;div(class "grow shrink basis-0 flex-col justify-start items-start inline-flex")
          ;div(class "inline-flex items-center gap-1")
            ;h5.text-lg.font-bold.tracking-tight
              ;+  (ship-tytl sip bol)
            ==
            ;+  (copy-butn (ship:enjs:ff sip))
          ==
          ;div(class "inline-flex items-center gap-1")
            ;*  ?:  =(0x0 adr)  :_  ~  ;p: {nun}
                :~  ;a/"{(esat:enrl:ff %addr adr cid)}"
                        =target  "_blank"
                        =class  "fund-addr hover:text-link"
                        =x-init  "initENS($el, '{(addr:enjs:ff adr)}')";
                    (copy-butn (addr:enjs:ff adr))
                ==
          ==
          ;div(class "self-stretch justify-between items-center inline-flex")
            ;div(class "inline-flex items-center gap-1")
              ;a/"https://network.urbit.org/{<sip>}"
                  =target  "_blank"
                  =class  "font-normal hover:text-link"
                ; AZP: {<`@`sip>}
              ==
              ;+  (copy-butn (bloq:enjs:ff `@`sip))
            ==
            ;div(class "inline-flex gap-1")
              ;*  ?:  |(!=(our src):bol =(sip src.bol))  ~
                  :_  ~
                  ;a/"{(chat:enrl:ff sip)}"(target "_blank")
                    ;img.fund-butn-icon@"{(aset:enrl:ff %chat)}";
                  ==
            ==
          ==
        ==
      ==
    ==
  ++  mark-well                                  ::  markdown (github) well
    |=  [txt=tape typ=?(%ters %togl %verb)]
    ^-  manx
    ::  FIXME: This is hacky and wasteful, but attempting to use Alpine.js to
    ::  just edit in/out the 'line-clamp-5' class doesn't work due to
    ::  collisions with Twind.js.
    ;div(class "w-full", x-data "\{open: {(bool:enjs:ff ?=(%verb typ))}}")
      ::  FIXME: Attempting to apply a "to transparent" graident, but
      ::  it's not working...
      ::  after:bg-gradient-to-b after:from-inherit
      ;*  %+  turn  ~[["!open" "line-clamp-5"] ["open" ""]]
          |=  [sow=tape kas=tape]
          ;zero-md(class "w-full {kas} {cas}", x-show sow, xlass "styleMD()", no-shadow ~)
            ;template
              ;link/"{(dest:enrl:ff /asset/[~.mdhl.css])}"(rel "stylesheet");
            ==
            ;script(type "text/markdown"): {txt}
          ==
      ;*  ?.  ?=(%togl typ)  ~
          :_  ~
          ;div(class "flex justify-center pt-2")
            ;*  %+  turn  ~[["!open" "true" "show more +"] ["open" "false" "show less -"]]
                |=  [sow=tape qiq=tape txt=tape]
                ::  FIXME: Attempt at eliminating the button when the
                ::  clamp doesn't even truncate extra lines
                ::  =x-show  "{sow} && needsClamp($el.parentElement.previousElementSibling, 5)"
                ;button.fund-butn-ac-s(type "button", x-show sow, x-on-click "open = {qiq}"): {txt}
          ==
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
        ;span: {?^(alt +.u.alt ?^(src +.u.src (dest:enrl:ff /)))}
      ==
    --
  ++  proj-ther                                  ::  project funding thermometer
    |=  [pro=proj big=bean]
    ^-  manx
    =+  pod=~(odit pj pro)
    =+  [udr ovr]=(need void:(filo:fk pod))
    =+  tot=(add cost.pod ?:(udr 0 ovr))
    =+  cen=(srel:enjs:ff (perc:fx (add fill.pod plej.pod) tot))
    ;div(class "w-full flex flex-row items-center gap-3")
      ;div(class "w-full min-w-0 flex-1 flex flex-col gap-1")
        ;div(class "w-full min-w-0 flex-1 flex flex-row gap-1")
          ;*  %+  turn  (enum:fx ~(odim pj pro))
              |=  [min=@ mod=odit]
              ;div  =class  "w-full min-w-0 flex-1 hover:cursor-pointer"
                  =x-on-click  "scrollTo('fund-mile-{<min>}')"
                ;+  (mile-ther mod ?.(big ~ "Milestone {<+(min)>}") big)
              ==
        ==
        ;*  ?.  big  ~
            :_  ~
            ;div(class "hidden sm:(flex flex-row gap-2)")
              ;h3.text-palette-primary.font-medium
                ; {(swam:enjs:ff fill.pod payment.pro)}
              ==
              ;h3.text-palette-secondary: /
              ;h3.text-palette-secondary
                ; {(swam:enjs:ff plej.pod payment.pro)}
              ==
            ==
      ==
      ;*  ?.  big  ~
          :_  ~
          %+  cash-bump
            ;span(class "inline-flex gap-1")
              ; {cen}% raised
              ;span(class "hidden sm:block"): of
            ==
          ;span(class "hidden sm:block"): {(swam:enjs:ff cost.pod payment.pro)}
    ==
  ++  swap-selz                                  ::  swap select input fields
    |=  [sid=@ud emt=bean swa=(unit swap) mod=tape xoc=tape]
    ^-  manx
    =/  ini=tape  ?~(swa "undefined" "'{(trip symbol.u.swa)}'")
    =/  cid=tape  "chain-{<sid>}"
    =/  tid=tape  "token-{<sid>}"
    =/  its=tape  "initTomSelect($el, \{empty: {(bool:enjs:ff emt)}})"
    =/  uts=tape  "tsUpdateToken($refs['{cid}'], $refs['{tid}'])"
    =/  iut=tape  :(welp its "; " uts "({ini})")
    ;div(class cas, x-data ~)
      ::  FIXME: This is a hack to make the 'selz' use uniform padding
      ::  in the filter UI
      ;div(class "fund-form-group col-span-1 {?.(emt ~ (trip %p-0))}")
        ;select(name "can", required ~, x-init its, x-ref cid, x-on-change uts)
          ;*  =+  can=?~(swa id:(~(got by xmap:fc) %ethereum) chain.u.swa)
              %+  welp
                ?.  emt  ~
                :_  ~  ;option(value ~): Any Chain
              %+  turn  xlis:fc
              |=  xet=xeta
              ^-  manx
              :_  ; {(xeta:enjs:ff xet)}
              :-  %option
              ;:  welp
                  [%value (bloq:enjs:ff id.xet)]~
                  [%data-image (aset:enrl:ff tag.xet)]~
                  ?.(&(!emt =(can id.xet)) ~ [%selected ~]~)
              ==
        ==
        ;*  ?:  emt  ~
            :_  ~  ;label(for "can"): Blockchain
      ==
      ::  FIXME: This is a hack to make the 'selz' use uniform padding
      ::  in the filter UI
      ;div(class "fund-form-group col-span-1 {?.(emt ~ (trip %p-0))}")
        ;select#proj-token-options.hidden(required ~)
          ;*  %+  welp
                ?.  emt  ~
                :_  ~  ;option(value ~): Any Token
              %+  turn  slis:fc
              |=  swa=swap
              ^-  manx
              :_  ; {(swad:enjs:ff swa)}
              :-  %option
              :~  [%value (trip symbol.swa)]
                  [%data-type (trip -.swa)]
                  [%data-chain (bloq:enjs:ff chain.swa)]
                  [%data-image (aset:enrl:ff symbol.swa)]
                  ::  FIXME: Should handle %chip case more elegantly
                  [%data-href (esat:enrl:ff %addr addr.swa chain.swa)]
              ==
        ==
        ;select(name "tok", required ~, x-init iut, x-model mod, x-ref tid, x-on-change xoc);
        ;*  ?:  emt  ~
            :_  ~
            ;div(class "inline-flex gap-1 items-center")
              ::  FIXME: Better if this were automatically populated by CSS
              ::  rules like all of the other <input>s
              ;label(for "tok")
                ; Token
                ;span(class "-ml-1 text-red-500"): *
              ==
              ::  FIXME: It would be better if this were an <a> element,
              ::  but that doesn't properly auto-update via 'x-bind-href'
              ;button  =type  "button"
                  =x-on-click  "openHREF($refs['{tid}'].tomselect.options[$refs['{tid}'].tomselect.activeOption.dataset.value].href, true)"
                ::  TODO: Remove static width & replace with outer
                ::  sizing control
                ;img.w-6.fund-butn-icon@"{(aset:enrl:ff %etherscan)}";
              ==
            ==
      ==
    ==
  ++  mile-ther                                  ::  milestone funding thermometer
    |=  [odi=odit tyt=tape big=bean]
    ^-  manx
    ::  TODO: Clean up the overage handling code in here.
    |^  =+  [udr ovr]=(need void:(filo:fk odi))
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
        =/  kaz=(list tape)
          =+  qaz=[con="palette-primary" pej="palette-secondary" ovr=?:(udr "white" "black")]
          :~  "bg-{con.qaz} border-{con.qaz}"
              "bg-{pej.qaz} border-{ovr.qaz}"
              "bg-{ovr.qaz} border-{ovr.qaz}"
          ==
        ::  FIXME: Funding percentage calculations aren't right when there
        ::  are overages (since we renormalize to overage amount).
        =/  cez=(list @rs)  ?:(=(0 tot) ~[.0 .0 .100] (turn caz (curr perc:fx tot)))
        =/  dez=(list @ud)
          =<  -  %^  spin  (iron (turn cez cend))  0
          |=([nex=@ud acc=@ud] =-([- -] (add nex acc)))
        ;div(class "fund-odit-ther relative {(trip ?:(big ~ 'sm:h-4'))} {cas}")
          ;div(class "h-full w-full flex relative")
            ;*  %+  murn  (flop :(izip:fx caz naz kaz cez dez))
                |=  [cas=cash nam=tape kas=tape cen=@rs den=@ud]
                ^-  (unit manx)
                =/  qas=tape  ?.(big "border-2" "border-0 sm:rounded-md")
                ?:  =(0 den)  ~
                :-  ~
                ;div  =title  "{(real:enjs:ff cen)}% {nam}"
                  =class  "fund-odit-sect absolute left-0 w-[{<den>}%] {qas} {kas}";
          ==
          ;*  ?~  tyt  ~
              :_  ~
              ::  NOTE: https://stackoverflow.com/a/1777282/837221
              ;div(class "hidden sm:(block absolute left-[50%] pt-1.5 font-medium text-nowrap)")
                ;div(class "relative left-[-50%]"): {tyt}
              ==
        ==
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
  ++  hero-plaq                                  ::  full-page notification w/ buttons
    |=  [tyt=tape txt=tape buz=marl]
    ^-  manx
    ;form(method "post", class "p-2 h-[80vh] {cas}")
      ;div(class "h-full flex flex-col flex-wrap justify-center items-center text-center gap-10")
        ;h1: {tyt}
        ;*  ?~  txt  ~
            :_  ~  ;div(class "text-xl"): {txt}
        ;div(class "flex flex-row flex-wrap gap-x-3 gap-y-2 justify-evenly")
          ;*  buz
        ==
      ==
    ==
  ++  work-tytl                                  ::  work unit (project/milestone) title
    |=  [tyt=tape sat=stat man=manx]
    ^-  manx
    ;div(class "flex flex-wrap items-center justify-between {cas}")
      ;h1(class "fund-title"): {tyt}
      ;+  (~(work-bump ..$ ~) sat man)
    ==
  ++  ship-logo                                  ::  icon for a user ship
    |=  [sip=@p bol=bowl:gall]
    ^-  manx
    (icon-logo %rect (~(ship-logo fa bol) sip))
  ++  ship-tytl                                  ::  title for a user ship
    |=  [sip=@p bol=bowl:gall]
    ^-  manx
    ;span(class "line-clamp-1 {cas}"): {(~(ship-tytl fa bol) sip)}
  ++  work-bump                                  ::  bumper for work unit
    |=  [sat=stat man=manx]
    ;div(class "flex items-center gap-x-2 {cas}")
      ;+  (~(stat-pill ..$ ~) %medi sat)
      ;+  %-  ~(cash-bump ..$ ~)
          :_  man
          ;span.text-nowrap: Funding Goal
    ==
  ++  cash-bump                                  ::  bumper for cash amount
    |=  [tan=manx ban=manx]
    ^-  manx
    ;div(class "flex flex-col justify-start items-end text-black {cas}")
      ;h6.text-nowrap.leading-none.tracking-tight
        ;+  tan
      ==
      ;h2.text-nowrap
        ;+  ban
      ==
    ==
  ++  stat-pill                                  ::  status pill element
    |=  [syz=?(%smol %medi %lorj) sat=stat]
    ^-  manx
    =/  siz=@tas  (dis syz (dec (bex 8)))
    =-  ;div(class "{kas} {cas}"): {nam}
    ^-  [nam=tape kas=tape]
    :-  (stat:enjs:ff sat)
    =-  "{-}-{(trip siz)}"
    ?-  sat
      %born  "fund-pill-bo"
      %prop  "fund-pill-bo"
      %lock  "fund-pill-lo"
      %work  "fund-pill-lo"
      %sess  "fund-pill-lo"
      %done  "fund-pill-do"
      %dead  "fund-pill-de"
    ==
  ++  icon-stax                                  ::  stack of icons (leftmost on top)
    |=  [typ=?(%circ %rect) liz=(list tape)]
    ^-  manx
    ;div(class "flex flex-row-reverse h-6 {cas}")
      ;*  %+  turn  (enum:fx (flop liz))
          |=  [lid=@ lin=tape]
          =+  lim=?:(=(0 lid) "" "-mr-3")
          (~(icon-logo ..$ "relative h-full {lim}") typ lin)
    ==
  ++  icon-logo                                  ::  single icon image
    |=  [typ=?(%circ %rect) lin=tape]
    ^-  manx
    ;img@"{lin}"(class "fund-aset-{(trip typ)} {cas}");
  ++  flip-cheq                                  ::  checkbox flip switch <o->
    |=  nam=tape
    ^-  manx
    =-  ;label(class "cursor-pointer {cas}")
          ;input(name nam, type "checkbox", class "sr-only peer");
          ;div(class kas);
        ==
    ^=  kas
    """
    relative w-8 h-4 bg-palette-primary border-2 border-palette-secondary rounded-full
    peer-checked:bg-palette-secondary/80 peer-checked:after:translate-x-[175%] peer-checked:after:bg-palette-primary
    after:content-[''] after:absolute after:top-[1px] after:bg-palette-secondary/80 after:rounded-full
    after:h-2.5 after:w-2.5 after:transition-transform
    """
  ++  link-text                                  ::  hyperlink/redirect text
    |=  [wer=tape tab=bean txt=tape diz=tape]
    ^-  manx
    =/  hov=tape  ?:(|(?=(~ wer) ?=(^ diz)) ~ "hover:text-link")
    =-  ?~(diz - (~(help-wrap ..$ ~) diz -))
    :_  ; {txt}
    :-  %a
    ;:  welp
        [%class "text-black {hov} {cas}"]~
        ?~(wer ~ [%href wer]~)
        ?~(diz ~ [%disabled ~]~)
        ?.(tab ~ [%target "_blank"]~)
    ==
  ++  link-butn                                  ::  hyperlink/redirect button
    |=  [wer=tape tab=bean txt=tape diz=tape]
    ^-  manx
    =-  ?~(diz - (~(help-wrap ..$ ~) diz -))
    :_  ; {txt}
    :-  %button
    ;:  welp
        [%type "button"]~
        [%class "fund-butn-de-m {cas}"]~
        [%x-on-click "openHREF('{wer}', {(bool:enjs:ff tab)})"]~
        ?~(diz ~ [%disabled ~]~)
    ==
  ++  edit-butn                                  ::  project edit link button
    |=  lag=flag
    ^-  manx
    ;a/"{(flat:enrl:ff lag)}/edit"(class cas)
      ;img.fund-butn-icon@"{(aset:enrl:ff %edit)}";
    ==
  ++  pink-butn                                  ::  project link copy button
    |=  [lag=flag url=tape]
    ^-  manx
    =-  ;button(type "button", class cas, x-data ~, x-on-click xoc)
          ;img.fund-butn-icon@"{(aset:enrl:ff %share)}";
        ==
    ^=  xoc
    """
    copyText('{url}{(flat:enrl:ff lag)}');
    alert('project url copied to clipboard');
    """
  ++  copy-butn                                  ::  arbitrary text copy button
    |=  txt=tape
    ^-  manx
    ;button(type "button", class cas, x-data ~, x-on-click "copyText('{txt}'); swapHTML($el, '✔️');")
      ::  TODO: Remove static width here and control size from caller
      ::  element instead (we can get away with static for now because
      ::  it's the same height in all of its current use locations)
      ;img.w-6.fund-butn-icon@"{(aset:enrl:ff %copy)}";
    ==
  ++  prod-butn                                  ::  prod/poke/action button
    |=  [syz=?(%smol %medi %lorj) typ=?(%action %true %false) pod=@tas txt=tape xon=tape diz=tape]
    ^-  manx
    =/  siz=@tas  (dis syz (dec (bex 8)))
    =/  tip=@tas  (dis typ (dec (bex 16)))
    =-  ?~(diz - (~(help-wrap ..$ ~) diz -))
    :_  ; {txt}
    :-  %button
    ;:  welp
        [%id "prod-butn-{(trip pod)}"]~
        [%type "submit"]~
        [%name "dif"]~
        [%value (trip pod)]~
        [%class "fund-butn-{(trip tip)}-{(trip siz)} {cas}"]~
        ?~(diz ~ [%disabled ~]~)
        ?~(xon ~ [%x-on-click xon]~)
    ==
  ::  NOTE: This is needed particularly for disabled buttons; see:
  ::  https://atomiks.github.io/tippyjs/v6/constructor/#disabled-elements
  ++  help-wrap                                  ::  element w/ tooltip wrapper
    |=  [hep=tape man=manx]
    ^-  manx
    :_  [man]~
    :-  %span
    :-  [%class cas]
    :_  ~
    :-  %x-init
    %-  zing  %+  join  "\0a"
    ^-  (list tape)
    :~  :(weld "const text = '" hep "';")
        ^-  tape  ^~
        %+  rip  3
        '''
        if (typeof initTippy !== 'undefined') {
          initTippy($el, {text: text, hover: true});
        }
        '''
    ==
  --
--
