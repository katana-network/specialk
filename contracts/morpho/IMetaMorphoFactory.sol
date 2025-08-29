// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IMetaMorphoFactory
 * @notice Interface for MetaMorpho Factory, which creates MetaMorpho vaults for Morpho Blue
 * @author Morpho Labs
 * @custom:contact security@morpho.org
 * @custom:tatara 0x505619071bdCDeA154f164b323B6C42Fc14257f7
 * @custom:tags morpho,defi,factory,vault,metamorpho
 */
interface IMetaMorphoFactory {
    /**
     * @notice Emitted when a new MetaMorpho vault is created
     * @param metaMorpho The address of the new MetaMorpho vault
     * @param sender The address that created the vault
     * @param initialOwner The initial owner of the vault
     * @param initialTimelock The initial timelock duration
     * @param asset The underlying asset of the vault
     * @param name The name of the vault token
     * @param symbol The symbol of the vault token
     * @param salt The salt used for CREATE2 deployment
     */
    event CreateMetaMorpho(
        address indexed metaMorpho,
        address indexed sender,
        address initialOwner,
        uint256 initialTimelock,
        address asset,
        string name,
        string symbol,
        bytes32 salt
    );

    /**
     * @notice The address of the Morpho Blue contract
     * @return The Morpho contract address
     */
    function MORPHO() external view returns (address);

    /**
     * @notice Checks if an address is a MetaMorpho vault created by this factory
     * @param target The address to check
     * @return True if the address is a MetaMorpho vault, false otherwise
     */
    function isMetaMorpho(address target) external view returns (bool);

    /**
     * @notice Creates a new MetaMorpho vault
     * @param initialOwner The initial owner of the vault
     * @param initialTimelock The initial timelock duration for governance actions
     * @param asset The underlying asset of the vault
     * @param name The name of the vault token
     * @param symbol The symbol of the vault token
     * @param salt The salt to use for the CREATE2 deployment
     * @return metaMorpho The address of the newly created MetaMorpho vault
     */
    function createMetaMorpho(
        address initialOwner,
        uint256 initialTimelock,
        address asset,
        string memory name,
        string memory symbol,
        bytes32 salt
    ) external returns (address metaMorpho);
} 