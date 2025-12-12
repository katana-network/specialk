// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IVaultBridgeToken.sol";

/**
 * @title IvbUSDT
 * @notice Interface for the Vault Bridge USDT token. This is deployed on the
   origin chain - for "Katana" this means Ethereum and "Bokuto"
   this means Sepolia. The address for each context is different, and indicated
   in custom tags.
 * @dev Vault Bridge token that allows bridging USDT across networks with yield exposure
 * @custom:katana ethereum:0x6d4f9f9f8f0155509ecd6Ac6c544fF27999845CC
 * @custom:bokuto sepolia:0xdd9aCdD3D2AeC1C823C51f8389597C6be9779B28
 * @custom:tags vaultbridge,token,usdt,yield,origin
 */
interface IvbUSDT is IVaultBridgeToken {

}