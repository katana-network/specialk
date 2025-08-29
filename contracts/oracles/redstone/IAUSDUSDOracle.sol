// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IAUSDUSDOracle
 * @notice Interface for AUSD/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0x53bB139e962ee0AC6477F40D0352e8dAF0480b70
 * @custom:tags oracle,redstone,price-feed,ausd,usd
 */
interface IAUSDUSDOracle is IRedstoneAggregator {

}