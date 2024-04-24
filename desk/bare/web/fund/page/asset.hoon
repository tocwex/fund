::  /web/fund/page/asset/hoon: render an arbitrary asset file (png, svg, etc.)
::
/-  f=fund
/+  rudder, s=server, fh=fund-http
::  FIXME: This doesn't work because /~ only accepts hoon files.
::  /~  asez  mime  /web/fund/asset
::  TODO: Could use %clay .^((list path) %ct %/app/landscape) for something
::  more programmatic, but that loses caching behavior when used naively
::  TODO: Consider breaking out 'style' and 'script' into their own handlers
/*  urbit-logo   %mime  /web/fund/asset/urbit/svg
/*  tocwex-logo  %mime  /web/fund/asset/tocwex/svg
/*  x-logo       %mime  /web/fund/asset/x/svg
/*  github-logo  %mime  /web/fund/asset/github/svg
/*  const-js     %mime  /web/fund/script/const/js
/*  boot-js      %mime  /web/fund/script/boot/js
/*  safe-js      %mime  /web/fund/script/safe/js
/*  fund-css     %mime  /web/fund/style/fund/css
^-  pag-now:f
|_  [bol=bowl:gall ord=order:rudder dat=dat-now:f]
++  argue  |=([header-list:http (unit octs)] !!)
++  final  (alert:rudder url.request.ord build)
++  build
  |=  [arz=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  pat=(pole knot)  (slag:derl:format:fh url.request.ord)
  ?>  ?=([%asset ast=@t ~] pat)
  |^  ?+  ast.pat  [%code 404 'Not found']
        %~.urbit.svg     (svg-reply urbit-logo)
        %~.tocwex.svg    (svg-reply tocwex-logo)
        %~.x.svg         (svg-reply x-logo)
        %~.github.svg    (svg-reply github-logo)
        %~.boot.js       (js-reply boot-js)
        %~.const.js      (js-reply const-js)
        %~.safe.js       (js-reply safe-js)
        %~.fund.css      (css-reply fund-css)
      ==
  ++  png-reply
    |=  =mime
    ^-  reply:rudder
    [%full (%*(. png-response:gen:s cache %.y) +.mime)]
  ++  svg-reply
    |=  =mime
    ^-  reply:rudder
    [%full (%*(. svg-response:gen:s cache %.y) +.mime)]
  ++  css-reply
    |=  =mime
    ^-  reply:rudder
    [%full (%*(. css-response:gen:s cache %.y) +.mime)]
  ++  js-reply
    |=  =mime
    ^-  reply:rudder
    [%full (%*(. js-response:gen:s cache %.y) +.mime)]
  --
--
::  VERSION: [0 1 3]
