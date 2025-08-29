// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMorphoBlue.sol";
import "./IPreLiquidation.sol";

/**
 * @title IPreLiquidationFactory
 * @notice Interface for the PreLiquidation Factory that creates pre-liquidation contracts for Morpho Blue markets
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tags morpho,defi,liquidation,factory,preliquidation
 */
interface IPreLiquidationFactory {
    /**
     * @notice Emitted when a new PreLiquidation contract is created
     * @param preLiquidation The address of the newly created PreLiquidation contract
     * @param id The ID of the Morpho market for which this PreLiquidation contract was created
     * @param params The pre-liquidation parameters for the created contract
     */
    event CreatePreLiquidation(
        address indexed preLiquidation, 
        IMorphoBlue.Id indexed id, 
        IPreLiquidation.PreLiquidationParams params
    );

    /**
     * @notice Returns the address of the Morpho Blue contract
     * @return The Morpho contract address
     */
    function MORPHO() external view returns (address);

    /**
     * @notice Verifies if an address is a PreLiquidation contract created by this factory
     * @param target The address to check
     * @return True if the address is a PreLiquidation contract, false otherwise
     */
    function isPreLiquidation(address target) external view returns (bool);

    /**
     * @notice Creates a new PreLiquidation contract for a specific Morpho Blue market
     * @dev Will revert if a PreLiquidation contract with the same parameters already exists
     * @param id The ID of the Morpho market for which to create a PreLiquidation contract
     * @param preLiquidationParams The parameters for the PreLiquidation contract
     * @return preLiquidation The address of the newly created PreLiquidation contract
     */
    function createPreLiquidation(
        IMorphoBlue.Id id, 
        IPreLiquidation.PreLiquidationParams calldata preLiquidationParams
    ) external returns (address preLiquidation);
} 