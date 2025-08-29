// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC4337.sol";
import "./IERC4337Account.sol";

/**
 * @title IEntryPoint v0.6.0
 * @notice Account-Abstraction (EIP-4337) singleton EntryPoint
 * @dev Only one instance required on each chain
 * @custom:tatara 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789
 * @custom:tags account-abstraction,erc4337,entrypoint,v0.6.0
 */
interface IEntryPoint is IStakeManager, INonceManager {
    /**
     * @notice UserOps grouped by aggregator
     */
    struct UserOpsPerAggregator {
        UserOperation[] userOps;
        // aggregator address
        IAggregator aggregator;
        // aggregated signature
        bytes signature;
    }

    /**
     * @dev Execute a batch of UserOperations
     * @param ops Operations to execute
     * @param beneficiary Address to receive fees
     */
    function handleOps(UserOperation[] calldata ops, address payable beneficiary) external;

    /**
     * @dev Execute a batch of UserOperation with Aggregators
     * @param opsPerAggregator Operations grouped by aggregator
     * @param beneficiary Address to receive fees
     */
    function handleAggregatedOps(
        UserOpsPerAggregator[] calldata opsPerAggregator,
        address payable beneficiary
    ) external;

    /**
     * @dev Generate a request ID for the operation
     * @param userOp The user operation
     * @return Request ID (hash)
     */
    function getUserOpHash(UserOperation calldata userOp) external view returns (bytes32);

    /**
     * @dev Simulate a call to account.validateUserOp and paymaster.validatePaymasterUserOp
     * @param userOp The user operation to validate
     * @dev This method always reverts to return validation result
     */
    function simulateValidation(UserOperation calldata userOp) external;

    /**
     * @dev Get counterfactual sender address
     * @param initCode The constructor code
     * @dev This method always reverts with sender address
     */
    function getSenderAddress(bytes memory initCode) external;

    /**
     * @dev Simulate full execution of a UserOperation
     * @param op The user operation to simulate
     * @param target If non-zero, the call target after simulation
     * @param targetCallData Call data for the target
     * @dev This method always reverts with ExecutionResult
     */
    function simulateHandleOp(
        UserOperation calldata op,
        address target,
        bytes calldata targetCallData
    ) external;
}

/**
 * @title IAggregator Interface (v0.6.0)
 * @notice Aggregated Signatures validator
 */
interface IAggregator {
    /**
     * @dev Validate aggregated signature
     * @param userOps Array of operations to validate
     * @param signature Aggregated signature
     */
    function validateSignatures(
        UserOperation[] calldata userOps,
        bytes calldata signature
    ) external view;

    /**
     * @dev Validate signature of a single userOp
     * @param userOp The operation to validate
     * @return sigForUserOp Signature to include in the userOp
     */
    function validateUserOpSignature(
        UserOperation calldata userOp
    ) external view returns (bytes memory sigForUserOp);

    /**
     * @dev Aggregate multiple signatures
     * @param userOps Array of operations to aggregate
     * @return aggregatedSignature The aggregated signature
     */
    function aggregateSignatures(
        UserOperation[] calldata userOps
    ) external view returns (bytes memory aggregatedSignature);
}

/**
 * @title IPaymaster Interface (v0.6.0)
 * @notice Paymaster interface for paying gas for user operations
 */
interface IPaymaster {
    /**
     * @dev Paymaster operation modes
     */
    enum PostOpMode {
        opSucceeded, // User op succeeded
        opReverted, // User op reverted
        postOpReverted // Post-operation handling reverted
    }

    /**
     * @dev Validate paymaster for user operation
     * @param userOp The user operation
     * @param userOpHash Hash of the user operation
     * @param maxCost Maximum cost of the transaction
     * @return context Context for post-operation
     * @return validationData Validation data (see IAccount for format)
     */
    function validatePaymasterUserOp(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) external returns (bytes memory context, uint256 validationData);

    /**
     * @dev Post-operation handler
     * @param mode Operation mode
     * @param context Context from validatePaymasterUserOp
     * @param actualGasCost Actual gas cost used so far
     */
    function postOp(
        PostOpMode mode,
        bytes calldata context,
        uint256 actualGasCost
    ) external;
} 