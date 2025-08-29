// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ISushiRouter.sol";

/**
 * @title ISafeExecutor
 * @notice Interface for the SafeExecutor contract used by SushiRouter
 * @dev This contract executes swap operations without having token approvals,
 *      making it safer for interacting with other contracts
 */
interface ISafeExecutor {
    /**
     * @notice Execute a call to the specified executor address
     * @dev Forwards the call to the executor and bubbles up any revert
     * @param executor The address of the executor contract
     * @param executorData The calldata to send to the executor
     */
    function execute(
        address executor,
        bytes calldata executorData
    ) external payable;

    /**
     * @notice Execute multiple calls in sequence
     * @dev Forwards calls to multiple executors and bubbles up any revert
     * @param executors Array of executor details (address, value, and calldata)
     */
    function executeMultiple(
        ISushiRouter.Executor[] calldata executors
    ) external payable;
} 