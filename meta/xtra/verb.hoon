::  /cfg/verb.hoon : %fund verbosity enablement configuration
::
::    to deploy locally, run the following:
::
::    cd ./desk/full/cfg/
::    ln -s ../../../meta/xtra/verb.hoon ./
::
%-  malt
^-  (list [@tas vase])
:~  [%debug !>(%&)]
==
