// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title ILINKUSDOracle
 * @notice Interface for LINK/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x06bD6464e94Bee9393Ae15B5Dd5eCDFAa4F299C1
 * @custom:tags oracle,chainlink,price-feed,link,usd
 */
interface ILINKUSDOracle is IEACAggregatorProxy {

}