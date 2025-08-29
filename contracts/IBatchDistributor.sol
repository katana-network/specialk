// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

/**
 * @title IBatchDistributor
 * @dev Interface for the native and ERC-20 token batch distribution contract
 * @notice Allows gas-efficient distribution of ETH and ERC-20 tokens to multiple recipients in one transaction
 * @custom:tatara 0x36C38895A20c835F9A6A294821D669995eB2265E
 * @custom:katana 0x66C0499B1Df146dbaf4B1DEa1df436ba26DAfF21
 * @custom:bokuto 0x2A6fd05d3C6A373FBb073dea12bCee7C174AE606
 * @custom:tags utility,batch,distribution,erc20
 */
interface IBatchDistributor {
    /**
     * @dev Transaction struct for the recipient and amount data
     */
    struct Transaction {
        address payable recipient;
        uint256 amount;
    }

    /**
     * @dev Batch struct containing an array of transactions
     */
    struct Batch {
        Transaction[] txns;
    }

    /**
     * @dev Error thrown when an ETH transfer fails
     * @param emitter The contract that emitted the error
     */
    error EtherTransferFail(address emitter);

    /**
     * @notice Distributes ETH to multiple recipients in a single transaction
     * @dev Any excess ETH is refunded to the sender
     * @param batch A struct containing an array of recipient/amount pairs
     */
    function distributeEther(Batch calldata batch) external payable;

    /**
     * @notice Distributes ERC-20 tokens to multiple recipients in a single transaction
     * @dev Optimized to save gas by batching transfers
     * @param token The ERC-20 token contract address
     * @param batch A struct containing an array of recipient/amount pairs
     */
    function distributeToken(IERC20 token, Batch calldata batch) external;
} 