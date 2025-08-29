// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IyUSDUSDOracle
 * @notice Interface for yUSD/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xe61b585418B92917771c89D4d3957707cfFE6154
 * @custom:tags oracle,chainlink,price-feed,yusd,usd
 */
interface IyUSDUSDOracle is IEACAggregatorProxy {

}