// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IPolygonZkEVMTimelock
 * @notice Interface for the PolygonZkEVMTimelock contract which manages governance actions with time delays
 * @custom:tatara 0xdbC6981a11fc2B000c635bFA7C47676b25C87D39
 * @custom:tags agglayer,polygon,governance,timelock,zkevm
 */
interface IPolygonZkEVMTimelock {
    /**
     * @notice Emitted when a new operation is scheduled
     * @param operationId Unique identifier of the operation
     * @param predecessor Optional dependency before execution
     * @param target Contract address for the operation
     * @param value ETH value to send
     * @param data Function call data
     * @param delay Execution delay in seconds
     */
    event OperationScheduled(
        bytes32 indexed operationId,
        bytes32 indexed predecessor,
        address target,
        uint256 value,
        bytes data,
        uint256 delay
    );

    /**
     * @notice Emitted when an operation becomes ready for execution
     * @param operationId Unique identifier of the operation
     * @param index Index of the operation in the ready queue
     */
    event OperationReady(bytes32 indexed operationId, uint256 indexed index);

    /**
     * @notice Emitted when an operation is executed
     * @param operationId Unique identifier of the operation
     * @param target Contract address for the operation
     * @param value ETH value sent
     * @param data Function call data
     * @param timestamp Execution timestamp
     */
    event OperationExecuted(
        bytes32 indexed operationId,
        address target,
        uint256 value,
        bytes data,
        uint256 timestamp
    );

    /**
     * @notice Emitted when an operation is cancelled
     * @param operationId Unique identifier of the operation
     */
    event OperationCancelled(bytes32 indexed operationId);

    /**
     * @notice Emitted when the minimum delay is changed
     * @param oldDelay Previous minimum delay
     * @param newDelay New minimum delay
     */
    event MinDelayChange(uint256 oldDelay, uint256 newDelay);

    /**
     * @notice Initialize the timelock with required parameters
     * @param minDelay Minimum delay for operations
     * @param admin Address of the admin
     * @param proposers Array of addresses that can propose operations
     * @param executors Array of addresses that can execute operations
     */
    function initialize(
        uint256 minDelay,
        address admin,
        address[] memory proposers,
        address[] memory executors
    ) external;

    /**
     * @notice Schedule an operation with a delay
     * @param target Contract address for the operation
     * @param value ETH value to send
     * @param data Function call data
     * @param predecessor Optional dependency before execution
     * @param salt Random value to allow having multiple operations with same parameters
     * @param delay Execution delay in seconds
     * @return operationId Unique identifier of the scheduled operation
     */
    function schedule(
        address target,
        uint256 value,
        bytes calldata data,
        bytes32 predecessor,
        bytes32 salt,
        uint256 delay
    ) external returns (bytes32 operationId);

    /**
     * @notice Schedule a batch of operations with a delay
     * @param targets Array of contract addresses for the operations
     * @param values Array of ETH values to send
     * @param datas Array of function call data
     * @param predecessor Optional dependency before execution
     * @param salt Random value to allow having multiple operations with same parameters
     * @param delay Execution delay in seconds
     * @return operationId Unique identifier of the scheduled batch operation
     */
    function scheduleBatch(
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas,
        bytes32 predecessor,
        bytes32 salt,
        uint256 delay
    ) external returns (bytes32 operationId);

    /**
     * @notice Cancel a scheduled operation
     * @param operationId Unique identifier of the operation
     */
    function cancel(bytes32 operationId) external;

    /**
     * @notice Execute a scheduled operation
     * @param target Contract address for the operation
     * @param value ETH value to send
     * @param data Function call data
     * @param predecessor Optional dependency before execution
     * @param salt Random value that was used when scheduling
     * @return result Return data from the execution
     */
    function execute(
        address target,
        uint256 value,
        bytes calldata data,
        bytes32 predecessor,
        bytes32 salt
    ) external payable returns (bytes memory result);

    /**
     * @notice Execute a scheduled batch operation
     * @param targets Array of contract addresses for the operations
     * @param values Array of ETH values to send
     * @param datas Array of function call data
     * @param predecessor Optional dependency before execution
     * @param salt Random value that was used when scheduling
     * @return results Array of return data from each execution
     */
    function executeBatch(
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas,
        bytes32 predecessor,
        bytes32 salt
    ) external payable returns (bytes[] memory results);

    /**
     * @notice Update the minimum delay for operations
     * @param newDelay New minimum delay in seconds
     */
    function updateDelay(uint256 newDelay) external;

    /**
     * @notice Returns an operation state
     * @param operationId Unique identifier of the operation
     * @return The current state of the operation (0=unknown, 1=pending, 2=ready, 3=done)
     */
    function getOperationState(bytes32 operationId) external view returns (uint8);

    /**
     * @notice Returns whether an operation is pending
     * @param operationId Unique identifier of the operation
     * @return True if the operation is pending
     */
    function isOperationPending(bytes32 operationId) external view returns (bool);

    /**
     * @notice Returns whether an operation is ready for execution
     * @param operationId Unique identifier of the operation
     * @return True if the operation is ready
     */
    function isOperationReady(bytes32 operationId) external view returns (bool);

    /**
     * @notice Returns whether an operation has been executed
     * @param operationId Unique identifier of the operation
     * @return True if the operation has been executed
     */
    function isOperationDone(bytes32 operationId) external view returns (bool);

    /**
     * @notice Returns the timestamp when an operation becomes ready for execution
     * @param operationId Unique identifier of the operation
     * @return The timestamp when the operation is ready (0 if none)
     */
    function getTimestamp(bytes32 operationId) external view returns (uint256);

    /**
     * @notice Returns the minimum delay for operations
     * @return The minimum delay in seconds
     */
    function getMinDelay() external view returns (uint256);

    /**
     * @notice Generates the operation ID for a single call operation
     * @param target Contract address for the operation
     * @param value ETH value to send
     * @param data Function call data
     * @param predecessor Optional dependency before execution
     * @param salt Random value to allow having multiple operations with same parameters
     * @return The operation ID
     */
    function hashOperation(
        address target,
        uint256 value,
        bytes calldata data,
        bytes32 predecessor,
        bytes32 salt
    ) external pure returns (bytes32);

    /**
     * @notice Generates the operation ID for a batch operation
     * @param targets Array of contract addresses for the operations
     * @param values Array of ETH values to send
     * @param datas Array of function call data
     * @param predecessor Optional dependency before execution
     * @param salt Random value to allow having multiple operations with same parameters
     * @return The operation ID
     */
    function hashOperationBatch(
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas,
        bytes32 predecessor,
        bytes32 salt
    ) external pure returns (bytes32);

    /**
     * @notice Returns whether an address has proposal permissions
     * @param account Address to check
     * @return True if the account can propose operations
     */
    function isProposer(address account) external view returns (bool);

    /**
     * @notice Returns whether an address has execution permissions
     * @param account Address to check
     * @return True if the account can execute operations
     */
    function isExecutor(address account) external view returns (bool);

    /**
     * @notice Grants proposal permissions to an account
     * @param account Address to grant permissions
     */
    function grantProposer(address account) external;

    /**
     * @notice Revokes proposal permissions from an account
     * @param account Address to revoke permissions
     */
    function revokeProposer(address account) external;

    /**
     * @notice Grants execution permissions to an account
     * @param account Address to grant permissions
     */
    function grantExecutor(address account) external;

    /**
     * @notice Revokes execution permissions from an account
     * @param account Address to revoke permissions
     */
    function revokeExecutor(address account) external;

    /**
     * @notice Renounces proposal permissions for the caller
     */
    function renounceProposer() external;

    /**
     * @notice Renounces execution permissions for the caller
     */
    function renounceExecutor() external;
} 