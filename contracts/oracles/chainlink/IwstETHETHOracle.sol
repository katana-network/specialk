// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IwstETHETHOracle
 * @notice Interface for wstETH/ETH Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0xCB568C33EA2B0B81852655d722E3a52d9D44e7De
 * @custom:tags oracle,chainlink,price-feed,wsteth,eth
 */
interface IwstETHETHOracle is IEACAggregatorProxy {

}