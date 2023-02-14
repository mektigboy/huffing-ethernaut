// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IFallback} from "src/interfaces/IFallback.sol";

contract FallbackTest is Test {
    address OWNER = makeAddr("Owner");
    address ATTACKER = makeAddr("Attacker");

    IFallback fallbackInterface;

    function setUp() public {
        vm.deal(ATTACKER, 10000 ether);

        vm.prank(OWNER);
        address fallbackAddress = HuffDeployer.config().with_args(abi.encode(OWNER)).deploy("Fallback");
        fallbackInterface = IFallback(fallbackAddress);
    }

    function test_owner() public {
        assertEq(fallbackInterface.owner(), OWNER);
    }

    function test_contributions() public {
        assertEq(fallbackInterface.contributions(OWNER), 1000 ether);
    }

    function test_getContributions() public {
        vm.prank(OWNER);
        assertEq(fallbackInterface.getContribution(), 1000 ether);
    }

    function test_contribute() public {
        vm.startPrank(ATTACKER);

        vm.expectRevert();
        fallbackInterface.contribute{value: 0.0001 ether}();

        fallbackInterface.contribute{value: 10000 ether}();

        vm.stopPrank();

        assertEq(fallbackInterface.contributions(ATTACKER), 10000 ether);
        assertEq(fallbackInterface.owner(), ATTACKER);
    }

    function test_withdraw() public {
        vm.deal(address(fallbackInterface), 10000 ether);

        vm.prank(ATTACKER);
        fallbackInterface.withdraw();
        
        assertEq(address(ATTACKER).balance, 10000 ether);
    }
}
