#!/usr/bin/env node

import { execSync } from 'node:child_process';
import { existsSync, mkdirSync, rmSync, readdirSync, statSync, writeFileSync, readFileSync } from 'node:fs';
import { join, relative, dirname, basename } from 'node:path';

// Paths
const INTERFACES_DIR = join(process.cwd(), 'interfaces');
const ABIS_DIR = join(process.cwd(), 'abis');
const TEMP_DIR = join(process.cwd(), 'temp_abis');

// Check if interfaces directory exists
if (!existsSync(INTERFACES_DIR)) {
  console.error('Interfaces directory not found');
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

// Get all interface files
function getAllInterfaceFiles(dir, relativePath = '', result = []) {
  const files = readdirSync(dir);
  
  for (const file of files) {
    const filePath = join(dir, file);
    const stats = statSync(filePath);
    
    if (stats.isDirectory()) {
      const newRelativePath = join(relativePath, file);
      getAllInterfaceFiles(filePath, newRelativePath, result);
    } else if (file.endsWith('.sol')) {
      result.push({
        path: filePath,
        relativePath: relativePath
      });
    }
  }
  
  return result;
}

// Extract interface name from file content
function extractInterfaceName(filePath) {
  try {
    const content = readFileSync(filePath, 'utf8');
    
    // Try to match interface definition
    const interfaceMatch = content.match(/interface\s+(\w+)/);
    if (interfaceMatch && interfaceMatch[1]) {
      return interfaceMatch[1];
    }
    
    // Try to match the file name (remove the 'I' prefix if exists)
    const fileName = basename(filePath, '.sol');
    if (fileName.startsWith('I')) {
      return fileName;
    }
    
    return null;
  } catch (error) {
    console.error(`Error reading file ${filePath}:`, error.message);
    return null;
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

// Process a single interface file to extract ABI
function processInterface(interfaceFile) {
  const { path, relativePath } = interfaceFile;
  const fileName = basename(path, '.sol');
  const outDir = join(ABIS_DIR, relativePath);
  
  // Create directory if it doesn't exist
  if (!existsSync(outDir)) {
    mkdirSync(outDir, { recursive: true });
  }
  
  const outputPath = join(outDir, `${fileName}.json`);
  console.log(`Processing ${relative(INTERFACES_DIR, path)}`);
  
  try {
    // Generate ABI using solc
    let solcCmd = `solc --abi --pretty-json --include-path node_modules/ --base-path . -o ${TEMP_DIR} ${path}`;
    try {
      execSync(solcCmd, { stdio: 'pipe' });
    } catch (solcError) {
      // If solc fails, try solcjs
      solcCmd = `solcjs --abi --include-path node_modules/ --base-path . -o ${TEMP_DIR} ${path}`;
      execSync(solcCmd, { stdio: 'pipe' });
    }
    
    // Find the generated ABI file
    const abiFiles = readdirSync(TEMP_DIR);
    let abiFile = null;
    
    const interfaceName = extractInterfaceName(path);
    for (const file of abiFiles) {
      if (interfaceName && file.includes(interfaceName)) {
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
console.log('Scanning interfaces...');
const interfaceFiles = getAllInterfaceFiles(INTERFACES_DIR);
console.log(`Found ${interfaceFiles.length} interface files`);

console.log('Generating ABIs...');
for (const interfaceFile of interfaceFiles) {
  processInterface(interfaceFile);
}

// Clean up temp directory
if (existsSync(TEMP_DIR)) {
  rmSync(TEMP_DIR, { recursive: true, force: true });
}

console.log('ABI generation complete'); 