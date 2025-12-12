// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ICreate2Deployer
 * @dev Interface for the Create2Deployer contract on Katana
 * @notice Helper contract for using CREATE2 opcode with additional safety features and utilities
 * @custom:bokuto 0x13b0D85CcB8bf860b6b79AF3029fCA081AE9beF2
 */
interface ICreate2Deployer {
    /**
     * @notice Deploys a contract using CREATE2 opcode
     * @dev Allows creating contracts at deterministic addresses
     * @param value Amount of ETH to send to the created contract
     * @param salt Unique value for determining the contract address
     * @param code The contract bytecode to deploy
     */
    function deploy(uint256 value, bytes32 salt, bytes memory code) external;

    /**
     * @notice Deploys an ERC1820Implementer contract using CREATE2 opcode
     * @dev Specialized deployment for ERC1820 implementation
     * @param value Amount of ETH to send to the created contract
     * @param salt Unique value for determining the contract address
     */
    function deployERC1820Implementer(uint256 value, bytes32 salt) external;

    /**
     * @notice Computes the address where a contract would be deployed using CREATE2
     * @param salt Unique value for determining the contract address
     * @param codeHash Hash of the contract creation code
     * @return The computed address
     */
    function computeAddress(bytes32 salt, bytes32 codeHash) external view returns (address);

    /**
     * @notice Computes the address a contract would have if deployed by a specific deployer
     * @param salt Unique value for determining the contract address
     * @param codeHash Hash of the contract creation code
     * @param deployer Address of the contract that would deploy the new contract
     * @return The computed address
     */
    function computeAddressWithDeployer(
        bytes32 salt,
        bytes32 codeHash,
        address deployer
    ) external pure returns (address);

    /**
     * @notice Pauses the contract's deployments
     * @dev Can only be called by the contract owner
     */
    function pause() external;

    /**
     * @notice Unpauses the contract's deployments
     * @dev Can only be called by the contract owner
     */
    function unpause() external;
} 