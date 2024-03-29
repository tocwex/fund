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
::  $mesg: blockchain signed message information (message or raw hex)
::
+$  mesg  (each @t @ux)
::
::  $addr: blockchain address
::
+$  addr  @ux  ::  address:ethereum-types
::
::  $sign: blockchain signature
::
+$  sign  @ux
::
::  $bloq: blockchain block height
::
+$  bloq  @ud  ::  event-id:ethereum-types
::
::  $xact: blockchain transaction data
::
+$  xact  (pair bloq addr)
::
::  $sigm: blockchain message signature
::
+$  sigm
  $:  =sign
      from=addr
      =mesg
  ==
::
::  $oath: blockchain project agreement receipt
::
+$  oath
  $:  =xact
      =sigm
      work=addr
      orac=addr
      safe=addr
  ==
::
::  $stub: blockchain contribution payment receipt
::
+$  stub
  $:  =xact
      from=addr
  ==
::
::  $perm: permission level (associated with $poke/$prod)
::
+$  perm
  $~  %peon
  $?  %boss  ::  admin action
      %peer  ::  worker action
      %peon  ::  viewer action
  ==
::
::  $role: peer role relative to a work unit
::
+$  role
  $?  %work  ::  project worker
      %orac  ::  project oracle
      %fund  ::  project funder
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
      %prop  ::  created, proposed to oracle (off-chain)
      %lock  ::  locked in (on-chain, scope locked, launched)
      %work  ::  underway (on-chain, work started)
      %sess  ::  under assessment (on-chain, work reviewed)
      %done  ::  completed successfully
      %dead  ::  completed unsuccessfully
  ==
::
::  $plej: promise for contribution
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
::
::  $odit: financials associated with a work unit ($proj, $mile)
::
+$  odit
  $:  cost=@rs
      fill=@rs
      plej=@rs
      void=(unit @rs)
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
      status=stat
      approval=(unit (pair sigm @rs))
      withdrawal=(unit xact)
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
        assessment=sess
        milestones=(lest mile)
        pledges=(map ship plej)
        contribs=(list trib)
        contract=(unit oath)
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
      [%bump sat=stat oat=(unit oath)]
      [%mula mula]
      ::  meta prods  ::
      [%join ~]
      [%exit ~]
      [%lure who=@p wut=role]
  ==
::
::  $poke: project-bound action (prod)
::
+$  poke  (pair flag prod)
::
::  $mess: (error) mess(age) (used internally)
::
+$  mess  [who=@p wer=flag wut=prod]
::  +$  mess  [wer=flag wut=prod who=@p why=(unit @t)]
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
