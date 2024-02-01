/+  default-agent, rudder
/+  dbug, tonic
/~  pages  (page:rudder ~ ~)  /app/fund
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      ~
  ==
+$  versioned-state
  $%  state-0
  ==
--
^-  agent:gall
=|  state-0
=*  state  -
%-  agent:dbug
%-  agent:tonic
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  :~
    :*  %pass  /eyre/connect  %arvo  %e
        %connect  `/apps/[dap.bowl]  dap.bowl
    ==
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %handle-http-request
    =-  [-< this(state [%0 ->])]
    %.  [bowl !<(order:rudder vase) ~]
    %:  (steer:rudder _~ _~)
      pages
      (point:rudder /apps/[dap.bowl] | ~(key by pages))
      (fours:rudder ~)
      _~
    ==
  ==
++  on-peek  on-peek:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%http-response *]
    `this
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--
