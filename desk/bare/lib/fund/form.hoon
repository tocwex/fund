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
    (need (chip:fx /apps/fund (stab (crip pre))))
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
    (dest /asset/[(crip "{(cass (trip ast))}.svg")])
  ++  asec                                     ::  as(s)e(t) c(ord) (url path)
    |=  ast=@t  ~+
    ^-  cord
    (desc /asset/[(crip "{(cass (trip ast))}.svg")])
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
  ++  mony                                     ::  [12.345.000 [1 0x0 %wstr %wstr 6]] => "12.34 $WSTR"
    |=  [cas=^cash con=^coin]
    ^-  tape
    ?+  symbol.con  "{(cash cas decimals.con)} {(coin con)}"
      ?(%'USDC' %'fundUSDC' %'OOBP')  "${(cash cas decimals.con)}"
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
  ++  bool                                     ::  %.y => "true"
    |=  bul=?
    ^-  tape
    ?:(bul "true" "false")
  ++  srel                                     ::  .1.2345e1 => "12"
    |=  rel=@rs
    ^-  tape
    (flot:fx (rlys rel) `[0 0])
  ++  bloq                                     ::  1234.56… => "123456…"
    |=  boq=^bloq
    ^-  tape
    (a-co:co boq)
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
  ++  flag                                     ::  [~zod %nam] => "~zod/nam"
    |=  lag=^flag
    ^-  tape
    "{<p.lag>}/{(trip q.lag)}"
  ++  poke                                     ::  [%level [~zod %nam] %type …] => "level:~zod/nam:type"
    |=  pok=^poke
    ^-  tape
    =-  (zing (join ":" `(list tape)`~[lvl (flag lag) typ]))
    ^-  [lvl=tape lag=^flag typ=tape]
    :-  (trip -.pok)
    ?-  -.pok
      %fund  [[~zod %$] (trip +<.pok)]
      %prof  [[p.pok %$] (trip +<.q.pok)]
      %meta  [p.pok (trip +<.q.pok)]
      %proj  [p.pok "{(trip -.q.pok)}{?+(-.q.pok ~ ?(%bump %mula) ['-' (trip +<.q.pok)])}"]
    ==
  ++  coin                                     ::  [1 0x1 %wstr %wstr 6] => "$WSTR"
    |=  con=^coin
    ^-  tape
    "${(cuss (trip symbol.con))}"
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
  --
--
