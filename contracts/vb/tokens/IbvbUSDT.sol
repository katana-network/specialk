// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IGenericCustomToken.sol";

/**
 * @title IbvbUSDT
 * @notice Interface for the Bridged Vault Bridge USDT token. This is deployed on the
 *   destination chain - for "Katana" this means Katana and "Bokuto"
 *   this means these respective testnets. The address for each context is different,
 *   and indicated in custom tags.
 * @dev Bridged representation of vault bridge USDT that can be minted/burned via bridge
 * @custom:katana 0x2DCa96907fde857dd3D816880A0df407eeB2D2F2
 * @custom:bokuto 0xf6801557e17131Da48Fd03B2c34172872F936345
 * @custom:tags vaultbridge,token,usdt,bridge,destination
 */
interface IbvbUSDT is IGenericCustomToken {

}