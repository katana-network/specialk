// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IEACAggregatorProxy.sol";

/**
 * @title IJitoSOLSOLOracle
 * @notice Interface for jitoSOL/SOL Chainlink price oracle on Katana
 * @dev Extends the EAC Aggregator Proxy interface for price feeds
 * @custom:katana 0x1C0a310cf42F357087Be122e69ee402D19A265dC
 * @custom:tags oracle,chainlink,price-feed,jitosol,sol
 */
interface IJitoSOLSOLOracle is IEACAggregatorProxy {

}