// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IYearnVault.sol";

/**
 * @title IYvAUSD
 * @notice Interface for the Yearn AUSD ERC4626 vault
 * @dev This vault accepts AUSD and issues yvAUSD tokens
 * @custom:katana 0x93Fec6639717b6215A48E5a72a162C50DCC40d68
 * @custom:tatara 0xAe4b2FCf45566893Ee5009BA36792D5078e4AD60
 * @custom:tags yearn,defi,vault,ausd,yield
 */
interface IYvAUSD is IYearnVault {
    /**
     * @notice Returns whether the vault is currently accepting deposits
     * @return True if deposits are enabled, false otherwise
     */
    function depositLimit() external view returns (uint256);

    /**
     * @notice Returns the amount of time (in seconds) between deposits and withdrawals
     * @return The lockup period in seconds
     */
    function depositLimitModule() external view returns (address);

    /**
     * @notice Returns the maximum capacity of the vault in terms of the underlying asset
     * @return The maximum capacity
     */
    function emergencyShutdown() external view returns (bool);

    /**
     * @notice Returns the percentage of assets that should be kept as float (not deployed to strategies)
     * @return The target float percentage, scaled by 1e4 (10000 = 100%)
     */
    function targetFloatPercent() external view returns (uint256);

    /**
     * @notice Withdraws everything from the strategy and puts the vault in emergency shutdown mode
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
} 