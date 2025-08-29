// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMorphoBlue.sol";
import "./IMetaMorpho.sol";

/**
 * @title IPublicAllocator
 * @notice Interface for PublicAllocator, which enables permissionless reallocation of MetaMorpho vaults
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tatara 0x8FfD3815919081bDb60CD8079C68444331B65042
 * @custom:tags morpho,defi,allocator,liquidity
 */
interface IPublicAllocator {
    /**
     * @notice Maximum settable flow cap, ensuring caps can always be stored on 128 bits
     * @dev The actual max possible flow cap is type(uint128).max-1
     * @return The maximum settable flow cap value
     */
    function MAX_SETTABLE_FLOW_CAP() external pure returns (uint128);

    /**
     * @notice Defines maximum allowed inflow and outflow for a market
     * @param maxIn The maximum allowed inflow in a market
     * @param maxOut The maximum allowed outflow in a market
     */
    struct FlowCaps {
        uint128 maxIn;
        uint128 maxOut;
    }

    /**
     * @notice Configuration for updating flow caps for a specific market
     * @param id Market ID for which to change flow caps
     * @param caps New flow caps for this market
     */
    struct FlowCapsConfig {
        IMorphoBlue.Id id;
        FlowCaps caps;
    }

    /**
     * @notice Defines a withdrawal from a specific market
     * @param marketParams The market parameters from which to withdraw
     * @param amount The amount to withdraw
     */
    struct Withdrawal {
        IMorphoBlue.MarketParams marketParams;
        uint128 amount;
    }

    /**
     * @notice The Morpho Blue contract
     * @return The Morpho contract address
     */
    function MORPHO() external view returns (address);

    /**
     * @notice Returns the admin for a given vault
     * @param vault The MetaMorpho vault
     * @return The admin address for the vault
     */
    function admin(address vault) external view returns (address);

    /**
     * @notice Returns the current ETH fee for a given vault
     * @param vault The MetaMorpho vault
     * @return The fee amount in ETH
     */
    function fee(address vault) external view returns (uint256);

    /**
     * @notice Returns the accrued ETH fee for a given vault
     * @param vault The MetaMorpho vault
     * @return The accrued fee amount in ETH
     */
    function accruedFee(address vault) external view returns (uint256);

    /**
     * @notice Returns the maximum inflow and outflow for a given market in a vault
     * @param vault The MetaMorpho vault
     * @param id The market identifier
     * @return Flow caps for the specified market
     */
    function flowCaps(address vault, IMorphoBlue.Id id) external view returns (FlowCaps memory);

    /**
     * @notice Reallocates funds from multiple markets to one target market
     * @dev Requires payment of the vault's fee
     * @dev Validates that flow caps are respected and market parameters are valid
     * @param vault The MetaMorpho vault to reallocate
     * @param withdrawals The markets to withdraw from and the amounts to withdraw
     * @param supplyMarketParams The market to supply the withdrawn funds to
     */
    function reallocateTo(
        address vault, 
        Withdrawal[] calldata withdrawals, 
        IMorphoBlue.MarketParams calldata supplyMarketParams
    ) external payable;

    /**
     * @notice Sets the admin for a given vault
     * @param vault The MetaMorpho vault
     * @param newAdmin The new admin address
     */
    function setAdmin(address vault, address newAdmin) external;

    /**
     * @notice Sets the fee for a given vault
     * @param vault The MetaMorpho vault
     * @param newFee The new fee amount in ETH
     */
    function setFee(address vault, uint256 newFee) external;

    /**
     * @notice Sets the maximum inflow and outflow through public allocation for markets
     * @param vault The MetaMorpho vault
     * @param config Array of market IDs and their flow cap configurations
     */
    function setFlowCaps(address vault, FlowCapsConfig[] calldata config) external;

    /**
     * @notice Transfers the accrued fees to a recipient
     * @param vault The MetaMorpho vault
     * @param feeRecipient The address to receive the fees
     */
    function transferFee(address vault, address payable feeRecipient) external;

    /**
     * @notice Emitted when a new admin is set for a vault
     * @param sender The address that set the admin
     * @param vault The MetaMorpho vault
     * @param newAdmin The new admin address
     */
    event SetAdmin(address indexed sender, address indexed vault, address indexed newAdmin);

    /**
     * @notice Emitted when a new fee is set for a vault
     * @param sender The address that set the fee
     * @param vault The MetaMorpho vault
     * @param newFee The new fee amount
     */
    event SetFee(address indexed sender, address indexed vault, uint256 newFee);

    /**
     * @notice Emitted when flow caps are set for markets
     * @param sender The address that set the flow caps
     * @param vault The MetaMorpho vault
     * @param config The flow cap configurations
     */
    event SetFlowCaps(address indexed sender, address indexed vault, FlowCapsConfig[] config);

    /**
     * @notice Emitted when fees are transferred
     * @param sender The address that initiated the transfer
     * @param vault The MetaMorpho vault
     * @param amount The amount transferred
     * @param recipient The recipient of the fees
     */
    event TransferFee(address indexed sender, address indexed vault, uint256 amount, address indexed recipient);

    /**
     * @notice Emitted when a withdrawal is performed during reallocation
     * @param sender The address that performed the reallocation
     * @param vault The MetaMorpho vault
     * @param marketId The market ID from which funds were withdrawn
     * @param amount The amount withdrawn
     */
    event PublicWithdrawal(address indexed sender, address indexed vault, IMorphoBlue.Id indexed marketId, uint128 amount);

    /**
     * @notice Emitted when a reallocation is completed
     * @param sender The address that performed the reallocation
     * @param vault The MetaMorpho vault
     * @param marketId The market ID to which funds were supplied
     * @param amount The total amount reallocated
     */
    event PublicReallocateTo(address indexed sender, address indexed vault, IMorphoBlue.Id indexed marketId, uint128 amount);
} 