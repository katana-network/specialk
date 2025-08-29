// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IweETHUSDOracle
 * @notice Interface for weETH/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xDd87FD0FD6F68AcB6897d05fCf31F3AB1165a49F
 * @custom:tags oracle,redstone,price-feed,weeth,usd
 */
interface IweETHUSDOracle is IRedstoneAggregator {

}