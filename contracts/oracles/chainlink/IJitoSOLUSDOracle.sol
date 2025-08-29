// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IJitoSOLUSDOracle
 * @notice Interface for jitoSOL/USD Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x36E03469335b7F2eF51aAeB914b76c038645679A
 * @custom:tags oracle,chainlink,price-feed,jitosol,usd
 */
interface IJitoSOLUSDOracle is IEACAggregatorProxy {

}