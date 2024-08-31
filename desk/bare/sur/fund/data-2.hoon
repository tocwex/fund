/-  fund
/-  sss-proj, sss-prof=sss-prof-0, sss-meta=sss-meta-0
/+  sss, rudder
|%
::
::  +proj: convenience accessor for 'sss-proj' sss core
::
++  proj  sss-proj
::
::  +meta: convenience accessor for 'sss-meta' sss core
::
++  meta  sss-meta
::
::  +prof: convenience accessor for 'sss-prof' sss core
::
++  prof  sss-prof
::
::  $data: top-level app data; forwarded to rudder-related requests
::
+$  data
  $:  init=_|
      adrz-loql=(map @p (map addr:fund sigm:fund))
      meta-srcs=[f2p=(jug flag:fund @p) p2f=(jug @p flag:fund)]
      proj-subs=_(mk-subs:sss lake:sss-proj path:sss-proj)
      proj-pubs=_(mk-pubs:sss lake:sss-proj path:sss-proj)
      meta-subs=_(mk-subs:sss lake:sss-meta path:sss-meta)
      meta-pubs=_(mk-pubs:sss lake:sss-meta path:sss-meta)
      prof-subs=_(mk-subs:sss lake:sss-prof path:sss-prof)
      prof-pubs=_(mk-pubs:sss lake:sss-prof path:sss-prof)
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
