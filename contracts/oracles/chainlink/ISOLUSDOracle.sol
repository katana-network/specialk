// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title ISOLUSDOracle
 * @notice Interface for SOL/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x709c4dc298322916eaE59bfdc2e3d750B55C864B
 * @custom:tags oracle,chainlink,price-feed,sol,usd
 */
interface ISOLUSDOracle is IEACAggregatorProxy {

}