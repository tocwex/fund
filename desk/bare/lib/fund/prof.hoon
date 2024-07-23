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
    "I, {<who>}, own wallet {<(addr:enjs:ff wat)>}"
  --
--
