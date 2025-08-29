// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title ISUSHI
 * @notice Interface for Bridge-wrapped SUSHI (SUSHI) on Katana
 * @dev SUSHI implements the standard ERC-20 interface
 * @custom:katana 0x17BFF452dae47e07CeA877Ff0E1aba17eB62b0aB
 * @custom:katana ethereum:0x6b3595068778dd592e39a122f4f5a5cf09c90fe2
 * @custom:tags erc20,token,governance,sushi,defi
 */
interface ISUSHI is IERC20 {
    // SUSHI fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}