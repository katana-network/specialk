// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IwstETHUSDOracle
 * @notice Interface for wstETH/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xE23eCA12D7D2ED3829499556F6dCE06642AFd990
 * @custom:tags oracle,redstone,price-feed,wsteth,usd
 */
interface IwstETHUSDOracle is IRedstoneAggregator {

}