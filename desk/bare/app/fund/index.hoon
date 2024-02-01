/+  rudder, *twind-ui
^-  (page:rudder ~ ~)
|_  $:  =bowl:gall
        =order:rudder
        data=~
    ==
++  argue  ::  POST reply
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder ~)
  ~
++  final  ::  POST render
  |=  [done=? =brief:rudder]
  ^-  reply:rudder
  [%auth '/']
++  build  ::  GET
  |=  [args=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %page
  %^  template  q.byk.bowl  "%fund"
  :~  ;main(class "flex flex-col justify-center items-center gap-4 h-full")
        ;h2(class "text-3xl underline"): %fund demo
        ;p: Signed in as {<src.bowl>}
        ;p
          ; Not you?
          ;a(class "text-blue-500", href "/~/login?redirect=/apps/fund"): Log in
        ==
      ==
  ==
--
