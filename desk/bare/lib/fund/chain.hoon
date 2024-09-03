:: /lib/fund/chain/hoon: blockchain-related data and functions for %fund
::
/-  *fund-watcher, *fund-core
/+  fund-config=config
|%
++  xlis                                         ::  chain metadata list
  ~+
  ^-  (list xeta)
  :~  [1 %ethereum 'https://eth.drpc.org']
      [11.155.111 %sepolia 'https://sepolia.drpc.org']
      ::  [10 %optimism ?]
      ::  [8.453 %base ?]
      ::  [42.161 %arbitrum ?]
      ::  [0 %none '']
  ==
++  xmap                                         ::  chain metadata map
  ~+
  ^-  (map @ xeta)
  %+  roll  xlis
  |=  [xet=xeta acc=(map @ xeta)]
  ::  NOTE: There could be collisions here, but it's quite unlikely
  (~(gas by acc) ~[[`@`id.xet xet] [`@`tag.xet xet]])
++  slis                                         ::  swap metadata list
  ~+
  ^-  (list swap)
  :~  :*  %coin  ::  eth-usdc
          1
          0xa0b8.6991.c621.8b36.c1d1.9d4a.2e9e.b0ce.3606.eb48
          'USDC'
          'USDC'
          6
      ==
      :*  %coin  ::  eth-wstr
          1
          0xf0dc.76c2.2139.ab22.618d.dfb4.98be.1283.2546.12b1
          'WrappedStar'
          'WSTR'
          18
      ==
      :*  %enft  ::  eth-azp-star
          1
          0x33ee.cbf9.0847.8c10.6146.26a9.d304.bfe1.8b78.dd73
          'Azimuth Points'
          'AZP'
          |=(i=@ud "https://azimuth.network/erc721/{<i>}.json")
          (malt ~[[%size |=(=@t =(%star t))]])
      ==
      :*  %coin  ::  sepolia-usdc
          11.155.111
          0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38
          '%fund USDC'
          'fundUSDC'
          6
      ==
      :*  %coin  ::  sepolia-wstr
          11.155.111
          0x3066.f428.d935.a44b.e7aa.845b.6c6b.8125.19ce.1e17
          '%fund WSTR'
          'fundWSTR'
          18
      ==
      :*  %enft  ::  sepolia-azp-star
          11.155.111
          0xabe2.8c76.e1c9.750e.b78f.32a0.7c29.5afa.99b5.57fd
          'Urbit Azimuth NFT (TEST)'
          'AZP-TEST'
          |=(i=@ud "https://azimuth.network/erc721/{<i>}.json")
          (malt ~[[%size |=(=@t =(%star t))]])
      ==
      ::  [%chip %0 %0x0 'Fiat USD' 'USD' 2]  ::  none-fusd
      ::  [%chip %0 %0x0 'Azimuth Points (Fiat)' 'AZP-FIAT' 2]  ::  none-fazp
  ==
++  smap                                         ::  swap metadata map
  ~+
  ^-  (map [@ @] swap)
  %+  roll  slis
  |=  [swa=swap acc=(map [@ @] swap)]
  ::  NOTE: There could be collisions here, but it's quite unlikely
  %-  ~(gas by acc)
  %-  turn  :_  (late swa)
  :~  [`@`chain.swa `@`addr.swa]
      [`@`tag:(~(got by xmap) chain.swa) `@`addr.swa]
      [`@`chain.swa `@`symbol.swa]
      [`@`tag:(~(got by xmap) chain.swa) `@`symbol.swa]
  ==
++  scan-cfgz
  |=  [oat=oath swa=swap]
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
