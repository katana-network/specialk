#!/bin/bash

# Check if chain parameter is provided
if [ -z "$1" ]; then
  echo "❌ Error: Please specify a chain to fork"
  echo "Usage: $0 [tatara|bokuto|katana]"
  echo "Example: $0 tatara"
  exit 1
fi

CHAIN=$1

# Set chain-specific variables
case $CHAIN in
  "tatara")
    CHAIN_ID=129399
    RPC_VAR="TATARA_RPC_URL"
    ;;
  "bokuto")
    CHAIN_ID=737373
    RPC_VAR="BOKUTO_RPC_URL"
    ;;
  "katana")
    CHAIN_ID=747474
    RPC_VAR="KATANA_RPC_URL"
    ;;
  *)
    echo "❌ Error: Invalid chain '$CHAIN'"
    echo "Supported chains: tatara, bokuto, katana"
    exit 1
    ;;
esac

# Get RPC URL from .env file
RPC_URL=$(grep "^$RPC_VAR=" $(pwd)/.env 2>/dev/null | cut -d '=' -f2)

if [ -z "$RPC_URL" ]; then
  echo "❌ Error: $RPC_VAR environment variable is not set"
  echo "Please set it in your .env file"
  echo "Example: $RPC_VAR=https://your-rpc-endpoint.com"
  exit 1
fi

echo "⚡ Starting local $CHAIN fork with Anvil..."
echo "Chain ID: $CHAIN_ID"
echo "RPC URL: $RPC_URL"

# Start anvil with the specified chain fork
anvil \
  --fork-url "$RPC_URL" \
  --chain-id $CHAIN_ID \
  --port 8545 \
  --block-time 12

# This will keep running until Ctrl+C is pressed 