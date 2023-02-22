// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IKing} from "src/interfaces/IKing.sol";

contract King is Test {
    address OWNER = makeAddr("Owner");
    address ATTACKER = makeAddr("Attacker");

    IKing kingInterface;

    error CallFailed();

    function setUp() public {
        vm.deal(OWNER, 0.001 ether);
        vm.startPrank(OWNER);

        address kingAddress = HuffDeployer
            .config()
            .with_args(bytes.concat(abi.encode(OWNER), abi.encode(0.001 ether)))
            .deploy("King");
        kingInterface = IKing(kingAddress);

        vm.stopPrank();
    }

    function test_prize() public {
        assertEq(kingInterface.prize(), 0.001 ether);
    }

    function test_owner() public {
        assertEq(kingInterface.owner(), OWNER);
    }

    function test_king() public {
        assertEq(kingInterface._king(), OWNER);
    }

    function test_receive() public {
        vm.deal(OWNER, 1 ether);
        vm.deal(ATTACKER, 3 ether);

        vm.prank(OWNER);
        (bool success1, ) = address(kingInterface).call{value: 1 ether}("");
        if (!success1) revert CallFailed();

        assertEq(kingInterface.prize(), 1 ether);

        vm.startPrank(ATTACKER);

        vm.expectRevert();
        (bool success2, ) = address(kingInterface).call{value: 0.1 ether}("");
        if (!success2) revert CallFailed();

        (bool success3, ) = address(kingInterface).call{value: 1 ether}("");
        if (!success3) revert CallFailed();

        assertEq(kingInterface.prize(), 1 ether);

        (bool success4, ) = address(kingInterface).call{value: 2 ether}("");
        if (!success4) revert CallFailed();

        assertEq(kingInterface.prize(), 2 ether);

        vm.stopPrank();
    }

    function test_PoC() public {
        
    }
}
