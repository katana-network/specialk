// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IMultiSendCallOnly
 * @dev Interface for the MultiSendCallOnly contract on Katana
 * @notice This contract allows batching multiple transactions into a single transaction, but only allows CALL operations (no delegatecall)
 * @custom:bokuto 0xA1dabEF33b3B82c7814B6D82A79e50F4AC44102B
 */
interface IMultiSendCallOnly {
    /**
     * @dev Sends multiple transactions and reverts all if one fails
     * @param transactions Encoded batch of transactions
     * @notice The format for the transactions bytes is:
     * (operation, to, value, data.length, data)+
     * where:
     *   - operation: must be 0 (call only, 1 for delegatecall will revert)
     *   - to: target address
     *   - value: ether value
     *   - data.length: length of the data
     *   - data: call data
     * @notice Unlike MultiSend, this function only allows normal calls (no delegatecall), making it safer for use with user wallets
     */
    function multiSend(bytes memory transactions) external payable;
} 