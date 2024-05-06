// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    // contract address for Chainlink price feed oracles on different networks
    enum priceFeedAddr { BASE_SEPOLIA, MAINNET_SEPOLIA, AVALANCHE_TESTNET}
    mapping(priceFeedAddr => address) public priceFeedsEthUsd;

    FundMe public fundMe;

    function setUp() public {
        priceFeedsEthUsd[priceFeedAddr.BASE_SEPOLIA] = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;
        priceFeedsEthUsd[priceFeedAddr.MAINNET_SEPOLIA] = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        priceFeedsEthUsd[priceFeedAddr.AVALANCHE_TESTNET] = 0x86d67c3D38D2bCeE722E601025C25a575021c6EA;
        
        fundMe = new FundMe(priceFeedsEthUsd[priceFeedAddr.BASE_SEPOLIA]);
    }

    function test_MinumumUSDis5() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_OwnerIsMsgSender() public view {
        console.log("Owner is:", fundMe.i_owner());
        console.log("FundMeTest Address is:", address(this));
        console.log("Msg sender is:", msg.sender);
        assertEq(fundMe.i_owner(), address(this));
    }

    // function test_Fund() public {
    //     console.log("Eth balance is:", fundMe.addressToAmountFunded(address(this)));
    //     fundMe.fund{value: 6 * 10 ** 18}();
    //     assertEq(fundMe.addressToAmountFunded(address(this)), 6 * 10 ** 18);
    // }

    // function test_Withdraw() public {
    //     fundMe.fund{value: 1000000000000000000}();
    //     fundMe.withdraw();
    //     assertEq(fundMe.addressToAmountFunded(address(this)), 0);
    // }

    function test_GetVersion4Pricefeed() view public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
