// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IProxyAdmin
 * @notice Interface for the ProxyAdmin contract which manages transparent proxy contracts
 * @custom:tatara 0x85cEB41028B1a5ED2b88E395145344837308b251
 * @custom:tags agglayer,polygon,proxy,admin,governance
 */
interface IProxyAdmin {
    /**
     * @notice Returns the implementation address of a proxy
     * @param proxy Address of the TransparentUpgradeableProxy
     * @return The address of the implementation
     */
    function getProxyImplementation(address proxy) external view returns (address);

    /**
     * @notice Returns the admin address of a proxy
     * @param proxy Address of the TransparentUpgradeableProxy
     * @return The address of the admin
     */
    function getProxyAdmin(address proxy) external view returns (address);

    /**
     * @notice Changes the admin of a proxy
     * @param proxy Address of the TransparentUpgradeableProxy
     * @param newAdmin Address of the new admin
     */
    function changeProxyAdmin(address proxy, address newAdmin) external;

    /**
     * @notice Upgrades a proxy to a new implementation
     * @param proxy Address of the TransparentUpgradeableProxy
     * @param implementation Address of the new implementation
     */
    function upgrade(address proxy, address implementation) external;

    /**
     * @notice Upgrades a proxy to a new implementation and calls a function on the new implementation
     * @param proxy Address of the TransparentUpgradeableProxy
     * @param implementation Address of the new implementation
     * @param data Function call data to be executed on the implementation after upgrade
     */
    function upgradeAndCall(address proxy, address implementation, bytes memory data) external payable;

    /**
     * @notice Transfers ownership of the contract to a new account
     * @param newOwner Address of the new owner
     */
    function transferOwnership(address newOwner) external;

    /**
     * @notice Returns the address of the current owner
     * @return The address of the owner
     */
    function owner() external view returns (address);

    /**
     * @notice Returns the address of the pending owner
     * @return The address of the pending owner
     */
    function pendingOwner() external view returns (address);

    /**
     * @notice Leaves the contract without owner, making it impossible to call `onlyOwner` functions
     */
    function renounceOwnership() external;
} 