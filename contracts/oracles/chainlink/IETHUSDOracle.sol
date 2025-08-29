// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IETHUSDOracle
 * @notice Interface for ETH/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x7BdBDB772f4a073BadD676A567C6ED82049a8eEE
 * @custom:tags oracle,chainlink,price-feed,eth,usd
 */
interface IETHUSDOracle is IEACAggregatorProxy {

}