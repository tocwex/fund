::  base.hoon : %fund default configuration file
::
::    see /lib/config.hoon for more information
::
%-  malt
^-  (list [@tas vase])
:~  [%debug !>(%|)]
    [%chain !>(`@tas`%mainnet)]
    [%point !>(~tocwex)]
    [%sign-addr !>(0x0)]  ::  TODO: Fill this in with real address
    [%safe-addr !>(0x0)]  ::  TODO: Fill this in with real address
==
