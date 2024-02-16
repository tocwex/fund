/+  sss
|%
+|  %meta
::  $epic: interface version number (type)
::
+$  epic  @ud
::  $epic-now: interface version number (value)
::
++  epic-now  `epic`0

+|  %base
::  $flag: identifier for a project (ship, id)
::
+$  flag  (pair @p @tas)
::  $sess: assessment information (ship, cut)
::
+$  sess  (pair @p @rs)
::  $addr: blockchain address
::
+$  addr  @ux  ::  address:ethereum-types
::  $bloq: blockchain block height
::
+$  bloq  @ud  ::  event-id:ethereum-types
::  $bill: blockchain project bill
::
+$  bill
  $:  =bloq
      work=addr
      sess=addr
      ::  hash=@ux  ::  TODO: include Urbit side?
  ==
::  $stub: blockchain donation stub
::
+$  stub
  $:  =bloq
      from=addr
      coin=addr
  ==
::  $perm: permission level (associated with $poke/$jolt)
::
+$  perm
  $?  %boss  ::  admin action
      %help  ::  worker action
      %peon  ::  viewer action
  ==
::  $role: peer role relative to a work unit
::
+$  role
  $?  %work  ::  project worker
      %sess  ::  project assessor
      %fund  ::  project pledger/donator
      %look  ::  project follower
  ==
::  $rolz: role sets keyed by project id (host/term)
::
+$  rolz  (jug flag role)
::  $stat: status of work unit (project, milestone)
::
+$  stat
  $?  %born  ::  proposed (off-chain)
      %lock  ::  locked in (on-chain, scope locked, launched)
      %work  ::  underway (on-chain, work started)
      %sess  ::  under assessment (on-chain, work reviewed)
      %done  ::  completed successfully
      %dead  ::  completed unsuccessfully
  ==
::  $oath: pledge for contribution
::
+$  oath
  $:  cash=@rs
      ship=@p
      when=bloq
  ==
::  $gift: actualization of contribution
::
+$  gift
  $:  cash=@rs
      ship=(unit @p)
      when=stub
  ==
::  $mula: pledge (oath) or donation (gift) made by user
::
+$  mula
  $%  [%oath oath]
      [%gift gift]
  ==

+|  %core
::  $mile: segment of work (milestone) within a project
::
+$  mile
  $:  title=@t
      summary=@t
      image=(unit @t)
      cost=@rs
      estimate=bloq
      donations=(list gift)
      status=stat
      ::  terminate=bloq  ::  undecided feature
      ::  fill=@rs  ::  reduction over `contributions`
  ==
::  $proj: collection of work (milestones) requesting funding
::
++  proj
  =<  rock
  |%
  +$  rock
    $:  title=@t
        summary=@t
        image=(unit @t)
        ::  cost=@rs  ::  reduction over `milestones`
        workers=(set @p)
        assessment=sess
        milestones=(list mile)
        contract=(unit bill)
        pledges=(list oath)
        ::  status=stat  ::  reduction of `milestones`
        ::  fill=@rs  ::  reduction over `milestones`
    ==
  +$  wave  [=bowl:gall =poke]
  ++  lake  (lake:sss rock wave)
  +$  path  [%fund %proj ship=@ name=@ ~]
  --
::  $proz: collection of projects keyed by id (host/term)
::
+$  proz  (map flag proj)
::  $prej: project with peer information
::
+$  prej  [proj live=?]
::  $prez: project collection with peer information
::
+$  prez  (map flag prej)

+|  %face
::  $jolt: raw action identifier
::
+$  jolt
  $%  [%init-proj ~]
      [%drop-proj ~]
      [%join-proj ~]
      $:  %edit-proj
          nam=(unit @t)
          sum=(unit @t)
          pic=(unit @t)
          woz=(unit (set @p))
      ==
  ==
::  $poke: project-bound action (jolt)
::
+$  poke  (pair flag jolt)
::  $dat-now: top-level app data; forwarded to rudder-related requests
::
+$  dat-now
  $:  =proz
      =rolz
      subs=_(mk-subs:sss *lake:proj path:proj)
      pubs=_(mk-pubs:sss *lake:proj path:proj)
  ==
::  $act-now: action data forwarded to rudder-related POST requests
::
+$  act-now
  ~
--
