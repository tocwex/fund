/-  *fund
|%
::  +sss: structures/cores for peer-based synchronization (sss)
::
++  sss
  |%
  ::  +proj-flag: sss project path to project id flag
  ::
  ++  proj-flag
    |=  =path:proj
    ^-  flag
    [`@p`(slav %p ship.path) `@tas`(slav %tas name.path)]
  ::  +proj-lake: schema for peer-based project synchronization
  ::
  ++  proj-lake
    |%
    ++  name  %proj
    +$  rock  rock:proj
    +$  wave  wave:proj
    ++  wash  proj-wash
    --
  ::  +proj-wash: update function for project peer state deltas
  ::
  ++  proj-wash
    |=  [pro=proj bol=bowl:gall [sip=@p nam=@tas] jol=jolt]
    ^-  rock:proj
    ?+    -.jol  pro
        %init-proj
      %_  pro
        workers  (silt [our.bol]~)
      ==
    ::
        %edit-proj
      %_  pro
        title    (fall nam.jol title.pro)
        summary  (fall sum.jol summary.pro)
        image    (hunt |=(^ %.y) pic.jol image.pro)
        workers  (fall woz.jol workers.pro)
      ==
    ==
  --
--
