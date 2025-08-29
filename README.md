# Katana Development Starter Kit

![Box of legos](leo.jpg)

## 🚀 Introduction

Welcome to the **Katana Development Starter Kit**! This repository serves as
your launchpad for building on **Katana** and its testnets **Tatara** and **Bokuto**.

This kit provides:

- **Bun-based development environment** 🧅
- **Anvil + Foundry integration** for reliable local chain forks
- **Pre-configured build system** using Esbuild & TypeScript
- **[UI-kit CSS](https://getuikit.com/)**, optional to use
- **[viem](https://viem.sh/)** for blockchain interactions
- **Example contracts** to help you integrate with **Katana's money legos** and
  interfaces for all deployed contracts on Katana and testnets
- **Foundry setup** for smart contract development and testing
- **Static File Handling** (HTML, CSS, and assets copied to `dist/`, easy to
  host on IPFS or any static file hosting service)
- **Contract address mapping generator** for easy access to deployed contract
  addresses in JavaScript, including origin chain addresses for cross-chain operations
- **Foundry MCP Server** for AI-assisted smart contract development
- Script to generate a single file contract directory with all the ABIs,
  contract names, paths, descriptions, addresses, and context they belong to,
  for directory browsers like the [contract dir](https://contracts.katana.tools)

Whether you're building yield strategies, cross-chain intent-based execution,
or novel DeFi protocols**, this starter kit helps you bootstrap your project
**fast**.

- [Documentation](https://docs.katana.network/)
- [More about contract interfaces](/interfaces/README.md)
- [More about running Katana locally for development](/scripts/README.md)

## Chain information

### Katana

| Property                        | Value                                         |
|----------------------------------|-----------------------------------------------|
| **Chain Name**                   | Katana                                        |
| **Chain ID**                     | `747474`                                      |
| **Public RPC URL**               | [https://rpc.katana.network/](https://rpc.katana.network/) |
| **Gas Token**                    | ETH                                           |
| **Block Explorer**               | [https://katanascan.com/](https://katanascan.com/) |
| **Block Time**                   | 1 second                                      |
| **Block Gas Limit**              | 60M units                                     |
| **Block Gas Target**             | 30M units                                     |
| **Gas Pricing**                  | EIP1559                                       |
| **EIP-1559 Elasticity Multiplier** | 60                                          |
| **EIP-1559 Denominator**         | 250                                           |
| **Data Availability**            | EIP4844                                       |
| **Account Abstraction**          | EIP7702                                       |

---

### Bokuto

| Property         | Value                                              |
|------------------|----------------------------------------------------|
| **Chain Name**   | Bokuto                                             |
| **Chain ID**     | `737373`                                           |
| **RPC URL**      | [https://rpc-bokuto.katanarpc.com](https://rpc-bokuto.katanarpc.com) |
| **Block Explorer**      | [https://explorer-bokuto.katanarpc.com/](https://explorer-bokuto.katanarpc.com/) |
| **Gas Token**           | ETH                                                                   |
| **Block Time**          | 1 second                                                              |
| **Gas Block Limit**     | 60M units                                                             |
| **Gas Pricing**         | EIP1559                                                               |
| **Data Availability**   | EIP4844                                                               |

---

### Tatara

| Property                | Value                                                                 |
|-------------------------|-----------------------------------------------------------------------|
| **Network Name**        | Tatara Network (aka Katana Testnet)                                   |
| **Chain ID**            | `129399`                                                              |
| **RPC URL**             | `https://rpc.tatara.katanarpc.com/<apikey>`                           |
| **Block Explorer**      | [https://explorer.tatara.katana.network/](https://explorer.tatara.katana.network/) |
| **Vault Bridge Faucet** | [https://faucet-api.polygon.technology/api-docs/](https://faucet-api.polygon.technology/api-docs/) |
| **Bridge UI**           | [https://portal-staging.polygon.technology/bridge](https://portal-staging.polygon.technology/bridge) |
| **Gas Token**           | ETH                                                                   |
| **Block Time**          | 1 second                                                              |
| **Gas Block Limit**     | 60M units                                                             |
| **Gas Pricing**         | EIP1559                                                               |
| **Data Availability**   | EIP4844                                                               |

---

## 🛠 Setup & Installation

### 1️⃣ **Install Dependencies**

Copy `.env.example` into `.env` and add in your RPC endpoints if you want to
change them (recommended: to prevent rate limiting).

Ensure you have the required tools installed:

- [Bun](https://bun.sh/) - Follow the installation instructions at <https://bun.sh/>
- [Foundry](https://book.getfoundry.sh/) for contract development and local
  chain forks
- [Git](https://git-scm.com/)

After installing Bun, run:

```sh
# Install project dependencies
bun install
```

### 2️⃣ **Run the Build System**

This project uses **Bun** as its runtime and **Esbuild** for bundling. To build
your project, run:

```sh
bun run build:all
```

This will:

- Compile and minify the example TypeScript code
- Copy HTML & static assets to `./dist`
- Prepare the environment for deployment
- Compile helper utilities like an address-to-contract mapping in
  `utils/addresses` and interface ABIs in the `/abis` folder as well as address
  lookup Solidity contracts in `contracts/utils`. This includes both regular
  destination chain addresses and origin chain addresses for cross-chain operations.
- Build the Foundry MCP server for AI-assisted development

🚨 Note: Going forward, you can just rebuild the web app using `bun run build`.

### 3️⃣ **Local Chain Forking**

#### Environment Setup

Create a `.env` file by copying `.env.example`. If you want non-rate-limited
access, replace the RPC endpoints there with your own, otherwise, use the
defaults.

```bash
# Copy and customize based on your available RPC endpoints
TATARA_RPC_URL=https://rpc.tatara.katanarpc.com
KATANA_RPC_URL=https://rpc.katana.network/
BOKUTO_RPC_URL=https://rpc-bokuto.katanarpc.com
```

#### Terminal 1: Start Anvil Fork

```sh
# Fork Tatara testnet
bun run start:anvil tatara

# Or fork Bokuto testnet
bun run start:anvil bokuto

# Or fork Katana mainnet
bun run start:anvil katana
```

#### Terminal 2: Verify the Fork

To check if all is well, you can run the following command in another terminal.

```sh
bun run verify:anvil
```

This will automatically detect which chain you're forking and verify that
contracts are accessible. It will test key contracts (like AUSD, WETH,
MorphoBlue) if available on the forked chain and show connection details for
your wallet.

See [scripts/README.md](scripts/README.md) for more details.

### 4️⃣ **Example dApp**

The starter kit includes a simple example dApp that automatically detects and
connects to any of the supported local chain forks (Tatara, Katana, or Bokuto)
and displays information about key contracts available on that chain.

To run the example:

1. Start your local chain fork (in its own terminal):

   ```sh
   # Fork any supported chain
   bun run start:anvil tatara   # or bokuto/katana
   ```

2. In a new terminal, build the dApp:

   ```sh
   bun run build
   ```

3. Start **frontend app**
   `bun run dev`

   This starts the frontend dapp here `http://localhost:8080`

The example dApp automatically:

- **Detects the running chain** by reading the chain ID from your local fork
- **Loads the appropriate contracts** using the dynamic address system
  (including origin chain addresses)
- **Shows available contract information** (AUSD, WETH, MorphoBlue) if deployed
  on that chain
- **Displays helpful messages** if contracts aren't available on the selected chain

The app gracefully handles different chains and will show which contracts are
available on each network. You can use this as a starting point for your own
multi-chain dApp development.

### 5️⃣ **Using the Foundry MCP Server**

The kit includes a Foundry MCP (Model Context Protocol) server that enables
AI-assisted smart contract and app development when used with compatible AI
tools like Cursor.

To use the MCP server:

1. Configure e.g. Cursor to use the MCP server by adding the following to your Cursor
   config in `.cursor/mcp.json`:

   ```json
   "mcpServers": {
     "foundry": {
       "command": "bun run",
       "args": [
         "/absolute_path_to_starter_kit/dist-mcp/index.js"
       ],
       "env": {
         "PRIVATE_KEY": "0xYourPrivateKeyHere",
         "RPC_URL": "http://localhost:8545"
       }
     }
   }
   ```

   Replace `/absolute_path_to_starter_kit/` with absolute path to your clone of
   the starter kit.

2. Launch the local chain with `bun run start:anvil tatara` (or `bokuto`/`katana`).

3. The `PRIVATE_KEY` and `RPC_URL` environment variables are optional. If not
   provided, the RPC URL will default to `http://localhost:8545`.

4. After configuring, you can use the AI in Cursor to interact with Foundry
   tools, including:
   - Calling contract functions
   - Checking balances
   - Starting/stopping Anvil instances
   - Creating and deploying smart contracts
   - Working with Katana-specific contracts

The MCP server provides a seamless interface between AI tools and Foundry's
blockchain development toolkit, making it easier to build and interact with
contracts on Katana.

### 6️⃣ **Foundry commands (run from repo root)**

The following convenience commands are available via Bun scripts in
`package.json` and run from the repository root:

- **forge:deps**: Set up Foundry dependencies (clones `forge-std` if missing)

  ```sh
  bun run forge:deps
  ```

  You don't need to generally run this ever - it's automatic during `build:all`.

- **forge:build**: Build the contracts in the `forge/` workspace

  ```sh
  bun run forge:build
  ```

  Compiles your contracts, creating deployable artifacts.

- **forge:test**: Run the Foundry test suite in the `forge/` workspace

  ```sh
  bun run forge:test
  ```

- **forge:deploy**: Deploy a Foundry script target using a wrapper around `forge script`

  Defaults if not provided:

- **RPC URL**: `http://localhost:8545`
- **Private key**: `0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80` (unlocked Anvil demo account)

  Chain-aware usage (the `@script/` prefix is optional):

  ```sh
  # Local anvil (uses defaults shown above)
  bun run forge:deploy -- @script/DaikatanaPayments.s.sol:DaikatanaPaymentsScript --chain local

  # Katana mainnet (reads KATANA_RPC_URL and KATANA_DEPLOYER_KEY from .env)
  bun run forge:deploy -- @script/DaikatanaPayments.s.sol:DaikatanaPaymentsScript --chain katana

  # Tatara/Bokuto testnets
  bun run forge:deploy -- @script/Counter.s.sol:CounterScript --chain tatara
  bun run forge:deploy -- @script/Counter.s.sol:CounterScript --chain bokuto

  # Override only the private key while keeping chain RPC from .env
  bun run forge:deploy -- @script/DaikatanaPayments.s.sol:DaikatanaPaymentsScript \
    --chain katana \
    --private-key 0xYOUR_PRIVATE_KEY

  # Override both explicitly (bypasses .env values for the chain)
  bun run forge:deploy -- @script/Counter.s.sol:CounterScript \
    --rpc-url https://your.rpc/ \
    --private-key 0xYOUR_PRIVATE_KEY
  ```

  Notes:

- The wrapper auto-adds `--broadcast` unless you already provided it.
- Extra flags are forwarded to `forge script` as-is.
- Script path is normalized to `forge/script/...` under the `forge/` workspace.
- When using `--sig`, put it after a literal `--` and quote the signature to avoid shell parsing:

    ```sh
    bun run forge:deploy -- @script/DaikatanaPayments.s.sol:DaikatanaPaymentsScript \
      --chain local \
      --sig 'run(uint256,uint256,bool)' 5000000000000000 100 true
    ```

#### Verifying contracts programmatically

To verify a Katana-deployed contract via the unified Etherscan API key, install
nightly
[per their guide](https://docs.etherscan.io/etherscan-v2/contract-verification/verify-with-foundry).

Then:

```bash
cd forge
forge verify-contract --watch --root . --chain katana \
  {ADDRESS} \
  src/{CONTRACTFILE.sol}:{CONTRACTNAME} \
  --verifier etherscan \
  --etherscan-api-key {APIKEY} \
  --optimizer-runs 200
```

Obtain the etherscan key [in the API dash](https://etherscan.io/apidashboard).

### 7️⃣ **Contract Address Mapping**

The kit includes a utility to generate a JavaScript mapping of all contract
addresses for Tatara testnet, Katana mainnet, and Bokuto testnet. This
makes it easy to access contract addresses in your frontend code without
hardcoding them. The system also handles **origin chain addresses** for
cross-chain operations like Vault Bridge.

To generate the address mapping:

```sh
bun run build:addressutils
```

This will create files in `utils/addresses/` and `contracts/utils/`:

**TypeScript Files:**

- `mapping.ts` - Auto-generated mapping of contract addresses (do not edit)
- `index.ts` - User-friendly API wrapper with chain context management

**Solidity Files:**

- `[Chain]Addresses.sol` - Contract address libraries for each chain
- `[Chain]OriginAddresses.sol` - Origin chain address libraries for cross-chain operations

### Usage

The improved API provides a cleaner interface with automatic "I" prefix handling:

```javascript
import { addresses, CHAINS } from '../utils/addresses';

// Set the chain context (by name or ID)
addresses.setChain('tatara');
// or
addresses.setChain(CHAINS.tatara);

// Get contract addresses - automatically handles I prefix
const wethAddress = addresses.getAddress('WETH');      // Finds IWETH
const morphoAddress = addresses.getAddress('MorphoBlue'); // Finds IMorphoBlue
const ausdAddress = addresses.getAddress('AUSD');      // Finds IAUSD

// Check if a contract exists
if (addresses.hasContract('Permit2')) {
  const permit2 = addresses.getAddress('Permit2');
}

// Get all available contracts on current chain
const allContracts = addresses.getAllContracts();

// Get address for a specific chain without changing context
const wethOnKatana = addresses.getAddressForChain('WETH', 'katana');
```

### Origin Chain Addresses

For cross-chain operations (like Vault Bridge), you often need addresses from
the **origin chain** (Ethereum/Sepolia) while operating in a **destination
chain** context (Katana/Bokuto/Tatara). The address system handles this
automatically:

```javascript
import { addresses } from '../utils/addresses';

// Set context to Katana (destination chain)
addresses.setChain('katana');

// Get destination chain contracts (deployed on Katana)
const bridgedUSDC = addresses.getAddress('bvbUSDC');
// Returns: 0x203A662b0BD271A6ed5a60EdFbd04bFce608FD36

// Get origin chain contracts (deployed on Ethereum, accessed from Katana context)
const vaultUSDC = addresses.getOriginAddress('vbUSDC');
// Returns: 0x53E82ABbb12638F09d9e624578ccB666217a765e

const migrationManager = addresses.getOriginAddress('MigrationManager');
// Returns: 0x417d01B64Ea30C4E163873f3a1f77b727c689e02

// Check what origin contracts are available
const originContracts = addresses.getAllOriginContracts();
// Returns: ["IMigrationManager", "IvbETH", "IvbUSDC", "IvbUSDS", "IvbUSDT", "IvbWBTC"]
```

**Chain Context Mapping:**

- **Katana context** → Origin addresses from **Ethereum**
- **Bokuto context** → Origin addresses from **Sepolia**
- **Tatara context** → Origin addresses from **Sepolia**

### Features

- **Automatic I-prefix handling**: Try `WETH` and it will find `IWETH`
- **Chain context management**: Set once, use everywhere
- **Origin chain support**: Access origin chain addresses for cross-chain operations
- **Context-aware addressing**: Katana context → Ethereum origins, Bokuto/Tatara
  → Sepolia origins
- **Better error messages**: Shows available contracts when not found
- **Type-safe**: Full TypeScript support with address types
- **Dual address types**: Regular (destination) and origin addresses in one API

The address mapping is generated from the `@custom:tatara`, `@custom:katana`, and
`@custom:bokuto` doccomments in the contract files.

---

## 🔗 Smart Contract Development

See [interfaces](interfaces).

## 🛠 Contributing

We welcome contributions! If you'd like to improve the Katana Starter Kit, fork
the repo and submit a PR.

---

3️⃣ Deploy and interact with Katana's **DeFi money legos**

🚀 **Happy Building!**
