::  /ted/get-proz/hoon: query the on-chain statistics for all %fund
::  projects (optionally within a given block window)
::
::    -fund!get-proz %ethereum ~ ~
::    -fund!get-proz %sepolia `6.000.000 `6.100.000
::    -fund!get-proz %ethereum `20.425.500 `20.500.000
::
/-  spider, chain-watcher, f=fund
/+  ethereum, config, io=strandio, fc=fund-chain, ff=fund-form
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ can=@ sub=(unit bloq:f) tub=(unit bloq:f)] arg)
;<  bol=bowl:spider  bind:m  get-bowl:io
=/  xet=xeta:f  (~(got by xmap:fc) can)
::  FIXME: This is a really ugly hack to account for the different
::  Alchemy endpoint versions
=/  key=tape  (trip !<(@t (slot:config %alch-akey)))
=/  net=tape  ?+(can "mainnet" %ethereum "mainnet", %sepolia "sepolia")
=/  rp2=tape  "https://eth-{net}.g.alchemy.com/v2/{key}"
=/  rp3=tape  "https://eth-{net}.g.alchemy.com/nft/v3/{key}"
=/  tid=@ta  (cat 3 'fund_proz_' (scot %uv (sham %child eny.bol)))
;<  ~  bind:m  (watch-our:io /awaiting/[tid] %spider /thread-result/[tid])
;<  ~  bind:m
  %+  poke:io  [our.bol %spider]
  spider-start+!>([`tid.bol `tid byk.bol(r da+now.bol) %get-pact !>([~ can ~ sub tub])])
;<  caj=cage  bind:m  (take-fact:io /awaiting/[tid])
;<  ~  bind:m  (take-kick:io /awaiting/[tid])
=/  loz=loglist:chain-watcher
  ?+  p.caj  ~|([%strange-thread-result p.caj %child tid] !!)
    %thread-fail  ~|([%failed-thread-result p.caj %child tid] !!)
    %thread-done  =+(!<(res=* q.caj) ;;(loglist:chain-watcher res))
  ==
=/  paz=(list pact:f)
  %+  murn  loz
  |=  log=event-log:rpc:ethereum
  ^-  (unit pact:f)
  =/  boq=(unit bloq:f)  ?.(?=(^ mined.log) ~ `block-number.u.mined.log)
  =/  adr=(unit addr:f)  (rust (scag 66 (trip data.log)) ;~(pfix (jest '0x') hex))
  :(both `id.xet adr boq)
~&  "fetching {<(lent paz)>} projects"
|^  =|  poz=(list [pac=pact:f swa=swap:f cur=cash:f tot=cash:f])
    |-  ^-  form:m
    ?~  paz  (pure:m !>((flop poz)))
    =*  pac  i.paz
    =/  adr=@t  (crip (addr:enjs:ff addr.pac))
    ~&  >  "fetching project {<addr.pac>}"
    ;<  njs=(unit json)  bind:m  (quri-enft-curr adr)
    ~?  ?=(~ njs)  "unable to fetch nft information"
    ?^  nur=(dejs-enft-curr (fall njs *json))
      ;<  njs=(unit json)  bind:m  (quri-swap-totl adr %enft)
      =/  not  (fall (dejs-enft-totl (fall njs *json)) [-.u.nur 0])
      $(paz t.paz, poz [[pac -.u.nur +.u.nur +.not] poz])
    ;<  cjs=(unit json)  bind:m  (quri-coin-curr adr)
    ~?  ?=(~ cjs)  "unable to fetch coin information"
    ?^  cur=(dejs-coin-curr (fall cjs *json))
      ;<  cjs=(unit json)  bind:m  (quri-swap-totl adr %coin)
      =/  cot  (fall (dejs-coin-totl (fall cjs *json)) [-.u.cur 0])
      $(paz t.paz, poz [[pac -.u.cur +.u.cur +.cot] poz])
    ~&  >>  "skipping; no funds found"
    $(paz t.paz)
++  nu  |=(j=json `(unit @ux)`?.(?=([%s *] j) ~ (rush p.j ;~(pfix (jest '0x') hex))))
++  ku  (ci:dejs-soft:format |=(=@ux ``@`ux) nu)
++  quri-json
  |=  req=request:http
  =/  m  (strand ,(unit json))
  ;<  ~  bind:m  (send-request:io req)
  ;<  res=client-response:iris  bind:m  take-client-response:io
  =-  (pure:m (de:json:html -))
  ?>(?=(%finished -.res) ?~(full-file.res '' q.data.u.full-file.res))
++  quri-enft-curr
  |=  adr=@t
  =/  m  (strand ,(unit json))
  ;<    njs=(unit json)
      bind:m
    %-  quri-json
    =-  [%'GET' (crip "{rp3}/getCollectionsForOwner{-}") ~ ~]
    %-  tail:en-purl:html
    :~  ['owner' adr]
        ['withMetadata' 'false']
    ==
  (pure:m njs)
++  quri-coin-curr
  |=  adr=@t
  =/  m  (strand ,(unit json))
  ;<    cjs=(unit json)
      bind:m
    %-  quri-json
    =-  [%'POST' (crip rp2) ['Content-Type' 'application/json']~ `-]
    %-  as-octs:mimes:html
    %-  en:json:html  ^-  json
    :-  %o
    %-  malt  ^-  (list [@t json])
    :~  ['id' s+'1']
        ['jsonrpc' s+'2.0']
        ['method' s+'alchemy_getTokenBalances']
        ['params' a+~[s+adr s+'erc20']]
    ==
  (pure:m cjs)
++  quri-swap-totl
  |=  [adr=@t typ=?(%coin %enft)]
  =/  m  (strand ,(unit json))
  ;<    tjs=(unit json)
      bind:m
    %-  quri-json
    :*  %'POST'  (crip rp2)
        ~[['accept' 'application/json'] ['Content-Type' 'application/json']]
        ~   %-  as-octs:mimes:html
        %-  en:json:html  ^-  json
        :-  %o
        %-  malt  ^-  (list [@t json])
        :~  ['id' s+'1']
            ['jsonrpc' s+'2.0']
            ['method' s+'alchemy_getAssetTransfers']
        ::
              :-  'params'
            :-  %a
            :_  ~
            :-  %o
            %-  malt  ^-  (list [@t json])
            :~  ['toAddress' s+adr]
                ['category' a+[s+?-(typ %coin 'erc20', %enft 'erc721')]~]
                ['withMetadata' b+&]
                ['excludeZeroValue' b+&]
            ==
        ==
    ==
  (pure:m tjs)
++  dejs-swap-curr
  |=  saz=(unit (list [addr:f cash:f]))
  ^-  (unit [swap:f cash:f])
  =-  ?~(- ~ `i.-)
  %+  murn  (fall saz *(list [addr:f cash:f]))
  |=([a=addr:f c=cash:f] ?~(s=(~(get by smap:fc) can a) ~ `[u.s c]))
++  dejs-enft-curr
  |=  jon=json
  ^-  (unit [swap:f cash:f])
  %-  dejs-swap-curr
  =,  dejs-soft:format
  %.  jon
  (ot [collections+(ar (ot ~[address+nu [%'totalBalance' ni]]))]~)
++  dejs-coin-curr
  |=  jon=json
  ^-  (unit [swap:f cash:f])
  %-  dejs-swap-curr
  =,  dejs-soft:format
  %.  jon
  %-  ot  :_  ~  :-  %result
  %-  ot  :_  ~  :-  %'tokenBalances'
  (ar (ot ~[[%'contractAddress' nu] [%'tokenBalance' ku]]))
++  dejs-swap-totl
  |=  saz=(unit (list [addr:f cash:f]))
  ^-  (unit [swap:f cash:f])
  =-  ?~(- ~ `[-.i.- (roll (turn - tail) add)])
  %+  murn  (fall saz *(list [addr:f cash:f]))
  |=([a=addr:f c=cash:f] ?~(s=(~(get by smap:fc) can a) ~ `[u.s c]))
++  dejs-enft-totl
  |=  jon=json
  ^-  (unit [swap:f cash:f])
  %-  dejs-swap-totl
  =,  dejs-soft:format
  %.  jon
  %-  ot  :_  ~  :-  %result
  %-  ot  :_  ~  :-  %transfers
  (ar (ot [%'rawContract' (ot ~[address+nu value+_`1])]~))
++  dejs-coin-totl
  |=  jon=json
  ^-  (unit [swap:f cash:f])
  %-  dejs-swap-totl
  =,  dejs-soft:format
  %.  jon
  %-  ot  :_  ~  :-  %result
  %-  ot  :_  ~  :-  %transfers
  (ar (ot [%'rawContract' (ot ~[address+nu value+ku])]~))
--
