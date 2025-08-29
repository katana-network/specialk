// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IConduit
 * @notice Interface for OpenSea's Conduit contracts that enable transferring approved tokens
 * @dev Conduits are deployed by the ConduitController and can transfer ERC20/721/1155 tokens
 * @custom:address Contract addresses are generated dynamically based on the conduit key
 * @custom:tags opensea,nft,marketplace,conduit
 */
interface IConduit {
    /**
     * @notice Item type identifiers for ERC20, ERC721, and ERC1155
     */
    enum ItemType {
        ERC20,
        ERC721,
        ERC1155,
        NATIVE
    }
    
    /**
     * @notice An item that can be transferred
     */
    struct TransferItem {
        ItemType itemType;     // The type of item
        address token;         // The token contract
        address from;          // The originator of the transfer
        address to;            // The recipient of the transfer
        uint256 identifier;    // The tokenId (for ERC721 and ERC1155)
        uint256 amount;        // The amount to transfer (for ERC20 and ERC1155)
    }
    
    /**
     * @notice Execute multiple transfers in a single call
     * @dev Only callable by an open channel on the conduit
     * @param transferItems Array of TransferItem structs containing transfer data
     */
    function execute(TransferItem[] calldata transferItems) external;
    
    /**
     * @notice Execute a batch ERC1155 token transfer (safeTransferFrom)
     * @dev Only callable by an open channel on the conduit
     * @param token The ERC1155 token contract address
     * @param from The address to transfer tokens from
     * @param to The address to transfer tokens to
     * @param ids Array of token IDs to transfer
     * @param amounts Array of amounts to transfer for each token ID
     */
    function executeBatch1155(
        address token,
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts
    ) external;
    
    /**
     * @notice Update a channel's status
     * @dev Only callable by the associated conduit controller
     * @param channel The channel to update
     * @param isOpen The new status of the channel (open or closed)
     */
    function updateChannel(address channel, bool isOpen) external;
} 