// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TataraOriginAddresses
 * @notice Library for accessing origin chain contract addresses when operating in Tatara context
 * @dev Auto-generated from contract doccomments. Do not edit manually.
 *      These are contracts deployed on origin chains (Ethereum/Sepolia) that are accessed
 *      from the Tatara context for cross-chain operations like Vault Bridge.
 */
library TataraOriginAddresses {
    /**
     * @notice Returns the origin chain address of IvbETH
     * @dev This contract is deployed on sepolia and accessed from Tatara context
     * @return The IvbETH contract address on sepolia
     */
    function getIvbETHAddress() internal pure returns (address) {
        return 0x4CcD4CbDE5Ec758cCBf75f0be280647Ff359c17a;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDC
     * @dev This contract is deployed on sepolia and accessed from Tatara context
     * @return The IvbUSDC contract address on sepolia
     */
    function getIvbUSDCAddress() internal pure returns (address) {
        return 0x4C8414eBFE5A55eA5859aF373371EE3233fFF7CD;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDS
     * @dev This contract is deployed on sepolia and accessed from Tatara context
     * @return The IvbUSDS contract address on sepolia
     */
    function getIvbUSDSAddress() internal pure returns (address) {
        return 0x56b89A124376CB0481c93C3d94f821F262Dc0D7A;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDT
     * @dev This contract is deployed on sepolia and accessed from Tatara context
     * @return The IvbUSDT contract address on sepolia
     */
    function getIvbUSDTAddress() internal pure returns (address) {
        return 0xb3f50565f611D645e0DDB44eB09c4588B1601514;
    }

    /**
     * @notice Returns the origin chain address of IvbWBTC
     * @dev This contract is deployed on sepolia and accessed from Tatara context
     * @return The IvbWBTC contract address on sepolia
     */
    function getIvbWBTCAddress() internal pure returns (address) {
        return 0xa278D086289f71a30D237feccBAF3698E43Bc5D6;
    }

}