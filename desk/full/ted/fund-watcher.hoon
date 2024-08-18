/-  spider, *fund-watcher
/+  strandio, ethio
=,  ethereum-types
=,  jael
::
::  Main loop: get updates since last checked
::
|=  args=vase
|^
=+  !<([~ pup=watchpup] args)
=/  m  (strand:strandio ,vase)
^-  form:m
;<  =latest=block  bind:m  (get-latest-block:ethio url.pup)
=+  last=number.id.latest-block
;<  pup=watchpup   bind:m  (zoom pup last (min last (fall to.pup last)))
=|  vows=disavows
?.  eager.pup
  (pure:m !>([vows pup]))
|-  ^-  form:m
=*  loop  $
?:  (gth number.pup number.id.latest-block)
 (pure:m !>([vows pup]))
;<  =block  bind:m                (get-block-by-number:ethio url.pup number.pup)
;<  [=new=disavows pup=watchpup]  bind:m  (take-block pup block)
%=  loop
 pup   pup
 vows  (weld vows new-disavows)
==
::
::  Process a block, detecting and handling reorgs
::
++  take-block
  |=  [pup=watchpup =block]
  =/  m  (strand:strandio ,[disavows watchpup])
  ^-  form:m
  ::  if this next block isn't direct descendant of our logs, reorg happened
  ?:  &(?=(^ blocks.pup) !=(parent-hash.block hash.id.i.blocks.pup))
    (rewind pup block)
  =/  contracts  contracts.pup
  ;<  =new=loglist  bind:m  ::  oldest first
    (get-logs-by-hash:ethio url.pup hash.id.block contracts topics.pup)
  %-  pure:m
  :-  ~
  %_  pup
    number        +(number.id.block)
    pending-logs  (~(put by pending-logs.pup) number.id.block new-loglist)
    blocks        [block blocks.pup]
  ==
::
::  Reorg detected, so rewind until we're back in sync
::
++  rewind
  ::  block: wants to be head of blocks.pup, but might not match
  |=  [pup=watchpup =block]
  =/  m  (strand:strandio ,[disavows watchpup])
  =*  blocks  blocks.pup
  =|  vows=disavows
  |-  ^-  form:m
  =*  loop  $
  ::  if we have no further history to rewind, we're done
  ?~  blocks
    (pure:m (flop vows) pup(blocks [block blocks]))
  ::  if target block is directly after "latest", we're done
  ?:  =(parent-hash.block hash.id.i.blocks)
    (pure:m (flop vows) pup(blocks [block blocks]))
  ::  next-block: the new target block
  ;<  =next=^block  bind:m
    (get-block-by-number:ethio url.pup number.id.i.blocks)
  =.  pending-logs.pup  (~(del by pending-logs.pup) number.id.i.blocks)
  =.  vows  [id.block vows]
  loop(block next-block, blocks t.blocks)
::
::  Zoom forward to near a given block number.
::
::    Zooming doesn't go forward one block at a time.  As a
::    consequence, it cannot detect and handle reorgs.  Only use it
::    at a safe distance -- 100 blocks ago is probably sufficient.
::
++  zoom
  |=  [pup=watchpup =latest=number:block up-to=number:block]
  =/  m  (strand:strandio ,watchpup)
  ^-  form:m
  =/  zoom-margin=number:block   (fall confirms.pup 15)
  =/  zoom-step=number:block    100.000
  ?:  (lth latest-number (add number.pup zoom-margin))
     ::  ~&  >>  "[{<`@ux`(swp 3 (end [3 4] (swp 3 -.contracts.pup)))>}] waiting - latest: {<latest-number>} number: {<number.pup>}  up-to: {<up-to>}"
    (pure:m pup)
   ::  ~&  >>  "[{<`@ux`(swp 3 (end [3 4] (swp 3 -.contracts.pup)))>}] ready - latest: {<latest-number>} number: {<number.pup>}  up-to: {<up-to>}"
  =/  up-to-number=number:block
    ;:  min
      (add 10.000.000 number.pup)
      (sub latest-number zoom-margin)
      up-to
    ==
  |-
  =*  loop  $
  ?:  (gth number.pup up-to-number)
    (pure:m pup(blocks ~))
  =/  to-number=number:block
      (min up-to-number (add number.pup zoom-step))
  ;<  =loglist  bind:m  ::  oldest first
    %:  get-logs-by-range:ethio
      url.pup
      contracts.pup
      topics.pup
      number.pup
      to-number
    ==
  ::  ~&  >>>  loglist+loglist
  =?  pending-logs.pup  ?=(^ loglist)
    (~(put by pending-logs.pup) to-number loglist)
  loop(number.pup +(to-number))
::  Fetch inputs for a list of logs
::
++  fetch-inputs
  |=  [pup=watchpup logs=(list event-log:rpc:ethereum)]
  =/  m  (strand:strandio ,(list event-log:rpc:ethereum))
  =|  res=(list event-log:rpc:ethereum)
  |-  ^-  form:m
  =*  loop  $
  ?~  logs
    (pure:m (flop res))
  ;<  log=event-log:rpc:ethereum  bind:m  (fetch-input pup i.logs)
  =.  res  [log res]
  loop(logs t.logs)
::  Fetch input for a log
::
++  fetch-input
  |=  [pup=watchpup log=event-log:rpc:ethereum]
  =/  m  (strand:strandio ,event-log:rpc:ethereum)
  ^-  form:m
  ?~  mined.log
    (pure:m log)
  ?^  input.u.mined.log
    (pure:m log)
  ;<  res=transaction-result:rpc:ethereum  bind:m
    (get-tx-by-hash:ethio url.pup transaction-hash.u.mined.log)
  (pure:m log(input.u.mined `(data-to-hex input.res)))
::
++  data-to-hex
  |=  data=@t
  ?~  data  *@ux
  ?:  =(data '0x')  *@ux
  (hex-to-num:ethereum data)
--
