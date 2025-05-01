/-  fund=fund-core-0, sss-proj=sss-proj-0
/+  sss, rudder
|%
::
::  +proj: convenience accessor for 'sss-proj' sss core
::
++  proj  sss-proj
::
::  $data: top-level app data; forwarded to rudder-related requests
::
+$  data
  $:  =proz:fund
      init=_|
      subs=_(mk-subs:sss lake:sss-proj path:sss-proj)
      pubs=_(mk-pubs:sss lake:sss-proj path:sss-proj)
  ==
::
::  $diff: data delta forwarded to rudder-related POST requests
::
+$  diff  poke:fund
::
::  $page: base data structure for rudder-related page cores
::
+$  page  (page:rudder data diff)
--
