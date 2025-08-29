// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IBTCUSDOracle
 * @notice Interface for BTC/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x41DdB7F8F5e1b2bD28193B84C1C36Be698dEd162
 * @custom:tags oracle,chainlink,price-feed,btc,usd
 */
interface IBTCUSDOracle is IEACAggregatorProxy {

}