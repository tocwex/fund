:: /lib/fund/form/hoon: format helper functions for %fund
::
/-  *fund
/+  fx=fund-xtra, rudder
|%
+|  %url
++  derl                                       ::  rl-path => noun
  |%
  ++  slag                                     ::  (url path) suffix
    |=  cor=cord  ~+
    ^-  path
    =/  [pre=tape suf=tape]  (chop:fx (trip cor) '?')
    ::  FIXME: A smarter `stab` parser would be better, e.g. something like:
    ::  `path`(rash '/a/b/' ;~(sfix stap fas))
    =?  pre  ?=([%'/' *] (flop pre))  (snip pre)
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
  ++  aset                                     ::  as(s)e(t) t(ape) (url path)
    |=  ast=@t  ~+
    ^-  tape
    (dest /asset/[(crip "{(trip ast)}.svg")])
  ++  asec                                     ::  as(s)e(t) c(ord) (url path)
    |=  ast=@t  ~+
    ^-  cord
    (desc /asset/[(crip "{(trip ast)}.svg")])
  --
  ++  surt                                     ::  s(hip) ur(l) t(ape) (url path)
    |=  sip=@p  ~+
    ^-  tape
    ::  TODO: Comets should use the URL to a pure black image
    ?-    (clan:title sip)
      %pawn  "https://azimuth.network/erc721/{(bloq:enjs 0)}.svg"
      %earl  "https://azimuth.network/erc721/{(bloq:enjs `@`(end 5 sip))}.svg"
      *      "https://azimuth.network/erc721/{(bloq:enjs `@`sip)}.svg"
    ==
  ++  surc                                     ::  s(hip) ur(l) c(ord) (url path)
    |=  sip=@p  ~+
    ^-  cord
    (crip (surt sip))

+|  %js
++  dejs                                       ::  js-tape => noun
  |%
  ++  cash                                     ::  "12.345" => 12.345.000
    =+  exp=6
    |=  cas=@t
    ^-  ^cash
    ::  FIXME: `royl-rn:so` crashes on values w/o leading 0s (e.g. '.1')
    =+  tas=(trip cas)
    =?  cas  &(?=(^ tas) =(i.tas '.'))  (crip ['0' tas])
    =+  caf=(rash cas (cook royl-cell:so royl-rn:so))
    ?>  ?=(%d -.caf)
    %-  abs:si  %-  need  %-  toi:fl  %-  grd:fl
    caf(e (sum:si e.caf (sun:si exp)))
  ++  real                                     ::  "12.345" => .1.2345e1
    |=  rel=@t
    ^-  @rs
    (rash rel royl-rs:so)
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
  ++  cash                                     ::  12.345.000 => "12.34"
    =+  exp=6
    |=  cas=^cash
    ^-  tape
    =+  cax=(drg:fl (sun:fl cas))
    ?>  ?=(%d -.cax)
    =.  e.cax  (dif:si e.cax (sun:si exp))
    (flot:fx cax `[2 2])
  ++  real                                     ::  .1.2345e1 => "12.34"
    |=  rel=@rs
    ^-  tape
    (flot:fx (rlys rel) `[0 2])
  ++  srel                                     ::  .1.2345e1 => "12"
    |=  rel=@rs
    ^-  tape
    (flot:fx (rlys rel) `[0 0])
  ++  bloq                                     ::  1234.56... => "123456..."
    |=  boq=^bloq
    ^-  tape
    (a-co:co boq)
  ++  addr                                     ::  0xabcd.ef... => "0xabcdef..."
    |=  adr=^addr
    ^-  tape
    ['0' 'x' ((x-co:co 40) adr)]
  ++  sadr                                     ::  0xabcd.ef... => "0xabc…def"
    |=  adr=^addr
    ^-  tape
    =+  bas=(addr adr)
    :(weld (scag 5 bas) "…" (slaj:fx 4 bas))
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
    "{(flag p.pok)}:{(trip -.q.pok)}{?.(?=(?(%bump %mula) -.q.pok) ~ ['-' (trip +<.q.pok)])}"
  ++  role                                     ::  %orac => "oracle"
    |=  rol=^role
    ^-  tape
    ?-  rol
      %work  "worker"
      %orac  "oracle"
      %fund  "funder"
    ==
  ++  mula                                     ::  [%plej ...] => "pledge"
    |=  mul=^mula
    ^-  tape
    ?-  -.mul
      %plej  "pledge"
      %trib  "contribution"
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
