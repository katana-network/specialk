// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IGnosisSafe.sol";

/**
 * @title IGnosisSafeL2
 * @dev Interface for the Gnosis Safe L2 multisignature wallet on Katana
 * @notice This contract extends IGnosisSafe with L2-specific optimizations and events
 * @custom:tatara 0xfb1bffC9d739B8D520DaF37dF666da4C687191EA
 */
interface IGnosisSafeL2 is IGnosisSafe {
    /**
     * @dev Emitted when a multisig transaction is executed through the Safe
     * @notice Contains more details than the standard SafeSuccess event for L2 indexing
     */
    event SafeMultiSigTransaction(
        address to,
        uint256 value,
        bytes data,
        Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address payable refundReceiver,
        bytes signatures,
        // Combined data containing nonce, sender and threshold
        bytes additionalInfo
    );

    /**
     * @dev Emitted when a transaction is executed by a module
     */
    event SafeModuleTransaction(
        address module, 
        address to, 
        uint256 value, 
        bytes data, 
        Operation operation
    );

    /**
     * @dev Allows to execute a Safe transaction confirmed by required number of owners
     * @notice This overrides the execTransaction method in GnosisSafe with L2 optimizations
     * @param to Destination address of Safe transaction
     * @param value Ether value of Safe transaction
     * @param data Data payload of Safe transaction
     * @param operation Operation type of Safe transaction
     * @param safeTxGas Gas that should be used for the Safe transaction
     * @param baseGas Gas costs that are independent of the transaction execution
     * @param gasPrice Gas price that should be used for the payment calculation
     * @param gasToken Token address (or 0 if ETH) that is used for the payment
     * @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin)
     * @param signatures Packed signature data ({bytes32 r}{bytes32 s}{uint8 v})
     * @return success Returns boolean indicating whether the transaction executed successfully
     */
    function execTransaction(
        address to,
        uint256 value,
        bytes calldata data,
        Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address payable refundReceiver,
        bytes memory signatures
    ) external payable override returns (bool success);

    /**
     * @dev Allows a Module to execute a Safe transaction without any further confirmations
     * @notice This overrides the execTransactionFromModule method in GnosisSafe with L2 optimizations
     * @param to Destination address of module transaction
     * @param value Ether value of module transaction
     * @param data Data payload of module transaction
     * @param operation Operation type of module transaction
     * @return success Returns boolean indicating whether the transaction executed successfully
     */
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes memory data,
        Operation operation
    ) external returns (bool success);

    /**
     * @dev Allows a Module to execute a Safe transaction without any further confirmations and with a specific nonce
     * @param to Destination address of module transaction
     * @param value Ether value of module transaction
     * @param data Data payload of module transaction
     * @param operation Operation type of module transaction
     * @param nonce Transaction nonce
     * @return success Returns boolean indicating whether the transaction executed successfully
     */
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes calldata data,
        Operation operation,
        uint256 nonce
    ) external override returns (bool success);
} 