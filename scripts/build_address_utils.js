#!/usr/bin/env node

import { existsSync, readdirSync, readFileSync, writeFileSync, statSync, mkdirSync } from 'node:fs';
import { join, basename, relative } from 'node:path';
import { createHash } from 'node:crypto';

// Constants
const CONTRACTS_DIR = join(process.cwd(), 'contracts');
const UTILS_DIR = join(CONTRACTS_DIR, 'utils');
const JS_UTILS_DIR = join(process.cwd(), 'utils', 'addresses');
const JS_OUTPUT_PATH = join(JS_UTILS_DIR, 'mapping.ts');

// Supported networks
const NETWORKS = ['tatara', 'katana', 'bokuto'];

// Chain IDs for each network
const CHAIN_IDS = {
  tatara: 129399,
  katana: 747474,
  bokuto: 737373,
};

/**
 * Get all Solidity files recursively
 */
function getAllSolidityFiles(dir, result = []) {
  const files = readdirSync(dir);
  
  for (const file of files) {
    const filePath = join(dir, file);
    const stats = statSync(filePath);
    
    if (stats.isDirectory() && file !== 'utils') { // Skip the utils directory to avoid circular references
      getAllSolidityFiles(filePath, result);
    } else if (file.endsWith('.sol')) {
      result.push(filePath);
    }
  }
  
  return result;
}

/**
 * Extract contract name from file content
 */
function extractContractName(filePath) {
  try {
    const content = readFileSync(filePath, 'utf8');
    
    // Split content into lines and process each line
    const lines = content.split('\n');
    
    for (const line of lines) {
      const trimmedLine = line.trim();
      
      // Skip empty lines and comment lines
      if (!trimmedLine || trimmedLine.startsWith('//') || trimmedLine.startsWith('*') || trimmedLine.startsWith('/*')) {
        continue;
      }
      
      // Look for interface or contract declarations (not inside comments)
      const interfaceMatch = trimmedLine.match(/^interface\s+(\w+)/);
      if (interfaceMatch && interfaceMatch[1]) {
        return interfaceMatch[1];
      }
      
      const contractMatch = trimmedLine.match(/^contract\s+(\w+)/);
      if (contractMatch && contractMatch[1]) {
        return contractMatch[1];
      }
      
      // Also check for interface/contract after modifiers like 'abstract'
      const modifiedInterfaceMatch = trimmedLine.match(/^(?:abstract\s+)?interface\s+(\w+)/);
      if (modifiedInterfaceMatch && modifiedInterfaceMatch[1]) {
        return modifiedInterfaceMatch[1];
      }
      
      const modifiedContractMatch = trimmedLine.match(/^(?:abstract\s+)?contract\s+(\w+)/);
      if (modifiedContractMatch && modifiedContractMatch[1]) {
        return modifiedContractMatch[1];
      }
    }
    
    // Fallback to filename without extension
    return basename(filePath, '.sol');
  } catch (error) {
    console.error(`Error reading file ${filePath}:`, error.message);
    return basename(filePath, '.sol');
  }
}

/**
 * Convert address to proper checksum format
 * Maps known problematic addresses to their correct checksummed versions
 */
function toChecksumAddress(address) {
  // Known checksum mappings for problematic addresses
  const checksumMap = {
    '0xa40d5f56745a118d0906a34e69aec8c0db1cb8fa': '0xa40D5f56745a118D0906a34E69aeC8C0Db1cB8fA',
    '0x7fc98430eaedbb6070b35b39d798725049088348': '0x7fc98430eAEdbb6070B35B39D798725049088348',
    '0xccc0fc2e34428120f985b460b487eb79e3c6fa57': '0xccC0Fc2E34428120f985b460b487eB79E3C6FA57'
  };
  
  const lowerAddress = address.toLowerCase();
  
  // Return known checksum version if available
  if (checksumMap[lowerAddress]) {
    return checksumMap[lowerAddress];
  }
  
  // For other addresses, ensure they start with 0x
  return address.startsWith('0x') ? address : '0x' + address;
}

/**
 * Extract network addresses from doccomments
 */
function extractNetworkAddresses(filePath) {
  try {
    const content = readFileSync(filePath, 'utf8');
    const addresses = {};
    const originAddresses = {};
    
    // Look for @custom:networkName address patterns (destination chain)
    for (const network of NETWORKS) {
      const regex = new RegExp(`@custom:${network}\\s+(0x[a-fA-F0-9]{40})`, 'gi');
      const match = regex.exec(content);
      if (match && match[1]) {
        // Apply proper checksumming
        addresses[network] = toChecksumAddress(match[1]);
      }
    }
    
    // Look for @custom:networkName originChain:address patterns (origin chain)
    for (const network of NETWORKS) {
      const regex = new RegExp(`@custom:${network}\\s+(ethereum|sepolia):(0x[a-fA-F0-9]{40})`, 'gi');
      const match = regex.exec(content);
      if (match && match[2]) {
        // Apply proper checksumming
        originAddresses[network] = {
          originChain: match[1],
          address: toChecksumAddress(match[2])
        };
      }
    }
    
    return { addresses, originAddresses };
  } catch (error) {
    console.error(`Error reading file ${filePath}:`, error.message);
    return { addresses: {}, originAddresses: {} };
  }
}

/**
 * Convert contract name to function name
 * e.g., "IMultiSend" -> "getMultiSendAddress"
 */
function contractNameToFunctionName(contractName) {
  // Remove 'I' prefix if it exists and starts with uppercase
  let name = contractName;
  if (name.startsWith('I') && name.length > 1 && name[1] === name[1].toUpperCase()) {
    name = name.substring(1);
  }
  
  return `get${name}Address`;
}

/**
 * Generate address library file for a specific network
 */
function generateAddressLibrary(network, contracts) {
  const networkName = network.charAt(0).toUpperCase() + network.slice(1);
  const chainId = CHAIN_IDS[network];
  
  let content = `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ${networkName}Addresses
 * @notice Library for accessing ${networkName} network contract addresses
 * @dev Auto-generated from contract doccomments. Do not edit manually.
 */
library ${networkName}Addresses {\n`;

  // Add chain ID constant
  content += `    /**
     * @notice Chain ID for ${networkName} network
     */
    uint256 internal constant CHAIN_ID = ${chainId};

`;

  // Sort contracts by name for consistent output
  const sortedContracts = Object.entries(contracts).sort(([a], [b]) => a.localeCompare(b));

  if (sortedContracts.length === 0) {
    content += `    // No contracts found with @custom:${network} addresses
    // This file will be populated as contracts are deployed to ${networkName}

`;
  } else {
    // Add functions for each contract
    for (const [contractName, address] of sortedContracts) {
      const functionName = contractNameToFunctionName(contractName);
      
      content += `    /**
     * @notice Returns the address of ${contractName}
     * @return The ${contractName} contract address
     */
    function ${functionName}() internal pure returns (address) {
        return ${address};
    }

`;
    }
  }

  content += `}`; // Close the library

  return content;
}

/**
 * Generate origin addresses library file for a specific network
 */
function generateOriginAddressLibrary(network, originContracts) {
  const networkName = network.charAt(0).toUpperCase() + network.slice(1);
  
  let content = `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ${networkName}OriginAddresses
 * @notice Library for accessing origin chain contract addresses when operating in ${networkName} context
 * @dev Auto-generated from contract doccomments. Do not edit manually.
 *      These are contracts deployed on origin chains (Ethereum/Sepolia) that are accessed
 *      from the ${networkName} context for cross-chain operations like Vault Bridge.
 */
library ${networkName}OriginAddresses {\n`;

  // Sort contracts by name for consistent output
  const sortedContracts = Object.entries(originContracts).sort(([a], [b]) => a.localeCompare(b));

  if (sortedContracts.length === 0) {
    content += `    // No origin chain contracts found for ${network} context
    // This file will be populated as origin chain contracts are added

`;
  } else {
    // Add functions for each contract
    for (const [contractName, contractData] of sortedContracts) {
      const functionName = contractNameToFunctionName(contractName);
      const originChain = contractData.originChain;
      const address = contractData.address;
      
      content += `    /**
     * @notice Returns the origin chain address of ${contractName}
     * @dev This contract is deployed on ${originChain} and accessed from ${networkName} context
     * @return The ${contractName} contract address on ${originChain}
     */
    function ${functionName}() internal pure returns (address) {
        return ${address};
    }

`;
    }
  }

  content += `}`; // Close the library

  return content;
}

/**
 * Generate TypeScript address mapping file
 */
function generateTypeScriptMapping(networkContracts, originNetworkContracts) {
  // Get all unique contract names across all networks (destination contracts)
  const allContractNames = new Set();
  
  for (const network of NETWORKS) {
    for (const contractName of Object.keys(networkContracts[network])) {
      allContractNames.add(contractName);
    }
  }
  
  // Get all unique origin contract names across all networks
  const allOriginContractNames = new Set();
  
  for (const network of NETWORKS) {
    for (const contractName of Object.keys(originNetworkContracts[network])) {
      allOriginContractNames.add(contractName);
    }
  }
  
  // Create the mapping object for destination contracts
  const addressMapping = {};
  
  allContractNames.forEach(contractName => {
    addressMapping[contractName] = {
      tatara: networkContracts.tatara[contractName] || null,
      katana: networkContracts.katana[contractName] || null,
      bokuto: networkContracts.bokuto[contractName] || null
    };
  });
  
  // Create the mapping object for origin contracts
  const originAddressMapping = {};
  
  allOriginContractNames.forEach(contractName => {
    originAddressMapping[contractName] = {
      tatara: originNetworkContracts.tatara[contractName]?.address || null,
      katana: originNetworkContracts.katana[contractName]?.address || null,
      bokuto: originNetworkContracts.bokuto[contractName]?.address || null
    };
  });
  
  // Create the TypeScript file content - minimal data-only file
  const tsContent = `// Auto-generated contract address mapping data
// Generated on ${new Date().toISOString()}
// Do not edit manually - this file is generated by scripts/build_address_utils.js
// Add this file to .gitignore

export const CHAIN_IDS = {
  TATARA: ${CHAIN_IDS.tatara},
  KATANA: ${CHAIN_IDS.katana},
  BOKUTO: ${CHAIN_IDS.bokuto}
} as const;

export const CONTRACT_ADDRESSES = {
${Object.entries(addressMapping)
  .sort(([a], [b]) => a.localeCompare(b))
  .map(([name, addrs]) => {
    // Simple string values, typing will be in index.ts
    const tatara = addrs.tatara ? `"tatara": "${addrs.tatara}"` : '"tatara": null';
    const katana = addrs.katana ? `"katana": "${addrs.katana}"` : '"katana": null';
    const bokuto = addrs.bokuto ? `"bokuto": "${addrs.bokuto}"` : '"bokuto": null';
    return `  "${name}": { ${tatara}, ${katana}, ${bokuto} }`;
  })
  .join(',\n')}
} as const;

export const ORIGIN_CONTRACT_ADDRESSES = {
${Object.entries(originAddressMapping)
  .sort(([a], [b]) => a.localeCompare(b))
  .map(([name, addrs]) => {
    // Simple string values, typing will be in index.ts
    const tatara = addrs.tatara ? `"tatara": "${addrs.tatara}"` : '"tatara": null';
    const katana = addrs.katana ? `"katana": "${addrs.katana}"` : '"katana": null';
    const bokuto = addrs.bokuto ? `"bokuto": "${addrs.bokuto}"` : '"bokuto": null';
    return `  "${name}": { ${tatara}, ${katana}, ${bokuto} }`;
  })
  .join(',\n')}
} as const;
`;

  return tsContent;
}

/**
 * Main function
 */
function main() {
  console.log('Building address utility files...');
  
  // Check if contracts directory exists
  if (!existsSync(CONTRACTS_DIR)) {
    console.error('Contracts directory not found');
    process.exit(1);
  }

  // Create utils directory if it doesn't exist
  if (!existsSync(UTILS_DIR)) {
    console.error('Utils directory not found');
    process.exit(1);
  }

  // Get all Solidity files
  console.log('Scanning for Solidity files...');
  const solidityFiles = getAllSolidityFiles(CONTRACTS_DIR);
  console.log(`Found ${solidityFiles.length} Solidity files`);

  // Parse files and extract addresses
  console.log('Extracting addresses from doccomments...');
  const networkContracts = {
    tatara: {},
    katana: {},
    bokuto: {}
  };

  const originNetworkContracts = {
    tatara: {},
    katana: {},
    bokuto: {}
  };

  let totalAddressesFound = 0;
  let totalOriginAddressesFound = 0;

  for (const filePath of solidityFiles) {
    const contractName = extractContractName(filePath);
    const { addresses, originAddresses } = extractNetworkAddresses(filePath);
    
    // Add destination chain addresses to appropriate network mappings
    for (const [network, address] of Object.entries(addresses)) {
      if (networkContracts[network]) {
        // Check for duplicates
        if (networkContracts[network][contractName] && networkContracts[network][contractName] !== address) {
          console.log(`  Warning: Duplicate contract name "${contractName}" with different addresses:`);
          console.log(`    Existing: ${networkContracts[network][contractName]}`);
          console.log(`    New: ${address} (from ${relative(CONTRACTS_DIR, filePath)})`);
          
          // Use the relative file path to create a unique name
          const uniqueName = `${contractName}_${relative(CONTRACTS_DIR, filePath).replace(/[/.]/g, '_').replace(/_sol$/, '')}`;
          networkContracts[network][uniqueName] = address;
          console.log(`    Renamed to: ${uniqueName}`);
        } else {
          networkContracts[network][contractName] = address;
        }
        
        totalAddressesFound++;
        console.log(`  Found ${network}: ${contractName} -> ${address} (${relative(CONTRACTS_DIR, filePath)})`);
      }
    }

    // Add origin chain addresses to appropriate network mappings
    for (const [network, addressData] of Object.entries(originAddresses)) {
      if (originNetworkContracts[network]) {
        // Check for duplicates
        if (originNetworkContracts[network][contractName] && originNetworkContracts[network][contractName].address !== addressData.address) {
          console.log(`  Warning: Duplicate origin contract name "${contractName}" with different addresses:`);
          console.log(`    Existing: ${originNetworkContracts[network][contractName].address} (${originNetworkContracts[network][contractName].originChain})`);
          console.log(`    New: ${addressData.address} (${addressData.originChain}) (from ${relative(CONTRACTS_DIR, filePath)})`);
          
          // Use the relative file path to create a unique name
          const uniqueName = `${contractName}_${relative(CONTRACTS_DIR, filePath).replace(/[/.]/g, '_').replace(/_sol$/, '')}`;
          originNetworkContracts[network][uniqueName] = addressData;
          console.log(`    Renamed to: ${uniqueName}`);
        } else {
          originNetworkContracts[network][contractName] = addressData;
        }
        
        totalOriginAddressesFound++;
        console.log(`  Found ${network} origin (${addressData.originChain}): ${contractName} -> ${addressData.address} (${relative(CONTRACTS_DIR, filePath)})`);
      }
    }
  }

  console.log(`\nTotal addresses found: ${totalAddressesFound}`);
  console.log(`Total origin addresses found: ${totalOriginAddressesFound}`);

  // Generate library files for each network
  console.log('\nGenerating address library files...');
  for (const network of NETWORKS) {
    const networkName = network.charAt(0).toUpperCase() + network.slice(1);
    const fileName = `${networkName}Addresses.sol`;
    const filePath = join(UTILS_DIR, fileName);
    
    const content = generateAddressLibrary(network, networkContracts[network]);
    writeFileSync(filePath, content);
    
    const contractCount = Object.keys(networkContracts[network]).length;
    console.log(`  Generated ${fileName} with ${contractCount} contracts`);
  }

  // Generate origin address library files for each network
  console.log('\nGenerating origin address library files...');
  for (const network of NETWORKS) {
    const networkName = network.charAt(0).toUpperCase() + network.slice(1);
    const fileName = `${networkName}OriginAddresses.sol`;
    const filePath = join(UTILS_DIR, fileName);
    
    const content = generateOriginAddressLibrary(network, originNetworkContracts[network]);
    writeFileSync(filePath, content);
    
    const contractCount = Object.keys(originNetworkContracts[network]).length;
    console.log(`  Generated ${fileName} with ${contractCount} origin contracts`);
  }

  // Generate TypeScript address mapping
  console.log('\nGenerating TypeScript address mapping...');
  
  // Ensure JS utils directory exists
  if (!existsSync(JS_UTILS_DIR)) {
    console.log(`  Creating ${JS_UTILS_DIR} directory...`);
    mkdirSync(JS_UTILS_DIR, { recursive: true });
  }
  
  const tsContent = generateTypeScriptMapping(networkContracts, originNetworkContracts);
  writeFileSync(JS_OUTPUT_PATH, tsContent);
  console.log(`  Generated ${relative(process.cwd(), JS_OUTPUT_PATH)}`);

  console.log('\nAddress utility files generated successfully!');
}

// Run the script
main();