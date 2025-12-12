// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ISenderCreator Interface (v0.6.0)
 * @notice Helper contract for creating sender accounts
 * @dev Used by the EntryPoint to deploy new accounts using the "initCode"
 * @custom:tags account-abstraction,erc4337,creator,v0.6.0
 */
interface ISenderCreator {
    /**
     * @dev Create a sender account using provided initialization code
     * @param initCode Initialization code for the new account
     * @return sender The address of the created account
     */
    function createSender(bytes calldata initCode) external returns (address sender);
} 