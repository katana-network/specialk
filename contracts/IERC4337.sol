// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IERC4337 Common Interfaces
 * @notice Shared types and interfaces for ERC-4337 Account Abstraction standard
 * @dev These interfaces are common between v0.6.0 and v0.7.0 versions
 * @custom:tags account-abstraction,erc4337,standard
 */

/**
 * @dev Validates user operations and handles their execution
 * @notice This interface defines common types used in ERC-4337
 */
interface IERC4337Common {
    /**
     * @dev Emitted when an account has been successfully deployed
     * @param userOpHash The hash of the user operation that deployed the account
     * @param sender The address of the deployed account
     * @param factory The factory that deployed the account
     * @param paymaster The paymaster used for this deployment
     */
    event AccountDeployed(bytes32 indexed userOpHash, address indexed sender, address factory, address paymaster);
    
    /**
     * @dev Emitted after each successful user operation
     * @param userOpHash The hash of the user operation
     * @param sender The sender account
     * @param paymaster The paying account (if different from sender)
     * @param nonce The nonce of the transaction
     * @param success Whether the operation succeeded
     * @param actualGasCost The gas cost of the operation
     * @param actualGasUsed The gas used by the operation
     */
    event UserOperationEvent(bytes32 indexed userOpHash, address indexed sender, address indexed paymaster, uint256 nonce, bool success, uint256 actualGasCost, uint256 actualGasUsed);
    
    /**
     * @dev Emitted when a user operation reverts with reason
     * @param userOpHash The hash of the user operation
     * @param sender The sender account
     * @param nonce The nonce of the transaction
     * @param revertReason The reason for reversion
     */
    event UserOperationRevertReason(bytes32 indexed userOpHash, address indexed sender, uint256 nonce, bytes revertReason);
    
    /**
     * @dev Emitted before execution of a batch of operations
     */
    event BeforeExecution();
    
    /**
     * @dev Emitted when signature aggregator is changed
     * @param aggregator The address of the new aggregator
     */
    event SignatureAggregatorChanged(address indexed aggregator);
    
    /**
     * @dev Error thrown when an operation fails
     * @param opIndex Index of the failed operation
     * @param reason Reason for the failure
     */
    error FailedOp(uint256 opIndex, string reason);
    
    /**
     * @dev Error thrown when signature validation fails
     * @param aggregator The address of the aggregator that failed
     */
    error SignatureValidationFailed(address aggregator);
    
    /**
     * @dev Structure for returning validation results
     * @param returnInfo Gas and time-range returned values
     * @param senderInfo Stake information about the sender
     * @param factoryInfo Stake information about the factory
     * @param paymasterInfo Stake information about the paymaster
     */
    error ValidationResult(ReturnInfo returnInfo, StakeInfo senderInfo, StakeInfo factoryInfo, StakeInfo paymasterInfo);
    
    /**
     * @dev Structure for returning validation results with aggregation
     * @param returnInfo Gas and time-range returned values
     * @param senderInfo Stake information about the sender
     * @param factoryInfo Stake information about the factory
     * @param paymasterInfo Stake information about the paymaster 
     * @param aggregatorInfo Signature aggregation info
     */
    error ValidationResultWithAggregation(ReturnInfo returnInfo, StakeInfo senderInfo, StakeInfo factoryInfo, StakeInfo paymasterInfo, AggregatorStakeInfo aggregatorInfo);
    
    /**
     * @dev Result of sender address calculation
     * @param sender The calculated sender address
     */
    error SenderAddressResult(address sender);
    
    /**
     * @dev Result of simulation execution
     * @param preOpGas Gas used before the operation
     * @param paid Amount paid
     * @param validAfter Timestamp from which the operation is valid
     * @param validUntil Timestamp until which the operation is valid
     * @param targetSuccess Whether the target call succeeded
     * @param targetResult The result of the target call
     */
    error ExecutionResult(uint256 preOpGas, uint256 paid, uint48 validAfter, uint48 validUntil, bool targetSuccess, bytes targetResult);

    /**
     * @dev Gas and return values during simulation
     * @param preOpGas Gas consumed in validation
     * @param prefund Required prefund amount
     * @param sigFailed Whether signature validation failed
     * @param validAfter Timestamp from which the operation is valid
     * @param validUntil Timestamp until which the operation is valid
     * @param paymasterContext Context from paymaster validation
     */
    struct ReturnInfo {
        uint256 preOpGas;
        uint256 prefund;
        bool sigFailed;
        uint48 validAfter;
        uint48 validUntil;
        bytes paymasterContext;
    }

    /**
     * @dev Stake information
     * @param stake Amount staked
     * @param unstakeDelaySec Delay for unstaking
     */
    struct StakeInfo {
        uint256 stake;
        uint256 unstakeDelaySec;
    }

    /**
     * @dev Aggregator stake information
     * @param aggregator The aggregator address
     * @param stakeInfo The stake information
     */
    struct AggregatorStakeInfo {
        address aggregator;
        StakeInfo stakeInfo;
    }
}

/**
 * @title IStakeManager Interface
 * @notice Manages deposits and stakes for ERC-4337 entities
 * @custom:component Common component for both v0.6.0 and v0.7.0
 */
interface IStakeManager {
    /**
     * @dev Emitted when funds are deposited
     * @param account Account that received deposit
     * @param totalDeposit New total deposit for the account
     */
    event Deposited(address indexed account, uint256 totalDeposit);

    /**
     * @dev Emitted when funds are withdrawn
     * @param account Account that withdrew funds
     * @param withdrawAddress Address receiving the funds
     * @param amount Amount withdrawn
     */
    event Withdrawn(address indexed account, address withdrawAddress, uint256 amount);

    /**
     * @dev Emitted when stake or unstake delay are modified
     * @param account Account that locked stake
     * @param totalStaked Amount staked
     * @param unstakeDelaySec Unstake delay in seconds
     */
    event StakeLocked(address indexed account, uint256 totalStaked, uint256 unstakeDelaySec);

    /**
     * @dev Emitted once a stake is scheduled for withdrawal
     * @param account Account that unlocked stake
     * @param withdrawTime Time when the stake can be withdrawn
     */
    event StakeUnlocked(address indexed account, uint256 withdrawTime);

    /**
     * @dev Emitted when stake is withdrawn
     * @param account Account that withdrew stake
     * @param withdrawAddress Address receiving the stake
     * @param amount Amount withdrawn
     */
    event StakeWithdrawn(address indexed account, address withdrawAddress, uint256 amount);

    /**
     * @dev Deposit info for an account
     * @param deposit The entity's deposit
     * @param staked Whether the entity is staked
     * @param stake Amount of staked ether
     * @param unstakeDelaySec Minimum delay for unstaking
     * @param withdrawTime First timestamp when withdrawStake can be called
     */
    struct DepositInfo {
        uint112 deposit;
        bool staked;
        uint112 stake;
        uint32 unstakeDelaySec;
        uint48 withdrawTime;
    }

    /**
     * @dev Get deposit info for an account
     * @param account The account to query
     * @return info Full deposit information
     */
    function getDepositInfo(address account) external view returns (DepositInfo memory info);

    /**
     * @dev Get account balance
     * @param account The account to query
     * @return The deposit amount for the account
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Add to the deposit of an account
     * @param account The account to add funds to
     */
    function depositTo(address account) external payable;

    /**
     * @dev Add stake and set unstake delay
     * @param _unstakeDelaySec New unstake delay period
     */
    function addStake(uint32 _unstakeDelaySec) external payable;

    /**
     * @dev Request to unlock the stake
     * @notice Stake can be withdrawn after unstake delay
     */
    function unlockStake() external;

    /**
     * @dev Withdraw stake to an address
     * @param withdrawAddress Address to receive the stake
     */
    function withdrawStake(address payable withdrawAddress) external;

    /**
     * @dev Withdraw deposit to an address
     * @param withdrawAddress Address to receive the funds
     * @param withdrawAmount Amount to withdraw
     */
    function withdrawTo(address payable withdrawAddress, uint256 withdrawAmount) external;
}

/**
 * @title INonceManager Interface
 * @notice Manages nonces for ERC-4337 accounts
 * @custom:component Common component for both v0.6.0 and v0.7.0
 */
interface INonceManager {
    /**
     * @dev Get the next nonce for an account
     * @param sender The account address
     * @param key The nonce key (high 192 bits)
     * @return nonce Full nonce to use in the next UserOp
     */
    function getNonce(address sender, uint192 key) external view returns (uint256 nonce);

    /**
     * @dev Manually increment account nonce
     * @param key The nonce key
     */
    function incrementNonce(uint192 key) external;
} 