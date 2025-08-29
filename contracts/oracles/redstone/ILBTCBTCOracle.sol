// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title ILBTCBTCOracle
 * @notice Interface for LBTC/BTC RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xb9D0073aCb296719C26a8BF156e4b599174fe1d5
 * @custom:tags oracle,redstone,price-feed,lbtc,btc
 */
interface ILBTCBTCOracle is IRedstoneAggregator {

}