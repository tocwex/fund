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
  getAccount, getBalance, getEnsName, signMessage,
  getConnections, switchAccount,
} from 'https://esm.sh/@wagmi/core@2.10.0';
import { fromHex } from 'https://esm.sh/viem@2.16.0';
import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.10.0/chains';
import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3';
import DOMPurify from 'https://cdn.jsdelivr.net/npm/dompurify@3.1.3/+esm';
import TippyJs from 'https://cdn.jsdelivr.net/npm/tippy.js@6.3.7/+esm';
import TomSelect from 'https://cdn.jsdelivr.net/npm/tom-select@2.3.1/+esm';
import UrbitOb from 'https://cdn.jsdelivr.net/npm/urbit-ob@5.0.1/+esm';
import * as SAFE from './safe.js';
import { FUND_SIGN_ADDR } from './config.js';
import { CONTRACT, NETWORK } from './const.js';

if (window.Alpine === undefined) {
  const PALETTE = {
    primary: '#545557',
    secondary: '#dedfe0',
    label: '#4a4b4c',
    background: '#f0f0f1',
    contrast: '#dedfe0',
  };
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
          // new style
          palette: PALETTE,
          // old style
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
        },
      },
    },
    // TODO: It would be great to put this all in a CSS file that
    // was loaded by this file or the browser and then injected here
    preflight: twind.css(`
      form { margin: unset; }
      h1, h2, h3, h4 { @apply font-serif; }
      h5, h6 { @apply font-sans; }
      h1 { @apply text-xl sm:text-3xl; }
      h2 { @apply text-lg sm:text-2xl; }
      h3 { @apply text-base sm:text-xl; }
      h4 { @apply text-base sm:text-lg; }
      h5 { @apply font-light text-sm sm:(font-medium text-base); }
      h6 { @apply font-light uppercase text-sm sm:font-medium; }
      h1-alt { @apply font-serif text-palette-contrast text-xl sm:text-3xl; }
      hr { @apply border-0 h-px bg-black; }
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
      // FIXME: It would be great if this could be specified purely in
      // tailwind syntax
      ['primary-gradient', {'background': `
        repeating-linear-gradient(-45deg,
          ${PALETTE.label}, ${PALETTE.label} 10px,
          ${PALETTE.primary} 10px, ${PALETTE.primary} 20px)
      `}],
      ['secondary-gradient', {'background': `
        repeating-linear-gradient(-45deg,
          ${PALETTE.label}, ${PALETTE.label} 10px,
          ${PALETTE.secondary} 10px, ${PALETTE.secondary} 20px)
      `}],
      ['text-link', {'font-weight': 700, 'text-decoration': 'underline'}],
      ['fund-pill', 'text-nowrap font-medium px-3 py-1 border-[3px] rounded-full'],
      ['fund-loader', 'w-full p-1 text-xl text-center animate-ping'],
      ['fund-select', 'w-full p-2 rounded-md bg-white placeholder-black/50 disabled:bg-gray-500'],
      ['fund-head', 'sticky z-40 top-0'],
      ['fund-foot', 'sticky z-40 bottom-0'],
      ['fund-body', 'font-sans max-w-screen-2xl min-h-screen mx-auto bg-palette-background text-palette-label px-1 lg:px-4'],
      ['fund-card', 'bg-palette-contrast rounded-md px-3 py-2 border-[3px] border-palette-contrast'],
      ['fund-warn', 'italic mx-4'],
      ['fund-addr', 'font-normal leading-normal tracking-wide line-clamp-1'],
      ['fund-input', 'fund-select read-only:bg-gray-500'],
      ['fund-title', 'font-sans font-medium text-2xl sm:text-4xl'],
      ['fund-form-group', 'flex flex-col-reverse w-full p-1 gap-1'],
      ['fund-butn-base', 'text-nowrap font-bold leading-tight tracking-wide rounded-md border-2'],
      ['fund-butn-icon', 'p-1 max-w-none rounded-md text-palette-secondary hover:bg-palette-background'],
      ['fund-butn-smol', 'fund-butn-base text-xs px-1.5 py-0.5'],
      ['fund-butn-medi', 'fund-butn-base text-sm px-3 py-1.5'],
      ['fund-butn-lorj', 'fund-butn-base text-base px-4 py-2'],
      //  FIXME: These classes should use 'hover:enabled' to stop
      //  disabled buttons from changing colors, but this causes hover
      //  styling for links not to work.
      ['fund-butn-default', 'bg-palette-primary border-palette-primary text-palette-secondary hover:(bg-palette-background border-palette-primary text-palette-primary shadow) active:(bg-palette-primary border-palette-primary text-palette-secondary) disabled:(primary-gradient border-black text-black shadow-none)'],
      ['fund-butn-action', 'bg-palette-background border-palette-primary text-palette-primary hover:(bg-palette-primary border-palette-primary text-palette-background shadow) active:(bg-palette-background border-palette-primary text-palette-primary) disabled:(secondary-gradient border-black text-black shadow-none)'],
      // ['fund-butn-true', 'fund-butn-default'],
      // ['fund-butn-false', 'fund-butn-action'],
      ['fund-butn-de-s', 'fund-butn-default fund-butn-smol'], // default
      ['fund-butn-ac-s', 'fund-butn-action fund-butn-smol'], // action
      ['fund-butn-tr-s', 'fund-butn-default fund-butn-smol'], // true
      ['fund-butn-fa-s', 'fund-butn-action fund-butn-smol'], // false
      ['fund-butn-de-m', 'fund-butn-default fund-butn-medi'], // default
      ['fund-butn-ac-m', 'fund-butn-action fund-butn-medi'], // action
      ['fund-butn-tr-m', 'fund-butn-default fund-butn-medi'], // true
      ['fund-butn-fa-m', 'fund-butn-action fund-butn-medi'], // false
      ['fund-butn-de-l', 'fund-butn-default fund-butn-lorj'], // default
      ['fund-butn-ac-l', 'fund-butn-action fund-butn-lorj'], // action
      ['fund-butn-tr-l', 'fund-butn-default fund-butn-lorj'], // true
      ['fund-butn-fa-l', 'fund-butn-action fund-butn-lorj'], // false
      ['fund-aset-circ', 'h-6 aspect-square bg-white rounded-full'],
      ['fund-aset-rect', 'h-6 aspect-square bg-white rounded'],
      ['fund-odit-ther', 'w-full flex h-4 sm:h-8 text-primary-700'],
      ['fund-odit-sect', 'h-full flex rounded-lg'],
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
      async parse(obj) {
        const parsed = await super.parse(obj);
        return DOMPurify.sanitize(parsed);
      }
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

  Alpine.store("page", {
    size: undefined,
  });
  Alpine.store("wallet", {
    address: null,
    chain: null,
    connected: false,
    balance: "…loading…",
    status: "…loading…",
    update(address, chain) {
      this.address = address;
      this.chain = chain;
      this.connected = !!address;
      this.status =
        (address === undefined) ? "connect 💰"
        : (address === null) ? "…loading…"
        : `${address.slice(0, 5)}…${address.slice(-4)}`;
      if (!address) {
        this.balance = 0;
      } else {
        getBalance(window.Wagmi, {address}).then(({formatted}) => {
          this.balance = `${Number(formatted).toFixed(2)} ETH`;
        });
      }
      window.dispatchEvent(new CustomEvent("fund-wallet", {detail: address}));
    },
  });
  Alpine.store("project", {
    type: undefined,
    symbol: undefined,
    assets: {},
    update(type, symbol) {
      this.type = type;
      this.symbol = symbol;
      this.assets = {};
      window.dispatchEvent(new CustomEvent("fund-project", {detail: symbol}));
    },
    loadAssets(addr, assets) {
      this.assets[addr] = assets;
    },
  });

  document.addEventListener('alpine:init', () => Alpine.data('fund', () => ({
    cmd,
    copyText,
    swapHTML,
    openHREF,
    scrollTo,
    sendFormData,
    sendForm,
    checkWallet,
    toggleWallet,
    // switchWallet,
    initENS,
    initTippy,
    initTomSelect,
    tsUpdateToken,
    tsCreateOracle,
    tsLoadNFTs,
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

  // FIXME: It's better to use this instead of `window.open` for local URLs
  // because the `<a>` click emulation prompts a partial turbojs reload where
  // `window.open` prompts a full page reload
  function openHREF(href, tab=false) {
    const link = document.createElement("a");
    link.setAttribute("class", "hidden");
    link.setAttribute("href", href);
    if (tab) { link.setAttribute("target", "_blank"); }
    document.body.appendChild(link);
    link.click();
  }

  function scrollTo(anchor) {
    const anchorElem = document.querySelector(`#${anchor}`);
    if (anchorElem) {
      const headHeight = document.querySelector("#fund-head")?.offsetHeight ?? 0;
      const anchorTop = anchorElem.offsetTop;
      const documentHeight = document.documentElement.scrollHeight;

      const anchorFloorDist = documentHeight - anchorTop - headHeight;
      const screenHeight = window.screen.height;

      // FIXME: Needs work when `headTop` is near `screenHeight`
      location.hash = `#${anchor}`;
      window.scrollBy(0, (screenHeight >= anchorFloorDist) ? 0 : -headHeight);
    }
  }

  function sendForm(event, checks=[], action=Promise.resolve(undefined)) {
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
      }).then(action).then(formData => (
        sendFormData(formData, event)
      )).catch((error) => {
        event.target.innerHTML = "error ✗";
        console.log(error);
        alert(error.message);
      });
    }
  }

  // NOTE: 'formData' is not a 'FormData' object; it's a {str => str} map
  function sendFormData(formData, event=undefined) {
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
    const button = event?.target?.cloneNode(true) ?? document.createElement("button");
    form.appendChild(button);

    const appendInput = ([key, value]) => {
      const useInput = !/\r|\n/.exec(value);
      const field = document.createElement(useInput ? "input" : "textarea");
      field.name = key;
      field[useInput ? "value" : "innerHTML"] = value;
      form.appendChild(field);
    };
    Object.entries(formData).forEach(appendInput);
    if (event?.target?.form !== undefined) {
      [...(new FormData(event.target.form).entries())].forEach(appendInput);
    }
    // NOTE: Safari doesn't recognize the form attributes of the
    // `requestSubmit` button, so we redundantly include them as a field
    appendInput([button.getAttribute("name"), button.getAttribute("value")]);

    document.body.appendChild(form);
    form.requestSubmit(button);
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

  function setWallet({connections, current, status}) {
    if (status === "disconnected") {
      const connection = connections.get(current);
      if (!connection) {
        Alpine.store("wallet").update(undefined, undefined);
      } else {
        reconnect(window.Wagmi, {connector: connection.connector});
      }
    } else if (status === "reconnecting") {
      Alpine.store("wallet").update(null, null);
    } else if (status === "connected") {
      const { address, chainId } = getAccount(window.Wagmi);
      Alpine.store("wallet").update(address, chainId);
    }
  }

  function toggleWallet(event) {
    const { status, current, connections } = window.Wagmi.state;
    const connection = connections.get(current);

    if (status === "connected") {
      // FIXME: Actually calling disconnects tells MetaMask to stop giving
      // this site permission to the associated wallets. Is there any way to
      // soft disconnect the wallet, i.e. set its status to disconnected without
      // removing it?
      disconnect(window.Wagmi, {connector: connection.connector});
    } else if (status === "disconnected") {
      if (connection) {
        reconnect(window.Wagmi, {connector: connection.connector});
      } else {
        const appUrl = window.location.toString().match(/.*\/apps\/fund/)[0];
        const getAddress = () => getAccount(window.Wagmi).address.toLowerCase();
        connect(window.Wagmi, {connector: Wagmi.connectors[0]}).then(() => (
          fetch(`${appUrl}/ship`, {method: "GET"})
        )).then((responseStream) => (
          responseStream.text()
        )).then((responseText) => {
          const responseDOM = new DOMParser().parseFromString(responseText, "text/html");
          const ship = responseDOM.querySelector("#ship").value;
          const clan = responseDOM.querySelector("#clan").value;
          const wallets = responseDOM.querySelector("#wallets").value.split(" ");
          return [ship, clan, wallets];
        }).then(([ship, clan, wallets]) => {
          const address = getAddress();
          if (wallets.includes(address) || clan === "pawn") {
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
    }
  }

  // FIXME: This doesn't work... may need to upgrade `wagmi.sh` to
  // latest version to fix
  //
  // async function switchWallet() {
  //   const connections = getConnections(window.Wagmi);
  //   const result = await switchAccount(window.Wagmi, {
  //     connector: connections[0]?.connector,
  //   });
  // }

  // FIXME: This doesn't work well for calculating line clamps on the
  // 'zero-md' elements because they generate content dynamically
  //
  // function needsClamp(elem, clamp) {
  //   const divHeight = elem.offsetHeight
  //   const lineHeight = parseInt(elem.style.lineHeight);
  //   const lines = divHeight / lineHeight;
  //   return lines > clamp;
  // }

  function initENS(elem, address) {
    elem.innerHTML = "…loading…";
    getEnsName(window.Wagmi, {address}).then(ensName => {
      elem.innerHTML = ensName
        ? ensName
        : `${address.slice(0, 5)}…${address.slice(-4)}`;
    });
  }

  function initTippy(elem, {
    dir=undefined, // String?
    hover=false, // Bool
  } = {}) {
    const optElem = elem.nextSibling;
    optElem.style.display = 'block';
    TippyJs(elem, {
      content: optElem,
      allowHTML: true,
      interactive: true,
      arrow: false,
      trigger: ["click", ...(!hover ? [] : ["mouseenter"])].join(" "),
      theme: "fund",
      offset: [0, 5],
      ...(!dir ? {} : {placement: dir}),
    });
  }

  // function initTomSelect(elem, empty, upOnly=false, maxItems=undefined, create=false) {
  function initTomSelect(elem, {
    empty=false, // Bool
    forceUp=false, // Bool
    maxItems=undefined, // Number?
    create=undefined, // ((value, data) => void)?
    load=undefined, // ((query, callback) => void)?
  } = {}) {
    function renderSelector(data, escape) {
      return `
        <div class='flex flex-row items-center gap-x-2'>
          <img class='fund-aset-circ' src='${data.image ??
            "https://placehold.co/24x24/white/black?font=roboto&text=~"
          }' />
          <span>${data.text}</span>
        </div>
      `;
    };

    if (elem.tomselect === undefined) {
      const tselElem = new TomSelect(elem, {
        allowEmptyOption: empty,
        render: {
          loading: (data, escape) => "<div class='fund-loader'>⏳</div>",
          option: (data, escape) => renderSelector(data, escape),
          item: (data, escape) => renderSelector(data, escape),
          ...(!create ? {} : {
            no_results: (data, escape) => null,
            option_create: (data, escape) => `
              <div class="create">
                Use custom option <strong>${escape(data.input)}</strong>
              </div>`,
          }),
        },
        onDropdownOpen: (dropdown) => {
          if (
              forceUp ||
              (dropdown.getBoundingClientRect().bottom >
              (window.innerHeight || document.documentElement.clientHeight))
          ) {
            dropdown.classList.add('dropup');
          }
        },
        onDropdownClose: (dropdown) => {
          dropdown.classList.remove('dropup');
        },
        ...(empty ? {} : {controlInput: null}),
        ...((maxItems === undefined || maxItems === 0) ? {} : {maxItems}),
        ...(!load ? {} : {load}),
        ...(!create ? {} : {
          create: !!create,
          onOptionAdd: create,
        }),
      });
      tselElem?.load && tselElem.load();
      elem.classList.add("fund-tsel");
      elem.matches(":disabled") && tselElem.disable();
    }
  }

  function tsUpdateToken(chainElem, tokenElem) {
    return (option) => {
      const tokenChain = chainElem.value;
      const tokenSelect = tokenElem.tomselect;
      const tokenOpts = document.querySelectorAll('#proj-token-options > option');
      const tokenChainOpts = Array.from(tokenOpts).map(elem => ({
        value: elem.value,
        text: elem.innerText,
        image: elem.dataset.image,
        chain: elem.dataset.chain,
        href: elem.dataset.href,
      })).filter(({value, chain}) => (
        chain === tokenChain || value === ""
      ));

      tokenSelect.clear(true);
      tokenSelect.clearOptions();
      tokenSelect.addOptions(tokenChainOpts);
      tokenSelect.addItem(
        (tokenChainOpts.find(({value}) => value === option) ?? tokenChainOpts[0]).value
      );
    };
  }

  function tsCreateOracle(elem) {
    return (value, data) => {
      const okClans = new Set(["galaxy", "star"]);
      if (!UrbitOb.isValidPatp(value) || !okClans.has(UrbitOb.clan(value))) {
        elem.tomselect.removeOption(value);
      } else if (data?.image === undefined) {
        elem.tomselect.updateOption(value, {
          value: data.value,
          text: data.text,
          image: `https://azimuth.network/erc721/${UrbitOb.patp2dec(value)}.svg`,
        });
      }
    };
  }

  function tsLoadNFTs(elem) {
    return (query, callback) => {
      const self = elem.tomselect;
      if (self.loading > 1) return callback();

      const address = Alpine.store("wallet").address;
      const chain = Alpine.store("wallet").chain;
      const loadedNFTs = Alpine.store("project").assets?.[address];
      const loadNFTOptions = loadedNFTs
        ? Promise.resolve(loadedNFTs)
        : SAFE.nftsGetAll(address, chain, Alpine.store("project").symbol).then(nfts => (
            // TODO: Generalize this logic by querying metadata filters from the BE
            nfts.filter(nft => ((nft?.raw?.metadata?.attributes ?? []).some(attr => (
              (attr?.trait_type === "size" && attr?.value === "star")
            )))).map(({name, image, tokenId}) => ({
              value: tokenId,
              text: name,
              image: image.cachedUrl,
            }))
          )).catch(() => []);

      self.clear(true);
      self.clearOptions();
      loadNFTOptions.then(options => {
        const nftOptions = (options.length > 0) ? options : [{
          value: "-1",
          text: "(no nfts in wallet)",
          image: "https://placehold.co/24x24/black/black?text=\\n",
        }];
        Alpine.store("project").loadAssets(address, nftOptions);
        callback(nftOptions);
        // NOTE: Auto-select if only one available; iffy on the ui/ux
        // if (nftOptions.length === 0) { self.addItem(-1); }
        delete self.loadedSearches[query];
      }).catch(() => callback());
    };
  }

  // https://css-tricks.com/working-with-javascript-media-queries/
  function watchViewport() {
    const viewportConfigs = [
      ["mobile", "(max-width: 640px)"],
      ["tablet", "(min-width: 640px) and (max-width: 1023px)"],
      ["desktop", "(min-width: 1024px)"],
    ];
    viewportConfigs.forEach(([size, query]) => {
      const sizeQuery = window.matchMedia(query);
      const handleSizeChange = e => {if (e.matches) Alpine.store("page").size = size;};
      sizeQuery.addListener(handleSizeChange);
      handleSizeChange(sizeQuery);
    });
  }

  window.Wagmi = createConfig({
    chains: [mainnet, sepolia],
    connectors: [injected()],
    transports: {
      [mainnet.id]: http(NETWORK.RPC.ETHEREUM),
      [sepolia.id]: http(NETWORK.RPC.SEPOLIA),
    },
  });
  window.Wagmi.subscribe(
    (state) => state,
    (state) => setWallet(state),
  );


  // FIXME: For some reason, twind's style refresher doesn't fire when a
  // submission fails, so we replicate its "reveal content" behavior manually
  // https://turbo.hotwired.dev/reference/events#turbo%3Asubmit-end
  document.addEventListener('turbo:submit-end', (event) => {
    if (!event.detail.success) {
      document.documentElement.setAttribute("class", "");
      document.documentElement.setAttribute("style", "");
    }
  });
  // https://turbo.hotwired.dev/reference/events#turbo%3Aload
  document.addEventListener("turbo:load", (event) => {
    setWallet(window.Wagmi.state);
  });

  // TODO: Including in 'turbo:load' causes this to fire too late
  watchViewport();

  Alpine.start();
}
