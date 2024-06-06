/-  fund, fund-proj-0
/+  sss, rudder
|%
::
::  +proj: convenience accessor for 'fund-proj' sss core
::
++  proj  fund-proj-0
::
::  $data: top-level app data; forwarded to rudder-related requests
::
+$  data
  $:  =proz:fund
      init=_|
      subs=_(mk-subs:sss lake:fund-proj-0 path:fund-proj-0)
      pubs=_(mk-pubs:sss lake:fund-proj-0 path:fund-proj-0)
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
