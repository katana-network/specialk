import { createPublicClient, createWalletClient, http, custom, formatEther, formatUnits, PublicClient, WalletClient } from 'viem';
import { addresses, CHAIN_IDS } from '../utils/addresses/index.js';

// Import ABIs from their respective locations
import AUSD_ABI from '../abis/tokens/IAUSD.json';
import WETH_ABI from '../abis/vb/tokens/IbvbEth.json';
import MORPHO_BLUE_ABI from '../abis/morpho/IMorphoBlue.json';

// Chain information
const CHAIN_INFO = {
  [CHAIN_IDS.KATANA]: { name: 'Katana', symbol: 'ETH' },
  [CHAIN_IDS.BOKUTO]: { name: 'Bokuto', symbol: 'ETH' }
};

// Current chain context - will be set dynamically
let currentChainId: number | null = null;
let currentChainInfo: { name: string; symbol: string } | null = null;

// DOM Elements
const networkIndicator = document.getElementById('network-indicator') as HTMLElement;
const networkName = document.getElementById('network-name') as HTMLElement;
const walletStatus = document.getElementById('wallet-status') as HTMLElement;
const connectWalletButton = document.getElementById('connect-wallet') as HTMLButtonElement;
const ausdDataElement = document.getElementById('ausd-data') as HTMLElement;
const wethDataElement = document.getElementById('weth-data') as HTMLElement;
const morphoDataElement = document.getElementById('morpho-data') as HTMLElement;

// Address display elements
const ausdAddressElement = document.getElementById('ausd-address') as HTMLElement;
const wethAddressElement = document.getElementById('weth-address') as HTMLElement;
const morphoAddressElement = document.getElementById('morpho-address') as HTMLElement;

// Origin contract elements
const vbusdcOriginDataElement = document.getElementById('vbusdc-origin-data') as HTMLElement;
const vbethOriginDataElement = document.getElementById('vbeth-origin-data') as HTMLElement;
const vbusdcOriginAddressElement = document.getElementById('vbusdc-origin-address') as HTMLElement;
const vbethOriginAddressElement = document.getElementById('vbeth-origin-address') as HTMLElement;

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
      
      // Then try to get chain ID and detect which chain we're connected to
      const chainId = await publicClient.getChainId();
      const chainInfo = CHAIN_INFO[chainId as keyof typeof CHAIN_INFO];
      
      if (!chainInfo) {
        const validChainIds = Object.keys(CHAIN_INFO).join(', ');
        updateNetworkStatus('error', `Unknown network: ${chainId}`);
        displayRpcError(`Connected to unknown network. Expected one of: ${validChainIds}`);
        return;
      }
      
      // Set the global chain context
      currentChainId = chainId;
      currentChainInfo = chainInfo;
      
      // Set the address context for this chain
      addresses.setChain(chainId);
      
      updateNetworkStatus('connected', chainInfo.name);
      console.log(`✅ Connected to ${chainInfo.name} (Chain ID: ${chainId})`);
      
      // Test if we have contracts available on this chain
      const availableContracts = addresses.getAllContracts();
      console.log(`📋 Found ${availableContracts.length} contracts available on ${chainInfo.name}`);
      
      // Check if we have the key contracts we want to display
      const hasAUSD = addresses.hasContract('AUSD');
      const hasWETH = addresses.hasContract('bvbEth');
      const hasMorpho = addresses.hasContract('MorphoBlue');
      
      if (!hasAUSD && !hasWETH && !hasMorpho) {
        updateNetworkStatus('warning', `${chainInfo.name} (No contracts)`);
        displayRpcError(`No key contracts (AUSD, bvbEth, MorphoBlue) found on ${chainInfo.name}. The contracts may not be deployed on this chain yet.`);
        return;
      }
      
      // Test reading a contract to validate the connection
      if (hasAUSD) {
        try {
          const ausdAddress = addresses.getAddress('AUSD');
          const ausdSymbol = await publicClient.readContract({
            address: ausdAddress,
            abi: AUSD_ABI,
            functionName: 'symbol'
          });
          console.log(`Connected and able to read contracts. AUSD symbol: ${ausdSymbol}`);
        } catch (contractError) {
          console.error('Contract read test failed:', contractError);
          updateNetworkStatus('error', 'Contract read failed');
          displayRpcError('Contract read error. The fork might not have the contract state loaded correctly.');
          return;
        }
      }
      
      // Update address displays
      updateAddressDisplays();
      
      // Now load all contract data
      loadContractData();
        
    } catch (error) {
      console.error('RPC connection error:', error);
      updateNetworkStatus('error', 'Fork not running');
      displayRpcError('Unable to connect to local chain fork');
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
      <h4>⚠️ Connection Error</h4>
      ${customMessage ? `<p>${customMessage}</p>` : ''}
      <p>Make sure you've started a local chain fork with:</p>
      <pre>bun run start:anvil bokuto   # or bokuto/katana</pre>
      <p>Your local RPC should be running at http://localhost:8545</p>
    </div>
  `;

  // Display error in all contract data elements
  ausdDataElement.innerHTML = errorMessage;
  wethDataElement.innerHTML = errorMessage;
  morphoDataElement.innerHTML = errorMessage;
  vbusdcOriginDataElement.innerHTML = errorMessage;
  vbethOriginDataElement.innerHTML = errorMessage;
}

// Update network status indicator
function updateNetworkStatus(status: 'connected' | 'error' | 'warning', name: string) {
  networkIndicator.className = status;
  networkName.textContent = name;
}

// Update address displays
function updateAddressDisplays() {
  try {
    // Update regular contract addresses
    if (addresses.hasContract('AUSD')) {
      const ausdAddress = addresses.getAddress('AUSD');
      ausdAddressElement.querySelector('code')!.textContent = ausdAddress;
    } else {
      ausdAddressElement.querySelector('code')!.textContent = 'Not deployed on this chain';
    }

    if (addresses.hasContract('bvbEth')) {
      const wethAddress = addresses.getAddress('bvbEth');
      wethAddressElement.querySelector('code')!.textContent = wethAddress;
    } else {
      wethAddressElement.querySelector('code')!.textContent = 'Not deployed on this chain';
    }

    if (addresses.hasContract('MorphoBlue')) {
      const morphoAddress = addresses.getAddress('MorphoBlue');
      morphoAddressElement.querySelector('code')!.textContent = morphoAddress;
    } else {
      morphoAddressElement.querySelector('code')!.textContent = 'Not deployed on this chain';
    }

    // Update origin contract addresses
    if (addresses.hasOriginContract('vbUSDC')) {
      const vbusdcOriginAddress = addresses.getOriginAddress('vbUSDC');
      const originChain = currentChainId === CHAIN_IDS.KATANA ? 'Ethereum' : 'Sepolia';
      vbusdcOriginAddressElement.querySelector('code')!.textContent = vbusdcOriginAddress;
      vbusdcOriginAddressElement.querySelector('span')!.textContent = `${originChain} Address:`;
    } else {
      vbusdcOriginAddressElement.querySelector('code')!.textContent = 'Not available in this context';
    }

    if (addresses.hasOriginContract('vbETH')) {
      const vbethOriginAddress = addresses.getOriginAddress('vbETH');
      const originChain = currentChainId === CHAIN_IDS.KATANA ? 'Ethereum' : 'Sepolia';
      vbethOriginAddressElement.querySelector('code')!.textContent = vbethOriginAddress;
      vbethOriginAddressElement.querySelector('span')!.textContent = `${originChain} Address:`;
    } else {
      vbethOriginAddressElement.querySelector('code')!.textContent = 'Not available in this context';
    }
  } catch (error) {
    console.error('Error updating address displays:', error);
  }
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
async function safeContractCall<T>(
  callback: () => Promise<T>,
  errorHandler: (error: any) => void
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
  // Check if AUSD is available on current chain
  if (!addresses.hasContract('AUSD')) {
    ausdDataElement.innerHTML = `<p>AUSD not available on ${currentChainInfo?.name || 'this chain'}</p>`;
    return;
  }

  // Get AUSD address dynamically
  const ausdAddress = addresses.getAddress('AUSD');

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
    ausdDataElement.innerHTML = `<p>Error loading data. Make sure the ${currentChainInfo?.name || 'chain'} fork is running.</p>`;
  }
}

// Load bvbEth Token data
async function loadWETHData() {
  // Check if bvbEth is available on current chain
  if (!addresses.hasContract('bvbEth')) {
    wethDataElement.innerHTML = `<p>bvbEth not available on ${currentChainInfo?.name || 'this chain'}</p>`;
    return;
  }

  // Get bvbEth address dynamically
  const wethAddress = addresses.getAddress('bvbEth');

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
              (error) => console.error('Error reading bvbEth name:', error)
    );
    
    const symbol = await safeContractCall(
      () => publicClient.readContract({
        address: wethAddress,
        abi: WETH_ABI,
        functionName: 'symbol'
      }),
              (error) => console.error('Error reading bvbEth symbol:', error)
    );
    
    const totalSupply = await safeContractCall(
      () => publicClient.readContract({
        address: wethAddress,
        abi: WETH_ABI,
        functionName: 'totalSupply'
      }),
              (error) => console.error('Error reading bvbEth totalSupply:', error)
    );

    // If we couldn't get any data, show error
    if (!name && !symbol && !totalSupply) {
      throw new Error('Failed to load any bvbEth data');
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
        console.error('Error formatting bvbEth supply:', e);
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
    console.error('Error loading bvbEth data:', error);
    wethDataElement.innerHTML = `<p>Error loading data. Make sure the ${currentChainInfo?.name || 'chain'} fork is running.</p>`;
  }
}

// Load MorphoBlue data
async function loadMorphoData() {
  // Check if MorphoBlue is available on current chain
  if (!addresses.hasContract('MorphoBlue')) {
    morphoDataElement.innerHTML = `<p>MorphoBlue not available on ${currentChainInfo?.name || 'this chain'}</p>`;
    return;
  }

  // Get MorphoBlue address dynamically
  const morphoAddress = addresses.getAddress('MorphoBlue');

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
    morphoDataElement.innerHTML = `<p>Error loading data. Make sure the ${currentChainInfo?.name || 'chain'} fork is running.</p>`;
  }
}

// Load origin contract data for vbUSDC
async function loadVBUSDCOriginData() {
  if (!addresses.hasOriginContract('vbUSDC')) {
    const originChain = currentChainId === CHAIN_IDS.KATANA ? 'Ethereum' : 'Sepolia';
    vbusdcOriginDataElement.innerHTML = `<p>vbUSDC not available on ${originChain} in this context</p>`;
    return;
  }

  vbusdcOriginDataElement.innerHTML = '<div class="spinner"></div><p>Loading origin data...</p>';
  
  try {
    const vbusdcOriginAddress = addresses.getOriginAddress('vbUSDC');
    const originChain = currentChainId === CHAIN_IDS.KATANA ? 'Ethereum' : 'Sepolia';
    
    // Since we're demonstrating cross-chain addresses, we can't actually read from origin contracts
    // via the local fork, but we can show the address and explain the concept
    vbusdcOriginDataElement.innerHTML = '';
    vbusdcOriginDataElement.classList.add('loaded');

    const formattedData = [
      { label: 'Origin Chain', value: originChain },
      { label: 'Contract Type', value: 'Vault Bridge USDC Token' },
      { label: 'Purpose', value: 'Cross-chain yield-bearing USDC' },
      { label: 'Origin Address', value: vbusdcOriginAddress },
      { label: 'Note', value: 'This contract exists on the origin chain and cannot be read directly from the destination chain fork.' }
    ];

    formattedData.forEach(item => {
      const dataItem = document.createElement('div');
      dataItem.className = 'data-item';
      dataItem.innerHTML = `
        <div class="label">${item.label}</div>
        <div class="value">${item.value}</div>
      `;
      vbusdcOriginDataElement.appendChild(dataItem);
    });
  } catch (error) {
    console.error('Error loading vbUSDC origin data:', error);
    vbusdcOriginDataElement.innerHTML = `<p>Error loading origin data.</p>`;
  }
}

// Load origin contract data for vbETH
async function loadVBETHOriginData() {
  if (!addresses.hasOriginContract('vbETH')) {
    const originChain = currentChainId === CHAIN_IDS.KATANA ? 'Ethereum' : 'Sepolia';
    vbethOriginDataElement.innerHTML = `<p>vbETH not available on ${originChain} in this context</p>`;
    return;
  }

  vbethOriginDataElement.innerHTML = '<div class="spinner"></div><p>Loading origin data...</p>';
  
  try {
    const vbethOriginAddress = addresses.getOriginAddress('vbETH');
    const originChain = currentChainId === CHAIN_IDS.KATANA ? 'Ethereum' : 'Sepolia';
    
    vbethOriginDataElement.innerHTML = '';
    vbethOriginDataElement.classList.add('loaded');

    const formattedData = [
      { label: 'Origin Chain', value: originChain },
      { label: 'Contract Type', value: 'Vault Bridge ETH Token' },
      { label: 'Purpose', value: 'Cross-chain yield-bearing ETH' },
      { label: 'Origin Address', value: vbethOriginAddress },
      { label: 'Note', value: 'This contract exists on the origin chain and cannot be read directly from the destination chain fork.' }
    ];

    formattedData.forEach(item => {
      const dataItem = document.createElement('div');
      dataItem.className = 'data-item';
      dataItem.innerHTML = `
        <div class="label">${item.label}</div>
        <div class="value">${item.value}</div>
      `;
      vbethOriginDataElement.appendChild(dataItem);
    });
  } catch (error) {
    console.error('Error loading vbETH origin data:', error);
    vbethOriginDataElement.innerHTML = `<p>Error loading origin data.</p>`;
  }
}

// Load all contract data
async function loadContractData() {
  // Load data sequentially to avoid overloading the server
  // Only load contracts that are available on the current chain
  try {
    console.log(`📊 Loading contract data for ${currentChainInfo?.name}...`);
    
    if (addresses.hasContract('AUSD')) {
      await loadAUSDData();
    } else {
      ausdDataElement.innerHTML = `<p>AUSD not deployed on ${currentChainInfo?.name}</p>`;
    }
    
    if (addresses.hasContract('bvbEth')) {
      await loadWETHData();
    } else {
      wethDataElement.innerHTML = `<p>bvbEth not deployed on ${currentChainInfo?.name}</p>`;
    }
    
    if (addresses.hasContract('MorphoBlue')) {
      await loadMorphoData();
    } else {
      morphoDataElement.innerHTML = `<p>MorphoBlue not deployed on ${currentChainInfo?.name}</p>`;
    }

    // Load origin contract data
    await loadVBUSDCOriginData();
    await loadVBETHOriginData();
    
    console.log('✅ Contract data loading complete');
  } catch (error) {
    console.error('Failed to load contract data:', error);
  }
}

// Add error styles and section styling
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
  
  .section-description {
    color: #6b7280;
    font-style: italic;
    margin-bottom: 1rem;
    line-height: 1.5;
  }
  
  #origin-contracts-section {
    margin-top: 2rem;
    padding-top: 1.5rem;
    border-top: 1px solid #e5e7eb;
  }
  
  #origin-contracts-section .card {
    border-left: 3px solid #10b981;
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
    ethereum: any;
  }
}
