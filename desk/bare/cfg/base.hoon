::  /cfg/base.hoon : %fund base configuration file
::
::    see /lib/config.hoon for more information
::
%-  malt
^-  (list [@tas vase])
=/  alc=tape  (flop ~['2' '2' 'B' 'W' '4' '-' 'c' 'W' 'F' 'F' 'B' 'J' 'n' 'b' 'b' '3' '1' 'r' 'L' 'n' 'V' 'W' 'F' 'i' 'j' 'C' 'l' 'G' 'u' '1' 'E' '3'])
:~  [%debug !>(%|)]
    [%point !>(~tocwex)]
    [%sign-addr !>(0x78e6.603f.0393.3e0f.ebc6.88a7.734e.a8b4.b63f.42d0)]
    [%safe-addr !>(0x944a.5ba3.3bd9.5a5e.45e5.41c3.dd5a.0732.e90d.58e6)]
    [%uprl-herz !>(~h1)]
    [%scan-herz !>(~m2)]
    [%scan-tout !>(~m1)]
    [%scan-bloq !>(10)]
    [%alch-akey !>(`@t`(crip alc))]
    [%rpce-ethe !>(`@t`(crip "https://eth-mainnet.g.alchemy.com/v2/{alc}"))]
    [%rpce-sepo !>(`@t`(crip "https://eth-sepolia.g.alchemy.com/v2/{alc}"))]
    [%feat-oraz !>(`(list @p)`~[~reb ~bitdeg ~roswet ~nisfeb ~hosdys ~ridlyd ~darlur ~mocbel ~posdeg ~dalten ~firbex ~moddux ~pandux ~fogbus])]
    [%meta-site !>('https://tocwexsyndicate.com')]
    [%meta-help !>('https://docs.tocwexsyndicate.com')]
    [%meta-tlon !>('https://tlon.network/lure/~tocwex/syndicate-public')]
    [%meta-aset !>('https://90981e03b3525c060ac438353e4a3300.cdn.bubble.io')]
    [%meta-logo !>('https://sfo3.digitaloceanspaces.com/sarlev-sarsen/sarlev-sarsen/2024.4.29..23.58.31..2b02.0c49.ba5e.353f-IMG_4726.jpeg')]
    [%meta-desc !>('%fund: A sovereign webapp built by ~toxwex.syndicate on an integrated blockchain escrow ecosystem for human created, understood, and assessed "wise contracts".')]
==
