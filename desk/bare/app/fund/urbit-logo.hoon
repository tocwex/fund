/+  rudder, *twind-ui, s=server
^-  (page:rudder ~ ~)
|_  [=bowl:gall =order:rudder data=~]
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
  :-  %full
  ^-  simple-payload:http
  %-  %*(. svg-response:gen:s cache %.y)
  %-  as-octs:mimes:html
'''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.00215 14.7922C1.97343 13.1581 2.232 11.844 2.77785 10.8498C3.3237 9.85554 4.03237 9.13203 4.90382 8.67921C5.78488 8.2264 6.71377 8 7.6906 8C8.66739 8 9.55799 8.22148 10.3624 8.66445C11.1764 9.09757 12.1054 9.78171 13.1492 10.7168C13.8578 11.3469 14.4229 11.7898 14.8442 12.0458C15.2752 12.3017 15.7444 12.4297 16.252 12.4297C17.0756 12.4297 17.7267 12.1245 18.2056 11.5142C18.6844 10.894 18.9142 9.99828 18.8951 8.82687H21.9978C22.0266 10.4609 21.768 11.7751 21.2222 12.7693C20.6859 13.7635 19.9772 14.487 19.0962 14.9398C18.2152 15.3926 17.2862 15.619 16.3094 15.619C15.3326 15.619 14.442 15.4025 13.6376 14.9694C12.8331 14.5264 11.9043 13.8373 10.8508 12.9022C10.1517 12.2722 9.58674 11.8292 9.15581 11.5733C8.72483 11.3173 8.2556 11.1894 7.74804 11.1894C6.97236 11.1894 6.33074 11.4699 5.82318 12.031C5.32519 12.5823 5.08579 13.5026 5.10493 14.7922H2.00215Z" fill="black"/>
</svg>
'''
--