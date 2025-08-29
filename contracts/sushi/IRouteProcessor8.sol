// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IRouteProcessor8
 * @notice Interface for Sushi's RouteProcessor8
 * @dev Processes the route generated off-chain. Includes an option to take a portion of any surplus.
 * @custom:katana 0x2905d7e4D048d29954F81b02171DD313F457a4a4
 * @custom:tags sushi,swap,dex,defi
 */
interface IRouteProcessor8 {
    /// @notice Emitted after a route is processed
    /// @param from The tx initiator
    /// @param to Recipient of the output tokens
    /// @param tokenIn Input token
    /// @param tokenOut Output token
    /// @param amountIn Total input amount routed
    /// @param amountOut Actual output amount received
    /// @param slippage Slippage captured during execution (if any)
    /// @param referralCode Referral code of the tx creator
    event Route(
        address indexed from,
        address to,
        address indexed tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOut,
        int256 slippage,
        uint32 indexed referralCode
    );

    /// @notice Process an off-chain generated route
    /// @return amountOut Actual amount of tokenOut received
    function processRoute(
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 amountOutQuote,
        address to,
        bytes calldata route,
        bool takeSurplus,
        uint32 referralCode
    ) external payable returns (uint256 amountOut);

    /// @notice Transfer a specified amount of input value to `transferValueTo` then process the route
    /// @return amountOut Actual amount of tokenOut received
    function processRouteWithTransferValueInput(
        address payable transferValueTo,
        uint256 amountValueTransfer,
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 amountOutQuote,
        address to,
        bytes calldata route,
        bool takeSurplus,
        uint32 referralCode
    ) external payable returns (uint256 amountOut);

    /// @notice Process the route and send `amountValueTransfer - fee` of output to `transferValueTo`
    /// @return amountOut Actual amount of tokenOut received
    function processRouteWithTransferValueOutput(
        address payable transferValueTo,
        uint256 amountValueTransfer,
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 amountOutQuote,
        address to,
        bytes calldata route,
        bool takeSurplus,
        uint32 referralCode
    ) external payable returns (uint256 amountOut);

    /// @notice Transfer a specified value to `transferValueTo` then process the route
    /// @dev Note the exact method name casing: transferValueAndprocessRoute (lowercase 'p' in process)
    /// @return amountOut Actual amount of tokenOut received
    function transferValueAndprocessRoute(
        address transferValueTo,
        uint256 amountValueTransfer,
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 amountOutQuote,
        address to,
        bytes calldata route,
        bool takeSurplus,
        uint32 referralCode
    ) external payable returns (uint256 amountOut);
}
