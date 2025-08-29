// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IVaultBridgeToken.sol";

/**
 * @title IvbETH
 * @notice Interface for the Vault Bridge ETH token. This is deployed on the
   origin chain - for "Katana" this means Ethereum, for "Tatara" and "Bokuto"
   this means Sepolia. The address for each context is different, and indicated
   in custom tags.
 * @dev Vault Bridge token that allows bridging ETH across networks with yield exposure
 * @custom:katana ethereum:0x2DC70fb75b88d2eB4715bc06E1595E6D97c34DFF
 * @custom:tatara sepolia:0x4CcD4CbDE5Ec758cCBf75f0be280647Ff359c17a
 * @custom:bokuto sepolia:0x188FFFc2562C67aCdB9a0CD0B819021DDfC82A6B
 * @custom:tags vaultbridge,token,eth,yield,origin
 */
interface IvbETH is IVaultBridgeToken {

}