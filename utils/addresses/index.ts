// Address management wrapper with improved API
// This file is manually maintained - do not auto-generate

import { CONTRACT_ADDRESSES, ORIGIN_CONTRACT_ADDRESSES, CHAIN_IDS } from './mapping';

/**
 * Chain IDs for all supported networks
 */
export interface ChainIds {
  TATARA: number;
  KATANA: number;
  BOKUTO: number;
}

/**
 * Contract addresses for each network
 */
export interface ContractAddresses {
  [contractName: string]: {
    tatara: `0x${string}` | null;
    katana: `0x${string}` | null;
    bokuto: `0x${string}` | null;
  };
}

// Export the chain IDs from mapping
export { CHAIN_IDS };

/**
 * Supported chain names
 */
export type ChainName = 'tatara' | 'katana' | 'bokuto';

/**
 * Map chain names to their IDs
 */
export const CHAINS = {
  tatara: CHAIN_IDS.TATARA,
  katana: CHAIN_IDS.KATANA,
  bokuto: CHAIN_IDS.BOKUTO,
} as const;

/**
 * Get a contract address based on the contract name and chain ID
 * @param contractName - The name of the contract
 * @param chainId - The chain ID
 * @returns The contract address or null if not found
 */
function getContractAddress(contractName: string, chainId: number): `0x${string}` | null {
  if (!contractName || !CONTRACT_ADDRESSES[contractName]) {
    return null;
  }
  
  switch (chainId) {
    case CHAIN_IDS.TATARA:
      return CONTRACT_ADDRESSES[contractName].tatara as `0x${string}` | null;
    case CHAIN_IDS.KATANA:
      return CONTRACT_ADDRESSES[contractName].katana as `0x${string}` | null;
    case CHAIN_IDS.BOKUTO:
      return CONTRACT_ADDRESSES[contractName].bokuto as `0x${string}` | null;
    default:
      return null;
  }
}

/**
 * Get an origin contract address based on the contract name and chain ID
 * @param contractName - The name of the contract
 * @param chainId - The chain ID (representing the context, not the origin chain)
 * @returns The origin contract address or null if not found
 */
function getOriginContractAddress(contractName: string, chainId: number): `0x${string}` | null {
  if (!contractName || !ORIGIN_CONTRACT_ADDRESSES[contractName]) {
    return null;
  }
  
  switch (chainId) {
    case CHAIN_IDS.TATARA:
      return ORIGIN_CONTRACT_ADDRESSES[contractName].tatara as `0x${string}` | null;
    case CHAIN_IDS.KATANA:
      return ORIGIN_CONTRACT_ADDRESSES[contractName].katana as `0x${string}` | null;
    case CHAIN_IDS.BOKUTO:
      return ORIGIN_CONTRACT_ADDRESSES[contractName].bokuto as `0x${string}` | null;
    default:
      return null;
  }
}

/**
 * Address management class with chain context
 */
class AddressManager {
  private currentChainId: number | null = null;

  /**
   * Set the current chain context
   * @param chainIdOrName - Chain ID or name to set as context
   * @example
   * addresses.setChain(CHAINS.tatara);
   * addresses.setChain('tatara');
   * addresses.setChain(129399);
   */
  setChain(chainIdOrName: number | ChainName): void {
    if (typeof chainIdOrName === 'string') {
      const chainId = CHAINS[chainIdOrName];
      if (!chainId) {
        throw new Error(`Unknown chain name: ${chainIdOrName}. Valid names are: ${Object.keys(CHAINS).join(', ')}`);
      }
      this.currentChainId = chainId;
    } else {
      // Validate that it's a known chain ID
      const validChainIds = Object.values(CHAIN_IDS);
      if (!validChainIds.includes(chainIdOrName)) {
        throw new Error(`Unknown chain ID: ${chainIdOrName}. Valid IDs are: ${validChainIds.join(', ')}`);
      }
      this.currentChainId = chainIdOrName;
    }
  }

  /**
   * Get the current chain ID
   * @returns The current chain ID or null if not set
   */
  getChain(): number | null {
    return this.currentChainId;
  }

  /**
   * Get the current chain name
   * @returns The current chain name or null if not set
   */
  getChainName(): ChainName | null {
    if (!this.currentChainId) return null;
    
    for (const [name, id] of Object.entries(CHAINS)) {
      if (id === this.currentChainId) {
        return name as ChainName;
      }
    }
    return null;
  }

  /**
   * Get a contract address for the current chain
   * @param contractName - Name of the contract (with or without 'I' prefix)
   * @returns The contract address
   * @throws Error if chain not set or contract not found
   * @example
   * addresses.setChain('tatara');
   * const wethAddress = addresses.getAddress('WETH'); // Automatically tries 'IWETH' if 'WETH' not found
   */
  getAddress(contractName: string): `0x${string}` {
    if (!this.currentChainId) {
      throw new Error('Chain not set. Call setChain() first.');
    }

    // Try exact name first
    let address = getContractAddress(contractName, this.currentChainId);
    
    // If not found and doesn't start with 'I', try with 'I' prefix
    if (!address && !contractName.startsWith('I')) {
      address = getContractAddress('I' + contractName, this.currentChainId);
    }
    
    // If not found and starts with 'I', try without 'I' prefix
    if (!address && contractName.startsWith('I')) {
      address = getContractAddress(contractName.substring(1), this.currentChainId);
    }

    if (!address) {
      const chainName = this.getChainName();
      const availableContracts = Object.keys(CONTRACT_ADDRESSES)
        .filter(name => CONTRACT_ADDRESSES[name][chainName as ChainName])
        .sort();
      
      throw new Error(
        `Contract "${contractName}" not found on ${chainName} (chain ID: ${this.currentChainId}). ` +
        `Available contracts: ${availableContracts.join(', ')}`
      );
    }

    return address;
  }

  /**
   * Get a contract address for a specific chain (without setting context)
   * @param contractName - Name of the contract (with or without 'I' prefix)
   * @param chainIdOrName - Chain ID or name
   * @returns The contract address or null if not found
   */
  getAddressForChain(contractName: string, chainIdOrName: number | ChainName): `0x${string}` | null {
    const chainId = typeof chainIdOrName === 'string' ? CHAINS[chainIdOrName] : chainIdOrName;
    
    if (!chainId) {
      return null;
    }

    // Try exact name first
    let address = getContractAddress(contractName, chainId);
    
    // If not found and doesn't start with 'I', try with 'I' prefix
    if (!address && !contractName.startsWith('I')) {
      address = getContractAddress('I' + contractName, chainId);
    }
    
    // If not found and starts with 'I', try without 'I' prefix
    if (!address && contractName.startsWith('I')) {
      address = getContractAddress(contractName.substring(1), chainId);
    }

    return address;
  }

  /**
   * Check if a contract exists on the current chain
   * @param contractName - Name of the contract (with or without 'I' prefix)
   * @returns True if the contract exists on the current chain
   */
  hasContract(contractName: string): boolean {
    if (!this.currentChainId) {
      return false;
    }

    const address = this.getAddressForChain(contractName, this.currentChainId);
    return address !== null;
  }

  /**
   * Get all contract names available on the current chain
   * @returns Array of contract names
   */
  getAllContracts(): string[] {
    if (!this.currentChainId) {
      throw new Error('Chain not set. Call setChain() first.');
    }

    const chainName = this.getChainName();
    return Object.keys(CONTRACT_ADDRESSES)
      .filter(name => CONTRACT_ADDRESSES[name][chainName as ChainName])
      .sort();
  }

  /**
   * Get an origin contract address for the current chain context
   * Origin contracts are deployed on origin chains (Ethereum/Sepolia) but accessed
   * from the current chain context (e.g., for Vault Bridge operations)
   * @param contractName - Name of the contract (with or without 'I' prefix)
   * @returns The origin contract address
   * @throws Error if chain not set or contract not found
   * @example
   * addresses.setChain('katana');
   * const vbUSDCAddress = addresses.getOriginAddress('vbUSDC'); // Gets the Ethereum address
   */
  getOriginAddress(contractName: string): `0x${string}` {
    if (!this.currentChainId) {
      throw new Error('Chain not set. Call setChain() first.');
    }

    // Try exact name first
    let address = getOriginContractAddress(contractName, this.currentChainId);
    
    // If not found and doesn't start with 'I', try with 'I' prefix
    if (!address && !contractName.startsWith('I')) {
      address = getOriginContractAddress('I' + contractName, this.currentChainId);
    }
    
    // If not found and starts with 'I', try without 'I' prefix
    if (!address && contractName.startsWith('I')) {
      address = getOriginContractAddress(contractName.substring(1), this.currentChainId);
    }

    if (!address) {
      const chainName = this.getChainName();
      const availableOriginContracts = Object.keys(ORIGIN_CONTRACT_ADDRESSES)
        .filter(name => ORIGIN_CONTRACT_ADDRESSES[name][chainName as ChainName])
        .sort();
      
      throw new Error(
        `Origin contract "${contractName}" not found for chain ${chainName}. ` +
        `Available origin contracts: ${availableOriginContracts.join(', ')}`
      );
    }

    return address;
  }

  /**
   * Get an origin contract address for a specific chain without changing context
   * @param contractName - Name of the contract
   * @param chainIdOrName - Chain ID or name
   * @returns The origin contract address or null if not found
   */
  getOriginAddressForChain(contractName: string, chainIdOrName: number | ChainName): `0x${string}` | null {
    const chainId = typeof chainIdOrName === 'string' ? CHAINS[chainIdOrName] : chainIdOrName;
    
    // Try exact name first
    let address = getOriginContractAddress(contractName, chainId);
    
    // If not found and doesn't start with 'I', try with 'I' prefix
    if (!address && !contractName.startsWith('I')) {
      address = getOriginContractAddress('I' + contractName, chainId);
    }
    
    // If not found and starts with 'I', try without 'I' prefix
    if (!address && contractName.startsWith('I')) {
      address = getOriginContractAddress(contractName.substring(1), chainId);
    }

    return address;
  }

  /**
   * Check if an origin contract exists on the current chain
   * @param contractName - Name of the contract
   * @returns True if the origin contract exists
   */
  hasOriginContract(contractName: string): boolean {
    if (!this.currentChainId) {
      return false;
    }

    const address = this.getOriginAddressForChain(contractName, this.currentChainId);
    return address !== null;
  }

  /**
   * Get all origin contract names available on the current chain
   * @returns Array of origin contract names
   */
  getAllOriginContracts(): string[] {
    if (!this.currentChainId) {
      throw new Error('Chain not set. Call setChain() first.');
    }

    const chainName = this.getChainName();
    return Object.keys(ORIGIN_CONTRACT_ADDRESSES)
      .filter(name => ORIGIN_CONTRACT_ADDRESSES[name][chainName as ChainName])
      .sort();
  }
}

// Export a singleton instance
export const addresses = new AddressManager();

// Also export the class for advanced usage
export { AddressManager };

// Export the contract addresses for advanced usage
export { CONTRACT_ADDRESSES, ORIGIN_CONTRACT_ADDRESSES };