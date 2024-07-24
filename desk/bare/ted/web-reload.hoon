::  /ted/web-reload.hoon: force a reload of all web-based hoon pages
::
::    -fund!web-reload
::
/-  spider
/+  io=strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  bol=bowl:spider  bind:m  get-bowl:io
=/  dex=@tas  q.byk.bol
;<  fyz=(list path)  bind:m  (scry:io (list path) %ct dex /web)
;<    txz=(list (pair path @t))
    bind:m
  =/  m  (strand ,(list (pair path @t)))
  =|  cur=(list (pair path @t))
  |-  ^-  form:m
  ?~  fyz  (pure:m cur)
  ?.  =(%hoon (rear i.fyz))  $(fyz t.fyz)
  ;<  txt=@t  bind:m  (scry:io @t %cx dex i.fyz)
  $(fyz t.fyz, cur [[i.fyz txt] cur])
;<    ~
    bind:m
  %-  send-raw-cards:io
  %+  turn  txz
  |=  [fyl=path old=@t]
  =+  new=(welp (to-wain:format old) ~['::  RELOAD' ''])
  :*  %pass  [%web-reload fyl]
      %arvo  %c
      [%info dex %& [fyl %mut %txt !>(new)]~]
  ==
(pure:m !>(~))
