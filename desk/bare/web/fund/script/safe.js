import {
  getAccount, getClient, getChainId, getPublicClient, getBalance, getBlockNumber,
  signMessage, readContract, writeContract, waitForTransactionReceipt,
} from 'https://esm.sh/@wagmi/core@2.x';
import {
  encodeFunctionData, encodePacked, keccak256,
  fromHex, toHex, fromBytes, toBytes, concat, parseUnits,
  recoverAddress, recoverMessageAddress, verifyMessage,
} from 'https://esm.sh/viem@2.x';
import BigNumber from 'https://cdn.jsdelivr.net/npm/bignumber.js@9.1.2/+esm'
import { FUND_SIGN_ADDR, FUND_SAFE_ADDR } from './config.js';
import { FUND_CUT, ADDRESS, NETWORK, CONTRACT } from './const.js';

//////////////////////
// Module Functions //
//////////////////////

export const ethGetChain = () => (NETWORK.NAME?.[getChainId(window.Wagmi)] ?? NETWORK.NAME[1]);

export const txnGetURL = (address) => {
  const chain = ethGetChain().toLowerCase();
  return `https://${
    (chain === "mainnet") ? "" : `${chain}.`
  }etherscan.io/tx/${address}`
};

export const safeGetURL = (address) => {
  const chain = ethGetChain().toLowerCase();
  return `https://app.safe.global/home?safe=${
    (chain === "mainnet") ? "" : `${chain.substring(0, 3)}:`
  }${address}`;
};

export const safeGetBlock = async () => {
  const block = await getBlockNumber(window.Wagmi);
  return block.toString();
};

export const safeGetAccount = (chainId) => {
  const account = getAccount(window.Wagmi);
  if (account.isDisconnected)
    throw new SafeError(`wallet not connected; please click the 'connect' button in the top-right corner of the page to continue`);
  if (account.chain === undefined)
    throw new SafeError(`error with blockchain network; unable to recognize connected network`);
  if (NETWORK.NAME?.[account.chain.id] === undefined)
    throw new SafeError(`error with blockchain network; the chain ${account.chain.id} is unsupported`);
  if (chainId !== undefined && account.chain.id !== chainId)
    throw new SafeError(`using the wrong blockchain network for this project; please switch your network to '${NETWORK.NAME[chainId].toLowerCase()}' instead`);
  return account;
}

export const safeSignDeploy = async ({projectChain, projectContent}) => {
  const { address } = safeGetAccount(projectChain);
  const signature = await signMessage(window.Wagmi, {
    account: address,
    message: projectContent,
  });
  return [address, signature];
};

export const safeExecDeploy = async ({projectChain, oracleAddress}) => {
  const { address: workerAddress } = safeGetAccount(projectChain);
  if (fromHex(oracleAddress, "bigint") === fromHex(workerAddress, "bigint"))
    throw new SafeError(`cannot use the same wallet for the worker and oracle: ${workerAddress}`);
  const deployTransaction = await writeContract(window.Wagmi, {
    abi: CONTRACT.SAFE_PROXYFACTORY.ABI,
    address: CONTRACT.SAFE_PROXYFACTORY.ADDRESS[ethGetChain()],
    functionName: "createProxyWithNonce",
    args: [
      CONTRACT.SAFE_TEMPLATE.ADDRESS[ethGetChain()],
      encodeFunctionData({
        abi: CONTRACT.SAFE_TEMPLATE.ABI,
        functionName: "setup",
        args: [
          [workerAddress, oracleAddress, FUND_SIGN_ADDR], 2n,
          // TODO: Post-setup logic (contract address, call params) needs to go here
          ADDRESS.NULL, "",
          CONTRACT.SAFE_FALLBACK.ADDRESS[ethGetChain()],
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

export const safeExecDeposit = async ({projectChain, fundAmount, fundToken, safeAddress}) => {
  const TOKEN = safeTransactionToken({id: fundToken});
  const { address: funderAddress } = safeGetAccount(projectChain);
  // const tokenDecimals = await readContract(window.Wagmi, {
  //   abi: TOKEN.ABI,
  //   address: TOKEN.ADDRESS[ethGetChain()],
  //   functionName: "decimals",
  // });
  const sendTransaction = await writeContract(window.Wagmi, {
    abi: TOKEN.ABI,
    address: TOKEN.ADDRESS[ethGetChain()],
    functionName: "transfer",
    args: [
      safeAddress,
      parseUnits(fundAmount, TOKEN.DECIMALS),
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

export const safeSignClaim = async ({projectChain, safeAddress, fundAmount, fundToken, workerAddress, oracleCut}) => {
  const { address: oracleAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetClaimTransactions({
    fundAmount,
    fundToken,
    workerAddress,
    oracleAddress,
    oracleCut,
  });
  return safeSignWithdrawal({transactions, oracleAddress, safeAddress});
};

export const safeExecClaim = async ({projectChain, safeAddress, fundAmount, fundToken, oracleSignature, oracleAddress, oracleCut}) => {
  const { address: workerAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetClaimTransactions({
    fundAmount,
    fundToken,
    workerAddress,
    oracleAddress,
    oracleCut,
  });
  return safeExecWithdrawal({transactions, oracleSignature, oracleAddress, workerAddress, safeAddress});
};

export const safeSignRefund = async ({projectChain, fundToken, safeAddress, safeInitBlock}) => {
  const { address: oracleAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetRefundTransactions({fundToken, safeAddress, safeInitBlock});
  return safeSignWithdrawal({transactions, oracleAddress, safeAddress});
};

export const safeExecRefund = async ({projectChain, fundToken, safeAddress, safeInitBlock, oracleSignature, oracleAddress}) => {
  const { address: workerAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetRefundTransactions({fundToken, safeAddress, safeInitBlock});
  return safeExecWithdrawal({transactions, oracleSignature, oracleAddress, workerAddress, safeAddress});
};

//////////////////////
// Helper Functions //
//////////////////////

// type Token = "usdc" | "usdt" | "dai";
// interface Cut = {cut: number, to: `0x${string}`};
// interface Transaction = {id: Token, amt: bigint, to: `0x${string}`};

// Solution from: https://stackoverflow.com/a/871646/837221
export function SafeError(message = "") {
    this.name = "SafeError";
    this.message = message;
}; SafeError.prototype = Error.prototype;

const safeNextSaltNonce = () => (fromHex(keccak256(toHex(Date.now())), "bigint"));
const safeTransactionToken = ({id = "usdc"} = {}) => (CONTRACT[id.toUpperCase()]);

const safeAddressSort = (getAddress = (v) => v) => (a, b) => {
  return (([a, b]) => (a === b) ? 0 : ((a < b) ? -1 : 1))(
    [a, b].map(v => fromHex(getAddress(v), "bigint")));
};

const safeEncodeTransaction = ({id, amt, to}) => {
  return encodeFunctionData({
    abi: safeTransactionToken({id, amt, to}).ABI,
    functionName: "transfer",
    args: [to, amt],
  });
};

const safeGetClaimTransactions = async ({fundAmount, fundToken, workerAddress, oracleAddress, oracleCut}) => {
  const adminCuts = [
    {to: FUND_SAFE_ADDR, cut: FUND_CUT},
    {to: oracleAddress, cut: Number(oracleCut) / 100.0},
    {to: workerAddress, cut: 1.0 - (FUND_CUT + (Number(oracleCut) / 100.0))},
  ];
  return safeGetTransactions({token: fundToken, amount: fundAmount, cuts: adminCuts});
};

const safeGetRefundTransactions = async ({fundToken, safeAddress, safeInitBlock}) => {
  const TOKEN = safeTransactionToken({id: fundToken});
  const safeBalance = await getBalance(window.Wagmi, {
    address: safeAddress,
    token: TOKEN.ADDRESS[ethGetChain()],
  });
  const safeCurrTotal = Number(safeBalance.formatted);
  // FIXME: If there are ever projects that exceed ~2k contributions, this will
  // need to be changed to paginate RPC queries.
  const transferLogs = await getPublicClient(window.Wagmi).getContractEvents({
    address: TOKEN.ADDRESS[ethGetChain()],
    abi: TOKEN.ABI,
    eventName: "Transfer",
    args: {to: safeAddress},
    fromBlock: BigInt(safeInitBlock),
    // toBlock: "safe",
  });
  const contributors = transferLogs.reduce((acc, {args: {from, value}}) => {
    let cur = acc[from] ?? 0n;
    acc[from] = cur + value;
    return acc;
  }, {});
  const safeFullTotal = Object.values(contributors).reduce((acc, val) => acc + val, 0n);
  const contribCuts = Object.entries(contributors).map(([from, value]) => ({
    to: from,
    // TODO: Can this sort of math ever overload the Number type? Should
    // these fractions be computed another way to prevent overflows?
    cut: Number(value) / Number(safeFullTotal),
  }));
  return safeGetTransactions({token: fundToken, amount: safeCurrTotal, cuts: contribCuts});
};

// NOTE: "amount" is a "Number" of decimal presentation, which is then
// converted to a "BigInt" for fractionalizing
const safeGetTransactions = ({token, amount, cuts}) => {
  const TOKEN = safeTransactionToken({id: token});
  const transactionMap = cuts
    .map(({cut, to}) => ({
      to: to,
      id: token,
      amt: (new BigNumber(10)).pow(TOKEN.DECIMALS).times(amount).times(cut).integerValue(),
    })).reduce((acc, {to, id, amt}) => {
      const tid = `${id}:${to}`;
      let cur = acc[tid] ?? {to, id, amt: BigNumber(0)};
      acc[tid] = {to, id, amt: cur.amt.plus(amt)};
      return acc;
    }, {});
  const transactions = Object.values(transactionMap)
    .map(({to, id, amt}) => ({to, id, amt: BigInt(amt.toString())}))
    .filter(({to, id, amt}) => (amt > 0n))
    .sort(safeAddressSort(v => v.to));

  const transactionTotal = transactions.reduce((acc, {amt}) => acc + amt, 0n);
  const bigintAmount = BigInt((new BigNumber(10)).pow(TOKEN.DECIMALS).times(amount).toString());
  const transactionRemainder = (([a, b]) => b - a)([transactionTotal, bigintAmount].sort());
  // NOTE: This _can_ happen (e.g. {cuts: [0.33333, 0.66666], amount: 1000000});
  // just make sure the amount is _relatively_ small
  if (transactionRemainder > 100n) {
    throw new SafeError(`big roundoff when distributing costs: ${transactionRemainder}`);
  } else if (transactionRemainder !== 0n) {
    transactions[0].amt += transactionRemainder;
  }

  return transactions;
};

const safeGetWithdrawalArgs = async ({safe, transactions}) => {
  if (transactions.length === 0)
    throw new SafeError(`unable to construct withdrawal for safe; no transactions provided (probably no funds available)`);
  console.log(`constructing transaction for safe ${safe} with arguments:`);
  console.log(transactions);
  const isDelegateCall = (transactions.length > 1) ? 1 : 0;
  const transactionContract = !isDelegateCall
    ? safeTransactionToken(transactions[0]).ADDRESS[ethGetChain()]
    : CONTRACT.SAFE_MULTISEND.ADDRESS[ethGetChain()];
  const transactionData = !isDelegateCall
    ? safeEncodeTransaction(transactions[0])
    : encodeFunctionData({
        abi: CONTRACT.SAFE_MULTISEND.ABI,
        functionName: "multiSend",
        args: [encodePacked(["bytes[]"], [
          transactions.map(transaction => {
            const TOKEN = safeTransactionToken(transaction);
            const encodedTransaction = safeEncodeTransaction(transaction);
            return encodePacked(
              // NOTE: 0, toAddress, value (eth), call data length (bytes), call data
              // sepolia.etherscan.io/address/0xa1dabef33b3b82c7814b6d82a79e50f4ac44102b#code#F1#L10
              ["uint8", "address", "uint256", "uint256", "bytes"],
              [0, TOKEN.ADDRESS[ethGetChain()], 0n, (encodedTransaction.length - 2) / 2, encodedTransaction],
            );
          })
        ])],
      });
  const safeNonce = await readContract(window.Wagmi, {
    abi: CONTRACT.SAFE_TEMPLATE.ABI,
    address: safe,
    functionName: "nonce",
  });
  return [
    transactionContract,
    // NOTE: amount (eth), data (transaction calls), isDelegateCall?
    // sepolia.etherscan.io/address/0xfb1bffC9d739B8D520DaF37dF666da4C687191EA#code#F12#L7
    0n, transactionData, isDelegateCall,
    // NOTE: safeTxGas, baseGas, gasPrice, gasToken, refundReceiver
    0n, 0n, 0n, ADDRESS.NULL, ADDRESS.NULL,
    safeNonce,
  ];
};

const safeSignWithdrawal = async ({transactions, oracleAddress, safeAddress})  => {
  const withdrawalArgs = await safeGetWithdrawalArgs({
    safe: safeAddress,
    transactions: transactions,
  });
  const approvalPayload = await readContract(window.Wagmi, {
    abi: CONTRACT.SAFE_TEMPLATE.ABI,
    address: safeAddress,
    functionName: "getTransactionHash",
    args: withdrawalArgs,
  });
  // FIXME: Use "signTypedData" here with Safe transaction spec instead
  const oracleSignature = await signMessage(window.Wagmi, {
    account: oracleAddress,
    message: { raw: approvalPayload },
  });
  return [oracleAddress, oracleSignature, approvalPayload];
};

const safeExecWithdrawal = async ({transactions, oracleSignature, oracleAddress, workerAddress, safeAddress})  => {
  const withdrawalArgs = await safeGetWithdrawalArgs({
    safe: safeAddress,
    transactions: transactions,
  });
  const withdrawTransaction = await writeContract(window.Wagmi, {
    abi: CONTRACT.SAFE_TEMPLATE.ABI,
    address: safeAddress,
    functionName: "execTransaction",
    // NOTE: In "execTransaction", we exchange the nonce for the signatures
    args: withdrawalArgs.slice(0, -1).concat([
      [workerAddress, oracleAddress]
        .sort(safeAddressSort())
        .map(address => (address === oracleAddress)
          // github.com/safe-global/safe-smart-account/blob/main/docs/signatures.md
          // sepolia.etherscan.io/address/0xfb1bffC9d739B8D520DaF37dF666da4C687191EA#code#F24#L295
          ? toHex(fromHex(oracleSignature, "bigint") + 4n, {size: 65})
          : encodePacked(["uint256", "uint256", "uint8"], [address, ADDRESS.NULL, 1])
        ).reduce((a, n) => concat([a, n]), "")
    ]),
  });
  const withdrawReceipt = await waitForTransactionReceipt(window.Wagmi, {
    hash: withdrawTransaction,
  });
  return [withdrawReceipt.blockNumber.toString(), withdrawReceipt.transactionHash];
};
