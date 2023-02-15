// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IFallout} from "src/interfaces/IFallout.sol";

contract FalloutTest is Test {
    address OWNER = makeAddr("Owner");

    address ALICE = makeAddr("Alice");
    address BOB = makeAddr("Bob");
    address CAROL = makeAddr("Carol");
    address DAVE = makeAddr("Dave");
    address EVE = makeAddr("Eve");
    address FRED = makeAddr("Fred");
    address GARY = makeAddr("Gary");
    address HARRY = makeAddr("Harry");
    address IAN = makeAddr("Ian");
    address JANE = makeAddr("Jane");

    address ATTACKER = makeAddr("Attacker");

    IFallout falloutInterface;

    error CallFailed();

    function setUp() public {
        vm.deal(ALICE, 10 ether);
        vm.deal(BOB, 10 ether);
        vm.deal(CAROL, 10 ether);
        vm.deal(DAVE, 10 ether);
        vm.deal(EVE, 10 ether);
        vm.deal(FRED, 10 ether);
        vm.deal(GARY, 10 ether);
        vm.deal(HARRY, 10 ether);
        vm.deal(IAN, 10 ether);
        vm.deal(JANE, 10 ether);

        vm.prank(OWNER);
        address falloutAddress = HuffDeployer
            .config()
            .with_args(abi.encode(OWNER))
            .deploy("Fallout");
        falloutInterface = IFallout(falloutAddress);
    }

    function test_owner() public {
        assertEq(falloutInterface.owner(), OWNER);
    }

    function test_allocations() public {
        assertEq(falloutInterface.allocations(OWNER), 0);
    }

    function test_allocate() public {
        vm.startPrank(ALICE);
        falloutInterface.allocate{value: 5 ether}();
        falloutInterface.allocate{value: 5 ether}();
        vm.stopPrank();

        assertEq(falloutInterface.allocations(ALICE), 10 ether);
    }

    // function test_sendAllocation() public {
    //     vm.prank(ALICE);
    //     falloutInterface.allocate{value: 10 ether}();

    //     assertEq(ALICE.balance, 0 ether);

    //     vm.startPrank(BOB);

    //     vm.expectRevert();
    //     falloutInterface.sendAllocation(BOB);

    //     vm.stopPrank();

    //     vm.prank(ALICE);
    //     falloutInterface.sendAllocation(ALICE);

    //     // assertEq(ALICE.balance, 10 ether);
    // }

    function test_sendAllocation() public {
        vm.deal(address(falloutInterface), 100 ether);

        assertEq(address(falloutInterface).balance, 100 ether);

        vm.prank(ALICE);
        falloutInterface.allocate{value: 10 ether}();

        assertEq(address(falloutInterface).balance, 110 ether);
        assertEq(falloutInterface.allocations(ALICE), 10 ether);
        assertEq(ALICE.balance, 0 ether);

        vm.expectRevert();
        falloutInterface.sendAllocation(BOB);
        
        falloutInterface.sendAllocation(ALICE);

        assertEq(ALICE.balance, 10 ether);
    }
}
