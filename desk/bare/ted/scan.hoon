::  /ted/scan.hoon: watch a subscription wire on the %scanner agent for
::  some (optionally) specified number of %fact updates
::
::    -fund!scan /fund/test `1
::
::    .^((list path) %gx /=spider=/tree/noun)
::    :spider &spider-stop [~.~.dojo... |]
::
/-  spider, scanner
/+  io=strandio, fx=fund-xtra
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ pat=path num=(unit @)] arg)
=/  sat=path  [%watch pat]
;<  ~  bind:m  (watch-our:io sat %scanner [%logs pat])
;<    diz=(list diff:scanner)
    bind:m
  =/  m  (strand ,(list diff:scanner))
  =|  cur=(list diff:scanner)
  |-  ^-  form:m
  =+  idx=(lent cur)
  ?:  &(?=(^ num) (gte idx u.num))  (pure:m (flop cur))
  ;<  caj=cage  bind:m  (take-fact:io sat)
  =+  !<(nex=diff:scanner q.caj)
  ;<  tym=@da  bind:m  get-time:io
  ~&  >>  "-watch {<idx>} ({<tym>}): {(trip -.nex)}"
  $(cur [nex cur])
(pure:m !>(diz))
