// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMorphoBlue.sol";

/**
 * @title IMetaMorpho
 * @notice Interface for MetaMorpho vaults - ERC4626 yield aggregators for Morpho Blue markets
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tags morpho,defi,vault,erc4626,metamorpho
 */
interface IMetaMorpho {
    /**
     * @notice Represents an allocation to a specific market with an amount of assets
     * @param marketParams The market parameters
     * @param assets The amount of assets to allocate
     */
    struct MarketAllocation {
        IMorphoBlue.MarketParams marketParams;
        uint256 assets;
    }

    /**
     * @notice The address of the Morpho Blue contract
     * @return The Morpho contract address
     */
    function MORPHO() external view returns (address);

    /**
     * @notice Returns the current configuration of a market
     * @param id The market identifier
     * @return cap The maximum amount of assets that can be allocated to this market
     * @return enabled Whether the market is enabled
     * @return removableAt The timestamp when the market can be removed (if pending removal)
     */
    function config(IMorphoBlue.Id id) external view returns (uint184 cap, bool enabled, uint64 removableAt);

    /**
     * @notice Returns the address of the curator responsible for market allocations
     * @return The curator address
     */
    function curator() external view returns (address);

    /**
     * @notice Checks if an address is an allocator that can rebalance funds
     * @param target The address to check
     * @return True if the address is an allocator
     */
    function isAllocator(address target) external view returns (bool);

    /**
     * @notice Returns the current fee charged on yield
     * @return The fee rate (scaled by 1e18)
     */
    function fee() external view returns (uint96);

    /**
     * @notice Returns the ordered list of markets to supply into when new deposits come in
     * @param index The index in the queue
     * @return The market ID at the given index
     */
    function supplyQueue(uint256 index) external view returns (IMorphoBlue.Id);

    /**
     * @notice Returns the ordered list of markets to withdraw from when users request withdrawals
     * @param index The index in the queue
     * @return The market ID at the given index
     */
    function withdrawQueue(uint256 index) external view returns (IMorphoBlue.Id);

    /**
     * @notice Updates the supply cap for a market
     * @param marketParams The market parameters
     * @param newSupplyCap The new maximum amount of assets that can be allocated to this market
     */
    function submitCap(IMorphoBlue.MarketParams memory marketParams, uint256 newSupplyCap) external;

    /**
     * @notice Sets the supply queue order for allocating deposits
     * @param newSupplyQueue The new ordered list of market IDs to supply into
     */
    function setSupplyQueue(IMorphoBlue.Id[] calldata newSupplyQueue) external;

    /**
     * @notice Updates the withdraw queue order
     * @param indexes The indexes of each market in the previous withdraw queue, in the new order
     */
    function updateWithdrawQueue(uint256[] calldata indexes) external;

    /**
     * @notice Reallocates the vault's liquidity across markets
     * @param allocations Array of market allocations with target asset amounts
     */
    function reallocate(MarketAllocation[] calldata allocations) external;
} 