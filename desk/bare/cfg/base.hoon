::  /cfg/base.hoon : %fund base configuration file
::
::    see /lib/config.hoon for more information
::
%-  malt
^-  (list [@tas vase])
:~  [%debug !>(%|)]
    [%chain !>(`@tas`%mainnet)]
    [%point !>(~tocwex)]
    [%sign-addr !>(0x0)]  ::  TODO: Fill this in with real address
    [%safe-addr !>(0x0)]  ::  TODO: Fill this in with real address
    [%site-base !>('tocwexsyndicate.com')]
    [%site-corp !>('https://tocwexsyndicate.com')]
    [%site-help !>('https://docs.tocwexsyndicate.com')]
    [%meta-tytl !>('%fund - sovereign work assessment tools for humans')]
    [%meta-logo !>('https://avatars.githubusercontent.com/u/96998266')]
    [%meta-desc !>('%fund: A sovereign webapp built by ~toxwex.syndicate on an integrated blockchain escrow ecosystem for human created, understood, and assessed "wise contracts".')]
==
