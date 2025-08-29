// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IWBTCUSDOracle
 * @notice Interface for WBTC/USD RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xE5E307A3aEDf4e8eF60E1bfCc9ccD477dFad93ce
 * @custom:tags oracle,redstone,price-feed,wbtc,usd
 */
interface IWBTCUSDOracle is IRedstoneAggregator {

}