/-  *fund-core
/+  tx=naive-transactions
|%
::
::  +filo: fill in an $odit by calculating `void` (if required)
::
++  filo
  |=  odi=odit
  ^-  odit
  %_    odi
      void
    ?^  void.odi  void.odi
    =+  fil=(add fill.odi plej.odi)
    `[(gte cost.odi fil) (sub (max cost.odi fil) (min cost.odi fil))]
  ==
::
::  +tula: t(ime) associated with a $(m)ula (measured by block height)
::
++  tula
  |=  mul=mula
  ^-  bloq
  ?-  -.mul
    %plej  when.mul
    %trib  p.xact.when.mul
    %pruf  p.xact.when.mul
  ==
::
::  +daoq: @d(ate)a(bsolute) (for) $(bl)oq
::
++  daoq
  |=  [boq=bloq can=@ud]
  ^-  @da
  =-  (add sod (^mul (sub boq (min boq sob)) (droq boq can)))
  ^-  [sob=bloq sod=@da]
  ?+  can        [0 *@da]
    %1           [19.763.774 ~2024.4.29..21.54.11]
    %11.155.111  [5.793.125 ~2024.4.28..4.9.0]
  ==
::
::  +droq: @d(ate)r(elative) (for) $(bl)oq
::
++  droq
  |=  [boq=bloq can=@ud]
  ^-  @dr
  =-  (abs:si (need (toi:rs (mul:rs rpm (sun:rs (bex 64))))))
  ^-  rpm=@rs
  ?+  can        .12.500
    %1           .12.065
    %11.155.111  .13.520
  ==
::
::  +csig: c(heck) (Ethereum EIP-191) sig(nature)
::
++  csig
  |=  sig=sigm
  ^-  bean
  =-  ?~(- | =(u.- from.sig))
  ^-  (unit @ux)
  =/  dat=tape  =+(t=(trip `@t`p.mesg.sig) ?-(-.mesg.sig %& t, %| (flop t)))
  =/  msg=tape  "\19Ethereum Signed Message:\0a{(a-co:co (met 3 p.mesg.sig))}{dat}"
  ::  FIXME: Should use +crip instead of +rep, but can't due to a bug in
  ::  +crip dealing with tapes containing \00 entries; see:
  ::  https://github.com/urbit/urbit/pull/6818
  =/  syg=octs  (as-octs:mimes:html (rep 3 msg))
  (verify-sig:tx sign.sig syg)
--
