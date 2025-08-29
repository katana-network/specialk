// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IBundler3
 * @notice Interface for the Bundler3 contract, which enables batching multiple calls in a single transaction
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tatara 0xD0bDf3E62F6750Bd83A50b4001743898Af287009
 * @custom:tags morpho,bundler,batch,utility
 */
interface IBundler3 {
    /**
     * @notice Struct containing all the data needed to make a call
     * @param to The call target address
     * @param data The calldata to execute
     * @param value The ETH value to send with the call
     * @param skipRevert If true, other planned calls will continue executing even if this call reverts
     * @param callbackHash The hash of the reenter bundle data (if a callback is expected)
     */
    struct Call {
        address to;
        bytes data;
        uint256 value;
        bool skipRevert;
        bytes32 callbackHash;
    }

    /**
     * @notice Executes a sequence of calls in order
     * @dev Locks the initiator for the duration of the multicall
     * @param bundle The ordered array of calls to execute
     */
    function multicall(Call[] calldata bundle) external payable;

    /**
     * @notice Executes a sequence of calls during a callback
     * @dev Can only be called by the last unreturned callee with known data
     * @param bundle The ordered array of calls to execute
     */
    function reenter(Call[] calldata bundle) external;

    /**
     * @notice Returns the hash used to authorize reentry
     * @return The current reenter hash
     */
    function reenterHash() external view returns (bytes32);

    /**
     * @notice Returns the address that initiated the current multicall
     * @return The address of the multicall initiator
     */
    function initiator() external view returns (address);
} 