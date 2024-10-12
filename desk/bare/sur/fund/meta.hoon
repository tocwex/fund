/-  *fund-core
|%
::
::  $meta: project metadata (for cross-ship sharing)
::
+$  meta
  $:  title=@t
      image=(unit @t)
      cost=cash
      payment=swap
      launch=bloq
      worker=@p
      oracle=@p
  ==
::
::  $mete: profile metadata with peer information
::
+$  mete  [meta live=$~(| ?)]
::
::  $metz: collection of project metadata keyed by id (host/term)
::
+$  metz  (map flag meta)
::
::  $mytz: project metadata collection with peer information
::
+$  mytz  (map flag mete)
::
::  $prod: raw metadata delta
::
+$  prod
  $%  ::  data prods  ::
      [%init met=meta]
      [%drop ~]
      ::  meta prods  ::
      [%join ~]
      [%exit ~]
  ==
::
::  $poke: metadata edit delta
::
+$  poke  (pair flag prod)
--
