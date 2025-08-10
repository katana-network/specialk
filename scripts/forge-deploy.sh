#!/usr/bin/env bash

set -euo pipefail

# Defaults
DEFAULT_RPC_URL="${DEFAULT_RPC_URL:-http://localhost:8545}"
DEFAULT_PRIVATE_KEY="${DEFAULT_PRIVATE_KEY:-0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80}"

if ! command -v forge >/dev/null 2>&1; then
  echo "Error: forge not found in PATH. Install Foundry: https://book.getfoundry.sh/getting-started/installation" >&2
  exit 1
fi

target=""
rpc_url="$DEFAULT_RPC_URL"
private_key="$DEFAULT_PRIVATE_KEY"

# Collect any extra flags to pass along unchanged
passthrough_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --rpc-url)
      [[ $# -ge 2 ]] || { echo "Error: --rpc-url requires a value" >&2; exit 1; }
      rpc_url="$2"
      shift 2
      ;;
    --private-key)
      [[ $# -ge 2 ]] || { echo "Error: --private-key requires a value" >&2; exit 1; }
      private_key="$2"
      shift 2
      ;;
    --*)
      # Forward any other flags as-is (value, if present, will be handled in next loop iteration)
      passthrough_args+=("$1")
      shift
      ;;
    *)
      if [[ -z "$target" ]]; then
        target="$1"
      else
        # Forward stray args
        passthrough_args+=("$1")
      fi
      shift
      ;;
  esac
done

if [[ -z "$target" ]]; then
  echo "Usage: scripts/forge-deploy.sh <@script/FILE:Contract | script/FILE:Contract | FILE:Contract> [--rpc-url URL] [--private-key KEY] [extra forge flags]" >&2
  exit 1
fi

# Normalize target to path relative to forge workspace
if [[ "$target" == @script/* ]]; then
  target="${target#@}"
fi
if [[ "$target" == forge/* ]]; then
  target="${target#forge/}"
fi
if [[ "$target" != script/* ]]; then
  target="script/$target"
fi

# Enter the forge workspace root
cd "$(dirname "$0")/.."/forge

# Avoid duplicating --broadcast if already provided
broadcast_flag="--broadcast"
for arg in "${passthrough_args[@]}"; do
  if [[ "$arg" == "--broadcast" ]]; then
    broadcast_flag=""
    break
  fi
done

set -x
forge script "$target" ${broadcast_flag} --rpc-url "$rpc_url" --private-key "$private_key" "${passthrough_args[@]}"

