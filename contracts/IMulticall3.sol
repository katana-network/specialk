// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IMulticall3
 * @dev Interface for Multicall3 contract on Katana
 * @notice Allows batching multiple read-only calls into a single transaction
 * @custom:bokuto 0xcA11bde05977b3631167028862bE2a173976CA11
 * @custom:tags utility,multicall,batch
 */
interface IMulticall3 {
    struct Call {
        address target;
        bytes callData;
    }

    struct Call3 {
        address target;
        bool allowFailure;
        bytes callData;
    }

    struct Call3Value {
        address target;
        bool allowFailure;
        uint256 value;
        bytes callData;
    }

    struct Result {
        bool success;
        bytes returnData;
    }

    /**
     * @notice Aggregates results from multiple contract calls (Multicall1 compatible)
     * @param calls An array of Call structs
     * @return blockNumber The block number where the calls were executed
     * @return returnData An array of bytes containing the responses
     */
    function aggregate(Call[] calldata calls) external payable returns (uint256 blockNumber, bytes[] memory returnData);

    /**
     * @notice Aggregates calls without requiring all to succeed (Multicall2 compatible)
     * @param requireSuccess If true, require all calls to succeed
     * @param calls An array of Call structs
     * @return returnData An array of Result structs
     */
    function tryAggregate(bool requireSuccess, Call[] calldata calls) external payable returns (Result[] memory returnData);

    /**
     * @notice Aggregates calls with block info (Multicall2 compatible)
     * @param requireSuccess If true, require all calls to succeed
     * @param calls An array of Call structs
     * @return blockNumber The block number where the calls were executed
     * @return blockHash The hash of the block where the calls were executed
     * @return returnData An array of Result structs
     */
    function tryBlockAndAggregate(bool requireSuccess, Call[] calldata calls) external payable returns (
        uint256 blockNumber,
        bytes32 blockHash,
        Result[] memory returnData
    );

    /**
     * @notice Aggregates calls with block info, requiring all to succeed (Multicall2 compatible)
     * @param calls An array of Call structs
     * @return blockNumber The block number where the calls were executed
     * @return blockHash The hash of the block where the calls were executed
     * @return returnData An array of Result structs
     */
    function blockAndAggregate(Call[] calldata calls) external payable returns (
        uint256 blockNumber,
        bytes32 blockHash,
        Result[] memory returnData
    );

    /**
     * @notice Aggregates calls with per-call failure flags (Multicall3 specific)
     * @param calls An array of Call3 structs
     * @return returnData An array of Result structs
     */
    function aggregate3(Call3[] calldata calls) external payable returns (Result[] memory returnData);

    /**
     * @notice Aggregates calls with ETH value and per-call failure flags (Multicall3 specific)
     * @param calls An array of Call3Value structs
     * @return returnData An array of Result structs
     */
    function aggregate3Value(Call3Value[] calldata calls) external payable returns (Result[] memory returnData);

    /**
     * @notice Returns the block hash for a given block number
     * @param blockNumber The block number
     * @return blockHash The block hash
     */
    function getBlockHash(uint256 blockNumber) external view returns (bytes32 blockHash);

    /**
     * @notice Returns the current block number
     * @return blockNumber The block number
     */
    function getBlockNumber() external view returns (uint256 blockNumber);

    /**
     * @notice Returns the current block's coinbase address
     * @return coinbase The coinbase address
     */
    function getCurrentBlockCoinbase() external view returns (address coinbase);

    /**
     * @notice Returns the current block's difficulty
     * @return difficulty The block difficulty
     */
    function getCurrentBlockDifficulty() external view returns (uint256 difficulty);

    /**
     * @notice Returns the current block's gas limit
     * @return gaslimit The gas limit
     */
    function getCurrentBlockGasLimit() external view returns (uint256 gaslimit);

    /**
     * @notice Returns the current block's timestamp
     * @return timestamp The timestamp
     */
    function getCurrentBlockTimestamp() external view returns (uint256 timestamp);

    /**
     * @notice Returns the ETH balance of a given address
     * @param addr The address to check
     * @return balance The ETH balance
     */
    function getEthBalance(address addr) external view returns (uint256 balance);

    /**
     * @notice Returns the hash of the previous block
     * @return blockHash The block hash
     */
    function getLastBlockHash() external view returns (bytes32 blockHash);

    /**
     * @notice Returns the current block's base fee (EIP-1559)
     * @return basefee The base fee
     */
    function getBasefee() external view returns (uint256 basefee);

    /**
     * @notice Returns the current chain ID
     * @return chainid The chain ID
     */
    function getChainId() external view returns (uint256 chainid);
} 