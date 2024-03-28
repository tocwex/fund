import {
  getAccount, getBlockNumber, signMessage,
  readContract, writeContract, waitForTransactionReceipt,
} from 'https://esm.sh/@wagmi/core@2.x';
import {
  encodeFunctionData, encodePacked, keccak256,
  fromHex, toHex, fromBytes, toBytes, concat, parseUnits,
  recoverAddress, recoverMessageAddress,
} from 'https://esm.sh/viem@2.x';
import { DEBUG_MODE, ADDRESS, CONTRACT } from './const.js';

//////////////////////
// Module Functions //
//////////////////////

export const txnGetURL = (address) => (
  `https://${!DEBUG_MODE ? "" : "sepolia."}etherscan.io/tx/${address}`
);

export const safeGetURL = (address) => (
  `https://app.safe.global/home?safe=${!DEBUG_MODE ? "" : "sep:"}${address}`
);

export const safeGetBlock = async () => {
  const block = await getBlockNumber(window.Wagmi);
  return block.toString();
};

export const safeSign = async ({projectContent}) => {
  const { address } = getAccount(window.Wagmi);
  const signature = await signMessage(window.Wagmi, {
    account: address,
    message: projectContent,
  });
  return [address, signature];
};

export const safeDeploy = async ({oracleAddress}) => {
  const { address: workerAddress } = getAccount(window.Wagmi);
  const deployTransaction = await writeContract(window.Wagmi, {
    abi: CONTRACT.SAFE_PROXYFACTORY.ABI,
    address: CONTRACT.SAFE_PROXYFACTORY.ADDRESS,
    functionName: "createProxyWithNonce",
    args: [
      CONTRACT.SAFE_TEMPLATE.ADDRESS,
      encodeFunctionData({
        abi: CONTRACT.SAFE_TEMPLATE.ABI,
        functionName: "setup",
        args: [
          [workerAddress, oracleAddress], 2n,
          // TODO: Module setup info (module address, payload) needs to go here
          ADDRESS.NULL, "",
          CONTRACT.SAFE_FALLBACK.ADDRESS,
          // TODO: Payment info (token, value receiver) (?) needs to go here
          ADDRESS.NULL, 0n, ADDRESS.NULL,
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
  return [
    deployReceipt.blockNumber.toString(),
    deployReceipt.transactionHash,
    workerAddress,
    oracleAddress,
    safeAddress,
  ];
};

export const safeSendFunds = async ({fundAmount, fundToken, safeAddress}) => {
  const { address: funderAddress } = getAccount(window.Wagmi);
  // TODO: Swap out the appropriate ERC-20 address based on user input
  const currencyDecimals = await readContract(window.Wagmi, {
    abi: CONTRACT.USDC.ABI,
    address: CONTRACT.USDC.ADDRESS,
    functionName: "decimals",
  });
  const sendTransaction = await writeContract(window.Wagmi, {
    abi: CONTRACT.USDC.ABI,
    address: CONTRACT.USDC.ADDRESS,
    functionName: "transfer",
    args: [
      safeAddress,
      parseUnits(fundAmount, currencyDecimals),
    ],
  });
  const sendReceipt = await waitForTransactionReceipt(window.Wagmi, {
    hash: sendTransaction,
  });
  return [
    funderAddress,
    sendReceipt.blockNumber.toString(),
    sendReceipt.transactionHash,
  ];
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
          : encodePacked(["uint256", "uint256", "uint8"], [address, ADDRESS.NULL, 1])
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
    0n, 0n, 0n, ADDRESS.NULL, ADDRESS.NULL,
    safeNonce,
  ]))
);
