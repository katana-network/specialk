# YvAUSD Vault Frontend

A simple, clean interface for interacting with the Yearn AUSD vault on Tatara testnet.

## Features

- 🔗 **Wallet Connection**: MetaMask integration via ConnectKit
- 💰 **Vault Operations**: Approve, Deposit, and Withdraw AUSD
- 📊 **Real-time Data**: View balances, allowances, and vault stats
- 🎨 **Clean UI**: Light theme with subtle design
- 📱 **Responsive**: Works on desktop and mobile

## Quick Setup

### 1. Prerequisites

- Node.js 16+ installed
- MetaMask browser extension
- Access to Tatara testnet

### 2. Installation

```bash
cd examples/ausd-yearnvault

# Install required packages
bun install --legacy-peer-deps
```

### 3. Environment Setup

Create a `.env` file in your project root:

```env
REACT_APP_WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id_here
```

**Get WalletConnect Project ID:**
1. Visit [WalletConnect Cloud](https://cloud.walletconnect.com)
2. Sign up/login
3. Create a new project
4. Copy the Project ID

### 4. MetaMask Tatara Testnet Setup

Add Tatara testnet to MetaMask:

**Network Details:**
- **Network Name**: Tatara Testnet
- **RPC URL**: `https://rpc.tatara.katanarpc.com`
- **Chain ID**: `167009`
- **Currency Symbol**: `ETH`
- **Block Explorer**: `https://explorer.tatara.katanarpc.com`

### 5. File Structure

Replace the generated files with the provided code:

```
src/
├── components/
│   ├── Navbar.tsx
│   └── VaultInterface.tsx
├── contracts.ts
├── Web3Provider.tsx
├── App.tsx
├── App.css
└── index.tsx
```

### 6. Run the Application

```bash
bun start
```

The app will open at `http://localhost:3000`

## Usage Guide

### Step 1: Connect Wallet
- Click "Connect Wallet" in the navbar
- Select MetaMask
- Ensure you're on Tatara testnet

### Step 2: Get Test Tokens
You'll need AUSD tokens to interact with the vault. If you don't have any, you'll need to:
- Get AUSD tokens from a faucet or
- Use the provided cast commands to mint/transfer if you have access

### Step 3: Approve Tokens
1. Enter the amount of AUSD you want to approve
2. Click "Approve"
3. Confirm the transaction in MetaMask

### Step 4: Deposit AUSD
1. Enter the amount of AUSD to deposit
2. Click "Deposit"
3. Confirm the transaction
4. You'll receive YvAUSD tokens representing your vault share

### Step 5: Monitor Your Position
- View your AUSD and YvAUSD balances
- See vault total assets
- Track your current allowance

### Step 6: Withdraw (Optional)
1. Enter the amount of YvAUSD to redeem
2. Click "Withdraw"
3. Confirm the transaction
4. You'll receive AUSD back

## Contract Addresses

- **AUSD Token**: `0xa9012a055bd4e0eDfF8Ce09f960291C09D5322dC`
- **YvAUSD Vault**: `0xAe4b2FCf45566893Ee5009BA36792D5078e4AD60`

## Cast Commands (For Testing)

If you have a private key with AUSD tokens, you can use these commands:

```bash
# Approve AUSD
cast send 0xa9012a055bd4e0eDfF8Ce09f960291C09D5322dC "approve(address,uint256)" 0xAe4b2FCf45566893Ee5009BA36792D5078e4AD60 1000000 \
    --private-key $PRIVATE_KEY \
    --rpc-url https://rpc.tatara.katanarpc.com

# Deposit AUSD
cast send 0xAe4b2FCf45566893Ee5009BA36792D5078e4AD60 "deposit(uint256,address)" 1000000 YOUR_ADDRESS \
    --private-key $PRIVATE_KEY \
    --rpc-url https://rpc.tatara.katanarpc.com
```

## Technical Notes

- **Token Decimals**: AUSD uses 6 decimals
- **ERC4626**: The vault follows ERC4626 standard
- **Auto-refresh**: Data updates automatically when transactions complete
- **Error Handling**: Transactions will show loading states and handle errors gracefully

## Troubleshooting

### Common Issues

1. **"Cannot connect to wallet"**
   - Ensure MetaMask is installed and unlocked
   - Check you're on the correct network (Tatara testnet)

2. **"Transaction failed"**
   - Check you have enough ETH for gas fees
   - Verify you have approved sufficient AUSD amount
   - Ensure you have enough AUSD balance

3. **"Network error"**
   - Verify Tatara testnet RPC is working
   - Try refreshing the page

4. **Missing WalletConnect Project ID**
   - Check your `.env` file exists and has the correct variable name
   - Restart the development server after adding environment variables

### Getting Test ETH

You'll need ETH for gas fees on Tatara testnet. Contact the Tatara testnet team or check their documentation for faucet information.

## Development

The project uses:
- **React 18** with TypeScript
- **Wagmi v2** for Ethereum interactions
- **Viem** for low-level blockchain operations
- **ConnectKit** for wallet connection UI
- **TanStack Query** for data fetching and caching

The code is structured to be simple and maintainable:
- All contract ABIs and addresses in one file
- Minimal component structure
- Clean separation of concerns
- Type safety throughout

## Support

If you encounter issues:
1. Check the browser console for error messages
2. Verify all environment variables are set correctly
3. Ensure you're using the correct contract addresses
4. Check MetaMask is connected to Tatara testnet