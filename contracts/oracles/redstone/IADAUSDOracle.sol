// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IADAUSDOracle
 * @notice Interface for ADA/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xf1454949C6dEdfb500ae63Aa6c784Aa1Dde08A6c
 * @custom:tags oracle,redstone,price-feed,ada,usd
 */
interface IADAUSDOracle is IRedstoneAggregator {

}