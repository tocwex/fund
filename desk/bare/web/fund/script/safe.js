import {
  getAccount, getClient, getPublicClient, getBalance, getBlockNumber,
  signMessage, readContract, writeContract, waitForTransactionReceipt,
} from 'https://esm.sh/@wagmi/core@2.x';
import {
  encodeFunctionData, encodePacked, keccak256,
  fromHex, toHex, fromBytes, toBytes, concat, parseUnits,
  recoverAddress, recoverMessageAddress, verifyMessage,
} from 'https://esm.sh/viem@2.x';
import { FUND_CHAIN, FUND_SIGN_ADDR, FUND_SAFE_ADDR } from '#urbit';
import { FUND_CUT, ADDRESS, CONTRACT } from './const.js';

//////////////////////
// Module Functions //
//////////////////////

export const txnGetURL = (address) => (
  `https://${
    (FUND_CHAIN === "mainnet") ? "" : `${FUND_CHAIN}.`
  }etherscan.io/tx/${address}`
);

export const safeGetURL = (address) => (
  `https://app.safe.global/home?safe=${
    (FUND_CHAIN === "mainnet") ? "" : `${FUND_CHAIN.substring(0, 3)}:`
  }${address}`
);

export const safeGetBlock = async () => {
  const block = await getBlockNumber(window.Wagmi);
  return block.toString();
};

// TODO: safeSignDeploy
export const safeSign = async ({projectContent}) => {
  const { address } = getAccount(window.Wagmi);
  const signature = await signMessage(window.Wagmi, {
    account: address,
    message: projectContent,
  });
  return [address, signature];
};

// TODO: safeExecDeploy
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
          [workerAddress, oracleAddress, FUND_SIGN_ADDR], 2n,
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

// TODO: safeDeposit
export const safeDepositFunds = async ({fundAmount, fundToken, safeAddress}) => {
  const TOKEN = safeTransactionToken();
  const { address: funderAddress } = getAccount(window.Wagmi);
  // const tokenDecimals = await readContract(window.Wagmi, {
  //   abi: TOKEN.ABI,
  //   address: TOKEN.ADDRESS,
  //   functionName: "decimals",
  // });
  const sendTransaction = await writeContract(window.Wagmi, {
    abi: TOKEN.ABI,
    address: TOKEN.ADDRESS,
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

export const safeSignClaim = async ({safeAddress, fundAmount, workerAddress, oracleCut}) => {
  const { address: oracleAddress } = getAccount(window.Wagmi);
  const transactions = await safeGetClaimTransactions({
    fundAmount,
    workerAddress,
    oracleAddress,
    oracleCut,
  });
  return safeSignWithdrawal({transactions, oracleAddress, safeAddress});
};

export const safeExecClaim = async ({safeAddress, fundAmount, oracleSignature, oracleAddress, oracleCut}) => {
  const { address: workerAddress } = getAccount(window.Wagmi);
  const transactions = await safeGetClaimTransactions({
    fundAmount,
    workerAddress,
    oracleAddress,
    oracleCut,
  });
  return safeExecWithdrawal({transactions, oracleSignature, oracleAddress, workerAddress, safeAddress});
};

export const safeSignRefund = async ({safeAddress, safeInitBlock}) => {
  const { address: oracleAddress } = getAccount(window.Wagmi);
  const transactions = await safeGetRefundTransactions({safeAddress, safeInitBlock});
  return safeSignWithdrawal({transactions, oracleAddress, safeAddress});
};

export const safeExecRefund = async ({safeAddress, safeInitBlock, oracleSignature, oracleAddress}) => {
  const { address: workerAddress } = getAccount(window.Wagmi);
  const transactions = await safeGetRefundTransactions({safeAddress, safeInitBlock});
  return safeExecWithdrawal({transactions, oracleSignature, oracleAddress, workerAddress, safeAddress});
};

//////////////////////
// Helper Functions //
//////////////////////

// type Token = "usdc" | "usdt" | "dai";
// interface Cut = {cut: number, to: `0x${string}`};
// interface Transaction = {id: Token, amt: bigint, to: `0x${string}`};

const safeNextSaltNonce = () => (fromHex(keccak256(toHex(Date.now())), "bigint"));
const safeTransactionToken = ({id = "usdc"} = {}) => (CONTRACT["USDC"]); // (CONTRACT[id.toUpperCase()]);

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

const safeGetClaimTransactions = async ({fundAmount, workerAddress, oracleAddress, oracleCut}) => {
  const adminCuts = [
    {to: FUND_SAFE_ADDR, cut: FUND_CUT},
    {to: oracleAddress, cut: Number(oracleCut) / 100.0},
    {to: workerAddress, cut: 1.0 - (FUND_CUT + (Number(oracleCut) / 100.0))},
  ];
  return safeGetTransactions({amount: fundAmount, cuts: adminCuts});
};

const safeGetRefundTransactions = async ({safeAddress, safeInitBlock}) => {
  const TOKEN = safeTransactionToken();
  const safeBalance = await getBalance(window.Wagmi, {
    address: safeAddress,
    token: TOKEN.ADDRESS,
  });
  const safeCurrTotal = Number(safeBalance.formatted);
  // FIXME: If there are ever projects that exceed ~2k contributions, this will
  // need to be changed to paginate RPC queries.
  const transferLogs = await getPublicClient(window.Wagmi).getContractEvents({
    address: TOKEN.ADDRESS,
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
  return safeGetTransactions({amount: safeCurrTotal, cuts: contribCuts});
};

const safeGetTransactions = ({amount, cuts}) => {
  // NOTE: "amount" is a "Number" of decimal presentation, which is then
  // converted to a "BigInt" for fractionalizing
  const transactionMap = cuts
    .map(({cut, to}) => ({
      to: to,
      id: "usdc",
      // TODO: Will this work for all values? Can this overflow the
      // Number type? Can this also create problems with difficult cut
      // fractions?
      amt:  BigInt(Math.round(amount * cut * 10 ** CONTRACT["USDC"].DECIMALS)),
    })).reduce((acc, {to, id, amt}) => {
      const tid = `${id}:${to}`;
      let cur = acc[tid] ?? {to, id, amt: 0n};
      acc[tid] = {to, id, amt: cur.amt + amt};
      return acc;
    }, {});
  const transactions = Object.values(transactionMap)
    .filter(({to, id, amt}) => (amt > 0n))
    .sort(safeAddressSort(v => v.to));

  // FIXME: Make stronger guarantees about rounding and then remove this check
  const bigintAmount = BigInt(Math.round(amount * 10 ** CONTRACT["USDC"].DECIMALS));
  const bigintTotal = transactions.reduce((acc, {amt}) => acc + amt, 0n);
  if (bigintAmount !== bigintTotal) {
    throw new Error(`Mismatch between requested transaction total and refund total: (${bigintAmount}, ${bigintTotal})`);
  }

  return transactions;
};

const safeGetWithdrawalArgs = async ({safe, transactions}) => {
  // TODO: Figure out if we want to support extracting funds in
  // an arbitrary order by milestone... as it is, this always uses
  // the latest nonce for a safe and thus the extractions must be
  // sequential and occur before the subsequent milestone evaluation
  // - NOTE: Best method is probably to allow arbitrary extraction, but
  //   to revoke an approval when using the signature doesn't work (e.g.
  //   if the user brings their own safe and has transactions in the
  //   meantime, or if the extractions occur out of order).
  console.log(`constructing transaction for safe ${safe} with arguments:`);
  console.log(transactions);
  const isDelegateCall = (transactions.length > 1) ? 1 : 0;
  const transactionContract = !isDelegateCall
    ? safeTransactionToken(transactions[0]).ADDRESS
    : CONTRACT.SAFE_MULTISEND.ADDRESS;
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
              [0, TOKEN.ADDRESS, 0n, (encodedTransaction.length - 2) / 2, encodedTransaction],
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
