|%
+|  %base
::
::  $flag: identifier for a project (ship, id)
::
+$  flag  (pair @p @tas)
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
::  $cash: blockchain transaction amount (e.g. wei)
::
+$  cash  @ud
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
::  $stub: blockchain contribution payment receipt
::
+$  stub
  $:  =xact
      from=addr
  ==
::
::  $xeta: blockchain metadata
::
+$  xeta
  $:  id=@ud
      tag=@tas
      rpc=@t
  ==
::
::  $coin: blockchain token information
::
+$  coin
  $:  chain=@ud
      =addr
      name=@t
      symbol=@t
      decimals=@ud
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
::  $blot: identifier for display-style action
::
+$  blot
  $~  %hide
  $?  %hide  ::  hide by default
      %show  ::  show by default
      %drop  ::  remove from data structure
  ==
::
::  $view: interpretation of outstanding pledge
::
+$  view
  $~  %slyd
  $?  %stif  ::  negative view; "welched"
      %slyd  ::  positive view; "forgiven"
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
::  $sess: assessment information (ship, cut)
::
+$  sess  (pair @p cash)
::
::  $pruf: blockchain/oracle attestation of contribution
::
+$  pruf
  $:  ship=(unit @p)
      =cash
      when=stub
      note=?(%with %depo)
  ==
::
::  $plej: ship promise for contribution
::
+$  plej
  $:  ship=@p
      =cash
      when=bloq
      note=@t
  ==
::
::  $trib: ship attestation of contribution
::
+$  trib
  $:  ship=(unit @p)
      =cash
      when=stub
      note=@t
  ==
::
::  $treb: record of contribution (with metadata)
::
+$  treb
  $:  trib
      plej=(unit plej)
      pruf=(unit pruf)
  ==
::
::  $mula: investment diff via attestation ($pruf), pledge ($plej), or contribution ($trib)
::
+$  mula
  $%  [%plej plej]
      [%trib trib]
      [%pruf pruf]
  ==
::
::  $odit: financials associated with a work unit ($proj, $mile)
::
+$  odit
  $:  cost=cash
      fill=cash
      plej=cash
      void=(unit [s=? v=cash])
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
::  $with: blockchain project withdrawal receipt
::
+$  with
  $:  xact=(unit xact)
      =sigm
      =cash
      pruf=(unit pruf)
  ==

+|  %core
::
::  $deta: display metadata (for visible + addressable items)
::
+$  deta
  $:  id=@ud
      show=?
  ==
::
::  $peta: display metadata and interpretation (deta + optional view)
::
+$  peta
  $:  view=(unit view)
      deta
  ==
::
::  $mile: segment of work (milestone) within a project
::
+$  mile
  $:  title=@t
      summary=@t
      image=(unit @t)
      cost=cash
      status=stat
      withdrawal=(unit with)
  ==
::
::  $proj: collection of work (milestones) requesting funding
::
++  proj
  $:  title=@t
      summary=@t
      image=(unit @t)
      assessment=sess
      currency=coin
      milestones=(lest mile)
      contract=(unit oath)
      pledges=(map ship [plej peta])
      contribs=(map addr [treb deta])
      proofs=(map addr pruf)
  ==
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
::  $prod: raw delta identifier
::
+$  prod
  $%  ::  proj prods  ::
      [%init pro=(unit proj)]
      [%drop ~]
      [%bump sat=stat oat=(unit oath)]
      [%mula mula]
      [%blot mid=@ dif=blot]
      [%draw min=@ dif=xact]
      [%wipe min=@ sig=(unit sigm)]
      ::  [%load ~]  ::  reload ethereum state
      ::  meta prods  ::
      [%join ~]
      [%exit ~]
      [%lure who=@p wut=role]
  ==
::
::  $poke: project-bound delta ($prod)
::
+$  poke  (pair flag prod)

+|  %misc
::
::  $mess: (error) mess(age) (used internally)
::
+$  mess  [who=@p wer=flag wut=prod]
--
