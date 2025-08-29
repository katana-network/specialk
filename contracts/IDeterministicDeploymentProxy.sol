// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IDeterministicDeploymentProxy
 * @dev Interface for Deterministic Deployment Proxy on Katana
 * @notice This contract enables deploying other contracts at the same address across different EVM chains
 * @custom:tatara 0x4e59b44847b379578588920cA78FbF26c0B4956C
 */
interface IDeterministicDeploymentProxy {
    /**
     * @dev Deploys a contract using CREATE2 to ensure the same deployment address across chains
     * @notice The calldata format is {bytes32 salt}{bytecode}
     * where:
     *   - salt: 32-byte value used to determine the deployment address
     *   - bytecode: The contract bytecode to deploy
     * @notice Any msg.value sent will be passed to the created contract
     * @return The address of the deployed contract (only returns the last 20 bytes)
     */
    function deploy(bytes calldata initCode) external payable returns (address);
} 