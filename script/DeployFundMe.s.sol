// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    // contract address for Chainlink price feed oracles on different networks

    function run() external returns (FundMe){   
        // get contract address for Chainlink price feed oracles on different networks
        HelperConfig helperConfig = new HelperConfig();
        address ethUSDPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
            FundMe fundMe = new FundMe(ethUSDPriceFeed);
        vm.stopBroadcast();

        return fundMe;
    } 
}