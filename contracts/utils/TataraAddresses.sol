// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TataraAddresses
 * @notice Library for accessing Tatara network contract addresses
 * @dev Auto-generated from contract doccomments. Do not edit manually.
 */
library TataraAddresses {
    /**
     * @notice Chain ID for Tatara network
     */
    uint256 internal constant CHAIN_ID = 129399;

    /**
     * @notice Returns the address of IAgoraFaucet
     * @return The IAgoraFaucet contract address
     */
    function getAgoraFaucetAddress() internal pure returns (address) {
        return 0xd236c18D274E54FAccC3dd9DDA4b27965a73ee6C;
    }

    /**
     * @notice Returns the address of IAUSD
     * @return The IAUSD contract address
     */
    function getAUSDAddress() internal pure returns (address) {
        return 0xa9012a055bd4e0eDfF8Ce09f960291C09D5322dC;
    }

    /**
     * @notice Returns the address of IBatchDistributor
     * @return The IBatchDistributor contract address
     */
    function getBatchDistributorAddress() internal pure returns (address) {
        return 0x36C38895A20c835F9A6A294821D669995eB2265E;
    }

    /**
     * @notice Returns the address of IBridgeL2SovereignChain
     * @return The IBridgeL2SovereignChain contract address
     */
    function getBridgeL2SovereignChainAddress() internal pure returns (address) {
        return 0x528e26b25a34a4A5d0dbDa1d57D318153d2ED582;
    }

    /**
     * @notice Returns the address of IBundler3
     * @return The IBundler3 contract address
     */
    function getBundler3Address() internal pure returns (address) {
        return 0xD0bDf3E62F6750Bd83A50b4001743898Af287009;
    }

    /**
     * @notice Returns the address of IbvbEth
     * @return The IbvbEth contract address
     */
    function getIbvbEthAddress() internal pure returns (address) {
        return 0x17B8Ee96E3bcB3b04b3e8334de4524520C51caB4;
    }

    /**
     * @notice Returns the address of IbvbUSDC
     * @return The IbvbUSDC contract address
     */
    function getIbvbUSDCAddress() internal pure returns (address) {
        return 0x102E14ffF48170F2e5b6d0e30259fCD4eE5E28aE;
    }

    /**
     * @notice Returns the address of IbvbUSDS
     * @return The IbvbUSDS contract address
     */
    function getIbvbUSDSAddress() internal pure returns (address) {
        return 0xD416d04845d299bCC0e5105414C99fFc88f0C97d;
    }

    /**
     * @notice Returns the address of IbvbUSDT
     * @return The IbvbUSDT contract address
     */
    function getIbvbUSDTAddress() internal pure returns (address) {
        return 0xDe51Ef59663e79B494E1236551187399D3359C92;
    }

    /**
     * @notice Returns the address of IbvbWBTC
     * @return The IbvbWBTC contract address
     */
    function getIbvbWBTCAddress() internal pure returns (address) {
        return 0x1538aDF273f6f13CcdcdBa41A5ce4b2DC2177D1C;
    }

    /**
     * @notice Returns the address of IConduitController
     * @return The IConduitController contract address
     */
    function getConduitControllerAddress() internal pure returns (address) {
        return 0x00000000F9490004C11Cef243f5400493c00Ad63;
    }

    /**
     * @notice Returns the address of ICreate2Deployer
     * @return The ICreate2Deployer contract address
     */
    function getCreate2DeployerAddress() internal pure returns (address) {
        return 0x13b0D85CcB8bf860b6b79AF3029fCA081AE9beF2;
    }

    /**
     * @notice Returns the address of ICreateX
     * @return The ICreateX contract address
     */
    function getCreateXAddress() internal pure returns (address) {
        return 0xba5Ed099633D3B313e4D5F7bdc1305d3c28ba5Ed;
    }

    /**
     * @notice Returns the address of IDeterministicDeploymentProxy
     * @return The IDeterministicDeploymentProxy contract address
     */
    function getDeterministicDeploymentProxyAddress() internal pure returns (address) {
        return 0x4e59b44847b379578588920cA78FbF26c0B4956C;
    }

    /**
     * @notice Returns the address of IEntryPoint
     * @return The IEntryPoint contract address
     */
    function getEntryPointAddress() internal pure returns (address) {
        return 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789;
    }

    /**
     * @notice Returns the address of IEntryPointSimulations
     * @return The IEntryPointSimulations contract address
     */
    function getEntryPointSimulationsAddress() internal pure returns (address) {
        return 0x0000000071727De22E5E9d8BAf0edAc6f37da032;
    }

    /**
     * @notice Returns the address of IGlobalExitRootManagerL2SovereignChain
     * @return The IGlobalExitRootManagerL2SovereignChain contract address
     */
    function getGlobalExitRootManagerL2SovereignChainAddress() internal pure returns (address) {
        return 0xa40D5f56745a118D0906a34E69aeC8C0Db1cB8fA;
    }

    /**
     * @notice Returns the address of IGnosisSafe
     * @return The IGnosisSafe contract address
     */
    function getGnosisSafeAddress() internal pure returns (address) {
        return 0x69f4D1788e39c87893C980c06EdF4b7f686e2938;
    }

    /**
     * @notice Returns the address of IGnosisSafeL2
     * @return The IGnosisSafeL2 contract address
     */
    function getGnosisSafeL2Address() internal pure returns (address) {
        return 0xfb1bffC9d739B8D520DaF37dF666da4C687191EA;
    }

    /**
     * @notice Returns the address of IMetaMorphoFactory
     * @return The IMetaMorphoFactory contract address
     */
    function getMetaMorphoFactoryAddress() internal pure returns (address) {
        return 0x505619071bdCDeA154f164b323B6C42Fc14257f7;
    }

    /**
     * @notice Returns the address of IMorphoAdaptiveIRM
     * @return The IMorphoAdaptiveIRM contract address
     */
    function getMorphoAdaptiveIRMAddress() internal pure returns (address) {
        return 0x9eB6d0D85FCc07Bf34D69913031ade9E16BD5dB0;
    }

    /**
     * @notice Returns the address of IMorphoBlue
     * @return The IMorphoBlue contract address
     */
    function getMorphoBlueAddress() internal pure returns (address) {
        return 0xC263190b99ceb7e2b7409059D24CB573e3bB9021;
    }

    /**
     * @notice Returns the address of IMorphoChainlinkOracleV2Factory
     * @return The IMorphoChainlinkOracleV2Factory contract address
     */
    function getMorphoChainlinkOracleV2FactoryAddress() internal pure returns (address) {
        return 0xe795DD345aD7E1bC9e8F6B4437a21704d731F9E0;
    }

    /**
     * @notice Returns the address of IMulticall3
     * @return The IMulticall3 contract address
     */
    function getMulticall3Address() internal pure returns (address) {
        return 0xcA11bde05977b3631167028862bE2a173976CA11;
    }

    /**
     * @notice Returns the address of IMultiSend
     * @return The IMultiSend contract address
     */
    function getMultiSendAddress() internal pure returns (address) {
        return 0x998739BFdAAdde7C933B942a68053933098f9EDa;
    }

    /**
     * @notice Returns the address of IMultiSendCallOnly
     * @return The IMultiSendCallOnly contract address
     */
    function getMultiSendCallOnlyAddress() internal pure returns (address) {
        return 0xA1dabEF33b3B82c7814B6D82A79e50F4AC44102B;
    }

    /**
     * @notice Returns the address of IPermit2
     * @return The IPermit2 contract address
     */
    function getPermit2Address() internal pure returns (address) {
        return 0x000000000022D473030F116dDEE9F6B43aC78BA3;
    }

    /**
     * @notice Returns the address of IPolygonZkEVMDeployer
     * @return The IPolygonZkEVMDeployer contract address
     */
    function getPolygonZkEVMDeployerAddress() internal pure returns (address) {
        return 0x36810012486fc134D0679c07f85fe5ba5A087D8C;
    }

    /**
     * @notice Returns the address of IPolygonZkEVMTimelock
     * @return The IPolygonZkEVMTimelock contract address
     */
    function getPolygonZkEVMTimelockAddress() internal pure returns (address) {
        return 0xdbC6981a11fc2B000c635bFA7C47676b25C87D39;
    }

    /**
     * @notice Returns the address of IProxyAdmin
     * @return The IProxyAdmin contract address
     */
    function getProxyAdminAddress() internal pure returns (address) {
        return 0x85cEB41028B1a5ED2b88E395145344837308b251;
    }

    /**
     * @notice Returns the address of IPublicAllocator
     * @return The IPublicAllocator contract address
     */
    function getPublicAllocatorAddress() internal pure returns (address) {
        return 0x8FfD3815919081bDb60CD8079C68444331B65042;
    }

    /**
     * @notice Returns the address of IRedSnwapper
     * @return The IRedSnwapper contract address
     */
    function getRedSnwapperAddress() internal pure returns (address) {
        return 0xAC4c6e212A361c968F1725b4d055b47E63F80b75;
    }

    /**
     * @notice Returns the address of IRIP7212
     * @return The IRIP7212 contract address
     */
    function getRIP7212Address() internal pure returns (address) {
        return 0x0000000000000000000000000000000000000100;
    }

    /**
     * @notice Returns the address of ISeaport
     * @return The ISeaport contract address
     */
    function getSeaportAddress() internal pure returns (address) {
        return 0x0000000000FFe8B47B3e2130213B802212439497;
    }

    /**
     * @notice Returns the address of ISenderCreator
     * @return The ISenderCreator contract address
     */
    function getSenderCreatorAddress() internal pure returns (address) {
        return 0xEFC2c1444eBCC4Db75e7613d20C6a62fF67A167C;
    }

    /**
     * @notice Returns the address of ISenderCreator_AAv0_6_0_ISenderCreator
     * @return The ISenderCreator_AAv0_6_0_ISenderCreator contract address
     */
    function getSenderCreator_AAv0_6_0_ISenderCreatorAddress() internal pure returns (address) {
        return 0x7fc98430eAEdbb6070B35B39D798725049088348;
    }

    /**
     * @notice Returns the address of ISushiRouter
     * @return The ISushiRouter contract address
     */
    function getSushiRouterAddress() internal pure returns (address) {
        return 0xAC4c6e212A361c968F1725b4d055b47E63F80b75;
    }

    /**
     * @notice Returns the address of ISushiTickLens
     * @return The ISushiTickLens contract address
     */
    function getSushiTickLensAddress() internal pure returns (address) {
        return 0xb46e319390de313b8cc95ea5aa30c7bbfd79da94;
    }

    /**
     * @notice Returns the address of ISushiV2Factory
     * @return The ISushiV2Factory contract address
     */
    function getSushiV2FactoryAddress() internal pure returns (address) {
        return 0xb45e53277a7e0f1d35f2a77160e91e25507f1763;
    }

    /**
     * @notice Returns the address of IuBTC
     * @return The IuBTC contract address
     */
    function getIuBTCAddress() internal pure returns (address) {
        return 0xB295FDad3aD8521E9Bc20CAeBB36A4258038574e;
    }

    /**
     * @notice Returns the address of IUSDCNativeConverter
     * @return The IUSDCNativeConverter contract address
     */
    function getUSDCNativeConverterAddress() internal pure returns (address) {
        return 0x28FDCaF075242719b16D342866c9dd84cC459533;
    }

    /**
     * @notice Returns the address of IUSDSNativeConverter
     * @return The IUSDSNativeConverter contract address
     */
    function getUSDSNativeConverterAddress() internal pure returns (address) {
        return 0x56342E6093381E2Bd732FFd6141b22136efB98Bf;
    }

    /**
     * @notice Returns the address of IUSDTNativeConverter
     * @return The IUSDTNativeConverter contract address
     */
    function getUSDTNativeConverterAddress() internal pure returns (address) {
        return 0x8f3a47e64d3AD1fBdC5C23adD53183CcCD05D8a4;
    }

    /**
     * @notice Returns the address of IuSOL
     * @return The IuSOL contract address
     */
    function getIuSOLAddress() internal pure returns (address) {
        return 0x79b2417686870EFf463E37a1cA0fDA1c7e2442cE;
    }

    /**
     * @notice Returns the address of IuXRP
     * @return The IuXRP contract address
     */
    function getIuXRPAddress() internal pure returns (address) {
        return 0x26435983DF976A02C55aC28e6F67C6477bBd95E7;
    }

    /**
     * @notice Returns the address of IWBTCNativeConverter
     * @return The IWBTCNativeConverter contract address
     */
    function getWBTCNativeConverterAddress() internal pure returns (address) {
        return 0x3Ef265DD0b4B86fC51b08D5B03699E57d52C9B27;
    }

    /**
     * @notice Returns the address of IWETHNativeConverter
     * @return The IWETHNativeConverter contract address
     */
    function getWETHNativeConverterAddress() internal pure returns (address) {
        return 0x3aFbD158CF7B1E6BE4dAC88bC173FA65EBDf2EcD;
    }

    /**
     * @notice Returns the address of IYvAUSD
     * @return The IYvAUSD contract address
     */
    function getYvAUSDAddress() internal pure returns (address) {
        return 0xAe4b2FCf45566893Ee5009BA36792D5078e4AD60;
    }

    /**
     * @notice Returns the address of IYvWETH
     * @return The IYvWETH contract address
     */
    function getYvWETHAddress() internal pure returns (address) {
        return 0xccC0Fc2E34428120f985b460b487eB79E3C6FA57;
    }

    /**
     * @notice Returns the address of Multicall
     * @return The Multicall contract address
     */
    function getMulticallAddress() internal pure returns (address) {
        return 0x4e1d97344FFa4B55A2C6335574982aa9cB627C4F;
    }

    /**
     * @notice Returns the address of Multicall2
     * @return The Multicall2 contract address
     */
    function getMulticall2Address() internal pure returns (address) {
        return 0xfC0F3dADD7aE3708f352610aa71dF7C93087a676;
    }

    /**
     * @notice Returns the address of MyInterface
     * @return The MyInterface contract address
     */
    function getMyInterfaceAddress() internal pure returns (address) {
        return 0x0000000071727De22E5E9d8BAf0edAc6f37da032;
    }

    /**
     * @notice Returns the address of SushiV3Factory
     * @return The SushiV3Factory contract address
     */
    function getSushiV3FactoryAddress() internal pure returns (address) {
        return 0x9B3336186a38E1b6c21955d112dbb0343Ee061eE;
    }

    /**
     * @notice Returns the address of SushiV3PositionManager
     * @return The SushiV3PositionManager contract address
     */
    function getSushiV3PositionManagerAddress() internal pure returns (address) {
        return 0x1400feFD6F9b897970f00Df6237Ff2B8b27Dc82C;
    }

    /**
     * @notice Returns the address of UniswapV2Router02
     * @return The UniswapV2Router02 contract address
     */
    function getUniswapV2Router02Address() internal pure returns (address) {
        return 0x57bffa72db682f7eb6c132dae03ff36bbeb0c459;
    }

}