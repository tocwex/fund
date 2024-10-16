::  /web/fund/page/proj-next/hoon: project redirect page for %fund
::
/-  fd=fund-data
/+  f=fund-proj, fh=fund-http, fx=fund-xtra
/+  rudder, config
%-  :(corl dump:preface:fh init:preface:fh (proj:preface:fh |))
^-  page:fd
|_  [bol=bowl:gall ord=order:rudder dat=data:fd]
++  argue
  |=  [hed=header-list:http bod=(unit octs)]
  ^-  $@(brief:rudder diff:fd)
  =/  [lau=(unit flag:f) *]  (grab:proj:preface:fh hed)
  ?~  lau  'bad dif; no project flag in the POST URL'
  ?+  arz=(parz:fh bod (sy ~[%dif]))  p.arz  [%| *]
    ?+    dif=(~(got by p.arz) %dif)
        (crip "bad dif; expected (bump-prop|join-proj), not {(trip dif)}")
      %bump-prop  [%proj u.lau %bump %prop ~]
      %join-proj  [%proj u.lau %join ~]
    ==
  ==
++  final
  |=  [gud=? txt=brief:rudder]
  ^-  reply:rudder
  =/  [dyp=@tas lag=flag:f pyp=@tas]  (gref:proj:preface:fh txt)
  :-  %next  :_  ~
  ?+    pyp  (flac:enrl:ff:fh lag)
      %join
    (desc:enrl:ff:fh /next/(scot %p p.lag)/[q.lag]/join)
  ==
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  pat=(pole knot)  (slag:derl:ff:fh url.request.ord)
  =/  [lau=(unit flag:f) pru=(unit prej:f)]  (grab:proj:preface:fh arz)
  =/  lag=flag:f  (fall lau *flag:f)
  =/  aut=?(%clear %eauth %admin)
    ?.((auth:fh bol) %clear ?:(=(our src):bol %admin %eauth))
  :-  %page
  %-  page:ui:fh
  :^  bol  ord  ?~(pru (flag:enjs:ff:fh lag) (trip title.u.pru))
  :+  fut=&  hed=&
  ?+  pat  !!  [%next sip=@ nam=@ typ=@ ~]
    =/  syt
      :*  hep=(trip !<(@t (slot:config %meta-help)))
          hos=(trip !<(@t (slot:config %meta-site)))
          tlo=(trip !<(@t (slot:config %meta-tlon)))
          pro=(dest:enrl:ff:fh pat(- %project, +>+ ~))
      ==
    =/  btn
      :*  hep=(link-butn:ui:fh hep.syt %& "what is %fund?" ~)
          pro=(link-butn:ui:fh pro.syt %| "back to project" ~)
          tlo=(link-butn:ui:fh tlo.syt %& "join group ~" ~)
          joi=(link-butn:ui:fh hos.syt %& "get urbit ~" ~)
          das=(link-butn:ui:fh (dest:enrl:ff:fh /) %| "back to dashboard" ~)
      ==
    ?+    typ.pat  !!
        %bump
      %^    hero-plaq:ui:fh
          "Your project action has been submitted."
        ~
      [pro.btn ?.(?=(%admin aut) ~ [das.btn]~)]
    ::
        %exit
      %^    hero-plaq:ui:fh
          "You are now leaving project '{(flag:enjs:ff:fh lag)}'…"
        ~
      :_  ~
      %.  [%x-init "delay(2000).then(() => $el.form.requestSubmit($el))"]~
      %~  joat  ma:fh
      (~(prod-butn ui:fh "hidden") %medi %true %join-proj "join project ✓" ~ ~)
    ::
        %join
      %^    hero-plaq:ui:fh
          "You are now joining project '{(flag:enjs:ff:fh lag)}'!"
        ~
      :_  ~
      ;div  =x-data  "\{ status: undefined }"
          =x-init  "queryPage('{pro.syt}', \{maxAttempts: 5}).then(p => \{status = !!p;})"
        ;+  (~(joat ma:fh pro.btn) [%x-show "status == true"]~)
        ;+  %.  [%x-show "status == undefined"]~
            %~  joat  ma:fh
            (link-butn:ui:fh pro.syt %| "back to project" "Loading data from host…")
        ;+  %.  [%x-show "status == false"]~
            %~  joat  ma:fh
            (link-butn:ui:fh pro.syt %| "error ✗" "Failed to reach host.")
      ==
    ::
        %edit
      %^      hero-plaq:ui:fh
          "Your changes have been saved!"
        ^-  tape  ^~
        %+  rip  3
        '''
        If you are ready to launch your project, click "Request Oracle"
        below to send a request to your chosen oracle. We do not
        currently support in-app notifications, so we suggest you also
        send them a direct message via the Tlon application to let them
        know they have a pending service request!
        '''
      :~  (prod-butn:ui:fh %medi %true %bump-prop "request oracle ✓" ~ ~)
          (link-butn:ui:fh (dest:enrl:ff:fh pat(- %project)) %| "continue editing" ~)
          pro.btn
      ==
    ::
        ?(%trib %plej)
      =-  ;div(class "flex flex-col gap-y-3 p-2 max-w-[640px] mx-auto")
            ;h1: Thank you!
            ;p: Your {?-(typ.pat %plej "pledge", %trib "contribution")} has been received!
            ;+  hed
            ;div(class "flex flex-row flex-wrap gap-y-2 gap-x-3")
              ;+  pro.btn
              ;+  but
              ;*  ?~  pow=(~(get by ~(ours conn:prof:fd bol [prof-subs prof-pubs]:dat)) p.lag)  ~
                  :_  ~
                  (pink-butn:ui:fh lag (trip ship-url.u.pow))
            ==
            ;+  bod
            ;p
              ; To learn more about `%fund` and our longer running vision at
              ; ~tocwex.syndicate for how to give people tools for sovereign
              ; cryptoeconomic activity in the world of atoms, join us on the
              ; network at ~tocwex/syndicate-public or click the button below.
            ==
            ;div(class "flex flex-row gap-x-3")
              ;+  ?:(?=(%clear aut) joi.btn tlo.btn)
            ==
          ==
      ^=  [but=manx hed=manx bod=manx]
      :*    ^=  but
          ?-    aut
            %clear  joi.btn
            %eauth  (link-butn:ui:fh "{hep.syt}/#installing-fund" %& "get %fund ~" ~)
            %admin  tlo.btn
          ==
      ::
            ^=  hed
          ;div(class "w-full flex flex-col gap-y-3")
            ;*  ?:  ?=(%trib typ.pat)  ~
                :_  ~
                ;p(class "text-red-500 border-red-500 border rounded-md p-3")
                  ; Your pledge is a public (and cryptographically provable) promise
                  ; to contribute funds that is backed by your word as {<src.bol>}.
                  ;span(class "font-bold")
                    ; Further action is required to ensure you maintain a positive
                    ; reputation.
                  ==
                ==
            ;+  =-  ;p: {-}
                ?-    aut
                    %clear
                  ^-  tape  ^~
                  %+  rip  3
                  '''
                  Sign up below with ~tocwex.syndicate’s hosting partner,
                  Red Horizon, to get a free Urbit ID with a hosted instance
                  and preinstalled version of %fund. And of course share
                  this project with your community if you think they might
                  be interested in what it has to offer!
                  '''
                ::
                    %eauth
                  ?:  ?=(%trib typ.pat)
                    ^-  tape  ^~
                    %+  rip  3
                    '''
                    Download `%fund` below to track your contributions,
                    discover new projects, and even run your own
                    crowdfunding campaigns. And of course share this
                    project with your community if you think they might
                    be interested in what it has to offer!
                    '''
                  ^-  tape  ^~
                  %+  rip  3
                  '''
                  In order to best follow through on your pledge, we
                  recommend downloading `%fund` below. This will give
                  you a list of past pledges requiring fulfillment, as
                  well as tools for tracking your contributions,
                  discovering new projects, and even running your own
                  crowdfunding campaigns. And of course share this
                  project with your community if you think they might be
                  interested in what it has to offer!
                  '''
                ::
                    %admin
                  ?:  ?=(%trib typ.pat)
                    ^-  tape  ^~
                    %+  rip  3
                    '''
                    Share this project with your community if you think
                    they might be interested in what it has to offer! If
                    you have any questions or need support of any kind,
                    join other %fund users on the network at
                    ~tocwex/syndicate-public or click the button below.
                    '''
                  ^-  tape  ^~
                  %+  rip  3
                  '''
                  Go to your project funder dashboard to see a list of
                  projects with open pledges requiring a fulfillment
                  transaction. And of course share this project with
                  your community if you think they might be interested
                  in what it has to offer!
                  '''
                ==
          ==
      ::
            ^=  bod
          ;div(class "w-full flex flex-col gap-y-3")
            ;*  =-  %-  welp  :_  ext
                    :~  ;p(class "font-semibold"): {tyt}
                        ;p: {txt}
                        ;p
                          ; To learn more about how `%fund` works, we recommend
                          ;a.text-link/"{hep.syt}": reading the docs.
                        ==
                    ==
                ^=  [ext=marl tyt=tape txt=tape]
                :_  ?:  ?=(%trib typ.pat)
                      :-  "Curious how this works?"
                      ^-  tape  ^~
                      %+  rip  3
                      '''
                      Your funds are now committed to backing this project.
                      In the event the trusted oracle or project worker
                      cancels the project, an on-chain refund will be
                      processed to the address from which you sent the
                      funds. If partial work completion occurs, your refund
                      will be proportional to your relative commitment and
                      the total amount returned to funders.
                      '''
                    :-  "Curious how pledges work in `%fund`?"
                    ^-  tape  ^~
                    %+  rip  3
                    '''
                    Your pledge is a cryptographically attested promise to
                    contribute the associated amount to the project’s smart
                    contract. Other network participants will be able to see
                    if you follow through on your promises, or if you welch
                    on your commitments and they should be more skeptical of
                    your credibility. As a cryptographically-owned identity,
                    and a node in a distributed network, your Urbit ID will
                    begin to accrue a reputation across funding
                    contributions, fulfilled pledges, successfully completed
                    milestones, and so much more. Through a blend of
                    on-chain and off-chain information, as well as public
                    and private relationships, peers in your emergent
                    economic network will develop a subjective understanding
                    of your reputation from their perspective. Every urbit
                    becomes it’s own credit rating agency.
                    '''
                ?-    aut
                    %clear
                  :~  ;p(class "font-semibold")
                        ; Interested in interacting with the various
                        ; project participants?
                      ==
                      ;p: Getting your own urbit will enable you to:
                      ;ul
                        ;li
                          ; Directly message the worker, oracle, and
                          ; funders across a sovereign peer-to-peer
                          ; network
                        ==
                        ;li
                          ; Build a long running reputation across a
                          ; decentralized reputation graph
                        ==
                        ;li
                          ; Run your own sovereign crowdfunding
                          ; campaigns and peer-to-peer economic contracts
                        ==
                  ==  ==
                ::
                    %eauth
                  :~  ;p(class "font-semibold")
                        ; Interested in discovering the full
                        ; capabilities of decentralized crowdfunding?
                      ==
                      ;p: Running your own version of `%fund` will enable you to:
                      ;ul
                        ;li
                          ; Keep track of the different projects to
                          ; which you have contributed or pledged funding
                        ==
                        ;li
                          ; Discover projects from your %pals (coming soon)
                        ==
                        ;li
                          ; Build a long running reputation across a
                          ; decentralized reputation graph
                        ==
                        ;li
                          ; Run your own sovereign crowdfunding
                          ; campaigns and peer-to-peer economic contracts
                        ==
                  ==  ==
                ::
                    %admin
                  :~  ;p(class "font-semibold")
                        ; Interested in expanding your usage of
                        ; decentralized crowdfunding?
                      ==
                      ;p: Running your own version of `%fund` on your planet enables you to:
                      ;ul
                        ;li
                          ; Keep track of the different projects to
                          ; which you have contributed or pledged funding
                        ==
                        ;li
                          ; Discover projects from your %pals (coming soon)
                        ==
                        ;li
                          ; Build a long running reputation across a
                          ; decentralized reputation graph
                        ==
                        ;li
                          ; Run your own sovereign crowdfunding
                          ; campaigns and peer-to-peer economic contracts
                        ==
                      ==
                      ;p
                        ; If you run `%fund` on a star, you will also be
                        ; able to serve as a trusted oracle, where you
                        ; can:
                      ==
                      ;ul
                        ;li
                          ; Review and accept service requests from
                          ; project workers
                        ==
                        ;li
                          ; Approve or reject project milestone work
                          ; reviews
                        ==
                        ;li
                          ; Get paid for serving as a trusted 3rd party
                          ; to a funding campaign
                        ==
                      ==
                  ==
                ==
          ==
      ==
    ==
  ==
--
::  VERSION: [1 4 5]
