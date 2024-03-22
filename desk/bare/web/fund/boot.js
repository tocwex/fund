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
  readContract, writeContract, waitForTransactionReceipt,
  signMessage, signTypedData,
} from 'https://esm.sh/@wagmi/core@2.x';
import { mainnet, sepolia } from 'https://esm.sh/@wagmi/core@2.x/chains';
import {
  encodeFunctionData, encodePacked, keccak256,
  fromHex, toHex, fromBytes, toBytes, concat, parseUnits,
  recoverAddress, recoverMessageAddress,
} from 'https://esm.sh/viem@2.x';

/// Constants/Helpers ///

const generateSaltNonce = () => fromHex(keccak256(toHex(Date.now())), "bigint");
const getSafeWithdrawalArgs = async ({safe, worker, amount}) => (
  readContract(window.Wagmi, {
    abi: SAFE_TEMPLATE_CONTRACT.ABI,
    address: safe,
    functionName: "nonce",
  }).then(safeNonce => ([
    // TODO: Swap out the appropriate ERC-20 address based on user input
    ERC20_CONTRACT.ADDRESS,
    0n, // NOTE: 0n is amount of ETH, which isn't supported
    encodeFunctionData({
      abi: ERC20_CONTRACT.ABI,
      functionName: "transfer",
      args: [worker, amount],
    }),
    // enum Operation {Call, DelegateCall}
    // 0 when transferring one currency, 1 when transferring multiple
    // https://sepolia.etherscan.io/address/0xfb1bffC9d739B8D520DaF37dF666da4C687191EA#code#F12#L7
    0,
    // NOTE: safeTxGas, baseGas, gasPrice, gasToken, refundReceiver
    0n, 0n, 0n, NULL_ADDRESS, NULL_ADDRESS,
    safeNonce,
  ]))
);

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

  Alpine.start();
}

/// Per-page Setup ///

// TODO: Bind this function call to the "finalize escrow" button
window.deploySafe = async () => {
  const { address: workerAddress } = getAccount(window.Wagmi);
  // TODO: The oracle's address will be provided by the on-form data
  const oracleAddress = "0x6E3dB180aD7DEA4508f7766A5c05c406cD6c9dcf";
  const deployTransaction = await writeContract(window.Wagmi, {
    abi: PROXY_FACTORY_CONTRACT.ABI,
    address: PROXY_FACTORY_CONTRACT.ADDRESS,
    functionName: "createProxyWithNonce",
    args: [
      SAFE_TEMPLATE_CONTRACT.ADDRESS,
      encodeFunctionData({
        abi: SAFE_TEMPLATE_CONTRACT.ABI,
        functionName: "setup",
        args: [
          [workerAddress, oracleAddress], 2n,
          // TODO: Module setup info (module address, payload) needs to go here
          NULL_ADDRESS, "",
          SAFE_FALLBACK_CONTRACT.ADDRESS,
          // TODO: Payment info (token, value receiver) (?) needs to go here
          NULL_ADDRESS, 0n, NULL_ADDRESS,
        ],
      }),
      generateSaltNonce(),
    ],
  });
  const deployReceipt = await waitForTransactionReceipt(window.Wagmi, {
    hash: deployTransaction,
  });
  const safeAddress = deployReceipt.logs.find(
    ({topics}) => topics.length > 1
  ).address;
  return safeAddress;
};

// TODO: Bind this function call to the "accept escrow request" button
window.signProject = async () => {
  // TODO: As an oracle, sign a message (verified on the worker's urbit)
  // containing the serialized text of the project information
  const { address: oracleAddress } = getAccount(window.Wagmi);
  const oracleSignature = await signMessage(window.Wagmi, {
    account: oracleAddress,
    // TODO: Get project summary string from page (hidden info)
    // TODO: Get the ship names from the page/URL
    // TODO: Will need to fixup whitespace/newlines for the acutal version
    message: `
      I, ${"~our"}, hereby agree to assess the following project,
      as proposed by ${"~her"} on ${new Date(Date.now()).toDateString()}:
      ${"project summary string goes here"}
    `.trim(),
  });
  return oracleSignature;
};

// TODO: Bind this function call to the "donate" button
window.sendFunds = async () => {
  const currencyDecimals = await readContract(window.Wagmi, {
    abi: ERC20_CONTRACT.ABI,
    // TODO: Swap out the appropriate ERC-20 address based on user input
    address: ERC20_CONTRACT.ADDRESS,
    functionName: "decimals",
  });
  const sendTransaction = await writeContract(window.Wagmi, {
    abi: ERC20_CONTRACT.ABI,
    // TODO: Swap out the appropriate ERC-20 address based on user input
    address: ERC20_CONTRACT.ADDRESS,
    functionName: "transfer",
    args: [
      // TODO: Get the safe address from the web page (hidden info)
      "0x0902CFF41a98411a924f08AD9D8efEC22dFE0AC9",
      // TODO: Get the token amount based on user input
      parseUnits("1", currencyDecimals),
    ],
  });
  const sendReceipt = await waitForTransactionReceipt(window.Wagmi, {
    hash: sendTransaction,
  });
  return sendReceipt;
};

// TODO: Bind this function call to the "approve milestone" button
window.approveWithdrawal = async () => {
  const { address: oracleAddress } = getAccount(window.Wagmi);
  // TODO: Get the safe address from the web page (hidden info)
  const safeAddress = "0x0902CFF41a98411a924f08AD9D8efEC22dFE0AC9";
  const withdrawalArgs = await getSafeWithdrawalArgs({
    safe: safeAddress,
    worker: "0x1be6260E5Eb950D580A700196A5Bc7f12f4CE3b9",
    amount: 1000n,
  });
  const approvalPayload = await readContract(window.Wagmi, {
    abi: SAFE_TEMPLATE_CONTRACT.ABI,
    address: safeAddress,
    functionName: "getTransactionHash",
    args: withdrawalArgs,
  });
  const oracleSignature = await signMessage(window.Wagmi, {
    account: oracleAddress,
    message: { raw: approvalPayload },
  });
  // NOTE: https://sepolia.etherscan.io/address/0xfb1bffC9d739B8D520DaF37dF666da4C687191EA#code#F24#L295
  return toHex(fromHex(oracleSignature, "bigint") + 4n);
};

// // TODO: Bind this function call to the "withdraw funds" button
window.executeWithdrawal = async () => {
  // TODO: As a worker, execute an extraction of a specific amount
  // from a safe
  const { address: workerAddress } = getAccount(window.Wagmi);
  // TODO: Get the safe address from the web page (hidden info)
  const safeAddress = "0x0902CFF41a98411a924f08AD9D8efEC22dFE0AC9";
  // TODO: Grab the signature from the host ship (should be embedded on
  // the page, maybe? same with the address)
  const oracleSignature = "TODO: run 'approveWithdrawal' while using 0x6E3 and put result here";
  const oracleAddress = "0x6E3dB180aD7DEA4508f7766A5c05c406cD6c9dcf";
  const signerAddresses = [workerAddress, oracleAddress];
  const withdrawalArgs = await getSafeWithdrawalArgs({
    safe: safeAddress,
    worker: "0x1be6260E5Eb950D580A700196A5Bc7f12f4CE3b9",
    amount: 1000n,
  });
  const withdrawTransaction = await writeContract(window.Wagmi, {
    abi: SAFE_TEMPLATE_CONTRACT.ABI,
    address: safeAddress,
    functionName: "execTransaction",
    // NOTE: In "execTransaction", we exchange the nonce for the signatures
    args: withdrawalArgs.slice(0, -1).concat([
      signerAddresses
        .map(hexAddress => fromHex(hexAddress, "bigint")).sort()
        .map(intAddress => signerAddresses.find(a => a.toLowerCase() === toHex(intAddress)))
        .map(address => (address === oracleAddress)
          ? oracleSignature
          : encodePacked(["uint256", "uint256", "uint8"], [address, NULL_ADDRESS, 1])
        ).reduce((a, n) => concat([a, n]), "")
    ]),
  });
  return 0;
};

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

// TODO: Figure out if it's possible to delegate these blobs to their own file
// TODO: Add Ethereum mainnet addresses here
const NULL_ADDRESS = "0x0000000000000000000000000000000000000000";
// https://developers.circle.com/stablecoins/docs/usdc-on-test-networks
const ERC20_CONTRACT = Object.freeze({
  ADDRESS: "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238",
  ABI: [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}],
});
// https://github.com/safe-global/safe-deployments/blob/main/src/assets/v1.3.0/proxy_factory.json
const SAFE_FALLBACK_CONTRACT = Object.freeze({
  ADDRESS: "0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC",
  ABI: undefined,
});
const PROXY_FACTORY_CONTRACT = Object.freeze({
  ADDRESS: "0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC",
  ABI: [{"anonymous":false,"inputs":[{"indexed":false,"internalType":"contract GnosisSafeProxy","name":"proxy","type":"address"},{"indexed":false,"internalType":"address","name":"singleton","type":"address"}],"name":"ProxyCreation","type":"event"},{"inputs":[{"internalType":"address","name":"_singleton","type":"address"},{"internalType":"bytes","name":"initializer","type":"bytes"},{"internalType":"uint256","name":"saltNonce","type":"uint256"}],"name":"calculateCreateProxyWithNonceAddress","outputs":[{"internalType":"contract GnosisSafeProxy","name":"proxy","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"singleton","type":"address"},{"internalType":"bytes","name":"data","type":"bytes"}],"name":"createProxy","outputs":[{"internalType":"contract GnosisSafeProxy","name":"proxy","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_singleton","type":"address"},{"internalType":"bytes","name":"initializer","type":"bytes"},{"internalType":"uint256","name":"saltNonce","type":"uint256"},{"internalType":"contract IProxyCreationCallback","name":"callback","type":"address"}],"name":"createProxyWithCallback","outputs":[{"internalType":"contract GnosisSafeProxy","name":"proxy","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_singleton","type":"address"},{"internalType":"bytes","name":"initializer","type":"bytes"},{"internalType":"uint256","name":"saltNonce","type":"uint256"}],"name":"createProxyWithNonce","outputs":[{"internalType":"contract GnosisSafeProxy","name":"proxy","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"proxyCreationCode","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"proxyRuntimeCode","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"pure","type":"function"}],
});
const SAFE_TEMPLATE_CONTRACT = Object.freeze({
  ADDRESS: "0xfb1bffC9d739B8D520DaF37dF666da4C687191EA",
  ABI: [{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"owner","type":"address"}],"name":"AddedOwner","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"approvedHash","type":"bytes32"},{"indexed":true,"internalType":"address","name":"owner","type":"address"}],"name":"ApproveHash","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"handler","type":"address"}],"name":"ChangedFallbackHandler","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"guard","type":"address"}],"name":"ChangedGuard","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"threshold","type":"uint256"}],"name":"ChangedThreshold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"module","type":"address"}],"name":"DisabledModule","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"module","type":"address"}],"name":"EnabledModule","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"bytes32","name":"txHash","type":"bytes32"},{"indexed":false,"internalType":"uint256","name":"payment","type":"uint256"}],"name":"ExecutionFailure","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"module","type":"address"}],"name":"ExecutionFromModuleFailure","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"module","type":"address"}],"name":"ExecutionFromModuleSuccess","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"bytes32","name":"txHash","type":"bytes32"},{"indexed":false,"internalType":"uint256","name":"payment","type":"uint256"}],"name":"ExecutionSuccess","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"owner","type":"address"}],"name":"RemovedOwner","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"module","type":"address"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"},{"indexed":false,"internalType":"enum Enum.Operation","name":"operation","type":"uint8"}],"name":"SafeModuleTransaction","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"},{"indexed":false,"internalType":"enum Enum.Operation","name":"operation","type":"uint8"},{"indexed":false,"internalType":"uint256","name":"safeTxGas","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"baseGas","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"gasPrice","type":"uint256"},{"indexed":false,"internalType":"address","name":"gasToken","type":"address"},{"indexed":false,"internalType":"address payable","name":"refundReceiver","type":"address"},{"indexed":false,"internalType":"bytes","name":"signatures","type":"bytes"},{"indexed":false,"internalType":"bytes","name":"additionalInfo","type":"bytes"}],"name":"SafeMultiSigTransaction","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"SafeReceived","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"initiator","type":"address"},{"indexed":false,"internalType":"address[]","name":"owners","type":"address[]"},{"indexed":false,"internalType":"uint256","name":"threshold","type":"uint256"},{"indexed":false,"internalType":"address","name":"initializer","type":"address"},{"indexed":false,"internalType":"address","name":"fallbackHandler","type":"address"}],"name":"SafeSetup","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"msgHash","type":"bytes32"}],"name":"SignMsg","type":"event"},{"stateMutability":"nonpayable","type":"fallback"},{"inputs":[],"name":"VERSION","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"uint256","name":"_threshold","type":"uint256"}],"name":"addOwnerWithThreshold","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"hashToApprove","type":"bytes32"}],"name":"approveHash","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"bytes32","name":"","type":"bytes32"}],"name":"approvedHashes","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_threshold","type":"uint256"}],"name":"changeThreshold","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataHash","type":"bytes32"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"bytes","name":"signatures","type":"bytes"},{"internalType":"uint256","name":"requiredSignatures","type":"uint256"}],"name":"checkNSignatures","outputs":[],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"dataHash","type":"bytes32"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"bytes","name":"signatures","type":"bytes"}],"name":"checkSignatures","outputs":[],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"prevModule","type":"address"},{"internalType":"address","name":"module","type":"address"}],"name":"disableModule","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"domainSeparator","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"module","type":"address"}],"name":"enableModule","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"enum Enum.Operation","name":"operation","type":"uint8"},{"internalType":"uint256","name":"safeTxGas","type":"uint256"},{"internalType":"uint256","name":"baseGas","type":"uint256"},{"internalType":"uint256","name":"gasPrice","type":"uint256"},{"internalType":"address","name":"gasToken","type":"address"},{"internalType":"address","name":"refundReceiver","type":"address"},{"internalType":"uint256","name":"_nonce","type":"uint256"}],"name":"encodeTransactionData","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"enum Enum.Operation","name":"operation","type":"uint8"},{"internalType":"uint256","name":"safeTxGas","type":"uint256"},{"internalType":"uint256","name":"baseGas","type":"uint256"},{"internalType":"uint256","name":"gasPrice","type":"uint256"},{"internalType":"address","name":"gasToken","type":"address"},{"internalType":"address payable","name":"refundReceiver","type":"address"},{"internalType":"bytes","name":"signatures","type":"bytes"}],"name":"execTransaction","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"enum Enum.Operation","name":"operation","type":"uint8"}],"name":"execTransactionFromModule","outputs":[{"internalType":"bool","name":"success","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"enum Enum.Operation","name":"operation","type":"uint8"}],"name":"execTransactionFromModuleReturnData","outputs":[{"internalType":"bool","name":"success","type":"bool"},{"internalType":"bytes","name":"returnData","type":"bytes"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getChainId","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"start","type":"address"},{"internalType":"uint256","name":"pageSize","type":"uint256"}],"name":"getModulesPaginated","outputs":[{"internalType":"address[]","name":"array","type":"address[]"},{"internalType":"address","name":"next","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getOwners","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"offset","type":"uint256"},{"internalType":"uint256","name":"length","type":"uint256"}],"name":"getStorageAt","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getThreshold","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"enum Enum.Operation","name":"operation","type":"uint8"},{"internalType":"uint256","name":"safeTxGas","type":"uint256"},{"internalType":"uint256","name":"baseGas","type":"uint256"},{"internalType":"uint256","name":"gasPrice","type":"uint256"},{"internalType":"address","name":"gasToken","type":"address"},{"internalType":"address","name":"refundReceiver","type":"address"},{"internalType":"uint256","name":"_nonce","type":"uint256"}],"name":"getTransactionHash","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"module","type":"address"}],"name":"isModuleEnabled","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"isOwner","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"nonce","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"prevOwner","type":"address"},{"internalType":"address","name":"owner","type":"address"},{"internalType":"uint256","name":"_threshold","type":"uint256"}],"name":"removeOwner","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"enum Enum.Operation","name":"operation","type":"uint8"}],"name":"requiredTxGas","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"handler","type":"address"}],"name":"setFallbackHandler","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"guard","type":"address"}],"name":"setGuard","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"_owners","type":"address[]"},{"internalType":"uint256","name":"_threshold","type":"uint256"},{"internalType":"address","name":"to","type":"address"},{"internalType":"bytes","name":"data","type":"bytes"},{"internalType":"address","name":"fallbackHandler","type":"address"},{"internalType":"address","name":"paymentToken","type":"address"},{"internalType":"uint256","name":"payment","type":"uint256"},{"internalType":"address payable","name":"paymentReceiver","type":"address"}],"name":"setup","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"name":"signedMessages","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"targetContract","type":"address"},{"internalType":"bytes","name":"calldataPayload","type":"bytes"}],"name":"simulateAndRevert","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"prevOwner","type":"address"},{"internalType":"address","name":"oldOwner","type":"address"},{"internalType":"address","name":"newOwner","type":"address"}],"name":"swapOwner","outputs":[],"stateMutability":"nonpayable","type":"function"},{"stateMutability":"payable","type":"receive"}],
});
