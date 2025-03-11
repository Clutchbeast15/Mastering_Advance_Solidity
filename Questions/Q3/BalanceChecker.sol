/*
Write a Solidity function to check the balance of a given address.
*/


// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract BalanceChecker{

        function checkBalance(address _address) public view returns(uint256){
                return _address.balance;
        }
}