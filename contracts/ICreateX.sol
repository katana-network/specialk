// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

/**
 * @title CreateX Factory Interface Definition
 * @author pcaversaccio (https://web.archive.org/web/20230921103111/https://pcaversaccio.com/)
 * @custom:coauthor Matt Solomon (https://web.archive.org/web/20230921103335/https://mattsolomon.dev/)
 * @notice Advanced contract deployment factory supporting CREATE, CREATE2, and CREATE3 deployment patterns
 * @dev Deployed at the same address across all EVM chains: 0xba5Ed099633D3B313e4D5F7bdc1305d3c28ba5Ed
 * @custom:tatara 0xba5Ed099633D3B313e4D5F7bdc1305d3c28ba5Ed
 * @custom:tags deployment,factory,create2,create3,utility
 */
interface ICreateX {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                            TYPES                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @dev Struct for handling ETH values in deployment operations
     * @param constructorAmount ETH amount to send during contract creation
     * @param initCallAmount ETH amount to send during initialization call
     */
    struct Values {
        uint256 constructorAmount;
        uint256 initCallAmount;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @dev Emitted when a contract is created with CREATE2 or CREATE3 (with salt)
     * @param newContract Address of the newly created contract
     * @param salt The salt used for address derivation
     */
    event ContractCreation(address indexed newContract, bytes32 indexed salt);
    
    /**
     * @dev Emitted when a contract is created with CREATE (no salt)
     * @param newContract Address of the newly created contract
     */
    event ContractCreation(address indexed newContract);
    
    /**
     * @dev Emitted when a CREATE3 proxy contract is deployed
     * @param newContract Address of the newly created proxy
     * @param salt The salt used for the proxy address derivation
     */
    event Create3ProxyContractCreation(address indexed newContract, bytes32 indexed salt);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CUSTOM ERRORS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @dev Thrown when contract creation fails
     * @param emitter The address that emitted the error
     */
    error FailedContractCreation(address emitter);
    
    /**
     * @dev Thrown when contract initialization fails
     * @param emitter The address that emitted the error
     * @param revertData The revert data from the failed initialization
     */
    error FailedContractInitialisation(address emitter, bytes revertData);
    
    /**
     * @dev Thrown when an invalid salt is provided
     * @param emitter The address that emitted the error
     */
    error InvalidSalt(address emitter);
    
    /**
     * @dev Thrown when an invalid nonce value is provided
     * @param emitter The address that emitted the error
     */
    error InvalidNonceValue(address emitter);
    
    /**
     * @dev Thrown when an ETH transfer fails
     * @param emitter The address that emitted the error
     * @param revertData The revert data from the failed transfer
     */
    error FailedEtherTransfer(address emitter, bytes revertData);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           CREATE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Deploys a contract using the standard CREATE opcode
     * @dev Uses the standard Ethereum CREATE opcode with nonce-based addressing
     * @param initCode The contract creation bytecode and constructor args
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate(bytes memory initCode) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE and initializes it with a separate call
     * @dev Useful for factory patterns that need post-deployment initialization
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @param refundAddress Address to receive any unused ETH
     * @return newContract Address of the newly deployed contract
     */
    function deployCreateAndInit(
        bytes memory initCode,
        bytes memory data,
        Values memory values,
        address refundAddress
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE and initializes it, without refund
     * @dev Same as deployCreateAndInit but without refund parameter
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @return newContract Address of the newly deployed contract
     */
    function deployCreateAndInit(
        bytes memory initCode,
        bytes memory data,
        Values memory values
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a minimal proxy (EIP-1167 clone) using CREATE
     * @dev Gas-efficient way to deploy copies of an existing contract
     * @param implementation Address of the implementation contract to clone
     * @param data Initialization calldata for the post-deployment call
     * @return proxy Address of the newly deployed proxy contract
     */
    function deployCreateClone(address implementation, bytes memory data) external payable returns (address proxy);

    /**
     * @notice Computes the address where a contract will be deployed using CREATE
     * @dev Given a deployer address and nonce, computes the resulting contract address
     * @param deployer The address that will deploy the contract
     * @param nonce The deployer's nonce (transaction count)
     * @return computedAddress The address where the contract will be deployed
     */
    function computeCreateAddress(address deployer, uint256 nonce) external view returns (address computedAddress);

    /**
     * @notice Computes the address where a contract will be deployed by this factory
     * @dev Computes the resulting contract address using this contract's address and nonce
     * @param nonce The factory's nonce (transaction count)
     * @return computedAddress The address where the contract will be deployed
     */
    function computeCreateAddress(uint256 nonce) external view returns (address computedAddress);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           CREATE2                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Deploys a contract using CREATE2 with a specified salt
     * @dev Produces deterministic addresses based on deployer, salt, and initcode
     * @param salt The salt used for address derivation
     * @param initCode The contract creation bytecode and constructor args
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate2(bytes32 salt, bytes memory initCode) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE2 with a default salt of bytes32(0)
     * @dev Simplified CREATE2 deployment with zero salt
     * @param initCode The contract creation bytecode and constructor args
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate2(bytes memory initCode) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE2 and initializes it with a separate call
     * @dev Most complete CREATE2 deployment option with salt, init call, and refund
     * @param salt The salt used for address derivation
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @param refundAddress Address to receive any unused ETH
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate2AndInit(
        bytes32 salt,
        bytes memory initCode,
        bytes memory data,
        Values memory values,
        address refundAddress
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE2 and initializes it without refund
     * @dev CREATE2 deployment with salt and init call but no refund
     * @param salt The salt used for address derivation
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate2AndInit(
        bytes32 salt,
        bytes memory initCode,
        bytes memory data,
        Values memory values
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE2 with zero salt and initializes it
     * @dev Simplified CREATE2 with initialization and refund
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @param refundAddress Address to receive any unused ETH
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate2AndInit(
        bytes memory initCode,
        bytes memory data,
        Values memory values,
        address refundAddress
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE2 with zero salt and initializes it without refund
     * @dev Minimal CREATE2 with initialization
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate2AndInit(
        bytes memory initCode,
        bytes memory data,
        Values memory values
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a minimal proxy (EIP-1167 clone) using CREATE2
     * @dev Gas-efficient way to deploy deterministic proxies
     * @param salt The salt used for address derivation
     * @param implementation Address of the implementation contract to clone
     * @param data Initialization calldata for the post-deployment call
     * @return proxy Address of the newly deployed proxy contract
     */
    function deployCreate2Clone(
        bytes32 salt,
        address implementation,
        bytes memory data
    ) external payable returns (address proxy);

    /**
     * @notice Deploys a minimal proxy (EIP-1167 clone) using CREATE2 with zero salt
     * @dev Simplified version for deploying clones
     * @param implementation Address of the implementation contract to clone
     * @param data Initialization calldata for the post-deployment call
     * @return proxy Address of the newly deployed proxy contract
     */
    function deployCreate2Clone(address implementation, bytes memory data) external payable returns (address proxy);

    /**
     * @notice Computes the address where a contract would be deployed using CREATE2
     * @dev Returns address based on deployer, salt, and initcode hash
     * @param salt The salt used for address derivation
     * @param initCodeHash Hash of the contract creation bytecode
     * @param deployer The address that will deploy the contract
     * @return computedAddress The address where the contract will be deployed
     */
    function computeCreate2Address(
        bytes32 salt,
        bytes32 initCodeHash,
        address deployer
    ) external pure returns (address computedAddress);

    /**
     * @notice Computes the address where a contract would be deployed by this factory
     * @dev Returns address based on this factory, salt, and initcode hash
     * @param salt The salt used for address derivation
     * @param initCodeHash Hash of the contract creation bytecode
     * @return computedAddress The address where the contract will be deployed
     */
    function computeCreate2Address(bytes32 salt, bytes32 initCodeHash) external view returns (address computedAddress);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           CREATE3                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Deploys a contract using CREATE3 pattern with specified salt
     * @dev Eliminates initcode dependency from address derivation (unlike CREATE2)
     * @param salt The salt used for address derivation
     * @param initCode The contract creation bytecode and constructor args
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate3(bytes32 salt, bytes memory initCode) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE3 with a default salt of bytes32(0)
     * @dev Simplified CREATE3 deployment with zero salt
     * @param initCode The contract creation bytecode and constructor args
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate3(bytes memory initCode) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE3 and initializes it with a separate call
     * @dev Most complete CREATE3 deployment option with salt, init call, and refund
     * @param salt The salt used for address derivation
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @param refundAddress Address to receive any unused ETH
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate3AndInit(
        bytes32 salt,
        bytes memory initCode,
        bytes memory data,
        Values memory values,
        address refundAddress
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE3 and initializes it without refund
     * @dev CREATE3 deployment with salt and init call but no refund
     * @param salt The salt used for address derivation
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate3AndInit(
        bytes32 salt,
        bytes memory initCode,
        bytes memory data,
        Values memory values
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE3 with zero salt and initializes it
     * @dev Simplified CREATE3 with initialization and refund
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @param refundAddress Address to receive any unused ETH
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate3AndInit(
        bytes memory initCode,
        bytes memory data,
        Values memory values,
        address refundAddress
    ) external payable returns (address newContract);

    /**
     * @notice Deploys a contract using CREATE3 with zero salt and initializes it without refund
     * @dev Minimal CREATE3 with initialization
     * @param initCode The contract creation bytecode and constructor args
     * @param data Initialization calldata for the post-deployment call
     * @param values ETH amounts to send during creation and initialization
     * @return newContract Address of the newly deployed contract
     */
    function deployCreate3AndInit(
        bytes memory initCode,
        bytes memory data,
        Values memory values
    ) external payable returns (address newContract);

    /**
     * @notice Computes the address where a contract would be deployed using CREATE3
     * @dev CREATE3 addresses depend only on deployer and salt (not initcode)
     * @param salt The salt used for address derivation
     * @param deployer The address that will deploy the contract
     * @return computedAddress The address where the contract will be deployed
     */
    function computeCreate3Address(bytes32 salt, address deployer) external pure returns (address computedAddress);

    /**
     * @notice Computes the address where a contract would be deployed by this factory
     * @dev Returns address based on this factory and salt only
     * @param salt The salt used for address derivation
     * @return computedAddress The address where the contract will be deployed
     */
    function computeCreate3Address(bytes32 salt) external view returns (address computedAddress);
}