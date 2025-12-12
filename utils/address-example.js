// Example of how to use the generated address mapping

import getContractAddress, { CHAIN_IDS, CONTRACT_ADDRESSES } from './addresses.js';

// Option 1: Get address by contract name and chain ID
const bokutoWETH = getContractAddress('WETH', CHAIN_IDS.BOKUTO);
console.log('WETH address on Bokuto:', bokutoWETH);

// Option 2: Get address from the mapping directly
const morphoAddress = CONTRACT_ADDRESSES.MorphoBlue.bokuto;
console.log('Morpho Blue address on Bokuto:', morphoAddress);

// Option 3: Checking if an address exists before using it
const chainId = CHAIN_IDS.BOKUTO; // Could come from a wallet connection
const contractName = 'Seaport';

const seaportAddress = getContractAddress(contractName, chainId);
if (seaportAddress) {
  console.log(`Using ${contractName} at ${seaportAddress}`);
} else {
  console.log(`${contractName} not available on chain ID ${chainId}`);
}

// Option 4: Getting all available contracts on a specific chain
function getContractsForChain(chainId) {
  const network = chainId === CHAIN_IDS.BOKUTO ? 'bokuto' : 'katana';
  return Object.entries(CONTRACT_ADDRESSES)
    .filter(([_, addresses]) => addresses[network] !== null)
    .map(([name, addresses]) => ({
      name,
      address: addresses[network]
    }));
}

const bokutoContracts = getContractsForChain(CHAIN_IDS.BOKUTO);
console.log('Available contracts on Bokuto:', bokutoContracts.length);