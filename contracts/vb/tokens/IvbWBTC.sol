// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IVaultBridgeToken.sol";

/**
 * @title IvbWBTC
 * @notice Interface for the Vault Bridge WBTC token. This is deployed on the
   origin chain - for "Katana" this means Ethereum, for "Tatara" and "Bokuto"
   this means Sepolia. The address for each context is different, and indicated
   in custom tags.
 * @dev Vault Bridge token that allows bridging WBTC across networks with yield exposure
 * @custom:katana ethereum:0x2C24B57e2CCd1f273045Af6A5f632504C432374F
 * @custom:tatara sepolia:0xa278D086289f71a30D237feccBAF3698E43Bc5D6
 * @custom:bokuto sepolia:0x2CE29070ee5e65C4191d5Efca8E85be181F34B6d
 * @custom:tags vaultbridge,token,wbtc,yield,origin
 */
interface IvbWBTC is IVaultBridgeToken {

}