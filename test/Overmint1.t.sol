// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import "forge-std/src/Test.sol";
import "../src/Overmint1.sol";

contract Overmint1Test is Test {
    Overmint1 public victim;
    Overmint1Attacker public attacker;
    address alice = makeAddr("alice");

    function setUp() public {
        victim = new Overmint1();
        
        attacker = new Overmint1Attacker(address(victim));
        
        vm.deal(alice, 1 ether);
    }

    function testAttack() public {
        vm.startPrank(alice);
        
        attacker.attack();
        
        assertTrue(victim.success(address(attacker)), "Attack failed - attacker should have 5 NFTs");
        
        assertEq(victim.balanceOf(address(attacker)), 5, "Attacker should have exactly 5 NFTs");
        
        assertEq(victim.totalSupply(), 5, "Total supply should be 5");
        
        vm.stopPrank();
    }
}