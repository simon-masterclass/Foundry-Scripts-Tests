// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        // fundMe = DeployFundMe.run();
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
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

    function test_FundFailsWithoutMinimumUSD() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function test_FundFailsWithoutMinimumUSD5_Anvil2500USD() public {
        vm.expectRevert();
        fundMe.fund{value: 0.0019e18}();
    }

    function test_FundMeWorksAtMinimumUSD5_Anvil2500USD() public {
        fundMe.fund{value: 0.002e18}();
        assertEq(fundMe.getAddressToAmountFunded(address(this)), 0.002e18);
    }

    function test_FundMeUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next TX will be from USER
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}
