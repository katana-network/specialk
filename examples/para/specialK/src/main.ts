import { createPublicClient, createWalletClient, http, custom, formatEther, formatUnits, PublicClient, WalletClient } from 'viem';
import getContractAddress, { CHAIN_IDS } from '../utils/addresses';

// Import ABIs from their respective locations
import AUSD_ABI from '../abis/tokens/IAUSD.json';
import WETH_ABI from '../abis/vb/IWETH.json';
import MORPHO_BLUE_ABI from '../abis/IMorphoBlue.json';

// Get addresses based on chain ID
const TATARA_CHAIN_ID = CHAIN_IDS.TATARA;

// DOM Elements
const networkIndicator = document.getElementById('network-indicator') as HTMLElement;
const networkName = document.getElementById('network-name') as HTMLElement;
const walletStatus = document.getElementById('wallet-status') as HTMLElement;
const connectWalletButton = document.getElementById('connect-wallet') as HTMLButtonElement;
const ausdDataElement = document.getElementById('ausd-data') as HTMLElement;
const wethDataElement = document.getElementById('weth-data') as HTMLElement;
const morphoDataElement = document.getElementById('morpho-data') as HTMLElement;

// Check for wallet
const hasEthereum = typeof window !== 'undefined' && window.ethereum;

// Create clients
let publicClient: PublicClient;
let walletClient: WalletClient;

// Create transport with retry logic
function createRobustTransport() {
  // Create transport with retries
  return http('http://localhost:8545', {
    timeout: 10000, // 10 seconds
    fetchOptions: {
      headers: {
        'Content-Type': 'application/json',
      },
      cache: 'no-cache',
    },
    // Basic retry with exponential backoff
    retryCount: 3,
    retryDelay: 1000,
  });
}

// Setup
async function initialize() {
  try {
    // Create a public client with custom config
    publicClient = createPublicClient({
      transport: createRobustTransport()
    });

    // Test connection with a simple method first
    try {
      // Ping the RPC with a simple request before attempting more complex calls
      await publicClient.getBlockNumber();
      
      // Then try to get chain ID
      const chainId = await publicClient.getChainId();
      
      if (chainId === TATARA_CHAIN_ID) {
        updateNetworkStatus('connected', 'Tatara');
        
        // Get AUSD address dynamically
        const ausdAddress = getContractAddress('AUSD', TATARA_CHAIN_ID);
        
        // Validate that we can read contract data before attempting to load everything
        if (!ausdAddress) {
          throw new Error('AUSD address not found');
        }
        
        // This acts as a sanity check
        try {
          const ausdSymbol = await publicClient.readContract({
            address: ausdAddress,
            abi: AUSD_ABI,
            functionName: 'symbol'
          });
          console.log(`Connected and able to read contracts. AUSD symbol: ${ausdSymbol}`);
          
          // Now load all contract data
          loadContractData();
        } catch (contractError) {
          console.error('Contract read test failed:', contractError);
          updateNetworkStatus('error', 'Contract read failed');
          displayRpcError('Contract read error. The fork might not have the contract state loaded correctly.');
        }
      } else {
        updateNetworkStatus('error', `Wrong network: ${chainId}`);
        displayRpcError(`Connected to wrong network. Expected ${TATARA_CHAIN_ID} (Tatara), got ${chainId}`);
      }
    } catch (error) {
      console.error('RPC connection error:', error);
      updateNetworkStatus('error', 'Fork not running');
      displayRpcError('Unable to connect to local Tatara fork');
    }
  } catch (error) {
    console.error('Initialization error:', error);
    updateNetworkStatus('error', 'Connection error');
    displayRpcError();
  }

  // Handle wallet connection separately from RPC connection
  if (!hasEthereum) {
    walletStatus.textContent = 'No wallet detected';
  }
}

// Display RPC connection error
function displayRpcError(customMessage?: string) {
  const errorMessage = `
    <div class="error-message">
      <h4>⚠️ RPC Connection Error</h4>
      ${customMessage ? `<p>${customMessage}</p>` : ''}
      <p>Make sure you've started the local Tatara fork with:</p>
      <pre>bun run start:anvil:tatara</pre>
      <p>Your local RPC should be running at http://localhost:8545</p>
    </div>
  `;

  // Display error in all contract data elements
  ausdDataElement.innerHTML = errorMessage;
  wethDataElement.innerHTML = errorMessage;
  morphoDataElement.innerHTML = errorMessage;
}

// Update network status indicator
function updateNetworkStatus(status: 'connected' | 'error' | 'warning', name: string) {
  networkIndicator.className = status;
  networkName.textContent = name;
}

// Connect wallet
async function connectWallet() {
  if (!hasEthereum) {
    alert('Please install MetaMask or another Ethereum wallet');
    return;
  }

  try {
    // Request account access
    walletClient = createWalletClient({
      transport: custom(window.ethereum)
    });
    
    const accounts = await walletClient.requestAddresses();
    
    if (accounts.length > 0) {
      walletStatus.textContent = `Connected: ${shortenAddress(accounts[0])}`;
      connectWalletButton.textContent = 'Connected';
      connectWalletButton.disabled = true;
    }
  } catch (error) {
    console.error('Connection error:', error);
    walletStatus.textContent = 'Connection failed';
  }
}

// Shorten address for display
function shortenAddress(address: string): string {
  return `${address.substring(0, 6)}...${address.substring(address.length - 4)}`;
}

// Generic function to safely load contract data with fallback
export async function safeContractCall<T>(
  callback: () => Promise<T>,
  errorHandler: (error: unknown) => void
): Promise<T | null> {
  try {
    return await callback();
  } catch (error) {
    errorHandler(error);
    return null;
  }
}

// Load AUSD Token data
async function loadAUSDData() {
  // Get AUSD address
  const ausdAddress = getContractAddress('AUSD', TATARA_CHAIN_ID);
  if (!ausdAddress) {
    ausdDataElement.innerHTML = '<p>Error: AUSD address not found</p>';
    return;
  }

  // Clear previous content and show loading state
  ausdDataElement.innerHTML = '<div class="spinner"></div><p>Loading data...</p>';
  
  try {
    // Load data sequentially to avoid batching issues
    const name = await safeContractCall(
      () => publicClient.readContract({
        address: ausdAddress,
        abi: AUSD_ABI,
        functionName: 'name'
      }),
      (error) => console.error('Error reading AUSD name:', error)
    );
    
    const symbol = await safeContractCall(
      () => publicClient.readContract({
        address: ausdAddress,
        abi: AUSD_ABI,
        functionName: 'symbol'
      }),
      (error) => console.error('Error reading AUSD symbol:', error)
    );
    
    const decimals = await safeContractCall(
      () => publicClient.readContract({
        address: ausdAddress,
        abi: AUSD_ABI,
        functionName: 'decimals'
      }),
      (error) => console.error('Error reading AUSD decimals:', error)
    );
    
    const totalSupply = await safeContractCall(
      () => publicClient.readContract({
        address: ausdAddress,
        abi: AUSD_ABI,
        functionName: 'totalSupply'
      }),
      (error) => console.error('Error reading AUSD totalSupply:', error)
    );

    // If we couldn't get any data, show error
    if (!name && !symbol && !decimals && !totalSupply) {
      throw new Error('Failed to load any AUSD data');
    }

    // Format and display data
    ausdDataElement.innerHTML = '';
    ausdDataElement.classList.add('loaded');

    // Calculate total supply formatted string
    let formattedSupply = 'Error loading';
    if (totalSupply !== null && decimals !== null) {
      try {
        // totalSupply is expected to be a bigint, ensure it is one
        const supplyBigInt = typeof totalSupply === 'bigint' ? totalSupply : BigInt(0);
        const decimalNumber = typeof decimals === 'number' ? decimals : 18;
        formattedSupply = `${formatUnits(supplyBigInt, decimalNumber)} ${symbol || ''}`;
      } catch (e) {
        console.error('Error formatting AUSD supply:', e);
      }
    }

    // Use type guards to ensure proper formatting
    const formattedData = [
      { label: 'Name', value: name ? String(name) : 'Error loading' },
      { label: 'Symbol', value: symbol ? String(symbol) : 'Error loading' },
      { label: 'Decimals', value: decimals !== null ? String(decimals) : 'Error loading' },
      { label: 'Total Supply', value: formattedSupply },
      { label: 'Address', value: ausdAddress }
    ];

    formattedData.forEach(item => {
      const dataItem = document.createElement('div');
      dataItem.className = 'data-item';
      dataItem.innerHTML = `
        <div class="label">${item.label}</div>
        <div class="value">${item.value}</div>
      `;
      ausdDataElement.appendChild(dataItem);
    });
  } catch (error) {
    console.error('Error loading AUSD data:', error);
    ausdDataElement.innerHTML = '<p>Error loading data. Make sure the Tatara fork is running.</p>';
  }
}

// Load WETH Token data
export async function loadWETHData() {
  // Get WETH address
  const wethAddress = getContractAddress('WETH', TATARA_CHAIN_ID);
  if (!wethAddress) {
    wethDataElement.innerHTML = '<p>Error: WETH address not found</p>';
    return;
  }

  // Clear previous content and show loading state
  wethDataElement.innerHTML = '<div class="spinner"></div><p>Loading data...</p>';
  
  try {
    // Load data sequentially to avoid batching issues
    const name = await safeContractCall(
      () => publicClient.readContract({
        address: wethAddress,
        abi: WETH_ABI,
        functionName: 'name'
      }),
      (error) => console.error('Error reading WETH name:', error)
    );
    
    const symbol = await safeContractCall(
      () => publicClient.readContract({
        address: wethAddress,
        abi: WETH_ABI,
        functionName: 'symbol'
      }),
      (error) => console.error('Error reading WETH symbol:', error)
    );
    
    const totalSupply = await safeContractCall(
      () => publicClient.readContract({
        address: wethAddress,
        abi: WETH_ABI,
        functionName: 'totalSupply'
      }),
      (error) => console.error('Error reading WETH totalSupply:', error)
    );

    // If we couldn't get any data, show error
    if (!name && !symbol && !totalSupply) {
      throw new Error('Failed to load any WETH data');
    }

    // Format and display data
    wethDataElement.innerHTML = '';
    wethDataElement.classList.add('loaded');

    // Calculate total supply formatted string
    let formattedSupply = 'Error loading';
    if (totalSupply !== null) {
      try {
        // totalSupply is expected to be a bigint, ensure it is one
        const supplyBigInt = typeof totalSupply === 'bigint' ? totalSupply : BigInt(0);
        formattedSupply = `${formatEther(supplyBigInt)} ${symbol || ''}`;
      } catch (e) {
        console.error('Error formatting WETH supply:', e);
      }
    }

    // Use type guards to ensure proper formatting
    const formattedData = [
      { label: 'Name', value: name ? String(name) : 'Error loading' },
      { label: 'Symbol', value: symbol ? String(symbol) : 'Error loading' },
      { label: 'Total Supply', value: formattedSupply },
      { label: 'Address', value: wethAddress }
    ];

    formattedData.forEach(item => {
      const dataItem = document.createElement('div');
      dataItem.className = 'data-item';
      dataItem.innerHTML = `
        <div class="label">${item.label}</div>
        <div class="value">${item.value}</div>
      `;
      wethDataElement.appendChild(dataItem);
    });
  } catch (error) {
    console.error('Error loading WETH data:', error);
    wethDataElement.innerHTML = '<p>Error loading data. Make sure the Tatara fork is running.</p>';
  }
}

// Load MorphoBlue data
async function loadMorphoData() {
  // Get MorphoBlue address
  const morphoAddress = getContractAddress('MorphoBlue', TATARA_CHAIN_ID);
  if (!morphoAddress) {
    morphoDataElement.innerHTML = '<p>Error: MorphoBlue address not found</p>';
    return;
  }

  // Clear previous content and show loading state
  morphoDataElement.innerHTML = '<div class="spinner"></div><p>Loading data...</p>';
  
  try {
    // Load data sequentially to avoid batching issues
    const owner = await safeContractCall(
      () => publicClient.readContract({
        address: morphoAddress,
        abi: MORPHO_BLUE_ABI,
        functionName: 'owner'
      }),
      (error) => console.error('Error reading MorphoBlue owner:', error)
    );
    
    const feeRecipient = await safeContractCall(
      () => publicClient.readContract({
        address: morphoAddress,
        abi: MORPHO_BLUE_ABI,
        functionName: 'feeRecipient'
      }),
      (error) => console.error('Error reading MorphoBlue feeRecipient:', error)
    );

    // Check if 50% LLTV is enabled
    const lltv50Percent = 5000n; // 50% in basis points
    const isLltv50Enabled = await safeContractCall(
      () => publicClient.readContract({
        address: morphoAddress,
        abi: MORPHO_BLUE_ABI,
        functionName: 'isLltvEnabled',
        args: [lltv50Percent]
      }),
      (error) => console.error('Error reading MorphoBlue LLTV:', error)
    );

    // If we couldn't get any data, show error
    if (!owner && !feeRecipient && isLltv50Enabled === null) {
      throw new Error('Failed to load any MorphoBlue data');
    }

    // Format and display data
    morphoDataElement.innerHTML = '';
    morphoDataElement.classList.add('loaded');

    // Use type guards to ensure proper formatting
    const formattedData = [
      { label: 'Owner', value: owner ? shortenAddress(String(owner)) : 'Error loading' },
      { label: 'Fee Recipient', value: feeRecipient ? shortenAddress(String(feeRecipient)) : 'Error loading' },
      { label: '50% LLTV Enabled', value: isLltv50Enabled === null ? 'Error loading' : 
          isLltv50Enabled ? 'Yes' : 'No' },
      { label: 'Address', value: morphoAddress }
    ];

    formattedData.forEach(item => {
      const dataItem = document.createElement('div');
      dataItem.className = 'data-item';
      dataItem.innerHTML = `
        <div class="label">${item.label}</div>
        <div class="value">${item.value}</div>
      `;
      morphoDataElement.appendChild(dataItem);
    });
  } catch (error) {
    console.error('Error loading MorphoBlue data:', error);
    morphoDataElement.innerHTML = '<p>Error loading data. Make sure the Tatara fork is running.</p>';
  }
}

// Load all contract data
async function loadContractData() {
  // Load data sequentially to avoid overloading TEVM server
  try {
    await loadAUSDData();
    await loadWETHData();
    await loadMorphoData();
  } catch (error) {
    console.error('Failed to load contract data:', error);
  }
}

// Add error styles
const style = document.createElement('style');
style.textContent = `
  .error-message {
    background-color: #fef2f2;
    border: 1px solid #fee2e2;
    border-radius: 6px;
    padding: 12px;
    margin-top: 10px;
  }
  
  .error-message h4 {
    color: #dc2626;
    margin-bottom: 8px;
  }
  
  .error-message pre {
    background-color: #f1f5f9;
    padding: 8px;
    border-radius: 4px;
    margin: 8px 0;
    overflow-x: auto;
  }
`;
document.head.appendChild(style);

// Event listeners
connectWalletButton.addEventListener('click', connectWallet);

// Initialize the app
initialize();

// Add window.ethereum type
declare global {
  interface Window {
    ethereum: unknown;
  }
}
