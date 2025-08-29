// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title ILBTC
 * @notice Interface for Lombard Staked BTC (LBTC) on Katana
 * @dev LBTC implements the standard ERC-20 interface
 * @custom:katana 0xecAc9C5F704e954931349Da37F60E39f515c11c1
 * @custom:katana ethereum:0x8236a87084f8b84306f72007f36f2618a5634494
 * @custom:tags erc20,token,bitcoin,lbtc,liquid
 */
interface ILBTC is IERC20 {
    // LBTC fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}