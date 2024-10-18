::  /web/fund/page/proj-okay/hoon: project page exists? (used internally)
::
/-  fd=fund-data
/+  f=fund-proj, fh=fund-http
/+  rudder
%-  :(corl dump:preface:fh (proj:preface:fh |))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  [lau=(unit flag:f) pru=(unit prej:f)]  (grab:proj:preface:fh arz)
  :-  %full
  ^-  simple-payload:http
  :_  ~
  :-  ?:(&(?=(^ lau) =(our.bol p.u.lau)) 200 404)
  ~[[%content-type 'text/plain'] ['Access-Control-Allow-Origin' '*']]
--
::  VERSION: [1 4 4]
