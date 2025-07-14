// Auto-generated contract address mapping
// Generated on 2025-07-03T02:55:09.164Z

/**
 * Chain IDs for Tatara testnet and Katana mainnet
 */
export interface ChainIds {
  TATARA: number;
  KATANA: number;
}

/**
 * Contract addresses for each network - using viem's Address type format
 */
export interface ContractAddresses {
  [contractName: string]: {
    tatara: `0x${string}` | null;
    katana: `0x${string}` | null;
  };
}

/**
 * Chain ID constants
 */
export const CHAIN_IDS: ChainIds = {
  TATARA: 471,
  KATANA: 747474
};

/**
 * Mapping of contract names to their addresses on each network
 */
export const CONTRACT_ADDRESSES: ContractAddresses = {
  "PolygonZkEVMDeployer": { "tatara": "0x36810012486fc134D0679c07f85fe5ba5A087D8C" as `0x${string}`, "katana": null },
  "ProxyAdmin": { "tatara": "0x85cEB41028B1a5ED2b88E395145344837308b251" as `0x${string}`, "katana": null },
  "BridgeL2SovereignChain": { "tatara": "0x528e26b25a34a4A5d0dbDa1d57D318153d2ED582" as `0x${string}`, "katana": null },
  "BridgeL2SovereignChainImplementation": { "tatara": "0x8BD36ca1A55e389335004872aA3C3Be0969D3aA7" as `0x${string}`, "katana": null },
  "GlobalExitRootManagerL2SovereignChain": { "tatara": "0xa40D5f56745a118D0906a34E69aeC8C0Db1cB8fA" as `0x${string}`, "katana": null },
  "GlobalExitRootManagerL2SovereignChainImplementation": { "tatara": "0x282a631D9F3Ef04Bf1A44B4C9e8bDC8EB278917f" as `0x${string}`, "katana": null },
  "PolygonZkEVMTimelock": { "tatara": "0xdbC6981a11fc2B000c635bFA7C47676b25C87D39" as `0x${string}`, "katana": null },
  "GnosisSafe": { "tatara": "0x69f4D1788e39c87893C980c06EdF4b7f686e2938" as `0x${string}`, "katana": null },
  "GnosisSafeL2": { "tatara": "0xfb1bffC9d739B8D520DaF37dF666da4C687191EA" as `0x${string}`, "katana": null },
  "MultiSend": { "tatara": "0x998739BFdAAdde7C933B942a68053933098f9EDa" as `0x${string}`, "katana": null },
  "MultiSendCallOnly": { "tatara": "0xA1dabEF33b3B82c7814B6D82A79e50F4AC44102B" as `0x${string}`, "katana": null },
  "DeterministicDeploymentProxy": { "tatara": "0x4e59b44847b379578588920cA78FbF26c0B4956C" as `0x${string}`, "katana": null },
  "Create2Deployer": { "tatara": "0x13b0D85CcB8bf860b6b79AF3029fCA081AE9beF2" as `0x${string}`, "katana": null },
  "CreateX": { "tatara": "0xba5Ed099633D3B313e4D5F7bdc1305d3c28ba5Ed" as `0x${string}`, "katana": null },
  "AUSD": { "tatara": "0xa9012a055bd4e0eDfF8Ce09f960291C09D5322dC" as `0x${string}`, "katana": "0x00000000efe302beaa2b3e6e1b18d08d69a9012a" },
  "WETH": { "tatara": "0x17B8Ee96E3bcB3b04b3e8334de4524520C51caB4" as `0x${string}`, "katana": null },
  "WETHNativeConverter": { "tatara": "0x3aFbD158CF7B1E6BE4dAC88bC173FA65EBDf2EcD" as `0x${string}`, "katana": null },
  "ybUSDC": { "tatara": "0xd8A986AFbB7e44e9F7D71cc529d7b28F7084028c" as `0x${string}`, "katana": null },
  "ybUSDT": { "tatara": "0xf5a675058bbd344a9f1Ab1AF00576Dfb404D57b2" as `0x${string}`, "katana": null },
  "ybWBTC": { "tatara": "0x9954f137ce70db2afEA291dfcE742b14d1535110" as `0x${string}`, "katana": null },
  "ybDAI": { "tatara": "0x106cbB7361c3D3D0a12A8160a714879CC13C5a29" as `0x${string}`, "katana": null },
  "USDCNativeConverter": { "tatara": "0xC4BaBEE541c2FA1EA55ce9aF9EB3B5C76B0CE5c7" as `0x${string}`, "katana": null },
  "USDTNativeConverter": { "tatara": "0xB69b7196F8fa4d531452d31B82e8068110cB82d4" as `0x${string}`, "katana": null },
  "WBTCNativeConverter": { "tatara": "0xB567390378c304E65139a60D44886F7B0150bBC0" as `0x${string}`, "katana": null },
  "DAINativeConverter": { "tatara": "0x6a99f2004044357A80E5D43345229179adc871D4" as `0x${string}`, "katana": null },
  "Seaport": { "tatara": "0x0000000000FFe8B47B3e2130213B802212439497" as `0x${string}`, "katana": null },
  "ConduitController": { "tatara": "0x00000000F9490004C11Cef243f5400493c00Ad63" as `0x${string}`, "katana": null },
  "SushiRouter": { "tatara": "0xAC4c6e212A361c968F1725b4d055b47E63F80b75" as `0x${string}`, "katana": null },
  "MorphoBlue": { "tatara": "0xC263190b99ceb7e2b7409059D24CB573e3bB9021" as `0x${string}`, "katana": null },
  "MorphoIRM": { "tatara": "0x9eB6d0D85FCc07Bf34D69913031ade9E16BD5dB0" as `0x${string}`, "katana": null },
  "MorphoAdaptiveIRM": { "tatara": "0x9eB6d0D85FCc07Bf34D69913031ade9E16BD5dB0" as `0x${string}`, "katana": null },
  "MetaMorphoFactory": { "tatara": "0x505619071bdCDeA154f164b323B6C42Fc14257f7" as `0x${string}`, "katana": null },
  "Bundler3": { "tatara": "0xD0bDf3E62F6750Bd83A50b4001743898Af287009" as `0x${string}`, "katana": null },
  "PublicAllocator": { "tatara": "0x8FfD3815919081bDb60CD8079C68444331B65042" as `0x${string}`, "katana": null },
  "MorphoChainlinkOracleV2Factory": { "tatara": "0xe795DD345aD7E1bC9e8F6B4437a21704d731F9E0" as `0x${string}`, "katana": null },
  "Multicall3": { "tatara": "0xcA11bde05977b3631167028862bE2a173976CA11" as `0x${string}`, "katana": null },
  "BatchDistributor": { "tatara": "0x36C38895A20c835F9A6A294821D669995eB2265E" as `0x${string}`, "katana": null },
  "Permit2": { "tatara": "0x000000000022D473030F116dDEE9F6B43aC78BA3" as `0x${string}`, "katana": null },
  "RIP7212": { "tatara": "0x0000000000000000000000000000000000000100" as `0x${string}`, "katana": null },
  "EntryPointV06": { "tatara": "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789" as `0x${string}`, "katana": null },
  "SenderCreatorV06": { "tatara": "0x7fc98430eAEdbb6070B35B39D798725049088348" as `0x${string}`, "katana": null },
  "EntryPointV07": { "tatara": "0x0000000071727De22E5E9d8BAf0edAc6f37da032" as `0x${string}`, "katana": null },
  "EntryPointSimulationsV07": { "tatara": "0x0000000071727De22E5E9d8BAf0edAc6f37da032" as `0x${string}`, "katana": null },
  "SenderCreatorV07": { "tatara": "0x00000000FC04C59277B65Bc2aC8c843392C3ca4c" as `0x${string}`, "katana": null },
  "YvAUSD": { "tatara": "0xAe4b2FCf45566893Ee5009BA36792D5078e4AD60" as `0x${string}`, "katana": null },
  "YvWETH": { "tatara": "0xccC0Fc2E34428120f985b460b487eB79E3C6FA57" as `0x${string}`, "katana": null }
};

/**
 * Get a contract address based on the contract name and chain ID
 * @param contractName - The name of the contract (without "get" and "Address")
 * @param chainId - The chain ID
 * @returns The contract address or null if not found
 */
export function getContractAddress(contractName: string, chainId: number): `0x${string}` | null {
  if (!contractName || !CONTRACT_ADDRESSES[contractName]) {
    return null;
  }
  
  switch (chainId) {
    case CHAIN_IDS.TATARA:
      return CONTRACT_ADDRESSES[contractName].tatara;
    case CHAIN_IDS.KATANA:
      return CONTRACT_ADDRESSES[contractName].katana;
    default:
      return null;
  }
}

export default getContractAddress;
