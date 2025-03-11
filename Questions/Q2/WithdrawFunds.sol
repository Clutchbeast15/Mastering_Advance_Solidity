/*

2. Write a Solidity function to withdraw funds from a smart contract.

   - The function should allow users to withdraw funds they have previously deposited into the contract.
   - Ensure the function checks that the user has sufficient balance before allowing the withdrawal.
   - Transfer the requested amount to the user's address.
   - Emit an event to log the withdrawal.

*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract WithdrawFunds {
    //address of the contract owner
    address payable public owner;

    // mapping to track the balance of each user
    mapping(address => uint256) public balances;

    //Event to log the Withdrawal
    event Withdrawal(address indexed _user, uint256 _amount);

    //Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    //Constructor to set the owner of the contract
    constructor() {
        owner = payable(msg.sender);
    }

    //Function to deposite funds into the contract
    function deposit() external payable {
        require(msg.value > 0, "Deposite amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }

    //Function to withdraw funds from the contract
    function withdraw(uint256 amount) external {
        //Check if the user has enough balance to withdraw
        require(balances[msg.sender] >= amount, "Insufficient balance");

        //Effect: update the user balance before transfer to avoid reentrancy attacks
        balances[msg.sender] -= amount;

        //Interaction: transfer the amount to the user
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        //emit the withdrawal event
        emit Withdrawal(msg.sender, amount);
    }

    //Fallback function to handle incoming Ether
    receive() external payable {}
}
