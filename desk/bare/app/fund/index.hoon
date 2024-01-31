/+  *twind-ui
|=  =bowl:gall
^-  manx
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
