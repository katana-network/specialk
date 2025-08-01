// Example of how to use the generated address mapping

import getContractAddress, { CHAIN_IDS, CONTRACT_ADDRESSES } from './addresses.js';

// Option 1: Get address by contract name and chain ID
const tataraWETH = getContractAddress('WETH', CHAIN_IDS.TATARA);
console.log('WETH address on Tatara:', tataraWETH);

// Option 2: Get address from the mapping directly
const morphoAddress = CONTRACT_ADDRESSES.MorphoBlue.tatara;
console.log('Morpho Blue address on Tatara:', morphoAddress);

// Option 3: Checking if an address exists before using it
const chainId = CHAIN_IDS.TATARA; // Could come from a wallet connection
const contractName = 'Seaport';

const seaportAddress = getContractAddress(contractName, chainId);
if (seaportAddress) {
  console.log(`Using ${contractName} at ${seaportAddress}`);
} else {
  console.log(`${contractName} not available on chain ID ${chainId}`);
}

// Option 4: Getting all available contracts on a specific chain
function getContractsForChain(chainId) {
  const network = chainId === CHAIN_IDS.TATARA ? 'tatara' : 'katana';
  return Object.entries(CONTRACT_ADDRESSES)
    .filter(([_, addresses]) => addresses[network] !== null)
    .map(([name, addresses]) => ({
      name,
      address: addresses[network]
    }));
}

const tataraContracts = getContractsForChain(CHAIN_IDS.TATARA);
console.log('Available contracts on Tatara:', tataraContracts.length);