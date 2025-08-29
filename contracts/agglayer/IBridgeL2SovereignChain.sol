// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IBridgeL2SovereignChain
 * @notice Interface for the BridgeL2SovereignChain contract which handles cross-chain message passing
 * @dev Proxy. Implementation address tatara: 0x8BD36ca1A55e389335004872aA3C3Be0969D3aA7
 * @custom:tatara 0x528e26b25a34a4A5d0dbDa1d57D318153d2ED582
 * @custom:tags agglayer,bridge,polygon,crosschain,sovereign
 */
interface IBridgeL2SovereignChain {
    /**
     * @notice Data structure for a bridge message
     * @param originAddress Address that triggered the message on the origin network
     * @param originNetwork Network identifier where the message originated
     * @param destinationAddress Address to receive the message on the destination network
     * @param destinationNetwork Network identifier where the message will be delivered
     * @param amount Amount of tokens to be transferred
     * @param metadata Additional data to be used by the destination contract
     */
    struct BridgeMessage {
        address originAddress;
        uint32 originNetwork;
        address destinationAddress;
        uint32 destinationNetwork;
        uint256 amount;
        bytes metadata;
    }

    /**
     * @notice Event emitted when a bridge operation is initiated
     * @param originNetwork Origin network identifier
     * @param originAddress Origin sender address
     * @param destinationNetwork Destination network identifier
     * @param destinationAddress Destination receiver address
     * @param amount Token amount
     * @param metadata Additional data included in the message
     * @param depositCount Unique identifier for the message
     */
    event BridgeEvent(
        uint32 indexed originNetwork,
        address indexed originAddress,
        uint32 indexed destinationNetwork,
        address destinationAddress,
        uint256 amount,
        bytes metadata,
        uint32 depositCount
    );

    /**
     * @notice Event emitted when a bridge operation is claimed
     * @param originNetwork Origin network identifier
     * @param originAddress Origin sender address
     * @param destinationNetwork Destination network identifier
     * @param destinationAddress Destination receiver address
     * @param amount Token amount
     * @param metadata Additional data included in the message
     * @param depositCount Unique identifier for the message
     */
    event ClaimEvent(
        uint32 indexed originNetwork,
        address indexed originAddress,
        uint32 indexed destinationNetwork,
        address destinationAddress,
        uint256 amount,
        bytes metadata,
        uint32 depositCount
    );

    /**
     * @notice Initializes the bridge with required parameters
     * @param _networkID Current network identifier
     * @param _globalExitRootManager Address of the GlobalExitRootManager contract
     * @param _polygonZkEVMaddress Address of the Polygon ZkEVM contract
     */
    function initialize(
        uint32 _networkID,
        address _globalExitRootManager,
        address _polygonZkEVMaddress
    ) external;

    /**
     * @notice Bridges assets to a destination network
     * @param destinationNetwork Network identifier where funds will be claimed
     * @param destinationAddress Address that will receive the funds
     * @param amount Amount of tokens to bridge
     * @param token Token address to bridge (0x0 for native assets)
     * @param permitData Data for ERC20 permit if token approval is needed
     * @param metadata Additional data to be used by the destination contract
     * @return depositCount Unique identifier for the bridge operation
     */
    function bridgeAsset(
        uint32 destinationNetwork,
        address destinationAddress,
        uint256 amount,
        address token,
        bytes calldata permitData,
        bytes calldata metadata
    ) external payable returns (uint32);

    /**
     * @notice Bridges a message to a destination network
     * @param destinationNetwork Network identifier where the message will be delivered
     * @param destinationAddress Address that will receive the message
     * @param metadata Message data to be bridged
     * @return depositCount Unique identifier for the bridge operation
     */
    function bridgeMessage(
        uint32 destinationNetwork,
        address destinationAddress,
        bytes calldata metadata
    ) external payable returns (uint32);

    /**
     * @notice Claims a bridge message on the destination chain
     * @param smtProof Merkle proof of the message inclusion
     * @param index Index of the message in the Merkle tree
     * @param mainnetExitRoot Exit root from the mainnet
     * @param rollupExitRoot Exit root from the rollup
     * @param originNetwork Origin network identifier
     * @param originAddress Origin sender address
     * @param destinationNetwork Destination network identifier
     * @param destinationAddress Destination receiver address
     * @param amount Token amount
     * @param metadata Additional data included in the message
     */
    function claimMessage(
        bytes32[] calldata smtProof,
        uint32 index,
        bytes32 mainnetExitRoot,
        bytes32 rollupExitRoot,
        uint32 originNetwork,
        address originAddress,
        uint32 destinationNetwork,
        address destinationAddress,
        uint256 amount,
        bytes calldata metadata
    ) external;

    /**
     * @notice Checks if a message has already been claimed
     * @param originNetwork Origin network identifier
     * @param originAddress Origin sender address
     * @param destinationNetwork Destination network identifier
     * @param destinationAddress Destination receiver address
     * @param amount Token amount
     * @param metadata Message data
     * @param depositCount Unique identifier for the message
     * @return True if the message has been claimed
     */
    function isClaimed(
        uint32 originNetwork,
        address originAddress,
        uint32 destinationNetwork,
        address destinationAddress,
        uint256 amount,
        bytes calldata metadata,
        uint32 depositCount
    ) external view returns (bool);

    /**
     * @notice Returns the current network identifier
     * @return The network ID
     */
    function networkID() external view returns (uint32);

    /**
     * @notice Returns the deposit count, which is used as an identifier for messages
     * @return The current deposit count
     */
    function depositCount() external view returns (uint32);

    /**
     * @notice Returns the address of the GlobalExitRootManager contract
     * @return The address of the GlobalExitRootManager
     */
    function globalExitRootManager() external view returns (address);

    /**
     * @notice Returns the address of the PolygonZkEVM contract
     * @return The address of the PolygonZkEVM
     */
    function polygonZkEVMaddress() external view returns (address);
} 