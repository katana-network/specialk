#!/usr/bin/env node

import { existsSync, readdirSync, readFileSync, writeFileSync, statSync, mkdirSync } from 'node:fs';
import { join, basename, dirname } from 'node:path';

// Constants
const CONTRACTS_DIR = join(process.cwd(), 'contracts');
const ABIS_DIR = join(process.cwd(), 'abis');
const ADDRESSES_DIR = join(process.cwd(), 'utils', 'addresses');
const OUTPUT_DIR = join(process.cwd(), 'utils');
const FULL_OUTPUT = join(OUTPUT_DIR, 'contractdir.json');
const SAMPLE_OUTPUT = join(OUTPUT_DIR, 'contractdir_sample.json');
const SCHEMA_OUTPUT = join(OUTPUT_DIR, 'contractdir_schema.json');
const DIVERSE_OUTPUT = join(OUTPUT_DIR, 'contractdir_diverse.json');
const SAMPLE_SIZE = 10; // Number of contracts to include in the sample
const DIVERSE_SIZE = 4; // Number of diverse contracts for LLM analysis

// Network mappings
const NETWORKS = ['tatara', 'katana', 'bokuto'];

// Check that required directories exist
if (!existsSync(CONTRACTS_DIR)) {
  console.error('Error: Contracts directory does not exist');
  process.exit(1);
}

if (!existsSync(ABIS_DIR)) {
  console.error('Error: ABIs directory does not exist. Run "bun run build:abi" first.');
  process.exit(1);
}

if (!existsSync(ADDRESSES_DIR)) {
  console.error('Error: Addresses directory does not exist. Run "bun run build:addressutils" first.');
  process.exit(1);
}

if (!existsSync(OUTPUT_DIR)) {
  mkdirSync(OUTPUT_DIR, { recursive: true });
}

console.log('Generating contract directory files...');

// Define contexts and their theme colors based on tags
const CONTEXTS = {
  "morpho": {
    name: "morpho",
    color: "#6f4ff2", // Purple
    priority: 1
  },
  "yearn": {
    name: "yearn", 
    color: "#0657F9", // Blue
    priority: 2
  },
  "vaultbridge": {
    name: "vaultbridge",
    color: "#f59e0b", // Amber
    priority: 3
  },
  "oracle": {
    name: "oracle",
    color: "#8b5cf6", // Violet
    priority: 4
  },
  "chainlink": {
    name: "chainlink",
    color: "#3b82f6", // Blue
    priority: 5
  },
  "redstone": {
    name: "redstone",
    color: "#ef4444", // Red
    priority: 6
  },
  "opensea": {
    name: "opensea",
    color: "#2081e2", // OpenSea blue
    priority: 7
  },
  "account-abstraction": {
    name: "account-abstraction",
    color: "#ff7a00", // Orange
    priority: 8
  },
  "agglayer": {
    name: "agglayer",
    color: "#8b46ff", // Purple
    priority: 9
  },
  "nft": {
    name: "nft",
    color: "#ec4899", // Pink
    priority: 10
  },
  "erc20": {
    name: "erc20",
    color: "#10b981", // Green
    priority: 11
  },
  "defi": {
    name: "defi",
    color: "#6366f1", // Indigo
    priority: 12
  },
  "utility": {
    name: "utility",
    color: "#00b7c5", // Cyan
    priority: 13
  },
  "bridge": {
    name: "bridge",
    color: "#e20b8c", // Magenta
    priority: 14
  },
  "general": {
    name: "general",
    color: "#6b7280", // Gray
    priority: 999
  }
};

// Load addresses from the new address utility system
function loadAddresses() {
  try {
    const addressMappingFile = join(ADDRESSES_DIR, 'mapping.ts');
    if (!existsSync(addressMappingFile)) {
      console.warn('Warning: Address mapping file not found. Addresses will not be included.');
      return {};
    }

    const mappingContent = readFileSync(addressMappingFile, 'utf8');
    
    // Extract the CONTRACT_ADDRESSES object
    const contractAddressMatch = mappingContent.match(/export const CONTRACT_ADDRESSES = ({[\s\S]*?}) as const;/);
    if (!contractAddressMatch) {
      console.warn('Warning: Could not parse CONTRACT_ADDRESSES from mapping.ts');
      return {};
    }

    // Convert TypeScript object to JSON-parseable format
    let addressDataStr = contractAddressMatch[1];
    
    // Replace TypeScript syntax with JSON syntax
    addressDataStr = addressDataStr
      .replace(/(\w+):/g, '"$1":')  // Add quotes around keys
      .replace(/'/g, '"')          // Replace single quotes with double quotes
      .replace(/,(\s*[}\]])/g, '$1'); // Remove trailing commas

    try {
      const addressData = JSON.parse(addressDataStr);
      console.log(`Loaded addresses for ${Object.keys(addressData).length} contracts`);
      return addressData;
    } catch (parseError) {
      console.warn('Warning: Could not parse address data:', parseError.message);
      return {};
    }
  } catch (error) {
    console.error('Error loading addresses:', error);
    return {};
  }
}

// Load origin addresses from the new address utility system  
function loadOriginAddresses() {
  try {
    const addressMappingFile = join(ADDRESSES_DIR, 'mapping.ts');
    if (!existsSync(addressMappingFile)) {
      return {};
    }

    const mappingContent = readFileSync(addressMappingFile, 'utf8');
    
    // Extract the ORIGIN_CONTRACT_ADDRESSES object
    const originAddressMatch = mappingContent.match(/export const ORIGIN_CONTRACT_ADDRESSES = ({[\s\S]*?}) as const;/);
    if (!originAddressMatch) {
      return {};
    }

    // Convert TypeScript object to JSON-parseable format
    let originDataStr = originAddressMatch[1];
    
    // Replace TypeScript syntax with JSON syntax
    originDataStr = originDataStr
      .replace(/(\w+):/g, '"$1":')  // Add quotes around keys
      .replace(/'/g, '"')          // Replace single quotes with double quotes
      .replace(/,(\s*[}\]])/g, '$1'); // Remove trailing commas

    try {
      const originData = JSON.parse(originDataStr);
      console.log(`Loaded origin addresses for ${Object.keys(originData).length} contracts`);
      return originData;
    } catch (parseError) {
      console.warn('Warning: Could not parse origin address data:', parseError.message);
      return {};
    }
  } catch (error) {
    console.error('Error loading origin addresses:', error);
    return {};
  }
}

// Get all contract files recursively (excluding utils)
function getAllFiles(dir, relativePath = '', fileMap = {}) {
  const files = readdirSync(dir);
  
  for (const file of files) {
    const filePath = join(dir, file);
    const stats = statSync(filePath);
    
    if (stats.isDirectory()) {
      // Skip the utils directory since those are generated files
      if (file === 'utils') {
        console.log(`Skipping generated directory: ${join(relativePath, file)}`);
        continue;
      }
      
      getAllFiles(filePath, join(relativePath, file), fileMap);
    } else if (file.endsWith('.sol')) {
      const key = join(relativePath, file).replace(/\\/g, '/');
      fileMap[key] = {
        path: filePath,
        relativePath: relativePath
      };
    }
  }
  
  return fileMap;
}

// Get all ABI files recursively
function getAllABIs(dir, relativePath = '', abiMap = {}) {
  const files = readdirSync(dir);
  
  for (const file of files) {
    const filePath = join(dir, file);
    const stats = statSync(filePath);
    
    if (stats.isDirectory()) {
      getAllABIs(filePath, join(relativePath, file), abiMap);
    } else if (file.endsWith('.json')) {
      const key = join(relativePath, file).replace(/\\/g, '/');
      abiMap[key] = {
        path: filePath,
        relativePath: relativePath
      };
    }
  }
  
  return abiMap;
}

// Extract function signatures from ABI
function extractFunctionSignatures(abi) {
  const signatures = [];
  
  if (!Array.isArray(abi)) return signatures;
  
  for (const item of abi) {
    if (item.type === 'function') {
      let signature = `${item.name}(${(item.inputs || []).map(input => input.type).join(',')})`;
      let outputTypes = (item.outputs || []).map(output => output.type).join(',');
      let abiSignature = {
        name: item.name,
        signature,
        inputs: item.inputs || [],
        outputs: item.outputs || [],
        stateMutability: item.stateMutability
      };
      
      // Add signature to the list
      signatures.push(abiSignature);
    }
  }
  
  return signatures;
}

// Extract documentation comments, network addresses, and tags from contract file
function extractContractMetadata(content) {
  // Find the main comment block before the interface/contract declaration
  const commentBlockRegex = /\/\*\*([\s\S]*?)\*\/\s*(?:interface|contract)\s+\w+/;
  const commentMatch = content.match(commentBlockRegex);
  
  if (!commentMatch) return null;
  
  const commentBlock = commentMatch[1];
  
  // Extract various tags
  const titleMatches = commentBlock.match(/@title\s+(.*?)(?=\s*\*\s*@|\s*\*\/)/gs) || [];
  const noticeMatches = commentBlock.match(/@notice\s+(.*?)(?=\s*\*\s*@|\s*\*\/)/gs) || [];
  const devMatches = commentBlock.match(/@dev\s+(.*?)(?=\s*\*\s*@|\s*\*\/)/gs) || [];
  
  // Extract network addresses (new format)
  const networkAddresses = {};
  const originAddresses = {};
  
  for (const network of NETWORKS) {
    // Regular network addresses: @custom:tatara 0x123...
    const networkRegex = new RegExp(`@custom:${network}\\s+(0x[a-fA-F0-9]{40})`, 'gi');
    const networkMatch = networkRegex.exec(commentBlock);
    if (networkMatch && networkMatch[1]) {
      networkAddresses[network] = networkMatch[1];
    }
    
    // Origin chain addresses: @custom:tatara ethereum:0x123...
    const originRegex = new RegExp(`@custom:${network}\\s+(ethereum|sepolia):(0x[a-fA-F0-9]{40})`, 'gi');
    const originMatch = originRegex.exec(commentBlock);
    if (originMatch && originMatch[2]) {
      originAddresses[network] = {
        originChain: originMatch[1],
        address: originMatch[2]
      };
    }
  }
  
  // Extract tags
  const tagsMatches = commentBlock.match(/@custom:tags\s+([^\n\r]*)/g) || [];
  const tags = tagsMatches.length > 0 
    ? tagsMatches[0].replace(/@custom:tags\s+/g, '').trim().split(',').map(tag => tag.trim())
    : [];
  
  // Clean up the extracted comments
  const titles = titleMatches.map(title => 
    title.replace(/@title\s+/g, '').replace(/\s*\*\s*/g, ' ').trim()
  );
  
  const notices = noticeMatches.map(notice => 
    notice.replace(/@notice\s+/g, '').replace(/\s*\*\s*/g, ' ').trim()
  );
  
  const devs = devMatches.map(dev => 
    dev.replace(/@dev\s+/g, '').replace(/\s*\*\s*/g, ' ').trim()
  );
  
  // Combine all information in a structured way
  const metadata = {
    title: titles.length > 0 ? titles[0] : null,
    notice: notices.length > 0 ? notices.join(' ') : null,
    dev: devs.length > 0 ? devs.join(' ') : null,
    tags: tags,
    networkAddresses: networkAddresses,
    originAddresses: originAddresses,
    full: ''
  };
  
  // Build a full text description
  let fullText = '';
  
  if (metadata.title) {
    fullText += metadata.title;
  }
  
  if (metadata.notice) {
    if (fullText) fullText += ': ';
    fullText += metadata.notice;
  }
  
  if (metadata.dev) {
    if (fullText) fullText += ' ';
    fullText += '(' + metadata.dev + ')';
  }
  
  metadata.full = fullText.trim() || null;
  
  return metadata;
}

// Determine the context for a contract based on tags (primary) and fallback to name/path matching
function determineContext(name, path, relativePath, tags = [], description) {
  // First priority: use tags to determine context
  if (tags && tags.length > 0) {
    // Find the highest priority context from tags
    let bestContext = null;
    let bestPriority = 999;
    
    for (const tag of tags) {
      const tagLower = tag.toLowerCase();
      
      // Check if this tag matches any context
      for (const [contextKey, contextData] of Object.entries(CONTEXTS)) {
        if (tagLower === contextKey || tagLower.includes(contextKey)) {
          if (contextData.priority < bestPriority) {
            bestContext = contextData;
            bestPriority = contextData.priority;
          }
        }
      }
      
      // Special mappings for common tag variations
      if (tagLower === 'erc4337') {
        if (CONTEXTS["account-abstraction"].priority < bestPriority) {
          bestContext = CONTEXTS["account-abstraction"];
          bestPriority = CONTEXTS["account-abstraction"].priority;
        }
      }
      
      if (tagLower === 'token' && !bestContext) {
        if (CONTEXTS["erc20"].priority < bestPriority) {
          bestContext = CONTEXTS["erc20"];
          bestPriority = CONTEXTS["erc20"].priority;
        }
      }
    }
    
    if (bestContext) {
      return bestContext;
    }
  }
  
  // Fallback: determine context based on name, path, etc.
  const nameLower = name.toLowerCase();
  const pathLower = path.toLowerCase();
  const relativeLower = relativePath ? relativePath.toLowerCase() : '';
  const desc = description ? description.toLowerCase() : '';
  
  // Check against each context
  for (const [contextKey, contextData] of Object.entries(CONTEXTS)) {
    if (contextKey === 'general') continue; // Skip general for fallback matching
    
    const contextLower = contextKey.toLowerCase();
    
    if (
      nameLower.includes(contextLower) || 
      pathLower.includes(contextLower) || 
      relativeLower.includes(contextLower) ||
      desc.includes(contextLower)
    ) {
      return contextData;
    }
  }
  
  // Special cases for common patterns not captured by tags
  if (nameLower.includes('erc4337') || pathLower.includes('aav0') || relativeLower.includes('aav0')) {
    return CONTEXTS["account-abstraction"];
  }
  
  if (nameLower.includes('seaport') || nameLower.includes('conduit') || desc.includes('opensea')) {
    return CONTEXTS["opensea"];
  }
  
  if (nameLower.includes('create2') || nameLower.includes('createx') || nameLower.includes('deploy')) {
    return CONTEXTS["utility"];
  }
  
  if (nameLower.includes('multicall') || nameLower.includes('permit2') || nameLower.includes('bundler')) {
    return CONTEXTS["utility"];
  }
  
  if (nameLower.includes('bridge') || nameLower.includes('sovereign') || nameLower.includes('l2')) {
    return CONTEXTS["bridge"];
  }
  
  // Default context for anything else
  return CONTEXTS["general"];
}

// Generate the contract directory
function generateContractDirectory() {
  const addresses = loadAddresses();
  const originAddresses = loadOriginAddresses();
  const contractFiles = getAllFiles(CONTRACTS_DIR);
  const abiFiles = getAllABIs(ABIS_DIR);
  
  const contractDir = [];
  
  // Process each contract file
  for (const [key, contractInfo] of Object.entries(contractFiles)) {
    const fileName = basename(key, '.sol');
    const abiKey = join(contractInfo.relativePath, `${fileName}.json`).replace(/\\/g, '/');
    
    // Get the contract content
    const contractContent = readFileSync(contractInfo.path, 'utf8');
    
    // Extract contract/interface name - improved regex to match actual declarations not comments
    const interfaceMatch = contractContent.match(/(?:^|\n)\s*interface\s+(\w+)/);
    const contractMatch = contractContent.match(/(?:^|\n)\s*contract\s+(\w+)/);
    const contractName = interfaceMatch ? interfaceMatch[1] : (contractMatch ? contractMatch[1] : fileName);
    
    // Extract contract metadata (description, tags, addresses)
    const metadata = extractContractMetadata(contractContent);
    
    // Try to find matching ABI
    let abi = null;
    let functionSignatures = [];
    if (abiFiles[abiKey]) {
      try {
        abi = JSON.parse(readFileSync(abiFiles[abiKey].path, 'utf8'));
        functionSignatures = extractFunctionSignatures(abi);
      } catch (err) {
        console.warn(`Warning: Could not parse ABI for ${abiKey}`);
      }
    }
    
    // Get addresses for this contract
    let contractAddresses = {};
    let contractOriginAddresses = {};
    
    // Try to match by name (remove leading 'I' if present for interfaces)
    let addressMatchName = contractName;
    if (addressMatchName.startsWith('I')) {
      addressMatchName = addressMatchName.substring(1);
    }
    
    // Look up in the address utilities
    if (addresses[contractName] || addresses[addressMatchName]) {
      contractAddresses = addresses[contractName] || addresses[addressMatchName];
      console.log(`Found addresses for ${contractName}: ${JSON.stringify(contractAddresses)}`);
    }
    
    // Look up origin addresses
    if (originAddresses[contractName] || originAddresses[addressMatchName]) {
      contractOriginAddresses = originAddresses[contractName] || originAddresses[addressMatchName];
      console.log(`Found origin addresses for ${contractName}: ${JSON.stringify(contractOriginAddresses)}`);
    }
    
    // If we didn't find addresses in utilities but found them in doccomments, use those
    if (Object.keys(contractAddresses).length === 0 && metadata && Object.keys(metadata.networkAddresses).length > 0) {
      contractAddresses = metadata.networkAddresses;
      console.log(`Using doccomment addresses for ${contractName}: ${JSON.stringify(contractAddresses)}`);
    }
    
    if (Object.keys(contractOriginAddresses).length === 0 && metadata && Object.keys(metadata.originAddresses).length > 0) {
      contractOriginAddresses = metadata.originAddresses;
      console.log(`Using doccomment origin addresses for ${contractName}: ${JSON.stringify(contractOriginAddresses)}`);
    }
    
    // Determine context using tags as primary method
    const context = determineContext(
      contractName, 
      key, 
      contractInfo.relativePath, 
      metadata ? metadata.tags : [], 
      metadata ? metadata.full : null
    );
    
    // Create contract entry with enhanced structure
    const contract = {
      name: contractName,
      path: key,
      relativePath: contractInfo.relativePath,
      description: metadata ? metadata.full : null,
      metadata: {
        title: metadata ? metadata.title : null,
        notice: metadata ? metadata.notice : null,
        dev: metadata ? metadata.dev : null,
        tags: metadata ? metadata.tags : []
      },
      context: context.name,
      theme: context.color,
      addresses: contractAddresses,
      originAddresses: contractOriginAddresses,
      abi,
      functionSignatures,
      // Add some computed fields for easier filtering
      hasAddresses: Object.keys(contractAddresses).length > 0,
      hasOriginAddresses: Object.keys(contractOriginAddresses).length > 0,
      hasAbi: abi !== null,
      functionCount: functionSignatures.length
    };
    
    contractDir.push(contract);
  }
  
  // Sort contracts by context priority, then by name
  contractDir.sort((a, b) => {
    const contextA = CONTEXTS[a.context] || CONTEXTS["general"];
    const contextB = CONTEXTS[b.context] || CONTEXTS["general"];
    
    if (contextA.priority !== contextB.priority) {
      return contextA.priority - contextB.priority;
    }
    
    return a.name.localeCompare(b.name);
  });
  
  return contractDir;
}

// Generate schema file
function generateSchema() {
  return {
    version: "2.0",
    description: "Katana Contract Directory Schema",
    generatedAt: new Date().toISOString(),
    networks: NETWORKS,
    contexts: Object.keys(CONTEXTS),
    contractStructure: {
      name: "string - Contract or interface name",
      path: "string - Relative path from contracts/ directory", 
      relativePath: "string - Parent directory path",
      description: "string|null - Combined title, notice, and dev comments",
      metadata: {
        title: "string|null - @title doccomment",
        notice: "string|null - @notice doccomment", 
        dev: "string|null - @dev doccomment",
        tags: "string[] - @custom:tags doccomment"
      },
      context: "string - Primary context/category based on tags",
      theme: "string - Hex color for UI theming",
      addresses: "object - Network addresses {tatara?, katana?, bokuto?}",
      originAddresses: "object - Origin chain addresses for cross-chain operations", 
      abi: "array|null - Contract ABI if available",
      functionSignatures: "array - Parsed function signatures from ABI",
      hasAddresses: "boolean - Whether contract has any network addresses",
      hasOriginAddresses: "boolean - Whether contract has origin addresses",
      hasAbi: "boolean - Whether ABI is available",
      functionCount: "number - Number of functions in ABI"
    }
  };
}

// Generate diverse sample for LLM analysis
function generateDiverseSample(contractDir) {
  const diverseContracts = [];
  const usedContexts = new Set();
  
  // Try to get one contract from each major context
  const priorityContexts = ['morpho', 'vaultbridge', 'oracle', 'erc20', 'account-abstraction', 'nft', 'utility'];
  
  for (const targetContext of priorityContexts) {
    const contractInContext = contractDir.find(c => 
      c.context === targetContext && 
      !usedContexts.has(c.context) &&
      c.hasAbi && 
      c.functionCount > 0
    );
    
    if (contractInContext) {
      diverseContracts.push(contractInContext);
      usedContexts.add(contractInContext.context);
      
      if (diverseContracts.length >= DIVERSE_SIZE) break;
    }
  }
  
  // Fill remaining slots with any interesting contracts
  while (diverseContracts.length < DIVERSE_SIZE) {
    const remaining = contractDir.find(c => 
      !diverseContracts.includes(c) &&
      c.hasAbi && 
      c.functionCount > 2
    );
    
    if (!remaining) break;
    diverseContracts.push(remaining);
  }
  
  return diverseContracts;
}

// Main execution
console.log('Generating contract directory...');
const contractDir = generateContractDirectory();

// Write full directory
writeFileSync(FULL_OUTPUT, JSON.stringify(contractDir, null, 2));
console.log(`✅ Full contract directory written to ${FULL_OUTPUT}`);

// Write sample directory (first SAMPLE_SIZE entries with good coverage)
const sampleContracts = contractDir.filter(c => c.hasAbi).slice(0, SAMPLE_SIZE);
writeFileSync(SAMPLE_OUTPUT, JSON.stringify(sampleContracts, null, 2));
console.log(`✅ Sample contract directory written to ${SAMPLE_OUTPUT}`);

// Write schema file
const schema = generateSchema();
writeFileSync(SCHEMA_OUTPUT, JSON.stringify(schema, null, 2));
console.log(`✅ Schema written to ${SCHEMA_OUTPUT}`);

// Write diverse sample for LLM analysis
const diverseContracts = generateDiverseSample(contractDir);
writeFileSync(DIVERSE_OUTPUT, JSON.stringify(diverseContracts, null, 2));
console.log(`✅ Diverse sample written to ${DIVERSE_OUTPUT}`);

// Print detailed statistics
console.log('\n📊 Directory Statistics:');
console.log(`  - Total contracts: ${contractDir.length}`);
console.log(`  - Contracts with ABIs: ${contractDir.filter(c => c.hasAbi).length}`);
console.log(`  - Contracts with addresses: ${contractDir.filter(c => c.hasAddresses).length}`);
console.log(`  - Contracts with origin addresses: ${contractDir.filter(c => c.hasOriginAddresses).length}`);
console.log(`  - Total function signatures: ${contractDir.reduce((sum, c) => sum + c.functionCount, 0)}`);

// Context breakdown
console.log('\n📂 Context Breakdown:');
const contextStats = {};
contractDir.forEach(c => {
  contextStats[c.context] = (contextStats[c.context] || 0) + 1;
});

Object.entries(contextStats)
  .sort(([,a], [,b]) => b - a)
  .forEach(([context, count]) => {
    console.log(`  - ${context}: ${count} contracts`);
  });

// Network coverage
console.log('\n🌐 Network Coverage:');
NETWORKS.forEach(network => {
  const withAddress = contractDir.filter(c => c.addresses[network]).length;
  const withOrigin = contractDir.filter(c => c.originAddresses[network]).length;
  console.log(`  - ${network}: ${withAddress} regular, ${withOrigin} origin addresses`);
});

console.log('\n🎉 Generation complete!'); 