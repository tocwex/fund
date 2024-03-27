import {
  getAccount, signMessage,
  readContract, writeContract, waitForTransactionReceipt,
} from 'https://esm.sh/@wagmi/core@2.x';
import {
  encodeFunctionData, encodePacked, keccak256,
  fromHex, toHex, fromBytes, toBytes, concat, parseUnits,
  recoverAddress, recoverMessageAddress,
} from 'https://esm.sh/viem@2.x';
import { ADDRESS, CONTRACT } from './const.js';

//////////////////////
// Module Functions //
//////////////////////

export const safeSign = async ({projectContent}) => {
  const { address } = getAccount(window.Wagmi);
  const signature = await signMessage(window.Wagmi, {
    account: address,
    message: projectContent,
  });
  return [address, signature];
};

// TODO: Bind this function call to the "finalize escrow" button
export const safeDeploy = async () => {
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
      safeNextSaltNonce(),
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

// TODO: Bind this function call to the "donate" button
export const safeSendFunds = async () => {
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
export const safeApproveWithdrawal = async () => {
  const { address: oracleAddress } = getAccount(window.Wagmi);
  // TODO: Get the safe address from the web page (hidden info)
  const safeAddress = "0x0902CFF41a98411a924f08AD9D8efEC22dFE0AC9";
  const withdrawalArgs = await safeGetWithdrawalArgs({
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
export const safeExecuteWithdrawal = async () => {
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
  const withdrawalArgs = await safeGetWithdrawalArgs({
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

//////////////////////
// Helper Functions //
//////////////////////

const safeNextSaltNonce = () => (
  fromHex(keccak256(toHex(Date.now())), "bigint")
);

const safeGetWithdrawalArgs = async ({safe, worker, amount}) => (
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
