// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMorphoBlue.sol";

/**
 * @title IMorphoAdaptiveIRM
 * @notice Interface for Morpho's Adaptive Curve Interest Rate Model (IRM)
 * @dev This IRM dynamically adjusts interest rates based on market utilization
 * @custom:tatara 0x9eB6d0D85FCc07Bf34D69913031ade9E16BD5dB0
 * @custom:tags morpho,defi,irm,interest-rate,adaptive
 */
interface IMorphoAdaptiveIRM {
    /**
     * @notice Emitted when a borrow rate is updated
     * @param id The market identifier
     * @param avgBorrowRate The average borrow rate
     * @param rateAtTarget The rate at target utilization
     */
    event BorrowRateUpdate(IMorphoBlue.Id indexed id, uint256 avgBorrowRate, uint256 rateAtTarget);

    /**
     * @notice The address of Morpho Blue contract
     * @return The address of Morpho
     */
    function MORPHO() external view returns (address);

    /**
     * @notice Returns the rate at target utilization for a given market
     * @dev The rate at target utilization determines the height of the interest rate curve
     * @param id The market identifier
     * @return The rate at target utilization (scaled by 1e18)
     */
    function rateAtTarget(IMorphoBlue.Id id) external view returns (int256);

    /**
     * @notice Calculates the current borrow rate for a market without changing state
     * @dev Returns the average borrow rate per second (scaled by 1e18)
     * @param marketParams The market parameters
     * @param market The market state
     * @return The borrow rate per second (scaled by 1e18)
     */
    function borrowRateView(
        IMorphoBlue.MarketParams memory marketParams, 
        IMorphoBlue.Market memory market
    ) external view returns (uint256);

    /**
     * @notice Calculates and updates the current borrow rate for a market
     * @dev Updates the rateAtTarget state variable for the market
     * @dev Only callable by the Morpho contract
     * @param marketParams The market parameters
     * @param market The market state
     * @return The borrow rate per second (scaled by 1e18)
     */
    function borrowRate(
        IMorphoBlue.MarketParams memory marketParams, 
        IMorphoBlue.Market memory market
    ) external returns (uint256);
} 