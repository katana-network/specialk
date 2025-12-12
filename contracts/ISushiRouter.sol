// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

/**
 * @title ISushiRouter
 * @notice Interface for SushiSwap's router contract
 * @dev Provides functions for swapping tokens through SushiSwap's liquidity pools
 * @custom:bokuto 0xAC4c6e212A361c968F1725b4d055b47E63F80b75
 * @dev The address 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE is used to represent the native token (ETH)
 * @custom:tags sushi,defi,amm,router,swap
 */
interface ISushiRouter {
    /**
     * @notice Error thrown when output amount is less than the minimum required
     * @param tokenOut The address of the output token
     * @param amountOut The actual output amount
     */
    error MinimalOutputBalanceViolation(address tokenOut, uint256 amountOut);

    /**
     * @notice Input token structure for multi-swap operations
     * @param token The input token
     * @param amountIn The amount to transfer (0 means use all available balance minus 1)
     * @param transferTo The address to transfer tokens to
     */
    struct InputToken {
        IERC20 token;
        uint256 amountIn;
        address transferTo;
    }

    /**
     * @notice Output token structure for multi-swap operations
     * @param token The output token
     * @param recipient The recipient of the output tokens
     * @param amountOutMin The minimum amount of output tokens required
     */
    struct OutputToken {
        IERC20 token;
        address recipient;
        uint256 amountOutMin;
    }

    /**
     * @notice Executor structure for swap operations
     * @param executor The address of the executor contract
     * @param value The amount of ETH to send
     * @param data The calldata to send to the executor
     */
    struct Executor {
        address executor;
        uint256 value;
        bytes data;
    }

    /**
     * @notice Swaps one token for another using SushiSwap
     * @dev If tokenIn is the native token (0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE), use amountIn of 0 and include the value in msg.value
     * @param tokenIn The input token
     * @param amountIn The amount of input tokens to swap (0 means use all available balance minus 1)
     * @param recipient The recipient of the output tokens
     * @param tokenOut The output token
     * @param amountOutMin The minimum amount of output tokens required
     * @param executor The address of the executor contract
     * @param executorData The calldata to send to the executor
     * @return amountOut The amount of output tokens received
     */
    function snwap(
        IERC20 tokenIn,
        uint256 amountIn,
        address recipient,
        IERC20 tokenOut,
        uint256 amountOutMin,
        address executor,
        bytes calldata executorData
    ) external payable returns (uint256 amountOut);

    /**
     * @notice Swaps multiple tokens using SushiSwap in a batch
     * @dev Can execute multiple swaps in a single transaction
     * @param inputTokens Array of input tokens with their amounts
     * @param outputTokens Array of output tokens with their minimum amounts
     * @param executors Array of executors to handle the swaps
     * @return amountOut Array of output amounts received
     */
    function snwapMultiple(
        InputToken[] calldata inputTokens,
        OutputToken[] calldata outputTokens,
        Executor[] calldata executors
    ) external payable returns (uint256[] memory amountOut);
} 