// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() public {
        // fundMe = DeployFundMe.run();
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function test_MinumumUSDis5() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_OwnerIsMsgSender() public view {
        // console.log("Owner is:", fundMe.i_owner());
        // console.log("FundMeTest(this) Address is:", address(this));
        // console.log("Msg sender is:", msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
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
