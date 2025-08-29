// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IMORPHO
 * @notice Interface for Bridge-wrapped MORPHO (MORPHO) on Katana
 * @dev MORPHO implements the standard ERC-20 interface
 * @custom:katana 0x1e5eFCA3D0dB2c6d5C67a4491845c43253eB9e4e
 * @custom:katana ethereum:0x58d97b57bb95320f9a05dc918aef65434969c2b2
 * @custom:tags erc20,token,governance,morpho
 */
interface IMORPHO is IERC20 {
    // MORPHO fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}