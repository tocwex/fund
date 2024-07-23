/-  *fund-core
|%
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
::  $prej: project with peer information
::
+$  prej  [proj live=_|]
::
::  $proz: collection of projects keyed by id (host/term)
::
+$  proz  (map flag proj)
::
::  $prez: project collection with peer information
::
+$  prez  (map flag prej)
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
--
