import alpineTurboDriveAdapter from 'https://cdn.skypack.dev/alpine-turbo-drive-adapter';
import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo@7.1';
import Alpine from 'https://cdn.skypack.dev/alpinejs@3.x.x';
import { tw, apply, setup } from 'https://cdn.skypack.dev/twind';
import * as colors from 'https://cdn.skypack.dev/twind/colors';
import { css } from 'https://cdn.skypack.dev/twind/css';
import 'https://cdn.skypack.dev/twind/shim';
import {
  http, createConfig, injected, getAccount,
  connect, disconnect, reconnect,
} from 'https://esm.sh/@wagmi/core@2.x';
import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.x/chains';

/// Constants/Helpers ///

const setWalletButton = ({connections, current, status}) => {
  const walletButton = document.querySelector("#connect-wallet");
  const connection = connections.get(current);

  if (status === "disconnected") {
    if (!connection) {
      walletButton.innerHTML = "connect 💰";
    } else {
      reconnect(window.Wagmi, {connector: connection.connector});
    }
  } else if (status === "reconnecting") {
    walletButton.innerHTML = "…loading…";
  } else if (status === "connected") {
    const { address } = getAccount(window.Wagmi);
    walletButton.innerHTML = `${address.slice(0, 5)}…${address.slice(-4)}`;
  }
};

/// First-time Setup ///

const hasLoaded = window.Alpine !== undefined;
if (!hasLoaded) {
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
    (state) => setWalletButton(state),
  );
  // FIXME: If I don't add a timeout, the button's inner html gets overridden
  // by the base page's button value
  window.navigation.addEventListener("navigatesuccess", (event) => {
    setTimeout(() => setWalletButton(window.Wagmi.state), 300);
  });
  window.navigation.addEventListener("currententrychange", (event) => {
    setTimeout(() => setWalletButton(window.Wagmi.state), 300);
  });

  Alpine.start();
}

/// Per-page Setup ///

document.querySelector("#connect-wallet").addEventListener("click", (event) => {
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
