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
import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3';
import DOMPurify from 'https://cdn.jsdelivr.net/npm/dompurify@3.1.3/+esm'
import * as SAFE from './safe.js';
import { FUND_SIGN_ADDR } from './config.js';
import { CONTRACT, NETWORK } from './const.js';

if (window.Alpine === undefined) {
  twind.install({
    presets: [
      presetTwind(),
      presetLineClamp(),
      presetAutoPrefix(),
    ],
    theme: {
      fontFamily: {
        serif: ['Lora', 'Noto Emoji', 'serif'],
        sans: ['Inter', 'Noto Emoji', 'sans-serif'],
        mono: ['Ubuntu Mono', 'mono'],
      },
      extend: {
        colors: {
          primary: {
            100: '#ffffff',
            150: '#fcfcfa',
            200: '#f8f8f5',
            250: '#f5f5f0',
            300: '#f1f1eb',
            350: '#eeeee7',
            400: '#ebebe2',
            450: '#e7e7dd',
            500: '#e4e4d8',
            550: '#cdcdb7',
            600: '#b6b696',
            650: '#a0a076',
            700: '#83835b',
            750: '#626244',
            800: '#41412d',
            850: '#212117',
            900: '#090909',
          },
          secondary: {
            100: '#ffffff',
            150: '#cfdcf2',
            200: '#9eb8e5',
            250: '#6e95d8',
            300: '#3e72cc',
            350: '#2b56a1',
            400: '#1e3c71',
            450: '#112240',
            500: '#04080f',
            550: '#04080e',
            600: '#03060c',
            650: '#03050a',
            700: '#020408',
            750: '#020306',
            800: '#010204',
            850: '#010102',
            900: '#090909',
          },
          tertiary: {
            100: '#ffffff',
            150: '#dff0f2',
            200: '#bfe1e6',
            250: '#7fc3cc',
            300: '#7fc3cc',
            350: '#5fb4bf',
            400: '#45a1ad',
            450: '#38838d',
            500: '#2c666e',
            550: '#265960',
            600: '#214c52',
            650: '#1b4044',
            700: '#163337',
            750: '#102629',
            800: '#0b191b',
            850: '#050d0e',
            900: '#090909',
          },
          highlight1: {
            100: '#ffffff',
            150: '#fddad9',
            200: '#fbb5b4',
            250: '#fa908e',
            300: '#f86a68',
            350: '#f64542',
            400: '#f4201d',
            450: '#df0e0a',
            500: '#b80c09',
            550: '#a20a08',
            600: '#8b0907',
            650: '#740705',
            700: '#5d0604',
            750: '#450403',
            800: '#2e0302',
            850: '#170101',
            900: '#090909',
          },
          highlight2: {
            100: '#ffffff',
            150: '#e7f5e1',
            200: '#d0eac4',
            250: '#b8e0a6',
            300: '#a1d588',
            350: '#89cb6a',
            400: '#71c04d',
            450: '#5ea93c',
            500: '#4d8b31',
            550: '#447a2b',
            600: '#3a6925',
            650: '#31571f',
            700: '#274619',
            750: '#1d3412',
            800: '#13230c',
            850: '#0a1106',
            900: '#090909',
          },
          gray: {
            100: '#ffffff',
            150: '#f0f0f0',
            200: '#e0e0e0',
            250: '#d0d0d0',
            300: '#c0c0c0',
            350: '#b0b0b0',
            400: '#a0a0a0',
            450: '#909090',
            500: '#808080',
            550: '#707070',
            600: '#606060',
            650: '#505050',
            700: '#404040',
            750: '#303030',
            800: '#202020',
            850: '#101010',
            900: '#000000',
          },
        },
      },
    },
    // TODO: It would be great to put this all in a CSS file that
    // was loaded by this file or the browser and then injected here
    preflight: twind.css(`
      form { margin: unset; }
      select { padding: unset; @apply fund-select; }
      textarea,input { padding: unset; @apply fund-input; }
      label { @apply font-light py-1; }
    `),
    rules: [
      ['text-nowrap', {'text-wrap': 'nowrap'}], // FIXME: Not defined in twind
      ['fund-pill', 'text-nowrap px-2 py-1 border-2 rounded-full'],
      ['fund-loader', 'w-full p-1 text-xl text-center animate-ping'],
      ['fund-select', 'w-full p-1 rounded-md bg-gray-200 placeholder-gray-400 border-2 border-gray-200 disabled:(border-gray-400 bg-gray-400)'],
      ['fund-input', 'fund-select read-only:(border-gray-400 bg-gray-400)'],
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

  window.Alpine = Alpine;
  function tws(parts) {
    const styles = Object.entries(parts).reduce((obj, [part, value]) => {
      obj[`&::part(${part})`] = {'@apply': value};
      return obj;
    }, {});
    return css(styles);
  }
  function cmd() {
    // https://twind.run/junior-crazy-mummy?file=script
    return twind.css({
      '.markdown-body > *': {'@apply': 'mt-3'},
      '.markdown-body > *:first-child': {'@apply': 'mt-0'},
      '& h1': {'@apply': 'text-2xl font-bold'},
      '& h2': {'@apply': 'text-xl font-semibold'},
      '& h3': {'@apply': 'text-lg font-semibold'},
      '& h4': {'@apply': 'underline font-medium italic'},
      '& h5': {'@apply': 'underline font-medium italic'},
      '& h6': {'@apply': 'underline italic'},
      '& a': {'color': '-webkit-link', 'text-decoration': 'underline'},
      '& ol,ul': {'padding': 'unset', 'padding-inline-start': '1.5rem', '@apply': 'list-outside'},
      '& ul': {'@apply': 'list-disc'},
      '& ol': {'@apply': 'list-decimal'},
      // NOTE: These two segments should debatably be hoisted into 'preflight'.
      '& blockquote': {'@apply': 'p-2 bg-gray-200 bg-opacity-50 border-l-4 border-gray-800'},
      '& code': {'@apply': 'font-mono bg-gray-200 rounded-md py-0.5 px-1.5'},
    });
  }

  // https://zerodevx.github.io/zero-md/?a=advanced-usage.md
  customElements.define(
    'zero-md',
    class extends ZeroMd {
      async load() {
        const elem = document.createElement("div");
        elem.setAttribute("id", "fund-loader");
        elem.setAttribute("class", "fund-loader");
        elem.innerText = "⏳";
        this.appendChild(elem);

        await super.load();

        this.marked.use({
          gfm: true,
          breaks: false,
          parse: async (obj) => {
            const parsed = await super.parse(obj);
            return DOMPurify.sanitize(parsed);
          },
          renderer: {
            image: (href, title, text) => {
              // FIXME: This is a really gross way to test if the 'zero-md'
              // container is in preview mode; ideally, we'd use CSS instead
              const isPreview = !/\/project\/(~[^\/]+)\/([^\/]+).*$/.test(window.location.toString());
              const imagElem = document.createElement(isPreview ? "a" : "img");
              if (isPreview) {
                imagElem.setAttribute("href", href);
                imagElem.innerText = text ?? title ?? href;
              } else {
                imagElem.setAttribute("src", href);
                if (text) imagElem.setAttribute("alt", text);
                if (title) imagElem.setAttribute("title", title);
              }
              return imagElem.outerHTML;
            },
          },
        });
      }
    },
  );
  addEventListener('zero-md-rendered', (event) => {
    const outer = event.target;
    const loader = Array.from(outer.children).find(e => e.id === "fund-loader");
    if (loader) outer.removeChild(loader);
  });

  // FIXME: For some reason, twind's style refresher doesn't fire when a
  // submission fails, so we replicate its "reveal content" behavior manually
  // https://turbo.hotwired.dev/reference/events#turbo%3Asubmit-end
  document.addEventListener('turbo:submit-end', (event) => {
    if (!event.detail.success) {
      document.documentElement.setAttribute("class", "");
      document.documentElement.setAttribute("style", "");
    }
  });

  document.addEventListener('alpine:init', () => Alpine.data('fund', () => ({
    tws,
    cmd,
    copyText: copyTextToClipboard,
    copyPURL: copyProjectURL,
    swapText: swapContent,
    sendForm: submitForm,
    checkWallet,
    CONTRACT,
    NETWORK,
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
        // FIXME: This is necessary in order to send the raw message
        // payload to the BE (e.g. sending the signed contract text as
        // part of the submission), but the %rudder's `+frisk` method
        // would need to be extended to support this
        // https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST
        // form.enctype = "multipart/form-data";
        form.enctype = "application/x-www-form-urlencoded";
        form.setAttribute("class", "hidden");
        const button = event.target.cloneNode(true);
        form.appendChild(button);

        const appendInput = ([key, value]) => {
          const useInput = !/\r|\n/.exec(value);
          const field = document.createElement(useInput ? "input" : "textarea");
          field.name = key;
          field[useInput ? "value" : "innerHTML"] = value;
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
