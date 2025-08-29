// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IGenericCustomToken.sol";

/**
 * @title IbvbWBTC
 * @notice Interface for the Bridged Vault Bridge WBTC token. This is deployed on the
 *   destination chain - for "Katana" this means Katana, for "Tatara" and "Bokuto"
 *   this means these respective testnets. The address for each context is different,
 *   and indicated in custom tags.
 * @dev Bridged representation of vault bridge WBTC that can be minted/burned via bridge
 * @custom:tatara 0x1538aDF273f6f13CcdcdBa41A5ce4b2DC2177D1C
 * @custom:katana 0x0913DA6Da4b42f538B445599b46Bb4622342Cf52
 * @custom:bokuto 0xe8255B44634b478aB10a649c6C207A654473dbed
 * @custom:tags vaultbridge,token,wbtc,bridge,destination
 */
interface IbvbWBTC is IGenericCustomToken {

}