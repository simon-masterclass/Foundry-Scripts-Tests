// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    // contract address for Chainlink price feed oracles on different networks
    enum priceFeedAddr { BASE_SEPOLIA, MAINNET_SEPOLIA, AVALANCHE_TESTNET}

    mapping(priceFeedAddr => address) public priceFeedsEthUsd;

    function run() external {   
        priceFeedsEthUsd[priceFeedAddr.BASE_SEPOLIA] = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;
        priceFeedsEthUsd[priceFeedAddr.MAINNET_SEPOLIA] = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        priceFeedsEthUsd[priceFeedAddr.AVALANCHE_TESTNET] = 0x86d67c3D38D2bCeE722E601025C25a575021c6EA;

        vm.startBroadcast();
            new FundMe(priceFeedsEthUsd[priceFeedAddr.BASE_SEPOLIA]);
        vm.stopBroadcast();
    } 
}