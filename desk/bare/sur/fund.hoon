|%
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
::  $role: peer role relative to a work unit
::
+$  role
  $?  %work  ::  project worker
      %sess  ::  project assessor
      %fund  ::  project pledger/donator
      %look  ::  project follower
  ==
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
::  $contribution: pledge (oath) or donation (gift) made by user
::
+$  contribution
  $%  [%oath oath]
      [%gift gift]
  ==
::  $milestone: segment of work within a project
::
+$  milestone
  $:  title=@t
      summary=@t
      cost=@rs
      estimate=bloq
      donations=(list gift)
      status=stat
      ::  terminate=bloq  ::  undecided feature
      ::  fill=@rs  ::  reduction over `contributions`
  ==
::  $project: collection of work (milestones) requesting funding
::
+$  project
  $:  title=@t
      summary=@t
      ::  cost=@rs  ::  reduction over `milestones`
      workers=(set @p)
      assessment=sess
      milestones=(list milestone)
      contract=(unit bill)
      pledges=(list oath)
      ::  status=stat  ::  reduction of `milestones`
      ::  fill=@rs  ::  reduction over `milestones`
  ==
::  $peer-project: $project with peer (host) information
::
+$  peer-project
  $:  =project
      =flag
      stale=?
      fail=?
  ==
::  $epic: interface version number (type)
::
+$  epic  @ud
::  $epic-now: interface version number (value)
::
++  epic-now  `epic`0
::  $dat-now: top-level app data; forwarded to rudder-related requests
::
+$  dat-now
  $:  ours=(map flag project)
      rols=(jug flag role)
      ::  subs=_(mk-subs ...)
      ::  pubs=_(mk-pubs ...)
  ==
::  $act-now: action data forwarded to rudder-related POST requests
::
+$  act-now
  ~
--
