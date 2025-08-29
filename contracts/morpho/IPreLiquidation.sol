// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMorphoBlue.sol";

/**
 * @title IPreLiquidation
 * @notice Interface for the PreLiquidation contract that enables early liquidations for Morpho Blue positions
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tags morpho,defi,liquidation,preliquidation
 */
interface IPreLiquidation {
    /**
     * @notice Pre-liquidation parameters for a Morpho Blue market
     * @param preLltv The maximum LTV of a position before allowing pre-liquidation, scaled by WAD
     * @param preLCF1 The pre-liquidation close factor when position LTV equals preLltv, scaled by WAD
     * @param preLCF2 The pre-liquidation close factor when position LTV equals LLTV, scaled by WAD
     * @param preLIF1 The pre-liquidation incentive factor when position LTV equals preLltv, scaled by WAD
     * @param preLIF2 The pre-liquidation incentive factor when position LTV equals LLTV, scaled by WAD
     * @param preLiquidationOracle The oracle used to assess whether a position can be pre-liquidated
     */
    struct PreLiquidationParams {
        uint256 preLltv;
        uint256 preLCF1;
        uint256 preLCF2;
        uint256 preLIF1;
        uint256 preLIF2;
        address preLiquidationOracle;
    }

    /**
     * @notice Emitted when a position is pre-liquidated
     * @param id The market ID where the pre-liquidation occurred
     * @param preliquidator The address that performed the pre-liquidation
     * @param borrower The address of the position's owner
     * @param repaidAssets The amount of debt repaid
     * @param repaidShares The amount of borrow shares repaid
     * @param seizedAssets The amount of collateral seized
     */
    event PreLiquidate(
        IMorphoBlue.Id indexed id,
        address indexed preliquidator,
        address indexed borrower,
        uint256 repaidAssets,
        uint256 repaidShares,
        uint256 seizedAssets
    );

    /**
     * @notice Returns the address of the Morpho Blue contract
     * @return The Morpho contract address
     */
    function MORPHO() external view returns (address);

    /**
     * @notice Returns the ID of the Morpho market for which this contract was created
     * @return The market ID
     */
    function ID() external view returns (IMorphoBlue.Id);

    /**
     * @notice Returns the market parameters for the associated Morpho market
     * @return The market parameters
     */
    function marketParams() external view returns (IMorphoBlue.MarketParams memory);

    /**
     * @notice Returns the pre-liquidation parameters for this contract
     * @return The pre-liquidation parameters
     */
    function preLiquidationParams() external view returns (PreLiquidationParams memory);

    /**
     * @notice Pre-liquidates a position that is within the pre-liquidation LTV range
     * @dev Either seizedAssets or repaidShares must be zero (exactly one must be specified)
     * @dev The position must be within the pre-liquidation range (LTV > preLltv but LTV <= LLTV)
     * @dev The pre-liquidation close factor and incentive factor scale linearly based on the position's LTV
     * @param borrower The owner of the position to pre-liquidate
     * @param seizedAssets The amount of collateral to seize (if repaidShares is zero)
     * @param repaidShares The amount of debt shares to repay (if seizedAssets is zero)
     * @param data Arbitrary data to pass to the onPreLiquidate callback (pass empty bytes if not using callback)
     * @return seizedAssets The amount of collateral seized
     * @return repaidAssets The amount of debt repaid
     */
    function preLiquidate(
        address borrower, 
        uint256 seizedAssets, 
        uint256 repaidShares, 
        bytes calldata data
    ) external returns (uint256, uint256);
} 