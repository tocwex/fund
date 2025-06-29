::  /cfg/base.hoon : %fund base configuration file
::
::    see /lib/config.hoon for more information
::
%-  malt
^-  (list [@tas vase])
=/  key=tape  (flop ~['1' 'e' 'c' 'b' 'd' 'c' '8' 'a' 'a' '2' '0' '5' 'd' 'c' '7' '8' '7' '4' '8' '4' '8' 'e' '8' 'd' '1' '1' '8' 'a' '0' '9' '7' '3'])
:~  [%debug !>(%|)]
    [%point !>(~tocwex)]
    [%sign-addr !>(0x78e6.603f.0393.3e0f.ebc6.88a7.734e.a8b4.b63f.42d0)]
    [%safe-addr !>(0x8a00.b1d0.8e0f.efad.85c9.fb69.e318.16e2.4002.d6b1)]
    [%uprl-herz !>(~h1)]
    [%scan-herz !>(~m2)]
    [%scan-tout !>(~m10)]
    [%scan-bloq !>(10)]
    [%alch-akey !>(`@t`(crip (flop ~['2' '2' 'B' 'W' '4' '-' 'c' 'W' 'F' 'F' 'B' 'J' 'n' 'b' 'b' '3' '1' 'r' 'L' 'n' 'V' 'W' 'F' 'i' 'j' 'C' 'l' 'G' 'u' '1' 'E' '3'])))]
    [%rpce-ethe !>(`@t`(crip "https://mainnet.infura.io/v3/{key}"))]
    [%rpce-sepo !>(`@t`(crip "https://sepolia.infura.io/v3/{key}"))]
    [%feat-oraz !>(`(list @p)`~[~reb ~rus ~bitdeg ~roswet ~nisfeb ~hosdys ~ridlyd ~darlur ~mocbel ~posdeg ~dalten ~firbex ~moddux ~pandux ~fogbus])]
    [%meta-site !>('https://tocwexsyndicate.com')]
    [%meta-help !>('https://docs.tocwexsyndicate.com')]
    [%meta-tlon !>('https://tlon.network/lure/~tocwex/syndicate-public')]
    [%meta-aset !>('https://90981e03b3525c060ac438353e4a3300.cdn.bubble.io')]
    [%meta-logo !>('https://sfo3.digitaloceanspaces.com/sarlev-sarsen/sarlev-sarsen/2024.4.29..23.58.31..2b02.0c49.ba5e.353f-IMG_4726.jpeg')]
    [%meta-desc !>('%fund: A sovereign webapp built by ~toxwex.syndicate on an integrated blockchain escrow ecosystem for human created, understood, and assessed "wise contracts".')]
==
