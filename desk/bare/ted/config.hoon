::  /ted/config.hoon: add or remove an app configuration file
::
::    -fund!config & /xtra/verb/hoon
::    -fund!config | /verb/hoon
::
/-  spider
/+  io=strandio, fx=fund-xtra
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ add=? pat=path] arg)
=/  pin=path  [%cfg pat]
=/  ext=@tas  -:(flop pin)
;<  bol=bowl:spider  bind:m  get-bowl:io
;<  dir=arch  bind:m  (scry:io arch %cy q.byk.bol pin)
?~  fil.dir  (pure:m !>('no file at input path'))
::  TODO: verify that file is a hoon file that produces (map @tas vase)
?.  =(%hoon ext)  (pure:m !>('input file is invalid config file'))
;<  txt=noun  bind:m  (scry:io noun %cx q.byk.bol pin)
;<    ~
    bind:m
  =+  pre=|=(p=path [(scot %p our.bol) q.byk.bol (scot %da now.bol) p])
  %+  poke:io  [our.bol %hood]
  ?.  add  kiln-rm+!>((pre pin))
  =/  pou=path  (pre [%cfg (slaj:fx 2 pin)])
  kiln-info+!>([*tape `(foal:space:userlib pou ext [%atom %t ~] txt)])
::  FIXME: Need to wait for a sec so that config file loads before all
::  the web files are changed
;<  ~  bind:m  (sleep:io ~s1)
;<  tid=tid:spider   bind:m  (start-thread:io %web-reload)
::  ;<  thread-result:io  bind:m  (await-thread:io %web-reload !>(~))
(pure:m !>(~))
