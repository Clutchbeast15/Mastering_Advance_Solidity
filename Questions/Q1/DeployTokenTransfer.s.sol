// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {TokenTransfer} from "../src/TokenTransfer.sol";
import {console} from "forge-std/console.sol";

contract DeployTokenTransfer is Script{

        
        function run() external{
                vm.startBroadcast();
                TokenTransfer tokenTransfer = new TokenTransfer();
                vm.stopBroadcast();

                console.log("TokenTransfer contract address: ",address(tokenTransfer));
                
        }
}