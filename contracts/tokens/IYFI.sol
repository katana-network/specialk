// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IYFI
 * @notice Interface for Bridge-wrapped Yearn Finance (YFI) on Katana
 * @dev YFI implements the standard ERC-20 interface
 * @custom:katana 0x476eaCd417cD65421bD34fca054377658BB5E02b
 * @custom:katana ethereum:0x0bc529c00c6401aef6d220be8c6ea1667f6ad93e
 * @custom:tags erc20,token,governance,yearn,yfi
 */
interface IYFI is IERC20 {
    // YFI fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}