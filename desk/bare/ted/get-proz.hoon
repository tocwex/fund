::  /ted/get-proz/hoon: query the on-chain statistics for all %fund
::  projects (optionally within a given block window)
::
::    -fund!get-proz %ethereum ~ ~
::    -fund!get-proz %sepolia `6.000.000 `6.001.000
::
/-  spider, fund-watcher, f=fund
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
=/  rp2=tape  (trip rpc.xet)
=/  rp3=tape
  =/  vid=@  (need (find "v2" rp2))
  :(welp (scag vid rp2) "nft/v3" (slag (add vid (lent "v2")) rp2))
=/  tid=@ta  (cat 3 'fund_proz_' (scot %uv (sham %child eny.bol)))
;<  ~  bind:m  (watch-our:io /awaiting/[tid] %spider /thread-result/[tid])
;<  ~  bind:m
  %+  poke:io  [our.bol %spider]
  spider-start+!>([`tid.bol `tid byk.bol(r da+now.bol) %get-pact !>([~ can ~ sub tub])])
;<  caj=cage  bind:m  (take-fact:io /awaiting/[tid])
;<  ~  bind:m  (take-kick:io /awaiting/[tid])
=/  loz=loglist:fund-watcher
  ?+  p.caj  ~|([%strange-thread-result p.caj %child tid] !!)
    %thread-fail  (strand-fail:strand %get-pact-error ~)
    %thread-done  =+(!<(res=* q.caj) ;;(loglist:fund-watcher res))
  ==
=/  paz=(list pact:f)
  %+  murn  loz
  |=  log=event-log:rpc:ethereum
  ^-  (unit pact:f)
  =/  boq=(unit bloq:f)  ?.(?=(^ mined.log) ~ `block-number.u.mined.log)
  =/  adr=(unit addr:f)  (rust (scag 66 (trip data.log)) ;~(pfix (jest '0x') hex))
  :(both `id.xet adr boq)
=/  qyz=(list [pact:f request:http])
  %+  roll  paz
  |=  [nex=pact:f acc=(list [pact:f request:http])]
  %+  welp  acc
  :~    =-  [nex %'GET' (crip "{rp3}/getCollectionsForOwner{arz}") ~ ~]
      ^-  arz=tape
      %-  tail:en-purl:html
      :~  ['owner' (crip (addr:enjs:ff addr.nex))]
          ['withMetadata' 'false']
      ==
  ::
        =-  [nex %'POST' (crip rp2) hez `bod]
      ^-  [hez=header-list:http bod=octs]
      :-  ['Content-Type' 'application/json']~
      %-  as-octs:mimes:html
      %-  en:json:html  ^-  json
      :-  %o
      %-  malt  ^-  (list [@t json])
      :~  ['id' s+'1']
          ['jsonrpc' s+'2.0']
          ['method' s+'alchemy_getTokenBalances']
          ['params' a+~[s+(crip (addr:enjs:ff addr.nex)) s+'erc20']]
      ==
  ==
;<    joz=(list [pact:f json])
    bind:m
  =/  m  (strand ,(list [pact:f json]))
  =|  cur=(list [pact:f json])
  |-  ^-  form:m
  ?~  qyz  (pure:m (flop cur))
  ;<  ~  bind:m  (send-raw-card:io %pass /request %arvo %i %request +.i.qyz *outbound-config:iris)
  ;<  res=client-response:iris  bind:m  take-client-response:io
  =/  bod=@t  ?>(?=(%finished -.res) ?~(full-file.res '' q.data.u.full-file.res))
  =/  jon=(unit json)  (de:json:html bod)
  ::  TODO: If any of the given endpoints has invalid JSON, throw error
  ::  for the whole thread; should this be more forgiving?
  ?~  jon  (strand-fail:strand %json-parse-error ~)
  ::  NOTE: Need to wait a second so as not to exceed API compute per second
  ;<  ~  bind:m  (sleep:io ~s1)
  $(qyz t.qyz, cur [[-.i.qyz u.jon] cur])
=/  poz=(list [pac=pact:f swa=swap:f amo=cash:f])
  %+  murn  joz
  |=  [pac=pact:f jon=json]
  ^-  (unit [pact:f swap:f cash:f])
  =-  ?~(res ~ `[pac i.res])
  ^-  res=(list [swap:f cash:f])
  %-  murn  :_  |=([a=addr:f c=cash:f] ?~(s=(~(get by smap:fc) can a) ~ `[u.s c]))
  %-  fall  :_  *(list [addr:f cash:f])
  =,  dejs-soft:format
  =+  nu=|=(j=json `(unit @ux)`?.(?=([%s *] j) ~ (rush p.j ;~(pfix (jest '0x') hex))))
  =-  (clap nft con tail)
  ^-  [nft=(unit (list [addr:f cash:f])) con=(unit (list [addr:f cash:f]))]
  :-  %.(jon (ot [collections+(ar (ot ~[address+nu [%'totalBalance' ni]]))]~))
  %.  jon
  %-  ot  :_  ~  :-  %result
  %-  ot  :_  ~  :-  %'tokenBalances'
  (ar (ot ~[[%'contractAddress' nu] [%'tokenBalance' (ci |=(=@ux ``@`ux) nu)]]))
(pure:m !>(poz))
