// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IUSDTUSDOracle
 * @notice Interface for USDT/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xF03E1566Fc6B0eBFA3dD3aA197759C4c6617ec78
 * @custom:tags oracle,chainlink,price-feed,usdt,usd
 */
interface IUSDTUSDOracle is IEACAggregatorProxy {

}