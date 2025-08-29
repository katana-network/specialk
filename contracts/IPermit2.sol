// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IPermit2
 * @notice Comprehensive interface for Uniswap's Permit2 system, combining allowance transfers and signature-based transfers
 * @dev Unifies functionality from multiple Permit2 interfaces for token approvals and transfers
 * @custom:tatara 0x000000000022D473030F116dDEE9F6B43aC78BA3
 * @custom:tags utility,permit,erc20,signature,uniswap
 */
interface IPermit2 {
    /// -----------------------------------------------------------------------
    /// CONSTANTS
    /// -----------------------------------------------------------------------
    
    /**
     * @dev EIP-712 types for AllowanceTransfer
     * @dev See https://eips.ethereum.org/EIPS/eip-712
     */
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit data struct
    /// @dev keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    function PERMIT_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit with allowance data struct
    /// @dev keccak256("PermitWithAllowance(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline,uint48 expiration)");
    function PERMIT_WITH_ALLOWANCE_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit batch data struct
    /// @dev keccak256("PermitBatch(address owner,PermitDetails[] details,uint256 nonce,uint256 deadline)")
    function PERMIT_BATCH_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit details data struct
    /// @dev keccak256("PermitDetails(address token,uint160 amount,uint48 expiration,uint48 nonce)")
    function PERMIT_DETAILS_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit batch with allowance data struct
    /// @dev keccak256("PermitBatchWithAllowance(address owner,PermitDetailsWithAllowance[] details,uint256 nonce,uint256 deadline)")
    function PERMIT_BATCH_WITH_ALLOWANCE_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit details with allowance data struct
    /// @dev keccak256("PermitDetailsWithAllowance(address token,uint160 amount,uint48 expiration,uint48 nonce,address allowanceTarget,uint48 allowanceExpiration)")
    function PERMIT_DETAILS_WITH_ALLOWANCE_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the transfer details struct
    /// @dev keccak256("TransferDetails(address to,uint256 amount)");
    function TRANSFER_DETAILS_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the token permissions data struct
    /// @dev keccak256("TokenPermissions(address token,uint256 amount)");
    function TOKEN_PERMISSIONS_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit transfer data struct
    /// @dev keccak256("PermitTransferFrom(TokenPermissions permitted,address spender,uint256 nonce,uint256 deadline)");
    function PERMIT_TRANSFER_FROM_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit transfer batch data struct
    /// @dev keccak256("PermitBatchTransferFrom(TokenPermissions[] permitted,address spender,uint256 nonce,uint256 deadline)");
    function PERMIT_BATCH_TRANSFER_FROM_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit witness transfer data struct
    /// @dev keccak256("PermitWitnessTransferFrom(TokenPermissions permitted,address spender,uint256 nonce,uint256 deadline,bytes32 witness)");
    function PERMIT_WITNESS_TRANSFER_FROM_TYPEHASH() external view returns (bytes32);
    
    /// @dev The EIP-712 typeHash for the permit witness transfer batch data struct
    /// @dev keccak256("PermitBatchWitnessTransferFrom(TokenPermissions[] permitted,address spender,uint256 nonce,uint256 deadline,bytes32 witness)");
    function PERMIT_BATCH_WITNESS_TRANSFER_FROM_TYPEHASH() external view returns (bytes32);

    /// -----------------------------------------------------------------------
    /// STRUCTS
    /// -----------------------------------------------------------------------
    
    /**
     * @notice Details for the permit allowance
     * @param token The token address
     * @param amount The maximum amount allowed to spend
     * @param expiration Expiration timestamp for the permit
     * @param nonce A unique value for each permit
     */
    struct PermitDetails {
        address token;
        uint160 amount;
        uint48 expiration;
        uint48 nonce;
    }
    
    /**
     * @notice Extended details for the permit allowance with allowance target
     * @param token The token address
     * @param amount The maximum amount allowed to spend
     * @param expiration Expiration timestamp for the permit
     * @param nonce A unique value for each permit
     * @param allowanceTarget The target address for the allowance
     * @param allowanceExpiration Expiration timestamp for the allowance
     */
    struct PermitDetailsWithAllowance {
        address token;
        uint160 amount;
        uint48 expiration;
        uint48 nonce;
        address allowanceTarget;
        uint48 allowanceExpiration;
    }
    
    /**
     * @notice Transfer details for token transfers
     * @param to The recipient address
     * @param amount The amount to transfer
     */
    struct TransferDetails {
        address to;
        uint256 amount;
    }
    
    /**
     * @notice Allowance transfer details
     * @param from The source address
     * @param to The recipient address
     * @param amount The amount to transfer
     * @param token The token address
     */
    struct AllowanceTransferDetails {
        address from;
        address to;
        uint160 amount;
        address token;
    }
    
    /**
     * @notice Token permissions for signature-based transfers
     * @param token The token address
     * @param amount The amount allowed to transfer
     */
    struct TokenPermissions {
        address token;
        uint256 amount;
    }
    
    /**
     * @notice Single signed transfer parameters
     * @param permitted Token permissions for the transfer
     * @param nonce A unique value for each permit
     * @param deadline Expiration timestamp for the signature
     */
    struct PermitTransferFrom {
        TokenPermissions permitted;
        address spender;
        uint256 nonce;
        uint256 deadline;
    }
    
    /**
     * @notice Signed transfer parameters with a witness
     * @param permitted Token permissions for the transfer
     * @param nonce A unique value for each permit
     * @param deadline Expiration timestamp for the signature
     * @param witness Additional data to be verified
     */
    struct PermitWitnessTransferFrom {
        TokenPermissions permitted;
        address spender;
        uint256 nonce;
        uint256 deadline;
        bytes32 witness;
    }
    
    /**
     * @notice Batch signed transfer parameters
     * @param permitted Array of token permissions for multiple transfers
     * @param nonce A unique value for each permit
     * @param deadline Expiration timestamp for the signature
     */
    struct PermitBatchTransferFrom {
        TokenPermissions[] permitted;
        address spender;
        uint256 nonce;
        uint256 deadline;
    }
    
    /**
     * @notice Batch signed transfer parameters with a witness
     * @param permitted Array of token permissions for multiple transfers
     * @param nonce A unique value for each permit
     * @param deadline Expiration timestamp for the signature
     * @param witness Additional data to be verified
     */
    struct PermitBatchWitnessTransferFrom {
        TokenPermissions[] permitted;
        address spender;
        uint256 nonce;
        uint256 deadline;
        bytes32 witness;
    }
    
    /**
     * @notice Packed allowance for a token
     * @param amount The approved amount
     * @param expiration The expiration timestamp
     * @param nonce The current nonce for the allowance
     */
    struct PackedAllowance {
        uint160 amount;
        uint48 expiration;
        uint48 nonce;
    }

    /// -----------------------------------------------------------------------
    /// EVENTS
    /// -----------------------------------------------------------------------
    
    /**
     * @notice Emitted when an allowance is approved
     * @param owner The owner of the tokens
     * @param token The token address
     * @param spender The address allowed to spend the tokens
     * @param amount The maximum amount allowed to spend
     * @param expiration The expiration timestamp for the permit
     * @param nonce The nonce for the permit
     */
    event Approval(
        address indexed owner, 
        address indexed token, 
        address indexed spender, 
        uint160 amount, 
        uint48 expiration, 
        uint48 nonce
    );
    
    /**
     * @notice Emitted when an allowance is revoked
     * @param owner The owner of the tokens
     * @param token The token address
     * @param spender The address that was allowed to spend the tokens
     * @param nonce The nonce for the revoked permit
     */
    event Lockdown(
        address indexed owner, 
        address indexed token, 
        address indexed spender, 
        uint48 nonce
    );
    
    /**
     * @notice Emitted when a token is transferred using the allowance
     * @param owner The owner of the tokens
     * @param token The token address
     * @param spender The address that spent the tokens
     * @param amount The amount that was spent
     */
    event Transfer(
        address indexed owner, 
        address indexed token, 
        address indexed spender, 
        uint160 amount, 
        uint48 expiration, 
        uint48 nonce
    );
    
    /**
     * @notice Emitted when a transfer has been performed via signature
     * @param token The token address
     * @param from The source address
     * @param to The recipient address
     * @param amount The amount transferred
     * @param nonce The nonce used for the signature
     */
    event SignatureTransfer(
        address indexed token, 
        address indexed from, 
        address indexed to, 
        uint256 amount, 
        uint256 nonce
    );

    /// -----------------------------------------------------------------------
    /// ERRORS
    /// -----------------------------------------------------------------------
    
    /// @notice The signature is invalid
    error InvalidSignature();
    
    /// @notice The signature has expired
    error SignatureExpired();
    
    /// @notice The signature has already been used
    error InvalidNonce();
    
    /// @notice The permit has expired
    error PermitExpired();
    
    /// @notice The requested amount exceeds the allowance
    error InsufficientAllowance();
    
    /// @notice Signature data must include a witness
    error WitnessRequired();
    
    /// @notice Additional data must be provided when using witness mode
    error MissingWitness();
    
    /// @notice Multiple copies of the same token provided
    error TokenContractMismatch();
    
    /// @notice The amount must be less than 2^160
    error InvalidAmount();

    /// -----------------------------------------------------------------------
    /// ALLOWANCE TRANSFER FUNCTIONS
    /// -----------------------------------------------------------------------
    
    /**
     * @notice Approve a spender to use the owner's tokens via owner's signature
     * @param owner The owner of the tokens
     * @param spender The address being approved to spend the tokens
     * @param amount The maximum amount allowed to spend
     * @param deadline The deadline by which the signature must be used
     * @param signature The owner's signature authorizing the approval
     */
    function permit(
        address owner,
        address spender,
        uint160 amount,
        uint256 deadline,
        bytes calldata signature
    ) external;
    
    /**
     * @notice Approve a spender to use the owner's tokens via owner's signature with expiration
     * @param owner The owner of the tokens
     * @param spender The address being approved to spend the tokens
     * @param amount The maximum amount allowed to spend
     * @param expiration The expiration timestamp for the allowance
     * @param deadline The deadline by which the signature must be used
     * @param signature The owner's signature authorizing the approval
     */
    function permitWithAllowance(
        address owner,
        address spender,
        uint160 amount,
        uint48 expiration,
        uint256 deadline,
        bytes calldata signature
    ) external;
    
    /**
     * @notice Batch approve spenders to use the owner's tokens via owner's signature
     * @param owner The owner of the tokens
     * @param permitDetails Array of permit details including tokens, amounts, and expirations
     * @param deadline The deadline by which the signature must be used
     * @param signature The owner's signature authorizing the approvals
     */
    function permitBatch(
        address owner,
        PermitDetails[] calldata permitDetails,
        uint256 deadline,
        bytes calldata signature
    ) external;
    
    /**
     * @notice Batch approve spenders to use the owner's tokens via owner's signature with allowance targets
     * @param owner The owner of the tokens
     * @param permitDetails Array of permit details including tokens, amounts, expirations, and allowance targets
     * @param deadline The deadline by which the signature must be used
     * @param signature The owner's signature authorizing the approvals
     */
    function permitBatchWithAllowance(
        address owner,
        PermitDetailsWithAllowance[] calldata permitDetails,
        uint256 deadline,
        bytes calldata signature
    ) external;
    
    /**
     * @notice Approve a spender for all token allowances owned by the caller
     * @param token The token address
     * @param spender The address being approved to spend the tokens
     * @param amount The maximum amount allowed to spend
     * @param expiration The expiration timestamp for the allowance
     */
    function approve(
        address token,
        address spender,
        uint160 amount,
        uint48 expiration
    ) external;
    
    /**
     * @notice Approve multiple allowances in a single transaction
     * @param approvals Array of allowance details
     */
    function approveBatch(PermitDetails[] calldata approvals) external;
    
    /**
     * @notice Increase the current allowance for a spender
     * @param token The token address
     * @param spender The address being approved to spend the tokens
     * @param amount The amount to increase the allowance by
     * @param expiration The new expiration timestamp (0 to keep the current one)
     */
    function increaseAllowance(
        address token,
        address spender,
        uint160 amount,
        uint48 expiration
    ) external;
    
    /**
     * @notice Revokes the allowance for a spender on a given token
     * @param token The token address
     * @param spender The address to revoke approval from
     */
    function revoke(address token, address spender) external;
    
    /**
     * @notice Revoke multiple allowances in a single transaction
     * @param approvals Array of token and spender pairs to revoke
     */
    function revokeBatch(PermitDetails[] calldata approvals) external;
    
    /**
     * @notice Revoke all allowances from all spenders across all tokens
     */
    function lockdown(PermitDetails[] calldata approvals) external;
    
    /**
     * @notice Transfer tokens from the owner to a recipient
     * @param from The owner of the tokens
     * @param to The recipient address
     * @param amount The amount to transfer
     * @param token The token address
     */
    function transferFrom(
        address from,
        address to,
        uint160 amount,
        address token
    ) external;
    
    /**
     * @notice Transfer multiple tokens from owners to recipients
     * @param transferDetails Array of transfer details
     */
    function transferFromBatch(
        AllowanceTransferDetails[] calldata transferDetails
    ) external;
    
    /**
     * @notice Retrieve the current allowance for a token-spender pair
     * @param owner The owner of the tokens
     * @param token The token address
     * @param spender The spender address
     * @return amount The current approved amount
     * @return expiration The expiration timestamp for the allowance
     * @return nonce The current nonce for the allowance
     */
    function allowance(
        address owner,
        address token,
        address spender
    ) external view returns (uint160 amount, uint48 expiration, uint48 nonce);

    /// -----------------------------------------------------------------------
    /// SIGNATURE TRANSFER FUNCTIONS
    /// -----------------------------------------------------------------------
    
    /**
     * @notice Transfer tokens with a signed permission
     * @param permit The signed permit data
     * @param transferDetails The transfer details
     * @param owner The owner of the tokens
     * @param signature The owner's signature authorizing the transfer
     */
    function permitTransferFrom(
        PermitTransferFrom calldata permit,
        TransferDetails calldata transferDetails,
        address owner,
        bytes calldata signature
    ) external;
    
    /**
     * @notice Transfer tokens with a signed permission that includes a witness value
     * @param permit The signed permit data with witness
     * @param transferDetails The transfer details
     * @param owner The owner of the tokens
     * @param signature The owner's signature authorizing the transfer
     * @param witnessData Additional data that resolves to the witness hash
     */
    function permitWitnessTransferFrom(
        PermitWitnessTransferFrom calldata permit,
        TransferDetails calldata transferDetails,
        address owner,
        bytes calldata signature,
        bytes calldata witnessData
    ) external;
    
    /**
     * @notice Transfer multiple tokens with a signed permission
     * @param permit The signed batch permit data
     * @param transferDetails Array of transfer details
     * @param owner The owner of the tokens
     * @param signature The owner's signature authorizing the transfers
     */
    function permitBatchTransferFrom(
        PermitBatchTransferFrom calldata permit,
        TransferDetails[] calldata transferDetails,
        address owner,
        bytes calldata signature
    ) external;
    
    /**
     * @notice Transfer multiple tokens with a signed permission that includes a witness value
     * @param permit The signed batch permit data with witness
     * @param transferDetails Array of transfer details
     * @param owner The owner of the tokens
     * @param signature The owner's signature authorizing the transfers
     * @param witnessData Additional data that resolves to the witness hash
     */
    function permitBatchWitnessTransferFrom(
        PermitBatchWitnessTransferFrom calldata permit,
        TransferDetails[] calldata transferDetails,
        address owner,
        bytes calldata signature,
        bytes calldata witnessData
    ) external;
    
    /**
     * @notice Check if the nonce has been used for an owner
     * @param owner The owner address
     * @param nonce The nonce to check
     * @return True if the nonce has been used, false otherwise
     */
    function nonceBitmap(address owner, uint256 nonce) external view returns (uint256);
    
    /**
     * @notice Invalidate an ordered nonce for the caller
     * @param token The token address
     * @param spender The spender address
     * @param newNonce The new nonce to use
     */
    function invalidateNonces(address token, address spender, uint48 newNonce) external;
} 