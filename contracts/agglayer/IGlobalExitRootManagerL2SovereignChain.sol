// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IGlobalExitRootManagerL2SovereignChain
 * @notice Interface for the GlobalExitRootManagerL2SovereignChain contract which manages exit roots
 * @dev Proxy. Implementation address: 0x282a631D9F3Ef04Bf1A44B4C9e8bDC8EB278917f
 * @custom:tatara 0xa40d5f56745a118d0906a34e69aec8c0db1cb8fa
 * @custom:tags agglayer,bridge,polygon,exit-root,sovereign
 */
interface IGlobalExitRootManagerL2SovereignChain {
    /**
     * @notice Emitted when a new global exit root is updated
     * @param mainnetExitRoot Mainnet exit root
     * @param rollupExitRoot Rollup exit root
     * @param globalExitRoot Global exit root (a combination of both roots)
     */
    event UpdateGlobalExitRoot(
        bytes32 indexed mainnetExitRoot,
        bytes32 indexed rollupExitRoot,
        bytes32 indexed globalExitRoot
    );

    /**
     * @notice Initializes the contract with required parameters
     * @param _bridgeAddress Address of the Bridge contract
     * @param _rollupAddress Address of the Rollup contract
     */
    function initialize(address _bridgeAddress, address _rollupAddress) external;

    /**
     * @notice Updates the exit roots from L1 (mainnet)
     * @param newRoot New root from L1
     */
    function updateExitRoot(bytes32 newRoot) external;

    /**
     * @notice Returns the last global exit root
     * @return The last global exit root
     */
    function getLastGlobalExitRoot() external view returns (bytes32);

    /**
     * @notice Returns a global exit root by index
     * @param index Index of the global exit root
     * @return The global exit root at the specified index
     */
    function globalExitRootMap(uint256 index) external view returns (bytes32);

    /**
     * @notice Returns true if the global exit root exists
     * @param globalExitRoot Global exit root to check
     * @return True if the global exit root exists
     */
    function isGlobalExitRoot(bytes32 globalExitRoot) external view returns (bool);

    /**
     * @notice Returns the current mainnet exit root
     * @return The current mainnet exit root
     */
    function mainnetExitRoot() external view returns (bytes32);

    /**
     * @notice Returns the current rollup exit root
     * @return The current rollup exit root
     */
    function rollupExitRoot() external view returns (bytes32);

    /**
     * @notice Returns the address of the bridge contract
     * @return The bridge contract address
     */
    function bridgeAddress() external view returns (address);

    /**
     * @notice Returns the address of the rollup contract
     * @return The rollup contract address
     */
    function rollupAddress() external view returns (address);

    /**
     * @notice Returns the last global exit root and its timestamp
     * @return The last global exit root
     * @return The timestamp when the last global exit root was updated
     */
    function getLastGlobalExitRootAndTimestamp() external view returns (bytes32, uint256);

    /**
     * @notice Returns the timestamp of a global exit root
     * @param globalExitRoot The global exit root to query
     * @return The timestamp of the global exit root, or 0 if it doesn't exist
     */
    function globalExitRootMapTimestamp(bytes32 globalExitRoot) external view returns (uint256);
} 