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
  |^  [%page (template q.byk.bowl "%fund" render)]
  ++  render
    :~  ;main(class "flex flex-col justify-center items-center gap-4 h-full")
          ;h2(class "text-3xl underline"): %fund demo
          ;p: Signed in as {<src.bowl>}
          ;sl-dialog(label "Progress Demo", class "dialog-overview")
            ;div(class "w-full h-6 flex text-center")
              ;div(class "w-1/6 h-full bg-red-600"): 15%
              ;div(class "w-1/3 h-full bg-blue-600"): 30%
              ;div(class "w-1/2 h-full bg-gray-600");
            ==
            ;sl-button(slot "footer", variant "primary"): Dismiss
          ==
          ;sl-button: Show Demo
          ;p
            ; Not you?
            ;a(class "text-blue-500", href "/~/login?redirect=/apps/fund"): Log in
          ==
        ==
        ;script(type "module"): {script}
    ==
  ++  script
    """
    const dialog = document.querySelector('.dialog-overview');
    const openButton = dialog.nextElementSibling;
    const closeButton = dialog.querySelector('sl-button[slot="footer"]');

    openButton.addEventListener('click', () => dialog.show());
    closeButton.addEventListener('click', () => dialog.hide());
    """
  --
--
