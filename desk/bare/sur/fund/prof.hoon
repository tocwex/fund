/-  *fund
|%
::
::  $prof: user profile data
::
++  prof
  $:  ship-url=@t
      wallets=(map addr sigm)
  ==
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
  $%
::
::  $poke: profile edit delta
::
+$  poke  (pair @p prod)
--
