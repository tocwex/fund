/+  default-agent, rudder
/+  dbug, tonic  ::  debug-only
/~  base    (page:rudder ~ ~)  /app/fund
/~  assets  (page:rudder ~ ~)  /app/fund/assets
|%
+$  state-0
  $:  %0
      ~
  ==
+$  versioned-state
  $%  state-0
  ==
+$  card  card:agent:gall
++  pages  ::  map of pages keyed by full web path
  ~+
  %-  ~(uni by base)
  =<  +
  %+  ~(rib by assets)  0
  |=  [[k=knot v=(page:rudder ~ ~)] a=@]
  [0 (crip (welp "assets/" (trip k))) v]
++  point  ::  web addressing considering full web path
  =,  rudder
  |=  [base=(lest @t) have=(set term)]
  ^-  route
  |=  trail
  ^-  (unit place)
  ?~  site=(decap base site)  ~
  ?-  spat=(roll u.site |=([n=@t a=@t] ?:(=(a '') n (crip :(welp (trip a) "/" (trip n))))))
    %$          `[%page | %index]
    @           ?:((~(has in have) spat) `[%page | spat] ~)
  ==
--
^-  agent:gall
=|  state-0
=*  state  -
%-  agent:dbug  ::  debug-only
%-  agent:tonic  ::  debug-only
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
    =-  [-< this(+.state ->)]
    %.  [bowl !<(order:rudder vase) ~]
    %:  (steer:rudder _~ _~)
      pages
      (point /apps/[dap.bowl] ~(key by pages))
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
