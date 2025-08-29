// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IPOL
 * @notice Interface for Bridge-wrapped POL (POL) on Katana
 * @dev POL implements the standard ERC-20 interface
 * @custom:katana 0xb24e3035d1FCBC0E43CF3143C3Fd92E53df2009b
 * @custom:katana ethereum:0x455e53CBB86018Ac2B8092FdCd39d8444aFFC3F6
 * @custom:tags erc20,token,governance,polygon,pol
 */
interface IPOL is IERC20 {
    // POL fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}