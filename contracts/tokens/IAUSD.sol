// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IAUSD
 * @notice Interface for Agora USD (AUSD), the stablecoin on Katana
 * @dev AUSD implements the standard ERC-20 interface
 * @custom:tatara 0xa9012a055bd4e0eDfF8Ce09f960291C09D5322dC
 * @custom:katana 0x00000000eFE302BEAA2b3e6e1b18d08D69a9012a
 * @custom:katana ethereum:0x00000000eFE302BEAA2b3e6e1b18d08D69a9012a
 * @custom:tags erc20,token,stablecoin,ausd
 */
interface IAUSD is IERC20 {
    // AUSD fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
} 