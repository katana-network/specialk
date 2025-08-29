// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IBTCUSDOracle
 * @notice Interface for BTC/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xb67047eDF6204F4C81333248dA71F8387050790C
 * @custom:tags oracle,redstone,price-feed,btc,usd
 */
interface IBTCUSDOracle is IRedstoneAggregator {

}