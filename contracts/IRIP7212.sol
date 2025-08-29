// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IRIP7212 - Precompile for secp256r1 (P-256) Curve Support
 * @notice Interface for the RIP-7212 precompile that enables efficient verification of P-256 signatures
 * @dev Located at address 0x0000000000000000000000000000000000000100 on chains that support RIP-7212
 * @custom:tatara 0x0000000000000000000000000000000000000100
 * @custom:tags utility,cryptography,precompile,signature-verification
 */
interface IRIP7212 {
    /**
     * @notice Verifies a secp256r1 (P-256) signature
     * @dev This precompile significantly reduces gas costs for P-256 signature verification (only ~3450 gas)
     * @param hash The 32-byte message hash that was signed
     * @param r The r component of the ECDSA signature (32 bytes)
     * @param s The s component of the ECDSA signature (32 bytes)
     * @param x The x-coordinate of the public key (32 bytes)
     * @param y The y-coordinate of the public key (32 bytes)
     * @return valid True if the signature is valid, false otherwise
     */
    function verify(
        bytes32 hash,
        bytes32 r,
        bytes32 s,
        bytes32 x,
        bytes32 y
    ) external view returns (bool valid);
    
    /**
     * @notice Batch verifies multiple secp256r1 (P-256) signatures
     * @dev Efficiently verifies multiple signatures in a single call
     * @param hashes Array of 32-byte message hashes
     * @param rs Array of r components of the ECDSA signatures
     * @param ss Array of s components of the ECDSA signatures
     * @param xs Array of x-coordinates of the public keys
     * @param ys Array of y-coordinates of the public keys
     * @return valid True if all signatures are valid, false otherwise
     */
    function batchVerify(
        bytes32[] calldata hashes,
        bytes32[] calldata rs,
        bytes32[] calldata ss,
        bytes32[] calldata xs,
        bytes32[] calldata ys
    ) external view returns (bool valid);
} 