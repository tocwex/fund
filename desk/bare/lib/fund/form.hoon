:: /lib/fund/form/hoon: format helper functions for %fund
::
/-  *fund
/+  fx=fund-xtra
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
  --

+|  %js
++  dejs                                       ::  js-tape => noun
  |%
  ++  cash                                     ::  "12.345" => 12.345.000
    =+  exp=6
    |=  cas=@t
    ^-  ^cash
    =+  caf=(rash cas (cook royl-cell:so royl-rn:so))
    ?>  ?=(%d -.caf)
    %-  abs:si  %-  need  %-  toi:fl  %-  grd:fl
    caf(e (sum:si e.caf (sun:si exp)))
  ++  real                                     ::  "12.345" => .1.2345e1
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
  ++  cash                                     ::  12.345.000 => "12.345"
    =+  exp=6
    |=  cas=^cash
    ^-  tape
    ::  TODO: Need to round off everything past two digits after the decimal
    ::  TODO: Need to pad with at least two zeroes after the decimal place
    ::  TODO: Need to insert commas after every three digits before decimal place
    =+  cax=(drg:fl (sun:fl cas))
    ?>  ?=(%d -.cax)
    =+  caf=cax(e (dif:si e.cax (sun:si exp)))
    =/  rep=tape  ?:(s.caf "" "-")
    =/  f  ((d-co:co 1) a.caf)
    =^  e  e.caf
      =/  e=@s  (sun:si (lent f))
      =/  sci  :(sum:si e.caf e -1)
      [(sum:si sci --1) --0]
    (weld rep (ed-co:co e f))
  ++  real                                     ::  .1.2345e1 => "12.345"
    |=  rel=@rs
    ^-  tape
    ?+    ryl=(rlys rel)  "?"
        [%d *]
      =/  rep=tape  ?:(s.ryl "" "-")
      =/  f  ((d-co:co 1) a.ryl)
      =^  e  e.ryl
        =/  e=@s  (sun:si (lent f))
        =/  sci  :(sum:si e.ryl e -1)
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
