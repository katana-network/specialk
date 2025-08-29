// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IwstETHstETHOracle
 * @notice Interface for wstETH/stETH RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0x31a36CdF4465ba61ce78F5CDbA26FDF8ec361803
 * @custom:tags oracle,redstone,price-feed,wsteth,steth
 */
interface IwstETHstETHOracle is IRedstoneAggregator {

}