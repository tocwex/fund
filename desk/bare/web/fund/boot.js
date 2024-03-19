import alpineTurboDriveAdapter from 'https://cdn.skypack.dev/alpine-turbo-drive-adapter';
import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo@7.1';
import Alpine from 'https://cdn.skypack.dev/alpinejs@3.x.x';
import { tw, apply, setup } from 'https://cdn.skypack.dev/twind';
import * as colors from 'https://cdn.skypack.dev/twind/colors';
import { css } from 'https://cdn.skypack.dev/twind/css';
import 'https://cdn.skypack.dev/twind/shim';
import {
  http, createConfig, injected, getAccount, getClient,
  connect, disconnect, reconnect,
} from 'https://esm.sh/@wagmi/core@2.x';
import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.x/chains';
import { ethers, FallbackProvider, JsonRpcProvider } from 'https://cdn.jsdelivr.net/npm/ethers@6.11.1/+esm';
// import { EthersAdapter } from 'https://cdn.jsdelivr.net/npm/@safe-global/protocol-kit@3.0.1/+esm';
// import safeGlobalapiKit from 'https://cdn.jsdelivr.net/npm/@safe-global/api-kit@2.2.0/+esm';

function clientToProvider(client) {
  const { chain, transport } = client
  const network = {
    chainId: chain.id,
    name: chain.name,
    ensAddress: chain.contracts?.ensRegistry?.address,
  }
  if (transport.type === 'fallback') {
    const providers = (transport.transports).map(
      ({ value }) => new JsonRpcProvider(value?.url, network),
    )
    if (providers.length === 1) return providers[0]
    return new FallbackProvider(providers)
  }
  return new JsonRpcProvider(transport.url, network)
}

/** Action to convert a viem Client to an ethers.js Provider. */
function getEthersProvider(config, {chainId}) {
  const client = getClient(config, {chainId})
  return clientToProvider(client)
}

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
      'fund-butn-wallet': `text-nowrap px-2 py-1 rounded-md duration-300 border-2 border-black text-white bg-black hover:(text-black rounded-md rounded-lg bg-white)`,
      'fund-butn-red': `text-nowrap px-2 py-1 rounded-md text-white border-2 border-red-600 bg-red-600 hover:bg-red-500 disabled:bg-red-200 disabled:border-red-200`,
      'fund-butn-green': `text-nowrap px-2 py-1 rounded-md text-white border-2 border-green-600 bg-green-600 hover:bg-green-500 disabled:bg-green-200 disabled:border-green-200`,
      'fund-butn-black': `text-nowrap px-2 py-1 rounded-md text-white  border-2 border-black bg-black hover:bg-gray-800 disabled:bg-gray-200 disabled:border-gray-200`,
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
  // https://turbo.hotwired.dev/reference/events#turbo%3Arender
  document.addEventListener("turbo:render", (event) => {
    setWalletButton(window.Wagmi.state);
  });

  // console.log(getEthersProvider(window.Wagmi, {chainId: sepolia.id}));

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
