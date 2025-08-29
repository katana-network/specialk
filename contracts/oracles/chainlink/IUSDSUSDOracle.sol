// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IUSDSUSDOracle
 * @notice Interface for USDS/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x44cdCd6F81cEe5BAC68B21845Fc82846ee09A369
 * @custom:tags oracle,chainlink,price-feed,usds,usd
 */
interface IUSDSUSDOracle is IEACAggregatorProxy {

}