// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IJitoSOL
 * @notice Interface for Jito Staked SOL (JitoSOL) on Katana
 * @dev JitoSOL implements the standard ERC-20 interface
 * @custom:katana 0x6C16E26013f2431e8B2e1Ba7067ECCcad0Db6C52
 * @custom:tags erc20,token,staking,jitosol,solana
 */
interface IJitoSOL is IERC20 {
    // JitoSOL fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}