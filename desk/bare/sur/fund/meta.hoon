/-  *fund-core
|%
::
::  $meta: project metadata (for cross-ship sharing)
::
+$  meta
  $:  title=@t
      cost=cash
      currency=coin
      worker=@p
      oracle=@p
  ==
::
::  $mete: profile metadata with peer information
::
+$  mete  [meta live=_|]
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
