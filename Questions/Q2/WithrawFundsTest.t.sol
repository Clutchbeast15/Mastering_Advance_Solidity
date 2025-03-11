//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {WithdrawFunds} from "../src/WithdrawFunds.sol";

contract WithdrawFundsTest is Test{
        WithdrawFunds public withdrawFunds;
        address public owner = address(0x123);
        address public user = address(0x456);

        function setUp() public{
                //Deploy the WithdrawFunds contract
                vm.prank(owner);
                withdrawFunds = new WithdrawFunds();

                //Fund the user some ether
                vm.deal(user, 10 ether);
                       
        }

        //Test the deposit function
        function testDeposit() public{
                //user deposits 5 ether
                vm.prank(user);
                withdrawFunds.deposit {value: 5 ether}();

                //Check the user balance
                assertEq(withdrawFunds.balances(user), 5 ether);
                assertEq(address(withdrawFunds).balance, 5 ether);
        
        }

        function testWithdraw() public {
                //user deposits 5 ether
                vm.prank(user);
                withdrawFunds.deposit{value: 5 ether}();

                //user withdraws 3 ether
                vm.prank(user);
                withdrawFunds.withdraw(3 ether);

                //Check the user balance
                assertEq(withdrawFunds.balances(user), 2 ether);
                assertEq(address(withdrawFunds).balance, 2 ether);
                assertEq(user.balance, 8 ether); //initial balance - 5 ether deposit + 3 ether withdrawal
        

        }
}