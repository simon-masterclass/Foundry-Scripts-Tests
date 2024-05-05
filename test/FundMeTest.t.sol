// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() public {
        fundMe = new FundMe();
    }

    function test_Fund() public {
        fundMe.fund{value: 1000000000000000000}();
        assertEq(fundMe.addressToAmountFunded(address(this)), 1000000000000000000);
    }

    function test_Withdraw() public {
        fundMe.fund{value: 1000000000000000000}();
        fundMe.withdraw();
        assertEq(fundMe.addressToAmountFunded(address(this)), 0);
    }

    function test_GetVersion() view public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 0);
    }
}

