:: /lib/fund/chain/hoon: blockchain-related data and functions for %fund
::
/-  *fund-watcher, *fund-core
/+  fund-config=config
|%
++  xeta                                         ::  chain metadata core
  |%
  ::  ++  none      `^xeta`[0 %none '']
  ++  ethereum  `^xeta`[1 %ethereum 'https://eth.drpc.org']
  ++  sepolia   `^xeta`[11.155.111 %sepolia 'https://sepolia.drpc.org']
  ::  ++  optimism  `^xeta`[10 %optimism ?]
  ::  ++  base      `^xeta`[8.453 %base ?]
  ::  ++  arbitrum  `^xeta`[42.161 %arbitrum ?]
  --
++  xmap                                         ::  chain metadata map
  ~+
  ^-  (map @ ^xeta)
  =+  vas=!>(xeta)
  =<  +  %^  spin  (sloe p.vas)  *(map @ ^xeta)
  |=  [nex=@tas acc=(map @ ^xeta)]
  =+  xet=;;(^xeta +:(slap vas (ream nex)))
  ::  NOTE: There could be collisions here, but it's quite unlikely
  [nex (~(gas by acc) ~[[`@`id.xet xet] [`@`tag.xet xet]])]
++  xlis                                         ::  chain metadata list
  ~+
  ^-  (list ^xeta)
  %-  turn  :_  |=(i=@ud (~(got by xmap) i))
  (sort ~(tap in (silt (turn ~(val by xmap) |=(x=^xeta id.x)))) lth)
++  swap                                         ::  swap metadata core
  |%
  ++  ethereum-usdc
    ^-  ^swap
    :*  %coin
        id:ethereum:xeta
        0xa0b8.6991.c621.8b36.c1d1.9d4a.2e9e.b0ce.3606.eb48
        'USDC'
        'USDC'
        6
    ==
  ++  ethereum-wstr
    ^-  ^swap
    :*  %coin
        id:ethereum:xeta
        0xf0dc.76c2.2139.ab22.618d.dfb4.98be.1283.2546.12b1
        'WrappedStar'
        'WSTR'
        18
    ==
  ++  ethereum-azp-star
    ^-  ^swap
    :*  %enft
        id:ethereum:xeta
        0x33ee.cbf9.0847.8c10.6146.26a9.d304.bfe1.8b78.dd73
        'Azimuth Points'
        'AZP'
        |=(i=@ud "https://azimuth.network/erc721/{<i>}.json")
        (malt ~[[%size |=(=@t =(%star t))]])
    ==
  ++  sepolia-usdc
    ^-  ^swap
    :*  %coin
        id:sepolia:xeta
        0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38
        '%fund USDC'
        'fundUSDC'
        6
    ==
  ++  sepolia-wstr
    ^-  ^swap
    :*  %coin
        id:sepolia:xeta
        0x3066.f428.d935.a44b.e7aa.845b.6c6b.8125.19ce.1e17
        '%fund WSTR'
        'fundWSTR'
        18
    ==
  ++  sepolia-azp-star
    ^-  ^swap
    :*  %enft
        id:sepolia:xeta
        0xabe2.8c76.e1c9.750e.b78f.32a0.7c29.5afa.99b5.57fd
        'Urbit Azimuth NFT (TEST)'
        'AZP-TEST'
        |=(i=@ud "https://azimuth.network/erc721/{<i>}.json")
        (malt ~[[%size |=(=@t =(%star t))]])
    ==
  ::  ++  none-fusd
  ::    ^-  ^swap
  ::    :*  %chip
  ::        %0
  ::        %0x0
  ::        'Fiat USD'
  ::        'USD'
  ::        2
  ::    ==
  --
++  smap                                         ::  swap metadata map
  ~+
  ^-  (map [@ @] ^swap)
  =+  vas=!>(swap)
  =<  +  %^  spin  (sloe p.vas)  *(map [@ @] ^swap)
  |=  [nex=@tas acc=(map [@ @] ^swap)]
  =+  swa=;;(^swap +:(slap vas (ream nex)))
  ::  NOTE: There could be collisions here, but it's quite unlikely
  :-  nex
  %-  ~(gas by acc)
  %-  turn  :_  (late swa)
  :~  [`@`chain.swa `@`addr.swa]
      [`@`tag:(~(got by xmap) chain.swa) `@`addr.swa]
      [`@`chain.swa `@`symbol.swa]
      [`@`tag:(~(got by xmap) chain.swa) `@`symbol.swa]
  ==
++  slis                                         ::  swap metadata list
  ~+
  ^-  (list ^swap)
  %-  zing
  %+  turn  xlis
  |=  xet=^xeta
  ^-  (list ^swap)
  =+  swav=|=(s=^swap ?-(-.s %coin 0, %enft 1, %chip 2))
  %+  sort  ~(tap in (silt (skim ~(val by smap) |=(b=^swap =(id.xet chain.b)))))
  |=  [saa=^swap sab=^swap]
  =/  [vaa=@ vab=@]  [(swav saa) (swav sab)]
  ?.  =(vaa vab)  (lth vaa vab)
  (aor symbol.saa symbol.sab)
++  scan-cfgz
  |=  [oat=oath swa=^swap]
  ^-  (list [path config])
  ?:  |(=(0x0 safe.oat) ?=(%chip -.swa))  ~
  ?~  con=(~(get by smap) [chain addr]:swa)  ~
  ?~  can=(~(get by xmap) chain.u.con)  ~
  %+  turn  `(list @tas)`~[%depo %with]
  |=  act=term
  =/  [src=@ux dst=@ux]  ?:(?=(%depo act) [0x0 safe.oat] [safe.oat 0x0])
  :-  /scan/[act]
  :*  url=rpc.u.can
      eager=|
      refresh-rate=!<(@dr (slot:fund-config %scan-herz))
      timeout-time=!<(@dr (slot:fund-config %scan-tout))
      from=p.xact.oat
      to=~
      contracts=[addr.u.con]~
      confirms=`!<(@ud (slot:fund-config %scan-bloq))
      topics=?-(-.swa %coin ~[0x0 src dst], %enft ~[0x0 src dst 0x0])
  ==
--
