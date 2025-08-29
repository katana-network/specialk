// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IMultiSend
 * @dev Interface for the MultiSend contract on Katana
 * @notice This contract allows batching multiple transactions into a single transaction
 * @custom:tatara 0x998739BFdAAdde7C933B942a68053933098f9EDa
 */
interface IMultiSend {
    /**
     * @dev Sends multiple transactions and reverts all if one fails
     * @param transactions Encoded batch of transactions
     * @notice The format for the transactions bytes is:
     * (operation, to, value, data.length, data)+
     * where:
     *   - operation: 0 = call, 1 = delegatecall
     *   - to: target address
     *   - value: ether value
     *   - data.length: length of the data
     *   - data: call data
     */
    function multiSend(bytes memory transactions) external payable;
} 