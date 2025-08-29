// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "../IERC20.sol";

/**
 * @title IKAT
 * @notice Interface for KAT, the native token on Katana
 * @dev KAT implements the standard ERC-20 interface
 * @custom:katana 0x7F1f4b4b29f5058fA32CC7a97141b8D7e5ABDC2d
 * @custom:tags erc20,token,governance,katana,native
 */
interface IKAT is IERC20 {
    // KAT fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
} 