import {
  getAccount, getBlockNumber, signMessage,
  readContract, writeContract, waitForTransactionReceipt,
} from 'https://esm.sh/@wagmi/core@2.x';
import {
  encodeFunctionData, encodePacked, keccak256,
  fromHex, toHex, fromBytes, toBytes, concat, parseUnits,
  recoverAddress, recoverMessageAddress, verifyMessage,
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
          // TODO: Post-setup logic (contract address, call params) needs to go here
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
  // const tokenDecimals = await readContract(window.Wagmi, {
  //   abi: CONTRACT.USDC.ABI,
  //   address: CONTRACT.USDC.ADDRESS,
  //   functionName: "decimals",
  // });
  const sendTransaction = await writeContract(window.Wagmi, {
    abi: CONTRACT.USDC.ABI,
    address: CONTRACT.USDC.ADDRESS,
    functionName: "transfer",
    args: [
      safeAddress,
      parseUnits(fundAmount, CONTRACT.USDC.DECIMALS),
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

export const safeApproveWithdrawal = async ({fundAmount, workerAddress, safeAddress}) => {
  const { address: oracleAddress } = getAccount(window.Wagmi);
  const withdrawalArgs = await safeGetWithdrawalArgs({
    safe: safeAddress,
    worker: workerAddress,
    amount: fundAmount,
  });
  const approvalPayload = await readContract(window.Wagmi, {
    abi: CONTRACT.SAFE_TEMPLATE.ABI,
    address: safeAddress,
    functionName: "getTransactionHash",
    args: withdrawalArgs,
  });
  const oracleSignature = await signMessage(window.Wagmi, {
    account: oracleAddress,
    message: { raw: approvalPayload },
  });
  return [oracleAddress, oracleSignature, approvalPayload];
};

export const safeExecuteWithdrawal = async ({fundAmount, oracleSignature, oracleAddress, safeAddress}) => {
  const { address: workerAddress } = getAccount(window.Wagmi);
  const signerAddresses = [workerAddress, oracleAddress];
  const withdrawalArgs = await safeGetWithdrawalArgs({
    safe: safeAddress,
    worker: workerAddress,
    amount: fundAmount,
  });
  const withdrawTransaction = await writeContract(window.Wagmi, {
    abi: CONTRACT.SAFE_TEMPLATE.ABI,
    address: safeAddress,
    functionName: "execTransaction",
    // NOTE: In "execTransaction", we exchange the nonce for the signatures
    args: withdrawalArgs.slice(0, -1).concat([
      signerAddresses
        .map(hexAddress => fromHex(hexAddress, "bigint")).sort()
        .map(intAddress => signerAddresses.find(a => a.toLowerCase() === toHex(intAddress)))
        .map(address => (address === oracleAddress)
          // https://github.com/safe-global/safe-smart-account/blob/main/docs/signatures.md
          // https://sepolia.etherscan.io/address/0xfb1bffC9d739B8D520DaF37dF666da4C687191EA#code#F24#L295
          ? toHex(fromHex(oracleSignature, "bigint") + 4n)
          : encodePacked(["uint256", "uint256", "uint8"], [address, ADDRESS.NULL, 1])
        ).reduce((a, n) => concat([a, n]), "")
    ]),
  });
  const withdrawReceipt = await waitForTransactionReceipt(window.Wagmi, {
    hash: withdrawTransaction,
  });
  return [withdrawReceipt.blockNumber.toString(), withdrawReceipt.transactionHash];
};

//////////////////////
// Helper Functions //
//////////////////////

const safeNextSaltNonce = () => (
  fromHex(keccak256(toHex(Date.now())), "bigint")
);

const safeGetWithdrawalArgs = async ({safe, worker, amount}) => (
  // TODO: Add support for extracting multiple different kinds of
  // coins in a single transaction
  // TODO: Figure out the best method for extracting heterogeneous
  // funds (by type, by percentage of pool, by time, etc.)
  // TODO: Figure out if we want to support extracting funds in
  // an arbitrary order by milestone... as it is, this always uses
  // the latest nonce for a safe and thus the extractions must be
  // sequential and occur before the subsequent milestone evaluation
  // - NOTE: Best method is probably to allow arbitrary extraction, but
  //   to revoke an approval when using the signature doesn't work (e.g.
  //   if the user brings their own safe and has transactions in the
  //   meantime, or if the extractions occur out of order).
  readContract(window.Wagmi, {
    abi: CONTRACT.SAFE_TEMPLATE.ABI,
    address: safe,
    functionName: "nonce",
  }).then(safeNonce => ([
    CONTRACT.USDC.ADDRESS,
    0n, // NOTE: 0n is amount of ETH, which isn't supported
    encodeFunctionData({
      abi: CONTRACT.USDC.ABI,
      functionName: "transfer",
      args: [worker, parseUnits(amount, CONTRACT.USDC.DECIMALS)],
    }),
    // enum Operation {Call, DelegateCall}
    // 0 when transferring one token, 1 when transferring multiple
    // https://sepolia.etherscan.io/address/0xfb1bffC9d739B8D520DaF37dF666da4C687191EA#code#F12#L7
    0,
    // NOTE: safeTxGas, baseGas, gasPrice, gasToken, refundReceiver
    0n, 0n, 0n, ADDRESS.NULL, ADDRESS.NULL,
    safeNonce,
  ]))
);

const safeGetMultisendArgs = async () => {
  // TODO: Fill this in with parameter values instead of constant test values
  const transactions = [
    {id: "dai", amt: "2000", to: "0xcbBD2aAB5Ee509e8531AB407D48fC93CDc25e1aD"},
    {id: "usdc", amt: "3000", to: "0xcbBD2aAB5Ee509e8531AB407D48fC93CDc25e1aD"},
  ];
  const transactionCalls = transactions.map(({id, amt, to}) => {
    const TOKEN = CONTRACT[id.toUpperCase()];
    const transferCall = encodeFunctionData({
      abi: TOKEN.ABI,
      functionName: "transfer",
      args: [to, parseUnits(amt, TOKEN.DECIMALS)],
    });
    const transferCode = encodePacked(
      ["uint8", "address", "uint256", "uint256", "bytes"],
      [0, TOKEN.ADDRESS, 0n, (transferCall.length - 2) / 2, transferCall],
    );
    return transferCode;
  });

  return encodeFunctionData({
    abi: CONTRACT.SAFE_MULTICALL.ABI,
    functionName: "multiSend",
    args: [encodePacked(["bytes[]"], [transactionCalls])],
  });
};
