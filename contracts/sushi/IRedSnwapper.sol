// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title IRedSnwapper
 * @notice Interface for Sushi'sRedSnwapper
 * @dev RedSnwapper is a facade for the execution router contracts (RouteProcessor), and handles single & multi token swaps.
 * @custom:katana 0xAC4c6e212A361c968F1725b4d055b47E63F80b75
 * @custom:tags sushi,swap,dex,defi
 */
interface IRedSnwapper {
    error MinimalOutputBalanceViolation(address tokenOut, uint256 amountOut);

    function safeExecutor() external view returns (address);

    function snwap(
        address tokenIn,
        uint256 amountIn,
        address recipient,
        address tokenOut,
        uint256 amountOutMin,
        address executor,
        bytes memory executorData
    ) external payable returns (uint256 amountOut);

    function snwapMultiple(
        InputToken[] memory inputTokens,
        OutputToken[] memory outputTokens,
        Executor[] memory executors
    ) external payable returns (uint256[] memory amountOut);
}

struct InputToken {
    address token;
    uint256 amountIn;
    address transferTo;
}

struct OutputToken {
    address token;
    address recipient;
    uint256 amountOutMin;
}

struct Executor {
    address executor;
    uint256 value;
    bytes data;
}