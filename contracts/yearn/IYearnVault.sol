// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IYearnVault
 * @notice Interface for Yearn ERC4626-compatible vaults
 * @dev This interface includes all standard ERC4626 methods plus additional Yearn vault specific functions
 * @custom:tags yearn,defi,vault,erc4626,yield
 */
interface IYearnVault is IERC20 {
    /* ERC4626 Standard Functions */

    /**
     * @notice Returns the address of the underlying token used for the vault
     * @return The address of the underlying asset token
     */
    function asset() external view returns (address);

    /**
     * @notice Returns the total amount of the underlying asset managed by the vault
     * @return The total amount of the underlying asset
     */
    function totalAssets() external view returns (uint256);

    /**
     * @notice Converts a given amount of assets to the corresponding amount of shares
     * @param assets The amount of assets to convert
     * @return The amount of shares that would be minted
     */
    function convertToShares(uint256 assets) external view returns (uint256);

    /**
     * @notice Converts a given amount of shares to the corresponding amount of assets
     * @param shares The amount of shares to convert
     * @return The amount of assets that would be withdrawn
     */
    function convertToAssets(uint256 shares) external view returns (uint256);

    /**
     * @notice Returns the maximum amount of the underlying asset that can be deposited for a receiver
     * @param receiver The address that would receive the shares
     * @return The maximum amount of assets that can be deposited
     */
    function maxDeposit(address receiver) external view returns (uint256);

    /**
     * @notice Simulates the amount of shares that would be minted for a given amount of assets
     * @param assets The amount of assets to deposit
     * @return The amount of shares that would be minted
     */
    function previewDeposit(uint256 assets) external view returns (uint256);

    /**
     * @notice Deposits assets into the vault and mints shares to the receiver
     * @param assets The amount of assets to deposit
     * @param receiver The address to receive the minted shares
     * @return shares The amount of shares minted
     */
    function deposit(uint256 assets, address receiver) external returns (uint256 shares);

    /**
     * @notice Returns the maximum amount of shares that can be minted for a receiver
     * @param receiver The address that would receive the shares
     * @return The maximum amount of shares that can be minted
     */
    function maxMint(address receiver) external view returns (uint256);

    /**
     * @notice Simulates the amount of assets that would be required to mint a given amount of shares
     * @param shares The amount of shares to mint
     * @return The amount of assets that would be required
     */
    function previewMint(uint256 shares) external view returns (uint256);

    /**
     * @notice Mints shares to the receiver by depositing assets
     * @param shares The amount of shares to mint
     * @param receiver The address to receive the minted shares
     * @return assets The amount of assets deposited
     */
    function mint(uint256 shares, address receiver) external returns (uint256 assets);

    /**
     * @notice Returns the maximum amount of assets that can be withdrawn by a caller
     * @param owner The address that owns the shares
     * @return The maximum amount of assets that can be withdrawn
     */
    function maxWithdraw(address owner) external view returns (uint256);

    /**
     * @notice Simulates the amount of shares that would be burned to withdraw a given amount of assets
     * @param assets The amount of assets to withdraw
     * @return The amount of shares that would be burned
     */
    function previewWithdraw(uint256 assets) external view returns (uint256);

    /**
     * @notice Withdraws assets from the vault to the receiver, burning shares from the owner
     * @param assets The amount of assets to withdraw
     * @param receiver The address to receive the assets
     * @param owner The address that owns the shares
     * @return shares The amount of shares burned
     */
    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares);

    /**
     * @notice Returns the maximum amount of shares that can be redeemed by a caller
     * @param owner The address that owns the shares
     * @return The maximum amount of shares that can be redeemed
     */
    function maxRedeem(address owner) external view returns (uint256);

    /**
     * @notice Simulates the amount of assets that would be received for redeeming a given amount of shares
     * @param shares The amount of shares to redeem
     * @return The amount of assets that would be received
     */
    function previewRedeem(uint256 shares) external view returns (uint256);

    /**
     * @notice Redeems shares from the owner and sends assets to the receiver
     * @param shares The amount of shares to redeem
     * @param receiver The address to receive the assets
     * @param owner The address that owns the shares
     * @return assets The amount of assets sent to the receiver
     */
    function redeem(uint256 shares, address receiver, address owner) external returns (uint256 assets);

    /* Yearn Vault Specific Functions */

    /**
     * @notice Returns the vault's current version
     * @return The vault's version string
     */
    function apiVersion() external view returns (string memory);

    /**
     * @notice Returns the address of the protocol's governance
     * @return The governance address
     */
    function governance() external view returns (address);

    /**
     * @notice Returns the address of the protocol's management
     * @return The management address
     */
    function management() external view returns (address);

    /**
     * @notice Returns the vault's current performance fee, if any
     * @return The performance fee, scaled by 1e4 (10000 = 100%)
     */
    function performanceFee() external view returns (uint256);

    /**
     * @notice Returns the vault's current management fee, if any
     * @return The management fee, scaled by 1e4 (10000 = 100%)
     */
    function managementFee() external view returns (uint256);

    /**
     * @notice Returns the price of a single vault share in terms of the underlying asset
     * @return The price per share
     */
    function pricePerShare() external view returns (uint256);

    /**
     * @notice Returns the address of the vault's current strategy, if any
     * @return The strategy address
     */
    function strategy() external view returns (address);

    /**
     * @notice Returns the total amount of assets the vault's strategy is managing
     * @return The total strategy assets
     */
    function totalDebt() external view returns (uint256);
} 