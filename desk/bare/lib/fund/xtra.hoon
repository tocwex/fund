::  /lib/fund/xtra/hoon: miscellaneous helper functions
::
|%
+|  %hoon
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
::  +find: given list [l1, …, lN] and gate of g: li -> ?, return the
::  first item where g(li) is true
::
++  find
  |*  [a=(list) b=$-(* ?)]
  =>  .(a (homo a))
  ^-  (unit _?>(?=(^ a) i.a))
  ?~(c=(skim a b) ~ `i.c)
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
    [?~((rush i.tap hep) i.tap 'x') t.tap]
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

+|  %arvo
::
::  +read-file: use %clay to read the latest version of a file in this
::  desk at a given path
::
++  read-file
  |=  [=bowl:gall =path]  ~+
  ^-  tape
  %-  trip
  .^(@t %cx (weld /(scot %p our.bowl)/[dap.bowl]/(scot %da now.bowl) path))

+|  %ethereum
::
::  +curr-bloq: the current blockchain block
::
++  curr-bloq
  ^-  @ud
  ?:  .^(? %j /=fake=)  20.000.000
  .^(@ud %gx /=eth-watcher=/block/azimuth/noun)
::
::  +time-bloq: the estimated number of blocks for a time frame
::
++  time-bloq
  |=  time=@dr
  ^-  @ud
  0
::
::  +bloq-time: the estimated time frame for a number of blocks
::
++  bloq-time
  |=  bloq=@ud
  ^-  @dr
  *@dr
--
