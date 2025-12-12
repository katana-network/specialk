// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IGenericCustomToken.sol";

/**
 * @title IbvbUSDS
 * @notice Interface for the Bridged Vault Bridge USDS token. This is deployed on the
 *   destination chain - for "Katana" this means Katana and "Bokuto"
 *   this means these respective testnets. The address for each context is different,
 *   and indicated in custom tags.
 * @dev Bridged representation of vault bridge USDS that can be minted/burned via bridge
 * @custom:katana 0x62D6A123E8D19d06d68cf0d2294F9A3A0362c6b3
 * @custom:bokuto 0x801f719178d9b85D4948ed146C50596273885a75
 * @custom:tags vaultbridge,token,usds,bridge,destination
 */
interface IbvbUSDS is IGenericCustomToken {

}