// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IUSDCUSDOracle
 * @notice Interface for USDC/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xbe5CE90e16B9d9d988D64b0E1f6ed46EbAfb9606
 * @custom:tags oracle,chainlink,price-feed,usdc,usd
 */
interface IUSDCUSDOracle is IEACAggregatorProxy {

}