// SPDX-License-Identifier: MIT

// Deploy Mocks when using local Anvil chain
// Keep track of contract addresses across different blockchain networks

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import (MockV3Aggregator) from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // on local Anvil chain, deploy the MockV3Aggregator contract
    // otherwise, retrieve the contract address from the Chainlink price feed oracle

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 84532) {
            activeNetworkConfig = getSepoliaBaseConfig();
        } else if (block.chainid == 43113) {
            activeNetworkConfig = getAvaxFujiConfig();
        } else {
            activeNetworkConfig = getAnvilNetworkConfig();
        }
    }

    function getAnvilNetworkConfig() public returns (NetworkConfig memory) {
        // 1. Deploy the mock
        // 2. Return the mock address

        vm.startBroadcast();
            // Deploy the MockV3Aggregator contract
            MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 3000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            // Sepolia testnet ETH / USD Address on Etheum Mainnet
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
    }

    function getSepoliaBaseConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            // Sepolia testnet ETH / USD Address on Base Sepolia network
            priceFeed: 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1
        });
    }

    function getAvaxFujiConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            // Avalanche Fuji testnet ETH / USD Address on Avalanche C-Chain
            priceFeed: 0x86d67c3D38D2bCeE722E601025C25a575021c6EA
        });
    }

    // contract address for Chainlink price feed oracles on different networks
    // address public BASE_SEPOLIA = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;
    // address public MAINNET_SEPOLIA = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    // address public AVALANCHE_TESTNET = 0x86d67c3D38D2bCeE722E601025C25a575021c6EA;
}