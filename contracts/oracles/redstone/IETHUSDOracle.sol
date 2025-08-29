// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IETHUSDOracle
 * @notice Interface for ETH/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xE94c9f9A1893f23be38A5C0394E46Ac05e8a5f8C
 * @custom:tags oracle,redstone,price-feed,eth,usd
 */
interface IETHUSDOracle is IRedstoneAggregator {

}