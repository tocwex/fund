/-  f=fund
/+  default-agent, rudder
/+  dbug, tonic  ::  debug-only
/~  base    (page:rudder dat-now:f act-now:f)  /app/fund
/~  assets  (page:rudder dat-now:f act-now:f)  /app/fund/assets
|%
+$  card  card:agent:gall
+$  state-now  [%0 sat-now:f]
++  pages  ::  map of pages keyed by full web path
  ~+
  %-  ~(uni by base)
  =<  +
  %+  ~(rib by assets)  0
  |=  [[k=knot v=(page:rudder dat-now:f act-now:f)] a=@]
  [0 (crip (welp "assets/" (trip k))) v]
++  point  ::  web addressing considering full web path
  =,  rudder
  |=  [base=(lest @t) have=(set term)]
  ^-  route
  |=  trail
  ^-  (unit place)
  ?~  site=(decap base site)  ~
  ?-  spat=(roll u.site |=([n=@t a=@t] ?:(=(a '') n (crip :(welp (trip a) "/" (trip n))))))
    %$  `[%page | %index]
    @   ?:((~(has in have) spat) `[%page | spat] ~)
  ==
++  datify  ::  sat-now:f => dat-now:f
  |=  sat=state-now
  ^-  dat-now:f
  =|  dat=dat-now:f
  %_    dat
      roles
    rols.sat
  ::
      projects
    %-  ~(rut by ours.sat)
    |=  [k=flag:f v=project:f]
    ^-  peer-project:f
    [v k | |]
  ==
++  satify  ::  dat-now:f => sat-now:f
  |=  dat=dat-now:f
  ^-  state-now
  =|  sat=state-now
  %_    sat
      rols
    roles.dat
  ::
      ours
    =<  -
    %+  ~(rib by projects.dat)  *(map flag:f project:f)
    |=  [[k=flag:f v=peer-project:f] a=(map flag:f project:f)]
    ^-  [(map flag:f project:f) flag:f peer-project:f]
    :_  [k v]
    ?.  =(1 1)  a  ::  =(our p.k)
    (~(put by a) k project.v)
  ==
--
^-  agent:gall
=|  state-now
=*  state  -
%-  agent:dbug  ::  debug-only
%-  agent:tonic  ::  debug-only
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  :~  :*  %pass  /eyre/connect  %arvo  %e
          %connect  `/apps/[dap.bowl]  dap.bowl
  ==  ==
::
++  on-save  !>([state epic-now:f])
::
++  on-load
  |=  =vase
  ^-  (quip card _this)
  |^  =+  !<([sat=state-any pic=epic:f] vase)
      ?-  -.sat
        %0  `this(state sat)
      ==
  +$  state-any  $%(state-now)
  ::  +$  state-0  ...
  --
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %handle-http-request
    =-  :-  -.render
        this(state (satify +.render))
    ^=  render
    %.  [bowl !<(order:rudder vase) (datify state)]
    %:  (steer:rudder dat-now:f act-now:f)
      pages
      (point /apps/[dap.bowl] ~(key by pages))
      (fours:rudder *dat-now:f)
      |=(act=act-now:f ~)
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
