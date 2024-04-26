/~  cfgz  (map @tas vase)  /cfg
|%
++  conf                                         ::  config as map
  =<  best
  |%
  ++  base  (~(got by cfgz) %base)
  ++  beat  (snag 0 (turn (skip ~(tap by cfgz) |=([n=@ta *] =(%base n))) tail))
  ++  best  (~(uni by base) beat)
  --
++  slot                                         ::  value of key in config
  |=  key=@tas  ~+
  ^-  vase
  (~(got by conf) key)
++  enjs                                         ::  js-compatible dump of config
  ^~
  ^-  tape
  %-  ~(rep by conf)
  |=  [[key=@tas val=vase] acc=tape]
  =-  ?~(acc - :(welp acc "\0a" -))
  =-  "export const FUND_{var} = {dat};"
  ^-  [var=tape dat=tape]
  :-  (cuss (turn (trip key) |=(t=@tD ?.(=('-' t) t '_'))))
  ?+  -.val  !!
    [%atom %f *]  ?:(!<(bean val) "true" "false")
    [%atom %ux *]  "'{(welp ~['0' 'x'] ((x-co:co 40) !<(@ux val)))}'"
    [%atom dim=@ ~]  "'{(scow ->-.val !<(@ val))}'"
  ==
--
