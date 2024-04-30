/~  cfgz  (map @tas vase)  /cfg
|%
++  conf                                         ::  config as map
  ~+
  ::  NOTE: Configuration files are ordered in precedence by the reverse
  ::  alphabetical sorting of their file names (e.g. %base is overridden
  ::  by %main, which is overridden by %test, etc.)
  ^-  (map @tas vase)
  =<  +  %^  spin
      (sort ~(tap by cfgz) |=([[a=@ta *] [b=@ta *]] (lth a b)))
    *(map @tas vase)
  |=([[p=@ta n=(map @tas vase)] a=(map @tas vase)] [[p n] (~(uni by a) n)])
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
