// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title ILBTCBTCOracle
 * @notice Interface for LBTC/BTC Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x6830BfE63F8804B4972D92826b9088d2fb6AFe5b
 * @custom:tags oracle,chainlink,price-feed,lbtc,btc
 */
interface ILBTCBTCOracle is IEACAggregatorProxy {

}