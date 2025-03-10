
/*
1. Solidity function to transfer tokens from one address to another address

## Question Description
The task is to write a Solidity function that allows the transfer of ERC-20 tokens from one address to another. 
The function should ensure that the sender has enough tokens to transfer, has approved the contract to spend the tokens,
and that the transfer is executed securely.

*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenTransfer{
        function transferToken(address tokenaddress ,address from , address to , uint256 amount)public returns(bool){
                
                // ensure the amount is greater than zero
                require(amount> 0, "Amount must be greater than zero");

                //ensure the from  address is not zero address
                require(from != address(0), "Invalid sender address");
                
                //ensure the to address is not zero address
                require(to != address(0), "Invalid recipient address");

                // create an instance of the ERC20 token
                IERC20 token = IERC20(tokenaddress);

                //check if the from address has enough tokens to transfer
                require(token.balanceOf(from) >= amount, "Insufficient balance");
                
                //check if the from address has approved this contract to spend the tokens on its behalf
                require(token.allowance(from,address(this)) >=amount,"Insufficient allowance");

                //transfer the tokens from `from` to `to`
                bool success = token.transferFrom(from,to,amount);

                //check if the transfer was successful
                require(success,"Transfer failed");

                return success;
        }
}