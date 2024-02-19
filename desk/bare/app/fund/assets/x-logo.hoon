/-  f=fund
/+  rudder, tw=twind, s=server
^-  pag-now:f
|_  [=bowl:gall =order:rudder data=dat-now:f]
++  argue  ::  POST reply
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder act-now:f)
  ~
++  final  ::  POST render
  |=  [done=? =brief:rudder]
  ^-  reply:rudder
  [%auth '/']
++  build  ::  GET
  |=  [args=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  :-  %full
  ^-  simple-payload:http
  %-  %*(. svg-response:gen:s cache %.y)
  %-  as-octs:mimes:html
'''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_296_83)">
<path d="M13.2841 10.7714L19.0916 4H17.7154L12.6728 9.87954L8.64526 4H4L10.0904 12.8909L4 19.9918H5.37626L10.7014 13.7828L14.9547 19.9918H19.6L13.2838 10.7714H13.2841ZM11.3991 12.9692L10.7821 12.0839L5.87214 5.03921H7.986L11.9484 10.7245L12.5654 11.6098L17.716 18.9998H15.6022L11.3991 12.9696V12.9692Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_296_83">
<rect width="15.6" height="16" fill="black" transform="translate(4 4)"/>
</clipPath>
</defs>
</svg>
'''
--
