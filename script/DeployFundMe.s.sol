// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    // contract address for Chainlink price feed oracles on different networks

    function run() external returns (FundMe){   
        // contract address for Chainlink price feed oracles on different networks
        address BASE_SEPOLIA = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;
        // address MAINNET_SEPOLIA = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        // address AVALANCHE_TESTNET = 0x86d67c3D38D2bCeE722E601025C25a575021c6EA;

        vm.startBroadcast();
            FundMe fundMe = new FundMe(BASE_SEPOLIA);
        vm.stopBroadcast();

        return fundMe;
    } 
}