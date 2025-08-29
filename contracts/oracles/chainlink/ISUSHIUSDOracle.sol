// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title ISUSHIUSDOracle
 * @notice Interface for SUSHI/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xA30C356781E5e1b455b274cdDe524FB7BF3809da
 * @custom:tags oracle,chainlink,price-feed,sushi,usd
 */
interface ISUSHIUSDOracle is IEACAggregatorProxy {

}