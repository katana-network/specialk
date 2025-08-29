#!/usr/bin/env node

import { execSync } from 'node:child_process';
import { existsSync, mkdirSync, rmSync, readdirSync, statSync, writeFileSync, readFileSync } from 'node:fs';
import { join, relative, dirname, basename } from 'node:path';

// Paths
const CONTRACTS_DIR = join(process.cwd(), 'contracts');
const ABIS_DIR = join(process.cwd(), 'abis');
const TEMP_DIR = join(process.cwd(), 'temp_abis');

// Check if contracts directory exists
if (!existsSync(CONTRACTS_DIR)) {
  console.error('Contracts directory not found');
  process.exit(1);
}

// Clean up existing directories
if (existsSync(ABIS_DIR)) {
  console.log('Cleaning up existing abis directory');
  rmSync(ABIS_DIR, { recursive: true, force: true });
}

if (existsSync(TEMP_DIR)) {
  rmSync(TEMP_DIR, { recursive: true, force: true });
}

// Create directories
console.log('Creating directories');
mkdirSync(ABIS_DIR);
mkdirSync(TEMP_DIR);

// Get all contract files (interfaces and contracts)
function getAllContractFiles(dir, relativePath = '', result = []) {
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
      
      const newRelativePath = join(relativePath, file);
      getAllContractFiles(filePath, newRelativePath, result);
    } else if (file.endsWith('.sol')) {
      result.push({
        path: filePath,
        relativePath: relativePath
      });
    }
  }
  
  return result;
}

// Extract contract/interface name from file content
function extractContractName(filePath) {
  try {
    const content = readFileSync(filePath, 'utf8');
    
    // Try to match interface definition
    const interfaceMatch = content.match(/interface\s+(\w+)/);
    if (interfaceMatch && interfaceMatch[1]) {
      return interfaceMatch[1];
    }
    
    // Try to match contract definition
    const contractMatch = content.match(/contract\s+(\w+)/);
    if (contractMatch && contractMatch[1]) {
      return contractMatch[1];
    }
    
    // Fallback to filename
    const fileName = basename(filePath, '.sol');
    return fileName;
  } catch (error) {
    console.error(`Error reading file ${filePath}:`, error.message);
    return basename(filePath, '.sol'); // Fallback to filename even on error
  }
}

// Format JSON nicely
function formatJson(jsonStr) {
  try {
    const obj = JSON.parse(jsonStr);
    return JSON.stringify(obj, null, 2);
  } catch (error) {
    return jsonStr;
  }
}

// Process a single contract/interface file to extract ABI
function processContract(contractFile) {
  const { path, relativePath } = contractFile;
  const fileName = basename(path, '.sol');
  const outDir = join(ABIS_DIR, relativePath);
  
  // Create directory if it doesn't exist
  if (!existsSync(outDir)) {
    mkdirSync(outDir, { recursive: true });
  }
  
  const outputPath = join(outDir, `${fileName}.json`);
  console.log(`Processing ${relative(CONTRACTS_DIR, path)}`);
  
  try {
    // Generate ABI using solc
    let solcCmd = `solc --abi --pretty-json --include-path node_modules/ --base-path . -o ${TEMP_DIR} ${path}`;
    try {
      execSync(solcCmd, { stdio: 'pipe' });
    } catch (solcError) {
      // If solc fails, try solcjs
      solcCmd = `solcjs --abi --include-path node_modules/ --base-path . -o ${TEMP_DIR} ${path}`;
      try{
        execSync(solcCmd, { stdio: 'pipe' });
      } catch (solcjsError){
        console.error(`  - Error generating ABI for ${fileName}: ${solcjsError.message}`);
      }
      
    }
    
    // Find the generated ABI file
    const abiFiles = readdirSync(TEMP_DIR);
    let abiFile = null;
    
    const contractName = extractContractName(path);
    for (const file of abiFiles) {
      if (contractName && file.includes(contractName)) {
        abiFile = file;
        break;
      } else if (file.includes(fileName)) {
        abiFile = file;
        break;
      }
    }
    
    if (!abiFile && abiFiles.length > 0) {
      // Just use the first one if we can't match by name
      abiFile = abiFiles[0];
    }
    
    if (abiFile) {
      // Read, format, and write the ABI
      const abiContent = readFileSync(join(TEMP_DIR, abiFile), 'utf8');
      writeFileSync(outputPath, formatJson(abiContent));
      console.log(`  - ABI written to ${relative(process.cwd(), outputPath)}`);
    } else {
      console.error(`  - No ABI file generated for ${fileName}`);
    }
    
    // Clean up temp files
    for (const file of abiFiles) {
      rmSync(join(TEMP_DIR, file));
    }
  } catch (error) {
    console.error(`  - Error processing ${path}: ${error.message}`);
  }
}

// Main execution
console.log('Scanning contracts...');
const contractFiles = getAllContractFiles(CONTRACTS_DIR);
console.log(`Found ${contractFiles.length} contract files`);

console.log('Generating ABIs...');
for (const contractFile of contractFiles) {
  processContract(contractFile);
}

// Clean up temp directory
if (existsSync(TEMP_DIR)) {
  rmSync(TEMP_DIR, { recursive: true, force: true });
}

console.log('ABI generation complete');

// Validation function
function countFilesRecursively(dir, extension, skipDirs = []) {
  let count = 0;
  const items = readdirSync(dir);
  
  for (const item of items) {
    const fullPath = join(dir, item);
    const stats = statSync(fullPath);
    
    if (stats.isDirectory()) {
      // Skip specified directories
      if (skipDirs.includes(item)) {
        continue;
      }
      count += countFilesRecursively(fullPath, extension, skipDirs);
    } else if (item.endsWith(extension)) {
      count++;
    }
  }
  
  return count;
}

// Validate the generated ABIs
console.log('\nValidation Check:');
const contractCount = countFilesRecursively(CONTRACTS_DIR, '.sol', ['utils']);
const abiCount = countFilesRecursively(ABIS_DIR, '.json');

console.log(`  - Total contract files: ${contractCount}`);
console.log(`  - Total generated ABIs: ${abiCount}`);

if (abiCount === contractCount) {
  console.log('\n✅ OK: The number of generated ABIs matches the number of contract files.');
} else {
  console.log('\n❌ NOK: The number of generated ABIs does not match the number of contract files.');
  process.exit(1); // Exit with error code if validation fails
} 