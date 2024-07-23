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
    `[(gth cost.odi fil) (sub (max cost.odi fil) (min cost.odi fil))]
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
