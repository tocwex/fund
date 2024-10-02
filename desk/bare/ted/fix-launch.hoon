::  /ted/fix-launch.hoon: fix a failed project launch where the blockchain
::  contract was initialized but the Urbit poke was lost
::
::    -fund!fix-launch %proj-name %ethereum '0xabcd…1234'
::
::  this thread takes a while to run (~25 seconds) and can be a bit
::  fickle; try running it a couple of times if it comes back with
::  "unable to read/find" errors
::
/-  spider, fund-watcher, f=fund
/+  ethereum, io=strandio, fc=fund-chain
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ pon=@tas can=@tas txs=@t] arg)
=/  txn=@ux   (rash txs ;~(pfix (jest '0x') hex))
;<  bol=bowl:spider  bind:m  get-bowl:io
;<    pru=(unit proj:proj:f)
    bind:m
  (scry:io (unit proj:proj:f) %gx q.byk.bol /proj/(scot %p our.bol)/[pon]/noun)
=/  sig=sigm:f  sigm:(need contract:(need pru))
=/  xet=xeta:f  (~(got by xmap:fc) can)
=/  [xos=@ud xoa=@ux]
  ?+  id.xet     !!
    %1           [19.763.774 0xce13.ec86.bd8b.8827.9ec6.3eb9.f1ae.d967.59ce.5063]
    %11.155.111  [5.793.125 0xafd2.dcb1.e947.01e5.b96d.88d1.6586.8590.4578.c2f7]
  ==
|^  ;<  saf=(unit (pair @ud @t))  bind:m  (read-chain %safe xos xoa)
    ?~  saf  (pure:m !>('failure: unable to read/find safe for given transaction'))
    =/  sad=(unit @ux)  (rust (scag 66 (trip q.u.saf)) ;~(pfix (jest '0x') hex))
    ?~  sad  (pure:m !>('failure: bad transaction data for given safe'))
    ;<  pyr=(unit (pair @ud @t))  bind:m  (read-chain %peer p.u.saf u.sad)
    ?~  pyr  (pure:m !>('failure: unable to read/find safe metadata'))
    =/  pyd=(pole @ux)
      =/  dat=tape  (trip q.u.pyr)
      %+  murn  `(list @)`~[2 3]
      |=(i=@ (rust (scag 64 (slag (sub (lent dat) (mul 64 i)) dat)) hex))
    ::  FIXME: I'm ~60% sure this will always be the ordering based on
    ::  how the FE calls the contract construtor; if this is wrong, %fund
    ::  will reject the poke anyway because `!=(from.sig ora.pyd)`
    ?.  ?=([ora=@ux wok=@ux ~] pyd)
      (pure:m !>('failure: bad transaction data for given safe'))
    ;<    ~
        bind:m
      %+  poke:io  [our.bol %fund]
      fund-poke+!>([%proj [our.bol pon] %bump %lock `[[p.u.saf txn] sig wok.pyd ora.pyd u.sad]])
    (pure:m !>('success'))
++  read-chain
  |=  [rid=@tas boq=@ud con=@ux]
  =/  m  (strand ,(unit (pair @ud @t)))
  =/  pat=path  /fund/fix-launch/[rid]/[pon]
  =/  sat=path  [%watch pat]
  ;<    ~
      bind:m
    %+  poke:io  [our.bol %fund-watcher]
    :-  %fund-watcher-poke  !>
    :+  %watch  pat
    :*  url=rpc.xet
        eager=|  refresh-rate=~m1  timeout-time=~s10
        from=boq  to=~
        contracts=[con]~  confirms=~  topics=~
    ==
  ;<  ~  bind:m  (sleep:io ~s10)
  ;<  ~  bind:m  (watch-our:io sat %fund-watcher [%logs pat])
  ;<  caj=cage  bind:m  (take-fact:io sat)
  =+  !<(dif=diff:fund-watcher q.caj)
  ?.  ?=(?(%history %logs) -.dif)  (pure:m ~)
  =/  loz=(list event-log:rpc:ethereum)
    %+  skim  loglist.dif
    |=  log=event-log:rpc:ethereum
    &(?=(^ mined.log) =(txn transaction-hash.u.mined.log))
  ?.  &(?=(^ loz) ?=(^ mined.i.loz))  (pure:m ~)
  (pure:m `[block-number.u.mined.i.loz data.i.loz])
--
