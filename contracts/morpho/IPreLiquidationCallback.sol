// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IPreLiquidationCallback
 * @notice Interface that pre-liquidators must implement to receive callbacks during pre-liquidation
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tags morpho,defi,liquidation,callback,preliquidation
 */
interface IPreLiquidationCallback {
    /**
     * @notice Callback function called when a pre-liquidation occurs
     * @dev This callback is only called if non-empty data is passed to the preLiquidate function
     * @param repaidAssets The amount of debt assets repaid in the pre-liquidation
     * @param data Arbitrary data that was passed to the preLiquidate function
     */
    function onPreLiquidate(uint256 repaidAssets, bytes calldata data) external;
} 