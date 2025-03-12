/*
Write a Solidity function to implement a basic ERC-20 token.

*/

//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract BasicERC20{

        //state variables
        string public name; //name of the token
        string public symbol; //symbol of the token
        uint8 public decimals; //number of decimal places the token can be divided into
        uint256 public totalSupply; //total supply of the token

        //mapping to store the balance of each address
        mapping(address => uint256) public balanceOf;

        //mapping to store the allowance (spender -> amount)
        mapping(address => mapping(address => uint256)) public allowance;

        //Events

        //event emitted when token are transfered
        event Transfer(address indexed from, address indexed to, uint256 value );

        //event emitted when allowance is set 
        event Approval(address indexed owner, address indexed spender, uint256 value);

        //Constructor
        constructor(
                string memory _name, //Token name
                string memory _symbol, //Token symbol
                uint8 _decimals, //number of decimals
                uint256 _initialSupply //initial supply of the token
        ){
                name = _name; //set the name of the token
                symbol = _symbol; //set the symbol of the token
                decimals  = _decimals; //set the number of decimals
                totalSupply = _initialSupply * (10 ** decimals); //set the total supply of the token with decimals
                balanceOf[msg.sender] = totalSupply;
        }

        //Function to transfer tokens from one address to another address
        function transfer(address _to , uint256 _value) public returns(bool success){
                //check if sener has enough balance
                require(balanceOf[msg.sender] >= _value,"Insufficient balance");

                //check if the recipient address is not zero address
                require(_to != address(0),"Invalid recipient address");

                balanceOf[msg.sender] -= _value; //deduct the transferred amount from the sender's balance
                balanceOf[_to] += _value; //add the transferred amount to the recipient's balance
                emit Transfer(msg.sender, _to, _value);//emit the transfer event
                return true; //return true to indicate a successful transfer
        } 

        //Function to approve a spender to spend a certain amount of tokens on behalf of the owner
        function approve(address _sender, uint256 _value) public returns(bool success){
                //check if the spender address is not zero address
                require (_sender != address(0),"Invalid spender address");

                //set the allowance for the spender
                allowance[msg.sender][_sender]= _value;
                emit Approval(msg.sender, _sender, _value);//emit the approval event
                return true;
        }

        //Function to transfer tokens from one address to another address on behalf of the owner 
          function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
                // Check if the sender has enough balance
                require(balanceOf[_from] >= _value, "Insufficient balance");

                // Check if the spender has enough allowance
                require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

                balanceOf[_from] -= _value; // Deduct the transferred amount from the sender's balance
                balanceOf[_to] += _value; // Add the transferred amount to the recipient's balance
                allowance[_from][msg.sender] -= _value; // Deduct the transferred amount from the spender's allowance
                emit Transfer(_from, _to, _value); // Emit the transfer event
                return true;
        }
        
}