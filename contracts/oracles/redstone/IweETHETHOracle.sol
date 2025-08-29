// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRedstoneAggregator.sol";

/**
 * @title IweETHETHOracle
 * @notice Interface for weETH/ETH RedStone price oracle on Katana
 * @dev Extends the RedStone Aggregator interface for price feeds
 * @custom:katana 0xe8D9FbC10e00ecc9f0694617075fDAF657a76FB2
 * @custom:tags oracle,redstone,price-feed,weeth,eth
 */
interface IweETHETHOracle is IRedstoneAggregator {

}