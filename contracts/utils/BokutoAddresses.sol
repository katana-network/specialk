// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BokutoAddresses
 * @notice Library for accessing Bokuto network contract addresses
 * @dev Auto-generated from contract doccomments. Do not edit manually.
 */
library BokutoAddresses {
    /**
     * @notice Chain ID for Bokuto network
     */
    uint256 internal constant CHAIN_ID = 737373;

    /**
     * @notice Returns the address of IBatchDistributor
     * @return The IBatchDistributor contract address
     */
    function getBatchDistributorAddress() internal pure returns (address) {
        return 0x2A6fd05d3C6A373FBb073dea12bCee7C174AE606;
    }

    /**
     * @notice Returns the address of IBulkWriter
     * @return The IBulkWriter contract address
     */
    function getBulkWriterAddress() internal pure returns (address) {
        return 0xA681A7BE7A87bDA505c1a947b172b8A1988E329A;
    }

    /**
     * @notice Returns the address of IbvbEth
     * @return The IbvbEth contract address
     */
    function getIbvbEthAddress() internal pure returns (address) {
        return 0x84b3493fA9B125A8EFf1CCc1328Bd84D0B4a2Dbf;
    }

    /**
     * @notice Returns the address of IbvbUSDC
     * @return The IbvbUSDC contract address
     */
    function getIbvbUSDCAddress() internal pure returns (address) {
        return 0xc2a4C310F2512A17Ac0047cf871aCAed3E62bB4B;
    }

    /**
     * @notice Returns the address of IbvbUSDS
     * @return The IbvbUSDS contract address
     */
    function getIbvbUSDSAddress() internal pure returns (address) {
        return 0x801f719178d9b85D4948ed146C50596273885a75;
    }

    /**
     * @notice Returns the address of IbvbUSDT
     * @return The IbvbUSDT contract address
     */
    function getIbvbUSDTAddress() internal pure returns (address) {
        return 0xf6801557e17131Da48Fd03B2c34172872F936345;
    }

    /**
     * @notice Returns the address of IbvbWBTC
     * @return The IbvbWBTC contract address
     */
    function getIbvbWBTCAddress() internal pure returns (address) {
        return 0xe8255B44634b478aB10a649c6C207A654473dbed;
    }

    /**
     * @notice Returns the address of ICatalogFactory
     * @return The ICatalogFactory contract address
     */
    function getCatalogFactoryAddress() internal pure returns (address) {
        return 0xC0137140B2D2a146d20dBbb0153e5Ac1048f30E3;
    }

    /**
     * @notice Returns the address of ICatalogUtils
     * @return The ICatalogUtils contract address
     */
    function getCatalogUtilsAddress() internal pure returns (address) {
        return 0xB1e10B768E9d56A51f1C80d70414989ECAf87fd0;
    }

    /**
     * @notice Returns the address of IConduitController
     * @return The IConduitController contract address
     */
    function getConduitControllerAddress() internal pure returns (address) {
        return 0x00000000F9490004C11Cef243f5400493c00Ad63;
    }

    /**
     * @notice Returns the address of IRenderUtils
     * @return The IRenderUtils contract address
     */
    function getRenderUtilsAddress() internal pure returns (address) {
        return 0xcd891c3de90dcdF99549E9B6402BFAa695DEc69B;
    }

    /**
     * @notice Returns the address of ISeaport
     * @return The ISeaport contract address
     */
    function getSeaportAddress() internal pure returns (address) {
        return 0x0000000000000068F116a894984e2DB1123eB395;
    }

    /**
     * @notice Returns the address of ITokenAttributesRepository
     * @return The ITokenAttributesRepository contract address
     */
    function getTokenAttributesRepositoryAddress() internal pure returns (address) {
        return 0xC3f5961F6Bf6A60A6d2F9f45Ec477E1E46144827;
    }

    /**
     * @notice Returns the address of IUSDCNativeConverter
     * @return The IUSDCNativeConverter contract address
     */
    function getUSDCNativeConverterAddress() internal pure returns (address) {
        return 0xF1b01AAB6B790bb15610Dc18c6908b32765B5a06;
    }

    /**
     * @notice Returns the address of IUSDSNativeConverter
     * @return The IUSDSNativeConverter contract address
     */
    function getUSDSNativeConverterAddress() internal pure returns (address) {
        return 0xC4BaBEE541c2FA1EA55ce9aF9EB3B5C76B0CE5c7;
    }

    /**
     * @notice Returns the address of IUSDTNativeConverter
     * @return The IUSDTNativeConverter contract address
     */
    function getUSDTNativeConverterAddress() internal pure returns (address) {
        return 0x1bd455C30ad8E2b8dF40df44A2eF923d67B33Feb;
    }

    /**
     * @notice Returns the address of IWBTCNativeConverter
     * @return The IWBTCNativeConverter contract address
     */
    function getWBTCNativeConverterAddress() internal pure returns (address) {
        return 0x7A8ed27F4C30512326878652d20fC85727401854;
    }

    /**
     * @notice Returns the address of IWETHNativeConverter
     * @return The IWETHNativeConverter contract address
     */
    function getWETHNativeConverterAddress() internal pure returns (address) {
        return 0x409834270b6F2591DD6c1e9f351E4194B112dA44;
    }

    /**
     * @notice Returns the address of Multicall
     * @return The Multicall contract address
     */
    function getMulticallAddress() internal pure returns (address) {
        return 0x1a593e35B50A6BD65f23aa022C910FF0Cef58ACd;
    }

    /**
     * @notice Returns the address of Multicall2
     * @return The Multicall2 contract address
     */
    function getMulticall2Address() internal pure returns (address) {
        return 0xafc9dD4B1416f61c86A5540423D29abdFf665dbB;
    }

}