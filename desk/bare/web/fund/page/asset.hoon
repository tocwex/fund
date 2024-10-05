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
      ++  joyn  |=([d=@t l=(list @t)] (crip (roll (join d l) |=([n=@t a=tape] (weld a (trip n))))))
      +$  sath  (each path [@ta @t])  ::  pseudo-path
      --
  =/  pat=(pole knot)  (slag:derl:ff:fh url.request.ord)
  ?>  ?=([%asset fyl=@t ~] pat)
  =/  max=(map @t sath)  ::  'file.ext' => /path/to/file/ext
    =<  +  %^  spin
        .^((list path) %ct (beak q.byk.bol /web/[dap.bol]))
      (my ~[['config.js' `sath`[%| 'js' (crip enjs:config)]]])  ::  pseudo-paths
    |=  [pat=path mix=(map @t sath)]
    [pat (~(put by mix) (joyn '.' (slaj:fx 2 pat)) %& pat)]
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
    %=    pat
        fyl
      %-  crip  %+  welp  (trip fyl.pat)
      (tail:en-purl:html [[%v (crip (vers:enjs:ff:fh hav))] arz])
    ==
  ::  if this file has an old version specified, 404
  ?.  =(hav u.ned)
    [%code 404 'Not found (old version)']
  ::  perform string substitution for url arguments for 'mold/x.y' files
  =/  txt=tape
    =/  raw=@t  ?-(-.u.mat %| +.p.u.mat, %& .^(@t %cx (beak q.byk.bol p.u.mat)))
    ?.  sub=?-(-.u.mat %| |, %& ?=([@ @ %mold *] (flop p.u.mat)))  (trip raw)
    ::  FIXME: Remove newlines because they can't be handled naively in cords
    ::  when fed through `ream` with escapes
    =/  rew=@t  (crip :(welp "\"" (skip (trip raw) |=(=@t =('\0a' t))) "\""))
    =/  ars=(list [@tas tape])
      %-  welp  :_  (turn arz |=([k=@t v=@t] [(asci:fx k) (trip v)]))
      ^-  dez=(list [@tas tape])  ::  substitution defaults
      :~  [%stroke "#545557"]  ::  palette-primary
      ==
    =/  vas=vase
      :_  `*`(flop (turn ars tail))
      =/  typ=type  -:!>(~)
      |-
      ?~  ars  typ
      $(ars t.ars, typ [%cell [%face -.i.ars -:!>(+.i.ars)] typ])
    ?-  res=(mule |.(!<(tape (slap (slop vas !>(..hoon)) (ream rew)))))
      [%& *]  +.res
      [%| *]  ~?(!<(? (slot:config %debug)) p.res (trip raw))
    ==
  =/  mym=mime  %.((crip txt) .^($-(@t mime) %cf (beak q.byk.bol /[ext]/mime)))
  :-  %full
  ^-  simple-payload:http
  :_  `q.mym
  :+  200  [%content-type (joyn '/' p.mym)]  ::  1 week cache time
  ?:(!<(bean (slot:config %debug)) ~ ['cache-control' 'max-age=604800']~)
--
::  VERSION: [1 4 1]
