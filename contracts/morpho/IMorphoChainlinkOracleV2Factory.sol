// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC4626.sol";
import "../oracles/chainlink/IAggregatorV3Interface.sol";
import "./IMorphoChainlinkOracleV2.sol";

/**
 * @title IMorphoChainlinkOracleV2Factory
 * @notice Interface for the factory that creates Morpho Chainlink Oracle V2 instances
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tatara 0xe795DD345aD7E1bC9e8F6B4437a21704d731F9E0
 * @custom:tags morpho,oracle,chainlink,factory,defi
 */
interface IMorphoChainlinkOracleV2Factory {
    /**
     * @notice Emitted when a new Chainlink oracle is created
     * @param caller The address that created the oracle
     * @param oracle The address of the new oracle contract
     */
    event CreateMorphoChainlinkOracleV2(address caller, address oracle);

    /**
     * @notice Checks if an address was deployed by this factory
     * @param target The address to check
     * @return Whether the address is a MorphoChainlinkOracleV2 deployed by this factory
     */
    function isMorphoChainlinkOracleV2(address target) external view returns (bool);

    /**
     * @notice Creates a new Morpho Chainlink Oracle V2
     * @dev Here is the list of assumptions that guarantees the oracle behaves as expected:
     * - The vaults, if set, are ERC4626-compliant
     * - The feeds, if set, are Chainlink-interface-compliant
     * - Decimals passed as argument are correct
     * - The base vaults's sample shares quoted as assets and the base feed prices don't overflow when multiplied
     * - The quote vault's sample shares quoted as assets and the quote feed prices don't overflow when multiplied
     * @param baseVault Base vault (address zero to omit)
     * @param baseVaultConversionSample Sample amount of base vault shares for conversion precision
     * @param baseFeed1 First base feed (address zero if price = 1)
     * @param baseFeed2 Second base feed (address zero if price = 1)
     * @param baseTokenDecimals Base token decimals
     * @param quoteVault Quote vault (address zero to omit)
     * @param quoteVaultConversionSample Sample amount of quote vault shares for conversion precision
     * @param quoteFeed1 First quote feed (address zero if price = 1)
     * @param quoteFeed2 Second quote feed (address zero if price = 1)
     * @param quoteTokenDecimals Quote token decimals
     * @param salt The salt to use for the CREATE2 deployment
     * @return oracle The created oracle address
     */
    function createMorphoChainlinkOracleV2(
        IERC4626 baseVault,
        uint256 baseVaultConversionSample,
        IAggregatorV3Interface baseFeed1,
        IAggregatorV3Interface baseFeed2,
        uint256 baseTokenDecimals,
        IERC4626 quoteVault,
        uint256 quoteVaultConversionSample,
        IAggregatorV3Interface quoteFeed1,
        IAggregatorV3Interface quoteFeed2,
        uint256 quoteTokenDecimals,
        bytes32 salt
    ) external returns (IMorphoChainlinkOracleV2 oracle);
} 