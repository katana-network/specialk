// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IAggregatorV3Interface
 * @notice Interface for Chainlink price feed aggregators
 * @dev From Chainlink's AggregatorV3Interface
 * @custom:tags oracle,chainlink,price-feed,standard
 */
interface IAggregatorV3Interface {
    /**
     * @notice Get the decimals for this aggregator's answer
     * @return The number of decimals
     */
    function decimals() external view returns (uint8);

    /**
     * @notice Get the description of this aggregator
     * @return The description string
     */
    function description() external view returns (string memory);

    /**
     * @notice Get the version of this aggregator
     * @return The version number
     */
    function version() external view returns (uint256);

    /**
     * @notice Get data about a specific round
     * @param _roundId The round ID to retrieve
     * @return roundId The round ID
     * @return answer The price answer
     * @return startedAt The timestamp when the round started
     * @return updatedAt The timestamp when the round was updated
     * @return answeredInRound The round in which the answer was computed
     */
    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    /**
     * @notice Get data about the latest round
     * @return roundId The round ID
     * @return answer The price answer
     * @return startedAt The timestamp when the round started
     * @return updatedAt The timestamp when the round was updated
     * @return answeredInRound The round in which the answer was computed
     */
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
} 