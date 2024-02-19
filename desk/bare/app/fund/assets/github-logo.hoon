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
<g clip-path="url(#clip0_296_86)">
<path fill-rule="evenodd" clip-rule="evenodd" d="M12.2716 4C7.69761 4 4 7.66667 4 12.2028C4 15.8288 6.36918 18.8982 9.65587 19.9845C10.0668 20.0662 10.2173 19.808 10.2173 19.5908C10.2173 19.4007 10.2038 18.7488 10.2038 18.0697C7.90281 18.5587 7.42366 17.0918 7.42366 17.0918C7.05388 16.1412 6.50599 15.8968 6.50599 15.8968C5.75289 15.3943 6.56085 15.3943 6.56085 15.3943C7.39623 15.4487 7.83458 16.2363 7.83458 16.2363C8.57397 17.4857 9.76542 17.1327 10.2447 16.9153C10.3131 16.3857 10.5324 16.019 10.7652 15.8153C8.93003 15.6252 6.9992 14.919 6.9992 11.7682C6.9992 10.8718 7.32766 10.1385 7.84813 9.56817C7.76601 9.3645 7.47835 8.52233 7.93041 7.39517C7.93041 7.39517 8.62883 7.17783 10.2036 8.23717C10.8778 8.05761 11.5731 7.96627 12.2716 7.9655C12.97 7.9655 13.6819 8.06067 14.3394 8.23717C15.9143 7.17783 16.6127 7.39517 16.6127 7.39517C17.0648 8.52233 16.777 9.3645 16.6949 9.56817C17.229 10.1385 17.544 10.8718 17.544 11.7682C17.544 14.919 15.6131 15.6115 13.7642 15.8153C14.0656 16.0733 14.3257 16.5622 14.3257 17.3363C14.3257 18.4363 14.3121 19.3192 14.3121 19.5907C14.3121 19.808 14.4628 20.0662 14.8736 19.9847C18.1603 18.898 20.5294 15.8288 20.5294 12.2028C20.543 7.66667 16.8318 4 12.2716 4Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_296_86">
<rect width="16.5926" height="16" fill="black" transform="translate(4 4)"/>
</clipPath>
</defs>
</svg>
'''
--
