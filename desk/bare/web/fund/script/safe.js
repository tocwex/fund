import {
  getAccount, getClient, getChainId, getPublicClient, getBalance, getBlockNumber,
  signMessage, readContract, writeContract, waitForTransactionReceipt,
} from 'https://esm.sh/@wagmi/core@2.10.0';
import {
  encodeFunctionData, encodePacked, keccak256,
  fromHex, toHex, fromBytes, toBytes, concat, parseUnits,
  recoverAddress, recoverMessageAddress, verifyMessage,
} from 'https://esm.sh/viem@2.16.0';
import BigNumber from 'https://cdn.jsdelivr.net/npm/bignumber.js@9.1.2/+esm'
import { FUND_SIGN_ADDR, FUND_SAFE_ADDR } from './config.js';
import { FUND_CUT, ADDRESS, NETWORK, ABI, CONTRACT } from './const.js';

//////////////////////
// Module Functions //
//////////////////////

export const ethGetChain = () => (NETWORK.NAME?.[getChainId(window.Wagmi)] ?? NETWORK.NAME[1]);

export const txnGetURL = (address) => {
  const chain = ethGetChain().toLowerCase();
  return `https://${
    (chain === "ethereum") ? "" : `${chain}.`
  }etherscan.io/tx/${address}`
};

export const nftsGetURL = (wallet, chainId, token) => {
  const chainName = NETWORK.NAME[chainId];
   const queryUrl = new URL(`https://eth${
     (chainId === NETWORK.ID.ETHEREUM) ? "-mainnet"
     : (chainId === NETWORK.ID.SEPOLIA) ? "-sepolia"
     : ""
   }.g.alchemy.com/nft/v3/${NETWORK.APIKEY[chainName]}/getNFTsForOwner`);

   queryUrl.searchParams.append("owner", wallet);
   queryUrl.searchParams.append("contractAddresses[]",
     CONTRACT[token.toUpperCase()].ADDRESS[chainName]);
   queryUrl.searchParams.append("withMetadata", "true");
   queryUrl.searchParams.append("pageSize", "100");

  return queryUrl;
}

export const safeGetURL = (address) => {
  const chain = ethGetChain().toLowerCase();
  return `https://app.safe.global/home?safe=${
    (chain === "ethereum") ? "" : `${chain.substring(0, 3)}:`
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

export const nftsGetAll = async (wallet, chainId, token) => {
  const getNFTs = (pageKey = undefined, results = [], isLastCall = false) => {
    const queryUrl = nftsGetURL(wallet, chainId, token);
    if (pageKey !== undefined) {
      queryUrl.searchParams.append("pageKey", pageKey);
    }
    return isLastCall
      ? new Promise(resolve => resolve(results))
      : fetch(queryUrl)
          .then(response => response.json())
          .then(json => getNFTs(
            json.pageKey,
            results.concat(json?.ownedNfts ?? []),
            json.ownedNfts.length < 100 || json.pageKey === undefined,
          ));
  };
  return getNFTs();
}

export const safeGetBalance = async ({fundToken, safeAddress}) => {
  const TOKEN = safeTransactionToken({tok: fundToken});
  if (TOKEN.ABI === ABI.ERC20) {
    const safeBalance = await getBalance(window.Wagmi, {
      address: safeAddress,
      token: TOKEN.ADDRESS[ethGetChain()],
    });
    return Number(safeBalance.formatted);
  } else if (TOKEN.ABI === ABI.ERC721) {
    const nftsUrl = nftsGetURL(safeAddress, getChainId(window.Wagmi), fundToken);
    return fetch(nftsUrl)
      .then(response => response.json())
      .then(json => json.totalCount);
  } else {
    throw new SafeError(`error with getting chain balance; unsupported token type`);
  }
};

export const safeGetTransfers = async ({fundToken, safeAddress, safeInitBlock}) => {
  const TOKEN = safeTransactionToken({tok: fundToken});
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
  return transferLogs;
};

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

export const safeExecDeposit = async ({projectChain, fundAmount, fundToken, fundTransfers, safeAddress}) => {
  const TOKEN = safeTransactionToken({tok: fundToken});
  if ((TOKEN.ABI === ABI.ERC721) && fundAmount !== '' && Number(fundAmount) !== fundTransfers.length)
    throw new SafeError(`pledge mismatch; pledged ${fundAmount} NFTs but selected ${fundTransfers.length}`);

  const { address: funderAddress } = safeGetAccount(projectChain);
  const wrappedTransaction = safeWrapTransactions(
    fundTransfers.map(tokenId => ({
      tok: fundToken,
      val: (TOKEN.ABI === ABI.ERC721) ? tokenId : parseUnits(fundAmount, TOKEN.DECIMALS),
      from: getAccount(window.Wagmi)?.address,
      to: safeAddress,
    }))
  );

  const sendTransaction = await writeContract(window.Wagmi, wrappedTransaction);
  const sendReceipt = await waitForTransactionReceipt(window.Wagmi, {
    hash: sendTransaction,
  });
  return [
    funderAddress,
    sendReceipt.blockNumber.toString(),
    sendReceipt.transactionHash,
  ];
};

export const safeSignClaim = async ({projectChain, safeAddress, fundAmount, fundToken, workerAddress, oracleCut, safeInitBlock}) => {
  const { address: oracleAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetClaimTransactions({
    projectChain,
    fundAmount,
    fundToken,
    safeAddress,
    workerAddress,
    oracleAddress,
    oracleCut,
    safeInitBlock,
  });
  return safeSignWithdrawal({transactions, oracleAddress, safeAddress});
};

export const safeExecClaim = async ({projectChain, safeAddress, fundAmount, fundToken, oracleSignature, oracleAddress, oracleCut, safeInitBlock}) => {
  const { address: workerAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetClaimTransactions({
    projectChain,
    fundAmount,
    fundToken,
    safeAddress,
    workerAddress,
    oracleAddress,
    oracleCut,
    safeInitBlock,
  });
  return safeExecWithdrawal({transactions, oracleSignature, oracleAddress, workerAddress, safeAddress});
};

export const safeSignRefund = async ({projectChain, fundToken, safeAddress, safeInitBlock}) => {
  const { address: oracleAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetRefundTransactions({projectChain, fundToken, safeAddress, safeInitBlock});
  return safeSignWithdrawal({transactions, oracleAddress, safeAddress});
};

export const safeExecRefund = async ({projectChain, fundToken, safeAddress, safeInitBlock, oracleSignature, oracleAddress}) => {
  const { address: workerAddress } = safeGetAccount(projectChain);
  const transactions = await safeGetRefundTransactions({projectChain, fundToken, safeAddress, safeInitBlock});
  return safeExecWithdrawal({transactions, oracleSignature, oracleAddress, workerAddress, safeAddress});
};

//////////////////////
// Helper Functions //
//////////////////////

//
// interface Cut = {cut: number, to: `0x${string}`};
// interface Transaction = {tok: Token, val: bigint, from: `0x${string}`, to: `0x${string}`};
// interface WrappedTransaction = {abi: object, functionName: string, args: string[]};
//

// Solution from: https://stackoverflow.com/a/871646/837221
export function SafeError(message = "") {
    this.name = "SafeError";
    this.message = message;
}; SafeError.prototype = Error.prototype;

const safeNextSaltNonce = () => (fromHex(keccak256(toHex(Date.now())), "bigint"));
const safeTransactionToken = ({tok = "usdc"} = {}) => (CONTRACT[tok.toUpperCase()]);

const safeAddressSort = (getAddress = (v) => v) => (a, b) => {
  return (([a, b]) => (a === b) ? 0 : ((a < b) ? -1 : 1))(
    [a, b].map(v => fromHex(getAddress(v), "bigint")));
};

const safeWrapTransaction = ({tok, val, from, to}) => {
  const TOKEN = safeTransactionToken({tok, val, from, to});
  return {
    abi: TOKEN.ABI,
    address: TOKEN.ADDRESS[ethGetChain()],
    ...((TOKEN.ABI === ABI.ERC20) ? {
      functionName: "transfer",
      args: [to, val],
    } : (TOKEN.ABI === ABI.ERC721) ? {
      functionName: "safeTransferFrom",
      args: [from, to, val],
    } : {}),
  };
};

const safeGetClaimTransactions = async ({projectChain, fundAmount, fundToken, safeAddress, workerAddress, oracleAddress, oracleCut, safeInitBlock}) => {
  const TOKEN = safeTransactionToken({tok: fundToken});
  if (TOKEN.ABI === ABI.ERC20) {
    const ORACLE_CUT = Number(oracleCut) / 100.0;
    const adminCuts = [
      {to: FUND_SAFE_ADDR, cut: FUND_CUT},
      {to: oracleAddress, cut: ORACLE_CUT},
      {to: workerAddress, cut: 1.0 - (FUND_CUT + ORACLE_CUT)},
    ];
    return safeDistribTransactions({
      token: fundToken,
      safe: safeAddress,
      amount: fundAmount,
      cuts: adminCuts,
    });
  } else if (TOKEN.ABI === ABI.ERC721) {
    const transfers = await safeGetTransfers({fundToken, safeAddress, safeInitBlock});
    const remainingTokens = await nftsGetAll(safeAddress, projectChain, fundToken);
    const validTokenSet = new Set(remainingTokens.filter(nft => (
      (nft?.raw?.metadata?.attributes ?? []).some(attr => (
        (attr?.trait_type === "size" && attr?.value === "star")
      ))
    )).map(nft => nft.tokenId));
    const claims = transfers
      .filter(({args: {tokenId}}) => validTokenSet.has(String(tokenId)))
      .sort((a, b) => (b.blockHeight - a.blockHeight))
      .slice(0, fundAmount)
      .map(({args: {from, to, tokenId}}) => ({
        from: safeAddress,
        to: workerAddress,
        val: tokenId,
        tok: fundToken,
      }));
    return claims;
  } else {
    throw new SafeError(`error with calculating claim transactions; unsupported token type`);
  }
};

const safeGetRefundTransactions = async ({projectChain, fundToken, safeAddress, safeInitBlock}) => {
  const TOKEN = safeTransactionToken({tok: fundToken});
  const transfers = await safeGetTransfers({fundToken, safeAddress, safeInitBlock});
  if (TOKEN.ABI === ABI.ERC20) {
    const safeCurrTotal = await safeGetBalance({fundToken, safeAddress});
    const contributors = transfers.reduce((acc, {args: {from, value}}) => {
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
    return safeDistribTransactions({
      token: fundToken,
      safe: safeAddress,
      amount: safeCurrTotal,
      cuts: contribCuts,
    });
  } else if (TOKEN.ABI === ABI.ERC721) {
    const remainingTokens = await nftsGetAll(safeAddress, projectChain, fundToken);
    const validTokenSet = new Set(remainingTokens.filter(nft => (
      (nft?.raw?.metadata?.attributes ?? []).some(attr => (
        (attr?.trait_type === "size" && attr?.value === "star")
      ))
    )).map(nft => nft.tokenId));
    const refunds = transfers
      .filter(({args: {tokenId}}) => validTokenSet.has(String(tokenId)))
      .map(({args: {from, to, tokenId}}) => ({
        from: safeAddress,
        to: from,
        val: tokenId,
        tok: fundToken,
      }));
    return refunds;
  } else {
    throw new SafeError(`error with calculating refund transactions; unsupported token type`);
  }
};

// NOTE: "amount" is a "Number" of decimal presentation, which is then
// converted to a "BigInt" for fractionalizing
const safeDistribTransactions = ({token, safe, amount, cuts}) => {
  const TOKEN = safeTransactionToken({tok: token});
  if (TOKEN.ABI !== ABI.ERC20)
    throw new SafeError(`cannot calculate a token distribution for non-ERC20 token '${token}'`);

  const transactionMap = cuts
    .map(({cut, to}) => ({
      from: safe,
      to: to,
      tok: token,
      val: (new BigNumber(10)).pow(TOKEN.DECIMALS).times(amount).times(cut).integerValue(),
    })).reduce((acc, {from, to, tok, val}) => {
      const tid = `${tok}:${from}:${to}`;
      let cur = acc[tid] ?? {from, to, tok, val: BigNumber(0)};
      acc[tid] = {from, to, tok, val: cur.val.plus(val)};
      return acc;
    }, {});
  const transactions = Object.values(transactionMap)
    .map(({from, to, tok, val}) => ({from, to, tok, val: BigInt(val.toString())}))
    .filter(({from, to, tok, val}) => (val > 0n))
    .sort(safeAddressSort(v => v.to));

  const transactionTotal = transactions.reduce((acc, {val}) => acc + val, 0n);
  const bigintAmount = BigInt((new BigNumber(10)).pow(TOKEN.DECIMALS).times(amount).toString());
  const transactionRemainder = (([a, b]) => b - a)([transactionTotal, bigintAmount].sort());
  // NOTE: This _can_ happen (e.g. {cuts: [0.33333, 0.66666], amount: 1000000});
  // just make sure the amount is _relatively_ small
  if (transactionRemainder > 100n) {
    throw new SafeError(`big roundoff when distributing costs: ${transactionRemainder}`);
  } else if (transactionRemainder !== 0n) {
    transactions[0].val += transactionRemainder;
  }

  return transactions;
};

const safeWrapTransactions = (transactions) => {
  console.log(`constructing wrapped transaction with arguments:`);
  console.log(transactions);
  return (transactions.length === 1)
    ? safeWrapTransaction(transactions[0])
    : {
      abi: CONTRACT.SAFE_MULTISEND.ABI,
      address: CONTRACT.SAFE_MULTISEND.ADDRESS[ethGetChain()],
      functionName: "multiSend",
      args: [encodePacked(["bytes[]"], [
        transactions.map(transaction => {
          const TOKEN = safeTransactionToken(transaction);
          const encodedTransaction = encodeFunctionData(safeWrapTransaction(transaction));
          const encodedByteCount = (encodedTransaction.length - 2) / 2;
          return encodePacked(
            // NOTE: 0, callAddress, value (eth), call data length (bytes), call data
            // sepolia.etherscan.io/address/0xa1dabef33b3b82c7814b6d82a79e50f4ac44102b#code#F1#L10
            ["uint8", "address", "uint256", "uint256", "bytes"],
            [0, TOKEN.ADDRESS[ethGetChain()], 0n, encodedByteCount, encodedTransaction],
          );
        })
      ])],
    };
}

const safeGetWithdrawalArgs = async ({safe, transactions}) => {
  if (transactions.length === 0)
    throw new SafeError(`unable to construct withdrawal for safe; no transactions provided (probably no funds available)`);
  const wrappedTransaction = safeWrapTransactions(transactions);
  const safeNonce = await readContract(window.Wagmi, {
    abi: CONTRACT.SAFE_TEMPLATE.ABI,
    address: safe,
    functionName: "nonce",
  });

  return [
    wrappedTransaction.address,
    // sepolia.etherscan.io/address/0xfb1bffC9d739B8D520DaF37dF666da4C687191EA#code#F12#L7
    // NOTE: amount (eth), data (transaction calls)
    0n, encodeFunctionData(wrappedTransaction),
    //  NOTE: isDelegateCall?
    (wrappedTransaction.abi === CONTRACT.SAFE_MULTISEND.ABI) ? 1 : 0,
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
