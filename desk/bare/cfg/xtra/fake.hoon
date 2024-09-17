::  /cfg/xtra/fake.hoon : %fund fakezod configuration file
::
%-  malt
^-  (list [@tas vase])
=/  alc=tape  (flop ~['E' 'f' 'd' 't' 'J' 'X' 'S' 'C' 'H' 'I' 'C' 'F' 'D' 'B' 'w' '4' '3' 'R' 'H' 'f' 'y' 'f' 'b' 'y' '1' 'S' 'A' 'E' 'E' 'E' 'R' '2'])
:~  [%debug !>(%&)]
    [%point !>(~zod)]
    [%sign-addr !>(0xcbbd.2aab.5ee5.09e8.531a.b407.d48f.c93c.dc25.e1ad)]
    [%safe-addr !>(0xcbbd.2aab.5ee5.09e8.531a.b407.d48f.c93c.dc25.e1ad)]
    [%uprl-herz !>(~m1)]
    [%scan-herz !>(~s10)]
    [%scan-tout !>(~s10)]
    [%scan-bloq !>(5)]
    [%alch-akey !>(`@t`(crip alc))]
    [%rpce-ethe !>(`@t`(crip "https://eth-mainnet.g.alchemy.com/v2/{alc}"))]
    [%rpce-sepo !>(`@t`(crip "https://eth-sepolia.g.alchemy.com/v2/{alc}"))]
    [%feat-oraz !>(`(list @p)`(gulf 0 255))]
==
