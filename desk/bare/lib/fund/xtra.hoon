::  /lib/fund/xtra/hoon: miscellaneous helper functions
::
|%
::
::  +enum: given a list [l1, …, lN], return an index-enumerated list
::  [[0 l1], …, [N-1 lN]]
::
++  enum
  |*  a=(list)
  =>  .(a (homo a))
  ^-  (list _?>(?=(^ a) [0 i.a]))
  =/  ind=@  0
  |-  ?~(a ~ [[ind i.a] $(a t.a, ind +(ind))])
::
::  +izip: given lists [l1, …, lN] and [m1, …, mM], return an
::  inner-zipped list [[l1, m1], …, [l(min N M) m(min N M)]]
::
++  izip
  |*  [a=(list *) b=(list *)]
  ?~  a  ~
  ?~  b  ~
  [[i.a i.b] $(a t.a, b t.b)]
::
::  +ozip: given lists [l1, …, lN] and [m1, …, mM], return an
::  outer-zipped list of units [[`l1, `m1], …, [`l(max N M) `m(max N M)]]
::
++  ozip
  |*  [a=(list *) b=(list *)]
  ?~  a  (turn b (cork (lead ~) (lead ~)))
  ?~  b  (turn a (cork (lead ~) (late ~)))
  [[`i.a `i.b] $(a t.a, b t.b)]
::
::  +find: given list [l1, …, lN] and gate of g: li -> ?, return the
::  first item where g(li) is true
::
++  find
  |*  [a=(list) b=$-(* ?)]
  =>  .(a (homo a))
  ^-  (unit _?>(?=(^ a) i.a))
  ?~(c=(skim a b) ~ `i.c)
::
::  +scaj: given list [l1, …, lN] and count a, return the prefix
::  items exluding the last a, i.e. [l1, …, l(N-a)]
::
++  scaj
  |*  [a=@ b=(list)]
  =>  .(b (homo b))
  =+  c=(lent b)
  ?:((gte a c) ~ (scag (sub c a) b))
::
::  +slaj: given list [l1, …, lN] and count a, return the last a
::  items [l(max(1, N-a)), …, lN]
::
++  slaj
  |*  [a=@ b=(list)]
  =>  .(b (homo b))
  =+  c=(lent b)
  ?:((gte a c) b (slag (sub c a) b))
::
::  +asci: transform arbitrary @t into nearest equivalent @tas
::
++  asci
  |=  cor=@t
  ^-  @tas
  |^  (crip (cass (trix (weed (trip cor)))))
  ++  trix  ::  "-ab---3" => "xab---3"
    |=  tap=tape  ^-  tape
    ?~  tap  tap
    [?~((rush i.tap ;~(pose hep nud)) i.tap 'x') t.tap]
  ++  weed  ::  "-ab^-#3" => "-ab---3"
    |=  tap=tape  ^-  tape
    %+  turn  (tuba tap)
    |=  car=@c  ^-  @tD
    =/  tar=@t  (tuft car)
    ?~(rar=(rush tar alp) '-' u.rar)
  --
::
::  +chop: same idea as partition:string but safer and maybe more efficient
::
++  chop
  |*  [log=(list *) div=*]
  ^-  [pre=_log suf=_log]
  =/  pre=_log  ~
  |-
  ?:  =(~ log)      [pre ~]
  ?:  =(div -.log)  [pre +.log]
  $(pre (snoc pre -.log), log +.log)
::
::  +chip: strip leading based from full site path (see decap:rudder)
::
++  chip
  |=  [bas=(list @t) syt=(list @t)]
  ^-  (unit (list @t))
  ?~  bas  `syt
  ?~  syt  ~
  ?.  =(i.bas i.syt)  ~
  $(bas t.bas, syt t.syt)
::
::  +caps: capitalize the given input string (first character only)
::
++  caps
  |=  tap=tape
  ^-  tape
  ?~  tap  tap
  [-:(cuss [i.tap]~) t.tap]
::
::  +star: is the given identity at least as privileged as a star?
::
++  star
  |=  who=@p
  ^-  bean
  (gte 2 (met 3 who))
::
::  +plan: is the given identity at least as privileged as a planet?
::
++  plan
  |=  who=@p
  ^-  bean
  (gte 4 (met 3 who))
::
::  +link: is the given string a link (and is it relative or absolute)?
::
++  link
  |=  lin=tape
  ^-  (unit bean)
  =,  de-purl:html
  =-  (bind - head)
  %+  rust  lin
  ;~  pose
      ;~(plug (easy %&) auri)       ::  absolute link
      ;~(plug (easy %|) apat yque)  ::  relative link
  ==
::
::  +dist: absolute distance between two values
::
++  dist
  |=  [a=@ b=@]
  ^-  @
  (sub (max a b) (min a b))
::
::  +rato: rat(i)o of value relative to given total
::
++  rato
  |=  [val=@ tot=@]
  ^-  @rs
  ?:  =(0 tot)
    ?:(=(0 val) .0 .1)  ::  FIXME: Probably should be NaN instead
  (div:rs (sun:rs val) (sun:rs tot))
::
::  +perc: perc(entage) of value relative to given total
::
++  perc
  |=  [val=@ tot=@]
  ^-  @rs
  (mul:rs .100 (rato val tot))
::
::  +flot: render decimal float as tape (optionally decimal-truncated
::  and/or padded)
::
++  flot
  |=  [val=dn dex=(unit [min=@ max=@])]
  ^-  tape
  ?-    val
    [%n *]  "NaN"
    [%i *]  ?:(s.val "" "-")
  ::
      [%d *]
    =-  %+  weld  ?:(s.fin "" "-")
        ::  TODO: insert commas after every three digits before decimal place
        =/  int=tape  ((d-co:co 1) a.fin)
        =/  exp=@s    (sum:si e.fin (sun:si (lent int)))
        (ed-co:co exp int)
    ^-  fin=[%d s=? e=@s a=@u]
    ?~  dex  val
    ?:  =(--1 (cmp:si e.val --0))  val  ::  e.val > 0
    =-  val(e (dif:si e.val sha), a (?:((syn:si sha) mul div) a.val (pow 10 (abs:si sha))))
    ^-  sha=@sd
    =+  vel=(abs:si e.val)
    ?:  (gth vel max.u.dex)  (dif:si (sun:si max.u.dex) (sun:si vel))
    ?:  (lth vel min.u.dex)  (dif:si (sun:si min.u.dex) (sun:si vel))
    --0
  ==
--
