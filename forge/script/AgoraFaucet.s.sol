// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import { IAgoraFaucet } from "contracts/IAgoraFaucet.sol";
import { BokutoAddresses } from "contracts/utils/BokutoAddresses.sol";

contract CounterScript is Script {
    IAgoraFaucet public agoraFaucet;

    function setUp() public {
        agoraFaucet = IAgoraFaucet(BokutoAddresses.getAgoraFaucetAddress());
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        address msgSender = vm.addr(privateKey);
        console.log("msg.sender is : ", msgSender);

        vm.startBroadcast(privateKey);

        agoraFaucet.requestFunds(msgSender);

        vm.stopBroadcast();
    }
}
