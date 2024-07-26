import alpineTurboDriveAdapter from 'https://cdn.skypack.dev/alpine-turbo-drive-adapter';
import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo@7.1';
import Alpine from 'https://cdn.skypack.dev/alpinejs@v3.13.9';
import * as twind from 'https://cdn.jsdelivr.net/npm/@twind/core@1.1.3/+esm';
import presetTwind from 'https://cdn.jsdelivr.net/npm/@twind/preset-tailwind@1.1.4/+esm';
import presetLineClamp from 'https://cdn.jsdelivr.net/npm/@twind/preset-line-clamp@1.0.7/+esm';
import presetAutoPrefix from 'https://cdn.jsdelivr.net/npm/@twind/preset-autoprefix@1.0.7/+esm';
import {
  http, createConfig, injected,
  connect, disconnect, reconnect,
  getAccount, getEnsName, signMessage,
} from 'https://esm.sh/@wagmi/core@2.10.0';
import { fromHex } from 'https://esm.sh/viem@2.16.0';
import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.10.0/chains';
// import urbitHttpApi from 'https://cdn.skypack.dev/@urbit/http-api';
import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3';
import DOMPurify from 'https://cdn.jsdelivr.net/npm/dompurify@3.1.3/+esm';
import TippyJs from 'https://cdn.jsdelivr.net/npm/tippy.js@6.3.7/+esm';
import TomSelect from 'https://cdn.jsdelivr.net/npm/tom-select@2.3.1/+esm';
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
        serif: ['Chaney Wide', 'Noto Emoji', 'serif'],
        sans: ['Safiro Medium', 'Noto Emoji', 'sans-serif'],
        mono: ['Ubuntu Mono', 'mono'],
      },
      extend: {
        fontSize: {
          '3xs': ['0.25rem', {lineHeight: '0.5rem'}],
          '2xs': ['0.50rem', {lineHeight: '0.75rem'}],
        },
        colors: {
          primary: {
            100: '#fdfdfd',
            150: '#fafafa',
            200: '#f8f8f8',
            250: '#f6f6f6',
            300: '#f4f4f4',
            350: '#f1f1f1',
            400: '#efefef',
            450: '#ededed',
            500: '#e8e8e8',
            550: '#bababa',
            600: '#a2a2a2',
            650: '#8b8b8b',
            700: '#747474',
            750: '#5d5d5d',
            800: '#464646',
            850: '#232323',
            900: '#171717',
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
            250: '#9fd2d9',
            300: '#7fc3cc',
            350: '#5fb4bf',
            400: '#45a1ad',
            450: '#38838d',
            500: '#2c666e',
            550: '#265960',
            600: '#214c52',
            650: '#214c52',
            700: '#163337',
            750: '#102629',
            800: '#0b191b',
            850: '#050d0e',
            900: '#090909',
          },
          highlight1: {
            100: '#ffe5eb',
            150: '#ffccd6',
            200: '#ffb3c2',
            250: '#ff99ad',
            300: '#ff8099',
            350: '#ff6685',
            400: '#ff4d70',
            450: '#ff335c',
            500: '#ff0033',
            550: '#cc0029',
            600: '#b30024',
            650: '#99001f',
            700: '#80001a',
            750: '#660014',
            800: '#4d000f',
            850: '#33000a',
            900: '#1a0005',
          },
          highlight2: {
            100: '#edf4ef',
            150: '#dce8e0',
            200: '#caddd0',
            250: '#b8d2c0',
            300: '#a6c6b0',
            350: '#95bba1',
            400: '#83b091',
            450: '#71a481',
            500: '#568665',
            550: '#446b51',
            600: '#3c5e47',
            650: '#33503c',
            700: '#2b4332',
            750: '#223628',
            800: '#1a281e',
            850: '#111b14',
            900: '#090d0a',
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
      h1, h2, h3, h4 { @apply font-serif; }
      h5, h6 { @apply font-sans; }
      h1 { @apply text-3xl; }
      h2 { @apply text-2xl; }
      h3 { @apply text-xl; }
      h4 { @apply text-lg; }
      h5 { @apply font-medium text-md; }
      h6 { @apply font-medium text-xs uppercase; }
      select { padding: unset; @apply fund-select; }
      textarea,input { padding: unset; @apply fund-input; }
      label { @apply font-light; }
      ol,ul { padding: unset; padding-inline-start: 1.5rem; list-style-position: outside; }
      ul { @apply: list-disc; }
      ol { @apply: list-decimal; }
      code { @apply font-mono text-tertiary-150 bg-tertiary-850 rounded-md py-0.5 px-1.5; }
      blockquote { @apply p-2 bg-gray-200 bg-opacity-50 border-l-4 border-gray-800; }
    `),
    rules: [
      ['text-nowrap', {'text-wrap': 'nowrap'}], // FIXME: Not defined in twind
      ['text-link', {'font-weight': 700, 'text-decoration': 'underline'}],
      ['fund-pill', 'text-nowrap font-medium px-2 py-1 border-2 rounded-full'],
      ['fund-loader', 'w-full p-1 text-xl text-center animate-ping'],
      ['fund-select', 'w-full p-2 rounded-md bg-primary-250 placeholder-primary-550 disabled:(bg-gray-400)'],
      ['fund-head', 'sticky fixed z-50 top-0'],
      ['fund-foot', 'sticky fixed z-40 bottom-0'],
      ['fund-body', 'font-sans max-w-screen-2xl min-h-screen mx-auto bg-primary-500 text-secondary-500 lg:px-4'],
      ['fund-card', 'bg-primary-500 border-2 border-secondary-500 rounded-md'],
      ['fund-warn', 'italics mx-4 text-gray-600'],
      ['fund-addr', 'font-normal leading-normal tracking-wide'],
      ['fund-input', 'fund-select read-only:(bg-gray-400)'],
      ['fund-form-group', 'flex flex-col-reverse w-full p-1 gap-1'],
      ['fund-butn-base', 'text-nowrap font-bold leading-tight tracking-wide rounded-md border-2'],
      ['fund-butn-icon', 'p-1 max-w-none rounded-full text-secondary-500 hover:bg-primary-550 active:bg-primary-450'],
      ['fund-butn-smol', 'fund-butn-base text-xs px-1.5 py-0.5'],
      ['fund-butn-medi', 'fund-butn-base text-sm px-3 py-1.5'],
      //  ['fund-butn-lorj', 'fund-butn-base text-sm px-3 py-1.5'], // h-8
      //  FIXME: These classes should use 'hover:enabled' to stop
      //  disabled buttons from changing colors, but this causes hover
      //  styling for links not to work.
      ['fund-butn-default', 'bg-primary-100 border-secondary-500 text-secondary-500 hover:(bg-primary-250 border-secondary-500 text-secondary-500 shadow) active:(bg-primary-200 border-secondary-400 text-secondary-450 shadow) disabled:(bg-primary-550 border-primary-800 text-primary-750)'],
      ['fund-butn-action', 'bg-secondary-500 border-secondary-550 text-primary-100 hover:(bg-secondary-450 border-secondary-400 text-primary-100 shadow) active:(bg-secondary-450 border-secondary-350 text-primary-100 shadow) disabled:(bg-gray-500 border-gray-350 text-gray-200)'],
      ['fund-butn-true', 'bg-highlight2-500 border-highlight2-550 text-primary-100 hover:(bg-highlight2-550 border-highlight2-500 text-primary-100 shadow) active:(bg-highlight2-550 border-highlight2-450 text-primary-100 shadow) disabled:(bg-highlight2-650 border-highlight2-550 text-highlight2-450)'],
      ['fund-butn-false', 'bg-highlight1-500 border-highlight1-550 text-primary-100 hover:(bg-highlight1-550 border-highlight1-500 text-primary-100 shadow) active:(bg-highlight1-550 border-highlight1-450 text-primary-100 shadow) disabled:(bg-highlight1-650 border-highlight1-550 text-highlight1-450)'],
      ['fund-butn-conn', 'bg-tertiary-500 border-tertiary-550 text-primary-100 hover:(bg-tertiary-550 border-tertiary-500 text-primary-100 shadow) active:(bg-tertiary-550 border-tertiary-450 text-primary-100 shadow) disabled:(bg-tertiary-650 border-tertiary-550 text-tertiary-450)'],
      ['fund-butn-de-s', 'fund-butn-default fund-butn-smol'], // default
      ['fund-butn-ac-s', 'fund-butn-action fund-butn-smol'], // action
      ['fund-butn-tr-s', 'fund-butn-true fund-butn-smol'], // true
      ['fund-butn-fa-s', 'fund-butn-false fund-butn-smol'], // false
      ['fund-butn-co-s', 'fund-butn-conn fund-butn-smol'], // conn
      ['fund-butn-de-m', 'fund-butn-default fund-butn-medi'], // default
      ['fund-butn-ac-m', 'fund-butn-action fund-butn-medi'], // action
      ['fund-butn-tr-m', 'fund-butn-true fund-butn-medi'], // true
      ['fund-butn-fa-m', 'fund-butn-false fund-butn-medi'], // false
      ['fund-butn-co-m', 'fund-butn-conn fund-butn-medi'], // conn
      ['fund-aset-circ', 'h-5 bg-contain bg-white rounded-full'],
      ['fund-odit-ther', 'w-full rounded-md flex h-4 sm:h-8 text-primary-700'], // FIXME: text-primary-600
      ['fund-odit-sect', 'h-full flex justify-center items-center text-center first:rounded-l-md last:rounded-r-md'],
    ],
  });

  window.Alpine = Alpine;
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
    cmd,
    copyText,
    swapHTML,
    sendForm,
    checkWallet,
    CONTRACT,
    NETWORK,
    ...SAFE, // FIXME: Makes 'safe.js' available to inline/non-module scripts
  })));

  function swapHTML(elem, html) {
    if (elem.getAttribute("data-html") === null) {
      elem.setAttribute("data-html", elem.innerHTML);
    }
    elem.innerHTML = html;
    setTimeout(() => {elem.innerHTML = elem.dataset.html;}, 2000);
  }

  function fallbackCopyText(text) {
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

  function copyText(text) {
    if (!navigator.clipboard) {
      fallbackCopyText(text);
      return;
    }
    navigator.clipboard.writeText(text).then(function() {
      console.log('Async: Copying to clipboard was successful!');
    }, function(err) {
      console.error('Async: Could not copy text: ', err);
    });
  }

  function sendForm(event, checks = [], action = Promise.resolve(undefined)) {
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
        // NOTE: Safari doesn't recognize the form attributes of the
        // `requestSubmit` button, so we redundantly include them as a field
        appendInput([button.getAttribute("name"), button.getAttribute("value")]);

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

  function renderSelector(data, escape) {
    return `
      <div class='flex flex-row items-center gap-x-1'>
        <img class='fund-aset-circ' src='${data.image}' />
        <span>${data.text}</span>
      </div>
    `;
  };

  // window.Urbit = new urbitHttpApi('', '', 'fund');
  // window.Urbit.ship = window.ship;

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
          const appUrl = window.location.toString().match(/.*\/apps\/fund/)[0];
          const getAddress = () => getAccount(window.Wagmi).address.toLowerCase();
            //  return window.Urbit.scry({
            //    app: "fund",
            //    path: `/prof/~${window.ship}/${getAddress()}`,
            //  });
          connect(window.Wagmi, {connector: Wagmi.connectors[0]}).then(() => (
            fetch(`${appUrl}/ship`, {method: "GET"})
          )).then((responseStream) => (
            responseStream.text()
          )).then((responseText) => {
            const responseDOM = new DOMParser().parseFromString(responseText, "text/html");
            const ship = responseDOM.querySelector("#ship").value;
            const wallets = responseDOM.querySelector("#wallets").value.split(" ");
            return [ship, wallets];
          }).then(([ship, wallets]) => {
            const address = getAddress();
            if (wallets.includes(address)) {
              return Promise.resolve(undefined);
            } else {
              return signMessage(window.Wagmi, {
                account: getAccount(window.Wagmi),
                message: `I, ${ship}, am broadcasting to the Urbit network that I own wallet ${address}`,
              });
            }
          }).then((signature) => {
            if (signature === undefined) {
              return Promise.resolve(undefined);
            } else {
              // NOTE: Solution from: https://stackoverflow.com/a/46642899/837221
              const signData = new URLSearchParams({
                dif: "prof-sign",
                pos: signature,
                poa: getAddress(),
              });
              return fetch(`${appUrl}/ship`, {
                method: "POST",
                headers: {"Content-type": "application/x-www-form-urlencoded; charset=UTF-8"},
                body: signData,
              });
            }
          });
        }
      } else if (status === "connected") {
        // FIXME: Actually calling disconnects tells MetaMask to stop giving
        // this site permission to the associated wallets. Is there any way to
        // soft disconnect the wallet, i.e. set its status to disconnected without
        // removing it?
        disconnect(window.Wagmi, {connector: connection.connector});
      }
    });

    document.querySelectorAll(".fund-addr-ens").forEach(adrElem => {
      const rawAddr = adrElem.dataset.addr;
      getEnsName(window.Wagmi, {address: rawAddr}).then(ensName => {
        adrElem.innerHTML = ensName
          ? ensName
          : `${rawAddr.slice(0, 5)}…${rawAddr.slice(-4)}`;
      });
    });

    document.querySelectorAll(".fund-tsel").forEach(selElem => {
      const telElem = new TomSelect(`#${selElem.id}`, {
        allowEmptyOption: false,
        controlInput: null,
        render: {
          option(data, escape) { return renderSelector(data, escape); },
          item(data, escape) { return renderSelector(data, escape); },
        },
      });
      selElem.matches(":disabled") && telElem.disable();
    });

    document.querySelectorAll(".fund-tipi").forEach(tipElem => {
      const tipElemId = `#${tipElem.id}`;
      TippyJs(tipElemId, {
        content: document.querySelector(`${tipElemId}-opts`).innerHTML,
        allowHTML: true,
        interactive: true,
        arrow: false,
        trigger: "click",
        theme: "fund",
        offset: [0, 5],
      });
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
