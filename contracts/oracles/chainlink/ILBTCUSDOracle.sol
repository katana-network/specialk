// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title ILBTCUSDOracle
 * @notice Interface for LBTC/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x5C2c6A77310C7750fCc5c3f13a3f9C3b18a68d3e
 * @custom:tags oracle,chainlink,price-feed,lbtc,usd
 */
interface ILBTCUSDOracle is IEACAggregatorProxy {

}