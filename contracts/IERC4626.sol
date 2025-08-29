// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IERC4626
 * @notice Minimal interface for ERC4626 tokenized vaults
 * @dev Only includes the functions needed for Morpho Chainlink Oracle integration
 * @custom:tags erc4626,vault,standard,defi
 */
interface IERC4626 {
    /**
     * @notice Converts a given number of shares to the amount of assets they represent
     * @param shares The amount of shares to convert
     * @return The amount of assets that the shares represent
     */
    function convertToAssets(uint256 shares) external view returns (uint256);
} 