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
          ;link(rel "icon", href "/apps/fund/assets/favicon", type "image/svg+xml");
          ;link(rel "stylesheet", href "https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
          ;link(rel "stylesheet", href "https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist/themes/dark.css");
          ;script(type "module", src "https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.4.0/dist/shoelace-autoloader.js");
          ;script(type "module"): {script-boot}
          ;script(src "/session.js");  ::  debug-only
          ;+  (inject:tonic desk)  ::  debug-only
        ==
        ;+  %:  mx
              %body
              'max-w-screen-2xl mx-auto text-base font-serif'
              ~[[%x-data "twind"]]
              %+  snoc  body
              ;script(type "module"): {script-mark}
            ==
        ::
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
        const walletButton = document.querySelector("#wallet-button");

        if (status === "disconnected") {
          walletButton.innerHTML = "connect wallet";
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

    const walletButton = document.querySelector("#wallet-button");

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
