// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title KatanaOriginAddresses
 * @notice Library for accessing origin chain contract addresses when operating in Katana context
 * @dev Auto-generated from contract doccomments. Do not edit manually.
 *      These are contracts deployed on origin chains (Ethereum/Sepolia) that are accessed
 *      from the Katana context for cross-chain operations like Vault Bridge.
 */
library KatanaOriginAddresses {
    /**
     * @notice Returns the origin chain address of IAUSD
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IAUSD contract address on ethereum
     */
    function getAUSDAddress() internal pure returns (address) {
        return 0x00000000eFE302BEAA2b3e6e1b18d08D69a9012a;
    }

    /**
     * @notice Returns the origin chain address of ILBTC
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The ILBTC contract address on ethereum
     */
    function getLBTCAddress() internal pure returns (address) {
        return 0x8236a87084f8b84306f72007f36f2618a5634494;
    }

    /**
     * @notice Returns the origin chain address of IMigrationManager
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IMigrationManager contract address on ethereum
     */
    function getMigrationManagerAddress() internal pure returns (address) {
        return 0x417d01B64Ea30C4E163873f3a1f77b727c689e02;
    }

    /**
     * @notice Returns the origin chain address of IMORPHO
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IMORPHO contract address on ethereum
     */
    function getMORPHOAddress() internal pure returns (address) {
        return 0x58d97b57bb95320f9a05dc918aef65434969c2b2;
    }

    /**
     * @notice Returns the origin chain address of IPOL
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IPOL contract address on ethereum
     */
    function getPOLAddress() internal pure returns (address) {
        return 0x455e53CBB86018Ac2B8092FdCd39d8444aFFC3F6;
    }

    /**
     * @notice Returns the origin chain address of IPROVE
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IPROVE contract address on ethereum
     */
    function getPROVEAddress() internal pure returns (address) {
        return 0x6bef15d938d4e72056ac92ea4bdd0d76b1c4ad29;
    }

    /**
     * @notice Returns the origin chain address of ISUSHI
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The ISUSHI contract address on ethereum
     */
    function getSUSHIAddress() internal pure returns (address) {
        return 0x6b3595068778dd592e39a122f4f5a5cf09c90fe2;
    }

    /**
     * @notice Returns the origin chain address of IvbETH
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IvbETH contract address on ethereum
     */
    function getIvbETHAddress() internal pure returns (address) {
        return 0x2DC70fb75b88d2eB4715bc06E1595E6D97c34DFF;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDC
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IvbUSDC contract address on ethereum
     */
    function getIvbUSDCAddress() internal pure returns (address) {
        return 0x53E82ABbb12638F09d9e624578ccB666217a765e;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDS
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IvbUSDS contract address on ethereum
     */
    function getIvbUSDSAddress() internal pure returns (address) {
        return 0x3DD459dE96F9C28e3a343b831cbDC2B93c8C4855;
    }

    /**
     * @notice Returns the origin chain address of IvbUSDT
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IvbUSDT contract address on ethereum
     */
    function getIvbUSDTAddress() internal pure returns (address) {
        return 0x6d4f9f9f8f0155509ecd6Ac6c544fF27999845CC;
    }

    /**
     * @notice Returns the origin chain address of IvbWBTC
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IvbWBTC contract address on ethereum
     */
    function getIvbWBTCAddress() internal pure returns (address) {
        return 0x2C24B57e2CCd1f273045Af6A5f632504C432374F;
    }

    /**
     * @notice Returns the origin chain address of IweETH
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IweETH contract address on ethereum
     */
    function getIweETHAddress() internal pure returns (address) {
        return 0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee;
    }

    /**
     * @notice Returns the origin chain address of IwstETH
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IwstETH contract address on ethereum
     */
    function getIwstETHAddress() internal pure returns (address) {
        return 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0;
    }

    /**
     * @notice Returns the origin chain address of IYFI
     * @dev This contract is deployed on ethereum and accessed from Katana context
     * @return The IYFI contract address on ethereum
     */
    function getYFIAddress() internal pure returns (address) {
        return 0x0bc529c00c6401aef6d220be8c6ea1667f6ad93e;
    }

}