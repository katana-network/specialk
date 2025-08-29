// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IWBTCUSDOracle
 * @notice Interface for WBTC/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x0D03E26E0B5D09E24E5a45696D0FcA12E9648FBB
 * @custom:tags oracle,chainlink,price-feed,wbtc,usd
 */
interface IWBTCUSDOracle is IEACAggregatorProxy {

}