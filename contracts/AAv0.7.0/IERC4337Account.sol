// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ERC-4337 v0.7.0 Account Interface
 * @notice Interface for accounts that can be validated by the EntryPoint
 * @custom:tags account-abstraction,erc4337,account,v0.7.0
 */
interface IAccount {
    /**
     * @dev Validates a user operation signature and nonce
     * @notice The EntryPoint will call this method before executing the user operation
     * @param userOp The user operation to validate
     * @param userOpHash The hash of the user's request data
     * @param missingAccountFunds Missing funds that the account must provide to execute the op
     * @return validationData Packed validation data (first 20 bytes is validating contract, last 12 bytes is validUntil and validAfter)
     *    <20-byte> sigAuthorizer: 0 for valid signature, 1 for invalid signature, otherwise address of signature authorizer
     *    <6-byte> validUntil: last timestamp this operation is valid (0 for no expiry)
     *    <6-byte> validAfter: first timestamp this operation is valid
     */
    function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external returns (uint256 validationData);
}

/**
 * @dev Packed User Operation struct matching v0.7.0 EntryPoint
 * @notice More gas-efficient version of the UserOperation struct
 */
struct PackedUserOperation {
    address sender;
    uint256 nonce;
    bytes initCode;
    bytes callData;
    bytes32 accountGasLimits;
    uint256 preVerificationGas;
    bytes32 gasFees;
    bytes paymasterAndData;
    bytes signature;
} 