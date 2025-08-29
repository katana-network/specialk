// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IweETHETHOracle
 * @notice Interface for weETH/ETH Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x3Eae75C0a2f9b1038C7c9993C1Da36281E838811
 * @custom:tags oracle,chainlink,price-feed,weeth,eth
 */
interface IweETHETHOracle is IEACAggregatorProxy {

}