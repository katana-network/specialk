// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IXRPUSDOracle
 * @notice Interface for XRP/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xb4fe9028A4D4D8B3d00e52341F2BB0798860532C
 * @custom:tags oracle,redstone,price-feed,xrp,usd
 */
interface IXRPUSDOracle is IRedstoneAggregator {

}