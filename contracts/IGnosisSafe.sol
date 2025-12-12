// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IGnosisSafe
 * @dev Interface for the Gnosis Safe multisignature wallet on Katana
 * @notice This contract enables multisig wallet functionality with support for ERC191 signatures
 * @custom:bokuto 0x69f4D1788e39c87893C980c06EdF4b7f686e2938
 * @custom:tags gnosis,multisig,wallet,security
 */
interface IGnosisSafe {
    enum Operation {
        Call,
        DelegateCall
    }

    /// @dev Setup event emitted on Safe initialization
    event SafeSetup(address indexed initiator, address[] owners, uint256 threshold, address initializer, address fallbackHandler);
    
    /// @dev Emitted when a new hash is approved by an owner
    event ApproveHash(bytes32 indexed approvedHash, address indexed owner);
    
    /// @dev Emitted when a message is signed
    event SignMsg(bytes32 indexed msgHash);
    
    /// @dev Emitted when an execution fails
    event ExecutionFailure(bytes32 txHash, uint256 payment);
    
    /// @dev Emitted when an execution succeeds
    event ExecutionSuccess(bytes32 txHash, uint256 payment);

    /**
     * @dev Initializes the Safe with owners and threshold
     * @param _owners List of Safe owners
     * @param _threshold Number of required confirmations for a Safe transaction
     * @param to Contract address for optional delegate call
     * @param data Data payload for optional delegate call
     * @param fallbackHandler Handler for fallback calls to this contract
     * @param paymentToken Token that should be used for the payment (0 is ETH)
     * @param payment Value that should be paid
     * @param paymentReceiver Address that should receive the payment (or 0 if tx.origin)
     */
    function setup(
        address[] calldata _owners,
        uint256 _threshold,
        address to,
        bytes calldata data,
        address fallbackHandler,
        address paymentToken,
        uint256 payment,
        address payable paymentReceiver
    ) external;

    /**
     * @dev Allows to execute a Safe transaction confirmed by required number of owners
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
        bytes calldata signatures
    ) external payable returns (bool success);

    /**
     * @dev Allows to execute a Safe transaction confirmed by required number of owners
     * and with specified nonce
     * @param to Destination address of Safe transaction
     * @param value Ether value of Safe transaction
     * @param data Data payload of Safe transaction
     * @param operation Operation type of Safe transaction
     * @param nonce Transaction nonce
     * @return success Returns boolean indicating whether the transaction executed successfully
     */
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes calldata data,
        Operation operation,
        uint256 nonce
    ) external returns (bool success);

    /**
     * @dev Marks a hash as approved
     * @param hashToApprove The hash that should be marked as approved for signatures
     */
    function approveHash(bytes32 hashToApprove) external;

    /**
     * @dev Returns the hash of a transaction with a specific nonce
     * @param to Destination address of Safe transaction
     * @param value Ether value of Safe transaction
     * @param data Data payload of Safe transaction
     * @param operation Operation type of Safe transaction
     * @param safeTxGas Gas that should be used for the Safe transaction
     * @param baseGas Gas costs for data used to trigger the safe transaction
     * @param gasPrice Maximum gas price that should be used for this transaction
     * @param gasToken Token address (or 0 if ETH) that is used for the payment
     * @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin)
     * @param _nonce Transaction nonce
     * @return Transaction hash
     */
    function getTransactionHash(
        address to,
        uint256 value,
        bytes calldata data,
        Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address refundReceiver,
        uint256 _nonce
    ) external view returns (bytes32);

    /**
     * @dev Returns hash to be signed by owners
     * @param to Destination address of Safe transaction
     * @param value Ether value of Safe transaction
     * @param data Data payload of Safe transaction
     * @param operation Operation type of Safe transaction
     * @param safeTxGas Gas that should be used for the Safe transaction
     * @param baseGas Gas costs for data used to trigger the safe transaction
     * @param gasPrice Maximum gas price that should be used for this transaction
     * @param gasToken Token address (or 0 if ETH) that is used for the payment
     * @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin)
     * @param _nonce Transaction nonce
     * @return Transaction hash bytes
     */
    function encodeTransactionData(
        address to,
        uint256 value,
        bytes calldata data,
        Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address refundReceiver,
        uint256 _nonce
    ) external view returns (bytes memory);

    /**
     * @dev Returns the chain id used by this contract
     * @return Chain ID
     */
    function getChainId() external view returns (uint256);

    /**
     * @dev Returns the domain separator for EIP-712 signing
     * @return Domain separator
     */
    function domainSeparator() external view returns (bytes32);

    /**
     * @dev Returns the current transaction nonce
     * @return Nonce value
     */
    function nonce() external view returns (uint256);

    /**
     * @dev Returns the Safe version string
     * @return Version string
     */
    function VERSION() external view returns (string memory);

    /**
     * @dev Checks if a hash is approved
     * @param owner Owner address
     * @param hash Hash to check
     * @return Approval status
     */
    function approvedHashes(address owner, bytes32 hash) external view returns (uint256);

    /**
     * @dev Adds an owner to the Safe
     * @param owner New owner address
     * @param _threshold New threshold
     */
    function addOwnerWithThreshold(address owner, uint256 _threshold) external;

    /**
     * @dev Removes an owner from the Safe
     * @param prevOwner Owner that points to the owner to be removed in the linked list
     * @param owner Owner address to be removed
     * @param _threshold New threshold
     */
    function removeOwner(address prevOwner, address owner, uint256 _threshold) external;

    /**
     * @dev Replaces an owner with a new owner
     * @param prevOwner Owner that points to the owner to be replaced in the linked list
     * @param oldOwner Owner address to be replaced
     * @param newOwner New owner address
     */
    function swapOwner(address prevOwner, address oldOwner, address newOwner) external;

    /**
     * @dev Changes the threshold of the Safe
     * @param _threshold New threshold
     */
    function changeThreshold(uint256 _threshold) external;

    /**
     * @dev Returns array of owners
     * @return Array of Safe owners
     */
    function getOwners() external view returns (address[] memory);

    /**
     * @dev Returns number of required confirmations
     * @return Safe threshold
     */
    function getThreshold() external view returns (uint256);

    /**
     * @dev Checks if an address is an owner
     * @param owner Address to check
     * @return Owner status
     */
    function isOwner(address owner) external view returns (bool);
} 