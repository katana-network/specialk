// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IVaultBridgeToken.sol";

/**
 * @title IvbUSDS
 * @notice Interface for the Vault Bridge USDS token. This is deployed on the
   origin chain - for "Katana" this means Ethereum, for "Tatara" and "Bokuto"
   this means Sepolia. The address for each context is different, and indicated
   in custom tags.
 * @dev Vault Bridge token that allows bridging USDS across networks with yield exposure
 * @custom:katana ethereum:0x3DD459dE96F9C28e3a343b831cbDC2B93c8C4855
 * @custom:tatara sepolia:0x56b89A124376CB0481c93C3d94f821F262Dc0D7A
 * @custom:bokuto sepolia:0x406F1A8D91956d8D340821Cf6744Aa74c666836C
 * @custom:tags vaultbridge,token,usds,yield,origin
 */
interface IvbUSDS is IVaultBridgeToken {

}