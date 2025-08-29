// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IAUSDUSDOracle
 * @notice Interface for AUSD/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x3A49D4e23868222785f148BA2bd0bAEc80d36a2A
 * @custom:tags oracle,chainlink,price-feed,ausd,usd
 */
interface IAUSDUSDOracle is IEACAggregatorProxy {

}