// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IConduitController
 * @notice Interface for OpenSea's Conduit Controller system that enables deploying and managing conduits
 * @dev Conduits allow registered callers (channels) to transfer approved ERC20/721/1155 tokens on their behalf
 * @custom:tatara 0x00000000F9490004C11Cef243f5400493c00Ad63
 * @custom:katana 0x00000000F9490004C11Cef243f5400493c00Ad63
 * @custom:bokuto 0x00000000F9490004C11Cef243f5400493c00Ad63
 * @custom:tags opensea,nft,marketplace,conduit,controller
 */
interface IConduitController {
    /**
     * @notice Properties of a conduit
     */
    struct ConduitProperties {
        address owner;       // Current owner of the conduit
        address potentialOwner;  // Potential owner that can accept ownership
        bytes32 conduitKey;  // The conduit key used to deploy the conduit
        uint256 totalChannels;   // The total number of open channels for the conduit
        mapping(address => bool) channels;  // Mapping of channels to their status
        address[] channelsList;  // Array of open channels
    }

    /**
     * @notice Deploy a new conduit using a supplied conduit key and assigning an initial owner for the deployed conduit
     * @dev The first twenty bytes of the supplied conduit key must match the caller
     * @param conduitKey The conduit key used to deploy the conduit
     * @param initialOwner The initial owner to set for the new conduit
     * @return conduit The address of the newly deployed conduit
     */
    function createConduit(
        bytes32 conduitKey,
        address initialOwner
    ) external returns (address conduit);

    /**
     * @notice Open or close a channel on a given conduit
     * @dev Only the owner of the conduit may call this function
     * @param conduit The conduit for which to open or close the channel
     * @param channel The channel to open or close on the conduit
     * @param isOpen A boolean indicating whether to open or close the channel
     */
    function updateChannel(
        address conduit,
        address channel,
        bool isOpen
    ) external;

    /**
     * @notice Initiate conduit ownership transfer
     * @dev Only the owner of the conduit may call this function
     * @param conduit The conduit for which to initiate ownership transfer
     * @param newPotentialOwner The new potential owner of the conduit
     */
    function transferOwnership(
        address conduit,
        address newPotentialOwner
    ) external;

    /**
     * @notice Clear the currently set potential owner from a conduit
     * @dev Only the owner of the conduit may call this function
     * @param conduit The conduit for which to cancel ownership transfer
     */
    function cancelOwnershipTransfer(address conduit) external;

    /**
     * @notice Accept ownership of a supplied conduit
     * @dev Only accounts that the current owner has set as the new potential owner may call this function
     * @param conduit The conduit for which to accept ownership
     */
    function acceptOwnership(address conduit) external;

    /**
     * @notice Retrieve the current owner of a deployed conduit
     * @param conduit The conduit for which to retrieve the associated owner
     * @return owner The owner of the supplied conduit
     */
    function ownerOf(address conduit) external view returns (address owner);

    /**
     * @notice Retrieve the conduit key for a deployed conduit via reverse lookup
     * @param conduit The conduit for which to retrieve the associated conduit key
     * @return conduitKey The conduit key used to deploy the supplied conduit
     */
    function getKey(address conduit) external view returns (bytes32 conduitKey);

    /**
     * @notice Derive the conduit associated with a given conduit key and determine whether that conduit exists
     * @param conduitKey The conduit key used to derive the conduit
     * @return conduit The derived address of the conduit
     * @return exists A boolean indicating whether the derived conduit has been deployed or not
     */
    function getConduit(bytes32 conduitKey) external view returns (
        address conduit,
        bool exists
    );

    /**
     * @notice Retrieve the potential owner, if any, for a given conduit
     * @param conduit The conduit for which to retrieve the potential owner
     * @return potentialOwner The potential owner, if any, for the conduit
     */
    function getPotentialOwner(address conduit) external view returns (address potentialOwner);

    /**
     * @notice Retrieve the status (either open or closed) of a given channel on a conduit
     * @param conduit The conduit for which to retrieve the channel status
     * @param channel The channel for which to retrieve the status
     * @return isOpen The status of the channel on the given conduit
     */
    function getChannelStatus(
        address conduit,
        address channel
    ) external view returns (bool isOpen);

    /**
     * @notice Retrieve the total number of open channels for a given conduit
     * @param conduit The conduit for which to retrieve the total channel count
     * @return totalChannels The total number of open channels for the conduit
     */
    function getTotalChannels(address conduit) external view returns (uint256 totalChannels);

    /**
     * @notice Retrieve an open channel at a specific index for a given conduit
     * @dev The index of a channel can change as a result of other channels being closed on the conduit
     * @param conduit The conduit for which to retrieve the open channel
     * @param channelIndex The index of the channel in question
     * @return channel The open channel, if any, at the specified channel index
     */
    function getChannel(
        address conduit,
        uint256 channelIndex
    ) external view returns (address channel);

    /**
     * @notice Retrieve all open channels for a given conduit
     * @dev This function may revert with an out-of-gas error for conduits with many channels
     * @param conduit The conduit for which to retrieve open channels
     * @return channels An array of open channels on the given conduit
     */
    function getChannels(address conduit) external view returns (address[] memory channels);

    /**
     * @notice Retrieve the conduit creation code and runtime code hashes
     * @return creationCodeHash The hash of the creation code
     * @return runtimeCodeHash The hash of the runtime code
     */
    function getConduitCodeHashes() external view returns (
        bytes32 creationCodeHash,
        bytes32 runtimeCodeHash
    );
} 