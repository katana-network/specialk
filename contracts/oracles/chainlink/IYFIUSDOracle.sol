// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IYFIUSDOracle
 * @notice Interface for YFI/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xfcDcCF5C2BEAB72FDb910481beaE807F5453686B
 * @custom:tags oracle,chainlink,price-feed,yfi,usd
 */
interface IYFIUSDOracle is IEACAggregatorProxy {

}