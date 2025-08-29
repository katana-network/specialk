#!/usr/bin/env node

import { parseAbi, formatEther, formatUnits, createPublicClient, http } from 'viem';
import { addresses, CHAIN_IDS } from '../utils/addresses/index.js';

// Configuration
const PORT = 8545;
const LOCAL_RPC_URL = `http://localhost:${PORT}`;

// Chain information
const CHAIN_INFO = {
  [CHAIN_IDS.TATARA]: { name: 'Tatara', symbol: 'ETH' },
  [CHAIN_IDS.KATANA]: { name: 'Katana', symbol: 'ETH' },
  [CHAIN_IDS.BOKUTO]: { name: 'Bokuto', symbol: 'ETH' }
};

// ABIs for the contracts we want to interact with
const ERC20_ABI = parseAbi([
  'function name() view returns (string)',
  'function symbol() view returns (string)',
  'function decimals() view returns (uint8)',
  'function totalSupply() view returns (uint256)',
  'function balanceOf(address) view returns (uint256)'
]);

const MORPHO_BLUE_ABI = parseAbi([
  'function owner() view returns (address)',
  'function feeRecipient() view returns (address)',
  'function isLltvEnabled(uint256 lltv) view returns (bool)'
]);

// Verify contracts by connecting to the fork
async function verifyContracts() {
  console.log('\n📋 Verifying contracts on the fork:');
  
  try {
    // Create a viem client connected to Anvil
    const client = createPublicClient({
      transport: http(LOCAL_RPC_URL),
    });

    // Wait for anvil to be fully ready 
    let retries = 10;
    while (retries > 0) {
      try {
        // Check if we can connect
        await client.getChainId();
        break;
      } catch (error) {
        console.log(`Waiting for Anvil to be ready... (${retries} retries left)`);
        await new Promise(resolve => setTimeout(resolve, 1000));
        retries--;
        
        if (retries === 0) {
          throw new Error("Timed out waiting for Anvil to be ready");
        }
      }
    }

    // Detect which chain is running and set context
    const chainId = await client.getChainId();
    const chainInfo = CHAIN_INFO[chainId];
    
    if (!chainInfo) {
      const validChainIds = Object.keys(CHAIN_INFO).join(', ');
      throw new Error(`Unknown chain ID ${chainId}. Expected one of: ${validChainIds}`);
    }
    
    console.log(`✅ Chain ID verified: ${chainId} (${chainInfo.name})`);
    
    // Set the address context for this chain
    addresses.setChain(chainId);

    // Get available contracts for this chain
    const availableContracts = addresses.getAllContracts();
    console.log(`\n📋 Found ${availableContracts.length} contracts available on ${chainInfo.name}`);
    
    // Test some key contracts if available
    const contractsToTest = ['AUSD', 'WETH', 'MorphoBlue'];
    let testedCount = 0;
    
    for (const contractName of contractsToTest) {
      try {
        if (addresses.hasContract(contractName)) {
          const contractAddress = addresses.getAddress(contractName);
          console.log(`\n🪙 Checking ${contractName} contract...`);
          console.log(`Address: ${contractAddress}`);
          
          // Test basic ERC20 functions
          try {
            const name = await client.readContract({
              address: contractAddress,
              abi: ERC20_ABI,
              functionName: 'name'
            });
            
            const symbol = await client.readContract({
              address: contractAddress,
              abi: ERC20_ABI,
              functionName: 'symbol'
            });
            
            const decimals = await client.readContract({
              address: contractAddress,
              abi: ERC20_ABI,
              functionName: 'decimals'
            });
            
            const totalSupply = await client.readContract({
              address: contractAddress,
              abi: ERC20_ABI,
              functionName: 'totalSupply'
            });
            
            console.log(`Name: ${name}`);
            console.log(`Symbol: ${symbol}`);
            console.log(`Decimals: ${decimals}`);
            console.log(`Total Supply: ${formatUnits(totalSupply, decimals)} ${symbol}`);
            
            testedCount++;
          } catch (contractError) {
            console.log(`⚠️  Contract ${contractName} exists but couldn't read ERC20 data (might not be an ERC20 token)`);
            testedCount++;
          }
        } else {
          console.log(`⚠️  ${contractName} not available on ${chainInfo.name}`);
        }
      } catch (error) {
        console.log(`❌ Error testing ${contractName}:`, error.message);
      }
    }
    
    console.log(`\n✅ Contract verification successful! Tested ${testedCount} contracts.`);
    
    // Print connection information
    console.log(`\nYour ${chainInfo.name} fork is ready for use!`);
    console.log('\nConnect MetaMask or other wallets to this RPC endpoint:');
    console.log(`- Network Name: ${chainInfo.name} Local Fork`);
    console.log(`- RPC URL: http://localhost:${PORT}`);
    console.log(`- Chain ID: ${chainId}`);
    console.log(`- Currency Symbol: ${chainInfo.symbol}`);
    
    return { success: true, chainInfo, testedCount, availableContracts: availableContracts.length };
  } catch (error) {
    console.error('❌ Error verifying contracts:', error);
    return false;
  }
}

// Main function
async function main() {
  console.log(`🔍 Verifying Anvil fork at: ${LOCAL_RPC_URL}`);
  
  // Verify the contracts
  const result = await verifyContracts();
  
  if (result && result.success) {
    console.log("\nYou can leave the Anvil process running for as long as you need it.");
    console.log("Press Ctrl+C in the Anvil terminal to stop the server when done.");
    console.log(`\n📊 Summary: ${result.testedCount} contracts tested, ${result.availableContracts} total available on ${result.chainInfo.name}`);
  } else {
    console.error("\n❌ Failed to verify Anvil fork.");
    console.error("Make sure Anvil is running with the correct parameters:");
    console.error("Examples:");
    console.error("  bun run start:anvil tatara");
    console.error("  bun run start:anvil katana");
    console.error("  bun run start:anvil bokuto");
    process.exit(1);
  }
}

// Only run if executed directly
if (process.argv[1] === import.meta.url.substring(7)) {
  main().catch(error => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
}

export { verifyContracts }; 