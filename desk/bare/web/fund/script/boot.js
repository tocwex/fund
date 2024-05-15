import alpineTurboDriveAdapter from 'https://cdn.skypack.dev/alpine-turbo-drive-adapter';
import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo@7.1';
import Alpine from 'https://cdn.skypack.dev/alpinejs@v3.13.9';
import * as twind from 'https://cdn.jsdelivr.net/npm/@twind/core@1.1.3/+esm';
import presetTwind from 'https://cdn.jsdelivr.net/npm/@twind/preset-tailwind@1.1.4/+esm';
import presetLineClamp from 'https://cdn.jsdelivr.net/npm/@twind/preset-line-clamp@1.0.7/+esm';
import presetAutoPrefix from 'https://cdn.jsdelivr.net/npm/@twind/preset-autoprefix@1.0.7/+esm';
import {
  http, createConfig, injected,
  connect, disconnect, reconnect, getAccount,
} from 'https://esm.sh/@wagmi/core@2.x';
import { fromHex } from 'https://esm.sh/viem@2.x';
import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.x/chains';
// import { marked } from "https://cdn.jsdelivr.net/npm/marked/lib/marked.esm.js";
// import DOMPurify from 'https://cdn.jsdelivr.net/npm/dompurify@3.1.3/+esm'
import * as SAFE from './safe.js';
import { FUND_SIGN_ADDR } from './config.js';
import { NETWORK } from './const.js';

if (window.Alpine === undefined) {
  twind.install({
    presets: [
      presetTwind(),
      presetLineClamp(),
      presetAutoPrefix(),
    ],
    theme: {
      fontFamily: {
        serif: ['Poppins', 'Noto Emoji', 'serif'],
        sans: ['Noto Emoji', 'sans-serif'],
        mono: ['Roboto Mono', 'mono'],
      },
    },
    // TODO: Still need to work on overrides from base preflight;
    // should be able to apply p-4 to textarea and it should work...
    // TODO: It would be great to put this all in a CSS file that
    // was loaded by this file or the browser and then injected here
    // TODO: Still need to fix ol,ul; at least it's easier
    preflight: twind.css(`
      form {
        @apply mb-0;
      }
      ol,ul {
        @apply list-outside;
      }
      ol {
        @apply list-decimal;
      }
      ul {
        @apply list-disc;
      }
      textarea,select,input {
        @apply fund-input;
      }
      blockquote {
        @apply p-2 bg-gray-200 bg-opacity-50 border-l-4 border-gray-800;
      }
      code {
        @apply font-mono bg-gray-200 rounded-md py-0.5 px-1.5;
      }
      label {
        @apply text-black font-light py-1;
      }
    `),
    rules: [
      ['text-nowrap', {'text-wrap': 'nowrap'}], // FIXME: Not defined in twind
      ['fund-link', {'color': '-webkit-link', 'text-decoration': 'underline'}],
      ['fund-pill', 'text-nowrap px-2 py-1 border-2 rounded-full'],
      ['fund-input', 'w-full p-1 rounded-md bg-gray-200 placeholder-gray-400 border-2 border-gray-200 disabled:(border-gray-400 bg-gray-400) read-only:(border-gray-400 bg-gray-400)'],
      ['fund-tytl-link', 'text-xl font-medium duration-300 hover:text-yellow-500'],
      ['fund-form-group', 'flex flex-col-reverse w-full p-1 gap-1'],
      ['fund-butn-base', 'text-nowrap px-2 py-1 rounded-md border-2'],
      ['fund-butn-link', 'fund-butn-base border-black duration-300 hover:(rounded-lg bg-yellow-400 border-yellow-400)'],
      ['fund-butn-effect', 'fund-butn-base border-black duration-300 text-white bg-black hover:(text-black rounded-md rounded-lg bg-white)'],
      ['fund-butn-red', 'fund-butn-base text-white border-red-600 bg-red-600 hover:bg-red-500 disabled:bg-red-200 disabled:border-red-200'],
      ['fund-butn-green', 'fund-butn-base text-white border-green-600 bg-green-600 hover:bg-green-500 disabled:bg-green-200 disabled:border-green-200'],
      ['fund-butn-black', 'fund-butn-base text-white border-black bg-black hover:bg-gray-800 disabled:bg-gray-200 disabled:border-gray-200'],
      ['fund-odit-ther', 'w-full flex h-8 text-white border-2 border-black'],
      ['fund-odit-sect', 'h-full flex justify-center items-center text-center'],
    ],
  });

  // setup({
  //   theme: {
  //     fontFamily: {
  //       serif: ['Poppins', 'Noto Emoji', 'serif'],
  //       sans: ['Noto Emoji', 'sans-serif'],
  //       mono: ['Roboto Mono', 'mono'],
  //     },
  //     extend: { colors },
  //   },
  //   // FIXME: This should ultimately be in some sort of CSS file that can be
  //   // replaced by the user for custom styling
  //   // FIXME: Some of the override styling (e.g. 'p-1' for input/textarea) is
  //   // being overridden by twind's *own* preflight; need to disable this somehow
  //   // - https://github.com/tw-in-js/twind/issues/221
  //   preflight: (preflight, {theme}) => {
  //     const preflightEdits = {
  //       // "ol,ul": undefined,
  //       // "h1,h2,h3,h4,h5,h6": undefined,
  //       // "fieldset,ol,ul,legend": undefined,
  //       // "fieldset,legend": { padding: '0' },
  //     };
  //     return (css(Object.assign({}, preflight, preflightEdits), {
  //       form: apply`mb-0`, // NOTE: Needed to override "margin-block-end" rule in Chrome browsers
  //       ul: apply`list-disc`,
  //       ol: apply`list-decimal`,
  //       blockquote: apply`p-2 bg-gray-200 bg-opacity-50 border-l-4 border-gray-800`,
  //       input: apply`fund-input`,
  //       textarea: apply`fund-input`,
  //       select: apply`fund-input`,
  //       label: apply`text-black font-light py-1`,
  //       code: apply`font-mono bg-gray-200 rounded-md py-0.5 px-1.5`,
  //     }));
  //   },
  //   plugins: {
  //     // FIXME: Custom implementation based on (not working) plugin:
  //     // https://www.npmjs.com/package/@twind/preset-line-clamp
  //     'line-clamp': (parts) => ({
  //       overflow: 'hidden',
  //       display: '-webkit-box',
  //       '-webkit-box-orient': 'vertical',
  //       '-webkit-line-clamp': `${parts[0]}`,
  //     }),
  //     'fund-link': (parts) => ({
  //       'color': '-webkit-link',
  //       'text-decoration': 'underline',
  //     }),
  //     'fund-pill': apply`text-nowrap px-2 py-1 border-2 rounded-full`,
  //     'fund-input': apply`w-full p-1 rounded-md bg-gray-200 placeholder-gray-400 border-2 border-gray-200 disabled:(border-gray-400 bg-gray-400) read-only:(border-gray-400 bg-gray-400)`,
  //     'fund-tytl-link': apply`text-xl font-medium duration-300 hover:text-yellow-500`,
  //     'fund-form-group': apply`flex flex-col-reverse w-full p-1 gap-1`,
  //     'fund-butn-base': apply`text-nowrap px-2 py-1 rounded-md border-2 border-black`,
  //     'fund-butn-link': apply`fund-butn-base duration-300 hover:(rounded-lg bg-yellow-400 border-yellow-400)`,
  //     'fund-butn-effect': apply`fund-butn-base duration-300 text-white bg-black hover:(text-black rounded-md rounded-lg bg-white)`,
  //     'fund-butn-red': apply`fund-butn-base text-white border-red-600 bg-red-600 hover:bg-red-500 disabled:bg-red-200 disabled:border-red-200`,
  //     'fund-butn-green': apply`fund-butn-base text-white border-green-600 bg-green-600 hover:bg-green-500 disabled:bg-green-200 disabled:border-green-200`,
  //     'fund-butn-black': apply`fund-butn-base text-white border-black bg-black hover:bg-gray-800 disabled:bg-gray-200 disabled:border-gray-200`,
  //     'fund-odit-ther': apply`w-full flex h-8 text-white border-2 border-black`,
  //     'fund-odit-sect': apply`h-full flex justify-center items-center text-center`,
  //   },
  // });

  // marked.use({
  //   gfm: true,
  //   breaks: false,
  //   renderer: {
  //     link: (href, title, text) => {
  //       const anchElem = document.createElement("a");
  //       anchElem.setAttribute("class", "fund-link");
  //       anchElem.setAttribute("href", href);
  //       if (title) anchElem.setAttribute("title", title);
  //       anchElem.innerHTML = text;
  //       return anchElem.outerHTML;
  //     },
  //     code: (code, info, escaped) => {
  //       const preElem = document.createElement("pre");
  //       preElem.setAttribute("class", "min-w-full inline-block");
  //       const codElem = document.createElement("code");
  //       codElem.setAttribute("class", "block py-2 px-3");
  //       codElem.innerText = code;
  //       preElem.appendChild(codElem);
  //       return preElem.outerHTML;
  //     },
  //     image: (href, title, text) => {
  //       const imagElem = document.createElement("img");
  //       imagElem.setAttribute("class", "mx-auto border-2 border-black"); // w-full
  //       imagElem.setAttribute("src", href);
  //       if (text) imagElem.setAttribute("alt", text);
  //       if (title) imagElem.setAttribute("title", title);
  //       return imagElem.outerHTML;
  //     },
  //   },
  // });

  window.Alpine = Alpine;
  function tws(parts) {
    const styles = Object.entries(parts).reduce((obj, [part, value]) => {
      obj[`&::part(${part})`] = {'@apply': value};
      return obj;
    }, {});
    return css(styles);
  }
  function cmd() {
    return twind.css({
      '& h1': {'@apply': 'text-2xl font-bold'},
      '& h2': {'@apply': 'text-xl font-semibold'},
      '& h3': {'@apply': 'text-lg font-semibold'},
      '& h4': {'@apply': 'underline font-medium italic'},
      '& h5': {'@apply': 'underline font-medium italic'},
      '& h6': {'@apply': 'underline italic'},
    });
  }

  document.addEventListener('alpine:init', () => Alpine.data('fund', () => ({
    tws,
    cmd,
    copyText: copyTextToClipboard,
    copyPURL: copyProjectURL,
    swapText: swapContent,
    sendForm: submitForm,
    checkWallet,
    // marked,
    // DOMPurify,
    ...SAFE, // FIXME: Makes 'safe.js' available to inline/non-module scripts
  })));

  function swapContent(elem, text) {
    if (elem.getAttribute("data-text") === null) {
      elem.setAttribute("data-text", elem.innerText);
    }
    elem.innerText = text;
    setTimeout(() => {elem.innerText = elem.getAttribute("data-text");}, 2000);
  }

  function copyProjectURL() {
    copyTextToClipboard(window.location.toString().replace(
      /\/((project)|(next))\/(~[^\/]+)\/([^\/]+).*/,
      "/project/$4/$5",
    ));
  }

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

  function submitForm(event, checks = [], action = Promise.resolve(undefined)) {
    event.preventDefault();
    if ((event.target.form !== undefined) && !event.target.form.reportValidity()) {
      return Promise.resolve(undefined);
    } else {
      event.target.insertAdjacentHTML("beforeend", "<span class='animate-ping'>⏳</span>");
      return new Promise((resolve, reject) => {
        try {
          checks.forEach(check => check());
          resolve();
        } catch(error) {
          reject(error);
        }
      }).then(action).then(formData => {
        const form = document.createElement("form");
        form.method = "post";
        form.setAttribute("class", "hidden");
        const button = event.target.cloneNode(true);
        form.appendChild(button);

        const appendInput = ([key, value]) => {
          const field = document.createElement("input");
          field.name = key;
          field.value = value;
          form.appendChild(field);
        };
        Object.entries(formData).forEach(appendInput);
        if (event.target.form !== undefined) {
          [...(new FormData(event.target.form).entries())].forEach(appendInput);
        }

        document.body.appendChild(form);
        form.requestSubmit(button);
      }).catch((error) => {
        event.target.innerHTML = "error ✗";
        console.log(error);
        alert(error.message);
      });
    }
  }

  function checkWallet(expectedAddresses, roleTitle) {
    const { address: currentAddress } = SAFE.safeGetAccount();
    if (
      !expectedAddresses
        .concat([FUND_SIGN_ADDR])
        .map(address => fromHex(address, "bigint"))
        .includes(fromHex(currentAddress, "bigint"))
    )
      throw new Error(`connected wallet is not the ${roleTitle} wallet for this project; please connect one of the follwing wallets to continue:\n${expectedAddresses.join("\n")}`);
  }

  window.Wagmi = createConfig({
    chains: [mainnet, sepolia],
    connectors: [injected()],
    transports: {
      [mainnet.id]: http(NETWORK.RPC.MAINNET),
      [sepolia.id]: http(NETWORK.RPC.SEPOLIA),
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
