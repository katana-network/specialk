// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IMorphoOracle
 * @notice Interface for oracles used by Morpho Blue
 * @dev It is the user's responsibility to select markets with safe oracles
 * @custom:tags morpho,oracle,defi,interface
 */
interface IMorphoOracle {
    /**
     * @notice Returns the price of 1 asset of collateral token quoted in 1 asset of loan token
     * @dev The price is scaled by 1e36
     * @dev It corresponds to the price of 10**(collateral token decimals) assets of collateral token quoted in
     * 10**(loan token decimals) assets of loan token with `36 + loan token decimals - collateral token decimals`
     * decimals of precision
     * @return The price of the collateral token in loan token units
     */
    function price() external view returns (uint256);
} 