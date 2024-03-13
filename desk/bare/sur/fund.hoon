/+  sss, rudder
|%
+|  %meta
::
::  $epic: interface version number (type)
::
+$  epic  @ud
::
::  $epic-now: interface version number (value)
::
++  epic-now  `epic`0

+|  %base
::
::  $flag: identifier for a project (ship, id)
::
+$  flag  (pair @p @tas)
::
::  $sess: assessment information (ship, cut)
::
+$  sess  (pair @p @rs)
::
::  $addr: blockchain address
::
+$  addr  @ux  ::  address:ethereum-types
::
::  $bloq: blockchain block height
::
+$  bloq  @ud  ::  event-id:ethereum-types
::
::  $bill: blockchain project bill
::
+$  bill
  $:  =bloq
      oath=addr
      work=addr
      sess=addr
      ::  hash=@ux  ::  TODO: include Urbit side?
  ==
::
::  $stub: blockchain contribution payment stub
::
+$  stub
  $:  =bloq
      from=addr
      coin=addr
  ==
::
::  $perm: permission level (associated with $poke/$prod)
::
+$  perm
  $~  %peon
  $?  %boss  ::  admin action
      %help  ::  worker action
      %peon  ::  viewer action
  ==
::
::  $role: peer role relative to a work unit
::
+$  role
  $~  %look
  $?  %work  ::  project worker
      %sess  ::  project assessor
      %fund  ::  project pledger/contributor
      %look  ::  project follower
  ==
::
::  $rolz: role sets keyed by project id (host/term)
::
+$  rolz  (jug flag role)
::
::  $stat: status of work unit (project, milestone)
::
+$  stat
  $~  %born
  $?  %born  ::  just created, draft mode (off-chain)
      %prop  ::  created, proposed to assessor (off-chain)
      %lock  ::  locked in (on-chain, scope locked, launched)
      %work  ::  underway (on-chain, work started)
      %sess  ::  under assessment (on-chain, work reviewed)
      %done  ::  completed successfully
      %dead  ::  completed unsuccessfully
  ==
::
::  $plej: pledge for contribution
::
+$  plej
  $:  ship=@p
      cash=@rs
      when=bloq
      note=@t
  ==
::
::  $trib: actualization of contribution
::
+$  trib
  $:  ship=(unit @p)
      cash=@rs
      when=stub
      note=@t
  ==
::
::  $mula: investment via pledge ($plej) or contribution ($trib)
::
+$  mula
  $%  [%plej plej]
      [%trib trib]
  ==

+|  %core
::
::  $mile: segment of work (milestone) within a project
::
+$  mile
  $:  title=@t
      summary=@t
      image=(unit @t)
      cost=@rs
      ::  goal=bloq  ::  relative block height, e.g. +120 blocks
      contract=(unit bill)
      contribs=(list trib)
      status=stat
      ::  terminate=bloq  ::  undecided feature
      ::  fill=@rs  ::  reduction over `contribs`
  ==
::
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
        ::  workers=(set @p)  ::  TODO: Future feature
        assessment=sess
        milestones=(lest mile)
        contract=(unit bill)
        pledges=(map ship plej)
        ::  status=stat  ::  reduction of `milestones`
        ::  fill=@rs  ::  reduction over `milestones`
    ==
  +$  wave  [=bowl:gall =poke]
  ++  lake  (lake:sss rock wave)
  +$  path  [%fund %proj sip=@ nam=@ ~]
  --
::
::  $proz: collection of projects keyed by id (host/term)
::
+$  proz  (map flag proj)
::
::  $prej: project with peer information
::
+$  prej  [proj live=_|]
::
::  $prez: project collection with peer information
::
+$  prez  (map flag prej)

+|  %face
::
::  $prod: raw action identifier
::
+$  prod
  $%  ::  proj prods  ::
      [%init pro=(unit proj)]
      [%drop ~]
      [%bump sat=stat bil=(unit bill)]
      [%mula mula]
      ::  meta prods  ::
      [%join ~]
      [%exit ~]
      [%lure who=@p wat=role]
  ==
::
::  $poke: project-bound action (prod)
::
+$  poke  (pair flag prod)
::
::  $mess: (error) mess(age) (used internally)
::
+$  mess  [who=@p wer=flag wat=prod]
::
::  $dat-now: top-level app data; forwarded to rudder-related requests
::
+$  dat-now
  $:  =proz
      =rolz
      subs=_(mk-subs:sss *lake:proj path:proj)
      pubs=_(mk-pubs:sss *lake:proj path:proj)
  ==
::
::  $act-now: action data forwarded to rudder-related POST requests
::
+$  act-now  (lest poke)
::
::  $pag-now: base data structure for rudder-related page cores
::
+$  pag-now  (page:rudder dat-now act-now)
::
::  $paz-now: map from page path to rudder page core (for imports with /~)
::
+$  paz-now  (map knot pag-now)
--
