// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BokutoOriginAddresses
 * @notice Library for accessing origin chain contract addresses when operating in Bokuto context
 * @dev Auto-generated from contract doccomments. Do not edit manually.
 *      These are contracts deployed on origin chains (Ethereum/Sepolia) that are accessed
 *      from the Bokuto context for cross-chain operations like Vault Bridge.
 */
library BokutoOriginAddresses {
    /**
     * @notice Returns the origin chain address of IMigrationManager
     * @dev This contract is deployed on sepolia and accessed from Bokuto context
     * @return The IMigrationManager contract address on sepolia
     */
    function getMigrationManagerAddress() internal pure returns (address) {
        return 0x16B46094cb1eE593181Ba2d997E77E88D7E9Ab8F;
    }

    /**
     * @notice Returns the origin chain address of IvbETH
     * @dev This contract is deployed on sepolia and accessed from Bokuto context
     * @return The IvbETH contract address on sepolia
     */
    function getIvbETHAddress() internal pure returns (address) {
        return 0x188FFFc2562C67aCdB9a0CD0B819021DDfC82A6B;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDC
     * @dev This contract is deployed on sepolia and accessed from Bokuto context
     * @return The IvbUSDC contract address on sepolia
     */
    function getIvbUSDCAddress() internal pure returns (address) {
        return 0xb62Ba0719527701309339a175dDe3CBF1770dd38;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDS
     * @dev This contract is deployed on sepolia and accessed from Bokuto context
     * @return The IvbUSDS contract address on sepolia
     */
    function getIvbUSDSAddress() internal pure returns (address) {
        return 0x406F1A8D91956d8D340821Cf6744Aa74c666836C;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDT
     * @dev This contract is deployed on sepolia and accessed from Bokuto context
     * @return The IvbUSDT contract address on sepolia
     */
    function getIvbUSDTAddress() internal pure returns (address) {
        return 0xdd9aCdD3D2AeC1C823C51f8389597C6be9779B28;
    }

    /**
     * @notice Returns the origin chain address of IvbWBTC
     * @dev This contract is deployed on sepolia and accessed from Bokuto context
     * @return The IvbWBTC contract address on sepolia
     */
    function getIvbWBTCAddress() internal pure returns (address) {
        return 0x2CE29070ee5e65C4191d5Efca8E85be181F34B6d;
    }

}