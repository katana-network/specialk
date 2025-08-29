// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IWBTCBTCOracle
 * @notice Interface for WBTC/BTC Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xAd2937e7D25c237856B03319265465C0291b1895
 * @custom:tags oracle,chainlink,price-feed,wbtc,btc
 */
interface IWBTCBTCOracle is IEACAggregatorProxy {

}