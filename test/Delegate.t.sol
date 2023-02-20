// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IDelegate} from "src/interfaces/IDelegate.sol";
import {IDelegation} from "src/interfaces/IDelegation.sol";

contract Delegate is Test {
    address OWNER = makeAddr("Owner");
    address ATTACLER = makeAddr("Attacker");

    IDelegate delegateInterface;
    IDelegation delegationInterface;

    function setUp() public {
        vm.startPrank(OWNER);

        address delegateAddress = HuffDeployer
            .config()
            .with_args(abi.encode(OWNER))
            .deploy("Delegate");
        delegateInterface = IDelegate(delegateAddress);

        address delegationAddress = HuffDeployer
            .config()
            .with_args(bytes.concat(abi.encode(delegateAddress), abi.encode(OWNER)))
            .deploy("Delegation");
        delegationInterface = IDelegation(delegationAddress);

        vm.stopPrank();
    }

    function test_owner() public {
        assertEq(delegateInterface.owner(), OWNER);
        assertEq(delegationInterface.owner(), OWNER);
    }

    function test_delegate() public {
        assertEq(delegationInterface.delegate(), address(delegateInterface));
    }
}
