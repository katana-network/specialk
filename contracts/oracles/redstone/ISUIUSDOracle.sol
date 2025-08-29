// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title ISUIUSDOracle
 * @notice Interface for SUI/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0x98ECE0D516f891a35278E3186772fb1545b274eB
 * @custom:tags oracle,redstone,price-feed,sui,usd
 */
interface ISUIUSDOracle is IRedstoneAggregator {

}