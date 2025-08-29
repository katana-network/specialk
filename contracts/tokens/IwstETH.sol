// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @title IwstETH
 * @notice Interface for Bridge-wrapped wstETH (wstETH) on Katana
 * @dev wstETH implements the standard ERC-20 interface
 * @custom:katana 0x7Fb4D0f51544F24F385a421Db6e7D4fC71Ad8e5C
 * @custom:katana ethereum:0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0
 * @custom:tags erc20,token,staking,wsteth,lido
 */
interface IwstETH is IERC20 {
    // wstETH fully implements the ERC-20 standard
    // This interface exists to document the token address and potential future extensions
}