import {
  http, createConfig, injected,
  connect, disconnect, reconnect,
  getAccount, getBalance, getEnsName, signMessage,
  watchAccount, watchChainId,
} from '@wagmi/core';
import { fromHex } from 'viem';
import { mainnet, sepolia } from '@wagmi/core/chains';
import { FUND_SIGN_ADDR } from './config.js';
import { NETWORK } from './const.js';
import * as SAFE from './safe.js';

let chainAPI;

export function initChain({ Alpine, limit }) {
  if (chainAPI) return chainAPI;

  window.Wagmi = createConfig({
    chains: [mainnet, sepolia],
    connectors: [injected()],
    transports: {
      [mainnet.id]: http(NETWORK.RPC.ETHEREUM),
      [sepolia.id]: http(NETWORK.RPC.SEPOLIA),
    },
  });

  function setWallet({address, chainId, status}) {
    if (status === "disconnected") {
      Alpine.store("wallet").update(undefined, undefined);
    } else if (status === "reconnecting") {
      Alpine.store("wallet").update(null, null);
    } else if (status === "connected") {
      Alpine.store("wallet").update(address, chainId);
      getBalance(window.Wagmi, {address}).then(({formatted}) => {
        if (Alpine.store("wallet").address === address) {
          Alpine.store("wallet").balance = `${Number(formatted).toFixed(2)} ETH`;
        }
      });
      getEnsName(window.Wagmi, {address}).then((ensName) => {
        if (Alpine.store("wallet").address === address) {
          Alpine.store("wallet").status = ensName
            ? ensName
            : `${address.slice(0, 5)}…${address.slice(-4)}`;
        }
      }).catch((error) => {
        if (Alpine.store("wallet").address === address) {
          Alpine.store("wallet").status = `${address.slice(0, 5)}…${address.slice(-4)}`;
        }
      });
    }
  }

  watchAccount(window.Wagmi, {onChange: (curr, prev) => {
    // NOTE: Filter only `watchAccount` events that affect the wallet address.
    if (
      ["connected", "disconnected"].includes(curr?.status) &&
      (curr?.status !== prev?.status || curr?.address !== prev?.address)
    ) {
      setWallet(curr);
    }
  }});
  watchChainId(window.Wagmi, {onChange: (curr, prev) => {
    // NOTE: We `setWallet` on chain change also because it enables
    // per-network ENS support.
    setWallet(getAccount(window.Wagmi));
  }});

  reconnect(window.Wagmi);

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

  function toggleWallet(event) {
    const { status, current, connections } = window.Wagmi.state;
    const connection = connections.get(current);

    if (status === "connected") {
      return disconnect(window.Wagmi, {connector: connection.connector});
    } else if (status === "disconnected") {
      // FIXME: For some reason, `reconnect` tends to silently fail the
      // first time, so we "reconnect" and then actually connect.
      return (!connection
        ? Promise.resolve(undefined)
        : reconnect(window.Wagmi, {connector: connection.connector})
      ).then(() => {
        const appUrl = window.location.toString().match(/.*\/apps\/fund/)[0];
        const getAddress = () => (getAccount(window.Wagmi)?.address ?? '').toLowerCase();
        return connect(window.Wagmi, {connector: window.Wagmi.connectors[0]}).then(() => (
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
      });
    }
  }

  function initENS(elem, address) {
    elem.innerHTML = "…loading…";
    getEnsName(window.Wagmi, {address}).then(ensName => {
      elem.innerHTML = ensName
        ? ensName
        : `${address.slice(0, 5)}…${address.slice(-4)}`;
    });
  }

  function initAZP(elem, point) {
    if (typeof initAZP.limiter === "undefined") {
      initAZP.limiter = limit(1, 2); // 1 query / 2 seconds
    }

    const setUnavailable = () => {
      elem.innerHTML = "(unavailable)";
      elem.removeAttribute("href");
      elem.setAttribute("disabled", undefined);
      elem?.nextElementSibling?.remove();
    };

    elem.innerHTML = "…loading…";
    return new Promise(resolve => initAZP.limiter(resolve)).then(() => (
      SAFE.ownersGetAll(point, 1, "AZP")
    )).then(owners => {
      const owner = owners?.[0];
      if (owner === undefined) {
        setUnavailable();
        return Promise.resolve(undefined);
      } else {
        const href = (elem?.getAttribute("href") ?? "").replace(/\/[^\/]+$/, "/" + owner);
        elem.setAttribute("href", href);
        // FIXME: This part in particular is really ugly; a better
        // solution should be used if possible.
        const sibling = elem?.nextElementSibling;
        if (!!sibling) {
          sibling.setAttribute("x-on:click", `copyText('${owner}'); swapHTML($el, '✔');`);
        }
        return initENS(elem, owner);
      }
    }).catch(error => {
      setUnavailable();
      return Promise.resolve(undefined);
    });
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
            // TODO: Generalize this logic by querying metadata filters from the BE.
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
        // NOTE: Auto-select if only one available; iffy on the ui/ux.
        // if (nftOptions.length === 0) { self.addItem(-1); }
        delete self.loadedSearches[query];
      }).catch(() => callback());
    };
  }

  chainAPI = {
    checkWallet,
    initAZP,
    initENS,
    toggleWallet,
    tsLoadNFTs,
    ...SAFE,
  };

  return chainAPI;
}
