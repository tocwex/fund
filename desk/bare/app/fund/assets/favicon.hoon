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
<?xml version="1.0" encoding="utf-8"?>
<svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
  <ellipse style="stroke: rgb(0, 0, 0); fill: rgb(255, 255, 255); paint-order: fill; stroke-width: 0px;" cx="512" cy="512" rx="512" ry="512" transform="matrix(1, 0, 0, 1, 1.1368683772161603e-13, 0)"/>
  <g transform="matrix(3.4322540760040283, 0, 0, 3.4322540760040283, 66.40146636962902, 292.3357238769531)" style="">
    <path d="M0.0541 0C70.7217 0.0292317 128 57.3256 128 128C57.3177 128 0.0164917 70.7089 7.62806e-06 0.0305091C7.62851e-06 0.0203397 -4.44317e-10 0.01017 0 0H0.0541Z" fill="#000000"/>
    <line x1="128" y1="96" x2="-8.87604e-09" y2="96" stroke="#ffffff" fill="none" stroke-width="3.653571367382254px" stroke-linecap="square"/>
    <circle cx="64" cy="64" r="16" stroke="#ffffff" fill="none" stroke-width="3.653571367382254px" stroke-linecap="square"/>
  </g>
  <g transform="matrix(3.4322540760040283, 0, 0, 3.4322540760040283, 518.2700195312501, 292.3357238769531)" style="">
    <path d="M64 128H0L5.59506e-06 0L64 5.59506e-06C99.3462 8.68512e-06 128 28.6538 128 64C128 99.3462 99.3462 128 64 128Z" fill="#000000"/>
    <path fill-rule="evenodd" clip-rule="evenodd" d="M80 64C80 72.8366 72.8366 80 64 80C55.1634 80 48 72.8366 48 64C48 55.1634 55.1634 48 64 48C72.8366 48 80 55.1634 80 64ZM64 72C68.4183 72 72 68.4183 72 64C72 59.5817 68.4183 56 64 56C59.5817 56 56 59.5817 56 64C56 68.4183 59.5817 72 64 72Z" fill="#ffffff"/>
  </g>
</svg>
'''
--
