/-  *fund-core
|%
::
::  $prof: user profile data
::
++  prof
  $:  ship-url=@t
      wallets=(map addr sigm)
      ::  favorites=(set flag)  ::  listings of projects; see "meta"
  ==
::
::  $pref: profile with peer information
::
+$  pref  [prof live=_|]
::
::  $proz: collection of projects keyed by id (host/term)
::
+$  proz  (map @p prof)
::
::  $prez: project collection with peer information
::
+$  prez  (map @p pref)
::
::  $prod: raw profile delta
::
+$  prod
  $%  ::  data prods  ::
      [%sign sig=sigm]
      [%surl url=@t]
      ::  meta prods  ::
      [%join ~]
      [%exit ~]
  ==
::
::  $poke: profile edit delta
::
+$  poke  (pair @p prod)
--
