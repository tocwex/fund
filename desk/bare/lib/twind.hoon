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
  |=  [=bowl:gall tytl=tape body=marl]
  ^-  manx
  =/  is-authed=bean
    =+  peers=.^((map ship ?(%alien %known)) /ax/(scot %p our.bowl)//(scot %da now.bowl)/peers)
    ?|  !=((clan:title src.bowl) %pawn)
        (~(has by peers) src.bowl)
    ==
  |^  ;html
        ;head
          ;meta(charset "UTF-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
          ;title: {tytl}
          ;link(rel "icon", href "/apps/fund/assets/favicon", type "image/svg+xml");
          ;link(rel "preconnect", href "https://fonts.googleapis.com");
          ;link(rel "preconnect", href "https://fonts.gstatic.com", crossorigin "");
          ;link(rel "stylesheet preload", as "style", href "https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap", crossorigin "");
          ;link(rel "stylesheet preload", as "style", href "https://fonts.googleapis.com/css2?family=Noto+Emoji:wght@300..700&display=swap", crossorigin "");
          ;link(rel "stylesheet", href "https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist/themes/light.css");
          ;script(type "module", src "https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist/shoelace-autoloader.js");
          ;script(type "module"): {script-boot}
          ;script(src "/session.js");  ::  debug-only
          ;+  (inject:tonic q.byk.bowl)  ::  debug-only
        ==
        ;+  %:  mx
              %body
              'max-w-screen-2xl mx-auto text-base font-serif'
              ~[[%x-data "twind"] [%style "visibility: hidden;"]]
              :(welp head body foot)
            ==
      ==
  ++  head
    ^-  marl
    ::  TODO: Add back button from non-home pages (will need to know
    ::  current path)
    :~  ;nav(class "lg:mx-4 mt-1.5 mb-2")
          ;ul(class "py-2 flex justify-between border-black border-b-2")
            ;div(class "mx-2")
              ;div(onclick "location.href='/apps/fund/'", class "flex items-center gap-x-2 text-xl border-2 rounded-sm border-white ease-in-out hover:text-yellow-500 duration-300 font-medium")
                ::  ;img(type "image/svg+xml", src "/apps/fund/assets/favicon", class "h-10 rounded-full border-4");
                ; %fund
              ==
            ==
            ;div(class "flex gap-x-2 mx-2")
              ::  FIXME: Opening login page in a new tab because opening it
              ::  in the current tab causes issues with further redirects
              ::  (e.g. to the ship login page for eAuth)
              ::  FIXME: This should redirect to the current route
              ::  instead of the base app route
              ;button(id "login-urbit", class "text-nowrap px-2 py-1 border-2 border-black rounded-md {?:(is-authed "" "duration-300 hover:rounded-lg hover:bg-yellow-400 hover:border-yellow-400 active:bg-yellow-500 active:border-yellow-500")}")
                ;+  ?.  is-authed
                    ;a(href "/~/login?redirect=/apps/fund", target "_blank"): urbit login
                  ;p: {<src.bowl>}
              ==
              ;button(id "connect-wallet", class "cursor-pointer text-nowrap px-2 py-1 border-2 duration-300 border-black bg-black text-white hover:text-black rounded-md hover:rounded-lg hover:bg-white hover:border-gray-800 active:bg-gray-800 active:border-black active:text-white");
            ==
          ==
        ==
    ==
  ++  foot
    ^-  marl
    :~  ;footer(class "lg:mx-4")
          ;div(class "justify-center border-t-2 border-black pt-2 pb-1 lg:flex lg:flex-row-reverse lg:items-center lg:justify-between")
            ;div(class "flex justify-center grow lg:grow-0 lg:justify-end lg:p-2")
              ;div(class "px-10 lg:px-2")
                ;a(href "https://tlon.network/lure/~tocwex/syndicate-public", target "_blank")
                  ;img(type "image/svg+xml", src "/apps/fund/assets/urbit-logo");
                ==
              ==
              ;div(class "px-10 lg:px-2")
                ;a(href "https://twitter.com/tocwex", target "_blank")
                  ;img(type "image/svg+xml", src "/apps/fund/assets/x-logo");
                ==
              ==
              ;div(class "px-10 lg:px-2")
                ;a(href "https://github.com/tocwex", target "_blank")
                  ;img(type "image/svg+xml", src "/apps/fund/assets/github-logo");
                ==
              ==
            ==
            ;div(class "mb-0 mt-2 text-center text-xs lg:text-base lg:m-0 lg:p-1 lg:pb-2")
              ;div(class "mb-2 lg:mb-0 justify-center flex flex-row items-center lg:justify-start lg:px-3 hover:underline")
                ;a(href "https://tocwexsyndicate.com", target "_blank")
                  ; crafted by ~tocwex.syndicate
                ==
              ==
            ==
          ==
        ==
        ;script(type "module"): {script-mark}
    ==
  ++  script-boot
    ^~
    %-  trip
    '''
    import alpineTurboDriveAdapter from 'https://cdn.skypack.dev/alpine-turbo-drive-adapter';
    import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo@7.1';
    import Alpine from 'https://cdn.skypack.dev/alpinejs@3.x.x';
    import { tw, apply, setup } from 'https://cdn.skypack.dev/twind';
    import * as colors from 'https://cdn.skypack.dev/twind/colors';
    import { css } from 'https://cdn.skypack.dev/twind/css';
    import 'https://cdn.skypack.dev/twind/shim';
    import { http, createConfig, injected, getAccount } from 'https://esm.sh/@wagmi/core@2.x';
    import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.x/chains';

    // FIXME: Use a small timeout to avoid seeing css animation pop-in
    // TODO: Would love to use a slightly more principled solution (one not
    // dependent on a static max timeout length), e.g.:
    // https://stackoverflow.com/a/38296629
    window.addEventListener("load", (event) =>
      setTimeout(() => {
        document.body.style["visibility"] = "visible";
      }, 300)
    );

    setup({
      theme: {
        fontFamily: {
          serif: ['Poppins', 'Noto Emoji', 'serif'],
          sans: ['Noto Emoji', 'sans-serif'],
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

    window.Wagmi = createConfig({
      chains: [mainnet, sepolia],
      connectors: [injected()],
      transports: {
        [mainnet.id]: http(),
        [sepolia.id]: http(),
      },
    });
    window.Wagmi.subscribe(
      (state) => state,
      ({connections, current, status}) => {
        const connection = connections.get(current);
        const walletButton = document.querySelector("#connect-wallet");

        if (status === "disconnected") {
          walletButton.innerHTML = "connect 💰";
        } else if (status === "reconnecting") {
          walletButton.innerHTML = "…loading…";
        } else if (status === "connected") {
          const { address } = getAccount(window.Wagmi);
          walletButton.innerHTML = `${address.slice(0, 5)}…${address.slice(-4)}`;
        }
      },
    );

    Alpine.start();
    '''
  ++  script-mark
    ^~
    %-  trip
    '''
    import {
      connect,
      disconnect,
      reconnect,
      getAccount,
    } from 'https://esm.sh/@wagmi/core@2.x';

    const walletButton = document.querySelector("#connect-wallet");

    // NOTE: This enables auto-reconnect on page refresh when a valid existing
    // Ethereum wallet connection exists.
    const { status, current, connections } = window.Wagmi.state;
    const connection = connections.get(current);
    if (status === "disconnected" && connection) {
      reconnect(window.Wagmi, {connector: connection.connector});
    }

    walletButton.addEventListener("click", (event) => {
      const { status, current, connections } = window.Wagmi.state;
      const connection = connections.get(current);

      if (status === "disconnected") {
        if (connection) {
          reconnect(window.Wagmi, {connector: connection.connector});
        } else {
          connect(window.Wagmi, {connector: Wagmi.connectors[0]});
        }
      } else if (status === "connected") {
        // FIXME: Actually calling disconnects tells MetaMask to stop giving
        // this site permission to the associated wallets. Is there any way to
        // soft disconnect the wallet, i.e. set its status to disconnected without
        // removing it?
        disconnect(window.Wagmi, {connector: connection.connector});
      }
    });
    '''
  --
--
