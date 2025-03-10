// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {TokenTransfer} from "../src/TokenTransfer.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Mock ERC20 token for testing
contract MockERC20 is ERC20 {
    constructor() ERC20("MockToken", "MTK") {}

    // Mint tokens to a specified address
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

// Main test contract
contract TokenTransferTest is Test {
    // Declare state variables
    TokenTransfer tokenTransfer;
    MockERC20 mockERC20;
    address owner = address(0x1);
    address recipient = address(0x2);

    // Set up the initial state for each test
    function setUp() public {
        // Deploy the TokenTransfer contract
        tokenTransfer = new TokenTransfer();

        // Deploy the mock ERC20 token
        mockERC20 = new MockERC20();

        // Mint 10000 ether (10000 tokens) to the owner
        mockERC20.mint(owner, 10000 ether);
    }

    // Test case: Successful token transfer
    function testTransferToken() public {
        // Approve the TokenTransfer contract to spend tokens on behalf of the owner
        vm.prank(owner);
        mockERC20.approve(address(tokenTransfer), 500 ether);

        // Transfer tokens from owner to recipient
        vm.prank(owner);
        bool success = tokenTransfer.transferTokens(address(mockERC20), owner, recipient, 500 ether);

        // Assertions
        assertTrue(success, "Transfer should be successful");
        assertEq(mockERC20.balanceOf(owner), 9500 ether, "Owner balance should be 9500 ether");
        assertEq(mockERC20.balanceOf(recipient), 500 ether, "Recipient balance should be 500 ether");
    }

    // Test case: Insufficient balance
    function testTransferTokenInsufficientBalance() public {
        // Attempt to transfer more tokens than the owner has
        vm.prank(owner);
        vm.expectRevert("Insufficient balance");
        tokenTransfer.transferTokens(address(mockERC20), owner, recipient, 20000 ether);
    }
}