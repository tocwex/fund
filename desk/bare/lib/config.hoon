/~  cfgz  (map @tas vase)  /cfg
|%
++  conf                                         ::  config as map
  ~+
  ::  NOTE: Configuration files are ordered in precedence by the reverse
  ::  alphabetical sorting of their file names (e.g. %base is overridden
  ::  by %main, which is overridden by %test, etc.)
  ^-  (map @tas vase)
  =<  +  %^  spin
      (sort ~(tap by cfgz) |=([[a=@tas *] [b=@tas *]] (aor a b)))
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
  ?+  -.val  "undefined"
    [%atom %f *]  ?:(!<(bean val) "true" "false")
    [%atom %ux *]  "'{['0' 'x' ((x-co:co 40) !<(@ux val))]}'"
    [%atom %ud *]  "'{(a-co:co !<(@ val))}'"
    [%atom %p *]  "'{(scow %p !<(@ val))}'"
    [%atom %dr *]  "'{(a-co:co !<(@ val))}'"  ::  FIXME: Doesn't really work
    [%atom dim=@ ~]  "'{(scow %tas !<(@ val))}'"
  ==
--
