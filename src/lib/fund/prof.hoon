/-  *fund-prof
/+  fc=fund-core, ff=fund-form
|%
::
::  +pf: p(ro)f(ile) (library); helper door for $prof data
::
++  pf
  |_  prof
  ++  csig
    |=  [sip=@p sig=sigm]
    ^-  bean
    ?&  =((oath sip from.sig) (trip `@t`p.mesg.sig))
        (csig:fc sig)
    ==
  ++  oath
    |=  [sip=@p wat=addr]
    ^-  tape
    "I, {<sip>}, am broadcasting to the Urbit network that I own wallet {(addr:enjs:ff wat)}"
  --
--
