// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IMORPHOUSDOracle
 * @notice Interface for MORPHO/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xdFd824A5Dcad8667142d58FE4aF115d5d052f26c
 * @custom:tags oracle,chainlink,price-feed,morpho,usd
 */
interface IMORPHOUSDOracle is IEACAggregatorProxy {

}