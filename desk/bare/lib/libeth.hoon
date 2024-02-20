|%
::  $bloq: blockchain block height
::
+$  bloq  @ud
::  +curr-bloq: the current blockchain block
::
++  curr-bloq
  ^-  @ud
  ?:  .^(? %j /=fake=)  20.000.000
  .^(@ud %gx /=eth-watcher=/block/azimuth/noun)
::  +time-bloq: the estimated number of blocks for a time frame
::
++  time-bloq
  |=  time=@dr
  ^-  @ud
  0
::  +bloq-time: the estimated time frame for a number of blocks
::
++  bloq-time
  |=  bloq=@ud
  ^-  @dr
  *@dr
--
