::  /web/fund/page/asset/hoon: render an arbitrary asset file (png, svg, etc.)
::
/-  fd=fund-data
/+  fh=fund-http, fx=fund-xtra
/+  config, rudder
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  ::  NOTE: Files are loaded at run-time here through scries in order to
  ::  avoid expensive re-compilation when doing quick edits to js/css
  =>  |%
      ++  beak  |=([d=@tas p=path] (en-beam [our.bol d da+now.bol] p))
      ++  forj  |=([d=@t l=(list @t)] (crip (roll (join d l) |=([n=@t a=tape] (weld a (trip n))))))
      +$  sath  (each path [@ta @t])  ::  pseudo-path
      --
  =/  pat=(pole knot)  (slag:derl:ff:fh url.request.ord)
  ?>  ?=([%asset fyl=@t ~] pat)
  =/  max=(map @t sath)
    =<  +  %^  spin
        .^((list path) %ct (beak q.byk.bol /web/[dap.bol]))
      (my ~[['config.js' `sath`[%| 'js' (crip enjs:config)]]])  ::  pseudo-paths
    |=  [pat=path mix=(map @t sath)]
    [pat (~(put by mix) (forj '.' (slaj:fx 2 pat)) %& pat)]
  ::  if this file isn't a recognized asset, 404
  ?~  mat=(~(get by max) fyl.pat)
    [%code 404 'Not found (no asset)']
  =/  ext=@ta  ?-(-.u.mat %| -.p.u.mat, %& (rear p.u.mat))
  ::  if this file is using an unsupported extension, 404
  ?.  .^(? %cu (beak q.byk.bol /mar/[ext]/hoon))
    [%code 404 'Not found (bad file type)']
  ::  inspired by: https://stackoverflow.com/a/1922924/837221
  =+  hav=.^([@ @ @] %gx (beak %docket /charges/[dap.bol]/version/noun))
  =/  ned=(unit [@ @ @])
    =-  (rush - ;~((glue dot) dem dem dem))
    (fall (bind (find:fx arz |=([k=@t @t] =(%v k))) tail) '')
  ::  if this file has no version specified, 307 to latest version
  ?~  ned
    :-  %next  :_  ~
    %-  desc:enrl:ff:fh
    pat(fyl (crip (welp (trip fyl.pat) "?v={<+2.hav>}.{<+6.hav>}.{<+7.hav>}")))
  ::  if this file has an old version specified, 404
  ?.  =(hav u.ned)
    [%code 404 'Not found (old version)']
  =/  mym=mime
    %-  .^($-(@t mime) %cf (beak q.byk.bol /[ext]/mime))
    ?-(-.u.mat %| +.p.u.mat, %& .^(@t %cx (beak q.byk.bol p.u.mat)))
  :-  %full
  ^-  simple-payload:http
  :_  `q.mym
  :+  200  [%content-type (forj '/' p.mym)]  ::  1 week cache time
  ?:(!<(bean (slot:config %debug)) ~ ['cache-control' 'max-age=604800']~)
--
::  VERSION: [1 1 2]
