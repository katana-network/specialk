// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IuSUI
 * @notice Interface for SUI (Universal) (uSUI) on Katana
 * @dev uSUI implements the standard ERC-20 interface
 * @custom:katana 0xb0505e5a99abd03d94a1169e638B78EDfEd26ea4
 * @custom:tags erc20,token,wrapped,sui,usui
 */
interface IuSUI is IERC20 {
    // uSUI fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}