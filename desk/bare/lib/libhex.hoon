::  /lib/libhex/hoon: h(oon) ex(tension) helper functions
::
|%
::  +enum: given a list [l1, …, lN], return an index-enumerated list
::  [[0 l1], …, [N-1 lN]]
::
++  enum
  |*  a=(list)
  =>  .(a (homo a))
  ^-  (list _?>(?=(^ a) [0 i.a]))
  =/  n=@  0
  |-  ?~(a ~ [[n i.a] $(a t.a, n +(n))])
--
