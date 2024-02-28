::  /lib/libhex/hoon: h(oon) ex(tension) helper functions
::
|%
::  +enum: given a list [l1, …, lN], return an index-enumerated list
::  [[0 l1], …, [N-1 lN]]
::
++  enum
  |*  lis=(list)
  =>  .(lis (homo lis))
  ^-  (list _?>(?=(^ lis) [0 i.lis]))
  =/  ind=@  0
  |-  ?~(lis ~ [[ind i.lis] $(lis t.lis, ind +(ind))])
::  +asci: transform arbitrary @t into nearest equivalent @tas
::
::    NOTE: I attempted to take the map-based algorithm from 'anyascii'
::    (i.e. https://github.com/anyascii/anyascii), but the resulting
::    Hoon file took over 2 hours to compile, so we use a much simpler
::    algorithm as a first pass
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
    ?~(rar=(rush tar alp) 'x' u.rar)
  --
--
