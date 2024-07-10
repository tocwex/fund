/-  *scanner, *fund
|%
++  xeta                                         ::  chain metadata core
  |%
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
  =+  eta=;;(^xeta +:(slap vas (ream nex)))
  ::  NOTE: There could be collisions here, but it's quite unlikely
  [nex (~(gas by acc) ~[[`@`id.eta eta] [`@`tag.eta eta]])]
++  coin                                         ::  coin metadata map
  ^-  (map [@ addr] ^coin)
  %-  malt  %-  zing
  %+  turn
    ^-  (list ^coin)
    :~  [id:ethereum:xeta 0xa0b8.6991.c621.8b36.c1d1.9d4a.2e9e.b0ce.3606.eb48 'USDC' 'USDC' 6]
        [id:ethereum:xeta 0xf0dc.76c2.2139.ab22.618d.dfb4.98be.1283.2546.12b1 'WrappedStar' 'WSTR' 18]
        [id:sepolia:xeta 0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38 '%fund USDC' 'fundUSDC' 6]
        [id:sepolia:xeta 0x3066.f428.d935.a44b.e7aa.845b.6c6b.8125.19ce.1e17 '%fund WSTR' 'fundWSTR' 18]
    ==
  |=  con=^coin
  ^-  (list [[@ addr] ^coin])
  =+  bas=[[id=*@ addr.con] con]
  ~[bas(id chain.con) bas(id tag:(~(got by xmap) chain.con))]
++  scan-cfgz
  |=  [oat=oath cin=^coin]
  ^-  (list [path config])
  ?:  =(0x0 safe.oat)  ~
  ?~  con=(~(get by coin) [chain addr]:cin)  ~
  ?~  can=(~(get by xmap) chain.u.con)  ~
  %+  turn  `(list @tas)`~[%depo %with]
  |=  act=term
  :-  /scan/[act]
  :*  url=rpc.u.can
      eager=|
      refresh-rate=~s10
      timeout-time=~m1
      from=p.xact.oat
      to=~
      contracts=[addr.u.con]~
      confirms=`6
      topics=[0x0 ?:(=(%depo act) ~[0x0 safe.oat] ~[safe.oat 0x0])]
  ==
--
