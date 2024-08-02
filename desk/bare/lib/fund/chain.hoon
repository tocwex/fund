:: /lib/fund/chain/hoon: blockchain-related data and functions for %fund
::
/-  *fund-watcher, *fund-core
/+  fund-config=config
|%
++  xeta                                         ::  chain metadata core
  |%
  ++  ethereum   `^xeta`[1 %ethereum 'https://eth.drpc.org']
  ++  sepolia    `^xeta`[11.155.111 %sepolia 'https://sepolia.drpc.org']
  ::  ++  optimism   `^xeta`[10 %optimism ?]
  ::  ++  base       `^xeta`[8.453 %base ?]
  ::  ++  arbitrum   `^xeta`[42.161 %arbitrum ?]
  ::  ++  chainless  `^xeta`[9.223.372.036.854.775.772 %chainless '']  ::  https://eips.ethereum.org/EIPS/eip-2294
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
++  coin                                         ::  coin metadata core
  |%
  ++  ethereum-usdc   [id:ethereum:xeta 0xa0b8.6991.c621.8b36.c1d1.9d4a.2e9e.b0ce.3606.eb48 'USDC' 'USDC' 6]
  ++  ethereum-wstr   [id:ethereum:xeta 0xf0dc.76c2.2139.ab22.618d.dfb4.98be.1283.2546.12b1 'WrappedStar' 'WSTR' 18]
  ++  sepolia-usdc    [id:sepolia:xeta 0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38 '%fund USDC' 'fundUSDC' 6]
  ++  sepolia-wstr    [id:sepolia:xeta 0x3066.f428.d935.a44b.e7aa.845b.6c6b.8125.19ce.1e17 '%fund WSTR' 'fundWSTR' 18]
  ::  ++  chainless-none  [id:chainless:xeta 0x0 'Coinless' 'COINLESS' 2]
  --
++  cmap                                         ::  coin metadata map
  ~+
  ^-  (map [@ @] ^coin)
  =+  vas=!>(coin)
  =<  +  %^  spin  (sloe p.vas)  *(map [@ @] ^coin)
  |=  [nex=@tas acc=(map [@ @] ^coin)]
  =+  con=;;(^coin +:(slap vas (ream nex)))
  ::  NOTE: There could be collisions here, but it's quite unlikely
  :-  nex
  %-  ~(gas by acc)
  %-  turn  :_  (late con)
  :~  [`@`chain.con `@`addr.con]
      [`@`tag:(~(got by xmap) chain.con) `@`addr.con]
      [`@`chain.con `@`symbol.con]
      [`@`tag:(~(got by xmap) chain.con) `@`symbol.con]
  ==
++  clis
  ~+
  ^-  (list ^coin)
  %-  zing
  %+  turn  xlis
  |=  xet=^xeta
  ^-  (list ^coin)
  %-  sort  :_  |=([a=^coin b=^coin] (aor symbol.a symbol.b))
  ~(tap in (silt (skim ~(val by cmap) |=(c=^coin =(id.xet chain.c)))))
++  scan-cfgz
  |=  [oat=oath cin=^coin]
  ^-  (list [path config])
  ?:  =(0x0 safe.oat)  ~
  ?~  con=(~(get by cmap) [chain addr]:cin)  ~
  ::  ?:  =(id:chainless:xeta chain.u.con)  ~
  ?~  can=(~(get by xmap) chain.u.con)  ~
  %+  turn  `(list @tas)`~[%depo %with]
  |=  act=term
  :-  /scan/[act]
  :*  url=rpc.u.can
      eager=|
      refresh-rate=!<(@dr (slot:fund-config %scan-herz))
      timeout-time=!<(@dr (slot:fund-config %scan-tout))
      from=p.xact.oat
      to=~
      contracts=[addr.u.con]~
      confirms=`!<(@ud (slot:fund-config %scan-bloq))
      topics=[0x0 ?:(=(%depo act) ~[0x0 safe.oat] ~[safe.oat 0x0])]
  ==
--
