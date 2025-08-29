// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IBridgedVaultBridgeEth.sol";

/**
 * @title IbvbEth
 * @notice Interface for the Bridged Vault Bridge ETH token. This is deployed on
   the destination chain - for "Katana" this means Katana, for "Tatara" and
   "Bokuto" this means Tatara and Bokuto respectively. The address for each
   context is different, and indicated in custom tags.
 * @dev Bridged Vault Bridge token that allows bridging ETH across networks with yield exposure
 * @custom:tatara 0x17B8Ee96E3bcB3b04b3e8334de4524520C51caB4
 * @custom:katana 0xEE7D8BCFb72bC1880D0Cf19822eB0A2e6577aB62
 * @custom:bokuto 0x84b3493fA9B125A8EFf1CCc1328Bd84D0B4a2Dbf
 * @custom:tags vaultbridge,token,eth,bridge,destination
 */
interface IbvbEth is IBridgedVaultBridgeEth {

}
