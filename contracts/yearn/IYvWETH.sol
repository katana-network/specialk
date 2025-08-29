// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IYearnVault.sol";

/**
 * @title IYvWETH
 * @notice Interface for the Yearn WETH ERC4626 vault
 * @dev This vault accepts WETH and issues yvWETH tokens
 * @custom:tatara 0xccc0fc2e34428120f985b460b487eb79e3c6fa57
 * @custom:tags yearn,defi,vault,weth,yield
 */
interface IYvWETH is IYearnVault {
    /**
     * @notice Returns the deposit limit for the vault in terms of the underlying asset
     * @return The maximum amount of WETH that can be deposited
     */
    function depositLimit() external view returns (uint256);

    /**
     * @notice Returns the module responsible for enforcing deposit limits
     * @return The address of the deposit limit module
     */
    function depositLimitModule() external view returns (address);

    /**
     * @notice Returns whether the vault is in emergency shutdown mode
     * @return True if the vault is shut down, false otherwise
     */
    function emergencyShutdown() external view returns (bool);

    /**
     * @notice Returns the target percentage of assets to keep as float (not deployed to strategies)
     * @return The target float percentage, scaled by 1e4 (10000 = 100%)
     */
    function targetFloatPercent() external view returns (uint256);

    /**
     * @notice Enables or disables emergency shutdown mode
     * @param active True to enable shutdown, false to disable
     */
    function setEmergencyShutdown(bool active) external;

    /**
     * @notice Sets a new deposit limit for the vault
     * @param limit The new deposit limit
     */
    function setDepositLimit(uint256 limit) external;

    /**
     * @notice Sets the management fee for the vault
     * @param fee The new management fee
     */
    function setManagementFee(uint256 fee) external;

    /**
     * @notice Sets the performance fee for the vault
     * @param fee The new performance fee
     */
    function setPerformanceFee(uint256 fee) external;

    /**
     * @notice Sets the target percentage of assets to keep as float
     * @param targetPercent The new target percentage
     */
    function setTargetFloatPercent(uint256 targetPercent) external;

    /**
     * @notice Returns the address that will receive management fees
     * @return The rewards address
     */
    function rewards() external view returns (address);

    /**
     * @notice Sets the address that will receive management fees
     * @param rewards The new rewards address
     */
    function setRewards(address rewards) external;

    /**
     * @notice Returns the list of strategies currently used by the vault
     * @return Array of strategy addresses
     */
    function withdrawalQueue() external view returns (address[] memory);
} 