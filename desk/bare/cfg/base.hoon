::  /cfg/base.hoon : %fund base configuration file
::
::    see /lib/config.hoon for more information
::
%-  malt
^-  (list [@tas vase])
:~  [%debug !>(%|)]
    [%chain !>(`@tas`%mainnet)]
    [%point !>(~tocwex)]
    [%sign-addr !>(0x78e6.603f.0393.3e0f.ebc6.88a7.734e.a8b4.b63f.42d0)]
    [%safe-addr !>(0x944a.5ba3.3bd9.5a5e.45e5.41c3.dd5a.0732.e90d.58e6)]
    [%site-base !>('tocwexsyndicate.com')]
    [%site-corp !>('https://tocwexsyndicate.com')]
    [%site-help !>('https://docs.tocwexsyndicate.com')]
    [%site-host !>('https://redhorizon.com/join/217ddb05-07f1-4897-8c6a-d6ef76da7380')]
    [%meta-tytl !>('%fund - sovereign work assessment tools for humans')]
    [%meta-logo !>('https://avatars.githubusercontent.com/u/96998266')]
    [%meta-desc !>('%fund: A sovereign webapp built by ~toxwex.syndicate on an integrated blockchain escrow ecosystem for human created, understood, and assessed "wise contracts".')]
==
