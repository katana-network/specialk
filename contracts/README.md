# Katana Contract Interfaces

This folder contains Solidity interfaces for all core contracts deployed on
**Katana**, **Tatara** (testnet), and **Bokuto** (testnet). These interfaces
provide a unified way to interact with the diverse ecosystem of DeFi protocols,
bridges, oracles, and utilities available across the Katana network.

## 📋 Address Management System

The starter kit provides both **Solidity** and **JavaScript/TypeScript**
utilities for managing contract addresses across networks.

### Solidity Address Libraries

Network-specific address libraries are auto-generated and provide type-safe
access to contract addresses:

```solidity
import "./utils/KatanaAddresses.sol";
import "./utils/TataraAddresses.sol";
import "./utils/BokutoAddresses.sol";

contract MyDapp {
    function usebvbEth() external {
        // Automatically gets the correct address for the current network
        address wethAddress = KatanaAddresses.getbvbEthAddress();
        IbvbEth weth = IbvbEth(wethAddress);
        weth.deposit{value: 1 ether}();
    }
}
```

### JavaScript/TypeScript Address API

For frontend applications, use the comprehensive address management system:

```javascript
import { addresses, CHAINS } from '../utils/addresses';

// Set the chain context (by name or ID)
addresses.setChain('katana');
// or addresses.setChain(CHAINS.katana);

// Get contract addresses with automatic "I" prefix handling
const wethAddress = addresses.getAddress('bvbEth');      // Finds IbvbEth automatically
const morphoAddress = addresses.getAddress('MorphoBlue'); // Direct match
const ausdAddress = addresses.getAddress('AUSD');      // Finds IAUSD

// Check contract availability
if (addresses.hasContract('Permit2')) {
  const permit2 = addresses.getAddress('Permit2');
}

// Get all available contracts on current chain
const allContracts = addresses.getAllContracts();

// Cross-chain origin addresses (for Vault Bridge)
addresses.setChain('katana');
const bridgedUSDC = addresses.getAddress('bvbUSDC');      // Katana address
const originUSDC = addresses.getOriginAddress('vbUSDC');  // Ethereum address
```

### Generating Address Utilities

To update the address utilities after adding new contracts:

```bash
bun run build:addressutils
```

This generates:

- **Solidity libraries**: `contracts/utils/[Network]Addresses.sol`
- **Origin chain libraries**: `contracts/utils/[Network]OriginAddresses.sol`
- **TypeScript mapping**: `utils/addresses/mapping.ts` (data only)
- **TypeScript API**: `utils/addresses/index.ts` (user-friendly wrapper)

## 🏗️ Contract Categories

### 🪙 **Core Tokens**

**Use these when:** You need to interact with primary tokens in the Katana ecosystem

- **[IAUSD](./tokens/IAUSD.sol)** - Agora USD stablecoin, the primary stable
  asset on Katana. Use for stable value transfers, yield farming base asset, and
  as loan/collateral in DeFi protocols.

- **[IbvUSD](./tokens/IbvUSD.sol)** - Bitvault USD - BTC collateralized stablecoin.

- **[IBTCK](./tokens/IBTCK.sol)** - Bitcoin Katana, wrapped Bitcoin on Katana.
  Use for Bitcoin exposure in DeFi applications.

- **[ILBTC](./tokens/ILBTC.sol)** - Lombard Bitcoin, liquid Bitcoin staking
  token. Use when you want Bitcoin exposure with staking rewards.

- **[IKAT](./tokens/IKAT.sol)** - Katana network token. Use for governance,
  staking, and protocol incentives. Currently non-transferable until ~EOY.
  [More info](https://katana.network/blog/the-network-is-katana-the-token-is-kat).

- **[IPOL](./tokens/IPOL.sol)** - Polygon token on Katana. Use for cross-chain
  Polygon ecosystem interactions.

- **[ISUSHI](./tokens/ISUSHI.sol)** - SushiSwap token on Katana. Use for DEX
  interactions and SushiSwap protocol participation.

- **[IMORPHO](./tokens/IMORPHO.sol)** - Morpho protocol token. Use for Morpho
  governance and protocol incentives.

- **[IYFI](./tokens/IYFI.sol)** - Yearn Finance token. Use for Yearn protocol
  interactions and governance.

- **[IweETH](./tokens/IweETH.sol)** - Wrapped liquid staked Ethereum. Use for
  ETH staking exposure with DeFi composability.

- **[IwstETH](./tokens/IwstETH.sol)** - Wrapped staked ETH from Lido. Use for
  ETH staking rewards while maintaining liquidity.

- **[IJitoSOL](./tokens/IJitoSOL.sol)** - Jito liquid staked Solana. Use for
  Solana staking exposure on Katana.

- **[IuBTC](./tokens/IuBTC.sol)** - Universal Bitcoin token. Use for Bitcoin
  yield strategies.

- **[IuSOL](./tokens/IuSOL.sol)** - Universal Solana token. Use for Solana
  yield strategies.

- **[IuSUI](./tokens/IuSUI.sol)** - Universal Sui token. Use for Sui ecosystem
  exposure.

- **[IuXRP](./tokens/IuXRP.sol)** - Universal XRP token. Use for XRP ecosystem
  interactions.

### 🌉 **Vault Bridge Ecosystem**

**Use these when:** You're building cross-chain applications or working with
bridged assets

#### Bridged Vault Tokens (Destination Chain)

- **[IbvbEth](./vb/tokens/IbvbEth.sol)** - Bridged vault-bridge ETH on
  destination chains. Use when receiving ETH from Ethereum/Sepolia. Also known
  as WETH (same interface).

- **[IbvbUSDC](./vb/tokens/IbvbUSDC.sol)** - Bridged vault-bridge USDC. Use for
  USDC bridged from origin chains to Katana/testnets.

- **[IbvbUSDS](./vb/tokens/IbvbUSDS.sol)** - Bridged vault-bridge USDS. Use for
  USDS cross-chain transfers.

- **[IbvbUSDT](./vb/tokens/IbvbUSDT.sol)** - Bridged vault-bridge USDT. Use for
  Tether transfers between chains.

- **[IbvbWBTC](./vb/tokens/IbvbWBTC.sol)** - Bridged vault-bridge wrapped
  Bitcoin. Use for Bitcoin cross-chain transfers.

#### Base Interfaces

- **[IVaultBridgeToken](./vb/IVaultBridgeToken.sol)** - Base interface for Vault
  Bridge Token contracts. Use as the foundation for all vault bridge token
  implementations.

- **[IBridgedVaultBridgeEth](./vb/IBridgedVaultBridgeEth.sol)** - Interface for
  Bridged Vault Bridge ETH token. Use for bridged ETH functionality on
  destination chains.

- **[IGenericCustomToken](./vb/IGenericCustomToken.sol)** - Base interface for
  generic custom tokens in the vault bridge ecosystem. Use for custom token
  implementations.

- **[INativeConverter](./vb/INativeConverter.sol)** - Base interface for native
  converter contracts. Use as foundation for all converter implementations.

- **[IMigrationManager](./vb/IMigrationManager.sol)** - Migration manager
  interface for handling cross-chain asset migrations. Use for complex migration
  operations.

#### Native Converters

- **[IUSDCNativeConverter](./vb/converters/IUSDCNativeConverter.sol)** -
  Converts between USDC and yield-bearing versions. Use for USDC yield
  optimization strategies.

- **[IUSDSNativeConverter](./vb/converters/IUSDSNativeConverter.sol)** -
  Converts USDS to yield-bearing format. Use for USDS yield generation.

- **[IUSDTNativeConverter](./vb/converters/IUSDTNativeConverter.sol)** -
  Converts USDT for yield strategies. Use for Tether yield optimization.

- **[IWBTCNativeConverter](./vb/converters/IWBTCNativeConverter.sol)** -
  Converts WBTC for yield strategies. Use for Bitcoin yield generation.

- **[IWETHNativeConverter](./vb/converters/IWETHNativeConverter.sol)** -
  Seamless ETH/WETH(bvbEth) conversion. Use for ETH wrapping/unwrapping in
  applications.

### 🏦 **DeFi Lending & Borrowing**

**Use these when:** Building lending protocols, yield strategies, or leveraged positions

#### Morpho Protocol

- **[IMorphoBlue](./morpho/IMorphoBlue.sol)** - Core Morpho lending protocol.
  Use for creating isolated lending markets, supplying assets, borrowing against
  collateral, and liquidations.

- **[IMorphoAdaptiveIRM](./morpho/IMorphoAdaptiveIRM.sol)** - Adaptive interest
  rate model. Use when creating markets that need dynamic rate optimization.

- **[IMetaMorphoFactory](./morpho/IMetaMorphoFactory.sol)** - Factory for
  MetaMorpho vaults. Use to deploy new yield aggregation vaults.

- **[IMetaMorpho](./morpho/IMetaMorpho.sol)** - ERC-4626 yield aggregator
  vaults. Use for automated yield optimization across multiple Morpho markets.

- **[IPublicAllocator](./morpho/IPublicAllocator.sol)** - Permissionless vault
  rebalancing. Use to optimize MetaMorpho vault allocations for fees.

-
  **[IMorphoChainlinkOracleV2Factory](./morpho/IMorphoChainlinkOracleV2Factory.sol)**
  - Oracle factory for Morpho markets. Use to create price oracles for new
  markets.

- **[IMorphoChainlinkOracleV2](./morpho/IMorphoChainlinkOracleV2.sol)** -
  Chainlink-based price oracles. Use for accurate price feeds in lending
  markets.

- **[IPreLiquidationFactory](./morpho/IPreLiquidationFactory.sol)** - Factory
  for pre-liquidation contracts. Use to create early intervention liquidation
  mechanisms.

- **[IPreLiquidation](./morpho/IPreLiquidation.sol)** - Early liquidation
  system. Use to prevent bad debt by liquidating risky positions before they
  become underwater.

#### Yearn Protocol

- **[IYvAUSD](./yearn/IYvAUSD.sol)** - Yearn AUSD vault for automated yield
  generation. Use to earn yield on AUSD deposits.

- **[IYvWETH](./yearn/IYvWETH.sol)** - Yearn WETH vault for ETH yield
  strategies. Use to earn yield on ETH holdings.

### 🔄 **DEX & Trading**

**Use these when:** Building trading interfaces, implementing swaps, or managing
liquidity

- **[ISushiRouter](./ISushiRouter.sol)** - SushiSwap router for token swaps. Use
  for efficient token exchanges with minimal slippage.

- **[ISushiV3Factory](./ISushiV3Factory.sol)** - SushiSwap V3 factory contract.
  Use to create new trading pairs and manage pool deployments.

- **[ISushiV3PositionManager](./ISushiV3PositionManager.sol)** - Manages
  SushiSwap V3 liquidity positions. Use for sophisticated liquidity provision
  strategies.

### 🖼️ **NFTs & Marketplaces**

**Use these when:** Building NFT applications, marketplaces, or trading platforms

- **[ISeaport](./opensea/ISeaport.sol)** - OpenSea's advanced marketplace
  protocol. Use for comprehensive NFT trading with complex order types, bulk
  operations, and criteria-based orders.

- **[IConduitController](./opensea/IConduitController.sol)** - Manages Seaport
  conduits for secure transfers. Use to create secure transfer pathways for
  marketplaces.

- **[IConduit](./opensea/IConduit.sol)** - Efficient token transfer system. Use
  for gas-optimized batch transfers in NFT marketplaces.

- **[ICatalogFactory](./nft/ICatalogFactory.sol)** - Factory for NFT catalog
  contracts. Use to deploy new ERC6220 NFT collections with standardized
  features.

- **[ICatalogUtils](./nft/ICatalogUtils.sol)** - Utilities for NFT ERC6220
  catalog management. Use for metadata and collection management tools.

- **[IRenderUtils](./nft/IRenderUtils.sol)** - NFT rendering utilities. Use for
  dynamic NFT metadata and image generation.

- **[ITokenAttributesRepository](./nft/ITokenAttributesRepository.sol)** -
  Repository for NFT attributes. Use for modular NFT trait systems.

- **[IBulkWriter](./nft/IBulkWriter.sol)** - Bulk operations for NFT attributes.
  Use for efficient batch updates of NFT metadata.

### 🔐 **Security & Multisig**

**Use these when:** Implementing secure transaction patterns or multisig functionality

- **[IGnosisSafe](./IGnosisSafe.sol)** - Industry-standard multisig wallet. Use
  for secure multi-party asset management and governance.

- **[IGnosisSafeL2](./IGnosisSafeL2.sol)** - L2-optimized Gnosis Safe with
  enhanced event logging. Use for gas-efficient multisig operations.

- **[IMultiSend](./IMultiSend.sol)** - Batch transaction execution with call and
  delegatecall support. Use for complex multi-step operations.

- **[IMultiSendCallOnly](./IMultiSendCallOnly.sol)** - Safer batch execution
  (call only). Use when you need transaction batching without delegatecall
  risks.

- **[ISafeExecutor](./ISafeExecutor.sol)** - Safe execution patterns. Use for
  secure contract interactions with built-in safety checks.

### 🚀 **Contract Deployment**

**Use these when:** Deploying contracts, especially with deterministic addresses

- **[ICreateX](./ICreateX.sol)** - Comprehensive deployment factory supporting
  CREATE, CREATE2, and CREATE3. Use for advanced deployment patterns,
  cross-chain address consistency, and proxy deployments.

- **[ICreate2Deployer](./ICreate2Deployer.sol)** - CREATE2 deployer with safety
  features. Use for deterministic deployments with additional security.

- **[IDeterministicDeploymentProxy](./IDeterministicDeploymentProxy.sol)** -
  Arachnid's standard proxy for same-address deployments across chains. Use for
  basic cross-chain contract deployment.

### 🌐 **Cross-chain Infrastructure**

**Use these when:** Building cross-chain applications or bridges

- **[IBridgeL2SovereignChain](./agglayer/IBridgeL2SovereignChain.sol)** - Bridge
  for cross-chain asset and message transfers. Use for secure inter-chain
  communication.

-
  **[IGlobalExitRootManagerL2SovereignChain](./agglayer/IGlobalExitRootManagerL2SovereignChain.sol)**
  - Manages exit roots for secure withdrawals. Use for cross-chain withdrawal
  verification.

- **[IPolygonZkEVMDeployer](./agglayer/IPolygonZkEVMDeployer.sol)** - Interface
  for the PolygonZkEVMDeployer contract which manages deployments of rollup
  components.

- **[IPolygonZkEVMTimelock](./agglayer/IPolygonZkEVMTimelock.sol)** - Governance
  timelock for administrative actions. Use for secure governance operations.

- **[IProxyAdmin](./agglayer/IProxyAdmin.sol)** - Manages transparent proxy
  upgrades. Use for controlled infrastructure upgrades.

- **[IBridgeExtension](./agglayer/IBridgeExtension.sol)** - Extended bridge
  functionality. Use for advanced cross-chain operations with Agglayer / LXLY
  bridging.

- **[ILxLyBridge](./ILxLyBridge.sol)** - Layer X to Layer Y bridge interface.
  Use for cross-chain asset transfers between different layers.

### 🧮 **Utilities & Helpers**

**Use these when:** You need common utility functions or gas optimizations

- **[IMulticall3](./IMulticall3.sol)** - Batch multiple read-only calls in a
  single transaction. Use to reduce RPC calls and improve dApp performance.

- **[IBundler3](./IBundler3.sol)** - Advanced multicall with reentrant callback
  support. Use for complex multi-contract interactions.

- **[IBatchDistributor](./IBatchDistributor.sol)** - Efficient bulk token
  distribution. Use for airdrops, payroll, and reward distribution.

- **[IPermit2](./IPermit2.sol)** - Advanced token approval system with
  signatures and batch operations. Use for better UX in token transfers.

- **[IRIP7212](./IRIP7212.sol)** - secp256r1 signature verification precompile.
  Use for biometric authentication and secure enclave integration.

- **[IAgoraFaucet](./IAgoraFaucet.sol)** - Testnet faucet for obtaining AUSD
  test tokens. Use for testnet development and testing.

### 📊 **Price Oracles**

**Use these when:** You need reliable price data for DeFi applications

#### Chainlink Oracles

- **[IAggregatorV3Interface](./oracles/chainlink/IAggregatorV3Interface.sol)** -
  Base Chainlink aggregator interface
- **[IEACAggregatorProxy](./oracles/chainlink/IEACAggregatorProxy.sol)** -
  Chainlink aggregator proxy interface
- **[IAUSDUSDOracle](./oracles/chainlink/IAUSDUSDOracle.sol)** - AUSD/USD price
  feed
- **[IBTCUSDOracle](./oracles/chainlink/IBTCUSDOracle.sol)** - Bitcoin/USD price
  feed
- **[IETHUSDOracle](./oracles/chainlink/IETHUSDOracle.sol)** - Ethereum/USD
  price feed
- **[IJitoSOLSOLOracle](./oracles/chainlink/IJitoSOLSOLOracle.sol)** -
  JitoSOL/SOL price feed
- **[IJitoSOLUSDOracle](./oracles/chainlink/IJitoSOLUSDOracle.sol)** -
  JitoSOL/USD price feed
- **[ILBTCBTCOracle](./oracles/chainlink/ILBTCBTCOracle.sol)** - Lombard BTC/BTC
  price feed
- **[ILBTCUSDOracle](./oracles/chainlink/ILBTCUSDOracle.sol)** - Lombard BTC/USD
  price feed
- **[ILINKUSDOracle](./oracles/chainlink/ILINKUSDOracle.sol)** - LINK/USD price
  feed
- **[IMORPHOUSDOracle](./oracles/chainlink/IMORPHOUSDOracle.sol)** - MORPHO/USD
  price feed
- **[IPOLUSDOracle](./oracles/chainlink/IPOLUSDOracle.sol)** - POL/USD price
  feed
- **[ISOLUSDOracle](./oracles/chainlink/ISOLUSDOracle.sol)** - SOL/USD price
  feed
- **[ISUSHIUSDOracle](./oracles/chainlink/ISUSHIUSDOracle.sol)** - SUSHI/USD
  price feed
- **[IUSDCUSDOracle](./oracles/chainlink/IUSDCUSDOracle.sol)** - USDC/USD price
  feed
- **[IUSDSUSDOracle](./oracles/chainlink/IUSDSUSDOracle.sol)** - USDS/USD price
  feed
- **[IUSDTUSDOracle](./oracles/chainlink/IUSDTUSDOracle.sol)** - USDT/USD price
  feed
- **[IWBTCBTCOracle](./oracles/chainlink/IWBTCBTCOracle.sol)** - WBTC/BTC price
  feed
- **[IWBTCUSDOracle](./oracles/chainlink/IWBTCUSDOracle.sol)** - WBTC/USD price
  feed
- **[IweETHETHOracle](./oracles/chainlink/IweETHETHOracle.sol)** - weETH/ETH
  price feed
- **[IwstETHETHOracle](./oracles/chainlink/IwstETHETHOracle.sol)** - wstETH/ETH
  price feed
- **[IYFIUSDOracle](./oracles/chainlink/IYFIUSDOracle.sol)** - YFI/USD price
  feed
- **[IyUSDUSDOracle](./oracles/chainlink/IyUSDUSDOracle.sol)** - yUSD/USD price
  feed

#### RedStone Oracles

- **[IRedstoneAggregator](./oracles/redstone/IRedstoneAggregator.sol)** - Base
  RedStone aggregator interface
- **[IADAUSDOracle](./oracles/redstone/IADAUSDOracle.sol)** - Cardano/USD price
  feed
- **[IAUSDUSDOracle](./oracles/redstone/IAUSDUSDOracle.sol)** - AUSD/USD price
  feed (RedStone)
- **[IBTCUSDOracle](./oracles/redstone/IBTCUSDOracle.sol)** - Bitcoin/USD price
  feed (RedStone)
- **[IETHUSDOracle](./oracles/redstone/IETHUSDOracle.sol)** - Ethereum/USD price
  feed (RedStone)
- **[ILBTCBTCOracle](./oracles/redstone/ILBTCBTCOracle.sol)** - Lombard BTC/BTC
  price feed (RedStone)
- **[ISUIUSDOracle](./oracles/redstone/ISUIUSDOracle.sol)** - Sui/USD price feed
- **[IWBTCUSDOracle](./oracles/redstone/IWBTCUSDOracle.sol)** - WBTC/USD price
  feed (RedStone)
- **[IweETHETHOracle](./oracles/redstone/IweETHETHOracle.sol)** - weETH/ETH
  price feed (RedStone)
- **[IweETHUSDOracle](./oracles/redstone/IweETHUSDOracle.sol)** - weETH/USD
  price feed (RedStone)
- **[IwstETHstETHOracle](./oracles/redstone/IwstETHstETHOracle.sol)** -
  wstETH/stETH price feed (RedStone)
- **[IwstETHUSDOracle](./oracles/redstone/IwstETHUSDOracle.sol)** - wstETH/USD
  price feed (RedStone)
- **[IXRPUSDOracle](./oracles/redstone/IXRPUSDOracle.sol)** - XRP/USD price feed

### ⚡ **Account Abstraction (ERC-4337)**

**Use these when:** Building smart account systems or account abstraction features

#### Common Components

- **[IERC4337](./IERC4337.sol)** - Common interfaces and structures used across
  both v0.6.0 and v0.7.0 of the ERC-4337 standard, including IStakeManager and
  INonceManager.

#### v0.6.0 Implementation

- **[IEntryPoint](./AAv0.6.0/IEntryPoint.sol)** - Core entry point for user
  operations
- **[IERC4337Account](./AAv0.6.0/IERC4337Account.sol)** - Smart account
  interface
- **[ISenderCreator](./AAv0.6.0/ISenderCreator.sol)** - Helper for account
  creation

#### v0.7.0 Implementation

- **[IEntryPoint](./AAv0.7.0/IEntryPoint.sol)** - Updated entry point with
  latest features
- **[IEntryPointSimulations](./AAv0.7.0/IEntryPointSimulations.sol)** -
  Simulation capabilities for v0.7.0
- **[IERC4337Account](./AAv0.7.0/IERC4337Account.sol)** - Updated account
  interface with PackedUserOperation
- **[ISenderCreator](./AAv0.7.0/ISenderCreator.sol)** - v0.7.0 account creation
  helper

### 📜 **Legacy & Compatibility**

**Use these when:** Working with legacy systems or needing backward compatibility

- **[Multicall](./MultiCall1.sol)** - Original multicall implementation
- **[Multicall2](./MultiCall2.sol)** - Enhanced multicall with failure handling
- **[IERC20](./IERC20.sol)** - Standard ERC-20 token interface
- **[IERC4626](./IERC4626.sol)** - Tokenized vault standard interface

## 🔧 How to Use These Interfaces

### 1. **Import the Interface**

```solidity
import "./contracts/tokens/IAUSD.sol";
import "./contracts/utils/KatanaAddresses.sol";
```

### 2. **Get the Contract Address**

```solidity
address ausdAddress = KatanaAddresses.getAUSDAddress();
```

### 3. **Create Contract Instance**

```solidity
IAUSD ausd = IAUSD(ausdAddress);
```

### 4. **Interact with the Contract**

```solidity
uint256 balance = ausd.balanceOf(msg.sender);
ausd.transfer(recipient, amount);
```

## 🔄 Origin Chain Addresses

For cross-chain operations, some contracts exist on **origin chains**
(Ethereum/Sepolia) while being used in the context of **destination chains**
(Katana/Bokuto/Tatara):

```solidity
// Access origin chain addresses from destination chain context
import "./contracts/utils/KatanaOriginAddresses.sol";

contract VaultBridgeIntegration {
    function bridgeUSDC() external {
        // Get the origin USDC vault address (on Ethereum)  
        address originVault = KatanaOriginAddresses.getvbUSDCAddress();
        
        // Get the destination bridged token (on Katana)
        address bridgedToken = KatanaAddresses.getbvbUSDCAddress();
    }
}
```

**Chain Context Mapping:**

- **Katana context** → Origin addresses from **Ethereum**
- **Bokuto/Tatara context** → Origin addresses from **Sepolia**

## 🏗️ Examples

Check out the `/examples` folder in the root repository for complete examples
showing how to:

- Build lending interfaces with Morpho
- Create DEX trading bots with SushiSwap  
- Implement NFT marketplaces with Seaport
- Build cross-chain applications with Vault Bridge
- Create yield strategies with Yearn and MetaMorpho

## 🔄 Keeping Addresses Updated

Contract addresses are automatically extracted from the `@custom:network`
doccomments in each interface file. To add a new contract:

1. Create the interface file with proper `@custom:tatara`, `@custom:katana`,
   `@custom:bokuto` tags
2. Run `bun run build:addressutils` to regenerate address utilities
3. Use the new contract in your applications via the address management system

This ensures your addresses stay synchronized across Solidity libraries,
TypeScript utilities, and documentation.
