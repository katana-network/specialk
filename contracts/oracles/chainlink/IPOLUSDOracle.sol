// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IPOLUSDOracle
 * @notice Interface for POL/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xF6630799b5387e0E9ACe92a5E82673021781B440
 * @custom:tags oracle,chainlink,price-feed,pol,usd
 */
interface IPOLUSDOracle is IEACAggregatorProxy {

}