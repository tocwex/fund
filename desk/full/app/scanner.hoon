::  scanner: ethereum event log collector
::
::  based on eth-watcher
::
/-  *scanner, spider
/+  ethereum, default-agent, verb, dbug
=,  ethereum-types
=,  jael
::
=>  |%
    +$  card  card:agent:gall
    +$  app-state
      $:  %0
          dogs=(map path watchdog)
      ==
    ::
    +$  context  [=path dog=watchdog]
    +$  watchdog
      $:  config
          running=(unit [since=@da =tid:spider])
          =number:block
          =pending-logs
          =history
          blocks=(list block)
      ==
    ::
    ::  history: newest block first, oldest event first
    +$  history  (list loglist)
    --
::
::  Helpers
::
=>  |%
    ++  wait
      |=  [=path now=@da time=@dr]
      ^-  card
      [%pass [%timer path] %arvo %b %wait (add now time)]
    ::
    ++  wait-shortcut
      |=  [=path now=@da]
      ^-  card
      [%pass [%timer path] %arvo %b %wait now]
    ::
    ++  poke-spider
      |=  [=path our=@p =cage]
      ^-  card
      [%pass [%running path] %agent [our %spider] %poke cage]
    ::
    ++  watch-spider
      |=  [=path our=@p =sub=path]
      ^-  card
      [%pass [%running path] %agent [our %spider] %watch sub-path]
    ::
    ++  leave-spider
      |=  [=path our=@p]
      ^-  card
      [%pass [%running path] %agent [our %spider] %leave ~]
    --
::
::  Main
::
%-  agent:dbug
^-  agent:gall
=|  state=app-state
%+  verb  |
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    bec   byk.bowl(r da+now.bowl)
::
++  on-init
  ^-  (quip card _this)
  [~ this]
::
++  on-save   !>(state)
++  on-load   |=(old=vase `this(state !<(_state old)))
++  on-poke
  |=  [=mark =vase]
  ?:  ?=(%noun mark)
    ~&  state
    `this
  ?.  ?=(%scanner-poke mark)
    (on-poke:def mark vase)
  ::
  =+  !<(=poke vase)
  ?-  -.poke
      %watch
    ::  fully restart the watchdog if it doesn't exist yet,
    ::  or if result-altering parts of the config changed.
    =/  restart=?
      ?|  !(~(has by dogs.state) path.poke)
          ?!  .=  ->+>+:(~(got by dogs.state) path.poke)
                   +>+>.config.poke
      ==
    ::
    =/  already  (~(has by dogs.state) path.poke)
    ~?  &(already restart)
      [dap.bowl 'overwriting existing watchdog on' path.poke]
    =/  wait-cards=(list card)
      ?:  already  ~
      [(wait-shortcut path.poke now.bowl) ~]
    ::
    =/  restart-cards=(list card)
      =/  dog  (~(get by dogs.state) path.poke)
      ?.  ?&  restart
              ?=(^ dog)
              ?=(^ running.u.dog)
          ==
        ~
      =/  =cage  [%spider-stop !>([tid.u.running.u.dog &])]
      :_  ~
      `card`[%pass [%starting path.poke] %agent [our.bowl %spider] %poke cage]
    =/  new-dog
      =/  dog=watchdog
        ?:  restart  *watchdog
        (~(got by dogs.state) path.poke)
      =+  pending=(sort ~(tap in ~(key by pending-logs.dog)) lth)
      =?  pending-logs.dog
          ?:  restart  |
          ?~  pending  |
          (gte i.pending from.config.poke)
        ?>  ?=(^ pending)
        ::  if there are pending logs newer than what we poke with,
        ::  we need to clear those too avoid processing duplicates
        ::
        ~&  %dropping-unreleased-logs^[from+i.pending n+(lent pending)]
        ~
      %_  dog
        -       config.poke
        number  from.config.poke
      ==
    =.  dogs.state  (~(put by dogs.state) path.poke new-dog)
    [(weld wait-cards restart-cards) this]
  ::
      %clear
    ?:  (~(has by dogs.state) path.poke)
      =.  dogs.state  (~(del by dogs.state) path.poke)
      [~ this]
    =-  =.  dogs.state  -  [~ this]
    %-  ~(rep by dogs.state)
    |=  [[=path dog=watchdog] dogs=_dogs.state]
    ^+  dogs.state
    ?.  =(-.path -.path.poke)  dogs
    ~&  >>  "deleting dog for {<path>}"
    (~(del by dogs) path)
  ==
::
::  +on-watch: subscribe & get initial subscription data
::
::    /logs/some-path:
::
++  on-watch
  |=  =path
  ^-  (quip card agent:gall)
  ?.  ?=([%logs ^] path)
    ~|  [%invalid-subscription-path path]
    !!
  :_  this  :_  ~
  :*  %give  %fact  ~  %scanner-diff  !>
      :-  %history
      ^-  loglist
      %-  zing
      %-  flop
      =<  history
      (~(gut by dogs.state) t.path *watchdog)
  ==
::
++  on-leave  on-leave:def
::
::  +on-peek: get diagnostics data
::
::    /block/some-path: get next block number to check for /some-path
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  ~
      [%x %block ^]
    ?.  (~(has by dogs.state) t.t.path)  ~
    :+  ~  ~
    :-  %atom
    !>(number:(~(got by dogs.state) t.t.path))
  ::
      [%x %dogs ~]
    ``noun+!>(~(key by dogs.state))
  ::
      [%x %dogs %configs ~]
    ``noun+!>((~(run by dogs.state) |=(=watchdog -.watchdog)))
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  |^
  ^-  (quip card agent:gall)
  ?.  ?=([%running *] wire)
    (on-agent:def wire sign)
  ?-    -.sign
      %poke-ack
    ?~  p.sign
      [~ this]
    %-  (slog leaf+"scanner couldn't start thread" u.p.sign)
    :_  (clear-running t.wire)  :_  ~
    (leave-spider t.wire our.bowl)
  ::
      %watch-ack
    ?~  p.sign
      [~ this]
    %-  (slog leaf+"scanner couldn't start listening to thread" u.p.sign)
    ::  TODO: kill thread that may have started, although it may not
    ::  have started yet since we get this response before the
    ::  %start-spider poke is processed
    ::
    [~ (clear-running t.wire)]
  ::
      %kick  [~ (clear-running t.wire)]
      %fact
    =*  path  t.wire
    =/  dog  (~(get by dogs.state) path)
    ?~  dog
      [~ this]
    ?+    p.cage.sign  (on-agent:def wire sign)
        %thread-fail
      =+  !<([=term =tang] q.cage.sign)
      %-  (slog leaf+"scanner failed; will retry" leaf+<term> tang)
      [~ this(dogs.state (~(put by dogs.state) path u.dog(running ~)))]
    ::
        %thread-done
      ::  if empty, that means we cancelled this thread
      ::
      ?:  =(*vase q.cage.sign)
        `this
      =+  !<([vows=disavows pup=watchpup] q.cage.sign)
      =.  u.dog
        %_  u.dog
          -             -.pup
          number        number.pup
          blocks        blocks.pup
          pending-logs  pending-logs.pup
        ==
      =^  cards-1  u.dog  (disavow path u.dog vows)
      =^  cards-2  u.dog  (release-logs path u.dog)
      =.  dogs.state  (~(put by dogs.state) path u.dog(running ~))
      [(weld cards-1 cards-2) this]
    ==
  ==
  ::
  ++  clear-running
    |=  =path
    =/  dog  (~(get by dogs.state) path)
    ?~  dog
      this
    this(dogs.state (~(put by dogs.state) path u.dog(running ~)))
  ::
  ++  disavow
    |=  [=path dog=watchdog vows=disavows]
    ^-  (quip card watchdog)
    =/  history-ids=(list [id:block loglist])
      %+  murn  history.dog
      |=  logs=loglist
      ^-  (unit [id:block loglist])
      ?~  logs
         ~
      `[[block-hash block-number]:(need mined.i.logs) logs]
    =/  actual-vows=disavows
      %+  skim  vows
      |=  =id:block
      (lien history-ids |=([=history=id:block *] =(id history-id)))
    =/  actual-history=history
      %+  murn  history-ids
      |=  [=id:block logs=loglist]
      ^-  (unit loglist)
      ?:  (lien actual-vows |=(=vow=id:block =(id vow-id)))
        ~
      `logs
    :_  dog(history actual-history)
    %+  turn  actual-vows
    |=  =id:block
    [%give %fact [%logs path]~ %scanner-diff !>([%disavow id])]
  ::
  ++  release-logs
    |=  [=path dog=watchdog]
    ^-  (quip card watchdog)
    ?:  (lth number.dog 30)
      `dog
    =/  numbers=(list number:block)  ~(tap in ~(key by pending-logs.dog))
    =.  numbers  (sort numbers lth)
    =^  logs=(list event-log:rpc:ethereum)  dog
      |-  ^-  (quip event-log:rpc:ethereum watchdog)
      ?~  numbers
        `dog
      =^  rel-logs-1  dog
        =/  =loglist  (~(get ja pending-logs.dog) i.numbers)
        =.  pending-logs.dog  (~(del by pending-logs.dog) i.numbers)
        ?~  loglist
          `dog
        =.  history.dog  [loglist history.dog]
        [loglist dog]
      =^  rel-logs-2  dog  $(numbers t.numbers)
      [(weld rel-logs-1 rel-logs-2) dog]
    :_  dog
    ?~  logs
      ~
    ^-  (list card:agent:gall)
    ::  ~&  >>>  scanner+"releasing logs {<path>}"
    [%give %fact [%logs path]~ %scanner-diff !>([%logs logs])]~
  --
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card agent:gall)
  ?+    +<.sign-arvo  ~|([%strange-sign-arvo -.sign-arvo] !!)
      %wake
    ?.  ?=([%timer *] wire)  ~&  weird-wire=wire  [~ this]
    =*  path  t.wire
    ?.  (~(has by dogs.state) path)
      ~&  >>  unknown-dog+path
      [~ this]
    ::  ~&  >>  scanner+"found dog for {<path>}"
    =/  dog=watchdog
      (~(got by dogs.state) path)
    ?^  error.sign-arvo
      ::  failed, try again.  maybe should tell user if fails more than
      ::  5 times.
      ::
      %-  (slog leaf+"scanner failed; will retry" ~)
      [[(wait path now.bowl refresh-rate.dog)]~ this]
    ::  maybe kill a timed-out update thread, maybe start a new one
    ::
    =^  stop-cards=(list card)  dog
      ::  if still running beyond timeout time, kill it
      ::
      ?.  ?&  ?=(^ running.dog)
            ::
              %+  gth  now.bowl
              (add since.u.running.dog timeout-time.dog)
          ==
        `dog
      ::
      %-  (slog leaf+"scanner {(spud path)} timed out; will restart" ~)
      =/  =cage  [%spider-stop !>([tid.u.running.dog |])]
      :_  dog(running ~)
      :~  (leave-spider path our.bowl)
          [%pass [%starting path] %agent [our.bowl %spider] %poke cage]
      ==
    ::
    =^  start-cards=(list card)  dog
      ::  if not (or no longer) running, start a new thread
      
      ?^  running.dog
        `dog
      :: if reached the to-block, don't start a new thread
      ::
      ?:  ?&  ?=(^ to.dog)
              (gte number.dog u.to.dog)
          ==
        `dog
      ::
      =/  new-tid=@ta
        (cat 3 'scanner--' (scot %uv eny.bowl))
      :_  dog(running `[now.bowl new-tid])
      =/  args
        :*  ~  `new-tid  bec  %scanner
            !>([~ `watchpup`[- number pending-logs blocks]:dog])
        ==
      :~  (watch-spider path our.bowl /thread-result/[new-tid])
          (poke-spider path our.bowl %spider-start !>(args))
      ==
    ::
    :-  [(wait path now.bowl refresh-rate.dog) (weld stop-cards start-cards)]
    this(dogs.state (~(put by dogs.state) path dog))
  ==
::
++  on-fail   on-fail:def
--
