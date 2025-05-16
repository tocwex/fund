::  /ted/get-pact/hoon: query the events for a given contract on a given
::  chain (optionally specified between a given starting and ending
::  block)
::
::    -fund!get-pact %ethereum ~ ~ ~
::    -fund!get-pact %sepolia `'0xabcd…1234' `6.000.000 `6.001.000
::
/-  spider, chain-watcher, f=fund
/+  ethereum, io=strandio, fc=fund-chain
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ can=@ puc=(unit @t) sub=(unit bloq:f) tub=(unit bloq:f)] arg)
;<  bol=bowl:spider  bind:m  get-bowl:io
=/  xet=xeta:f  (~(got by xmap:fc) can)
=/  pac=pact:f  (~(got by pmap:fc) can)
=/  pad=addr:f  ?~(puc addr.pac (rash u.puc ;~(pfix (jest '0x') hex)))
=/  sob=bloq:f  (fall sub start.pac)
=/  pat=path  /fund/get-pact/(scot %ux pad)/(scot %da now.bol)
;<    ~
    bind:m
  %+  poke:io  [our.bol %chain-watcher]
  :-  %chain-watcher-poke  !>
  :+  %watch  pat
  :*  url=rpc.xet
      eager=|  refresh-rate=~m1  timeout-time=~s30
      from=sob  to=tub
      contracts=[pad]~  confirms=~  topics=~
  ==
;<  ~  bind:m  (sleep:io ~s30)
;<  ~  bind:m  (watch-our:io [%watch pat] %chain-watcher [%logs pat])
;<  caj=cage  bind:m  (take-fact:io [%watch pat])
=+  !<(dif=diff:chain-watcher q.caj)
=/  loz=loglist:chain-watcher  ?+(-.dif loglist.dif %disavow *loglist:chain-watcher)
;<    ~
    bind:m
  (poke:io [our.bol %chain-watcher] chain-watcher-poke+!>([%clear pat]))
(pure:m !>(loz))
