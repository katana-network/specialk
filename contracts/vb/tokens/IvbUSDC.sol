// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IVaultBridgeToken.sol";

/**
 * @title IvbUSDC
 * @notice Interface for the Vault Bridge USDC token. This is deployed on the
   origin chain - for "Katana" this means Ethereum and "Bokuto"
   this means Sepolia. The address for each context is different, and indicated
   in custom tags.
 * @dev Vault Bridge token that allows bridging USDC across networks with yield exposure
 * @custom:katana ethereum:0x53E82ABbb12638F09d9e624578ccB666217a765e
 * @custom:bokuto sepolia:0xb62Ba0719527701309339a175dDe3CBF1770dd38
 * @custom:tags vaultbridge,token,usdc,yield,origin
 */
interface IvbUSDC is IVaultBridgeToken {

}