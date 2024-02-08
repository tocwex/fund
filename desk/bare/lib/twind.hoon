::  twind: utilities for generating manx w/ tailwindcss and shoelace
::
::  TODO:
::  - Consider making `render` more generic by allowing for the
::    insertion of arbitrary setup JS and template headers
::
/+  tonic
|%
++  mx
  |=  [hed=@tas class=@t =mart =marl]
  ^-  manx
  [[hed (welp ~[[`@tas`':class' "tw`{(trip class)}`"]] mart)] marl]
::
++  render
  |=  [desk=term title=tape body=marl]
  ^-  manx
  |^  ;html
        ;head
          ;meta(charset "UTF-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
          ;title: {title}
          ::  FIXME: The icon here needs to be updated
          ;link(rel "icon", href "/apps/fund/assets/urbit-logo", type "image/svg+xml");
          ;link(rel "stylesheet", href "https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
          ;link(rel "stylesheet", href "https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist/themes/dark.css");
          ;script(type "module", src "https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist/shoelace-autoloader.js");
          ;script(type "module"): {setup}
          ;script(src "/session.js");  ::  debug-only
          ;+  (inject:tonic desk)  ::  debug-only
        ==
        ;+  %:  mx
              %body
              'max-w-screen-2xl mx-auto text-base font-serif'
              ~[[%x-data "twind"]]
              body
            ==
        ::
      ==
  ++  setup
    ^~
    %-  trip
    '''
    import alpineTurboDriveAdapter from 'https://cdn.skypack.dev/alpine-turbo-drive-adapter';
    import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo@7.1';
    import Alpine from 'https://cdn.skypack.dev/alpinejs@3.x.x'
    import { tw, apply, setup } from 'https://cdn.skypack.dev/twind'
    import * as colors from 'https://cdn.skypack.dev/twind/colors'
    import { css } from 'https://cdn.skypack.dev/twind/css'
    import 'https://cdn.skypack.dev/twind/shim'

    setup({
      theme: {
        fontFamily: {
          serif: ['Poppins', 'serif'],
          sans: 'sans-serif',
        },
        extend: {
          colors,
        },
      },
    })

    window.Alpine = Alpine;
    const tws = (parts) => {
      const styles = Object.entries(parts).reduce((obj, [part, value]) => {
        obj[`&::part(${part})`] = css(apply(value))

        return obj;
      }, {});
      return () => styles;
    }

    document.addEventListener('alpine:init', () => {
      Alpine.data('twind', () => ({
        tw,
        tws,
        copy: copyTextToClipboard,
      }));
    });

    function fallbackCopyTextToClipboard(text) {
      var textArea = document.createElement("textarea");
      textArea.value = text;

      // Avoid scrolling to bottom
      textArea.style.top = "0";
      textArea.style.left = "0";
      textArea.style.position = "fixed";

      document.body.appendChild(textArea);
      textArea.focus();
      textArea.select();

      try {
        var successful = document.execCommand('copy');
        var msg = successful ? 'successful' : 'unsuccessful';
        console.log('Fallback: Copying text command was ' + msg);
      } catch (err) {
        console.error('Fallback: Oops, unable to copy', err);
      }

      document.body.removeChild(textArea);
    }

    function copyTextToClipboard(text) {
      if (!navigator.clipboard) {
        fallbackCopyTextToClipboard(text);
        return;
      }
      navigator.clipboard.writeText(text).then(function() {
        console.log('Async: Copying to clipboard was successful!');
      }, function(err) {
        console.error('Async: Could not copy text: ', err);
      });
    }

    Alpine.start();
    '''
  --
--
