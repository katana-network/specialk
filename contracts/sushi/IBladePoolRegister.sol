// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title IBladePoolRegister
 * @notice Interface for Sushi's Blade Pool Register
 * @dev Blade is Sushi's RFQ (Request for Quote) trading protocol that provides better pricing through off-chain liquidity aggregation and on-chain settlement.
 * @custom:katana 0xe56a524F7F35d39E5d5C34428De497da29D4B88b
 * @custom:tags sushi,swap,dex,defi,rfq
 */
interface IBladePoolRegister {
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    event BladeLPTransferCreated(
        address indexed oldExchange,
        address indexed newExchange,
        address indexed lpTransferAddress
    );
    event BladePermitRouterCreated(
        address indexed permitRouterAddress,
        address indexed exchangeAddress
    );
    event BladeVerifiedExchangeCreated(
        address indexed exchangeAddress,
        address[] tokens,
        address[] oracles
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function bladeVerifiedImplementation() external view returns (address);

    function createBladePermitRouter(
        address bladeExchange,
        address permitRouterAddress
    ) external returns (address);

    function createBladeVerifiedExchange(
        address theSigner,
        address theWrapper,
        address[] memory tokens,
        address[] memory oracles,
        uint256[] memory minTimeTolerances,
        address initialOwner,
        address exchangeAddress
    ) external returns (address);

    function createLPTransfer(
        address oldExchange,
        address newExchange,
        address lpTransferAddress
    ) external returns (address);

    function isRegistered(address) external view returns (bool);

    function lpTransferImplementation() external view returns (address);

    function owner() external view returns (address);

    function permitRouterImplementation() external view returns (address);

    function renounceOwnership() external;

    function setLPTransferImplementation(address newImpl) external;

    function setPermitRouterImplementation(address newImpl) external;

    function setVerifiedImplementation(address newImpl) external;

    function transferOwnership(address newOwner) external;
}