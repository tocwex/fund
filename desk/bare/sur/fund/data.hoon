/-  fund
/-  sss-proj, sss-prof, sss-meta
/+  sss, rudder
|%
::
::  +proj: convenience accessor for 'sss-proj' sss core
::
++  proj  sss-proj
::
::  +prof: convenience accessor for 'sss-prof' sss core
::
++  prof  sss-prof
::
::  $data: top-level app data; forwarded to rudder-related requests
::
+$  data
  $:  init=_|
      adrs=(map addr:fund sigm:fund)
      proj-subs=_(mk-subs:sss lake:sss-proj path:sss-proj)
      proj-pubs=_(mk-pubs:sss lake:sss-proj path:sss-proj)
      prof-subs=_(mk-subs:sss lake:sss-prof path:sss-prof)
      prof-pubs=_(mk-pubs:sss lake:sss-prof path:sss-prof)
      meta-subs=_(mk-subs:sss lake:sss-meta path:sss-meta)
      meta-pubs=_(mk-pubs:sss lake:sss-meta path:sss-meta)
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
