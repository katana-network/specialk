// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC4626.sol";
import "../oracles/chainlink/IAggregatorV3Interface.sol";
import "./IMorphoOracle.sol";

/**
 * @title IMorphoChainlinkOracleV2
 * @notice Interface for Morpho's Chainlink Oracle V2, which combines ERC4626 vault assets with Chainlink price feeds
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tags morpho,oracle,chainlink,defi
 */
interface IMorphoChainlinkOracleV2 is IMorphoOracle {
    /**
     * @notice Returns the address of the base ERC4626 vault
     * @return The base vault address
     */
    function BASE_VAULT() external view returns (IERC4626);

    /**
     * @notice Returns the base vault conversion sample
     * @return The sample amount used to convert vault shares to assets
     */
    function BASE_VAULT_CONVERSION_SAMPLE() external view returns (uint256);

    /**
     * @notice Returns the address of the quote ERC4626 vault
     * @return The quote vault address
     */
    function QUOTE_VAULT() external view returns (IERC4626);

    /**
     * @notice Returns the quote vault conversion sample
     * @return The sample amount used to convert vault shares to assets
     */
    function QUOTE_VAULT_CONVERSION_SAMPLE() external view returns (uint256);

    /**
     * @notice Returns the address of the first base feed
     * @return The first base Chainlink feed
     */
    function BASE_FEED_1() external view returns (IAggregatorV3Interface);

    /**
     * @notice Returns the address of the second base feed
     * @return The second base Chainlink feed
     */
    function BASE_FEED_2() external view returns (IAggregatorV3Interface);

    /**
     * @notice Returns the address of the first quote feed
     * @return The first quote Chainlink feed
     */
    function QUOTE_FEED_1() external view returns (IAggregatorV3Interface);

    /**
     * @notice Returns the address of the second quote feed
     * @return The second quote Chainlink feed
     */
    function QUOTE_FEED_2() external view returns (IAggregatorV3Interface);

    /**
     * @notice Returns the price scale factor, calculated at contract creation
     * @return The scale factor for price calculations
     */
    function SCALE_FACTOR() external view returns (uint256);
} 