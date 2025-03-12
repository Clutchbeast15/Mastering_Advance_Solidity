
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// Import Foundry's testing library and the BasicERC20 contract
import "forge-std/Test.sol";
import "../src/BasicERC20.sol";

contract BasicERC20Test is Test {
    // Declare the token contract and some test addresses
    BasicERC20 private token;
    address private owner = address(0x123); // Owner of the token
    address private user1 = address(0x456); // User 1 for testing transfers
    address private user2 = address(0x789); // User 2 for testing transfers

    // setUp() is called before each test case
    function setUp() public {
        // Simulate the owner deploying the token contract
        vm.prank(owner); // Set the `msg.sender` to `owner` for the next call
        token = new BasicERC20("TestToken", "TT", 18, 1000000); // Deploy the token with 1,000,000 initial supply
    }

    // Test the initial state of the token contract
    function testInitialSupply() public view {
        // Check if the total supply is correctly set (1,000,000 tokens with 18 decimals)
        assertEq(token.totalSupply(), 1000000 * (10 ** 18));
        // Check if the owner's balance is equal to the total supply
        assertEq(token.balanceOf(owner), 1000000 * (10 ** 18));
    }

    // Test the transfer function
    function testTransfer() public {
        // Simulate the owner transferring 1,000 tokens to user1
        vm.prank(owner); // Set `msg.sender` to `owner`
        token.transfer(user1, 1000 * (10 ** 18));

        // Check if the owner's balance is reduced by 1,000 tokens
        assertEq(token.balanceOf(owner), 999000 * (10 ** 18));
        // Check if user1's balance is increased by 1,000 tokens
        assertEq(token.balanceOf(user1), 1000 * (10 ** 18));
    }

    // Test the transfer function when the sender has insufficient balance
    function testTransferInsufficientBalance() public {
        // Simulate user1 trying to transfer tokens without having any balance
        vm.prank(user1); // Set `msg.sender` to `user1`
        // Expect the transaction to revert with the error message "Insufficient balance"
        vm.expectRevert("Insufficient balance");
        token.transfer(user2, 1000 * (10 ** 18));
    }

    // Test the transfer function when the recipient address is invalid (zero address)
    function testTransferInvalidRecipient() public {
        // Simulate the owner trying to transfer tokens to the zero address
        vm.prank(owner); // Set `msg.sender` to `owner`
        // Expect the transaction to revert with the error message "Invalid recipient address"
        vm.expectRevert("Invalid recipient address");
        token.transfer(address(0), 1000 * (10 ** 18));
    }

    // Test the approve function
    function testApprove() public {
        // Simulate the owner approving user1 to spend 1,000 tokens on their behalf
        vm.prank(owner); // Set `msg.sender` to `owner`
        token.approve(user1, 1000 * (10 ** 18));

        // Check if the allowance is correctly set
        assertEq(token.allowance(owner, user1), 1000 * (10 ** 18));
    }

    // Test the approve function when the spender address is invalid (zero address)
    function testApproveInvalidSpender() public {
        // Simulate the owner trying to approve the zero address
        vm.prank(owner); // Set `msg.sender` to `owner`
        // Expect the transaction to revert with the error message "Invalid spender address"
        vm.expectRevert("Invalid spender address");
        token.approve(address(0), 1000 * (10 ** 18));
    }

    // Test the transferFrom function
    function testTransferFrom() public {
        // Simulate the owner approving user1 to spend 1,000 tokens
        vm.prank(owner); // Set `msg.sender` to `owner`
        token.approve(user1, 1000 * (10 ** 18));

        // Simulate user1 transferring 500 tokens from the owner to user2
        vm.prank(user1); // Set `msg.sender` to `user1`
        token.transferFrom(owner, user2, 500 * (10 ** 18));

        // Check if the owner's balance is reduced by 500 tokens
        assertEq(token.balanceOf(owner), 999500 * (10 ** 18));
        // Check if user2's balance is increased by 500 tokens
        assertEq(token.balanceOf(user2), 500 * (10 ** 18));
        // Check if the allowance is reduced by 500 tokens
        assertEq(token.allowance(owner, user1), 500 * (10 ** 18));
    }

    // Test the transferFrom function when the owner has insufficient balance
    function testTransferFromInsufficientBalance() public {
        // Simulate the owner approving user1 to spend 1,000 tokens
        vm.prank(owner); // Set `msg.sender` to `owner`
        token.approve(user1, 1000 * (10 ** 18));

        // Simulate user1 trying to transfer more tokens than the owner's balance
        vm.prank(user1); // Set `msg.sender` to `user1`
        // Expect the transaction to revert with the error message "Insufficient balance"
        vm.expectRevert("Insufficient balance");
        token.transferFrom(owner, user2, 1000001 * (10 ** 18));
    }

    // Test the transferFrom function when the spender has insufficient allowance
    function testTransferFromInsufficientAllowance() public {
        // Simulate the owner approving user1 to spend 1,000 tokens
        vm.prank(owner); // Set `msg.sender` to `owner`
        token.approve(user1, 1000 * (10 ** 18));

        // Simulate user1 trying to transfer more tokens than the approved allowance
        vm.prank(user1); // Set `msg.sender` to `user1`
        // Expect the transaction to revert with the error message "Insufficient allowance"
        vm.expectRevert("Insufficient allowance");
        token.transferFrom(owner, user2, 1001 * (10 ** 18));
    }
}