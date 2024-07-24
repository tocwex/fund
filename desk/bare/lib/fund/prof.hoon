/-  *fund-prof
/+  ff=fund-form
|%
::
::  +pf: p(ro)f(ile) (library); helper door for $prof data
::
++  pf
  |_  prof
  ++  oath
    |=  [who=@p wat=addr]
    ^-  tape
    "I, {<who>}, am broadcasting to the Urbit network that I own wallet {(addr:enjs:ff wat)}"
  --
--
