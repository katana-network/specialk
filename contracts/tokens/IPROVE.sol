// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IPROVE
 * @notice Interface for Bridge-wrapped Succinct (PROVE) on Katana
 * @dev PROVE implements the standard ERC-20 interface
 * @custom:katana 0xb244Add9FE6cB17558221e4Dfea960e680CCD29b
 * @custom:katana ethereum:0x6bef15d938d4e72056ac92ea4bdd0d76b1c4ad29
 * @custom:tags erc20,token,polygon,succinct,prove
 */
interface IPROVE is IERC20 {
    // PROVE fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}