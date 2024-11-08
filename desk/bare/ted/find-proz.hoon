::  /ted/find-proz/hoon: query metadata for all projects on a given chain
::
::    -fund!find-proz %ethereum
::
::    .^((list path) %gx /=spider=/tree/noun)
::    :spider &spider-stop [~.~.dojo... |]
::
/-  spider, fund-watcher, f=fund
/+  ethereum, io=strandio, fc=fund-chain
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ can=@tas] arg)
=/  xet=xeta:f  (~(got by xmap:fc) can)
=/  [xos=@ud xoa=@ux]
  ?+  id.xet     !!
    %1           [19.763.774 0xce13.ec86.bd8b.8827.9ec6.3eb9.f1ae.d967.59ce.5063]
    %11.155.111  [5.793.125 0xafd2.dcb1.e947.01e5.b96d.88d1.6586.8590.4578.c2f7]
  ==
::  TODO: Get all `(list [con=addr:f swa=swap:f cur=cash:f tot=cash:f])`
::  - [ ] List of all contract addresses
::  - [ ] Swap medium for each project (Alchemy API)
::    - [ ] ERC20s: https://docs.alchemy.com/reference/alchemy-gettokenbalances
::    - [ ] ERC721s: https://docs.alchemy.com/reference/getcollectionsforowner-v3
::  - [ ] Cash amount for the project's medium of exchange (Alchemy API)
::    - [ ] Current cash in project treasury
::    - [ ] Total raised in project tresury
::
::  TODO: Need these threads:
::  - $-(can=@tas loz=(list event-log:rpc:ethereum))
::      list of contract events for given chain (can be made more
::      general; idk if it's worth it)
::  - $-(con=@ux toz=(map swap:f [cash:f cash:f]))
::      for each swap type, list the amount owned by the given contract
::      (first value is total, second value is current)
::
::      ^---- this can maybe be in this thread
::
::  with these threads, the logic for this thread broadly becomes:
::  1. query all contract creation events on the given chain
::  2. for each contract, get the swap amounts
|^  ;<  saz=(unit (list event-log:rpc:ethereum))  bind:m  (read-chain %safe xos xoa)
    ?~  saz  (pure:m !>('failure: unable to read/find safe creation transactions'))
    ~&  >>  saz
    (pure:m !>((crip "success: safe count is {<(lent u.saz)>}")))
++  read-chain
  |=  [rid=@tas boq=bloq:f con=addr:f]
  =/  m  (strand ,(unit (list event-log:rpc:ethereum)))
  =/  pat=path  /fund/find-proz/[rid]
  =/  sat=path  [%watch pat]
  ;<    ~
      bind:m
    %+  poke:io  [our.bol %fund-watcher]
    :-  %fund-watcher-poke  !>
    :+  %watch  pat
    :*  url=rpc.xet
        eager=|  refresh-rate=~m1  timeout-time=~s30
        from=boq  to=~
        contracts=[con]~  confirms=~  topics=~
    ==
  ;<  ~  bind:m  (sleep:io ~s30)
  ;<  ~  bind:m  (watch-our:io sat %fund-watcher [%logs pat])
  ;<  caj=cage  bind:m  (take-fact:io sat)
  =+  !<(dif=diff:fund-watcher q.caj)
  ?.  ?=(?(%history %logs) -.dif)  (pure:m ~)
  =/  loz=(list event-log:rpc:ethereum)
    %+  skim  loglist.dif
    |=(log=event-log:rpc:ethereum ?=(^ mined.log))
  ?.  &(?=(^ loz) ?=(^ mined.i.loz))  (pure:m ~)
  (pure:m `loglist.dif)
--
