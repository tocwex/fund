import alpineTurboDriveAdapter from 'https://cdn.skypack.dev/alpine-turbo-drive-adapter';
import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo@7.1';
import Alpine from 'https://cdn.skypack.dev/alpinejs@v3.13.9';
import { tw, apply, setup } from 'https://cdn.skypack.dev/twind';
import * as colors from 'https://cdn.skypack.dev/twind/colors';
import { css } from 'https://cdn.skypack.dev/twind/css';
import 'https://cdn.skypack.dev/twind/shim';
import {
  http, createConfig, injected,
  connect, disconnect, reconnect,
  getAccount,
} from 'https://esm.sh/@wagmi/core@2.x';
import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.x/chains';
import { RPC } from './const.js';

if (window.Alpine === undefined) {
  setup({
    theme: {
      fontFamily: {
        serif: ['Poppins', 'Noto Emoji', 'serif'],
        sans: ['Noto Emoji', 'sans-serif'],
        mono: ['Roboto Mono', 'mono'],
      },
      extend: { colors },
    },
    // FIXME: This should ultimately be in some sort of CSS file that can be
    // replaced by the user for custom styling
    // FIXME: Some of the override styling (e.g. 'p-1' for input/textarea) is
    // being overridden by twind's *own* preflight; need to disable this somehow
    // - https://github.com/tw-in-js/twind/issues/221
    preflight: (preflight, {theme}) => ({
      ...preflight,
      input: apply`w-full p-1 rounded-md bg-gray-200 placeholder-gray-400 border-2 border-gray-200 disabled:(border-gray-400 bg-gray-400) read-only:(border-gray-400 bg-gray-400)`,
      textarea: apply`w-full p-1 rounded-md bg-gray-200 placeholder-gray-400 border-2 border-gray-200 disabled:(border-gray-400 bg-gray-400) read-only:(border-gray-400 bg-gray-400)`,
      select: apply`w-full p-1 rounded-md bg-gray-200 placeholder-gray-400 border-2 border-gray-200 disabled:(border-gray-400 bg-gray-400)`,
      label: apply`text-black font-light py-1`,
    }),
    // FIXME: Recursive style embeddings don't seem to work with the shim; may
    // need to use `tw(...)` directly to refactor beyond 1 level
    plugins: {
      'fund-pill': `text-nowrap px-2 py-1 border-2 rounded-full`,
      'fund-tytl-link': `text-xl font-medium duration-300 hover:text-yellow-500`,
      'fund-form-group': `flex flex-col-reverse w-full p-1 gap-1`,
      'fund-butn-link': `text-nowrap px-2 py-1 rounded-md duration-300 border-2 border-black hover:(rounded-lg bg-yellow-400 border-yellow-400)`,
      'fund-butn-effect': `text-nowrap px-2 py-1 rounded-md duration-300 border-2 border-black text-white bg-black hover:(text-black rounded-md rounded-lg bg-white)`,
      'fund-butn-red': `text-nowrap px-2 py-1 rounded-md text-white border-2 border-red-600 bg-red-600 hover:bg-red-500 disabled:bg-red-200 disabled:border-red-200`,
      'fund-butn-green': `text-nowrap px-2 py-1 rounded-md text-white border-2 border-green-600 bg-green-600 hover:bg-green-500 disabled:bg-green-200 disabled:border-green-200`,
      'fund-butn-black': `text-nowrap px-2 py-1 rounded-md text-white  border-2 border-black bg-black hover:bg-gray-800 disabled:bg-gray-200 disabled:border-gray-200`,
      'fund-odit-ther': `w-full flex h-8 text-white border-2 border-black`,
      'fund-odit-sect': `h-full flex justify-center items-center text-center`,
    },
  });

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

  function copyTextToClipboard(text, sel = "") {
    if (!navigator.clipboard) {
      fallbackCopyTextToClipboard(text);
      return;
    }
    navigator.clipboard.writeText(text).then(function() {
      console.log('Async: Copying to clipboard was successful!');
    }, function(err) {
      console.error('Async: Could not copy text: ', err);
    });

    if (sel !== "") {
      const button = document.querySelector(sel);
      const oldHTML = button.innerHTML;
      button.innerHTML = "copied ✔️";
      setTimeout(() => {button.innerHTML = oldHTML;}, 2000);
    }
  }

  window.Wagmi = createConfig({
    chains: [mainnet, sepolia],
    connectors: [injected()],
    transports: {
      [mainnet.id]: http(RPC.MAINNET),
      [sepolia.id]: http(RPC.SEPOLIA),
    },
  });
  window.Wagmi.subscribe(
    (state) => state,
    (state) => setWalletButton(state),
  );
  // https://turbo.hotwired.dev/reference/events#turbo%3Aload
  document.addEventListener("turbo:load", (event) => {
    setWalletButton(window.Wagmi.state);
    document.querySelector("#fund-butn-wallet").addEventListener("click", (event) => {
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
  });

  const setWalletButton = ({connections, current, status}) => {
    const walletButton = document.querySelector("#fund-butn-wallet");
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

  Alpine.start();
}
