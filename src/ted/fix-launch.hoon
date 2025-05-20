::  /ted/fix-launch/hoon: fix a failed project launch where the blockchain
::  contract was initialized but the Urbit poke was lost
::
::    -fund!fix-launch %proj-name %ethereum '0xabcd…1234'
::
::  this thread takes a long time to run and can be a bit fickle; try
::  running it 3 times if it comes back with errors
::
/-  spider, chain-watcher, f=fund
/+  ethereum, io=strandio, fc=fund-chain
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ pon=@tas can=@ txs=@t] arg)
;<  bol=bowl:spider  bind:m  get-bowl:io
;<    pru=(unit proj:proj:f)
    bind:m
  (scry:io (unit proj:proj:f) %gx q.byk.bol /proj/(scot %p our.bol)/[pon]/noun)
=/  sig=sigm:f  sigm:(need contract:(need pru))
=/  txn=addr:f  (rash txs ;~(pfix (jest '0x') hex))
|^  ;<  saf=(unit (pair @ud @t))  bind:m  (find-xact ~)
    ?~  saf  (pure:m !>('failure: unable to read/find safe for given transaction'))
    =/  sad=(unit @ux)  (rust (scag 66 (trip q.u.saf)) ;~(pfix (jest '0x') hex))
    ?~  sad  (pure:m !>('failure: bad transaction data for given safe'))
    ;<  pyr=(unit (pair @ud @t))  bind:m  (find-xact `[`@ud`can u.sad p.u.saf])
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
++  find-xact
  |=  puc=(unit pact:f)
  =/  m  (strand ,(unit (pair @ud @t)))
  =/  arz
    :*  ~  can
        (bind puc |=(p=pact:f (crip `tape`['0' 'x' ((x-co:co 40) addr.p)])))
        (bind puc |=(p=pact:f `bloq:f`start.p))
        ~
    ==
  =/  tid=@ta  (cat 3 'fund_launch_' (scot %uv (sham %child eny.bol)))
  ;<  ~  bind:m  (watch-our:io /awaiting/[tid] %spider /thread-result/[tid])
  ;<  ~  bind:m
    %+  poke:io  [our.bol %spider]
    spider-start+!>([`tid.bol `tid byk.bol(r da+now.bol) %get-pact !>(arz)])
  ;<  caj=cage  bind:m  (take-fact:io /awaiting/[tid])
  ;<  ~  bind:m  (take-kick:io /awaiting/[tid])
  ?+  p.caj  ~|([%strange-thread-result p.caj %child tid] !!)
    %thread-fail  (pure:m ~)
  ::
      %thread-done
    =+  !<(res=* q.caj)
    =/  loz=loglist:chain-watcher
      %+  skim  ;;(loglist:chain-watcher res)
      |=  log=event-log:rpc:ethereum
      &(?=(^ mined.log) =(txn transaction-hash.u.mined.log))
    ?.  &(?=(^ loz) ?=(^ mined.i.loz))  (pure:m ~)
    (pure:m `[block-number.u.mined.i.loz data.i.loz])
  ==
--
