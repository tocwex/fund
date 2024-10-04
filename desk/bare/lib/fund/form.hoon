:: /lib/fund/form/hoon: format helper functions for %fund
::
/-  *fund
/+  fx=fund-xtra
|%
+|  %url
++  derl                                         ::  rl-path => noun
  |%
  ++  slag                                       ::  (url path) suffix
    |=  cor=cord  ~+
    ^-  path
    =/  [pre=tape suf=tape]  (chop:fx (trip cor) '?')
    ::  FIXME: A smarter `stab` parser would be better, e.g. something like:
    ::  `path`(rash '/a/b/' ;~(sfix stap fas))
    =?  pre  ?=([%'/' *] (flop pre))  (snip pre)
    (need (chip:fx /apps/fund (stab (crip pre))))
  ++  flag                                       ::  (url path) (project) flag
    |=  cor=cord  ~+
    ^-  (unit ^flag)
    ?+  pat=`(pole knot)`(slag cor)  ~
      [@ sip=@ nam=@ *]  (both (slaw %p sip.pat) (slaw %tas nam.pat))
    ==
  --
++  enrl                                         ::  noun => rl-path
  |%
  ++  dest                                       ::  des(k) t(ape) (url path)
    |=  pat=path  ~+
    ^-  tape
    (spud [%apps %fund pat])
  ++  desc                                       ::  des(k) c(ord) (url path)
    |=  pat=path  ~+
    ^-  cord
    (spat [%apps %fund pat])
  ++  chat                                       ::  cha(t) t(ape) (url path)
    |=  sip=@p  ~+
    ^-  tape
    (spud /apps/groups/dm/(scot %p sip))
  ++  chac                                       ::  cha(t) c(ord) (url path)
    |=  sip=@p  ~+
    ^-  cord
    (spat /apps/groups/dm/(scot %p sip))
  ++  flat                                       ::  fla(g) t(ape) (url path)
    |=  lag=flag  ~+
    ^-  tape
    (dest /project/(scot %p p.lag)/[q.lag])
  ++  flac                                       ::  fla(g) c(ord) (url path)
    |=  lag=flag  ~+
    ^-  cord
    (desc /project/(scot %p p.lag)/[q.lag])
  ++  aset                                       ::  as(s)e(t) t(ape) (url path)
    |=  ast=@t  ~+
    ^-  tape
    (dest /asset/[(crip "{(cass (trip ast))}.svg")])
  ++  asec                                       ::  as(s)e(t) c(ord) (url path)
    |=  ast=@t  ~+
    ^-  cord
    (desc /asset/[(crip "{(cass (trip ast))}.svg")])
  --
  ++  surt                                       ::  s(hip) ur(l) t(ape) (url path)
    |=  sip=@p  ~+
    ^-  tape
    ?-  (clan:title sip)
      %pawn  (colt %black)
      %earl  "https://azimuth.network/erc721/{(bloq:enjs `@`(end 5 sip))}.svg"
      *      "https://azimuth.network/erc721/{(bloq:enjs `@`sip)}.svg"
    ==
  ++  surc                                       ::  s(hip) ur(l) c(ord) (url path)
    |=  sip=@p  ~+
    ^-  cord
    (crip (surt +<))
  ++  esat                                       ::  e(ther)s(c)a(n) t(ape) (url path)
    |=  [typ=?(%xact %addr) hex=@ux cid=@ud]  ~+
    ^-  tape
    =/  tyt=@t  ?-(typ %xact %tx, %addr %address)
    =/  cit=@t  ?+(cid %$ %1 %$, %11.155.111 'sepolia.')
    "https://{(trip cit)}etherscan.io/{(trip tyt)}/{(z-co:co hex)}"
  ++  esac                                       ::  e(ther)s(c)a(n) c(ord) (url path)
    |=  [typ=?(%xact %addr) hex=@ux cid=@ud]  ~+
    ^-  cord
    (crip (esat +<))
  ++  colt                                       ::  col(or) t(ape) (url path)
    |=  clr=@t
    ^-  tape
     "https://placehold.co/24x24/{(trip clr)}/{(trip clr)}?text=\\n"
  ++  colc                                       ::  col(or) c(ord) (url path)
    |=  clr=@t
    ^-  cord
    (crip (colt +<))

+|  %js
++  dejs                                       ::  js-tape => noun
  |%
  ++  comp                                     ::  "12.345" => 12.345.000
    |=  [amo=@t swa=swap]
    ^-  ^cash
    ?-  -.swa
      %coin  (cash amo decimals.swa)
      %enft  (bloq amo)
      %chip  (cash amo decimals.swa)
    ==
  ++  cash                                     ::  "12.345" => 12.345.000
    |=  [cas=@t dex=@ud]
    ^-  ^cash
    ::  FIXME: `royl-rn:so` crashes on values w/o leading 0s (e.g. '.1')
    =+  tas=(trip cas)
    =?  cas  &(?=(^ tas) =(i.tas '.'))  (crip ['0' tas])
    =+  caf=(rash cas (cook royl-cell:so royl-rn:so))
    ?>  ?=(%d -.caf)
    %-  abs:si  %-  need  %-  toi:fl  %-  grd:fl
    caf(e (sum:si e.caf (sun:si dex)))
  ++  real                                     ::  "12.345" => .1.2345e1
    |=  rel=@t
    ^-  @rs
    (rash rel royl-rs:so)
  ++  bool                                     ::  "true" => %.y
    |=  bul=@t
    ^-  bean
    %+  rash  bul
    ;~  pose
      (cold %& (jest 'true'))
      (cold %| (jest 'false'))
    ==
  ++  bloq                                     ::  "123456…" => 1234.56…
    |=  boq=@t
    ^-  ^bloq
    (rash boq dem)
  ++  addr                                     ::  "0xabcdef…" => 0xabcd.ef…
    |=  adr=@t
    ^-  ^addr
    (rash adr ;~(pfix (jest '0x') hex))
  ++  sign                                     ::  "0xabcdef…" => 0xabcd.ef…
    |=  sig=@t
    ^-  ^sign
    (rash sig ;~(pfix (jest '0x') hex))
  ++  ship                                     ::  "~zod" => ~zod
    |=  sip=@t
    ^-  ^ship
    (rash sip ;~(pfix sig fed:ag))
  ++  flag                                     ::  "~zod/nam" => [~zod %nam]
    |=  lag=@t
    ^-  ^flag
    (rash lag ;~((glue fas) ;~(pfix sig fed:ag) sym))
  ++  poke                                     ::  "lvl:~zod/nam:typ" => [p=%lvl q=[~zod %nam] q=%typ]
    |=  pok=@t
    ^-  (trel @tas ^flag @tas)
    %+  rash  pok
    ;~  (glue col)
      ;~(pose (jest %fund) (jest %proj) (jest %prof) (jest %meta))
      ;~((glue fas) ;~(pfix sig fed:ag) ;~(pose sym (easy '')))
      sym
    ==
  --
++  enjs                                       ::  noun => js-tape
  |%
  ++  swam                                     ::  [12.345.000 *swap] => "12.34 $USD"
    |=  [amo=^cash swa=^swap]
    ^-  tape
    =/  com=tape  (comp amo swa)
    =/  sym=@t  ?-(-.swa %coin symbol.swa, %enft symbol.swa, %chip symbol.swa)
    ?+  sym  "{com} {(swap swa)}"
      ?(%'USD' %'USDC' %'fundUSDC')  "${com}"
    ==
  ++  comp                                     ::  12.345.000 => "12.34"
    |=  [amo=^cash swa=^swap]
    ^-  tape
    ?-  -.swa
      %coin  (cash amo decimals.swa)
      %enft  (bloq amo)
      %chip  (cash amo decimals.swa)  ::  FIXME: Decimals should be more custom
    ==
  ++  cash                                     ::  12.345.000 => "12.34"
    |=  [cas=^cash dex=@ud]
    ^-  tape
    =+  cax=(drg:fl (sun:fl cas))
    ?>  ?=(%d -.cax)
    =.  e.cax  (dif:si e.cax (sun:si dex))
    (flot:fx cax `[2 2])
  ++  real                                     ::  .1.2345e1 => "12.34"
    |=  rel=@rs
    ^-  tape
    (flot:fx (rlys rel) `[0 2])
  ++  srel                                     ::  .1.2345e1 => "12"
    |=  rel=@rs
    ^-  tape
    (flot:fx (rlys rel) `[0 0])
  ++  bloq                                     ::  1234.56… => "123456…"
    |=  boq=^bloq
    ^-  tape
    (a-co:co boq)
  ++  bool                                     ::  %.y => "true"
    |=  bul=?
    ^-  tape
    ?:(bul "true" "false")
  ++  addr                                     ::  0xabcd.ef… => "0xabcdef…"
    |=  adr=^addr
    ^-  tape
    ['0' 'x' ((x-co:co 40) adr)]
  ++  sadr                                     ::  0xabcd.ef… => "0xabc…def"
    |=  adr=^addr
    ^-  tape
    =+  bas=(addr adr)
    :(weld (scag 5 bas) "…" (slaj:fx 4 bas))
  ++  sign                                     ::  0xabcd.ef… => "0xabcdef…"
    |=  sig=^sign
    ^-  tape
    ['0' 'x' ((x-co:co 130) sig)]
  ++  ship                                     ::  ~zod => "~zod"
    |=  sip=^ship
    ^-  tape
    "{<sip>}"
  ++  ssip                                     ::  ~mister-sampel-samplel-palnet => "~sampel^palnet"
    |=  sip=^ship
    ^-  tape
    ?-  (clan:title sip)
      %pawn  =+((ship sip) :(welp (scag 7 -) "_" (slaj:fx 6 -)))
      %earl  (snap (ship (end 5 sip)) 7 '^')
      *      (ship sip)
    ==
  ++  flag                                     ::  [~zod %nam] => "~zod/nam"
    |=  lag=^flag
    ^-  tape
    "{(ship p.lag)}/{(trip q.lag)}"
  ++  poke                                     ::  [%level [~zod %nam] %type …] => "level:~zod/nam:type"
    |=  pok=^poke
    ^-  tape
    =-  (zing (join ":" `(list tape)`~[lvl (flag lag) typ]))
    ^-  [lvl=tape lag=^flag typ=tape]
    :-  (trip -.pok)
    ?-  -.pok
      %fund  [[~zod %$] (trip +<.pok)]
      %prof  [[p.pok %$] (trip -.q.pok)]
      %meta  [p.pok (trip -.q.pok)]
      %proj  [p.pok "{(trip -.q.pok)}{?+(-.q.pok ~ ?(%bump %mula) ['-' (trip +<.q.pok)])}"]
    ==
  ++  swad                                     ::  [%coin 1 0x1 %wstr %wstr 6] => "Wrapped Star"
    |=  swa=^swap
    ^-  tape
    =-  "{tyt} ({typ})"
    ^-  [typ=tape tyt=tape]
    :-  ?-(-.swa %coin "Coin", %enft "NFT", %chip "Fiat")
    ?+  symbol.swa  (trip name.swa)
      ?(%'USDC' %'fundUSDC')  "USD Coin"
      ?(%'WSTR' %'fundWSTR')  "Wrapped Star"
      ?(%'AZP' %'AZP-TEST')   "Urbit Star"
    ==
  ++  swap                                     ::  [%coin 1 0x1 %wstr %wstr 6] => "$WSTR"
    |=  swa=^swap
    ^-  tape
    ?-  -.swa
      %coin  (coin +.swa)
      %enft  (enft +.swa)
      %chip  (chip +.swa)
    ==
  ++  coin                                     ::  [1 0x1 %wstr %wstr 6] => "$WSTR"
    |=  con=^coin
    ^-  tape
    "${(cuss (trip symbol.con))}"
  ++  enft                                     ::  [1 0x1 %azimuth %azp …] => "@AZP"
    |=  nft=^enft
    ^-  tape
    "@{(cuss (trip symbol.nft))}"
  ++  chip                                     ::  [%udc %udc 2] => "-USD"
    |=  chi=^chip
    ^-  tape
    "-{(cuss (trip symbol.chi))}"
  ++  xeta                                     ::  [1 %ethereum ''] => "Ethereum"
    |=  xet=^xeta
    ^-  tape
    ?+  tag.xet  (caps:fx (trip tag.xet))
      %sepolia   "Sepolia (Testnet)"
    ==
  ++  role                                     ::  %orac => "oracle"
    |=  rol=^role
    ^-  tape
    ?-  rol
      %work  "worker"
      %orac  "oracle"
      %fund  "funder"
    ==
  ++  mula                                     ::  [%plej …] => "pledge"
    |=  mul=^mula
    ^-  tape
    ?-  -.mul
      %plej  "pledge"
      %trib  "contribution"
      %pruf  ?-(note.mul %with "withdrawal", %depo "deposit")
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
  ++  size                                     ::  --1 => "lg"
    |=  syz=@sd
    ^-  tape
    ?+  syz   "md"
      %-4     "3xs"
      %-3     "2xs"
      %-2     "xs"
      %-1     "sm"
      %--0    "md"
      %--1    "lg"
      %--2    "xl"
      %--3    "2xl"
      %--4    "3xl"
    ==
  --
--
