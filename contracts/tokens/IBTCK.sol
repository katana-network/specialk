// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IBTCK
 * @notice Interface for Bitcoin on Katana (BTCK) on Katana
 * @dev BTCK implements the standard ERC-20 interface
 * @custom:katana 0xB0F70C0bD6FD87dbEb7C10dC692a2a6106817072
 * @custom:tags erc20,token,bitcoin,btck
 */
interface IBTCK is IERC20 {
    // BTCK fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}