::  /cfg/test.hoon : %fund debug configuration file
::
::    to deploy locally, run the following:
::
::    cd ./desk/full/cfg/
::    ln ../../../meta/test.hoon ./
::
%-  malt
^-  (list [@tas vase])
:~  [%debug !>(%&)]
    [%chain !>(`@tas`%sepolia)]  ::  TODO: %$ for 'chain bypass' mode
    [%point !>(~zod)]
    [%sign-addr !>(0xcbbd.2aab.5ee5.09e8.531a.b407.d48f.c93c.dc25.e1ad)]
    [%safe-addr !>(0xcbbd.2aab.5ee5.09e8.531a.b407.d48f.c93c.dc25.e1ad)]
==
