// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IPolygonZkEVMDeployer
 * @notice Interface for the PolygonZkEVMDeployer contract which manages deployments of rollup components
 * @custom:tatara 0x36810012486fc134D0679c07f85fe5ba5A087D8C
 * @custom:tags agglayer,polygon,deployment,zkevm,rollup
 */
interface IPolygonZkEVMDeployer {
    /**
     * @notice Initializes a new PolygonZkEVM deployment
     * @param _admin Address that will be the admin of all the contracts
     * @param _chainID L2 chainID
     * @param _version Version of the PolygonZkEVM deployment
     * @param _gasTokenAddress Address of the token used to pay gas fees
     * @param _gasTokenNetwork Network where the token is deployed
     * @param _gasTokenMetadata Additional information about the token
     * @param _rollupVerifier RollupVerifier address
     */
    function initialize(
        address _admin,
        uint64 _chainID,
        string calldata _version,
        address _gasTokenAddress,
        uint32 _gasTokenNetwork,
        bytes calldata _gasTokenMetadata,
        address _rollupVerifier
    ) external;

    /**
     * @notice Checks if an account is the admin of the contract
     * @param account The address to check
     * @return True if the account is the admin
     */
    function isAdmin(address account) external view returns (bool);

    /**
     * @notice Returns the L2 chain ID of this deployment
     * @return The chain ID
     */
    function chainID() external view returns (uint64);

    /**
     * @notice Returns the version of this deployment
     * @return The version string
     */
    function version() external view returns (string memory);

    /**
     * @notice Returns the RollupVerifier address
     * @return The RollupVerifier address
     */
    function rollupVerifier() external view returns (address);

    /**
     * @notice Returns the gas token address
     * @return The address of the token used for gas
     */
    function gasTokenAddress() external view returns (address);

    /**
     * @notice Returns the gas token network
     * @return The network ID where the gas token is deployed
     */
    function gasTokenNetwork() external view returns (uint32);

    /**
     * @notice Returns the gas token metadata
     * @return The gas token metadata
     */
    function gasTokenMetadata() external view returns (bytes memory);
} 