::  /ted/watch/hoon: watch a subscription wire on the %chain-watcher agent for
::  some (optionally) specified number of %fact updates
::
::    -fund!watch /fund/test `1
::
::    .^((list path) %gx /=spider=/tree/noun)
::    :spider &spider-stop [~.~.dojo... |]
::
/-  spider, chain-watcher
/+  io=strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ pat=path num=(unit @)] arg)
=/  sat=path  [%watch pat]
;<  ~  bind:m  (watch-our:io sat %chain-watcher [%logs pat])
;<    diz=(list diff:chain-watcher)
    bind:m
  =/  m  (strand ,(list diff:chain-watcher))
  =|  cur=(list diff:chain-watcher)
  |-  ^-  form:m
  =+  idx=(lent cur)
  ?:  &(?=(^ num) (gte idx u.num))  (pure:m (flop cur))
  ;<  caj=cage  bind:m  (take-fact:io sat)
  =+  !<(nex=diff:chain-watcher q.caj)
  ;<  tym=@da  bind:m  get-time:io
  ~&  >>  "-scan {<idx>} ({<tym>}): {(trip -.nex)}"
  $(cur [nex cur])
(pure:m !>(diz))
