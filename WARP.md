# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is the **Katana Development Starter Kit**, a comprehensive development environment for building on Katana blockchain and its testnets (Tatara and Bokuto). The kit provides a complete stack for DeFi protocol development including smart contracts, frontend applications, and blockchain interaction utilities.

### Key Networks
- **Katana Mainnet**: Chain ID 747474, RPC: https://rpc.katana.network/
- **Tatara Testnet**: Chain ID 129399, RPC: https://rpc.tatara.katanarpc.com
- **Bokuto Testnet**: Chain ID 737373, RPC: https://rpc-bokuto.katanarpc.com

## Essential Commands

### Initial Setup
```bash
# Install dependencies
bun install

# Copy environment file and configure RPC endpoints
cp .env.example .env

# Build everything (run once after cloning)
bun run build:all
```

### Development Workflow
```bash
# Start local chain fork (choose one)
bun run start:anvil tatara    # Fork Tatara testnet
bun run start:anvil katana    # Fork Katana mainnet  
bun run start:anvil bokuto    # Fork Bokuto testnet

# Verify fork is working (in another terminal)
bun run verify:anvil

# Build frontend application
bun run build

# Start development server
bun run dev    # Serves at http://localhost:8080
```

### Foundry Smart Contract Development
```bash
# Build contracts
bun run forge:build

# Run tests
bun run forge:test

# Deploy contracts (supports chain-aware deployment)
bun run forge:deploy -- @script/Counter.s.sol:CounterScript --chain local
bun run forge:deploy -- @script/Counter.s.sol:CounterScript --chain tatara
bun run forge:deploy -- @script/Counter.s.sol:CounterScript --chain katana

# Set up Foundry dependencies (automatic during build:all)
bun run forge:deps
```

### Address and ABI Management
```bash
# Generate contract address mappings from doccomments
bun run build:addressutils

# Generate ABI files from contract interfaces
bun run build:abi

# Generate contract directory for tooling/documentation
bun run build:contractdir
```

### MCP Server for AI Development
```bash
# Build MCP server for AI-assisted development
bun run build:mcpserver

# Start MCP server (for use with Cursor/other AI tools)
bun run start:mcp
```

## Architecture Overview

### Multi-Chain Address System
The project features a sophisticated address management system that handles both destination chain contracts and origin chain addresses for cross-chain operations:

- **Destination Addresses**: Contracts deployed on Katana/Tatara/Bokuto
- **Origin Addresses**: Contracts on Ethereum/Sepolia used for Vault Bridge operations
- **Dynamic Resolution**: Automatically handles 'I' prefix for interfaces (e.g., `WETH` → `IWETH`)

Key files:
- `utils/addresses/index.ts` - Main address management API
- `utils/addresses/mapping.ts` - Auto-generated address mappings
- `contracts/utils/` - Solidity address libraries for each chain

### Contract Interface System
All contract interfaces are stored in the `contracts/` directory with doccomments specifying deployment addresses:

```solidity
/**
 * @custom:tatara 0x1234567890123456789012345678901234567890
 * @custom:katana 0x2345678901234567890123456789012345678901
 * @custom:bokuto sepolia:0x3456789012345678901234567890123456789012
 */
interface IAUSD {
    // Interface definition
}
```

### Foundry Integration
- Workspace: `forge/` directory
- Scripts: `forge/script/` for deployment scripts
- Tests: `forge/test/` for contract tests
- Source: `forge/src/` for contract implementations
- Chain-aware deployment wrapper: `scripts/forge-deploy.sh`

### Frontend Application
- Built with TypeScript, Viem, and UIKit CSS
- Automatically detects running chain fork
- Displays contract information for available networks
- Demonstrates multi-chain address resolution

### MCP Server
Provides AI-assisted development through Foundry MCP server at `utils/mcp-server/index.ts`:
- Cast operations (call, send, balance, logs, etc.)
- Anvil management (start, stop, status)
- Contract interaction by name instead of address
- Automatic address lookup and function signature resolution

## Development Patterns

### Working with Addresses
```typescript
import { addresses, CHAINS } from '../utils/addresses';

// Set chain context
addresses.setChain('tatara');

// Get contract addresses (automatic I-prefix handling)
const wethAddress = addresses.getAddress('WETH');      // Finds IWETH
const ausdAddress = addresses.getAddress('AUSD');      // Finds IAUSD

// Origin chain addresses (for Vault Bridge)
const originUSDC = addresses.getOriginAddress('vbUSDC'); // Ethereum address from Katana context
```

### Chain Fork Development
1. Always start with a local fork: `bun run start:anvil <network>`
2. Verify connection: `bun run verify:anvil`
3. The fork runs on `http://localhost:8545` with 12-second block time
4. Example dApp automatically detects the running fork

### Contract Deployment
Use the chain-aware deployment wrapper:
```bash
# Local deployment (uses default anvil account)
bun run forge:deploy -- @script/MyScript.s.sol:MyScript --chain local

# Testnet deployment (reads from .env)
bun run forge:deploy -- @script/MyScript.s.sol:MyScript --chain tatara
```

### Adding New Contracts
1. Add interface to `contracts/` with `@custom:network address` doccomments
2. Run `bun run build:addressutils` to update address mappings
3. Run `bun run build:abi` to generate ABI files
4. The address system will automatically pick up new contracts

## Environment Configuration

### Required Environment Variables (.env)
```bash
# RPC endpoints (customize to avoid rate limiting)
TATARA_RPC_URL=https://rpc.tatara.katanarpc.com
KATANA_RPC_URL=https://rpc.katana.network/
BOKUTO_RPC_URL=https://rpc-bokuto.katanarpc.com

# Deployment keys (set for live deployments)
TATARA_DEPLOYER_KEY=0x...
KATANA_DEPLOYER_KEY=0x...
BOKUTO_DEPLOYER_KEY=0x...
LOCAL_DEPLOYER_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### MCP Server Configuration
For AI-assisted development with Cursor, add to `.cursor/mcp.json`:
```json
{
  "mcpServers": {
    "foundry": {
      "command": "bun",
      "args": ["/absolute/path/to/specialk/dist-mcp/index.js"],
      "env": {
        "PRIVATE_KEY": "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
        "RPC_URL": "http://localhost:8545"
      }
    }
  }
}
```

## Important Notes

- **Always use chain forks for development**: Start anvil fork before running the dApp
- **Address system is dynamic**: No need to hardcode addresses, use the address management system
- **Origin vs Destination**: Understand the difference between origin chain addresses (Ethereum/Sepolia) and destination chain addresses (Katana/Tatara/Bokuto)
- **Build order matters**: Run `build:addressutils` before other build steps when adding new contracts
- **MCP server requires absolute paths**: Use full paths in MCP configuration files

## Txtx Integration

The project includes txtx runbooks in `runbooks/` for infrastructure-as-code blockchain operations. Use `txtx ls` to see available runbooks and `txtx run <runbook-id>` to execute them.
