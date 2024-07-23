|%
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
      cash=@rs
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
      milestones=(lest mile)
      pledges=(map ship plej)
      contribs=(list trib)
      contract=(unit oath)
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
      ::  [%blot ...mula-like...]
      [%draw min=@ dif=xact]
      [%wipe min=@ sig=(unit sigm)]
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
