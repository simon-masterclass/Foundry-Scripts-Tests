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
    uint256 constant GAS_PRICE = 1; // 1 gwei is the best reference point for gas price

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
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function test_Fund() public {
        console.log("Eth balance is:", fundMe.getAddressToAmountFunded(address(this)));
        fundMe.fund{value: 6 * 10 ** 18}();
        assertEq(fundMe.getAddressToAmountFunded(address(this)), 6 * 10 ** 18);
    }

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

    function test_AddsFundersToArrayOfFunders() public {
        vm.prank(USER); // The next TX will be from USER
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded 
    {
        vm.prank(USER); // The next TX will be from USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function test_OnlyOwnerCanWithdraw() public funded {
        vm.prank(USER); // The next TX will be from USER
        vm.expectRevert();
        fundMe.withdraw();
    }

    function test_WithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        //console.log("Starting Owner Balance:", startingOwnerBalance); 
        uint256 startingFundMeBalance = address(fundMe).balance;
        //console.log("Starting FundMe Balance:", startingFundMeBalance);

        // Act
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        uint256 gasStart = gasleft();
        fundMe.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // uint256 gasUsed = (gasStart - gasleft())*tx.gasprice; NOTE: This is slightly more expensive than the 2 lines above
        console.log("Gas Used:", gasUsed);  

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;  
        // console.log("Ending Owner Balance:", endingOwnerBalance);     
        uint256 endingFundMeBalance = address(fundMe).balance;
        // console.log("Ending FundMe Balance:", endingFundMeBalance);

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i <= numberOfFunders; i++) {
            // vm.prank = new address is the next sender
            // vm.deal new address gets dealt 0.1 ether
            // hoax = vm.prank + vm.deal
            hoax(address(i), SEND_VALUE); // The next TX will be from USER
            fundMe.fund{value: SEND_VALUE}();
        }


        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        console.log("Starting Owner Balance:", startingOwnerBalance); 
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log("Starting FundMe Balance:", startingFundMeBalance);

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;  
        console.log("Ending Owner Balance:", endingOwnerBalance);     
        uint256 endingFundMeBalance = address(fundMe).balance;
        console.log("Ending FundMe Balance:", endingFundMeBalance);

        assert(endingFundMeBalance == 0);
        assert(endingOwnerBalance == startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultipleFunders_Cheaper() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i <= numberOfFunders; i++) {
            // vm.prank = new address is the next sender
            // vm.deal new address gets dealt 0.1 ether
            // hoax = vm.prank + vm.deal
            hoax(address(i), SEND_VALUE); // The next TX will be from USER
            fundMe.fund{value: SEND_VALUE}();
        }


        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        console.log("Starting Owner Balance:", startingOwnerBalance); 
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log("Starting FundMe Balance:", startingFundMeBalance);

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;  
        console.log("Ending Owner Balance:", endingOwnerBalance);     
        uint256 endingFundMeBalance = address(fundMe).balance;
        console.log("Ending FundMe Balance:", endingFundMeBalance);

        assert(endingFundMeBalance == 0);
        assert(endingOwnerBalance == startingOwnerBalance + startingFundMeBalance);
    }

}
