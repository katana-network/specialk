#!/usr/bin/env bash
# Re-exec under bash if not already, or if POSIX mode is on
if [ -z "${BASH_VERSION:-}" ]; then exec /usr/bin/env bash "$0" "$@"; fi
if (set -o | grep -q 'posix[[:space:]]*on'); then exec /usr/bin/env bash "$0" "$@"; fi

set -euo pipefail

# Defaults
DEFAULT_RPC_URL="${DEFAULT_RPC_URL:-http://localhost:8545}"
DEFAULT_PRIVATE_KEY="${DEFAULT_PRIVATE_KEY:-0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80}"

if ! command -v forge >/dev/null 2>&1; then
  echo "Error: forge not found in PATH. Install Foundry: https://book.getfoundry.sh/getting-started/installation" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

# Load root .env if present so we can read chain RPCs and deployer keys
if [ -f "$repo_root/.env" ]; then
  set +u
  set -a
  # shellcheck disable=SC1090
  source "$repo_root/.env"
  set +a
  set -u
fi

target=""
rpc_url="$DEFAULT_RPC_URL"
private_key="$DEFAULT_PRIVATE_KEY"
rpc_url_explicit=0
private_key_explicit=0
chain=""

# Collect any extra flags to pass along unchanged
passthrough_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --chain)
      [[ $# -ge 2 ]] || { echo "Error: --chain requires a value (local|tatara|bokuto|katana)" >&2; exit 1; }
      chain="$2"
      shift 2
      ;;
    --rpc-url)
      [[ $# -ge 2 ]] || { echo "Error: --rpc-url requires a value" >&2; exit 1; }
      rpc_url="$2"
      rpc_url_explicit=1
      shift 2
      ;;
    --private-key)
      [[ $# -ge 2 ]] || { echo "Error: --private-key requires a value" >&2; exit 1; }
      private_key="$2"
      private_key_explicit=1
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
  echo "Usage: scripts/forge-deploy.sh <@script/FILE:Contract | script/FILE:Contract | FILE:Contract> [--rpc-url URL] [--private-key KEY] [--chain local|tatara|bokuto|katana] [extra forge flags]" >&2
  exit 1
fi

# If user specified --chain, map to RPC and deployer key from .env, unless explicitly overridden
if [[ -n "$chain" ]]; then
  # Normalize chain to lowercase/uppercase (portable for macOS bash 3.x)
  chain_lc=$(printf '%s' "$chain" | tr '[:upper:]' '[:lower:]')
  if [[ "$chain_lc" == "local" ]]; then
    # Use built-in defaults for local anvil
    if [[ $rpc_url_explicit -eq 0 ]]; then rpc_url="$DEFAULT_RPC_URL"; fi
    if [[ $private_key_explicit -eq 0 ]]; then private_key="$DEFAULT_PRIVATE_KEY"; fi
    echo "Using chain 'local' RPC: $rpc_url"
    if [[ $private_key_explicit -eq 0 ]]; then echo "Using default local anvil deployer key"; fi
  else
    case "$chain_lc" in
      tatara|bokuto|katana) : ;;
      *) echo "Error: unknown --chain '$chain'. Expected one of: local, tatara, bokuto, katana" >&2; exit 1;;
    esac

    chain_uc=$(printf '%s' "$chain_lc" | tr '[:lower:]' '[:upper:]')
    rpc_var="${chain_uc}_RPC_URL"
    key_var="${chain_uc}_DEPLOYER_KEY"

    chain_rpc="${!rpc_var-}"
    chain_key="${!key_var-}"

    if [[ -z "${chain_rpc:-}" ]]; then
      echo "Error: $rpc_var not set in $repo_root/.env. Please define it (see .env.example for reference)." >&2
      exit 1
    fi

    if [[ $rpc_url_explicit -eq 0 ]]; then
      rpc_url="$chain_rpc"
    fi
    if [[ $private_key_explicit -eq 0 && -n "${chain_key:-}" ]]; then
      private_key="$chain_key"
    fi

    echo "Using chain '$chain_lc' RPC: $rpc_url"
    if [[ $private_key_explicit -eq 0 ]]; then
      if [[ -n "${chain_key:-}" ]]; then
        echo "Using deployer key from \$$key_var"
      else
        echo "Warning: $key_var not set in .env; falling back to default key."
      fi
    fi
  fi
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
cd "$repo_root/forge"

# Avoid duplicating --broadcast if already provided
broadcast_flag="--broadcast"
if [ "${#passthrough_args[@]:-0}" -gt 0 ] 2>/dev/null; then
  for arg in "${passthrough_args[@]}"; do
    if [[ "$arg" == "--broadcast" ]]; then
      broadcast_flag=""
      break
    fi
  done
fi

set -x
forge script "$target" ${broadcast_flag} --rpc-url "$rpc_url" --private-key "$private_key" ${passthrough_args+"${passthrough_args[@]}"}